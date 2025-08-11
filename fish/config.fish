# Fish Shell Configuration
# ~/.config/fish/config.fish

fish_default_key_bindings
# Disable greeting
set -g fish_greeting

# Path additions
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/share/pnpm
fish_add_path /usr/local/bin

# Aliases
alias ls='eza --icons'
alias ll='eza --icons -l'
alias la='eza --icons -A'
alias l='ls -CF'

# Oh My Posh initialization (minimal config)
if command -v oh-my-posh >/dev/null
    oh-my-posh init fish --config ~/.poshthemes/amro.omp.json | source
end

#echo 'set -gx GEM_HOME $HOME/.local/share/gem/ruby/(ruby -e "puts RUBY_VERSION")' >> ~/.config/fish/config.fish
#echo 'set -gx PATH $GEM_HOME/bin $PATH' >> ~/.config/fish/config.fish
# Auto-start commands (uncomment if needed)
# if status is-interactive
#     # Commands to run in interactive sessions can go here
# end
set -gx GEM_HOME $HOME/.local/share/gem/ruby/(ruby -e "puts RUBY_VERSION")
set -gx PATH $GEM_HOME/bin $PATH
