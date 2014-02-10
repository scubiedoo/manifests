# manifests
A modular build environment for cubieboard image generation.

# Prerequisites

You need the following tools build a cubieboard image.

- [https://www.virtualbox.org/](https://www.virtualbox.org/ "VirtualBox")<br>
  VirtualBox is a well-known virtual machine, because we don't want to accidently do any harm our own host machine

- [http://www.vagrantup.com/](http://www.vagrantup.com/ "Vagrant")<br>
  Vagrant can automatically set up virtual machines. Thus, it can easily create and recreate a virtual machine.<br>
  Therfore, the installation process is automated and no manual ineractino should be necessary.   

- git (optionally)<br>
  git is not needed because you can download the sources and start the build process. But it is recommended for updating the build environment.

# Let's go

After installing all necessary tools, you have to do the following steps to build a basic cubieboard image

1. Create the vagrant box which is used as a basic VirtualBox setup for cubieboard image creation. Typically, you only have to do this step once (or once in a while to update the vagrant box).

1. Start the VirtualBox image and let the provisioning build the cubieboard image.

1. For further builds, start the VirtualBox image and 
   - rerun the vagrant provisioning by calling `vagrant provision`
   - login to the virtual machine and run the build script `/vagrant/manifests.sh`  

# Motivation

I found myself testing image over image on my cubieboard2, searching THE image that fits all my needs.
Everytime there was something that didn't work.
While reading a thread on cubieforums.com, the idea popped up to take a distro and make it customizable for everybody,
but still have developers to improve its overall performance.

Thus, my target is to provide a customizable framework for image creation so that users can select features 

I am using Ubuntu ever since, so my first choice was a Ubuntu based image, namely cubiuntu.

