use crate::error::Error;
use deadpool_postgres::tokio_postgres::NoTls;
use once_cell::sync::OnceCell;
use serde::Deserialize;

pub type PgPool = deadpool_postgres::Pool;
pub type PgClient = deadpool_postgres::Client;

static INSTANCE: OnceCell<Config> = OnceCell::new();

#[derive(Debug, Deserialize, Clone)]
pub struct Config {
    pub pg_url: String,
}

impl Config {
    pub async fn new() -> Result<Self, Error> {
        let pg_url =
            std::env::var("PG_URL").unwrap_or("postgres://user:pass@db:5432/web".to_owned());
        Ok(Self { pg_url })
    }

    pub fn global() -> &'static Config {
        INSTANCE.get().expect("config is not initialized")
    }

    pub fn set_global(value: &Config) {
        let _ = INSTANCE.set(value.clone());
    }

    pub fn get_postgres_pool(&self) -> Result<deadpool_postgres::Pool, Error> {
        let pg_url = url::Url::parse(&self.pg_url)?;
        let dbname = match pg_url.path_segments() {
            Some(mut res) => res.next(),
            None => Some("web"),
        };
        let cfg = deadpool_postgres::Config {
            user: Some(pg_url.username().to_string()),
            password: pg_url.password().map(|password| password.to_string()),
            dbname: dbname.map(|dbname| dbname.to_string()),
            host: pg_url.host_str().map(|host| host.to_string()),
            ..Default::default()
        };
        let res = cfg.create_pool(Some(deadpool_postgres::Runtime::Tokio1), NoTls)?;
        Ok(res)
    }

    pub async fn get_postgres_client(
        pool: &deadpool_postgres::Pool,
    ) -> Result<deadpool_postgres::Client, Error> {
        pool.get().await.map_err(Into::into)
    }

    pub async fn setup() -> Result<Self, Error> {
        let config = Self::new().await?;
        Self::set_global(&config);
        Ok(config)
    }
}
