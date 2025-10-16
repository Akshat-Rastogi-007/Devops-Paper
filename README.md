# Devops-Paper

# Sys_Manager.sh - Command Usage & Screenshots

## 1. Add Multiple Users

**Command:**
```
sudo ./sys_manager.sh add_users /home/rastogi/Desktop/names.txt
```

**Screenshot / Output:**


---

## 2. Setup Project Folders

**Command:**
```
./sys_manager.sh setup_projects rastogi 3
```

**Screenshot / Output:**

![Setup Projects Screenshot](YOUR_IMAGE_PATH_HERE)

---

## 3. System Report

**Command:**
```
./sys_manager.sh sys_report sysinfo.txt
```

**Screenshot / Output:**

![System Report Screenshot](YOUR_IMAGE_PATH_HERE)

---

## 4. Process Management

### a) List Zombie Processes

**Command:**
```
./sys_manager.sh process_manage rastogi list_zombies
```

**Screenshot / Output:**

![List Zombies Screenshot](YOUR_IMAGE_PATH_HERE)

### b) List Stopped Processes

**Command:**
```
./sys_manager.sh process_manage rastogi list_stopped
```

**Screenshot / Output:**

![List Stopped Screenshot](YOUR_IMAGE_PATH_HERE)

### c) Kill Zombie Processes (Warning)

**Command:**
```
./sys_manager.sh process_manage rastogi kill_zombies
```

**Screenshot / Output:**

![Kill Z
