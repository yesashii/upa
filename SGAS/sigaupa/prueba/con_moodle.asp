<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_negocio.asp" -->
<% 
Response.AddHeader "Content-Disposition", "attachment;filename=enrolments.txt"
Response.ContentType = "text/plain"
Server.ScriptTimeOut = 400000
set pagina = new CPagina

set conexion_sga = new cConexion
'set negocio = new cNegocio

conexion_sga.inicializar "upacifico"
'negocio.inicializa conexion
peri_ccod="240"

fecha=conexion_sga.ConsultaUno("select protic.trunc(getdate())")

if fecha="25/07/2015" then
fecha_corte="and convert(datetime,protic.trunc(a.audi_fmodificacion),103)>=convert(datetime,25/07/2015,103)"
else
fecha_corte="and protic.trunc(a.audi_fmodificacion)=protic.trunc(getdate())"
end if


consulta_sga="select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'del'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
"where a.audi_tusuario like 'Eliminado%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'del'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
"where a.audi_tusuario like 'Eliminado%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"AND NOT EXISTS (SELECT 1 FROM CARGAS_ACADEMICAS TT WHERE TT.MATR_NCORR=A.MATR_NCORR AND TT.SECC_CCOD=A.SECC_CCOD) "& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'del'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
"where a.audi_tusuario like 'Eliminado%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and b.carr_ccod  in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'add'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
"where a.audi_tusuario like 'Agregada%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'add'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,sis_usuarios e"& vbCrLf &_
"where a.audi_tusuario like 'Agregada%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and b.carr_ccod  in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,f.secc_ccod"& vbCrLf &_
",cast(f.sede_ccod as varchar)+'-'+cast(rtrim(f.carr_ccod) as varchar)+'-'+cast(f.jorn_ccod as varchar)+'-'+rtrim(f.asig_ccod)+'-'+cast(SUBSTRING(f.secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'add'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,cargas_academicas e,secciones f"& vbCrLf &_
"where a.audi_tusuario like 'Modificada%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and a.MATR_NCORR=e.MATR_NCORR"& vbCrLf &_
"and e.SECC_CCOD=f.SECC_CCOD"& vbCrLf &_
"and b.ASIG_CCOD=f.ASIG_CCOD"& vbCrLf &_
"and b.SECC_CCOD<>f.SECC_CCOD"& vbCrLf &_
"and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(b.sede_ccod as varchar)+'-'+cast(rtrim(b.carr_ccod) as varchar)+'-'+cast(b.jorn_ccod as varchar)+'-'+rtrim(b.asig_ccod)+'-'+cast(SUBSTRING(b.secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'del'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,cargas_academicas e,secciones f"& vbCrLf &_
"where a.audi_tusuario like 'Modificada%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and a.MATR_NCORR=e.MATR_NCORR"& vbCrLf &_
"and e.SECC_CCOD=f.SECC_CCOD"& vbCrLf &_
"and b.ASIG_CCOD=f.ASIG_CCOD"& vbCrLf &_
"and b.SECC_CCOD<>f.SECC_CCOD"& vbCrLf &_
"and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,f.secc_ccod"& vbCrLf &_
",cast(f.sede_ccod as varchar)+'-'+cast(rtrim(f.carr_ccod) as varchar)+'-'+cast(f.jorn_ccod as varchar)+'-'+rtrim(f.asig_ccod)+'-'+cast(SUBSTRING(f.secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'add'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,cargas_academicas e,secciones f"& vbCrLf &_
"where a.audi_tusuario like 'Modificada%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and a.MATR_NCORR=e.MATR_NCORR"& vbCrLf &_
"and e.SECC_CCOD=f.SECC_CCOD"& vbCrLf &_
"and b.ASIG_CCOD=f.ASIG_CCOD"& vbCrLf &_
"and b.SECC_CCOD<>f.SECC_CCOD"& vbCrLf &_
"and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(b.sede_ccod as varchar)+'-'+cast(rtrim(b.carr_ccod) as varchar)+'-'+cast(b.jorn_ccod as varchar)+'-'+rtrim(b.asig_ccod)+'-'+cast(SUBSTRING(b.secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'del'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,cargas_academicas e,secciones f"& vbCrLf &_
"where a.audi_tusuario like 'Modificada%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and a.MATR_NCORR=e.MATR_NCORR"& vbCrLf &_
"and e.SECC_CCOD=f.SECC_CCOD"& vbCrLf &_
"and b.ASIG_CCOD=f.ASIG_CCOD"& vbCrLf &_
"and b.SECC_CCOD<>f.SECC_CCOD"& vbCrLf &_
"and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,f.secc_ccod"& vbCrLf &_
",cast(f.sede_ccod as varchar)+'-'+cast(rtrim(f.carr_ccod) as varchar)+'-'+cast(f.jorn_ccod as varchar)+'-'+rtrim(f.asig_ccod)+'-'+cast(SUBSTRING(f.secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'add'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,cargas_academicas e,secciones f"& vbCrLf &_
"where a.audi_tusuario like 'Modificada%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and a.MATR_NCORR=e.MATR_NCORR"& vbCrLf &_
"and e.SECC_CCOD=f.SECC_CCOD"& vbCrLf &_
"and b.ASIG_CCOD=f.ASIG_CCOD"& vbCrLf &_
"and b.SECC_CCOD<>f.SECC_CCOD"& vbCrLf &_
"and b.carr_ccod  in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"union"& vbCrLf &_
"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
",cast(b.sede_ccod as varchar)+'-'+cast(rtrim(b.carr_ccod) as varchar)+'-'+cast(b.jorn_ccod as varchar)+'-'+rtrim(b.asig_ccod)+'-'+cast(SUBSTRING(b.secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
",'del'as inst"& vbCrLf &_
"from cargas_academicas_log a,secciones b,alumnos c,postulantes d,cargas_academicas e,secciones f"& vbCrLf &_
"where a.audi_tusuario like 'Modificada%'"& vbCrLf &_
"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
"and a.MATR_NCORR=e.MATR_NCORR"& vbCrLf &_
"and e.SECC_CCOD=f.SECC_CCOD"& vbCrLf &_
"and b.ASIG_CCOD=f.ASIG_CCOD"& vbCrLf &_
"and b.SECC_CCOD<>f.SECC_CCOD"& vbCrLf &_
"and b.carr_ccod  in ('930','810','920')"& vbCrLf &_
"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
""&fecha_corte&""& vbCrLf &_
"order by a.audi_fmodificacion"
'"order by  a.audi_fmodificacion"


consulta_sga=   "select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
				"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
				",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
				",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
				",'del'as inst"& vbCrLf &_
				"from cargas_academicas_log a (nolock),secciones b(nolock),alumnos c(nolock),postulantes d(nolock),sis_usuarios e(nolock)"& vbCrLf &_
				"where a.audi_tusuario like 'Eliminado%'"& vbCrLf &_
				"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
				"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
				"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
				"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
				"AND NOT EXISTS (SELECT 1 FROM CARGAS_ACADEMICAS TT (nolock) WHERE TT.MATR_NCORR=A.MATR_NCORR AND TT.SECC_CCOD=A.SECC_CCOD) "& vbCrLf &_
				"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
				""&fecha_corte&""& vbCrLf &_
				"union"& vbCrLf &_
				"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
				"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
				",cast(sede_ccod as varchar)+'-'+cast(rtrim(carr_ccod) as varchar)+'-'+cast(jorn_ccod as varchar)+'-'+rtrim(asig_ccod)+'-'+cast(SUBSTRING(secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
				",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
				",'add'as inst"& vbCrLf &_
				"from cargas_academicas_log a (nolock),secciones b (nolock),alumnos c (nolock),postulantes d (nolock),sis_usuarios e (nolock)"& vbCrLf &_
				"where a.audi_tusuario like 'Agregada%'"& vbCrLf &_
				"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
				"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
				"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
				"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
				"and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
				"AND EXISTS (SELECT 1 FROM CARGAS_ACADEMICAS TT (nolock) WHERE TT.MATR_NCORR=A.MATR_NCORR AND TT.SECC_CCOD=A.SECC_CCOD) "& vbCrLf &_
				"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
				""&fecha_corte&""& vbCrLf &_
				"union"& vbCrLf &_
				"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
				"a.matr_ncorr,f.secc_ccod"& vbCrLf &_
				",cast(f.sede_ccod as varchar)+'-'+cast(rtrim(f.carr_ccod) as varchar)+'-'+cast(f.jorn_ccod as varchar)+'-'+rtrim(f.asig_ccod)+'-'+cast(SUBSTRING(f.secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
				",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
				",'add'as inst"& vbCrLf &_
				"from cargas_academicas_log a (nolock),secciones b (nolock),alumnos c (nolock),postulantes d (nolock),cargas_academicas e (nolock),secciones f (nolock)"& vbCrLf &_
				"where a.audi_tusuario like 'Modificada%'"& vbCrLf &_
				"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
				"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
				"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
				"and a.MATR_NCORR=e.MATR_NCORR"& vbCrLf &_
				"and e.SECC_CCOD=f.SECC_CCOD"& vbCrLf &_
				"and b.ASIG_CCOD=f.ASIG_CCOD"& vbCrLf &_
				"and b.SECC_CCOD<>f.SECC_CCOD"& vbCrLf &_
				"and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
				"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
				""&fecha_corte&""& vbCrLf &_
				"union"& vbCrLf &_
				"select  distinct d.pers_ncorr as id,a.audi_fmodificacion,"& vbCrLf &_
				"a.matr_ncorr,b.secc_ccod"& vbCrLf &_
				",cast(b.sede_ccod as varchar)+'-'+cast(rtrim(b.carr_ccod) as varchar)+'-'+cast(b.jorn_ccod as varchar)+'-'+rtrim(b.asig_ccod)+'-'+cast(SUBSTRING(b.secc_tdesc, 1, 1)as varchar) as id_curso"& vbCrLf &_
				",substring(a.audi_tusuario,1,9)as estado"& vbCrLf &_
				",'del'as inst"& vbCrLf &_
				"from cargas_academicas_log a (nolock),secciones b (nolock),alumnos c (nolock),postulantes d (nolock),cargas_academicas e (nolock),secciones f (nolock)"& vbCrLf &_
				"where a.audi_tusuario like 'Modificada%'"& vbCrLf &_
				"and a.matr_ncorr=c.matr_ncorr"& vbCrLf &_
				"and c.post_ncorr=d.post_ncorr"& vbCrLf &_
				"and a.secc_ccod=b.secc_ccod"& vbCrLf &_
				"and a.MATR_NCORR=e.MATR_NCORR"& vbCrLf &_
				"and e.SECC_CCOD=f.SECC_CCOD"& vbCrLf &_
				"and b.ASIG_CCOD=f.ASIG_CCOD"& vbCrLf &_
				"and b.SECC_CCOD<>f.SECC_CCOD"& vbCrLf &_
				"and b.carr_ccod not in ('930','810','920')"& vbCrLf &_
				"and d.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
				""&fecha_corte&""& vbCrLf &_
				"order by a.audi_fmodificacion"



' Response.Write("<pre>"&consulta_sga&"</pre>")
' response.end()
set f_datos_sga  = new cformulario
f_datos_sga.carga_parametros "tabla_vacia.xml", "tabla" 
f_datos_sga.inicializar conexion_sga							
f_datos_sga.consultar consulta_sga

'Response.Write(consulta_sga)

 while f_datos_sga.Siguiente
 
 			    accion = f_datos_sga.obtenerValor("inst")
				response.Write(accion&",")
				response.Write("student,")
				id_alumno = f_datos_sga.obtenerValor("id")
				response.Write(id_alumno&",")
				id_curso = f_datos_sga.obtenerValor("id_curso")
				response.Write(id_curso)
				Response.Write(vbCrLf)
			
	LACM_NCORR=conexion_sga.ConsultaUno("exec ObtenerSecuencia 'LOG_AUTO_ACTUALIZACION_MOODLE'")
			
	insr="insert into LOG_AUTO_ACTUALIZACION_MOODLE (LACM_NCORR,pers_ncorr,id_curso,accion,AUDI_FMODIFICACION)values ("&LACM_NCORR&","&id_alumno&",'"&id_curso&"','"&accion&"',getdate())"
	'Response.Write("<br>"&insr)
	conexion_sga.ejecutaS (insr)	
	
   wend 
%>