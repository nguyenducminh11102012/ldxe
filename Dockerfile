# Sử dụng Windows Server 2019 LTSC
FROM mcr.microsoft.com/windows:ltsc2019

# Thiết lập môi trường
SHELL ["powershell", "-Command"]

# Cài đặt Ngrok
ADD https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip C:\ngrok.zip
RUN Expand-Archive C:\ngrok.zip -DestinationPath C:\ngrok; `
    Remove-Item C:\ngrok.zip; `
    [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\ngrok", [System.EnvironmentVariableTarget]::Machine)

# Bật RDP (Remote Desktop Protocol)
RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0; `
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Đặt mật khẩu cho user Administrator
RUN net user Administrator "YourSecurePassword123" /ACTIVE:YES

# Mở cổng RDP và Ngrok
EXPOSE 3389

# Lệnh khởi động RDP và mở Ngrok (thay YOUR_NGROK_AUTH_TOKEN bằng token của bạn)
CMD Start-Process -NoNewWindow -FilePath "C:\ngrok\ngrok.exe" -ArgumentList "tcp 3389 --authtoken=YOUR_NGROK_AUTH_TOKEN"; `
    Start-Sleep -Seconds 5; `
    Write-Host "Ngrok started. Connect using RDP on provided Ngrok URL."; `
    Start-Sleep -Seconds 86400
