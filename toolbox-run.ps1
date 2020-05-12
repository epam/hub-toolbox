$IMAGE = "agilestacks/toolbox:stable"
$TOOLBOX_SHELL = "/bin/bash"

$BASEDIR = (pwd).Path
$USER    = $env:UserName
$HOMEDIR = "/home/$USER"
$WINHOME = "C:\Users\$USER"
$homevol = "{0}:{1}" -f "$WINHOME", "$HOMEDIR"
$basevol = "{0}:{1}" -f "$BASEDIR", "/workspace"

echo $homevol
echo $basevol

& "C:\Program Files\Docker\Docker\resources\bin\docker.exe" run -ti --rm `
-h toolbox-"$env:computername" `
-e "USER=$USER" `
-e "UID=1000" `
-e "GID=1000" `
-e "HOME=$HOMEDIR" `
-e "SHELL=$TOOLBOX_SHELL" `
-e 'PS1=\u@\e[92m\h\e[0m \w $ ' `
-v "$homevol" `
-v "$basevol" `
--privileged=true `
--cap-add=NET_ADMIN `
-w "/workspace" `
"$IMAGE" "$args"

echo "Shutting down toolbox... bye!"
