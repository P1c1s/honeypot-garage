# Honeypot

## Indice
1. [Introduzione](#1-introduzione)
   i. [Topologia della rete](#1.1-topologia-della-rete)
   ii. [Spazio dei nomi](#1.2-spazio-dei-nomi)
   iii. [Lan]
    1. [Lan A]
    2. [Lan B]
    3. [Lan C]
    4. [Lan D]
    5. [Lan E]
    6. [Lan FX]
    7. [Lan I]
    8. [Lan S]
2. [Interfacce del Router](#2-interfacce-del-router)
   - [Interfaccia: eth0 (LAN 1)](#interfaccia-eth0-lan-1)
   - [Interfaccia: eth1 (LAN 2)](#interfaccia-eth1-lan-2)
   - [Interfaccia: eth2 (LAN 3)](#interfaccia-eth2-lan-3)
4. [Firewall](#4-firewall)
5. [Accounts](#5-accounts)

## 1. Introduzione
Questo documento descrive l'architettura di rete e le interfacce di un router, evidenziando i dispositivi collegati e le loro funzioni.

## 2. Topologia della rete
![alt text](network.drawio.png)

--- 
## 2. Spazio dei nomi

![alt text](namespace.drawio.png)



# 2. Interfacce del Router

## Interfaccia: eth0 (LAN 1)
**Nome interfaccia**: eth0  
**Descrizione**: All'interfaccia eth0 è collegata la LAN di livello 1.  
**Hosts**: 
- **Switch 1**: Collega i seguenti dispositivi:
  - **DNS Server**: Fornisce risoluzione dei nomi per i dispositivi nella rete.
  - **Web Server (Apache)**: Server dedicato per la gestione di richieste web.

## Interfaccia: eth1 (LAN 2)
**Nome interfaccia**: eth1  
**Descrizione**: All'interfaccia eth1 è collegata la LAN di livello 2.  
**Hosts**: 
- **Switch 2**: Collega i seguenti dispositivi:
  - **Web Server (App 2)**: Server dedicato per l'applicazione 2, gestisce le richieste web.
  - **Web Server (App 3)**: Server dedicato per l'applicazione 3, gestisce le richieste web.

## Interfaccia: eth2 (LAN 3)
**Nome interfaccia**: eth2  
**Descrizione**: All'interfaccia eth2 è collegata la LAN di livello 3.  
**Hosts**: 
- **Switch 3**: (Se presente, altrimenti omettere)
  - (Elencare eventuali dispositivi collegati)

# NAT

###### Chain PREROUTING (nat) – Port Forwarding

| num | target | prot | opt | in   | out | source    | destination | source port | destination port | DNAT to         | Note        |
| --- | ------ | ---- | --- | ---- | --- | --------- | ----------- | ----------- | ---------------- | --------------- | ----------- |
| 1   | DNAT   | tcp  |     | eth4 |     | 0.0.0.0/0 | 0.0.0.0/0   | any         | 22               | 192.168.0.4:22  | `sshserver` |
| 2   | DNAT   | tcp  |     | eth4 |     | 0.0.0.0/0 | 0.0.0.0/0   | any         | 80               | 192.169.0.2:80  | `ws1a`      |
| 3   | DNAT   | tcp  |     | eth4 |     | 0.0.0.0/0 | 0.0.0.0/0   | any         | 139              | 192.169.0.4:139 | `smb`       |
| 4   | DNAT   | tcp  |     | eth4 |     | 0.0.0.0/0 | 0.0.0.0/0   | any         | 445              | 192.169.0.4:445 | `smb `      |
| 5   | DNAT   | tcp  |     | eth4 |     | 0.0.0.0/0 | 0.0.0.0/0   | any         | 8080             | 192.170.0.3:80  | `wsn`       |


###### Chain FORWARD – Allow NAT Traffic
| num | target | prot | opt | in | out | source    | destination | source port | destination port | Note        |
| --- | ------ | ---- | --- | -- | --- | --------- | ----------- | ----------- | ---------------- | ----------- |
| 1   | ACCEPT | tcp  |     |    |     | 0.0.0.0/0 | 192.168.0.4 | any         | 22               | `sshserver` |
| 2   | ACCEPT | tcp  |     |    |     | 0.0.0.0/0 | 192.169.0.2 | any         | 80               | `ws1a`      |
| 3   | ACCEPT | tcp  |     |    |     | 0.0.0.0/0 | 192.169.0.4 | any         | 139              | `smb`       |
| 4   | ACCEPT | tcp  |     |    |     | 0.0.0.0/0 | 192.169.0.4 | any         | 445              | `smb`       |
| 5   | ACCEPT | tcp  |     |    |     | 0.0.0.0/0 | 192.170.0.3 | any         | 80               | `wsn`       |


# 3. Firewall

###### Chain INPUT (Policy ACCEPT)
| num | target | prot | opt | in | out | source     | destination | source port | destination port |
| --- | ------ | ---- | --- | -- | --- | ---------- | ----------- | ----- | --- |
|     |        |      |     |    |     |            |             |         |     |

###### Chain FORWARD (Policy DROP)
| num | target | prot | opt | in  | out | source          | destination       | source port | destination port |
|-----|--------|------|-----|-----|-----|------------------|--------------------|-------------|-------------------|
| 2   | ACCEPT | all  |     |     |     | 192.168.0.0/24   |                    |             |                   |
| 3   | ACCEPT | all  |     |     |     | 192.169.0.0/24   |                    |             |                   |
| 4   | ACCEPT | all  |     |     |     | 192.170.0.0/24   |                    |             |                   |
| 5   | ACCEPT | tcp  |     |     |     | 192.168.1.0/24   |                    |             | 22                |
| 6   | ACCEPT | all  |     |     |     |                  |                    |             |                   |


###### Chain OUTPUT (Policy ACCEPT)
| num | target | prot | opt | in | out | source     | destination | source port | destination port |
| --- | ------ | ---- | --- | -- | --- | ---------- | ----------- | ----- | ----- |
|     |        |      |     |    |     |            |             |         |     |

# 5. Accounts

### SSH

| Host    | Username | Password   | Tipo di Account       |
| ------- | -------- | ---------- | --------------------- |
| bind    | senior   | 1Password! | Amministratore Senior |
| bind    | junior   | 2Password! | Amministratore Junior |
| ldap    | senior   | 1Password! | Amministratore Senior |
| mdb     | senior   | 1Password! | Amministratore Senior |
| openvpn | senior   | 1Password! | Amministratore Senior |
| smb     | senior   | 1Password! | Amministratore Senior |
| wsa1    | senior   | 1Password! | Amministratore Senior |
| wsa1    | junior   | 2Password! | Amministratore Junior |
| wsa2    | senior   | 1Password! | Amministratore Senior |
| wsa2    | junior   | 2Password! | Amministratore Junior |
| wsn     | senior   | 1Password! | Amministratore Senior |
| wsn     | junior   | 2Password! | Amministratore Junior |

### Samba

| Host | Username | Password | Tipo di Account |
| ---- | -------- | -------- | --------------- |
| smb  | mario    | 1as-aoi  | Dirigente       |
| smb  | filippo  | lolw-9u! | Dipendete       |

### DB/phpmyadmin

| Host  | Username | Password   | Tipo di Account       |
| ----- | -------- | ---------- | --------------------- |
| mdb   | senior   | 1Password! | Amministratore Senior |
| mdb   | junior   | 2Password! | Amministratore Junior |
| mdb   | pluto   | pluto       | Da eliminare - funziona solo in v0.5-ufficiale in su |


<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tabella Colorata</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        .red {
            background-color: red;
            color: white;
        }
        .green {
            background-color: green;
            color: white;
        }
    </style>
</head>
<body>

<table>
    <thead>
        <tr>
            <th></th>
            <th>LAN A</th>
            <th>LAN B</th>
            <th>LAN C</th>
            <th>LAN D</th>
            <th>LAN O</th>
            <th>LAN S</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>bind</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>oldap</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>wsa1</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>mdb</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>wsa2</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>nginx</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>openvpn</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>pcs1</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>pcs2</td>
            <td></td>
            <td></td>
            <td class="red">x</td>
            <td class="green">v</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>pcd1</td>
            <td></td>
            <td></td>
            <td class="red">x</td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>pco1</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
    </tbody>
</table>

</body>
</html>

|       | LAN A | LAN B | LAN C     | LAN D     | LAN O | LAN S |
|-------|-------|-------|-----------|-----------|-------|-------|
| bind  |       |       |           |           |       |       |
| oldap |       |       |           |           |       |       |
| wsa1  |       |       |           |           |       |       |
| mdb   |       |       |           |           |       |       |
| wsa2  |       |       |           |           |       |       |
| nginx |       |       |           |           |       |       |
| openvpn |     |       |           |           |       |       |
| pcs1  |       |       |           |           |       |       |
| pcs2  |       |       | **x** (red) | **v** (green) |       |       |
| pcd1  |       |       | **x** (red) |           |       |       |
| pco1  |       |       |           |           |       |       |
