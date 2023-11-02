
## Laravel Docker AWS Deployment

## setup

``` bash
make fresh
docker compose exec api composer update
# or 
docker compose exec api composer install
docker compose exec api php artisan jetstream:install inertia
docker compose exec api php artisan migrate
# DB_HOSTはコンテナ名であることに留意
```