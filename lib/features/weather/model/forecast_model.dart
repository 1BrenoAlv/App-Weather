class ForecastModel {
  final DateTime dateTime;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String iconCode;

  ForecastModel({
    required this.dateTime,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.iconCode,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      dateTime: DateTime.parse(json['dt_txt']),
      temp: (json['main']['temp'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      iconCode: json['weather'][0]['icon'],
    );
  }

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/$iconCode@x.png';
  }
}
