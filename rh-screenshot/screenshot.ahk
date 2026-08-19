#Requires AutoHotkey v2.0
#SingleInstance Force

^+PrintScreen:: {
    result := RunWait('wsl.exe -e python3 /home/xv4nz7/Documents/wslscreenshot.py -s', , 'Hide')

    if (result = 0) {
        TrayTip('✅ Screenshot', 'Tersimpan & sudah di-copy ke clipboard!', 1)
    } else if (result = 2) {
        ; User cancel / abort — diam saja
    } else {
        MsgBox('❌ Screenshot gagal! Exit code: ' result, 'Error', 16)
    }
}


