#!/usr/bin/env bash

file="assets/data.txt"

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m'

timeout=5

main() {
  echo -e "${GREEN}Running aleo.sh${NC}"
  process_file "$file"
}

process_file() {
  local file="$1"

  if [ ! -f "$file" ]; then
    echo -e "${RED}File $file not found.${NC}"
    exit 1
  fi

  while IFS=: read -r server password ip user email wallet git_code; do
    if setup "$server" "$password" "$ip" "$wallet" "$user" "$email" "$git_code"; then
      echo -e "${GREEN}Setup successful on $server - ($ip)${NC}"

      git_setup "$server" "$password" "$ip" "$wallet" "$user" "$email" "$git_code"
    else
      echo -e "${RED}Failed to connect to ${YELLOW}$server - ($ip)${NC}"
    fi
  done <"$file"
}

setup() {
  local server="$1"
  local password="$2"
  local ip="$3"
  local wallet="$4"
  local user="$5"
  local email="$6"
  local git_code="$7"

  echo -e "Running install_package.sh on ${GREEN}$server ${BLUE}($ip)${NC}"
  if sshpass -p "$password" ssh -o ConnectTimeout="$timeout" "$server@$ip" 'bash -s' <install_package.sh; then
    return 0
  else
    return 1
  fi
}

git_setup() {
  local server="$1"
  local password="$2"
  local ip="$3"
  local wallet="$4"
  local user="$5"
  local email="$6"
  local git_code="$7"

  echo -e "${YELLOW}Wallet${NC} - $wallet"
  echo -e "${YELLOW}User${NC} - $user"
  echo -e "${YELLOW}Email${NC} - $email"
  echo -e "${YELLOW}Git code${NC} - $git_code"

  if sshpass -p "$password" ssh -o ConnectTimeout="$timeout" "$server@$ip" 'bash -s' $wallet $user $email $git_code <git_setup.sh; then
    return 0
  else
    return 1
  fi
}

main
