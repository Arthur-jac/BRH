 CREATE SCHEMA brh;
 
 USE BRH;
 
 CREATE TABLE PESSOA(
	cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(144) NOT NULL,
    email_pessoal VARCHAR(144) NOT NULL
 );
 
 CREATE TABLE ENDERECO(
	cep VARCHAR(10) PRIMARY KEY,
    estado VARCHAR(2) NOT NULL,
    cidade VARCHAR(144) NOT NULL,
    bairro VARCHAR(144) NOT NULL,
    logradouro VARCHAR(144) NOT NULL
 );
 
 CREATE TABLE COLABORADOR(
	matricula VARCHAR(4) PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    email_corporativo VARCHAR(144) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
	complemento VARCHAR(144),
    departamento VARCHAR(8) NOT NULL,
    CONSTRAINT fk_colaborador_pessoa FOREIGN KEY (cpf) REFERENCES PESSOA (cpf),
    CONSTRAINT fk_colaborador_endereco FOREIGN KEY (cep) REFERENCES ENDERECO (cep)
 );
 
 CREATE TABLE DEPARTAMENTO(
	sigla VARCHAR(8) PRIMARY KEY,
    nome VARCHAR(14) NOT NULL,
    chefe VARCHAR(4) NOT NULL,
    departamento_superior VARCHAR(8) NOT NULL,
    CONSTRAINT fk_departamento_superior FOREIGN KEY (departamento_superior) REFERENCES DEPARTAMENTO (sigla),
    CONSTRAINT fk_departamento_colaborador FOREIGN KEY (chefe) REFERENCES COLABORADOR(matricula)
 ); 
 
 ALTER TABLE COLABORADOR ADD CONSTRAINT 
 fk_colaborador_departamento FOREIGN KEY (departamento) REFERENCES DEPARTAMENTO (sigla);
 
 CREATE TABLE DEPENDENTE(
	cpf VARCHAR(14) PRIMARY KEY,
    colaborador VARCHAR(4) NOT NULL,
    nome VARCHAR(144) NOT NULL,
    data_nascimento DATE NOT NULL,
    parentesco VARCHAR(144) NOT NULL,
	CONSTRAINT fk_dependente_colaborador FOREIGN KEY (colaborador) REFERENCES COLABORADOR(matricula)
 );
 
 CREATE TABLE TELEFONE(
	telefone VARCHAR(20) NOT NULL,
    colaborador VARCHAR(4) NOT NULL,
    CONSTRAINT pk_telefone PRIMARY KEY (telefone,colaborador),
    CONSTRAINT fk_telefone_colaborador FOREIGN KEY (colaborador) REFERENCES COLABORADOR(matricula)
 );
 
 CREATE TABLE PAPEL(
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(144) UNIQUE NOT NULL
 );
 
 CREATE TABLE PROJETO(
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(144) UNIQUE NOT NULL,
    responsavel VARCHAR(4) NOT NULL,
    inicio DATE NOT NULL,
    fim DATE,
    CONSTRAINT pk_projeto_reponsavel FOREIGN KEY(responsavel) REFERENCES COLABORADOR(matricula)
 );

 CREATE TABLE ATRIBUICAO(
	colaborador VARCHAR(4) NOT NULL,
    projeto INTEGER NOT NULL UNIQUE,
    papel INTEGER NOT NULL UNIQUE,
	CONSTRAINT pk_atribuicao_colaborador FOREIGN KEY(colaborador) REFERENCES COLABORADOR(matricula),
	CONSTRAINT pk_atribuicao_projeto FOREIGN KEY(projeto) REFERENCES PROJETO(id),
	CONSTRAINT pk_atribuicao_papel FOREIGN KEY(papel) REFERENCES PAPEL(id)
 );
