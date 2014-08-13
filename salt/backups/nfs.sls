#Enable NFS

rpc/bind:
  service.running:
    - enable: True

nfs/status:
  service.running:
    - enable: True

nfs/nlockmgr:
  service.running:
    - enable: True

nfs/client:
  service.running:
    - enable: True
    - watch: 
      - file: /etc/vfstab

#Add line to vfstab
/backups:
  file.directory:
    - dir_mode: 755
    - file_mode: 644
    - owner: admin
    - group: adm
    - makedirs: True
    - clean: False

/etc/vfstab:
  file.append:
    - text:
      - {{ salt['pillar.get']('server:ovh1:ip')}}:{{ salt['pillar.get']('server:ovh1:path')}}/{{ salt['pillar.get']('nfs:suffix')}} -  /backups nfs - yes -



# /backups:
#    mount.mounted:
#     - device: {{ salt['pillar.get']('server:ovh1:ip')}}:{{ salt['pillar.get']('server:ovh1:path')}}/{{ salt['pillar.get']('nfs:suffix')}}
#     - fstype: nfs
#     - persist: True
#     - config: '/etc/vfstab'