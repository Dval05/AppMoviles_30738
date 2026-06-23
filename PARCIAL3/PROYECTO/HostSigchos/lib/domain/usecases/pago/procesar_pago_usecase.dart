import '../../entities/pago.dart';
import '../../repositories/pago_repository.dart';
import '../../repositories/reserva_repository.dart';

/// Caso de uso: Procesar un pago
class ProcesarPagoUseCase {
  final PagoRepository _pagoRepository;
  final ReservaRepository _reservaRepository;

  ProcesarPagoUseCase(this._pagoRepository, this._reservaRepository);

  Future<Pago> call(Pago pago) async {
    final pagoProcesado = await _pagoRepository.procesarPago(pago);
    // Actualizar el estado de la reserva a 'completado'
    await _reservaRepository.actualizarEstado(pago.reservaId, 'completado');
    return pagoProcesado;
  }
}
