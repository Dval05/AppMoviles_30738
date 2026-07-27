import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/contacto_provider.dart';
import '../../domain/entities/contacto.dart';

class ContactoPage extends ConsumerWidget {
  const ContactoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactos = ref.watch(contactoNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Contactos',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        elevation: 0,
      ),
      body: contactos.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: contactos.length,
              itemBuilder: (context, index) {
                final contacto = contactos[index];
                return _ContactoCard(contacto: contacto);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddContactDialog(context, ref),
        label: const Text('Nuevo Contacto'),
        icon: const Icon(Icons.person_add_rounded),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contact_page_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay contactos guardados',
            style: TextStyle(color: Colors.grey[600], fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog(BuildContext context, WidgetRef ref) {
    final nombreController = TextEditingController();
    final telefonoController = TextEditingController();
    final correoController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Agregar Contacto', textAlign: TextAlign.center),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nombreController, 'Nombre completo', Icons.person),
                const SizedBox(height: 12),
                _buildTextField(telefonoController, 'Teléfono', Icons.phone, keyboardType: TextInputType.phone),
                const SizedBox(height: 12),
                _buildTextField(correoController, 'Correo electrónico', Icons.email, keyboardType: TextInputType.emailAddress),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ref.read(contactoNotifierProvider.notifier).agregarContacto(
                      nombreController.text,
                      telefonoController.text,
                      correoController.text,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
    );
  }
}

class _ContactoCard extends ConsumerWidget {
  final Contacto contacto;

  const _ContactoCard({required this.contacto});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(
            contacto.nombre[0].toUpperCase(),
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          contacto.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 14, color: Colors.grey),
                const SizedBox(width: 8),
                Text(contacto.telefono),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.email, size: 14, color: Colors.grey),
                const SizedBox(width: 8),
                Text(contacto.correo),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () {
            if (contacto.id != null) {
              ref.read(contactoNotifierProvider.notifier).eliminarContacto(contacto.id!);
            }
          },
        ),
      ),
    );
  }
}
