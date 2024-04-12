
@echo off
setlocal enabledelayedexpansion

cls
set "rip="
set mypath=%cd%
set "resolution="

:ipset
echo please input the Receiver's IP addr.
set /p "rip="
echo the Receiver's IP is %rip%
echo please input the Receiver's port.
set /p "port="
echo the Receiver's port is %port%
Title %~nx0, IP: %rip%:%port%
goto screen

rem -draw_mouse 1 : No Mouse icon
:screen
%mypath%\ffmpeg220831\bin\ffmpeg -filter_complex ddagrab=framerate=40,hwdownload,format=bgra -c:v hevc_nvenc -draw_mouse 0 -pix_fmt yuv420p -g 600 -qp 30 -b_ref_mode 0 -f rtsp -rtsp_transport tcp rtsp://%rip%:%port%/live 

:end
echo The process(es) is/are done. That's all. The END.
echo off

