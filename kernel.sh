#!/bin/sh

#apt-get install build-essential bin86 kernel-package libqt3-headers libqt3-mt-dev wget libncurses5 libncurses5-dev

cd /usr/src

DOWNLOAD_PATH=`curl kernel.org | grep "/pub/linux/kernel/" | grep ">F<" | cut -d'"' -f2 | head -n 1`
KERNEL_FILENAME=`echo $DOWNLOAD_PATH | tr "/" "\n" | tail -n 1`

#wget -c http://kernel.org$DOWNLOAD_PATH
#tar -xvjf $KERNEL_FILENAME
KERNEL_FIELDCNT=`echo $KERNEL_FILENAME | tr "." "\n" | head -n -2 | wc -l`
KERNEL_DIR=`echo $KERNEL_FILENAME | tr "." "\n" | head -n -2 |  tr "\n" "." | cut -d"." --field=-$KERNEL_FIELDCNT`
echo
echo $KERNEL_DIR
cd $KERNEL_DIR

cp /boot/config-$(uname -r) .config

yes "" | make oldconfig

make xconfig
#make menuconfig

make-kpkg clean

CONCURRENCY_LEVEL=3 time make-kpkg --initrd --revision=64 kernel_image kernel_headers modules_image

