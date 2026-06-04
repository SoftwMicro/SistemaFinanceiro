# Script PowerShell para rodar a aplicação Docker conectando ao MySQL existente

Write-Host "[*] Sistema Financeiro - Docker Run Script" -ForegroundColor Cyan
Write-Host ""

# Verificar se Docker está rodando
try {
    $null = docker ps 2>&1
} catch {
    Write-Host "[-] Docker não está rodando. Inicie o Docker Desktop e tente novamente." -ForegroundColor Red
    exit 1
}

# Menu de opções
Write-Host "Escolha como conectar ao banco de dados:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1) MySQL no HOST (usando host.docker.internal) - Padrão para Windows Docker Desktop" -ForegroundColor Green
Write-Host "2) MySQL em outro container na mesma rede Docker"
Write-Host "3) MySQL em IP/hostname customizado"
Write-Host ""

$choice = Read-Host "Opção (1-3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "[*] Conectando ao MySQL no host via host.docker.internal" -ForegroundColor Yellow
        Write-Host ""

        $port = Read-Host "Porta do MySQL no host (padrão: 3306)"
        if ([string]::IsNullOrWhiteSpace($port)) { $port = "3306" }

        $db_user = Read-Host "Usuário do banco (padrão: admin)"
        if ([string]::IsNullOrWhiteSpace($db_user)) { $db_user = "admin" }

        $db_password = Read-Host "Senha do banco (padrão: 010101)"
        if ([string]::IsNullOrWhiteSpace($db_password)) { $db_password = "010101" }

        $datasource_url = "jdbc:mysql://host.docker.internal:$port/pedidos?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"

        Write-Host ""
        Write-Host "[+] Rodando container..." -ForegroundColor Green
        Write-Host ""

        docker run --rm -p 8080:8080 `
            -e "SPRING_DATASOURCE_URL=$datasource_url" `
            -e "SPRING_DATASOURCE_USERNAME=$db_user" `
            -e "SPRING_DATASOURCE_PASSWORD=$db_password" `
            -e "JAVA_OPTS=-Xms256m -Xmx512m" `
            sistema-financeiro:latest
    }

    "2" {
        Write-Host ""
        Write-Host "[*] Conectando ao MySQL em container Docker na mesma rede" -ForegroundColor Yellow
        Write-Host ""

        $mysql_host = Read-Host "Nome do container MySQL (ex: mysql-financeiro)"
        $mysql_port = Read-Host "Porta do MySQL (padrão: 3306)"
        if ([string]::IsNullOrWhiteSpace($mysql_port)) { $mysql_port = "3306" }

        $db_user = Read-Host "Usuário do banco (padrão: admin)"
        if ([string]::IsNullOrWhiteSpace($db_user)) { $db_user = "admin" }

        $db_password = Read-Host "Senha do banco (padrão: 010101)"
        if ([string]::IsNullOrWhiteSpace($db_password)) { $db_password = "010101" }

        $network = Read-Host "Nome da rede Docker (ex: bridge, ou deixe em branco para usar padrão)"

        $datasource_url = "jdbc:mysql://$mysql_host`:$mysql_port/pedidos?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"

        Write-Host ""
        Write-Host "[+] Rodando container..." -ForegroundColor Green
        Write-Host ""

        if ([string]::IsNullOrWhiteSpace($network)) {
            docker run --rm -p 8080:8080 `
                -e "SPRING_DATASOURCE_URL=$datasource_url" `
                -e "SPRING_DATASOURCE_USERNAME=$db_user" `
                -e "SPRING_DATASOURCE_PASSWORD=$db_password" `
                -e "JAVA_OPTS=-Xms256m -Xmx512m" `
                sistema-financeiro:latest
        } else {
            docker run --rm -p 8080:8080 --network $network `
                -e "SPRING_DATASOURCE_URL=$datasource_url" `
                -e "SPRING_DATASOURCE_USERNAME=$db_user" `
                -e "SPRING_DATASOURCE_PASSWORD=$db_password" `
                -e "JAVA_OPTS=-Xms256m -Xmx512m" `
                sistema-financeiro:latest
        }
    }

    "3" {
        Write-Host ""
        Write-Host "[*] Conectando ao MySQL em host customizado" -ForegroundColor Yellow
        Write-Host ""

        $mysql_host = Read-Host "Host/IP do MySQL"
        $mysql_port = Read-Host "Porta do MySQL (padrão: 3306)"
        if ([string]::IsNullOrWhiteSpace($mysql_port)) { $mysql_port = "3306" }

        $database = Read-Host "Nome do banco (padrão: pedidos)"
        if ([string]::IsNullOrWhiteSpace($database)) { $database = "pedidos" }

        $db_user = Read-Host "Usuário do banco (padrão: admin)"
        if ([string]::IsNullOrWhiteSpace($db_user)) { $db_user = "admin" }

        $db_password = Read-Host "Senha do banco (padrão: 010101)"
        if ([string]::IsNullOrWhiteSpace($db_password)) { $db_password = "010101" }

        $datasource_url = "jdbc:mysql://$mysql_host`:$mysql_port/$database`?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"

        Write-Host ""
        Write-Host "[+] Rodando container..." -ForegroundColor Green
        Write-Host ""

        docker run --rm -p 8080:8080 `
            -e "SPRING_DATASOURCE_URL=$datasource_url" `
            -e "SPRING_DATASOURCE_USERNAME=$db_user" `
            -e "SPRING_DATASOURCE_PASSWORD=$db_password" `
            -e "JAVA_OPTS=-Xms256m -Xmx512m" `
            sistema-financeiro:latest
    }

    default {
        Write-Host "[-] Opção inválida!" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "[+] Container parado." -ForegroundColor Green

