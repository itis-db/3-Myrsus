DROP SCHEMA IF EXISTS recruiting CASCADE;
CREATE SCHEMA recruiting;
SET search_path TO recruiting, public;

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE industry (
    industry_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE region (
    region_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE city (
    city_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    region_id BIGINT NOT NULL REFERENCES region(region_id),
    name TEXT NOT NULL,
    UNIQUE (region_id, name)
);

CREATE TABLE employment_type (
    employment_type_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE work_format (
    work_format_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE seniority_level (
    seniority_level_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE company (
    company_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    industry_id BIGINT NOT NULL REFERENCES industry(industry_id),
    city_id BIGINT NOT NULL REFERENCES city(city_id),
    name TEXT NOT NULL UNIQUE,
    website TEXT NOT NULL UNIQUE,
    founded_on DATE NOT NULL
);

CREATE TABLE skill (
    skill_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE vacancy (
    vacancy_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    company_id BIGINT NOT NULL REFERENCES company(company_id),
    city_id BIGINT NOT NULL REFERENCES city(city_id),
    employment_type_id BIGINT NOT NULL REFERENCES employment_type(employment_type_id),
    work_format_id BIGINT NOT NULL REFERENCES work_format(work_format_id),
    seniority_level_id BIGINT NOT NULL REFERENCES seniority_level(seniority_level_id),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    salary_from INTEGER NOT NULL CHECK (salary_from > 0),
    salary_to INTEGER NOT NULL CHECK (salary_to >= salary_from),
    published_at DATE NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    search_vector tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('russian', COALESCE(title, '')), 'A') ||
        setweight(to_tsvector('russian', COALESCE(description, '')), 'B')
    ) STORED
);

CREATE TABLE vacancy_skill (
    vacancy_id BIGINT NOT NULL REFERENCES vacancy(vacancy_id),
    skill_id BIGINT NOT NULL REFERENCES skill(skill_id),
    PRIMARY KEY (vacancy_id, skill_id)
);

CREATE INDEX city_region_id_idx ON city(region_id);
CREATE INDEX company_industry_id_idx ON company(industry_id);
CREATE INDEX company_city_id_idx ON company(city_id);
CREATE INDEX vacancy_company_id_idx ON vacancy(company_id);
CREATE INDEX vacancy_city_id_idx ON vacancy(city_id);
CREATE INDEX vacancy_employment_type_id_idx ON vacancy(employment_type_id);
CREATE INDEX vacancy_work_format_id_idx ON vacancy(work_format_id);
CREATE INDEX vacancy_seniority_level_id_idx ON vacancy(seniority_level_id);
CREATE INDEX vacancy_published_at_idx ON vacancy(published_at DESC);
CREATE INDEX vacancy_active_published_idx ON vacancy(is_active, published_at DESC);
CREATE INDEX vacancy_skill_skill_id_idx ON vacancy_skill(skill_id);
CREATE INDEX vacancy_search_vector_idx ON vacancy USING GIN(search_vector);
CREATE INDEX vacancy_title_trgm_idx ON vacancy USING GIN(LOWER(title) gin_trgm_ops);
CREATE INDEX vacancy_description_trgm_idx ON vacancy USING GIN(LOWER(description) gin_trgm_ops);
