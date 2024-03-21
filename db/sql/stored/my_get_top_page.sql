DROP TYPE IF EXISTS type_my_get_top_page CASCADE;
CREATE TYPE type_my_get_top_page AS (
  user_json_array JSONB[]
  ,company_json_array JSONB[]
  ,book_json_array JSONB[]
);

CREATE OR REPLACE FUNCTION my_get_top_page (
) RETURNS SETOF type_my_get_top_page AS $FUNCTION$
DECLARE
  w_user_json_array JSONB[];
  w_company_json_array JSONB[];
  w_book_json_array JSONB[];
BEGIN
  SELECT
    ARRAY_AGG(to_json(t1.*) ORDER BY t1.created_at ASC)
  INTO
    w_user_json_array
  FROM
    public.users AS t1 
  ;

  SELECT
    ARRAY_AGG(to_json(t1.*) ORDER BY t1.created_at ASC)
  INTO
    w_company_json_array
  FROM
    public.companies AS t1 
  ;

  SELECT
    ARRAY_AGG(to_json(t1.*) ORDER BY t1.created_at ASC)
  INTO
    w_book_json_array
  FROM
    public.books AS t1 
  ;

  RETURN QUERY SELECT
    w_user_json_array
    ,w_company_json_array
    ,w_book_json_array
  ;
END;
$FUNCTION$ LANGUAGE plpgsql;