SET SERVEROUTPUT ON
-- 1. Criar procedure insere_projeto
CREATE OR REPLACE PROCEDURE brh.insere_projeto
(p_nome IN brh.projeto.nome%type, p_responsavel IN brh.projeto.responsavel%type)
IS
BEGIN
INSERT INTO brh.projeto (nome,responsavel,inicio,fim)
VALUES(p_nome,p_responsavel,sysdate,null);
END;

EXECUTE brh.insere_projeto('BI','A123');
rollback;
-- 2. Criar função calcula_idade
CREATE OR REPLACE FUNCTION brh.calcula_idade
(p_data DATE)
RETURN FLOAT
IS
v_idade FLOAT;
BEGIN
    v_idade := FLOOR(MONTHS_BETWEEN(SYSDATE,p_data)/12);
    RETURN v_idade;
END;

DECLARE
v_idade FLOAT;
BEGIN
v_idade := brh.calcula_idade('01/10/2001');
dbms_output.put_line(v_idade);
END;

-- 4. Criar function finaliza_projeto
CREATE OR REPLACE FUNCTION brh.finaliza_projeto
(p_id IN brh.projeto.id%type)
RETURN brh.projeto.fim%type 
IS
v_data_termino brh.projeto.fim%type;
BEGIN
    SELECT fim INTO v_data_termino FROM brh.projeto WHERE id = p_id;
    IF v_data_termino IS NOT NULL THEN
        dbms_output.put_line(v_data_termino);
        RETURN v_data_termino;
    ELSE
        UPDATE brh.projeto SET fim = sysdate WHERE id = p_id;
        dbms_output.put_line(v_data_termino);
        RETURN v_data_termino;
    END IF;
END;

DECLARE
v_tp DATE;
BEGIN
v_tp := brh.finaliza_projeto(45);
END;

-- 5. Validar novo projeto
CREATE OR REPLACE PROCEDURE brh.insere_projeto
(p_nome IN brh.projeto.nome%type, p_responsavel IN brh.projeto.responsavel%type)
IS
v_saida varchar(144);
BEGIN
IF LENGTH(p_nome) < 2 OR p_nome IS NULL THEN
    v_saida := 'Nome de projeto inválido! Deve ter dois ou mais caracteres.';
    dbms_output.put_line(v_saida);
ELSE 
    INSERT INTO brh.projeto (nome,responsavel,inicio,fim)
    VALUES(p_nome,p_responsavel,sysdate,null);
END IF;
END;

EXECUTE brh.insere_projeto(null,'A123');

-- 6. Validar cálculo idade
CREATE OR REPLACE FUNCTION brh.calcula_idade
(p_data DATE)
RETURN FLOAT
IS
v_idade FLOAT;
BEGIN
IF p_data > SYSDATE OR p_data IS NULL THEN
    dbms_output.put_line('Impossível calcular idade! Data inválida: ' || p_data);
    RETURN NULL;
ELSE
    v_idade := FLOOR(MONTHS_BETWEEN(SYSDATE,p_data)/12);
    RETURN v_idade;
END IF;
END;

DECLARE
v_idade FLOAT;
BEGIN
v_idade := brh.calcula_idade(null);
dbms_output.put_line(v_idade);
END;

-- 8. Criar define_atribuicao 
CREATE OR REPLACE PROCEDURE brh.define_atribuicao
(p_colaborador brh.colaborador.nome%type,
 p_projeto brh.projeto.nome%type,
 p_papel brh.papel.nome%type)
IS
v_colaborador brh.colaborador.matricula%type;
v_projeto brh.projeto.id%type;
v_papel brh.papel.id%type;
CURSOR cur_colab IS SELECT matricula INTO v_colaborador FROM brh.colaborador WHERE nome = p_colaborador;
CURSOR cur_projeto IS SELECT id INTO v_projeto FROM brh.projeto WHERE nome = p_projeto;
CURSOR cur_papel IS SELECT id INTO v_papel FROM brh.papel WHERE nome = p_papel;
BEGIN
OPEN cur_colab;
FETCH cur_colab INTO v_colaborador;
IF cur_colab%FOUND THEN 
    CLOSE cur_colab;
    OPEN cur_projeto;
    FETCH cur_projeto INTO v_projeto;
    IF cur_projeto%FOUND THEN
            CLOSE cur_projeto;
            OPEN cur_papel;
            FETCH cur_papel INTO v_papel;
            IF cur_papel%FOUND THEN
                CLOSE cur_papel;
                INSERT INTO brh.atribuicao(colaborador,projeto,papel)
                VALUES(v_colaborador,v_projeto,v_papel);
            ELSE
                INSERT INTO brh.papel(nome)
                VALUES(p_papel);
            END IF;
    ELSE
        dbms_output.put_line('Projeto inexistente: ' ||p_projeto);
    END IF;
ELSE
    dbms_output.put_line('Colaborador inexistente: ' ||p_colaborador);
END IF;
END;

EXECUTE brh.define_atribuicao('Xena','BRH','DBA');
