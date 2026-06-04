#!/bin/bash

# Sistema Financeiro - Update Docker Script (WSL/Linux)
# Automatiza: git pull -> docker build -> docker run

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Sistema Financeiro - Update Docker (WSL/Linux)             ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 1. Verificar Git
if [ ! -d .git ]; then
    echo -e "${RED}❌ Não estou em um repositório Git.${NC}"
    echo "   Navegue até o projeto e tente novamente."
    exit 1
fi

# 2. Pull
echo -e "${YELLOW}[1/4] Puxando alterações do repositório...${NC}"
git pull origin main 2>/dev/null || git pull origin $(git rev-parse --abbrev-ref HEAD)
echo -e "${GREEN}✅ Repositório atualizado${NC}"

# 3. Mostrar último commit
echo ""
echo -e "${CYAN}📝 Último commit:${NC}"
git log --oneline -1
echo ""

# 4. Verificar se Docker está rodando
echo -e "${YELLOW}[2/4] Verificando Docker...${NC}"
if ! docker ps > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker não está rodando.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Docker está ativo${NC}"

# 5. Remover imagem antiga
echo ""
echo -e "${YELLOW}[3/4] Limpando imagem antiga...${NC}"
if docker images sistema-financeiro:latest --quiet | grep -q .; then
    docker rmi sistema-financeiro:latest > /dev/null 2>&1
    echo -e "${GREEN}✅ Imagem antiga removida${NC}"
else
    echo -e "${CYAN}ℹ️  Nenhuma imagem anterior encontrada${NC}"
fi

# 6. Build
echo ""
echo -e "${YELLOW}[4/4] Buildando nova imagem...${NC}"
if docker build -t sistema-financeiro:latest . > /tmp/docker_build.log 2>&1; then
    echo -e "${GREEN}✅ Build concluído com sucesso${NC}"
else
    echo -e "${RED}❌ Erro durante o build. Veja os logs:${NC}"
    cat /tmp/docker_build.log
    exit 1
fi

# 7. Informar próximos passos
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           ✅ Tudo pronto! Pronto para rodar!                   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}📌 Para rodar a aplicação, execute:${NC}"
echo -e "   ${YELLOW}./run-docker-final.sh${NC}"
echo ""

echo -e "${CYAN}🌐 Endpoints disponíveis:${NC}"
echo -e "   ${YELLOW}http://localhost:8080${NC} (Aplicação)"
echo -e "   ${YELLOW}http://localhost:8080/swagger-ui.html${NC} (Swagger UI)"
echo -e "   ${YELLOW}http://localhost:8080/v3/api-docs${NC} (OpenAPI)"
echo ""

# Perguntar se quer rodar agora
read -p "Deseja rodar a aplicação agora? (s/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo -e "${YELLOW}🚀 Iniciando aplicação...${NC}"
    echo ""
    ./run-docker-final.sh
fi

