import 'package:flutter_test/flutter_test.dart';
import 'package:spotted/models/bebida.dart';
import 'package:spotted/models/consumo.dart';
import 'package:spotted/utils/bac_calculador.dart';

/// Valida o BACCalculador contra a noite do Ricardo (populate.sql),
/// calculada à mão: 75 kg, sexo M, r = 0,68, beta = 0,15 g/L/h.
void main() {
  const caneca = Bebida(id: 2, nome: 'Caneca', categoria: 'Cerveja', volumeMl: 500, teorAlcool: 5.0);
  const agua = Bebida(id: 9, nome: 'Água', categoria: 'Sem alcool', volumeMl: 330, teorAlcool: 0.0);
  const shot = Bebida(id: 7, nome: 'Shot de tequila', categoria: 'Shot', volumeMl: 40, teorAlcool: 38.0);

  Consumo consumo(int id, String hora, Bebida bebida) =>
      Consumo(id: id, consumidoEm: DateTime.parse(hora), bebida: bebida);

  final noiteRicardo = [
    consumo(1, '2026-09-26 23:10:00', caneca),
    consumo(2, '2026-09-26 23:50:00', caneca),
    consumo(3, '2026-09-27 00:20:00', agua),
    consumo(4, '2026-09-27 00:45:00', shot),
  ];

  final ricardo = BACCalculador(pesoKg: 75, sexo: 'M', consumos: noiteRicardo);

  group('Noite do Ricardo', () {
    test('taxa antes da primeira bebida é zero', () {
      expect(ricardo.taxaEm(DateTime.parse('2026-09-26 23:00:00')), 0);
    });

    test('taxa às 23:10: 19,73 g / 51 = 0,387 g/L', () {
      expect(ricardo.taxaEm(DateTime.parse('2026-09-26 23:10:00')), closeTo(0.387, 0.001));
    });

    test('taxa às 00:45: 51,44 g / 51 - 0,15 x 1,58 h = 0,771 g/L', () {
      expect(ricardo.taxaEm(DateTime.parse('2026-09-27 00:45:00')), closeTo(0.771, 0.001));
    });

    test('fica abaixo de 0,5 g/L às 02:33', () {
      expect(ricardo.horaAbaixoDe(0.5), DateTime.parse('2026-09-27 02:33:28'));
    });

    test('série começa na primeira bebida e acaba em zero', () {
      final pontos = ricardo.serie();
      expect(pontos.first.$1, DateTime.parse('2026-09-26 23:10:00'));
      expect(pontos.last.$2, 0);
      expect(pontos.length, 82);
    });
  });

  group('Noite só com água', () {
    final soAgua = BACCalculador(
      pesoKg: 75,
      sexo: 'M',
      consumos: [consumo(1, '2026-09-26 23:10:00', agua)],
    );

    test('taxa é zero', () {
      expect(soAgua.taxaEm(DateTime.parse('2026-09-27 00:00:00')), 0);
    });

    test('não há hora abaixo do limite nem série', () {
      expect(soAgua.horaAbaixoDe(0.5), isNull);
      expect(soAgua.serie(), isEmpty);
    });
  });

  test('mulher com o mesmo peso tem taxa mais alta (r = 0,55)', () {
    final ines = BACCalculador(pesoKg: 75, sexo: 'F', consumos: noiteRicardo);
    final momento = DateTime.parse('2026-09-27 00:45:00');
    expect(ines.taxaEm(momento), greaterThan(ricardo.taxaEm(momento)));
  });
}
