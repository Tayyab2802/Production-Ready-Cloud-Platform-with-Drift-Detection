from fastapi import FastAPI

app = FastAPI(title="Banking Demo API")


@app.get("/")
def root():
    return {"message": "Banking demo API is running"}


@app.get("/health")
def health():
    return {"status": "healthy"}


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