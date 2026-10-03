package com.quantdesk.sachinvs3

import org.junit.Assert.assertTrue
import org.junit.Test

class SignalEngineTest {
    @Test
    fun nextSignalHasValidTradingBounds() {
        val signal = SignalEngine().next()
        assertTrue(signal.action == "BUY" || signal.action == "SELL")
        assertTrue(signal.price > 0.0)
        assertTrue(signal.confidence in 60..95)
        assertTrue(signal.quality in 80..99)
        assertTrue(signal.regime in listOf("TREND", "RANGE", "VOLATILE"))
    }
}
