DROP TYPE IF EXISTS type_my_set_workers_for_start CASCADE;
CREATE TYPE type_my_set_workers_for_start AS (
  uuid UUID
);

CREATE OR REPLACE FUNCTION my_set_workers_for_start (
  p_now TIMESTAMPTZ DEFAULT NULL
) RETURNS SETOF type_my_set_workers_for_start AS $FUNCTION$
DECLARE
  w_now TIMESTAMPTZ := COALESCE(p_now, NOW());
  w_row RECORD;
BEGIN
  FOR i IN 1..10 LOOP
    SELECT 
      uuid
    INTO 
      w_row
    FROM 
      workers
    WHERE 
      start_at IS NULL
    ORDER BY 
      t1.created_at DESC
    LIMIT 1;
    IF NOT FOUND THEN
      RETURN;
    END IF;
    
    UPDATE workers SET
      start_at = w_now
    WHERE
      uuid = w_row.uuid
      AND start_at IS NULL
    ;
    IF FOUND THEN
      RETURN QUERY SELECT w_row.uuid;
      RETURN;
    END IF;
  END LOOP;
END;
$FUNCTION$ LANGUAGE plpgsql;