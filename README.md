# Vagrant box creation

Setting up a virtual machine can take some time, e.g. upgrade and install all packages or compile own tools.
Vagrant provides a mechanism called "boxing" to precreate a virtual machine so that the actual start and setup of this machine is much faster.

As long as this is work in progress, everybody needs to create an own vagrant box file. We might provide the box image as download link in the future.

## Start the box creation

The process is quite easy and already written to an executable script.

1. Download a basic box provided by the Vagrant community.
1. Modify the virtual machine for Cubieboard development.
1. Repackage the virtual machine into a new box file for deployment. The result can be found in `vm/cubievm.box`

All this is done for you in `createCubieVM.bat`.
Finally, switch the branch to [cubiuntu](../cubiuntu "cubiuntu") and build your cubieboard image. 


### How it works

Vagrant offers a tool called *provisioning*.<br>
Provisioning starts advanced tools like chef, puppet, or a simple shell to set up the virtual machine with all needed packages and configurations.

I used the shell provisioning to minimize dependent knowledge about other tools.
Based on threads posted to cubieforums.com, i concluded that bash will be sufficient for most cases.
Thus, when creating a virtual machine, the `setupCubieVM.sh` script will be executed to install packages.

I didn't put much effort in configuration in this script.
Feel free to support the cubieboard community with chef or puppet scripts!

### Troubleshooting
In case you are behind a proxy

 - download the box from [http://files.vagrantup.com/precise32.box](http://files.vagrantup.com/precise32.box "Vagrant box")
 - save this file to `vm\precise32.box`
   The `createCubieVM.bat` prefers using an existing file over downloading from the Internet. 

## Useful vagrant commands

From cmd.exe or shell, you can start, halt, destroy, and recreate your virtual machine for building the cubieboard image.

 - vagrant up<br>
   start the virtual machine. If it doesn't exist, it will be created.

 - vagrant ssh<br>
   login to the virtual machine (works on linux only, for windows use [putty](http://www.chiark.greenend.org.uk/%7Esgtatham/putty/download.html "putty"))

 - vagrant halt<br>
   stop the virtual machine.

 - vagrant destroy<br>
   If you ever have problems with your VM, simply remove it from your system and recreate it.
