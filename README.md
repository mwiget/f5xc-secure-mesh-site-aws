# f5xc-secure-mesh-site

Sample Terraform orchestration to create 2 secure mesh sites based on
3-node aws clusters, one single interface site and one dual interface site.


```
secure_mesh_site_1       secure_mesh_site_2
+--------------+         +--------------+
| +----------+ |    |    | +----------+ |    
| |  node0   |------|------|  node0   |------|
| +----------+ |    |    | +----------+ |    |
| +----------+ |    |    | +----------+ |    | inside
| |  node1   |------|------|  node1   |------| network
| +----------+ |    |    | +----------+ |    |
| +----------+ |    |    | +----------+ |    |
| |  node2   |------|------|  node2   |------|
| +----------+ |    |    | +----------+ |
+--------------+    |    +--------------+
                 outside
                 network
```
