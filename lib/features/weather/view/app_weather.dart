import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_clima/features/weather/model/daily_weather_modal.dart';
import 'package:web_clima/features/weather/model/weather_model.dart';
import 'package:web_clima/features/weather/view_model/weather_view_model.dart';

class AppWeather extends StatefulWidget {
  const AppWeather({super.key});

  @override
  State<AppWeather> createState() => _AppWeatherState();
}

class _AppWeatherState extends State<AppWeather> {
  final TextEditingController _cityController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().fetchWeather("São Paulo");
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _searchWeather() {
    if (_cityController.text.isNotEmpty) {
      context.read<WeatherViewModel>().fetchWeather(_cityController.text);
      _cityController.clear(); // Limpa o campo após a busca
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeatherViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.weather?.cityName ?? 'App de Clima'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'Digite uma cidade',
                      labelStyle: TextStyle(color: (Colors.white)),
                      hintText: 'Ex: Rio de Janeiro',
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),

                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _searchWeather(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchWeather,
                  iconSize: 30,
                  tooltip: 'Buscar',
                ),
              ],
            ),
          ),
          Expanded(child: Center(child: _buildBody(viewModel))),
        ],
      ),
    );
  }

  Widget _buildBody(WeatherViewModel viewModel) {
    if (viewModel.isLoading) {
      return const CircularProgressIndicator();
    }

    if (viewModel.errorMessage != null) {
      return Text(
        'Erro ao buscar dados:\n${viewModel.errorMessage}',
        style: const TextStyle(
          color: Color.fromARGB(255, 228, 48, 35),
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      );
    }
    if (viewModel.weather != null && viewModel.dailyWeather != null) {
      return ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCurrentWeather(viewModel.weather!),
          const SizedBox(height: 24),
          _buildDailyForecast(viewModel.dailyWeather!),
        ],
      );
    }

    return const Text('Buscando informações do clima...');
  }

  Widget _buildCurrentWeather(WeatherModel weather) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              weather.cityName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${weather.temperatura.toStringAsFixed(0)}°C',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(weather.iconUrl, width: 60, height: 60),
                const SizedBox(width: 8),
                Text(
                  weather.descricao,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Umidade: ${weather.umidade}%'),
                Text('Vento: ${weather.windSpeedKmH.toStringAsFixed(1)} km/h'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyForecast(List<DailyWeatherModal> dailyList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Próximos 5 dias',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        ...dailyList.map((day) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Image.network(day.iconUrl, width: 50, height: 50),
              title: Text(day.dayOfWeek),
              subtitle: Text('${day.date.day}/${day.date.month}'),
              trailing: Text(
                '${day.tempMin.toStringAsFixed(0)}° / ${day.tempMax.toStringAsFixed(0)}°',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
