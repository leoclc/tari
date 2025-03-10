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

./Tari.AppImage &  
