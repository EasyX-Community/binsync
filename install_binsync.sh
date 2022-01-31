#!/usr/bin/env bash

# Autofilled Variables (do not change)
export vPWD=$(pwd)
export vPATH=$(echo $PATH)
export vVER=$(cat bin/.binsync.version)

# Clear variables
vUSER=""
vHOST=""
vBINSYNCDIR=""
vHOSTMACHINE=1
vCRONJOB=1
vCRONJOBUPDATE=1
vHOSTMACHINEENG=""
vCRONJOBENG=""

if [ -f "bin/.binsync.config" ] ; then

  source bin/.binsync.config

  echo ""
  echo "binsync install ${vVER}"
  echo ""
  echo "user                [$vUSER]"
  echo "host                [$vHOST]"
#  echo "source directory    [$vSOURCEDIR]"
  echo "working directory   [$vPWD]"
  echo "bin directory       [$vBINSYNCDIR]"
  echo "path                [$vPATH]"
  echo ""

else

  echo "apt updating..."
  apt update
  echo ""

  vDIALOG=$(dpkg-query -s dialog)
  if [[ "dpkg-query: package 'dialog' is not installed" == *"${vDIALOG}"* ]]; then
    echo "installing dialog"
    echo ""
    apt install -y dialog
    echo ""
  fi

  vRSYNC=$(dpkg-query -s rsync)
  if [[ "dpkg-query: package 'rsync' is not installed" == *"${vRSYNC}"* ]]; then
    echo "installing rsync"
    echo ""
    apt install -y rsync
    echo ""
  fi

  vCONTINUEVAR=1
  while [ "$vCONTINUEVAR" == "1" ]
  do

    while [ "$vUSER" == "" ]
    do
      vUSER=$(dialog --stdout --title "Configuration" \
        --backtitle "binsync ${vVER} setup" \
        --inputbox "User:" 8 60)
    done

    while [ "$vHOST" == "" ]
    do
      vHOST=$(dialog --stdout --title "Configuration" \
        --backtitle "binsync ${vVER} setup" \
        --inputbox "Host IP:" 8 60)
    done

    while [ "$vBINSYNCDIR" == "" ]
    do
      vBINSYNCDIR=$(dialog --stdout --title "Configuration" \
        --backtitle "binsync ${vVER} setup" \
        --inputbox "Binsync Dir:" 8 60)
    done

    dialog --stdout --title "Configuration" \
      --backtitle "binsync ${vVER} setup" \
      --yesno "Is this the host machine?" 10 60 \
    3>&1 1>&2 2>&3 3>&-
    vHOSTMACHINE=$?

    if [[ $vHOSTMACHINE -eq 1 ]] ; then

      dialog --stdout --title "Configuration" \
        --backtitle "binsync ${vVER} setup" \
        --yesno "Should I install cronjob to run every 5 min?" 10 60 \
      3>&1 1>&2 2>&3 3>&-
      vCRONJOB=$?

    fi

    dialog --stdout --title "Configuration" \
      --backtitle "binsync ${vVER} setup" \
      --yesno "Should I install cronjob to update binsync weekly?" 10 60 \
    3>&1 1>&2 2>&3 3>&-
    vCRONJOBUPDATE=$?

    if [ $vHOSTMACHINE -eq 0 ] ; then
      vHOSTMACHINEENG="yes"
    else
      vHOSTMACHINEENG="no"
    fi

    if [ $vCRONJOB -eq 0 ] ; then
      vCRONJOBENG="yes"
    else
      vCRONJOBENG="no"
    fi

    if [ $vCRONJOBUPDATE -eq 0 ] ; then
      vCRONJOBUPDATEENG="yes"
    else
      vCRONJOBUPDATEENG="no"
    fi

    dialog --stdout --title "Configuration" \
      --backtitle "binsync ${vVER} setup" \
      --yesno "Is this information correct?\nUser: ${vUSER}\nHost IP: ${vHOST}\nBinsync Dir: ${vBINSYNCDIR}\nRepo Dir: ${vPWD}\nIs Host: ${vHOSTMACHINEENG}\nInstall Cronjob: ${vCRONJOBENG}\nWeekly update cronjob: ${vCRONJOBUPDATEENG}" 15 60 \
    3>&1 1>&2 2>&3 3>&-
    vCONTINUEVAR=$?

  done

  echo "" | tee bin/.binsync.config > /dev/null 2>&1
  echo "#!/usr/bin/env bash" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "#" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "## SSH Connection Info" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "#" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "# Username for SSH connection" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "export vUSER=\"${vUSER}\"" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "# Host IP for SSH connection" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "export vHOST=\"${vHOST}\"" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "#" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "## Directories" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "#" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "# Location of binsync dir to sync (DO NOT put trailing /)" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "export vBINSYNCDIR=\"${vBINSYNCDIR}\" # DO NOT put trailing /" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "# Location of this repository" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "export vREPODIR=\"${vPWD}\"" | tee -a bin/.binsync.config > /dev/null 2>&1
  echo "" | tee -a bin/.binsync.config > /dev/null 2>&1

fi

source bin/.binsync.config

mkdir -p ${vBINSYNCDIR}

# CHMOD the binsync scripts
chmod +x bin/binsync-*

# Check if vBINSYNCDIR is added to $PATH
if [[ "${vPATH}" == *"${vBINSYNCDIR}"* ]]; then
  echo "binsync repo directory already in path [${vPATH}]"
  echo ""
else
  echo "Adding binsync repo directory to \$PATH"
  echo "export PATH=${vBINSYNCDIR}:\$PATH" | tee -a ${HOME}/.bashrc
  echo ""
fi

# Check if vPWD/bin is added to $PATH
if [[ "${vPATH}" == *"${vPWD}/bin"* ]]; then
  echo "binsync bin directory already in path"
  echo ""
else
  echo "Adding binsync bin directory to \$PATH"
  echo "export PATH=${vPWD}/bin:\$PATH" | tee -a ${HOME}/.bashrc
  echo ""
fi

# ADD BINSYNC CRONJOB
if [[ $vCRONJOB -eq 0 ]] ; then
  vCRONJOBENG="yes"
  vCRONENTRIES=$(crontab -l)
  if [[ "$vCRONENTRIES" != *"${vPWD}/bin/binsync-pull ; ${vPWD}/bin/binsync-push ;"* ]] ; then
    echo "installing cronjob"
    echo -e "$(crontab -l)\n\n# binsync cronjob" | crontab -
    echo -e "$(crontab -l)\n*/5 * * * * ${vPWD}/bin/binsync-pull ; ${vPWD}/bin/binsync-push ;" | crontab -
  else
    echo "refusing to install cron, cron already exists!"
  fi
else
  vCRONJOBENG="no"
  echo "skipping cronjob install"
fi

# ADD BINSYNC-UPDATE CRONJOB
if [[ $vCRONJOBUPDATE -eq 0 ]] ; then
  vCRONJOBUPDATEENG="yes"
  vCRONENTRIES=$(crontab -l)
  if [[ "$vCRONENTRIES" != *"@weekly ${vPWD}/bin/binsync-update ;"* ]] ; then
    echo "installing binsync-update cronjob"
    echo -e "$(crontab -l)\n\n# binsync-update cronjob" | crontab -
    echo -e "$(crontab -l)\n@weekly ${vPWD}/bin/binsync-update ;" | crontab -
  else
    echo "refusing to install binsync-update cron, cron already exists!"
  fi
else
  vCRONJOBUPDATEENG="no"
  echo "skipping binsync-update cronjob install"
fi

echo ""

echo "binsync installation is complete!"
echo ""
echo "Please execute 'source ~/.bashrc' or log out and back in again"
echo ""

# Clear ENV vars for security
source bin/.binsync.config.clear
