import os
from decimal import Decimal

from fastapi import FastAPI
from sqlalchemy import (
    Column,
    ForeignKey,
    Integer,
    Numeric,
    String,
    create_engine,
    text,
)
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import declarative_base, relationship, sessionmaker

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
SessionLocal = sessionmaker(bind=engine) if engine else None
Base = declarative_base()


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)

    accounts = relationship("Account", back_populates="user")


class Account(Base):
    __tablename__ = "accounts"

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    account_type = Column(String(50), nullable=False)
    balance = Column(Numeric(12, 2), nullable=False)

    user = relationship("User", back_populates="accounts")


class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True)
    merchant = Column(String(100), nullable=False)
    amount = Column(Numeric(12, 2), nullable=False)
    category = Column(String(50), nullable=False)


def seed_database():
    if engine is None or SessionLocal is None:
        return

    Base.metadata.create_all(bind=engine)

    db = SessionLocal()
    try:
        existing_user = db.query(User).first()
        if existing_user:
            return

        user = User(name="Demo Customer")
        db.add(user)
        db.flush()

        db.add_all(
            [
                Account(
                    user_id=user.id,
                    account_type="Current Account",
                    balance=Decimal("3452.21"),
                ),
                Account(
                    user_id=user.id,
                    account_type="Savings Account",
                    balance=Decimal("12844.00"),
                ),
            ]
        )

        db.add_all(
            [
                Transaction(
                    merchant="Tesco",
                    amount=Decimal("-43.50"),
                    category="Groceries",
                ),
                Transaction(
                    merchant="Amazon",
                    amount=Decimal("-25.99"),
                    category="Shopping",
                ),
                Transaction(
                    merchant="Salary",
                    amount=Decimal("2100.00"),
                    category="Income",
                ),
            ]
        )

        db.commit()
    finally:
        db.close()


@app.on_event("startup")
def startup_event():
    seed_database()


@app.get("/")
def root():
    return {"message": "Banking demo API is running"}


@app.get("/health")
def health():
    return {"status": "healthy!!!"}


@app.get("/api/db-health")
def db_health():
    if engine is None:
        return {"database": "not configured"}

    try:
        with engine.connect() as connection:
            result = connection.execute(text("SELECT 1"))
            return {"database": "connected", "result": result.scalar()}
    except SQLAlchemyError as error:
        return {"database": "connection failed", "error": str(error)}


@app.get("/api/accounts")
def accounts():
    if SessionLocal is None:
        return {"accounts": []}

    db = SessionLocal()
    try:
        rows = db.query(Account).all()
        return {
            "accounts": [
                {
                    "type": row.account_type,
                    "balance": float(row.balance),
                }
                for row in rows
            ]
        }
    finally:
        db.close()


@app.get("/api/transactions")
def transactions():
    if SessionLocal is None:
        return {"transactions": []}

    db = SessionLocal()
    try:
        rows = db.query(Transaction).all()
        return {
            "transactions": [
                {
                    "merchant": row.merchant,
                    "amount": float(row.amount),
                    "category": row.category,
                }
                for row in rows
            ]
        }
    finally:
        db.close()