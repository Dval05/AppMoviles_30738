//Inicia el sqlite INSERT, SELECT, UPDATE, DELETE
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/contacto.dart';

class ContactoLocalDatasource {
  //instancia
  final Database database;
  ContactoLocalDatasource(this.database);

  //Metodos
  //Metodo obtener contactos
  Future<List<Contacto>> obtenerContactos() async {
    final result = await database.query('contactos',
      orderBy: 'id DESC'
    );

    return result.map((map){
      return Contacto(
        id: map ['id'] as int,
        nombre: map ['nombre'] as String,
        telefono: map['telefono'] as String,
        correo: map ['correo'] as String,
      );
    }).toList();
  }

  //Metodo para insertas contactos
  Future<void> insertarContacto(Contacto contacto) async {
    await database.insert(
      'contactos',
      {
        'nombre': contacto.nombre,
        'telefono': contacto.telefono,
        'correo': contacto.correo,
      }
      );
  }

  //Metodo para actualizar contactos

  Future<void> actualizarContacto(Contacto contacto) async {
    await database.update(
      'contactos',
      {
        'nombre': contacto.nombre,
        'telefono': contacto.telefono,
        'correo': contacto.correo,
      },
      //validacion
      where: 'id = ?',
      whereArgs: [contacto.id],

      );
  }

  //Metodo de eliminar contactos

  Future<void> eliminarContacto(int id) async {
    await database.delete(
      'contactos',

      //validacion
      where: 'id = ?',
      whereArgs: [id],
      );
  }
}
