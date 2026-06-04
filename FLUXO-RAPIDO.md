# 🔄 FLUXO DE DESENVOLVIMENTO PRÁTICO

TL;DR - Guia rápido para alterar código, commitar e ver mudanças no Docker.

---

## 🖥️ WINDOWS (Fazer Alterações)

```powershell
# 1. Abrir projeto no IntelliJ
cd C:\Projetos\SistemaFinanceiro

# 2. Alterar código (ex: editar controller)
# ... faça as mudanças na IDE ...

# 3. Commit e Push (usar script)
.\commit-and-push.ps1 "feat: descrição sua alteração"

# Ou fazer manualmente:
git add .
git commit -m "feat: sua descrição"
git push origin main
```

---

## 🐧 WSL / LINUX (Atualizar Docker)

```bash
# 1. Entrar na pasta do projeto
cd ~/SistemaFinanceiro  # caminho do seu projeto no WSL

# 2. Pull + Build + Run automático
chmod +x update-docker.sh
./update-docker.sh

# O script perguntará se quer rodar. Responda "s" (sim)

# A aplicação inicia e está disponível em:
# http://localhost:8080
```

---

## ⚡ SUPER RÁPIDO (Uma Linha de Comando)

Se não quer usar scripts, comando único no WSL:

```bash
cd ~/SistemaFinanceiro && git pull origin main && \
docker build -t sistema-financeiro:latest . && \
./run-docker-final.sh
```

---

## 🔍 VERIFICAR STATUS

```bash
# Ver se atualizações foram puxadas
git log --oneline -3

# Ver imagens Docker
docker images | grep sistema-financeiro

# Ver containers rodando
docker ps

# Ver logs em tempo real
docker logs -f <container-id>
```

---

## 📋 CHECKLIST RÁPIDO

- [ ] Alterar código no Windows (IntelliJ)
- [ ] Executar `.\commit-and-push.ps1 "mensagem"` no PowerShell
- [ ] Esperar push terminar
- [ ] No WSL: `./update-docker.sh`
- [ ] Responder "s" para rodar a app
- [ ] Acessar http://localhost:8080
- [ ] Testar novo endpoint no Swagger UI

---

## 🎯 FLUXO VISUAL

```
┌──────────────────┐
│   WINDOWS        │
│   (IntelliJ)     │
│  Alterar Código  │
└────────┬─────────┘
         │
         │ commit-and-push.ps1
         │
         ▼
┌──────────────────┐
│  GitLab/GitHub   │
│   Repositório    │
└────────┬─────────┘
         │
         │ git pull
         │
         ▼
┌──────────────────┐
│   WSL/LINUX      │
│  update-docker.sh│
│  - git pull      │
│  - docker build  │
│  - docker run    │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  APLICAÇÃO NOVA  │
│  localhost:8080  │
│   Testando...    │
└──────────────────┘
```

---

## 🚀 EXEMPLO PRÁTICO REAL

**Cenário:** Você quer adicionar um novo endpoint

### Windows (PowerShell)
```powershell
cd C:\Projetos\SistemaFinanceiro

# Abrir IntelliJ e alterar arquivo:
# src/main/java/com/financeiro/financeiro/controller/OrdersPagamentoController.java
# Adicionar novo método GET

# Depois fazer commit
.\commit-and-push.ps1 "feat: adicionar endpoint GET /pagamentos/{id}/status"

# Output:
# ✅ Commit criado
# ✅ Push realizado na branch 'main'
# 📝 Próximos passos no WSL:
#    1. git pull origin main
#    2. docker build -t sistema-financeiro:latest .
#    3. ./run-docker-final.sh
```

### WSL (Bash)
```bash
cd ~/SistemaFinanceiro

./update-docker.sh

# Output:
# [1/4] Puxando alterações...
# ✅ Repositório atualizado
# 📝 Último commit: feat: adicionar endpoint GET /pagamentos/{id}/status
# [2/4] Verificando Docker...
# [3/4] Buildando com as alterações...
# ℹ️  Docker vai reutilizar cache para ir mais rápido
# [4/4] Compilando código nova...
# ✅ Build concluído com sucesso
#
# Deseja rodar a aplicação agora? (s/n) s
# 🚀 Iniciando aplicação...
```

### Testar
- Abra http://localhost:8080/swagger-ui.html
- Procure pelo novo endpoint `/pagamentos/{id}/status`
- Teste no Swagger UI
- ✅ Sucesso!

---

## 🆘 ERROS COMUNS

| Erro | Solução |
|------|---------|
| `docker: not found` | WSL Docker não está rodando. Inicie Docker Desktop |
| `fatal: not in a git repository` | Navegue até a pasta do projeto |
| `port 8080 already in use` | Mude para 8081: `-p 8081:8080` |
| `Connection refused` | MySQL não está rodando na rede `yamls_default` |
| `git: command not found` | Instale Git: `apt-get install git` (WSL) |

---

## 📚 MAIS DETALHES

Para documentação completa, veja:
- `DESENVOLVIMENTO-DOCKER-GIT.md` - Guia detalhado
- `DOCKER-SETUP-FINAL.md` - Configuração completa
- `WSL-DOCKER-SETUP.md` - Setup WSL específico

---

## ✨ RESUMO FINAL

**3 Passos Simples:**
1. 📝 Altere código (Windows/IntelliJ)
2. 📤 Execute `.\commit-and-push.ps1` (Windows/PowerShell)
3. 🚀 Execute `./update-docker.sh` (WSL/Bash)

**Pronto! Aplicação rodando com suas alterações em http://localhost:8080**

---

📅 Última atualização: 2026-06-04  
✅ Status: Ready for Development

