import 'package:intl/intl.dart';

class DailyWeatherModal {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String iconCode;

  DailyWeatherModal({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.iconCode,
  });

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  String get dayOfWeek {
    return DateFormat('EEEE', 'pt_BR').format(date);
  }
}
