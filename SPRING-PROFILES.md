# Spring Profiles Guide - Sistema Financeiro

Este projeto usa Spring Profiles para gerenciar diferentes configurações de ambiente.

## Perfis Disponíveis

### 1. **Padrão (localhost)** - Para desenvolvimento local no IntelliJ
- **Ativado por padrão** quando você executa sem especificar um perfil
- **Arquivo:** `application.properties`
- **URL do MySQL:** `jdbc:mysql://localhost:3306/pedidos`
- **Usuário:** `admin` (ou env var `DB_USERNAME`)
- **Senha:** `010101` (ou env var `DB_PASSWORD`)

**Como usar:**
```
No IntelliJ:
1. Clique em "Run" > "Run Configurations..."
2. Deixe vazio ou não configure nada especial
3. Execute a aplicação normalmente
```

### 2. **docker** - Para rodar a aplicação em Docker com MySQL no host
- **Arquivo:** `application-docker.properties`
- **URL do MySQL:** `jdbc:mysql://host.docker.internal:3306/pedidos`
- **Ativado com:** `-e SPRING_PROFILES_ACTIVE=docker` (Docker)

**Como usar:**
```powershell
# Build
docker build -t sistema-financeiro:latest .

# Run (ativa automaticamente o perfil 'docker' via Dockerfile)
docker run --rm -p 8080:8080 sistema-financeiro:latest
```

### 3. **container** - Para rodar em Docker com MySQL em outro container
- **Arquivo:** `application-container.properties`
- **URL do MySQL:** `jdbc:mysql://mysql-financeiro:3306/pedidos`
- **Ativado com:** `-e SPRING_PROFILES_ACTIVE=container` (Docker)

**Como usar:**
```powershell
# Build
docker build -t sistema-financeiro:latest .

# Run com perfil 'container' (MySQL em outro container da mesma rede)
docker run --rm -p 8080:8080 `
  -e SPRING_PROFILES_ACTIVE=container `
  --network bridge `
  sistema-financeiro:latest
```

## Resumo

| Ambiente | Perfil | Comando |
|----------|--------|---------|
| **IntelliJ Local** | (padrão/vazio) | Clique "Run" normalmente no IntelliJ |
| **Docker + MySQL no Host** | `docker` | `docker run ... sistema-financeiro:latest` (automático) |
| **Docker + MySQL em Container** | `container` | `docker run ... -e SPRING_PROFILES_ACTIVE=container ...` |

## Como sobrescrever configurações em runtime

Se precisar conectar a um MySQL diferente sem criar novo perfil:

```powershell
# Via env vars (sobrescreve application.properties)
docker run --rm -p 8080:8080 `
  -e SPRING_DATASOURCE_URL="jdbc:mysql://outro-host:3306/meu-db?useSSL=false" `
  -e SPRING_DATASOURCE_USERNAME="outro-user" `
  -e SPRING_DATASOURCE_PASSWORD="outra-senha" `
  sistema-financeiro:latest
```

## ✅ Confirmação: Alterações NÃO afetam IntelliJ local

- ✅ `application.properties` voltou a usar `localhost`
- ✅ Perfis Spring isolam as configurações de cada ambiente
- ✅ Executar no IntelliJ funciona normalmente (sem precisar mudar nada)
- ✅ Docker usa seu próprio perfil (`application-docker.properties`)

