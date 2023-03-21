# .bashrc

export TERM=xterm-256color
export PREFIX="/home/napolitm/usr"
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:${PREFIX}/lib64/pkgconfig/:${PKG_CONFIG_PATH}"
export LD_LIBRARY_PATH="${PREFIX}/lib:${PREFIX}/lib64:${LD_LIBRARY_PATH}"
export MANPATH="${PREFIX}/share/man:${MANPATH}"
export INFOPATH="${PREFIX}/share/info:${INFOPATH}"

if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]] && [[ "$HOSTNAME" == "xxxxxx" ]]; then
          tmux -u attach-session -t default || tmux -u new-session -s default
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [[ -n "$PS1" ]]; then
    export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
    export HISTSIZE=100000                   # big big history
    export HISTFILESIZE=100000               # big big history
    shopt -s histappend                      # append to history, don't overwrite it

    # Save and reload the history after each command finishes
    export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
    source <(glab completion -s bash)
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi

alias vimc="vim ~/.config/nvim/init.vim"
alias tt="tmux select-pane -R"
export H=/home/napolitm
export CONAN_USER_HOME=/home/napolitm/
function untar {
    tar xf $1 && rm $1 
}


alias configurep="./configure --prefix=/ctc/users/napolitm/usr"
alias more="less -R"
alias less="/usr/bin/less -R"
alias rg='~/.cargo/bin/rg --color=always'
alias cat='bat'

function rgvim {
    rg -l --color=never $1 | xargs -o nvim
}

function fdvim {
    fd --color=never $1 | xargs -o nvim
}

function gitprune {
     git for-each-ref --sort='-committerdate' --format='%(refname)%09%(committerdate)' refs/heads | sed -e 's-refs/heads/--' | gawk -v days=${1:-30} '{ "date --date="$3"-"$4"-"$6 " +%s"  |& getline then ; "date +%s" |& getline now; diff=int((now-then)/86400);  if (diff > days) print $1}' | xargs git branch -D
}

alias configurep="./configure --prefix=/home/napolitm/usr"
export PATH=/home/napolitm/usr/bin:$PATH

# User specific aliases and functions
. "$HOME/.cargo/env"
alias glabmr="glab mr create --squash-before-merge --remove-source-branch --fill --fill-commit-body"
alias gitamend="git commit -a --amend --no-edit"
alias gitrebase="git pull --rebase"
alias gitrb='git fetch && git rebase origin/features/pilot'
alias gitb='git branch --sort=committerdate | cat'

function gitc() {
	git checkout "$(git branch --sort=committerdate | grep -v '^  all$' | tac | fzf | tr -d '[:space:]')"
}

alias vi=nvim
alias vim=nvim
alias ls='ls --color=auto'
source /home/napolitm/usr/share/git-prompt.sh
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

function conan_path {
	pkg=$1
	headN=1
	if [[ $2 == "--all" ]]; then 
		headN=10000
		set --
	fi
	
	stat ~/.conan/data/$pkg/$2/**/package/* -c "%y %n" | sort -r | head -n $headN | awk ' {print $NF } '
}

export PROMPT_COMMAND="history -a; history -c; history -r; "
shopt -s direxpand
