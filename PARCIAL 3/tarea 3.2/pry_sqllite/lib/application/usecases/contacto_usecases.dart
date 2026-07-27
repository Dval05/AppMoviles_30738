import '../../domain/entities/contacto.dart';
import '../../domain/repositories/contacto_repository.dart';

class ContactoUsecases {
  
  //Inyectar
  final ContactoRepository repository;

  ContactoUsecases(this.repository);

  //Implementar metodos de contacto repository

  Future<List<Contacto>> listar() {
    return repository.obtenerContactos();
  }

  //Agregar
  Future<void> agregarContacto(Contacto contacto) {
    return repository.agregarContacto(contacto);
  }

  Future<void> actualizarContacto(Contacto contacto) {
    return repository.actualizarContacto(contacto);
  }

  
  Future<void> eliminarContacto(int id) {
    return repository.eliminarContacto(id);
  }
}
