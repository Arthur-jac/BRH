-- Filtrar dependentes
SELECT colab.nome AS colaborador,
    dpt.nome AS dependente,
    dpt.data_nascimento 
FROM brh.colaborador colab 
INNER JOIN brh.dependente dpt
ON colab.matricula = dpt.colaborador
WHERE dpt.nome LIKE '%h%' 
OR dpt.nome LIKE '%H%'
OR TO_CHAR(dpt.data_nascimento,'MM')='04' 
OR TO_CHAR(dpt.data_nascimento,'MM')='05' 
OR TO_CHAR(dpt.data_nascimento,'MM')='06'
ORDER BY colab.nome, dpt.nome;

-- Listar colaborador com maior salário
SELECT matricula, nome, salario
FROM brh.colaborador 
WHERE salario = (SELECT MAX(salario)
FROM brh.colaborador); 

-- Relatório de senioridade
SELECT matricula,nome,salario,
(CASE
    WHEN salario <= 3000 THEN 'Júnior'
    WHEN salario <= 6000 THEN 'Pleno'
    WHEN salario <= 20000 THEN 'Sênior'
    ELSE 'Corpo diretor'
END) AS senioridade
FROM brh.colaborador
ORDER BY nome, senioridade;

-- Listar colaboradores em projetos 
SELECT dep.nome AS departamento,
    pj.nome AS projeto,
    COUNT(*) AS quantidade_colaboradores
FROM brh.departamento dep
INNER JOIN brh.colaborador colab
ON dep.sigla = colab.departamento
INNER JOIN brh.atribuicao atb
ON atb.colaborador = colab.matricula
INNER JOIN brh.projeto pj
ON atb.projeto = pj.id
GROUP BY dep.nome, pj.nome
ORDER BY dep.nome, pj.nome;

-- Listar colaboradores com mais dependentes
SELECT colab.nome, COUNT(*) AS quantidade_dependente
FROM brh.colaborador colab
INNER JOIN brh.dependente dpt
ON colab.matricula = dpt.colaborador
GROUP BY colab.nome
HAVING COUNT(*) > 1
ORDER BY quantidade_dependente DESC, colab.nome ASC;

-- Listar faixa etária dos dependentes
SELECT dpt.cpf, 
        dpt.nome AS nome_dependente, 
        dpt.data_nascimento,
        dpt.parentesco, 
        dpt.colaborador,
        NVL(Floor(Months_Between(SYSDATE,dpt.data_nascimento)/12),0) AS idade,
        (CASE
            WHEN  NVL(Floor(Months_Between(SYSDATE,dpt.data_nascimento)/12),0) < 18  THEN 'Menor de idade'
            ELSE 'Maior de idade'
        END) faixa_etaria
FROM brh.dependente dpt
ORDER BY dpt.colaborador, dpt.nome;

-- Analisar a necessidade de criar uma view
SELECT plano.colab AS colaborador,
        SUM(plano.valor_dependente) + plano.valor_senioridade AS valor_total
FROM vw_plano_saude plano
GROUP BY plano.colab, plano.valor_senioridade
ORDER BY plano.colab;

-- Reletório de plano de saúde
SELECT plano.colab AS colaborador,
        SUM(plano.valor_dependente) + plano.valor_senioridade AS valor_total
FROM
    (SELECT colab.nome as colab,
    (CASE
        WHEN dpt.parentesco = 'CÃ´njuge' THEN 100
        WHEN  NVL(Floor(Months_Between(SYSDATE,dpt.data_nascimento)/12),0) >= 18 THEN 50
        ELSE 25
    END) AS valor_dependente,
    (CASE
        WHEN colab.salario <= 3000 THEN salario * 0.01
        WHEN colab.salario <= 6000 THEN salario * 0.02
        WHEN colab.salario <= 20000 THEN salario * 0.03
        ELSE salario * 0.05
    END) AS valor_senioridade 
FROM brh.colaborador colab
INNER JOIN brh.dependente dpt
ON colab.matricula = dpt.colaborador) plano
GROUP BY plano.colab, plano.valor_senioridade
ORDER BY plano.colab;

-- Paginar listagem de colaboradores

-- Página 1: da Ana ao João (registros 1 ao 10);
SELECT * 
FROM (SELECT c.*, ROWNUM RNUM
FROM (SELECT * FROM brh.colaborador c ORDER BY nome)
c WHERE ROWNUM <= 10)
WHERE rnum >= 1;

-- Página 2: da Kelly à Tati (registros 11 ao 20);
SELECT * 
FROM (SELECT c.*, ROWNUM RNUM
FROM (SELECT * FROM brh.colaborador c ORDER BY nome)
c WHERE ROWNUM <= 20)
WHERE rnum >= 11;

-- Página 3: do Uri ao Zico (registros 21 ao 26).
SELECT * 
FROM (SELECT c.*, ROWNUM RNUM
FROM (SELECT * FROM brh.colaborador c ORDER BY nome)
c WHERE ROWNUM <= 26)
WHERE rnum >= 21;

-- Listar colaboradores que participaram de todos os projetos
SELECT atb.colaborador, COUNT(atb.projeto) AS quantidade_projetos 
FROM brh.atribuicao atb
GROUP BY atb.colaborador
HAVING COUNT(atb.projeto) = (SELECT COUNT(*) FROM brh.projeto pj);









 





