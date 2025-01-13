USE mini_mercado_virtual;
/*
  Cria uma nova instancia da entidade endereco populando os seguintes valores:
  uf (unidade federativa, estado), cidade, cep (codigo de enderecamento postal,
  bairro, logradouro (rua) e o numero da residencia.
*/
INSERT INTO endereco (uf, cidade, cep, bairro, logradouro, numero)
VALUES ("SP", "Sao Paulo", "01153000", "Barra Funda", "Vitorino Carmilo", 156);

/*
  Cria nova instancia da entidade cliente utilizando os campos: nome (nome
  completo), email (valor unico) e senha. email e senha serao utilizados
  posteriormente na autenticacao de cada usuario e por esse motivo que o valor
  contido no campo email deve ser unico.
*/
INSERT INTO cliente (nome, email, senha)
VALUES ("Romario Roberto de Lima", "orlando@hotmail.com", "Password213*")
     , ("Ronaldo Nazario da Silva", "ronaldo@hotmail.com", "GolPass09*");

/*
  Responsavel pela linkagem dos clientes aos enderecos presentes no banco de
  dados. Tudo isso e feito por meio dos identificadores de cada instancia
  (cliente, endereco) a ser utilizada na relacao.
*/
INSERT INTO cliente_endereco (id_cliente, id_endereco)
VALUES (1, 1), (2, 1);

/*
  Cria nova instancia da entidade cliente preenchendo os campos: descricao
  (informacao de identificacao a nivel de usuario), valor (preco de uma unica
  unidade), estoque (quantidade de produto ainda disponiveis para venda).
*/
INSERT INTO produto (descricao, valor, estoque)
VALUES ("Mouse sem fio Logitech Trackball ERGO M575S", 325.90, 20)
     , ("Art of Computer Programming, The, Volumes 1-4B", 1984.68, 1)
     , ("Faca Diutac - Nautika", 96.90,	10)
     , ("Concrete Mathematics: A Foundation for Computer Science", 549.56, 4)
;

/*
  Nova instancia de pedido utilizando ID de instancia de cliente em atividade e
  o endereco correto da tabela de juncao cliente e endereco.
*/

INSERT INTO pedido (id_cliente, id_endereco)
SELECT c.id_cliente
     , e.id_endereco
  FROM cliente_endereco AS ce
 INNER JOIN cliente AS c
    ON c.id_cliente = ce.id_cliente
 INNER JOIN endereco AS e
    ON e.id_endereco = ce.id_endereco;

/*
  Nova instancia da entidade pedido_produto, responsavel pela relacao entre a
  quantidade de produtos em um pedido.
*/
INSERT INTO pedido_produto (id_pedido, id_produto, quantidade, somatorio)
SELECT ppq.id_pedido
     , ppq.id_produto
     , ppq.quantidade
     , p.valor * ppq.quantidade
  FROM (SELECT 1 AS id_pedido
             , 1 AS id_produto
	     , 2 AS quantidade 
	 UNION ALL
        SELECT 2
	     , 2
	     , 1) AS ppq
 INNER JOIN produto AS p
    ON p.id_produto = ppq.id_produto;
