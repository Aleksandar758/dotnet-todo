# todo Helm Chart

This chart deploys the dotnet-todo application.

## Deploy locally with KinD / Minikube

1. Create a cluster (KinD example):

```bash
kind create cluster
```

2. Load the locally built image into kind:

```bash
kind load docker-image dotnet-todo:latest
```

3. Install the chart:

```bash
helm install my-todo charts/todo --set image.tag=latest
```

4. Check health and logs:

```bash
kubectl get pods
kubectl logs -l app=todo
kubectl port-forward svc/my-todo-todo 5000:5000
# then curl http://localhost:5000/todoitems
```

## Cost optimization notes

- Use low CPU/memory requests for small services.
- Use autoscaling for variable workloads.
- Use spot/low-cost nodes for non-critical workloads and set PodDisruptionBudgets accordingly.
