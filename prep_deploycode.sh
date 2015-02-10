# Sets environment variables for COD Repo and Virtual environment path

echo "Configuration for code deployer"
flag=0

# Getting path of COD Repo
while [[ $flag -eq 0 ]]; do
	echo "Enter absolute path of COD repository: "
	read path_to_repo
	path_to_hosts="$path_to_repo/ops/orchestration/app_install"
	cd $path_to_hosts -&>/dev/null
	if [ $? -eq 0 ]; then
		echo 'Correct path entered.'
		echo "export COD_REPO=$path_to_repo" >> ~/.bashrc
		break
	else
		echo 'Invalid path entered.'
		continue
	fi
done

# Getting path of virtual environment
flag=0
while [[ $flag -eq 0 ]]; do
	echo "Enter absolute path of environment (example: /home/wayne_bruce/virtual_envs/cod): "
	read path_to_env
	path_to_env_activate="$path_to_env/bin"
	cd $path_to_env_activate -&>/dev/null
	if [ $? -eq 0 ]; then
		echo 'Correct path entered.'
		echo "export COD_ENV=$path_to_env_activate" >> ~/.bashrc
		break
	else
		echo 'Invalid path entered.'
		continue
	fi
done

# Getting path of deloycode.sh
flag=0
while [[ $flag -eq 0 ]]; do
	echo "Enter absolute path of deploycode.sh: "
	read path_to_deploycode
	cd $path_to_deploycode -&>/dev/null
	if [ $? -eq 0 ]; then
		echo 'Correct path entered.'
		echo $path_to_deploycode
		x="'source $path_to_deploycode/deploycode.sh'"
		echo "alias deploy=$x" >> ~/.bashrc
		break
	else
		echo 'Invalid path entered.'
		continue
	fi
done

echo 'Now you can deploy code, using command: `deploy`'
echo 'Note: If you change the location of deploycode.sh, you have to do 2 things: '
echo '1. Open ~/.bashrc, remove alias entry for deploy.'
echo '2. Run this script again.'
source ~/.bashrc