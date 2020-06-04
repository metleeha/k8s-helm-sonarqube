# Install Sonarqube on Kubernetes Cluster (Helm ver.3)

## git clone
git을 로컬에 복제합니다. 
아래 명령어를 수행하시면 됩니다. 
```bash
git clone http://9.21.104.136:8001/root/k8s-sonarqube.git
```
## IBM Cloud Login
IBM Cloud에 로그인 합니다.
Acacemy 교육시 수행한 핸즈온 문서를 참조 합니다.

## Kubernetes Cluster에 네임스페이스 생성
namespace는 본인에게 주어진 번호를 사용하여 labXX로 생성합니다.
예를들어 본인의 번호가 99번의 경우 lab99 을 사용 합니다.
```bash
kubectl create namesapce lab99
```

## Postgre
### PostgreSQL PV 생성
복제한 git 폴더에서 pv.yaml을 열어서 아래 부분을 수정 합니다.
pv생성시 사용하는 pv명은 `lab99`-postgre-pv 로 prefix만 수정합니다.(중요)
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: lab99-postgre-pv # modify
  namespace: lab99 # modify
  labels:
    type: postgre
```
수정을 완료 하였으면 다시한번 `labXX` 규칙에 맞게 수정하였는지 확인합니다.
확인 완료 후 아래 명령을 수행 합니다.
```bash
kubectl create -f pv.yaml
```

### PostgreSQL PVC 생성
복제한 git 폴더에서 pvc.yaml을 열어서 아래 부분을 수정 합니다.
pcc명은 `lab99`-postgre-pvc 로 prefix만 수정 합니다. (중요)
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: lab99-postgre-pvc # modify
  namespace: lab99 # modify
  labels:
    type: postgre
```
수정을 완료 하였으면 다시한번 labXX 규칙에 맞게 수정하였는지 확인합니다.
확인 완료 후 아래 명령을 수행 합니다.
```bash
kubectl create -f pvc.yaml
```

## Sonarqube
### Sonarqube PV 생성
복제한 git 폴더에서 pv.yaml을 열어서 아래 부분을 수정 합니다.
pv생성시 사용하는 pv명은 `lab99`-sonarqube-pv 로 prefix만 수정합니다.(중요)
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: lab99-sonarqube-pv # modify
  namespace: lab99 # modify
  labels:
    type: sonarqube
```
수정을 완료 하였으면 다시한번 `labXX` 규칙에 맞게 수정하였는지 확인합니다.
확인 완료 후 아래 명령을 수행 합니다.
```bash
kubectl create -f pv.yaml
```

### Sonarqube PVC 생성
복제한 git 폴더에서 pvc.yaml을 열어서 아래 부분을 수정 합니다.
pcc명은 `lab99`-sonarqube-pvc 로 prefix만 수정 합니다. (중요)
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: lab99-sonarqube-pvc # modify
  namespace: lab99 # modify
  labels:
    type: sonarqube
```
수정을 완료 하였으면 다시한번 labXX 규칙에 맞게 수정하였는지 확인합니다.
확인 완료 후 아래 명령을 수행 합니다.
```bash
kubectl create -f pvc.yaml
```

## Helm(ver.3) 이용해 Sonarqube 설치
helm3 버전 체크 
```bash
helm version
```
helm repo 업데이트 
```bash
helm repo update
```

### `./postgre/` helm으로 postgreSQL 설치 실행
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install [labXX]-postgresql bitnami/postgresql -f values.yaml
```

### `./sonarqube/` helm 으로 Sonarqube 설치 실행 
```bash
helm repo add oteemo https://oteemo.github.io/charts/
helm install [labXX] oteemo/sonarqube -f values.yaml
```

## Sonarqube 설치 확인 및 로그인
설치된 서비스의 포트 번호 확인 
```bash
kubectl get svc 
```
```bash
kubectl get svc [labXX]-sonarqube --output yaml
```
노드 정보 확인 
- kubernetes dashboard 포드 정보 > Node 주소 클릭 > Export IP Adress 확인 

예시 : `https://[Node Export IP]:[32XXX]`
명령어로 찾은 password를 사용해 admin으로 로그인 