
-- Relatório de departamentos
SELECT sigla,nome FROM departamento ORDER BY nome;

-- Relatório de dependentes
SELECT c.nome, d.nome as nome_dependente, d.data_nascimento, d.parentesco 
FROM colaborador as c INNER JOIN dependente as d on d.colaborador = c.matricula ORDER BY C.nome, d.nome;

-- Inserir novo colaborador em projeto
INSERT INTO papel 
VALUES(8,'Especialista de Negócios');

INSERT INTO colaborador
VALUES('F111','111.111.111-11','Fulano de Tal','fulano@x.com','fulano@y.com',5000.00,'SEDES','71222-100','Rua 1');

INSERT INTO telefone_colaborador
VALUES('(61) 9 9999-9999','F111','M');

INSERT INTO projeto
VALUES(5,'BI','F111','2022-08-24',null);

INSERT INTO atribuicao
VALUES('F111',5,8);

-- Excluir departamento SECAP
DELETE FROM telefone_colaborador WHERE colaborador IN ('H123','M123','R123','W123');

UPDATE departamento 
SET chefe = 'F111' WHERE sigla = 'SECAP';

DELETE FROM dependente WHERE colaborador IN ('H123','M123','R123','W123');

DELETE FROM atribuicao WHERE colaborador IN ('H123','M123','R123','W123');

DELETE FROM colaborador WHERE departamento = 'SECAP';

DELETE FROM departamento WHERE sigla = 'SECAP';