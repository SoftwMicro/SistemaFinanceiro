#!/bin/bash

# Sistema Financeiro - Docker Run Script (WSL/Linux)
# Este script roda a aplicação conectando ao MySQL existente na rede 'yamls_default'

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   Sistema Financeiro - Docker Run (WSL/Linux)                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Verificar se Docker está rodando
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Docker não está rodando. Inicie o Docker e tente novamente."
    exit 1
fi

# Verificar se a imagem existe
if ! docker images sistema-financeiro:latest --quiet | grep -q .; then
    echo "❌ Imagem 'sistema-financeiro:latest' não encontrada."
    echo "📝 Para buildar a imagem, execute:"
    echo "   docker build -t sistema-financeiro:latest ."
    exit 1
fi

# Verificar se o container mysql-dev está rodando
if ! docker ps | grep -q mysql-dev; then
    echo "⚠️  Container 'mysql-dev' não está rodando."
    echo "📝 Para iniciar o MySQL, execute:"
    echo "   docker run -d --name mysql-dev --network yamls_default \\"
    echo "     -e MYSQL_ROOT_PASSWORD=root123 \\"
    echo "     -e MYSQL_DATABASE=pedidos \\"
    echo "     -e MYSQL_USER=admin \\"
    echo "     -e MYSQL_PASSWORD=010101 \\"
    echo "     -p 3306:3306 mysql:8.0"
    exit 1
fi

echo "✅ Docker está rodando"
echo "✅ Imagem 'sistema-financeiro:latest' encontrada"
echo "✅ Container 'mysql-dev' está rodando"
echo ""

echo "🚀 Iniciando aplicação..."
echo "📝 Acesse em:"
echo "   🌐 http://localhost:8080"
echo "   📚 Swagger UI: http://localhost:8080/swagger-ui.html"
echo "   📋 OpenAPI: http://localhost:8080/v3/api-docs"
echo ""
echo "⏹️  Pressione Ctrl+C para parar"
echo ""

# Rodar o container
docker run --rm -p 8080:8080 --network yamls_default \
  -e SPRING_PROFILES_ACTIVE=docker \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://mysql-dev:3306/pedidos?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" \
  -e SPRING_DATASOURCE_USERNAME="admin" \
  -e SPRING_DATASOURCE_PASSWORD="010101" \
  sistema-financeiro:latest

echo ""
echo "✅ Container parado."

