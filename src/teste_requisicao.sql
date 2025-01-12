USE mini_mercado_virtual;
/*
  Requisicao das informacoes basicas do cliente que registrou pedido no
  sistema.
*/
SELECT c.nome
     , c.email
     , DATE(p.data_inclusao)
     , c.status_cliente
  FROM pedido AS p
 INNER JOIN cliente AS c
    ON c.id_cliente = p.id_cliente;

/*
  Descricao detalhada de uma instancia de cliente, com todos os dados de
  localizacao relevantes.
*/
SELECT c.nome
     , c.email
     , c.senha
     , e.uf
     , e.cidade
     , e.bairro
     , e.logradouro
     , e.numero
  FROM cliente AS c
 INNER JOIN (cliente_endereco AS ce, endereco AS e)
    ON ce.id_cliente = c.id_cliente
   AND e.id_endereco = ce.id_endereco; 

/*
  Requisicao contendo descricao do produto em questao, basendo-se na premissa
  de que todos os produtos retornados estao abaixo de R$300.
*/
SELECT p.descricao
     , p.valor
  FROM produto p
 WHERE p.valor < 500;

/*
  Se ainda em andamento, o pedido sera retornado com as devidas informacoes
  solicitadas.
*/
SELECT p.id_pedido
     , c.nome
     , c.email
     , p.status_pedido
     , p.data_inclusao
  FROM pedido AS p
 INNER JOIN cliente AS c
    ON c.id_cliente = p.id_cliente
 WHERE p.status_pedido = true;

/* TODO
  Pedido_Produto, tive problemas em relacionar as tabelas cliente_endereco
  para obter informacoes do endereco, visto que nao possui ligacao de chave
  estrangeira com nenhuma outra tabela.
SELECT PE.id_pedido, C.nome, C.email, E.uf, E.cidade, E.bairro, E.logradouro,
       E.numero, PR.descricao, PR.valor, quantidade, somatorio,
       DATE(PE.data_inclusao), PE.status_pedido
FROM Pedido_Produto AS PP
INNER JOIN (Pedido AS PE, Cliente AS C, Endereco AS E, Produto AS PR)
ON PE.id_pedido=PP.id_pedido AND C.id_cliente=PE.id_cliente
AND PR.id_produto=PP.id_produto AND E.id_endereco=C.id_endereco;
*/

/*
  Solicita os dados de inclusao, quantidades e valor total de acordo com o dia
  especificado na instrucao 'WHERE'. Basicamente, o extrato do dia.
*/
 SELECT DATE(p.data_inclusao)            AS "Data inclusao"
      , SUM(pp.quantidade)               AS "Unidades"
      , CONCAT("R$ ", SUM(pp.somatorio)) AS "Valor total"
   FROM pedido_produto AS pp
  INNER JOIN pedido AS p
     ON p.id_pedido = pp.id_pedido
  WHERE DATE(p.data_inclusao)
BETWEEN "2025/01/11"
    AND "2025/01/12";

/*
  Novamente, lista o extrado do dia determinado pela instrucao 'WHERE', mas
  dessa vez organiza o output de acordo com cada produto vendido durante o dia,
  incluindo quantidade, valor de cada um e o somatorio final do valor obtido.
*/
 SELECT DATE(pe.data_inclusao)           AS "Data inclusao"
      , pr.descricao                     AS "Descricao do produto"
      , CONCAT("R$ ", pr.valor)          AS "Valor unidade"
      , SUM(pp.quantidade)               AS "Unidades"
      , CONCAT("R$ ", SUM(pp.somatorio)) AS "Valor total"
   FROM pedido_produto AS pp
  INNER JOIN (pedido AS pe, produto AS pr)
     ON pe.id_pedido = pp.id_pedido
    AND pr.id_produto = pp.id_produto
  WHERE DATE(pe.data_inclusao)
BETWEEN "2025/01/11"
    AND "2025/01/12"
  GROUP BY pp.id_produto;
