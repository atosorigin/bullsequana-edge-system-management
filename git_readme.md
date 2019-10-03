#BitBucket
==========
**Pour cloner la branche master :**

git clone https://bitbucket.sdmc.ao-srv.com/scm/eds/mipm.git

**Première création de repo : git init (à faire une seule fois)**

cd mipm

git pull

git add .

git commit (ouvre un éditeur vi ou nano)
ou
git commit -m 'Mon commentaire'

**Pour personnaliser :**
git config --global user.name "axxxxxx"
git config --global user.email "francine.sauvage@atos.fr"

git config --global credentials.helper store
ou
git config --global credentials.helper cache

#Jira
======
https://jira.sdmc.ao-srv.com/projects/EDS/summary

#Postgres
=========
Add the following empty directory in database/pg_data :
```
mipm> mkdir pg_tblspc
mipm> mkdir pg_replslot
mipm> mkdir pg_twophase
mipm> mkdir pg_stat
mipm> mkdir pg_stat_tmp
mipm> mkdir pg_snapshots
mipm> mkdir pg_commit_ts
mipm> mkdir pg_logical
mipm> mkdir pg_logical/snapshots
mipm> mkdir pg_logical/mappings

```

