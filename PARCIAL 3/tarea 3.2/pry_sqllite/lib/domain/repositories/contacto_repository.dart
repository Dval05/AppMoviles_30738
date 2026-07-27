//3. Aqui uniucamente se define que operacion existe
// Agregar, elmimar, actualizar, consultar
import '../entities/contacto.dart';

abstract class ContactoRepository {
  //Metodos

  Future<void> agregarContacto(Contacto contacto);
  Future<void> eliminarContacto(int id);
  Future<void> actualizarContacto(Contacto contacto);
  Future<List<Contacto>> obtenerContactos();
}