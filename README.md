# Install Sonarqube on Kubernetes Cluster (Helm ver.3)

## 선행 조건
- IBM Cloud login
    ```bash
    ibmcloud login --sso
    ibmcloud target -g klab-cloud-academy
    # ibm cloud cluster 대시보드에서 CLI 접속 토큰 확인
    ibmcloud ks cluster config --cluster [TOKEN]
    ```
- Kubernetes Cluster 네임스페이스 생성
    ```bash
    kubectl create namespace [labXX]
    ```
- Kubernetes Cluster 네임스페이스 기본 설정 
    ```bash
    kubectl config set-context --current --namespace=[labXX]
    ```
### postgreSQL 설치 values.yaml 파일 설정
### Sonarqube 설치 values.yaml 파일 설정
1. pvc 이름 변경


## Postgre
### PostgreSQL PV 생성
```bash
kubectl create -f pv.yaml
```
### PostgreSQL PVC 생성
```bash
kubectl create -f pvc.yaml
```
## Sonarqube
### Sonarqube PV 생성
```bash
kubectl create -f pv.yaml
```
### Sonarqube PVC 생성
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
#### 실행 결과창
```bash

```

### `./sonarqube/` helm 으로 Sonarqube 설치 실행 
```bash
helm repo add oteemo https://oteemo.github.io/charts/
helm install [labXX]-sonarqube oteemo/sonarqube -f values.yaml
```

## Sonarqube 설치 확인 및 로그인
설치된 Sonarqube 컨테이너의 Node Export IP Adress에 설정한 nodePort 번호를 붙여 접속
예시 : `https://[Node Export IP]:[3200XX]`
명령어로 찾은 password를 사용해 admin으로 로그인 