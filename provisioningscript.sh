wget -O com.tari.universe.zip $TARI_FOLDER_ZIPPED_DRIVE_LINK
sudo unzip com.tari.universe.zip
sudo mkdir -p ~/.local/share/
mv com.tari.universe ~/.local/share/
wget -O Tari.AppImage $TARIAPPIMAGE_DRIVE_LINK
chmod +x Tari.AppImage

# Define the file path
FILE_PATH="/opt/ai-dock/bin/checktarirunning.sh"

# Write content to the file
cat << 'EOF' > "$FILE_PATH"
#!/bin/bash

# Path where the Tari.Universe file is expected
TARI_PATH="/opt/ai-dock/bin"
TARI_EXECUTABLE=$(ls -t "$TARI_PATH"/Tari* 2>/dev/null | head -n 1)  # Find the most recent Tari file

# Check if a Tari process is running
if ! pgrep -f "Tari.Universe" > /dev/null; then
    if [[ -n "$TARI_EXECUTABLE" ]]; then
        echo "Tari process not found. Restarting $TARI_EXECUTABLE..."
        chmod +x "$TARI_EXECUTABLE"
        nohup "$TARI_EXECUTABLE" >/dev/null 2>&1 &
    else
        echo "No Tari file found in $TARI_PATH."
    fi
else
    echo "Tari is running."
fi
EOF

# Make the script executable
#chmod +x "$FILE_PATH"

#CRON_JOB="* * * * * /opt/ai-dock/bin/checktarirunning.sh"
#(crontab -l 2>/dev/null | grep -F "$CRON_JOB") || (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -


#./"$FILE" &
