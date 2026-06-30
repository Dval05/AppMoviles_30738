import '../../entities/habitacion.dart';
import '../../repositories/habitacion_repository.dart';

class AgregarHabitacionUseCase {
  AgregarHabitacionUseCase(this._repository);
  final HabitacionRepository _repository;

  Future<void> call(Habitacion habitacion) {
    if (habitacion.hosteriaId.isEmpty) {
      throw Exception('El ID de la hostería es requerido.');
    }
    if (habitacion.tipo.isEmpty) {
      throw Exception('El tipo de habitación es requerido.');
    }
    if (habitacion.capacidad <= 0) {
      throw Exception('La capacidad debe ser mayor a 0.');
    }
    if (habitacion.precioPorNoche <= 0) {
      throw Exception('El precio debe ser mayor a 0.');
    }

    return _repository.agregarHabitacion(habitacion);
  }
}
