import 'package:flutter/material.dart';

import '../../../themes/esquema_color.dart';
import '../../routes/app_routes.dart';

class ChatbotSuggestionsScreen extends StatelessWidget {
  const ChatbotSuggestionsScreen({required this.suggestions, super.key});

  final List<dynamic> suggestions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugerencias del Chatbot'),
        backgroundColor: ColorSchemeApp.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: suggestions.isEmpty
          ? const Center(child: Text('No hay sugerencias disponibles.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final hotelSuggestion = suggestions[index] as Map<String, dynamic>;
                final String hotelName = hotelSuggestion['hosteriaNombre'] ?? 'Hotel Desconocido';
                final String hosteriaId = hotelSuggestion['hosteriaId'] ?? '';
                final List<dynamic> habitaciones = hotelSuggestion['habitaciones'] ?? [];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotelName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorSchemeApp.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Habitaciones Sugeridas:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...habitaciones.map((h) {
                          final hab = h as Map<String, dynamic>;
                          final String tipo = hab['tipo'] ?? 'Habitación';
                          final double precio = (hab['precio'] as num?)?.toDouble() ?? 0.0;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.bed, color: ColorSchemeApp.primaryGreen),
                            title: Text(tipo),
                            trailing: Text(
                              '\$${precio.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: ColorSchemeApp.goldenAccent,
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (hosteriaId.isNotEmpty) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.habitaciones,
                                  arguments: hosteriaId,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorSchemeApp.primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Ver Habitaciones en este Hotel'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
