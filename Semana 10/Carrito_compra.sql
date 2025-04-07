
CREATE TABLE persona (
    id INT PRIMARY KEY auto_increment,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo VARCHAR(50) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(50) NOT NULL
);


CREATE TABLE cliente (
    id INT PRIMARY KEY auto_increment,
    fecha_vinculacion DATE NOT NULL,
    persona_id INT NOT NULL,
    FOREIGN KEY (persona_id) REFERENCES persona(id)
);


CREATE TABLE empleado (
    id INT PRIMARY KEY auto_increment,
    fecha_vinculacion DATE NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    tipo_contrato VARCHAR(50) NOT NULL,
    persona_id INT NOT NULL,
    FOREIGN KEY (persona_id) REFERENCES persona(id)
);


CREATE TABLE categoria (
    id INT PRIMARY KEY auto_increment,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL
);


CREATE TABLE metodo_pago (
    id INT PRIMARY KEY auto_increment,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL
);


CREATE TABLE producto (
    id INT PRIMARY KEY auto_increment,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL,
    categoria_id INT NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categoria(id)
);


CREATE TABLE inventario (
    id INT PRIMARY KEY auto_increment,
    nombre VARCHAR(50) NOT NULL,
    fecha DATE NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    fecha_lote DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    producto_id INT NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES producto(id)
);


CREATE TABLE factura (
    id INT PRIMARY KEY auto_increment,
    fecha DATE NOT NULL,
    valor_bruto DECIMAL(10,2) NOT NULL,
    valor_descuento DECIMAL(10,2) NOT NULL,
    valor_incremento DECIMAL(10,2) NOT NULL,
    valor_neto DECIMAL(10,2) NOT NULL,
    cliente_id INT NOT NULL,
    medio_pago_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id),
    FOREIGN KEY (medio_pago_id) REFERENCES metodo_pago(id)
);


CREATE TABLE detalle_factura (
    id INT PRIMARY KEY auto_increment,
    cantidad INT NOT NULL,
    porcentaje_descuento DECIMAL(10,2) NOT NULL,
    porcentaje_incremento DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    producto_id INT NOT NULL,
    factura_id INT NOT NULL,
    FOREIGN KEY (producto_id) REFERENCES producto(id),
    FOREIGN KEY (factura_id) REFERENCES factura(id)
);

INSERT INTO persona (nombre, apellido, fecha_nacimiento, correo, direccion, telefono) VALUES
('Sergio', 'Delgado', '1972-06-10', 'sergio.delgado@gmail.com', 'Transversal 43 #65-22, Medellín', '+57 312 321 4567'),
('Lucía', 'Vega', '1980-03-15', 'lucia.vega@gmail.com', 'Calle 12 #8-35, Bogotá', '+57 310 654 7890'),
('Carlos', 'Pérez', '1985-10-23', 'carlos.perez@gmail.com', 'Carrera 7 #45-12, Cali', '+57 301 987 6543'),
('Laura', 'Jiménez', '1990-05-17', 'laura.jimenez@gmail.com', 'Avenida 6 #21-34, Barranquilla', '+57 313 123 4567'),
('Camilo', 'González', '1979-12-03', 'camilo.gonzalez@gmail.com', 'Calle 59 #33-17, Bucaramanga', '+57 314 321 7890'),
('Valentina', 'Ramírez', '1993-01-25', 'valentina.ramirez@gmail.com', 'Diagonal 18 #72-20, Cartagena', '+57 316 456 1234'),
('Andrés', 'Moreno', '1988-08-08', 'andres.moreno@gmail.com', 'Carrera 9 #13-40, Santa Marta', '+57 319 654 7890'),
('Natalia', 'Castaño', '1976-11-29', 'natalia.castano@gmail.com', 'Transversal 22 #44-18, Manizales', '+57 300 123 9876'),
('Diego', 'Rojas', '1991-07-11', 'diego.rojas@gmail.com', 'Calle 100 #23-45, Medellín', '+57 302 567 8901'),
('Paula', 'Suárez', '1983-04-27', 'paula.suarez@gmail.com', 'Carrera 11 #9-50, Bogotá', '+57 312 678 1234'),
('Esteban', 'López', '1974-09-22', 'esteban.lopez@gmail.com', 'Avenida 10 #60-33, Cali', '+57 311 432 7654'),
('Juliana', 'Mejía', '1992-06-30', 'juliana.mejia@gmail.com', 'Calle 40 #12-90, Cartagena', '+57 313 345 6789'),
('Felipe', 'García', '1987-03-19', 'felipe.garcia@gmail.com', 'Carrera 15 #77-66, Medellín', '+57 318 123 4567'),
('Isabella', 'Ortiz', '1995-12-07', 'isabella.ortiz@gmail.com', 'Transversal 3 #45-20, Santa Marta', '+57 310 654 3210'),
('Mateo', 'Torres', '1982-02-04', 'mateo.torres@gmail.com', 'Calle 27 #33-78, Bogotá', '+57 320 789 0123'),
('Daniela', 'Castro', '1990-11-16', 'daniela.castro@gmail.com', 'Carrera 20 #30-55, Bucaramanga', '+57 301 321 4567'),
('Tomás', 'Navarro', '1986-01-12', 'tomas.navarro@gmail.com', 'Avenida 5 #19-22, Barranquilla', '+57 311 222 3333'),
('Manuela', 'Herrera', '1994-08-20', 'manuela.herrera@gmail.com', 'Diagonal 14 #55-10, Cali', '+57 314 444 5555'),
('Julián', 'Reyes', '1978-07-09', 'julian.reyes@gmail.com', 'Transversal 19 #23-44, Medellín', '+57 316 666 7777'),
('Sofía', 'Álvarez', '1989-10-01', 'sofia.alvarez@gmail.com', 'Calle 34 #9-90, Bogotá', '+57 319 888 9999'),
('Samuel', 'Mendoza', '1981-05-06', 'samuel.mendoza@gmail.com', 'Carrera 18 #60-11, Cali', '+57 312 999 0000'),
('Gabriela', 'Salazar', '1993-09-14', 'gabriela.salazar@gmail.com', 'Calle 88 #45-34, Cartagena', '+57 300 888 7777'),
('Juan', 'Silva', '1986-04-18', 'juan.silva@gmail.com', 'Diagonal 22 #33-22, Medellín', '+57 301 123 4560'),
('Antonia', 'Ruiz', '1991-12-22', 'antonia.ruiz@gmail.com', 'Transversal 8 #11-15, Santa Marta', '+57 315 654 3210'),
('David', 'Nieto', '1975-08-13', 'david.nieto@gmail.com', 'Calle 70 #23-40, Bogotá', '+57 313 789 4561'),
('Valeria', 'Barrios', '1994-03-28', 'valeria.barrios@gmail.com', 'Carrera 17 #55-78, Barranquilla', '+57 311 987 6543'),
('Emilio', 'Rosales', '1980-07-07', 'emilio.rosales@gmail.com', 'Avenida 15 #99-18, Bucaramanga', '+57 314 654 7891'),
('Martina', 'Aguilar', '1988-01-01', 'martina.aguilar@gmail.com', 'Calle 11 #22-10, Cartagena', '+57 316 333 4444'),
('Alexander', 'León', '1983-06-03', 'alexander.leon@gmail.com', 'Diagonal 27 #60-12, Cali', '+57 310 432 1234'),
('Sara', 'Peña', '1996-02-10', 'sara.pena@gmail.com', 'Carrera 14 #77-23, Medellín', '+57 318 555 6666'),
('Sebastián', 'Cortés', '1977-11-19', 'sebastian.cortes@gmail.com', 'Calle 38 #12-30, Bogotá', '+57 317 111 2222'),
('Mariana', 'Zapata', '1992-05-08', 'mariana.zapata@gmail.com', 'Carrera 25 #45-60, Barranquilla', '+57 312 333 4444'),
('Nicolás', 'Acosta', '1984-09-26', 'nicolas.acosta@gmail.com', 'Avenida 40 #18-90, Cali', '+57 300 555 6666'),
('Renata', 'Vargas', '1993-07-03', 'renata.vargas@gmail.com', 'Diagonal 50 #67-12, Medellín', '+57 316 777 8888'),
('Tomás', 'Figueroa', '1985-03-11', 'tomas.figueroa@gmail.com', 'Transversal 19 #30-44, Santa Marta', '+57 313 000 1111'),
('Daniela', 'Montoya', '1989-06-21', 'daniela.montoya@gmail.com', 'Calle 60 #19-55, Bucaramanga', '+57 319 222 3333'),
('Alejandro', 'Gil', '1973-10-14', 'alejandro.gil@gmail.com', 'Carrera 10 #88-45, Bogotá', '+57 301 444 5555'),
('Catalina', 'Luna', '1995-01-30', 'catalina.luna@gmail.com', 'Avenida 12 #55-99, Cartagena', '+57 314 666 7777'),
('Jorge', 'Valencia', '1982-02-17', 'jorge.valencia@gmail.com', 'Diagonal 45 #33-20, Medellín', '+57 310 888 9999'),
('Melissa', 'Paredes', '1990-12-05', 'melissa.paredes@gmail.com', 'Carrera 13 #19-77, Barranquilla', '+57 311 123 4567'),
('Luis', 'Campos', '1979-04-24', 'luis.campos@gmail.com', 'Calle 71 #10-22, Bogotá', '+57 312 234 5678'),
('Isabela', 'Cárdenas', '1987-11-30', 'isabela.cardenas@gmail.com', 'Carrera 28 #56-18, Cali', '+57 313 876 5432'),
('Mauricio', 'Quintero', '1991-06-12', 'mauricio.quintero@gmail.com', 'Avenida 26 #44-90, Medellín', '+57 310 345 6789'),
('Adriana', 'Mora', '1986-08-15', 'adriana.mora@gmail.com', 'Transversal 5 #33-10, Santa Marta', '+57 301 678 9012'),
('Ricardo', 'Padilla', '1980-10-10', 'ricardo.padilla@gmail.com', 'Calle 15 #23-88, Cartagena', '+57 300 789 0123'),
('Tatiana', 'Santos', '1993-09-25', 'tatiana.santos@gmail.com', 'Carrera 12 #44-77, Barranquilla', '+57 314 901 2345'),
('Eduardo', 'Muñoz', '1978-03-02', 'eduardo.munoz@gmail.com', 'Avenida 3 #66-55, Bucaramanga', '+57 316 345 6789'),
('Daniela', 'Rincón', '1984-12-19', 'daniela.rincon@gmail.com', 'Diagonal 19 #20-11, Bogotá', '+57 318 567 8901'),
('Cristian', 'Espinosa', '1990-07-27', 'cristian.espinosa@gmail.com', 'Calle 25 #17-45, Cali', '+57 315 678 9012'),
('María José', 'Beltrán', '1996-02-03', 'mariajose.beltran@gmail.com', 'Carrera 7 #12-80, Medellín', '+57 319 789 0123');

UPDATE

UPDATE persona
SET telefono = '+57 300 111 2233'
WHERE correo = 'sergio.delgado@gmail.com';

UPDATE persona
SET nombre = 'Andrés', apellido = 'Sánchez'
WHERE id = 3;

UPDATE persona
SET telefono = '+57 310 111 2222', direccion = 'Carrera 5 #22-33, Medellín'
WHERE correo = 'carlos.perez@gmail.com';

UPDATE persona
SET correo = 'lucia.vega.actualizado@gmail.com'
WHERE nombre = 'Lucía' AND apellido = 'Vega';

UPDATE persona
SET fecha_nacimiento = '1990-01-01'
WHERE id = 10;

Delete

DELETE FROM persona
WHERE correo = 'daniela.rincon@gmail.com';

DELETE FROM persona
WHERE correo = 'tomas.navarro@gmail.com';

DELETE FROM persona
WHERE nombre = 'Ricardo';

DELETE FROM persona
WHERE id = 15;

DELETE FROM persona
WHERE direccion = 'Carrera 12 #44-77, Barranquilla';

INNER JOIN

SELECT c.id AS cliente_id, p.nombre, p.apellido, p.correo
FROM cliente c
INNER JOIN persona p ON c.persona_id = p.id;

SELECT e.id AS empleado_id, p.nombre, p.apellido, e.salario, e.tipo_contrato
FROM empleado e
INNER JOIN persona p ON e.persona_id = p.id;

SELECT pr.id AS producto_id, pr.nombre, c.nombre AS categoria
FROM producto pr
INNER JOIN categoria c ON pr.categoria_id = c.id;

SELECT i.id AS inventario_id, i.nombre, pr.nombre AS producto, i.stock, i.precio
FROM inventario i
INNER JOIN producto pr ON i.producto_id = pr.id;

SELECT df.id AS detalle_id, pr.nombre AS producto, df.cantidad, df.subtotal
FROM detalle_factura df
INNER JOIN producto pr ON df.producto_id = pr.id;






