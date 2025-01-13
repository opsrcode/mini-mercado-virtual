#!/bin/bash
# $ chmod +x ./gerar_relatorio.sh && ./gerar_relatorio.sh
 
# -[-p]assword=, -[-u]ser=, -[-v]erbose
sudo mariadb -u root -p < ./schema_mini_mercado_virtual.sql
mariadb -u opsrcode -p < populate_mini_mercado_virtual.sql
rm -f ./relatorio.txt
mariadb -vvv -u opsrcode -p < teste_requisicao.sql 2>&1 > ./relatorio.txt
