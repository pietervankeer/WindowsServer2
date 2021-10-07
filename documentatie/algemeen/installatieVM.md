# Virtuele machine aanmaken

Maak binnen de hypervisor een virtuele machine aan met volgende specificaties:

- 1 processorkern
- minimum 2 Gb werkgeheugen
- 1 netwerkadapter op "Intern netwerk"

> Opgelet! Als je een domeincontroller wil maken kies je voor 2 netwerkadapters:
>
> - 1 Nat netwerkadapter
> - 1 Intern netwerkadapter
>
> Opgelet! Indien je een domeincontroller wil maken zorg dat dat de nat netwerkadapter op adapter 1 staat. Anders gaat het [initial setup](../../scripts/domeincontroller/1_initial_setup.ps1) script de adapters fout configureren.
