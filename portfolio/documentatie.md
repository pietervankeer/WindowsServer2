# Documentatie Windows Server 2

## Algemeen

### Join Domain

Dit script gaat er voor zorgen dat de computer in het domain gezet wordt. Het script maakt een account aan in Active Directory en plaatst het in de Organisational unit MemberServers.

## Domeincontroller

### Domeincontroller: Initial setup

Het [initial setup](../scripts/domeincontroller/1_initial_setup.ps1) script gaat:

- Hostname instellen
- Windows updates uitschakelen __(in een productieomgeving is dit ten zeerste afgeraden)__
- Netwerkadapters goed instellen
  - Ip-adressen instellen (statisch of via dhcp)
  - Naamgeving van netwerk adapters
  - IPv6 uitschakelen

```json
{
    "Hostname": "EP1-DC-ALFA",
    "Network": [
        {
            "Name": "WAN",
            "DHCP": "True",
            "IPAdress": ""
        },
        {
            "Name": "LAN10",
            "DHCP": "False",
            "IPAdress": "192.168.10.200"
        }
    ]
}
```

### Active Directory Domain Services (ADDS)
  
Het script [2_adds.ps1](../scripts/domeincontroller/2_adds.ps1) zorgt ervoor dat de role `Active Directory Domain Services` geinstalleerd en geconfigureerd wordt.  
Het gaat de rol `Active Directory Domain Services` installeren en daarna de server promoveren naar een domeincontroller.  
Tijdens de promotie worden de domeinnaam, netbiosnaam en safemode administrator wachtwoord ingesteld uit de [algemene settings](../scripts/settings.json).

```json
{
    "ADDS": {
        "DomainName": "EP1-PIETER.hogent",
        "NetBiosName": "EP1-PIETER",
        "password": "Admin2021"
    }
}
```

| Variabele     | Uitleg                                                                                                                                                 |
| :------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `DomainName`  | Domeinnaam. Hier vul je de naam in dat je wil instellen voor het domein.                                                                               |
| `NetBiosName` | Netbiosnaam. Dit kan je vergelijken met een roepnaam. als ik wil inloggen als domeinadministrator gebruik ik de netbiosnaam `EP1-PIETER\Administrator` |
| `password`    | Dit is een wachtwoord dat je moet gebruiken als de computer opstart in Safe mode, of een variant hiervan.                                              |

### DNS

Voer het script [3_dns_routing.ps1](../scripts/domeincontroller/3_dns_routing.ps1) uit zodat dns geconfigureerd wordt.  
Dit gaat een reverse lookupzone aanmaken en daarna de rol `Remote access` installeren. De instellingen hiervan kan je vinden in het [algemene settingsbestand](../scripts/settings.json)

```json
{
    "DNS": {
        "NetworkID": "192.168.10.0/24"
    }
}
```

| Variabele   | Uitleg                        |
| :---------- | :---------------------------- |
| `NetworkID` | Het netwerkID in CIDR-notatie |

### DHCP

Om de domeincontroller IP adressen te laten uitdelen moeten we hiervan een DHCP-server maken. Dit kan je doen met het script [4_DHCP.ps1](../scripts/domeincontroller/4_dhcp.ps1).
Dit zorgt er voor dat de rol DHCP server zal geinstalleerd worden alsook het aanmaken van een DHCP scope waar kan instellen welke addressen er worden uitgedeeld en welke niet. Wat er precies zal geconfigureerd worden kan je vinden in het [settingsbestand](../scripts/domeincontroller/settings.json).

```json
{
    "DHCP": {
        "scopeName": "HoGent-EP1",
        "ScopeDescr": "De scope voor het toewijzen van ip-adressen in het netwerk.",
        "scopeStartIp": "192.168.10.100",
        "scopeEndIp": "192.168.10.150",
        "scopeSubnetMask": "255.255.255.0",
        "scopeLease": "8.00:00:00"
    }
}
```

| Variabele         | Uitleg                                                                                              |
| :---------------- | :-------------------------------------------------------------------------------------------------- |
| `scopeName`       | De naam van de DHCP-scope die je gaat aanmaken.                                                     |
| `ScopeDescr`      | Een gepaste beschrijving voor die scope die je gaat aamaken.                                        |
| `scopeStartIp`    | Het __begin__ van de range van ip-adressen die de dhcp server mag uitdelen.                         |
| `scopeEndIp`      | Het __einde__ van de range van ip-adressen die de dhcp server mag uitdelen.                         |
| `scopeSubnetMask` | Het subnetmask van de ip adressen die de dhcp scope mag uitdelen.                                   |
| `scopeLease`      | De lease tijd is hoelang de dchp server een ip-adres mag "uitlenen" voor het moet vernieuwd worden. |

## Webserver

### Webserver: Initial setup

Het [initial setup](../scripts/Webserver/1_initial_setup.ps1) script gaat:

- Hostname instellen
- Windows updates uitschakelen __(in een productieomgeving is dit ten zeerste afgeraden)__
- Netwerkadapters goed instellen
  - Ip-adressen instellen (statisch)
  - Naamgeving van netwerk adapters
  - IPv6 uitschakelen

```json
{
    "Hostname": "EP1-WEB",
    "Network": [
        {
            "Name": "LAN10",
            "DHCP": "False",
            "IPAdress": "192.168.10.220"
        }
    ]
}
```

### Active Directory Certificate Services (ADCS)

Het script [2_install_webserver.ps1] gaat de rol `Active directory certificate services` installeren. Maar nog niet configureren

## Deploymentserver

### Deploymentserver: Initial setup

Het [initial setup](../scripts/deploymentserver/1_initial_setup.ps1) script gaat:

- Hostname instellen
- Windows updates uitschakelen __(in een productieomgeving is dit ten zeerste afgeraden)__
- Netwerkadapters goed instellen
  - Ip-adressen instellen (statisch)
  - Naamgeving van netwerk adapters
  - IPv6 uitschakelen

```json
{
    "Hostname": "EP1-SCCM",
    "Network": [
        {
            "Name": "LAN10",
            "DHCP": "False",
            "IPAdress": "192.168.10.225"
        }
    ]
}
```

nadat dit uitgevoerd is geen we de nodige programma's installeren:

- Dubbelklik op `F:\configfiles\install_adk.exe` en installeer het programma.
- Dubbelklik op `F:\configfiles\install_mdt.msi` en installeer het programma.
- Dubbelklik op `F:\configfiles\install_sccm.exe` en installeer het programma.

## Certificatieserver
