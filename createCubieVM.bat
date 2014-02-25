rem I'm a bash shell user, so sorry for any bad batch code in advance

set BASEBOX_FILE=vm\precise32.box
set CUBIEBOX_FILE=vm\cubievm.box

mkdir vm
if exist %BASEBOX_FILE% (
	cmd /c vagrant box add --force precise32 %BASEBOX_FILE%
	if ERRORLEVEL 1 GOTO :EOF
) else (
	cmd /c vagrant box add --force precise32 http://files.vagrantup.com/precise32.box
	if ERRORLEVEL 1 GOTO :EOF
	cmd /c vagrant box repackage precise32 VirtualBox
	if ERRORLEVEL 1 GOTO :EOF
	mv package.box %BASEBOX_FILE%
)

cmd /c vagrant plugin install vagrant-proxyconf
if ERRORLEVEL 1 GOTO :EOF

cmd /c vagrant destroy --force
cmd /c vagrant box remove cubievm
cmd /c vagrant up
if ERRORLEVEL 1 GOTO :EOF

del /Q /F %CUBIEBOX_FILE%
cmd /c vagrant package --base cubievm --output %CUBIEBOX_FILE% --vagrantfile Vagrantfile.cubievm
if ERRORLEVEL 1 GOTO :EOF

cmd /c vagrant box add --force cubievm %CUBIEBOX_FILE%
if ERRORLEVEL 1 GOTO :EOF

echo "Successfully created cubievm box"
pause
exit 0

:EOF

echo "Failed create cubievm box"
pause
