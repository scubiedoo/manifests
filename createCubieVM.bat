rem set HTTP_PROXY=squid:80/
rem set HTTPS_PROXY=squid:80/

mkdir vm

cmd /c vagrant box add precise32 vm\precise32.box

cmd /c vagrant plugin install vagrant-proxyconf
if ERRORLEVEL 1 GOTO:EOF

cmd /c vagrant destroy 
cmd /c vagrant up
if ERRORLEVEL 1 GOTO:EOF

cmd /c vagrant package --base cubievm --output vm\cubievm.box --vagrantfile Vagrantfile.cubievm
if ERRORLEVEL 1 GOTO:EOF

cmd /c vagrant box add --force cubievm vm\cubievm.box
if ERRORLEVEL 1 GOTO:EOF

echo "Successfully created cubievm box"

:EOF
