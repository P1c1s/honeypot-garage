

<p align="center">
  <img src="https://raw.githubusercontent.com/pi-hole/graphics/refs/heads/master/Vortex/vortex_with_text.svg" alt="Pi-hole website" width="168" height="270">
  <br>
  <strong>Network-wide ad blocking via your own Linux hardware</strong>
</p>


<!-- markdownlint-configure-file { "MD004": { "style": "consistent" } } -->
<!-- markdownlint-disable MD033 -->
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Badge Esempio</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center; /* Centra i badge verticalmente */
            margin: 0;
            padding: 20px;
            background-color: #f2f2f2; /* Sfondo leggero per contrasto */
        }
        .badge-container {
            display: flex;
            justify-content: center; /* Centra i badge orizzontalmente */
            gap: 10px; 
        }
        .badge {
            display: flex;
            align-items: center;
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 100px;
            background-color: #f9f9f9;
        }
        .badge img {
            border-radius: 50%;
            width: 15px; /* Dimensione dell'immagine */
            height: 15px;
            margin-right: 4px;
        }
        .badge .name {
            font-size: 14px; /* Dimensione del font per il nome */
            font-weight: bold;
            text-decoration: none; /* Rimuovi il sottolineato dal link */
            color: #333; /* Colore del testo */
        }
        p {
            text-align: center; /* Allinea il testo al centro */
        }
    </style>
</head>
<body>
    <p>
        <img src="src/logo.png" alt="Pi-hole logo" width="300" height="300">
        <br>
        <strong style="color: yellow">Beeware</strong>
        <br>
        <span style="font-size: 14px; color: gray;">Capture and analyze malicious traffic effectively...</span>
    </p>
    <div class="badge-container">
        <div class="badge">
            <img src="https://github.com/p1c1s.png" alt="Foto">
            <a class="name" href="https://github.com/p1c1s">p1c1s</a>
        </div>
        <div class="badge">
            <img src="https://github.com/sicmic.png" alt="Foto">
            <a class="name" href="https://github.com/sicmic">sicmic</a>
        </div>
    </div>
</body>
</html>

# Honeypot Deployment Documentation

## Table of Contents
1. [Introduction](#1-introduction)
2. [Network Architecture](#2-network-architecture)
   - [2.1 Routing Tables](#21-routing-tables)
   - [2.2 Network and Subnets](#22-network-and-subnets)
3. [Services Overview](#3-services-overview)
   - [3.1 LAN A](#31-lan-a)
   - [3.2 LAN B](#32-lan-b)
   - [3.3 LAN C](#33-lan-c)
4. [How to use it](#)
---

## 1. Introduction

This document outlines the implementation of a honeypot system.

A **honeypot** is a computing resource intentionally designed to **attract and deceive cyber attackers** by simulating system vulnerabilities or exposing seemingly sensitive data. Its main objective is to **monitor and analyze attack techniques**, gathering valuable intelligence to improve overall security strategies.

Honeypots are powerful tools for **studying malicious behavior** and developing more effective defense mechanisms.  

To simulate a realistic corporate environment, a **network architecture** was designed for a fictional company called **"The Boys"** — a young, dynamic IT firm specializing in tailor-made digital solutions for both businesses and individuals.

To ensure **greater scalability** and **zero deployment costs**, the entire infrastructure is **fully simulated** using the advanced emulation tool [Kathará](https://www.kathara.org).


---

## 2. Network Architecture

The honeypot environment is entirely **IPv6-based**, reflecting modern network standards and challenges. The IT infrastructure of *The Boys* features a **robust and scalable architecture**, designed to support both the production and distribution of digital content efficiently.

### 2.1 Routing Tables

Custom routing tables are configured within the routers to manage traffic across the segmented network. These tables define the paths packets should follow to reach specific subnets, ensuring efficient communication between internal services and network zones.

### 2.2 Network and Subnets

The network is divided into multiple **Local Area Networks (LANs)**, each with a specific functional role. Below is an overview of the main LANs and their representation in the topological schema.

IPv6 addressing has been planned using the base prefix: `2a04::/56`, which is then split into two main subnet groups through **subnetting**.

- The **first macro subnet** is dedicated to servers and hosts critical services such as DNS, web servers, and more.  
  This subnet is further divided to allow for future scalability, yielding **16 subnets** in total.  
  The applied subnetting is: `2a04:0:0:0::/60` → `2a04:0:0:f::/60`  
  Currently, only three networks have been implemented:
  - **LAN A**
  - **LAN B**
  - **LAN C**

- The **second macro subnet** is reserved for employee workstations.  
  It is partitioned into a large number of subnets (**up to 240 LANs**) to support potential large-scale deployments.  
  The applied subnetting is: `2a04:0:0:10::/60` → `2a04:0:0:ff::/60`  
  As of now, the following networks are active:
  - **LAN S**
  - **LAN D**
  - **LAN O**

![Network Architecture](network.drawio.png)

---

## 3. Services Overview

The following services are deployed within the simulated infrastructure to represent typical enterprise systems. They are distributed across three internal networks (LANs):

### 3.1 LAN A
- **bind1**: DNS server for internal name resolution and service discovery.  
- **rsyslog**: Centralized logging system for auditing and monitoring.  
- **oldap**: Directory service providing centralized authentication and user management.

### 3.2 LAN B
- **wsa1**: Apache web server hosting internal web content.  
- **mdb**: MariaDB relational database for storing application and system data.  
- **smb**: Samba server offering Windows-compatible file and printer sharing.

### 3.3 LAN C
- **wsa2**: Apache web server serving public-facing websites and web applications.  
- **wsn**: Nginx server acting as a reverse proxy or lightweight web server.  
- **bind2**: Secondary DNS server for redundancy and additional resolution support.  
- **ovpn**: OpenVPN server providing secure remote access to the internal network.


### 4. How to use it

1. Run `./pull-images.sh` to download and install the necessary Docker images.

2. Run `./launcher.sh` to start the lab environment. Thi script create all the containers

> **Note:**  
> To run and simulate the entire honeypot infrastructure described in this document, it is **necessary to have Docker and Katahrá installed** on your system.
> * Docker enables containerization and management of all services in an isolated and scalable environment. You can download Docker here: [https://www.docker.com/get-started](https://www.docker.com/get-started).
> * Katahrá ... You can download Katahrá here: ([https://www.kathara.org](https://www.kathara.org)).


