#!/bin/sh

echo "🎬 entrypoint.sh"

composer dump-autoload --no-interaction --no-dev --optimize

echo "🎬 artisan commands"

php artisan cache:clear
php artisan october:up
#chown -R www-data:www-data $LARAVEL_PATH/storage/app/uploads
#chmod -R 775 $LARAVEL_PATH/storage/app/uploads

#echo "🎬 reset manifest cache"
#php artisan cache:forget cdn:manifest

echo "🎬 start supervisord"
supervisord -c $LARAVEL_PATH/.deploy/config/supervisor.conf
