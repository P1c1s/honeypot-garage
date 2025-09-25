FROM theb0ys/base:latest

# Install hping3 and other dependencies
RUN apt-get update && \
    apt-get install -y hping3 curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install Metasploit Framework
RUN curl -o msfinstall https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb && \
    chmod 755 msfinstall && \
    ./msfinstall && \
    rm msfinstall

# Set the shell prompt to red
RUN echo "PS1='\[\e[01;31m\][\u@\h \W]\$\[\e[00m\] '" >> /root/.bashrc


# Start a bash shell by default
CMD ["/bin/bash"]
