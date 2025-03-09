#!/bin/bash
pip install gdown
/home/user/.local/bin/gdown --fuzzy $TARI_FOLDER_ZIPPED_DRIVE_LINK
sudo unzip com.tari.universe.zip
mkdir -p ~/.local/share/
mv com.tari.universe ~/.local/share/
/home/user/.local/bin/gdown --fuzzy $TARIAPPIMAGE_DRIVE_LINK
# Find the most recently modified file in the current directory
FILE=$(ls -t | head -n 1)
chmod +x "$FILE"

# Define the file path
FILE_PATH="/opt/ai-dock/bin/checktarirunning.sh"

# Write content to the file
cat << 'EOF' > "$FILE_PATH"
#!/bin/bash

# Path where the Tari.Universe file is expected
TARI_PATH="/opt/ai-dock/bin"
TARI_EXECUTABLE=$(ls -t "$TARI_PATH"/Tari.Universe* 2>/dev/null | head -n 1)  # Find the most recent Tari.Universe file

# Check if a Tari process is running
if ! pgrep -f "Tari.Universe" > /dev/null; then
    if [[ -n "$TARI_EXECUTABLE" ]]; then
        echo "Tari process not found. Restarting $TARI_EXECUTABLE..."
        chmod +x "$TARI_EXECUTABLE"
        nohup "$TARI_EXECUTABLE" >/dev/null 2>&1 &
    else
        echo "No Tari.Universe file found in $TARI_PATH."
    fi
else
    echo "Tari is running."
fi
EOF

# Make the script executable
chmod +x "$FILE_PATH"

CRON_JOB="* * * * * /opt/ai-dock/bin/checktarirunning.sh"
(crontab -l 2>/dev/null | grep -F "$CRON_JOB") || (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

./"$FILE" &
