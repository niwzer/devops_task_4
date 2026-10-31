FROM python:3.7.3

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .

RUN python -m pip install --no-cache-dir -r requirements.txt \
    && python -m pip install --no-cache-dir gunicorn==23.0.0

COPY . .

RUN python manage.py build

WORKDIR /app/build

EXPOSE 8000

CMD ["gunicorn", "demo.wsgi:application", "--bind", "0.0.0.0:8000", "--access-logfile", "-", "--error-logfile", "-"]