import 'dart:convert';

class Ong {
  final String? id;
  final String? name;
  Ong({
    required this.id,
    required this.name,
  });

  factory Ong.fromJson(dynamic json) {
    return Ong(id: json['_id'] as String, name: json['nombre'] as String);
  }
}

class Campanhas {
  final String? id;
  final String? name;
  final String? descricao;
  final String? endereco;
  final Ong? ong;
  final String? dataInicio;
  final String? dataFim;

  Campanhas(
      {required this.id,
      required this.name,
      required this.descricao,
      required this.endereco,
      required this.ong,
      required this.dataInicio,
      required this.dataFim});

  factory Campanhas.fromJson(dynamic json) {
    return Campanhas(
      id: json['_id'] as String,
      name: json['nombre'] as String,
      descricao: json['descricao'] as String,
      endereco: json['endereco'] as String,
      ong: Ong.fromJson(json['ong']),
      dataInicio: json['dataInicio'] as String,
      dataFim: json['dataFinal'] as String,
    );
  }
}
