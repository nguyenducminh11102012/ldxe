# Sử dụng image Windows Server LTSC 2025
FROM mcr.microsoft.com/windows/server:ltsc2025

# Cài đặt PowerShell và tải ngrok
RUN powershell -Command \
    Invoke-WebRequest https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip -OutFile ngrok.zip; \
    Expand-Archive ngrok.zip -DestinationPath C:\ngrok; \
    Remove-Item ngrok.zip

# Cài đặt các cài đặt cần thiết cho Remote Desktop
RUN powershell -Command \
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0; \
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"; \
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1; \
    Set-LocalUser -Name "runneradmin" -Password (ConvertTo-SecureString -AsPlainText "Datnguyentv.com" -Force)

# Cài đặt IIS (Internet Information Services) để mở cổng 8080 và hiển thị "Hello World"
RUN powershell -Command \
    Install-WindowsFeature -Name Web-Server; \
    Set-Content -Path C:\inetpub\wwwroot\index.html -Value "Hello World"

# Expose cổng 3389 cho ngrok (RDP) và cổng 8080 cho IIS (Web)
EXPOSE 3389
EXPOSE 8080

# Thực thi ngrok và IIS server
CMD C:\ngrok\ngrok.exe authtoken 2nyiyWrhpT6OwyUoaoZ2zdE9nNo_7KtHBQxaox3Wx2t9qBHTT && \
    C:\ngrok\ngrok.exe tcp 3389 & \
    powershell -Command Start-Process "C:\Windows\System32\inetsrv\iisreset.exe"
