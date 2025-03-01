# Sử dụng Windows Server 2019 GUI làm base image
FROM mcr.microsoft.com/windows/server:2019

# Chuyển sang PowerShell để thực thi các lệnh
SHELL ["powershell", "-Command"]

# Bật GUI và RDP
RUN Install-WindowsFeature -Name Desktop-Experience, RDS-RD-Server; \
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0; \
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"; \
    Write-Host "✅ RDP đã bật thành công!"

# Đặt mật khẩu cho Administrator
RUN $password = ConvertTo-SecureString "YourSecurePass123!" -AsPlainText -Force; \
    Set-LocalUser -Name "Administrator" -Password $password; \
    Write-Host "✅ Mật khẩu đã được đặt!"

# Tải và cài đặt Ngrok
RUN Invoke-WebRequest -Uri "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip" -OutFile "ngrok.zip"; \
    Expand-Archive -Path "ngrok.zip" -DestinationPath "C:\ngrok"; \
    Remove-Item -Path "ngrok.zip"; \
    Write-Host "✅ Ngrok đã được cài đặt!"

# Thêm Ngrok vào PATH
ENV PATH="C:\ngrok;${PATH}"

# Cấu hình Ngrok với Auth Token
RUN & "C:\ngrok\ngrok.exe" authtoken 2nyiyWrhpT6OwyUoaoZ2zdE9nNo_7KtHBQxaox3Wx2t9qBHTT; \
    Write-Host "✅ Ngrok đã được cấu hình với Auth Token!"

# Mở cổng RDP
EXPOSE 3389

# Khởi động RDP và Ngrok khi container chạy
CMD Start-Service TermService; \
    Start-Process -NoNewWindow -FilePath "C:\ngrok\ngrok.exe" -ArgumentList "tcp 3389"; \
    Write-Host "🎉 Ngrok đang chạy, dùng ngrok để lấy RDP!"; \
    cmd.exe
