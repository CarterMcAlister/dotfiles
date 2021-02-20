#!/bin/bash

# Run without downloading by running in your home directory:
# curl https://raw.githubusercontent.com/CarterMcAlister/dotfiles/master/setup.sh | bash

## Custom color codes & utility functions
source helper/utility.sh

# Welcome msg

e_bold "${tan}┌──────────────────────────────────────────────────────────────┐
|                                                              |
| Hello $(whoami)!                                             |
|                                                              |
| Let's get your machine set up.                               |
|                                                              |
└──────────────────────────────────────────────────────────────┘"

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
e_header "Getting dotfiles"
git clone git@github.com:$githubUsername/dotfiles.git "${HOME}/dotfiles"
cp ~/dotfiles/bin_scripts ~/.bin_scripts 


# 3. Git configuration

e_header "Setup git config (global)"
cp ~/dotfiles/.gitignore_global ~/.gitignore_global  ## Adding .gitignore global
git config --global core.excludesfile "${HOME}/.gitignore_global"

ask "${blue} Enter Your Github Email: "
read -r emailId
if is_empty $emailId; then
  git config --global user.email "$emailId" ## Git Email Id
  e_success "Email is set"
else
  e_error "Not set"
fi

ask "${blue} Enter Your Github Username: "
read -r userName
if is_empty $userName; then
  git config --global user.name "$userName" ## Git Username
  e_success "Username is set"
else
  e_error "Not set"
fi

# 4. Install applications

e_header "Installing Applications with Brew"
cp ~/dotfiles/Brewfile ~/Brewfile  
brew bundle install


# 5. Install Oh-My-Zsh & custom aliases

ZSH=~/.oh-my-zsh

if [ -d "$ZSH" ]; then
  e_warning "Oh My Zsh is already installed. Skipping.."
else
  e_header "Installing Oh My Zsh..."
  curl -L http://install.ohmyz.sh | sh

  ## To install ZSH plugins & configs
  e_header "Setting up ZSH configuration and plugins"
	## Install zsh plugins
  cp ~/dotfiles/oh-my-zsh/.aliases ~/.aliases 
  cp ~/dotfiles/oh-my-zsh/.zshrc ~/.zshrc   
  cp ~/dotfiles/oh-my-zsh/.p10k.zsh ~/.p10k.zsh
	## Install zsh plugins
  git clone https://github.com/peterhurford/git-it-on.zsh ~/.oh-my-zsh/custom/plugins/git-it-on
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-completions  ~/.oh-my-zsh/custom/plugins/zsh-completions
	git clone https://github.com/agkozak/zsh-z ~/.oh-my-zsh/custom/plugins/zsh-z
fi 
#todo: add other plugins

# 6. Install ZSH NVM

if test ! $(which nvm); then
  e_header "Installing zsh-nvm.."

  git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm

  ## To setup npm install/update -g without sudo
  cp ~/dotfiles/.npmrc ~/.npmrc
  mkdir "${HOME}/.npm-packages"
  export PATH="$HOME/.node/bin:$PATH"
  sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}

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
e_note "Please grant sudo permissions"

## Ask for the administrator password
sudo -v
## Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

## Set system configs
source osx/screen.sh
source osx/dock.sh
source osx/system.sh
source osx/browser.sh

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

echo "🍺  Thats all, Done. Note that some of these changes require a logout/restart to take effect."

# END
