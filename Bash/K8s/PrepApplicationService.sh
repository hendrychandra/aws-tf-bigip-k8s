#!/bin/bash -xe

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

#╔════════════════════════╗
#║   Ingress Controller   ║
#╚════════════════════════╝

# Note: NGINX Ingress needs ample time between: NGINX Ingress Controller creation, and when the Ingress object created.

# Reference : https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/baremetal/deploy.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.7.0/deploy/static/provider/baremetal/deploy.yaml
kubectl patch service --namespace ingress-nginx ingress-nginx-controller --patch '{"spec":{"externalTrafficPolicy":"Cluster","type":"NodePort","ports":[{"port":80,"nodePort":30080},{"port":443,"nodePort":30443}]}}'

Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --namespace ingress-nginx --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --namespace ingress-nginx -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --namespace ingress-nginx --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All NGINX Ingress pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All NGINX Ingress pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔══════════╗
#║   DVWA   ║
#╚══════════╝

# Source References:
# https://github.com/digininja/DVWA
# https://hub.docker.com/r/vulnerables/web-dvwa

# Initial Credential
# admin:password

# Credentials after initial reset
# admin:password
# gordonb:abc123
# 1337:charley
# pablo:letmein
# smithy:password

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: dvwa

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: dvwa
  namespace: dvwa
spec:
  selector:
    matchLabels:
      app: dvwa
  replicas: 1
  template:
    metadata:
      labels:
        app: dvwa
    spec:
      containers:
      - name: dvwa
        image: vulnerables/web-dvwa:1.9
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
          protocol: TCP

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: dvwa
  name: dvwa
  namespace: dvwa
spec:
  ports:
  - nodePort: 30081
    port: 80
    protocol: TCP
    targetPort: 80
    name: http
  selector:
    app: dvwa
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔══════════════╗
#║   Hackazon   ║
#╚══════════════╝

# Source Reference:
# https://github.com/cmutzel/all-in-one-hackazon
# https://hub.docker.com/r/bepsoccer/all-in-one-hackazon

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: hackazon

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: hackazon
  namespace: hackazon
spec:
  selector:
    matchLabels:
      app: hackazon
  replicas: 1
  template:
    metadata:
      labels:
        app: hackazon
    spec:
      containers:
      - name: hackazon
        image: bepsoccer/all-in-one-hackazon
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
          protocol: TCP

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: hackazon
  name: hackazon
  namespace: hackazon
spec:
  ports:
  - nodePort: 30082
    port: 80
    protocol: TCP
    targetPort: 80
    name: http
  selector:
    app: hackazon
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
  sleep $Loop_Period
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

# Admin credential:
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if ( kubectl exec -it -n hackazon $(kubectl get pods -n hackazon --no-headers=true | awk '{print $1}') -- cat /hackazon-db-pw.txt ) ; then
  echo "Hackazon (UserID:eMail:Password) admin:admin@hackazon.com:$(kubectl exec -it -n hackazon $(kubectl get pods -n hackazon --no-headers=true | awk '{print $1}') -- cat /hackazon-db-pw.txt)"
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for Hackazon's configuration to be Completed."
  sleep $Loop_Period
 fi
done

# Correction to the 'sendmail' mail-agent which does not exist
kubectl exec -it -n hackazon $(kubectl get pods -n hackazon --no-headers=true | awk '{print $1}') -- cat /var/www/hackazon/assets/config/email.php
kubectl exec -it -n hackazon $(kubectl get pods -n hackazon --no-headers=true | awk '{print $1}') -- sed -i "s/'type' *=> 'sendmail'/'type' => 'native'/g" /var/www/hackazon/assets/config/email.php
kubectl exec -it -n hackazon $(kubectl get pods -n hackazon --no-headers=true | awk '{print $1}') -- cat /var/www/hackazon/assets/config/email.php

# There is a glitch, if you access directly to nodePort: 30082, the glitch appears after you login, or when registering new user:
# "Error: 400 Invalid Referer"
# However, when accessed through another NGINX Reverse Proxy, the glitch does not appear.
# So the glitch may be related to either or combination of: HTTP Header Host, Referer, Non-Standard Port Usage, etc.

#╔════════════════╗
#║   Juice-Shop   ║
#╚════════════════╝

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: juice-shop

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: juice-shop
  namespace: juice-shop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: juice-shop
  template:
    metadata:
      labels:
        app: juice-shop
    spec:
      containers:
      - name: juice-shop
        image: bkimminich/juice-shop:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 3000
          name: http
          protocol: TCP

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: juice-shop
  name: juice-shop
  namespace: juice-shop
spec:
  ports:
  - nodePort: 30084
    port: 80
    protocol: TCP
    targetPort: 3000
    name: http
  selector:
    app: juice-shop
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔═══════════════════════╗
#║   WitcherPortal CTF   ║
#╚═══════════════════════╝

#
# ---------
#
# image: sbacker/ctfapi2@sha256:128fa2fb754dcd8e962d54c2f2fb975f60fc081381454a3276525298c5b5fbd8
# is the CTFd. CTFd is only like a registry or book-keeper which take notes of what you have obtained.
# It knows the correct answer (pre-configured). Just like an Exam/Test machine.
# It is OK to run this image on any random port.
#
# Credential
# admin
# @F5Netw0rks
#
# Participant needs to register first before joining CTF (i.e. the Exam/Test).
#
# ---------
#
# image: sbacker/witcherportal2@sha256:8b9f0b24d974be1f8ad5f61ee56bbd07d21c62f7f0b9d07320125d046bc8f50f
# is the WitcherPortal (the main part), where participant will try to break into the portal with little or no clue/information.
# It is OK to run this image on any random port.
#
# ---------
#
# image: sbacker/witchermesgserver@sha256:1b4cd3d801be60990641ae28a2603f7c424db4e681712f75fa6487e299d038cd
# is the WebSocket part of the WitcherPortal.
#
# The main WitcherPortal insist to stick with the below structure.
#
# http://witcherportal.domain.tld:30086
#   ws://          wsr.domain.tld:8080
#
# Where 'domain.tld' (and also 'witcherportal') can be variable (can be changed to your local needs).
# Protocol used is 'ws://'. 'wss://' is not supported.
# 'wsr' part of the domain name apparently fixed by the main WitcherPortal.
# The main WitcherPortal always redirect traffic to port 8080 (refer to the 'structure' above).
# While the WebSocket image itself can be listening at different port (in this case port 30087).
#
# Notes from others: Access must use Domain Name (websocket part of the application will break if not).
# Example, add the following example line to 'hosts' file:
# 192.168.123.201 Server1 Server1.Ubuntu
# However, my own test reveals exactly the other way around. Access with Domain Name fails, but accessing with IP Address is OK.
#
# NGINX Reverse Proxy is needed in-front for the purpose of fixing this hardwire-coded 'structure'.
# Some reference which may help:
# https://www.nginx.com/blog/websocket-nginx/
#
# ---------
#
# The three containers above can be implemented in same pod/deployment or separately each in its own pod/deployment; since there is no internal communications between those containers.
#
# ---------
#

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: f5-ctf

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: f5-ctf
  namespace: f5-ctf
spec:
  selector:
    matchLabels:
      app: f5-ctf
  replicas: 1
  template:
    metadata:
      labels:
        app: f5-ctf
    spec:
      containers:
      - name: ctfapi2
        image: sbacker/ctfapi2@sha256:128fa2fb754dcd8e962d54c2f2fb975f60fc081381454a3276525298c5b5fbd8
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8000
          protocol: TCP
          name: ctfapi2
      - name: witcherportal2
        image: sbacker/witcherportal2@sha256:8b9f0b24d974be1f8ad5f61ee56bbd07d21c62f7f0b9d07320125d046bc8f50f
        imagePullPolicy: IfNotPresent
        env:
        - name: PYTHONUNBUFFERED
          value: "1"
        ports:
        - containerPort: 80
          protocol: TCP
          name: witcherportal2
      - name: msgserver
        image: sbacker/witchermesgserver@sha256:1b4cd3d801be60990641ae28a2603f7c424db4e681712f75fa6487e299d038cd
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
          protocol: TCP
          name: msgserver

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: f5-ctf
  name: f5-ctf
  namespace: f5-ctf
spec:
  ports:
  - nodePort: 30085
    port: 8000
    protocol: TCP
    targetPort: 8000
    name: ctfapi2
  - nodePort: 30086
    port: 80
    protocol: TCP
    targetPort: 80
    name: witcherportal2
  - nodePort: 30087
    port: 8080
    protocol: TCP
    targetPort: 8080
    name: msgserver
  selector:
    app: f5-ctf
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔═════════════════╗
#║   F5-Demo-App   ║
#╚═════════════════╝

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: f5-demo-app

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: f5-demo-app
  namespace: f5-demo-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: f5-demo-app
  template:
    metadata:
      labels:
        app: f5-demo-app
    spec:
      containers:
      - name: f5-demo-app
        image: f5devcentral/f5-demo-app
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
          protocol: TCP

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: f5-demo-app
  name: f5-demo-app
  namespace: f5-demo-app
spec:
  ports:
  - nodePort: 31081
    port: 80
    protocol: TCP
    targetPort: 80
    name: http
  selector:
    app: f5-demo-app
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔═══════════════════╗
#║   F5-Demo-HTTPD   ║
#╚═══════════════════╝

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: f5-demo-httpd

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: f5-demo-httpd-orange
  namespace: f5-demo-httpd
spec:
  replicas: 1
  selector:
    matchLabels:
      app: f5-demo-httpd-orange
  template:
    metadata:
      labels:
        app: f5-demo-httpd-orange
    spec:
      containers:
      - name: f5-demo-httpd-orange
        image: f5devcentral/f5-demo-httpd:nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
        env:
        - name: F5DEMO_APP
          value: website
        - name: F5DEMO_NODENAME
          value: "The Orange F5 Demo Application"
        - name: F5DEMO_COLOR
          value: ed7b0c
        - name: F5DEMO_NODENAME_SSL
          value: "The Orange SSL F5 Demo Application (SSL)"
        - name: F5DEMO_COLOR_SSL
          value: ed7b0c
        - name: F5DEMO_BACKEND_URL
          value: "http://f5-demo-httpd-green.f5-demo-httpd.svc.cluster.local/"

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: f5-demo-httpd-orange
  name: f5-demo-httpd-orange
  namespace: f5-demo-httpd
spec:
  ports:
  - nodePort: 31082
    port: 80
    protocol: TCP
    targetPort: 80
    name: http
  selector:
    app: f5-demo-httpd-orange
  type: NodePort

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: f5-demo-httpd-green
  namespace: f5-demo-httpd
spec:
  replicas: 1
  selector:
    matchLabels:
      app: f5-demo-httpd-green
  template:
    metadata:
      labels:
        app: f5-demo-httpd-green
    spec:
      containers:
      - name: f5-demo-httpd-green
        image: f5devcentral/f5-demo-httpd:nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
        env:
        - name: F5DEMO_APP
          value: website
        - name: F5DEMO_NODENAME
          value: "The Green F5 Demo Application"
        - name: F5DEMO_COLOR
          value: a0bf37
        - name: F5DEMO_NODENAME_SSL
          value: "The Green SSL F5 Demo Application (SSL)"
        - name: F5DEMO_COLOR_SSL
          value: a0bf37
        - name: F5DEMO_BACKEND_URL
          value: "http://f5-demo-httpd-blue.f5-demo-httpd.svc.cluster.local/"

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: f5-demo-httpd-green
  name: f5-demo-httpd-green
  namespace: f5-demo-httpd
spec:
  ports:
  - nodePort: 31083
    port: 80
    protocol: TCP
    targetPort: 80
    name: http
  selector:
    app: f5-demo-httpd-green
  type: NodePort

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: f5-demo-httpd-blue
  namespace: f5-demo-httpd
spec:
  replicas: 1
  selector:
    matchLabels:
      app: f5-demo-httpd-blue
  template:
    metadata:
      labels:
        app: f5-demo-httpd-blue
    spec:
      containers:
      - name: f5-demo-httpd-blue
        image: f5devcentral/f5-demo-httpd:nginx
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
        env:
        - name: F5DEMO_APP
          value: website
        - name: F5DEMO_NODENAME
          value: "The Blue F5 Demo Application"
        - name: F5DEMO_COLOR
          value: 0194d2
        - name: F5DEMO_NODENAME_SSL
          value: "The Blue SSL F5 Demo Application (SSL)"
        - name: F5DEMO_COLOR_SSL
          value: 0194d2
        - name: F5DEMO_BACKEND_URL
          value: "http://f5-demo-httpd-orange.f5-demo-httpd.svc.cluster.local/"

---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: f5-demo-httpd-blue
  name: f5-demo-httpd-blue
  namespace: f5-demo-httpd
spec:
  ports:
  - nodePort: 31084
    port: 80
    protocol: TCP
    targetPort: 80
    name: http
  selector:
    app: f5-demo-httpd-blue
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔══════════╗
#║   Cafe   ║
#╚══════════╝

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: cafe

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: coffee
  namespace: cafe
spec:
  replicas: 2
  selector:
    matchLabels:
      app: coffee
  template:
    metadata:
      labels:
        app: coffee
    spec:
      containers:
      - name: coffee
        image: nginxdemos/nginx-hello:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080

---

apiVersion: v1
kind: Service
metadata:
  name: coffee
  namespace: cafe
spec:
  ports:
  - nodePort: 31085
    port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: coffee
  type: NodePort

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: milk
  namespace: cafe
spec:
  replicas: 2
  selector:
    matchLabels:
      app: milk
  template:
    metadata:
      labels:
        app: milk
    spec:
      containers:
      - name: milk
        image: nginxdemos/nginx-hello:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080

---

apiVersion: v1
kind: Service
metadata:
  name: milk
  namespace: cafe
spec:
  ports:
  - nodePort: 31086
    port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: milk
  type: NodePort

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: tea
  namespace: cafe
spec:
  replicas: 2
  selector:
    matchLabels:
      app: tea
  template:
    metadata:
      labels:
        app: tea
    spec:
      containers:
      - name: tea
        image: nginxdemos/nginx-hello:plain-text
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080

---

apiVersion: v1
kind: Service
metadata:
  name: tea
  namespace: cafe
spec:
  ports:
  - nodePort: 31087
    port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: tea
  type: NodePort
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

#╔═════════════╗
#║   Arcadia   ║
#╚═════════════╝

# Arcadia needs to be executed last, since it needs NGINX Ingress.
# And NGINX Ingress needs ample time (in terms of scripting) between: NGINX Ingress Controller creation, and when the Ingress object created.

# Arcadia's 'main' and 'backend' can work with only 'main' exposed to outside cluster.
# However, 'app2' and 'app3' needs Ingress to work.

# Information for implementation can be referenced from:
# https://gitlab.com/arcadia-application/ano-toolset/-/blob/master/Terraform/MainBackApp/main.tf
# https://gitlab.com/arcadia-application/ano-toolset/-/blob/master/Terraform/App2/main.tf
# https://gitlab.com/arcadia-application/ano-toolset/-/blob/master/Terraform/App3/main.tf

# https://clouddocs.f5.com/training/community/nginx/html/class5/module2/lab1/lab1.html
# Credential matt:ilovef5

kubectl apply -f - << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: arcadia

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: arcadia
  labels:
    app: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: registry.gitlab.com/arcadia-application/back-end/backend:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: backend
  namespace: arcadia
  labels:
    app: backend
    service: backend
spec:
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: backend

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: main
  namespace: arcadia
  labels:
    app: main
spec:
  replicas: 1
  selector:
    matchLabels:
      app: main
  template:
    metadata:
      labels:
        app: main
    spec:
      containers:
      - name: main
        image: registry.gitlab.com/arcadia-application/main-app/mainapp:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: main
  namespace: arcadia
  labels:
    app: main
    service: main
spec:
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: main

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: app2
  namespace: arcadia
  labels:
    app: app2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app2
  template:
    metadata:
      labels:
        app: app2
    spec:
      containers:
      - name: app2
        image: registry.gitlab.com/arcadia-application/app2/app2:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: app2
  namespace: arcadia
  labels:
    app: app2
    service: app2
spec:
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: app2

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: app3
  namespace: arcadia
  labels:
    app: app3
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app3
  template:
    metadata:
      labels:
        app: app3
    spec:
      containers:
      - name: app3
        image: registry.gitlab.com/arcadia-application/app3/app3:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: app3
  namespace: arcadia
  labels:
    app: app3
    service: app3
spec:
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: app3
EOF

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

kubectl exec -it -n arcadia $(kubectl get pods -n arcadia --no-headers=true | awk '{print $1}' | grep "main") -- ls -lap /var/www/html
kubectl exec -it -n arcadia $(kubectl get pods -n arcadia --no-headers=true | awk '{print $1}' | grep "main") -- mkdir --mode=777 --parents /var/www/html/contact
kubectl exec -it -n arcadia $(kubectl get pods -n arcadia --no-headers=true | awk '{print $1}' | grep "main") -- ls -lap /var/www/html

Loop_Period="9s"
until [ `kubectl get ingress --namespace arcadia --no-headers | grep -e "arcadia" | wc -l` -gt 0 ] ; do
kubectl apply -f - << EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: arcadia
  namespace: arcadia
spec:
  ingressClassName: nginx
  defaultBackend:
    service:
      name: main
      port:
        number: 80
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: main
            port:
              number: 80
      - path: /files
        pathType: Prefix
        backend:
          service:
            name: backend
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: app2
            port:
              number: 80
      - path: /app3
        pathType: Prefix
        backend:
          service:
            name: app3
            port:
              number: 80
EOF
 if [ `kubectl get ingress --namespace arcadia --no-headers | grep -e "arcadia" | wc -l` -gt 0 ] ; then
  echo "`date +%Y%m%d%H%M%S` Ingress creation succeed."
 else
  echo "`date +%Y%m%d%H%M%S` Ingress creation failed. Wait and Repeat."
  sleep $Loop_Period
 fi
done

#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

# Below may not be applicable for aLL cases nor future-proof
Loop_Period="9s"
Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done

kubectl get node -o wide -A
kubectl get deployment -o wide -A
kubectl get pod -o wide -A
kubectl get service -o wide -A

#╔═════════╗
#║   End   ║
#╚═════════╝
