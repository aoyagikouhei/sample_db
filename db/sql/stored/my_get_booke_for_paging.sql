DROP TYPE IF EXISTS type_my_get_booke_for_paging CASCADE;
CREATE TYPE type_my_get_booke_for_paging AS (
  uuid UUID
  ,title TEXT
);

CREATE OR REPLACE FUNCTION my_get_booke_for_paging (
  p_title TEXT DEFAULT NULL
  ,p_limit BIGINT DEFAULT NULL
  ,p_offset BIGINT DEFAULT 0
  ,p_with_count_flag BOOLEAN DEFAULT FALSE
) RETURNS SETOF type_my_get_booke_for_paging AS $FUNCTION$
DECLARE
BEGIN
  RETURN QUERY SELECT
    t1.uuid
    ,t1.title
  FROM
    public.books AS t1
  WHERE
    p_title IS NULL OR title LIKE p_title
  ORDER BY
    t1.created_at
  LIMIT
    p_limit
  OFFSET
    p_offset
  ;

  IF p_with_count_flag IS TRUE THEN
    RETURN QUERY SELECT
      NULL::UUID
      ,COUNT(*)::TEXT
    FROM
      public.books
    WHERE
      p_title IS NULL OR title LIKE p_title
    ;
  END IF;
END;
$FUNCTION$ LANGUAGE plpgsql;