# Domaincontroller

## Active Directory Domain Services (ADDS)

Active directory maakt het mogelijk om gebruikersaccounts aan te maken op netwerk. Hiermee kan elke gebruiker inloggen op een computer binnen het netwerk met zijn eigen account.  
Als je bijvoorbeeld denkt aan een schoolomgeving. Iedere student heeft zijn eigen account en meldt zich aan op een computer van de school. Als hij zich inlogt in lokaal A en daar een word-document maakt dan is het mogelijk dat hij in lokaal B kan verderwerken aan het word-document.

### Script

Het script [2_adds.ps1](../../scripts/domeincontroller/2_adds.ps1) zorgt ervoor dat de nodige roles geinstalleerd en geconfigureerd worden.  
Het gaat de rol `Active Directory Domain Services` installeren en daarna de server promoveren naar een domeincontroller.  
Tijdens de promotie worden de domeinnaam, netbiosnaam en safemode administrator wachtwoord ingesteld uit de [algemene settings](../../scripts/settings.json).

## DNS

Voer het script [3_dns_routing.ps1](../../scripts/domeincontroller/3_dns_routing.ps1) uit zodat dns geconfigureerd wordt.  
Dit gaat een reverse lookupzone aanmaken en de server configureren als nat router.  
Nadat het script uitgevoerd is moeten we manueel het dns PTR-record genereren.  

### PTR-record genereren

In de servermanager:

Tools --> DNS.
In het dialoogvenster dat geopend is zoek je onder EP1-DC-ALFA in de linkerkolom voor `Forward Lookup Zone`, klik hierop.  
Open de zone `EP1-PIETER-hogent` en zoek naar een record met de naam `ep1-dc-alfa`.  

> Opgelet! Er zijn 2 record met deze naam. Wij zoeken het record met ip address `192.168.10.200`  

Rechtermuisklik op dit record --> properties
Vink "Update associated pointer (PTR) record" aan.
