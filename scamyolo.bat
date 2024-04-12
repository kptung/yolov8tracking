@echo off
setlocal enabledelayedexpansion
cls
:requirements
pip install ultralytics
pip install -r requirements.txt

cls
set mypath=%cd%
set objtrack=obj_tracker9.py
:devicevideo
@For /f tokens^=1^,2delims^=^" %%a in (
'%mypath%\ffmpeg -stats -hide_banner -list_devices true -f dshow -i dummy 2^>^&1 ^| findstr /c:"(video)"'
) do (
	set /a N+=1
    set "usbcams[!N!]=%%~b"
)

:source
echo ===== streaming =====
echo [1] usb-cam 
echo [2] rtsp-cam
echo Please select:
set /p "src="
echo The choice is %src%
IF %src% == 1 goto usbcam
IF %src% == 2 goto ipset

:usbcam
echo ===== camera Menu =====
set input=
For /L %%i in (1,1,%N%) do (
    echo [%%i] !usbcams[%%i]!
)
echo Please select:
set /p "cam="
echo the selected cam is %cam%
set /a cam=%cam%-1
python %objtrack% --video %cam%
goto end

:ipset
echo please input the source's IP addr.
set /p "rip="
echo the source's IP is %rip%
echo please input the source's port.
set /p "port="
echo the source's port is %port%
echo please input the source's channel.
set /p "channel="
echo the source's channel is %channel%
goto setacpw

:setacpw
echo ===== Account/Password =====
echo [1] Authorization
echo [2] No authorization
echo Please select:
set /p "ch="
echo The choice is %ch%
IF %ch% == 1 goto acpw
IF %ch% == 2 python %objtrack% --video "rtsp://%rip%:%port%/%channel%"
goto end

:acpw
echo please input the user account
set /p "ac="
echo the user account is %ac%
echo please input the user password
set /p "pw="
echo the user password is %pw%
python %objtrack% --video "rtsp://%ac%:%pw%@%rip%:%port%/%channel%"
goto end

:end
echo The process(es) is/are done. That's all. The END.
echo off

