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
	   echo -e "$prefix$i" >> tempData/monitors.txt
	done
	sed -i '18r tempData/monitors.txt' conf/prometheus.yml
	echo -e "\n\n"
	echo "Setting Prometheus Configuration"
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

	echo -e "\n\n"
	echo "Copying Prometheus binaries"

	cp prometheus-${prometheus_version}.linux-amd64/prometheus /usr/local/bin/

	cp prometheus-${prometheus_version}.linux-amd64/promtool /usr/local/bin/

	echo -e "\n\n"
	echo "Setting Prometheus permissions"

	chown prometheus:prometheus /usr/local/bin/prometheus

	chown prometheus:prometheus /usr/local/bin/promtool

	cp -r prometheus-${prometheus_version}.linux-amd64/consoles /etc/prometheus/

	cp -r prometheus-${prometheus_version}.linux-amd64/console_libraries /etc/prometheus/

	chown -R prometheus:prometheus /etc/prometheus/consoles

	chown -R prometheus:prometheus /etc/prometheus/console_libraries

	echo -e "\n\n"
	echo "Cleaning Prometheus left-over"

	rm -rf prometheus-${prometheus_version}.linux-amd64*

	echo -e "\n\n"
	echo "Installing Node Exporter in 3 seconds"
	sleep 3
	echo -e "\n"

	wget https://github.com/prometheus/node_exporter/releases/download/v${node_exporter_version}/node_exporter-${node_exporter_version}.linux-amd64.tar.gz 

	tar -xf node_exporter-${node_exporter_version}.linux-amd64.tar.gz
	echo -e "\n\n"
	echo "Setting Node Exporter binaries"
	cp node_exporter-${node_exporter_version}.linux-amd64/node_exporter /usr/local/bin

	echo -e "\n\n"
	echo "Setting Node Exporter permissions"

	chown node_exporter:node_exporter /usr/local/bin/node_exporter

	echo -e "\n\n"
	echo "Cleaning Node Exporter left-over"

	rm -rf node_exporter-${node_exporter_version}.linux-amd64*

	cp services/prometheus.service /etc/systemd/system/prometheus.service

	cp services/node_exporter.service  /etc/systemd/system/node_exporter.service
	
	echo -e "\n\n"
	echo "Installing BlackBox Monitor in 3 seconds"
	sleep 3
	echo -e "\n"
	
	wget https://github.com/prometheus/blackbox_exporter/releases/download/v${blackbox_exporter_version}/blackbox_exporter-${blackbox_exporter_version}.linux-amd64.tar.gz
	
	echo -e "\n\n"
	echo "Setting BlackBox Exporter binaries"

	tar -xvf blackbox_exporter-${blackbox_exporter_version}.linux-amd64.tar.gz
	
	cp blackbox_exporter-${blackbox_exporter_version}.linux-amd64/blackbox_exporter /usr/local/bin/blackbox_exporter
	echo -e "\n\n"
	echo "Setting BlackBox Exporter permissions"
	chown blackbox_exporter:blackbox_exporter /usr/local/bin/blackbox_exporter
	
	rm -rf blackbox_exporter-${blackbox_exporter_version}.linux-amd64*
	
	mkdir /etc/blackbox_exporter
	
	cp services/blackbox.yml /etc/blackbox_exporter/blackbox.yml
	
	chown blackbox_exporter:blackbox_exporter /etc/blackbox_exporter/blackbox.yml
	
	cp blackbox_exporter.service /etc/systemd/system/blackbox_exporter.service
	cp conf/prometheus.yml  /etc/prometheus/prometheus.yml

	echo -e "\n\n"
	echo "Finalizing system services"

	systemctl daemon-reload
	sleep 2
	systemctl enable prometheus
	systemctl enable node_exporter	
	systemctl enable blackbox_exporter
	sleep 2

	echo -e "\n\n"
	echo "Starting all services..."

	systemctl start node_exporter
	systemctl start blackbox_exporter
	systemctl restart prometheus
	sleep 2

	echo -e "\n\n"
	echo "Finishing installation in few moments..."
	sleep 1
	truncate -s 0 tempData/monitors.txt
	sleep 1
	echo -e "\n\n"
	echo "DONE"
	echo -e "\n"
  else
     echo "Enter value is not an integer or not defined"
  fi

