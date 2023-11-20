#!/bin/bash

# Define working directory
WORK_DIR="/home/opc/expense_report"
VENV_PATH="/home/opc/expense_report/venv"
SYSTEMD_SERVICE_FILE="/etc/systemd/system/expense-report-webapp.service"

# Update package manager
sudo yum update -y && echo "Package manager updated successfully"

# Install Git, Python 3.8, and Python 3.8 Development package
sudo yum install git python38 python38-devel -y && echo "Git and Python 3.8 installed successfully"

# Navigate to opc's home directory
cd /home/opc/ && echo "Navigated to /home/opc"

# Clone the Expense Report Webapp repository
git clone https://github.com/tsmith4014/expense_report.git && echo "Repository cloned successfully"

# Navigate to the cloned repository
cd $WORK_DIR && echo "Navigated to $WORK_DIR"

# Install Python-Pip
sudo yum install python3-pip -y && echo "Python-Pip installed successfully"

# Edit requirements.txt to include gunicorn
echo "gunicorn" >> requirements.txt && echo "Added gunicorn to requirements.txt"

# Create a Python virtual environment using Python 3.8
python3.8 -m venv venv && echo "Python virtual environment created successfully"

# Activate the virtual environment
source $VENV_PATH/bin/activate && echo "Virtual environment activated"

# Install Python dependencies
pip install -r requirements.txt && echo "Python dependencies installed successfully"

# Create Gunicorn config file
echo "bind = '0.0.0.0:8000'
workers = 4" > gunicorn_config.py && echo "Gunicorn config file created successfully"

# Create systemd service file
sudo bash -c "cat > $SYSTEMD_SERVICE_FILE" << EOF
[Unit]
Description=Gunicorn instance to serve expense-report-webapp
Wants=network.target
After=syslog.target network-online.target

[Service]
Type=simple
User=opc
Group=opc
WorkingDirectory=$WORK_DIR
Environment="PATH=$VENV_PATH/bin"
ExecStart=$VENV_PATH/bin/gunicorn -w 4 -b 0.0.0.0:8000 app:app
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "Systemd service file created successfully"

# Reload systemd daemon
sudo systemctl daemon-reload && echo "Systemd daemon reloaded successfully"

# Enable the service
sudo systemctl enable expense-report-webapp.service && echo "Service enabled successfully"

# Start the service
sudo systemctl start expense-report-webapp.service && echo "Service started successfully"

# Check the service status
systemctl status expense-report-webapp.service








# # Define working directory
# WORK_DIR="/home/opc/expense_report"  # Corrected the directory name
# VENV_PATH="/home/opc/expense_report/venv"
# SYSTEMD_SERVICE_FILE="/etc/systemd/system/expense-report-webapp.service"

# # Update package manager
# yum update -y

# # Install Git and Python3
# yum install git python3 -y

# # Navigate to opc's home directory
# cd /home/opc/

# # Clone the Expense Report Webapp repository
# git clone https://github.com/tsmith4014/expense_report.git

# # Navigate to the cloned repository
# cd $WORK_DIR

# # Install Python-Pip
# yum install python3-pip -y

# # Edit requirements.txt to include gunicorn
# echo "gunicorn" >> requirements.txt

# # Create a Python virtual environment
# python3 -m venv venv

# # Activate the virtual environment
# source $VENV_PATH/bin/activate

# # Install Python dependencies
# pip install -r requirements.txt

# # Create Gunicorn config file
# echo "bind = '0.0.0.0:8000'
# workers = 4" > gunicorn_config.py

# # Create systemd service file
# echo "[Unit]
# Description=Gunicorn instance to serve expense-report-webapp
# Wants=network.target
# After=syslog.target network-online.target

# [Service]
# Type=simple
# WorkingDirectory=$WORK_DIR
# Environment=\"PATH=$VENV_PATH/bin\"
# ExecStart=$VENV_PATH/bin/gunicorn -w 4 -b 0.0.0.0:8000 app:app
# Restart=always
# RestartSec=10

# [Install]
# WantedBy=multi-user.target" > $SYSTEMD_SERVICE_FILE

# # Reload systemd daemon
# systemctl daemon-reload

# # Enable the service
# systemctl enable expense-report-webapp.service

# # Start the service
# systemctl start expense-report-webapp.service

# # Check the service status
# systemctl status expense-report-webapp.service

