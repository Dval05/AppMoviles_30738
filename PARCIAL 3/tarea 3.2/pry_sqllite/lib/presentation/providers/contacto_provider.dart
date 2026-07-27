// provides StateNotifer StateNOtifierProvider => Controlar estado
import 'package:flutter_riverpod/legacy.dart';
import 'package:sqflite/sqflite.dart';
import 'package:riverpod/riverpod.dart';
import '../../application/usecases/contacto_usecases.dart';
import '../../data/datasources/contacto_local_datasource.dart';
import '../../data/repositories/contacto_repository_impl.dart';
import '../../domain/entities/contacto.dart';
import '../../domain/repositories/contacto_repository.dart';

final databaseProvider = Provider<Database>((ref) {
    throw UnimplementedError('La base de datos se inicia');
});

final contactoLocalDatasourceProvider = Provider<ContactoLocalDatasource> ((ref){
    final database = ref.watch(databaseProvider);
    return ContactoLocalDatasource(database);
});

final contactoRepositoryProvider = Provider<ContactoRepository> ((ref){
    final dataSource = ref.watch(contactoLocalDatasourceProvider);
    return ContactoRepositoryImpl(dataSource);
});

final contactoUseCaseProvider = Provider<ContactoUsecases> ((ref){
    final repository = ref.watch(contactoRepositoryProvider);
    return ContactoUsecases(repository);
});

//Manejar el estado
class ContactoNotifier extends StateNotifier<List<Contacto>> {
    final ContactoUsecases usecases;

    ContactoNotifier(this.usecases) : super([]) {
        cargarContactos();
    }

    //metodos
    Future<void> cargarContactos() async {
        state = await usecases.listar();
    }

    //agregar
    Future<void> agregarContacto(
        String nombre,
        String telefono,
        String correo,
        ) async {
        final contacto = Contacto(
            nombre: nombre,
            telefono: telefono,
            correo: correo,
            id: null,
        );

        await usecases.agregarContacto(contacto);
        await cargarContactos();
    }

    //eliminar
    Future<void> eliminarContacto(int id) async {
        await usecases.eliminarContacto(id);
        await cargarContactos();
    }
}

//Manejo de estado
final contactoNotifierProvider =
StateNotifierProvider<ContactoNotifier, List<Contacto>>((ref) {
    final useCase = ref.watch(contactoUseCaseProvider);
    return ContactoNotifier(useCase);
});