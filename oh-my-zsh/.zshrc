## Path to your oh-my-zsh installation
export ZSH=$HOME/.oh-my-zsh

## Use Powerlevel
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable Brew Autocompletions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
## oh-my-zsh plugins
plugins=(git zsh-nvm npm git-it-on zsh-autosuggestions zsh-completions z)


# User configuration

## Custom bins
PATH="$PATH:$HOME/.bin";
PATH="$PATH:$HOME/.bin_scripts";

## RVM & MANPath
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
#export MANPATH="/usr/local/man:$MANPATH"

## NVM path (should be before sourcing zsh)
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

## Path to oh-my-zsh script
source $ZSH/oh-my-zsh.sh

## custom aliases
source $HOME/.aliases

## Postgres path
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin

## Adding RVM & other rails related to the path
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/qt@5.5/bin:$PATH"

## Yarn pkg manager path
export PATH="$HOME/.yarn/bin:$PATH"

## To set node packages path
## Allow global npm install without sudo
## Source: (https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md)
NPM_PACKAGES="${HOME}/.npm-packages"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
PATH="$NPM_PACKAGES/bin:$PATH"

## Unset manpath so we can inherit from /etc/manpath via the `manpath`
unset MANPATH ## delete if you already modified MANPATH elsewhere in your config
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

## History configuration

# history size
HISTSIZE=5000
HISTFILESIZE=10000

SAVEHIST=5000
setopt EXTENDED_HISTORY
HISTFILE="${HOME}/.zsh_history"
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# do not store duplications
setopt HIST_IGNORE_DUPS

## Ignore case
CASE_SENSITIVE="false"
## Use cmd+I to accept suggestions
bindkey "^I" autosuggest-accept
## Hide % at start of line
unsetopt PROMPT_SP
## Ignore compfix nag
ZSH_DISABLE_COMPFIX="true"

autoload -U compinit && compinit

clear

## END
