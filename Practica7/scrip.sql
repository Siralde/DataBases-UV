/**

Diseño Fisico

*/

CREATE TABLE sala(
	codigo number PRIMARY KEY,
	nombre_sala varchar2(20) NOT NULL,
	capacidad number NOT NULL
);

-- PARTE IZQUIERDA MULTIUSOS


CREATE TABLE multiusos(
	id_multiusos number PRIMARY KEY,
	megafonia number(1) NOT NULL,
	red number(1) NOT NULL, /* 0 FALSE, 1 TRUE */
	codigo number NOT NULL,

	CONSTRAINT fk_sala_codigo FOREIGN KEY(codigo) REFERENCES sala(codigo)

);


CREATE TABLE empleado(
	id_empleado number PRIMARY KEY,
	nombre varchar2(20) NOT NULL,
	nif number NOT NULL,
	puesto number NOT NULL,
	categoria varchar2(20) NOT NULL
);



CREATE TABLE reservaciones(
	id_reserva number PRIMARY KEY,
	fecha_hora_ini date NOT NULL,
	fecha_hora_fin date NOT NULL,
	evento varchar2(20) NOT NULL,
	id_multiusos number NOT NULL,
	id_empleado number NOT NULL,

	CONSTRAINT fk_multiusos_id FOREIGN KEY(id_multiusos) REFERENCES multiusos(id_multiusos),

	CONSTRAINT fk_empleado_id FOREIGN KEY(id_empleado) REFERENCES empleado(id_empleado)

);

-- FIN DE LA PRIMERA COLUMNA --



-- INICIO SEGUNDA COLUMNA

CREATE TABLE salaconciertos(
	id number PRIMARY KEY,
	codigo_sala number NOT NULL,

	CONSTRAINT fk_sala2_codigo FOREIGN KEY(codigo_sala) REFERENCES sala(codigo)
);

CREATE TABLE tipozona(
	id_tipozona number PRIMARY KEY,
	descripcion varchar2(20) NOT NULL
);

CREATE TABLE zonas(
	id_zona number,
	capacidad number NOT NULL,
	id_salaconcierto number NOT NULL,
	id_tipozona number NOT NULL,

	CONSTRAINT pk_zonas PRIMARY KEY(id_zona. id_salaconcierto),
	CONSTRAINT fk_salaconcierto_id FOREIGN KEY(id_salaconcierto) REFERENCES salaconciertos(id),
	CONSTRAINT fk_tipozona_id FOREIGN KEY(id_tipozona) REFERENCES tipozona(id_tipozona)
);


-- FIN SEGUNDA COLUMNA




-- INICIO DE LA CUARTA COLUMNA --




CREATE TABLE orquesta(
	id_orquesta number PRIMARY KEY,
	nombre varchar2(20) NOT NULL,
	pais varchar2(20) NOT NULL
);


CREATE TABLE director(
	id_director number PRIMARY KEY,
	nombre varchar2(20) NOT NULL,
	nacionalidad varchar2(20) NOT NULL
);

CREATE TABLE conciertos(
	id_concierto number PRIMARY KEY,
	titulo varchar2(20) NOT NULL,
	fecha_ini date NOT NULL,
	fecha_fin date NOT NULL,
	id_orquesta number NOT NULL,
	id_director number NOT NULL,
	id_programa number NOT NULL UNIQUE,
	num_obras number NOT NULL,
	duracion number NOT NULL,

	CONSTRAINT fk_orquesta_id FOREIGN KEY(id_orquesta) REFERENCES orquesta(id_orquesta),

	CONSTRAINT fk_director_id FOREIGN KEY(id_director) REFERENCES director(id_director)
);


CREATE TABLE obras(
	id_obra number PRIMARY KEY,
	titulo varchar2(20) NOT NULL,
	autor varchar2(20) NOT NULL,
	fecha date NOT NULL,
	duracion number NOT NULL,
	id_programa number NOT NULL,

	CONSTRAINT fk_concierto_programa_id FOREIGN KEY (id_programa) REFERENCES conciertos(id_programa)
);

-- Fin Cuarta columna --





-- INICIO DE LA TERCERA COLUMNA


CREATE TABLE evento(
	id_evento number PRIMARY KEY,
	fecha date NOT NULL,
	hora_ini date NOT NULL,
	hora_fin date NOT NULL,
	id_concierto number NOT NULL,

	CONSTRAINT fk_concierto_id FOREIGN KEY(id_concierto) REFERENCES conciertos(id_concierto)
);


CREATE TABLE localidades(
	id_localidades number PRIMARY KEY,
	vendidas number NOT NULL,
	capacidad number NOT NULL,
	precio number NOT NULL,
	id_evento number NOT NULL,
	id_zona number NOT NULL,

	CONSTRAINT fk_evento_id FOREIGN KEY(id_evento) REFERENCES evento(id_evento),

	CONSTRAINT fk_zona_id FOREIGN KEY(id_zona) REFERENCES zonas(id_zona)

);


CREATE TABLE entradas(
	id_entrada number PRIMARY KEY,
	fila varchar2(10) NOT NULL,
	asiento varchar2(20) NOT NULL,
	precio_final number NOT NULL,
	id_localidades number NOT NULL,

	CONSTRAINT fk_localidades_id FOREIGN KEY(id_localidades) REFERENCES localidades(id_localidades)
);

-- FIN DE LA TERCERA COLUMNA --


