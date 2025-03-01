# Sử dụng Windows Server 2019 LTSC
FROM mcr.microsoft.com/windows:ltsc2019

# Thiết lập PowerShell làm shell mặc định
SHELL ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

# Cập nhật Windows và cài đặt RDP
RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0; `
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"; `
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1

# Đặt mật khẩu cho user "Administrator"
RUN net user Administrator "YourSecurePassword123" /ACTIVE:YES

# Tải xuống và cài đặt Ngrok
ADD https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip C:\ngrok.zip
RUN Expand-Archive -Path C:\ngrok.zip -DestinationPath C:\ngrok; `
    Remove-Item -Path C:\ngrok.zip -Force; `
    [System.Environment]::SetEnvironmentVariable('Path', $env:Path + ';C:\ngrok', [System.EnvironmentVariableTarget]::Machine)

# Mở cổng RDP
EXPOSE 3389

# Chạy Ngrok để mở RDP qua internet
CMD Start-Process -NoNewWindow -FilePath "C:\ngrok\ngrok.exe" -ArgumentList "authtoken YOUR_NGROK_AUTH_TOKEN"; `
    Start-Process -NoNewWindow -FilePath "C:\ngrok\ngrok.exe" -ArgumentList "tcp 3389"; `
    Start-Sleep -Seconds 5; `
    Write-Host "Ngrok started. Connect using RDP on provided Ngrok URL."; `
    Start-Sleep -Seconds 86400
