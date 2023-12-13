#!/usr/bin/env bash

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m'

declare -a __required=(
  "curl"
  "iptables"
  "build-essential"
  "git"
  "wget"
  "jq"
  "make"
  "gcc"
  "nano"
  "tmux"
  "htop"
  "nvme-cli"
  "pkg-config"
  "libssl-dev"
  "libleveldb-dev"
  "tar"
  "clang"
  "bsdmainutils"
  "ncdu"
  "unzip"
  "libleveldb-dev"
  "cargo"
  "sshpass"
)

install_packages() {
  echo -e "${CYAN}Packeges updated ${NC}"
  sudo apt update && sudo apt upgrade -y

  for package in "${__required[@]}"; do
    if ! dpkg -l | grep -q "^ii[[:space:]]*$package"; then
      echo "installing package: $package"
      echo 123 | sudo -S apt-get install -y "$package"
    else
      echo -e "${GREEN} Downloaded${NC} $package"
    fi
  done

  echo -e "${CYAN}Packeges updated ${NC}"
}

install_packages
