-- Видалення існуючих таблиць з каскадним видаленням обмежень
DROP TABLE IF EXISTS AUTOMATICRECOMMENDATION CASCADE;
DROP TABLE IF EXISTS INDIVIDUALRECOMMENDATION CASCADE;
DROP TABLE IF EXISTS RECOMMENDATION CASCADE;
DROP TABLE IF EXISTS EDUCATIONALMATERIAL CASCADE;
DROP TABLE IF EXISTS LITERARYWORK CASCADE;
DROP TABLE IF EXISTS MENTOR CASCADE;
DROP TABLE IF EXISTS "User" CASCADE;

-- Створення таблиці "User"
CREATE TABLE "User" (
    USER_ID SERIAL,
    NAME VARCHAR(100),
    EMAIL VARCHAR(100),
    AGE INTEGER,
    EDUCATIONLEVEL VARCHAR(50),
    ISMENTOR BOOLEAN
);

-- Додавання обмеження первинного ключа
ALTER TABLE "User" ADD CONSTRAINT USER_PK PRIMARY KEY (USER_ID);

-- Додавання обмежень NOT NULL
ALTER TABLE "User" ALTER COLUMN NAME SET NOT NULL;
ALTER TABLE "User" ALTER COLUMN EMAIL SET NOT NULL;
ALTER TABLE "User" ALTER COLUMN AGE SET NOT NULL;
ALTER TABLE "User" ALTER COLUMN ISMENTOR SET NOT NULL;

-- Додавання обмеження перевірки на вік користувача
ALTER TABLE "User" ADD CONSTRAINT USER_AGE_POSITIVE CHECK (AGE > 0);

-- Додавання регулярного виразу для перевірки формату email
ALTER TABLE "User" ADD CONSTRAINT USER_EMAIL_FORMAT CHECK (
    EMAIL ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
);

-- Створення таблиці Mentor
CREATE TABLE MENTOR (
    MENTOR_ID SERIAL,
    USER_ID INTEGER,
    EXPERTISEAREA VARCHAR(100),
    YEARSOFEXPERIENCE INTEGER,
    CONTACTINFO VARCHAR(150)
);

-- Додавання обмеження первинного ключа
ALTER TABLE MENTOR ADD CONSTRAINT MENTOR_PK PRIMARY KEY (MENTOR_ID);

-- Додавання обмежень NOT NULL
ALTER TABLE MENTOR ALTER COLUMN USER_ID SET NOT NULL;
ALTER TABLE MENTOR ALTER COLUMN YEARSOFEXPERIENCE SET NOT NULL;

-- Додавання обмеження зовнішнього ключа для зв'язку з таблицею "User"
ALTER TABLE MENTOR ADD CONSTRAINT MENTOR_USER_FK
FOREIGN KEY (USER_ID) REFERENCES "User" (USER_ID);

-- Додавання перевірки кількості років досвіду ментора
ALTER TABLE MENTOR ADD CONSTRAINT MENTOR_YEARS_EXPERIENCE_POSITIVE CHECK (
    YEARSOFEXPERIENCE > 0
);

-- Створення таблиці LiteraryWork
CREATE TABLE LITERARYWORK (
    WORK_ID SERIAL,
    USER_ID INTEGER,
    TITLE VARCHAR(200),
    TEXT TEXT,
    GENRE VARCHAR(50),
    WORDCOUNT INTEGER,
    CREATIONDATE DATE,
    LASTMODIFIEDDATE DATE
);

-- Додавання обмеження первинного ключа
ALTER TABLE LITERARYWORK ADD CONSTRAINT LITERARYWORK_PK PRIMARY KEY (WORK_ID);

-- Додавання обмежень NOT NULL
ALTER TABLE LITERARYWORK ALTER COLUMN USER_ID SET NOT NULL;
ALTER TABLE LITERARYWORK ALTER COLUMN TITLE SET NOT NULL;
ALTER TABLE LITERARYWORK ALTER COLUMN TEXT SET NOT NULL;
ALTER TABLE LITERARYWORK ALTER COLUMN CREATIONDATE SET NOT NULL;

-- Додавання обмеження зовнішнього ключа для зв'язку з таблицею "User"
ALTER TABLE LITERARYWORK ADD CONSTRAINT LITERARYWORK_USER_FK
FOREIGN KEY (USER_ID) REFERENCES "User" (USER_ID);

-- Додавання перевірки кількості слів у творі
ALTER TABLE LITERARYWORK ADD CONSTRAINT LITERARYWORK_WORDCOUNT_POSITIVE CHECK (
    WORDCOUNT > 0
);

-- Додавання регулярного виразу для перевірки жанру
ALTER TABLE LITERARYWORK ADD CONSTRAINT LITERARYWORK_GENRE_FORMAT CHECK (
    GENRE ~ '^[A-Za-z ]+$'
);

-- Створення таблиці EducationalMaterial
CREATE TABLE EDUCATIONALMATERIAL (
    MATERIAL_ID SERIAL,
    USER_ID INTEGER,
    TITLE VARCHAR(200),
    CONTENT TEXT,
    AUTHOR VARCHAR(100),
    PUBLICATIONDATE DATE
);

-- Додавання обмеження первинного ключа
ALTER TABLE EDUCATIONALMATERIAL ADD CONSTRAINT EDUCATIONALMATERIAL_PK PRIMARY KEY (
    MATERIAL_ID
);

-- Додавання обмежень NOT NULL
ALTER TABLE EDUCATIONALMATERIAL ALTER COLUMN USER_ID SET NOT NULL;
ALTER TABLE EDUCATIONALMATERIAL ALTER COLUMN TITLE SET NOT NULL;
ALTER TABLE EDUCATIONALMATERIAL ALTER COLUMN CONTENT SET NOT NULL;
ALTER TABLE EDUCATIONALMATERIAL ALTER COLUMN AUTHOR SET NOT NULL;
ALTER TABLE EDUCATIONALMATERIAL ALTER COLUMN PUBLICATIONDATE SET NOT NULL;

-- Додавання обмеження зовнішнього ключа для зв'язку з таблицею "User"
ALTER TABLE EDUCATIONALMATERIAL ADD CONSTRAINT EDUCATIONALMATERIAL_USER_FK
FOREIGN KEY (USER_ID) REFERENCES "User" (USER_ID);

-- Створення таблиці Recommendation
CREATE TABLE Recommendation (
    Recommendation_id SERIAL,
    User_id INTEGER,
    Work_id INTEGER,
    Content VARCHAR(500),
    Date DATE,
    Recommendationtype VARCHAR(50)
);

-- Додавання обмеження первинного ключа
ALTER TABLE Recommendation ADD CONSTRAINT Recommendation_pk PRIMARY KEY (
    Recommendation_id
);

-- Додавання обмежень NOT NULL
ALTER TABLE Recommendation ALTER COLUMN User_id SET NOT NULL;
ALTER TABLE Recommendation ALTER COLUMN Work_id SET NOT NULL;
ALTER TABLE Recommendation ALTER COLUMN Content SET NOT NULL;
ALTER TABLE Recommendation ALTER COLUMN Date SET NOT NULL;
ALTER TABLE Recommendation ALTER COLUMN Recommendationtype SET NOT NULL;

-- Додавання обмежень зовнішнього ключа для зв'язку з таблицями "User" і LiteraryWork
ALTER TABLE Recommendation ADD CONSTRAINT Recommendation_user_fk
FOREIGN KEY (User_id) REFERENCES "User" (User_id);

ALTER TABLE Recommendation ADD CONSTRAINT Recommendation_work_fk
FOREIGN KEY (Work_id) REFERENCES Literarywork (Work_id);

-- Додавання перевірки на тип рекомендації
ALTER TABLE Recommendation ADD CONSTRAINT Recommendation_type_chk
CHECK (Recommendationtype IN ('Individual', 'Automatic'));

-- Створення таблиці IndividualRecommendation
CREATE TABLE Individualrecommendation (
    Recommendation_id INTEGER,
    Mentor_id INTEGER,
    Mentorcomments VARCHAR(300)
);

-- Додавання обмеження первинного ключа
ALTER TABLE Individualrecommendation ADD CONSTRAINT Individualrecommendation_pk
PRIMARY KEY (Recommendation_id);

-- Додавання обмежень NOT NULL
ALTER TABLE Individualrecommendation ALTER COLUMN Mentor_id SET NOT NULL;
ALTER TABLE Individualrecommendation ALTER COLUMN Mentorcomments SET NOT NULL;

-- Додавання обмежень зовнішнього ключа для зв'язку з таблицями Recommendation і Mentor
ALTER TABLE Individualrecommendation ADD CONSTRAINT Individualrecommendation_recommendation_fk
FOREIGN KEY (Recommendation_id) REFERENCES Recommendation (Recommendation_id);

ALTER TABLE Individualrecommendation ADD CONSTRAINT Individualrecommendation_mentor_fk
FOREIGN KEY (Mentor_id) REFERENCES Mentor (Mentor_id);

-- Створення таблиці AutomaticRecommendation
CREATE TABLE Automaticrecommendation (
    Recommendation_id INTEGER
);

-- Додавання обмеження первинного ключа
ALTER TABLE Automaticrecommendation ADD CONSTRAINT Automaticrecommendation_pk
PRIMARY KEY (Recommendation_id);

-- Додавання обмеження зовнішнього ключа для зв'язку з таблицею Recommendation
ALTER TABLE Automaticrecommendation ADD CONSTRAINT Automaticrecommendation_recommendation_fk
FOREIGN KEY (Recommendation_id) REFERENCES Recommendation (Recommendation_id);
