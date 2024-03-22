DROP TABLE IF EXISTS books;
CREATE TABLE books (
    uuid UUID NOT NULL DEFAULT gen_random_uuid()
    ,user_uuid UUID NOT NULL
    ,title TEXT NOT NULL
    ,created_at TIMESTAMPTZ
    ,PRIMARY KEY (uuid)
);
