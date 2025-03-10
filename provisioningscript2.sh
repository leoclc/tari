#!/bin/bash

# Download and extract Tari Universe
wget -O wallet.zip "$TARI_WALLET_ZIPPED_DRIVE_LINK"
unzip wallet.zip

wget -O data.mdb "$TARI_BLOCK_DATA_DRIVE_LINK"

# Move the wallet folder to the correct location
#sudo mkdir -p ~/.local/share/com.tari.universe
#mv ~/com.tari.universe ~/.local/share/
#sudo chown -R $USER:$USER ~/.local/share/com.tari.universe

# Download and make Tari AppImage executable
wget -O Tari.AppImage "$TARIAPPIMAGE_DRIVE_LINK"
chmod +x Tari.AppImage

# Start Tari AppImage
echo "Starting Tari AppImage..."
./Tari.AppImage &  
TARI_PID=$!  # Store process ID

# Wait for 5 minutes
echo "Waiting for 3 minutes before moving files..."
sleep 300

# Kill Tari AppImage after 5 minutes
echo "Stopping Tari AppImage..."
kill $TARI_PID

# Ensure the target directories exist
mkdir -p ~/.local/share/com.tari.universe/
mkdir -p ~/.local/share/com.tari.universe/node/nextnet/data/base_node/db/

# Move wallet folder and data.mdb file
echo "Moving wallet folder..."
mv wallet ~/.local/share/com.tari.universe/

echo "Moving data.mdb file..."
mv data.mdb ~/.local/share/com.tari.universe/node/nextnet/data/base_node/db/

echo "Provisioning complete!"

# Define the file path
FILE_PATH="/opt/ai-dock/bin/checktarirunning.sh"

# Write content to the file
cat << 'EOF' > "$FILE_PATH"
#!/bin/bash

# Path where the Tari.Universe file is expected
TARI_PATH="/home/user"
TARI_EXECUTABLE=$(ls -t "$TARI_PATH"/Tari* 2>/dev/null | head -n 1)  # Find the most recent Tari file

# Check if a Tari process is running
if ! pgrep -f "Tari" > /dev/null; then
    if [[ -n "$TARI_EXECUTABLE" ]]; then
        echo "Tari process not found. Restarting $TARI_EXECUTABLE..."
        sudo /home/user/Tari.AppImage &
    else
        echo "No Tari file found in $TARI_PATH."
    fi
else
    echo "Tari is running."
fi
EOF

# Make the script executable
chmod +x /opt/ai-dock/bin/checktarirunning.sh

CRON_JOB="* * * * * /opt/ai-dock/bin/checktarirunning.sh"
(crontab -l 2>/dev/null | grep -F "$CRON_JOB") || (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

./Tari.AppImage &  
