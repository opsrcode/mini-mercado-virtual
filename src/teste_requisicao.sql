USE mini_mercado_virtual;
/*
  Requisicao das informacoes basicas do cliente que registrou pedido no
  sistema.
*/
SELECT c.nome                AS "Nome cliente"
     , c.email               AS "E-mail"
     , DATE(p.data_inclusao) AS "Data inclusao"
     , c.status_cliente      AS "Status"
  FROM pedido AS p
 INNER JOIN cliente AS c
    ON c.id_cliente = p.id_cliente;

/*
  Descricao detalhada de uma instancia de cliente, com todos os dados de
  localizacao relevantes.
*/
SELECT c.nome       AS "Nome cliente"
     , c.email      AS "E-mail"
     , c.senha      AS "Senha"
     , e.uf         AS "UF"
     , e.cidade     AS "Cidade"
     , e.bairro     AS "Bairro"
     , e.logradouro AS "Logradouro"
     , e.numero     AS "Numero"
  FROM cliente AS c
 INNER JOIN cliente_endereco AS ce
    ON ce.id_cliente = c.id_cliente
 INNER JOIN endereco AS e
    ON e.id_endereco = ce.id_endereco; 

/*
  Requisicao contendo descricao do produto em questao, basendo-se na premissa
  de que todos os produtos retornados estao abaixo de R$300.
*/
SELECT p.descricao AS "Descricao produto"
     , p.valor     AS "Valor"
  FROM produto p
 WHERE p.valor < 500;

/*
  Se ainda em andamento, o pedido sera retornado com as devidas informacoes
  solicitadas.
*/
SELECT p.id_pedido     AS "ID pedido"
     , c.nome          AS "Nome cliente"
     , c.email         AS "E-mail"
     , p.status_pedido AS "Em andamento"
     , p.data_inclusao AS "Data solicitacao"
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
BETWEEN "2025/01/10"
    AND current_date;

/*
  Novamente, lista o extrado do dia determinado pela instrucao 'WHERE', mas
  dessa vez organiza o output de acordo com cada produto vendido durante o dia,
  incluindo quantidade, valor de cada um e o somatorio final do valor obtido.
*/
 SELECT DATE(pe.data_inclusao)           AS "Data inclusao"
      , pr.descricao                     AS "Descricao produto"
      , CONCAT("R$ ", pr.valor)          AS "Valor unidade"
      , SUM(pp.quantidade)               AS "Unidades"
      , CONCAT("R$ ", SUM(pp.somatorio)) AS "Valor total"
   FROM pedido_produto AS pp
  INNER JOIN pedido AS pe
     ON pe.id_pedido = pp.id_pedido
  INNER JOIN produto AS pr
     ON pr.id_produto = pp.id_produto
  WHERE DATE(pe.data_inclusao)
BETWEEN "2025/01/10"
    AND current_date
  GROUP BY pp.id_produto;
