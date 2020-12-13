# This guide to register RHEL gust VM to Satellite Server 

Intall Satellite CA

```
rpm -ivh http://satellite.example.com/pub/katello-ca-consumer-latest.noarch.rpm
```

Register with Satellite 

```
subscription-manager register --org="gcloud" --activationkey="cloud-guest-key"
```
