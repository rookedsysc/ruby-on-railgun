FROM my-python-base:1.0

WORKDIR /app

COPY ./app /app

ENV PYTHONPATH=/app

EXPOSE 8000
EXPOSE 50051

RUN ls

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
