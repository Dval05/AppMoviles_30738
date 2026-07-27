//Implementar el contato repository
//usar el SQLLite

import '../../domain/entities/contacto.dart';
import '../../domain/repositories/contacto_repository.dart';
import '../datasources/contacto_local_datasource.dart';

//clase que implementa el repositorio

class ContactoRepositoryImpl implements ContactoRepository {
  //Instanciacion
  ContactoLocalDatasource contactoLocalDatasource;
  ContactoRepositoryImpl(this.contactoLocalDatasource);

  @override
  Future<void> actualizarContacto(Contacto contacto) {
    return contactoLocalDatasource.actualizarContacto(contacto);
  }

  @override
  Future<void> agregarContacto(Contacto contacto) {
    return contactoLocalDatasource.insertarContacto(contacto);
  }

  @override
  Future<void> eliminarContacto(int id) {
    return contactoLocalDatasource.eliminarContacto(id);
  }

  @override
  Future<List<Contacto>> obtenerContactos() {
    return contactoLocalDatasource.obtenerContactos();
  }
}