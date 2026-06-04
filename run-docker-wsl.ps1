# PowerShell script para encontrar IP do container MySQL e rodar a aplicação

Write-Host @"
╔════════════════════════════════════════════════════════════════╗
║       Sistema Financeiro - Docker Run (WSL/Linux Setup)       ║
╚════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# 1. Listar containers MySQL rodando
Write-Host "`n[*] Procurando containers MySQL...`n" -ForegroundColor Yellow

$mysqlContainers = docker ps --filter "ancestor=mysql" --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}" 2>$null

if ([string]::IsNullOrEmpty($mysqlContainers)) {
    Write-Host "[-] Nenhum container MySQL encontrado rodando." -ForegroundColor Red
    Write-Host ""
    Write-Host "Opções:" -ForegroundColor Yellow
    Write-Host "  1. Iniciar MySQL container antes de rodar a aplicação"
    Write-Host "  2. Informar o hostname/IP do MySQL manualmente"
    Write-Host ""
    $choice = Read-Host "Opção (1 ou manualmente informar)"

    if ($choice -eq "1") {
        Write-Host "`n[*] Iniciando MySQL..." -ForegroundColor Yellow
        docker run -d --name mysql-financeiro `
            -e MYSQL_ROOT_PASSWORD=root123 `
            -e MYSQL_DATABASE=pedidos `
            -e MYSQL_USER=admin `
            -e MYSQL_PASSWORD=010101 `
            -p 3306:3306 `
            mysql:8.0
        Write-Host "[+] MySQL iniciado. Aguardando 10 segundos para ficar pronto..." -ForegroundColor Green
        Start-Sleep -Seconds 10
        $mysqlHost = "mysql-financeiro"
    } else {
        $mysqlHost = Read-Host "Informe o hostname/IP do MySQL (ex: localhost, 192.168.1.100, mysql-financeiro)"
    }
} else {
    Write-Host $mysqlContainers
    Write-Host ""
    $selectedContainer = Read-Host "Informe o nome do container MySQL (ex: mysql-financeiro)"

    # Obter IP do container
    Write-Host "`n[*] Obtendo IP do container '$selectedContainer'..." -ForegroundColor Yellow

    $mysqlIP = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $selectedContainer 2>$null

    if ([string]::IsNullOrEmpty($mysqlIP)) {
        Write-Host "[-] Não foi possível obter o IP." -ForegroundColor Red
        $mysqlHost = Read-Host "Informe o hostname/IP manualmente"
    } else {
        Write-Host "[+] IP encontrado: $mysqlIP" -ForegroundColor Green
        $mysqlHost = $mysqlIP
    }
}

# 2. Obter credenciais
Write-Host ""
$mysqlPort = Read-Host "Porta MySQL (padrão: 3306)"
if ([string]::IsNullOrWhiteSpace($mysqlPort)) { $mysqlPort = "3306" }

$dbUser = Read-Host "Usuário banco (padrão: admin)"
if ([string]::IsNullOrWhiteSpace($dbUser)) { $dbUser = "admin" }

$dbPassword = Read-Host "Senha banco (padrão: 010101)" -AsSecureString
$dbPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($dbPassword))
if ([string]::IsNullOrWhiteSpace($dbPasswordPlain)) { $dbPasswordPlain = "010101" }

# 3. Construir URL JDBC
$datasourceUrl = "jdbc:mysql://$mysqlHost`:$mysqlPort/pedidos?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"

Write-Host "`n[*] Configuração Final:" -ForegroundColor Cyan
Write-Host "  Host MySQL: $mysqlHost"
Write-Host "  Porta: $mysqlPort"
Write-Host "  Usuário: $dbUser"
Write-Host "  URL JDBC: $datasourceUrl"
Write-Host ""

# 4. Verificar se existe imagem
Write-Host "[*] Verificando imagem Docker..." -ForegroundColor Yellow
$imageExists = docker images sistema-financeiro:latest --quiet 2>$null

if ([string]::IsNullOrEmpty($imageExists)) {
    Write-Host "[-] Imagem 'sistema-financeiro:latest' não encontrada." -ForegroundColor Yellow
    $buildChoice = Read-Host "Deseja buildar agora? (s/n)"

    if ($buildChoice -eq "s" -or $buildChoice -eq "S") {
        Write-Host "`n[*] Construindo imagem..." -ForegroundColor Yellow
        docker build -t sistema-financeiro:latest .

        if ($LASTEXITCODE -ne 0) {
            Write-Host "[-] Build falhou!" -ForegroundColor Red
            exit 1
        }
        Write-Host "[+] Build concluído!" -ForegroundColor Green
    } else {
        Write-Host "[-] Imagem necessária para rodar. Abortando." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[+] Imagem encontrada!" -ForegroundColor Green
}

# 5. Rodar container
Write-Host "`n[*] Iniciando aplicação..." -ForegroundColor Cyan
Write-Host "[+] Acesse a aplicação em: http://localhost:8080" -ForegroundColor Green
Write-Host "[+] Swagger UI em: http://localhost:8080/swagger-ui.html" -ForegroundColor Green
Write-Host "`nCtrl+C para parar o container`n"

docker run --rm -p 8080:8080 `
    -e "SPRING_PROFILES_ACTIVE=docker" `
    -e "SPRING_DATASOURCE_URL=$datasourceUrl" `
    -e "SPRING_DATASOURCE_USERNAME=$dbUser" `
    -e "SPRING_DATASOURCE_PASSWORD=$dbPasswordPlain" `
    -e "JAVA_OPTS=-Xms256m -Xmx512m" `
    sistema-financeiro:latest

Write-Host "`n[+] Container parado." -ForegroundColor Green

