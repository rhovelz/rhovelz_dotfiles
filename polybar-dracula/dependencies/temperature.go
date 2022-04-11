package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os/exec"
	"regexp"
	"time"

	"golang.org/x/sync/errgroup"
)

type temperature struct {
	current   string
	requested time.Time
}

func (t *temperature) listener(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		return
	}

	task := r.FormValue("task")

	if task == "next" {
		if t.current == "cpu" {
			fmt.Println(t.hdd())
		} else if t.current == "hdd" {
			fmt.Println(t.cpu())
		}
	} else if task == "current" {
		t.cur()
	}
}

func (t *temperature) cur() {
	if t.current == "cpu" {
		fmt.Println(t.cpu())
		t.requested = time.Now()
	} else if t.current == "hdd" {
		fmt.Println(t.hdd())
		t.requested = time.Now()
	}
}

func (t *temperature) cpu() string {
	out, err := exec.Command("sensors").Output()
	if err != nil {
		return err.Error()
	}
	pattern := regexp.MustCompile(`(?m)k10temp-pci-00c3\n.*\nTdie: +\+(?P<temp>\d+)\.`)
	t.current = "cpu"
	return "CPU +" + pattern.FindStringSubmatch(string(out))[1] + "°C"
}

func (t *temperature) hdd() string {
	out, err := exec.Command("nc", "localhost", "7634").Output()
	if err != nil {
		return err.Error()
	}
	pattern := regexp.MustCompile(`(?m)\|ST1000LM035.*\|(?P<temp>\d+)\|`)
	t.current = "hdd"
	return "HDD +" + pattern.FindStringSubmatch(string(out))[1] + "°C"
}

func main() {
	temp := temperature{current: "hdd"}
	temp.cur()
	temp.requested = time.Now()

	http.HandleFunc("/", temp.listener)

	tasks, ctx := errgroup.WithContext(context.Background())

	tasks.Go(func() error {
		return http.ListenAndServe(":9096", nil)
	})

	tasks.Go(func() error {
		tick := time.NewTicker(time.Second * 30)
		defer tick.Stop()
		for {
			select {
			case <-tick.C:
				since := time.Since(temp.requested)
				if since.Seconds() < 30 {
					<-time.NewTimer(30000 - since).C
					temp.cur()
				} else {
					temp.cur()
				}
			case <-ctx.Done():
				return nil
			}
		}
	})

	if err := tasks.Wait(); err != nil {
		log.Fatal("An error occurred:", err)
	}
}
