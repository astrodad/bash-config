# bashrc - general
#--------------------------------------------------------------------------------
#  Copyright 2016 Joseph Skora
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#--------------------------------------------------------------------------------

#============================================================
# Terminal output is suppressed by default because it can
# conflict with SSH sessions in an unobvious way.  Output
# can be redirected to a log for debugging purposes using
# the BASH_LOG function instead of the 'echo' command.
#
# If .bashrc is being suppressed or if the OS can not be
# determined console messages are currently not suppressed
# to make sure user is aware of those states.
#============================================================

# Suppress .bashrc if requested
#------------------------------------------------------------
if [ -f ${HOME}/.bashrc.suppress ] ; then
    echo "Suppressing .bashrc due to ~/.bashrc.suppress"
    return
fi

# Log to file if debug file exists or debug variable is set.
#------------------------------------------------------------
export BASH_LOGFILE=${HOME}/.bash_profile.log
if [ -f ~/.bashrc.debug -o "${BASH_DEBUG:-NO}" == "YES" ] ; then
    export BASH_DEBUG=YES
    echo "*DEBUG ON*" > ${BASH_LOGFILE}
else
    export BASH_DEBUG=NO
fi
BASH_LOG() {
    if [ "${BASH_DEBUG}" == "YES" ]; then
	echo "$(date +%Y%m%d-%H%M%S) $*" >> ${BASH_LOGFILE}
    fi
}
BASH_LOG "ORIGINAL PATH was ${PATH}"

# Determine operating system and host identities
#------------------------------------------------------------
OS=$(uname)
HOST=$(hostname -s)
# attempt aliased 'which' and retry without on error
GREP=$(which --skip-alias grep 2>/dev/null)
if [ $? -ne 0 ]; then
    GREP=$(which grep 2>/dev/null)
fi
BASH_LOG "${HOST} appears to be running ${OS}"
case ${OS} in
Darwin)
    ;;
Linux)
    # prefer OS X like prompt
    PS1='\h:\W \u\$ '    
    ;;
NetBSD)
    # prefer OS X like prompt
    PS1='\h:\W \u\$ '    
    ;;
*)
    echo "*** Unknown OS, guessing at configuration ***"
    ;;
esac

# function for adding paths
#------------------------------------------------------------
BASH_ADDPATH() {
    if ! echo ${PATH} | $GREP -q ${1} ; then
	if [ "${2}" == "PRE" ]; then
	    BASH_LOG "prefixing $1 to PATH"
	    export PATH=${1}:${PATH}
	else
	    BASH_LOG "suffixing $1 to PATH"
	    export PATH=${PATH}:${1}
	fi
    fi
}

# add home binary path if not already included
#------------------------------------------------------------
BASH_ADDPATH ${HOME}/bin PRE

# setup git completion if scripts exist
#------------------------------------------------------------
if [ -f ~/.git-completion.sh ] ; then
    source ~/.git-completion.sh
fi
if [ -f ~/.git-prompt.sh ] ; then
    source ~/.git-prompt.sh
    export GIT_PS1_SHOWDIRTYSTATE=true
    export PS1='\[\e]0;\u@\h\a\]\[\e[1;32m\]\u@\h \[\e[1;33m\]\w\[\e[0m\]$(__git_ps1 " (%s)")\n$ '
else
    export PS1='\[\e]0;\u@\h\a\]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]  `date`\n$ '
fi

# python rc file
#------------------------------------------------------------
if [ -f ${HOME}/.pythonrc ]; then
    export PYTHONSTARTUP=${HOME}/.pythonrc
fi

# source bashrc existing files for OS, and HOST
#------------------------------------------------------------
for sfx in .${OS} .${HOST}; do
    if [ -f ~/.bashrc${sfx} ] ; then
        BASH_LOG "sourcing .bashrc${sfx}"
        source ~/.bashrc${sfx}
    fi
done

# history
#     - timestamp entries,
#     - keep 2,000 commands (default is 500), and
#     - ignore duplicates
#     - ignore lines beginning with space (suppress history)
#------------------------------------------------------------
export HISTTIMEFORMAT="%c "
export HISTSIZE=2000
export HISTCONTROL=ignoredups:ignorespace

# configure ssh-agent
#------------------------------------------------------------
SSH_ENV="$HOME/.ssh/environment"
function start_agent {
    #echo "Initializing new SSH agent..."
    touch $SSH_ENV
    chmod 600 "${SSH_ENV}"
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' >> "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    #/usr/bin/ssh-add
}
# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    kill -0 $SSH_AGENT_PID 2>/dev/null || {
        start_agent
    }
else
    start_agent
fi

# configure source highlight
#------------------------------------------------------------
if [ -f "/usr/share/source-highlight/src-hilite-lesspipe.sh" ]; then
    SRC_HILITE="/usr/share/source-highlight/src-hilite-lesspipe.sh"
elif [ -f "/usr/bin/src-hilite-lesspipe.sh" ]; then
    SRC_HILITE="/usr/bin/src-hilite-lesspipe.sh"
elif [ -f "/opt/local/bin/src-hilite-lesspipe.sh" ]; then
    SRC_HILITE="/opt/local/bin/src-hilite-lesspipe.sh"
fi
if [ -f "${SRC_HILITE}" ] ; then
    export LESSOPEN="| ${SRC_HILITE} %s"
    export LESS=' -R '
fi

BASH_LOG "FINAL PATH was ${PATH}"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
if [ -z "${SDKMAN_DIR}" ]; then   # prevent re-running sdkman init
    export SDKMAN_DIR="${HOME}/.sdkman"
    [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
fi
