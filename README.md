# f5xc-secure-mesh-site

Sample Terraform orchestration to create 2 secure mesh sites based on
3-node aws clusters, one single interface site and one dual interface site.


```
secure_mesh_site_1       secure_mesh_site_2
+--------------+         +--------------+
| +----------+ |    |    | +----------+ |    
| | master-0 |------|------| master-0 |------|
| +----------+ |    |    | +----------+ |    |
| +----------+ |    |    | +----------+ |    | inside
| | master-1 |------|------| master-1 |------| network
| +----------+ |    |    | +----------+ |    |
| +----------+ |    |    | +----------+ |    |
| | master-2 |------|------| master-2 |------|
| +----------+ |    |    | +----------+ |
+--------------+    |    +--------------+
                 outside
                 network
```
