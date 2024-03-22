DROP TYPE IF EXISTS type_my_set_books_for_add CASCADE;
CREATE TYPE type_my_set_books_for_add AS (
  uuid UUID
);

CREATE OR REPLACE FUNCTION my_set_books_for_add (
  p_user_uuid UUID DEFAULT NULL
  ,p_title TEXT DEFAULT NULL
  ,p_now TIMESTAMPTZ DEFAULT NULL
) RETURNS SETOF type_my_set_books_for_add AS $FUNCTION$
DECLARE
  w_book_count BIGINT;
  w_now TIMESTAMPTZ := COALESCE(p_now, NOW());
  w_row RECORD;
BEGIN
  RETURN QUERY
  INSERT INTO books (title, user_uuid, created_at) 
  VALUES (p_title, p_user_uuid, w_now)
  RETURNING
    uuid
  ;

  SELECT COUNT(*) INTO w_book_count FROM books
  WHERE
    user_uuid = p_user_uuid
  ;

  UPDATE users SET
    book_count = w_book_count
  WHERE
    uuid = p_user_uuid
  ;
END;
$FUNCTION$ LANGUAGE plpgsql;