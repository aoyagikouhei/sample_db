use axum::{
    http::Uri,
    response::IntoResponse,
    routing::get,
    Json, Router,
};
use serde_json::json;
use std::collections::HashMap;
use tiktokapi_v2::{
    apis::{get_v2_user_info, post_v2_video_list},
    oauth::{TiktokOauth, TiktokScope},
    responses::{user::UserField, video::VideoField},
};
use tower_cookies::{Cookie, CookieManagerLayer, Cookies};
use url::Url;

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/", get(points))
        .layer(CookieManagerLayer::new());

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
