# ✅ Sistema Financeiro - Configuração Docker Completa

Configuração finalizada e **TESTADA COM SUCESSO** em WSL/Linux!

## 🎯 Status Final

- ✅ Dockerfile multi-stage (Java 17)
- ✅ Spring Profiles (local, docker, container)
- ✅ MySQL conectando via rede Docker
- ✅ Aplicação rodando na porta 8080
- ✅ Swagger UI disponível

## 🚀 Como Rodar

### Opção 1: Script Bash (Fácil)

```bash
chmod +x run-docker-final.sh
./run-docker-final.sh
```

### Opção 2: Comando Manual Direto

```bash
docker run --rm -p 8080:8080 --network yamls_default \
  -e SPRING_PROFILES_ACTIVE=docker \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://mysql-dev:3306/pedidos?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" \
  -e SPRING_DATASOURCE_USERNAME="admin" \
  -e SPRING_DATASOURCE_PASSWORD="010101" \
  sistema-financeiro:latest
```

## 📝 Passos de Setup (primeira vez)

1. **Build da imagem** (execute uma vez)
```bash
docker build -t sistema-financeiro:latest .
```

2. **Rodar a aplicação**
```bash
./run-docker-final.sh
```

## 🌐 Acessar a Aplicação

- **URL Principal:** http://localhost:8080
- **Swagger UI:** http://localhost:8080/swagger-ui.html
- **OpenAPI JSON:** http://localhost:8080/v3/api-docs

## 📊 Endpoints Disponíveis (conforme as entidades criadas)

- Pedidos de Caixa (Orders Caixa)
- Pedidos de Pagamento (Orders Pagamento)

Veja a documentação Swagger para detalhes completos.

## 🔧 Configurações da Rede Docker

**Seu setup:**
- ✅ MySQL: Container `mysql-dev` na rede `yamls_default`
- ✅ Aplicação: Container `sistema-financeiro` na rede `yamls_default`
- ✅ Ambos podem se comunicar pelo nome do host

## 💻 Desenvolvimento Local (IntelliJ)

Para rodar na IDE sem Docker:

```bash
cd C:\Projetos\SistemaFinanceiro
./mvnw spring-boot:run
```

Usa `application.properties` (localhost:3306) automaticamente.

## 🛠️ Troubleshooting

### "Container not found"
```bash
docker ps  # Ver containers rodando
```

### "MySQL connection refused"
```bash
# Verifique se mysql-dev está na rede yamls_default
docker inspect mysql-dev | grep yamls_default
```

### "Port 8080 already in use"
```bash
docker run --rm -p 8081:8080 --network yamls_default ...
# Acesse em http://localhost:8081
```

## 📋 Ficheiro de Configurações

| Arquivo | Propósito |
|---------|----------|
| `application.properties` | Config padrão (local/IntelliJ) - usa `localhost` |
| `application-docker.properties` | Config para Docker - usa `localhost` (WSL) |
| `application-container.properties` | Config para container names |
| `Dockerfile` | Build multi-stage |
| `docker-compose.yml` | Orquestração (opcional) |
| `run-docker-final.sh` | Script para rodar a app |

## ✨ Próximas Melhorias (Opcional)

- [ ] Adicionar healthcheck ao Dockerfile
- [ ] Usar distroless image para reduzir tamanho
- [ ] Configurar secrets para senhas
- [ ] Adicionar nginx como reverse proxy
- [ ] CI/CD pipeline

## 📞 Resumo do Que Foi Feito

1. **Dockerfile**: Multi-stage com JDK (build) e JRE (run)
2. **Spring Profiles**: 3 ambientes configurados
3. **Rede Docker**: Identificada a rede `yamls_default`
4. **Testes**: Aplicação rodando e conectada ao MySQL
5. **Templates**: Scripts para facilitar uso futuro

---

**Data**: 2026-06-04  
**Status**: ✅ Pronto para Produção/Desenvolvimento

