SET search_path TO recruiting, public;

SELECT
    v.vacancy_id,
    v.title,
    ts_rank_cd(v.search_vector, websearch_to_tsquery('russian', 'комиссий лимитов статусов платежей')) AS relevance
FROM vacancy v
WHERE v.is_active = TRUE
  AND v.search_vector @@ websearch_to_tsquery('russian', 'комиссий лимитов статусов платежей')
ORDER BY relevance DESC, v.published_at DESC
LIMIT 10;

SELECT
    v.vacancy_id,
    v.title,
    GREATEST(
        similarity(LOWER(v.title), 'postgre'),
        similarity(LOWER(v.description), 'резервн')
    ) AS relevance
FROM vacancy v
WHERE LOWER(v.title) LIKE '%postgre%'
   OR LOWER(v.description) LIKE '%резервн%'
ORDER BY relevance DESC, v.published_at DESC
LIMIT 10;

WITH search_params AS (
    SELECT
        'postgresql резервным копированием'::TEXT AS term,
        websearch_to_tsquery('russian', 'postgresql резервным копированием') AS query
)
SELECT
    v.vacancy_id,
    v.title,
    ts_rank_cd(v.search_vector, sp.query) AS text_rank,
    GREATEST(
        similarity(LOWER(v.title), LOWER(sp.term)),
        similarity(LOWER(v.description), LOWER(sp.term))
    ) AS trigram_rank,
    ts_rank_cd(v.search_vector, sp.query) * 0.8 +
    GREATEST(
        similarity(LOWER(v.title), LOWER(sp.term)),
        similarity(LOWER(v.description), LOWER(sp.term))
    ) * 0.2 AS total_rank
FROM vacancy v
CROSS JOIN search_params sp
WHERE v.is_active = TRUE
  AND (
        v.search_vector @@ sp.query
        OR LOWER(v.title) % LOWER(sp.term)
        OR LOWER(v.description) % LOWER(sp.term)
      )
ORDER BY total_rank DESC, v.published_at DESC
LIMIT 10;

EXPLAIN ANALYZE
SELECT
    v.vacancy_id,
    v.title,
    ts_rank_cd(v.search_vector, websearch_to_tsquery('russian', 'комиссий лимитов статусов платежей')) AS relevance
FROM vacancy v
WHERE v.is_active = TRUE
  AND v.search_vector @@ websearch_to_tsquery('russian', 'комиссий лимитов статусов платежей')
ORDER BY relevance DESC, v.published_at DESC
LIMIT 10;

EXPLAIN ANALYZE
SELECT
    v.vacancy_id,
    v.title,
    GREATEST(
        similarity(LOWER(v.title), 'postgre'),
        similarity(LOWER(v.description), 'резервн')
    ) AS relevance
FROM vacancy v
WHERE LOWER(v.title) LIKE '%postgre%'
   OR LOWER(v.description) LIKE '%резервн%'
ORDER BY relevance DESC, v.published_at DESC
LIMIT 10;

EXPLAIN ANALYZE
WITH search_params AS (
    SELECT
        'postgresql резервным копированием'::TEXT AS term,
        websearch_to_tsquery('russian', 'postgresql резервным копированием') AS query
)
SELECT
    v.vacancy_id,
    v.title,
    ts_rank_cd(v.search_vector, sp.query) * 0.8 +
    GREATEST(
        similarity(LOWER(v.title), LOWER(sp.term)),
        similarity(LOWER(v.description), LOWER(sp.term))
    ) * 0.2 AS total_rank
FROM vacancy v
CROSS JOIN search_params sp
WHERE v.is_active = TRUE
  AND (
        v.search_vector @@ sp.query
        OR LOWER(v.title) % LOWER(sp.term)
        OR LOWER(v.description) % LOWER(sp.term)
      )
ORDER BY total_rank DESC, v.published_at DESC
LIMIT 10;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT
    v.vacancy_id,
    v.title,
    ts_rank_cd(v.search_vector, websearch_to_tsquery('russian', 'комиссий лимитов статусов платежей')) AS relevance
FROM vacancy v
WHERE v.is_active = TRUE
  AND v.search_vector @@ websearch_to_tsquery('russian', 'комиссий лимитов статусов платежей')
ORDER BY relevance DESC, v.published_at DESC
LIMIT 10;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT
    v.vacancy_id,
    v.title,
    GREATEST(
        similarity(LOWER(v.title), 'postgre'),
        similarity(LOWER(v.description), 'резервн')
    ) AS relevance
FROM vacancy v
WHERE LOWER(v.title) LIKE '%postgre%'
   OR LOWER(v.description) LIKE '%резервн%'
ORDER BY relevance DESC, v.published_at DESC
LIMIT 10;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
WITH search_params AS (
    SELECT
        'postgresql резервным копированием'::TEXT AS term,
        websearch_to_tsquery('russian', 'postgresql резервным копированием') AS query
)
SELECT
    v.vacancy_id,
    v.title,
    ts_rank_cd(v.search_vector, sp.query) * 0.8 +
    GREATEST(
        similarity(LOWER(v.title), LOWER(sp.term)),
        similarity(LOWER(v.description), LOWER(sp.term))
    ) * 0.2 AS total_rank
FROM vacancy v
CROSS JOIN search_params sp
WHERE v.is_active = TRUE
  AND (
        v.search_vector @@ sp.query
        OR LOWER(v.title) % LOWER(sp.term)
        OR LOWER(v.description) % LOWER(sp.term)
      )
ORDER BY total_rank DESC, v.published_at DESC
LIMIT 10;
