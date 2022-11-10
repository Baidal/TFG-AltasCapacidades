INSERT INTO `altascapacidades`.`rol`
(`rol`
) VALUES (
	'Psicologos'
);

INSERT INTO `altascapacidades`.`rol`
(`rol`
) VALUES (
	'Tutores'
);

INSERT INTO `altascapacidades`.`rol`
(
`rol`
) 
VALUES (
	'admin'
);

INSERT INTO `altascapacidades`.`estado`
(
`estado`
) 
VALUES (
	'activo'
);

INSERT INTO `altascapacidades`.`estado`
(
`estado`
) 
VALUES (
	'inactivo'
);

INSERT INTO `altascapacidades`.`estado`
(
`estado`
) 
VALUES (
	'vetado'
);

INSERT INTO `altascapacidades`.`usuario`
(
`email`,
`password`,
`nombre`,
`apellidos`,
`dni`,
`telefono`,
`fecha_nacimiento`,
`estado_id`,
`rol_id`)
VALUES
(
'israel_22@gmail.com',
'$2a$10$2GFgR8LsmACRX2eDa347XehTheJNCCnumVUFM4fhDj2O2yXVTqur.',
'Luisa',
'Rico Díaz',
'4592898E',
'629602722',
'2000-01-20',
1,
1);

INSERT INTO `altascapacidades`.`usuario`
(
`email`,
`password`,
`nombre`,
`apellidos`,
`dni`,
`telefono`,
`fecha_nacimiento`,
`estado_id`,
`rol_id`)
VALUES
(
'luis@gmail.com',
'$2a$10$2GFgR8LsmACRX2eDa347XehTheJNCCnumVUFM4fhDj2O2yXVTqur.',
'Luis',
'Vidal Rico',
'4592892E',
'629602723',
'2000-12-20',
1,
2);

INSERT INTO `altascapacidades`.`usuario`
(
`email`,
`password`,
`nombre`,
`apellidos`,
`dni`,
`telefono`,
`fecha_nacimiento`,
`estado_id`,
`rol_id`)
VALUES
(
'alberto@gmail.com',
'$2a$10$2GFgR8LsmACRX2eDa347XehTheJNCCnumVUFM4fhDj2O2yXVTqur.',
'Alberto',
'Gutiérrez Martínez',
'4592822E',
'629602724',
'1990-12-20',
1,
3);

INSERT INTO `altascapacidades`.`expediente`
(
`nombre_niño`,
`apellidos_niño`,
`nombre`,
`dni_niño`,
`fechanacimiento_niño`)
VALUES
(
'Luis',
'Vidal Rico',
'Expediente 1',
'32112332A',
'2020-10-12');

INSERT INTO `altascapacidades`.`expediente`
(
`nombre_niño`,
`apellidos_niño`,
`nombre`,
`dni_niño`,
`fechanacimiento_niño`)
VALUES
(
'Aberto',
'Rodríguez',
'Expediente 2',
'32112332B',
'2020-10-12');

INSERT INTO `altascapacidades`.`expediente`
(
`nombre_niño`,
`apellidos_niño`,
`nombre`,
`dni_niño`,
`fechanacimiento_niño`)
VALUES
(
'Alfonso',
'García',
'Expediente 3',
'32112332B',
'2020-10-12');

INSERT INTO `altascapacidades`.`usuario_expediente`
(`usuario_id`,
`expediente_id`,
`rol_id`)
VALUES
(
1, 1, 1
);

INSERT INTO `altascapacidades`.`usuario_expediente`
(`usuario_id`,
`expediente_id`,
`rol_id`)
VALUES
(
1, 2, 1
);

INSERT INTO `altascapacidades`.`usuario_expediente`
(`usuario_id`,
`expediente_id`,
`rol_id`)
VALUES
(
1, 3, 2
);

INSERT INTO `altascapacidades`.`usuario_expediente`
(`usuario_id`,
`expediente_id`,
`rol_id`)
VALUES
(
2, 1, 2
);
INSERT INTO `altascapacidades`.`usuario_expediente`
(`usuario_id`,
`expediente_id`,
`rol_id`)
VALUES
(
2, 2, 1
);

INSERT INTO `altascapacidades`.`anotaciones`
(
`titulo`,
`anotacion`,
`usuario_id`,
`expediente_id`)
VALUES
(
'Anotacion 1',
'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
1,
1);

INSERT INTO `altascapacidades`.`anotaciones`
(
`titulo`,
`anotacion`,
`usuario_id`,
`expediente_id`)
VALUES
(
'Lorem ipsum dolor',
'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.',
1,
1);

INSERT INTO `altascapacidades`.`anotaciones`
(
`titulo`,
`anotacion`,
`usuario_id`,
`expediente_id`)
VALUES
(
'Lorem ipsum dolor',
'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.',
1,
1);

INSERT INTO `altascapacidades`.`anotaciones`
(
`titulo`,
`anotacion`,
`usuario_id`,
`expediente_id`)
VALUES
(
'Lorem ipsum dolor',
'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.',
1,
2);

INSERT INTO `altascapacidades`.`cuestionario`
(
`nombre`)
VALUES
(
	'Cuestionario 1'
);

INSERT INTO `altascapacidades`.`cuestionario`
(
`nombre`)
VALUES
(
	'Cuestionario 2'
);

INSERT INTO `altascapacidades`.`cuestionario`
(
`nombre`)
VALUES
(
	'Cuestionario 3'
);

INSERT INTO `altascapacidades`.`cuestionario`
(
`nombre`)
VALUES
(
	'Cuestionario 4'
);

INSERT INTO `altascapacidades`.`cuestionario`
(
`nombre`)
VALUES
(
	'Cuestionario 5'
);

INSERT INTO `altascapacidades`.`cuestionario`
(
`nombre`)
VALUES
(
	'Cuestionario 6'
);

INSERT INTO `altascapacidades`.`cuestionario`
(
`nombre`)
VALUES
(
	'Cuestionario 7'
);

INSERT INTO `altascapacidades`.`cuestionario`
(
`nombre`)
VALUES
(
	'Cuestionario 8'
);

INSERT INTO `altascapacidades`.`cuestionarios_defecto_rol`
(
`rol_id`,
`cuestionario_id`)
VALUES
(
	1, 1
);

INSERT INTO `altascapacidades`.`cuestionarios_defecto_rol`
(
`rol_id`,
`cuestionario_id`)
VALUES
(
	1, 2
);

INSERT INTO `altascapacidades`.`cuestionarios_defecto_rol`
(
`rol_id`,
`cuestionario_id`)
VALUES
(
	1, 4
);

INSERT INTO `altascapacidades`.`cuestionarios_defecto_rol`
(
`rol_id`,
`cuestionario_id`)
VALUES
(
	1, 5
);

INSERT INTO `altascapacidades`.`cuestionarios_defecto_rol`
(
`rol_id`,
`cuestionario_id`)
VALUES
(
	2, 1
);

INSERT INTO `altascapacidades`.`cuestionarios_defecto_rol`
(
`rol_id`,
`cuestionario_id`)
VALUES
(
	1, 6
);