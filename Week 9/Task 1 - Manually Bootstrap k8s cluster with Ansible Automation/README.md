# Task 1 - Manually Bootstrap k8s cluster with Ansible Automation

In this task I deployed Kubernetes the Hard way on locally deployed virtual machines by following [kelseyhightower](https://github.com/kelseyhightower) tutorial([link](https://github.com/kelseyhightower/kubernetes-the-hard-way)). But in my case I used Ansible to automate this process.

## Deployment Guide

To successfully use ansible playbook provided in this [repository](/Week%209/Task%201%20-%20Manually%20Bootstrap%20k8s%20cluster%20with%20Ansible%20Automation/ansible/setup_cluster.yml) you have to follow next steps:
1. You should deploy jumbox(optional), server and desirable ammount of node-* (or worker) virtual machines with minimal requirements of at least:

| Name    | Description            | CPU | RAM   | Storage |
|---------|------------------------|-----|-------|---------|
| jumpbox | Administration host    | 1   | 512MB | 10GB    |
| server  | Kubernetes server      | 1   | 2GB   | 20GB    |
| node-*  | Kubernetes worker node | 1   | 2GB   | 20GB    |

2. Copy `ansible/` folder to `jumpbox` machine
3. Edit [`inventory.yml`](/Week%209/Task%201%20-%20Manually%20Bootstrap%20k8s%20cluster%20with%20Ansible%20Automation/ansible/inventory.yml) to have all deployed VMs, but `jumpbox` config mustn't be edited! Also add `ansible_become_password` as needed
4. Edit [`variables.yml`](/Week%209/Task%201%20-%20Manually%20Bootstrap%20k8s%20cluster%20with%20Ansible%20Automation/ansible/variables.yml) to suit your preferences
    4.1 `k8s_subnets` must have the same ammount of subnets as there are worker nodes in `inventory.yml`
    4.2 Don't forget to set `k8s_cluster_cidr`
5. Configure ssh connection between `jumpbox` and other VMs
6. Execute next command in `ansible/` directory if you set `ansible_become_password` in `inventory.yml`:
```bash
ansible-playbook -i inventory.yml setup_cluster.yml
```
Otherwise add `-K` flag and input common sudo password for VMs provisioned.
7. If play was successfull, you will be able to execute `kubectl get pods` from `jumpbox` machine and see nginx pod like on this screenshot:
![alt text](/Week%209/Task%201%20-%20Manually%20Bootstrap%20k8s%20cluster%20with%20Ansible%20Automation/screenshots/after_play_get_pods.png)

## Personal deployment test

Before publishing code for this task I tested playbook on locally deployed VMs. Clean playbook installation followed with next recap:
![alt text](/Week%209/Task%201%20-%20Manually%20Bootstrap%20k8s%20cluster%20with%20Ansible%20Automation/screenshots/First_play.png)

I had a bug in `smoke_test` role due to me forgeting to remove unneded task. After removing problematic step and applying playbook once again I had successfull deployment, which also tested playbook's idempotency:
![alt text](/Week%209/Task%201%20-%20Manually%20Bootstrap%20k8s%20cluster%20with%20Ansible%20Automation/screenshots/play_after_debug.png)

In the end I was able to access nginx default page in web browser:
![alt text](/Week%209/Task%201%20-%20Manually%20Bootstrap%20k8s%20cluster%20with%20Ansible%20Automation/screenshots/nginx_test_connection.png)