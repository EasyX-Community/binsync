#!/usr/bin/env bash

# Get calling script's directory
SOURCE=${BASH_SOURCE[0]}
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
vSOURCEDIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

echo "source directory    [$vSOURCEDIR]"

# Autofilled Variables (do not change)
export vPWD=$(pwd)
export vPATH=$(echo $PATH)

export vVER=$(cat ${vSOURCEDIR}/bin/.binsync.version)

if test -f "${vSOURCEDIR}/bin/.binsync.config"; then
  source ${vSOURCEDIR}/bin/.binsync.config
else
  echo "${vSOURCEDIR}/bin/.binsync.config does not exist, please read the README.md!"
  echo ""
  exit
fi

echo ""
echo "binsync-install ${vVER} [${vBINSYNCDIR}]"
echo ""
echo "user                [$vUSER]"
echo "host                [$vHOST]"
echo "source directory    [$vSOURCEDIR]"
echo "working directory   [$vPWD]"
echo "bin directory       [$vBINSYNCDIR]"
echo "path                [$vPATH]"
echo ""

vRSYNC=$(dpkg-query -l rsync)
if [[ "no packages found matching" == *"${vRSYNC}"* ]]; then
  echo "installing rsync"
  echo ""
  apt update
  echo ""
  apt install -y rsync
  echo ""
fi

mkdir -p ${vBINSYNCDIR}

# Change the repo dir in scripts (THISISREPODIRPLACEHOLDERDONOTTOUCH)
sed -i "s~THISISREPODIRPLACEHOLDERDONOTTOUCH~${vPWD}~" bin/binsync-update
sed -i "s~THISISREPODIRPLACEHOLDERDONOTTOUCH~${vPWD}~" bin/binsync-pull
sed -i "s~THISISREPODIRPLACEHOLDERDONOTTOUCH~${vPWD}~" bin/binsync-push

# CHMOD the binsync scripts
chmod +x bin/binsync-*

# Check if vPWD/bin is added to $PATH
if [[ "${vPATH}" == *"${vPWD}/bin"* ]]; then
  echo "Binsync directory already in path [${vPATH}]"
  echo ""
else
  echo "Adding binsync directory to \$PATH"
  echo "export PATH=${vPWD}/bin:\$PATH" | tee -a ${HOME}/.bashrc
  echo ""
  echo "Please execute 'source ${HOME}/.bashrc' or log out and back in again"
  echo ""
fi

echo "binsync installation is complete!"
echo ""

# Clear ENV vars for security
source ${vSOURCEDIR}/bin/.binsync.config.clear
