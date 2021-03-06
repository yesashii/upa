<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usuario = negocio.obtenerUsuario
'usuario = "13241409"

nombre = conexion.consultaUno("select protic.initCap(pers_tnombre+' '+pers_tape_paterno) from personas where cast(pers_nrut as varchar)='"&usuario&"'")
pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
email_docente = conexion.consultaUno("select top 1 lower(email_nuevo) from cuentas_email_upa where cast(pers_ncorr as varchar)='"&pers_ncorr&"' order by fecha_creacion desc")

set f_mensajes = new CFormulario
f_mensajes.Carga_Parametros "tabla_vacia.xml", "tabla"   '"mensajes.xml", "mensajes"
f_mensajes.Inicializar conexion

 c_mensajes = " select top 10 mepe_ncorr, protic.trunc(fecha_emision) as fecha, " & vbCrLf &_
			  "	protic.initCap(pers_tnombre + ' ' + pers_tape_paterno) as de, " & vbCrLf &_
			  "	titulo, case when a.pers_ncorr_origen=a.pers_ncorr_destino then 'Copia envio' else 'Alumno' end as origen, " & vbCrLf &_
			  "	fecha_emision, b.pers_ncorr,tipo_origen, " & vbCrLf &_
			  " case isnull(estado,'Sin leer') when 'Sin leer' then '<img src=""../imagenes/sin_leer.jpg"" width=""17"" height=""15"" border=""0"" alt=""Sin Leer"">' " & vbCrLf &_
              " else '<img src=""../imagenes/leidos.jpg"" width=""17"" height=""15"" border=""0"" alt=""Le�dos"">' end as foto " & vbCrLf &_
			  "	from mensajes_entre_personas a, personas b " & vbCrLf &_
			  "	where a.pers_ncorr_origen = b.pers_ncorr " & vbCrLf &_
			  "	and convert(datetime,protic.trunc(fecha_vencimiento),103) >= convert(datetime,protic.trunc(getDate()),103) " & vbCrLf &_
			  "	and cast(pers_ncorr_destino as varchar)='"&pers_ncorr&"'  and isnull(estado,'Activo') <> 'Eliminado' " & vbCrLf &_
			  "	order by fecha_emision desc"
 
 f_mensajes.Consultar c_mensajes
 'response.Write("<pre>"&c_mensajes&"</pre>")

peri_ccod = negocio.obtenerPeriodoAcademico("PLANIFICACION")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where peri_ccod='"&peri_ccod&"'")
primer_semestre = conexion.consultaUno("select peri_ccod from periodos_academicos where anos_ccod='"&anos_ccod&"' and plec_ccod=1")
segundo_semestre = conexion.consultaUno("select peri_ccod from periodos_academicos where anos_ccod='"&anos_ccod&"' and plec_ccod=2")

'set f_asignaturas2 = new CFormulario
'f_asignaturas2.Carga_Parametros "tabla_vacia.xml", "tabla"
'f_asignaturas2.Inicializar conexion

'c_asignaturas2 = " select distinct substring(c.secc_tdesc,1,1) + ' ' + ltrim(rtrim(d.asig_ccod)) + ': '+ d.asig_tdesc as asignatura, " & vbCrLf &_
'               " (select count(*) from cargas_academicas tt where tt.secc_ccod=c.secc_ccod and isnull(tt.sitf_ccod,'T') in ('A','R','T','RI') ) as total_alumnos, " & vbCrLf &_
'				" (select case count(*) when 0 then 'NO' else 'SI' end from calificaciones_seccion tt where tt.secc_ccod=c.secc_ccod ) as programada, " & vbCrLf &_
'				" (select case count(*) when 0 then 'NO' else 'SI' end from calificaciones_alumnos tt where tt.secc_ccod=c.secc_ccod ) as notas_parciales, " & vbCrLf &_
'				" (select case count(*) when 0 then 'NO' else 'SI' end from cargas_academicas tt where tt.secc_ccod=c.secc_ccod and isnull(tt.sitf_ccod,'P')<> 'P' ) as notas_finales," & vbCrLf &_
'				" case isnull(c.estado_cierre_ccod,1) when 2 then 'SI' else 'NO' end as cerrada, " & vbCrLf &_
'				" (select count(*) from cargas_academicas tt where tt.secc_ccod=c.secc_ccod and isnull(tt.sitf_ccod,'T') = 'A' ) as aprobados,  " & vbCrLf &_
'				" (select count(*) from cargas_academicas tt where tt.secc_ccod=c.secc_ccod and isnull(tt.sitf_ccod,'T') = 'R' ) as reprobados,  " & vbCrLf &_
'				" (select count(*) from cargas_academicas tt where tt.secc_ccod=c.secc_ccod and isnull(tt.sitf_ccod,'T') = 'RI' ) as reprobados_i,  " & vbCrLf &_
'				" (select count(*) from cargas_academicas tt where tt.secc_ccod=c.secc_ccod and isnull(tt.sitf_ccod,'T') = 'T' ) as blancos  " & vbCrLf &_
'               " from bloques_profesores a, bloques_horarios b, secciones c, asignaturas d " & vbCrLf &_
'                " where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.tpro_ccod=1 and a.bloq_ccod=b.bloq_ccod" & vbCrLf &_
'				" and b.secc_ccod = c.secc_ccod and c.asig_ccod=d.asig_ccod and cast(c.peri_ccod as varchar)='"&primer_semestre&"' " & vbCrLf &_
'				" order by asignatura "

'f_asignaturas2.Consultar c_asignaturas2
'while f_asignaturas2.siguiente
'	total = total + cint(f_asignaturas2.obtenerValor("total_alumnos"))
'	A  = A  + cint(f_asignaturas2.obtenerValor("aprobados"))
'	R  = R  + cint(f_asignaturas2.obtenerValor("reprobados"))
'	RI = RI + cint(f_asignaturas2.obtenerValor("reprobados_i"))
'	B  = B  + cint(f_asignaturas2.obtenerValor("blancos"))
'wend
'if total > 0 then 
'   PA  = formatNumber(A * 100 / total,0)
'   PR  = formatNumber(R * 100 / total,0)
'   PRI = formatNumber(RI * 100 / total,0)
'   PB  = formatNumber(B * 100 / total,0)
'   PB  = 3
'end if

set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_asignaturas.Inicializar conexion

c_asignaturas = " select distinct substring(c.secc_tdesc,1,1) + ' ' + ltrim(rtrim(d.asig_ccod)) + ': '+ d.asig_tdesc as asignatura, " & vbCrLf &_
                " (select count(*) from cargas_academicas tt where tt.secc_ccod=c.secc_ccod and isnull(tt.sitf_ccod,'T') in ('A','R','T','RI') ) as total_alumnos, " & vbCrLf &_
				" (select case count(*) when 0 then 'NO' else 'SI' end from calificaciones_seccion tt where tt.secc_ccod=c.secc_ccod ) as programada, " & vbCrLf &_
				" (select case count(*) when 0 then 'NO' else 'SI' end from calificaciones_alumnos tt where tt.secc_ccod=c.secc_ccod ) as notas_parciales, " & vbCrLf &_
				" (select case count(*) when 0 then 'NO' else 'SI' end from cargas_academicas tt where tt.secc_ccod=c.secc_ccod and isnull(tt.sitf_ccod,'P')<> 'P' ) as notas_finales," & vbCrLf &_
				" case isnull(c.estado_cierre_ccod,1) when 2 then 'SI' else 'NO' end as cerrada, " & vbCrLf &_
				" (select count(*) from cargas_academicas tt where tt.secc_ccod=c.secc_ccod and isnull(tt.sitf_ccod,'T') = 'A' ) as aprobados,  " & vbCrLf &_
				" (select count(*) from cargas_academicas tt where tt.secc_ccod=c.secc_ccod and isnull(tt.sitf_ccod,'T') = 'R' ) as reprobados,  " & vbCrLf &_
				" (select count(*) from cargas_academicas tt where tt.secc_ccod=c.secc_ccod and isnull(tt.sitf_ccod,'T') = 'RI' ) as reprobados_i,  " & vbCrLf &_
				" (select count(*) from cargas_academicas tt where tt.secc_ccod=c.secc_ccod and isnull(tt.sitf_ccod,'T') = 'T' ) as blancos  " & vbCrLf &_
               " from bloques_profesores a, bloques_horarios b, secciones c, asignaturas d " & vbCrLf &_
               " where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.tpro_ccod=1 and a.bloq_ccod=b.bloq_ccod" & vbCrLf &_
				" and b.secc_ccod = c.secc_ccod and c.asig_ccod=d.asig_ccod and cast(c.peri_ccod as varchar)='"&primer_semestre&"' " & vbCrLf &_
				" order by asignatura "

f_asignaturas.Consultar c_asignaturas
				
''response.Write("A "&A&" R "&R&" RI "&RI&" B "&B)
''response.Write("<br>A "&PA&" R "&PR&" RI "&PRI&" B "&PB)

'c_ev_docente = " select cast((cast(avg(puntaje_obtenido)  as numeric(2,1)) * 100) / 6 as numeric(3,0)) " & vbCrLf &_
'			   " from " & vbCrLf &_
'			   " ( " & vbCrLf &_ 
'			   " 	select distinct d.pers_ncorr,a.secc_ccod,protic.initcap(e.sede_tdesc) as sede,protic.initcap(f.carr_tdesc) as carrera,protic.initcap(g.jorn_tdesc) as jornada, " & vbCrLf &_
'			   " 	ltrim(rtrim(h.asig_ccod))+ ' ' + protic.initcap(h.asig_tdesc) as asignatura,a.secc_tdesc as seccion,protic.initcap(b.peri_tdesc) as periodo, " & vbCrLf &_
'			   " 	(select count(*) from cargas_academicas bb,alumnos cc where bb.secc_ccod=a.secc_ccod and bb.matr_ncorr=cc.matr_ncorr and cc.emat_ccod=1) as total_alumnos, " & vbCrLf &_
'			   " 	(select count(distinct pers_ncorr)  " & vbCrLf &_
'			   " 	from cuestionario_opinion_alumnos aa where aa.secc_ccod=a.secc_ccod and aa.pers_ncorr_profesor=d.pers_ncorr and isnull(estado_cuestionario,0)=2 ) as evaluado2, " & vbCrLf &_
'			   " 	cast( " & vbCrLf &_
'			   "		(  ( " & vbCrLf &_
'			   "		   (select cast(avg(parte_2_1) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_1,0) > 0 ) " & vbCrLf &_
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_2_2) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_2,0) > 0 )  " & vbCrLf &_
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_2_3) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_3,0) > 0 )   " & vbCrLf &_
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_2_4) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_4,0) > 0 )  " & vbCrLf &_ 
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_2_5) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_5,0) > 0 )  " & vbCrLf &_
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_2_6) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_6,0) > 0 )  " & vbCrLf &_ 
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_2_7) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_7,0) > 0 )  " & vbCrLf &_  
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_2_8) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_8,0) > 0 )  " & vbCrLf &_   
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_2_9) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_2_9,0) > 0 ) " & vbCrLf &_    
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_3_1) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_3_1,0) > 0 ) " & vbCrLf &_    
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_3_2) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_3_2,0) > 0 ) " & vbCrLf &_  
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_3_3) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_3_3,0) > 0 )  " & vbCrLf &_  
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_3_4) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_3_4,0) > 0 )  " & vbCrLf &_ 
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_4_1) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_4_1,0) > 0 )  " & vbCrLf &_   
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_4_2) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_4_2,0) > 0 )  " & vbCrLf &_ 
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_4_3) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_4_3,0) > 0 ) " & vbCrLf &_    
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_4_4) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_4_4,0) > 0 )   " & vbCrLf &_
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_5_1) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_5_1,0) > 0 )  " & vbCrLf &_   
'			   "		  +  " & vbCrLf &_
'		       "		   (select cast(avg(parte_5_2) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_5_2,0) > 0 )  " & vbCrLf &_ 
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_5_3) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_5_3,0) > 0 )   " & vbCrLf &_
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_5_4) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_5_4,0) > 0 )   " & vbCrLf &_  
'			   "		  +  " & vbCrLf &_
'			   "		   (select cast(avg(parte_5_5) as decimal(2,1)) from cuestionario_opinion_alumnos bb where bb.secc_ccod =a.secc_ccod and bb.pers_ncorr_profesor = d.pers_ncorr  and isnull(estado_cuestionario,0)=2 and isnull(parte_5_5,0) > 0 )   " & vbCrLf &_
'			   "		  ) / 22  " & vbCrLf &_
'			   "		) as decimal(2,1))  as puntaje_obtenido  " & vbCrLf &_
'			   " 	from secciones a, periodos_academicos b,bloques_horarios c, bloques_profesores d,  " & vbCrLf &_
'			   " 		sedes e,carreras f,jornadas g,asignaturas h,especialidades i  " & vbCrLf &_
'			   " 	where a.peri_ccod=b.peri_ccod  " & vbCrLf &_
'			   " 		and cast(b.peri_ccod as varchar)='"&peri_ccod&"'  " & vbCrLf &_
'			   " 		and a.secc_ccod=c.secc_ccod  " & vbCrLf &_
'		       "  		and c.bloq_ccod=d.bloq_ccod  " & vbCrLf &_
'			   " 		and cast(d.pers_ncorr as varchar)='"&pers_ncorr&"' and d.tpro_ccod=1  " & vbCrLf &_
'			   " 		and a.sede_ccod=e.sede_ccod  " & vbCrLf &_
'			   " 		and f.carr_ccod=i.carr_ccod  " & vbCrLf &_
'			   " 		and a.carr_ccod=f.carr_ccod  " & vbCrLf &_
'			   " 		and a.jorn_ccod=g.jorn_ccod  " & vbCrLf &_
'			   " 		and a.asig_ccod=h.asig_ccod  " & vbCrLf &_
'			   " 		and exists (select 1 from cuestionario_opinion_alumnos bb where bb.secc_ccod=a.secc_ccod and bb.pers_ncorr_profesor=d.pers_ncorr )  " & vbCrLf &_
'			   " )table1 "

''porcentaje_encuesta = conexion.consultaUno(c_ev_docente)
''if porcentaje_encuesta <> "" then
''	porcentaje_encuesta =  cint(porcentaje_encuesta)
''end if
''response.Write(porcentaje_encuesta)
'porcentaje_encuesta = 75

c_es_profesor = " Select count(*) from bloques_profesores a, bloques_horarios b, secciones c "&_
                  " where a.bloq_ccod=b.bloq_ccod and b.secc_ccod=c.secc_ccod and c.peri_ccod=226 "&_
				  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='21' "
es_profesor = conexion.consultaUno(c_es_profesor)

c_es_alumno = " Select count(*) from alumnos a, ofertas_academicas b, especialidades c"&_
                " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "&_
				" and a.emat_ccod <> 9 and b.peri_ccod=226 and c.carr_ccod='21' "&_
				" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'"
es_alumno = conexion.consultaUno(c_es_alumno)
  
c_es_administrativo = " Select count(*) from personas where pers_nrut in (9498228,7013653,8099825,2633087,9975051,13687557,15740666) "&_
                      " and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
es_administrativo = conexion.consultaUno(c_es_administrativo)

%>

<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: black;
}

#menu div.barraMenu {
text-align: left;
}
.notificacion
{
	text-align:justify;
	font-size:14px;
	color:#000;
	font:serif; 
}
.nombre
{
	text-align: left;
	font: bold 14px;
	color:#000;
	font:serif; 
	font-weight: 500; 
}
.area
{
	text-align: left;
	font-size:13px;
	color:#666;
	font-weight: 10; 
}
#menu div.barraMenu a.botonMenu {
background-color: #EAEAEA;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #EAEAEA;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #EAEAEA;
color: white;
}
        .calFondoCalendario {background-color:#EAEAEA}
		.calEncabe {font-family:Arial, Helvetica, sans-serif; font-size:11px; color:black}
		.calFondoEncabe {background-color:#EAEAEA}
		.calDias {font-family:Arial, Helvetica, sans-serif; font-size:11px; font-weight:900}
		.calSimbolo {font-family:Arial, Helvetica, sans-serif; font-size:13px; text-decoration:none; font-weight:500; color:black}
		.calResaltado {font-family:Arial, Helvetica, sans-serif; font-size:13px; text-decoration:none; font-weight:700}
		.calCeldaResaltado {background-color:lightyellow}
		.calEvaluado {font-family:Arial, Helvetica, sans-serif; font-size:18px; text-decoration:none; font-weight:700; color:blue}
		.calCeldaEvaluado {background-color:#EAEAEA}
</style>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
function muestra (dia, mes,anio,codigo)
{
	//alert ("d�a "+dia+" mes "+mes+" anio "+anio);
	var direccion = "ver_evaluaciones.asp?dia="+ dia+"&mes="+mes+"&anio="+anio+"&codigo="+codigo;
	window.open(direccion,"ventana1","width=310, height=400, scrollbars=yes, menubar=no, location=no, resizable=no"); 

}
function carga_mensaje (mepe, pers, tipo)
{
	//alert ("d�a "+dia+" mes "+mes+" anio "+anio);
	var direccion = "../REG_DEF_EVALUACIONES/editar_mensaje.asp?mepe_ncorr="+ mepe+"&pers_ncorr="+pers+"&tipo="+tipo;
	window.open(direccion,"ventana6","width=600, height=440, scrollbars=yes, menubar=no, location=no, resizable=no"); 

}
function redireccionar_mensaje(pers_ncorr,tipo)
{
	var direccion = "redireccionar.asp?pers_ncorr="+pers_ncorr+"&tipo="+tipo;
	window.open(direccion,"ventana76","width=600, height=600, scrollbars=yes, menubar=yes, location=yes, resizable=yes"); 
}
function abrir_mensajeria()
{
	document.mensajes.submit();
}
function abrir_votacion()
{
	irA("../web_votacion/index.asp", "1", 700, 550);
}

</script>

<body bgcolor="#EAEAEA">
<%if f_asignaturas.nroFilas > 0 or es_administrativo > "0" then%>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr valign="top">
		<td width="67" height="90">
			<img width="67" height="90" src="../imagenes/PNGs/profe_enano.png" border="0">
		</td>
		<td align="left">
			<table width="70%" align="left" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="2" width="100%"><font size="3" color="#cc6600" face="Georgia, Times New Roman, Times, serif"><strong>Bienvenido(a) Profesor(a) <%=nombre%></strong></font></td>
				</tr>
				<tr>
					<td width="95%"><font size="2" color="#003366" face="Georgia, Times New Roman, Times, serif"><div align="justify">A trav�s de este sitio podr� ingresar la programaci�n de controles y calificaciones para las diferentes asignaturas que dicte en el semestre, mantener comunicaci�n con los alumnos, imprimir su horario semestral, ver resultados de evaluaci�n docente, entre otras actividades.<br>Lo(a) invitamos a navegar por las diferentes opciones.</div></font></td>
				</tr>
				<tr>
					<td colspan="2" width="100%" align="center">&nbsp;</td>
				</tr>
				<%if es_alumno > "0" or es_profesor > "0" or es_administrativo > "0" then%>
				<tr>
					<td colspan="2" width="100%" align="center">
					<a href="javascript:abrir_votacion();" title="Accede a la Votaci�n Online presionando aqu�"><img width="555" height="112" src="../web_votacion/boton_votacion.jpg" border="0"></a>
					</td>
				</tr>
				<tr>
					<td colspan="2" width="100%" align="center">&nbsp;</td>
				</tr>
				<%end if%>
				<tr>
					<td colspan="2" width="100%"  height="80" align="center"><font color="#009933" size="2" face="Georgia, Times New Roman, Times, serif"><font color="#003366" size="2" face="Georgia, Times New Roman, Times, serif">Cuenta de Email Institucional...:</font> <%=email_docente%></font></td>
				</tr>
                <tr>
    				<td width="100%">
                    <table width="100%" border="0">
  <tr>
  	<td align="center">
              <img width="562" height="184" src="../imagenes/docentes365.png">
    </td>
  </tr>
  <tr valign="top">
		<td width="100%" align="center">
        	<table width="562" bgcolor="#000000" cellpadding="0" cellspacing="0">
               <tr>
               	  <td width="100%" align="right">
                  	<a href="http://www.youtube.com/watch?v=m0SlrBhk4Xs&feature=share&list=PLXPr7gfUMmKyN0PGs-cY7SLxJPt8CcFdk" target="_blank">
                    	<font size="+1" color="#FFFF66" face="Times New Roman, Times, serif">Descubre Office 365 (Youtube)</font>
                    </a>
                  </td>                  
               </tr>
            </table>
        </td>
	</tr>
  <tr>
  	<td>&nbsp;</td>
  </tr>
  <tr>
    <td><font size="3" color="#cc6600" face="Georgia, Times New Roman, Times, serif"><hr/>Estimado Docente:</font></td>
  </tr>
  <tr>
    <td class="notificacion">Gusto en saludarlo, por intermedio del presente comunicado, queremos informarle que a partir de este d&iacute;a Lunes 12 del presente, en su acceso a su portal docente, encontrar&aacute; la siguiente opci&oacute;n �Solicitar Soporte�</td>
  </tr>
  <tr>
    <td><img width="600" height="172"  src="../imagenes/noti_prof_2.gif" border="0" ></td>
  </tr>
  <tr>
    <td class="notificacion">Lo anterior, est� orientado principalmente a los docentes que hacen uso de los laboratorios de computaci&oacute;n, no obstante puede ser utilizado para reportar errores de nuestros servicios ON Line. Buscamos mejorar y mantener nuestros servicios acad&eacute;micos, su ayuda y comentarios, son importantes para nosotros.<br/><br/>Atte.-</td>
  </tr>
  <tr>
    <td class="nombre">FERNANDO CIFUENTES G.</td>
<tr>
    <td class="area">DIRECTOR DE TECNOLOG�A DE LA INFORMACI�N.<hr/></td>
  </tr>
</table>
 
                    </td>
    			</tr>
				<tr>
					<td colspan="2" width="100%" align="center">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	  <td colspan="2" align="left">
		<table width="100%" cellpadding="0" cellspacing="0">
		<tr valign="top">
	      <td width="448" height="349"> 
            <table width="447" height="346" align="center" cellpadding="0" cellspacing="0">
              <tr valign="top">
				<td  width="100%" height="344" align="center"> 
                  <table width="95%" align="center" cellpadding="0" cellspacing="0">
										<tr>
										    <td colspan="2" height="30">
											 <form name="mensajes" action="../REG_DEF_EVALUACIONES/MENSAJES_PROFESOR.ASP" target="_top">
											  <table width="360" cellpadding="0" cellspacing="0">
											  	<tr>
													<td width="60%" align="left"><font color="#cc6600" face="Georgia, Times New Roman, Times, serif">Mensajes Internos</font></td>
													<td width="40%" align="center"><input type="button" name="ver_mensajes" value="Enviar Mensaje" onClick="javascript:abrir_mensajeria();" title="Abrir aplicaci�n de mensajer�a"></td>
												</tr>
											  </table>
											 </form>
											</td>
										</tr>
										<tr>
										    <td width="95%">
												<script type="text/javascript">
														/******************************************
														* Scrollable content script II- � Dynamic Drive (www.dynamicdrive.com)
														* Visit http://www.dynamicdrive.com/ for full source code
														* This notice must stay intact for use
														******************************************/
														
														iens6=document.all||document.getElementById
														ns4=document.layers
														
														//specify speed of scroll (greater=faster)
														var speed=5
														
														if (iens6){
														document.write('<div id="container" style="position:relative;width:360px;height:310px;border:0px solid black;overflow:hidden">')
														document.write('<div id="content" style="position:absolute;width:355px;left:0;top:0">')
														}
												</script>
												<ilayer name="nscontainer" width=360 height=160 clip="0,0,360,160">
													<layer name="nscontent" width=360 height=160 visibility=hidden>
													<!--INSERT CONTENT HERE-->
													<%
													   if f_mensajes.nroFilas > 0 then  'Para cuando tenga mensajes ingresados
													   while f_mensajes.siguiente
															fecha_emision = f_mensajes.obtenerValor("fecha_emision")
															de = f_mensajes.obtenerValor("de")
															titulo = f_mensajes.obtenerValor("titulo")
															pers_ncorr2 = f_mensajes.obtenerValor("pers_ncorr")
															mepe_ncorr = f_mensajes.obtenerValor("mepe_ncorr")
															tipo_origen = f_mensajes.obtenerValor("tipo_origen")
															url_mensaje = "javascript: carga_mensaje("&mepe_ncorr& "," &pers_ncorr2& "," &tipo_origen& ");"
													%>
													      <table width="100%" border="1">
													   	  <tr>
														  	  <td align="center"><font size="1" face="Arial" color="#003366"><%=fecha_emision%></font></td>	
															  <td align="left" bgcolor="#cc6600"><font size="1" face="Arial" color="#FFFFFF"><strong><%=de%></strong></font></td>
														  </tr>
														  <tr>
														  	  <td colspan="2"><font size="-2" face="Arial" color="#003366"><%=titulo%>&nbsp;<a href="<%=url_mensaje%>">Ver Mensaje</a></font></td>	
														  </tr>	
													   </table>
													   <br>
													<%wend
													  else %>
													   <table width="100%" border="0">
													   	  <tr>
														  	  <td width="98%">
															    <div align="justify">
																 <font size="2" face="Georgia, Times New Roman, Times, serif" color="#cc6600">
																  En esta secci�n aparecer�n los mensajes internos enviados por las escuelas en las que imparta clases o bien los alumnos de sus asignaturas.<br>En este momento no presenta mensajes en su bandeja de entrada.<br>Cabe destacar que estos mensajes son independientes de los correos electr�nicos que reciba.<br>Si desea enviar un mensaje a alguna secci�n o alumno en particular, presione el bot�n "Enviar Mensaje". 
																 </font>
																</div>
															  </td>	
														  </tr>	
													   </table>
													   <%end if%>
													<!--END CONTENT-->
													</layer>
												</ilayer>
												<script language="JavaScript1.2">
													if (iens6)
														document.write('</div></div>')
												</script>
												<!--<table width="360px">
												<td>
												   <p align="right">
													<a href="#" onMouseover="moveup()" onMouseout="clearTimeout(moveupvar)"><img src="../imagenes/PNGs/up.gif" border=0></a>  
													<a href="#" onMouseover="movedown()" onMouseout="clearTimeout(movedownvar)"><img src="../imagenes/PNGs/down.gif" border=0></a>
													</p>
												</td>
												</table>-->
												<script language="JavaScript1.2">
													if (iens6)
													{
														var crossobj=document.getElementById? document.getElementById("content") : document.all.content
														var contentheight=crossobj.offsetHeight
													}
													else if (ns4)
													{
														var crossobj=document.nscontainer.document.nscontent
														var contentheight=crossobj.clip.height
													}
													function movedown()
													{
														if (iens6&&parseInt(crossobj.style.top)>=(contentheight*(-1)+100))
																crossobj.style.top=parseInt(crossobj.style.top)-speed+"px"
														else if (ns4&&crossobj.top>=(contentheight*(-1)+100))
																crossobj.top-=speed
														movedownvar=setTimeout("movedown()",20)
													}
													
													function moveup()
													{
														if (iens6&&parseInt(crossobj.style.top)<=0)
															crossobj.style.top=parseInt(crossobj.style.top)+speed+"px"
														else if (ns4&&crossobj.top<=0)
															crossobj.top+=speed
														moveupvar=setTimeout("moveup()",20)
													}
													
													function getcontent_height()
													{
														if (iens6)
															contentheight=crossobj.offsetHeight
														else if (ns4)
															document.nscontainer.document.nscontent.visibility="show"
													}
													window.onload=getcontent_height
												</script>
											</td>
											<td width="5%">
												<table width="100%" cellpadding="0" cellspacing="0">
													<tr valign="top">
														<td width="100%" height="155" align="center"><a href="#" onMouseover="moveup()" onMouseout="clearTimeout(moveupvar)"><img src="../imagenes/PNGs/up.gif" border=0></a></td>
													</tr>
													<tr valign="bottom">
														<td width="100%" height="155" align="center"><a href="#" onMouseover="movedown()" onMouseout="clearTimeout(movedownvar)"><img src="../imagenes/PNGs/down.gif" border=0></a></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td> 
							</tr>
						</table>
					</td> 					
					<td width="10">&nbsp;</td>
					<td align="left">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr valign="top">
							<td width="290" align="left">
							<table width="293" border="1">
								<tr valign="top">
									<td colspan="2" bgcolor="#003366" align="center"><font color="#FFFFFF" face="Georgia, Times New Roman, Times, serif"><strong>Accesos Directos</strong></font></td>
								</tr>
								<tr>
									<td width="135" align="center"><input type="button" name="email" value="Email" onClick="javascript: redireccionar_mensaje(<%=pers_ncorr%>,2);" title="Acceder a email institucional"></td>
									<td width="139" align="center"><input type="button" name="aula" value="Aula Virtual" onClick="javascript: redireccionar_mensaje(<%=pers_ncorr%>,1);" title="Acceder a aplicaci�n Aula virtual (Moodle)"></td>
								</tr>
							</table>
							<br>
						<table width="291" border="1" bgcolor="#EAEAEA">
							<tr>
								<td width="100%" align="center" bgcolor="#003366"><font color="#FFFFFF" face="Georgia, Times New Roman, Times, serif"><strong>Evaluaciones Programadas</strong></font></td>
							</tr>
							<tr>
								<td width="100%">
								<%Const URLDestino = "OtraPagina.asp" 
									Dim MyMonth 'Month of calendar
									Dim MyYear 'Year of calendar
									Dim FirstDay 'First day of the month. 1 = Monday
									Dim CurrentDay 'Used to print dates in calendar
									Dim Col 'Calendar column
									Dim Row 'Calendar row
									
									MyMonth = Request.Querystring("Month")
									MyYear = Request.Querystring("Year")
									
									If IsEmpty(MyMonth) then MyMonth = Month(Date)
									if IsEmpty(MyYear) then MyYear = Year(Date)
									
									'invocar a la busqueda de evaluaciones del elaumno apra este a�o.-
									set f_evaluaciones = new CFormulario
									f_evaluaciones.Carga_Parametros "tabla_vacia.xml", "tabla"
									f_evaluaciones.Inicializar conexion
									consulta =  "  select distinct cali_fevaluacion,datepart(day,cali_fevaluacion) as dia_evaluacion, datepart(month,cali_fevaluacion) as mes_evaluacion, "& vbCrLf &_	
												"  datepart(year,cali_fevaluacion) as anio_evaluacion  "& vbCrLf &_	
												"  from bloques_profesores a, bloques_horarios b, secciones c, "& vbCrLf &_	
												"  calificaciones_seccion e "& vbCrLf &_	
											    "  where a.bloq_ccod=b.bloq_ccod and a.tpro_ccod=1 "& vbCrLf &_	
												"  and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbCrLf &_
												"  and b.secc_ccod = c.secc_ccod and c.secc_ccod=e.secc_ccod "& vbCrLf &_	
												"  and cast(datepart(month,cali_fevaluacion) as varchar) ='"&MyMonth&"' "& vbCrLf &_
												"  and cast(datepart(year,cali_fevaluacion) as varchar)  ='"&MyYear&"' "& vbCrLf &_	
											    "  order by cali_fevaluacion asc"
									f_evaluaciones.Consultar consulta 
																	
									Call ShowHeader (MyMonth, MyYear)
									
									FirstDay = WeekDay(DateSerial(MyYear, MyMonth, 1)) -1
									CurrentDay = 1
									
									'Let's build the calendar
									For Row = 0 to 5
										For Col = 0 to 6
											If Row = 0 and Col < FirstDay then
												response.write "<td>&nbsp;</td>"
											elseif CurrentDay > LastDay(MyMonth, MyYear) then
												response.write "<td>&nbsp;</td>"
											else
												response.write "<td"
												
												f_evaluaciones.primero
												coincide = 0 ' indica si el dia a dibujar corresponde a un d�a para evaluar
												while f_evaluaciones.siguiente
													dia_eva  = f_evaluaciones.obtenerValor("dia_evaluacion")
													mes_eva  = f_evaluaciones.obtenerValor("mes_evaluacion")
													anio_eva = f_evaluaciones.obtenerValor("anio_evaluacion")
													if cInt(MyYear) = cInt(anio_eva) and cInt(MyMonth) = cInt(mes_eva) and CurrentDay = Cint(dia_eva) then 
														coincide = 1	
													end if
												wend
												
												if coincide = 1 then
													response.write " class='calCeldaEvaluado' align='center'>"
												else
													if cInt(MyYear) = Year(Date) and cInt(MyMonth) = Month(Date) and CurrentDay = Day(Date) then 
														response.write " class='calCeldaResaltado' align='center'>"
													else 
														response.write " align='center'>"
													end if
												end if 
												if coincide = 1 then
													response.write "<a href='javascript: muestra(" & CurrentDay _
																& "," & MyMonth & "," & MyYear & "," & pers_ncorr & ");' title='Presione en el d�a para ver las evaluaciones.'>" 
												end if
												if coincide = 1 then
													Response.Write "<div class='calEvaluado'>" 
												else
													if cInt(MyYear) = Year(Date) and cInt(MyMonth) = Month(Date) and CurrentDay = Day(Date) then 
														Response.Write "<div class='calResaltado'>" 
													else
														Response.Write "<div class='calSimbolo'>" 
													end if
												end if
												if Col = 0 then' Para poner en rojo los domingos
													Response.Write "<font color='#990000'>" & CurrentDay & " </font></div>"
												else
													Response.Write CurrentDay & "</div>"
												end if
												
												if coincide = 1 then
													Response.Write "</a>"
												end if
												Response.Write "</td>"
												CurrentDay = CurrentDay + 1
											End If
										Next
										response.write "</tr>"
									Next
								    response.write "</table>"%>
								</td>
							</tr>
						</table>
							</td>
							<td width="480">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<%'if f_asignaturas.nroFilas > 0 then%>
	<!--<tr valign="top">
	   <td colspan="2" align="left">
	     <table width="60%" border="0" cellpadding="2" cellspacing="2">
		    <tr><td colspan="6" align="left"><font color="#cc6600">Resumen asignaturas 1er Semestre.-</font></td></tr>	
			<tr>
				<td bgcolor="#999999"><strong>Asignatura</strong></td>
				<td bgcolor="#00CC66">N�Alumnos</td>
				<td bgcolor="#e3692c">Programada</td>
				<td bgcolor="#4bb9fe">Parciales</td>
				<td bgcolor="#b4c846">Finales</td>
				<td  bgcolor="#e9cd49">Cerrada</td>
			</tr>
			<%'while f_asignaturas.siguiente
			  'asignatura = f_asignaturas.obtenerValor("asignatura")	
			  'total_alumnos	= f_asignaturas.obtenerValor("total_alumnos")
			  'programada	= f_asignaturas.obtenerValor("programada")
			  'if programada = "SI" then
			 ' 	color_programada = "#00CC33"
			 ' else
			 '   color_programada = "#CC3300"
			 ' end if
			 ' notas_parciales	= f_asignaturas.obtenerValor("notas_parciales")
			 ' if notas_parciales = "SI" then
			 ' 	color_parciales = "#00CC33"
			 ' else
			 '   color_parciales = "#CC3300"
			 ' end if
			 ' notas_finales	= f_asignaturas.obtenerValor("notas_finales")
			 ' if notas_finales = "SI" then
			 ' 	color_finales = "#00CC33"
			 ' else
			 '   color_finales = "#CC3300"
			 ' end if
			 ' cerrada = f_asignaturas.obtenerValor("cerrada")
			 ' if cerrada = "SI" then
			 ' 	color_cerrada = "#00CC33"
			 ' else
			 '   color_cerrada = "#CC3300"
			 ' end if
              %>
			<tr>
				<td align="left" bgcolor="#FFFFFF"><font size="-2" color="#333333"><strong><%'=asignatura%></strong></font></td>
				<td align="center" bgcolor="#FFFFFF"><font  color="#333333"><strong><%'=total_alumnos%></strong></font></td>
				<td align="center" bgcolor="#FFFFFF"><font  color="<%'=color_programada%>"><strong><%'=programada%></strong></font></td>
				<td align="center" bgcolor="#FFFFFF"><font  color="<%'=color_parciales%>"><strong><%'=notas_parciales%></strong></font></td>
				<td align="center" bgcolor="#FFFFFF"><font  color="<%'=color_finales%>"><strong><%'=notas_finales%></strong></font></td>
				<td align="center" bgcolor="#FFFFFF"><font  color="<%'=color_cerrada%>"><strong><%'=cerrada%></strong></font></td>
			</tr>
			<%'wend%>
		 </table>
	   </td>
	</tr>-->
	<%'end if%>
</table>

<%Sub ShowHeader(MyMonth,MyYear)
%>
<table border='0' cellspacing='3' cellpadding='3' width='285' align='center' class="calFondoCalendario" bordercolor="#EAEAEA">
	<tr align='center'> 
		<td colspan='7'>
			<table border='0' cellspacing='1' cellpadding='1' width='100%' class="calFondoEncabe">
				<tr valign="TOP">
					<td align='left' valign="middle">
						<%
						response.write "<a href = 'blanco.asp?"
						if MyMonth - 1 = 0 then 
							response.write "month=12&year=" & MyYear -1
						else 
							response.write "month=" & MyMonth - 1 & "&year=" & MyYear
						end if
						response.write "'><span class='calSimbolo'><img width='5' height='18' src='../imagenes/PNGs/flecha_izquierda.png' border='0'></span></a>"

						response.write "<span class='calEncabe'><font size='3' color='#009933' face='Georgia, Times New Roman, Times, serif'>&nbsp;" & MonthName(MyMonth) & "&nbsp;</font></span>"

						response.write "<a href = 'blanco.asp?"
						if MyMonth + 1 = 13 then 
							response.write "month=1&year=" & MyYear + 1
						else 
							response.write "month=" & MyMonth + 1 & "&year=" & MyYear
						end if
						response.write "'><span class='calSimbolo'><img width='5' height='18' src='../imagenes/PNGs/flecha_derecha.png' border='0'></span></a>"
						%>
					</td>
					<td align='center'>
						<%
						response.write "<a href = 'blanco.asp?"
						response.write "month=" & Month(Date()) & "&year=" & Year(Date())
						response.write "'><div class='calSimbolo'>&nbsp;</div></a>"
						%>						
					</td>
					<td align='right'>
						<%
						response.write "<a href = 'blanco.asp?"
						response.write "month=" & MyMonth & "&year=" & MyYear -1
						response.write "'><span class='calSimbolo'><img width='5' height='18' src='../imagenes/PNGs/flecha_izquierda.png' border='0'></span></a>"

						response.write "<span class='calEncabe'><font size='3' color='#009933' face='Georgia, Times New Roman, Times, serif'>&nbsp;" & MyYear & "&nbsp;</font></span>"
						response.write "<a href = 'blanco.asp?"
						response.write "month=" & MyMonth & "&year=" & MyYear + 1
						response.write "'><span class='calSimbolo'><img width='5' height='18' src='../imagenes/PNGs/flecha_derecha.png' border='0'></span></a>"
						%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr align='center'> 
		<td bgcolor="#EAEAEA"><div class='calDias'><font color="#990000">Do</font></div></td>
		<td bgcolor="#EAEAEA"><div class='calDias'>Lu</div></td>
		<td bgcolor="#EAEAEA"><div class='calDias'>Ma</div></td>
		<td bgcolor="#EAEAEA"><div class='calDias'>Mi</div></td>
		<td bgcolor="#EAEAEA"><div class='calDias'>Ju</div></td>
		<td bgcolor="#EAEAEA"><div class='calDias'>Vi</div></td>
		<td bgcolor="#EAEAEA"><div class='calDias'>Sa</div></td>
	</tr>
<%
End Sub

Function MonthName(MyMonth)
	Select Case MyMonth
		Case 1
			MonthName = "Enero"
		Case 2
			MonthName = "Febr."
		Case 3
			MonthName = "Marzo"
		Case 4
			MonthName = "Abril"
		Case 5
			MonthName = "Mayo"
		Case 6
			MonthName = "Junio"
		Case 7
			MonthName = "Julio"
		Case 8
			MonthName = "Ago."
		Case 9
			MonthName = "Sept."
		Case 10
			MonthName = "Oct."
		Case 11
			MonthName = "Nov."
		Case 12
			MonthName = "Dic."
		Case Else
			MonthName = "ERROR!"
	End Select
End Function

Function LastDay(MyMonth, MyYear)
' Returns the last day of the month. Takes into account leap years
' Usage: LastDay(Month, Year)
' Example: LastDay(12,2000) or LastDay(12) or Lastday


	Select Case MyMonth
		Case 1, 3, 5, 7, 8, 10, 12
			LastDay = 31

		Case 4, 6, 9, 11
			LastDay = 30

		Case 2
			If IsDate(MyYear & "-" & MyMonth & "-" & "29") Then LastDay = 29 Else LastDay = 28

		Case Else
			LastDay = 0
	End Select
End Function
%>
<%end if%>

