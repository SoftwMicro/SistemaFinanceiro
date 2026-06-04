#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Script para fazer commit e push das alterações no Windows

.DESCRIPTION
    Automatiza o fluxo de:
    1. Verificar mudanças
    2. Adicionar arquivos
    3. Criar commit
    4. Push para repositório

.EXAMPLE
    .\commit-and-push.ps1 "feat: adicionar novo endpoint"
#>

param(
    [string]$message = "update: alterações na aplicação"
)

# Cores para output
$success = @{ ForegroundColor = 'Green' }
$warning = @{ ForegroundColor = 'Yellow' }
$error_color = @{ ForegroundColor = 'Red' }
$info = @{ ForegroundColor = 'Cyan' }

Write-Host "`n╔════════════════════════════════════════════════════════════════╗" @info
Write-Host "║         Commit e Push - Sistema Financeiro                    ║" @info
Write-Host "╚════════════════════════════════════════════════════════════════╝`n" @info

# Verificar se estamos em um repositório Git
if (-not (Test-Path .git)) {
    Write-Host "❌ Não estou em um repositório Git. Navegue até o projeto primeiro." @error_color
    exit 1
}

# 1. Verificar status
Write-Host "[1/4] Verificando mudanças..." @warning
git status
Write-Host ""

$changes = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changes)) {
    Write-Host "ℹ️  Nenhuma mudança encontrada." @info
    exit 0
}

# Perguntar confirmação
Write-Host ""
$confirm = Read-Host "Deseja continuar com commit e push? (s/n)"
if ($confirm -ne 's' -and $confirm -ne 'S') {
    Write-Host "❌ Operação cancelada." @error_color
    exit 1
}

# 2. Adicionar tudo
Write-Host "`n[2/4] Adicionando arquivos..." @warning
git add .
Write-Host "✅ Arquivos adicionados" @success

# 3. Commit
Write-Host "`n[3/4] Criando commit..." @warning
git commit -m $message
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Commit criado: '$message'" @success
} else {
    Write-Host "❌ Erro ao criar commit" @error_color
    exit 1
}

# 4. Push
Write-Host "`n[4/4] Enviando para repositório (push)..." @warning

# Detectar branch atual
$branch = git rev-parse --abbrev-ref HEAD
git push origin $branch

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Push realizado na branch '$branch'" @success
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" @success
    Write-Host "║           ✅ Operação concluída com sucesso!                   ║" @success
    Write-Host "╚════════════════════════════════════════════════════════════════╝" @success
    Write-Host ""
    Write-Host "📝 Próximos passos no WSL:`n" @info
    Write-Host "   1. git pull origin $branch" @info
    Write-Host "   2. docker rmi sistema-financeiro:latest" @info
    Write-Host "   3. docker build -t sistema-financeiro:latest ." @info
    Write-Host "   4. ./run-docker-final.sh" @info
    Write-Host ""
} else {
    Write-Host "❌ Erro ao fazer push. Verifique sua conexão ou credenciais." @error_color
    exit 1
}

