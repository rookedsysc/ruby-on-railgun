FROM python:3.10-slim

WORKDIR /app

COPY ./app /app
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000
EXPOSE 50051

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]