# If ipc enabled
# polybar-mesg cmd quit
killall -q polybar

echo "---" | tee -a /tmp/polybar.log
polybar theoroi 2>&1 | tee -a /tmp/polybar.log & disown

echo "Bars launched"
