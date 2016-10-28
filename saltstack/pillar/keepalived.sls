keepalived:
  image:
    name: oberthur/docker-keepalived
    tag: latest
    container_name: keepalived

  config:
    instance: VI_1
    state: EQUAL
    interface: eth1
    virtual_router_id: 111
    priority: 100
    advert_int: 1
    virtual_ip:
      address: 192.168.50.102
      mask: 24

