# Starwart Chart

Helm chart for Stalwart Mail Server

## Deployment

Write values.yaml

```yaml
mail:
  image:
    tag: v0.10.7
  storage:
    size: 20Gi
```

```sh
# update dependencies
helm dependency update --skip-refresh ./apps/stalwart

# test template generation
helm template ./apps/stalwart -f values.yaml

# deploy helm chart
helm install stalwart ./apps/stalwart -f values.yaml
```

Write the ingress definition

```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    traefik.ingress.kubernetes.io/router.tls: "true"
    cert-manager.io/cluster-issuer: "my-cluster-issuer"
  name: stalwart
spec:
  tls:
    - hosts:
        - mail.myserver.com
      secretName: tls-stalwart
  rules:
    - host: mail.myserver.com
      http:
        paths:
          - backend:
              service:
                name: stalwart-mail
                port:
                  number: 8080
            path: /
            pathType: Prefix
```

```sh
# create ingress
kubectl apply -f ingress.yaml

# get admin password
kubectl log $NAME_OF_THE_STALWART_POD
```

Go to mail.server.com and sign in.