# mac-setup
Scripts to setup macbook with oh-my-zsh and allow user to assume-role with MFA

## Installation steps
1. Clone the repo and use the Brewfile for package installation
```sh 
cd mac-setup
brew bundle install
```
2. configure your iTerm2 shell with power10k theme with basic plugins
```sh
p10k configure
```
3. To assume role with MFA source `assume_role.sh` in your `~/.zshrc` or `~/.bashrc` file.
```sh
code ~/.zshrc
alias mfa='source ~/mac-setup/assume_role.sh'
```