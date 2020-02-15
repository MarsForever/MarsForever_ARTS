
##### 試験内容
* 3時間
* 24問
* 74% 以上

##### 准备物品
* 护照
* PC
* web camera
* two moniters(https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/)

#### 房间
* 没有文字的房间 =》 把书架盖起来
* 桌子前没有物品 
* ask question on chart


#### login web
https://www.examslocal.com/Candidate

command 操作
copy: ctlr + insert
paste: shift + insert

#### Tips
##### 特定文字列探す
grep -w 
##### 違うものを表示
grep -v
##### 文字列の大小を区別しない
grep -i
#### awk sed使い方
kubectl get pods | sed -n 3p | awk ‘{print $1}’　\

sed -n $num p 何行目を指定する \

awk ‘{print $num}’ specific nth keyword \

#### kubectl completion
source < (kubectl completion bash)
#### Experience
##### 真题
CKA考试经验总结 2019/1/19\
https://www.jianshu.com/p/135c1d618a79 \
https://lupeier.com/post/cka-preparation-experience/

1. kubectl get pv --sort-by=.metadata.name

2. kubectl logs $podname | grep error > $filename

3. count the noReachable node

   1. kubectl get nodes

   2. ```bash
      JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}' \
       && kubectl get nodes -o jsonpath="$JSONPATH" | grep "Ready=True"
      ```
   
4. Create pod names nginx,assign it to disk=stat

   1. kubectl run nginx --image=nginx --restart=Never --dry-run > 4.yaml
   2.  https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector   
   
5. Create a pod with a ini container,and create a empyt file,if the file is not there ,exit form the pod

   1. https://kubernetes.io/docs/concepts/workloads/pods/init-containers/#using-init-containers

6. Create a pod names test includes four images nginx,reds,memcached, busybox

   1. kubectl run test --image=nginx --image=redis --image=memcached --image=busybox --restart=Never -n $namespace
7. Create a pod the image is nginx ,volume name is cache-volume under /data folder,and volume is non-Persistent


​    


CKA 习题和真题汇总 \
https://blog.csdn.net/fly910905/article/details/103553839 

CKA考试总结分享 \
https://blog.51cto.com/9406836/2418780 

kubernetes学习：CKA考试题 \
https://www.cnblogs.com/haoprogrammer/p/11149661.html 

CKA题库 \
https://www.jxhs.me/2019/11/17/CKA%E9%A2%98%E5%BA%93/ \
##### 提示
https://qiita.com/oke-py/items/46ecb3f530a92273b130

##### 学习内容

* 『Kubernetes完全ガイド』
を読んで手を動かしてみる
minikubeやGKE（Google Kubernetes Engine）で実際に操作することで理解が深まりました。
4〜13、19章の内容は押さえておくとよいでしょう。
* cka 90% 以上

##### bookmark
https://kubernetes.io/docs/
https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands
https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/


CKA + CKAD Exam Tips \
https://training.linuxfoundation.org/wp-content/uploads/2020/01/Important-Tips-CKA-CKAD-01.28.2020.pdf \
CKA + CKAD Candidate Handbook \
https://training.linuxfoundation.org/wp-content/uploads/2020/01/CKA-CKAD-Candidate-Handbook-v1.8.pdf \
CKA + CKAD FAQ \
https://training.linuxfoundation.org/wp-content/uploads/2020/01/CKA-CKAD-FAQ-01.28.2020.pdf \
考试小贴士 \
https://training.linuxfoundation.cn/ueditor/php/upload/file/20200131/1580432116220882.pdf \
cka以及ckad常见问题 \
https://training.linuxfoundation.cn/ueditor/php/upload/file/20200131/1580432142740915.pdf \
cka以及ckad考生手册 \
https://training.linuxfoundation.cn/ueditor/php/upload/file/20200131/1580432168844194.pdf \
保密协议 \
https://training.linuxfoundation.org/wp-content/uploads/2019/05/Certification-and-Confidentiality-Agreement-CNCF-v1.2.pdf \


#### coupon 使用
