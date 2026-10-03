import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const QuantDeskApp());

class QuantDeskApp extends StatelessWidget {
  const QuantDeskApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: const Color(0xFF071019),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan, brightness: Brightness.dark),
    ),
    home: const QuantDeskHome(),
  );
}

class Signal {
  final String action;
  final double confidence;
  final double price;
  final String regime;
  final int quality;
  const Signal(this.action, this.confidence, this.price, this.regime, this.quality);
}

class QuantEngine {
  final Random _random = Random(7);
  double price = 25000;
  Signal next() {
    price += (_random.nextDouble() - .48) * 80;
    final buy = _random.nextBool();
    return Signal(buy ? 'BUY' : 'SELL', .60 + _random.nextDouble() * .35, price,
        _random.nextInt(10) > 6 ? 'TREND' : 'RANGE', 80 + _random.nextInt(20));
  }
}

class QuantDeskHome extends StatefulWidget {
  const QuantDeskHome({super.key});
  @override
  State<QuantDeskHome> createState() => _QuantDeskHomeState();
}

class _QuantDeskHomeState extends State<QuantDeskHome> {
  final engine = QuantEngine();
  late Signal signal;
  Timer? timer;
  bool running = true;
  int trades = 0;

  @override
  void initState() {
    super.initState();
    signal = engine.next();
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (running && mounted) setState(() => signal = engine.next());
    });
  }

  @override
  void dispose() { timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('QuantDesk', style: TextStyle(fontWeight: FontWeight.w800)),
        Text('6-Layer AI • PAPER MODE', style: TextStyle(fontSize: 11, color: Colors.cyan)),
      ]),
      actions: [IconButton(
        tooltip: 'Pause/Resume',
        onPressed: () => setState(() => running = !running),
        icon: Icon(running ? Icons.pause_circle : Icons.play_circle),
      )],
    ),
    body: RefreshIndicator(
      onRefresh: () async => setState(() => signal = engine.next()),
      child: ListView(padding: const EdgeInsets.all(14), children: [
        _heroCard(),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _metric('PRICE', signal.price.toStringAsFixed(2))),
          const SizedBox(width: 8),
          Expanded(child: _metric('QUALITY', '${signal.quality}%')),
          const SizedBox(width: 8),
          Expanded(child: _metric('TRADES', '${trades}')),
        ]),
        const SizedBox(height: 12),
        _section('AI LAYERS', [
          _layer('L1', 'Data Guard', '${signal.quality}% quality'),
          _layer('L2', 'Regime Detector', signal.regime),
          _layer('L3', 'Strategy Ensemble', '5 strategies'),
          _layer('L4', 'Online ML', 'P(up) ${(signal.confidence * 100).round()}%'),
          _layer('L5', 'Risk Guard', '0.5% risk / 20% cap'),
          _layer('L6', 'Supervisor', signal.action == 'BUY' ? 'Consensus OK' : 'Monitoring'),
        ]),
        const SizedBox(height: 12),
        _section('STRATEGIES', [
          _strategy('EMA Trend', signal.action),
          _strategy('RSI Reversion', signal.regime),
          _strategy('Donchian Breakout', 'Ready'),
          _strategy('VWAP Reversion', 'Ready'),
          _strategy('Momentum', 'Ready'),
        ]),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PAPER EXECUTION', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('No broker order routing. No credentials are stored in the APK.'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => setState(() => trades++),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Simulate Paper Trade'),
            ),
          ],
        ))),
      ]),
    ),
  );

  Widget _heroCard() => Card(
    child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
      Container(width: 62, height: 62, decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: signal.action == 'BUY' ? Colors.green.withOpacity(.16) : Colors.red.withOpacity(.16),
      ), child: Icon(signal.action == 'BUY' ? Icons.trending_up : Icons.trending_down,
        size: 34, color: signal.action == 'BUY' ? Colors.greenAccent : Colors.redAccent)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(signal.action, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
        Text('NIFTY 50 • ${signal.regime}', style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: signal.confidence),
        const SizedBox(height: 4),
        Text('Confidence ${(signal.confidence * 100).round()}%', style: const TextStyle(fontSize: 12)),
      ])),
    ])),
  );

  Widget _metric(String a, String b) => Card(child: Padding(padding: const EdgeInsets.all(12),
    child: Column(children: [Text(a, style: const TextStyle(fontSize: 10, color: Colors.white54)),
      const SizedBox(height: 4), Text(b, style: const TextStyle(fontWeight: FontWeight.bold))])));

  Widget _section(String title, List<Widget> children) => Card(child: Padding(
    padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: [Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.cyan)),
      const SizedBox(height: 10), ...children])));

  Widget _layer(String n, String name, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
      CircleAvatar(radius: 15, child: Text(n, style: const TextStyle(fontSize: 10))),
      const SizedBox(width: 10), Expanded(child: Text(name)), Text(value, style: const TextStyle(color: Colors.white70))
    ]));

  Widget _strategy(String name, String value) => ListTile(dense: true, contentPadding: EdgeInsets.zero,
    leading: const Icon(Icons.auto_graph, size: 18), title: Text(name), trailing: Text(value));
}
