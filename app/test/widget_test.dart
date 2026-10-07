import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spotted/views/widgets/register_widget.dart';

void main() {
  testWidgets('Ecrã de registo mostra o botão Submeter', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterSpotted()));

    expect(find.text('Submeter'), findsOneWidget);
  });
}
