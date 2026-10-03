import 'package:flutter_test/flutter_test.dart';
import 'package:quantdesk/main.dart';

void main() {
  test('QuantEngine produces a valid paper signal', () {
    final s = QuantEngine().next();
    expect(['BUY', 'SELL'], contains(s.action));
    expect(s.price, greaterThan(0));
    expect(s.confidence, inInclusiveRange(0.60, 0.95));
    expect(s.quality, inInclusiveRange(80, 99));
  });
}
