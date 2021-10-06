##### 51 Accounts and Users

##### 52 Practice CertificateSigningRequests

##### 53 Recap

#### Section 12 Cluster Hardening Exercise caution in using ServiceAccounts
##### 54 Intro

##### 55
```sh
# from inside a Pod we can do:
cat /run/secrets/kubernetes.io/serviceaccount/token

curl https://kubernetes.default -k -H "Authorization: Bearer SA_TOKEN"
```

##### 56
https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account
##### 57
##### 58 Recap

- SA are resources with token in secret
- SAs and Pods + mounting
- Create RBAC with SAs

https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin

https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account

#### Section 13 Cluster Hardening Restrict API Access

##### 59 Intro
###### Restrict API access
- Authentication Authorization Admission
- Connect to the API in different ways
- Restrict API access in various ways

###### Request workflow

- API requests are always tied to 
  - A normal user
  - A ServiceAccount
  - Are treated as anonymous requests
- Every request must authenticate
  - Or be treated as an anonymous user

###### Restrictions

1. Don't allow anonymous access
2. Close insecure port
3. Don't expose ApiServer to the outside
4. Restrict access from Nodes to API(NodeRestriction)
5. Prevent unauthorized access(RBAC)
6. Prevent pods from accessing API
7. Apiserver port behind firewall / allowed ip ranges(cloud provider)

##### 60 Practice Anonymous Access

###### Anonymous Access

- kube-apiserver --anonymous-auth=true|false
- In 1.6+, anonymous access is enabled by default
  - if authorization mode other than AlwaysAllow
  - but ABAC and RBAC require explicit authorization for anonymous

###### Anonymous Access

**Enable/Disable anonymous access and test it **

```sh
#
cat /etc/kubernetes/manifests/kube-apiserver.yaml
----------------------------------------------------------------
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --enable-admission-plugins=NodeRestriction
----------------------------------------------------------------
root@cks-master:~# curl https://localhost:6443
----------------------------------------------------------------
curl: (60) SSL certificate problem: unable to get local issuer certificate
More details here: https://curl.haxx.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
----------------------------------------------------------------

root@cks-master:~# curl https://localhost:6443 -k
----------------------------------------------------------------
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "forbidden: User \"system:anonymous\" cannot get path \"/\"",
  "reason": "Forbidden",
  "details": {

  },
  "code": 403
}
----------------------------------------------------------------
root@cks-master:~#vim /etc/kubernetes/manifests/kube-apiserver.yaml
----------------------------------------------------------------
    - kube-apiserver
    - --anonymous-auth=true   # add this line
    - --advertise-address=10.146.0.2
    - --allow-privileged=true
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
----------------------------------------------------------------
k -n kube-system get pod | grep api
The connection to the server 10.146.0.2:6443 was refused - did you specify the right host or port?

root@cks-master:~#k -n kube-system get pod | grep api

---------------------------------------------------------------------------
kube-apiserver-cks-master            1/1     Running   0          17s
---------------------------------------------------------------------------
root@cks-master:~# curl https://localhost:6443 -k
---------------------------------------------------------------------------
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "forbidden: User \"system:anonymous\" cannot get path \"/\"",
  "reason": "Forbidden",
  "details": {

  },
  "code": 403
}
---------------------------------------------------------------------------


root@cks-master:~#vim /etc/kubernetes/manifests/kube-apiserver.yaml
----------------------------------------------------------------
    - kube-apiserver
    - --anonymous-auth=false   # change this line
----------------------------------------------------------------
root@cks-master:~# curl https://localhost:6443 -k
---------------------------------------------------------------------------
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "Unauthorized",
  "reason": "Unauthorized",
  "code": 401
}
---------------------------------------------------------------------------
root@cks-master:~#k -n kube-system get pod | grep api
---------------------------------------------------------------------------
kube-apiserver-cks-master            1/1     Running   0          2m14s
---------------------------------------------------------------------------
```

##### 61 Practice Insecure Access

Since K8S 1.20 the insecure access is not longer possible 

kube-apiserver --insecure-port=8080



###### HTTP / HTTPS Access

kubectl(client cert) ===Rquest(https)===>  API Server(server cert)

CA(scope): https,server cert, API Server



###### Insecure Access

- kube-apiserver --insecure-port=8080
  - HTTP
  - Request **bypasses** authentication and authorization modules
  - Admission controller still enforces
- Enable insecure access/port and use it

```sh
# before K8S 1.20
vim /etc/kuberntes/manifests/kube-apiserver.yaml

#before
------------------------------------------------------------------------------------------------------------------------
    - --insecure-port=0
------------------------------------------------------------------------------------------------------------------------
#after
------------------------------------------------------------------------------------------------------------------------
    - --insecure-port=8080
------------------------------------------------------------------------------------------------------------------------
```

##### 62 Practice Manual API Request

###### Send manual API request

**Let's have a look at the kubeconfig certs and perform a manual API query**

```sh
root@cks-master:~# k config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://10.146.0.2:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED

root@cks-master:~# k config view --raw
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1ESXhNakl4TVRFek1Wb1hEVE14TURJeE1ESXhNVEV6TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTk9SCjRyU3gxbzZNZ0k1L0dUQjdaNEVVck85c25OVkUwVzBFenB2aTJiMDdIRUlFSmpOMHl3QWRJby8zUVhleUVVL2cKREFhQnBKbUVBUVo5UkJUUXl2NEdVRGRoNzY3c2xmZzJabnVLczZyV0VaSDdrVXdXWERTYWVMaVA2TjBZc2U1aQpYYVhjOGlkaERLNy9UaDk1WFVheDlrY3piM0hKRFdseTJ0U3huWUZzVlIzSEhuQlBOVCtUSVFWVGsvZHpON3grCnA1QzFNWW5vaXYyTVBSekNkZEdhZkpwZ1ZyWnF6WGlncTk3eENZbXBOVS83WjYwdE1zY3ZtMGFzTTg2YXFiU1UKQ29TZ0lvbjQ3RlVIbEZyV2JWRWZzU2VKVWpRVXRCZ0pxYU1mc2Zpa1hEN3FhWndIeEM1NlZZYjlydThmVEw4SwoxSmZLWElncnNFUklwT2VzRkFzQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZMMHl6U3ZuZnl1TE82bXQzL3MzemxrcU15S05NQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFBNGR4NFNweUpqNndVdGN2QnBKSXppVGU3dVpwZVVuOUg4TE1QaUhnaGw4a1RZZnVVcgpaZEw2Q3JUb09tdFZMRUR4bFlaSmp0QVlBajF1NzF5dFM0YWJoMTNMNXJXME5IaFFKK2FjS25iRm1zc2wySzhGCm4xNXU3dE1KS1YwS0ZxVlNqK2FZbC8rWHIzTGxjdnpERjdIWDExQkM0amxsUCtTVzB2amRGK2Rudit4bEJDUW4KVm00R1h3c3NsenZ5azVrODR3elI3SkJVZVEwWk53UmQwelFrL1BFam04THJvOTVHTlFxeTdGeVdGcmRXSXZ4NApHTGVEVC9HdkdXdzFPUGJRSldLbll4YURtZ0ZBUzJZRG5sVTNHOTlWZVBmdjdoc1l5ZGxMYzJURVZldFpZYUpzCi85dmIxUWtxaWlONlNXKzBpV1haS25MVFQwem9IRSs0cG1KegotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://10.146.0.2:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURFekNDQWZ1Z0F3SUJBZ0lJUG1welZHYnExMnN3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TVRBeU1USXlNVEV4TXpGYUZ3MHlNakF5TVRJeU1URXhNelZhTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXRCUmMwblF2VCtZcGdpN1YKMG9PMUtNcUNZZVU4Q0tUd0ZNQXZhc2ducXI2dS9qV08yMlVrUUxwU2t2MXgvU09wNnFlaU91cGJuM253VHd1bwprR0ZGSW56Z1pWYXBKc0NUUVRPVjJjSmd5Z3hQNGZPYXJHV3djZGVQMHNic0VqWlNCcGs4N1N4dFIwbDEwQ3JOCjdlWUExd1F0L09iOGRoTE9JU1JWa0FoQmxRZzRKTDBFeU55YzBSL0RJWk94QmN0anJibXgwOENwVFIvSjBXL1YKU3ZOVkhTdDQwUUpxc2RVcDFFeUJ3U1JVaXdqdmFWZThGNVpUME9MYXFVcXdSbmxXN1RiYjFJNjZIRk1uRmgvbAp4M1BxNUZ5QWI2ankxdnE2a2l3RE9GWk1TVlVuOVIyS1ZUa2s3bnQ2cE5CNUVwYi9EZ2VhUGdrZVg5YytNMG1LCm5lWXB0d0lEQVFBQm8wZ3dSakFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0h3WURWUjBqQkJnd0ZvQVV2VExOSytkL0s0czdxYTNmK3pmT1dTb3pJbzB3RFFZSktvWklodmNOQVFFTApCUUFEZ2dFQkFET0YxN1FkbWdvbjlsMW1jL2QwMU40UU9WQW8rNWpob3BpL2ZoS2dNYWZQVVNVQnN4dHI2bUN1CmZIQVNEeDI1TDVWRmNVNFhoaEhnZkhPU3F2blVVanp6MFB4NTZDQitnaE5xdXdnWmtoMml5WGwxTmRRMDNTdG0KQmVwUDhyVmkrQnhwb1RCYVRsRTVWNUEzVm5xTzJIYWJtNktuTU5jOWM5L2hMdEMwbGhra3lNeEtCS1hsaVkzSAovUlRzUUF0NmxKQ1dDNDV3RWdJTUtOZ1h2ekpqVks2cWdWNUxFSzc5Zll2MkI4d2p1VlFwMWJ3SnpPbHhQN01LCkh6RmhrOHlITlBRWEtKdWh0eUV5THNoMzY2SnpaeUlVMjBzQXQ1Rytjd3JFNmw5MXFZWnVtK1dnUVdLdDg1Sm4KeWIxYUNNY3RwcHZiMktlalRqa3BVM3VwVU9NNEEwWT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb2dJQkFBS0NBUUVBdEJSYzBuUXZUK1lwZ2k3VjBvTzFLTXFDWWVVOENLVHdGTUF2YXNnbnFyNnUvaldPCjIyVWtRTHBTa3YxeC9TT3A2cWVpT3VwYm4zbndUd3Vva0dGRkluemdaVmFwSnNDVFFUT1YyY0pneWd4UDRmT2EKckdXd2NkZVAwc2JzRWpaU0Jwazg3U3h0UjBsMTBDck43ZVlBMXdRdC9PYjhkaExPSVNSVmtBaEJsUWc0SkwwRQp5TnljMFIvRElaT3hCY3RqcmJteDA4Q3BUUi9KMFcvVlN2TlZIU3Q0MFFKcXNkVXAxRXlCd1NSVWl3anZhVmU4CkY1WlQwT0xhcVVxd1JubFc3VGJiMUk2NkhGTW5GaC9seDNQcTVGeUFiNmp5MXZxNmtpd0RPRlpNU1ZVbjlSMksKVlRrazdudDZwTkI1RXBiL0RnZWFQZ2tlWDljK00wbUtuZVlwdHdJREFRQUJBb0lCQUVqeEhwQVlnN21IYnpUTwpKOG8za3ovTWwzZHoxUmRqUitQLzNMVVNFZzgxWWNpU2hTVVZHTlFuSko5cGpheU5yNXZlL3ZXQ1RFNlNvK1pBCndLeUsyZWdZVVFSN1Q5VGttRUVHMWlINGZDQWJVSmdqaG5saVQxQXRrcEk4QlE5emRWSTY2OVRkOC8yMkljU0sKTWhPMDRJNDNvVEVabHhWMGxJNFVHNXhWMjhxemRhaHhKaVdlb0x3Ty91OUhqaUlwSG13NzMrTVZPaUNsa0NnSgorT0F6RGxMemsyWFhzdE9UcWo4NHZvRXpXMmIwVWdWaTRyQXhGRjlpUEduNHJVTUtmV0xoY3E1SWx2RGY5bmo3CjF1SlZVUUNrZ2FrMWJJTXZORU95ektFRy9VSytONTFyS0ZaUURERm1ZeTlWdnNjcnMvMHQreGRkZ1ZKWnRHM3gKQVNXRmFwRUNnWUVBMVRjZmxEL0FWNHI4dFgyVjRMNGdUdFJkdjdTMlhxR0hlNG5PM3kwOGIrb2VqbGYrM3NsagpzeUpqOHpvVUVqbDVCVHR6cWUvbVNpZXc1TFYrV1pEMHpKTXU2aFdlNXFnajM2VUh1NHRrSU0zcHV2QUppMFNQCnRNc0dYM1hpblk0OWFET2Y3N2RkQmE3R2RYdUhpNXdyc2MzWXNLc0J6U2JDbXBVdGlvRmhpbHNDZ1lFQTJEY04KbTlQKzFiV3lkc0RxNnZBTnJDQWFIZjJWMTcwWGE2T00rSkJiME5UOHhPTXVBcmwrUmFoOGx0ZEgxdFBlb3RHMQpVVjVLeXh1WjlhNHBIaTVIR3psM1VESytvYktsdjNBbGRJY01kWWhkRytPVUFpeEJqMndvb0VVdlNYNlg5NmRqCk03bGhDNHJuRUtQTzFvcGJpR3BpVkdUQXJqODBQbE1DbTU2ZjVOVUNnWUFXQm5XNnFNTkR4OVhISWN3RHhXQXQKQkg4U3VLWkdMRVdFbTMzRlREVDhFcUZKYndtakZnYTRrSXJtcTA4N2VyaG5zL2FFellWcWo2TVVYVE5LS1ZGQQplTXZWM3BubGxlVHV5MnQ3RWpFcnVsbTB0K3NrZWRhbWhIcUtEZkYwK1NhYXh3cDBodXFURmJUbW1mWXNrOXRuCnFLNER3Z2FUbkxkcHBKTnB4V2ZBRlFLQmdCNlZPdkdOdlFBUm9WcTIwd1BFVE1yS0I2ZXlWTjJkTzVEWUkzcU4KUU05N01QM1FmSk9hRlVoWkdyWmpZUi83L0FQZjBkdmVrSW5HTDdMV25hNU5NWFdpWFVRVXlXNHB6TlFWVXRiMgp1MFpzc1c3ZWMvTVN1M3REKzBNZ1JoNEpNQW14dlpCMWFrcXRyUjFuYmp4ZWViQUVERUNQdDhsdDJ6L3RrZkxkCkx4UzVBb0dBVG9DVFlxSGFkT1RNRzRaL3NsNm1OSm4yMGdIR2toU2lFQzcxVUV4Z3pYNW1kYXlDMVphZWR0YXkKbUtiVGh2WE56eXd1OThDdnIyNjJGYUlXUjlWcE1yQTUzSXJpd2s4ZjBSSnhoTnptWm9jYXJrNkxkTjEvbUNLaQpYMjB3UVNVV2pZTlZNYTNYcnJOWjhPZjdOR2RWYXRkNUNsOHVNblJZbWVTY05lakljbzQ9Ci0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==


#check the kubw config fiel
vim .kubw/config

# copy certificate-authority-data
root@cks-master:~# echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1ESXhNakl4TVRFek1Wb1hEVE14TURJeE1ESXhNVEV6TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTk9SCjRyU3gxbzZNZ0k1L0dUQjdaNEVVck85c25OVkUwVzBFenB2aTJiMDdIRUlFSmpOMHl3QWRJby8zUVhleUVVL2cKREFhQnBKbUVBUVo5UkJUUXl2NEdVRGRoNzY3c2xmZzJabnVLczZyV0VaSDdrVXdXWERTYWVMaVA2TjBZc2U1aQpYYVhjOGlkaERLNy9UaDk1WFVheDlrY3piM0hKRFdseTJ0U3huWUZzVlIzSEhuQlBOVCtUSVFWVGsvZHpON3grCnA1QzFNWW5vaXYyTVBSekNkZEdhZkpwZ1ZyWnF6WGlncTk3eENZbXBOVS83WjYwdE1zY3ZtMGFzTTg2YXFiU1UKQ29TZ0lvbjQ3RlVIbEZyV2JWRWZzU2VKVWpRVXRCZ0pxYU1mc2Zpa1hEN3FhWndIeEM1NlZZYjlydThmVEw4SwoxSmZLWElncnNFUklwT2VzRkFzQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZMMHl6U3ZuZnl1TE82bXQzL3MzemxrcU15S05NQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFBNGR4NFNweUpqNndVdGN2QnBKSXppVGU3dVpwZVVuOUg4TE1QaUhnaGw4a1RZZnVVcgpaZEw2Q3JUb09tdFZMRUR4bFlaSmp0QVlBajF1NzF5dFM0YWJoMTNMNXJXME5IaFFKK2FjS25iRm1zc2wySzhGCm4xNXU3dE1KS1YwS0ZxVlNqK2FZbC8rWHIzTGxjdnpERjdIWDExQkM0amxsUCtTVzB2amRGK2Rudit4bEJDUW4KVm00R1h3c3NsenZ5azVrODR3elI3SkJVZVEwWk53UmQwelFrL1BFam04THJvOTVHTlFxeTdGeVdGcmRXSXZ4NApHTGVEVC9HdkdXdzFPUGJRSldLbll4YURtZ0ZBUzJZRG5sVTNHOTlWZVBmdjdoc1l5ZGxMYzJURVZldFpZYUpzCi85dmIxUWtxaWlONlNXKzBpV1haS25MVFQwem9IRSs0cG1KegotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg== | base64 -d
-----BEGIN CERTIFICATE-----
MIIC5zCCAc+gAwIBAgIBADANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwprdWJl
cm5ldGVzMB4XDTIxMDIxMjIxMTEzMVoXDTMxMDIxMDIxMTEzMVowFTETMBEGA1UE
AxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANOR
4rSx1o6MgI5/GTB7Z4EUrO9snNVE0W0Ezpvi2b07HEIEJjN0ywAdIo/3QXeyEU/g
DAaBpJmEAQZ9RBTQyv4GUDdh767slfg2ZnuKs6rWEZH7kUwWXDSaeLiP6N0Yse5i
XaXc8idhDK7/Th95XUax9kczb3HJDWly2tSxnYFsVR3HHnBPNT+TIQVTk/dzN7x+
p5C1MYnoiv2MPRzCddGafJpgVrZqzXigq97xCYmpNU/7Z60tMscvm0asM86aqbSU
CoSgIon47FUHlFrWbVEfsSeJUjQUtBgJqaMfsfikXD7qaZwHxC56VYb9ru8fTL8K
1JfKXIgrsERIpOesFAsCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgKkMA8GA1UdEwEB
/wQFMAMBAf8wHQYDVR0OBBYEFL0yzSvnfyuLO6mt3/s3zlkqMyKNMA0GCSqGSIb3
DQEBCwUAA4IBAQA4dx4SpyJj6wUtcvBpJIziTe7uZpeUn9H8LMPiHghl8kTYfuUr
ZdL6CrToOmtVLEDxlYZJjtAYAj1u71ytS4abh13L5rW0NHhQJ+acKnbFmssl2K8F
n15u7tMJKV0KFqVSj+aYl/+Xr3LlcvzDF7HX11BC4jllP+SW0vjdF+dnv+xlBCQn
Vm4GXwsslzvyk5k84wzR7JBUeQ0ZNwRd0zQk/PEjm8Lro95GNQqy7FyWFrdWIvx4
GLeDT/GvGWw1OPbQJWKnYxaDmgFAS2YDnlU3G99VePfv7hsYydlLc2TEVetZYaJs
/9vb1QkqiiN6SW+0iWXZKnLTT0zoHE+4pmJz
-----END CERTIFICATE-----
# copy certificate-authority-data
root@cks-master:~# echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1ESXhNakl4TVRFek1Wb1hEVE14TURJeE1ESXhNVEV6TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTk9SCjRyU3gxbzZNZ0k1L0dUQjdaNEVVck85c25OVkUwVzBFenB2aTJiMDdIRUlFSmpOMHl3QWRJby8zUVhleUVVL2cKREFhQnBKbUVBUVo5UkJUUXl2NEdVRGRoNzY3c2xmZzJabnVLczZyV0VaSDdrVXdXWERTYWVMaVA2TjBZc2U1aQpYYVhjOGlkaERLNy9UaDk1WFVheDlrY3piM0hKRFdseTJ0U3huWUZzVlIzSEhuQlBOVCtUSVFWVGsvZHpON3grCnA1QzFNWW5vaXYyTVBSekNkZEdhZkpwZ1ZyWnF6WGlncTk3eENZbXBOVS83WjYwdE1zY3ZtMGFzTTg2YXFiU1UKQ29TZ0lvbjQ3RlVIbEZyV2JWRWZzU2VKVWpRVXRCZ0pxYU1mc2Zpa1hEN3FhWndIeEM1NlZZYjlydThmVEw4SwoxSmZLWElncnNFUklwT2VzRkFzQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZMMHl6U3ZuZnl1TE82bXQzL3MzemxrcU15S05NQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFBNGR4NFNweUpqNndVdGN2QnBKSXppVGU3dVpwZVVuOUg4TE1QaUhnaGw4a1RZZnVVcgpaZEw2Q3JUb09tdFZMRUR4bFlaSmp0QVlBajF1NzF5dFM0YWJoMTNMNXJXME5IaFFKK2FjS25iRm1zc2wySzhGCm4xNXU3dE1KS1YwS0ZxVlNqK2FZbC8rWHIzTGxjdnpERjdIWDExQkM0amxsUCtTVzB2amRGK2Rudit4bEJDUW4KVm00R1h3c3NsenZ5azVrODR3elI3SkJVZVEwWk53UmQwelFrL1BFam04THJvOTVHTlFxeTdGeVdGcmRXSXZ4NApHTGVEVC9HdkdXdzFPUGJRSldLbll4YURtZ0ZBUzJZRG5sVTNHOTlWZVBmdjdoc1l5ZGxMYzJURVZldFpZYUpzCi85dmIxUWtxaWlONlNXKzBpV1haS25MVFQwem9IRSs0cG1KegotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg== | base64 -d > ca

#client-certificate-data
root@cks-master:~# echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURFekNDQWZ1Z0F3SUJBZ0lJUG1welZHYnExMnN3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TVRBeU1USXlNVEV4TXpGYUZ3MHlNakF5TVRJeU1URXhNelZhTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXRCUmMwblF2VCtZcGdpN1YKMG9PMUtNcUNZZVU4Q0tUd0ZNQXZhc2ducXI2dS9qV08yMlVrUUxwU2t2MXgvU09wNnFlaU91cGJuM253VHd1bwprR0ZGSW56Z1pWYXBKc0NUUVRPVjJjSmd5Z3hQNGZPYXJHV3djZGVQMHNic0VqWlNCcGs4N1N4dFIwbDEwQ3JOCjdlWUExd1F0L09iOGRoTE9JU1JWa0FoQmxRZzRKTDBFeU55YzBSL0RJWk94QmN0anJibXgwOENwVFIvSjBXL1YKU3ZOVkhTdDQwUUpxc2RVcDFFeUJ3U1JVaXdqdmFWZThGNVpUME9MYXFVcXdSbmxXN1RiYjFJNjZIRk1uRmgvbAp4M1BxNUZ5QWI2ankxdnE2a2l3RE9GWk1TVlVuOVIyS1ZUa2s3bnQ2cE5CNUVwYi9EZ2VhUGdrZVg5YytNMG1LCm5lWXB0d0lEQVFBQm8wZ3dSakFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0h3WURWUjBqQkJnd0ZvQVV2VExOSytkL0s0czdxYTNmK3pmT1dTb3pJbzB3RFFZSktvWklodmNOQVFFTApCUUFEZ2dFQkFET0YxN1FkbWdvbjlsMW1jL2QwMU40UU9WQW8rNWpob3BpL2ZoS2dNYWZQVVNVQnN4dHI2bUN1CmZIQVNEeDI1TDVWRmNVNFhoaEhnZkhPU3F2blVVanp6MFB4NTZDQitnaE5xdXdnWmtoMml5WGwxTmRRMDNTdG0KQmVwUDhyVmkrQnhwb1RCYVRsRTVWNUEzVm5xTzJIYWJtNktuTU5jOWM5L2hMdEMwbGhra3lNeEtCS1hsaVkzSAovUlRzUUF0NmxKQ1dDNDV3RWdJTUtOZ1h2ekpqVks2cWdWNUxFSzc5Zll2MkI4d2p1VlFwMWJ3SnpPbHhQN01LCkh6RmhrOHlITlBRWEtKdWh0eUV5THNoMzY2SnpaeUlVMjBzQXQ1Rytjd3JFNmw5MXFZWnVtK1dnUVdLdDg1Sm4KeWIxYUNNY3RwcHZiMktlalRqa3BVM3VwVU9NNEEwWT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo= | base64 -d > crt

#client-key-data
root@cks-master:~# echo LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb2dJQkFBS0NBUUVBdEJSYzBuUXZUK1lwZ2k3VjBvTzFLTXFDWWVVOENLVHdGTUF2YXNnbnFyNnUvaldPCjIyVWtRTHBTa3YxeC9TT3A2cWVpT3VwYm4zbndUd3Vva0dGRkluemdaVmFwSnNDVFFUT1YyY0pneWd4UDRmT2EKckdXd2NkZVAwc2JzRWpaU0Jwazg3U3h0UjBsMTBDck43ZVlBMXdRdC9PYjhkaExPSVNSVmtBaEJsUWc0SkwwRQp5TnljMFIvRElaT3hCY3RqcmJteDA4Q3BUUi9KMFcvVlN2TlZIU3Q0MFFKcXNkVXAxRXlCd1NSVWl3anZhVmU4CkY1WlQwT0xhcVVxd1JubFc3VGJiMUk2NkhGTW5GaC9seDNQcTVGeUFiNmp5MXZxNmtpd0RPRlpNU1ZVbjlSMksKVlRrazdudDZwTkI1RXBiL0RnZWFQZ2tlWDljK00wbUtuZVlwdHdJREFRQUJBb0lCQUVqeEhwQVlnN21IYnpUTwpKOG8za3ovTWwzZHoxUmRqUitQLzNMVVNFZzgxWWNpU2hTVVZHTlFuSko5cGpheU5yNXZlL3ZXQ1RFNlNvK1pBCndLeUsyZWdZVVFSN1Q5VGttRUVHMWlINGZDQWJVSmdqaG5saVQxQXRrcEk4QlE5emRWSTY2OVRkOC8yMkljU0sKTWhPMDRJNDNvVEVabHhWMGxJNFVHNXhWMjhxemRhaHhKaVdlb0x3Ty91OUhqaUlwSG13NzMrTVZPaUNsa0NnSgorT0F6RGxMemsyWFhzdE9UcWo4NHZvRXpXMmIwVWdWaTRyQXhGRjlpUEduNHJVTUtmV0xoY3E1SWx2RGY5bmo3CjF1SlZVUUNrZ2FrMWJJTXZORU95ektFRy9VSytONTFyS0ZaUURERm1ZeTlWdnNjcnMvMHQreGRkZ1ZKWnRHM3gKQVNXRmFwRUNnWUVBMVRjZmxEL0FWNHI4dFgyVjRMNGdUdFJkdjdTMlhxR0hlNG5PM3kwOGIrb2VqbGYrM3NsagpzeUpqOHpvVUVqbDVCVHR6cWUvbVNpZXc1TFYrV1pEMHpKTXU2aFdlNXFnajM2VUh1NHRrSU0zcHV2QUppMFNQCnRNc0dYM1hpblk0OWFET2Y3N2RkQmE3R2RYdUhpNXdyc2MzWXNLc0J6U2JDbXBVdGlvRmhpbHNDZ1lFQTJEY04KbTlQKzFiV3lkc0RxNnZBTnJDQWFIZjJWMTcwWGE2T00rSkJiME5UOHhPTXVBcmwrUmFoOGx0ZEgxdFBlb3RHMQpVVjVLeXh1WjlhNHBIaTVIR3psM1VESytvYktsdjNBbGRJY01kWWhkRytPVUFpeEJqMndvb0VVdlNYNlg5NmRqCk03bGhDNHJuRUtQTzFvcGJpR3BpVkdUQXJqODBQbE1DbTU2ZjVOVUNnWUFXQm5XNnFNTkR4OVhISWN3RHhXQXQKQkg4U3VLWkdMRVdFbTMzRlREVDhFcUZKYndtakZnYTRrSXJtcTA4N2VyaG5zL2FFellWcWo2TVVYVE5LS1ZGQQplTXZWM3BubGxlVHV5MnQ3RWpFcnVsbTB0K3NrZWRhbWhIcUtEZkYwK1NhYXh3cDBodXFURmJUbW1mWXNrOXRuCnFLNER3Z2FUbkxkcHBKTnB4V2ZBRlFLQmdCNlZPdkdOdlFBUm9WcTIwd1BFVE1yS0I2ZXlWTjJkTzVEWUkzcU4KUU05N01QM1FmSk9hRlVoWkdyWmpZUi83L0FQZjBkdmVrSW5HTDdMV25hNU5NWFdpWFVRVXlXNHB6TlFWVXRiMgp1MFpzc1c3ZWMvTVN1M3REKzBNZ1JoNEpNQW14dlpCMWFrcXRyUjFuYmp4ZWViQUVERUNQdDhsdDJ6L3RrZkxkCkx4UzVBb0dBVG9DVFlxSGFkT1RNRzRaL3NsNm1OSm4yMGdIR2toU2lFQzcxVUV4Z3pYNW1kYXlDMVphZWR0YXkKbUtiVGh2WE56eXd1OThDdnIyNjJGYUlXUjlWcE1yQTUzSXJpd2s4ZjBSSnhoTnptWm9jYXJrNkxkTjEvbUNLaQpYMjB3UVNVV2pZTlZNYTNYcnJOWjhPZjdOR2RWYXRkNUNsOHVNblJZbWVTY05lakljbzQ9Ci0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg== | base64 -d > key

root@cks-master:~# k config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://10.146.0.2:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED

# get server url
root@cks-master:~# k config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://10.146.0.2:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED

root@cks-master:~# curl https://10.146.0.2:6443
curl: (60) SSL certificate problem: unable to get local issuer certificate
More details here: https://curl.haxx.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.



root@cks-master:~# curl https://10.146.0.2:6443 --cacert ca
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "forbidden: User \"system:anonymous\" cannot get path \"/\"",
  "reason": "Forbidden",
  "details": {

  },
  "code": 403
}

root@cks-master:~# curl https://10.146.0.2:6443 --cacert ca --cert crt
curl: (58) unable to set private key file: 'crt' type PEM

# get api info
root@cks-master:~# curl https://10.146.0.2:6443 --cacert ca --cert crt --key key{
  "paths": [
    "/.well-known/openid-configuration",
    "/api",
    "/api/v1",
    "/apis",
    "/apis/",
    "/apis/admissionregistration.k8s.io",
    "/apis/admissionregistration.k8s.io/v1",
    "/apis/admissionregistration.k8s.io/v1beta1",
    "/apis/apiextensions.k8s.io",
    "/apis/apiextensions.k8s.io/v1",
    "/apis/apiextensions.k8s.io/v1beta1",
    "/apis/apiregistration.k8s.io",
    "/apis/apiregistration.k8s.io/v1",
    "/apis/apiregistration.k8s.io/v1beta1",
    "/apis/apps",
    "/apis/apps/v1",
    "/apis/authentication.k8s.io",
    "/apis/authentication.k8s.io/v1",
    "/apis/authentication.k8s.io/v1beta1",
    "/apis/authorization.k8s.io",
    "/apis/authorization.k8s.io/v1",
    "/apis/authorization.k8s.io/v1beta1",
    "/apis/autoscaling",
    "/apis/autoscaling/v1",
    "/apis/autoscaling/v2beta1",
    "/apis/autoscaling/v2beta2",
    "/apis/batch",
    "/apis/batch/v1",
    "/apis/batch/v1beta1",
    "/apis/certificates.k8s.io",
    "/apis/certificates.k8s.io/v1",
    "/apis/certificates.k8s.io/v1beta1",
    "/apis/coordination.k8s.io",
    "/apis/coordination.k8s.io/v1",
    "/apis/coordination.k8s.io/v1beta1",
    "/apis/discovery.k8s.io",
    "/apis/discovery.k8s.io/v1beta1",
    "/apis/events.k8s.io",
    "/apis/events.k8s.io/v1",
    "/apis/events.k8s.io/v1beta1",
    "/apis/extensions",
    "/apis/extensions/v1beta1",
    "/apis/flowcontrol.apiserver.k8s.io",
    "/apis/flowcontrol.apiserver.k8s.io/v1beta1",
    "/apis/networking.k8s.io",
    "/apis/networking.k8s.io/v1",
    "/apis/networking.k8s.io/v1beta1",
    "/apis/node.k8s.io",
    "/apis/node.k8s.io/v1",
    "/apis/node.k8s.io/v1beta1",
    "/apis/policy",
    "/apis/policy/v1beta1",
    "/apis/rbac.authorization.k8s.io",
    "/apis/rbac.authorization.k8s.io/v1",
    "/apis/rbac.authorization.k8s.io/v1beta1",
    "/apis/scheduling.k8s.io",
    "/apis/scheduling.k8s.io/v1",
    "/apis/scheduling.k8s.io/v1beta1",
    "/apis/storage.k8s.io",
    "/apis/storage.k8s.io/v1",
    "/apis/storage.k8s.io/v1beta1",
    "/healthz",
    "/healthz/autoregister-completion",
    "/healthz/etcd",
    "/healthz/log",
    "/healthz/ping",
    "/healthz/poststarthook/aggregator-reload-proxy-client-cert",
    "/healthz/poststarthook/apiservice-openapi-controller",
    "/healthz/poststarthook/apiservice-registration-controller",
    "/healthz/poststarthook/apiservice-status-available-controller",
    "/healthz/poststarthook/bootstrap-controller",
    "/healthz/poststarthook/crd-informer-synced",
    "/healthz/poststarthook/generic-apiserver-start-informers",
    "/healthz/poststarthook/kube-apiserver-autoregistration",
    "/healthz/poststarthook/priority-and-fairness-config-consumer",
    "/healthz/poststarthook/priority-and-fairness-config-producer",
    "/healthz/poststarthook/priority-and-fairness-filter",
    "/healthz/poststarthook/rbac/bootstrap-roles",
    "/healthz/poststarthook/scheduling/bootstrap-system-priority-classes",
    "/healthz/poststarthook/start-apiextensions-controllers",
    "/healthz/poststarthook/start-apiextensions-informers",
    "/healthz/poststarthook/start-cluster-authentication-info-controller",
    "/healthz/poststarthook/start-kube-aggregator-informers",
    "/healthz/poststarthook/start-kube-apiserver-admission-initializer",
    "/livez",
    "/livez/autoregister-completion",
    "/livez/etcd",
    "/livez/log",
    "/livez/ping",
    "/livez/poststarthook/aggregator-reload-proxy-client-cert",
    "/livez/poststarthook/apiservice-openapi-controller",
    "/livez/poststarthook/apiservice-registration-controller",
    "/livez/poststarthook/apiservice-status-available-controller",
    "/livez/poststarthook/bootstrap-controller",
    "/livez/poststarthook/crd-informer-synced",
    "/livez/poststarthook/generic-apiserver-start-informers",
    "/livez/poststarthook/kube-apiserver-autoregistration",
    "/livez/poststarthook/priority-and-fairness-config-consumer",
    "/livez/poststarthook/priority-and-fairness-config-producer",
    "/livez/poststarthook/priority-and-fairness-filter",
    "/livez/poststarthook/rbac/bootstrap-roles",
    "/livez/poststarthook/scheduling/bootstrap-system-priority-classes",
    "/livez/poststarthook/start-apiextensions-controllers",
    "/livez/poststarthook/start-apiextensions-informers",
    "/livez/poststarthook/start-cluster-authentication-info-controller",
    "/livez/poststarthook/start-kube-aggregator-informers",
    "/livez/poststarthook/start-kube-apiserver-admission-initializer",
    "/logs",
    "/metrics",
    "/openapi/v2",
    "/openid/v1/jwks",
    "/readyz",
    "/readyz/autoregister-completion",
    "/readyz/etcd",
    "/readyz/informer-sync",
    "/readyz/log",
    "/readyz/ping",
    "/readyz/poststarthook/aggregator-reload-proxy-client-cert",
    "/readyz/poststarthook/apiservice-openapi-controller",
    "/readyz/poststarthook/apiservice-registration-controller",
    "/readyz/poststarthook/apiservice-status-available-controller",
    "/readyz/poststarthook/bootstrap-controller",
    "/readyz/poststarthook/crd-informer-synced",
    "/readyz/poststarthook/generic-apiserver-start-informers",
    "/readyz/poststarthook/kube-apiserver-autoregistration",
    "/readyz/poststarthook/priority-and-fairness-config-consumer",
    "/readyz/poststarthook/priority-and-fairness-config-producer",
    "/readyz/poststarthook/priority-and-fairness-filter",
    "/readyz/poststarthook/rbac/bootstrap-roles",
    "/readyz/poststarthook/scheduling/bootstrap-system-priority-classes",
    "/readyz/poststarthook/start-apiextensions-controllers",
    "/readyz/poststarthook/start-apiextensions-informers",
    "/readyz/poststarthook/start-cluster-authentication-info-controller",
    "/readyz/poststarthook/start-kube-aggregator-informers",
    "/readyz/poststarthook/start-kube-apiserver-admission-initializer",
    "/readyz/shutdown",
    "/version"
  ]
}

```

##### 63 Practice External Apiserver Access

###### Send API request from outside

**Make Kuberntes API reachable from the outside**

access using kubectl (copy kubeconfig)



kubectl(client cert) ===Rquest(https)===>  API Server(server cert)

CA(scope): https,server cert, API Server



```sh
root@cks-master:~# k get svc | grep kubernetes
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP   23d


root@cks-master:~# k edit svc kubernetes
# before
------------------------
  type: ClusterIP
------------------------  
#after
------------------------  
  type: NodePort
------------------------

root@cks-master:~# k get svc | grep kubernetes
kubernetes   NodePort    10.96.0.1        <none>        443:31234/TCP   23d


# from master node
k config view --raw > conf

# inspect apiserver cert
cd /etc/kubernetes/pki
openssl x509 -in apiserver.crt -text




# copy conf file to local server
# from local server
k --kubeconfig conf get ns

#add the ip to hosts
sudo vim /etc/hosts
$wokers externalIP kubernetes

#change ExternalIP to kubernetes
vim conf

k --kubeconfig conf get ns

```

##### 64 NodeRestriction AdmissionController

- Admission Controller
  - kube-apiserver --enable-admission-plugins=NodeRestriction
  - Limits the Node labels a kubelet can modify
- Ensure secure workload isolation via labels
  - No one can pretend to be a "secure" node and schedule secure pods(why?)

##### 65 Practice Verify NodeRestriction

###### NodeRestriction in action

**Verify the NodeRestriciton works**

Use worker node kubelet kubeconfig to set labels

```sh
root@cks-master:~# cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep admission
    - --enable-admission-plugins=NodeRestriction



root@cks-worker:~# k config view
apiVersion: v1
clusters: null
contexts: null
current-context: ""
kind: Config
preferences: {}
users: null

root@cks-worker:~# export KUBECONFIG=/etc/kubernetes/kubelet.conf
root@cks-worker:~# k get ns
Error from server (Forbidden): namespaces is forbidden: User "system:node:cks-worker" cannot list resource "namespaces" in API group "" at the cluster scope


root@cks-worker:~# k label node cks-master cks/test=yes
Error from server (Forbidden): nodes "cks-master" is forbidden: node "cks-worker" is not allowed to modify node "cks-master"

root@cks-worker:~# k label node cks-worker cks/test=yes
node/cks-worker labeled


root@cks-worker:~# k label node cks-worker node-restriction.kubernetes.io/test=yes
Error from server (Forbidden): nodes "cks-worker" is forbidden: is not allowed to modify labels: node-restriction.kubernetes.io/test

```



##### 66 Recap

- Outside -> API
- Pod -> API
- Node -> API
- Anonymous access
- Insecure access
- Certificates

[Controlling Access to the Kubernetes API](https://kubernetes.io/docs/concepts/security/controlling-access)

#### Section 14 Cluster Hardening Upgrade Kubernetes

##### 67 Intro

###### Why Update Kubernetes Frequently

- Release Cycles
- Version differences of components
- Upgrade

###### Why upgrade frequently

- Support
- Security fixes
- Bug fixes
- Stay up to date for dependencies

###### Kubernetes Release Cycles

major.minor.patch => 1.19.2

- Minor version every 3 months
- No LTS(Long Term Support)

###### Support

> Maintenance release branches for the most recent three minor releases(1.19,1.18,1.17)

Applicable fixes,including security fixes, may be backported to those three release branches, 

depending on severity and feasibility.

###### How to upgrade a cluster

- First upgrade the master components
  - apiserver,controller-manager,scheduler
- Then the worker components
  - kubelet,kube-proxy
- Components same minor version as apiserver

###### Possible Version Differences

###### Sequence

| Version |           |           |                    |
| ------- | --------- | --------- | ------------------ |
| 1.19    |           |           |                    |
| 1.18    |           |           |                    |
| 1.17    | Apiserver | Scheduler | Controller-Manager |

| Version |           |           |                    |
| ------- | --------- | --------- | ------------------ |
| 1.19    |           |           |                    |
| 1.18    |     Apiserver      |           |                    |
| 1.17    |  | Scheduler | Controller-Manager |

| Version |           |           |                    |
| ------- | --------- | --------- | ------------------ |
| 1.19    |           |           |                    |
| 1.18    |  Apiserver         |    Scheduler       |                    |
| 1.17    |  |  | Controller-Manager |


| Version |           |           |                    |
| ------- | --------- | --------- | ------------------ |
| 1.19    |           |           |                    |
| 1.18    |  Apiserver         |    Scheduler       |  Controller-Manager                  |
| 1.17    |  |  |  |


| Version |           |           |                    |                    |  |
| ------- | --------- | --------- | ------------------ | ------------------ | ------------------ |
| 1.19    |           |           |                    |                    | kubectl |
| 1.18    |  Apiserver         |    Scheduler       |  Controller-Manager                  |                    |                    |
| 1.17    |  |  |  | Kubelet Kube-Proxy |  |

| Version |           |           |                    |                    |  |
| ------- | --------- | --------- | ------------------ | ------------------ | ------------------ |
| 1.19    | Apiserver | Scheduler | Controller-Manager |                    | kubectl |
| 1.18    |           |           |                    |                    |                    |
| 1.17    |  |  |  | Kubelet Kube-Proxy |  |


| Version |           |           |                    |                    |  |
| ------- | --------- | --------- | ------------------ | ------------------ | ------------------ |
| 1.19    | Apiserver | Scheduler | Controller-Manager |                    | kubectl |
| 1.18    |           |           |                    | Kubelet Kube-Proxy |                    |
| 1.17    |  |  |  |  |  |



| Version |           |           |                    |                    |  |
| ------- | --------- | --------- | ------------------ | ------------------ | ------------------ |
| 1.19    | Apiserver | Scheduler | Controller-Manager | Kubelet Kube-Proxy | kubectl |
| 1.18    |           |           |                    |  |                    |
| 1.17    |  |  |  |  |  |
##### Version differences - Rule of thumb

**Components same minor version as apiserver or one below**

###### How to upgrade a node

1. kubectl drain(排出)
   - Safety evict all pods from node
   - Mark node as SchedulingDisabled(kubectl cordon(包围隔离))
2. Do the upgrade
3. kubectl uncordon
   - Unmark（去掉标记） node as SchedulingDisabled

###### How to make your application survive(幸存) an upgrade

- Pod gracePeriod / Terminating state
- Pod Lifecycle Events
- PodDisruptionBudget(破坏预算)

##### 68. Practice Create outdated cluster

###### Create an outdated cluster

**Install an earlier version of k8s in our cluster**



```sh
# master
bash <(curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/previous/install_master.sh)

# worker
bash <(curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/previous/install_worker.sh)

#copy to worker and excute
kubeadm join 10.146.0.2:6443 --token $token     --discovery-token-ca-cert-hash $sha256


root@cks-master:~# kubectl get nodes
NAME         STATUS   ROLES    AGE   VERSION
cks-master   Ready    master   95s   v1.19.7
cks-worker   Ready    <none>   14s   v1.19.7

```

##### 69 Practice Upgrade master node

###### Upgrade a cluster

**Upgrade the master to one minor version up**

```sh
# get error
root@cks-master:~# k drain cks-master
node/cks-master cordoned
error: unable to drain node "cks-master", aborting command...

There are pending nodes to be drained:
 cks-master
error: cannot delete DaemonSet-managed Pods (use --ignore-daemonsets to ignore): kube-system/kube-proxy-hkg42, kube-system/weave-net-d56rj


root@cks-master:~# k drain cks-master --ignore-daemonsets
node/cks-master already cordoned
WARNING: ignoring DaemonSet-managed Pods: kube-system/kube-proxy-hkg42, kube-system/weave-net-d56rj
evicting pod kube-system/coredns-f9fd979d6-f7sc6
evicting pod kube-system/coredns-f9fd979d6-4p45l
pod/coredns-f9fd979d6-f7sc6 evicted
pod/coredns-f9fd979d6-4p45l evicted
node/cks-master evicted


root@cks-master:~# k get node
NAME         STATUS                     ROLES    AGE     VERSION
cks-master   Ready,SchedulingDisabled   master   6m47s   v1.19.7
cks-worker   Ready                      <none>   5m26s   v1.19.7


root@cks-master:~# apt-cache show kubeadm  | grep 1.20
Version: 1.20.4-00
Filename: pool/kubeadm_1.20.4-00_amd64_27807dfe9734d69677bc6a0a8daf84042d51ee42a984f9181d3c91cc037d19ce.deb
Version: 1.20.2-00
Filename: pool/kubeadm_1.20.2-00_amd64_38fa4593055ef1161d4cb322437eedda95186fb850819421b8cf75f3a943dc51.deb
Version: 1.20.1-00
Filename: pool/kubeadm_1.20.1-00_amd64_7cd8d4021bb251862b755ed9c240091a532b89e6c796d58c3fdea7c9a72b878f.deb
Version: 1.20.0-00
Filename: pool/kubeadm_1.20.0-00_amd64_18afc5e3855cf5aaef0dbdfd1b3304f9e8e571b3c4e43b5dc97c439d62a3321a.deb
Size: 8152068
Filename: pool/kubeadm_1.5.7-00_amd64_2759fc99e5b23e44c92b44c506ed9cc1c2087780786bfa97c715da02da84c55d.deb
SHA256: 2759fc99e5b23e44c92b44c506ed9cc1c2087780786bfa97c715da02da84c55d

root@cks-master:~# apt-get install kubeadm=1.20.2-00 kubelet=1.20.2-00 kubectl=1.20.2-00
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm kubectl kubelet
3 upgraded, 0 newly installed, 0 to remove and 14 not upgraded.
Need to get 0 B/34.5 MB of archives.
After this operation, 1517 kB of additional disk space will be used.
(Reading database ... 106960 files and directories currently installed.)
Preparing to unpack .../kubelet_1.20.2-00_amd64.deb ...
Unpacking kubelet (1.20.2-00) over (1.19.7-00) ...
Preparing to unpack .../kubectl_1.20.2-00_amd64.deb ...
Unpacking kubectl (1.20.2-00) over (1.19.7-00) ...
Preparing to unpack .../kubeadm_1.20.2-00_amd64.deb ...
Unpacking kubeadm (1.20.2-00) over (1.19.7-00) ...
Setting up kubelet (1.20.2-00) ...
Setting up kubectl (1.20.2-00) ...
Setting up kubeadm (1.20.2-00) ...


root@cks-master:~# kubeadm upgrade plan
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: v1.19.7
[upgrade/versions] kubeadm version: v1.20.2
[upgrade/versions] Latest stable version: v1.20.4
[upgrade/versions] Latest stable version: v1.20.4
[upgrade/versions] Latest version in the v1.19 series: v1.19.8
[upgrade/versions] Latest version in the v1.19 series: v1.19.8

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   CURRENT       AVAILABLE
kubelet     1 x v1.19.7   v1.19.8
            1 x v1.20.2   v1.19.8

Upgrade to the latest version in the v1.19 series:

COMPONENT                 CURRENT    AVAILABLE
kube-apiserver            v1.19.7    v1.19.8
kube-controller-manager   v1.19.7    v1.19.8
kube-scheduler            v1.19.7    v1.19.8
kube-proxy                v1.19.7    v1.19.8
CoreDNS                   1.7.0      1.7.0
etcd                      3.4.13-0   3.4.13-0

You can now apply the upgrade by executing the following command:

        kubeadm upgrade apply v1.19.8

_____________________________________________________________________

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   CURRENT       AVAILABLE
kubelet     1 x v1.19.7   v1.20.4
            1 x v1.20.2   v1.20.4

Upgrade to the latest stable version:

COMPONENT                 CURRENT    AVAILABLE
kube-apiserver            v1.19.7    v1.20.4
kube-controller-manager   v1.19.7    v1.20.4
kube-scheduler            v1.19.7    v1.20.4
kube-proxy                v1.19.7    v1.20.4
CoreDNS                   1.7.0      1.7.0
etcd                      3.4.13-0   3.4.13-0

You can now apply the upgrade by executing the following command:

        kubeadm upgrade apply v1.20.4

Note: Before you can perform this upgrade, you have to update kubeadm to v1.20.4.

_____________________________________________________________________


The table below shows the current state of component configs as understood by this version of kubeadm.
Configs that have a "yes" mark in the "MANUAL UPGRADE REQUIRED" column require manual config upgrade or
resetting to kubeadm defaults before a successful upgrade can be performed. The version to manually
upgrade to is denoted in the "PREFERRED VERSION" column.

API GROUP                 CURRENT VERSION   PREFERRED VERSION   MANUAL UPGRADE REQUIRED
kubeproxy.config.k8s.io   v1alpha1          v1alpha1            no
kubelet.config.k8s.io     v1beta1           v1beta1             no
_____________________________________________________________________


root@cks-master:~#kubeadm upgrade apply v1.20.2
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade/version] You have chosen to change the cluster version to "v1.20.2"
[upgrade/versions] Cluster version: v1.19.7
[upgrade/versions] kubeadm version: v1.20.2
[upgrade/confirm] Are you sure you want to proceed with the upgrade? [y/N]: y
[upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
[upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
[upgrade/prepull] You can also perform this action in beforehand using 'kubeadm config images pull'
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.20.2"...
Static pod: kube-apiserver-cks-master hash: 061027db0e88e3657f1ab490806403c1
Static pod: kube-controller-manager-cks-master hash: 1c77e9039eeb896c6eb9619eb25efa58
Static pod: kube-scheduler-cks-master hash: 57b58b3eb5589cb745c50233392349fb
[upgrade/etcd] Upgrading to TLS for etcd
Static pod: etcd-cks-master hash: c970a064d0fe1e6f97b36ff70f3c431e
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Renewing etcd-server certificate
[upgrade/staticpods] Renewing etcd-peer certificate
[upgrade/staticpods] Renewing etcd-healthcheck-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/etcd.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-03-09-23-22-23/etcd.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: etcd-cks-master hash: c970a064d0fe1e6f97b36ff70f3c431e
Static pod: etcd-cks-master hash: c970a064d0fe1e6f97b36ff70f3c431e
Static pod: etcd-cks-master hash: 6f9ca4ac97cad368cd838eebb7e01a6f
[apiclient] Found 1 Pods for label selector component=etcd
[upgrade/staticpods] Component "etcd" upgraded successfully!
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests174344580"
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Renewing apiserver certificate
[upgrade/staticpods] Renewing apiserver-kubelet-client certificate
[upgrade/staticpods] Renewing front-proxy-client certificate
[upgrade/staticpods] Renewing apiserver-etcd-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-apiserver.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-03-09-23-22-23/kube-apiserver.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: kube-apiserver-cks-master hash: 061027db0e88e3657f1ab490806403c1
Static pod: kube-apiserver-cks-master hash: f6c58610040386ba7cf06646b052f201
[apiclient] Found 1 Pods for label selector component=kube-apiserver
[upgrade/staticpods] Component "kube-apiserver" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Renewing controller-manager.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-controller-manager.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-03-09-23-22-23/kube-controller-manager.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: kube-controller-manager-cks-master hash: 1c77e9039eeb896c6eb9619eb25efa58
Static pod: kube-controller-manager-cks-master hash: 1a3810fb74d35de2490ad0c288bb67f6
[apiclient] Found 1 Pods for label selector component=kube-controller-manager
[upgrade/staticpods] Component "kube-controller-manager" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Renewing scheduler.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-scheduler.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-03-09-23-22-23/kube-scheduler.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: kube-scheduler-cks-master hash: 57b58b3eb5589cb745c50233392349fb
Static pod: kube-scheduler-cks-master hash: 69cd289b4ed80ced4f95a59ff60fa102
[apiclient] Found 1 Pods for label selector component=kube-scheduler
[upgrade/staticpods] Component "kube-scheduler" upgraded successfully!
[upgrade/postupgrade] Applying label node-role.kubernetes.io/control-plane='' to Nodes with label node-role.kubernetes.io/master='' (deprecated)
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.20" in namespace kube-system with the configuration for the kubelets in the cluster
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.20.2". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.

root@cks-master:~# k get node
NAME         STATUS                     ROLES                  AGE   VERSION
cks-master   Ready,SchedulingDisabled   control-plane,master   17m   v1.20.2
cks-worker   Ready                      <none>                 15m   v1.19.7

# unable cordon(取消隔离)
root@cks-master:~# k  uncordon cks-master
node/cks-master uncordoned


root@cks-master:~# k get node
NAME         STATUS   ROLES                  AGE   VERSION
cks-master   Ready    control-plane,master   19m   v1.20.2
cks-worker   Ready    <none>                 18m   v1.19.7
```



##### 70 Practice Upgrade worker node

**cks-master**

```sh
root@cks-master:~# k drain cks-worker
node/cks-worker cordoned
error: unable to drain node "cks-worker", aborting command...

There are pending nodes to be drained:
 cks-worker
error: cannot delete DaemonSet-managed Pods (use --ignore-daemonsets to ignore): kube-system/kube-proxy-rmqgx, kube-system/weave-net-nngrx

root@cks-master:~# k drain cks-worker  --ignore-daemonsets
node/cks-worker already cordoned
WARNING: ignoring DaemonSet-managed Pods: kube-system/kube-proxy-rmqgx, kube-system/weave-net-nngrx
evicting pod kube-system/coredns-74ff55c5b-lvdbz
evicting pod kube-system/coredns-74ff55c5b-6b88q
pod/coredns-74ff55c5b-6b88q evicted
pod/coredns-74ff55c5b-lvdbz evicted
node/cks-worker evicted


root@cks-master:~# k get node
NAME         STATUS                     ROLES                  AGE   VERSION
cks-master   Ready                      control-plane,master   22m   v1.20.2
cks-worker   Ready,SchedulingDisabled   <none>                 21m   v1.19.7

```

**cks-worker**

```sh
root@cks-worker:~# kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.7", GitCommit:"1dd5338295409edcfff11505e7bb246f0d325d15", GitTreeState:"clean", BuildDate:"2021-01-13T13:21:39Z", GoVersion:"go1.15.5", Compiler:"gc", Platform:"linux/amd64"}

root@cks-worker:~# apt-get install kubeadm=1.20.2-00
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 16 not upgraded.
Need to get 0 B/7706 kB of archives.
After this operation, 160 kB of additional disk space will be used.
(Reading database ... 106960 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.20.2-00_amd64.deb ...
Unpacking kubeadm (1.20.2-00) over (1.19.7-00) ...
Setting up kubeadm (1.20.2-00) ...



root@cks-worker:~# apt-cache show kubeadm  | grep 1.20.2
Version: 1.20.2-00
Filename: pool/kubeadm_1.20.2-00_amd64_38fa4593055ef1161d4cb322437eedda95186fb850819421b8cf75f3a943dc51.deb


root@cks-worker:~# kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"20", GitVersion:"v1.20.2", GitCommit:"faecb196815e248d3ecfb03c680a4507229c2a56", GitTreeState:"clean", BuildDate:"2021-01-13T13:25:59Z", GoVersion:"go1.15.5", Compiler:"gc", Platform:"linux/amd64"}


root@cks-worker:~# kubeadm upgrade node
[upgrade] Reading configuration from the cluster...
[upgrade] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks
[preflight] Skipping prepull. Not a control plane node.
[upgrade] Skipping phase. Not a control plane node.
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[upgrade] The configuration for this node was successfully updated!
[upgrade] Now you should go ahead and upgrade the kubelet package using your package manager.


root@cks-worker:~# apt-get install kubelet=1.20.2-00 kubectl=1.20.2-00
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 15 not upgraded.
Need to get 0 B/26.8 MB of archives.
After this operation, 1357 kB of additional disk space will be used.
(Reading database ... 106960 files and directories currently installed.)
Preparing to unpack .../kubectl_1.20.2-00_amd64.deb ...
Unpacking kubectl (1.20.2-00) over (1.19.7-00) ...
Preparing to unpack .../kubelet_1.20.2-00_amd64.deb ...
Unpacking kubelet (1.20.2-00) over (1.19.7-00) ...
Setting up kubelet (1.20.2-00) ...
Setting up kubectl (1.20.2-00) ...


root@cks-worker:~# kubelet --version
Kubernetes v1.20.2

root@cks-worker:~# kubectl version
Client Version: version.Info{Major:"1", Minor:"20", GitVersion:"v1.20.2", GitCommit:"faecb196815e248d3ecfb03c680a4507229c2a56", GitTreeState:"clean", BuildDate:"2021-01-13T13:28:09Z", GoVersion:"go1.15.5", Compiler:"gc", Platform:"linux/amd64"}
The connection to the server localhost:8080 was refused - did you specify the right host or port?

root@cks-master:~# k get node
NAME         STATUS                     ROLES                  AGE   VERSION
cks-master   Ready                      control-plane,master   30m   v1.20.2
cks-worker   Ready,SchedulingDisabled   <none>                 29m   v1.20.2


root@cks-master:~# k uncordon cks-worker
node/cks-worker uncordoned

root@cks-master:~# k get node
NAME         STATUS   ROLES                  AGE   VERSION
cks-master   Ready    control-plane,master   31m   v1.20.2
cks-worker   Ready    <none>                 29m   v1.20.2

```

###### Upgrade a cluster

**Upgrade the worker to match with master**

##### 71 Recap

**kubeadm upgrade**
https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade

**k8s versions**
https://kubernetes.io/docs/setup/release/version-skew-policy

#### Section 15 Microservice Vunerabilites - Manage Kubernetes Secrets
##### 72. Intro

- Overview
- Create Secure Secret Scenario
- Hack some Secrets

##### Introduction

**Secret**

- Passwords
- API keys
- Credentials
- Information needed by an application

###### Introduction Secrets

![](.\images\Section15\Screenshot_1.png)

![](.\images\Section15\Screenshot_2.png)

Introduction K8S Secretes

![](.\images\Section15\Screenshot_3.png)



##### 73. Create Simple Secret Scenario

###### Simple Secret Scenario

![](.\images\Section15\Screenshot_4.png)

```sh
root@cks-master:~# k create secret generic secret1 --from-literal user=admin
secret/secret1 created


root@cks-master:~# k create secret generic secret2 --from-literal pass=123abc
secret/secret2 created


root@cks-master:~# k run pod --image=nginx -oyaml --dry-run=client
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - image: nginx
    name: pod
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

*1
*2

root@cks-master:~# vim pod.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - image: nginx
    name: pod
    resources: {}
    env:
      - name: PASSWORD
        valueFrom:
          secretKeyRef:
            name: secret2
            key: pass
    volumeMounts:
    - name: secret1
      mountPath: "/etc/secret1"
      readOnly: true
  volumes:
  - name: secret1
    secret:
      secretName: secret1
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

root@cks-master:~# k -f pod.yaml create
pod/pod created
root@cks-master:~# k get pod
NAME   READY   STATUS              RESTARTS   AGE
pod    0/1     ContainerCreating   0          4s
root@cks-master:~# k get pod
NAME   READY   STATUS    RESTARTS   AGE
pod    1/1     Running   0          9s

root@cks-master:~# k exec pod -- env | grep PASS
PASSWORD=123abc

root@cks-master:~# k exec pod -- mount | grep secret1
tmpfs on /etc/secret1 type tmpfs (ro,relatime)


root@cks-master:~# k exec pod -- find /etc/secret1
/etc/secret1
/etc/secret1/..data
/etc/secret1/user
/etc/secret1/..2021_03_10_23_26_20.879551704
/etc/secret1/..2021_03_10_23_26_20.879551704/use

root@cks-master:~# k exec pod -- cat /etc/secret1/user
adminr
```

[*1](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod)

```sh
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mypod
    image: redis
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
      readOnly: true
  volumes:
  - name: foo
    secret:
      secretName: mysecret
```

[*2](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-environment-variables)

```sh
apiVersion: v1
kind: Pod
metadata:
  name: secret-env-pod
spec:
  containers:
  - name: mycontainer
    image: redis
    env:
      - name: SECRET_USERNAME
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: username
      - name: SECRET_PASSWORD
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: password
  restartPolicy: Never
```

##### 74. Practice - Hack Secrets in Docker

Secrets and docker

![](.\images\Section15\Screenshot_5.png)

```sh
root@cks-master:~# k get pod
NAME   READY   STATUS    RESTARTS   AGE
pod    1/1     Running   1          23h

# get the password
root@cks-worker:~# docker ps | grep nginx
d22f3301ee10        nginx                  "/docker-entrypoint.…"   13 minutes ago      Up 13 minutes                           k8s_pod_pod_default_e4de83c9-33c6-405d-a07f-6222e0da74fb_1
root@cks-worker:~# docker inspect d22f3301ee10
[
    {
        "Id": "d22f3301ee100eb972cc3da360238f8fcd987a1b3f1c1ad887659ac3ee3406af",
        "Created": "2021-03-11T22:35:22.073987855Z",
        "Path": "/docker-entrypoint.sh",
        "Args": [
            "nginx",
            "-g",
            "daemon off;"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 4917,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2021-03-11T22:35:22.761475008Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:018aec2b4f302b08b4c7274b72bede1fe56ee1f2bcaa06492e3f464e05f1a9a8",
        "ResolvConfPath": "/var/lib/docker/containers/f53d30c1346108d955b1249b7475efa7b27657ce72127299932fbcbd5b6df465/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/f53d30c1346108d955b1249b7475efa7b27657ce72127299932fbcbd5b6df465/hostname",
        "HostsPath": "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/etc-hosts",
        "LogPath": "/var/lib/docker/containers/d22f3301ee100eb972cc3da360238f8fcd987a1b3f1c1ad887659ac3ee3406af/d22f3301ee100eb972cc3da360238f8fcd987a1b3f1c1ad887659ac3ee3406af-json.log",
        "Name": "/k8s_pod_pod_default_e4de83c9-33c6-405d-a07f-6222e0da74fb_1",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "docker-default",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": [
                "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/volumes/kubernetes.io~secret/secret1:/etc/secret1:ro",
                "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/volumes/kubernetes.io~secret/default-token-twdg9:/var/run/secrets/kubernetes.io/serviceaccount:ro",
                "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/etc-hosts:/etc/hosts",
                "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/containers/pod/456fcbd6:/dev/termination-log"
            ],
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "container:f53d30c1346108d955b1249b7475efa7b27657ce72127299932fbcbd5b6df465",
            "PortBindings": null,
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Capabilities": null,
            "Dns": null,
            "DnsOptions": null,
            "DnsSearch": null,
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "container:f53d30c1346108d955b1249b7475efa7b27657ce72127299932fbcbd5b6df465",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 1000,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": [
                "seccomp=unconfined"
            ],
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 2,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "kubepods-besteffort-pode4de83c9_33c6_405d_a07f_6222e0da74fb.slice",
            "BlkioWeight": 0,
            "BlkioWeightDevice": null,
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 100000,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "KernelMemory": 0,
            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/asound",
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/73379f394014a7e41c5aade53913c3aa55d335884ee57d4b0ff5ebd3a49a0658-init/diff:/var/lib/docker/overlay2/f8b80781ff34b860377540a924b9f966a4086dabf23fb9d92a52e23696fdd423/diff:/var/lib/docker/overlay2/b90eb53458a074f7b404a6a3720886439296e57aff1587e8bd21b549109d0d51/diff:/var/lib/docker/overlay2/ed7c61f17f6404f4be564fe313f691a5a7722726631f6ad4788872205ba3532d/diff:/var/lib/docker/overlay2/7d07bc8b69a87b5514b2efdf23d82d78bf2800806c839f30d5be3b03306cb75e/diff:/var/lib/docker/overlay2/ba51ab1c3cdb1ecebfb7afe6784c67b1682faa097511406bd54391a0720c4458/diff:/var/lib/docker/overlay2/ab81512a9bd8e92779ac490254ce02e81a10d519ea111aaa76388e189cbef64e/diff",
                "MergedDir": "/var/lib/docker/overlay2/73379f394014a7e41c5aade53913c3aa55d335884ee57d4b0ff5ebd3a49a0658/merged",
                "UpperDir": "/var/lib/docker/overlay2/73379f394014a7e41c5aade53913c3aa55d335884ee57d4b0ff5ebd3a49a0658/diff",
                "WorkDir": "/var/lib/docker/overlay2/73379f394014a7e41c5aade53913c3aa55d335884ee57d4b0ff5ebd3a49a0658/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [
            {
                "Type": "bind",
                "Source": "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/volumes/kubernetes.io~secret/secret1",
                "Destination": "/etc/secret1",
                "Mode": "ro",
                "RW": false,
                "Propagation": "rprivate"
            },
            {
                "Type": "bind",
                "Source": "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/volumes/kubernetes.io~secret/default-token-twdg9",
                "Destination": "/var/run/secrets/kubernetes.io/serviceaccount",
                "Mode": "ro",
                "RW": false,
                "Propagation": "rprivate"
            },
            {
                "Type": "bind",
                "Source": "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/etc-hosts",
                "Destination": "/etc/hosts",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            },
            {
                "Type": "bind",
                "Source": "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/containers/pod/456fcbd6",
                "Destination": "/dev/termination-log",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            }
        ],
        "Config": {
            "Hostname": "pod",
            "Domainname": "",
            "User": "0",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PASSWORD=123abc",
                "KUBERNETES_SERVICE_PORT=443",
                "KUBERNETES_SERVICE_PORT_HTTPS=443",
                "KUBERNETES_PORT=tcp://10.96.0.1:443",
                "KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443",
                "KUBERNETES_PORT_443_TCP_PROTO=tcp",
                "KUBERNETES_PORT_443_TCP_PORT=443",
                "KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1",
                "KUBERNETES_SERVICE_HOST=10.96.0.1",
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NGINX_VERSION=1.19.8",
                "NJS_VERSION=0.5.2",
                "PKG_RELEASE=1~buster"
            ],
            "Cmd": [
                "nginx",
                "-g",
                "daemon off;"
            ],
            "Healthcheck": {
                "Test": [
                    "NONE"
                ]
            },
            "Image": "nginx@sha256:d5b6b094a614448aa0c48498936f25073dc270e12f5fcad5dc11e7f053e73026",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": [
                "/docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {
                "annotation.io.kubernetes.container.hash": "9818bb8d",
                "annotation.io.kubernetes.container.restartCount": "1",
                "annotation.io.kubernetes.container.terminationMessagePath": "/dev/termination-log",
                "annotation.io.kubernetes.container.terminationMessagePolicy": "File",
                "annotation.io.kubernetes.pod.terminationGracePeriod": "30",
                "io.kubernetes.container.logpath": "/var/log/pods/default_pod_e4de83c9-33c6-405d-a07f-6222e0da74fb/pod/1.log",
                "io.kubernetes.container.name": "pod",
                "io.kubernetes.docker.type": "container",
                "io.kubernetes.pod.name": "pod",
                "io.kubernetes.pod.namespace": "default",
                "io.kubernetes.pod.uid": "e4de83c9-33c6-405d-a07f-6222e0da74fb",
                "io.kubernetes.sandbox.id": "f53d30c1346108d955b1249b7475efa7b27657ce72127299932fbcbd5b6df465",
                "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
            },
            "StopSignal": "SIGQUIT"
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {},
            "SandboxKey": "",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "",
            "Gateway": "",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "",
            "IPPrefixLen": 0,
            "IPv6Gateway": "",
            "MacAddress": "",
            "Networks": {}
        }
    }
]

#get the user name
root@cks-worker:~# docker cp d22f3301ee10:/etc/secret1 secret1
root@cks-worker:~# cat secret1/user
admin
```

##### 75.Practice Hack Secrets in ETCD

###### Secrets and etcd

![](.\images\Section15\Screenshot_6.png)

```sh
root@cks-master:~# ETCDCTL_API=3 etcdctl endpoint health
127.0.0.1:2379 is unhealthy: failed to commit proposal: context deadline exceeded
Error:  unhealthy cluster




# access secret int etcd
root@cks-master:~# cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
    - --etcd-servers=https://127.0.0.1:2379


root@cks-master:~# ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt endpoint health
127.0.0.1:2379 is healthy: successfully committed proposal: took = 1.132134ms

# --endpoints "https://127.0.0.1:2379" not necessary because we’re on same node

# get username and password
root@cks-master:~# ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/secret1
/registry/secrets/default/secret1
k8s

v1Secret▒
▒
secret1default"*$c61cd235-6133-4487-8e56-772648f27d802▒▒▒▒z▒_
kubectl-createUpdatev▒▒▒▒FieldsV1:-
+{"f:data":{".":{},"f:user":{}},"f:type":{}}
useradminOpaque"
root@cks-master:~# ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/secret2
/registry/secrets/default/secret2
k8s

v1Secret▒
▒
secret2default"*$b314de1d-4b59-42ec-b9ee-8d185944ca602▒▒▒▒z▒_
kubectl-createUpdatev▒▒▒▒FieldsV1:-
+{"f:data":{".":{},"f:pass":{}},"f:type":{}}
pass123abcOpaque"

```

###### 76. ETCD Encryption

###### Encrypt etcd



![](.\images\Section15\Screenshot_7.png)

![](.\images\Section15\Screenshot_8.png)

###### Encrypt (all Secrets) in etcd

![](.\images\Section15\Screenshot_9.png)

```sh
kubectl get secrets --all-namespaces -o json | kubectl replace -f -
```

![](.\images\Section15\Screenshot_10.png)


```sh
kubectl get secrets --all-namespaces -o json | kubectl replace -f -
```

##### 77. Practice Encrypt ETCD

###### Encrypt etcd

**Encrypt Secrets in ETCD at rest and test it**

> Encrypt all existing secrets using **aescbc** and a password of our choice

```sh
marsforever@cks-master:~$ sudo -i
root@cks-master:~# cd /etc/kubernetes/
root@cks-master:/etc/kubernetes# mkdir etcd
root@cks-master:/etc/kubernetes# cd etcd/
#※1
root@cks-master:/etc/kubernetes/etcd# vim ec.yaml

#add the string to ec.yaml's secret
root@cks-master:/etc/kubernetes/etcd# echo -n password | base64
cGFzc3dvcmQ=

root@cks-master:/etc/kubernetes/etcd# cat ec.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - aescbc:
        keys:
        - name: key1
          secret: cGFzc3dvcmQ=
    - identity: {}


```

######  ※1 encrypt etcd docs page contains also example on how to read etcd secret
https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#encrypting-your-data



```sh
root@cks-master:/etc/kubernetes/etcd# cd ..
root@cks-master:/etc/kubernetes# cd manifests/
root@cks-master:/etc/kubernetes/manifests# vim kube-apiserver.yaml
spec:
  containers:
  - command:
    - kube-apiserver
#add the new line    
    - --encryption-provider-config=/etc/kubernetes/etcd/ec.yaml
#add the new lines
#mount the path
    - mountPath: /etc/kubernetes/etcd
      name: etcd
      readOnly: true    
#add the new lines
#set the folder
  - hostPath:
      path: /etc/kubernetes/etcd
      type: DirectoryOrCreate
    name: etcd

root@cks-master:/etc/kubernetes/manifests# cd /var/log/pods
root@cks-master:/var/log/pods# tail -f kube-system_kube-apiserver-cks-master_b2f2c7bbaa5a0c135c9ebc4de2eac4ad/kube-apiserver/4.log
{"log":"Flag --insecure-port has been deprecated, This flag has no effect now and will be removed in v1.24.\n","stream":"stderr","time":"2021-03-13T03:44:50.913649642Z"}
{"log":"I0313 03:44:50.913659       1 server.go:632] external host was not specified, using 10.146.0.2\n","stream":"stderr","time":"2021-03-13T03:44:50.913789379Z"}
{"log":"I0313 03:44:50.914290       1 server.go:182] Version: v1.20.2\n","stream":"stderr","time":"2021-03-13T03:44:50.914394666Z"}
{"log":"Error: error while parsing encryption provider configuration file \"/etc/kubernetes/etcd/ec.yaml\": error while parsing file: resources[0].providers[0].aescbc.keys[0].secret: Invalid value: \"REDACTED\": secret is not of the expected length, got 8, expected one of [16 24 32]\n","stream":"stderr","time":"2021-03-13T03:44:51.375760488Z"}

root@cks-master:/var/log/pods# cd /etc/kubernetes/etcd/
root@cks-master:/etc/kubernetes/etcd# vim ec.yaml
root@cks-master:/etc/kubernetes/etcd# echo -n passwordpassword | base64
cGFzc3dvcmRwYXNzd29yZA==

root@cks-master:/etc/kubernetes/etcd# cd /var/log/pods/
root@cks-master:/var/log/pods# tail -f kube-system_kube-apiserver-cks-master_b2f2c7bbaa5a0c135c9ebc4de2eac4ad/kube-apiserver/5.log
{"log":"Flag --insecure-port has been deprecated, This flag has no effect now and will be removed in v1.24.\n","stream":"stderr","time":"2021-03-13T03:46:21.962286244Z"}
{"log":"I0313 03:46:21.962567       1 server.go:632] external host was not specified, using 10.146.0.2\n","stream":"stderr","time":"2021-03-13T03:46:21.962910321Z"}
{"log":"I0313 03:46:21.963460       1 server.go:182] Version: v1.20.2\n","stream":"stderr","time":"2021-03-13T03:46:21.963551658Z"}
{"log":"Error: error while parsing encryption provider configuration file \"/etc/kubernetes/etcd/ec.yaml\": error while parsing file: resources[0].providers[0].aescbc.keys[0].secret: Invalid value: \"REDACTED\": secret is not of the expected length, got 8, expected one of [16 24 32]\n","stream":"stderr","time":"2021-03-13T03:46:22.364017822Z"}

#Restart kube api server
root@cks-master:/var/log/pods# cd -
/etc/kubernetes/etcd
root@cks-master:/etc/kubernetes/etcd# cd ../manifests/
root@cks-master:/etc/kubernetes/manifests# mv kube-apiserver.yaml ..
# check the apiserver is stopped
root@cks-master:/etc/kubernetes/manifests# ps aux | grep apiserver
root     26261  0.0  0.0  14860  1004 pts/0    S+   03:50   0:00 grep --color=auto apiserver
root@cks-master:/etc/kubernetes/manifests# mv ../kube-apiserver.yaml .
root@cks-master:/etc/kubernetes/manifests# ls
etcd.yaml            kube-controller-manager.yaml
kube-apiserver.yaml  kube-scheduler.yaml
root@cks-master:/etc/kubernetes/manifests# ps aux | grep apiserver
root     26786 76.2  7.9 1097096 321824 ?      Ssl  03:52   0:06 kube-apiserver --encryption-provider-config=/etc/kubernetes/etcd/ec.yaml --advertise-address=10.146.0.2 --allow-privileged=true --authorization-mode=Node,RBAC --client-ca-file=/etc/kubernetes/pki/ca.crt --enable-admission-plugins=NodeRestriction --enable-bootstrap-token-auth=true --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379 --insecure-port=0 --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key --requestheader-allowed-names=front-proxy-client --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --secure-port=6443 --service-account-issuer=https://kubernetes.default.svc.cluster.local --service-account-key-file=/etc/kubernetes/pki/sa.pub --service-account-signing-key-file=/etc/kubernetes/pki/sa.key --service-cluster-ip-range=10.96.0.0/12 --tls-cert-file=/etc/kubernetes/pki/apiserver.crt --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
root     26851  0.0  0.0  14860  1092 pts/0    R+   03:52   0:00 grep --color=auto apiserver

root@cks-master:/etc/kubernetes/manifests# k get secret
NAME                  TYPE                                  DATA   AGE
default-token-twdg9   kubernetes.io/service-account-token   3      3d4h
secret1               Opaque                                1      2d4h
secret2               Opaque                                1      2d4h

root@cks-master:/etc/kubernetes/manifests#k get secret default-token-twdg9 -oyaml
apiVersion: v1
data:
  ca.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1ETXdPVEl6TURZek5Gb1hEVE14TURNd056SXpNRFl6TkZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT1QvCkR4T0VzdmxNTThCVk8zU3lCc2hVcHpyTkRjU25qOHRrUXhQN3lNSldKeW9mMEltQXR3bU5xWlJKYUd4NTB4VEgKdHl5eHNGVWRiems0RTZJbEpmSHJzMllhRVhOdk1ZSDNrZlErWHdIVFNNaTlXNkNheWNQd0NaVlV3QUJyY3lpMgpybXowMEpoTlZuMnZaTFJYSUtTaTlFNTJsaGI1cEdUdUFTVXdGU0FGMWltZGY4ZSt1ejhHUWhJSTE1bUFMcGJYCmw1clJYUERiR05XSHhCaCtXWUY3aEROemtpQXJyNjZ4VE5TV1RORUhPK0xuNGlSRWpQYW1LS1FnSnQrNTNKOHEKTTI4bmR2QnBrUnRtelhjRXlZTzdXdG9RWkpiUHN2TmNCZUN3M2toRWFQQU9zZmwvaytSWlhmSVd1eHFIK2xuMgpSRTJDTVlZL1lXVitXTHNtTU1FQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZDeWdiM0hEc3I2bkxCa2hucXZGWmlBZkRYVmRNQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFBK1VYS2RoWGgvTDE0STlqVlV4RDlBTTg3NzllMWdvZlgvcnVsY3loa1haYXc3cWtuZQpUellWOFJDc3p6U3hQYjl1c1pxSjZJenFVQ3pFUDYrVmYrM0JSM1BLQWZacDU5c1M1ZTJUSThSYTAxanpxcWcvClJwb081TjFoRGUwVnpOaDI0ZkhQTTMrUHUwTWZ3VUJJUU9CWHRBUXZyd2dUbWNEenV6QzdNcUlic2pjUkw3VjUKREdqcG1rZm14VkRKN1l4UnUyT2FLWTNicE50TTRMYVlkb0JoQWRXWXl5WU1ZME1mMXN2ODJwMUlIRVhYTWFTWQptVnlGVlZHZDBBZTFzNSt2OE05TmdpV3FVdUUzaFoxalJsNTI2ZHgxSlpqbVlkZTl3WkZwMmVmVjFMWExOcUJmCmNaMlJjSEh4TnQ4clArVlBoVERiTzlOVjZxUVpQejdvYkk3ZAotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
  namespace: ZGVmYXVsdA==
  token: ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNklsSnBOemxEYmtsTFFUWldhMnBDYTJWak5pMVZhbkExVDIwNGN5MWlRbkp6VWsxeGVtbDJXbFZRYUZVaWZRLmV5SnBjM01pT2lKcmRXSmxjbTVsZEdWekwzTmxjblpwWTJWaFkyTnZkVzUwSWl3aWEzVmlaWEp1WlhSbGN5NXBieTl6WlhKMmFXTmxZV05qYjNWdWRDOXVZVzFsYzNCaFkyVWlPaUprWldaaGRXeDBJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5elpXTnlaWFF1Ym1GdFpTSTZJbVJsWm1GMWJIUXRkRzlyWlc0dGRIZGtaemtpTENKcmRXSmxjbTVsZEdWekxtbHZMM05sY25acFkyVmhZMk52ZFc1MEwzTmxjblpwWTJVdFlXTmpiM1Z1ZEM1dVlXMWxJam9pWkdWbVlYVnNkQ0lzSW10MVltVnlibVYwWlhNdWFXOHZjMlZ5ZG1salpXRmpZMjkxYm5RdmMyVnlkbWxqWlMxaFkyTnZkVzUwTG5WcFpDSTZJakUzTkRaaU1qUTRMVEZpWXpVdE5EVXlOeTFpTldGbUxUSTRPRGhoTm1FNVlUZzJaQ0lzSW5OMVlpSTZJbk41YzNSbGJUcHpaWEoyYVdObFlXTmpiM1Z1ZERwa1pXWmhkV3gwT21SbFptRjFiSFFpZlEudmFoVDFBS3g4RlVoMXJBOG4tTk96TEd6UXFhU1JuMFRBNC1zSzBzZXdydGs4SjhRNFBDbmlqV01KT0RaSTl0ajJlV2dJd284R2JPa1YtanNSeEl5MFV4WFNYb3hhOTl5WFlyZnJEdjFSS1V5UXowUVJlTGh4UnBUS0FnTGpLcU95b1pNQ1hlbWM5Z21mSUNzQ3JjVzE5Q3o4NlFyN2pvazhSNVhPRGFKb256SWowTTNhSFJ3U3FyVDFJTElmdFpLdk9NUXBlRHhCZVQ4aXU1N0piZXFEb1pSR09PbFh2SFZwUzdsel95dTcwU2ZadUNwc29NVURjLXJvYTdZdk5EZDBJb3E5U05mazZvRGotU0FRMk5SUy1ETUpobW5BWWl3bV85NFI5amFFcXEzMzV5allYdHNWTFJSMHFjRGs3ZzNLSklOZHRZTnBuam5mWXNQMGdnQjRn
kind: Secret
metadata:
  annotations:
    kubernetes.io/service-account.name: default
    kubernetes.io/service-account.uid: 1746b248-1bc5-4527-b5af-2888a6a9a86d
  creationTimestamp: "2021-03-09T23:07:01Z"
  managedFields:
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:data:
        .: {}
        f:ca.crt: {}
        f:namespace: {}
        f:token: {}
      f:metadata:
        f:annotations:
          .: {}
          f:kubernetes.io/service-account.name: {}
          f:kubernetes.io/service-account.uid: {}
      f:type: {}
    manager: kube-controller-manager
    operation: Update
    time: "2021-03-09T23:07:01Z"
  name: default-token-twdg9
  namespace: default
  resourceVersion: "353"
  uid: 47c8f77f-02aa-4b69-9444-19818b562105
type: kubernetes.io/service-account-token

```



--encryption-provider-config

https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#configuration-and-determining-whether-encryption-at-rest-is-already-enabled



###### read secret from etcd

https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#verifying-that-data-is-encrypted

ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/very-secure



```sh
root@cks-master:/etc/kubernetes/manifests# ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/default-token-twdg9
/registry/secrets/default/default-token-twdg9
k8s

v1Secret▒
▒
default-token-twdg9default"*$47c8f77f-02aa-4b69-9444-19818b5621052▒▒▒▒b-
"kubernetes.io/service-account.namedefaultbI
!kubernetes.io/service-account.uid$1746b248-1bc5-4527-b5af-2888a6a9a86dz▒▒
kube-controller-managerUpdatev▒▒▒▒FieldsV1:▒
▒{"f:data":{".":{},"f:ca.crt":{},"f:namespace":{},"f:token":{}},"f:metadata":{"f:annotations":{".":{},"f:kubernetes.io/service-account.name":{},"f:kubernetes.io/service-account.uid":{}}},"f:type":{}}▒
ca.crt-----BEGIN CERTIFICATE-----
MIIC5zCCAc+gAwIBAgIBADANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwprdWJl
cm5ldGVzMB4XDTIxMDMwOTIzMDYzNFoXDTMxMDMwNzIzMDYzNFowFTETMBEGA1UE
AxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOT/
DxOEsvlMM8BVO3SyBshUpzrNDcSnj8tkQxP7yMJWJyof0ImAtwmNqZRJaGx50xTH
tyyxsFUdbzk4E6IlJfHrs2YaEXNvMYH3kfQ+XwHTSMi9W6CaycPwCZVUwABrcyi2
rmz00JhNVn2vZLRXIKSi9E52lhb5pGTuASUwFSAF1imdf8e+uz8GQhII15mALpbX
l5rRXPDbGNWHxBh+WYF7hDNzkiArr66xTNSWTNEHO+Ln4iREjPamKKQgJt+53J8q
M28ndvBpkRtmzXcEyYO7WtoQZJbPsvNcBeCw3khEaPAOsfl/k+RZXfIWuxqH+ln2
RE2CMYY/YWV+WLsmMMECAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgKkMA8GA1UdEwEB
/wQFMAMBAf8wHQYDVR0OBBYEFCygb3HDsr6nLBkhnqvFZiAfDXVdMA0GCSqGSIb3
DQEBCwUAA4IBAQA+UXKdhXh/L14I9jVUxD9AM8779e1gofX/rulcyhkXZaw7qkne
TzYV8RCszzSxPb9usZqJ6IzqUCzEP6+Vf+3BR3PKAfZp59sS5e2TI8Ra01jzqqg/
RpoO5N1hDe0VzNh24fHPM3+Pu0MfwUBIQOBXtAQvrwgTmcDzuzC7MqIbsjcRL7V5
DGjpmkfmxVDJ7YxRu2OaKY3bpNtM4LaYdoBhAdWYyyYMY0Mf1sv82p1IHEXXMaSY
mVyFVVGd0Ae1s5+v8M9NgiWqUuE3hZ1jRl526dx1JZjmYde9wZFp2efV1LXLNqBf
cZ2RcHHxNt8rP+VPhTDbO9NV6qQZPz7obI7d
-----END CERTIFICATE-----

        namespacedefault▒

token▒eyJhbGciOiJSUzI1NiIsImtpZCI6IlJpNzlDbklLQTZWa2pCa2VjNi1VanA1T204cy1iQnJzUk1xeml2WlVQaFUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRlZmF1bHQtdG9rZW4tdHdkZzkiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGVmYXVsdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjE3NDZiMjQ4LTFiYzUtNDUyNy1iNWFmLTI4ODhhNmE5YTg2ZCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmRlZmF1bHQifQ.vahT1AKx8FUh1rA8n-NOzLGzQqaSRn0TA4-sK0sewrtk8J8Q4PCnijWMJODZI9tj2eWgIwo8GbOkV-jsRxIy0UxXSXoxa99yXYrfrDv1RKUyQz0QReLhxRpTKAgLjKqOyoZMCXemc9gmfICsCrcW19Cz86Qr7jok8R5XODaJonzIj0M3aHRwSqrT1ILIftZKvOMQpeDxBeT8iu57JbeqDoZRGOOlXvHVpS7lz_yu70SfZuCpsoMUDc-roa7YvNDd0Ioq9SNfk6oDj-SAQ2NRS-DMJhmnAYiwm_94R9jaEqq335yjYXtsVLRR0qcDk7g3KJINdtYNpnjnfYsP0ggB4g#kubernetes.io/service-account-token"
```

###### get secret very-secure

```sh
root@cks-master:/etc/kubernetes/etcd# k create secret generic very-secure --from-literal cc=1234
secret/very-secure created

root@cks-master: cd /etc/kubernetes/etcd

root@cks-master:/etc/kubernetes/etcd# ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/very-secure
/registry/secrets/default/very-secure
k8s:enc:aescbc:v1:key1:▒oT▒▒▒fݬ{▒▒▒`▒[▒d0˯▒▒▒/f▒F▒�6K▒[K▒M▒!%▒▒▒▒▒▒1j▒(▒I▒~▒p▒▒▒▒g▒|▒+▒▒▒Tc▒vP▒Ҫ2▒nцK!▒+▒Z▒{▒
▒▒+p▒▒1gM▒▒▒▒▒z▒▒▒D▒V,▒5▒/▒▒▒▒ak▒▒P▒)▒▒▒B:N▒▒▒▒▒▒n▒Q▒▒▒▒▒=dN▒▒P`d▒Xg)▒▒▒^▒▒▒▒`▒▒

root@cks-master:~# k get secret very-secure -oyaml
apiVersion: v1
data:
  cc: MTIzNA==
kind: Secret
metadata:
  creationTimestamp: "2021-03-13T04:15:23Z"
  managedFields:
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:data:
        .: {}
        f:cc: {}
      f:type: {}
    manager: kubectl-create
    operation: Update
    time: "2021-03-13T04:15:23Z"
  name: very-secure
  namespace: default
  resourceVersion: "19693"
  uid: da8b81ed-ea22-4413-a3cd-ae45c561b4de


root@cks-master:~# echo MTIzNA== | base64 -d
1234

#The tool  cut will split input into fields using space as the delimiter ( -d"" ). We then only select the 9th field using  -f 2
#sed -n 1p select the 1st line 
#tr -d '' delete the space
k get secret very-secure -oyaml | grep cc | cut -f 2 -d ":" | sed -n 1p | tr -d ' ' | base64 -d
1234

root@cks-master:~# k delete secret default-token-twdg9
secret "default-token-twdg9" deleted

# the contoller will recreate the secret
root@cks-master:~# k get secret
NAME                  TYPE                                  DATA   AGE
default-token-wlb7k   kubernetes.io/service-account-token   3      3s
secret1               Opaque                                1      8d
secret2               Opaque                                1      8d
very-secure           Opaque                                1      5d19h

#Check the secret is there
root@cks-master:/etc/kubernetes/etcd# k get secret -oyaml | grep very-secure
    name: very-secure

#check the secret of the kube-system
k get -n kube-system secret

NAME                                             TYPE                                  DATA   AGE
attachdetach-controller-token-5d5j5              kubernetes.io/service-account-token   3      9d
bootstrap-signer-token-5rfwh                     kubernetes.io/service-account-token   3      9d
bootstrap-token-5l9c78                           bootstrap.kubernetes.io/token         5      9d
certificate-controller-token-c5p2q               kubernetes.io/service-account-token   3      9d
clusterrole-aggregation-controller-token-bjtg2   kubernetes.io/service-account-token   3      9d
coredns-token-tl9fd                              kubernetes.io/service-account-token   3      9d
cronjob-controller-token-q6p5n                   kubernetes.io/service-account-token   3      9d
daemon-set-controller-token-4x4rm                kubernetes.io/service-account-token   3      9d
default-token-krzvk                              kubernetes.io/service-account-token   3      9d
deployment-controller-token-dw4zf                kubernetes.io/service-account-token   3      9d
disruption-controller-token-8v8zt                kubernetes.io/service-account-token   3      9d
endpoint-controller-token-zfcl6                  kubernetes.io/service-account-token   3      9d
endpointslice-controller-token-xh6j4             kubernetes.io/service-account-token   3      9d
endpointslicemirroring-controller-token-577mv    kubernetes.io/service-account-token   3      9d
expand-controller-token-xmht8                    kubernetes.io/service-account-token   3      9d
generic-garbage-collector-token-m4c2b            kubernetes.io/service-account-token   3      9d
horizontal-pod-autoscaler-token-x9lkt            kubernetes.io/service-account-token   3      9d
job-controller-token-ntsvh                       kubernetes.io/service-account-token   3      9d
kube-proxy-token-2vhzq                           kubernetes.io/service-account-token   3      9d
namespace-controller-token-mhh59                 kubernetes.io/service-account-token   3      9d
node-controller-token-hswlq                      kubernetes.io/service-account-token   3      9d
persistent-volume-binder-token-b6k4d             kubernetes.io/service-account-token   3      9d
pod-garbage-collector-token-jmtrz                kubernetes.io/service-account-token   3      9d
pv-protection-controller-token-kd4kn             kubernetes.io/service-account-token   3      9d
pvc-protection-controller-token-dhd5f            kubernetes.io/service-account-token   3      9d
replicaset-controller-token-ht4pf                kubernetes.io/service-account-token   3      9d
replication-controller-token-wgnlj               kubernetes.io/service-account-token   3      9d
resourcequota-controller-token-s2vmj             kubernetes.io/service-account-token   3      9d
root-ca-cert-publisher-token-vn5g4               kubernetes.io/service-account-token   3      9d
service-account-controller-token-xl6l2           kubernetes.io/service-account-token   3      9d
service-controller-token-9c8hd                   kubernetes.io/service-account-token   3      9d
statefulset-controller-token-zj8js               kubernetes.io/service-account-token   3      9d
token-cleaner-token-r8zt8                        kubernetes.io/service-account-token   3      9d
ttl-controller-token-8hjk2                       kubernetes.io/service-account-token   3      9d
weave-net-token-vd9ld                            kubernetes.io/service-account-token   3      9d


#Restart kube api server
root@cks-master:/var/log/pods# cd -
/etc/kubernetes/etcd
root@cks-master:/etc/kubernetes/etcd# cd ../manifests/
root@cks-master:/etc/kubernetes/manifests# mv kube-apiserver.yaml ..
# check the apiserver is stopped
root@cks-master:/etc/kubernetes/manifests# ps aux | grep apiserver
root     26261  0.0  0.0  14860  1004 pts/0    S+   03:50   0:00 grep --color=auto apiserver
root@cks-master:/etc/kubernetes/manifests# mv ../kube-apiserver.yaml .
#Check the aipserver is working
root@cks-master:/etc/kubernetes/etcd# ps aux | grep apiserver

root      3198  6.3  8.7 1097608 351244 ?      Ssl  23:05   2:36 kube-apiserver --encryption-provider-config=/etc/kubernetes/etcd/ec.yaml --advertise-address=10.146.0.2 --allow-privileged=true --authorization-mode=Node,RBAC --client-ca-file=/etc/kubernetes/pki/ca.crt --enable-admission-plugins=NodeRestriction --enable-bootstrap-token-auth=true --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379 --insecure-port=0 --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key --requestheader-allowed-names=front-proxy-client --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --secure-port=6443 --service-account-issuer=https://kubernetes.default.svc.cluster.local --service-account-key-file=/etc/kubernetes/pki/sa.pub --service-account-signing-key-file=/etc/kubernetes/pki/sa.key --service-cluster-ip-range=10.96.0.0/12 --tls-cert-file=/etc/kubernetes/pki/apiserver.crt --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
root     18586  0.0  0.0  14860  1040 pts/0    S+   23:46   0:00 grep --color=auto apiserver


k get secret -A -oyaml | kubectl replace -f -
```



#### Question 

cd /etc/kubernetes/etcd

ec.yaml identity for what



docker secret and etcd secret hacking is solved?

##### Recap
##### Why do we even have ConfigMap and Secrets?
- ConfigMaps file can keep file
- Secrets is more secure way

![](.\images\Section15\Screenshot_11.png)

- Tools
  - HashiCorp
  - Vault

##### K8s Secret Risks

![](.\images\Section15\Screenshot_12.png)

![](.\images\Section15\Screenshot_13.png)

Recap

- What are Secrets?
- Deploying & Use Secrets
- Hacking Secrets(etcd & Docker)
- How Secrets are stored (encrypted)

#### Section 16 Microservice Vunerabilites - Container Runtime Sandboxes

##### 78.Intro

- Technical Overview
  - Containers are not contained
    - a container doesn't mean it's more protected
  - Containers / Docker
    - ![](.\images\Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes\Screenshot_1.png)
    - Sandbox
      - Playground when implementing an API
      - Simulated Testing environgment
      - Development server
      - **Security layer to  reduce attack surface**
    - Containers and system calls
      - ![](.\images\Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes\Screenshot_2.png)
      - Sandbox comes not for free
        - More resources needed
        - Might be better for smaller containers
        - Not good for syscall heavy workloads
        - No direct access to hardware
- Break out of container
- gVisor Kata Containers
##### 79. Practice - Container calls Linux Kernel
```sh
root@cks-master:~# k run pod --image=nginx
pod/pod created

root@cks-master:~# k exec pod -it -- bash

#show system information
root@pod:/# uname -r
5.4.0-1051-gcp

#trace system calls and signals
root@cks-master:~# strace uname -r

```
[Dirty Cow ](https://en.wikipedia.org/wiki/Dirty_COW)

Computers and devices that still use the older kernels remain vulnerable.

##### 80. Open Container Initiative OCI

OCI

- Open Container Initiative

- Linux Foundation project to design open standards for virtualization

- Specification

  - runtime,image,distribution

- Runtime

  - runc(container runtime that implements their specification)

  ![](.\images\Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes\Screenshot_3.png)

![](.\images\Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes\Screenshot_4.png)

![](.\images\Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes\Screenshot_5.png)

##### 81. Practice - Crictl

crictl and containerd

- crictl: Provides a CLI for CRI-compatible container runtimes



```sh
# show containers
docker ps
crictl ps
#get nginx image
crictl pull nginx
Image is up to date for nginx@sha256:853b221d3341add7aaadf5f81dd088ea943ab9c918766e295321294b035f3f3e

#show pods
crictl pods
```

##### 82. Sandbox Runtime Katacontainers

![](.\images\Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes\Screenshot_6.png)

Kata containers

- Strong separation layer
- Runs every container in its own private VM(Hypervisor based)
- QEMU as default
  - needs virtualisation,like nested virtualisation in cloud

##### 83. Sandbox Runtime gVisor

user-space kernel for containers

- Another layer of spearation
- NOT hypervisor/VM based
- Simulator kernel syscalls with limited functionality
- Runtime called runsc

![](.\images\Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes\Screenshot_7.png)

##### 84.Practice - Create and use RuntimeClasses

```sh
vim runsc.yaml
-----
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: gvisor
handler: runsc
-----
root@cks-master:~# k -f rc.yaml create
runtimeclass.node.k8s.io/gvisor created

```



```sh
k run gvisor --image=nginx -oyaml --dry-run=client > pod.yaml
root@cks-master:~# vim pod.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: gvisor
  name: gvisor
spec:
  runtimeClassName: test
  containers:
  - image: nginx
    name: gvisor
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

root@cks-master:~# k -f pod.yaml create
Error from server (Forbidden): error when creating "pod.yaml": pods "gvisor" is forbidden: pod rejected: RuntimeClass "test" not found

root@cks-master:~# vim pod.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: gvisor
  name: gvisor
spec:
  runtimeClassName: gvisor
  containers:
  - image: nginx
    name: gvisor
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

root@cks-master:~# k -f pod.yaml create
pod/gvisor created



root@cks-master:~# k get pod -w
NAME     READY   STATUS              RESTARTS   AGE
gvisor   0/1     ContainerCreating   0          30s
pod      1/1     Running             0          126m

```



##### 85.Practice - Install and use gVisor



![](.\images\Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes\Screenshot_8.png)

```sh
root@cks-worker:~#sudo -i
root@cks-worker:~#bash <(curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/course-content/microservice-vulnerabilities/container-runtimes/gvisor/install_gvisor.sh)
# use containerd
root@cks-worker:~# cat /etc/default/kubelet
KUBELET_EXTRA_ARGS="--container-runtime remote --container-runtime-endpoint unix:///run/containerd/containerd.sock"
#check kubelet
root@cks-worker:~# service kubelet status
```

cks-worker is using containerd

```sh
root@cks-master:~# k get node -owide
NAME         STATUS   ROLES                  AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
cks-master   Ready    control-plane,master   34h   v1.21.0   10.146.0.2    <none>        Ubuntu 18.04.5 LTS   5.4.0-1051-gcp   docker://20.10.7
cks-worker   Ready    <none>                 34h   v1.21.0   10.146.0.3    <none>        Ubuntu 18.04.5 LTS   5.4.0-1051-gcp   containerd://1.5.2

# gvisor using containerd
root@cks-master:~# k get pod
NAME     READY   STATUS    RESTARTS   AGE
gvisor   1/1     Running   0          10m
pod      1/1     Running   0          136m

root@cks-master:~# k exec -it gvisor -- bash
root@gvisor:/# uname -r
4.4.0
root@gvisor:/# dmesg
[    0.000000] Starting gVisor...
[    0.260793] Searching for needles in stacks...
[    0.737771] Digging up root...
[    1.161314] Conjuring /dev/null black hole...
[    1.467524] Moving files to filing cabinet...
[    1.670183] Forking spaghetti code...
[    1.765726] Checking naughty and nice process list...
[    1.861117] Daemonizing children...
[    2.041006] Feeding the init monster...
[    2.383943] Rewriting operating system in Javascript...
[    2.744631] Preparing for the zombie uprising...
[    3.014470] Ready!
```



##### Recap

- Container Sandboxes
- containerd
- kata-containers(vm)
- gvisor/runsc(kernel)
- k8s Runtimes

###### References

- Container Runtime Landscape
https://www.youtube.com/watch?v=RyXL1zOa8Bw
- Gvisor
https://www.youtube.com/watch?v=kxUZ4lVFuVo
- Kata Containers
https://www.youtube.com/watch?v=4gmLXyMeYWI



#### Section 17 Microservice Vunerabilites - OS Level Security Domains
##### 87. Intro and Security Contexts
Security Contexts
**Define privilege and access control for Pod/Container**

- userID and GroupID
- Run privilged or unprivileged

![](.\images\Section17\Screenshot_1.png)



![](.\images\Section17\Screenshot_2.png)

PodSecurityContext v1 core

https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/

![](.\images\Section17\Screenshot_3.png)

##### 88. Practice - Set Container User and Group
** Change the user and gourp under which the conatiner processes are running

```sh
k run pod --image=busybox --command -oyaml --dry-run=client > pod.yaml -- sh -c 'sleep 1d'

root@cks-master:~# k -f pod.yaml create
pod/pod created

root@cks-master:~# k exec -it pod -- sh
/ # id
uid=0(root) gid=0(root) groups=10(wheel)
```
add security context
```sh
vim pod.yaml

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

recreate pod

```sh
k -f pod.yaml delete --force --grace-period=0


root@cks-master:~# k -f pod.yaml create
pod/pod created

root@cks-master:~# k exec -it pod -- sh
/ $ id
uid=1000 gid=3000
/ $ touch test
touch: test: Permission denied
/ $ cd /tmp/
/tmp $ touch test
/tmp $ ls -lh test
-rw-r--r--    1 1000     3000           0 Sep 20 06:58 test

```
##### 89.　Non-Root

**Force container to run as non-root**

```sh
vim pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      runAsNonRoot: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
k -f pod.yaml delete --force --grace-period=0

root@cks-master:~# k -f pod.yaml apply
pod/pod created

comment out security
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
#  securityContext:
#    runAsUser: 1000
#    runAsGroup: 3000
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      runAsNonRoot: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
k delete pod pod --force --grace-period=0
k apply -f pod.yaml
# because securitycontext is root
root@cks-master:~# k get pod
NAME     READY   STATUS                       RESTARTS   AGE
gvisor   1/1     Running                      1          39h
pod      0/1     CreateContainerConfigError   0          5s

root@cks-master:~# k describe pod pod

  Warning  Failed     50s (x8 over 2m17s)  kubelet            Error: container has runAsNonRoot and image will run as root (pod: "pod_default(a0aa01b2-231b-4d21-abff-751052622d6a)", container: pod)

```

##### 90. Privileged Containers

- By default Docker containers run "unprivileged"
- possible to run as privileged to 
  - Access all devices
  - Run Docker daemon inside container
    - docker run --privilileged

**Privileged means that container user 0(root) is directly mapped to host user 0 (root)**

###### Privileged Containers in Kubernetes

By default in kubernetes container are not running privileged

```sh
spec:
  containers:
    securityContext:
      privileged: true
```

##### 91.Practice - Create Privileged Container

**Enabled privileged and test using sysctl**

```sh
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  securityContext:
   runAsUser: 1000
   runAsGroup: 3000
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      runAsNonRoot: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k delete pod pod --force --grace-period=0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "pod" force deleted

root@cks-master:~# k apply -f pod.yaml
pod/pod created

root@cks-master:~# k exec -it pod -- sh
/ $ sysctl kernel.hostname=attacker
sysctl: error setting key 'kernel.hostname': Read-only file system

```



```sh
commentout securitycontext
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    #securityContext:
    #  runAsNonRoot: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
#recreate pod
k delete pod pod --force --grace-period=0 
k -f pod.yaml create

root@cks-master:~# k exec -it pod -- sh
/ $ sysctl kernel.hostname=attacker
sysctl: error setting key 'kernel.hostname': Read-only file system

```
Change security context to  the privileged 
```sh
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      privileged: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
recreate pod

k delete pod pod --force --grace-period=0
k -f pod.yaml create


root@cks-master:~# k exec -it pod -- sh
/ # sysctl kernel.hostname=attacker
kernel.hostname = attacker
/ # id
uid=0(root) gid=0(root) groups=10(wheel)

```

##### 92. PrivilegeEscalation

> AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process

![](.\images\Section17\Screenshot_4.png)

Privileged

> means that container user 0(root) is directly mapped to host user 0(root)

PrivilegeEscalation

>Controls where the process can gain more privileges than its parent process

##### 93. Practice - Disable PriviledgeEscalation

```sh
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      allowPrivilegedEscalation: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k exec -it pod -- sh
/ # cat /proc/1/s
sched         sessionid     smaps         stack         statm         syscall
schedstat     setgroups     smaps_rollup  stat          status
/ # cat /proc/1/sta
stack   stat    statm   status
/ # cat /proc/1/status | grep No
NoNewPrivs:     0
```

recreate pod.yaml

```sh
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      allowPrivilegeEscalation: false
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k delete pod pod --force --grace-period=0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "pod" force deleted
root@cks-master:~# k -f pod.yaml create
pod/pod created

root@cks-master:~# k exec -it pod -- sh
/ # cat /proc/1/status | grep NoNew
NoNewPrivs:     1

```

##### 94.PodSecurityPolicies

- Cluster-level resource
- Controls under which security conditions a Pod has to run

![](.\images\Section17\Screenshot_5.png)

![](.\images\Section17\Screenshot_5.png)



![](.\images\Section17\Screenshot_6.png)

##### 95.Pod Security Policies

> Create a PodSecurityPolicy to always enforce no allowPrivilegeEscalation



```sh
vim /etc/kubernetes/manifests/kube-apiserver.yaml
---    
    - --enable-admission-plugins=NodeRestriction,PodSecurityPolicy
---
```

```sh
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: default
spec:
  allowPrivilegeEscalation: false
  privileged: false  # Don't allow privileged pods!
  # The rest fills in some required fields.
  seLinux:
    rule: RunAsAny
  supplementalGroups:
    rule: RunAsAny
  runAsUser:
    rule: RunAsAny
  fsGroup:
    rule: RunAsAny
  volumes:
  - '*'
---
root@cks-master:~# k -f psp.yaml create
Warning: policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
podsecuritypolicy.policy/default created

```

https://kubernetes.io/docs/concepts/policy/pod-security-policy/#create-a-policy-and-a-pod

can't not create pod with deploy

```sh
root@cks-master:~# k create deploy nginx --image=nginx
deployment.apps/nginx created
root@cks-master:~# k get deploy nginx
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   0/1     0            0           5s
root@cks-master:~# k get deploy nginx -w
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   0/1     0            0           9s

```

can create pod 

```sh
Croot@cks-master:~# k run nginx --image=nginx
pod/nginx created
root@cks-master:~# k get pod
NAME     READY   STATUS              RESTARTS   AGE
gvisor   1/1     Running             1          40h
nginx    0/1     ContainerCreating   0          2s
pod      1/1     Running             0          25m
```

create role and rolebinding

```sh
root@cks-master:~# k create role psp-access --verb=use --resource=podsecuritypolicies
role.rbac.authorization.k8s.io/psp-access created
root@cks-master:~# k create rolebinding psp-access --role=psp-access --serviceaccount=default:default
rolebinding.rbac.authorization.k8s.io/psp-access created
```

recreate nginx deploy

```sh
root@cks-master:~# k delete deploy nginx
deployment.apps "nginx" deleted
root@cks-master:~# k create deploy nginx --image=nginx
deployment.apps/nginx created
root@cks-master:~# k get deploy nginx
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   1/1     1            1           21s
```



`allowPrivilegeEscalation: true` and can't create pod

```sh
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      allowPrivilegeEscalation: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k -f pod.yaml create
Error from server (Forbidden): error when creating "pod.yaml": pods "pod" is forbidden: PodSecurityPolicy: unable to admit pod: [spec.containers[0].securityContext.allowPrivilegeEscalation: Invalid value: true: Allowing privilege escalation for containers is not allowed]

```

`allowPrivilegeEscalation: false` and can create pod

```sh
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      allowPrivilegeEscalation: false
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---

root@cks-master:~# k get pod
NAME                     READY   STATUS    RESTARTS   AGE
gvisor                   1/1     Running   1          41h
nginx                    1/1     Running   0          9m7s
nginx-6799fc88d8-4kfdc   1/1     Running   0          4m44s
pod                      1/1     Running   0          53s

```

> Create a PodSecurityPolicy to always enforce no allowPrivilegeEscalation

##### 96. Recap

![](.\images\Section17\Screenshot_8.png)

![](.\images\Section17\Screenshot_9.png)

#### Section 18 Microservice Vunerabilites - mTLS

##### 97.Intro

- mTLS/Pod to Pod Communication
  - mTLS -Mutual TLS
    - Mutual authntication
    - Two-way(bilateral) authentication
    - Two parties authenticating each other at the same time
- Service Meshes
- Scenarios

![](.\images\Section18\Screenshot_10.png)



![](.\images\Section18\Screenshot_11.png)



![](.\images\Section18\Screenshot_12.png)



![](.\images\Section18\Screenshot_14.png)



![](.\images\Section18\Screenshot_15.png)



##### 98.Practice - Create sidecar proxy

Create a proxy sidecar which with NET_ADMIN capacity

```sh

root@cks-master:~# k run app --image=bash --command -oyaml --dry-run=client > app.yaml -- sh -c 'ping google.com'
root@cks-master:~# vim app.yaml
root@cks-master:~# k -f app.yaml create
pod/app created
root@cks-master:~# k get pod
NAME                     READY   STATUS    RESTARTS   AGE
app                      1/1     Running   0          11s
nginx-6799fc88d8-7fdq7   1/1     Running   0          4d7h
root@cks-master:~# k logs -f app
PING google.com (172.217.27.78): 56 data bytes
64 bytes from 172.217.27.78: seq=0 ttl=121 time=2.116 ms
64 bytes from 172.217.27.78: seq=1 ttl=121 time=1.866 ms
64 bytes from 172.217.27.78: seq=2 ttl=121 time=1.780 ms
64 bytes from 172.217.27.78: seq=3 ttl=121 time=1.918 ms
64 bytes from 172.217.27.78: seq=4 ttl=121 time=1.725 ms
64 bytes from 172.217.27.78: seq=5 ttl=121 time=1.788 ms
64 bytes from 172.217.27.78: seq=6 ttl=121 time=1.905 ms
64 bytes from 172.217.27.78: seq=7 ttl=121 time=1.957 ms
64 bytes from 172.217.27.78: seq=8 ttl=121 time=1.944 ms
64 bytes from 172.217.27.78: seq=9 ttl=121 time=1.951 ms
64 bytes from 172.217.27.78: seq=10 ttl=121 time=1.813 ms
64 bytes from 172.217.27.78: seq=11 ttl=121 time=1.821 ms
64 bytes from 172.217.27.78: seq=12 ttl=121 time=2.008 ms
64 bytes from 172.217.27.78: seq=13 ttl=121 time=1.967 ms
64 bytes from 172.217.27.78: seq=14 ttl=121 time=1.659 ms
```

```sh
root@cks-master:~# vim app.yaml
root@cks-master:~# cat app.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: app
  name: app
spec:
  containers:
  - command:
    - sh
    - -c
    - ping google.com
    image: bash
    name: app
    resources: {}
  - name: proxy
    image: ubuntu
    command:
    - sh
    - -c
    - 'apt-get update && apt-get install iptables -y && iptables -L && sleep 1d'
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

root@cks-master:~# k -f app.yaml delete --force --grace-period 0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "app" force deleted
root@cks-master:~# k -f app.yaml create
pod/app created
#show two apps
root@cks-master:~# k get pod
NAME                     READY   STATUS    RESTARTS   AGE
app                      2/2     Running   1          25s
nginx-6799fc88d8-7fdq7   1/1     Running   0          4d7h

```

add "NET_ADMIN"

```sh
root@cks-master:~# vim app.yaml
root@cks-master:~# cat app.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: app
  name: app
spec:
  containers:
  - command:
    - sh
    - -c
    - ping google.com
    image: bash
    name: app
    resources: {}
  - name: proxy
    image: ubuntu
    command:
    - sh
    - -c
    - 'apt-get update && apt-get install iptables -y && iptables -L && sleep 1d'
    securityContext:
      capabilities:
        add: ["NET_ADMIN"]
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k -f app.yaml create
pod/app created

#show logs
root@cks-master:~# k logs app -c proxy
Get:1 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Get:2 http://archive.ubuntu.com/ubuntu focal InRelease [265 kB]
Get:3 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 Packages [30.1 kB]
Get:4 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [791 kB]
Get:5 http://security.ubuntu.com/ubuntu focal-security/restricted amd64 Packages [543 kB]
Get:6 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [1092 kB]
Get:7 http://archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Get:8 http://archive.ubuntu.com/ubuntu focal-backports InRelease [101 kB]
Get:9 http://archive.ubuntu.com/ubuntu focal/multiverse amd64 Packages [177 kB]
Get:10 http://archive.ubuntu.com/ubuntu focal/restricted amd64 Packages [33.4 kB]
Get:11 http://archive.ubuntu.com/ubuntu focal/main amd64 Packages [1275 kB]
Get:12 http://archive.ubuntu.com/ubuntu focal/universe amd64 Packages [11.3 MB]
Get:13 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [1071 kB]
Get:14 http://archive.ubuntu.com/ubuntu focal-updates/restricted amd64 Packages [590 kB]
Get:15 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [1537 kB]
Get:16 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [33.3 kB]
Get:17 http://archive.ubuntu.com/ubuntu focal-backports/main amd64 Packages [2668 B]
Get:18 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 Packages [6310 B]
Fetched 19.1 MB in 13s (1525 kB/s)
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  libip4tc2 libip6tc2 libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11
  libxtables12 netbase
Suggested packages:
  firewalld kmod nftables
The following NEW packages will be installed:
  iptables libip4tc2 libip6tc2 libmnl0 libnetfilter-conntrack3 libnfnetlink0
  libnftnl11 libxtables12 netbase
0 upgraded, 9 newly installed, 0 to remove and 5 not upgraded.
Need to get 595 kB of archives.
After this operation, 3490 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu focal/main amd64 libip4tc2 amd64 1.8.4-3ubuntu2 [18.8 kB]
Get:2 http://archive.ubuntu.com/ubuntu focal/main amd64 libmnl0 amd64 1.0.4-2 [12.3 kB]
Get:3 http://archive.ubuntu.com/ubuntu focal/main amd64 libxtables12 amd64 1.8.4-3ubuntu2 [28.4 kB]
Get:4 http://archive.ubuntu.com/ubuntu focal/main amd64 netbase all 6.1 [13.1 kB]
Get:5 http://archive.ubuntu.com/ubuntu focal/main amd64 libip6tc2 amd64 1.8.4-3ubuntu2 [19.2 kB]
Get:6 http://archive.ubuntu.com/ubuntu focal/main amd64 libnfnetlink0 amd64 1.0.1-3build1 [13.8 kB]
Get:7 http://archive.ubuntu.com/ubuntu focal/main amd64 libnetfilter-conntrack3 amd64 1.0.7-2 [41.4 kB]
Get:8 http://archive.ubuntu.com/ubuntu focal/main amd64 libnftnl11 amd64 1.1.5-1 [57.8 kB]
Get:9 http://archive.ubuntu.com/ubuntu focal/main amd64 iptables amd64 1.8.4-3ubuntu2 [390 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 595 kB in 3s (171 kB/s)
Selecting previously unselected package libip4tc2:amd64.
(Reading database ... 4127 files and directories currently installed.)
Preparing to unpack .../0-libip4tc2_1.8.4-3ubuntu2_amd64.deb ...
Unpacking libip4tc2:amd64 (1.8.4-3ubuntu2) ...
Selecting previously unselected package libmnl0:amd64.
Preparing to unpack .../1-libmnl0_1.0.4-2_amd64.deb ...
Unpacking libmnl0:amd64 (1.0.4-2) ...
Selecting previously unselected package libxtables12:amd64.
Preparing to unpack .../2-libxtables12_1.8.4-3ubuntu2_amd64.deb ...
Unpacking libxtables12:amd64 (1.8.4-3ubuntu2) ...
Selecting previously unselected package netbase.
Preparing to unpack .../3-netbase_6.1_all.deb ...
Unpacking netbase (6.1) ...
Selecting previously unselected package libip6tc2:amd64.
Preparing to unpack .../4-libip6tc2_1.8.4-3ubuntu2_amd64.deb ...
Unpacking libip6tc2:amd64 (1.8.4-3ubuntu2) ...
Selecting previously unselected package libnfnetlink0:amd64.
Preparing to unpack .../5-libnfnetlink0_1.0.1-3build1_amd64.deb ...
Unpacking libnfnetlink0:amd64 (1.0.1-3build1) ...
Selecting previously unselected package libnetfilter-conntrack3:amd64.
Preparing to unpack .../6-libnetfilter-conntrack3_1.0.7-2_amd64.deb ...
Unpacking libnetfilter-conntrack3:amd64 (1.0.7-2) ...
Selecting previously unselected package libnftnl11:amd64.
Preparing to unpack .../7-libnftnl11_1.1.5-1_amd64.deb ...
Unpacking libnftnl11:amd64 (1.1.5-1) ...
Selecting previously unselected package iptables.
Preparing to unpack .../8-iptables_1.8.4-3ubuntu2_amd64.deb ...
Unpacking iptables (1.8.4-3ubuntu2) ...
Setting up libip4tc2:amd64 (1.8.4-3ubuntu2) ...
Setting up libip6tc2:amd64 (1.8.4-3ubuntu2) ...
Setting up libmnl0:amd64 (1.0.4-2) ...
Setting up libxtables12:amd64 (1.8.4-3ubuntu2) ...
Setting up libnfnetlink0:amd64 (1.0.1-3build1) ...
Setting up netbase (6.1) ...
Setting up libnftnl11:amd64 (1.1.5-1) ...
Setting up libnetfilter-conntrack3:amd64 (1.0.7-2) ...
Setting up iptables (1.8.4-3ubuntu2) ...
update-alternatives: using /usr/sbin/iptables-legacy to provide /usr/sbin/iptables (iptables) in auto mode
update-alternatives: using /usr/sbin/ip6tables-legacy to provide /usr/sbin/ip6tables (ip6tables) in auto mode
update-alternatives: using /usr/sbin/arptables-nft to provide /usr/sbin/arptables (arptables) in auto mode
update-alternatives: using /usr/sbin/ebtables-nft to provide /usr/sbin/ebtables (ebtables) in auto mode
Processing triggers for libc-bin (2.31-0ubuntu9.2) ...
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  10.32.0.0/12         base-address.mcast.net/4
DROP       all  --  anywhere             base-address.mcast.net/4

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

```

https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

##### 99.Recap

- mTLS
- Pod to Pod Communication
- Create sidecar proxy
- NET_ADMIN capacity

#### Section 19 Open Policy Agent(OPA)
##### 100. Cluster Reset

> Every new section works with a fresh cluster