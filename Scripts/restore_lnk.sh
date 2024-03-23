#!/bin/bash
#|---/ /+---------------------------------+---/ /|#
#|--/ /-| Script to fix slinks in .config |--/ /-|#
#|-/ /--| Prasanth Rangan                 |-/ /--|#
#|/ /---+---------------------------------+/ /---|#

export scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/global_fn.sh"
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh..."
    exit 1
fi

find "${CloneDir}" -type l | while read slink
do
    fixd_slink=$(readlink $slink | cut -d '/' -f 4-)
    linkd_file=$(echo $slink | awk -F "${CloneDir}/Configs/" '{print $NF}')
    echo -e "\033[0;32m[LINK]\033[0m $HOME/$linkd_file --> $HOME/$fixd_slink..."
    ln -fs "$HOME/${fixd_slink}" "$HOME/${linkd_file}"
done

if [ -f "${HyprdotsDir}/scripts/globalcontrol.sh" ] ; then
    sed -i "/^CloneDir=/c\CloneDir=\"$CloneDir\"" "${HyprdotsDir}/scripts/globalcontrol.sh"
    echo "globalcontrol updated..."
fi

if printenv HYPRLAND_INSTANCE_SIGNATURE &> /dev/null
    then
    echo "reloading hyprland..."
    hyprctl reload
fi
