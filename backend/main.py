from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime, timezone
import random

app = FastAPI(title="QuantDesk API", version="1.0.0")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

@app.get("/health")
def health():
    return {"ok": True, "mode": "paper", "timestamp": datetime.now(timezone.utc).isoformat()}

@app.get("/api/snapshot")
def snapshot(symbol: str = "NIFTY50"):
    return {
        "symbol": symbol,
        "price": round(25000 + random.uniform(-100, 100), 2),
        "action": random.choice(["BUY", "SELL", "HOLD"]),
        "quality": random.randint(80, 99),
        "regime": random.choice(["TREND", "RANGE", "VOLATILE"]),
        "paper_only": True,
        "timestamp": datetime.now(timezone.utc).isoformat()
    }
