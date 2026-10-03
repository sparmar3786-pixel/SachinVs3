# QuantDesk

QuantDesk is a paper-trading Android terminal based on a six-layer signal pipeline.

## Six layers
1. Data Guard
2. Regime Detector
3. Strategy Ensemble
4. Online ML
5. Risk Guard
6. Supervisor

## Safety boundary
This build is paper-only. It does not place broker orders and does not store Angel One/NSE credentials in the APK.

## Backend
Run the FastAPI service from backend with:
python -m pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000

## Android
GitHub Actions creates the Android platform, runs Flutter tests and analysis, then builds a release APK artifact.

Live MCP/broker integration should remain server-side; secrets must never be embedded in the APK.
