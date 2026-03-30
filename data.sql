SET search_path TO recruiting, public;

INSERT INTO industry (name)
VALUES
('Финтех'),
('Электронная коммерция'),
('Логистика'),
('HealthTech'),
('EdTech'),
('Телеком'),
('SaaS'),
('Информационная безопасность');

INSERT INTO region (name)
VALUES
('Москва'),
('Санкт-Петербург'),
('Республика Татарстан'),
('Новосибирская область'),
('Свердловская область'),
('Самарская область'),
('Нижегородская область'),
('Краснодарский край');

INSERT INTO city (region_id, name)
SELECT r.region_id, s.name
FROM region r
JOIN (
    VALUES
    ('Москва', 'Москва'),
    ('Санкт-Петербург', 'Санкт-Петербург'),
    ('Республика Татарстан', 'Казань'),
    ('Новосибирская область', 'Новосибирск'),
    ('Свердловская область', 'Екатеринбург'),
    ('Самарская область', 'Самара'),
    ('Нижегородская область', 'Нижний Новгород'),
    ('Краснодарский край', 'Краснодар')
) AS s(region_name, name) ON s.region_name = r.name;

INSERT INTO employment_type (name)
VALUES
('Полная занятость'),
('Частичная занятость'),
('Проектная работа');

INSERT INTO work_format (name)
VALUES
('Офис'),
('Гибрид'),
('Удаленно');

INSERT INTO seniority_level (name)
VALUES
('Junior'),
('Middle'),
('Senior'),
('Lead');

WITH company_source(industry_name, city_name, name, website, founded_on) AS (
    VALUES
    ('Финтех', 'Москва', 'ФинКонтур', 'https://fincontur.ru', DATE '2016-04-12'),
    ('Финтех', 'Санкт-Петербург', 'Платежный Вектор', 'https://payvector.ru', DATE '2018-09-03'),
    ('Электронная коммерция', 'Москва', 'МаркетПульс', 'https://marketpulse.ru', DATE '2015-02-18'),
    ('Электронная коммерция', 'Самара', 'ШопЛиния', 'https://shopline.ru', DATE '2019-07-22'),
    ('Логистика', 'Казань', 'СфераДоставка', 'https://sfera-delivery.ru', DATE '2014-05-30'),
    ('Логистика', 'Нижний Новгород', 'Маршрут24', 'https://route24.ru', DATE '2017-11-08'),
    ('HealthTech', 'Новосибирск', 'МедПлатформа', 'https://medplatform.ru', DATE '2016-10-14'),
    ('HealthTech', 'Краснодар', 'Диагностик Онлайн', 'https://diag-online.ru', DATE '2020-03-12'),
    ('EdTech', 'Екатеринбург', 'ОбразПро', 'https://obrazpro.ru', DATE '2013-08-27'),
    ('EdTech', 'Санкт-Петербург', 'КурсНавигатор', 'https://coursenavigator.ru', DATE '2021-01-19'),
    ('Телеком', 'Москва', 'СеверТелеком', 'https://severtelecom.ru', DATE '2012-06-15'),
    ('Телеком', 'Новосибирск', 'СвязьГрад', 'https://svyazgrad.ru', DATE '2018-12-11'),
    ('SaaS', 'Казань', 'ПиксельСофт', 'https://pixelsoft.ru', DATE '2017-04-05'),
    ('SaaS', 'Екатеринбург', 'ДатаПоток', 'https://datastream.ru', DATE '2019-09-17'),
    ('Информационная безопасность', 'Москва', 'КиберЩит', 'https://cybershield.ru', DATE '2015-11-20'),
    ('Информационная безопасность', 'Нижний Новгород', 'Сигнал Безопасности', 'https://signal-sec.ru', DATE '2020-06-09')
)
INSERT INTO company (industry_id, city_id, name, website, founded_on)
SELECT i.industry_id, c.city_id, s.name, s.website, s.founded_on
FROM company_source s
JOIN industry i ON i.name = s.industry_name
JOIN city c ON c.name = s.city_name;

INSERT INTO skill (name)
VALUES
('SQL'),
('PostgreSQL'),
('Python'),
('Pandas'),
('Airflow'),
('dbt'),
('Kafka'),
('Docker'),
('Kubernetes'),
('Linux'),
('Git'),
('REST API'),
('gRPC'),
('Java'),
('Spring Boot'),
('Go'),
('React'),
('TypeScript'),
('Figma'),
('Power BI'),
('Tableau'),
('ClickHouse'),
('Machine Learning'),
('PyTorch'),
('Swift'),
('Objective-C'),
('DevOps'),
('Prometheus'),
('Grafana'),
('BPMN'),
('1С'),
('Jira'),
('CI/CD'),
('Nginx'),
('Redis'),
('RabbitMQ'),
('QA'),
('Selenium'),
('TestRail'),
('Информационная безопасность');

CREATE TEMP TABLE vacancy_template (
    industry_name TEXT NOT NULL,
    title TEXT NOT NULL PRIMARY KEY,
    description TEXT NOT NULL,
    employment_type_name TEXT NOT NULL,
    work_format_name TEXT NOT NULL,
    seniority_level_name TEXT NOT NULL,
    base_salary_from INTEGER NOT NULL,
    base_salary_to INTEGER NOT NULL
);

INSERT INTO vacancy_template (industry_name, title, description, employment_type_name, work_format_name, seniority_level_name, base_salary_from, base_salary_to)
VALUES
('Финтех', 'Аналитик данных', 'Нужно анализировать клиентское поведение, строить витрины данных и помогать продуктовым командам принимать решения по платежным сервисам и финансовым сценариям.', 'Полная занятость', 'Гибрид', 'Middle', 180000, 240000),
('Финтех', 'Системный аналитик', 'Роль связана с описанием интеграций, проработкой API и моделированием процессов расчета комиссий, лимитов и статусов платежей.', 'Полная занятость', 'Гибрид', 'Senior', 220000, 300000),
('Электронная коммерция', 'Python-разработчик', 'Команда развивает сервисы каталога и рекомендаций, пишет backend на Python и проектирует устойчивые интеграции между заказами, корзиной и складом.', 'Полная занятость', 'Удаленно', 'Middle', 200000, 280000),
('Электронная коммерция', 'React-разработчик', 'Нужно развивать интерфейсы личного кабинета, оформления заказа и управления доставкой, уделяя внимание скорости, доступности и удобству клиента.', 'Полная занятость', 'Удаленно', 'Middle', 190000, 260000),
('Логистика', 'Руководитель проектов', 'Необходимо координировать запуск логистических сервисов, согласовывать сроки с подрядчиками и вести дорожную карту автоматизации складских операций.', 'Полная занятость', 'Офис', 'Lead', 230000, 310000),
('Логистика', 'QA-инженер', 'Вакансия для специалиста по тестированию веб-сервисов и внутренних приложений, которые управляют маршрутами, складами и статусами поставок.', 'Полная занятость', 'Гибрид', 'Middle', 150000, 210000),
('HealthTech', 'Data engineer', 'Нужно поддерживать потоковую обработку медицинских событий, строить надежные ETL-пайплайны и обеспечивать качество данных для аналитики и отчетности.', 'Полная занятость', 'Гибрид', 'Senior', 230000, 320000),
('HealthTech', 'Product manager', 'Команда ищет менеджера продукта для развития цифровых кабинетов пациентов, онлайн-записи и сервисов клинической коммуникации.', 'Полная занятость', 'Гибрид', 'Senior', 240000, 330000),
('EdTech', 'BI-аналитик', 'Предстоит разрабатывать управленческие отчеты, анализировать воронку обучения и искать точки роста удержания студентов на цифровой платформе.', 'Полная занятость', 'Удаленно', 'Middle', 170000, 230000),
('EdTech', 'UX/UI designer', 'Нужно проектировать сценарии обучения, пересобирать пользовательский путь и улучшать интерфейсы курсов, домашней работы и коммуникации с преподавателем.', 'Полная занятость', 'Удаленно', 'Middle', 160000, 220000),
('Телеком', 'DevOps engineer', 'Роль включает сопровождение платформы мониторинга, развитие CI/CD и повышение устойчивости сервисов, которые обслуживают миллионы клиентских запросов.', 'Полная занятость', 'Гибрид', 'Senior', 240000, 320000),
('Телеком', 'Java-разработчик', 'Команда создает высоконагруженные сервисы для тарификации, биллинга и обработки сетевых событий, уделяя внимание отказоустойчивости и производительности.', 'Полная занятость', 'Гибрид', 'Senior', 230000, 310000),
('SaaS', 'DBA PostgreSQL', 'Нужно сопровождать кластеры PostgreSQL, оптимизировать сложные запросы, следить за резервным копированием и помогать командам разработки с моделированием данных.', 'Полная занятость', 'Удаленно', 'Senior', 230000, 320000),
('SaaS', 'Go-разработчик', 'Команда разрабатывает сервисы автоматизации продаж и документооборота, использует микросервисную архитектуру и работает с очередями событий.', 'Полная занятость', 'Удаленно', 'Middle', 220000, 300000),
('Информационная безопасность', 'Инженер по информационной безопасности', 'Нужно расследовать инциденты, выстраивать процессы контроля доступа и внедрять инструменты защиты инфраструктуры и пользовательских данных.', 'Полная занятость', 'Гибрид', 'Senior', 220000, 300000),
('Информационная безопасность', 'ML engineer', 'Команда строит модели выявления аномалий и подозрительной активности, работает с потоками событий и обучает модели на большом объеме телеметрии.', 'Полная занятость', 'Удаленно', 'Senior', 260000, 360000);

CREATE TEMP TABLE vacancy_template_skill (
    title TEXT NOT NULL,
    skill_name TEXT NOT NULL,
    PRIMARY KEY (title, skill_name)
);

INSERT INTO vacancy_template_skill (title, skill_name)
VALUES
('Аналитик данных', 'SQL'),
('Аналитик данных', 'PostgreSQL'),
('Аналитик данных', 'Python'),
('Аналитик данных', 'Pandas'),
('Аналитик данных', 'Tableau'),
('Системный аналитик', 'SQL'),
('Системный аналитик', 'REST API'),
('Системный аналитик', 'BPMN'),
('Системный аналитик', 'Jira'),
('Python-разработчик', 'Python'),
('Python-разработчик', 'PostgreSQL'),
('Python-разработчик', 'Docker'),
('Python-разработчик', 'Git'),
('Python-разработчик', 'Redis'),
('React-разработчик', 'React'),
('React-разработчик', 'TypeScript'),
('React-разработчик', 'REST API'),
('React-разработчик', 'Git'),
('Руководитель проектов', 'Jira'),
('Руководитель проектов', 'BPMN'),
('Руководитель проектов', 'SQL'),
('QA-инженер', 'QA'),
('QA-инженер', 'Selenium'),
('QA-инженер', 'TestRail'),
('QA-инженер', 'SQL'),
('Data engineer', 'Python'),
('Data engineer', 'SQL'),
('Data engineer', 'Airflow'),
('Data engineer', 'dbt'),
('Data engineer', 'Kafka'),
('Product manager', 'Jira'),
('Product manager', 'SQL'),
('Product manager', 'BPMN'),
('BI-аналитик', 'SQL'),
('BI-аналитик', 'ClickHouse'),
('BI-аналитик', 'Power BI'),
('BI-аналитик', 'Tableau'),
('UX/UI designer', 'Figma'),
('UX/UI designer', 'Jira'),
('DevOps engineer', 'Docker'),
('DevOps engineer', 'Kubernetes'),
('DevOps engineer', 'Linux'),
('DevOps engineer', 'CI/CD'),
('DevOps engineer', 'Prometheus'),
('DevOps engineer', 'Grafana'),
('Java-разработчик', 'Java'),
('Java-разработчик', 'Spring Boot'),
('Java-разработчик', 'PostgreSQL'),
('Java-разработчик', 'Kafka'),
('DBA PostgreSQL', 'PostgreSQL'),
('DBA PostgreSQL', 'SQL'),
('DBA PostgreSQL', 'Linux'),
('DBA PostgreSQL', 'Docker'),
('Go-разработчик', 'Go'),
('Go-разработчик', 'PostgreSQL'),
('Go-разработчик', 'gRPC'),
('Go-разработчик', 'RabbitMQ'),
('Инженер по информационной безопасности', 'Linux'),
('Инженер по информационной безопасности', 'Информационная безопасность'),
('Инженер по информационной безопасности', 'Docker'),
('ML engineer', 'Python'),
('ML engineer', 'Machine Learning'),
('ML engineer', 'PyTorch'),
('ML engineer', 'Kafka');

INSERT INTO vacancy (
    company_id,
    city_id,
    employment_type_id,
    work_format_id,
    seniority_level_id,
    title,
    description,
    salary_from,
    salary_to,
    published_at,
    is_active
)
SELECT
    c.company_id,
    c.city_id,
    et.employment_type_id,
    wf.work_format_id,
    sl.seniority_level_id,
    CASE
        WHEN g.n % 6 = 0 THEN 'Ведущий ' || vt.title
        WHEN g.n % 5 = 0 AND vt.seniority_level_name IN ('Middle', 'Senior') THEN vt.title || ' в продуктовую команду'
        ELSE vt.title
    END,
    vt.description ||
    CASE g.n % 6
        WHEN 0 THEN ' Команда запускает новый продукт и усиливает аналитическую и инженерную экспертизу.'
        WHEN 1 THEN ' Важна самостоятельность в работе, умение общаться с бизнесом и аккуратно вести документацию.'
        WHEN 2 THEN ' Проект находится в активной фазе роста, поэтому ожидается участие в улучшении процессов и архитектурных решений.'
        WHEN 3 THEN ' Работа предполагает тесное взаимодействие с аналитиками, разработчиками, тестировщиками и продуктовой командой.'
        WHEN 4 THEN ' От кандидата ожидается опыт оптимизации процессов, внимательность к деталям и ориентация на измеримый результат.'
        ELSE ' Компания расширяет платформу и ищет специалиста, который поможет ускорить поставку изменений без потери качества.'
    END,
    vt.base_salary_from + g.n * 600 + c.company_id * 1500,
    vt.base_salary_to + g.n * 800 + c.company_id * 1700,
    DATE '2026-03-30' - (((g.n - 1) * 2 + c.company_id)::INTEGER),
    g.n % 7 <> 0
FROM vacancy_template vt
JOIN industry i ON i.name = vt.industry_name
JOIN company c ON c.industry_id = i.industry_id
JOIN employment_type et ON et.name = vt.employment_type_name
JOIN work_format wf ON wf.name = vt.work_format_name
JOIN seniority_level sl ON sl.name = vt.seniority_level_name
CROSS JOIN generate_series(1, 200) AS g(n);

INSERT INTO vacancy_skill (vacancy_id, skill_id)
SELECT v.vacancy_id, s.skill_id
FROM vacancy v
JOIN vacancy_template_skill vts ON vts.title = REPLACE(v.title, 'Ведущий ', '')
JOIN skill s ON s.name = vts.skill_name
ON CONFLICT DO NOTHING;

INSERT INTO vacancy_skill (vacancy_id, skill_id)
SELECT v.vacancy_id, s.skill_id
FROM vacancy v
JOIN vacancy_template_skill vts ON vts.title = REPLACE(v.title, ' в продуктовую команду', '')
JOIN skill s ON s.name = vts.skill_name
ON CONFLICT DO NOTHING;
