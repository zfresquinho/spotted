class Bebida {
  final int id;
  final String nome;
  final String categoria;
  final int volumeMl;
  final double teorAlcool;

  const Bebida({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.volumeMl,
    required this.teorAlcool,
  });

  factory Bebida.fromJson(Map<String, dynamic> json) => Bebida(
        id: json["id"] as int,
        nome: json["nome"] as String,
        categoria: json["categoria"] as String,
        volumeMl: json["volumeMl"] as int,
        teorAlcool: (json["teorAlcool"] as num).toDouble(),
      );

  double get gramasAlcool => volumeMl * teorAlcool / 100 * 0.789;
}
