# Build

## under Jira (https://jira.sdmc.ao-srv.com/projects/EDS/summary) 
1. Stop current Sprint
2. Generate Release Note
3. Create a new Release with **your desired version** and sprint end date
4. Create the next version as Unrelease with next sprint start date

## under FSC/Jenkins (https://jenkins04.sdmc.ao-srv.com)
1. Run 'bullsequana-edge' jenkins project with the version as parameter = **your desired version** (like 2.0.9)

This step creates the tag under bitbucket

## under Factory (129.182.247.57)
1. Clone mism repo https://bitbucket.sdmc.ao-srv.com/scm/eds/mism.git
2. Go to your new mism directory
3. Run the following shell 
```
[/var/mism]# pkg/generate_tagged_deliverable_cli.sh
```
  
This step generates docker deliverable mism-**your desired version**.tar for in /var/livraisons/bullsequana-**your desired version**-bullsequana-edge-system-management directory
  
# PLM
1. Open a DOS command
2. Copy generated tar in MachineIntelligence directory
```
[/var/mism]# scp root@129.182.247.57:/var/livraisons/bullsequana-**your desired version**-bullsequana-edge-system-management directory/mism-**your desired version**.tar
or  on Z:\ dir
[/var/mism]# scp root@129.182.247.57:/var/livraisons/2.1.1-bullsequana-edge-system-management/bullsequana-edge-system-management/mism.2.1.1.tar.gz "Z:\16_MachineIntelligence\12_Zones_Dédiées\MISM"

```
3. Load mism.tar in PLM

# Test
## under Factory
1. Go to /var/livraisons/bullsequana-**your desired version**-bullsequana-edge-system-management/bullsequana-edge-system-management/
2. Run the following shell
```
[/var/mism]# ./install.sh
```

# Diffusion list
MICHALAK, BEATRICE <beatrice.michalak@atos.net>;  
BRASSAC, CLAUDE <claude.brassac@atos.net>;  
FRECHARD, DENIS <denis.frechard@atos.net>;  
COUSSON, PATRICK <patrick.cousson@atos.net>;  
MÉNÉTRIER, THIERRY <thierry.menetrier@atos.net>;  
MIJIYAWA, MEKANO <mekano.mijiyawa@atos.net>;  
VIGOR, ALAIN <alain.vigor@atos.net>;  
PAMBOUD, EVRARD (ext) <evrard.pamboud.external@atos.net>;  
POMMIER, PIERRE LAURENT <pierre-laurent.pommier@atos.net> 
MATEO, JEAN-LOUIS <jean-louis.mateo@atos.net>  
VACHEY, ERIC <eric.vachey@atos.net>  
PRIEBER, GERT <gert.prieber@atos.net>  
FIAT, LIONEL <lionel.fiat@atos.net>  
D HUIT, FABIEN <fabien.dhuit@atos.net>  
BORDIER, PASCALE <pascale.bordier@atos.net>  
Bouchet, Alain <alain.bouchet@atos.net>  

