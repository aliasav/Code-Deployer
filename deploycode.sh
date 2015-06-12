echo "Activating virtual environment 'cod' if not activated."
source $COD_ENV/activate
echo "Present directory:" `pwd`
git_status_output=$(git status 2>&1)
exit_code=$?
path_to_hosts=$COD_REPO/ops/orchestration/app_install
if [ "$exit_code" = "128" ]; then
	echo "Not inside a git repository, move into COD repository to deploy code."
else
	flag=0
	echo "Enter target server address to deploy: "
	read server
	# branch validation
	echo $(git branch) > /tmp/codedeployer1 2>&1
	flag2=0
	while [[ flag2 -eq 0 ]]; do
		echo "Enter branch to deploy: "
		read branch
		if grep -wq "$branch" /tmp/codedeployer1 ; then
			flag2=1
			echo "Valid Branch entered: $branch"
			rm -f /tmp/codedeployer1
			break
		else
			flag2=0
			echo "Invalid branch entered"
		fi
	done
	echo "Branch entered: $branch"
	# creating temporary hosts file
	rm -f /tmp/hosts
	touch /tmp/hosts
	server_parameter='null'
	environment_server='null'
	queues='null'
	echo "Enter environemt type: "
	read environment_server
	if [[ "$environment_server" = consumer_node ]]; then
		echo "Enter queues for consumer node (periodic_tasks, sms_reminders, email_reminders, phonecall_reminders, billing, generic) Use commas for multiple queues: "
		read queues
	fi
	echo "Enter server type:"
	read server_parameter
	echo "Environment type entered : $environment_server"
	echo "Server type entered : $server_parameter"
	touch /tmp/hosts
	if [[ "$server_parameter" = testing ]]; then
		echo "TESTING"
		sed '7!d' $path_to_hosts/hosts > /tmp/hosts
		echo $server >> /tmp/hosts
	else
		if [[ "$server_parameter" = staging ]]; then
			echo "STAGING"
			sed '1!d' $path_to_hosts/hosts > /tmp/hosts
			echo $server >> /tmp/hosts
		fi
	else
		if [[ "$server_parameter" = production ]]; then
			echo "PRODUCTION"
			sed '4!d' $path_to_hosts/hosts > /tmp/hosts
			echo $server >> /tmp/hosts
		fi
	fi
	ansible-playbook -i /tmp/hosts $path_to_hosts/app.yml --tags deploy --extra-vars "branch=$branch environment_server=$environment_server server=$server_parameter queues=$queues"
	rm -f /tmp/hosts
fi
