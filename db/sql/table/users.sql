DROP TABLE IF EXISTS users;
CREATE TABLE users (
    uuid UUID NOT NULL DEFAULT gen_random_uuid()
    ,user_name TEXT NOT NULL
    ,book_count BIGINT NOT NULL DEFAULT 0
    ,created_at TIMESTAMPTZ
    ,PRIMARY KEY (uuid)
);
