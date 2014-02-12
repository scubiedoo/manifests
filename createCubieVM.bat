rem I'm a bash shell user, so sorry for any bad batch code in advance

 set HTTP_PROXY=squid:80/
 set HTTPS_PROXY=squid:80/

set BOX_FILE=vm\precise32.box

mkdir vm

if exist %BOX_FILE% (
	cmd /c vagrant box add --force precise32 %BOX_FILE%
	if ERRORLEVEL 1 GOTO:EOF	
) else (
	cmd /c vagrant box add --force precise32 http://files.vagrantup.com/precise32.box
	if ERRORLEVEL 1 GOTO:EOF
)

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
