# Use Windows Server 2022 as base image (you can update to LTSC2025 if required)
FROM mcr.microsoft.com/windows/server:ltsc2022

# Set the working directory
WORKDIR /ngrok

# Download ngrok and unzip it
RUN powershell -Command Invoke-WebRequest https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip -OutFile ngrok.zip; \
    Expand-Archive ngrok.zip; \
    Remove-Item ngrok.zip

# Set the ngrok authtoken environment variable
ENV NGROK_AUTH_TOKEN="2nyiyWrhpT6OwyUoaoZ2zdE9nNo_7KtHBQxaox3Wx2t9qBHTT"

# Run commands to set up RDP and enable Remote Desktop
RUN powershell -Command \
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0; \
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"; \
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1; \
    Set-LocalUser -Name "runneradmin" -Password (ConvertTo-SecureString -AsPlainText "Datnguyentv.com" -Force)

# Start ngrok to expose the RDP port
CMD .\ngrok\ngrok.exe authtoken $Env:NGROK_AUTH_TOKEN; \
    .\ngrok\ngrok.exe tcp 3389
