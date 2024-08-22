# Setup
See https://github.com/prometheus-operator/kube-prometheus/blob/main/docs/customizing.md

```
./build.sh main.jsonnet
./setup.sh
```

## View prom targets
```
http://localhost:9090/targets?search=
```
