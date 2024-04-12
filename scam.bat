@echo off
setlocal enabledelayedexpansion

cls
set "rip="

:devicevideo
@For /f tokens^=1^,2delims^=^" %%a in (
'ffmpeg -stats -hide_banner -list_devices true -f dshow -i dummy 2^>^&1 ^| findstr /c:"(video)"'
) do (
	set /a N+=1
    set "usbcams[!N!]=%%~b"
)

:choice
echo ===== Streaming Menu =====
echo [1] Webcam-streaming
echo [2] RTSP-streaming
echo Please select:
set /p "ch="
echo The choice is %ch%
IF %ch% == 1 goto usbcamip
IF %ch% == 2 goto rtspip

:usbcamip
echo ===== camera Menu =====
set input=
For /L %%i in (1,1,%N%) do (
    echo [%%i] !usbcams[%%i]!
)
echo Please select:
set /p "cam="
goto rtspsever

:rtspip
echo please input the source RTSP-cam's IP addr. 
set /p "srcip="
echo the source RTSP-cam's IP is %srcip%
echo please input the source RTSP-cam's port.
set /p "srcport="
echo the source RTSP-cam's port is %srcport%
echo please input the source RTSP-cam's channel
set /p "srcch="
echo the source RTSP-cam's channel is %srcch%
goto rtspsever

:rtspsever
echo please input the RTSP sever's IP addr.
set /p "rip="
echo the RTSP sever's IP is %rip%
echo please input the RTSP sever's port.
set /p "port="
echo the RTSP sever's port is %port%
IF %ch% == 1 goto cast
IF %ch% == 2 goto rtsp

:cast
echo streaming mode is Unicast(UDP)(Receiving IP is %rip%)
echo =================================
ffmpeg -f dshow -i video="!usbcams[%cam%]!" -fflags +discardcorrupt -r 35 -c:v libx264 -preset ultrafast -f rtsp -rtsp_transport tcp rtsp://%rip%:%port%/live
goto end

:rtsp
echo streaming mode is Unicast(UDP)(Receiving IP is %rip%)
echo =================================
ffmpeg -i "rtsp://%srcip%:%srcport%/%srcch%" -fflags +discardcorrupt -r 35 -c:v copy -preset ultrafast -f rtsp -rtsp_transport tcp rtsp://%rip%:%port%/live
goto end

:end
echo The process(es) is/are done. That's all. The END.
echo off

