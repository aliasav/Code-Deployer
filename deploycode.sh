echo "Activating virtual environment 'cod' if not activated."
source $COD_ENV/activate
echo "Present directory:" `pwd`
git_status_output=$(git status 2>&1)
exit_code=$?
if [ "$exit_code" = "128" ]; then
	echo "Not inside a git repository, move into COD repository to deploy code."
else
	flag=0
	echo "Enter target server address to deploy: "
	read server
	echo "Enter branch to deploy: "
	read branch
	echo "Branch entered: $branch"
	# creating temporary hosts file
	touch /tmp/hosts
	path_to_hosts="$COD_REPO/ops/orchestration/app_install"
	sed '1!d' $path_to_hosts/hosts > /tmp/hosts
	echo $server >> /tmp/hosts
	ansible-playbook -i /tmp/hosts $path_to_hosts/app.yml --tags deploy --extra-vars "branch=$branch"
	rm -rf /tmp/hosts
fi
