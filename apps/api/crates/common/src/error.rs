use thiserror::Error;

#[derive(Error, Debug)]
pub enum Error {
    #[error("Invalid {0}")]
    Invalid(String),

    #[error("NotFound")]
    NotFound,

    #[error("Json {0}")]
    Json(#[from] serde_json::Error),

    #[error("Url {0}")]
    Url(#[from] url::ParseError),

    #[error("PgPoolCrete {0}")]
    PgPoolCrete(#[from] deadpool_postgres::CreatePoolError),

    #[error("PostgresPool {0}")]
    PostgresPool(#[from] deadpool_postgres::PoolError),

    #[error("Postgres {0}")]
    Postgres(#[from] deadpool_postgres::tokio_postgres::Error),
}
