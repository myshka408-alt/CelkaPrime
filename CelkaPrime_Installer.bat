@echo off
chcp 65001 >nul
color 0D
cls
echo.
echo ===============================================
echo           CelkaPrime Installer v1.0
echo ===============================================
echo.

set "DEST=C:\CelkaPrime"
set "ZIP=%TEMP%\CelkaPrime.zip"
set "URL=https://github.com/myshka408-alt/CelkaPrime/releases/download/v1.0/CelkaPrime.zip"
set "ICO_URL=https://raw.githubusercontent.com/myshka408-alt/CelkaPrime/main/CelkaTop.ico"
set "ICO=%DEST%\CelkaTop.ico"

:: Проверяем есть ли уже установка
if exist "%DEST%\start.bat" (
    echo CelkaPrime уже установлен!
    echo.
    choice /c YN /n /m "Хотите скачать лаунчер ещё раз? (Y/N): "
    if errorlevel 2 goto shortcut
    if errorlevel 1 goto download
)

:download
echo Подготовка к установке...
echo.

:: Создаём папку
if not exist "%DEST%" mkdir "%DEST%"

echo [1/3] Скачиваем файлы (690 MB)...
echo Это может занять несколько минут...
echo.
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $client = New-Object System.Net.WebClient; $client.DownloadFile('%URL%', '%ZIP%')}"

if not exist "%ZIP%" (
    echo.
    echo [ОШИБКА] Не удалось скачать файлы!
    echo Проверь интернет соединение и попробуй снова.
    echo.
    pause
    exit
)

echo [2/3] Распаковываем файлы...
powershell -Command "Expand-Archive -Path '%ZIP%' -DestinationPath 'C:\' -Force"

:: Удаляем zip
del "%ZIP%"

echo [3/3] Скачиваем иконку...
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $client = New-Object System.Net.WebClient; $client.DownloadFile('%ICO_URL%', '%ICO%')}"

:shortcut
echo.
choice /c YN /n /m "Создать ярлык на рабочем столе? (Y/N): "
if errorlevel 2 goto done
if errorlevel 1 (
    powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\CelkaPrime.lnk'); $s.TargetPath = 'C:\CelkaPrime\start.bat'; $s.WorkingDirectory = 'C:\CelkaPrime'; $s.IconLocation = 'C:\CelkaPrime\CelkaTop.ico'; $s.Save()"
    echo Ярлык создан!
)

:done
echo.
echo ===============================================
echo      CelkaPrime успешно установлен!
echo ===============================================
echo.
choice /c YN /n /m "Запустить лаунчер сейчас? (Y/N): "
if errorlevel 2 goto exit
if errorlevel 1 start "" "C:\CelkaPrime\start.bat"

:exit
exit