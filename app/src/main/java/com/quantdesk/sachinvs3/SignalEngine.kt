package com.quantdesk.sachinvs3

data class Signal(
    val action: String,
    val price: Double,
    val confidence: Int,
    val quality: Int,
    val regime: String
)

class SignalEngine(private val seed: Long = 7L) {
    private val random = java.util.Random(seed)
    private var price = 25000.0

    fun next(): Signal {
        price += (random.nextDouble() - 0.5) * 100.0
        val action = if (random.nextBoolean()) "BUY" else "SELL"
        val confidence = 60 + random.nextInt(36)
        val quality = 80 + random.nextInt(20)
        val regime = listOf("TREND", "RANGE", "VOLATILE")[random.nextInt(3)]
        return Signal(action, price, confidence, quality, regime)
    }
}
