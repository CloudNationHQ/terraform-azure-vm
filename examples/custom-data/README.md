This example details the setup and utilization of custom data and cloud-init.

```hcl
module "vm" {
  source  = "cloudnationhq/vm/azure"
  version = "~> 1.8"

  keyvault   = module.kv.vault.id
  naming     = local.naming
  depends_on = [module.kv]

  instance = {
    type          = "linux"
    name          = module.naming.linux_virtual_machine.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location

    custom_data = <<EOF
I2Nsb3VkLWNvbmZpZwpwYWNrYWdlX3VwZ3JhZGU6IHRydWUKcGFja2FnZXM6CiAg
LSBhcGFjaGUyCnJ1bmNtZDoKICAtIGVjaG8gIjxodG1sPjxib2R5PjxoMT5XZWxj
b21lIHRvIE15IFdlYiBQYWdlPC9oMT48L2JvZHk+PC9odG1sPiIgPiAvdmFyL3d3
dy9odG1sL2luZGV4Lmh0bWwK
EOF

    interfaces = {
      int = {
        subnet = module.network.subnets.int.id
      }
    }
  }
```

As a reference the below cloud-init.yaml file can be encoded with ```base64 -i cloud-init.yaml```.

```yaml
#cloud-config
package_upgrade: true
packages:
  - apache2
runcmd:
  - echo "<html><body><h1>Welcome to My Web Page</h1></body></html>" > /var/www/html/index.html
```

This base64 encoded string can be used as input for the custom data property.
