import '../../entities/habitacion.dart';
import '../../repositories/habitacion_repository.dart';

class ActualizarHabitacionUseCase {
  ActualizarHabitacionUseCase(this._repository);
  final HabitacionRepository _repository;

  Future<void> call(Habitacion habitacion) {
    if (habitacion.id.isEmpty) {
      throw Exception('El ID de la habitación es requerido para actualizar.');
    }
    return _repository.actualizarHabitacion(habitacion);
  }
}
