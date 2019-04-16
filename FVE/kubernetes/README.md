# Deploy onto Kubernetes

## Deploy
* fve kubernetes deployment yaml file folder
``./kubernetes``
* prerequisite
  * kubernetes command line tool
[kubectl official installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
  * kubernetes configuration file (Kube Config)
It is a standard kubernetes file used for the kubectl client to access to the cluster. It could be retrieved from the master node on private cloud. And if on public cloud, different cloud have their guide to retrieve this file from the cluster.
* resource management for fve and fglam
This will help you if your environment don't have minimal required resources for running fve. It will failed to schedule instead of running container failed and need to debug the container for trouble shooting.
  * For FVE, you will see content in the yaml files similar as below. By default, the FVE requires at least 4Gi memory and 2 Cores CPU. If your environment is large, you can change this based on the sizing guide. 
```        
resources:
    requests:
        memory: "4Gi"
        cpu: "2"
    limits:
        memory: "16Gi"
        cpu: "8"
```
  * For Fglam, you will see content in the yaml files similar as below. By default, the Fglam requires at least 512Mi memory and 0.1 Core CPU (100 millicores). If your environment is large, you can change this based on the sizing guide. 
```
resources:
    requests:
        memory: "512Mi"
        cpu: "100m"
    limits:
        memory: "2Gi"
        cpu: "2"
```
* difference between load balancer and nodeport (with use cases)
  * load balancer: Public cloud kubernetes service. Private cloud with ingress controller. You will get a public IP address to access fve. [kubernetes ingress controller official guide](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).
  * node port: Public cloud which have a public node. Private cloud without ingress controller. You will check which node the fve container is running on and access to fve with http://$NODE_IP_ADDRESS:$EXPOSED_NODE_PORT
### Deploy as Load Balancer
* fve kubernetes deployment yaml file
``./kubernetes/fve-loadbalancer.yml``
* Change ``loadBalancerIP: <Public IP>``
  * For AKS: follow the [official guide](https://docs.microsoft.com/en-us/azure/aks/static-ip).
### Deploy as Node Port
* fve kubernetes deployment yaml file
``./kubernetes/fve-nodeport.yml``

## Access FVE
Access method will be different based on the different service deploy methods.
### Load Balancer
* Use the public ip address ($PUBLIC_IP) in ``loadBalancerIP: <Public IP>`` and the port is 8080, http://$PUBLIC_IP:8080.
### Node Port
* Check Access IP Address
  * ``kubectl describe pods -n questfve``, you should see a pod whose name is similar to "fve-app-54f44dc866-rv64x"
  * ``kubectl describe <pod name>``, find line similar to "Node:               kubeckaworker/10.2.122.15", and the "10.2.122.15" is the Node IP Address to access the fve ($NODE_IP_ADDRESS).
* Check Access Port
  * ``kubectl get svc fve -n questfve``, you should see the PORT(s) similar to "8080:32131/TCP", and the 32121 is the port exposed on the node with the previous IP address ($EXPOSED_NODE_PORT). 
* Access the fve service through http://$NODE_IP_ADDRESS:$EXPOSED_NODE_PORT.