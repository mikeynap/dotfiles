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
alias glabmr="glab mr create --squash-before-merge --remove-source-branch --fill --fill-commit-body -a napolitm --yes "

function glabmr_rel {
   curr=$(git rev-parse --abbrev-ref HEAD)
   glabmr --target-branch features/${curr}_REL "$@"
}

alias glabmr_nosquash="glab mr create --remove-source-branch --fill --fill-commit-body -a napolitm --yes "
alias gitamend="git commit -a --amend --no-edit"
alias gitrebase="git pull --rebase"

function gitrb {
    b=$(git rev-parse --abbrev-ref HEAD)
    git checkout features/pilot
    git pull
    git checkout $b
    git rebase features/pilot
}

function gitrbc {
    git add .
    git rebase --continue

}
alias gitcp='git checkout features/pilot && git pull'
alias gitb='git branch --sort=committerdate | cat'
alias gitbp='gitcp && git checkout -b '

function gittag() {
    git tag $1 
    git push origin $1
}

function gitbprel() {
    curr=$(git rev-parse --abbrev-ref HEAD)
    stashed=''
    if [[ $curr = "features/pilot" ]]; then
        curr=$1
        shift
    fi
    featureb=${1:-features/${curr}_REL}
    gitbp $featureb || return 1
    git push -u origin $featureb || return 1
    git checkout -b $curr || git checkout $curr || return 1
}

function gitresethard() {
   git fetch
   curr=$(git rev-parse --abbrev-ref HEAD)
   git reset --hard origin/$curr
}

function gitrbrel() {
   curr=$(git rev-parse --abbrev-ref HEAD)
   featureb=${1:-features/${curr}_REL}
   git checkout features/pilot 
   git checkout $featureb || git checkout -b $featureb || return 1
   gitrb $featureb || return 1
   git push -f || return 1
   git checkout $curr || return 1
   git rebase $featureb || return 1
   git push -f || return 1
}

function gitmakerel() {
   curr=$(git rev-parse --abbrev-ref HEAD)
   featureb=${1:-features/${curr}_REL}
   gitcp
   git checkout -b $featureb
   git push -u origin $featureb
   git checkout $curr
   git rebase $featureb
}

function gitc() {
	git checkout "$(git branch --sort=committerdate | grep -v '^  all$' | tac | fzf | tr -d '[:space:]')"
}

function gitd {
    git diff -r HEAD${1:-'~'} -- $2
}

function gite {
    if [[ $(git diff --stat) != '' ]]; then 
        git diff --name-only | uniq | xargs -o nvim
    else 
        git diff --name-only HEAD${1:-'~'}  | uniq | xargs -o nvim
    fi
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
alias gits="git status"

_git_branches() {
    cur="${COMP_WORDS[COMP_CWORD]}"
    if [[ "${cur}" = "=\"" ]] || [[ "${cur}" = "=" ]]; then
        cur=""
    fi
    COMPREPLY=($(compgen -W "$(git branch | awk '{ print $1 }')" -- "${cur}"))
    return
}

complete -F _git_branches glab 
complete -F _git_branches glabmr 

activeSprint() {
    $JIRA_BIN sprint list | grep active | rg '(^[0-9]+)' -or '$1'
}

createTicket() {
    local story_points=`expr $2`
    $JIRA_BIN issue create -tTask -anapolitm --custom scrum-team=Quoting --custom story-points=$2 -s"$1" --no-input | rg '(TSG-[0-9]+)' -or '$1'
}

addToSprint() {
    local active_sprint=`activeSprint`
    $JIRA_BIN sprint add $active_sprint $1 1>/dev/null
}

beginWork() {
    $JIRA_BIN issue move $1 "Begin Work"
}

beginCodeReview() {
    $JIRA_BIN issue move $1 "Begin Code Review"
}

jiraAbandon() {
    $JIRA_BIN issue move $1 "Declined pull request" || true
    $JIRA_BIN issue move $1 "Abnormal close" --comment "${2:-asdf}" || true
}

jiraDone(){
    $JIRA_BIN issue move $1 "PR Merged" || true
    $JIRA_BIN issue move $1 "Direct Close" || true
}

ticketsFinish() {
    for ticket in $@; do
        jiraDone $ticket
    done
}

jj() {
    local ticket_id=`createTicket "$1" ${2:-3}`
    addToSprint $ticket_id &> /dev/null
    beginWork $ticket_id &> /dev/null
    beginCodeReview $ticket_id &> /dev/null
    echo $ticket_id
}

jjj_nomr() {
    local ticket_id=$(jj "$1" "${2:-3}")
    git commit -am "[$ticket_id] $1"
}

jjj() {
    local ticket_id=$(jj "$1" "${2:-3}")
    git commit -am "[$ticket_id] $1"
    git push 
    glabmr --target-branch ${3:-features/pilot}
}
