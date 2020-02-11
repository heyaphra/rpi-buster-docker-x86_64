#!/bin/bash

#  Original author: github.com/jguiraudet
#  Create a $CONTAINER_RUNTIME image raspbian distribution image for raspberry-pi

# Change the SRC path if needed:
SRC=https://downloads.raspberrypi.org/raspbian_full_latest
CONTAINER_RUNTIME=$1 # Ex: $CONTAINER_RUNTIME, docker, etc.
set -e
sudo echo Info: Need root access to mount the image to extract the content

FILE=./raspbian-tmp/*.img
if test -f "$FILE"; then
	echo "Using local image: $FILE"
else
	echo "$FILE not found locally."
	# Download the image
	mkdir raspbian-tmp
	cd raspbian-tmp
	echo Downloading image...
	wget --trust-server-names $SRC
	unzip *.zip && rm *.zip
fi

# Mount the image
DISK_IMG=$(ls *.img | sed 's/.img$//')
OFFSET=$(fdisk -lu $DISK_IMG.img | sed -n "s/\(^[^ ]*img2\)\s*\([0-9]*\)\s*\([0-9]*\)\s*\([0-9]*\).*/\2/p")
mkdir root
sudo mount -o loop,offset=$(($OFFSET * 512)) $DISK_IMG.img root
# Disable preloaded shared library to get everything including networking to work on x86
sudo mv root/etc/ld.so.preload root/etc/ld.so.preload.bak

# Copy qemu-arm-static in the image be able to interpret arm elf on x86
if /usr/bin/qemu-arm-static -version | grep 4.2.0; then
	# Fix crash with `tcg.c:1693: tcg fatal error` by using a more recent version
	wget https://github.com/multiarch/qemu-user-static/releases/download/v4.2.0-4/qemu-arm-static
	chmod 755 ./qemu-arm-static
	sudo cp ./qemu-arm-static root/usr/bin
else
	sudo cp /usr/bin/qemu-arm-static root/usr/bin
fi

# Create $CONTAINER_RUNTIME images
cd root
sudo tar -c . | sudo $CONTAINER_RUNTIME import - spidercatnat/raspbian-buster-for-x86_64:$CONTAINER_RUNTIME
cd ..

# Clean-up
sudo umount root
rmdir root
# rm $DISK_IMG.img
sudo $CONTAINER_RUNTIME images | grep raspbian

echo Test the image with:
echo $CONTAINER_RUNTIME run -ti --rm spidercatnat/raspbian-buster-for-x86_64:$CONTAINER_RUNTIME /bin/bash -c \'uname -a\'
# if $CONTAINER_RUNTIME run -ti --rm spidercatnat/raspbian-buster-for-x86_64:$CONTAINER_RUNTIME /bin/bash -c 'uname -a' | grep armv7l; then echo OK; else echo FAIL; fi
