# Task 2 - Understanding Persistent Storage

In this task I learned about Persistent Volumes, Persistent Volume Claims and Storage Classes.

To complete this tasks I used `pvc.yaml` manifest provided in sample-django chart `templates/` folder and OpenEBS NFS Provisioner available on Digital Ocean [marketplace](https://marketplace.digitalocean.com/apps/openebs-nfs-provisioner). Other manifests would've worked if I used external NFS server deployed somewhere else.

`pv.yaml` and `storageClass.yaml` manifests provided weren't used due to limitations of Digital Ocean volumes block storage (they do not support `Many` access modes) and my inability to deploy NFS server. These manifests are written as if NFS server was used to provide physical storage for PVs. And PVC manifest would've used `storageClass: sample-django-static-nfs` to dynamically provision PVs if there are no available ones.

## Screenshots of successful deployment

PV and PVC in cluster:
![alt text](PV%20and%20PVC%20in%20cluster.png)

sample-django static content in PV:
![alt text](PV%20contents.png)