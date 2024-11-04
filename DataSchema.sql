-- Видалення існуючих таблиць з каскадним видаленням обмежень
DROP TABLE IF EXISTS AutomaticRecommendation CASCADE;
DROP TABLE IF EXISTS IndividualRecommendation CASCADE;
DROP TABLE IF EXISTS Recommendation CASCADE;
DROP TABLE IF EXISTS EducationalMaterial CASCADE;
DROP TABLE IF EXISTS LiteraryWork CASCADE;
DROP TABLE IF EXISTS Mentor CASCADE;
DROP TABLE IF EXISTS "User" CASCADE;

-- Створення таблиці "User"
CREATE TABLE "User" (
    user_id SERIAL,
    name VARCHAR(100),
    email VARCHAR(100),
    age INTEGER,
    educationLevel VARCHAR(50),
    isMentor BOOLEAN
);

-- Додавання обмеження первинного ключа
ALTER TABLE "User" ADD CONSTRAINT user_pk PRIMARY KEY (user_id);

-- Додавання обмежень NOT NULL
ALTER TABLE "User" ALTER COLUMN name SET NOT NULL;
ALTER TABLE "User" ALTER COLUMN email SET NOT NULL;
ALTER TABLE "User" ALTER COLUMN age SET NOT NULL;
ALTER TABLE "User" ALTER COLUMN isMentor SET NOT NULL;

-- Додавання обмеження перевірки на вік користувача
ALTER TABLE "User" ADD CONSTRAINT user_age_positive CHECK (age > 0);

-- Додавання регулярного виразу для перевірки формату email
ALTER TABLE "User" ADD CONSTRAINT user_email_format CHECK (
    email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
);

-- Створення таблиці Mentor
CREATE TABLE Mentor (
    mentor_id SERIAL,
    user_id INTEGER,
    expertiseArea VARCHAR(100),
    yearsOfExperience INTEGER,
    contactInfo VARCHAR(150)
);

-- Додавання обмеження первинного ключа
ALTER TABLE Mentor ADD CONSTRAINT mentor_pk PRIMARY KEY (mentor_id);

-- Додавання обмежень NOT NULL
ALTER TABLE Mentor ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE Mentor ALTER COLUMN yearsOfExperience SET NOT NULL;

-- Додавання обмеження зовнішнього ключа для зв'язку з таблицею "User"
ALTER TABLE Mentor ADD CONSTRAINT mentor_user_fk
    FOREIGN KEY (user_id) REFERENCES "User"(user_id);

-- Додавання перевірки кількості років досвіду ментора
ALTER TABLE Mentor ADD CONSTRAINT mentor_years_experience_positive CHECK (yearsOfExperience > 0);

-- Створення таблиці LiteraryWork
CREATE TABLE LiteraryWork (
    work_id SERIAL,
    user_id INTEGER,
    title VARCHAR(200),
    text TEXT,
    genre VARCHAR(50),
    wordCount INTEGER,
    creationDate DATE,
    lastModifiedDate DATE
);

-- Додавання обмеження первинного ключа
ALTER TABLE LiteraryWork ADD CONSTRAINT literarywork_pk PRIMARY KEY (work_id);

-- Додавання обмежень NOT NULL
ALTER TABLE LiteraryWork ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE LiteraryWork ALTER COLUMN title SET NOT NULL;
ALTER TABLE LiteraryWork ALTER COLUMN text SET NOT NULL;
ALTER TABLE LiteraryWork ALTER COLUMN creationDate SET NOT NULL;

-- Додавання обмеження зовнішнього ключа для зв'язку з таблицею "User"
ALTER TABLE LiteraryWork ADD CONSTRAINT literarywork_user_fk
    FOREIGN KEY (user_id) REFERENCES "User"(user_id);

-- Додавання перевірки кількості слів у творі
ALTER TABLE LiteraryWork ADD CONSTRAINT literarywork_wordcount_positive CHECK (wordCount > 0);

-- Додавання регулярного виразу для перевірки жанру
ALTER TABLE LiteraryWork ADD CONSTRAINT literarywork_genre_format CHECK (
    genre ~ '^[A-Za-z ]+$'
);

-- Створення таблиці EducationalMaterial
CREATE TABLE EducationalMaterial (
    material_id SERIAL,
    user_id INTEGER,
    title VARCHAR(200),
    content TEXT,
    author VARCHAR(100),
    publicationDate DATE
);

-- Додавання обмеження первинного ключа
ALTER TABLE EducationalMaterial ADD CONSTRAINT educationalmaterial_pk PRIMARY KEY (material_id);

-- Додавання обмежень NOT NULL
ALTER TABLE EducationalMaterial ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE EducationalMaterial ALTER COLUMN title SET NOT NULL;
ALTER TABLE EducationalMaterial ALTER COLUMN content SET NOT NULL;
ALTER TABLE EducationalMaterial ALTER COLUMN author SET NOT NULL;
ALTER TABLE EducationalMaterial ALTER COLUMN publicationDate SET NOT NULL;

-- Додавання обмеження зовнішнього ключа для зв'язку з таблицею "User"
ALTER TABLE EducationalMaterial ADD CONSTRAINT educationalmaterial_user_fk
    FOREIGN KEY (user_id) REFERENCES "User"(user_id);

-- Створення таблиці Recommendation
CREATE TABLE Recommendation (
    recommendation_id SERIAL,
    user_id INTEGER,
    work_id INTEGER,
    content VARCHAR(500),
    date DATE,
    recommendationType VARCHAR(50)
);

-- Додавання обмеження первинного ключа
ALTER TABLE Recommendation ADD CONSTRAINT recommendation_pk PRIMARY KEY (recommendation_id);

-- Додавання обмежень NOT NULL
ALTER TABLE Recommendation ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE Recommendation ALTER COLUMN work_id SET NOT NULL;
ALTER TABLE Recommendation ALTER COLUMN content SET NOT NULL;
ALTER TABLE Recommendation ALTER COLUMN date SET NOT NULL;
ALTER TABLE Recommendation ALTER COLUMN recommendationType SET NOT NULL;

-- Додавання обмежень зовнішнього ключа для зв'язку з таблицями "User" і LiteraryWork
ALTER TABLE Recommendation ADD CONSTRAINT recommendation_user_fk
    FOREIGN KEY (user_id) REFERENCES "User"(user_id);

ALTER TABLE Recommendation ADD CONSTRAINT recommendation_work_fk
    FOREIGN KEY (work_id) REFERENCES LiteraryWork(work_id);

-- Додавання перевірки на тип рекомендації
ALTER TABLE Recommendation ADD CONSTRAINT recommendation_type_chk
    CHECK (recommendationType IN ('Individual', 'Automatic'));

-- Створення таблиці IndividualRecommendation
CREATE TABLE IndividualRecommendation (
    recommendation_id INTEGER,
    mentor_id INTEGER,
    mentorComments VARCHAR(300)
);

-- Додавання обмеження первинного ключа
ALTER TABLE IndividualRecommendation ADD CONSTRAINT individualrecommendation_pk
    PRIMARY KEY (recommendation_id);

-- Додавання обмежень NOT NULL
ALTER TABLE IndividualRecommendation ALTER COLUMN mentor_id SET NOT NULL;
ALTER TABLE IndividualRecommendation ALTER COLUMN mentorComments SET NOT NULL;

-- Додавання обмежень зовнішнього ключа для зв'язку з таблицями Recommendation і Mentor
ALTER TABLE IndividualRecommendation ADD CONSTRAINT individualrecommendation_recommendation_fk
    FOREIGN KEY (recommendation_id) REFERENCES Recommendation(recommendation_id);

ALTER TABLE IndividualRecommendation ADD CONSTRAINT individualrecommendation_mentor_fk
    FOREIGN KEY (mentor_id) REFERENCES Mentor(mentor_id);

-- Створення таблиці AutomaticRecommendation
CREATE TABLE AutomaticRecommendation (
    recommendation_id INTEGER
);

-- Додавання обмеження первинного ключа
ALTER TABLE AutomaticRecommendation ADD CONSTRAINT automaticrecommendation_pk
    PRIMARY KEY (recommendation_id);

-- Додавання обмеження зовнішнього ключа для зв'язку з таблицею Recommendation
ALTER TABLE AutomaticRecommendation ADD CONSTRAINT automaticrecommendation_recommendation_fk
    FOREIGN KEY (recommendation_id) REFERENCES Recommendation(recommendation_id);
