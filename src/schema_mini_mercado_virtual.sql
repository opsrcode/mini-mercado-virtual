DROP DATABASE IF EXISTS mini_mercado_virtual;
CREATE DATABASE mini_mercado_virtual;
GRANT ALL PRIVILEGES ON mini_mercado_virtual.* TO 'opsrcode'@'localhost';
USE mini_mercado_virtual;

CREATE TABLE IF NOT EXISTS endereco (
    id_endereco INTEGER auto_increment
  , uf             CHAR ( 2) NOT null
  , cidade      VARCHAR (50) NOT null
  , cep         VARCHAR ( 8) NOT null
  , bairro      VARCHAR (50) NOT null
  , logradouro  VARCHAR (50) NOT null
  , numero      INTEGER      NOT null
  , complemento VARCHAR (50)     null
  ,    PRIMARY KEY (id_endereco)
  , CONSTRAINT uq_end_cep_numero
        UNIQUE (cep, numero)
);

CREATE TABLE IF NOT EXISTS cliente (
    id_cliente      INTEGER auto_increment
  , nome            VARCHAR ( 50) NOT null
  , email           VARCHAR (255) NOT null
  , senha           VARCHAR (100) NOT null
  , status_cliente  BOOLEAN DEFAULT true
  , data_inclusao  DATETIME DEFAULT current_timestamp
  , data_alteracao DATETIME null
  ,    PRIMARY KEY (id_cliente)
  , CONSTRAINT uq_client_email
        UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS cliente_endereco (
    id_cliente  INTEGER NOT null
  , id_endereco INTEGER NOT null
  ,    PRIMARY KEY (id_cliente, id_endereco)
  , CONSTRAINT fk_cliente_cli_end
       FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente)
  , CONSTRAINT fk_endereco_cli_end
       FOREIGN KEY (id_endereco)
    REFERENCES endereco(id_endereco)
);

CREATE TABLE IF NOT EXISTS produto (
    id_produto      INTEGER auto_increment
  , descricao       VARCHAR (255) NOT null
  , valor           DECIMAL (7,2) NOT null
  , estoque         INTEGER DEFAULT 1
  , status_produto  BOOLEAN DEFAULT true
  , data_inclusao  DATETIME DEFAULT current_timestamp
  , data_alteracao DATETIME null
  , PRIMARY KEY (id_produto)
);

CREATE TABLE IF NOT EXISTS pedido (
    id_pedido       INTEGER auto_increment
  , id_cliente      INTEGER NOT null
  , id_endereco     INTEGER NOT null
  , status_pedido   BOOLEAN DEFAULT true
  , data_inclusao  DATETIME DEFAULT current_timestamp
  , data_alteracao DATETIME null
  ,    PRIMARY KEY (id_pedido)
  , CONSTRAINT fk_id_cliente_pedido
       FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente)
            ON DELETE cascade
  , CONSTRAINT fk_id_endereco_pedido
       FOREIGN KEY (id_endereco)
    REFERENCES endereco(id_endereco)
            ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS pedido_produto (
    id_pedido  INTEGER NOT null
  , id_produto INTEGER NOT null
  , quantidade INTEGER DEFAULT 1
  , somatorio  DECIMAL (10,2) NOT null
  ,    PRIMARY KEY (id_pedido, id_produto)
  , CONSTRAINT fk_id_pedido_pp
       FOREIGN KEY (id_pedido)
    REFERENCES pedido(id_pedido)
            ON DELETE cascade
  , CONSTRAINT fk_id_produto_pp
       FOREIGN KEY (id_produto)
    REFERENCES produto(id_produto)
            ON DELETE cascade
);
