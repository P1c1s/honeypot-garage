#!/bin/bash

# Check if the PPA is already added
if ! grep -q "^deb .*katharaframework/kathara" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding Kathara PPA..."
    sudo add-apt-repository ppa:katharaframework/kathara -y
else
    echo "Kathara PPA is already added."
fi

# Update the package list
echo "Updating package list..."
sudo apt update

# Check if Kathara is already installed
if ! dpkg -l | grep -q kathara; then
    echo "Installing Kathara..."
    sudo apt install -y kathara
else
    echo "Kathara is already installed."
fi

apt install python3-venv
apt install -y pip
# python3 -m pip install "kathara[pyuv]"
python3 -m pip install "kathara[pyuv]" --break-system-packages
