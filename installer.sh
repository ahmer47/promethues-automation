#!/bin/bash

prometheus_version="2.53.0"
blackbox_exporter_version="0.25.0"
node_exporter_version="1.8.1"
monitor_count=0
count=1
Monitor_Final=""
prefix=$"        - "
postfix=$"\n"
declare -a monitor_names
echo "How many http monitors you want to install? (1-100)"
read monitor_count
  if [[ $monitor_count ]] && [ $monitor_count -eq $monitor_count 2>/dev/null ]
  then
	for(( c = 0 ; c < $monitor_count ; c++))
	do
		echo "Enter Monitor Value no $((c + count))"
	  read monitor_value
	#  while read monitor_value
	#  do
	  monitor_names[$c]="$monitor_value"
	#  done
	done
	#echo "${#monitor_names[@]}"
	for i in "${monitor_names[@]}"
	do
	   : 
	   echo -e "$prefix$i" >> monitors.txt
	done
	sed -i '18r monitors.txt' finalprom
	echo -e "\n\n"
	echo "Setting Prometheus permissions"
	sleep 3
	echo -e "\n"

	useradd --no-create-home --shell /bin/false prometheus

	useradd --no-create-home --shell /bin/false node_exporter
	
	useradd --no-create-home --shell /bin/false blackbox_exporter

	echo "Creating Prometheus Directories"

	mkdir /etc/prometheus

	mkdir /var/lib/prometheus

	chown prometheus:prometheus /etc/prometheus

	chown prometheus:prometheus /var/lib/prometheus

	apt update

	echo -e "\n\n"
	echo "Install Prometheus in 3 seconds"
	sleep 3
	echo -e "\n"

	wget "https://github.com/prometheus/prometheus/releases/download/v${prometheus_version}/prometheus-${prometheus_version}.linux-amd64.tar.gz"
	
	tar -xf prometheus-${prometheus_version}.linux-amd64.tar.gz

	cp prometheus-${prometheus_version}.linux-amd64/prometheus /usr/local/bin/

	cp prometheus-${prometheus_version}.linux-amd64/promtool /usr/local/bin/

	chown prometheus:prometheus /usr/local/bin/prometheus

	chown prometheus:prometheus /usr/local/bin/promtool

	cp -r prometheus-${prometheus_version}.linux-amd64/consoles /etc/prometheus/

	cp -r prometheus-${prometheus_version}.linux-amd64/console_libraries /etc/prometheus/

	chown -R prometheus:prometheus /etc/prometheus/consoles

	chown -R prometheus:prometheus /etc/prometheus/console_libraries

	rm -rf prometheus-${prometheus_version}.linux-amd64*

	echo -e "\n\n"
	echo "Installing Node Exporter in 3 seconds"
	sleep 3
	echo -e "\n"

#	wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
	wget https://github.com/prometheus/node_exporter/releases/download/v${node_exporter_version}/node_exporter-${node_exporter_version}.linux-amd64.tar.gz 

	tar -xf node_exporter-${node_exporter_version}.linux-amd64.tar.gz

	cp node_exporter-${node_exporter_version}.linux-amd64/node_exporter /usr/local/bin

	chown node_exporter:node_exporter /usr/local/bin/node_exporter

	rm -rf node_exporter-${node_exporter_version}.linux-amd64*

	cp prometheus.service /etc/systemd/system/prometheus.service

	cp node_exporter.service  /etc/systemd/system/node_exporter.service
	
	echo -e "\n\n"
	echo "Installing BlackBox Monitor in 3 seconds"
	sleep 3
	echo -e "\n"
	
#	wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-amd64.tar.gz
	wget https://github.com/prometheus/blackbox_exporter/releases/download/v${blackbox_exporter_version}/blackbox_exporter-${blackbox_exporter_version}.linux-amd64.tar.gz
	tar -xvf blackbox_exporter-${blackbox_exporter_version}.linux-amd64.tar.gz
	
	cp blackbox_exporter-${blackbox_exporter_version}.linux-amd64/blackbox_exporter /usr/local/bin/blackbox_exporter
	
	chown blackbox_exporter:blackbox_exporter /usr/local/bin/blackbox_exporter
	
	rm -rf blackbox_exporter-${blackbox_exporter_version}.linux-amd64*
	
	mkdir /etc/blackbox_exporter
	
	cp blackbox.yml /etc/blackbox_exporter/blackbox.yml
	
	chown blackbox_exporter:blackbox_exporter /etc/blackbox_exporter/blackbox.yml
	
	cp blackbox_exporter.service /etc/systemd/system/blackbox_exporter.service
	
	systemctl daemon-reload
	sleep 2
	#systemctl start blackbox_exporter
	#sleep 2
	#systemctl enable blackbox_exporter
	#sleep 2
	
	cp finalprom  /etc/prometheus/prometheus.yml

	sleep 2
	systemctl start node_exporter
	sleep 2
	#systemctl start prometheus
	sleep 2
	systemctl enable prometheus
	#sleep 2
	systemctl enable node_exporter
	#sleep 2
	#systemctl restart prometheus
	sleep 2
	echo -e "\n\n"
	echo "Finishing installation in few moments"
	sleep 1
	truncate -s 0 monitors.txt
	sleep 1
	# cp finalprom-Backup finalprom
	echo -e "\n\n"
	echo "DONE"
	echo -e "\n"
  else
     echo "Enter value is not an integer or not defined"
  fi

