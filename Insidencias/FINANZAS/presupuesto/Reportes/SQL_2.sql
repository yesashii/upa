
CREATE TABLE "area_presupuestal_aux" (
	"area_ccod" NUMERIC(4,0) NOT NULL,
	"area_tdesc" VARCHAR(300) NULL DEFAULT NULL,
	"audi_tusuario" VARCHAR(300) NULL DEFAULT NULL,
	"audi_fmodificacion" VARCHAR(300) NULL DEFAULT NULL,
	"rut_responsable" NUMERIC(10,0) NULL DEFAULT NULL,
	"nombre_responsable" VARCHAR(150) NULL DEFAULT NULL,
	"rut_completo" VARCHAR(20) NULL DEFAULT NULL,
	"orden" INT NULL DEFAULT NULL,
	PRIMARY KEY ("area_ccod")
)
;
















-- -----------------------------------------







select * from presupuesto_upa.protic.area_presupuestal


-- ---------------------------



select * from area_presupuestal_aux




drop table area_presupuestal_aux