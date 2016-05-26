<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=encuestas_acreditacion.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_empleadores = new CFormulario
f_empleadores.Carga_Parametros "tabla_vacia.xml", "tabla"
f_empleadores.Inicializar conexion
		   
consulta = " select distinct b.carr_tdesc as carrera,nombre_empresa,case tamano_empresa when 1 then 'Grande (100 funcionarios o más)'  when 2 then 'Mediana (entre 31 y 99 funcionarios)' when 3 then 'Pequeña (30 funcionarios o menos)' end as tamano, "& vbCrLf &_
		   " actividad_empresa,cargo_encuestado,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   " case egresado_upa when 1 then 'Sí' when 2 then 'No' else 'no contestada' end as egresado, "& vbCrLf &_
		   " case preg_1 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_1, "& vbCrLf &_
		   " case preg_2 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_2, "& vbCrLf &_
		   " case preg_3 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_3, "& vbCrLf &_
		   " case preg_4 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_4, "& vbCrLf &_
		   " case preg_5 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No cuento con información'  else 'no contestada' end as preg_5, "& vbCrLf &_
		   " case preg_6 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_6, "& vbCrLf &_
		   " case preg_7 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_7, "& vbCrLf &_
		   " case preg_8 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_8, "& vbCrLf &_
		   " case preg_9 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_9, "& vbCrLf &_
		   " case preg_10 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_10, "& vbCrLf &_
		   " case preg_11 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_11, "& vbCrLf &_
		   " case preg_12 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_12, "& vbCrLf &_
		   " case preg_13 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_13, "& vbCrLf &_
		   " case preg_14 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_14, "& vbCrLf &_
		   " case preg_15 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_15, "& vbCrLf &_
		   " case preg_16 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_16, "& vbCrLf &_
		   " case preg_17 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_17, "& vbCrLf &_
		   " case preg_18 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_18, "& vbCrLf &_
		   " case preg_19 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_19, "& vbCrLf &_
		   " preg_20,preg_21,preg_22,preg_23,preg_24,preg_25,preg_26,preg_27,preg_28, "& vbCrLf &_
		   " case preg_29 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_29, "& vbCrLf &_
		   " case preg_30 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_30, "& vbCrLf &_
		   " case preg_31 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_31, "& vbCrLf &_
		   " case preg_32 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_32, "& vbCrLf &_
		   " case preg_33 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_33, "& vbCrLf &_
		   " case preg_341 when 5 then 'Menos de $ 200.000' when 4 then 'Entre $ 200.001 y $ 500.000' when 3 then 'Entre $ 500.001 y $ 1.000.000' when 2 then 'Entre $ 1.000.001 y $ 1.500.000' when 1 then 'Más de $ 1.500.001'  else 'no contestada' end as preg_34_1, "& vbCrLf &_
		   " case preg_342 when 5 then 'Menos de $ 200.000' when 4 then 'Entre $ 200.001 y $ 500.000' when 3 then 'Entre $ 500.001 y $ 1.000.000' when 2 then 'Entre $ 1.000.001 y $ 1.500.000' when 1 then 'Más de $ 1.500.001'  else 'no contestada' end as preg_34_2, "& vbCrLf &_
		   " case preg_343 when 5 then 'Menos de $ 200.000' when 4 then 'Entre $ 200.001 y $ 500.000' when 3 then 'Entre $ 500.001 y $ 1.000.000' when 2 then 'Entre $ 1.000.001 y $ 1.500.000' when 1 then 'Más de $ 1.500.001'  else 'no contestada' end as preg_34_3, "& vbCrLf &_
		   " case preg_344 when 5 then 'Menos de $ 200.000' when 4 then 'Entre $ 200.001 y $ 500.000' when 3 then 'Entre $ 500.001 y $ 1.000.000' when 2 then 'Entre $ 1.000.001 y $ 1.500.000' when 1 then 'Más de $ 1.500.001'  else 'no contestada' end as preg_34_4, "& vbCrLf &_
		   " deficiencias_egresados as deficiencias_limitaciones,caracteristicas_egresados,capacidades_egresados as capacidades_necesarias"& vbCrLf &_
		   " from encuestas_empleadores a, carreras b  where isnull(antiguos,'N')='N' and a.carr_ccod = b.carr_ccod"
           
f_empleadores.Consultar consulta

'---------------------------------------------------encuesta docente--------------------------------
set f_docentes = new CFormulario
f_docentes.Carga_Parametros "tabla_vacia.xml", "tabla"
f_docentes.Inicializar conexion
		   
consulta = " select distinct d.carr_tdesc as carrera, cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tnombre + ' ' +  b.pers_tape_paterno + ' ' + b.pers_tape_materno as nombre, "& vbCrLf &_
		   " c.sexo_tdesc,cast(datediff(year,pers_fnacimiento,getDate()) as varchar) as edad,anos_universidad,protic.obtener_grados_docente(b.pers_ncorr) as grados_docente, "& vbCrLf &_
		   " protic.obtener_titulos_docente(b.pers_ncorr) as titulos_docente,protic.obtener_asignaturas_docente_carrera_anuales (1,a.carr_ccod,b.pers_ncorr,2006) as asignaturas,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   "  case preg_1 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_1, "& vbCrLf &_
		   " case preg_2 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_2, "& vbCrLf &_
		   " case preg_3 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_3, "& vbCrLf &_
		   " case preg_4 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_4, "& vbCrLf &_
		   " case preg_5 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_5, "& vbCrLf &_
		   " case preg_6 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_6, "& vbCrLf &_
		   " case preg_7 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_7, "& vbCrLf &_
		   " case preg_8 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_8, "& vbCrLf &_
		   " case preg_9 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_9, "& vbCrLf &_
		   " case preg_10 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No cuento con información'  else 'no contestada' end as preg_10, "& vbCrLf &_
		   " case preg_11 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_11, "& vbCrLf &_
		   " case preg_12 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_12, "& vbCrLf &_
		   " case preg_13 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_13, "& vbCrLf &_
		   " case preg_14 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_14, "& vbCrLf &_
		   " case preg_15 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_15, "& vbCrLf &_
		   " case preg_16 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_16, "& vbCrLf &_
		   " case preg_17 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_17, "& vbCrLf &_
		   " case preg_18 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_18, "& vbCrLf &_
		   " case preg_19 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_19, "& vbCrLf &_
		   " case preg_20 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_20, "& vbCrLf &_
		   " case preg_21 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_21, "& vbCrLf &_
		   " preg_22,preg_23,preg_24,preg_25,preg_26,preg_27,preg_28,preg_29,preg_30, "& vbCrLf &_
		   " case preg_31 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_31, "& vbCrLf &_
		   " case preg_32 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_32, "& vbCrLf &_
		   " case preg_33 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_33, "& vbCrLf &_
		   " case preg_34 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_34, "& vbCrLf &_
		   " case preg_35 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_35, "& vbCrLf &_
		   " case preg_36 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_36, "& vbCrLf &_
		   " case preg_37 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_37, "& vbCrLf &_
		   " case preg_38 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_38, "& vbCrLf &_
		   " case preg_39 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_39, "& vbCrLf &_
		   " case preg_40 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_40, "& vbCrLf &_
		   " case preg_41 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_41, "& vbCrLf &_
		   " case preg_42 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_42, "& vbCrLf &_
		   " case preg_43 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_43, "& vbCrLf &_
		   " case preg_44 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_44, "& vbCrLf &_
		   " case preg_45 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_45, "& vbCrLf &_
		   " case preg_46 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_46, "& vbCrLf &_
		   " case preg_47 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_47, "& vbCrLf &_
		   " case preg_48 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_48, "& vbCrLf &_
		   " case preg_49 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_49, "& vbCrLf &_
		   " case preg_50 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_50, "& vbCrLf &_
		   " case preg_51 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_51, "& vbCrLf &_
		   " case preg_52 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_52, "& vbCrLf &_
		   " case preg_53 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_53, "& vbCrLf &_
		   " case preg_54 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_54, "& vbCrLf &_
		   " case preg_55 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_55, "& vbCrLf &_
		   " case preg_56 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_56, "& vbCrLf &_
		   " case preg_57 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_57, "& vbCrLf &_
		   " case preg_58 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_58, "& vbCrLf &_
		   " case preg_59 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_59, "& vbCrLf &_
		   " case preg_60 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_60, "& vbCrLf &_
		   " case preg_61 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_61, "& vbCrLf &_
		   " case preg_62 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_62, "& vbCrLf &_
		   " fortalesas_carrera"& vbCrLf &_
		   " from encuestas_docentes a, personas b, sexos c,carreras d"& vbCrLf &_
		   " where a.pers_ncorr = b.pers_ncorr and  isnull(antiguos,'N')='N' and isnull(a.pers_ncorr,0)<>0"& vbCrLf &_
		   " and b.sexo_ccod = c.sexo_ccod and a.carr_ccod = d.carr_ccod " &vbCrlf &_
		   " Union "&vbcrlf &_
		   " select d.carr_tdesc as carrera, 'Anónimo' as rut,'Anónimo' as nombre, "& vbCrLf &_
		   " '--' as sexo_tdesc,'--' as edad,anos_universidad,'--' as grados_docente, "& vbCrLf &_
		   " '--' as titulos_docente,'--' as asignaturas,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   "  case preg_1 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_1, "& vbCrLf &_
		   " case preg_2 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_2, "& vbCrLf &_
		   " case preg_3 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_3, "& vbCrLf &_
		   " case preg_4 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_4, "& vbCrLf &_
		   " case preg_5 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_5, "& vbCrLf &_
		   " case preg_6 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_6, "& vbCrLf &_
		   " case preg_7 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_7, "& vbCrLf &_
		   " case preg_8 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_8, "& vbCrLf &_
		   " case preg_9 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_9, "& vbCrLf &_
		   " case preg_10 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No cuento con información'  else 'no contestada' end as preg_10, "& vbCrLf &_
		   " case preg_11 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_11, "& vbCrLf &_
		   " case preg_12 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_12, "& vbCrLf &_
		   " case preg_13 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_13, "& vbCrLf &_
		   " case preg_14 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_14, "& vbCrLf &_
		   " case preg_15 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_15, "& vbCrLf &_
		   " case preg_16 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_16, "& vbCrLf &_
		   " case preg_17 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_17, "& vbCrLf &_
		   " case preg_18 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_18, "& vbCrLf &_
		   " case preg_19 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_19, "& vbCrLf &_
		   " case preg_20 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_20, "& vbCrLf &_
		   " case preg_21 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_21, "& vbCrLf &_
		   " preg_22,preg_23,preg_24,preg_25,preg_26,preg_27,preg_28,preg_29,preg_30, "& vbCrLf &_
		   " case preg_31 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_31, "& vbCrLf &_
		   " case preg_32 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_32, "& vbCrLf &_
		   " case preg_33 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_33, "& vbCrLf &_
		   " case preg_34 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_34, "& vbCrLf &_
		   " case preg_35 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_35, "& vbCrLf &_
		   " case preg_36 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_36, "& vbCrLf &_
		   " case preg_37 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_37, "& vbCrLf &_
		   " case preg_38 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_38, "& vbCrLf &_
		   " case preg_39 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_39, "& vbCrLf &_
		   " case preg_40 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_40, "& vbCrLf &_
		   " case preg_41 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_41, "& vbCrLf &_
		   " case preg_42 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_42, "& vbCrLf &_
		   " case preg_43 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_43, "& vbCrLf &_
		   " case preg_44 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_44, "& vbCrLf &_
		   " case preg_45 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_45, "& vbCrLf &_
		   " case preg_46 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_46, "& vbCrLf &_
		   " case preg_47 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_47, "& vbCrLf &_
		   " case preg_48 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_48, "& vbCrLf &_
		   " case preg_49 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_49, "& vbCrLf &_
		   " case preg_50 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_50, "& vbCrLf &_
		   " case preg_51 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_51, "& vbCrLf &_
		   " case preg_52 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_52, "& vbCrLf &_
		   " case preg_53 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_53, "& vbCrLf &_
		   " case preg_54 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_54, "& vbCrLf &_
		   " case preg_55 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_55, "& vbCrLf &_
		   " case preg_56 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_56, "& vbCrLf &_
		   " case preg_57 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_57, "& vbCrLf &_
		   " case preg_58 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_58, "& vbCrLf &_
		   " case preg_59 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_59, "& vbCrLf &_
		   " case preg_60 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_60, "& vbCrLf &_
		   " case preg_61 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_61, "& vbCrLf &_
		   " case preg_62 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_62, "& vbCrLf &_
		   " fortalesas_carrera"& vbCrLf &_
		   " from encuestas_docentes a,carreras d"& vbCrLf &_
		   " where  isnull(antiguos,'N')='N' and isnull(a.pers_ncorr,0)=0 "& vbCrLf &_
		   " and a.carr_ccod = d.carr_ccod "

           
f_docentes.Consultar consulta


'---------------------------------------------------encuesta Egresados--------------------------------
set f_egresados = new CFormulario
f_egresados.Carga_Parametros "tabla_vacia.xml", "tabla"
f_egresados.Inicializar conexion
		   
consulta = " select  distinct c.carr_tdesc as carrera,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,b.pers_tnombre + ' ' +  b.pers_tape_paterno + ' ' + b.pers_tape_materno as nombre, "& vbCrLf &_
		   " case sexo when 1 then 'Femenino' when '2' then 'Masculino' end as sexo,edad_alumno, case condicion_egreso when 1 then 'Egresado' else 'No clickeado' end as egresado, "& vbCrLf &_
		   " case condicion_titulado when 1 then 'Titulado' else 'No clickeado' end as titulado,ano_inicio,ano_final, "& vbCrLf &_
		   " case trabajando when 1 then 'Sí' else 'No' end as trabajando,case tiempo_demora when 5 then 'Menos de 2 meses' when 4 then 'Entre 2 meses y 6 meses' when 3 then 'Entre 6 meses y 1 año' when 2 then 'Más de 1 año' when 1 then 'No he encontrado trabajo' end as tiempo_demora, "& vbCrLf &_
		   " case renta_promedio when 5 then 'Menos de $200.000' when 4 then 'Entre $200.001 y $500.000' when 3 then 'Entre $500.001 y 1.000.000' when 2 then 'Entre $1.000.001 y $1.500.000' when 1 then 'Más de $1.500.001' end as renta_promedio, "& vbCrLf &_
		   " nombre_empresa,case tamano_empresa when 1 then 'Grande (100 funcionarios o más)'  when 2 then 'Mediana (entre 31 y 99 funcionarios)' when 3 then 'Pequeña (30 funcionarios o menos)' end as tamano, "& vbCrLf &_
		   " caracteristica_empresa,case rol_alumno when 1 then 'Jefatura'  when 2 then 'Empleado(a)' when 3 then 'Independiente' end as rol, "& vbCrLf &_
		   " cargo_empresa,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   " case preg_1 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_1, "& vbCrLf &_
		   " case preg_2 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_2, "& vbCrLf &_
		   " case preg_3 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_3, "& vbCrLf &_
		   " case preg_4 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_4, "& vbCrLf &_
		   " case preg_5 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_5, "& vbCrLf &_
		   " case preg_6 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_6, "& vbCrLf &_
		   " case preg_7 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_7, "& vbCrLf &_
		   " case preg_8 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_8, "& vbCrLf &_
		   " case preg_9 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_9, "& vbCrLf &_
		   " case preg_10 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'  else 'no contestada' end as preg_10, "& vbCrLf &_
		   " case preg_11 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_11, "& vbCrLf &_
		   " case preg_12 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_12, "& vbCrLf &_
		   " case preg_13 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_13, "& vbCrLf &_
		   " case preg_14 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_14, "& vbCrLf &_
		   " case preg_15 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_15, "& vbCrLf &_
		   " case preg_16 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_16, "& vbCrLf &_
		   " case preg_17 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_17, "& vbCrLf &_
		   " case preg_18 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_18, "& vbCrLf &_
		   " case preg_19 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_19,"& vbCrLf &_
		   " case preg_20 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_20, "& vbCrLf &_
		   " case preg_21 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_21, "& vbCrLf &_
		   " case preg_22 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_22, "& vbCrLf &_
		   " case preg_23 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_23, "& vbCrLf &_
		   " case preg_24 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_24,"& vbCrLf &_
		   " preg_25,preg_26,preg_27,preg_28,preg_29,preg_30,preg_31,preg_32,preg_33, "& vbCrLf &_
		   " case preg_34 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_34, "& vbCrLf &_
		   " case preg_35 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_35, "& vbCrLf &_
		   " case preg_36 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_36, "& vbCrLf &_
		   " case preg_37 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_37, "& vbCrLf &_
		   " case preg_38 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_38, "& vbCrLf &_
		   " case preg_39 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_39, "& vbCrLf &_
		   " case preg_40 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_40, "& vbCrLf &_
		   " case preg_41 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_41, "& vbCrLf &_
		   " case preg_42 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_42, "& vbCrLf &_
		   " case preg_43 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_43, "& vbCrLf &_
		   " case preg_44 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_44, "& vbCrLf &_
		   " case preg_45 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_45, "& vbCrLf &_
		   " case preg_46 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_46, "& vbCrLf &_
		   " case preg_47 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_47, "& vbCrLf &_
		   " case preg_48 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_48, "& vbCrLf &_
		   " case preg_49 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_49, "& vbCrLf &_
		   " case preg_50 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_50, "& vbCrLf &_
		   " case preg_51 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_51, "& vbCrLf &_
		   " case preg_52 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_52, "& vbCrLf &_
		   " case preg_53 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_53, "& vbCrLf &_
		   " case preg_54 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_54, "& vbCrLf &_
		   " case preg_55 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_55, "& vbCrLf &_
		   " case preg_56 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_56, "& vbCrLf &_
		   " case preg_57 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_57, "& vbCrLf &_
		   " case preg_58 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_58, "& vbCrLf &_
		   " case preg_59 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_59, "& vbCrLf &_
		   " case preg_60 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_60, "& vbCrLf &_
		   " contenidos_faltantes,sugerencias_autoridades,sugerencias_carrera"& vbCrLf &_
		   " from encuestas_egresados a, personas b,carreras c "& vbCrLf &_
		   " where a.pers_ncorr = b.pers_ncorr and isnull(antiguos,'N')='N' and a.carr_ccod=c.carr_ccod and isnull(a.pers_ncorr,0)<>0"&vbCrlf &_
		   " Union "&vbcrlf &_
           " select  c.carr_tdesc as carrera,'Anónimo' as rut,'Anónimo' as nombre, "& vbCrLf &_
		   " case sexo when 1 then 'Femenino' when '2' then 'Masculino' end as sexo,edad_alumno, case condicion_egreso when 1 then 'Egresado' else 'No clickeado' end as egresado, "& vbCrLf &_
		   " case condicion_titulado when 1 then 'Titulado' else 'No clickeado' end as titulado,ano_inicio,ano_final, "& vbCrLf &_
		   " case trabajando when 1 then 'Sí' else 'No' end as trabajando,case tiempo_demora when 5 then 'Menos de 2 meses' when 4 then 'Entre 2 meses y 6 meses' when 3 then 'Entre 6 meses y 1 año' when 2 then 'Más de 1 año' when 1 then 'No he encontrado trabajo' end as tiempo_demora, "& vbCrLf &_
		   " case renta_promedio when 5 then 'Menos de $200.000' when 4 then 'Entre $200.001 y $500.000' when 3 then 'Entre $500.001 y 1.000.000' when 2 then 'Entre $1.000.001 y $1.500.000' when 1 then 'Más de $1.500.001' end as renta_promedio, "& vbCrLf &_
		   " nombre_empresa,case tamano_empresa when 1 then 'Grande (100 funcionarios o más)'  when 2 then 'Mediana (entre 31 y 99 funcionarios)' when 3 then 'Pequeña (30 funcionarios o menos)' end as tamano, "& vbCrLf &_
		   " caracteristica_empresa,case rol_alumno when 1 then 'Jefatura'  when 2 then 'Empleado(a)' when 3 then 'Independiente' end as rol, "& vbCrLf &_
		   " cargo_empresa,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   " case preg_1 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_1, "& vbCrLf &_
		   " case preg_2 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_2, "& vbCrLf &_
		   " case preg_3 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_3, "& vbCrLf &_
		   " case preg_4 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_4, "& vbCrLf &_
		   " case preg_5 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_5, "& vbCrLf &_
		   " case preg_6 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_6, "& vbCrLf &_
		   " case preg_7 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_7, "& vbCrLf &_
		   " case preg_8 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_8, "& vbCrLf &_
		   " case preg_9 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_9, "& vbCrLf &_
		   " case preg_10 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'  else 'no contestada' end as preg_10, "& vbCrLf &_
		   " case preg_11 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_11, "& vbCrLf &_
		   " case preg_12 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_12, "& vbCrLf &_
		   " case preg_13 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_13, "& vbCrLf &_
		   " case preg_14 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_14, "& vbCrLf &_
		   " case preg_15 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_15, "& vbCrLf &_
		   " case preg_16 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_16, "& vbCrLf &_
		   " case preg_17 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_17, "& vbCrLf &_
		   " case preg_18 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_18, "& vbCrLf &_
		   " case preg_19 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_19,"& vbCrLf &_
		   " case preg_20 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_20, "& vbCrLf &_
		   " case preg_21 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_21, "& vbCrLf &_
		   " case preg_22 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_22, "& vbCrLf &_
		   " case preg_23 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_23, "& vbCrLf &_
		   " case preg_24 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_24,"& vbCrLf &_
		   " preg_25,preg_26,preg_27,preg_28,preg_29,preg_30,preg_31,preg_32,preg_33, "& vbCrLf &_
		   " case preg_34 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_34, "& vbCrLf &_
		   " case preg_35 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_35, "& vbCrLf &_
		   " case preg_36 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_36, "& vbCrLf &_
		   " case preg_37 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_37, "& vbCrLf &_
		   " case preg_38 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_38, "& vbCrLf &_
		   " case preg_39 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_39, "& vbCrLf &_
		   " case preg_40 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_40, "& vbCrLf &_
		   " case preg_41 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_41, "& vbCrLf &_
		   " case preg_42 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_42, "& vbCrLf &_
		   " case preg_43 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_43, "& vbCrLf &_
		   " case preg_44 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_44, "& vbCrLf &_
		   " case preg_45 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_45, "& vbCrLf &_
		   " case preg_46 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_46, "& vbCrLf &_
		   " case preg_47 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_47, "& vbCrLf &_
		   " case preg_48 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_48, "& vbCrLf &_
		   " case preg_49 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_49, "& vbCrLf &_
		   " case preg_50 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_50, "& vbCrLf &_
		   " case preg_51 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_51, "& vbCrLf &_
		   " case preg_52 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_52, "& vbCrLf &_
		   " case preg_53 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_53, "& vbCrLf &_
		   " case preg_54 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_54, "& vbCrLf &_
		   " case preg_55 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_55, "& vbCrLf &_
		   " case preg_56 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_56, "& vbCrLf &_
		   " case preg_57 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_57, "& vbCrLf &_
		   " case preg_58 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_58, "& vbCrLf &_
		   " case preg_59 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_59, "& vbCrLf &_
		   " case preg_60 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_60, "& vbCrLf &_
		   " contenidos_faltantes,sugerencias_autoridades,sugerencias_carrera"& vbCrLf &_
		   " from encuestas_egresados a,carreras c "& vbCrLf &_
		   " where isnull(antiguos,'N')='N' and a.carr_ccod=c.carr_ccod and isnull(a.pers_ncorr,0)=0"
		   
f_egresados.Consultar consulta
'response.Write("<pre>"&consulta&"</pre>")
'response.End()


'---------------------------------------------------encuesta Alumnos--------------------------------
set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumnos.Inicializar conexion
		   
consulta = " select distinct c.carr_tdesc as carrera,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_tnombre + ' ' +  b.pers_tape_paterno + ' ' + b.pers_tape_materno as nombre, "& vbCrLf &_
		   " case sexo when 1 then 'Femenino' when '2' then 'Masculino' end as sexo,edad_alumno,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   " case preg_1 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_1, "& vbCrLf &_
		   " case preg_2 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_2, "& vbCrLf &_
		   " case preg_3 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_3, "& vbCrLf &_
		   " case preg_4 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_4, "& vbCrLf &_
		   " case preg_5 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_5, "& vbCrLf &_
		   " case preg_6 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_6, "& vbCrLf &_
		   " case preg_7 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_7, "& vbCrLf &_
		   " case preg_8 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_8, "& vbCrLf &_
		   " case preg_9 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_9, "& vbCrLf &_
		   " case preg_10 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'  else 'no contestada' end as preg_10, "& vbCrLf &_
		   " case preg_11 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_11, "& vbCrLf &_
		   " case preg_12 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_12, "& vbCrLf &_
 		   " case preg_13 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_13, "& vbCrLf &_
		   " case preg_14 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_14, "& vbCrLf &_
		   " case preg_15 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_15, "& vbCrLf &_
		   " case preg_16 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_16, "& vbCrLf &_
		   " case preg_17 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_17, "& vbCrLf &_
		   " case preg_18 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_18,"& vbCrLf &_
		   " case preg_19 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_19, "& vbCrLf &_
		   " case preg_20 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_20, "& vbCrLf &_
		   " case preg_21 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_21, "& vbCrLf &_
		   " case preg_22 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_22, "& vbCrLf &_
		   " case preg_23 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_23, "& vbCrLf &_
		   " case preg_24 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_24, "& vbCrLf &_
		   " case preg_25 when 1 then 'Sí' when 0 then 'No' else 'no contestada' end as preg_25, "& vbCrLf &_
		   " case preg_26 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_26, "& vbCrLf &_
		   " case preg_27 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_27, "& vbCrLf &_
		   " case preg_28 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_28, "& vbCrLf &_
		   " case preg_29 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_29, "& vbCrLf &_
		   " case preg_30 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'  else 'no contestada' end as preg_30, "& vbCrLf &_
		   " case preg_31 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_31, "& vbCrLf &_
		   " case preg_32 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_32, "& vbCrLf &_
		   " case preg_33 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_33, "& vbCrLf &_
		   " case preg_34 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_34, "& vbCrLf &_
		   " case preg_35 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'  else 'no contestada' end as preg_35, "& vbCrLf &_
		   " case preg_36 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_36, "& vbCrLf &_
		   " preg_37,preg_38,preg_39,preg_40,preg_41,preg_42,preg_43,preg_44,preg_45, "& vbCrLf &_
		   " case preg_46 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_46,"& vbCrLf &_
		   " case preg_47 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_47, "& vbCrLf &_
		   " case preg_48 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_48, "& vbCrLf &_
		   " case preg_49 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_49,"& vbCrLf &_
		   " case preg_50 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_50, "& vbCrLf &_
		   " case preg_51 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_51, "& vbCrLf &_
		   " case preg_52 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_52, "& vbCrLf &_
		   " case preg_53 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_53, "& vbCrLf &_
		   " case preg_54 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_54, "& vbCrLf &_
		   " case preg_55 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_55, "& vbCrLf &_
		   " case preg_56 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_56, "& vbCrLf &_
		   " case preg_57 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_57, "& vbCrLf &_
   		   " case preg_58 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_58,"& vbCrLf &_
 		   " case preg_59 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_59,"& vbCrLf &_
		   " case preg_60 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_60, "& vbCrLf &_
		   " case preg_61 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_61, "& vbCrLf &_
		   " case preg_62 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_62, "& vbCrLf &_
		   " case preg_63 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_63, "& vbCrLf &_
		   " case preg_64 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_64, "& vbCrLf &_
		   " case preg_65 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_65, "& vbCrLf &_
		   " case preg_66 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_66, "& vbCrLf &_
		   " case preg_67 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_67, "& vbCrLf &_
		   " case preg_68 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_68, "& vbCrLf &_
		   " case preg_69 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_69, "& vbCrLf &_
		   " case preg_70 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_70, "& vbCrLf &_
		   " case preg_71 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_71, "& vbCrLf &_
		   " case preg_72 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_72, "& vbCrLf &_
		   " case preg_73 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_73, "& vbCrLf &_
		   " case preg_74 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_74, "& vbCrLf &_
		   " case preg_75 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_75, "& vbCrLf &_
		   " case preg_76 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_76, "& vbCrLf &_
		   " sugerencias_carrera "& vbCrLf &_
		   " from encuestas_alumnos a, personas b,carreras c  "& vbCrLf &_
		   " where a.pers_ncorr = b.pers_ncorr and isnull(antiguos,'N')='N' and a.carr_ccod=c.carr_ccod and isnull(a.pers_ncorr,0)<>0"&vbCrlf &_
		   " Union"&vbcrlf &_
		   " select c.carr_tdesc as carrera,'Anónimo' as rut, 'Anónimo' as nombre, "& vbCrLf &_
		   " case sexo when 1 then 'Femenino' when '2' then 'Masculino' end as sexo,edad_alumno,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   " case preg_1 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_1, "& vbCrLf &_
		   " case preg_2 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_2, "& vbCrLf &_
		   " case preg_3 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_3, "& vbCrLf &_
		   " case preg_4 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_4, "& vbCrLf &_
		   " case preg_5 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_5, "& vbCrLf &_
		   " case preg_6 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_6, "& vbCrLf &_
		   " case preg_7 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_7, "& vbCrLf &_
		   " case preg_8 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_8, "& vbCrLf &_
		   " case preg_9 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_9, "& vbCrLf &_
		   " case preg_10 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'  else 'no contestada' end as preg_10, "& vbCrLf &_
		   " case preg_11 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_11, "& vbCrLf &_
		   " case preg_12 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_12, "& vbCrLf &_
 		   " case preg_13 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_13, "& vbCrLf &_
		   " case preg_14 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_14, "& vbCrLf &_
		   " case preg_15 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_15, "& vbCrLf &_
		   " case preg_16 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_16, "& vbCrLf &_
		   " case preg_17 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_17, "& vbCrLf &_
		   " case preg_18 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_18,"& vbCrLf &_
		   " case preg_19 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_19, "& vbCrLf &_
		   " case preg_20 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_20, "& vbCrLf &_
		   " case preg_21 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_21, "& vbCrLf &_
		   " case preg_22 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_22, "& vbCrLf &_
		   " case preg_23 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_23, "& vbCrLf &_
		   " case preg_24 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_24, "& vbCrLf &_
		   " case preg_25 when 1 then 'Sí' when 0 then 'No' else 'no contestada' end as preg_25, "& vbCrLf &_
		   " case preg_26 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_26, "& vbCrLf &_
		   " case preg_27 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_27, "& vbCrLf &_
		   " case preg_28 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_28, "& vbCrLf &_
		   " case preg_29 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_29, "& vbCrLf &_
		   " case preg_30 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'  else 'no contestada' end as preg_30, "& vbCrLf &_
		   " case preg_31 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_31, "& vbCrLf &_
		   " case preg_32 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_32, "& vbCrLf &_
		   " case preg_33 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_33, "& vbCrLf &_
		   " case preg_34 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_34, "& vbCrLf &_
		   " case preg_35 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'  else 'no contestada' end as preg_35, "& vbCrLf &_
		   " case preg_36 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_36, "& vbCrLf &_
		   " preg_37,preg_38,preg_39,preg_40,preg_41,preg_42,preg_43,preg_44,preg_45, "& vbCrLf &_
		   " case preg_46 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_46,"& vbCrLf &_
		   " case preg_47 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_47, "& vbCrLf &_
		   " case preg_48 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_48, "& vbCrLf &_
		   " case preg_49 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_49,"& vbCrLf &_
		   " case preg_50 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_50, "& vbCrLf &_
		   " case preg_51 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_51, "& vbCrLf &_
		   " case preg_52 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_52, "& vbCrLf &_
		   " case preg_53 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_53, "& vbCrLf &_
		   " case preg_54 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_54, "& vbCrLf &_
		   " case preg_55 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_55, "& vbCrLf &_
		   " case preg_56 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_56, "& vbCrLf &_
		   " case preg_57 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_57, "& vbCrLf &_
   		   " case preg_58 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_58,"& vbCrLf &_
 		   " case preg_59 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_59,"& vbCrLf &_
		   " case preg_60 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_60, "& vbCrLf &_
		   " case preg_61 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_61, "& vbCrLf &_
		   " case preg_62 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_62, "& vbCrLf &_
		   " case preg_63 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_63, "& vbCrLf &_
		   " case preg_64 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_64, "& vbCrLf &_
		   " case preg_65 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo' when 0 then 'No utilizo'  else 'no contestada' end as preg_65, "& vbCrLf &_
		   " case preg_66 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_66, "& vbCrLf &_
		   " case preg_67 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_67, "& vbCrLf &_
		   " case preg_68 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_68, "& vbCrLf &_
		   " case preg_69 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_69, "& vbCrLf &_
		   " case preg_70 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_70, "& vbCrLf &_
		   " case preg_71 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_71, "& vbCrLf &_
		   " case preg_72 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_72, "& vbCrLf &_
		   " case preg_73 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_73, "& vbCrLf &_
		   " case preg_74 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_74, "& vbCrLf &_
		   " case preg_75 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_75, "& vbCrLf &_
		   " case preg_76 when 4 then 'Muy de acuerdo' when 3 then 'De acuerdo' when 2 then 'En desacuerdo' when 1 then 'Muy en desacuerdo'   else 'no contestada' end as preg_76, "& vbCrLf &_
		   " sugerencias_carrera "& vbCrLf &_
		   " from encuestas_alumnos a, carreras c  "& vbCrLf &_
		   " where isnull(antiguos,'N')='N' and a.carr_ccod=c.carr_ccod and isnull(a.pers_ncorr,0)=0"
           
f_alumnos.Consultar consulta
'response.Write("<pre>"&consulta&"</pre>")
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
%>
<html>
<head>
<title>Resultados Parciales Encuesta Acreditación</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Resultados Parciales Encuesta de Acreditación</font></div>
	</td>
 </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=fecha%> </td>
  </tr>
  <tr> 
    <td width="16%">&nbsp;</td>
    <td width="84%" colspan="3">&nbsp;</td>
  </tr>
</table>
 <p>&nbsp;</p>
 <table width="100%" border="1">
  <tr><td colspan="3" bgcolor="#CCFFCC"><font size="+1"><strong>Encuesta Empleadores</strong></font></td>
      <td colspan="44" bgcolor="#CCFFCC">&nbsp;</td>
  </tr>
  <tr> 
    <td><div align="center"><strong>fila</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>Nombre Empresa</strong></div></td>
    <td><div align="center"><strong>Tamaño Empresa</strong></div></td>
	<td><div align="center"><strong>Actividad</strong></div></td>
    <td><div align="center"><strong>Cargo Encuestado</strong></div></td>
	<td><div align="center"><strong>Fecha</strong></div></td>
	<td><div align="center"><strong>Egresado UPA</strong></div></td>
	<td><div align="center"><strong>Pregunta 1</strong></div></td>
	<td><div align="center"><strong>Pregunta 2</strong></div></td>
	<td><div align="center"><strong>Pregunta 3</strong></div></td>
	<td><div align="center"><strong>Pregunta 4</strong></div></td>
	<td><div align="center"><strong>Pregunta 5</strong></div></td>
	<td><div align="center"><strong>Pregunta 6</strong></div></td>
	<td><div align="center"><strong>Pregunta 7</strong></div></td>
	<td><div align="center"><strong>Pregunta 8</strong></div></td>
	<td><div align="center"><strong>Pregunta 9</strong></div></td>
	<td><div align="center"><strong>Pregunta 10</strong></div></td>
	<td><div align="center"><strong>Pregunta 11</strong></div></td>
	<td><div align="center"><strong>Pregunta 12</strong></div></td>
	<td><div align="center"><strong>Pregunta 13</strong></div></td>
	<td><div align="center"><strong>Pregunta 14</strong></div></td>
	<td><div align="center"><strong>Pregunta 15</strong></div></td>
	<td><div align="center"><strong>Pregunta 16</strong></div></td>
	<td><div align="center"><strong>Pregunta 17</strong></div></td>
	<td><div align="center"><strong>Pregunta 18</strong></div></td>
	<td><div align="center"><strong>Pregunta 19</strong></div></td>
	<td><div align="center"><strong>Pregunta 20</strong></div></td>
	<td><div align="center"><strong>Pregunta 21</strong></div></td>
	<td><div align="center"><strong>Pregunta 22</strong></div></td>
	<td><div align="center"><strong>Pregunta 23</strong></div></td>
	<td><div align="center"><strong>Pregunta 24</strong></div></td>
	<td><div align="center"><strong>Pregunta 25</strong></div></td>
	<td><div align="center"><strong>Pregunta 26</strong></div></td>
	<td><div align="center"><strong>Pregunta 27</strong></div></td>
	<td><div align="center"><strong>Pregunta 28</strong></div></td>
	<td><div align="center"><strong>Pregunta 29</strong></div></td>
	<td><div align="center"><strong>Pregunta 30</strong></div></td>
	<td><div align="center"><strong>Pregunta 31</strong></div></td>
	<td><div align="center"><strong>Pregunta 32</strong></div></td>
	<td><div align="center"><strong>Pregunta 33</strong></div></td>
	<td><div align="center"><strong>Pregunta 34.1</strong></div></td>
	<td><div align="center"><strong>Pregunta 34.2</strong></div></td>
	<td><div align="center"><strong>Pregunta 34.3</strong></div></td>
	<td><div align="center"><strong>Pregunta 34.4</strong></div></td>
	<td><div align="left"><strong>35. Señale a continuación las deficiencias y limitaciones profesionales que usted observa en los egresados de la Universidad del Pacífico y que le parece importante que la carrera enfrente.</strong></div></td>
	<td><div align="left"><strong>36. Señale las características que UD. reconoce en el egresado de la Universidad del Pacífico.</strong></div></td>
	<td><div align="left"><strong>37. Señale a continuación las características y capacidades que debería tener un profesional de la carrera, para que le resultara útil a su organización.</strong></div></td>
  </tr>
  <% fila = 1  
    while f_empleadores.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=f_empleadores.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_empleadores.ObtenerValor("nombre_empresa")%></div></td>
    <td><div align="left"><%=f_empleadores.ObtenerValor("tamano")%></div></td>
    <td><div align="left"><%=f_empleadores.ObtenerValor("actividad_empresa")%></div></td>
    <td><div align="left"><%=f_empleadores.ObtenerValor("cargo_encuestado")%></div></td>
	<td><div align="left"><%=f_empleadores.ObtenerValor("fecha")%></div></td>
	<td><div align="left"><%=f_empleadores.ObtenerValor("egresado")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_1")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_2")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_3")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_4")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_5")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_6")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_7")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_8")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_9")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_10")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_11")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_12")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_13")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_14")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_15")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_16")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_17")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_18")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_19")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_20")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_21")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_22")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_23")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_24")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_25")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_26")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_27")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_28")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_29")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_30")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_31")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_32")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_33")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_34_1")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_34_2")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_34_3")%></div></td>
	<td><div align="center"><%=f_empleadores.ObtenerValor("preg_34_4")%></div></td>
	<td><div align="left"><%=f_empleadores.ObtenerValor("deficiencias_limitaciones")%></div></td>
	<td><div align="left"><%=f_empleadores.ObtenerValor("caracteristicas_egresados")%></div></td>
	<td><div align="left"><%=f_empleadores.ObtenerValor("capacidades_necesarias")%></div></td>
  </tr>
  <% fila = fila + 1 
     wend %>
  <tr><td colspan="3">&nbsp;</td>
      <td colspan="44">&nbsp;</td>
  </tr>
</table>
<p>&nbsp;</p>
 <table width="100%" border="1">
  <tr><td colspan="5" bgcolor="#CCFFCC"><font size="+1"><strong>Encuesta Docentes</strong></font></td>
      <td colspan="69" bgcolor="#CCFFCC">&nbsp;</td>
  </tr>
  <tr> 
    <td><div align="center"><strong>fila</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>RUT</strong></div></td>
    <td><div align="center"><strong>Nombre</strong></div></td>
	<td><div align="center"><strong>Sexo</strong></div></td>
    <td><div align="center"><strong>Edad</strong></div></td>
	<td><div align="center"><strong>Años Universidad</strong></div></td>
	<td><div align="center"><strong>Grados Académicos</strong></div></td>
	<td><div align="center"><strong>Títulos</strong></div></td>
	<td><div align="center"><strong>Asignaturas</strong></div></td>
	<td><div align="center"><strong>Fecha</strong></div></td>
	<td><div align="center"><strong>Pregunta 1</strong></div></td>
	<td><div align="center"><strong>Pregunta 2</strong></div></td>
	<td><div align="center"><strong>Pregunta 3</strong></div></td>
	<td><div align="center"><strong>Pregunta 4</strong></div></td>
	<td><div align="center"><strong>Pregunta 5</strong></div></td>
	<td><div align="center"><strong>Pregunta 6</strong></div></td>
	<td><div align="center"><strong>Pregunta 7</strong></div></td>
	<td><div align="center"><strong>Pregunta 8</strong></div></td>
	<td><div align="center"><strong>Pregunta 9</strong></div></td>
	<td><div align="center"><strong>Pregunta 10</strong></div></td>
	<td><div align="center"><strong>Pregunta 11</strong></div></td>
	<td><div align="center"><strong>Pregunta 12</strong></div></td>
	<td><div align="center"><strong>Pregunta 13</strong></div></td>
	<td><div align="center"><strong>Pregunta 14</strong></div></td>
	<td><div align="center"><strong>Pregunta 15</strong></div></td>
	<td><div align="center"><strong>Pregunta 16</strong></div></td>
	<td><div align="center"><strong>Pregunta 17</strong></div></td>
	<td><div align="center"><strong>Pregunta 18</strong></div></td>
	<td><div align="center"><strong>Pregunta 19</strong></div></td>
	<td><div align="center"><strong>Pregunta 20</strong></div></td>
	<td><div align="center"><strong>Pregunta 21</strong></div></td>
	<td><div align="center"><strong>Pregunta 22</strong></div></td>
	<td><div align="center"><strong>Pregunta 23</strong></div></td>
	<td><div align="center"><strong>Pregunta 24</strong></div></td>
	<td><div align="center"><strong>Pregunta 25</strong></div></td>
	<td><div align="center"><strong>Pregunta 26</strong></div></td>
	<td><div align="center"><strong>Pregunta 27</strong></div></td>
	<td><div align="center"><strong>Pregunta 28</strong></div></td>
	<td><div align="center"><strong>Pregunta 29</strong></div></td>
	<td><div align="center"><strong>Pregunta 30</strong></div></td>
	<td><div align="center"><strong>Pregunta 31</strong></div></td>
	<td><div align="center"><strong>Pregunta 32</strong></div></td>
	<td><div align="center"><strong>Pregunta 33</strong></div></td>
	<td><div align="center"><strong>Pregunta 34</strong></div></td>
	<td><div align="center"><strong>Pregunta 35</strong></div></td>
	<td><div align="center"><strong>Pregunta 36</strong></div></td>
	<td><div align="center"><strong>Pregunta 37</strong></div></td>
	<td><div align="center"><strong>Pregunta 38</strong></div></td>
	<td><div align="center"><strong>Pregunta 39</strong></div></td>
	<td><div align="center"><strong>Pregunta 40</strong></div></td>
	<td><div align="center"><strong>Pregunta 41</strong></div></td>
	<td><div align="center"><strong>Pregunta 42</strong></div></td>
	<td><div align="center"><strong>Pregunta 43</strong></div></td>
	<td><div align="center"><strong>Pregunta 44</strong></div></td>
	<td><div align="center"><strong>Pregunta 45</strong></div></td>
	<td><div align="center"><strong>Pregunta 46</strong></div></td>
	<td><div align="center"><strong>Pregunta 47</strong></div></td>
	<td><div align="center"><strong>Pregunta 48</strong></div></td>
	<td><div align="center"><strong>Pregunta 49</strong></div></td>
	<td><div align="center"><strong>Pregunta 50</strong></div></td>
	<td><div align="center"><strong>Pregunta 51</strong></div></td>
	<td><div align="center"><strong>Pregunta 52</strong></div></td>
	<td><div align="center"><strong>Pregunta 53</strong></div></td>
	<td><div align="center"><strong>Pregunta 54</strong></div></td>
	<td><div align="center"><strong>Pregunta 55</strong></div></td>
	<td><div align="center"><strong>Pregunta 56</strong></div></td>
	<td><div align="center"><strong>Pregunta 57</strong></div></td>
	<td><div align="center"><strong>Pregunta 58</strong></div></td>
	<td><div align="center"><strong>Pregunta 59</strong></div></td>
	<td><div align="center"><strong>Pregunta 60</strong></div></td>
	<td><div align="center"><strong>Pregunta 61</strong></div></td>
	<td><div align="center"><strong>Pregunta 62</strong></div></td>
	<td><div align="left"><strong>63. Señale a continuación sugerencias o comentarios referidos a las fortalezas y/o debilidades de la carrera o institución, que le gustaría destacar:</strong></div></td>
  </tr>
  <% fila = 1  
    while f_docentes.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("sexo_tdesc")%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("edad")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("anos_universidad")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("grados_docente")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("titulos_docente")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("asignaturas")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("fecha")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_1")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_2")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_3")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_4")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_5")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_6")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_7")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_8")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_9")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_10")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_11")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_12")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_13")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_14")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_15")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_16")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_17")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_18")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_19")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_20")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_21")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_22")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_23")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_24")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_25")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_26")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_27")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_28")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_29")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_30")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_31")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_32")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_33")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_34")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_35")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_36")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_37")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_38")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_39")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_40")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_41")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_42")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_43")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_44")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_45")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_46")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_47")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_48")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_49")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_50")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_51")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_52")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_53")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_54")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_55")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_56")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_57")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_58")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_59")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_60")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_61")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("preg_62")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("Fortalesas_carrera")%></div></td>
  </tr>
  <% fila = fila + 1 
     wend %>
  <tr><td colspan="5">&nbsp;</td>
      <td colspan="69">&nbsp;</td>
  </tr>
</table>
<p>&nbsp;</p>
 <table width="100%" border="1">
  <tr><td colspan="9" bgcolor="#CCFFCC"><font size="+1"><strong>Encuesta Alumnos Egresados</strong></font></td>
      <td colspan="71" bgcolor="#CCFFCC">&nbsp;</td>
  </tr>
  <tr> 
    <td><div align="center"><strong>fila</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>RUT</strong></div></td>
    <td><div align="center"><strong>Nombre</strong></div></td>
	<td><div align="center"><strong>Sexo</strong></div></td>
    <td><div align="center"><strong>Edad</strong></div></td>
	<td><div align="center"><strong>Egresado</strong></div></td>
	<td><div align="center"><strong>Titulado</strong></div></td>
	<td><div align="center"><strong>Año Ingreso</strong></div></td>
	<td><div align="center"><strong>Año Término</strong></div></td>
	<td><div align="center"><strong>Trabajando</strong></div></td>
	<td><div align="center"><strong>tiempo en conseguir trabajo</strong></div></td>
	<td><div align="center"><strong>Renta Promedio</strong></div></td>
	<td><div align="center"><strong>Nombre Empresa</strong></div></td>
	<td><div align="center"><strong>Tamaño</strong></div></td>
	<td><div align="center"><strong>Actividad</strong></div></td>
	<td><div align="center"><strong>Rol Egresado</strong></div></td>
	<td><div align="center"><strong>Cargo en Empresa</strong></div></td>
	<td><div align="center"><strong>Fecha</strong></div></td>
	<td><div align="center"><strong>Pregunta 1</strong></div></td>
	<td><div align="center"><strong>Pregunta 2</strong></div></td>
	<td><div align="center"><strong>Pregunta 3</strong></div></td>
	<td><div align="center"><strong>Pregunta 4</strong></div></td>
	<td><div align="center"><strong>Pregunta 5</strong></div></td>
	<td><div align="center"><strong>Pregunta 6</strong></div></td>
	<td><div align="center"><strong>Pregunta 7</strong></div></td>
	<td><div align="center"><strong>Pregunta 8</strong></div></td>
	<td><div align="center"><strong>Pregunta 9</strong></div></td>
	<td><div align="center"><strong>Pregunta 10</strong></div></td>
	<td><div align="center"><strong>Pregunta 11</strong></div></td>
	<td><div align="center"><strong>Pregunta 12</strong></div></td>
	<td><div align="center"><strong>Pregunta 13</strong></div></td>
	<td><div align="center"><strong>Pregunta 14</strong></div></td>
	<td><div align="center"><strong>Pregunta 15</strong></div></td>
	<td><div align="center"><strong>Pregunta 16</strong></div></td>
	<td><div align="center"><strong>Pregunta 17</strong></div></td>
	<td><div align="center"><strong>Pregunta 18</strong></div></td>
	<td><div align="center"><strong>Pregunta 19</strong></div></td>
	<td><div align="center"><strong>Pregunta 20</strong></div></td>
	<td><div align="center"><strong>Pregunta 21</strong></div></td>
	<td><div align="center"><strong>Pregunta 22</strong></div></td>
	<td><div align="center"><strong>Pregunta 23</strong></div></td>
	<td><div align="center"><strong>Pregunta 24</strong></div></td>
	<td><div align="center"><strong>Pregunta 25</strong></div></td>
	<td><div align="center"><strong>Pregunta 26</strong></div></td>
	<td><div align="center"><strong>Pregunta 27</strong></div></td>
	<td><div align="center"><strong>Pregunta 28</strong></div></td>
	<td><div align="center"><strong>Pregunta 29</strong></div></td>
	<td><div align="center"><strong>Pregunta 30</strong></div></td>
	<td><div align="center"><strong>Pregunta 31</strong></div></td>
	<td><div align="center"><strong>Pregunta 32</strong></div></td>
	<td><div align="center"><strong>Pregunta 33</strong></div></td>
	<td><div align="center"><strong>Pregunta 34</strong></div></td>
	<td><div align="center"><strong>Pregunta 35</strong></div></td>
	<td><div align="center"><strong>Pregunta 36</strong></div></td>
	<td><div align="center"><strong>Pregunta 37</strong></div></td>
	<td><div align="center"><strong>Pregunta 38</strong></div></td>
	<td><div align="center"><strong>Pregunta 39</strong></div></td>
	<td><div align="center"><strong>Pregunta 40</strong></div></td>
	<td><div align="center"><strong>Pregunta 41</strong></div></td>
	<td><div align="center"><strong>Pregunta 42</strong></div></td>
	<td><div align="center"><strong>Pregunta 43</strong></div></td>
	<td><div align="center"><strong>Pregunta 44</strong></div></td>
	<td><div align="center"><strong>Pregunta 45</strong></div></td>
	<td><div align="center"><strong>Pregunta 46</strong></div></td>
	<td><div align="center"><strong>Pregunta 47</strong></div></td>
	<td><div align="center"><strong>Pregunta 48</strong></div></td>
	<td><div align="center"><strong>Pregunta 49</strong></div></td>
	<td><div align="center"><strong>Pregunta 50</strong></div></td>
	<td><div align="center"><strong>Pregunta 51</strong></div></td>
	<td><div align="center"><strong>Pregunta 52</strong></div></td>
	<td><div align="center"><strong>Pregunta 53</strong></div></td>
	<td><div align="center"><strong>Pregunta 54</strong></div></td>
	<td><div align="center"><strong>Pregunta 55</strong></div></td>
	<td><div align="center"><strong>Pregunta 56</strong></div></td>
	<td><div align="center"><strong>Pregunta 57</strong></div></td>
	<td><div align="center"><strong>Pregunta 58</strong></div></td>
	<td><div align="center"><strong>Pregunta 59</strong></div></td>
	<td><div align="center"><strong>Pregunta 60</strong></div></td>
	<td><div align="left"><strong>1. ¿Qué contenidos no me fueron entregados y hoy me doy cuenta de que me sería muy favorable conocer?</strong></div></td>
	<td><div align="left"><strong>2. ¿Qué sugerencias le haría a las autoridades de la carrera para mejorar la calidad de la formación?</strong></div></td>
	<td><div align="left"><strong>3. Señale a continuación, sugerencias o comentarios referidos a las fortalezas y/o debilidades de la carrera o institución, que le gustaría destacar:</strong></div></td>
  </tr>
  <% fila = 1  
    while f_egresados.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_egresados.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_egresados.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_egresados.ObtenerValor("sexo")%></div></td>
    <td><div align="left"><%=f_egresados.ObtenerValor("edad_alumno")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("egresado")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("titulado")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("ano_inicio")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("ano_final")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("trabajando")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("tiempo_demora")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("renta_promedio")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("nombre_empresa")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("tamano")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("caracteristica_empresa")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("rol")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("cargo_empresa")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("fecha")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_1")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_2")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_3")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_4")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_5")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_6")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_7")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_8")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_9")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_10")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_11")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_12")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_13")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_14")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_15")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_16")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_17")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_18")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_19")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_20")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_21")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_22")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_23")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_24")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_25")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_26")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_27")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_28")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_29")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_30")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_31")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_32")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_33")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_34")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_35")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_36")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_37")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_38")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_39")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_40")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_41")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_42")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_43")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_44")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_45")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_46")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_47")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_48")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_49")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_50")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_51")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_52")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_53")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_54")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_55")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_56")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_57")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_58")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_59")%></div></td>
	<td><div align="center"><%=f_egresados.ObtenerValor("preg_60")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("contenidos_faltantes")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("sugerencias_autoridades")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("sugerencias_carrera")%></div></td>
  </tr>
  <% fila = fila + 1 
     wend %>
  <tr><td colspan="9">&nbsp;</td>
      <td colspan="71">&nbsp;</td>
  </tr>
</table>
<p>&nbsp;</p>
 <table width="100%" border="1">
  <tr><td colspan="4" bgcolor="#CCFFCC"><font size="+1"><strong>Encuesta Alumnos</strong></font></td>
      <td colspan="81" bgcolor="#CCFFCC">&nbsp;</td>
  </tr>
  <tr> 
    <td><div align="center"><strong>fila</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>RUT</strong></div></td>
    <td><div align="center"><strong>Nombre</strong></div></td>
	<td><div align="center"><strong>Sexo</strong></div></td>
    <td><div align="center"><strong>Edad</strong></div></td>
	<td><div align="center"><strong>Nivel Alumno</strong></div></td>
	<td><div align="center"><strong>Año ingreso Carrera</strong></div></td>
	<td><div align="center"><strong>Fecha</strong></div></td>
	<td><div align="center"><strong>Pregunta 1</strong></div></td>
	<td><div align="center"><strong>Pregunta 2</strong></div></td>
	<td><div align="center"><strong>Pregunta 3</strong></div></td>
	<td><div align="center"><strong>Pregunta 4</strong></div></td>
	<td><div align="center"><strong>Pregunta 5</strong></div></td>
	<td><div align="center"><strong>Pregunta 6</strong></div></td>
	<td><div align="center"><strong>Pregunta 7</strong></div></td>
	<td><div align="center"><strong>Pregunta 8</strong></div></td>
	<td><div align="center"><strong>Pregunta 9</strong></div></td>
	<td><div align="center"><strong>Pregunta 10</strong></div></td>
	<td><div align="center"><strong>Pregunta 11</strong></div></td>
	<td><div align="center"><strong>Pregunta 12</strong></div></td>
	<td><div align="center"><strong>Pregunta 13</strong></div></td>
	<td><div align="center"><strong>Pregunta 14</strong></div></td>
	<td><div align="center"><strong>Pregunta 15</strong></div></td>
	<td><div align="center"><strong>Pregunta 16</strong></div></td>
	<td><div align="center"><strong>Pregunta 17</strong></div></td>
	<td><div align="center"><strong>Pregunta 18</strong></div></td>
	<td><div align="center"><strong>Pregunta 19</strong></div></td>
	<td><div align="center"><strong>Pregunta 20</strong></div></td>
	<td><div align="center"><strong>Pregunta 21</strong></div></td>
	<td><div align="center"><strong>Pregunta 22</strong></div></td>
	<td><div align="center"><strong>Pregunta 23</strong></div></td>
	<td><div align="center"><strong>Pregunta 24</strong></div></td>
	<td><div align="center"><strong>Pregunta 25</strong></div></td>
	<td><div align="center"><strong>Pregunta 26</strong></div></td>
	<td><div align="center"><strong>Pregunta 27</strong></div></td>
	<td><div align="center"><strong>Pregunta 28</strong></div></td>
	<td><div align="center"><strong>Pregunta 29</strong></div></td>
	<td><div align="center"><strong>Pregunta 30</strong></div></td>
	<td><div align="center"><strong>Pregunta 31</strong></div></td>
	<td><div align="center"><strong>Pregunta 32</strong></div></td>
	<td><div align="center"><strong>Pregunta 33</strong></div></td>
	<td><div align="center"><strong>Pregunta 34</strong></div></td>
	<td><div align="center"><strong>Pregunta 35</strong></div></td>
	<td><div align="center"><strong>Pregunta 36</strong></div></td>
	<td><div align="center"><strong>Pregunta 37</strong></div></td>
	<td><div align="center"><strong>Pregunta 38</strong></div></td>
	<td><div align="center"><strong>Pregunta 39</strong></div></td>
	<td><div align="center"><strong>Pregunta 40</strong></div></td>
	<td><div align="center"><strong>Pregunta 41</strong></div></td>
	<td><div align="center"><strong>Pregunta 42</strong></div></td>
	<td><div align="center"><strong>Pregunta 43</strong></div></td>
	<td><div align="center"><strong>Pregunta 44</strong></div></td>
	<td><div align="center"><strong>Pregunta 45</strong></div></td>
	<td><div align="center"><strong>Pregunta 46</strong></div></td>
	<td><div align="center"><strong>Pregunta 47</strong></div></td>
	<td><div align="center"><strong>Pregunta 48</strong></div></td>
	<td><div align="center"><strong>Pregunta 49</strong></div></td>
	<td><div align="center"><strong>Pregunta 50</strong></div></td>
	<td><div align="center"><strong>Pregunta 51</strong></div></td>
	<td><div align="center"><strong>Pregunta 52</strong></div></td>
	<td><div align="center"><strong>Pregunta 53</strong></div></td>
	<td><div align="center"><strong>Pregunta 54</strong></div></td>
	<td><div align="center"><strong>Pregunta 55</strong></div></td>
	<td><div align="center"><strong>Pregunta 56</strong></div></td>
	<td><div align="center"><strong>Pregunta 57</strong></div></td>
	<td><div align="center"><strong>Pregunta 58</strong></div></td>
	<td><div align="center"><strong>Pregunta 59</strong></div></td>
	<td><div align="center"><strong>Pregunta 60</strong></div></td>
	<td><div align="center"><strong>Pregunta 61</strong></div></td>
	<td><div align="center"><strong>Pregunta 62</strong></div></td>
	<td><div align="center"><strong>Pregunta 63</strong></div></td>
	<td><div align="center"><strong>Pregunta 64</strong></div></td>
	<td><div align="center"><strong>Pregunta 65</strong></div></td>
	<td><div align="center"><strong>Pregunta 66</strong></div></td>
	<td><div align="center"><strong>Pregunta 67</strong></div></td>
	<td><div align="center"><strong>Pregunta 68</strong></div></td>
	<td><div align="center"><strong>Pregunta 69</strong></div></td>
	<td><div align="center"><strong>Pregunta 70</strong></div></td>
	<td><div align="center"><strong>Pregunta 71</strong></div></td>
	<td><div align="center"><strong>Pregunta 72</strong></div></td>
	<td><div align="center"><strong>Pregunta 73</strong></div></td>
	<td><div align="center"><strong>Pregunta 74</strong></div></td>
	<td><div align="center"><strong>Pregunta 75</strong></div></td>
	<td><div align="center"><strong>Pregunta 76</strong></div></td>
	<td><div align="left"><strong>77. Señale a continuación sugerencias o comentarios referidos a las fortalezas y/o debilidades de la carrera o institución, que le gustaría destacar:</strong></div></td>
  </tr>
  <% fila = 1  
    while f_alumnos.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("sexo")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("edad_alumno")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("nivel_alumno")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("ano_ingreso")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("fecha")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_1")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_2")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_3")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_4")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_5")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_6")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_7")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_8")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_9")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_10")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_11")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_12")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_13")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_14")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_15")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_16")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_17")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_18")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_19")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_20")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_21")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_22")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_23")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_24")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_25")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_26")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_27")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_28")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_29")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_30")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_31")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_32")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_33")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_34")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_35")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_36")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_37")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_38")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_39")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_40")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_41")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_42")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_43")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_44")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_45")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_46")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_47")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_48")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_49")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_50")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_51")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_52")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_53")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_54")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_55")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_56")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_57")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_58")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_59")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_60")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_61")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_62")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_63")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_64")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_65")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_66")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_67")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_68")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_69")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_70")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_71")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_72")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_73")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_74")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_75")%></div></td>
	<td><div align="center"><%=f_alumnos.ObtenerValor("preg_76")%></div></td>
   	<td><div align="left"><%=f_alumnos.ObtenerValor("sugerencias_carrera")%></div></td>
	
  </tr>
  <% fila = fila + 1 
     wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>