class WeatherModel {
  final String cityName;
  final double temperatura;
  final String descricao;
  final String iconCode;
  final int umidade;
  final double velocVento;

  WeatherModel({
    required this.cityName,
    required this.descricao,
    required this.iconCode,
    required this.temperatura,
    required this.umidade,
    required this.velocVento,
  });

  // weather_model.dart

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // 1. Extrai os sub-objetos com segurança
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weather = weatherList.isNotEmpty
        ? weatherList[0] as Map<String, dynamic>? ?? {}
        : {};
    final wind = json['wind'] as Map<String, dynamic>? ?? {};

    // 2. Retorna o modelo com valores padrão para tudo
    return WeatherModel(
      cityName: json['name'] ?? 'Cidade Desconhecida',
      descricao: weather['description'] ?? 'Sem descrição',
      iconCode: weather['icon'] ?? '01d', // '01d' é um ícone padrão (sol)
      temperatura: (main['temp'] as num? ?? 0.0).toDouble(),
      umidade: main['humidity'] ?? 0,
      velocVento: (wind['speed'] as num? ?? 0.0).toDouble(),
    );
  }

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/$iconCode@4x.png';
  }

  double get windSpeedKmH {
    return velocVento * 3.6;
  }
}
