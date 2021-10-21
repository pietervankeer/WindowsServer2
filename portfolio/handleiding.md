# Handleiding Windows Server 2

## Algemeen

Alles wat onder algemeen te vinden is kan je toepassen op alle server die binnen de opdracht vallen van Windows Server 2

### Virtuele machine aanmaken

Maak binnen de hypervisor naar keuze een virtuele machine aan met volgende specificaties:

- 1 processorkern
- minimum 2 Gb werkgeheugen
- 1 netwerkadapter op "Intern netwerk"

> Opgelet! Als je een domeincontroller wil maken kies je voor 2 netwerkadapters:
>
> - 1 Nat netwerkadapter
> - 1 Intern netwerkadapter
>
> Opgelet! Indien je een domeincontroller wil maken zorg dat dat de nat netwerkadapter op adapter 1 staat. Anders gaat het [initial setup](../scripts/domeincontroller/1_initial_setup.ps1) script de adapters fout configureren.

### Installatie Windows Server 2019

Nadat je de virtuele machine hebt aangemaakt kan je het besturingssysteem installeren (in ons geval is dit Windows Server 2019)

Heb je nog niet een virtuele machine aangemaakt dan kan je dit doen aan de hand van volgende handleiding, [Virtuele machine aanmaken](#virtuele-machine-aanmaken)

Om te beginnen moet je de het installatiebestand (.iso) toevoegen aan de opslag van de vm (virtuele machine). Dit kan je doen in VirtualBox door de instellingen te openen van de vm en te navigeren naar het tabje "Opslag".

#### De vm opstarten

- Start de vm op.
- Doorloop de wizard voor het installeren van Windows Server 2019
- Klik op "Install now"
- Selecteer de gepaste versie die je wilt installeren, in ons geval is dit "Windows Server 2019 Standard (Desktop Experience)".
  - Wij nemen hier de Desktop Experience omdat we een grafische user interface willen.
- Lees en accepteer, indien u akkoord bent, de license terms.
- Kies voor "Custom: Install Windows Only (Advanced)"
- Selecteer de schijf/partitie waarop u Windows wil installeren en kies vervolgens voor next
- Wacht tot de installatie voltooid is.
- Kies een wachtwoord voor het administrator account

Nu is het besturingssysteem geïnstalleerd. Als je VirtualBox gebruikt gelieve dan ook de Guest additions te installeren zodat we in de toekomst gedeelde mappen kunnen gebruiken.

## Domeincontroller (EP1-DC-ALFA)

Om een domeinstructuur op te zetten hebben we een domeincontroller nodig. Deze gaat er ook voor zorgen dat er internet beschikbaar is binnen ons netwerk.

### Domeincontroller: Initial Setup

Na een clean install van het besturingssysteem, in ons geval Windows Server 2019, kan je overgaan tot het instellen van hostname, netwerkadapters, ... Dit doen we met het script [1_initial_setup.ps1](../scripts/domeincontroller/1_initial_setup.ps1). De configuratie hiervan kan je eventueel aanpassen in het [settingsbestand](../scripts/domeincontroller/settings.json).

### Active Directory Domain Services (ADDS)

Active directory maakt het mogelijk om gebruikersaccounts aan te maken op netwerk. Hiermee kan elke gebruiker inloggen op een computer binnen het netwerk met zijn eigen account.  
Als je bijvoorbeeld denkt aan een schoolomgeving. Iedere student heeft zijn eigen account en meldt zich aan op een computer van de school. Als hij zich inlogt in lokaal A en daar een word-document maakt dan is het mogelijk dat hij in lokaal B kan verderwerken aan het word-document.  
Het script [2_adds.ps1](../scripts/domeincontroller/2_adds.ps1) zorgt ervoor dat de nodige roles geinstalleerd en geconfigureerd worden.  
Het gaat de rol `Active Directory Domain Services` installeren en daarna de server promoveren naar een domeincontroller.  
Tijdens de promotie worden de domeinnaam, netbiosnaam en safemode administrator wachtwoord ingesteld uit de [algemene settings](../scripts/settings.json).

### DNS

Voer het script [3_dns_routing.ps1](../scripts/domeincontroller/3_dns_routing.ps1) uit zodat dns geconfigureerd wordt.  
Dit gaat een reverse lookupzone aanmaken en de server configureren als nat router.

### DHCP

Om de domeincontroller IP adressen te laten uitdelen moeten we hiervan een DHCP-server maken. Dit kan je doen met het script [4_DHCP.ps1](../scripts/domeincontroller/4_dhcp.ps1).
Dit zorgt er voor dat de rol DHCP server zal geinstalleerd worden alsook het aanmaken van een DHCP scope waar kan instellen welke addressen er worden uitgedeeld en welke niet. Wat er precies zal geconfigureerd worden kan je vinden in het [settingsbestand](../scripts/domeincontroller/settings.json).

## Webserver (EP1-WEB)

### Webserver: Initial Setup

Na een clean install van het besturingssysteem, in ons geval Windows Server 2019, kan je overgaan tot het instellen van hostname, netwerkadapters, ... Dit doen we met het script [1_initial_setup.ps1](../scripts/webserver/1_initial_setup.ps1). De configuratie hiervan kan je eventueel aanpassen in het [settingsbestand](../scripts/webserver/settings.json).

## Deploymentserver (EP1-SCCM)

## Certificatieserver (EP1-CA)
