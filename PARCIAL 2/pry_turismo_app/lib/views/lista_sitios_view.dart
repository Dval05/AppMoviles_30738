import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/turismo_viewmodel.dart';

class ListaSitiosView extends StatelessWidget {
  const ListaSitiosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TurismoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.cargando) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          return Center(child: Text('Error: ${viewModel.error}'));
        }

        return ListView.builder(
          itemCount: viewModel.sitios.length,
          itemBuilder: (context, index) {
            final sitio = viewModel.sitios[index];
            final distancia = viewModel.obtenerDistancia(sitio);

            return Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    sitio.imagenUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                  ),
                ),
                title: Text(sitio.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sitio.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.teal),
                        Text(viewModel.formatearDistancia(distancia)),
                      ],
                    ),
                  ],
                ),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}
