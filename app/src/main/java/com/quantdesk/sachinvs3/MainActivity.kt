package com.quantdesk.sachinvs3

import android.app.Activity
import android.graphics.Color
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import java.util.Locale

class MainActivity : Activity() {
    private val engine = SignalEngine()
    private val handler = Handler(Looper.getMainLooper())
    private lateinit var signalText: TextView
    private lateinit var metricsText: TextView
    private lateinit var statusText: TextView
    private var trades = 0
    private var running = true

    private val ticker = object : Runnable {
        override fun run() {
            if (running) renderSignal(engine.next())
            handler.postDelayed(this, 2000)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(buildScreen())
        renderSignal(engine.next())
        handler.postDelayed(ticker, 2000)
    }

    override fun onDestroy() {
        handler.removeCallbacks(ticker)
        super.onDestroy()
    }

    private fun buildScreen(): LinearLayout {
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(28, 24, 28, 24)
            setBackgroundColor(Color.rgb(11, 13, 18))
        }

        fun label(text: String, size: Float = 14f): TextView = TextView(this).apply {
            this.text = text
            textSize = size
            setTextColor(Color.LTGRAY)
            setPadding(0, 8, 0, 8)
        }

        val title = label("SACHIN VS3 • QUANTDESK", 22f)
        title.setTextColor(Color.WHITE)
        root.addView(title)

        statusText = label("PAPER MODE • No broker order routing", 13f)
        root.addView(statusText)

        signalText = label("Loading signal…", 30f)
        signalText.gravity = Gravity.CENTER
        signalText.setPadding(0, 36, 0, 36)
        root.addView(signalText, LinearLayout.LayoutParams(-1, -2))

        metricsText = label("", 16f)
        root.addView(metricsText)

        root.addView(label("AI LAYERS", 17f))
        root.addView(label("L1 Data Guard  •  L2 Regime  •  L3 Strategy Ensemble\nL4 Online ML  •  L5 Risk Guard  •  L6 Supervisor", 14f))

        root.addView(label("STRATEGIES", 17f))
        root.addView(label("EMA Trend  •  RSI Reversion  •  Donchian Breakout\nVWAP Reversion  •  Momentum", 14f))

        val controls = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER
        }
        val refresh = Button(this).apply {
            text = "REFRESH"
            setOnClickListener { renderSignal(engine.next()) }
        }
        val pause = Button(this).apply {
            text = "PAUSE"
            setOnClickListener {
                running = !running
                text = if (running) "PAUSE" else "RESUME"
                statusText.text = if (running) "PAPER MODE • Auto refresh 2s" else "PAPER MODE • Paused"
            }
        }
        controls.addView(refresh, LinearLayout.LayoutParams(0, -2, 1f))
        controls.addView(pause, LinearLayout.LayoutParams(0, -2, 1f))
        root.addView(controls)

        return root
    }

    private fun renderSignal(signal: Signal) {
        trades++
        signalText.text = String.format(Locale.US, "%s  %.2f", signal.action, signal.price)
        signalText.setTextColor(if (signal.action == "BUY") Color.rgb(76, 220, 130) else Color.rgb(255, 105, 105))
        metricsText.text = String.format(
            Locale.US,
            "Confidence %d%%   •   Quality %d   •   Regime %s   •   Paper trades %d",
            signal.confidence, signal.quality, signal.regime, trades
        )
        statusText.text = "PAPER MODE • Auto refresh 2s • Native Kotlin"
    }
}
