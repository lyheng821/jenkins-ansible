```bash
kubectl exec -it pod/spring-app-58778db48f-2b2hs -- bash


pisethkhon888@node1 ~/j/k/p/hostpath (master) [1]> kubectl exec -it pod/spr
ing-app-58778db48f-2b2hs -- bash
bash-4.4# ls
app.jar  src
bash-4.4# cd src/
bash-4.4# ls
main
bash-4.4# cd main/resources/images
bash-4.4# ls

bash-4.4# 
```

for check volumeMounts
# you need to know pod run in node expample node4
pisethkhon888@node4:/var$ ls
backups  crash   lib    lock  mail  run   spool
cache    images  local  log   opt   snap  tmp
pisethkhon888@node4:/var$ cd images
pisethkhon888@node4:/var/images$ ls