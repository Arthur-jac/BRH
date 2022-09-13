-- Relatório de departamentos
SELECT sigla,nome FROM brh_departamento ORDER BY nome;

-- Relatório de dependentes
SELECT brh_colaborador.nome,
    brh_dependente.nome as nome_dependente, 
    brh_dependente.data_nascimento, 
    brh_dependente.parentesco
FROM brh_colaborador 
INNER JOIN brh_dependente ON
    brh_colaborador.matricula = brh_dependente.colaborador 
ORDER BY brh_colaborador.nome, brh_dependente.nome;

-- Inserir novo colaborador em projeto
INSERT INTO brh_papel 
VALUES(8,'Especialista de Negócios');

INSERT INTO brh_colaborador
VALUES('C222','222.222.222-22','Ciclano de Tal','ciclano@x.com','ciclano@y.com',10000.00,'DEPTI','71222-100','Rua 2');

INSERT INTO brh_telefone_colaborador
VALUES('(61) 9 9999-9999','C222','M');

INSERT INTO brh_projeto
VALUES(5,'BI','C222',TO_DATE('01/10/2022','DD/MM/YYYY'),TO_DATE('01/10/2024', 'DD/MM/YYYY'));

INSERT INTO brh_atribuicao
VALUES('C222',5,8);

-- Relatório de contatos
SELECT brh_colaborador.nome,
    brh_colaborador.email_corporativo,
    brh_telefone_colaborador.numero 
FROM brh_colaborador 
INNER JOIN brh_telefone_colaborador ON 
    brh_telefone_colaborador.colaborador = brh_colaborador.matricula;

-- Relatório analítico de equipes 
SELECT depar.nome as nome_departamento,
        chefe.nome chefe,
        colab.nome as nome_colab,
        cel.numero,dp.nome as nome_dependente,
        pl.nome as papel,
        pj.nome as projeto
FROM brh_colaborador colab,
    brh_departamento depar,
    brh_telefone_colaborador cel,
    brh_dependente dp,
    brh_atribuicao atb,
    brh_papel pl,
    brh_projeto pj,
    brh_colaborador chefe
WHERE depar.sigla = colab.departamento
AND depar.chefe = chefe.matricula
AND colab.matricula= dp.colaborador (+)
AND colab.matricula = cel.colaborador 
AND colab.matricula = atb.colaborador
AND pl.id = atb.papel 
AND pj.id= atb.projeto;