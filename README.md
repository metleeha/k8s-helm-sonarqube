# Kubernetes Cluster에 Sonarqube 설치하기 
> Kubernetes Cluster에 Helm Chart로 Sonarqube 설치해보기 

이 튜토리얼은 쿠버네티스 클러스터 상에 Sonarqube를 설치하는 방법을 설명합니다. 쿠버네티스 클러스터는 로컬에서 설치해 사용하는 minikube, Public Cloud 플랫폼에서 제공하는 AWS EKS, GCP GKE, Azure AKS, IBM IKS 등 어떤 서비스를 사용해도 괜찮습니다.

## Sonarqube 란? 

소나큐브는 프로젝트의 품질을 관리할 수 있도록 여러가지 모니터링 툴을 제공하는 오슨소스 플랫폼입니다. 보통 소나큐브는 단독으로 사용되기 보다는 Jenkins 같은 CI 서버와 연동이 되어서 사용하며 Java를 포함한 20가지가 넘는 프로그래밍 언어 (예: C#, C/C++, Javascript 등)로 제작된 프로젝트의 모니터링을 제공합니다.

### Sonarqube의 장점
- 오픈소스 프로젝트(무료 사용)
- 심플하고 실용적인 UI 제공
- 테이블과 차트 이용해 프로젝트 개선사항 표기 
- 코드품질 개선을 위한 정보(소스 중복, 복잡도, 유닛 테스트 커버리지 및 잠재적인 버그 정보 등)를 프로젝트/파일 단위로 제공 

Jenkins와 연동해서 CI/CD 파이프라인을 구성해 사용하는 설정법은 DevOps Tool Chain 시리즈에 포함해 포스팅할 예정입니다. 
Sonarqube에 대해 좀 더 자세히 알고 싶으신 분들은 [슬라이드](https://www.slideshare.net/curvc/sonarqube-sonarqube)를 참고하거나, [공식문서](https://www.sonarqube.org/)를 찾아보세요.

## 선행 조건
- 커맨드 라인/터미널 접근
- 쿠버네티스 클러스터
- kubectl 명령 도구 구성
- Helm(ver.3) 

## Steps
- Sonarqube 배포를 위한 네임스페이스 생성
- PostgreSQL PersistentVolume/PersistentVolumeClaim 생성 
- Sonarqube PersistentVolume/PersistentVolumeClaim 생성
- Helm(ver.3)으로 PostgreSQL, Sonarqube 설치
- Sonarqube 설치 확인 및 로그인
- 정리하기

## Kubernetes Cluster에 네임스페이스 생성
Sonarqube 설치를 진행할 네임스페이스 생성 
```bash
kubectl create namesapce sonar-demo
```
결과창
```bash
namespace/sonar-demo created
```
## PstgreSQL PersistentVolume/PersistentVolumeClaim 생성
### PostgreSQL PV 생성
복제한 git 폴더에서 `postgre/pv.yaml`을 열어서 아래 부분을 수정 합니다.
pv생성시 사용하는 pv명은 `demo`-postgre-pv 로 prefix만 수정합니다.
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: demo-postgre-pv # modify
  namespace: sonar-demo # modify
  labels:
    type: postgre
```
수정 후 아래 명령을 수행 합니다.
```bash
kubectl create -f pv.yaml
```
### PostgreSQL PVC 생성
복제한 git 폴더에서 `postgre/pvc.yaml`을 열어서 아래 부분을 수정 합니다.
pv생성시 사용하는 pv명은 `demo`-postgre-pv 로 prefix만 수정합니다.
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: demo-postgre-pvc # modify
  namespace: sonar-demo # modify
  labels:
    type: postgre
```

## Sonarqube PersistentVolume/PersistentVolumeClaim 생성
### Sonarqube PV 생성
복제한 git 폴더에서 `sonarqube/pv.yaml`을 열어서 아래 부분을 수정 합니다.
pv생성시 사용하는 pv명은 `demo`-sonarqube-pv 로 prefix만 수정합니다.
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: demo-postgre-pv # modify
  namespace: sonar-demo # modify
  labels:
    type: sonarqube
...이하생략
```
수정 후 아래 명령을 수행 합니다.
```bash
kubectl create -f pv.yaml
```
### Sonarqube PVC 생성
복제한 git 폴더에서 `sonarqube/pvc.yaml`을 열어서 아래 부분을 수정 합니다.
pv생성시 사용하는 pv명은 `demo`-sonarqube-pv 로 prefix만 수정합니다.
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: demo-postgre-pvc # modify
  namespace: sonar-demo # modify
  labels:
    type: sonarqube
...이하생략
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
#### 리파지토리 추가   
helm 리파지토리를 추가 합니다.   
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami=
```
#### postgreSQL 설치   
helm 이름을 수정합니다. `demo`-postgre 의 prefix만 수정합니다.(중요)   
persistence.existingClaim 의 값을 생성한 pvc로 수정합니다. `demo`-postgre-pvc 에서 prefix만 수정합니다.(중요)   
namespace를 수정합니다.(중요)   
3개의 정보를 규칙에 따라 수정 하였으면, 다시 한번 수정된 내용을 확인하고 콘솔창에서 수정한 명령을 실행 합니다.   
```bash
helm install demo-postgre stable/postgresql \
--set persistence.existingClaim=demo-postgre-pvc \
--set persistence.enabled=false  \
--set postgresqlUsername=sonarUser  \
--set postgresqlPassword=sonarPass  \
--set postgresqlDatabase=sonarDB  \
--namespace sonar-demo
```

### `./sonarqube/` helm 으로 Sonarqube 설치 실행 
리파지토리 추가   
helm 리파지토리를 추가 합니다.   
```bash
helm repo add oteemo https://oteemo.github.io/charts/
```

sonarqube 설치   
helm 이름을 수정합니다. `demo`-sonarqube의 prefix만 수정합니다.(중요)   
postgresql.postgresqlServer 의 값을 수정합니다. `demo`-postgre-postgresql 에서 prefix만 수정합니다.(중요)   
namespace를 수정합니다.(중요)   
3개의 정보를 규칙에 따라 수정 하였으면, 다시 한번 수정된 내용을 확인하고 콘솔창에서 수정한 명령을 실행 합니다.   
```bash
helm install demo-sonarqube oteemo/sonarqube \
--set postgresql.postgresqlServer=demo-postgre-postgresql  \
--set service.type=NodePort  \
--set postgresql.enabled=false  \
--set postgresql.postgresqlUsername=sonarUser  \
--set postgresql.postgresqlPassword=sonarPass  \
--set postgresql.postgresqlDatabase=sonarDB  \
--namespace sonar-demo
```


## Sonarqube 설치 확인 및 로그인
show_url.sh 파일에 실행 권한을 줍니다.  
```bash
chmod 750 show_url.sh
```
명령어를 수행할때 입력값으로 네임스페이스 명을 사용합니다.
url 접속정보, 계정, 패스워드를 출력해 줍니다.   
```bash
./show_url.sh sonar-demo
```
콘솔 화면에 다음과 깉이 출력 됩니다.   
pod가 생성되는데 수분의 시간이 걸립니다. 
pod가 생성 완료 되었는지 확인 한 후 아래 url정보를 복사하여 브라우저에서 실행 합니다.    
```console
Sonarqube url is http://169.58.72.34:31108/login
ID is admin
admin passwd is admin
```

## 삭제하기   
삭제하는 명령입니다.   
삭제시 설정한 정보가 모두 사라지니 주의 하여 주세요.   
다른 사람의 리소스를 삭제하지 않도록 반드시 본인의 리소스를 확인 후 삭제하여 주세요.    
```bash
kubectl delete namespace sonar-demo
# helm 차트만 삭제
helm delete --purge demo-sonarqube
helm delete --purge demo-postgre
```


## Source Code
- [Git Repo](https://github.com/metleeha/k8s-helm-sonarqube.git)


## Reference
- Software Engineering Blog(July 5, 2020), http://utk-unm.blogspot.com/2014/09/sonarqube.html