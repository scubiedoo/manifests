# manifests
A modular build environment for cubieboard image generation.

# Prerequisites

You need the following tools build a cubieboard image.

- [https://www.virtualbox.org/](https://www.virtualbox.org/ "VirtualBox")<br>
  VirtualBox is a well-known virtual machine, because we don't want to accidently do any harm our own host machine

- [http://www.vagrantup.com/](http://www.vagrantup.com/ "Vagrant")<br>
  Vagrant can automatically create and recreate a virtual machine which results in the same environment for every user without doing manual steps.

- git (optionally)<br>
  git is not needed because you can download the sources and start the build process. But it is recommended for updating the build environment.

- [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html "putty") or any other ssh client<br>
  if you want to pre-test the rootfs, you will need a ssh client.

- about 20GB disk space 

# Cubieboard image

After installing all necessary tools, you have to do the following steps to build a basic cubieboard image

1. Create the vagrant box which is used as a basic VirtualBox setup for cubieboard image creation. Typically, you only have to do this step once (or once in a while to update the vagrant box).
   - Download the branch [buildvm](buildvm)
   - start `createCubieVM.bat/sh`

1. Start the VirtualBox image and let the provisioning build the cubieboard image.
   - Download/checkout the branch [cubiuntu](cubiuntu)
   - run `startVM.bat` or `vagrant up` in the download folder from `cmd.exe/shell`

1. For further builds, start the VirtualBox image and 
   - rerun the vagrant provisioning by calling `vagrant provision`
   - ssh login to the virtual machine (usr/pwd=`vagrant/vagrant`) and run the build script `/vagrant/manifests.sh`  

# Motivation

I found myself testing image over image on my cubieboard2, searching for THE image that fits all my needs.
Everytime there was something that didn't work or which I had to reconfigure. Then, a new image is released and i had to reconfigure the image again, and again...

While reading a thread on cubieforums.com, the idea popped up to take a distro and make it customizable for everybody,
but still have developers to improve its overall performance.

Thus, my target is to provide a customizable framework for image creation so that users can select features, but save their configurations when upgrading.

I am using Ubuntu ever since, so my first choice was a Ubuntu based image, namely cubiuntu.
