import 'package:flutter_test/flutter_test.dart';
import 'package:reservas_sala/domain/crear_reserva.dart';
import 'package:reservas_sala/domain/reserva.dart';

import 'support/reservas_en_memoria.dart';

DateTime hora(int h, [int m = 0]) => DateTime(2026, 10, 14, h, m);

void main() {
  late ReservasEnMemoria repositorio;
  late CrearReserva crearReserva;

  setUp(() {
    repositorio = ReservasEnMemoria();
    crearReserva = CrearReserva(repositorio);
  });

  Future<void> registrarExistente({
    String salaId = 'Sala A',
    required DateTime inicio,
    required DateTime fin,
  }) async {
    await repositorio.guardar(SolicitudReserva(
      salaId: salaId,
      usuarioId: 'u2',
      inicio: inicio,
      fin: fin,
    ));
  }

  Future<void> esperarRechazoPorSolapamiento({
    String salaId = 'Sala A',
    required DateTime inicio,
    required DateTime fin,
  }) async {
    final resultado = await crearReserva(SolicitudReserva(
      salaId: salaId,
      usuarioId: 'u1',
      inicio: inicio,
      fin: fin,
    ));

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La sala ya está reservada en ese horario');
    expect(repositorio.reservas, hasLength(1));
  }

  test('acepta una reserva válida y la guarda', () async {
    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(9),
      fin: hora(10),
    ));

    expect(resultado.aceptada, isTrue);
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza una reserva cuyo fin no es posterior al inicio', () async {
    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(10),
      fin: hora(9),
    ));

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La hora de fin debe ser posterior a la de inicio');
    expect(repositorio.reservas, isEmpty);
  });

  test('rechaza el solapamiento parcial que empieza dentro de otra reserva', () async {
    await registrarExistente(inicio: hora(9), fin: hora(10));

    await esperarRechazoPorSolapamiento(inicio: hora(9, 30), fin: hora(10, 30));
  });

  test('rechaza el solapamiento parcial que termina dentro de otra reserva', () async {
    await registrarExistente(inicio: hora(9), fin: hora(10));

    await esperarRechazoPorSolapamiento(inicio: hora(8, 30), fin: hora(9, 30));
  });

  test('rechaza una solicitud que contiene una reserva existente', () async {
    await registrarExistente(inicio: hora(9), fin: hora(10));

    await esperarRechazoPorSolapamiento(inicio: hora(8), fin: hora(11));
  });

  test('rechaza una solicitud contenida en una reserva existente', () async {
    await registrarExistente(inicio: hora(9), fin: hora(10));

    await esperarRechazoPorSolapamiento(inicio: hora(9, 15), fin: hora(9, 45));
  });

  test('rechaza una solicitud con el mismo intervalo que otra reserva', () async {
    await registrarExistente(inicio: hora(9), fin: hora(10));

    await esperarRechazoPorSolapamiento(inicio: hora(9), fin: hora(10));
  });

  test('acepta una reserva que empieza cuando termina la anterior', () async {
    await registrarExistente(inicio: hora(9), fin: hora(10));

    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(10),
      fin: hora(11),
    ));

    expect(resultado.aceptada, isTrue);
    expect(repositorio.reservas, hasLength(2));
  });

  test('acepta el mismo horario para una sala distinta', () async {
    await registrarExistente(inicio: hora(9), fin: hora(10));

    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala B',
      usuarioId: 'u1',
      inicio: hora(9),
      fin: hora(10),
    ));

    expect(resultado.aceptada, isTrue);
    expect(repositorio.reservas, hasLength(2));
  });
}
