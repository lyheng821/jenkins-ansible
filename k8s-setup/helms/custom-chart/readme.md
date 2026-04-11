# delete folder and file

folder charts


in temple delete 
## NOTE 
command for working with customchart 

```bash
# render the chart from value file 
# note run command in folder  /home/pisethkhon888/jenkins-ansible-lesson/k8s-setup/helms not in /home/pisethkhon888/jenkins-ansible-lesson/k8s-setup/helms/custom-chart

helm list

helm template custom-chart  --values custom-chart/values.yaml

helm template custom-chart  --values custom-chart/stag-values.yaml
```