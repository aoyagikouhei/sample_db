DROP TYPE IF EXISTS type_my_set_users_for_delete CASCADE;
CREATE TYPE type_my_set_users_for_delete AS (
  uuid UUID
);

CREATE OR REPLACE FUNCTION my_set_users_for_delete (
  p_user_uuid UUID DEFAULT NULL
  ,p_now TIMESTAMPTZ DEFAULT NULL
) RETURNS SETOF type_my_set_users_for_delete AS $FUNCTION$
DECLARE
  w_book_count BIGINT;
  w_now TIMESTAMPTZ := COALESCE(p_now, NOW());
BEGIN
  DELETE FROM books WHERE user_uuid = p_user_uuid;
  DELETE FROM users WHERE uuid = p_user_uuid;
END;
$FUNCTION$ LANGUAGE plpgsql;