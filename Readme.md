# 🖥️ Windows Health Check (PowerShell)

A beginner-friendly PowerShell script that performs a quick Windows health check and generates a text report.

This project demonstrates practical PowerShell scripting skills used by IT Support and System Administrators for gathering system information and basic health diagnostics.

---

## ✨ Features

* System Information
* CPU Information
* Memory Usage
* Disk Health Check
* Network Information
* Internet Connectivity Test
* Installed Software Inventory
* Health Score (0–100)
* Export Report to a Timestamped TXT File

---

## 📁 Project Structure

```text
windows-health-check/
│
├── HealthCheck.ps1
├── README.md
├── LICENSE
└── reports/
```

---

## 📋 Requirements

* Windows 10 or Windows 11
* Windows PowerShell 5.1 or PowerShell 7+
* No additional modules required

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-username/windows-health-check.git
```

### 2. Open PowerShell

Navigate to the project folder.

```powershell
cd windows-health-check
```

### 3. Allow script execution (current session only)

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

### 4. Run the script

```powershell
.\HealthCheck.ps1
```

---

## 📄 Sample Output

```text
==============================================
        WINDOWS HEALTH CHECK REPORT
==============================================

Computer Name : DESKTOP-R015HOG
Current User  : *****
Operating System : Microsoft Windows 10 Pro
OS Version    : 10.0.19045

CPU INFORMATION
-----------------------------
Processor     : Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
CPU Usage     : 28%
Cores         : 4
Logical CPU   : 8

MEMORY INFORMATION
-----------------------------
Total Memory  : 5.91 GB
Used Memory   : 4.98 GB
Free Memory   : 0.93 GB
Usage         : 84%

DISK INFORMATION
-----------------------------
Drive         : C:
Label         : 
Total Space   : 231.82 GB
Used Space    : 81.43 GB
Free Space    : 150.39 GB
Free Percent  : 65%
Status        : Healthy

NETWORK INFORMATION
-----------------------------
Adapter       : Ethernet
IPv4 Address  : **.***.**.***
Gateway       : **.***.**.***
DNS Servers   : 8.8.8.8, 8.8.4.4
MAC Address   : **-**-**-**-**-**
Internet      : Connected

INSTALLED SOFTWARE
-----------------------------
Cisco Packet Tracer 8.2.1 64Bit (8.2.1.118)
Cisco Packet Tracer 9.0.0 64Bit (9.0.0.810)
Copilot (150.0.4078.65)
Google Chrome (150.0.7871.129)
Intel(R) Processor Graphics (20.19.15.4835)
Maxx Audio Installer (x64) (2.6.6448.1)
Microsoft Edge (150.0.4078.83)
Microsoft Edge WebView2 Runtime (150.0.4078.83)
Microsoft Office Professional Plus 2016 - en-us (16.0.19127.20302)
Microsoft OneDrive (26.113.0614.0004)
Microsoft Update Health Tools (3.74.0.0)
Mozilla Firefox (x64 en-US) (152.0.6)
Mozilla Maintenance Service (133.0.3)
Office 16 Click-to-Run Extensibility Component (16.0.19127.20154)
Office 16 Click-to-Run Licensing Component (16.0.19029.20208)
Python 3.13.14 Core Interpreter (64-bit) (3.13.14150.0)
Python 3.13.14 Development Libraries (64-bit) (3.13.14150.0)
Python 3.13.14 Documentation (64-bit) (3.13.14150.0)
Python 3.13.14 Executables (64-bit) (3.13.14150.0)
Python 3.13.14 pip Bootstrap (64-bit) (3.13.14150.0)
Python 3.13.14 Standard Library (64-bit) (3.13.14150.0)
Python 3.13.14 Tcl/Tk Support (64-bit) (3.13.14150.0)
Python 3.13.14 Test Suite (64-bit) (3.13.14150.0)
Python Launcher (3.13.14150.0)
Realtek High Definition Audio Driver (6.0.1.6086)
Update for x64-based Windows Systems (KB5001716) (8.94.0.0)

Total Installed Applications : 26

OVERALL HEALTH
-----------------------------
Health Score : 75 / 100
Status       : Good
```

---

## 📂 Report Export

After each run, the script automatically saves a report inside the **reports** folder.

Example:

```text
reports/
└── HealthReport_2026-07-21_143522.txt
```

---

## 🎯 Learning Objectives

This project helps you practice:

* PowerShell Functions
* Working with CIM/WMI
* Collecting Windows system information
* PowerShell objects (`PSCustomObject`)
* Arrays and loops
* Conditional logic
* File and folder management
* Report generation


---

## 🤝 Contributing

Contributions, bug reports, and suggestions are welcome. Feel free to open an issue or submit a pull request.

---

## 📄 License

This project is licensed under the MIT License.

---

⭐ If you found this project helpful, consider giving it a star on GitHub.
