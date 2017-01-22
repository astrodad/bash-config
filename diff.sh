#!/bin/bash
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
#
# Compare existing bash profile and RC files from this project.

safe_diff () {
    SRC=$1
    DST=$2
    echo "${DST}"
    echo "----------------------------------------"
    if [ -f ${DST} ]; then
        diff ${SRC} ${DST}
    else
        echo "does not exist: ${DST}"
    fi
    echo ""
}

safe_diff bash_profile          ~/.bash_profile
safe_diff bashrc                ~/.bashrc
safe_diff bashrc.Darwin         ~/.bashrc.Darwin
safe_diff bashrc.Linux          ~/.bashrc.Linux
safe_diff bashrc.NetBSD         ~/.bashrc.NetBSD

safe_diff git-completion.sh     ~/.git-completion.sh
safe_diff git-prompt.sh         ~/.git-prompt.sh

safe_diff bin/setjava.sh        ~/bin/setjava.sh
safe_diff java-7.cfg            ~/.java-7.cfg
safe_diff java-JDK1.7.0_80.cfg  ~/.java-JDK1.7.0_80.cfg
safe_diff java-8.cfg            ~/.java-8.cfg
safe_diff java-JDK1.8.0_77.cfg  ~/.java-JDK1.8.0_77.cfg

safe_diff htoprc                ~/.config/htop/htoprc

safe_diff pythonrc              ~/.pythonrc

safe_diff gitconfig             ~/.gitconfig

safe_diff tmux.conf             ~/.tmux.conf

safe_diff vimrc                 ~/.vimrc

#--------------------------------------------------

echo "$0 done"

#============================================================
# done
#============================================================
