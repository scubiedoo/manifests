
How it works
============

Vagrant sets up a VirtualBox (which has been created before from #buildvm).

+---------------------------------------------------------------
|** Host **
| Vagrant starts the machine box.vdi
|c:\VirtualBox\box.vdi         <->  +-----------------------
|                                   |Ubuntu 12.04(buildvm)
| and maps the shared folder        |
|d:\manifests\                 <->  |/vagrant/
|                                   |
|                                   |creates an image files for 
|                                   |/vagrant/vm/builddisk.img    < mount > /mnt/builddisk
|                                   |/vagrant/vm/bootfs_ref.img   < mount > /mnt/bootfs_ref
|                                   |/vagrant/vm/rootfs_ref.img   < mount > /mnt/rootfs_ref
|                                   |

builddisk contains all compiled data like kernel, xbmc, etc.
this data is located on an own image file to securely use "vagrant destroy" without losing all compiled files.

(b/r)ootfs_ref represent the two partitions which will be written to the sd-card

