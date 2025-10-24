import 'package:flutter/material.dart';
import 'package:web_clima/core/services/api_service.dart';
import 'package:web_clima/features/weather/model/daily_weather_modal.dart';
import 'package:web_clima/features/weather/model/forecast_model.dart';
import 'package:web_clima/features/weather/model/weather_model.dart';
import 'dart:math';

class WeatherViewModel extends ChangeNotifier {
  final ApiService _api;
  WeatherViewModel(this._api); // injecao de depedendicias

  bool _isLoading = false;
  String? _errorMessage;
  WeatherModel? _weather;
  List<DailyWeatherModal>? _dailyWeather;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  WeatherModel? get weather => _weather;
  List<DailyWeatherModal>? get dailyWeather => _dailyWeather;

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final weatherJson = await _api.getWeatherByCity(city);
      final forecastJson = await _api.getForecastByCity(city);

      _weather = WeatherModel.fromJson(weatherJson);

      final List<dynamic> forecastListJson = forecastJson['list'];
      final List<ForecastModel> fullForecast = forecastListJson
          .map((item) => ForecastModel.fromJson(item))
          .toList();
      _dailyWeather = _processForecast(fullForecast);
    } catch (e, s) {
      _errorMessage = e.toString();
      print('Erro no fetchWeather: $e');
      print('Stack Trace: $s');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }

  List<DailyWeatherModal> _processForecast(List<ForecastModel> fullList) {
    final Map<int, DailyWeatherModal> dailyDataMap = {};

    for (var item in fullList) {
      final int day = item.dateTime.day;

      if (!dailyDataMap.containsKey(day)) {
        dailyDataMap[day] = DailyWeatherModal(
          date: item.dateTime,
          tempMin: item.tempMin,
          tempMax: item.tempMax,
          iconCode: item.iconCode,
        );
      } else {
        final currentDaily = dailyDataMap[day]!;
        dailyDataMap[day] = DailyWeatherModal(
          date: currentDaily.date,
          iconCode: item.dateTime.hour == 12
              ? item.iconCode
              : currentDaily.iconCode,
          tempMax: max(item.tempMax, currentDaily.tempMax),
          tempMin: min(item.tempMin, currentDaily.tempMin),
        );
      }
    }
    return dailyDataMap.values.toList();
  }
}
