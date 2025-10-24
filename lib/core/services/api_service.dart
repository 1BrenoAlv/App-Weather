import 'package:dio/dio.dart';

class ApiService {
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5'; // URL DA API
  static const String _keyApi =
      '8cc2686bb8c1883a7222669028712a97'; // KEY DE ACESSO DA API

  final Dio _dio = Dio(
    BaseOptions(baseUrl: _baseUrl),
  ); // CONFIGURAR A URL DA API

  Future<Map<String, dynamic>> getWeatherByCity(String city) async {
    // BUSCA A TEMPERATURA PELA CIDADE
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {
          'q': city,
          'appid': _keyApi,
          'units': 'metric', // CONVERTE PARA CELSIUS
          'lang': 'pt_br',
        },
      );
      return response.data;
    } on DioException catch (e) {
      print('Erro ao buscar clima $e');

      String errorMessage = 'Falha ao buscar dados do clima';

      if (e.response?.statusCode == 401) {
        errorMessage = 'Chave da API inválida!';
      } else if (e.response?.statusCode == 404) {
        errorMessage = 'Cidade não encontrada!';
      }

      throw ArgumentError(errorMessage);
    } catch (e) {
      print('Erro inesperado: $e');
      throw ArgumentError('Ocorreu um erro inesperado!');
    }
  }

  Future<Map<String, dynamic>> getForecastByCity(String city) async {
    // BUSCA PELOS PROXIMOS 5 DIAS
    try {
      final response = await _dio.get(
        '/forecast',
        queryParameters: {
          'q': city,
          'appid': _keyApi,
          'units': 'metric', // CONVERTE PARA CELSIUS
          'lang': 'pt_br',
        },
      );
      return response.data;
    } on DioException catch (e) {
      print('Erro ao buscar previsão: $e');

      String errorMessage = 'Falha ao buscar dados da previsão';

      if (e.response?.statusCode == 404) {
        errorMessage = 'Cidade não encontrada!';
      }

      throw ArgumentError(errorMessage);
    } catch (e) {
      print('Erro inesperado: $e');
      throw ArgumentError('Ocorreu um erro inesperado!');
    }
  }
}
