----------------------------------------------------------------
-- Creating Tables ---------------------------------------------
----------------------------------------------------------------

-- CREATE SCHEMA if not exists edu;
-- drop table if EXISTS edu.student; 
-- 
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";  -- to install the uuid_generate_v4 func
-- 
-- CREATE TABLE edu.student (
--     student_id UUID PRIMARY key DEFAULT uuid_generate_v4(),
--     first_name VARCHAR(225) not NULL,
--     last_name VARCHAR(225) not NULL,
--     email VARCHAR(225) not NULL,
--     date_of_birth DATE not null 
-- );

----------------------------------------------------------------
-- Table Constraints -------------------------------------------
----------------------------------------------------------------

-- DROP SCHEMA public CASCADE;
-- CREATE SCHEMA public;
-- 
-- CREATE TABLE category (
--     cat_id SMALLINT PRIMARY key,
--     "type" TEXT
-- );
-- 
-- CREATE TABLE column_constraints (
--     cc_id SMALLINT PRIMARY KEY,
--     something text not null,
--     email TEXT check (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'), -- Regex - Regular Expressions
--     cat_id SMALLINT REFERENCES category(cat_id) -- Foreign key
-- );
-- 
-- create table table_constraints (
--     cc_id smallint,
--     something Text,
--     email text,
--     cat_id smallint REFERENCES category(cat_id),
--     CONSTRAINT pk_table_constraints primary key (cc_id),
--     CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$') 
-- );
-- 
-- insert into column_constraints VALUES (
--     1,
--     'category 1',
--     'must.be@something.like.this'
-- );
-- 
-- insert into table_constraints VALUES (
--     1,
--     'category 1'
-- );
-- 
-- SELECT * from column_constraints;
-- SELECT * from table_constraints;

----------------------------------------------------------------
-- Custom Types ------------------------------------------------
----------------------------------------------------------------

/* Allows multiple runs of the code */
DROP SCHEMA IF EXISTS edu CASCADE;
DROP TYPE IF EXISTS Feedback, feedback_deprecated;
DROP DOMAIN IF EXISTS Rating;

/* Not a type, but a domain (alias) an existing type with a constraint. 
Could be also implemented at the backend depending on the application. */
CREATE DOMAIN Rating SMALLINT CHECK (VALUE > 0 AND VALUE <= 5); 

CREATE TYPE Feedback AS (
    student_id UUID,
    rating Rating,
    feedback TEXT
);

----------------------------------------------------------------
-- Creating the ZTM Data Model ---------------------------------
----------------------------------------------------------------

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
DROP SCHEMA IF EXISTS edu CASCADE;
CREATE SCHEMA edu;

/* Start with the 'student' table */
CREATE TABLE edu.student (
    student_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) CHECK (email ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}$'),  -- Generate REGEXES according to your needs using a LLM
    date_of_birth DATE NOT NULL
); 

/* Easiest option for second table is 'subject' as it has no dependency (foreign key) for missing tables */
CREATE TABLE edu.subject (
    subject_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subject TEXT NOT NULL,
    description TEXT
);

CREATE TABLE edu.teacher (
    teacher_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    -- opps! forgot the email
    date_of_birth DATE 
);

ALTER TABLE edu.teacher 
ADD COLUMN 
    email VARCHAR(255) CHECK (email ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}$');

CREATE TABLE edu.course (
    course_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL,
    description TEXT,
    subject_id UUID REFERENCES edu.subject(subject_id),
    teacher_id UUID REFERENCES edu.teacher(teacher_id),
    feedback FEEDBACK[]
);

CREATE TABLE edu.enrollment (
    course_id UUID REFERENCES edu.course(course_id),
    student_id UUID REFERENCES edu.student(student_id),
    enrollment_date DATE NOT NULL,
    CONSTRAINT pk_enrollment PRIMARY KEY (course_id, student_id) 
);

----------------------------------------------------------------
-- Inserting Data ----------------------------------------------
----------------------------------------------------------------

/* Starting from the perspective of a user journey */

INSERT INTO edu.student (
    /* If insertion order is not specified, then the default order = CREATE order */
    first_name, last_name, email, date_of_birth
    /* Notice that the student_id is skipped since it is automatically generated */
) VALUES ('Mo', 'Binni', 'mo@binni.io', '1992-11-13'::date);


/* Let's insert the SAME info for a teacher row' */

INSERT INTO edu.teacher (first_name, last_name, email, date_of_birth) 
    VALUES ('Mo', 'Binni', 'mo@binni.io', '1992-11-13'::date);
    
 /* Adding a course, but we need subjects first! */
 
 INSERT INTO edu.subject (subject, description) VALUES
    ('SQL', 'A database management language');
    
/* Unless you're doing a db migration, a feedback entry is not added during tables creation */
INSERT INTO edu.course ("name", description) VALUES 
    ('SQL Zero to Mastery', 'The #1 resource for SQL mastery');
    
/* Shouldn't be allowed to add a course without a subject_id */
/* This is a 'mini-migration' scenario, because we want to alter the table without dropping it */

/* Updating the table first is required to remove the null value */
UPDATE edu.course 
SET teacher_id = (SELECT DISTINCT teacher_id FROM edu.teacher)
 -- NOTE: Assuming only one record. In an actual application, this field would be filled by the backend
WHERE subject_id IS NULL;  
/* */
UPDATE edu.course 
SET subject_id = (SELECT DISTINCT subject_id FROM edu.subject)
WHERE subject_id IS NULL;  

/* Adding the non-nullable constraint */
ALTER TABLE edu.course 
    ALTER COLUMN subject_id SET NOT NULL,
    ALTER COLUMN teacher_id SET NOT NULL;
    
/* Adding an enrollment record */ 
INSERT INTO edu.enrollment (student_id, course_id, enrollment_date) VALUES
    (
        (SELECT DISTINCT student_id FROM edu.student), 
        (SELECT DISTINCT course_id FROM edu.course), 
        CURRENT_DATE
    );
    
/* Adding Feedback to a course */
UPDATE edu.course
SET feedback = array_append( 
    feedback,
    ROW (
        (SELECT DISTINCT student_id FROM edu.student),
        5,
        'Great course!'
    )::feedback -- convert to feedback custom type
)
WHERE course_id = (SELECT DISTINCT course_id FROM edu.course);

----------------------------------------------------------------
-- Updating the Model ------------------------------------------
----------------------------------------------------------------

/* 
 * Right now, the feedback model is not good. There are no 
 * checks for whether a given student_id exists in the student
 * table. We need to change that!
 */
 
 /* The feedback would be its own table */
 ALTER TYPE feedback RENAME TO feedback_deprecated;
 CREATE TABLE edu.feedback (
    student_id UUID NOT NULL REFERENCES edu.student(student_id),
    course_id UUID NOT NULL REFERENCES edu.course(course_id),
    rating Rating,
    feedback TEXT, 
    CONSTRAINT pk_feedback PRIMARY KEY (student_id, course_id)
 );
 
 INSERT INTO edu.feedback (student_id, course_id, rating, feedback) VALUES
    (
        (SELECT DISTINCT student_id FROM edu.student),
        (SELECT DISTINCT course_id FROM edu.course),
        5,
        'This was great!'
    );