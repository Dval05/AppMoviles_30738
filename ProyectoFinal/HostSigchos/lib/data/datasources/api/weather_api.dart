import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/errors/failures.dart';

class WeatherApi {
  // Sigchos location using wttr.in API
  static const String _baseUrl = 'https://wttr.in/Sigchos?format=j1';

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl)).timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current_condition'][0];
        return {
          'temperature': double.tryParse(current['temp_C'].toString()) ?? 0.0,
          'weathercode': int.tryParse(current['weatherCode'].toString()) ?? 0,
        };
      } else {
        throw const ServerFailure('Error al obtener el clima de Sigchos');
      }
    } catch (e) {
      throw const ServerFailure('No se pudo conectar al servidor de clima');
    }
  }
}
