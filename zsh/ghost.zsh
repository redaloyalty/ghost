# ghost shell extras - sourced from ~/.zshrc. Every tool is optional: missing ones are skipped.
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"          # z manager -> jumps to ~/ll/lovingloyalty-manager
if command -v eza >/dev/null; then
  alias ls='eza --group-directories-first'
  alias ll='eza -l --git --group-directories-first --time-style=relative'
  alias lt='eza --tree --level=2 --git-ignore'
fi
command -v fdfind >/dev/null && ! command -v fd >/dev/null && alias fd=fdfind
command -v batcat >/dev/null && ! command -v bat >/dev/null && alias bat=batcat
command -v lazygit >/dev/null && alias lg=lazygit
command -v vd >/dev/null && alias csv=vd                              # csv file.csv -> spreadsheet view
# fzf: Ctrl+R history, Ctrl+T files, Alt+C folders
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
command -v fdfind >/dev/null && export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --exclude .git --exclude node_modules'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border --color=fg+:#e6e1d6,hl:#8fbf8f,hl+:#b6e3a8,pointer:#8fbf8f,border:#2a2f2a'
# quick SQL on files: q "select count(*) from 'orders.csv'"
command -v duckdb >/dev/null && q() { duckdb -c "$*"; }
