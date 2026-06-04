@echo off
REM Script para construir a imagem Docker da aplicação Financeiro

cd /d "%~dp0"

echo [*] Construindo imagem Docker: sistema-financeiro:latest
docker build -t sistema-financeiro:latest .

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [+] Build bem-sucedido!
    echo.
    echo [*] Para rodar o container conectando ao MySQL na máquina host:
    echo.
    echo    docker run --rm -p 8080:8080 ^
    echo      -e SPRING_DATASOURCE_URL="jdbc:mysql://host.docker.internal:3306/pedidos?useSSL=false" ^
    echo      -e SPRING_DATASOURCE_USERNAME="admin" ^
    echo      -e SPRING_DATASOURCE_PASSWORD="010101" ^
    echo      sistema-financeiro:latest
    echo.
    echo [*] Ou, se o MySQL está em outro container na mesma rede:
    echo.
    echo    docker run --rm -p 8080:8080 --network minha-rede ^
    echo      -e SPRING_DATASOURCE_URL="jdbc:mysql://mysql-financeiro:3306/pedidos?useSSL=false" ^
    echo      sistema-financeiro:latest
    echo.
    echo [*] Ou simplesmente rodar a aplicação:
    echo.
    echo    docker run --rm -p 8080:8080 sistema-financeiro:latest
    echo.
) else (
    echo.
    echo [-] Build falhou!
    exit /b 1
)

