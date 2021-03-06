# Go ʕ◔ϖ◔ʔ
export GOPATH=~/go

# Fix Java UI window parenting with AwesomeWM.
#
# see: http://awesome.naquadah.org/wiki/Problems_with_Java
export _JAVA_AWT_WM_NONREPARENTING=1

typeset -U fpath # dedupe
fpath=(
   ~/.zsh/completions
   ~/.zsh/functions
   $fpath
)

typeset -U path # dedupe
path=(
   ~/bin
   $GOPATH/bin
   /usr/local/sbin
   /usr/local/bin
   /usr/sbin
   /usr/bin
   /sbin
   /bin
)

autoload -Uz bashcompinit
bashcompinit

autoload -Uz compinit
compinit

autoload -U select-word-style
select-word-style bash

# disable stop/start terminal output
stty stop  undef # ctrl+s
stty start undef # ctrl+q

bindkey -e # Emacs key bindings

source ~/.zshrc.hashicorp
source ~/.zshrc.kubernetes

# configure prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable cvs git hg p4 svn
#zstyle ':vcs_info:*' stagedstr   '%F{28}-%f'
#zstyle ':vcs_info:*' unstagedstr '%F{11}+%f'
#zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats '(%F{yellow}%s%f) %F{magenta}%b%f@%F{cyan}%.12i%f'
zstyle ':vcs_info:*' branchformat '%b'
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' use-simple true
precmd() {
   vcs_info
   # set terminal title to <user>@<host>:<cwd>
   case $TERM in
      rxvt*|xterm*) print -Pn '\e]0;%n@%m: %~\a' ;;
   esac
}
PROMPT='%F{green}%n%f@%F{cyan}%m%f:%F{yellow}%(5~|%-1~/.../%3~|%4~)%f$ '
RPROMPT='$KUBEPS1 $vcs_info_msg_0_'

# enable brace character class e.g. {a-z}
setopt BRACE_CCL

# configure history
HISTFILE=~/.zsh/history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# help guard against accidental rm -rf *
setopt NO_RM_STAR_SILENT
setopt RM_STAR_WAIT

# Appends every command to the history file once it is executed
# setopt inc_append_history
# Reloads the history whenever you use it
setopt SHARE_HISTORY

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval `dircolors -b`
    alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# aws cli completions
command -v aws_completer >/dev/null 2>&1 && {
   complete -C aws_completer aws
}

# ls: colorize output
alias ls='ls --color=auto'
# ls: use long listing format
alias ll='ls -la'
# ls: show hidden files
alias l.='ls -d .*'

# enable context aware ignore case search and colorize output
alias less='less -i -r'

# default to opening multiple files in tabs
alias vi="$(whence -p vi) -p"
alias vim="$(whence -p vim) -p"

# source z
source ~/.zsh/z/z.sh

# source private .zshrc
for rc in $(ls -a ~/.private*/.zshrc); do source $rc; done
