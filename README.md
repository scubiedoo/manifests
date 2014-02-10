
# How to create the cubiuntu image - user part #

Please install all necessary tools, refer to [master/README.md](../master/README.md) for a list.

## Step by step
Under Windows: start the Virtual Machine by executing `startVM.bat`.<br>
When you do it the first time, it will take quite a long time, because the Vagrant provisioning will instantly create the image file `generated.img`.

All preceeding builds need to be triggered manually:

- Start the Virtual Machine `startVM.bat`
- Open a shell: e.g. `putty.exe` on `vagrant@127.0.0.1`<br>
  password is `vagrant` 
- Create the image file `/vagrant/manifests.sh`

## Configuration ##
User configuration is work in progress.
For details refer to the developer's configuration section below.



# How it works - developer part #

The build process is designed to run reproducible and automatically from scratch.
Therefore, it uses an automatically created VM ([buildvm/README.md](../buildvm/README.md)) and a modular build script.

## Image files ##

It sets up different image files stored in the `vm` folder which are combined to the resulting cubiuntu image.

- `vm/builddisk.img` contains all compiled sources, e.g. u-boot, kernel, xbmc, ...
- `vm/bootfs_ref.img` contains the boot files, e.g. script.bin, uImage, uEnv.txt
- `vm/rootfs_ref.img` contains the rootfs, kernel modules and all modifications 

## Directory structure ##

still work in progress

In order to have a convenient entry point, every directory contains a script named as same as the directory itself. <br> 
*Not sure whether this is a good or bad idea* 
 
The repository provides the following directories 

- `build`<br>
   contains the build API and a setup file to perpare and mount the builddisk.

- `compile`<br>
   main folder that provides all scripts to create the image.<br>
   These scripts are organized by the main script `compile/compile.sh` which also supports modulary calling a sub-script.<br>
   Sub-scripts perform one step in the build chain, e.g. `kernel.sh` builds the kernel, `rootfs.sh` builds the root fs, `assemble.sh` creates the final image. Each sub-script uses it's own configuration file.

- `setup`<br>
   contains all scripts that modify the rootfs of the cubiuntu image. Each script is executed as `root` inside a chroot-environment which emulates the system like would run on the real cubieboard.

## API ##

Due to on going changes to the API, please refer to `build/build.api.sh` for documentation.

Most important functions:

- `manifests.sh`<br>
   The main script, `manifests.sh` supports (in an early state) module
   For example, when working on the rootfs, we want to skip the u-boot and kernel building process:
   `/vagrant/manifests.sh rootfs assemble`

- `success`<br>
   documents the next command and executes it. If the command fails (exit code != 0), a stack trace will be printed and the whole script termintates.

- `load_configuration`<br>
   configurations work by evaluating the result of a configuration file.
   This means that config files **produce a script as output**.
   The load process reads the configuration file of the calling script file name by using its name as a prefix for including first the `default.sh` config file and afterwards, in order to overwrite default values, the user-defined `config.sh` config file.

- `build_set` or `build_export`<br>
   can be used to set or export variables: use `build_set VAR value` to set or export a value in a configuration.

## Configuration ##
User-defined configuration works by overwriting the default values.
In order to keep the merge process easy and prevent user configurations conflicts, all user configurations are kept in an own file.

Except for the setup scripts which run in the chroot environment, every `default.sh` can be customized.
Therefore, create a new file called `scriptname.config.sh` where default settings can be overwritten.

**Attention:** the configuration script produces a **shell script** which can then be evaluated.<br>
In order to overwrite a variable, print "VARNAME=value" as output. This mechanism makes it possible to run other scripts as well, e.g. 
<pre>
#!/bin/bash
perl my-configure.pl 
</pre>

## Setup overview ##

Vagrant sets up a VirtualBox (which has been created before from [buildvm/README.md](../buildvm/README.md)).
I did it on a Windows host, so the structure looks like this:

<pre>
+--------------------------------------------------------------
|Windows Host
|
| Vagrant starts the machine box.vdi
|c:\VirtualBox\box.vdi         &lt;--->+-----------------------
|                                   |Ubuntu 12.04(buildvm)
| and maps the shared folder        |
|d:\manifests\                 &lt;---->/vagrant/
|                                   |
|                                   |creates image files for 
|                                   |/vagrant/vm/builddisk.img    &lt; mount > /mnt/builddisk
|                                   |/vagrant/vm/bootfs_ref.img   &lt; mount > /mnt/bootfs_ref
|                                   |/vagrant/vm/rootfs_ref.img   &lt; mount > /mnt/rootfs_ref
|                                   |
|                                   |/mnt/rootfs_ref contains the cubieboard rootfs 
|                                   |              | which can be accessed using chroot
|                                   |              +-->+----------------------
|                                   |                  | armhf chroot
|                                   |                  | 
|                                   |                  | 
|                                   |                  | during the rootfs creation process 
|                                   |                  | the files from setup are copied and
|                                   |                  | executed inside the chroot
|d:\manifests\setup   ---- copy ---->/mnt/rootfs_ref -->/root/setup
|                                   |                  | 
|                                   |
|                                   |finally, the image will be assembled into the following file
|d:\manifests\generated.img &lt;------- /vagrant/generated.img
|                                   |

</pre>

builddisk contains all compiled data like kernel, xbmc, etc.
this data is located in an own image file to securely use "vagrant destroy" without losing all compiled files.

(b/r)ootfs_ref represent the two partitions which will be written to the sd-card

