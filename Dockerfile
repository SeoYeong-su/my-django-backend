# 알파인 3.19 버전의 리눅스를 구축하는데 파이썬 버전은 3.11로 설치된 이미지를 불러옴
# 알파인 : 경량화된 리눅스
FROM python:3.11-alpine3.19

LABEL maintainer='seoddongsu'

# 컨테이너에 찍히는 로그를 볼 수 있도록 허용
# 실시간으로 볼 수 있기 때문에 컨테이너를 관리하기 편함.
ENV PYTHONUNBUFFERD 1

# tmp에 넣는 이유 : 컨테이너를 최대한 경량화 하기 위해서 -> 빌드가 완료되면 tmp 폴더를 삭제
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app
# django 포트번호
EXPOSE 8000

ARG DEV=false

# && \ : 엔터를 의미
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = 'true' ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user