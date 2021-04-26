security_group_rules = [
  {
    name      = "rule1"
    direction = "inbound"
    remote    = "0.0.0.0/0"
    tcp = {
      port_min = 22
      port_max = 22
    }
  },
  {
    name      = "rule2"
    direction = "inbound"
    remote    = "0.0.0.0/0"
  },
  {
    name      = "rule3"
    direction = "outbound"
    remote    = "0.0.0.0/0"
  },
]