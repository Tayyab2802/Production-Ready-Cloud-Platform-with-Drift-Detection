import os

from fastapi import FastAPI
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError

app = FastAPI(title="Banking Demo API")


DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME")
DB_USERNAME = os.getenv("DB_USERNAME")
DB_PASSWORD = os.getenv("DB_PASSWORD")


def get_database_url():
    if not all([DB_HOST, DB_NAME, DB_USERNAME, DB_PASSWORD]):
        return None

    return (
        f"postgresql://{DB_USERNAME}:{DB_PASSWORD}"
        f"@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )


DATABASE_URL = get_database_url()
engine = create_engine(DATABASE_URL) if DATABASE_URL else None


@app.get("/")
def root():
    return {"message": "Banking demo API is running"}


@app.get("/health")
def health():
    return {"status": "healthy"}


@app.get("/api/db-health")
def db_health():
    if engine is None:
        return {"database": "not configured"}

    try:
        with engine.connect() as connection:
            result = connection.execute(text("SELECT 1"))
            return {
                "database": "connected",
                "result": result.scalar()
            }
    except SQLAlchemyError as error:
        return {
            "database": "connection failed",
            "error": str(error)
        }


@app.get("/api/accounts")
def accounts():
    return {
        "accounts": [
            {"type": "Current Account", "balance": 3452.21},
            {"type": "Savings Account", "balance": 12844.00},
        ]
    }


@app.get("/api/transactions")
def transactions():
    return {
        "transactions": [
            {"merchant": "Tesco", "amount": -43.50},
            {"merchant": "Amazon", "amount": -25.99},
            {"merchant": "Salary", "amount": 2100.00},
        ]
    }