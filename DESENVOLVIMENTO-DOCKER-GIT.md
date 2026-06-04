# 🔄 Fluxo de Desenvolvimento com Docker e Git

Guia prático para fazer alterações, commitar e rodar no Docker.

## 📋 Fluxo Completo

### **Passo 1: Alterar Código no Windows (IDE/IntelliJ)**

```
1. Abra o projeto em C:\Projetos\SistemaFinanceiro no IntelliJ
2. Faça alterações no controller/service/etc
3. Teste localmente se quiser (./mvnw spring-boot:run)
```

Exemplo: Alterar endpoint em `src/main/java/com/financeiro/financeiro/controller/OrdersPagamentoController.java`

### **Passo 2: Commit e Push (Windows - PowerShell)**

```powershell
cd C:\Projetos\SistemaFinanceiro

# Ver alterações
git status

# Adicionar tudo
git add .

# Commit com mensagem descritiva
git commit -m "feat: alterar endpoint de pagamentos para retornar mais dados"

# Push para repositório
git push origin main
# (ou git push origin sua-branch)
```

### **Passo 3: Pull no WSL (Linux)**

```bash
cd /caminho/do/projeto  # Navegue até o projeto clonado no WSL

# Atualizar tudo do repositório
git pull origin main
# (ou git pull origin sua-branch)

# Verificar que as mudanças foram baixadas
git log --oneline -5  # Ver últimos commits
```

### **Passo 4: Reconstruir a Imagem Docker**

```bash
# Parar o container anterior (se estiver rodando)
# (Ctrl+C no terminal onde o docker run está ativo)

# Delete a imagem antiga (opcional, mas recomendado)
docker rmi sistema-financeiro:latest

# Buildar nova imagem
docker build -t sistema-financeiro:latest .
```

**Saída esperada:**
```
[+] Building 45.2s (11/11) FINISHED
 => [internal] load build definition from Dockerfile
 => ...
 => => naming to docker.io/library/sistema-financeiro:latest
```

### **Passo 5: Rodar a Nova Versão**

```bash
# Opção 1: Usando o script
chmod +x run-docker-final.sh
./run-docker-final.sh

# Opção 2: Comando direto
docker run --rm -p 8080:8080 --network yamls_default \
  -e SPRING_PROFILES_ACTIVE=docker \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://mysql-dev:3306/pedidos?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" \
  -e SPRING_DATASOURCE_USERNAME="admin" \
  -e SPRING_DATASOURCE_PASSWORD="010101" \
  sistema-financeiro:latest
```

### **Passo 6: Testar a Alteração**

```bash
# A aplicação está rodando em http://localhost:8080
# Acesse:
# - http://localhost:8080/swagger-ui.html (Swagger UI)
# - Ou use curl/Postman para testar endpoints
```

---

## 🎯 Exemplo Prático Completo

### Cenário: Alterar endpoint de Pagamento

**Windows (PowerShell):**
```powershell
cd C:\Projetos\SistemaFinanceiro

# 1. Alterar o arquivo no IntelliJ (adicionar novo campo na resposta)
# Editar: src/main/java/com/financeiro/financeiro/controller/OrdersPagamentoController.java

# 2. Commit
git add .
git commit -m "feat: adicionar novo campo 'dataPagamento' no endpoint GET /pagamentos"
git push origin main
```

**WSL (Bash):**
```bash
cd ~/SistemaFinanceiro  # ou caminho do seu projeto

# 1. Baixar mudanças
git pull origin main

# 2. Reconstruir Docker
docker rmi sistema-financeiro:latest  # Remover imagem antiga
docker build -t sistema-financeiro:latest .

# 3. Rodar nova versão
./run-docker-final.sh

# 4. Testar
curl http://localhost:8080/swagger-ui.html
# Ou acesse em http://localhost:8080/swagger-ui.html no navegador
```

---

## ⚡ Atalhos Úteis

### Script Bash para Automatizar Tudo

Crie um arquivo `update-docker.sh` no WSL:

```bash
#!/bin/bash
set -e

echo "🔄 Atualizando repositório..."
git pull origin main

echo "🗑️  Removendo imagem antiga..."
docker rmi sistema-financeiro:latest 2>/dev/null || true

echo "🔨 Buildando nova imagem..."
docker build -t sistema-financeiro:latest .

echo "✅ Build completo!"
echo "🚀 Para rodar, execute: ./run-docker-final.sh"
```

Use assim:
```bash
chmod +x update-docker.sh
./update-docker.sh
```

### PowerShell (Windows) - Build e Push

Crie `build-and-push.ps1`:

```powershell
param(
    [string]$message = "update: aplicação atualizada"
)

Write-Host "📝 Adicionando arquivos..." -ForegroundColor Yellow
git add .

Write-Host "💾 Commitando..." -ForegroundColor Yellow
git commit -m $message

Write-Host "📤 Push para repositório..." -ForegroundColor Yellow
git push origin main

Write-Host "✅ Done! Agora execute no WSL: chmod +x update-docker.sh && ./update-docker.sh" -ForegroundColor Green
```

Use assim (PowerShell):
```powershell
./build-and-push.ps1 "feat: novo endpoint"
```

---

## 🔍 Verificação de Status

### Ver commits
```bash
# Últimos commits
git log --oneline -10

# Ver branches
git branch -a

# Status atual
git status
```

### Ver imagens Docker
```bash
docker images | grep sistema-financeiro

# Ver containers rodando
docker ps
```

### Logs da aplicação
```bash
# Enquanto o container está rodando
docker logs -f <container-id>
```

---

## 🚨 Troubleshooting

### Erro: "cannot find module after git pull"

```bash
# Reconstruir dependências
./mvnw clean install

# Depois buildar Docker
docker build -t sistema-financeiro:latest .
```

### Erro: "port 8080 already in use"

```bash
# Parar container anterior
docker ps
docker stop <container-id>

# Ou rodar em outra porta
docker run --rm -p 8081:8080 ...
# Acesse em http://localhost:8081
```

### Quer descartar mudanças locais e puxar do repositório

```bash
# Reset hard (descarta tudo)
git reset --hard HEAD

# Pull
git pull origin main
```

---

## 📊 Resumo do Fluxo

```
Windows (IntelliJ)          GitLab/GitHub/etc         WSL (Linux)
       |                         |                        |
       | Alterar código          |                        |
       |-----------------------> |                        |
       |                         |                        |
       | Commit + Push           |                        |
       +-----------------------> |                        |
       |                         | Git Pull               |
       |                         |<-----------------------+
       |                         |                        |
       |                         |                Docker Build
       |                         |                        |
       |                         |                Docker Run
       |                         |                        |
       |                         |            Teste em localhost:8080
```

---

## ✅ Dica Final

**Sempre siga essa ordem:**
1. ✅ Alterar código
2. ✅ Testar localmente (opcional)
3. ✅ Commit + Push
4. ✅ Pull no WSL
5. ✅ Build Docker
6. ✅ Rodar container
7. ✅ Testar em http://localhost:8080

Pronto! Agora você tem um workflow completo de desenvolvimento com Docker! 🚀

