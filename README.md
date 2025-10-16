# Devops-Paper

# Sys_Manager.sh - Command Usage & Screenshots

## 1. Add Multiple Users

**Command:**
```
sudo ./sys_manager.sh add_users /home/rastogi/Desktop/names.txt
```

**Screenshot / Output:**

![UserAdd Screenshot](image/userCreation.png)

---

## 2. Setup Project Folders

**Command:**

```
./sys_manager.sh setup_projects rastogi 3
```

**Screenshot / Output:**

![Folder](image/project.png)
![Folder](image/sub_project.png)
![Folder](image/readme_file.png)
![Folder](image/project_command.png)

---

## 3. System Report

**Command:**
```
./sys_manager.sh sys_report rastogi /home/rastogi/outputfile.txt
```

**Screenshot / Output:**

![System Report Screenshot](sys_report_file.png)

---

## 4. Process Management

### a) List Zombie Processes

**Command:**
```
./sys_manager.sh process_manage rastogi list_zombies
```

**Screenshot / Output:**

![List Zombies Screenshot](image/list_zombies.png)

### b) List Stopped Processes

**Command:**
```
./sys_manager.sh process_manage rastogi list_stopped
```

**Screenshot / Output:**

![List Stopped Screenshot](image/list_stopped.png)

### c) Kill Zombie Processes (Warning)

**Command:**
```
./sys_manager.sh process_manage rastogi kill_zombies
```

**Screenshot / Output:**

![Kill Zombies Screenshot](image/kill_zombies.png)


### d) Kill Stopped Processes


**Command:**
```
./sys_manager.sh process_manage rastogi kill_stopped
```


**Screenshot / Output:**


![Kill Stopped Screenshot](image/screenshot.png)


---


## 5. Permission & Ownership Manager


**Command:**
```
./sys_manager.sh perm_owner rastogi /home/rastogi/projects 755 rastogi rastogi
```


**Screenshot / Output:**


![Permission & Ownership Screenshot](image/perm_owner.png)


---
## 6. Help Menu


**Command:**
```
./sys_manager.sh help
```


**Screenshot / Output:**


![Help Menu Screenshot](image/help_menu.png)


---
