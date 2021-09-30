# Installatie Windows Server 2019

Nadat je de virtuele machine hebt aangemaakt kan je het besturingssysteem installeren (in ons geval is dit Windows Server 2019)

Heb je nog niet een virtuele machine aangemaakt dan kan je dit doen aan de hand van volgende handleiding, [Virtuele machine aanmaken](installatieVM.md)

Om te beginnen moet je de het installatiebestand (.iso) toevoegen aan de opslag van de vm (virtuele machine). Dit kan je doen in VirtualBox door de instellingen te openen van de vm en te navigeren naar het tabje "Opslag".

## De vm opstarten

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