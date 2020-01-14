# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable Brew Autocompletions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

### Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

### Zplugins
zplugin ice depth=1; zplugin light romkatv/powerlevel10k
# zplugin load denysdovhan/spaceship-prompt
zplugin load zsh-users/zsh-completions
zplugin load zsh-users/zsh-autosuggestions
zplugin load rupa/z

# Should be last zplugin loaded
zplugin load zdharma/fast-syntax-highlighting

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#zsh manual configs
CASE_SENSITIVE="false"
bindkey "^I" autosuggest-accept
unsetopt PROMPT_SP 

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/carter/.sdkman"
[[ -s "/Users/carter/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/carter/.sdkman/bin/sdkman-init.sh"




# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/carter/Documents/Code/personal-capital-extended/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/carter/Documents/Code/personal-capital-extended/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/carter/Documents/Code/personal-capital-extended/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/carter/Documents/Code/personal-capital-extended/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/carter/Documents/Code/personal-capital-extended/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/carter/Documents/Code/personal-capital-extended/node_modules/tabtab/.completions/slss.zshexport PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
