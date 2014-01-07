set HTTP_PROXY=squid:80/
set HTTPS_PROXY=squid:80/

cmd /c vagrant plugin install vagrant-proxyconf
if ERRORLEVEL 1 GOTO:EOF

cmd /c vagrant up
if ERRORLEVEL 1 GOTO:EOF

cmd /c vagrant package --base cubievm --output cubievm.box --vagrantfile Vagrantfile.cubievm
if ERRORLEVEL 1 GOTO:EOF

cmd /c vagrant box add --force cubievm cubievm.box
if ERRORLEVEL 1 GOTO:EOF

:EOF
