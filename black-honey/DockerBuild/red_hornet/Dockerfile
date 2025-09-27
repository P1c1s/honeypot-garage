FROM theb0ys/base:latest

# Install necessary packages
RUN apt update && \
    apt install -y \
        sudo \
        dsniff \
        hping3 \
        hydra \
        john \
        nmap \
        unzip && \
        apt clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install Metasploit Framework
RUN curl -o msfinstall https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb && \
    chmod 755 msfinstall && \
    ./msfinstall && \
    rm msfinstall

# Add new user
# RUN useradd -m -s /bin/bash red-hornet && \
#     echo "red-hornet:password" | chpasswd && \
#     usermod -aG sudo red-hornet

# Set the shell prompt to red
RUN echo "PS1='\[\e[01;31m\][\u@\h \W]\$\[\e[00m\] '" >> /root/.bashrc

# Copy rockyou.txt.zip and usernames.txt.zip to the container
COPY rockyou.txt.zip /root/
COPY usernames.txt.zip /root/

# Extract the rockyou.txt file
RUN unzip /root/rockyou.txt.zip -d /root && \
    rm /root/rockyou.txt.zip  

# Extract the usernames.txt file
RUN unzip /root/usernames.txt.zip  -d /root && \
    rm /root/usernames.txt.zip  

# Copy the red_hornet.sh script to the container
COPY red_hornet.sh /root/.red_hornet.sh

# Make the script executable
RUN chmod +x /root/.red_hornet.sh

# Append the script to .bashrc to run on login
RUN cat /root/.red_hornet.sh >> /root/.bashrc