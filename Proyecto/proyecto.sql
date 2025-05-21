DROP DATABASE IF EXISTS gestion_academica;
CREATE DATABASE gestion_academica;
USE gestion_academica;

-- =============================================
-- ESTRUCTURA DE TABLAS (DDL)
-- =============================================

-- Tabla Persona
CREATE TABLE persona (
    id_persona INT AUTO_INCREMENT PRIMARY KEY,
    cedula VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE,
    genero ENUM('M', 'F', 'O'),
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla Rol
CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT
);

-- Tabla Usuario
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    ultimo_login DATETIME,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);

-- Tabla Permiso
CREATE TABLE permiso (
    id_permiso INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT
);

-- Tabla Rol_Permiso
CREATE TABLE rol_permiso (
    id_rol INT NOT NULL,
    id_permiso INT NOT NULL,
    PRIMARY KEY (id_rol, id_permiso),
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol),
    FOREIGN KEY (id_permiso) REFERENCES permiso(id_permiso)
);

-- Tabla Usuario_Rol
CREATE TABLE usuario_rol (
    id_usuario INT NOT NULL,
    id_rol INT NOT NULL,
    fecha_asignacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_rol),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);

-- Tabla Estudiante
CREATE TABLE estudiante (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT UNIQUE NOT NULL,
    codigo_estudiante VARCHAR(20) UNIQUE NOT NULL,
    fecha_ingreso DATE NOT NULL,
    estado ENUM('ACTIVO', 'INACTIVO', 'GRADUADO', 'RETIRADO') DEFAULT 'ACTIVO',
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);

-- Tabla Profesor
CREATE TABLE profesor (
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT UNIQUE NOT NULL,
    codigo_profesor VARCHAR(20) UNIQUE NOT NULL,
    especialidad VARCHAR(100),
    fecha_contratacion DATE,
    tipo_contrato ENUM('TIEMPO_COMPLETO', 'MEDIO_TIEMPO', 'CATEDRA'),
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);

-- Tabla Departamento
CREATE TABLE departamento (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    id_director INT,
    fecha_creacion DATE,
    FOREIGN KEY (id_director) REFERENCES profesor(id_profesor)
);

-- Tabla Carrera
CREATE TABLE carrera (
    id_carrera INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    id_departamento INT NOT NULL,
    duracion_semestres INT,
    creditos_totales INT,
    estado ENUM('ACTIVA', 'INACTIVA') DEFAULT 'ACTIVA',
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

-- Tabla Materia
CREATE TABLE materia (
    id_materia INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) UNIQUE NOT NULL,
    creditos INT NOT NULL,
    horas_teoria INT,
    horas_practica INT,
    id_departamento INT NOT NULL,
    prerequisitos TEXT,
    corequisitos TEXT,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

-- Tabla Periodo Academico
CREATE TABLE periodo_academico (
    id_periodo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado ENUM('PLANIFICACION', 'EN_CURSO', 'FINALIZADO', 'CERRADO') DEFAULT 'PLANIFICACION',
    UNIQUE KEY (nombre, fecha_inicio)
);

-- Tabla Grupo
CREATE TABLE grupo (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,
    id_materia INT NOT NULL,
    id_profesor INT NOT NULL,
    id_periodo INT NOT NULL,
    codigo_grupo VARCHAR(10) NOT NULL,
    cupo_maximo INT,
    horario TEXT,
    aula VARCHAR(20),
    UNIQUE KEY (id_materia, id_periodo, codigo_grupo),
    FOREIGN KEY (id_materia) REFERENCES materia(id_materia),
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY (id_periodo) REFERENCES periodo_academico(id_periodo)
);

-- Tabla Matricula
CREATE TABLE matricula (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_periodo INT NOT NULL,
    fecha_matricula DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('PENDIENTE', 'COMPLETADA', 'ANULADA') DEFAULT 'PENDIENTE',
    total_creditos INT,
    UNIQUE KEY (id_estudiante, id_periodo),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante),
    FOREIGN KEY (id_periodo) REFERENCES periodo_academico(id_periodo)
);

-- Tabla Detalle_Matricula
CREATE TABLE detalle_matricula (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_matricula INT NOT NULL,
    id_grupo INT NOT NULL,
    calificacion DECIMAL(3,1),
    estado ENUM('CURSANDO', 'APROBADO', 'REPROBADO', 'RETIRADO') DEFAULT 'CURSANDO',
    UNIQUE KEY (id_matricula, id_grupo),
    FOREIGN KEY (id_matricula) REFERENCES matricula(id_matricula),
    FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo)
);

-- Tabla Asistencia
CREATE TABLE asistencia (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    id_detalle_matricula INT NOT NULL,
    fecha DATE NOT NULL,
    estado ENUM('PRESENTE', 'AUSENTE', 'JUSTIFICADO', 'TARDANZA') NOT NULL,
    observaciones TEXT,
    UNIQUE KEY (id_detalle_matricula, fecha),
    FOREIGN KEY (id_detalle_matricula) REFERENCES detalle_matricula(id_detalle)
);

-- Tabla Justificacion
CREATE TABLE justificacion (
    id_justificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_asistencia INT UNIQUE NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_solicitud DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_revision DATETIME,
    id_revisor INT,
    estado ENUM('PENDIENTE', 'APROBADA', 'RECHAZADA') DEFAULT 'PENDIENTE',
    documentos_adjuntos TEXT,
    FOREIGN KEY (id_asistencia) REFERENCES asistencia(id_asistencia),
    FOREIGN KEY (id_revisor) REFERENCES usuario(id_usuario)
);

-- =============================================
-- INSERCIÓN DE DATOS (DML)
-- =============================================

-- 1. Insertar roles del sistema
INSERT INTO rol (nombre, descripcion) VALUES
('ADMINISTRADOR', 'Acceso completo al sistema'),
('COORDINADOR', 'Coordinador académico de departamento'),
('PROFESOR', 'Profesor que dicta materias'),
('ESTUDIANTE', 'Estudiante regular'),
('SECRETARIA', 'Personal administrativo'),
('JEFE_DEPARTAMENTO', 'Jefe de departamento académico'),
('ASISTENTE', 'Asistente administrativo'),
('INVITADO', 'Acceso limitado de solo lectura'),
('AUDITOR', 'Acceso para auditoría del sistema'),
('DESARROLLADOR', 'Acceso para mantenimiento del sistema'),
('TUTOR', 'Rol para tutores académicos');

-- Primero, asegurémonos de tener datos relacionados correctamente
INSERT INTO asistencia (id_detalle_matricula, fecha, estado) VALUES
(1, '2024-06-17', 'AUSENTE'),
(2, '2024-06-18', 'AUSENTE'),
(3, '2024-06-19', 'AUSENTE'),
(4, '2024-06-20', 'AUSENTE'),
(5, '2024-06-21', 'AUSENTE');

INSERT INTO justificacion (id_asistencia, descripcion, estado, fecha_solicitud, id_revisor) VALUES
(15, 'Enfermedad con fiebre alta', 'APROBADA', '2024-06-17 08:00:00', 1),
(16, 'Problemas de transporte público', 'PENDIENTE', '2024-06-18 09:30:00', NULL),
(17, 'Consulta médica programada', 'APROBADA', '2024-06-19 10:15:00', 2),
(18, 'Emergencia familiar', 'APROBADA', '2024-06-20 07:45:00', 1),
(19, 'Participación en evento académico', 'RECHAZADA', '2024-06-21 14:00:00', 2);

-- 2. Insertar permisos
INSERT INTO permiso (nombre, descripcion) VALUES
('USUARIOS_CREAR', 'Crear nuevos usuarios'),
('USUARIOS_EDITAR', 'Editar usuarios existentes'),
('USUARIOS_ELIMINAR', 'Eliminar usuarios'),
('ESTUDIANTES_GESTION', 'Gestionar estudiantes'),
('PROFESORES_GESTION', 'Gestionar profesores'),
('MATERIAS_GESTION', 'Gestionar materias'),
('GRUPOS_GESTION', 'Gestionar grupos'),
('ASISTENCIAS_REGISTRAR', 'Registrar asistencias'),
('JUSTIFICACIONES_APROBAR', 'Aprobar justificaciones'),
('REPORTES_GENERAR', 'Generar reportes'),
('CONFIGURACION_SISTEMA', 'Configurar parámetros del sistema'),
('MATRICULAS_PROCESAR', 'Procesar matrículas'),
('CALIFICACIONES_REGISTRAR', 'Registrar calificaciones');

-- 3. Asignar permisos a roles
INSERT INTO rol_permiso (id_rol, id_permiso) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10), (1, 11), (1, 12), (1, 13),
(2, 4), (2, 5), (2, 6), (2, 7), (2, 8), (2, 9), (2, 10),
(3, 8), (3, 13),
(4, 8),
(5, 4), (5, 12),
(6, 4), (6, 5), (6, 6), (6, 7), (6, 10),
(7, 4), (7, 12),
(9, 10),
(10, 1), (10, 2), (10, 11);

-- 4. Insertar personas (administradores, profesores y estudiantes)
INSERT INTO persona (cedula, nombre, apellido, fecha_nacimiento, genero, direccion, telefono, email) VALUES
-- Personal administrativo y docentes
('1000000001', 'Admin', 'Sistema', '1980-01-01', 'M', 'Calle Principal 123', '0991234567', 'admin@sistema.edu'),
('1000000002', 'María', 'González', '1985-05-15', 'F', 'Av. Secundaria 456', '0992345678', 'maria.gonzalez@sistema.edu'),
('1000000003', 'Carlos', 'Pérez', '1978-11-23', 'M', 'Calle Terciaria 789', '0993456789', 'carlos.perez@sistema.edu'),
('1000000004', 'Ana', 'Rodríguez', '1990-03-30', 'F', 'Av. Cuarta 1011', '0994567890', 'ana.rodriguez@sistema.edu'),
('1000000005', 'Pedro', 'Martínez', '1982-07-12', 'M', 'Calle Quinta 1213', '0995678901', 'pedro.martinez@sistema.edu'),
('1000000006', 'Luisa', 'Fernández', '1992-09-05', 'F', 'Av. Sexta 1415', '0996789012', 'luisa.fernandez@sistema.edu'),
('1000000007', 'Jorge', 'López', '1975-12-18', 'M', 'Calle Séptima 1617', '0997890123', 'jorge.lopez@sistema.edu'),
('1000000008', 'Diana', 'Sánchez', '1988-04-22', 'F', 'Av. Octava 1819', '0998901234', 'diana.sanchez@sistema.edu'),
('1000000009', 'Roberto', 'Ramírez', '1991-08-07', 'M', 'Calle Novena 2021', '0999012345', 'roberto.ramirez@sistema.edu'),
('1000000010', 'Carmen', 'Torres', '1983-02-14', 'F', 'Av. Décima 2223', '0990123456', 'carmen.torres@sistema.edu'),
('1000000011', 'Miguel', 'Vargas', '1970-06-28', 'M', 'Calle Once 2425', '0991122334', 'miguel.vargas@sistema.edu'),

-- Estudiantes
('2000000001', 'Juan', 'Pérez', '2000-01-10', 'M', 'Calle A 101', '0981111111', 'juan.perez@estudiante.edu'),
('2000000002', 'María', 'Gómez', '2000-02-15', 'F', 'Calle B 202', '0982222222', 'maria.gomez@estudiante.edu'),
('2000000003', 'Carlos', 'López', '2001-03-20', 'M', 'Calle C 303', '0983333333', 'carlos.lopez@estudiante.edu'),
('2000000004', 'Ana', 'Rodríguez', '2001-04-25', 'F', 'Calle D 404', '0984444444', 'ana.rodriguez@estudiante.edu'),
('2000000005', 'Pedro', 'Martínez', '2002-05-30', 'M', 'Calle E 505', '0985555555', 'pedro.martinez@estudiante.edu'),
('2000000006', 'Laura', 'Fernández', '2002-06-05', 'F', 'Calle F 606', '0986666666', 'laura.fernandez@estudiante.edu'),
('2000000007', 'Diego', 'González', '2000-07-10', 'M', 'Calle G 707', '0987777777', 'diego.gonzalez@estudiante.edu'),
('2000000008', 'Sofía', 'Hernández', '2000-08-15', 'F', 'Calle H 808', '0988888888', 'sofia.hernandez@estudiante.edu'),
('2000000009', 'Jorge', 'Díaz', '2001-09-20', 'M', 'Calle I 909', '0989999999', 'jorge.diaz@estudiante.edu'),
('2000000010', 'Lucía', 'Moreno', '2001-10-25', 'F', 'Calle J 1010', '0981010101', 'lucia.moreno@estudiante.edu');

-- 5. Insertar usuarios
INSERT INTO usuario (id_persona, username, password_hash, activo) VALUES
(1, 'admin', SHA2('Admin123!', 256), TRUE),
(2, 'magonzalez', SHA2('Mg2023!', 256), TRUE),
(3, 'cperez', SHA2('Cp2023!', 256), TRUE),
(4, 'arodriguez', SHA2('Ar2023!', 256), TRUE),
(5, 'pmartinez', SHA2('Pm2023!', 256), TRUE),
(6, 'lfernandez', SHA2('Lf2023!', 256), TRUE),
(7, 'jlopez', SHA2('Jl2023!', 256), TRUE),
(8, 'dsanchez', SHA2('Ds2023!', 256), TRUE),
(9, 'rramirez', SHA2('Rr2023!', 256), TRUE),
(10, 'ctorres', SHA2('Ct2023!', 256), TRUE),
(11, 'mvargas', SHA2('Mv2023!', 256), TRUE);

-- 6. Asignar roles a usuarios
INSERT INTO usuario_rol (id_usuario, id_rol) VALUES
(1, 1),  -- Admin tiene rol ADMINISTRADOR
(2, 2),  -- María es COORDINADOR
(3, 3),  -- Carlos es PROFESOR
(4, 4),  -- Ana es ESTUDIANTE
(5, 5),  -- Pedro es SECRETARIA
(6, 6),  -- Luisa es JEFE_DEPARTAMENTO
(7, 7),  -- Jorge es ASISTENTE
(8, 3),  -- Diana es PROFESOR
(9, 3),  -- Roberto es PROFESOR
(10, 8), -- Carmen es INVITADO
(11, 9); -- Miguel es AUDITOR

-- 7. Insertar profesores
INSERT INTO profesor (id_persona, codigo_profesor, especialidad, fecha_contratacion, tipo_contrato) VALUES
(3, 'PROF001', 'Matemáticas', '2015-03-15', 'TIEMPO_COMPLETO'),
(8, 'PROF002', 'Literatura', '2018-08-20', 'TIEMPO_COMPLETO'),
(9, 'PROF003', 'Historia', '2017-01-10', 'MEDIO_TIEMPO'),
(11, 'PROF004', 'Informática', '2020-05-22', 'TIEMPO_COMPLETO');

-- 8. Insertar estudiantes
INSERT INTO estudiante (id_persona, codigo_estudiante, fecha_ingreso, estado) VALUES
(12, 'EST2023001', '2023-01-15', 'ACTIVO'),
(13, 'EST2023002', '2023-01-15', 'ACTIVO'),
(14, 'EST2023003', '2023-01-15', 'ACTIVO'),
(15, 'EST2023004', '2023-01-15', 'ACTIVO'),
(16, 'EST2023005', '2023-01-15', 'ACTIVO'),
(17, 'EST2023006', '2023-01-15', 'ACTIVO'),
(18, 'EST2023007', '2023-01-15', 'ACTIVO'),
(19, 'EST2023008', '2023-01-15', 'ACTIVO'),
(20, 'EST2023009', '2023-01-15', 'ACTIVO'),
(21, 'EST2023010', '2023-01-15', 'ACTIVO');

-- 9. Insertar departamentos
INSERT INTO departamento (nombre, codigo, fecha_creacion) VALUES
('Ciencias Exactas', 'DCE', '2010-01-15'),
('Humanidades', 'DHU', '2010-01-15'),
('Tecnología', 'DTE', '2015-03-20'),
('Ciencias Sociales', 'DCS', '2012-08-10');

-- 10. Actualizar directores de departamento
UPDATE departamento SET id_director = 1 WHERE id_departamento = 1;
UPDATE departamento SET id_director = 2 WHERE id_departamento = 2;
UPDATE departamento SET id_director = 4 WHERE id_departamento = 3;
UPDATE departamento SET id_director = 3 WHERE id_departamento = 4;

-- 11. Insertar carreras
INSERT INTO carrera (nombre, codigo, id_departamento, duracion_semestres, creditos_totales, estado) VALUES
('Ingeniería en Sistemas', 'IS', 3, 10, 320, 'ACTIVA'),
('Licenciatura en Matemáticas', 'LM', 1, 8, 256, 'ACTIVA'),
('Licenciatura en Literatura', 'LL', 2, 8, 256, 'ACTIVA'),
('Economía', 'EC', 4, 8, 256, 'ACTIVA');

-- 12. Insertar materias
INSERT INTO materia (nombre, codigo, creditos, horas_teoria, horas_practica, id_departamento) VALUES
-- Departamento de Ciencias Exactas
('Cálculo I', 'CAL101', 4, 4, 2, 1),
('Cálculo II', 'CAL102', 4, 4, 2, 1),
('Álgebra Lineal', 'ALG201', 4, 4, 2, 1),
('Física I', 'FIS101', 4, 4, 2, 1),

-- Departamento de Humanidades
('Literatura Universal', 'LIT101', 3, 3, 0, 2),
('Gramática Avanzada', 'GRA201', 3, 3, 0, 2),
('Historia del Arte', 'ART301', 3, 3, 0, 2),

-- Departamento de Tecnología
('Programación I', 'PRO101', 4, 3, 3, 3),
('Programación II', 'PRO102', 4, 3, 3, 3),
('Bases de Datos', 'BAS301', 4, 3, 3, 3),

-- Departamento de Ciencias Sociales
('Introducción a la Economía', 'ECO101', 3, 3, 0, 4),
('Microeconomía', 'MIC201', 3, 3, 0, 4),
('Macroeconomía', 'MAC301', 3, 3, 0, 4);

-- 13. Insertar periodos académicos
INSERT INTO periodo_academico (nombre, fecha_inicio, fecha_fin, estado) VALUES
('2023-1', '2023-01-16', '2023-05-26', 'FINALIZADO'),
('2023-2', '2023-06-05', '2023-10-13', 'FINALIZADO'),
('2024-1', '2024-01-15', '2024-05-24', 'FINALIZADO'),
('2024-2', '2024-06-03', '2024-10-11', 'EN_CURSO');

-- 14. Insertar grupos
INSERT INTO grupo (id_materia, id_profesor, id_periodo, codigo_grupo, cupo_maximo, horario, aula) VALUES
-- Grupos para 2024-2 (periodo actual)
(1, 1, 4, 'G1', 30, 'Lunes y Miércoles 8:00-10:00', 'A101'),
(2, 1, 4, 'G1', 30, 'Martes y Jueves 8:00-10:00', 'A102'),
(5, 2, 4, 'G1', 25, 'Lunes y Miércoles 10:00-12:00', 'B201'),
(8, 4, 4, 'G1', 25, 'Martes y Jueves 10:00-12:00', 'LAB1'),
(11, 3, 4, 'G1', 20, 'Viernes 14:00-18:00', 'C301');

-- 15. Insertar matrículas
INSERT INTO matricula (id_estudiante, id_periodo, estado, total_creditos) VALUES
(1, 4, 'COMPLETADA', 12),
(2, 4, 'COMPLETADA', 12),
(3, 4, 'COMPLETADA', 12),
(4, 4, 'COMPLETADA', 12),
(5, 4, 'COMPLETADA', 12);

-- 16. Insertar detalles de matrícula
INSERT INTO detalle_matricula (id_matricula, id_grupo, estado) VALUES
(1, 1, 'CURSANDO'),
(1, 3, 'CURSANDO'),
(2, 1, 'CURSANDO'),
(2, 4, 'CURSANDO'),
(3, 2, 'CURSANDO'),
(3, 5, 'CURSANDO'),
(4, 3, 'CURSANDO'),
(4, 5, 'CURSANDO'),
(5, 4, 'CURSANDO'),
(5, 2, 'CURSANDO');

-- 17. Insertar asistencias
INSERT INTO asistencia (id_detalle_matricula, fecha, estado) VALUES
(1, '2024-06-05', 'PRESENTE'),
(1, '2024-06-10', 'PRESENTE'),
(1, '2024-06-12', 'AUSENTE'),
(2, '2024-06-03', 'PRESENTE'),
(2, '2024-06-05', 'TARDANZA'),
(3, '2024-06-05', 'PRESENTE'),
(3, '2024-06-10', 'PRESENTE'),
(4, '2024-06-04', 'PRESENTE'),
(4, '2024-06-06', 'AUSENTE'),
(5, '2024-06-07', 'PRESENTE');


INSERT INTO justificacion (id_asistencia, descripcion, estado) VALUES
(3, 'Enfermedad comprobada con certificado médico', 'APROBADA'),
(5, 'Problemas de transporte público', 'PENDIENTE'),
(9, 'Emergencia familiar', 'APROBADA');

-- =============================================
-- CONSULTAS CON JOIN (10 consultas)
-- =============================================

-- 1. Listado de estudiantes con sus personas asociadas
SELECT e.codigo_estudiante, p.nombre, p.apellido, p.email 
FROM estudiante e
JOIN persona p ON e.id_persona = p.id_persona;

-- 2. Profesores con sus materias asignadas
SELECT pr.codigo_profesor, p.nombre, p.apellido, m.nombre AS materia, g.codigo_grupo
FROM profesor pr
JOIN persona p ON pr.id_persona = p.id_persona
JOIN grupo g ON pr.id_profesor = g.id_profesor
JOIN materia m ON g.id_materia = m.id_materia;

-- 3. Asistencias con justificaciones
SELECT a.fecha, a.estado, j.descripcion, j.estado AS estado_justificacion
FROM asistencia a
LEFT JOIN justificacion j ON a.id_asistencia = j.id_asistencia;

-- 4. Estudiantes con sus materias matriculadas
SELECT e.codigo_estudiante, p.nombre, p.apellido, m.nombre AS materia, g.codigo_grupo
FROM estudiante e
JOIN persona p ON e.id_persona = p.id_persona
JOIN matricula ma ON e.id_estudiante = ma.id_estudiante
JOIN detalle_matricula dm ON ma.id_matricula = dm.id_matricula
JOIN grupo g ON dm.id_grupo = g.id_grupo
JOIN materia m ON g.id_materia = m.id_materia;

-- 5. Horarios de grupos con información completa
SELECT m.nombre AS materia, g.codigo_grupo, g.horario, g.aula, 
       pr.codigo_profesor, pe.nombre AS profesor_nombre, pe.apellido AS profesor_apellido
FROM grupo g
JOIN materia m ON g.id_materia = m.id_materia
JOIN profesor pr ON g.id_profesor = pr.id_profesor
JOIN persona pe ON pr.id_persona = pe.id_persona;

-- 6. Usuarios con sus roles y permisos
SELECT u.username, p.nombre, p.apellido, r.nombre AS rol, GROUP_CONCAT(per.nombre SEPARATOR ', ') AS permisos
FROM usuario u
JOIN persona p ON u.id_persona = p.id_persona
JOIN usuario_rol ur ON u.id_usuario = ur.id_usuario
JOIN rol r ON ur.id_rol = r.id_rol
JOIN rol_permiso rp ON r.id_rol = rp.id_rol
JOIN permiso per ON rp.id_permiso = per.id_permiso
GROUP BY u.username, p.nombre, p.apellido, r.nombre;

-- 7. Asistencias con justificaciones aprobadas
SELECT a.fecha, e.codigo_estudiante, p.nombre, p.apellido, m.nombre AS materia, j.descripcion
FROM asistencia a
JOIN justificacion j ON a.id_asistencia = j.id_asistencia
JOIN detalle_matricula dm ON a.id_detalle_matricula = dm.id_detalle
JOIN matricula ma ON dm.id_matricula = ma.id_matricula
JOIN estudiante e ON ma.id_estudiante = e.id_estudiante
JOIN persona p ON e.id_persona = p.id_persona
JOIN grupo g ON dm.id_grupo = g.id_grupo
JOIN materia m ON g.id_materia = m.id_materia
WHERE j.estado = 'APROBADA';

-- 8. Estudiantes ausentes sin justificación
SELECT a.fecha, e.codigo_estudiante, p.nombre, p.apellido, m.nombre AS materia
FROM asistencia a
JOIN detalle_matricula dm ON a.id_detalle_matricula = dm.id_detalle
JOIN matricula ma ON dm.id_matricula = ma.id_matricula
JOIN estudiante e ON ma.id_estudiante = e.id_estudiante
JOIN persona p ON e.id_persona = p.id_persona
JOIN grupo g ON dm.id_grupo = g.id_grupo
JOIN materia m ON g.id_materia = m.id_materia
LEFT JOIN justificacion j ON a.id_asistencia = j.id_asistencia
WHERE a.estado = 'AUSENTE' AND j.id_justificacion IS NULL;

-- 9. Materias con cantidad de estudiantes matriculados
SELECT m.nombre AS materia, COUNT(DISTINCT ma.id_estudiante) AS estudiantes_matriculados
FROM materia m
JOIN grupo g ON m.id_materia = g.id_materia
JOIN detalle_matricula dm ON g.id_grupo = dm.id_grupo
JOIN matricula ma ON dm.id_matricula = ma.id_matricula
GROUP BY m.nombre;

-- 10. Historial completo de asistencias
SELECT a.fecha, a.estado, 
       e.codigo_estudiante, p.nombre AS estudiante_nombre, p.apellido AS estudiante_apellido,
       m.nombre AS materia, g.codigo_grupo,
       CASE WHEN j.id_justificacion IS NOT NULL THEN j.descripcion ELSE NULL END AS justificacion,
       j.estado AS estado_justificacion
FROM asistencia a
JOIN detalle_matricula dm ON a.id_detalle_matricula = dm.id_detalle
JOIN matricula ma ON dm.id_matricula = ma.id_matricula
JOIN estudiante e ON ma.id_estudiante = e.id_estudiante
JOIN persona p ON e.id_persona = p.id_persona
JOIN grupo g ON dm.id_grupo = g.id_grupo
JOIN materia m ON g.id_materia = m.id_materia
LEFT JOIN justificacion j ON a.id_asistencia = j.id_asistencia
ORDER BY a.fecha DESC;

-- =============================================
-- PROCEDIMIENTOS ALMACENADOS (10 procedures)
-- =============================================

DELIMITER //

-- 1. Registrar nuevo estudiante
CREATE PROCEDURE sp_registrar_estudiante(
    IN p_cedula VARCHAR(20),
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_codigo_estudiante VARCHAR(20),
    IN p_fecha_ingreso DATE
)
BEGIN
    DECLARE v_id_persona INT;
    
    -- Insertar la persona primero
    INSERT INTO persona (cedula, nombre, apellido, email)
    VALUES (p_cedula, p_nombre, p_apellido, p_email);
    
    SET v_id_persona = LAST_INSERT_ID();
    
    -- Luego insertar el estudiante
    INSERT INTO estudiante (id_persona, codigo_estudiante, fecha_ingreso)
    VALUES (v_id_persona, p_codigo_estudiante, p_fecha_ingreso);
    
    SELECT CONCAT('Estudiante ', p_codigo_estudiante, ' registrado exitosamente') AS mensaje;
END //

-- 2. Registrar asistencia para un grupo en una fecha
CREATE PROCEDURE sp_registrar_asistencia_grupo(
    IN p_id_grupo INT,
    IN p_fecha DATE
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id_detalle INT;
    DECLARE v_estado VARCHAR(20);
    DECLARE cur CURSOR FOR 
        SELECT id_detalle FROM detalle_matricula WHERE id_grupo = p_id_grupo;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_id_detalle;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Por defecto marcamos como ausente (luego se puede actualizar)
        INSERT INTO asistencia (id_detalle_matricula, fecha, estado)
        VALUES (v_id_detalle, p_fecha, 'AUSENTE')
        ON DUPLICATE KEY UPDATE estado = 'AUSENTE';
    END LOOP;
    
    CLOSE cur;
    
    SELECT CONCAT('Asistencias registradas para el grupo ', p_id_grupo, ' en la fecha ', p_fecha) AS mensaje;
END //

DELIMITER //

-- 3. Actualizar estado de asistencia individual
DELIMITER $$

CREATE PROCEDURE sp_actualizar_asistencia(
    IN p_id_estudiante INT,
    IN p_id_grupo INT,
    IN p_fecha DATE,
    IN p_estado VARCHAR(20)
)
BEGIN
    DECLARE v_id_detalle INT;

    -- Buscar el detalle de matrícula correspondiente
    SELECT dm.id_detalle INTO v_id_detalle
    FROM detalle_matricula dm
    JOIN matricula m ON dm.id_matricula = m.id_matricula
    WHERE m.id_estudiante = p_id_estudiante AND dm.id_grupo = p_id_grupo;

    IF v_id_detalle IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se encontró matrícula para el estudiante en el grupo especificado';
    ELSE
        -- Actualizar o insertar la asistencia
        INSERT INTO asistencia (id_detalle_matricula, fecha, estado)
        VALUES (v_id_detalle, p_fecha, p_estado)
        ON DUPLICATE KEY UPDATE estado = p_estado;

        SELECT 'Asistencia actualizada correctamente' AS mensaje;
    END IF;
END $$

DELIMITER ;


 
