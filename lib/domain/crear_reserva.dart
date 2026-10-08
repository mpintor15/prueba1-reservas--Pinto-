import 'reserva.dart';
import 'reservas_repository.dart';

class CrearReserva {
  CrearReserva(this.repositorio);

  final ReservasRepository repositorio;

  Future<ResultadoReserva> call(SolicitudReserva solicitud) async {
    if (!solicitud.fin.isAfter(solicitud.inicio)) {
      return ResultadoReserva.rechazada(
        'La hora de fin debe ser posterior a la de inicio',
      );
    }

    final reservasExistentes =
        await repositorio.reservasDeSala(solicitud.salaId);
    final tieneSolapamiento = reservasExistentes.any((reserva) =>
        solicitud.inicio.isBefore(reserva.fin) &&
        reserva.inicio.isBefore(solicitud.fin));

    if (tieneSolapamiento) {
      return ResultadoReserva.rechazada(
        'La sala ya está reservada en ese horario',
      );
    }

    final reserva = await repositorio.guardar(solicitud);
    return ResultadoReserva.aceptada(reserva);
  }
}
