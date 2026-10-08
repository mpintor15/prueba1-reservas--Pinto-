## Escenarios que elegí y por qué

Elegí cruces parciales en ambos sentidos y una solicitud que contiene una reserva existente para cubrir distintos extremos del solapamiento (`specs/001-reservas-sala/spec.md:38-46`). Añadí los casos de horarios contiguos y de otra sala para fijar los límites de la regla
(`specs/001-reservas-sala/spec.md:47-50`). Las pruebas también cubren una solicitud contenida y un intervalo idéntico (`test/crear_reserva_test.dart:91-100`). El caso de uso aplica la regla con comparaciones estrictas de inicio y fin (`lib/domain/crear_reserva.dart:18-20`).

## Riesgo más grave del repositorio

La versión inicial tenía una clave literal con rol `service_role` (`lib/data/supabase_config.dart:3-4`, versión inicial). La configuración actual recibe una clave publishable al compilar (`lib/data/supabase_config.dart:1-3`) y el README prohíbe poner claves privilegiadas en Flutter y pide desactivar cualquier clave real expuesta (`README.md:19-23`). Las políticas actuales limitan la lectura a columnas necesarias para disponibilidad y verifican que `usuario_id` coincida con `auth.uid()` al insertar (`supabase/migracion.sql:16-30`).

## ¿La regla protege la app real?

La pantalla ahora envía la solicitud a `CrearReserva` (`lib/presentation/reserva_page.dart:67-77`), que consulta las reservas existentes y rechaza solapamientos (`lib/domain/crear_reserva.dart:14-25`). La migración aún no define una restricción de solapamiento en la base de datos (`supabase/migracion.sql:4-12`), así que una inserción directa podría evitar la regla del dominio. Además, falta el flujo de inicio de sesión y RLS rechazará escrituras hasta implementarlo (`README.md:32-34`).
