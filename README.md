manifests
=========

Android style to manage cubieboard2 repos

# 1.Instructions to create linux test firmware for cubieboard2

## 1.1 Get source code

 $curl https://raw.github.com/cubieboard/git-repo/stable/repo > ~/bin/repo
 
 $chmod +x ~/bin/repo
 
 $mkdir cubieboard2_test && cd cubieboard2_test
 
 $repo init --no-repo-verify -u git://github.com/cubieboard2/manifests -b cb2 -m test.xml 
 
 $repo sync

## 1.2 Compile and generate image

 $./build.sh rootfs/linux_test_rootfs.tar.gz

 This will generate an image(output/pack/livesuit_cubieboard2.img) , which can be flashed to the nandflash on cubieboard by livesuit tools

## 1.3 Flash the image to nandflash on Cubieboard2(A20)

  First, you need to download livesuit tools, the download url for each platform are,
 
* [Ubuntu x86](http://ubuntuone.com/2bf1fIHN3oFR5NRyggJqPP "Ubuntu x86")
* [Ubuntu x86-64](http://ubuntuone.com/1Q5Yi3eVAzS2xn3Ex7Ix3n "Ubuntu x86_64")
* [Mac](http://ubuntuone.com/7GLnElgM41yoGLZfRKxXzk "Mac")
* [Windows](http://ubuntuone.com/3Z95tYxkcpvKq5oc2Zdpka "Windows")



Please notices that, The livesuit is provided by allwinner, and they are closed source, so we are unable to modify them neither. Currently, The most stable version is for Windows. After you having installed livesuit on your PC,

1. Start livesuit, and select the image you want to flash

2. Power off Cubieboard2, press the FEX key, which is near to the Mini-USB port, and hold it on while plugging in Mini USB cable

3.  Livesuit will run into FEX mode, and start to flash the image to nandflash

# 2. Notes

1. This image is for testing cubieboard2, which will be triggered by sending IR key '1'(code=26) after
 system startup.

2. Please do not use old livesuit that comes with a10, It's not compatible, and I don't know why till now.

3. Some prebuilt image for cubieboard2

Ubuntu 12.04 Desktop:

* [v1.02, DDR480MHz](http://ubuntuone.com/5XAQqDTbQ9HsJ1iiSAhhdu "image1, DDR480Mhz")
* [v1.02, DDR432MHz](http://ubuntuone.com/0tRcRMM8MsoHMJ2onL9YNI "image2, DDR432MHz")

Android 4.2:

* [support rtl8192cu wifi DDR432MHz](http://ubuntuone.com/0XfWiwxnpW1P9oJDAeq3sI  "support rtl8192cu wifi DDR432MHz")
* [support rtl8192cu wifi DDR480MHz](http://ubuntuone.com/1HxMAVUwpikUeGG5o9bm7I  "support rtl8192cu wifi DDR480MHz")
* [kernel source](http://ubuntuone.com/1NiOvqFiOAm5U0XOoqwx9j  "kernel source")
* [support rtl8188eu wifi DDR432MHz](http://ubuntuone.com/65cb9IbMRw5FSwmwFsRzvk  "support rtl8188eu wifi DDR432MHz")
* [support rtl8188eu wifi DDR480MHz](http://ubuntuone.com/2Jv9jdDFrQkCviJOJj06tV  "support rtl8188eu wifi DDR480MHz")


  
