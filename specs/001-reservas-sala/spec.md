# Feature Specification: Reservas de sala

**Feature Branch**: `001-reservas-sala`
**Created**: 2026-10-01
**Status**: Draft

## User Scenarios & Testing

### User Story 1 — Reservar una sala (Priority: P1)

Como estudiante autenticado, quiero reservar una sala de estudio por un intervalo de tiempo
para tener dónde trabajar con mi grupo.

**Why this priority**: sin reservas, la app no tiene propósito.

**Independent Test**: se puede probar creando una reserva y comprobando que queda registrada.

**Acceptance Scenarios**:

1. **Dado** que la sala A está libre, **Cuando** la reservo de 09:00 a 10:00, **Entonces** la
   reserva queda registrada a mi nombre.
2. **Dado** que elijo como inicio las 10:00 y como fin las 09:00, **Cuando** intento reservar,
   **Entonces** la reserva se rechaza con el mensaje "La hora de fin debe ser posterior a la de inicio".

### User Story 2 — Evitar reservas simultáneas de una sala (Priority: P1)

Como estudiante autenticado, quiero que el sistema rechace una reserva que se solapa con otra de
la misma sala, para que dos estudiantes no reserven esa sala al mismo tiempo.

**Why this priority**: una sala no puede estar asignada a más de una persona durante el mismo
intervalo.

**Independent Test**: registrar una reserva y solicitar otra para la misma sala en intervalos
que se cruzan; comprobar que la segunda se rechaza y no queda registrada.

**Acceptance Scenarios**:

3. **Dado** que Sala A está reservada de 09:00 a 10:00, **Cuando** solicito Sala A de 09:30 a
   10:30, **Entonces** la solicitud se rechaza con el mensaje "La sala ya está reservada en ese
   horario" y no queda registrada.
4. **Dado** que Sala A está reservada de 09:00 a 10:00, **Cuando** solicito Sala A de 08:30 a
   09:30, **Entonces** la solicitud se rechaza con el mensaje "La sala ya está reservada en ese
   horario" y no queda registrada.
5. **Dado** que Sala A está reservada de 09:00 a 10:00, **Cuando** solicito Sala A de 08:00 a
   11:00, **Entonces** la solicitud se rechaza con el mensaje "La sala ya está reservada en ese
   horario" y no queda registrada.
6. **Dado** que Sala A está reservada de 09:00 a 10:00, **Cuando** solicito Sala A de 10:00 a
   11:00, **Entonces** la solicitud se acepta porque empieza cuando termina la reserva existente.
7. **Dado** que Sala A está reservada de 09:00 a 10:00, **Cuando** solicito Sala B de 09:00 a
   10:00, **Entonces** la solicitud se acepta porque corresponde a otra sala.

### Edge Cases

- Una reserva se rechaza si comparte algún instante con otra reserva de la misma sala.
- La hora de fin de una reserva no forma parte de su intervalo: una reserva puede empezar
  justo cuando termina otra.
- Las reservas de salas distintas no entran en conflicto aunque coincidan en el tiempo.

## Requirements

### Functional Requirements

- **FR-001**: El estudiante elige una sala, una hora de inicio y una hora de fin.
- **FR-002**: La hora de fin debe ser posterior a la hora de inicio.
- **FR-003**: La reserva aceptada queda asociada al estudiante que la solicita.
- **FR-004**: Una reserva se rechaza cuando su intervalo comparte algún instante con el de otra
  reserva de la misma sala.
- **FR-005**: Dos reservas de la misma sala pueden ser consecutivas cuando la hora de inicio de
  una coincide con la hora de fin de la otra.
- **FR-006**: Las reservas de salas distintas no se consideran en conflicto por coincidir en el
  tiempo.

### Key Entities

- **Reserva**: sala, estudiante, inicio y fin.
- **Sala**: identificada por su nombre (Sala A, Sala B, Sala C).

## Success Criteria

- **SC-001**: Un estudiante completa una reserva en menos de 30 segundos.
