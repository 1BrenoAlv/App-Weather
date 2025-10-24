import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_clima/core/services/api_service.dart';
import 'package:web_clima/features/weather/view/app_weather.dart';
import 'package:web_clima/features/weather/view_model/weather_view_model.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider(
          create: (context) => WeatherViewModel(context.read<ApiService>()),
        ),
      ],
      child: MaterialApp(
        title: 'App de Clima',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: AppWeather(),
      ),
    );
  }
}
