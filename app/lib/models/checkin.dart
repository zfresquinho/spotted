class Checkin {
  final int idcheckin;
  final int idspot;
  final DateTime feitoem;
  final DateTime? terminadoem;
  final String metodo;
  final String? spotNome;

  const Checkin({
    required this.idcheckin,
    required this.idspot,
    required this.feitoem,
    this.terminadoem,
    required this.metodo,
    this.spotNome,
  });

  factory Checkin.fromJson(Map<String, dynamic> json) => Checkin(
        idcheckin: json['id_checkin'] as int,
        idspot: json['id_spot'] as int,
        feitoem: DateTime.parse(json['feito_em'] as String),
        terminadoem: json['terminado_em'] != null
            ? DateTime.parse(json['terminado_em'] as String)
            : null,
        metodo: json['metodo'] as String,
        spotNome: json['spot_nome'] as String?,
      );
}
