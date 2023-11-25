-- Drop das procedures


-- Drop das tabelas
DROP TABLE IF EXISTS Matrícula;
DROP TABLE IF EXISTS Aluno;
DROP TABLE IF EXISTS Curso;
DROP TABLE IF EXISTS Área;

-- Definição das tabelas
CREATE TABLE Área (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
);

CREATE TABLE Curso (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    ÁreaID INT,
    FOREIGN KEY (ÁreaID) REFERENCES Área(ID)
);

CREATE TABLE Aluno (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Sobrenome VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Matrícula (
    AlunoID INT,
    CursoID INT,
    Data_de_Matrícula TIMESTAMP,
    FOREIGN KEY (AlunoID) REFERENCES Aluno(ID),
    FOREIGN KEY (CursoID) REFERENCES Curso(ID)
);

-- Stored Procedure para inserir um novo curso
DROP PROCEDURE IF EXISTS InserirCurso;

-- Inserindo dados na tabela Área
INSERT INTO Área (Nome) VALUES ('Ciências da Computação');
INSERT INTO Área (Nome) VALUES ('Engenharia Elétrica');
INSERT INTO Área (Nome) VALUES ('Matemática Aplicada');

-- Inserindo dados na tabela Curso
INSERT INTO Curso (Nome, ÁreaID) VALUES ('Bacharelado em Ciência da Computação', 1);
INSERT INTO Curso (Nome, ÁreaID) VALUES ('Engenharia Elétrica - Ênfase em Sistemas', 2);
INSERT INTO Curso (Nome, ÁreaID) VALUES ('Matemática Aplicada à Economia', 3);

-- Inserindo dados na tabela Aluno
INSERT INTO Aluno (Nome, Sobrenome, Email) VALUES ('João', 'Silva', 'joao.silva@example.com');
INSERT INTO Aluno (Nome, Sobrenome, Email) VALUES ('Maria', 'Santos', 'maria.santos@example.com');
INSERT INTO Aluno (Nome, Sobrenome, Email) VALUES ('Pedro', 'Oliveira', 'pedro.oliveira@example.com');

-- Inserindo dados na tabela Matrícula
INSERT INTO Matrícula (AlunoID, CursoID, Data_de_Matrícula) VALUES (1, 1, NOW());
INSERT INTO Matrícula (AlunoID, CursoID, Data_de_Matrícula) VALUES (2, 2, NOW());
INSERT INTO Matrícula (AlunoID, CursoID, Data_de_Matrícula) VALUES (3, 3, NOW());

DELIMITER //
CREATE PROCEDURE InserirCurso(
    IN p_nome_curso VARCHAR(100),
    IN p_area_id INT
)
BEGIN
    INSERT INTO Curso (Nome, ÁreaID)
    VALUES (p_nome_curso, p_area_id);
END //
DELIMITER ;

-- Função para buscar o ID do curso
DROP FUNCTION IF EXISTS BuscarIDCurso;
DELIMITER //
CREATE FUNCTION BuscarIDCurso(
    p_nome_curso VARCHAR(100),
    p_nome_area VARCHAR(100)
)
RETURNS INT
BEGIN
    DECLARE curso_id INT;

    SELECT c.ID INTO curso_id
    FROM Curso c
    INNER JOIN Área a ON c.ÁreaID = a.ID
    WHERE c.Nome = p_nome_curso AND a.Nome = p_nome_area;

    RETURN curso_id;
END //
DELIMITER ;

-- Procedure para matricular um aluno em um curso
DROP PROCEDURE IF EXISTS MatricularAluno;
DELIMITER //
CREATE PROCEDURE MatricularAluno(
    IN p_nome_aluno VARCHAR(50),
    IN p_sobrenome_aluno VARCHAR(50),
    IN p_email_aluno VARCHAR(100),
    IN p_nome_curso VARCHAR(100),
    IN p_nome_area VARCHAR(100)
)
BEGIN
    DECLARE aluno_id INT;
    DECLARE curso_id INT;

    -- Verifica se o aluno já está matriculado no curso
    SELECT ID INTO aluno_id
    FROM Aluno
    WHERE Email = p_email_aluno;

    SELECT BuscarIDCurso(p_nome_curso, p_nome_area) INTO curso_id;

    IF aluno_id IS NULL AND curso_id IS NOT NULL THEN
        -- Insere o novo aluno
        INSERT INTO Aluno (Nome, Sobrenome, Email)
        VALUES (p_nome_aluno, p_sobrenome_aluno, p_email_aluno);

        -- Realiza a matrícula do aluno no curso
        INSERT INTO Matrícula (AlunoID, CursoID, Data_de_Matrícula)
        VALUES ((SELECT LAST_INSERT_ID()), curso_id, NOW());
        
        SELECT 'Matrícula realizada com sucesso!' AS Resultado;
    ELSE
        SELECT 'Aluno já está matriculado ou curso não existe.' AS Resultado;
    END IF;
END //
DELIMITER ;

-- Selecionando todos os dados da tabela Área
SELECT * FROM Área;

-- Selecionando todos os dados da tabela Curso
SELECT * FROM Curso;

-- Selecionando todos os dados da tabela Aluno
SELECT * FROM Aluno;

-- Selecionando todos os dados da tabela Matrícula
SELECT * FROM Matrícula;



