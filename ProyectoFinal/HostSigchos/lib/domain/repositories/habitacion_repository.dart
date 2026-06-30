import '../entities/habitacion.dart';

/// Interfaz del repositorio de habitaciones
abstract class HabitacionRepository {
  /// Obtener habitaciones de una hostería
  Future<List<Habitacion>> getHabitacionesPorHosteria(String hosteriaId);

  /// Obtener todas las habitaciones
  Future<List<Habitacion>> getTodasLasHabitaciones();

  /// Obtener detalle de una habitación
  Future<Habitacion> getHabitacionById(String id);

  Future<bool> verificarDisponibilidad(
    String habitacionId,
    DateTime checkIn,
    DateTime checkOut,
    int cantidadSolicitada,
  );

  /// Agregar una nueva habitación
  Future<void> agregarHabitacion(Habitacion habitacion);

  /// Actualizar una habitación existente
  Future<void> actualizarHabitacion(Habitacion habitacion);
}
