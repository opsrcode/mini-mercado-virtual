$root_password = ConvertFrom-SecureString -AsPlainText (Read-Host "Senha root"    -AsSecureString)
$username      = Read-Host "Usuário"
$user_password = ConvertFrom-SecureString -AsPlainText (Read-Host "Senha usuário" -AsSecureString)

# -[-e]xecute=, -[-p]assword=, -[-u]ser=, -[-v]erbose
mysql -u root -p"$root_password" -e "source ./schema_mini_mercado_virtual.sql"
mysql -u $username -p"$user_password" -e "source ./populate_mini_mercado_virtual.sql"
rm -Force ./relatorio.txt
mysql -vvv -u $username -p"$user_password"  -e "source ./teste_requisicao.sql"> ./relatorio.txt
