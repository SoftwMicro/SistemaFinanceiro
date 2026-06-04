# WSL/Linux Docker Setup - Sistema Financeiro

Você está usando **Docker em WSL/Linux**, não Docker Desktop nativo do Windows.

## ⚠️ Importante: host.docker.internal NÃO funciona em WSL

- ✅ Windows Docker Desktop: `host.docker.internal` → acessa a máquina host
- ❌ WSL/Linux Docker: `host.docker.internal` → NÃO EXISTE (gera erro UnknownHostException)

**Solução:** Use `localhost` ou o IP do container MySQL.

## 🚀 Quick Start: Script Automático (Recomendado)

```powershell
cd C:\Projetos\SistemaFinanceiro
.\run-docker-wsl.ps1
```

Este script:
1. Lista containers MySQL rodando
2. Descobre o IP automaticamente
3. Pede credenciais
4. Constrói a imagem se necessário
5. Roda a aplicação com configuração correta

## 🔧 Opção 1: MySQL rodando no host WSL

Se o MySQL está rodando no seu WSL (ex: `mysql -u admin -p`):

```powershell
docker build -t sistema-financeiro:latest .

docker run --rm -p 8080:8080 `
  -e SPRING_DATASOURCE_URL="jdbc:mysql://localhost:3306/pedidos?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" `
  -e SPRING_DATASOURCE_USERNAME="admin" `
  -e SPRING_DATASOURCE_PASSWORD="010101" `
  sistema-financeiro:latest
```

## 🔧 Opção 2: MySQL em outro container Docker

Se o MySQL está em um container (ex: `mysql-financeiro`):

### Passo 1: Descobrir IP do container MySQL

```powershell
# Listar containers
docker ps

# Obter IP (substitua mysql-financeiro pelo nome do seu container)
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql-financeiro
# Output: 172.17.0.2
```

### Passo 2: Rodar a app apontando para esse IP

```powershell
docker build -t sistema-financeiro:latest .

docker run --rm -p 8080:8080 `
  -e SPRING_DATASOURCE_URL="jdbc:mysql://172.17.0.2:3306/pedidos?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" `
  -e SPRING_DATASOURCE_USERNAME="admin" `
  -e SPRING_DATASOURCE_PASSWORD="010101" `
  sistema-financeiro:latest
```

**Ou, use o container name se ambos estiverem na mesma bridge network:**

```powershell
docker run --rm -p 8080:8080 `
  --network bridge `
  -e SPRING_DATASOURCE_URL="jdbc:mysql://mysql-financeiro:3306/pedidos?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" `
  -e SPRING_DATASOURCE_USERNAME="admin" `
  -e SPRING_DATASOURCE_PASSWORD="010101" `
  sistema-financeiro:latest
```

## 🔧 Opção 3: Criar uma rede Docker customizada (Melhor prática)

Cria um isolamento melhor entre containers:

```powershell
# Criar rede
docker network create financeiro-net

# Rodar MySQL nessa rede
docker run -d --name mysql-financeiro --network financeiro-net `
  -e MYSQL_ROOT_PASSWORD=root123 `
  -e MYSQL_DATABASE=pedidos `
  -e MYSQL_USER=admin `
  -e MYSQL_PASSWORD=010101 `
  -p 3306:3306 `
  mysql:8.0

# Rodar a app nessa rede (aguarde MySQL ficar pronto ~10s)
docker run --rm -p 8080:8080 --network financeiro-net `
  -e SPRING_DATASOURCE_URL="jdbc:mysql://mysql-financeiro:3306/pedidos?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" `
  -e SPRING_DATASOURCE_USERNAME="admin" `
  -e SPRING_DATASOURCE_PASSWORD="010101" `
  sistema-financeiro:latest
```

## 🐛 Se ainda não conectar

1. **Verifique se MySQL está acessível:**
```powershell
# A partir de outro terminal, tente conectar
mysql -h 127.0.0.1 -P 3306 -u admin -p010101
```

2. **Verifique os logs do container:**
```powershell
docker logs -f <container-id>
```

3. **Verifique a rede:**
```powershell
# Ver containers na rede
docker network inspect bridge

# Ou
docker network inspect financeiro-net
```

4. **Teste a conectividade dentro do container:**
```powershell
# Execute um comando dentro do container rodando
docker exec <container-id> curl http://mysql-financeiro:3306
```

## 📋 Resumo: WSL vs Windows Docker Desktop

| Aspecto | WSL Docker | Windows Docker Desktop |
|---------|-----------|----------------------|
| `host.docker.internal` | ❌ Não existe | ✅ Funciona |
| `localhost` com MySQL no host | ✅ Funciona | ❌ Não funciona |
| Container names | ✅ Funciona (mesma rede) | ✅ Funciona (mesma rede) |
| IP do container | ✅ Funciona | ✅ Funciona |

## ✅ IntelliJ Local (não afetado)

Continua funcionando normalmente com `application.properties` (usa `localhost`):

```powershell
cd C:\Projetos\SistemaFinanceiro
./mvnw spring-boot:run
```

