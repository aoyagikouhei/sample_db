DROP TABLE IF EXISTS workers;
CREATE TABLE workers (
    uuid UUID NOT NULL
    ,created_at TIMESTAMPTZ
    ,start_at TIMESTAMPTZ
    ,PRIMARY KEY (uuid)
);

