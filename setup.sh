#!/usr/bin/env bash

# Run without downloading by running in your home directory:
# curl https://raw.githubusercontent.com/CarterMcAlister/dotfiles/master/setup.sh | bash

# Color Codes & Custom utilities
# Source: http://natelandau.com/bash-scripting-utilities/

## Fonts
bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

## Colors
purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

## To check input is empty or not
is_empty() {
if [ $# -eq  0 ]
  then
    return 1
fi
  return 0
}

## To check programs exit or not
is_exists() {
if [ $(type -P $1) ]; then
  return 1
fi
  return 0
}

## To check file exits or not
is_file_exists() {
if [ -f "$file" ]
then
	return 1
else
	return 0
fi
}

# Custom echo functions

ask() {
  printf "\n${bold}$@${reset}"
}

e_thanks() {
  printf "\n${bold}${purple}$@${reset}\n"
}

e_header() {
  printf "\n${underline}${bold}${green}%s${reset}\n" "$@"
}

e_arrow() {
  printf "\n ᐅ $@\n"
}

e_success() {
  printf "\n${green}✔ %s${reset}\n" "$@"
}

e_error() {
  printf "\n${red}✖ %s${reset}\n" "$@"
}

e_warning() {
  printf "\n${tan}ᐅ %s${reset}\n" "$@"
}

e_underline() {
  printf "\n${underline}${bold}%s${reset}\n" "$@"
}

e_bold() {
  printf "\n${bold}%s${reset}\n" "$@"
}

e_note() {
  printf "\n${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@"
}

## End utilities

# Welcome msg

e_bold "${tan}┌──────────────────────────────────────────────────────────────┐
                                                               
  Hello $(whoami)!                                             
                                                               
  Let's get your machine set up.                               
                                                              
└──────────────────────────────────────────────────────────────┘"

e_bold "${tan}Please grant sudo permissions"

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

## Create Code directory
mkdir -p "${HOME}/Code"

# 1. Install Homebrew

if test ! $(which brew); then
  e_header "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  e_warning "Homebrew is already installed. Skipping.."
fi

# 2. Install git

if test ! $(which git); then
  e_header "Installing git"
	brew install git
else
  e_warning "Git is already installed. Skipping.."
fi

## Get dotfiles
if [ -d ~/dotfiles ]; then
  ask "${blue} ~/dotfiles already exists. Replace and continue (y/n): "
  read -r replace
fi

if [[ "$replace" == "n" || "$replace" == "no" ]]; then
  exit
fi

if [[ "$replace" == "y" || "$replace" == "yes" ]]; then
  rm -rf ~/dotfiles
fi

e_header "Getting dotfiles"
git clone https://github.com/CarterMcAlister/dotfiles.git "${HOME}/dotfiles"
cp -ri ~/dotfiles/bin_scripts ~/.bin_scripts 
  

# 3. Git configuration

e_header "Setup git config (global)"
cp -ri ~/dotfiles/.gitignore_global ~/.gitignore_global
git config --global core.excludesfile "${HOME}/.gitignore_global"

ask "${blue} Enter Your Github Email: "
read -r emailId
if is_empty $emailId; then
  git config --global user.email "$emailId" ## Git Email Id
  e_success "Email is set"
else
  e_error "Email is required"
  exit
fi

ask "${blue} Enter Your Github Username: "
read -r userName
if is_empty $userName; then
  git config --global user.name "$userName" ## Git Username
  e_success "Username is set"
else
  e_error "Username is required"
  exit
fi

# 4. Install applications

e_header "Installing Applications with Brew"
cp -ri ~/dotfiles/Brewfile ~/Brewfile  
# brew bundle install


# 5. Install Oh-My-Zsh & custom aliases

ZSH=~/.oh-my-zsh

if [ -d $ZSH ]; then
  e_warning "Oh My Zsh is already installed. Skipping.."
else
  e_header "Installing Oh My Zsh..."
  curl -L http://install.ohmyz.sh | sh
fi 

e_header "Setting up ZSH configuration and plugins"
## Copying zsh configs
cp -ri ~/dotfiles/oh-my-zsh/.aliases ~/.aliases 
cp -ri ~/dotfiles/oh-my-zsh/.zshrc ~/.zshrc   
cp -ri ~/dotfiles/oh-my-zsh/.p10k.zsh ~/.p10k.zsh
## Install zsh plugins
git clone https://github.com/peterhurford/git-it-on.zsh ~/.oh-my-zsh/custom/plugins/git-it-on
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions  ~/.oh-my-zsh/custom/plugins/zsh-completions
git clone https://github.com/agkozak/zsh-z ~/.oh-my-zsh/custom/plugins/zsh-z
git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
# 6. Install ZSH NVM

if test ! $(which nvm); then
  e_header "Installing zsh-nvm.."

  git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm

  ## To setup npm install/update -g without sudo
  cp -ri ~/dotfiles/.npmrc ~/.npmrc
  if test [ ! -d ~/.npm-packages]; then
    mkdir "${HOME}/.npm-packages"
    export PATH="$HOME/.node/bin:$PATH"
    sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}
  fi

  ## Set npm global config
  npm config set init.author.name "$emailId" ## Replace it with your name
  npm config set init.author.email "$userName" ## Replace it with your email id
else
  e_warning "NVM is already installed. Skipping.."
fi

# 7. Yarn install
if ! type yarn > /dev/null
then
  e_header "Installing Yarn.."
  brew install yarn
else
  e_warning "Yarn is already installed. Skipping.."
fi

# 8. System configuration
e_header "Setting system configurations"

## Set system configs
source ~/dotfiles/osx/screen.sh
source ~/dotfiles/osx/dock.sh
source ~/dotfiles/osx/browser.sh
source ~/dotfiles/osx/system.sh

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Hide Spotlight tray-icon (and subsequent helper)
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

# 9. Wrap up

## Print installed node, npm version
echo "node --version: $(node --version)"
echo "npm --version: $(npm --version)"

echo "Generating an RSA token for GitHub"
ssh-keygen -t rsa -b 4096 -C "$emailId"
echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_rsa" | tee ~/.ssh/config
eval "$(ssh-agent -s)"
echo "run 'pbcopy < ~/.ssh/id_rsa.pub' and paste that into GitHub"

## Remove cloned dotfiles from system
if [ -d ~/dotfiles ]; then
  sudo rm -R ~/dotfiles
fi

e_success "Thats all, Done. Note that some of these changes require a logout/restart to take effect."

# END