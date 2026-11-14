class Utilizador {
  final String nome;
  final String email;
  final double? pesokg;
  final String? sexo;
  final DateTime dataNascimento;

  const Utilizador(
      {required this.nome,
      required this.email,
      required this.pesokg,
      required this.sexo,
      required this.dataNascimento});

  factory Utilizador.fromJson(Map<String, dynamic> json) => Utilizador(
        nome: json["nome"] as String,
        email: json["email"] as String,
        pesokg: (json["pesoKg"] as num?)?.toDouble(),
        sexo: json["sexo"] as String?,
        dataNascimento: DateTime.parse(json["dataNascimento"] as String),
      );
}
