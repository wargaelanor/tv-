FROM python:3.10-alpine3.23

ARG TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apk update && apk upgrade --scripts=no apk-tools
RUN apk add python3 python3-dev build-base musl-dev gcc g++ tzdata cargo rust libffi-dev musl-dev
RUN apk add --no-cache freetype-dev fribidi-dev harfbuzz-dev libgcc jpeg-dev lcms2-dev
RUN apk add --no-cache openjpeg-dev tcl-dev tiff-dev tk-dev zlib-dev bash pngquant dcron
RUN apk add netcat-openbsd git

RUN git clone https://github.com/developerfromjokela/opencarwings.git /app
WORKDIR /app

RUN pip3 install --upgrade pip
RUN pip3 install django-mysql django-postgresql gunicorn daphne gevent psycopg2-binary
RUN pip3 install -r requirements.txt

RUN /usr/bin/crontab /app/crontab

EXPOSE 80
EXPOSE 55230

CMD ["bash", "/app/docker/start.sh"]
