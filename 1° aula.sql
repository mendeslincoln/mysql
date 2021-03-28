CREATE DATABASE curso_sql;  /*criar base*/
USE curso_sql;  /*usar-la*/

CREATE TABLE funcionarios  /*criar tabela*/ 
(
id int unsigned not null auto_increment,  /*unsigned >  só valor positivo */
nome varchar(45) not null,
salario double not null default '0',
departamento varchar(45) not null,
PRIMARY KEY (id)
 );
CREATE TABLE veiculos
(


 id int unsigned not null auto_increment,
 funcionario_id int unsigned default null,
 veiculo varchar(45) not null default '',
 placa varchar(10) not null default '',
 PRIMARY KEY (id),
 CONSTRAINT fk_veiculos_funcionarios FOREIGN KEY (funcionario_id) REFERENCES funcionarios (id) /*relacionar o funcionario_id com o id do funcioario*/
 

);
CREATE TABLE salarios
(

 faixa varchar (45) not null,
 inicio double not null,
 fim double not null, 
 PRIMARY KEY (faixa)
 );
 CREATE TABLE filhos 
(
 id int unsigned not null auto_increment,
 funcionario_id int unsigned not null ,
 nome varchar(45) not null default '',
 idade int unsigned not null,
 PRIMARY KEY (id),
 CONSTRAINT fk_filhos_funcionarios FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id) /*relacionar o funcionario_id com o id do funcionario*/
);

ALTER TABLE funcionarios CHANGE COLUMN nome nome_func varchar(50) not null;  /*altera nome do campo , e seu tipo*/ 
ALTER TABLE funcionarios ADD COLUMN setor VARCHAR(45) not null AFTER departamento; /*cria uma nova coluna com nome SETOR na table funcionarios, após a coluna departamento*/

DROP TABLE salarios; /*apagar tabela por inteiro*/ 

CREATE INDEX departamentos ON funcionarios (departamento); /*colocar um elemento como índice, que melhora a performance na hora de ordenar*/ 
CREATE INDEX nomes ON funcionarios (nome(5)); /*colocar o nome como indice pelos 5 primeiros caracteres*/ 

INSERT INTO funcionarios (id, nome, salario , departamento, setor) VALUES (1, 'Fernando', 1400, 'TI', 'tecnico'); /*inserir itens nas tabelas*/

UPDATE funcionarios SET salario = salario * 1.1 WHERE nome = 'Fabio'; /*dar aumento*/
UPDATE funcionarios SET salario = ROUND(salario * 1.1,2) WHERE nome = 'Fabio'; /*dar aumento e considerar só duas casas decimais*/

SET SQL_SAFE_UPDATES = 0; /*Permite alterar todos os registros de uma tabela de uma só vez 0 desabilita 1 habilita*/

DELETE FROM  funcionarios WHERE id = '4'; /*deletar um registro*/

SELECT 						
f.nome AS Nome_Funcionario, 
f.salario AS Salario_Funcionario  /*usar apelido*/
FROM funcionarios AS f 
WHERE f.salario > 2000; 


SELECT * FROM funcionarios WHERE nome = 'Fabio'
UNION					/*fazer dois selects ao mesmo tempo*/
SELECT * FROM funcionarios WHERE id = '5';

SELECT F.nome, V.veiculo
FROM funcionarios AS F 
INNER JOIN veiculos AS V                /*Selecionar todos os funcionários que tem carro */
ON F.id = V.funcionario_id;

SELECT FU.nome AS "FUNCIONARIO", VE.veiculo "VEICULO", FI.nome "FILHO"
FROM funcionarios AS FU
INNER JOIN veiculos AS VE ON FU.id = VE.funcionario_id                /*Selecionar todos os funcionários que tem carro e tem filhos */
INNER JOIN filhos AS FI ON FU.id = FI.funcionario_id;


CREATE VIEW funcionarios_salario_acima_1500 AS SELECT * FROM funcionarios AS FU WHERE FU.salario >=1500; 
SELECT * FROM funcionarios_salario_acima_1500;    		 /*Criar view que facilita consultas rotineiras*/

SELECT COUNT(*) AS "QUANTIDADE"
FROM funcionarios AS FU
WHERE FU.salario > 1700			/*Quantidade de pessoas que trabalham no TI e ganham acima de 1700*/
AND FU.departamento = 'TI';


SELECT SUM(salario) AS 'SOMA DOS SALARIOS'
FROM funcionarios AS FU			/*Soma dos salários de todos que trabalham no TI*/
WHERE FU.departamento = 'TI'; 


SELECT AVG(salario) AS 'MEDIA DOS SALARIOS'
FROM funcionarios AS FU			/*Média dos salários de todos que trabalham no TI*/
WHERE FU.departamento = 'TI'; 

SELECT MAX(salario) FROM funcionarios; /*Valor do maior salario*/
SELECT MIN(salario) FROM funcionarios; /*Valor do menor salario*/

SELECT DISTINCT(departamento) AS 'DEPARTAMENTOS' FROM funcionarios; /*Mostrar todos os departamentos sem repetir*/

SELECT * FROM funcionarios AS FU 
ORDER BY FU.salario DESC;     /*Mostrar ordenado por salario na ordem descrecente */

SELECT * FROM funcionarios AS FU
ORDER BY FU.departamento , FU.salario DESC;  /*Mostra ordenado primeiro por departamento  depois por salario (decrescente)*/

SELECT * FROM funcionarios LIMIT 2 ;       /*Mostrar só os dois primeiros registros*/
SELECT * FROM funcionarios LIMIT 1, 2 ;       /*Mostrar dois registros, mas pular o primeiro*/

 /*Mostrar a soma salarial por departamento*/
SELECT departamento , SUM(salario) FROM funcionarios GROUP BY departamento;

/*Mostrar a soma por departamento onde o a média salarial do departamento for maior que 2000*/
SELECT departamento , SUM(salario) FROM funcionarios GROUP BY departamento HAVING AVG(salario) > 2000 ; 


/*Mostar os funcionarios de um departamento que tem média salarial acima de 2000*/
SELECT FU.nome
FROM funcionarios AS FU
WHERE departamento IN 
	(SELECT departamento FROM funcionarios GROUP BY departamento HAVING AVG(salario) >2000 );

/*Criar o usuario */
CREATE USER 'lincoln'@'192.168.0.1' IDENTIFIED BY '123456'; /*acesso só do ip 192.168.0.1*/
CREATE USER 'lincoln'@'localhost' IDENTIFIED BY '123456';/*acesso só do localhost*/
CREATE USER 'lincoln'@'%' IDENTIFIED BY '123456';/*acesso de qualquer lugar*/

/*Permissões*/
GRANT ALL ON curso_sql.* TO 'lincoln'@'localhost'; /*Total*/
GRANT SELECT ON curso_sql.* TO 'lincoln'@'localhost'; /*Só SELECT*/
GRANT INSERT ON curso_sql.funcionarios TO 'lincoln'@'localhost'; /*Só INSERT na tabela funcionários*/
REVOKE  INSERT ON curso_sql.funcionarios FROM 'lincoln'@'localhost'; /*Revogar a permissão acima*/

DROP USER 'lincoln'@'localhost'; /*Excluir usuário*/ 
SELECT User FROM mysql.user; /*Lista  usuários*/
SHOW GRANTS FOR 'lincoln'@'localhost'; /*Lista usuário e sua permissão*/








