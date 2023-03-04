# Laravel

Laravel болон PHP application ажиллуулах суурь docker image. nginx-fpm болон octane гэсэн 2 төрлийн image байгаа.

- `myagmarsurensejdav/laravel-docker:nginx-fpm` ээр Laravel болон бүх төрлийн PHP application ажлуулах боломжтой.
- `myagmarsurensejdav/laravel-docker:octane- ээр Laravel octane аргачлалаар ажиллах application ажлуулах боломжтой.

## Preinstalled packages

Дараах нэмэлт сангууд суурльлуулгадсан байгаа.

- php8.1
- php8.1-swoole
- php8.1-mysql
- php8.1-sqlite
- php8.1-pcntl

# Image Types

## Laravel octane

Laravel-с гаргасан албан ёсны сан бөгөөд php-swoole ийн тусламжтай http request ийг маш хурдтай боловсруулах боломжтой болгож байгаа юм. Илүү дэлгэрэнгүй бэлэн хэрхэн суулгах зааврыг [сайтаас](https://laravel.com/docs/8.x/octane) нь үзнэ үү.

`myagmarsurensejdav/laravel-docker:octane- image ийг ашиглана. APP_ENV=local байгаа тохиолдолд нэмэлтээд `--watch` argument нэмж ачааллах тул source code-д өөрчлөлт орсон бол process автоматаар restart хийгдээд явах болно.

`OCTANE_WORKERS=3`, `OCTANE_TASK_WORKERS=3` гэсэн env тохиргоог тохируулах боломжтой юм. Анхны утгаараа auto, auto ээр тохирсон байгаа тул production build тохиолдолд эдгээр утгыг тухайн серверт тааруулан тохируулах боломжтой юм.

## nginx-fpm

Бүх төрлийн веб аппликэйшн асаах боломжтой юм. `myagmarsurensejdav/laravel-docker:nginx-fpm` image ийг ашиглана. Laravel ээс өөр төрлийн PHP application асааж байгаа тохиолдолд `LARAVEL_TYPE=other` гэсэн тохиргоо хийж өгөх шаардлагатай юм.

# Container Roles

## http

`CONTAINER_ROLE=http` тохиргоогоор ажиллах бөгөөд веб серверийг `8000` дээр асаах юм. Анхдагч утгаараа http байдаг тул нэмэлт тохиргоо хийхгүйгээр шууд асах боломжтой юм.

## Scheduler

1 минут тутамд Laravel scheduler ийг ажиллуулах горим юм `CONTAINER_ROLE=scheduler` гэж тохируулан асааснаар минут тутамд `php artisan scheduler:run` command ийг дуудах байдлаар ажиллах юм.
nginx-fpm болон octane төрлийн бүх image энэ горимоор асах боломжтой.

## Rabbitmq

`vladimir-yuldashev/laravel-queue-rabbitmq` Laravel ийн rabbitmq тай харьцах сан бөгөөд rabbitmq дээр суурьласан queue ажиллах боломжыг олгодог сан юм. Сангийн тухай дэлгэрэнгүй мэдээллийг [github](https://github.com/vyuldashev/laravel-queue-rabbitmq) хуудаснаас танилцана уу.

`RABBITMQ_CONSUMER=true` env тохиргооны тусламжтай `php artisan rabbitmq:consume` process ийг supervisor-т нэмж ажиллуулах боломжтой юм.

## Composer

Build хийгдсэн `myagmarsurensejdav/laravel-docker:octane-composer` docker image ийн тусламжтай composer package уудыг суулгах боломжтой бөгөөд энэ image нь mplus ийн private gitlab repo руу хандах эрхтэйгээрээ давуу талтай юм.

Жишээ нь дараах байдлаар composer install хийж болох юм.

```
docker run --rm -it -v $(pwd):/app \
    myagmarsurensejdav/laravel-docker:octane-composer \
    composer install
```

## Example Dockerfile

Дараахь жишээ docker image-д octane, rabbitmq_consumer, scheduler ийг асааж өгсөн байгаа.

```
FROM myagmarsurensedjav/laravel-docker:octane-dev AS dev

FROM myagmarsurensejdav/laravel-docker:octane-composer AS vendor

COPY composer.json composer.json
COPY composer.lock composer.lock

RUN composer install \
    --optimize-autoloader \
    --no-ansi \
    --no-interaction \
    --no-progress \
    --no-scripts \
    --no-dev

FROM myagmarsurensedjav/laravel-docker:octane AS app

PHP_MEMORY_LIMIT=256M

COPY --from=vendor /app/vendor /app/vendor
COPY . .

RUN chmod -R 777 /app/storage \
    && composer dump-autoload
```

## Environment variables

```
APP_ENV=local

APP_USER=1000
APP_USER_GROUP=1000

OCTANE_WORKERS=3
OCTANE_TASK_WORKERS=3

RABBITMQ_CONSUMER_CONNECTION=rabbitmq

LARAVEL_TYPE=laravel
CONTAINER_ROLE=http|scheduler|horizon|rabbitmq

PHP_MEMORY_LIMIT=256M
```

## Dev container

zsh ашиглан container луу орох боломжтой. Энд oh-my-zshell суулгасан байгаа тул хөгжүүлэлтэнд хэрэгэцээтэй cli програм болон alias ууд суулгасан байгаа тул хөгжүүлэлтэндээ ашиглах боломжтой юм

```
docker-compose exec <service> zsh

# Тест ажлуулах
t

# php-cs-fixer код форматар ажлуулах
fix-cs

# Artisan команд ажлуулах
pa migrate

# Composer
c               # composer
cr              # composer require
crm             # composer remove
cu              # composer update
ci              # composer install
```

# PHP Extensions

## PHP redis

Энэ image-д php ийн redis тэй харьцах суугаагүй байгаа тул composer оор predis/predis санг суулгах хэрэгтэй юм.

```
composer requrie predis/predis
```

Үүний дараа config/database.php файлд байгаа REDIS_CLIENT тохиргоог `predis` гэсэн анхны утга өгөх хэрэгтэй.

## PHP gd

php-gd санг нэмэлтээр суулгах шаардлагатай үед. Image-д суулгах script нь хавсаргагдсан байгаа бөгөөд дараахь байдлаар өөрийн Dockerfile аа бэлдэж болох юм.

```
FROM myagmarsurensejdav/laravel-docker:nginx-fpm
RUN /scripts/install-php-gd.sh
```

## PHP bcmath

php-bcmath санг нэмэлтээр суулгах шаардлагатай үед. Image-д суулгах script нь хавсаргагдсан байгаа бөгөөд дараахь байдлаар өөрийн Dockerfile аа бэлдэж болох юм.

```
FROM myagmarsurensejdav/laravel-docker:nginx-fpm
RUN /scripts/install-php-bcmath.sh
```

## PHP zip

php-zip санг нэмэлтээр суулгах шаардлагатай үед. Image-д суулгах script нь хавсаргагдсан байгаа бөгөөд дараахь байдлаар өөрийн Dockerfile аа бэлдэж болох юм.

```
FROM myagmarsurensejdav/laravel-docker:nginx-fpm
RUN /scripts/install-php-zip.sh
```

# Known issues

## phpredis Extension

`phpredis` ийг pecl ээр суулгах явцад дараахь алдаа гарч байгаа тул дээрх `predis/predis` composer санг ашиглах аргачлалыг ашиглана. 

Дараахь командыг ажиллуулаад суулгах гэсэн боловч:
```
RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis
```

Гарч байгаа алдаа нь:

```
........................................................done: 268,154 bytes
29 source files, building
running: phpize
Configuring for:
PHP Api Version:         20200930
Zend Module Api No:      20200930
Zend Extension Api No:   420200930
Cannot find autoconf. Please check your autoconf installation and the
$PHP_AUTOCONF environment variable. Then, rerun this script.

ERROR: `phpize' failed
```