# Promethues-automation
This repository contains bash script for Easy Install onto Ubuntu OS below


Ubuntu 16 | Ubuntu 18 | Ubuntu 18 | Ubuntu 20 | Ubuntu 22 | Ubuntu 24
:------------ | :-------------| :-------------| :-------------| :-------------| :-------------
Tested | ✅	 |  ✅	 | ✅	 | ✅	| ❌

# Monitor setup
The program will input number of Monitors you need to setup on Prometheus as config below

```
static_configs:
      - targets:
```

Enter the number and then target IRL's for monitors

# Run Setup
```
./installer.sh
```

# Installed Packages
The script will install, Configure & Start the Prometheus, Node Exporter & Blackbox Exporter with linux system services enabled.

# Node Exporter
Set up and configured Node Exporter to collect Linux system metrics like CPU load and disk I/O

# BlackBox Exporter
The blackbox exporter allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC.
