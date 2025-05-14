#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

echo "[1/8] Updating apt repositories..."
sudo apt update -y

echo "[2/8] Installing prerequisites..."
sudo apt install -y software-properties-common curl build-essential libssl-dev libffi-dev

echo "[3/8] Adding deadsnakes PPA..."
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update -y

echo "[4/8] Installing Python 3.10 and venv..."
sudo apt install -y python3.10 python3.10-venv python3.10-dev python3.10-distutils

echo "[5/8] Installing pip for Python 3.10..."
if ! command -v pip3.10 &>/dev/null; then
  curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.10
fi

echo "[6/8] Configuring update-alternatives for python3..."
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 2 || true

echo "[7/8] Ensuring pip3 points to pip3.10..."
sudo ln -sf "$(which pip3.10)" /usr/bin/pip3

echo "[8/8] Installing/upgrading web3 via pip3..."
pip3 install --upgrade --force-reinstall web3 --root-user-action=ignore

echo -e "\n✅ Setup complete!"
echo "   python3  => $(python3 --version)"
echo "   pip3     => $(pip3 --version)"
python3 - << 'EOF2'
import web3
print(f"   web3     => {web3.__version__}")
EOF2
