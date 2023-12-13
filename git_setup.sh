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

email="$1"
wallet="$2"
user="$3"
git_code="$4"

main() {
    add_to_path
    clone_repository
    install_cargo
    create_wallet
    create_tictactoe
}

add_to_path() {
    echo 'export PATH="$PATH:/home/ilya/.cargo/bin"' | cat - ~/.bashrc >temp && mv temp ~/.bashrc
}

clone_repository() {
    if [ -d "$project_directory" ]; then
        cd
        rm -rf leo
        git clone https://github.com/AleoHQ/leo
        cd leo
    else
        cd
        git clone https://github.com/AleoHQ/leo
        cd leo
    fi
}

install_cargo() {
    echo -e "Current path:${CYAN}$(pwd)${NC}"

    if [ -f "Cargo.toml" ]; then
        if command -v cargo &>/dev/null; then
            echo -e "${GREEN}Cargo is installed${NC}"
            cargo install --path .
        else
            echo -e "${RED}cargo is not installed${NC}"
        fi
    else
        echo -e "${RED}Error: 'Cargo.toml' not found. Make sure you are in the correct directory.${NC}"
    fi
}

create_wallet() {
    leo account import "$wallet"
}

create_tictactoe() {

    echo "Wallet - $wallet"
    echo "User - $user"
    echo "Email - $email"
    echo "Git code - $git_code"

    leo example tictactoe
    cd tictactoe
    leo run new
    cd tictactoe

    echo -e "${GREEN}Init git repository${NC}"
    if ! git init -b main; then
        echo "Failed to initialize Git repository."
        exit 1
    fi

    echo -e "${GREEN}Add all files to git${NC}"
    git add .

    echo -e "${GREEN}Set user email and name${NC}"
    git config --global user.email "$email"
    git config --global user.name "$user"

    echo -e "${GREEN}Committing${NC}"
    git commit -m "Initial commit"

    echo -e "${GREEN}Make branch - main${NC}"
    git branch -M main

    echo -e "${GREEN}Add remote origin${NC}"
    git remote add origin https://github.com/$user/Aleo_test_app.git
    git remote -v
    echo -e "${GREEN}Set remote URL with git_code${NC}"
    git remote set-url origin https://$git_code@github.com/$user/Aleo_test_app.git
    echo -e "${GREEN}Push to GitHub${NC}"
    git push -u origin main
}

main
