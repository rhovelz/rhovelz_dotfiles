#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8

API_URL="https://wttr.in"
DELIM=":"

# Pengecekan OS untuk fungsi timeout (khusus macOS)
if [ "$(uname)" == "Darwin" ]; then
  function timeout() {
    local _duration="${1:-1}"
    shift
    command -p perl -e 'alarm shift; exec @ARGV' "$_duration" "$@"
  }
fi

function fetch_weather_information() {
  local _show_fahrenheit="$1"
  local _location="$2"
  local _unit

  if [ "$_show_fahrenheit" == "true" ]; then
    _unit="u"
  else
    _unit="m"
  fi

  # Menambahkan --connect-timeout agar curl tidak menggantung lama
  # Menggunakan URL encoding sederhana untuk spasi
  curl -L --silent --fail --connect-timeout 5 \
    "${API_URL}/${_location// /%20}?format=%C${DELIM}%t${DELIM}%l&${_unit}" 2>&1
}

function format_weather_info() {
  local _raw _show_location
  _raw="$1" 
  _show_location="$2"

  local _weather _temp _location
  _weather="${_raw%%"${DELIM}"*}"
  _weather=$(printf '%s' "$_weather" | tr '[:upper:]' '[:lower:]')
  
  _temp="${_raw#*"${DELIM}"}"
  _temp="${_temp%%"${DELIM}"*}"
  _temp="${_temp/+/}"
  
  _location="${_raw##*"${DELIM}"}"
  [ "${_location//[^,]/}" == ",," ] && _location="${_location%,*}"

  # --- MODIFIKASI DISINI: Mengubah Kota menjadi Huruf Besar di Awal ---
  # Menggunakan sed untuk mengubah huruf pertama setiap kata menjadi Uppercase
  _location=$(echo "$_location" | sed -E 's/(^| )([a-z])/\1\U\2/g')
  # --------------------------------------------------------------------

  case "$_weather" in
    'snow') _weather='❄' ;;
    'rain' | 'shower') _weather='☂' ;;
    'overcast' | 'cloud') _weather='☁' ;;
    *) _weather='☀' ;;
  esac

  if "$_show_location"; then
    printf '%s %s %s' "$_weather" "$_temp" "$_location"
  else
    printf '%s %s' "$_weather" "$_temp"
  fi
}

function main() {
  local _show_fahrenheit="${1:-false}" # Default ke Celsius (false)
  local _show_location="${2:-true}"
  local _location="$3"
  local _hide_errors="${4:-false}"

  # 1. Cek Koneksi dengan timeout yang lebih longgar (3 detik)
  # Menggunakan nc (netcat) atau /dev/tcp jika tersedia
  if ! timeout 3 bash -c "true < /dev/tcp/wttr.in/443" 2>/dev/null; then
    if [ "$_hide_errors" != "true" ]; then
      printf 'Offline/Slow Conn\n'
    fi
    return 1
  fi

  # 2. Ambil Data
  local _resp
  _resp=$(fetch_weather_information "$_show_fahrenheit" "$_location")
  local _exit_code=$?

  if [ $_exit_code -ne 0 ]; then
    if [ "$_hide_errors" != "true" ]; then
      if [[ "$_resp" == *"404"* ]]; then
        printf 'Unknown Location\n'
      else
        printf 'Service Down\n'
      fi
    fi
    return 1
  fi

  # 3. Format Data
  format_weather_info "$_resp" "$_show_location"
}

main "$@"