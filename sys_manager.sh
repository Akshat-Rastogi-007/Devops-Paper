#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

add_users(){
	
	file=$1

	if [ -z "$file" ]; then
		echo -e "${RED}ERROR: $0:${NC} Kindly give non-empty argunments."
		exit 1
	fi

	if [ ! -f "$file" ]; then
		echo -e "${RED}ERROR: $0:${NC} $file not found."
		exit 1
	fi

	echo "=== User Creation ==="
	
	while read username; do
	
		if [ -z "$username" ]; then
			continue
		fi

	    	if id "$username" &>/dev/null; then
        		echo -e "${YELLOW}$username : Already Exists${NC}"
    		else
        		useradd -m "$username"
        		echo -e "${GREEN}$username : Created${NC}"
    		fi

	done < "$file"

	echo -e "${BLUE}=== Process Complete ===${NC}"

}

setup_projects(){


	username=$1
	numberOfProjects=$2
	
	if [ -z "$username" ] || [ -z "$numberOfProjects" ]; then

		echo -e "${RED}ERROR: $0:${NC} Kindly give non-empty argunments."
                exit 1
	
	fi

	if ! id "$username" &>/dev/null; then
        	echo -e "${RED}Error:${NC} User '$username' does not exist."
        	exit 1
    	fi

	base_dir="/home/$username/projects"
    	mkdir -p "$base_dir"
	
	for ((i = 1; i <= numberOfProjects; i++)); do
		projectDir="$base_dir/project$i"
		mkdir -p "$projectDir"

		echo "Project: project $i" >> "$projectDir/readme.txt"
		echo "Created By: $username" >> "$projectDir/readme.txt"
		echo "Creation Date: $(date)" >> "$projectDir/readme.txt"

		chown -R "$usename":"$username" "$projectDir"
		chmod 755 "$projectDir"
		chmod 640 "$projectDir/readme.txt"


        	echo -e "${GREEN}Created:${NC} $project_dir ${YELLOW}(with README.txt)${NC}"
    	done


    	echo -e "${BLUE}=== Project Setup Complete for $username ===${NC}"


}

sys_report(){
	
	output_file=$1

	if [ -z "$output_file" ]; then
        	echo -e "${RED}ERROR: $0:${NC} Kindly give non-empty argunments."
        	exit 1
    	fi

	echo -e "${BLUE}=== Generating System Report ===${NC}"
    	echo "Report generated on: $(date)" | tee "$output_file"
    	echo "====================================" | tee -a "$output_file"

	echo -e "${YELLOW}-- Disk Usage --${NC}" | tee -a "$output_file"
    	df -h | tee -a "$output_file"

	echo -e "${YELLOW}\n-- Memory Info --${NC}" | tee -a "$output_file"
    	free -h | tee -a "$output_file"

	echo -e "${YELLOW}\n-- CPU Info --${NC}" | tee -a "$output_file"
    	lscpu | tee -a "$output_file"

	echo -e "${YELLOW}\n-- Top 5 Memory-consuming Processes --${NC}" | tee -a "$output_file"
    	ps aux --sort=-%mem | head -n 6 | tee -a "$output_file"

	echo -e "${YELLOW}\n-- Top 5 CPU-consuming Processes --${NC}" | tee -a "$output_file"
    	ps aux --sort=-%cpu | head -n 6 | tee -a "$output_file"

	echo -e "${BLUE}=== Report Generation Complete ===${NC}"
}

process_manage(){

	username=$1
    	action=$2

	if [ -z "$username" ] || [ -z "$action" ];then
		echo -e "${RED}ERROR: $0:${NC} Kindly give non-empty argunments."
		exit 1
	fi

	if ! id "$username" &>/dev/null; then
        	echo -e "${RED}Error:${NC} User '$username' does not exist."
        	exit 1
    	fi
	
	echo -e "${BLUE}=== Process Management for $username ===${NC}"

	case "$action" in
        	list_zombies)
            		echo -e "${YELLOW}Zombie Processes:${NC}"
            		ps -u "$username" -o pid,ppid,state,cmd | awk '$3=="Z" {print}'
            		;;
		list_stopped)
            		echo -e "${YELLOW}Stopped Processes:${NC}"
            		ps -u "$username" -o pid,ppid,state,cmd | awk '$3=="T" {print}'
            		;;
		kill_zombies)
            		echo -e "${RED}Warning:${NC} Zombie processes cannot be killed directly."
            		echo "You must kill their parent processes or reboot."
            		ps -u "$username" -o pid,ppid,state,cmd | awk '$3=="Z" {print}'
            		;;
		  kill_stopped)
            		echo -e "${RED}Killing Stopped Processes for $username...${NC}"
            		stopped_pids=$(ps -u "$username" -o pid= -o state= | awk '$2=="T"{print $1}')
            		if [ -z "$stopped_pids" ]; then
                		echo -e "${GREEN}No stopped processes found.${NC}"
            		else
                		echo "$stopped_pids" | xargs kill -9
                		echo -e "${GREEN}Killed stopped processes:${NC} $stopped_pids"
            		fi
            		;;

        	*)
			echo -e "${RED}Error:${NC} Invalid action '$action'."
			;;
	esac

	echo -e "${BLUE}=== Process Management Complete ===${NC}"
}

perm_owner(){

	username=$1
	path=$2
    	permissions=$3
    	owner=$4
    	group=$5

	
	if [ -z "$username" ] || [ -z "$path" ] || [ -z "$permissions" ] || [ -z "$owner" ] || [ -z "$group" ]; then
		echo -e "${RED}ERROR: $0:${NC} Kindly give non-empty argunments."
                exit 1
	fi

	if ! id "$username" &>/dev/null; then
        	echo -e "${RED}Error:${NC} User '$username' does not exist."
        	exit 1
    	fi

	if [ ! -e "$path" ]; then
        	echo -e "${RED}Error:${NC} Path '$path' does not exist."
        	exit 1
    	fi

	echo -e "${BLUE}=== Permission & Ownership Update for $username ===${NC}"

	if chown -R "$owner":"$group" "$path"; then
        	echo -e "${GREEN}Ownership set to $owner:$group for $path${NC}"
    	else
        	echo -e "${RED}Failed to set ownership for $path${NC}"
    	fi

    	if chmod -R "$permissions" "$path"; then
        	echo -e "${GREEN}Permissions set to $permissions for $path${NC}"
    	else
        	echo -e "${RED}Failed to set permissions for $path${NC}"
    	fi

	ls -l "$path" | head -n 5

	echo -e "${BLUE}=== Permission & Ownership Update Complete ===${NC}"

}

help_menu(){

	echo -e "${YELLOW}1. Add Multiple Users${NC}"
    	echo -e "Mode: add_users"
    	echo -e "Usage: ./sys_manager.sh add_users <usernames_file>"
    	echo -e "  • Reads usernames from file (one per line)"
    	echo -e "  • Creates users if they do not exist"
    	echo -e "  • Sets up home directory"
    	echo -e "  • Outputs summary (Created / Already Exists)"
    	echo -e "Example:"
    	echo -e "  ./sys_manager.sh add_users users.txt\n"

    	echo -e "${YELLOW}2. Setup Project Folders${NC}"
    	echo -e "Mode: setup_projects"
    	echo -e "Usage: ./sys_manager.sh setup_projects <username> <number_of_projects>"
    	echo -e "  • Creates /home/<username>/projects"
    	echo -e "  • Creates project1, project2, ..."
    	echo -e "  • Adds README.txt with creation date & user info"
    	echo -e "  • Sets ownership & permissions (Dirs: 755, Files: 640)"
    	echo -e "Example:"
    	echo -e "  ./sys_manager.sh setup_projects akshat 3\n"

    	echo -e "${YELLOW}3. System Report${NC}"
    	echo -e "Mode: sys_report"
    	echo -e "Usage: ./sys_manager.sh sys_report <output_file>"
    	echo -e "  • Saves system info: Disk, Memory, CPU"
    	echo -e "  • Shows top 5 memory- & CPU-consuming processes"
    	echo -e "Example:"
    	echo -e "  ./sys_manager.sh sys_report sysinfo.txt\n"

    	echo -e "${YELLOW}4. Process Management${NC}"
    	echo -e "Mode: process_manage"
    	echo -e "Usage: ./sys_manager.sh process_manage <username> <action>"
    	echo -e "  Actions:"
    	echo -e "    • list_zombies   → Lists zombie processes"
    	echo -e "    • list_stopped   → Lists stopped processes"
    	echo -e "    • kill_zombies   → Prints warning (cannot kill directly)"
    	echo -e "    • kill_stopped   → Kills stopped processes"
    	echo -e "Examples:"
    	echo -e "  ./sys_manager.sh process_manage akshat list_zombies"
    	echo -e "  ./sys_manager.sh process_manage akshat kill_stopped\n"

    	echo -e "${YELLOW}5. Permission & Ownership Manager${NC}"
    	echo -e "Mode: perm_owner"
    	echo -e "Usage: ./sys_manager.sh perm_owner <username> <path> <permissions> <owner> <group>"
    	echo -e "  • Recursively changes file/folder permissions & ownership"
    	echo -e "  • Verifies and reports result"
    	echo -e "Example:"
    	echo -e "  sudo ./sys_manager.sh perm_owner akshat /home/akshat/projects 755 akshat akshat\n"

    	echo -e "${YELLOW}6. Help Menu${NC}"
    	echo -e "Mode: help"
    	echo -e "Usage: ./sys_manager.sh help"
    	echo -e "  • Prints this formatted usage menu with examples"
    	echo -e "Example:"
    	echo -e "  ./sys_manager.sh help\n"

}

mode=$1
case "$mode" in

	add_users)
		add_users "$2";
		;;
	setup_projects)
		setup_projects "$2" "$3";
		;;
	sys_report)
		sys_report "$2";
		;;
	process_manage)
		process_manage "$2" "$3"
		;;
	perm_owner)
		perm_owner "$2" "$3" "$4" "$5" "$6"
		;;
	help)
		help_menu
        	;;
	*)
		echo -e "${RED}Error:${NC} Invalid mode '$mode'."
		echo -e "Use './sys_manager.sh help' to see available modes."
        	;;
esac


