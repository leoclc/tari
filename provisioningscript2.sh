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
sudo /home/user/Tari.AppImage &  
TARI_PID=$!  # Store process ID

# Wait for 5 minutes
echo "Waiting for 3 minutes before moving files..."
sleep 300

# Kill Tari AppImage after 5 minutes
echo "Stopping Tari AppImage..."
kill $TARI_PID

# Ensure the target directories exist
sudo mkdir -p ~/.local/share/com.tari.universe/
sudo mkdir -p ~/.local/share/com.tari.universe/node/nextnet/data/base_node/db/

# Move wallet folder and data.mdb file
echo "Moving wallet folder..."
sudo mv wallet ~/.local/share/com.tari.universe/

echo "Moving data.mdb file..."
sudo mv data.mdb ~/.local/share/com.tari.universe/node/nextnet/data/base_node/db/

echo "Provisioning complete!"

# Define the file path for the monitoring script
FILE_PATH="/opt/ai-dock/bin/checktarirunning.sh"

sudo /home/user/Tari.AppImage &  

# Create the monitoring script
cat << 'EOF' > "$FILE_PATH"
#!/bin/bash

# Path where the Tari.Universe file is expected
TARI_PATH="/home/user"

echo "Starting Tari monitoring service..."

# Infinite loop to check every 60 seconds
while true; do
    TARI_EXECUTABLE=$(ls -t "$TARI_PATH"/Tari* 2>/dev/null | head -n 1)  # Find the most recent Tari file

    # Check if Tari is running
    if ! pgrep -f "Tari" > /dev/null; then
        if [[ -n "$TARI_EXECUTABLE" ]]; then
            echo "$(date): Tari process not found. Restarting $TARI_EXECUTABLE..."
            sudo /home/user/Tari.AppImage &
        else
            echo "$(date): No Tari file found in $TARI_PATH."
        fi
    else
        echo "$(date): Tari is running."
    fi

    # Sleep for 1 minute before checking again
    sleep 60
done
EOF

# Make the script executable
sudo chmod +x "$FILE_PATH"

# Start the script in the background
sudo nohup "$FILE_PATH" >/dev/null 2>&1 &

echo "Tari monitoring script started successfully in the background!"



