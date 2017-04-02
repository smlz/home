# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=8096
HISTFILESIZE=16192

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [ "$(id -u)" = 0 ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\]\n\$ '
    else 
        if [ -n "$SSH_CONNECTION" ]; then
            PS1='${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\]\n\$ '
        elif [ -n "$STY" ] || [ -n "$TMUX" ]; then
            PROMPT_COMMAND='__PS1_RET=$?;'
            PS1='\[\033[01;34m\]\W/\[\033[00m\] $(test $__PS1_RET != 0 && echo -ne "\[\033[01;31m\]")$\[\033[00m\] '
        else
            PROMPT_COMMAND='__PS1_RET=$?;'
            PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\] $(get-git-branch)$(test -n "$VIRTUAL_ENV" && echo " (env)")\n$(test $__PS1_RET != 0 && echo -ne "\[\033[01;31m\]")$\[\033[00m\] '
        fi
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ls='LANG=C ls --color=auto --group-directories-first --human-readable'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -i'
alias less=/usr/share/vim/vim74/macros/less.sh
alias linus="echo pause | mplayer -slave -fs -idle -fixed-vo ~/bin/Linus_Torvalds_To_Nvidia_-_Fuck_You.mp4 -ss 10 -endpos 2.5 > /dev/null 2>&1"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
export EDITOR=nano
export PYMACS_PYTHON=/usr/bin/python
# Disable default virtualenv PS1 modification
export VIRTUAL_ENV_DISABLE_PROMPT=TRUE

#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

gitshortcuts=~/workspace/atizo-platform/scripts/git-shortcuts.rc
test -f $gitshortcuts && source $gitshortcuts

. ~/bin/django_bash_completion

true

source <(npm completion)

### Added by the Heroku Toolbelt
#export PATH="/usr/local/heroku/bin:$PATH"

export ORIGINAL_PATH=$PATH

update_path() {
  # npm: add npm_modules/.bin to $PATH
  P=$(pwd)
  while [[ $P != / ]]; do
      if [[ -d $P/node_modules && -d $P/node_modules/.bin ]]; then
          export PATH=$P/node_modules/.bin:$ORIGINAL_PATH
          break
      fi
      P=$(dirname $P)
  done

  # activate python virtual env if .venv exists
  P=$(pwd)
  while [[ $P != / ]]; do
      if [[ -d $P/.venv && -f $P/.venv/bin/activate ]]; then
          source $P/.venv/bin/activate
          FOUND_VENV=yes
          break
      fi
      P=$(dirname $P)
  done
  if [[ $FOUND_VENV != yes ]]; then
      type deactivate &>/dev/null && deactivate
  fi
  unset FOUND_VENV
  unset P
  true
}

cd() {
  builtin cd "$@"
  update_path
}

update_path
