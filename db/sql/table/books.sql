DROP TABLE IF EXISTS books;
CREATE TABLE books (
    uuid UUID NOT NULL DEFAULT gen_random_uuid()
    ,title TEXT NOT NULL
    ,created_at TIMESTAMPTZ
    ,PRIMARY KEY (uuid)
);
