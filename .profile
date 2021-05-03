PATH=/home/whjiang/.local/bin:/home/whjiang/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/var/lib/snapd/snap/bin:~/.config/rofi/bin
$TERMINAL=/usr/bin/kitty

setxkbmap -option caps:escape

_volume_pipe=/tmp/.volume-pipe
[[ -S $_volume_pipe ]] || mkfifo $_volume_pipe
