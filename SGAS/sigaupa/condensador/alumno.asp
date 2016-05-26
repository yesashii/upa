<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: POSTULACION
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 28/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=
'LINEA				          : 93, 555, 556, 557
'********************************************************************
set conexion = new CConexion
conexion.Inicializar "upacifico"

pers_nrut = request.queryString("busqueda[0][pers_nrut]")
pers_xdv = request.queryString("busqueda[0][pers_xdv]")
periodo_consulta = request.queryString("busqueda[0][peri_ccod]")

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "inicio_toma_carga_alfa.xml", "busqueda_alumno"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente



v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
v_anio_actual 	= 	Year(now())

filtrar_periodo = 0

if periodo_consulta = "" then 
	if v_mes_actual <= 02 then
	  ano_consulta = v_anio_actual - 1
	  periodo_consulta = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&ano_consulta&"' and plec_ccod = 2")
	elseif v_mes_actual >= 03 and v_mes_actual <= 08 then
	  ano_consulta = v_anio_actual
	  periodo_consulta = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&ano_consulta&"' and plec_ccod = 1")
	else
	  ano_consulta = v_anio_actual
	  periodo_consulta = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&ano_consulta&"' and plec_ccod = 2")
	end if
else
   filtrar_periodo = 1
end if

ano_consulta = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo_consulta&"'")

f_busqueda.AgregaCampoCons "pers_nrut", pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", pers_xdv
f_busqueda.AgregaCampoCons "peri_ccod", periodo_consulta

condicion_periodo = ""
if filtrar_periodo = 1 then
	condicion_periodo = " and cast(d.peri_ccod as varchar)='"&periodo_consulta&"'"
end if

set datos_personales = new CFormulario
datos_personales.Carga_Parametros "tabla_vacia.xml", "tabla"
datos_personales.Inicializar conexion
'consulta_datos =  " select ta.pers_ncorr,protic.format_rut(pers_nrut) as rut,ta.pers_xdv, "& vbCrLf &_
'				  " protic.initcap(ta.pers_tnombre + ' ' + ta.pers_tape_paterno + ' ' + ta.pers_tape_materno) as nombre, "& vbCrLf &_
'				  " protic.initCap(tb.sexo_tdesc) as sexo, protic.initCap(tc.pais_tdesc) as pais, "& vbCrLf &_
'				  " protic.initCap(protic.obtener_direccion_letra(ta.pers_ncorr,1,'CNPB')) as direccion, protic.initCap(protic.obtener_direccion_letra(ta.pers_ncorr,1,'C-C')) as comuna, "& vbCrLf &_
'				  " pers_tfono as telefono, pers_tcelular as celular, lower(pers_temail) as email_p, (select top 1 lower(email_nuevo) from cuentas_email_upa tt where tt.pers_ncorr=ta.pers_ncorr) as email_u, "& vbCrLf &_
'				  "	 (select top 1 carr_tdesc from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
'				  "	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "&condicion_periodo& vbCrLf &_
'				  "	   and c.pers_ncorr=ta.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as carrera, "& vbCrLf &_
'				  "	 (select top 1 emat_tdesc from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
'				  "	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "&condicion_periodo& vbCrLf &_
'				  "	   and c.pers_ncorr=ta.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as estado, "& vbCrLf &_
'				  "	 (select top 1 cast(anos_ccod as varchar)+'-'+cast(plec_ccod as varchar) from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
'				  "	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "&condicion_periodo& vbCrLf &_
'				  "	   and c.pers_ncorr=ta.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as periodo, "& vbCrLf &_
'				  "	 (select top 1 f.carr_ccod from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
'				  "	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "&condicion_periodo& vbCrLf &_
'				  "	   and c.pers_ncorr=ta.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as carr_ccod, "& vbCrLf &_
'				  "	 (select top 1 plan_ccod from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
'				  "	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "&condicion_periodo& vbCrLf &_
'				  "	   and c.pers_ncorr=ta.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as plan_ccod, "& vbCrLf &_
'				  "	 (select top 1 c.matr_ncorr from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
'				  "	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod and cast(d.peri_ccod as varchar)='"&periodo_consulta&"'"& vbCrLf &_
'				  "	   and c.pers_ncorr=ta.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by c.alum_fmatricula desc) as matr_ncorr "& vbCrLf &_
'				  " from personas_postulante ta,sexos tb,paises tc "& vbCrLf &_
'				  " where cast(ta.pers_nrut as varchar)='"&pers_nrut&"' "& vbCrLf &_
'				  " and ta.sexo_ccod *= tb.sexo_ccod "& vbCrLf &_
'				  " and ta.pais_ccod = tc.pais_ccod"

'----------------------------------------------------------------------------------------------------------Nueva consulta 2008
consulta_datos =  " select ta.pers_ncorr,                                                      " & vbCrLf &_
"       protic.format_rut(pers_nrut)                                             as rut,       " & vbCrLf &_
"       ta.pers_xdv,                                                                           " & vbCrLf &_
"       protic.initcap(ta.pers_tnombre + ' ' + ta.pers_tape_paterno                            " & vbCrLf &_
"                      + ' ' + ta.pers_tape_materno)                             as nombre,    " & vbCrLf &_
"       protic.initcap(tb.sexo_tdesc)                                            as sexo,      " & vbCrLf &_
"       protic.initcap(tc.pais_tdesc)                                            as pais,      " & vbCrLf &_
"       protic.initcap(protic.obtener_direccion_letra(ta.pers_ncorr, 1, 'CNPB')) as direccion, " & vbCrLf &_
"       protic.initcap(protic.obtener_direccion_letra(ta.pers_ncorr, 1, 'C-C'))  as comuna,    " & vbCrLf &_
"       pers_tfono                                                               as telefono,  " & vbCrLf &_
"       pers_tcelular                                                            as celular,   " & vbCrLf &_
"       lower(pers_temail)                                                       as email_p,   " & vbCrLf &_
"       (select top 1 lower(email_nuevo)                                                       " & vbCrLf &_
"        from   cuentas_email_upa tt                                                           " & vbCrLf &_
"        where  tt.pers_ncorr = ta.pers_ncorr)                                   as email_u,   " & vbCrLf &_
"       (select top 1 carr_tdesc                                                               " & vbCrLf &_
"        from   alumnos as c (nolock)                                                          " & vbCrLf &_
"               inner join ofertas_academicas as d                                             " & vbCrLf &_
"                       on c.ofer_ncorr = d.ofer_ncorr                                         " & vbCrLf &_
"               "& condicion_periodo & vbCrLf &_  
"               inner join especialidades as e                                                 " & vbCrLf &_
"                       on d.espe_ccod = e.espe_ccod                                           " & vbCrLf &_
"               inner join carreras as f                                                       " & vbCrLf &_
"                       on e.carr_ccod = f.carr_ccod                                           " & vbCrLf &_
"               inner join estados_matriculas as g                                             " & vbCrLf &_
"                       on c.emat_ccod = g.emat_ccod                                           " & vbCrLf &_
"                          and c.emat_ccod <> 9                                                " & vbCrLf &_
"               inner join periodos_academicos as h                                            " & vbCrLf &_
"                       on d.peri_ccod = h.peri_ccod                                           " & vbCrLf &_
"        where  c.pers_ncorr = ta.pers_ncorr                                                   " & vbCrLf &_
"        order  by d.peri_ccod desc)                                             as carrera,   " & vbCrLf &_
"       (select top 1 emat_tdesc                                                               " & vbCrLf &_
"        from   alumnos as c (nolock)                                                          " & vbCrLf &_
"               inner join ofertas_academicas as d                                             " & vbCrLf &_
"                       on c.ofer_ncorr = d.ofer_ncorr                                         " & vbCrLf &_
"				"& condicion_periodo & vbCrLf &_   
"               inner join especialidades as e                                                 " & vbCrLf &_
"                       on d.espe_ccod = e.espe_ccod                                           " & vbCrLf &_
"               inner join carreras as f                                                       " & vbCrLf &_
"                       on e.carr_ccod = f.carr_ccod                                           " & vbCrLf &_
"               inner join estados_matriculas as g                                             " & vbCrLf &_
"                       on c.emat_ccod = g.emat_ccod                                           " & vbCrLf &_
"               inner join periodos_academicos as h                                            " & vbCrLf &_
"                       on d.peri_ccod = h.peri_ccod                                           " & vbCrLf &_
"        where  c.pers_ncorr = ta.pers_ncorr                                                   " & vbCrLf &_
"               and c.emat_ccod <> 9                                                           " & vbCrLf &_
"        order  by d.peri_ccod desc)                                             as estado,    " & vbCrLf &_
"       (select top 1 cast(anos_ccod as varchar) + '-'                                         " & vbCrLf &_
"                     + cast(plec_ccod as varchar)                                             " & vbCrLf &_
"        from   alumnos as c (nolock)                                                          " & vbCrLf &_
"               inner join ofertas_academicas as d                                             " & vbCrLf &_
"                       on c.ofer_ncorr = d.ofer_ncorr                                         " & vbCrLf &_
"               "& condicion_periodo & vbCrLf &_  
"               inner join especialidades as e                                                 " & vbCrLf &_
"                       on d.espe_ccod = e.espe_ccod                                           " & vbCrLf &_
"               inner join carreras as f                                                       " & vbCrLf &_
"                       on e.carr_ccod = f.carr_ccod                                           " & vbCrLf &_
"               inner join estados_matriculas as g                                             " & vbCrLf &_
"                       on c.emat_ccod = g.emat_ccod                                           " & vbCrLf &_
"               inner join periodos_academicos as h                                            " & vbCrLf &_
"                       on d.peri_ccod = h.peri_ccod                                           " & vbCrLf &_
"        where  c.pers_ncorr = ta.pers_ncorr                                                   " & vbCrLf &_
"               and c.emat_ccod <> 9                                                           " & vbCrLf &_
"        order  by d.peri_ccod desc)                                             as periodo,   " & vbCrLf &_
"       (select top 1 f.carr_ccod                                                              " & vbCrLf &_
"        from   alumnos as c (nolock)                                                          " & vbCrLf &_
"               inner join ofertas_academicas as d                                             " & vbCrLf &_
"                       on c.ofer_ncorr = d.ofer_ncorr                                         " & vbCrLf &_
"				"& condicion_periodo & vbCrLf &_  
"               inner join especialidades as e                                                 " & vbCrLf &_
"                       on d.espe_ccod = e.espe_ccod                                           " & vbCrLf &_
"               inner join carreras as f                                                       " & vbCrLf &_
"                       on e.carr_ccod = f.carr_ccod                                           " & vbCrLf &_
"               inner join estados_matriculas as g                                             " & vbCrLf &_
"                       on c.emat_ccod = g.emat_ccod                                           " & vbCrLf &_
"               inner join periodos_academicos as h                                            " & vbCrLf &_
"                       on d.peri_ccod = h.peri_ccod                                           " & vbCrLf &_
"        where  c.pers_ncorr = ta.pers_ncorr                                                   " & vbCrLf &_
"               and c.emat_ccod <> 9                                                           " & vbCrLf &_
"        order  by d.peri_ccod desc)                                             as carr_ccod, " & vbCrLf &_
"       (select top 1 plan_ccod                                                                " & vbCrLf &_
"        from   alumnos as c (nolock)                                                          " & vbCrLf &_
"               inner join ofertas_academicas as d                                             " & vbCrLf &_
"                       on c.ofer_ncorr = d.ofer_ncorr                                         " & vbCrLf &_
"				"& condicion_periodo & vbCrLf &_  
"               inner join especialidades as e                                                 " & vbCrLf &_
"                       on d.espe_ccod = e.espe_ccod                                           " & vbCrLf &_
"               inner join carreras as f                                                       " & vbCrLf &_
"                       on e.carr_ccod = f.carr_ccod                                           " & vbCrLf &_
"               inner join estados_matriculas as g                                             " & vbCrLf &_
"                       on c.emat_ccod = g.emat_ccod                                           " & vbCrLf &_
"               inner join periodos_academicos as h                                            " & vbCrLf &_
"                       on d.peri_ccod = h.peri_ccod                                           " & vbCrLf &_
"        where  c.pers_ncorr = ta.pers_ncorr                                                   " & vbCrLf &_
"               and c.emat_ccod <> 9                                                           " & vbCrLf &_
"        order  by d.peri_ccod desc)                                             as plan_ccod, " & vbCrLf &_
"       (select top 1 c.matr_ncorr                                                             " & vbCrLf &_
"        from   alumnos as c (nolock)                                                          " & vbCrLf &_
"               inner join ofertas_academicas as d                                             " & vbCrLf &_
"                       on c.ofer_ncorr = d.ofer_ncorr                                         " & vbCrLf &_
"                          and cast(d.peri_ccod as varchar) = '"&periodo_consulta&"'           " & vbCrLf &_
"               inner join especialidades as e                                                 " & vbCrLf &_
"                       on d.espe_ccod = e.espe_ccod                                           " & vbCrLf &_
"               inner join carreras as f                                                       " & vbCrLf &_
"                       on e.carr_ccod = f.carr_ccod                                           " & vbCrLf &_
"               inner join estados_matriculas as g                                             " & vbCrLf &_
"                       on c.emat_ccod = g.emat_ccod                                           " & vbCrLf &_
"               inner join periodos_academicos as h                                            " & vbCrLf &_
"                       on d.peri_ccod = h.peri_ccod                                           " & vbCrLf &_
"        where  c.pers_ncorr = ta.pers_ncorr                                                   " & vbCrLf &_
"               and c.emat_ccod <> 9                                                           " & vbCrLf &_
"        order  by c.alum_fmatricula desc)                                       as matr_ncorr " & vbCrLf &_
"from   personas_postulante as ta                                                              " & vbCrLf &_
"       left outer join sexos as tb                                                            " & vbCrLf &_
"                    on ta.sexo_ccod = tb.sexo_ccod                                            " & vbCrLf &_
"       inner join paises as tc                                                                " & vbCrLf &_
"               on ta.pais_ccod = tc.pais_ccod                                                 " & vbCrLf &_
"where  cast(ta.pers_nrut as varchar) = '"&pers_nrut&"'                                        " 
'------------------------------------------------------------------------------------------------------fin_Nueva consulta 2008				  

datos_personales.Consultar consulta_datos
datos_personales.siguiente
'response.write("<pre>"&consulta_datos&"</pre>")
pers_ncorr = datos_personales.obtenerValor("pers_ncorr")
rut = datos_personales.obtenerValor("rut")
pers_xdv = datos_personales.obtenerValor("pers_xdv")
nombre = datos_personales.obtenerValor("nombre")
sexo = datos_personales.obtenerValor("sexo")
pais = datos_personales.obtenerValor("pais")
direccion = datos_personales.obtenerValor("direccion")
comuna = datos_personales.obtenerValor("comuna")
fono = datos_personales.obtenerValor("telefono")
celular = datos_personales.obtenerValor("celular")
email_p = datos_personales.obtenerValor("email_p")
email_u = datos_personales.obtenerValor("email_u")
carrera = datos_personales.obtenerValor("carrera")
estado = datos_personales.obtenerValor("estado")
periodo = datos_personales.obtenerValor("periodo")
carr_ccod = datos_personales.obtenerValor("carr_ccod")
plan_ccod = datos_personales.obtenerValor("plan_ccod")
matr_ncorr = datos_personales.obtenerValor("matr_ncorr")

f_busqueda.AgregaCampoCons "pers_nrut", pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", pers_xdv
f_busqueda.AgregaCampoCons "peri_ccod", periodo_consulta

tiene_foto  = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from rut_fotos_2010 where cast(rut as varchar)='"&pers_nrut&"'")
tiene_foto2 = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&pers_nrut&"'")

if tiene_foto="S" then 
 	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(imagen)) from rut_fotos_2010 where cast(rut as varchar)='"&pers_nrut&"'")
elseif tiene_foto="N" and tiene_foto2="S" then 
  	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(foto_truta)) from fotos_alumnos where cast(pers_nrut as varchar)='"&pers_nrut&"'")	
else
    nombre_foto = "user.png"
end if

'------------------------------------------------DATOS DE MALLA CURRICULAR y avance académico con una sola consulta-----------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------------
especialidad_plan = conexion.consultaUno("Select espe_tdesc + ' - ' + plan_tdesc from planes_estudio tt, especialidades t2 where tt.espe_ccod=t2.espe_ccod and cast(tt.plan_ccod as varchar)='"&plan_ccod&"'")
set datos_plan = new CFormulario
datos_plan.Carga_Parametros "tabla_vacia.xml", "tabla"
datos_plan.Inicializar conexion
consulta_plan =  " select nive_ccod, ltrim(rtrim(b.asig_ccod)) as asig_ccod, b.asig_tdesc as asignatura, "& vbCrLf &_
				 " isnull(protic.estado_ramo_alumno("&pers_ncorr&",b.asig_ccod,'"&carr_ccod&"',a.plan_ccod,'"&periodo_consulta&"'),'') as aprobado "& vbCrLf &_
				 " from malla_curricular a, asignaturas b "& vbCrLf &_
				 " where a.asig_ccod=b.asig_ccod "& vbCrLf &_
				 " and cast(a.plan_ccod as varchar)='"&plan_ccod&"' and isnull(mall_npermiso,0) <> 1 "& vbCrLf &_
				 " order by nive_ccod "
'response.Write("<pre>"&consulta_plan&"</pre>")
datos_plan.Consultar consulta_plan
datos_plan.siguiente
nivel = datos_plan.obtenerValor("nive_ccod")
datos_plan.primero

'----------------------------------------------CARGA ACADEMICA Y HORARIO DE CLASES-----------------------------------------------------------------------
'--------------------------------------------------------------------------------------------------------------------------------------------------------
peri_ccod = conexion.consultaUno("Select peri_ccod from alumnos a (nolock), ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
sede_ccod = conexion.consultaUno("Select sede_ccod from alumnos a (nolock), ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
v_plec_ccod = conexion.consultaUno("Select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")

set f_alumno = new CFormulario
f_alumno.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumno.Inicializar conexion

consulta = " select c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
		   " protic.horario_con_sala(b.secc_ccod) as horario,  case a.acse_ncorr when 3 then 'Carga Adicional' when 4 then 'Carga Sin Pre-requisitos' else case a.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, "& vbCrLf &_
		   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
           "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
		   " from cargas_Academicas a (nolock), secciones b, asignaturas c " & vbCrLf &_
		   " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
		   " and a.secc_ccod=b.secc_ccod " & vbCrLf &_
		   " and not exists (Select 1 from equivalencias eq (nolock) where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod " & vbCrLf &_
		   " union all " & vbCrLf &_
		   " select c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
		   " protic.horario_con_sala(b.secc_ccod) as horario,'Equivalencia'  as tipo, " & vbCrLf &_
		   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
           "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
		   " from equivalencias a (nolock), secciones b, asignaturas c " & vbCrLf &_
		   " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
		   " and a.secc_ccod=b.secc_ccod " & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod "


if v_plec_ccod = "2" and matr_ncorr <> "" then
	carr_ccod2= conexion.consultaUno("select carr_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
    primer_peri_ccod = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod = 1")    
    'response.Write("carrera "&carrera_a_consultar&" periodo "&primer_peri_ccod&" pers_ncorr "&pers_ncorr_temporal)
	consulta = consulta & "union      select f.asig_ccod as cod_asignatura, f.asig_tdesc as asignatura,e.secc_tdesc as seccion, " & vbCrLf &_
			   "     protic.horario_con_sala(e.secc_ccod) as horario, case acse_ncorr when 3 then 'Carga Adicional' when 4 then 'Carga Sin Pre-requisitos' else case d.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, " & vbCrLf &_
			   "     isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb " & vbCrLf &_
			   "             where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=f.asig_ccod),0) as creditos " & vbCrLf &_
			   "    from alumnos a (nolock), ofertas_academicas b, especialidades c, cargas_academicas d, secciones e, asignaturas f " & vbCrLf &_
			   "    where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
			   "    and cast(b.peri_ccod as varchar)='"&primer_peri_ccod&"' and b.espe_ccod=c.espe_ccod  " & vbCrLf &_
			   "    and c.carr_ccod='"&carr_ccod2&"' and a.emat_ccod in (1,4,8) and f.duas_ccod=3 " & vbCrLf &_
			   "    and not exists (Select 1 from equivalencias eq (nolock) where eq.matr_ncorr=d.matr_ncorr and eq.secc_ccod=d.secc_ccod)  " & vbCrLf &_
			   "    and a.matr_ncorr=d.matr_ncorr and d.secc_ccod=e.secc_ccod and e.asig_ccod=f.asig_ccod " & vbCrLf &_
			   " union " & vbCrLf &_
			   "    select f.asig_ccod as cod_asignatura, f.asig_tdesc as asignatura,e.secc_tdesc as seccion, " & vbCrLf &_
			   "    protic.horario_con_sala(e.secc_ccod) as horario, case isnull(acse_ncorr,0) when 0 then 'Equivalencia' else 'Carga Extraordinaria' end as tipo, " & vbCrLf &_
			   "    isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb " & vbCrLf &_
			   "            where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=f.asig_ccod),0) as creditos " & vbCrLf &_
    		   "    from alumnos a (nolock), ofertas_academicas b, especialidades c, equivalencias d, secciones e, asignaturas f,cargas_academicas ca " & vbCrLf &_
			   "    where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
			   "    and cast(b.peri_ccod as varchar)='"&primer_peri_ccod&"' and b.espe_ccod=c.espe_ccod  " & vbCrLf &_
		       "    and c.carr_ccod='"&carr_ccod2&"' and a.emat_ccod in (1,4,8) " & vbCrLf &_
			   "    and a.matr_ncorr=d.matr_ncorr and d.secc_ccod=e.secc_ccod and e.asig_ccod=f.asig_ccod and f.duas_ccod=3 " & vbCrLf &_
			   "    and d.matr_ncorr=ca.matr_ncorr and d.secc_ccod=ca.secc_ccod"
	
end if
f_alumno.Consultar consulta

consulta_horario_sede = " select a.hora_ccod, cast(datePart(hour,hora_hinicio) as varchar)+':'+cast(datePart(minute,hora_hinicio) as varchar) " & vbCrLf &_ 
                        " + '<br>' + cast(datePart(hour,hora_htermino) as varchar)+':'+cast(datePart(minute,hora_htermino) as varchar) as h  " & vbCrLf &_
						" from horarios a, horarios_sedes b where a.hora_ccod=b.hora_ccod and  cast(sede_ccod as varchar) = '"&sede_ccod&"'  " & vbCrLf &_
						" and isnull(horario_antiguo,0) = 0 and datePart(hour,hora_hinicio) > 0 order by a.hora_ccod asc "

set arreglo_horario = new CFormulario
arreglo_horario.Carga_Parametros "tabla_vacia.xml", "tabla"
arreglo_horario.Inicializar conexion
arreglo_horario.Consultar consulta_horario_sede
total_sede = arreglo_horario.NroFilas

consulta_dias  = "select dias_ccod, dias_tdesc from dias_semana where dias_ccod < 7 order by dias_ccod asc"
set arreglo_dias = new CFormulario
arreglo_dias.Carga_Parametros "tabla_vacia.xml", "tabla"
arreglo_dias.Inicializar conexion
arreglo_dias.Consultar consulta_dias

contador1 = 0
dim arreglo(15,6)
dim colores_horario(15,6)
dim colores(13)

while ( contador1 <= total_sede)
	contador2 = 0
	while ( contador2 <= 6 )
	   arreglo(contador1,contador2) = "&nbsp;"
	   colores_horario(contador1,contador2) = "#FFFFFF"
	   contador2 = contador2 + 1
	wend
	contador1 = contador1 + 1
wend

if total_sede > 0 then
	indice = 0
	arreglo(indice,0) = "Módulo"
    while arreglo_horario.siguiente
	    indice =  indice + 1
		hora_ccod = arreglo_horario.obtenerValor("hora_ccod")
		hora      = arreglo_horario.obtenerValor("h")
		arreglo(hora_ccod,0) = hora
    wend
end if
arreglo_horario.primero

if arreglo_dias.nroFilas > 0 then
	indice = 0
    while arreglo_dias.siguiente
		indice = indice + 1
		dias_ccod  = arreglo_dias.obtenerValor("dias_ccod")
		dias_tdesc = arreglo_dias.obtenerValor("dias_tdesc")
		arreglo(0,dias_ccod) = dias_tdesc
    wend
end if

if plec_ccod <> "1" then
	filtro_matriculas = " and cast(d.matr_ncorr as varchar) in ('"&matr_ncorr&"') "
	filtro_periodo    = " and cast(f.peri_ccod as varchar)= case g.duas_ccod when '3' then '"&primer_peri_ccod&"' else '"&peri_ccod&"' end "
else
	filtro_matriculas = " and cast(d.matr_ncorr as varchar) in ('"&matr_ncorr&"')"
	filtro_periodo    = " and cast(f.peri_ccod as varchar)= '"&peri_ccod&"' "
end if

colores(0) = "#F5A9A9"
colores(1) = "#F5D0A9"
colores(2) = "#F2F5A9"
colores(3) = "#ACFA58"
colores(4) = "#D0F5A9"
colores(5) = "#E0F8EC"
colores(6) = "#A9F5F2"
colores(7) = "#A9D0F5"
colores(8) = "#ECE0F8"
colores(9) = "#FBEFFB"
colores(10) = "#E6E6E6"
colores(11) = "#ACFA58"
colores(12) = "#EFFBF5"

consulta_asignaturas = " select distinct f.asig_ccod,f.secc_ccod " & vbCrLf &_ 
					   " from cargas_academicas d (nolock), secciones f,asignaturas g " & vbCrLf &_ 
					   " where d.secc_ccod=f.secc_ccod and f.asig_ccod=g.asig_ccod " & vbCrLf &_ 
					   " and not exists (select 1 from convalidaciones conv where d.matr_ncorr=conv.matr_ncorr and f.asig_ccod=conv.asig_ccod)  " & vbCrLf &_ 
					   " "&filtro_matriculas&" " & vbCrLf &_ 
					   " "&filtro_periodo&" " 

set arreglo_asignaturas = new CFormulario
arreglo_asignaturas.Carga_Parametros "tabla_vacia.xml", "tabla"
arreglo_asignaturas.Inicializar conexion
arreglo_asignaturas.Consultar consulta_asignaturas

if arreglo_asignaturas.nroFilas > 0 then
  i=0
	while arreglo_asignaturas.siguiente
		asig_ccod_temp  = arreglo_asignaturas.obtenerValor("asig_ccod")
		secc_ccod_temp  = arreglo_asignaturas.obtenerValor("secc_ccod")
		color = colores(i)
		'color_asignatura(asig_ccod_temp) = color
		i = i + 1
    wend
end if

consulta = " select b.sala_ccod,f.asig_ccod,tsal_tdesc,dias_ccod,hora_ccod,cast(f.asig_ccod as varchar)+ '-' + "  & vbCrLf &_ 
		   " cast(f.secc_tdesc as varchar) + ' ' + cast(g.asig_tdesc as varchar)+ ' ' + cast(b.sala_tdesc as varchar)+ ' ' + '' + " & vbCrLf &_ 
		   " protic.profesores_bloque_horario_alumno(a.bloq_ccod) + " & vbCrLf &_ 
    	   " case (select count(*) from horario_asignado_real aaa where aaa.bloq_ccod=a.bloq_ccod) "  & vbCrLf &_ 
           " when 0 then ''  " & vbCrLf &_ 
           " else '<br><font color=#000099>' + " & vbCrLf &_ 
           " 	(select '<strong>Horario Deporte: <br>('+ cast( datepart(hour,hora_hinicio)as varchar)+ ':' + cast( datepart(minute,hora_hinicio)as varchar)+  " & vbCrLf &_ 
      	   " ' -- ' + cast( datepart(hour,hora_htermino)as varchar)+ ':' + cast( datepart(minute,hora_htermino)as varchar)+ ')' "  & vbCrLf &_ 
 		   " from horario_asignado_real aaa,horarios_optativos bbb " & vbCrLf &_ 
		   " where aaa.bloq_ccod=a.bloq_ccod and aaa.hora_ccod_optativos=bbb.hora_ccod_optativos) + '</strong></font>'  " & vbCrLf &_ 
		   " end  as detalle,  " & vbCrLf &_ 
		   " count(distinct a.bloq_ccod) as usos  " & vbCrLf &_ 
		   " from bloques_horarios a, salas b, tipos_sala c, cargas_academicas d, secciones f, asignaturas g  " & vbCrLf &_ 
		   " where a.sala_ccod =b.sala_ccod " & vbCrLf &_ 
		   " and a.secc_ccod=f.secc_ccod " & vbCrLf &_ 
		   " and f.asig_ccod=g.asig_ccod " & vbCrLf &_ 
		   " and b.tsal_ccod=c.tsal_ccod " & vbCrLf &_ 
		   " and a.secc_ccod=d.secc_ccod " & vbCrLf &_ 
		   " and not exists (select 1 from convalidaciones conv where d.matr_ncorr=conv.matr_ncorr and f.asig_ccod=conv.asig_ccod) " & vbCrLf &_ 
		   " "&filtro_matriculas&" " & vbCrLf &_ 
		   " "&filtro_periodo&" " & vbCrLf &_ 
		   " group by  f.asig_ccod,f.secc_tdesc, g.asig_tdesc, b.sala_ccod,tsal_tdesc,dias_ccod,hora_ccod,a.secc_ccod, " & vbCrLf &_ 
		   " a.bloq_ccod,b.sala_tdesc" 

set arreglo_carga = new CFormulario
arreglo_carga.Carga_Parametros "tabla_vacia.xml", "tabla"
arreglo_carga.Inicializar conexion
arreglo_carga.Consultar consulta

if arreglo_carga.nroFilas > 0 then
	indice=0
    while arreglo_carga.siguiente
		indice = indice + 1
		asig_ccod_tt = arreglo_carga.obtenerValor("asig_ccod")
		dias_ccod    = arreglo_carga.obtenerValor("dias_ccod")
		hora_ccod    = arreglo_carga.obtenerValor("hora_ccod")
		detalle      = arreglo_carga.obtenerValor("detalle")
		arreglo(hora_ccod,dias_ccod) = detalle
		'colores_horario(hora_ccod,dias_ccod) = color_asignatura(asig_ccod_tt)
    wend
end if

'-----------------------------------------------------------------------------------------------------------------------------------
'---------------------------------------------------EVALUACION DOCENTE--------------------------------------------------------------
set f_ramos = new CFormulario
f_ramos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_ramos.Inicializar conexion
'response.Write(carrera)			
consulta2 = "  select distinct e.asig_ccod,f.asig_tdesc,protic.initcap(i.pers_tnombre + ' ' + i.pers_tape_paterno) as docente,e.secc_ccod,i.pers_ncorr, " & vbCrLf &_
			"  case c.plec_ccod when 1 then '1er Sem' when 2 then '2do Sem' when 3 then '3er Tri' end as semestre " & vbCrLf &_
			"  from alumnos a, ofertas_academicas b,periodos_academicos c,cargas_academicas d, " & vbCrLf &_
			"       secciones e,asignaturas f,bloques_horarios g, bloques_profesores h,personas i " & vbCrLf &_
			"  where cast(a.pers_ncorr as varchar)= '"&pers_ncorr&"' " & vbCrLf &_
			"  and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
			"  and b.peri_ccod = c.peri_ccod and cast(c.anos_ccod as varchar)='"&anos_ccod&"' and c.plec_ccod in (1,2,3) " & vbCrLf &_
			"  and a.matr_ncorr=d.matr_ncorr and d.secc_ccod=e.secc_ccod " & vbCrLf &_
			"  and e.asig_ccod=f.asig_ccod and e.secc_ccod=g.secc_ccod  " & vbCrLf &_
			"  and g.bloq_ccod=h.bloq_ccod and h.tpro_ccod=1 " & vbCrLf &_
			"  and h.pers_ncorr=i.pers_ncorr " & vbCrLf &_
			"  and not exists (select 1 from convalidaciones conv where conv.matr_ncorr=a.matr_ncorr and conv.asig_ccod=e.asig_ccod) " & vbCrLf &_
			"  order by semestre"
			
			
f_ramos.Consultar consulta2

'----------------------------------------------------------------------------------------------------------------------------------
'------------------------------------------------FICHA ACADEMICA DEL ALUMNO--------------------------------------------------------
set fDatosPer = new CFormulario
	fDatosPer.Carga_Parametros "ficha_antec_personales.xml", "f_datos_antecedentes"
	fDatosPer.Inicializar conexion
	cons_Datos = "exec LIST_FICHA_ANTECEDENTES_PERS " & pers_nrut
	fDatosPer.Consultar cons_Datos 
	fDatosPer.Siguiente

set fDatosPer2 = new CFormulario
	fDatosPer2.Carga_Parametros "ficha_antec_personales.xml", "f_datos_antecedentes2"
	fDatosPer2.Inicializar conexion
	cons_Datos = "exec LIST_FICHA_ANTECEDENTES_PERS2 " & pers_nrut
	fDatosPer2.Consultar cons_Datos 
	fDatosPer2.Siguiente
			
 '------------------------------------------------------CUENTA CORRIENTE--------------------------------------------------------------
 '------------------------------------------------------------------------------------------------------------------------------------
set f_cta_cte = new CFormulario
f_cta_cte.Carga_Parametros "tabla_vacia.xml", "tabla"
f_cta_cte.Inicializar conexion

condicion_periodo = ""
if filtrar_periodo = 1 then
	condicion_periodo = " and cast(b.peri_ccod as varchar)='"&periodo_consulta&"'"
end if

' consulta_cta_corriente = "select (select peri_tdesc from periodos_academicos tt where tt.peri_ccod=b.peri_ccod) as periodo, " & vbCrLf &_
'						  "	b.inst_ccod, b.comp_ndocto,b.tcom_ccod, case when b.tcom_ccod in (1,2) then cast(b.comp_ndocto as varchar)+ ' ('+protic.numero_contrato(b.comp_ndocto)+')'else cast(b.comp_ndocto as varchar) end as ncompromiso, " & vbCrLf &_
'						  "		 case " & vbCrLf &_
'						  "	   when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35 or b.tcom_ccod=15  " & vbCrLf &_
'						  "			then " & vbCrLf &_
'						  "		   (Select top 1 a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod " & vbCrLf &_
'						  "			and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) " & vbCrLf &_
'						  "		when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') " & vbCrLf &_
'						  "	   else  " & vbCrLf &_
'						  "			(select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)  " & vbCrLf &_
'						  "		end as tcom_tdesc,  " & vbCrLf &_
'						  "		b.dcom_ncompromiso,cast(b.dcom_ncompromiso as varchar) + '/' + cast(a.comp_ncuotas as varchar)  as ncuota, " & vbCrLf &_
'						  "		a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso, " & vbCrLf &_
'						  "		(select ting_tdesc from tipos_ingresos ttt where ttt.ting_ccod=protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')) as ting_ccod, " & vbCrLf &_
'						  "		case   " & vbCrLf &_
'						  "		when a.tcom_ccod=2 and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')=52  " & vbCrLf &_
'						  "			then   " & vbCrLf &_
'						  "			  (select pag.PAGA_NCORR from  pagares pag 	where  pag.cont_ncorr =a.comp_ndocto and isnull(pag.opag_ccod,1) not in (2))  " & vbCrLf &_
'						  "			else  " & vbCrLf &_
'						  "				protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto')  " & vbCrLf &_
'						  "			end as ding_ndocto,  " & vbCrLf &_
'						  "		protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos,  " & vbCrLf &_
'						  "		protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado, " & vbCrLf &_
'						  "		isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo,  " & vbCrLf &_
'						  "	(select d.edin_ccod from  estados_detalle_ingresos d " & vbCrLf &_
'						  "		where c.edin_ccod = d.edin_ccod) as edin_ccod, " & vbCrLf &_
'						  "	(select d.edin_tdesc+protic.obtener_institucion(c.ingr_ncorr) from estados_detalle_ingresos d " & vbCrLf &_
'						  "		where c.edin_ccod = d.edin_ccod) as edin_tdesc  " & vbCrLf &_
'						  "	 from compromisos a,detalle_compromisos b,detalle_ingresos c " & vbCrLf &_
'						  "	 where a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
'						  "		and a.inst_ccod = b.inst_ccod  " & vbCrLf &_
'						  "		and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
'						  "		and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') *= c.ting_ccod " & vbCrLf &_
'						  "		and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') *= c.ding_ndocto " & vbCrLf &_
'						  "		and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') *= c.ingr_ncorr " & vbCrLf &_
'						  "		and a.ecom_ccod = '1' "&condicion_periodo& vbCrLf &_
'						  "		and b.ecom_ccod <> '3' " & vbCrLf &_
'						  "		and cast(a.pers_ncorr as varchar) ='"&pers_ncorr&"' " & vbCrLf &_
'						  "		order by b.dcom_fcompromiso desc "

'----------------------------------------------------------------------------------------------------------Nueva consulta 2008
consulta_cta_corriente = " select (select peri_tdesc                                                                                                          " & vbCrLf &_
"        from   periodos_academicos tt                                                                                                                        " & vbCrLf &_
"        where  tt.peri_ccod = b.peri_ccod)                                                                                                as periodo,        " & vbCrLf &_
"       b.inst_ccod,                                                                                                                                          " & vbCrLf &_
"       b.comp_ndocto,                                                                                                                                        " & vbCrLf &_
"       b.tcom_ccod,                                                                                                                                          " & vbCrLf &_
"       case                                                                                                                                                  " & vbCrLf &_
"         when b.tcom_ccod in ( 1, 2 ) then cast(b.comp_ndocto as varchar) + ' ('                                                                             " & vbCrLf &_
"                                           + protic.numero_contrato(b.comp_ndocto) + ')'                                                                     " & vbCrLf &_
"         else cast(b.comp_ndocto as varchar)                                                                                                                 " & vbCrLf &_
"       end                                                                                                                                as ncompromiso,    " & vbCrLf &_
"       case                                                                                                                                                  " & vbCrLf &_
"         when b.tcom_ccod = 25                                                                                                                               " & vbCrLf &_
"               or b.tcom_ccod = 4                                                                                                                            " & vbCrLf &_
"               or b.tcom_ccod = 5                                                                                                                            " & vbCrLf &_
"               or b.tcom_ccod = 8                                                                                                                            " & vbCrLf &_
"               or b.tcom_ccod = 10                                                                                                                           " & vbCrLf &_
"               or b.tcom_ccod = 26                                                                                                                           " & vbCrLf &_
"               or b.tcom_ccod = 34                                                                                                                           " & vbCrLf &_
"               or b.tcom_ccod = 35                                                                                                                           " & vbCrLf &_
"               or b.tcom_ccod = 15 then (select top 1 a1.tdet_tdesc                                                                                          " & vbCrLf &_
"                                         from   tipos_detalle as a1                                                                                          " & vbCrLf &_
"                                                inner join detalles as a2                                                                                    " & vbCrLf &_
"                                                        on a1.tdet_ccod = a2.tdet_ccod                                                                       " & vbCrLf &_
"                                         where  a2.tcom_ccod = a.tcom_ccod                                                                                   " & vbCrLf &_
"                                                and a2.inst_ccod = a.inst_ccod                                                                               " & vbCrLf &_
"                                                and a2.comp_ndocto = a.comp_ndocto)                                                                          " & vbCrLf &_
"         when b.tcom_ccod = 37 then (select a3.tcom_tdesc                                                                                                    " & vbCrLf &_
"                                     from   tipos_compromisos a3                                                                                             " & vbCrLf &_
"                                     where  a3.tcom_ccod = a.tcom_ccod)                                                                                      " & vbCrLf &_
"                                    + '-'                                                                                                                    " & vbCrLf &_
"                                    + protic.obtener_nombre_carrera(a.ofer_ncorr, 'CJ')                                                                      " & vbCrLf &_
"         else (select a3.tcom_tdesc                                                                                                                          " & vbCrLf &_
"               from   tipos_compromisos a3                                                                                                                   " & vbCrLf &_
"               where  a3.tcom_ccod = a.tcom_ccod)                                                                                                            " & vbCrLf &_
"       end                                                                                                                                as tcom_tdesc,     " & vbCrLf &_
"       b.dcom_ncompromiso,                                                                                                                                   " & vbCrLf &_
"       cast(b.dcom_ncompromiso as varchar) + '/'                                                                                                             " & vbCrLf &_
"       + cast(a.comp_ncuotas as varchar)                                                                                                  as ncuota,         " & vbCrLf &_
"       a.comp_fdocto,                                                                                                                                        " & vbCrLf &_
"       b.dcom_fcompromiso,                                                                                                                                   " & vbCrLf &_
"       b.dcom_mcompromiso,                                                                                                                                   " & vbCrLf &_
"       (select ting_tdesc                                                                                                                                    " & vbCrLf &_
"        from   tipos_ingresos ttt                                                                                                                            " & vbCrLf &_
"        where  ttt.ting_ccod = protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')) as ting_ccod,      " & vbCrLf &_
"       case                                                                                                                                                  " & vbCrLf &_
"         when a.tcom_ccod = 2                                                                                                                                " & vbCrLf &_
"              and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = 52 then (select pag.paga_ncorr " & vbCrLf &_
"                                                                                                                                       from   pagares pag    " & vbCrLf &_
"                                                                                                                                       where                 " & vbCrLf &_
"         pag.cont_ncorr = a.comp_ndocto                                                                                                                      " & vbCrLf &_
"         and isnull(pag.opag_ccod, 1) not in ( 2 ))                                                                                                          " & vbCrLf &_
"         else protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto')                                    " & vbCrLf &_
"       end                                                                                                                                as ding_ndocto,    " & vbCrLf &_
"       protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)                                            as abonos,         " & vbCrLf &_
"       protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)                                  as documentado,    " & vbCrLf &_
"       isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)            as saldo,          " & vbCrLf &_
"       (select d.edin_ccod                                                                                                                                   " & vbCrLf &_
"        from   estados_detalle_ingresos d                                                                                                                    " & vbCrLf &_
"        where  c.edin_ccod = d.edin_ccod)                                                                                                 as edin_ccod,      " & vbCrLf &_
"       (select d.edin_tdesc                                                                                                                                  " & vbCrLf &_
"               + protic.obtener_institucion(c.ingr_ncorr)                                                                                                    " & vbCrLf &_
"        from   estados_detalle_ingresos d                                                                                                                    " & vbCrLf &_
"        where  c.edin_ccod = d.edin_ccod)                                                                                                 as edin_tdesc      " & vbCrLf &_
"from   compromisos as a                                                                                                                                      " & vbCrLf &_
"       inner join detalle_compromisos as b                                                                                                                   " & vbCrLf &_
"               on a.tcom_ccod = b.tcom_ccod                                                                                                                  " & vbCrLf &_
"                  and a.inst_ccod = b.inst_ccod                                                                                                              " & vbCrLf &_
"                  and a.comp_ndocto = b.comp_ndocto                                                                                                          " & vbCrLf &_
"                  "& condicion_periodo & vbCrLf &_  
"                  and b.ecom_ccod <> '3'                                                                                                                     " & vbCrLf &_
"       left outer join detalle_ingresos as c                                                                                                                 " & vbCrLf &_
"                    on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod               " & vbCrLf &_
"                       and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto       " & vbCrLf &_
"                       and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr         " & vbCrLf &_
"where  a.ecom_ccod = '1'                                                                                                                                     " & vbCrLf &_
"       and cast(a.pers_ncorr as varchar) = '"&pers_ncorr&"'                                                                                                  " & vbCrLf &_
"order  by b.dcom_fcompromiso desc                                                                                                                            " 
'------------------------------------------------------------------------------------------------------fin_Nueva consulta 2008						  

f_cta_cte.Consultar consulta_cta_corriente
'response.Write("<hr><pre>"&consulta_cta_corriente&"</pre>")

set f_becas_descuentos = new CFormulario
f_becas_descuentos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_becas_descuentos.Inicializar conexion

sql_becas_descuentos = 	" Select contrato,cont_ncorr, stde_ccod, stde_tdesc, bene_mmonto,mone_ccod,bene_nporcentaje_matricula,bene_nporcentaje_colegiatura,(select tben_tdesc from tipos_beneficios ttt where ttt.tben_ccod=tabla.tben_ccod) as tben_ccod,max(bene_fbeneficio) as bene_fbeneficio "& vbCrLf &_
								" From ( "& vbCrLf &_
								" select isnull(b.contrato,b.cont_ncorr) as contrato,b.peri_ccod,b.cont_ncorr, e.stde_ccod, e.stde_tdesc," & vbCrLf &_
								"        isnull(c.bene_mmonto_matricula, 0) + isnull(c.bene_mmonto_colegiatura, 0) as bene_mmonto," & vbCrLf &_
								"        c.mone_ccod, c.bene_nporcentaje_matricula, c.bene_nporcentaje_colegiatura, e.tben_ccod, c.bene_fbeneficio " & vbCrLf &_
								"            from postulantes a, contratos b, beneficios c, stipos_descuentos e " & vbCrLf &_
								"            where a.post_ncorr = b.post_ncorr " & vbCrLf &_
								"              and b.cont_ncorr = c.cont_ncorr " & vbCrLf &_
								"              and c.stde_ccod = e.stde_ccod " & vbCrLf &_
								"              and e.tben_ccod <> 1 " & vbCrLf &_
								"              and b.econ_ccod = '1' " & vbCrLf &_
								"              and c.eben_ccod = '1' " & vbCrLf &_
								"              and b.econ_ccod <> 3 " & vbCrLf &_
								"              and cast(a.pers_ncorr as varchar) = '" & pers_ncorr & "'" & vbCrLf &_			
						 " union " & vbCrLf &_
								"	select isnull(k.contrato,k.cont_ncorr) as contrato,k.peri_ccod, k.cont_ncorr, a.stde_ccod, b.tdet_tdesc as stde_tdesc, " & vbCrLf &_
								"		cast(isnull(a.sdes_mmatricula, 0) + isnull(a.sdes_mcolegiatura, 0) as int) as bene_mmonto, " & vbCrLf &_
								"			1 as mone_ccod,a.sdes_nporc_matricula as bene_nporcentaje_matricula,a.sdes_nporc_colegiatura as bene_nporcentaje_colegiatura, " & vbCrLf &_
								"		i.tben_ccod, cont_fcontrato as bene_fbeneficio " & vbCrLf &_
								"		from sdescuentos a,tipos_detalle b,sestados_descuentos c, " & vbCrLf &_
								"			  postulantes d,ofertas_academicas e,personas_postulante f, " & vbCrLf &_
								"			  especialidades g,carreras h,tipos_beneficios i,sedes j, contratos k " & vbCrLf &_
								"		where a.stde_ccod = b.tdet_ccod " & vbCrLf &_
								"			and a.esde_ccod = c.esde_ccod  " & vbCrLf &_
								"			and a.post_ncorr = d.post_ncorr  " & vbCrLf &_
								"			and a.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_
								"			and d.ofer_ncorr = e.ofer_ncorr  " & vbCrLf &_
								"			and d.pers_ncorr = f.pers_ncorr " & vbCrLf &_
								"			and e.espe_ccod = g.espe_ccod  " & vbCrLf &_
								"			and g.carr_ccod = h.carr_ccod " & vbCrLf &_
								"			and e.sede_ccod = j.sede_ccod   " & vbCrLf &_
								"			and b.tben_ccod = i.tben_ccod  " & vbCrLf &_
								"			and d.post_ncorr= k.post_ncorr " & vbCrLf &_
								"			and k.econ_ccod <> 3 " & vbCrLf &_
								"			and a.esde_ccod=1 " & vbCrLf &_
								"			and cast(f.pers_ncorr as varchar) ='" & pers_ncorr & "'" & vbCrLf &_													
								" ) as tabla " & vbCrLf &_
 								" group by contrato,cont_ncorr, stde_ccod, stde_tdesc, bene_mmonto,mone_ccod,bene_nporcentaje_matricula,bene_nporcentaje_colegiatura,tben_ccod"

f_becas_descuentos.Consultar sql_becas_descuentos


set f_comentarios = new CFormulario
f_comentarios.Carga_Parametros "tabla_vacia.xml", "tabla"
f_comentarios.Inicializar conexion
sql_comentarios ="Select come_ncorr,protic.trunc(COME_FCOMENTARIO) as COME_FCOMENTARIO, COME_TCOMENTARIO as COME_TCOMENTARIO,(select tico_tdesc from tipos_comentarios tt where tt.tico_ccod=a.tico_ccod) as TICO_CCOD from comentarios a where cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
f_comentarios.Consultar sql_comentarios

set f_morosidad = new CFormulario
f_morosidad.Carga_Parametros "tabla_vacia.xml", "tabla"
f_morosidad.Inicializar conexion
sql_morosidad = 	" select cast(isnull(f.fint_nfactor_anual/(12*100),0) as decimal(5,4) ) as factor_interes, " & vbCrLf &_
						" case when datediff(day,b.dcom_fcompromiso, getdate())>5 then datediff(day,b.dcom_fcompromiso, getdate()) else 0 end as dias_mora, " & vbCrLf &_
						" ROUND((cast(isnull(f.fint_nfactor_anual,0)/(12*100) as decimal(5,4))*protic.total_recepcionar_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso)*case when datediff(day,b.dcom_fcompromiso, getdate())>5 then datediff(day,b.dcom_fcompromiso, getdate())else 0 end)/30,0) as interes, "& vbCrLf &_
						" protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)+ ROUND((cast(isnull(f.fint_nfactor_anual,0)/(12*100) as decimal(5,4))*protic.total_recepcionar_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso)*case when datediff(day,b.dcom_fcompromiso, getdate())>5 then datediff(day,b.dcom_fcompromiso, getdate())else 0 end)/30,0) as a_pagar, "& vbCrLf &_
						"     case " & vbCrLf &_
						"   when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35" & vbCrLf &_
						"		then " & vbCrLf &_
						"       (Select a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod " & vbCrLf &_
						"        and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) " & vbCrLf &_
						" 	when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') "& vbCrLf &_
						"   else " & vbCrLf &_
						"        (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod) " & vbCrLf &_
						"    end as tcom_tdesc, " & vbCrLf &_
						"			b.comp_ndocto as c_comp_ndocto, cast(b.dcom_ncompromiso as varchar) + ' / '+ cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso, "& vbCrLf &_
						"			protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,"& vbCrLf &_   
						"			protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,  "& vbCrLf &_ 
						"			protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) + protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)as abonos, "& vbCrLf &_
						"			protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, "& vbCrLf &_
						"		    d.edin_tdesc  "& vbCrLf &_
						"		   "& vbCrLf &_
						"	 from "& vbCrLf &_
						"		compromisos a "& vbCrLf &_
						"		join detalle_compromisos b "& vbCrLf &_
						"			on a.tcom_ccod = b.tcom_ccod   "& vbCrLf &_ 
						"			and a.inst_ccod = b.inst_ccod    "& vbCrLf &_
						"			and a.comp_ndocto = b.comp_ndocto "& vbCrLf &_
						"		left outer join detalle_ingresos c "& vbCrLf &_
						"			on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod   "& vbCrLf &_
						"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto  "& vbCrLf &_
						"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr    "& vbCrLf &_
						"		left join estados_detalle_ingresos d   "& vbCrLf &_
						"			on c.edin_ccod = d.edin_ccod "& vbCrLf &_
						" 		left outer join rango_factor_interes h "& vbCrLf &_  
						"			on datediff(day,b.dcom_fcompromiso, getdate()) between rafi_ndias_minimo and rafi_ndias_maximo "& vbCrLf &_   
						"			and floor(b.dcom_mcompromiso/protic.valor_uf()) between rafi_mufes_min and rafi_mufes_max "& vbCrLf &_  
						"		left outer join factor_interes f "& vbCrLf &_  
						"			on f.rafi_ccod=h.rafi_ccod "& vbCrLf &_  
						"			and f.anos_ccod=datepart(year, getdate()) "& vbCrLf &_  
						"			and f.efin_ccod=1 "& vbCrLf &_
						"	 where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0  "& vbCrLf &_
						"	   --and isnull(d.udoc_ccod, 1) = 1  "& vbCrLf &_
						"	   and ( (c.ting_ccod is null) or  "& vbCrLf &_
						"			 (c.ting_ccod = 4 and d.edin_ccod not in (6) ) or  "& vbCrLf &_
						"			 (c.ting_ccod = 5 and d.edin_ccod not in (6) ) or  "& vbCrLf &_
						"			  (c.ting_ccod in (2, 50)) or  "& vbCrLf &_
						"			  (c.ting_ccod in (3,38) and d.edin_ccod not in (6, 12, 51)) or  "& vbCrLf &_
						"    		  (c.ting_ccod = 52 and d.edin_ccod not in (6) ) or "& vbCrLf &_
						"    		  (c.ting_ccod = 87 and d.edin_ccod not in (6) ) or "& vbCrLf &_
						"    		  (c.ting_ccod = 88 and d.edin_ccod not in (6) ) "& vbCrLf &_
						"			)  "& vbCrLf &_
						"	   and a.ecom_ccod = '1'  "& vbCrLf &_
						"	   and b.ecom_ccod = '1'  "& vbCrLf &_
						"  	and cast(a.pers_ncorr  as varchar)= '" & pers_ncorr & "'"& vbCrLf &_
						"   and datediff(day,b.dcom_fcompromiso, getdate())>1 "& vbCrLf &_
						"	order by b.dcom_fcompromiso asc, b.dcom_ncompromiso asc, b.tcom_ccod asc "

f_morosidad.Consultar sql_morosidad

'-------------------------------------------DATOS DE MATRICULAS Y GRAFICOS DE AVANCE------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------------------
set f_matriculas = new CFormulario
f_matriculas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_matriculas.Inicializar conexion

condicion_periodo = ""
if filtrar_periodo = 1 then
	condicion_periodo = " and cast(g.anos_ccod as varchar)='"&anos_ccod&"'"
end if

c_matriculas = " select anos_ccod,periodo,sede,carrera,jornada,emat_ccod,estado,cargas,aprobados, "& vbCrLf &_
		 	   " case when cargas = 0 then 0 else cast((aprobados*100)/cargas as numeric(4,1)) end as rendimiento "& vbCrLf &_
			   " from "& vbCrLf &_
			   " ( "& vbCrLf &_
			   " select g.anos_ccod,cast(g.anos_ccod as varchar)+'-'+cast(g.plec_ccod as varchar) as periodo, "& vbCrLf &_
			   " protic.initCap(e.sede_tdesc) as sede, protic.initCap(d.carr_tdesc) as carrera, "& vbCrLf &_
			   " protic.initCap(f.jorn_tdesc) as jornada, h.emat_ccod,h.emat_tdesc as estado, "& vbCrLf &_
			   " (select count(*) from cargas_academicas tt (nolock) where tt.matr_ncorr=a.matr_ncorr) as cargas, "& vbCrLf &_
			   " (select count(*) from cargas_academicas tt (nolock),situaciones_finales t2  "& vbCrLf &_
			   " where tt.matr_ncorr=a.matr_ncorr and tt.sitf_ccod = t2.sitf_ccod and t2.sitf_baprueba='S') as aprobados "& vbCrLf &_
			   " from alumnos a (nolock), ofertas_academicas b, especialidades c, carreras d,  "& vbCrLf &_
			   " sedes e, jornadas f,periodos_academicos g, estados_matriculas h "& vbCrLf &_
			   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod "& vbCrLf &_
			   " and b.sede_ccod=e.sede_ccod and b.jorn_ccod=f.jorn_ccod "& vbCrLf &_
			   " and b.peri_ccod=g.peri_ccod and a.emat_ccod=h.emat_ccod "&condicion_periodo& vbCrLf &_
			   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbCrLf &_
			   " )table1  "& vbCrLf &_
			   " order by anos_ccod asc,periodo asc "
			   
f_matriculas.Consultar c_matriculas

'---------------------------------------------HISTORICO DE NOTAS---------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------------------------
set historico		=		new cformulario
historico.inicializar 		conexion
historico.carga_parametros	"tabla_vacia.xml","tabla"

cons_historico="select a.nive_ccod,ltrim(rtrim(a.asig_ccod)) as asig_ccod,asig.asig_tdesc,a.mall_ccod, " & vbCrLf  & _
                   "	  case cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) when ' .0' then '0.0' else cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) end as carg_nnota_final,  " & vbCrLf  & _
				   "	 b.sitf_ccod,b.peri_ccod, " & vbCrLf  & _
				   "	 isnull( case ('('+ cast(pa.anos_ccod as varchar) + '-' + cast(b.sitf_ccod as varchar)+')') " & vbCrLf  & _
				   "     when ('('+ cast(pa.anos_ccod as varchar) + '-' + ')') then ' ' " & vbCrLf  & _
				   "     when '(-)' then ' '" & vbCrLf  & _
				   "     else ('('+ cast(pa.anos_ccod as varchar) + '-' + case cast(b.sitf_ccod as varchar) when 'A' then 'Apr' when 'R' then 'Repr' when 'C' then 'Conv' when 'SP' then 'S.P' when 'H' then 'Homologado' when 'S' then 'Suf' when 'RS' then 'RS' when 'RI' then 'RI' end +')') end ,'' ) as anos_ccod  " & vbCrLf  & _
				   "	 from (  " & vbCrLf  & _
				   "	 select ma.nive_ccod, asig_ccod,esp.carr_ccod,ma.mall_ccod  " & vbCrLf  & _
			  	   "	 from especialidades esp, planes_estudio pl, malla_curricular ma  " & vbCrLf  & _
				   "	 where esp.espe_ccod=pl.espe_ccod  " & vbCrLf  & _
				   "	  and pl.plan_ccod=ma.plan_ccod  " & vbCrLf  & _
				   "	  and cast(pl.plan_ccod as varchar)='"&plan_ccod&"') a left outer join" & vbCrLf  & _
				   "	  (	  " & vbCrLf  & _
				   "	  select h.asig_ccod,a.sitf_ccod,a.carg_nnota_final,g.peri_ccod " & vbCrLf  & _
				   "		from  " & vbCrLf  & _
				   "			 cargas_academicas a, " & vbCrLf  & _
				   "			 alumnos b, " & vbCrLf  & _
				   "			 personas c, " & vbCrLf  & _
				   "			 ofertas_academicas d " & vbCrLf  & _
				   "			 ,planes_estudio e " & vbCrLf  & _
				   "			 ,especialidades f " & vbCrLf  & _
				   "			 ,secciones g " & vbCrLf  & _
				   "			 ,asignaturas h " & vbCrLf  & _
				   "		where  " & vbCrLf  & _
				   "			  a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			  and b.pers_ncorr=c.pers_ncorr " & vbCrLf  & _
				   "			  and b.ofer_ncorr=d.ofer_ncorr " & vbCrLf  & _
				   "			  and b.plan_ccod=e.plan_ccod " & vbCrLf  & _
				   "              and isnull(a.carg_noculto,0) <>1" & vbcrlf &_
				   "			  and e.espe_ccod=f.espe_ccod " & vbCrLf  & _
				   "			  and not exists(select 1 from equivalencias equi where equi.asig_ccod=h.asig_ccod and a.matr_ncorr=equi.matr_ncorr and a.secc_ccod = equi.secc_ccod) " & vbCrLf  & _
				   "			  --and not exists(select 1 from equivalencias equi where equi.secc_ccod=g.secc_ccod and equi.matr_ncorr=a.matr_ncorr) " & vbCrLf  & _
				   "			  and a.secc_ccod=g.secc_ccod " & vbCrLf  & _
				   "			  and g.asig_ccod=h.asig_ccod " & vbCrLf  & _
				   "			  --and b.emat_ccod=1 " & vbCrLf  & _
				   "			  and cast(pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf  & _
				   "			  --and cast(f.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "			  and cast(a.sitf_ccod as varchar) not in ('EE','EQ','NN') " & vbCrLf  & _
				   "		union   " & vbCrLf  & _
				   "		select  " & vbCrLf  & _
				   "			 a.asig_ccod,sitf_ccod,case a.sitf_ccod when 'C' then isnull(a.conv_nnota,null) when 'AC' then a.conv_nnota else isnull(a.conv_nnota,null) end as nota,e.peri_ccod " & vbCrLf  & _
				   "		from  " & vbCrLf  & _
				   "			 convalidaciones a " & vbCrLf  & _
				   "			 , alumnos b " & vbCrLf  & _
				   "			 ,personas c " & vbCrLf  & _
				   "			 , actas_convalidacion d " & vbCrLf  & _
				   "			 , ofertas_academicas e " & vbCrLf  & _
				   "			 , planes_estudio f " & vbCrLf  & _
				   "			 ,especialidades g " & vbCrLf  & _
				   "		where " & vbCrLf  & _
				   "			 a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			 and b.pers_ncorr=c.pers_ncorr " & vbCrLf  & _
				   "			 and a.acon_ncorr=d.acon_ncorr " & vbCrLf  & _
				   "			 and b.ofer_ncorr=e.ofer_ncorr " & vbCrLf  & _
				   "			 and b.plan_ccod=f.plan_ccod " & vbCrLf  & _
				   "			 and f.espe_ccod=g.espe_ccod " & vbCrLf  & _
				   "			 and cast(g.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "			 and cast(c.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf  & _
				   "		union " & vbCrLf  & _
				   "		select " & vbCrLf  & _
				   "			  a.asig_ccod,b.sitf_ccod,b.carg_nnota_final,d.peri_ccod " & vbCrLf  & _
				   "		from " & vbCrLf  & _
				   "			equivalencias a " & vbCrLf  & _
				   "			, cargas_academicas b " & vbCrLf  & _
				   "			, secciones c " & vbCrLf  & _
				   "			, ofertas_academicas d " & vbCrLf  & _
				   "			, planes_estudio e " & vbCrLf  & _
				   "			, especialidades f " & vbCrLf  & _
				   "			, alumnos g " & vbCrLf  & _
				   "			, personas h " & vbCrLf  & _
				   "		where " & vbCrLf  & _
				   "			 a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			 and a.secc_ccod=b.secc_ccod " & vbCrLf  & _
				   "			 and b.secc_ccod=c.secc_ccod " & vbCrLf  & _
				   "			 and b.matr_ncorr=g.matr_ncorr " & vbCrLf  & _
				   "			 and d.ofer_ncorr=g.ofer_ncorr " & vbCrLf  & _
				   "			 and e.plan_ccod=g.plan_ccod " & vbCrLf  & _
				   "             and isnull(b.carg_noculto,0) <>1" & vbcrlf &_
				   "			 and e.espe_ccod=f.espe_ccod " & vbCrLf  & _
				   "			 and g.pers_ncorr=h.pers_ncorr " & vbCrLf  & _
				   "			 --and cast(f.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "			 and cast(h.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf  & _
				   "		union " & vbCrLf  & _
				   "    		 select distinct hd.asig_ccod,carg.sitf_ccod,carg.carg_nnota_final,i.peri_ccod " & vbCrLf  & _
				   "                from personas pers,alumnos al,cargas_academicas carg,situaciones_finales sf,secciones secc,asignaturas asig, homologacion_destino hd, " & vbCrLf  & _
				   "                     homologacion_fuente hf,homologacion h,ofertas_academicas i" & vbCrLf  & _
				   "                where cast(pers.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf  & _
				   "                and pers.pers_ncorr=al.pers_ncorr" & vbCrLf  & _
				   "                and al.matr_ncorr=carg.matr_ncorr" & vbCrLf  & _
				   "                and carg.sitf_ccod=sf.sitf_ccod" & vbCrLf  & _
				   "                --and cast(sf.sitf_baprueba as varchar)='S'" & vbCrLf  & _
				   "                and cast(carg.sitf_ccod as varchar) <>'EQ'" & vbCrLf  & _
				   "                and secc.secc_ccod=carg.secc_ccod" & vbCrLf  & _
				   "                and asig.asig_ccod=secc.asig_ccod" & vbCrLf  & _
				   "                and isnull(carg.carg_noculto,0) <>1" & vbcrlf &_
				   "                and asig.asig_ccod=hf.asig_ccod" & vbCrLf  & _
				   "                and hd.homo_ccod=h.homo_ccod" & vbCrLf  & _
				   "                and al.ofer_ncorr=i.ofer_ncorr" & vbCrLf  & _
				   "                and hf.homo_ccod=h.homo_ccod" & vbCrLf  & _
				   "			    and cast(secc.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "                and hd.asig_ccod <> hf.asig_ccod" & vbCrLf  & _
				   "                and h.THOM_CCOD = 1 " & vbCrLf  & _
				   "		) b  on  a.asig_ccod = b.asig_ccod " & vbCrLf  & _
				   "		join   asignaturas asig on a.asig_ccod=asig.asig_ccod  " & vbCrLf  & _
				   "	    left outer join periodos_academicos pa on b.peri_ccod=pa.peri_ccod" & vbCrLf  & _
				   "        join carreras ca on ca.carr_ccod=a.carr_ccod " & vbCrLf  & _
				   "        order by a.nive_ccod,a.asig_ccod,b.peri_ccod "


oportunidades	=	3

historico.consultar	cons_historico
nro_columnas =historico.nroFilas

'-------------------------------------------------------------------NOTAS PARCIALES---------------------------------------------------------------------
'-------------------------------------------------------------------------------------------------------------------------------------------------------
set parciales		=		new cformulario
parciales.inicializar 		conexion
parciales.carga_parametros	"tabla_vacia.xml","tabla"

c_parciales =   "select g.peri_ccod, g.peri_tdesc,sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada, " & vbCrLf  & _
				" k.nive_ccod as nivel,j.asig_tdesc as asignatura,i.secc_tdesc as seccion, " & vbCrLf  & _
				" cali_nevaluacion as numero, protic.initCap(m.teva_tdesc) as tipo, " & vbCrLf  & _
				" cali_nponderacion as ponderacion, protic.trunc(cali_fevaluacion) as fecha_ev, " & vbCrLf  & _
				" cala_nnota as nota_parcial, carg_nasistencia as asistencia, carg_nnota_final as nota_final, " & vbCrLf  & _
				" isnull(sitf_ccod,'') as estado " & vbCrLf  & _
				" from alumnos a (nolock) join ofertas_academicas b " & vbCrLf  & _
				"     on a.ofer_ncorr=b.ofer_ncorr " & vbCrLf  & _
				" join especialidades c " & vbCrLf  & _
				"     on b.espe_ccod=c.espe_ccod " & vbCrLf  & _
				" join carreras d " & vbCrLf  & _
				"     on c.carr_ccod=d.CARR_CCOD " & vbCrLf  & _
				" join sedes e " & vbCrLf  & _
				"     on b.sede_ccod=e.sede_ccod " & vbCrLf  & _
				" join jornadas f " & vbCrLf  & _
				"     on b.jorn_ccod=f.jorn_ccod " & vbCrLf  & _
				" join  periodos_academicos g " & vbCrLf  & _
				"     on b.peri_ccod=g.peri_ccod " & vbCrLf  & _
				" join cargas_academicas h (nolock) " & vbCrLf  & _
				"     on a.matr_ncorr=h.matr_ncorr " & vbCrLf  & _
				" join secciones i (nolock) " & vbCrLf  & _
				"     on h.secc_ccod=i.secc_ccod " & vbCrLf  & _
				" join asignaturas j " & vbCrLf  & _
				"     on i.asig_ccod=j.asig_ccod " & vbCrLf  & _
				" left outer join malla_curricular k " & vbCrLf  & _
				"     on i.asig_ccod=k.asig_ccod and i.mall_ccod=k.mall_ccod " & vbCrLf  & _
				" left outer join calificaciones_seccion l (nolock) " & vbCrLf  & _
				"     on i.secc_ccod = l.secc_ccod " & vbCrLf  & _
				" left outer join tipos_evaluacion m " & vbCrLf  & _
				"     on l.teva_ccod = m.teva_ccod " & vbCrLf  & _
				" left outer join calificaciones_alumnos n " & vbCrLf  & _
				"     on h.matr_ncorr=n.matr_ncorr and i.secc_ccod=n.secc_ccod and l.cali_ncorr=n.cali_ncorr " & vbCrLf  & _
				" where cast(g.anos_ccod as varchar)='"&ano_consulta&"' " & vbCrLf  & _
				" and cast(a.pers_ncorr as varchar) = '"&pers_ncorr&"' " & vbCrLf  & _
				" and a.emat_ccod <> 9 " & vbCrLf  & _
				" order by g.peri_ccod,sede, carrera, jornada, asignatura, seccion, numero"

parciales.consultar	c_parciales

'-----------------------------------------------------------CURRICULUM ALUMNO----------------------------------------------
'--------------------------------------------------------------------------------------------------------------------------
set f_datos_antecedentes = new CFormulario
f_datos_antecedentes.Carga_Parametros "tabla_vacia.xml", "tabla"
f_datos_antecedentes.Inicializar conexion

selec_antecedentes=	"select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
					"protic.trunc(pers_fnacimiento)fnacimiento,"& vbCrLf &_
					"pers_temail,"& vbCrLf &_
					"pers_temail2,"& vbCrLf &_
					"(select sexo_tdesc from sexos bb where a.sexo_ccod=bb.sexo_ccod )as sexo,"& vbCrLf &_
					"(select eciv_tdesc from estados_civiles aa where a.eciv_ccod=aa.eciv_ccod)as estado_civil,"& vbCrLf &_
					"(select pais_tnacionalidad from paises aa where aa.pais_ccod=a.pais_ccod)as nacionalidad,"& vbCrLf &_
					"dire_tcalle+' #'+dire_tnro as direccion,"& vbCrLf &_
					"dire_tpoblacion,"& vbCrLf &_
					"dire_tblock,"& vbCrLf &_
					"dire_tdepto,"& vbCrLf &_
					"dire_tfono,"& vbCrLf &_
					"dire_tcelular,"& vbCrLf &_
					"ciud_tdesc,"& vbCrLf &_
					"ciud_tcomuna,"& vbCrLf &_
					"(select regi_tdesc from regiones cc where cc.regi_ccod=c.regi_ccod)as regi_tdesc"& vbCrLf &_
					"from personas a, direcciones b,ciudades c "& vbCrLf &_
					"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
					"and b.ciud_ccod=c.ciud_ccod"& vbCrLf &_
					"and cast(pers_nrut as varchar)='"&pers_nrut&"'"& vbCrLf &_
					"and tdir_ccod=1"

f_datos_antecedentes.Consultar selec_antecedentes
f_datos_antecedentes.Siguiente

'-----------Diplomados y cursos
 set f_muestra_seminario = new CFormulario
 f_muestra_seminario.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_muestra_seminario.Inicializar conexion

 selec_seminario=" select ticu_tdesc as tipo,cscu_tnombre as nombre, cscu_tinstitucion as institucion, cscu_ano as anio "& vbCrLf &_
				 " from curso_seminario_curriculum a, tipo_curso_seminario b "& vbCrLf &_
				 " where a.ticu_ccod = b.ticu_ccod and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
 
 f_muestra_seminario.Consultar selec_seminario
 
 '----------Experiencia Laboral
 set f_muestra_trabajo = new CFormulario
 f_muestra_trabajo.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_muestra_trabajo.Inicializar conexion
					
 trabajomuestra =" select a.dlpr_ncorr,exal_ncorr ,dlpr_nombre_empresa as nombre_empresa,dlpr_rubro_empresa as rubro_empresa,dlpr_cargo_empresa as cargo_empresa,dlpr_web_empresa as web_empresa"&_
                 " from direccion_laboral_profesionales a,experiencia_alumno b "&_
				 " where a.dlpr_ncorr=b.dlpr_ncorr and tiea_ccod=1 and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' order  by exal_fini desc"

 f_muestra_trabajo.Consultar trabajomuestra

'-----------Práctica laboral
 set f_muestra_practica = new CFormulario
 f_muestra_practica.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_muestra_practica.Inicializar conexion

					
 MuestraPractica =" select a.dlpr_ncorr, pers_ncorr,dlpr_nombre_empresa as nombre_empresa,dlpr_rubro_empresa as rubro_empresa,dlpr_cargo_empresa as cargo_empresa,dlpr_web_empresa as web_empresa "&_
                  " from direccion_laboral_profesionales a,experiencia_alumno b "&_
				  " where a.dlpr_ncorr=b.dlpr_ncorr and tiea_ccod=2 and cast(a.pers_ncorr as varchar) = '"&pers_ncorr&"' order by exal_fini desc" 

 f_muestra_practica.Consultar MuestraPractica

'-----------Actividades Tempranas
 set f_muestra_pasantia = new CFormulario
 f_muestra_pasantia.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_muestra_pasantia.Inicializar conexion

 MuestraPasantia=	" select a.dlpr_ncorr,pers_ncorr,dlpr_nombre_empresa as nombre_empresa,dlpr_rubro_empresa as rubro_empresa,dlpr_cargo_empresa as cargo_empresa,dlpr_web_empresa as web_empresa "&_
                    " from direccion_laboral_profesionales a,experiencia_alumno b "&_
					" where a.dlpr_ncorr=b.dlpr_ncorr and tiea_ccod=3 and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' order by exal_fini desc "

 f_muestra_pasantia.Consultar MuestraPasantia
 
 '----------Idiomas
 set f_muestra_idioma = new CFormulario
 f_muestra_idioma.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_muestra_idioma.Inicializar conexion

 c_idioma =	" select idal_ncorr,a.idio_ccod,idal_habla as habla,idal_lee as lee,idal_escribe as escribe,a.nidi_ccod,nidi_tdesc as nivel,"&_
            " case when a.idio_ccod=8 then idal_otro else idio_tdesc end as idioma "&_
			" from idioma_alumno a,niveles_idioma b,idioma c "&_
			" where cast(pers_ncorr as varchar)= '"&pers_ncorr&"' and a.nidi_ccod=b.nidi_ccod and a.idio_ccod=c.idio_ccod"

 f_muestra_idioma.Consultar c_idioma
 
'----------Software
 set f_muestra_habilidades_programa = new CFormulario
 f_muestra_habilidades_programa.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_muestra_habilidades_programa.Inicializar conexion

 MuestraHabilidadesPrograma=	" select pers_ncorr,cdpa_ncorr,(select soft_tdesc from software zz where zz.soft_ncorr=a.cdpa_tprograma)as programa, "&_
                                " nidi_tdesc as nivel "&_
								" from curriculum_dominio_programa_alumno a, niveles_idioma b  "&_
								" where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and a.nidi_ccod=b.nidi_ccod " 

 f_muestra_habilidades_programa.Consultar MuestraHabilidadesPrograma 

'----------Habilidades
 set f_habilidades = new CFormulario
 f_habilidades.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_habilidades.Inicializar conexion

 tiene = conexion.consultaUno("select count(*) from curriculum_habilidades_alumno where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
 
 if tiene=0 then
    MuestraHabilidades  = "  select ''"
 else
	MuestraHabilidades  = " select chal_ncorr,upper(chal_tarea_trabajo) as chal_tarea_trabajo,upper(chal_thabilidades_tecnica) as chal_thabilidades_tecnica,upper(chal_thabilidades_personales) as chal_thabilidades_personales,upper(chal_thabilidades_profesionales) as chal_thabilidades_profesionales "&_
	                      " from curriculum_habilidades_alumno where cast(pers_ncorr as varchar)='"&pers_ncorr&"'" 
 end if
 f_habilidades.Consultar MuestraHabilidades
 f_habilidades.Siguiente
 
'---------------------------------------------------------------------BLOQUEOS DE ALUMNO
 set f_bloqueos = new CFormulario
 f_bloqueos.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_bloqueos.Inicializar conexion
 
 c_bloqueos = " select peri_tdesc as periodo,sede_tdesc as sede,tblo_tdesc as tipo,eblo_tdesc as estado, "& vbCrLf &_
			  " protic.trunc(bloq_fbloqueo) as fecha_bloqueo, protic.trunc(bloq_fdesbloqueo) as fecha_desbloqueo, "& vbCrLf &_
			  " lower(bloq_tobservacion) as observacion "& vbCrLf &_
			  " from bloqueos a, tipos_bloqueos b, periodos_academicos c, sedes d,estados_bloqueos e "& vbCrLf &_
			  " where a.tblo_ccod=b.tblo_ccod and a.peri_ccod=c.peri_ccod and a.sede_ccod=d.sede_ccod "& vbCrLf &_
			  " and a.eblo_ccod=e.eblo_ccod and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"& vbCrLf &_
			  " order by bloq_fbloqueo "

 f_bloqueos.Consultar c_bloqueos
 
'------------------------------------------------------------------ANTECEDENTES RELACIONADOS CON CAE
es_cae = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end  from ufe_alumnos_cae ttt where cast(ttt.anos_ccod as varchar)='"&ano_consulta&"' and esca_ccod=1 and cast(ttt.rut as varchar)= '"&pers_nrut&"'")
mensaje_cae = ""
if es_cae = "SI" then
	mensaje_cae = "<font face='Times New Roman, Times, serif' size='3' color='#777777'><strong>CON BENEFICIO<br>CAE AÑO "&ano_consulta&"</strong></font>"
else
	mensaje_cae = "<font face='Times New Roman, Times, serif' size='3' color='#CC3300'><strong>SIN BENEFICIO<br>CAE AÑO "&ano_consulta&"</strong></font>"
end if

ano_ingreso_carrera = conexion.consultaUno("select protic.ano_ingreso_carrera_egresa2('"&pers_ncorr&"','"&carr_ccod&"')")
es_moroso  = conexion.consultaUno("select case protic.es_moroso('"&pers_ncorr&"',getDate()) when 'S' then 'SI' else 'NO' end ")

c_nivel_base     = " select top 1 nive_ccod from malla_curricular tr " & vbCrLf & _
				   " where cast(tr.plan_ccod as varchar) = '"&plan_ccod&"' " & vbCrLf & _
				   " and isnull(tr.mall_npermiso,0) = 0 " & vbCrLf & _
				   " and isnull(protic.estado_ramo_alumno('"&pers_ncorr&"',tr.asig_ccod,'"&carr_ccod&"',tr.plan_ccod,'"&periodo_consulta&"'),'') = '' " & vbCrLf & _
				   " order by nive_ccod asc  "
'response.Write("<pre>"&c_nivel_base&"</pre>")

nivel_base       = conexion.consultaUno(c_nivel_base)
	
c_nivel_superior = " select top 1 nive_ccod from malla_curricular tr " & vbCrLf & _
				   " where cast(tr.plan_ccod as varchar) = '"&plan_ccod&"' " & vbCrLf & _
				   " and isnull(tr.mall_npermiso,0) = 0 " & vbCrLf & _
				   " and isnull(protic.estado_ramo_alumno('"&pers_ncorr&"',tr.asig_ccod,'"&carr_ccod&"',tr.plan_ccod,'"&periodo_consulta&"'),'') <> '' " & vbCrLf & _
				   " order by nive_ccod desc  "

'response.Write("<pre>"&c_nivel_superior&"</pre>")
'response.end	
nivel_superior   = conexion.consultaUno(c_nivel_superior)
			 
%>
<html>
<head>
  <title>Datos Alumno</title>
	
    <link rel="stylesheet" type="text/css" href="css/cuadros.css" />


	<style type="text/css">
	body 
	{
	  font:normal 9pt verdana; 
	  margin:0;
	  padding:0;
	  border:0px none;
	  overflow:hidden;
	}
	.x-layout-panel-north 
	{
	    border:0px none;
    }
	#nav { 
		}
	#autoTabs
	{
	    padding:10px;
		background-image: url(images/fondo.jpg);
	}
	#center1, #center2, #center3, #center4, #center5, #center6, #center7, #west, #west2, #west3, #west4 
	{
	    padding:10px;
		background-image: url(images/ondas.jpg);
    	background-repeat: no-repeat;
	    background-attachment: fixed;
	}
	#north, #south{
	    font:normal 8pt arial, helvetica;
		background-image: url(images/fondo_enc_pie.jpg);
	}
	.x-layout-panel-center p {
	    margin:5px;
	}
	#props-panel .x-grid-col-0{
	}
	#props-panel .x-grid-col-1{
	}
	table {
	  font-size   :1.0em;
	  text-align: left; }
	.forward_sort {
	  background  :#f58902; }
	.reverse_sort {
	  background  :#ececec; }
	ul.pagination {
	  margin      :0;
	  padding     :0;
	  list-style  :none; }
	ul.pagination li {
	  margin      :0;
	  padding     :0 0 2px 0;
	  float       :left;
	  list-style  :none; }
	ul.pagination li a {
	  padding     :1px 3px 3px 3px;
	  display     :block; }
	ul.pagination li a.currentPage {
	  background  :#e4ebff; }
	a {
	color: #777777;
	font-weight: bold;
	text-decoration: underline;
	}
	a:hover {
		color: #F8A704;
		text-decoration: underline;
	}
	.boton{
        font-size:10px;
        font-family:Verdana,Helvetica;
        font-weight:bold;
        color:white;
        background:#085fbc;
        border:0px;
        width:80px;
        height:19px;
       }
	.loading-indicator 
	{
		font-size:8pt;
		background-image: url(images/loading.gif%27);
		background-repeat: no-repeat;
		background-position:top left;
		padding-left:20px;
		height:18px;
		text-align:left;
	}
	#loading
	{
		position:absolute;
		left:45%;
		top:40%;
		border:3px solid #B2D0F7;
		background:white url(images/block-bg.gif) repeat-x;
		padding:10px;
		font:bold 14px verdana,tahoma,helvetica;
		color:#003366;
		width:250px;
		text-align:center;
	}
	</style>
    <style>
	   @media print{ .noprint {visibility:hidden; }}
	</style>
</head>
<body background="images/ondas.jpg">
<div id="loading">
    <div class="loading-indicator">Cargando Informaci&oacute;n.<br>Espere un momento por favor...</div>
</div>

<link rel="stylesheet" type="text/css" href="css/ext-all.css" />
<!-- LIBS -->     
<script type="text/javascript" src="js/yui-utilities.js"></script>
<script type="text/javascript" src="js/ext-yui-adapter.js"></script>     <!-- ENDLIBS -->
<script type="text/javascript" src="js/ext-all.js"></script>

<script type="text/javascript">
	var texto_vinculo = "";
	Example = function(){
	        var layout;
	        return {
	            init : function(){
				   Ext.get('loading').remove();
	               layout = new Ext.BorderLayout(document.body, {
	                    hideOnLayout: true,
	                    north: {
	                        split:false,
	                        initialSize: 65,
	                        titlebar: false
	                    },
	                    west: {
	                        split:true,
	                        initialSize: 500,
	                        minSize: 175,
	                        maxSize: 700,
	                        titlebar: true,
	                        collapsible: true,
							autoScroll:true,
                            animate: true
	                    },
	                    east: {
	                        split:true,
	                        initialSize: 200,
	                        minSize: 200,
	                        maxSize: 400,
	                        titlebar: true,
	                        collapsible: true,
                            animate: true
	                    },
	                    south: {
	                        split:true,
	                        initialSize: 100,
	                        minSize: 100,
	                        maxSize: 100,
	                        titlebar: true,
	                        collapsible: true,
                            animate: true
	                    },
	                    center: {
	                        titlebar: true,
	                        autoScroll:true,
                            closeOnTab: true
                        }
	                });

                    layout.beginUpdate();
	                layout.add('north', new Ext.ContentPanel('north', 'North'));
	                layout.add('south', new Ext.ContentPanel('south', {title: 'Accesos Directos', closable: false}));
	                layout.add('west', new Ext.ContentPanel('west', {title: 'Hist&oacute;rico de Notas', closable: false}));
					layout.add('west', new Ext.ContentPanel('west2', {title: 'Notas Parciales', closable: false}));
					layout.add('west', new Ext.ContentPanel('west3', {title: 'Curriculum Alumno', closable: false}));
					layout.add('west', new Ext.ContentPanel('west4', {title: 'Historial de Bloqueos', closable: false}));
	                //layout.add('east', new Ext.ContentPanel(Ext.id(), {autoCreate:true, title: 'Datos Personales', closable: true}));
	                layout.add('east', new Ext.ContentPanel('autoTabs', {title: 'Datos Personales', closable: false}));
	                layout.add('center', new Ext.ContentPanel('center1', {title: 'Malla Curricular', closable: false}));
	                layout.add('center', new Ext.ContentPanel('center2', {title: 'Avance Acad&eacute;mico', closable: false}));
					layout.add('center', new Ext.ContentPanel('center3', {title: 'Horario Clases', closable: false}));
					layout.add('center', new Ext.ContentPanel('center4', {title: 'Evaluaci&oacute;n Docente', closable: false}));
					layout.add('center', new Ext.ContentPanel('center5', {title: 'Ficha Alumno', closable: false}));
					layout.add('center', new Ext.ContentPanel('center6', {title: 'Cuenta Corriente', closable: false}));
					layout.add('center', new Ext.ContentPanel('center7', {title: 'Matr&iacute;culas', closable: false}));
	                layout.getRegion('center').showPanel('center1');
	                layout.getRegion('west').hide();
	                layout.endUpdate();
	           },
	           
	           toggleWest : function(link){
	                var west = layout.getRegion('west');
	                if(west.isVisible()){
	                    west.hide();
	                    link.innerHTML = texto_vinculo;
	                }else{
	                    west.show();
						texto_vinculo = link.innerHTML;
						texto2 = "Ocultar " + texto_vinculo.replace(/Ocultar /g, "");
	                    link.innerHTML = texto2;
	                }
	           }
			   
	     };
	       
	}();
	Ext.EventManager.onDocumentReady(Example.init, Example, true);
	
function imprimir(capa_a_imprimir,titulo)
{
	var bName = navigator.appName;
	var bVer = parseFloat(navigator.appVersion);
	
	var contenido = document.getElementById(capa_a_imprimir).innerHTML;
	contenido = contenido.replace(/degradado_08/g, "degradado_08_blanco");
	contenido = contenido.replace(/_04.jpg/g, "_04_blanco.jpg");
	contenido = contenido.replace(/_06.jpg/g, "_06_blanco.jpg");
	contenido = contenido.replace(/btn_arriba.png/g, "btn_arriba_claro.png");
	contenido = contenido.replace("imprimir('"+capa_a_imprimir+"','"+titulo+"')" , "window.print()");//para el icono
	contenido = contenido.replace("imprimir('"+capa_a_imprimir+"','"+titulo+"')" , "window.print()");//para el hipervínculo
	
	//alert(contenido);
	ventana=window.open("print.html","ventana","width=560");
	ventana.document.open();
	ventana.document.write("<html>");
	ventana.document.write("  <head> <title>");
	ventana.document.write(            titulo );
	ventana.document.write("         </title>");
	ventana.document.write("  <link rel='stylesheet' type='text/css' href='css/cuadros_imprimir.css'>");
	ventana.document.write("  <style>");
    ventana.document.write("  	   @media print{ .noprint {visibility:hidden; }}");
    ventana.document.write("  </style>");
	ventana.document.write(" </head>");
	ventana.document.write(" <body style='background-color: #FFFFFF'>");
	ventana.document.write(     contenido);
	ventana.document.write(" </body>");
	ventana.document.write("</html>");
	ventana.document.close();
	ventana.print();
	ventana.focus();
}

function reporte_excel(reporte)
{
    if (reporte==1)
	{
	   document.avance_academico.submit();
	}
    else if (reporte==2)
	 {
	   document.malla_curricular.submit();
	 }
	else if (reporte==3)
	 {
	   document.carga_academica.submit();
	 } 
	else if (reporte==4)
	 {
	   document.ev_docente.submit();
	 }  
	else if (reporte==6)
	 {
	   document.cta_cte.submit();
	 }  
	else if (reporte==7)
	 {
	   document.historico_notas.submit();
	 } 
	else if (reporte==8)
	 {
	   document.notas_parciales.submit();
	 }
	 else if (reporte==9)
	 {
	   document.curriculum.submit();
	 }
	 else if (reporte==10)
	 {
	   document.bloqueos.submit();
	 }
}

function reporte_word() 
  {
  var q_pers_nrut='<%=pers_nrut%>';
  var q_pers_xdv='<%=pers_xdv%>';
  var npag='1'; 
  var direccion;
  
  direccion="ficha_antecedentes_word.asp?busqueda[0][pers_nrut]="+q_pers_nrut+"&busqueda[0][pers_xdv]="+q_pers_xdv+"&npag="+npag;
  window.open(direccion ,"ventana100","width=755,heigt=455,left=200,top=200,scrollbars=yes");
  //scrollbars=yes,
  }
  
function resetearPeriodo()
{
	document.buscador.elements["busqueda[0][peri_ccod]"].selectedIndex = 0;
}

</script>
	
<script type="text/javascript" src="js/examples.js"></script><!-- EXAMPLES -->
<div id ="container">
<div id="west" class="x-layout-inactive-content">
      <table width="98%" align="center" cellpadding="0" cellspacing="0">
         <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01i">&nbsp;</td>
					<td height="10" class="t02i">&nbsp;</td>
					<td width="10" height="10" class="t03i">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_calipso_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05i">
					  <table width="100%" align="left" cellpadding="0" cellspacing="0">
						<tr>
							<td width="75%" align="left">
							  <table width="100%" cellpadding="0" cellspacing="0">
								  <tr>
									<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>HIST&Oacute;RICO DE NOTAS</strong></font></td>
								  </tr>
								  <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=rut%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nombre%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=carrera%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=estado%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Per&iacute;odo</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=periodo%></font></td>
								 </tr>
							  </table>
							</td>
							<td width="25%" align="center">
							  <table width="95%" cellpadding="0" cellspacing="0" border="0">
							  	 <tr>
								 	<td width="100%">
									<div align="center" class="noprint">
									  <table width="100%" cellpadding="0" cellspacing="0">
									  	<tr>
											<td width="26" height="26"><a href="javascript:imprimir('west','Historico de notas');"><img width="26" height="26" src="images/btn_imprimir.png" border="0" title="Imprimir histórico de notas"></a></td>
											<td width="90%"><a href="javascript:imprimir('west','Histórico de notas');" title="Imprimir histórico de notas">Imprimir</a></td>
										</tr>
										<%if historico.nroFilas > 0 then%>
										<tr>
											<td width="26" height="35"><a href="javascript:reporte_excel(7);"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte Excel"></a></td>
											<td width="90%"><a href="javascript:reporte_excel(7);">Excel</a></td>
										</tr>
										<%else%>
										<tr>
											<td width="26" height="35"><a href="javascript:alert('No hay datos asociados a los parametros de búsqueda.');"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte Excel"></a></td>
											<td width="90%"><a href="javascript:alert('No hay datos asociados a los parametros de búsqueda.');">Excel</a></td>
										</tr>
										<%end if%>
									  </table>
									 </div>
									</td>
								 </tr>
							  </table>
							</td>
						</tr>
					</table>
					  
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_calipso_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01i">&nbsp;</td>
					<td height="10" class="t02i">&nbsp;</td>
					<td width="10" height="10" class="t03i">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_calipso_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05i">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>DETALLE ASIGNATURAS</strong></font></td>
						  </tr>
						  <tr>
							<td colspan="3" align="center">
                                <%  tabla_historica = ""
									if plan_ccod <> "" then
										response.Write("<table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>")
										tabla_historica = tabla_historica & " <table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>"
										response.Write("<tr borderColor=#999999 bgColor=#c4d7ff>")
										tabla_historica = tabla_historica & " <tr borderColor=#999999 bgColor=#c4d7ff> "
										response.Write("   <TH><FONT color=#333333>Nivel</FONT></TH> ")
										tabla_historica = tabla_historica & "    <TH><FONT color=#333333>Nivel</FONT></TH> "
										response.Write("   <TH><FONT color=#333333>Código</FONT></TH>")
										tabla_historica = tabla_historica & "   <TH><FONT color=#333333>Código</FONT></TH> "
										response.Write("   <TH><FONT color=#333333>Asignatura</FONT></TH>")
										tabla_historica = tabla_historica & "   <TH><FONT color=#333333>Asignatura</FONT></TH> "
										for o_ = 1 to oportunidades
										   response.Write("<TH><FONT color=#333333>"&o_&"&nbsp;Oport.</FONT></TH>")
										   tabla_historica = tabla_historica & "  <TH><FONT color=#333333>"&o_&"&nbsp;Oport.</FONT></TH> "
										next
										response.Write("</tr>")
										tabla_historica = tabla_historica & " </tr>"
										historico.siguiente
										nivel		= historico.obtenervalor("nive_ccod")
										aux			= historico.obtenervalor("asig_ccod")
										asignatura	= historico.obtenervalor("asig_tdesc")
										nota		= historico.obtenervalor("carg_nnota_final")
										sit_final	= historico.obtenervalor("sitf_ccod")
										ano			= historico.obtenervalor("anos_ccod")
										malla		= historico.obtenervalor("mall_ccod")
										cadena		= nota&"&nbsp;"&historico.obtenervalor("anos_ccod")
										
										contador	=	1
										col			=	1	
										nro			=	3							    
										for k=0 to historico.nroFilas-1 
											if historico.obtenervalor("asig_ccod") <> "" then
												historico.siguiente
												
												if aux = historico.obtenervalor("asig_ccod") then
													col	=	col + 1
													cadena = cadena & "<td nowrap align='center'>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>"
												else
													response.write("<tr bgColor=#ffffff>")
													tabla_historica = tabla_historica & " <tr bgColor=#ffffff>"
													response.Write("      <td>"&nivel&"</td>")
													tabla_historica = tabla_historica & "      <td>"&nivel&"</td>"
													response.Write("      <td>"&aux&"</td>")
													tabla_historica = tabla_historica & "      <td>"&aux&"</td>"
													response.Write("      <td>"&asignatura&"</td>")
													tabla_historica = tabla_historica & "      <td>"&asignatura&"</td>"
													response.Write("      <td>"&cadena&"</td>")
													tabla_historica = tabla_historica & "      <td>"&cadena&"</td>"
													for i_=1 to oportunidades-col
														response.Write("  <td>&nbsp;</td>")
														tabla_historica = tabla_historica & "  <td>&nbsp;</td>"
													next
													response.Write("</tr>")
													tabla_historica = tabla_historica & "</tr>"
													col	=	1
													contador = 2
													nivel		= historico.obtenervalor("nive_ccod")
													aux			= historico.obtenervalor("asig_ccod")
													asignatura	= historico.obtenervalor("asig_tdesc")
													nota		= historico.obtenervalor("carg_nnota_final")
													sit_final	= historico.obtenervalor("sitf_ccod")
													ano			= historico.obtenervalor("anos_ccod")
													malla   	= historico.obtenervalor("mall_ccod")
													horas		= historico.obtenervalor("asig_nhoras")
													cadena		= historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")
													nf			= historico.obtenervalor("nf")
													sf			= historico.obtenervalor("sitf_ccod")
												end if
											end if
											if k=historico.nrofilas-1 then
													'historico.anterior
													historico.anterior
													nivel		= historico.obtenervalor("nive_ccod")
													aux			= historico.obtenervalor("asig_ccod")
													asignatura	= historico.obtenervalor("asig_tdesc")
													nota		= historico.obtenervalor("carg_nnota_final")
													sit_final	= historico.obtenervalor("sitf_ccod")
													ano			= historico.obtenervalor("anos_ccod")
													horas		= historico.obtenervalor("asig_nhoras")
													malla  	    = historico.obtenervalor("mall_ccod")
													cadena		= historico.obtenervalor("carg_nnota_final")
													nf			= historico.obtenervalor("nf")
													sf			= historico.obtenervalor("sitf_ccod")
													historico.siguiente
													if aux = historico.obtenervalor("asig_ccod") then
														response.write("<tr bgColor=#FFFFFF>")
														tabla_historica = tabla_historica & "<tr bgColor=#FFFFFF>"
														response.Write("   <td>"&nivel&"</td>")
														tabla_historica = tabla_historica & "   <td>"&nivel&"</td>"
														response.Write("   <td>"&aux&"</td>")
														tabla_historica = tabla_historica & "   <td>"&aux&"</td>"
														response.Write("   <td>"&asignatura&"</td>")
														tabla_historica = tabla_historica & "   <td>"&asignatura&"</td>"
														response.Write("   <td>"&cadena&"&nbsp;"&ano&"</td>")
														tabla_historica = tabla_historica & "   <td>"&cadena&"&nbsp;"&ano&"</td>"
														response.Write("   <td>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>")
														tabla_historica = tabla_historica & "   <td>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>"
														for h_=3 to oportunidades
														historico.siguiente
														response.write("<td>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>")
														tabla_historica = tabla_historica & "<td>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>"
															'response.Write("<td>&nbsp;</td>")
														next
														response.Write("</tr>")
														tabla_historica = tabla_historica & "</tr>"
													else
														historico.siguiente
														response.write("<tr bgColor=#FFFFFF>")
														tabla_historica = tabla_historica & "<tr bgColor=#FFFFFF>"
														response.Write("   <td>"&historico.obtenervalor("nive_ccod")&"</td>")
														tabla_historica = tabla_historica & "   <td>"&historico.obtenervalor("nive_ccod")&"</td>"
														response.Write("   <td>"&historico.obtenervalor("asig_ccod")&"</td>")
														tabla_historica = tabla_historica & "   <td>"&historico.obtenervalor("asig_ccod")&"</td>"
														response.Write("   <td>"&historico.obtenervalor("asig_tdesc")&"</td>")
														tabla_historica = tabla_historica & "   <td>"&historico.obtenervalor("asig_tdesc")&"</td>"
														response.Write("   <td>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>")
														tabla_historica = tabla_historica & "   <td>"&historico.obtenervalor("carg_nnota_final")&"&nbsp;"&historico.obtenervalor("anos_ccod")&"</td>"
														for h_=2 to oportunidades
															response.Write("<td>&nbsp;</td>")
															tabla_historica = tabla_historica & "<td>&nbsp;</td>"
														next
														response.Write("</tr>")
														tabla_historica = tabla_historica & "</tr>"
													end if
											end if
										response.Write("</tr>")
										tabla_historica = tabla_historica & "</tr>"
									next
							response.Write("</table>")
							tabla_historica = tabla_historica & "</table>"
							else %>
								  <table class="v1" border="1" borderColor="#999999" bgColor="#adadad" cellspacing="0" cellspading="0" width="98%">
								  <tr align="center" bgColor="#c4d7ff">
									<TH><FONT color=#333333>Nivel</FONT></TH>
									<TH><FONT color=#333333>C&oacute;digo</FONT></TH>
									<TH><FONT color=#333333>Asignatura</FONT></TH>
									<TH><FONT color=#333333>1 oportunidad</FONT></TH>
									<TH><FONT color=#333333>2 oportunidad</FONT></TH>
									<TH><FONT color=#333333>3 oportunidad</FONT></TH>
								  </tr>
								  <tr bgcolor="#FFFFFF">
									<td colspan="6" align="center" class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>No hay datos asociados a los parametros de b&uacute;squeda.</td>
								  </tr>
								</table>
								<%
							end if
							%>
							 <form name="historico_notas" action="historico_notas_excel.asp" method="post" target="_blank">
								   <input type="hidden" name="rut" value="<%=rut%>">
								   <input type="hidden" name="nombres" value="<%=nombre%>">
								   <input type="hidden" name="carrera" value="<%=carrera%>">
								   <input type="hidden" name="estado" value="<%=estado%>">
								   <input type="hidden" name="periodo" value="<%=periodo%>">
								   <input type="hidden" name="especialidad_plan" value="<%=especialidad_plan%>">
								   <input type="hidden" name="tabla_historica" value="<%=tabla_historica%>">
			                 </form>
							</td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_calipso_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
	</table>
  </div>
  
  <div id="west2" class="x-layout-inactive-content">
      <table width="98%" align="center" cellpadding="0" cellspacing="0">
         <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01c">&nbsp;</td>
					<td height="10" class="t02c">&nbsp;</td>
					<td width="10" height="10" class="t03c">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_celeste_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05c">
					  <table width="100%" align="left" cellpadding="0" cellspacing="0">
							<tr>
								<td width="75%" align="left">
								  <table width="100%" cellpadding="0" cellspacing="0">
									  <tr>
										<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>NOTAS PARCIALES</strong></font></td>
									  </tr>
									  <tr>
										<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT</strong></font></td>
										<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
										<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=rut%></font></td>
									 </tr>
									 <tr>
										<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre</strong></font></td>
										<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
										<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nombre%></font></td>
									 </tr>
									 <tr>
										<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera</strong></font></td>
										<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
										<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=carrera%></font></td>
									 </tr>
									 <tr>
										<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado</strong></font></td>
										<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
										<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=estado%></font></td>
									 </tr>
									 <tr>
										<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Per&iacute;odo</strong></font></td>
										<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
										<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=periodo%></font></td>
									 </tr>
								  </table>
								</td>
								<td width="25%" align="center">
								  <table width="95%" cellpadding="0" cellspacing="0" border="0">
									 <tr>
										<td width="100%">
										 <div align="center" class="noprint">
										  <table width="100%" cellpadding="0" cellspacing="0">
											<tr>
												<td width="26" height="26"><a href="javascript:imprimir('west2','Notas Parciales');"><img width="26" height="26" src="images/btn_imprimir.png" border="0" title="Imprimir notas parciales"></a></td>
												<td width="90%"><a href="javascript:imprimir('west2','Notas Parciales');" title="Imprimir notas parciales">Imprimir</a></td>
											</tr>
											<%if parciales.nroFilas > 0 then%>
											<tr>
												<td width="26" height="35"><a href="javascript:reporte_excel(8);"><img width="26" height="26" src="images/btn_word.png" border="0" title="Generar Reporte"></a></td>
												<td width="90%"><a href="javascript:reporte_excel(8);">Reporte</a></td>
											</tr>
											<%else%>
											<tr>
												<td width="26" height="35"><a href="javascript:alert('No existen notas parciales registradas para el alumno');"><img width="26" height="26" src="images/btn_word.png" border="0" title="Generar Reporte"></a></td>
												<td width="90%"><a href="javascript:alert('No existen notas parciales registradas para el alumno');">Reporte</a></td>
											</tr>
											<%end if%>
										  </table>
										 </div>
										</td>
									 </tr>
								  </table>
								</td>
							</tr>
						</table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_celeste_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <%if parciales.nroFilas > 0 then%>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01c">&nbsp;</td>
					<td height="10" class="t02c">&nbsp;</td>
					<td width="10" height="10" class="t03c">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_celeste_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05c">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>NOTAS PARCIALES POR SEMESTRE</strong></font></td>
						  </tr>
						  <tr>
							<td colspan="3" align="left">
							    <%tabla_parciales = ""%>
							    <table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
								<%tabla_parciales = tabla_parciales & "<table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>" %>
								<%
								 parciales.siguiente
								 asignatura = parciales.obtenerValor("asignatura")
								 pasada = 0
								 parciales.primero
							     while parciales.siguiente
								        mensaje_final = "Asistencia:"&asistencia&", Promedio Final: "&nota_final&" ("&estado2&")"
								    	peri_ccod2 = parciales.obtenerValor("peri_ccod")	
										peri_tdesc2 = parciales.obtenerValor("peri_tdesc")	
										sede2 = parciales.obtenerValor("sede")	
										carrera2 = parciales.obtenerValor("carrera")	
										jornada2 = parciales.obtenerValor("jornada")	
										nivel = parciales.obtenerValor("nivel")	
										asignatura2 = parciales.obtenerValor("asignatura")	
										seccion	 = parciales.obtenerValor("seccion")
										numero = parciales.obtenerValor("numero")	
										tipo = parciales.obtenerValor("tipo")	
										ponderacion = parciales.obtenerValor("ponderacion")	
										fecha_ev = parciales.obtenerValor("fecha_ev")	
										nota_parcial = parciales.obtenerValor("nota_parcial")	
										asistencia = parciales.obtenerValor("asistencia")	
										nota_final = parciales.obtenerValor("nota_final")	
										estado2 = parciales.obtenerValor("estado")
										if pasada = 0 or asignatura <> asignatura2 then
										      if pasada <> 0 then%>
										      <tr><%tabla_parciales = tabla_parciales & "<tr>" %>
												  <td colspan="5" align="right" bgcolor="#FFFFFF"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong><%=mensaje_final%></strong></font></td>
											      <%tabla_parciales = tabla_parciales & "<td colspan='5' align='right' bgcolor='#FFFFFF'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'><strong>"&mensaje_final&"</strong></font></td>" %>
											  </tr><%tabla_parciales = tabla_parciales & "</tr>" %>
											<%mensaje_final = ""
										    end if%>
										   </table><%tabla_parciales = tabla_parciales & "</table>" %>
										   </td><%tabla_parciales = tabla_parciales & "</td>" %>
										   </tr><%tabla_parciales = tabla_parciales & "</tr>" %>
										   <tr><%tabla_parciales = tabla_parciales & "<tr>" %>
											 <td colspan="3" align="left">&nbsp;</td>
											 <%tabla_parciales = tabla_parciales & "<td colspan='3' align='left'>&nbsp;</td>" %>
										   </tr><%tabla_parciales = tabla_parciales & "</tr>" %>
										   <tr><%tabla_parciales = tabla_parciales & "<tr>" %>
												<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Período</strong></font></td>
												<%tabla_parciales = tabla_parciales & "<td width='10%'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'><strong>Período</strong></font></td>" %>
												<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
												<%tabla_parciales = tabla_parciales & "<td width='2%' align='center'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'><strong>:</strong></font></td>" %>
												<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=peri_tdesc2%></font></td>
												<%tabla_parciales = tabla_parciales & "<td width='88%'><font face='Times New Roman, Times, serif' size='2' color='#404040'>"&peri_tdesc2&"</font></td>" %>
										   </tr><%tabla_parciales = tabla_parciales & "</tr>" %>
										   <tr><%tabla_parciales = tabla_parciales & "<tr>" %>
												<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Sede</strong></font></td>
												<%tabla_parciales = tabla_parciales & "<td width='10%'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'><strong>Sede</strong></font></td>" %>
												<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
												<%tabla_parciales = tabla_parciales & "<td width='2%' align='center'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'><strong>:</strong></font></td>" %>
												<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=sede2%></font></td>
												<%tabla_parciales = tabla_parciales & "<td width='88%'><font face='Times New Roman, Times, serif' size='2' color='#404040'>"&sede2&"</font></td>" %>
										   </tr><%tabla_parciales = tabla_parciales & "</tr>" %>
										   <tr><%tabla_parciales = tabla_parciales & "<tr>" %>
												<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera</strong></font></td>
												<%tabla_parciales = tabla_parciales & "<td width='10%'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'><strong>Carrera</strong></font></td>" %>
												<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
												<%tabla_parciales = tabla_parciales & "<td width='2%' align='center'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'><strong>:</strong></font></td>" %>
												<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=carrera2%></font></td>
												<%tabla_parciales = tabla_parciales & "<td width='88%'><font face='Times New Roman, Times, serif' size='2' color='#404040'>"&carrera2&"</font></td>" %>
										   </tr><%tabla_parciales = tabla_parciales & "</tr>" %>
										   <tr><%tabla_parciales = tabla_parciales & "<tr>" %>
												<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Jornada</strong></font></td>
												<%tabla_parciales = tabla_parciales & "<td width='10%'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'><strong>Jornada</strong></font></td>" %>
												<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
												<%tabla_parciales = tabla_parciales & "<td width='2%' align='center'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'><strong>:</strong></font></td>" %>
												<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=jornada2%></font></td>
												<%tabla_parciales = tabla_parciales & "<td width='88%'><font face='Times New Roman, Times, serif' size='2' color='#404040'>"&jornada2&"</font></td>" %>
										   </tr><%tabla_parciales = tabla_parciales & "</tr>" %>
										   <tr><%tabla_parciales = tabla_parciales & "<tr>" %>
											 <td colspan="3" align="left">&nbsp;</td>
											 <%tabla_parciales = tabla_parciales & "<td colspan='3' align='left'>&nbsp;</td>" %>
										   </tr><%tabla_parciales = tabla_parciales & "</tr>" %>
										   <tr><%tabla_parciales = tabla_parciales & "<tr>" %>
										   <td colspan="3" align="left"><%tabla_parciales = tabla_parciales & "<td colspan='3' align='left'>" %>
										   <table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
										   <%tabla_parciales = tabla_parciales & "<table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>" %>
										   <tr borderColor="#999999" bgColor="#c4d7ff"><%tabla_parciales = tabla_parciales & "<tr borderColor='#999999' bgColor='#c4d7ff'>" %>
												<TH align="center"><FONT color=#333333>NIVEL</FONT><FONT color="#990000"><br><%=nivel%></font></TH>
												<%tabla_parciales = tabla_parciales & "<TH align='center'><FONT color=#333333>NIVEL</FONT><FONT color='#990000'><br>"&nivel&"</font></TH>" %>
												<TH colspan="3" align="left"><FONT color=#333333>ASIGNATURA</FONT><FONT color="#990000"><br><%=asignatura2%></font></TH>
												<%tabla_parciales = tabla_parciales & "<TH colspan='3' align='left'><FONT color=#333333>ASIGNATURA</FONT><FONT color='#990000'><br>"&asignatura2&"</font></TH>" %>
												<TH align="center"><FONT color=#333333>SECCION</FONT><FONT color="#990000"><br><%=seccion%></font></TH>
												<%tabla_parciales = tabla_parciales & "<TH align='center'><FONT color=#333333>SECCION</FONT><FONT color='#990000'><br>"&seccion&"</font></TH>" %>
											</tr><%tabla_parciales = tabla_parciales & "</tr>" %>
										    <tr borderColor="#999999" bgColor="#c4d7ff"> <%tabla_parciales = tabla_parciales & "<tr borderColor='#999999' bgColor='#c4d7ff'>" %>
												<TH><FONT color=#333333>Orden</FONT></TH><%tabla_parciales = tabla_parciales & "	<TH><FONT color=#333333>Orden</FONT></TH>" %>
												<TH><FONT color=#333333>Tipo</FONT></TH> <%tabla_parciales = tabla_parciales & "	<TH><FONT color=#333333>Tipo</FONT></TH>" %>
												<TH><FONT color=#333333>Fecha</FONT></TH><%tabla_parciales = tabla_parciales & "	<TH><FONT color=#333333>Fecha</FONT></TH>" %>
												<TH><FONT color=#333333>Ponderación</FONT></TH><%tabla_parciales = tabla_parciales & "	<TH><FONT color=#333333>Ponderación</FONT></TH>" %>
												<TH><FONT color=#333333>Calificaci&oacute;n</FONT></TH><%tabla_parciales = tabla_parciales & "	<TH><FONT color=#333333>Calificaci&oacute;n</FONT></TH>" %>
											</tr><%tabla_parciales = tabla_parciales & "</tr>" %>
											<%pasada = pasada + 1
											  asignatura = asignatura2
										end if%>
											<tr borderColor="#999999" bgColor="#ffffff"><%tabla_parciales = tabla_parciales & "<tr borderColor='#999999' bgColor='#ffffff'>" %>
												<TD align="center"><%=numero%></TD><%tabla_parciales = tabla_parciales & "<TD align='center'>"&numero&"</TD>" %>
												<TD><%=tipo%></TD><%tabla_parciales = tabla_parciales & "<TD>"&tipo&"</TD>" %>
												<TD><%=fecha_ev%></TD><%tabla_parciales = tabla_parciales & "<TD>"&fecha_ev&"</TD>" %>
												<TD align="center"><%=ponderacion%></TD><%tabla_parciales = tabla_parciales & "<TD align='center'>"&ponderacion&"</TD>" %>
												<TD align="center"><%=nota_parcial%></TD><%tabla_parciales = tabla_parciales & "<TD align='center'>"&nota_parcial&"</TD>" %>
											</tr><%tabla_parciales = tabla_parciales & "</tr>" %>
							    <%wend%>
								        <tr><%tabla_parciales = tabla_parciales & "</tr>" %>
										  <td colspan="5" align="right" bgcolor="#FFFFFF"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong><%=mensaje_final%></strong></font></td>
										  <%tabla_parciales = tabla_parciales & "<td colspan='5' align='right' bgcolor='#FFFFFF'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'><strong>"&mensaje_final&"</strong></font></td>" %>
										</tr><%tabla_parciales = tabla_parciales & "</tr>" %>
							  </table><%tabla_parciales = tabla_parciales & "</table>" %>
							</td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_celeste_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <form name="notas_parciales" action="notas_parciales_excel.asp" method="post" target="_blank">
			 <input type="hidden" name="rut" value="<%=rut%>">
			 <input type="hidden" name="nombres" value="<%=nombre%>">
			 <input type="hidden" name="carrera" value="<%=carrera%>">
			 <input type="hidden" name="estado" value="<%=estado%>">
			 <input type="hidden" name="periodo" value="<%=periodo%>">
			 <input type="hidden" name="especialidad_plan" value="<%=especialidad_plan%>">
			 <input type="hidden" name="tabla_parciales" value="<%=tabla_parciales%>">
		 </form>
		 <%else%>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01c">&nbsp;</td>
					<td height="10" class="t02c">&nbsp;</td>
					<td width="10" height="10" class="t03c">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_celeste_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05c">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="center"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong><br><br>NO EXISTE INFORMACI&Oacute;N DE NOTAS PARCIALES REGISTRADAS EN EL P&Eacute;RIODO</strong></font></td>
						  </tr>
    				  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_celeste_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" height="300">&nbsp;</td>
		 </tr>
		 <%end if%>
	</table>
  </div>
  <div id="west3" class="x-layout-inactive-content">
      <table width="98%" align="center" cellpadding="0" cellspacing="0">
         <tr>
			<td colspan="3" id="curriculum_sup">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01t">&nbsp;</td>
					<td height="10" class="t02t">&nbsp;</td>
					<td width="10" height="10" class="t03t">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_violeta_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05t">
					  <table width="100%" align="left" cellpadding="0" cellspacing="0">
							<tr>
								<td width="75%" align="left">
								  <table width="100%" cellpadding="0" cellspacing="0">
									  <tr>
										<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>CURRICULUM ALUMNO</strong></font></td>
									  </tr>
									  <tr>
										<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT</strong></font></td>
										<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
										<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=rut%></font></td>
									 </tr>
									 <tr>
										<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre</strong></font></td>
										<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
										<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nombre%></font></td>
									 </tr>
									 <tr>
										<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera</strong></font></td>
										<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
										<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=carrera%></font></td>
									 </tr>
									 <tr>
										<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado</strong></font></td>
										<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
										<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=estado%></font></td>
									 </tr>
									 <tr>
										<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Per&iacute;odo</strong></font></td>
										<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
										<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=periodo%></font></td>
									 </tr>
								  </table>
								</td>
								<td width="25%" align="center">
								  <table width="95%" cellpadding="0" cellspacing="0" border="0">
									 <tr>
										<td width="100%">
										<div align="center" class="noprint">
										  <table width="100%" cellpadding="0" cellspacing="0">
											<tr>
												<td width="26" height="26"><a href="javascript:imprimir('west3','Curriculum Alumno');"><img width="26" height="26" src="images/btn_imprimir.png" border="0" title="Imprimir Curriculum"></a></td>
												<td width="30%">&nbsp;</td>
												<td width="26" height="26"><a href="javascript:reporte_excel(9);"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte"></a></td>
												<td width="30%">&nbsp;</td>
												<td width="26" height="26"><a href="#f_alumno"><img width="26" height="26" src="images/btn_alumno.png" border="0" title="Ir a datos personales"></a></td>
												<td width="30%">&nbsp;</td>
											</tr>
											<tr>
												<td width="26" height="30"><a href="#f_cursos"><img width="26" height="26" src="images/btn_cursos.png" border="0" title="Ir a cursos y diplomados"></a></td>
												<td width="30%">&nbsp;</td>
												<td width="26" height="30"><a href="#f_laboral"><img width="26" height="26" src="images/btn_laboral.png" border="0" title="Ir a experiencia laboral"></a></td>
												<td width="30%">&nbsp;</td>
												<td width="26" height="30"><a href="#f_practica"><img width="26" height="26" src="images/btn_practica.png" border="0" title="Ir a práctica laboral"></a></td>
												<td width="30%">&nbsp;</td>
											</tr>
											<tr>
												<td width="26" height="30"><a href="#f_actividades"><img width="26" height="26" src="images/btn_actividades.png" border="0" title="Ir a actividades tempranas"></a></td>
												<td width="30%">&nbsp;</td>
												<td width="26" height="30"><a href="#f_idiomas"><img width="26" height="26" src="images/btn_idiomas.png" border="0" title="Ir a conocimientos en idiomas"></a></td>
												<td width="30%">&nbsp;</td>
												<td width="26" height="30"><a href="#f_software"><img width="26" height="26" src="images/btn_software.png" border="0" title="Ir a dominio de software"></a></td>
												<td width="30%">&nbsp;</td>
											</tr>
											<tr>
												<td width="26" height="30"><a href="#f_habilidades"><img width="26" height="26" src="images/btn_habilidades.png" border="0" title="Ir a descripción de habilidades"></a></td>
												<td width="30%">&nbsp;</td>
												<td width="26" height="30">&nbsp;</td>
												<td width="30%">&nbsp;</td>
												<td width="26" height="30">&nbsp;</td>
												<td width="30%">&nbsp;</td>
											</tr>
										  </table>
										 </div>
										</td>
									 </tr>
								  </table>
								</td>
							</tr>
						</table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_violeta_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3" id="f_alumno">&nbsp;</td>
		 </tr>
		 <form name="curriculum" action="curriculum_excel.asp" method="post" target="_blank">
		   <input type="hidden" name="rut" value="<%=rut%>">
		   <input type="hidden" name="nombres" value="<%=nombre%>">
		   <input type="hidden" name="carrera" value="<%=carrera%>">
		   <input type="hidden" name="estado" value="<%=estado%>">
		   <input type="hidden" name="periodo" value="<%=periodo%>">
		   <input type="hidden" name="especialidad_plan" value="<%=especialidad_plan%>">
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01t">&nbsp;</td>
					<td height="10" class="t02t">&nbsp;</td>
					<td width="10" height="10" class="t03t">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_violeta_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05t">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>DATOS PERSONALES</strong></font></td>
						  </tr>
						  <tr>
						  	<td colspan="3">&nbsp;</td>
						  </tr>
						  <tr>
						  	<td colspan="3">
							   <table width="98%"  border="0" align="center">
							   <tr> 
												<td width="31%"  height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombres :</strong></font></td>
												<td width="27%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Fecha Nacimiento :</strong></font></td>
												<td width="21%">&nbsp;</td>
												<td width="21%">&nbsp;</td>
							   </tr>
							   <tr valign="top"> 
												<td height="20"> 
													 <table width="100%" border="0" cellpadding="0" cellspacing="0">
															<tr> 
															  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("nombre")%></font></td>
															  <input type="hidden" name="nombre_fp" value="<%=f_datos_antecedentes.dibujaCampo("nombre")%>">
															</tr>
													  </table>											
											     </td>
												 <td>
												       <table width="80%" border="0" cellpadding="0" cellspacing="0">
															<tr> 
															  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("fnacimiento")%></font></td>
															  <input type="hidden" name="fnacimiento_fp" value="<%=f_datos_antecedentes.dibujaCampo("fnacimiento")%>">
															</tr>
													   </table>											
												  </td>
												  <td>
														 <table width="100%" border="0" cellpadding="0" cellspacing="0">
															<tr>													</tr>
														 </table>	
		  										  </td>
												  <td>
														 <table width="96%" border="0" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
															<tr>													</tr>
													     </table>											
												  </td>
								</tr>
								<tr> 
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
								</tr>
								<tr> 
												<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Direcci&oacute;n :</strong></font></td>
												<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Comuna : </strong></font></td>
												<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Ciudad :</strong></font></td>
												<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Regi&oacute;n :</strong></font></td>
								</tr>
								<tr valign="top"> 
												<td height="20"> 
													  <table width="100%" border="0" cellpadding="0" cellspacing="0">
														<tr> 
														  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("direccion")%></font></td>
														  <input type="hidden" name="direccion_fp" value="<%=f_datos_antecedentes.dibujaCampo("direccion")%>">
														</tr>
													  </table>									    
												 </td>
												 <td> 
												      <table width="100%" border="0" cellpadding="0" cellspacing="0">
														<tr> 
														  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("ciud_tdesc")%></font></td>
														  <input type="hidden" name="ciud_tdesc_fp" value="<%=f_datos_antecedentes.dibujaCampo("ciud_tdesc")%>">
														</tr>
													  </table>									    
												  </td>
												  <td> 
													  <table width="100%" border="0" cellpadding="0" cellspacing="0">
														<tr> 
														  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("ciud_tcomuna")%></font></td>
														  <input type="hidden" name="ciud_tcomuna_fp" value="<%=f_datos_antecedentes.dibujaCampo("ciud_tcomuna")%>">
														</tr>
													  </table>										 
												  </td>
												  <td> 
													  <table width="100%" border="0" cellpadding="0" cellspacing="0">
														<tr> 
														  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("regi_tdesc")%></font></td>
														  <input type="hidden" name="regi_tdesc_fp" value="<%=f_datos_antecedentes.dibujaCampo("regi_tdesc")%>">
														</tr>
													  </table>
												  </td>
							    </tr>
								<tr> 
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
												<td height="10">&nbsp;</td>
								</tr>
								<tr> 
												<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Celular : </strong></font></td>
												<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Telefono :</strong></font></td>
												<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nacionalidad :</strong></font></td>
								</tr>
							    <tr valign="top"> 
												<td> 
													  <table width="100%" border="0" cellpadding="0" cellspacing="0">
														<tr> 
														  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("dire_tcelular")%></font></td>
														  <input type="hidden" name="dire_tcelular_fp" value="<%=f_datos_antecedentes.dibujaCampo("dire_tcelular")%>">
														</tr>
													  </table>	
												</td>
												<td> 
													  <table width="100%" border="0" cellpadding="0" cellspacing="0">
														<tr> 
														  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("dire_tfono")%></font></td>
														  <input type="hidden" name="dire_tfono_fp" value="<%=f_datos_antecedentes.dibujaCampo("dire_tfono")%>">
														</tr>
													  </table>	
												</td>
												<td> 
													 <table width="100%" border="0" cellpadding="0" cellspacing="0">
														<tr> 
														  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("nacionalidad")%></font></td>
														  <input type="hidden" name="nacionalidad_fp" value="<%=f_datos_antecedentes.dibujaCampo("nacionalidad")%>">
														</tr>
													  </table>	
												</td>
												<td> 
													  <table width="40%" border="0" cellpadding="0" cellspacing="0">
														<tr>											</tr>
													  </table>	
												</td>
							  </tr>
							  <tr> 
												<td height="10">&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
							 </tr>
							 <tr> 
												<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado Civil :</strong></font></td>
												<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Sexo  :</strong></font></td>
												<td>&nbsp;</td>
							 </tr>
							 <tr valign="top"> 
												<td height="20"> 
													  <table width="100%" border="0" cellpadding="0" cellspacing="0">
														<tr> 
														  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("estado_civil")%></font></td>
														  <input type="hidden" name="estado_civil_fp" value="<%=f_datos_antecedentes.dibujaCampo("estado_civil")%>">
														</tr>
													  </table>
											    </td>
												<td colspan="1">
													<table width="99%" border="0" cellpadding="0" cellspacing="0">
														<tr> 
														  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("sexo")%></font></td>
														  <input type="hidden" name="sexo_fp" value="<%=f_datos_antecedentes.dibujaCampo("sexo")%>">
														</tr>
													  </table>
											    </td>
												<td>
													<table width="99%" border="0" cellpadding="0" cellspacing="0">
													  <tr>                                          </tr>
													</table>
											    </td>
							</tr>
							<tr> 
												<td height="20" colespan "2"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Email 1 : </strong></font></td>
												<td></td>
							</tr>
							<tr valign="top"> 
												<td colspan="2"> 
													  <table width="100%"  border="0" cellpadding="0" cellspacing="0">
														<tr> 
														  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("pers_temail")%></font></td>
														  <input type="hidden" name="pers_temail_fp" value="<%=f_datos_antecedentes.dibujaCampo("pers_temail")%>">
														</tr>
													  </table>
											    </td>
												<td colspan="1">
													 <table width="99%" border="0" cellpadding="0" cellspacing="0">
														<tr>											</tr>
													  </table>
												</td>
												<td>
													<table width="99%" border="0" cellpadding="0" cellspacing="0">
													  <tr>                                          </tr>
													</table>
												</td>
							</tr>
							<tr> 
												<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Email 2 : </strong></font></td>
												<td></td>
							</tr>
							<tr valign="top"> 
												<td colspan="2"> 
												  <table width="100%" border="0" cellpadding="0" cellspacing="0">
													<tr> 
													  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=f_datos_antecedentes.dibujaCampo("pers_temail2")%></font></td>
													  <input type="hidden" name="pers_temail2_fp" value="<%=f_datos_antecedentes.dibujaCampo("pers_temail2")%>">
													</tr>
												  </table>
												</td>
												<td colspan="1">
												   <table width="99%" border="0" cellpadding="0" cellspacing="0">
													<tr>											</tr>
												  </table>
												</td>
												<td>
												  <table width="99%" border="0" cellpadding="0" cellspacing="0">
												    <tr><td width="100%" align="right"><a href="#curriculum_sup"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td></tr>
												  </table>
											    </td>
							</tr>   
						   </table>
						  </td>
						  </tr>
    				  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_violeta_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3" id="f_cursos">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01t">&nbsp;</td>
					<td height="10" class="t02t">&nbsp;</td>
					<td width="10" height="10" class="t03t">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_violeta_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05t">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>CURSOS Y DIPLOMADOS</strong></font></td>
						  </tr>
						  <tr>
							<td colspan="3">&nbsp;</td>
						  </tr>
						  <tr>
							<td colspan="3">
							   <% tabla_cursos = "" %>
								<table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
								<%tabla_cursos = tabla_cursos & "<table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>" %>
									<tr borderColor="#999999" bgColor="#c4d7ff"><%tabla_cursos = tabla_cursos & "<tr borderColor='#999999' bgColor='#c4d7ff'>" %>
										<TH><FONT color=#333333>Tipo</FONT></TH><%tabla_cursos = tabla_cursos & "<TH><FONT color='#333333'>Tipo</FONT></TH>" %>
										<TH><FONT color=#333333>Nombre</FONT></TH><%tabla_cursos = tabla_cursos & "<TH><FONT color='#333333'>Nombre</FONT></TH>" %>
										<TH><FONT color=#333333>Instituci&oacute;n</FONT></TH><%tabla_cursos = tabla_cursos & "<TH><FONT color='#333333'>Instituci&oacute;n</FONT></TH>" %>
										<TH align="center"><FONT color=#333333>Año</FONT></TH><%tabla_cursos = tabla_cursos & "<TH align='center'><FONT color='#333333'>Año</FONT></TH>" %>
									</tr><%tabla_cursos = tabla_cursos & "</tr>" %>
									<%if f_muestra_seminario.nroFilas > 0 then
									   while f_muestra_seminario.siguiente
									     tipo3 = f_muestra_seminario.obtenerValor("tipo")
										 nombre3 = f_muestra_seminario.obtenerValor("nombre")
										 institucion3 = f_muestra_seminario.obtenerValor("institucion")
										 anio3 = f_muestra_seminario.obtenerValor("anio")
									   %>
									     <tr borderColor="#999999" bgColor="#ffffff"><%tabla_cursos = tabla_cursos & "<tr borderColor='#999999' bgColor='#ffffff'>" %>
											<TD bgcolor="#FFFFFF"><%=tipo3%></TD>    <%tabla_cursos = tabla_cursos & "	<TD bgcolor='#FFFFFF'>"&tipo3&"</TD>" %>
											<TD bgcolor="#FFFFFF"><%=nombre3%></TD>  <%tabla_cursos = tabla_cursos & "  <TD bgcolor='#FFFFFF'>"&nombre3&"</TD>" %>
											<TD bgcolor="#FFFFFF"><%=institucion3%></TD><%tabla_cursos = tabla_cursos & "<TD bgcolor='#FFFFFF'>"&institucion3&"</TD>" %>
											<TD align="center" bgcolor="#FFFFFF"><%=anio3%></TD><%tabla_cursos = tabla_cursos & "<tr borderColor='#999999' bgColor='#c4d7ff'>" %>
										</tr><%tabla_cursos = tabla_cursos & "<tr borderColor='#999999' bgColor='#c4d7ff'>" %>
									   <%wend
									  else%>
									    <tr bgcolor="#FFFFFF"><td colspan="4" align="center">No existen seminarios o cursos registrados para el alumno</td></tr>
										<%tabla_cursos = tabla_cursos & "<tr bgcolor='#FFFFFF'><td colspan='4' align='center'>No existen seminarios o cursos registrados para el alumno</td></tr>" %>
									  <%end if%>
								</table><%tabla_cursos = tabla_cursos & "</table>" %>
								<input type="hidden" name="tabla_cursos" value="<%=tabla_cursos%>">							
							</td>
						  </tr>
						  <tr>
						  	<td colspan="3" align="right"><a href="#curriculum_sup"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_violeta_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3" id="f_laboral">&nbsp;</td>
		 </tr>
		  <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01t">&nbsp;</td>
					<td height="10" class="t02t">&nbsp;</td>
					<td width="10" height="10" class="t03t">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_violeta_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05t">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>EXPERIENCIA LABORAL</strong></font></td>
						  </tr>
						  <tr>
							<td colspan="3">&nbsp;</td>
						  </tr>
						  <tr>
							<td colspan="3">
							    <% tabla_laboral = ""%>
								<table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
								<% tabla_laboral = tabla_laboral & "<table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>"%>
									<tr borderColor="#999999" bgColor="#c4d7ff">   <% tabla_laboral = tabla_laboral & "<tr borderColor='#999999' bgColor='#c4d7ff'>"%>
										<TH><FONT color=#333333>Empresa</FONT></TH><% tabla_laboral = tabla_laboral & "<TH><FONT color=#333333>Empresa</FONT></TH>"%>
										<TH><FONT color=#333333>Rubro</FONT></TH>  <% tabla_laboral = tabla_laboral & "<TH><FONT color=#333333>Rubro</FONT></TH>"%>
										<TH><FONT color=#333333>Cargo</FONT></TH>  <% tabla_laboral = tabla_laboral & "<TH><FONT color=#333333>Cargo</FONT></TH>"%>
										<TH><FONT color=#333333>Web</FONT></TH>    <% tabla_laboral = tabla_laboral & "<TH><FONT color=#333333>Web</FONT></TH>"%>
									</tr><% tabla_laboral = tabla_laboral & "</tr>"%>
									<%if f_muestra_trabajo.nroFilas > 0 then
									   while f_muestra_trabajo.siguiente
									     nombre_empresa3 = f_muestra_trabajo.obtenerValor("nombre_empresa")
										 rubro_empresa3 = f_muestra_trabajo.obtenerValor("rubro_empresa")
										 cargo_empresa3 = f_muestra_trabajo.obtenerValor("cargo_empresa")
										 web_empresa3 = f_muestra_trabajo.obtenerValor("web_empresa")
									   %>
									     <tr borderColor="#999999" bgColor="#ffffff"><% tabla_laboral = tabla_laboral & "<tr borderColor='#999999' bgColor='#ffffff'>"%>
											<TD bgcolor="#FFFFFF"><%=nombre_empresa3%></TD><% tabla_laboral = tabla_laboral & "<TD bgcolor='#FFFFFF'>"&nombre_empresa3&"</TD>"%>
											<TD bgcolor="#FFFFFF"><%=rubro_empresa3%></TD><% tabla_laboral = tabla_laboral &  "<TD bgcolor='#FFFFFF'>"&rubro_empresa3&"</TD>"%>
											<TD bgcolor="#FFFFFF"><%=cargo_empresa3%></TD><% tabla_laboral = tabla_laboral &  "<TD bgcolor='#FFFFFF'>"&cargo_empresa3&"</TD>"%>
											<TD bgcolor="#FFFFFF"><%=web_empresa3%></TD><% tabla_laboral = tabla_laboral   &  "<TD bgcolor='#FFFFFF'>"&web_empresa3&"</TD>"%>
										</tr><% tabla_laboral = tabla_laboral & "</tr>"%>
									   <%wend
									  else%>
									    <tr bgcolor="#FFFFFF"><td colspan="4" align="center">No existe información de experiencia laboral registrada para el alumno</td></tr>
										<% tabla_laboral = tabla_laboral & "<tr bgcolor='#FFFFFF'><td colspan='4' align='center'>No existe información de experiencia laboral registrada para el alumno</td></tr>"%>
									  <%end if%>
								</table><% tabla_laboral = tabla_laboral & "</table>"%>							
							</td>
						  </tr>
						  <input type="hidden" name="tabla_laboral" value="<%=tabla_laboral%>">
						  <tr>
						  	<td colspan="3" align="right"><a href="#curriculum_sup"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_violeta_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3" id="f_practica">&nbsp;</td>
		 </tr>
    	 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01t">&nbsp;</td>
					<td height="10" class="t02t">&nbsp;</td>
					<td width="10" height="10" class="t03t">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_violeta_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05t">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>PR&Aacute;CTICA LABORAL</strong></font></td>
						  </tr>
						  <tr>
							<td colspan="3">&nbsp;</td>
						  </tr>
						  <tr>
							<td colspan="3">
							    <%tabla_practica = ""%>
								<table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
								<%tabla_practica = tabla_practica & "<table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>"%>
									<tr borderColor="#999999" bgColor="#c4d7ff"><%tabla_practica = tabla_practica & "<tr borderColor='#999999' bgColor='#c4d7ff'>"%>
										<TH><FONT color=#333333>Empresa</FONT></TH><%tabla_practica = tabla_practica & "<TH><FONT color=#333333>Empresa</FONT></TH>"%>
										<TH><FONT color=#333333>Rubro</FONT></TH><%tabla_practica = tabla_practica & "<TH><FONT color=#333333>Rubro</FONT></TH>"%>
										<TH><FONT color=#333333>Cargo</FONT></TH><%tabla_practica = tabla_practica & "<TH><FONT color=#333333>Cargo</FONT></TH>"%>
										<TH><FONT color=#333333>Web</FONT></TH><%tabla_practica = tabla_practica & "<TH><FONT color=#333333>Web</FONT></TH>"%>
									</tr><%tabla_practica = tabla_practica & "</tr>"%>
									<%if f_muestra_practica.nroFilas > 0 then
									   while f_muestra_practica.siguiente
									     nombre_empresa4 = f_muestra_practica.obtenerValor("nombre_empresa")
										 rubro_empresa4 = f_muestra_practica.obtenerValor("rubro_empresa")
										 cargo_empresa4 = f_muestra_practica.obtenerValor("cargo_empresa")
										 web_empresa4 = f_muestra_practica.obtenerValor("web_empresa")
									   %>
									     <tr borderColor="#999999" bgColor="#ffffff"><%tabla_practica = tabla_practica & "<tr borderColor='#999999' bgColor='#ffffff'>"%>
											<TD bgcolor="#FFFFFF"><%=nombre_empresa4%></TD><%tabla_practica = tabla_practica & "<TD bgcolor='#FFFFFF'>"&nombre_empresa4&"</TD>"%>
											<TD bgcolor="#FFFFFF"><%=rubro_empresa4%></TD><%tabla_practica = tabla_practica & " <TD bgcolor='#FFFFFF'>"&rubro_empresa4&"</TD>"%>
											<TD bgcolor="#FFFFFF"><%=cargo_empresa4%></TD><%tabla_practica = tabla_practica & " <TD bgcolor='#FFFFFF'>"&cargo_empresa4&"</TD>"%>
											<TD bgcolor="#FFFFFF"><%=web_empresa4%></TD><%tabla_practica = tabla_practica & "<TD bgcolor='#FFFFFF'>"&web_empresa4&"</TD>"%>
										</tr><%tabla_practica = tabla_practica & "</tr>"%>
									   <%wend
									  else%>
									    <tr bgcolor="#FFFFFF"><td colspan="4" align="center">No existe información de práctica laboral registrada para el alumno</td></tr>
									    <%tabla_practica = tabla_practica & "<tr bgcolor='#FFFFFF'><td colspan='4' align='center'>No existe información de práctica laboral registrada para el alumno</td></tr>"%>
									  <%end if%>
								</table><%tabla_practica = tabla_practica & "</table>"%>							
							</td>
						  </tr>
						  <input type="hidden" name="tabla_practica" value="<%=tabla_practica%>">
						  <tr>
						  	<td colspan="3" align="right"><a href="#curriculum_sup"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_violeta_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3" id="f_actividades">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01t">&nbsp;</td>
					<td height="10" class="t02t">&nbsp;</td>
					<td width="10" height="10" class="t03t">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_violeta_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05t">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>ACTIVIDADES TEMPRANAS</strong></font></td>
						  </tr>
						  <tr>
							<td colspan="3">&nbsp;</td>
						  </tr>
						  <tr>
							<td colspan="3">
							    <%tabla_actividades = ""%>
								<table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
								<%tabla_actividades = tabla_actividades & "<table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>"%>
									<tr borderColor="#999999" bgColor="#c4d7ff"><%tabla_actividades = tabla_actividades & "<tr borderColor='#999999' bgColor='#c4d7ff'>"%>
										<TH><FONT color=#333333>Empresa</FONT></TH><%tabla_actividades = tabla_actividades & "<TH><FONT color=#333333>Empresa</FONT></TH>"%>
										<TH><FONT color=#333333>Rubro</FONT></TH><%tabla_actividades = tabla_actividades & "<TH><FONT color=#333333>Rubro</FONT></TH>"%>
										<TH><FONT color=#333333>Cargo</FONT></TH><%tabla_actividades = tabla_actividades & "<TH><FONT color=#333333>Cargo</FONT></TH>"%>
										<TH><FONT color=#333333>Web</FONT></TH><%tabla_actividades = tabla_actividades & "<TH><FONT color=#333333>Web</FONT></TH>"%>
									</tr><%tabla_actividades = tabla_actividades & "</tr>"%>
									<%if f_muestra_pasantia.nroFilas > 0 then
									   while f_muestra_pasantia.siguiente
									     nombre_empresa5 = f_muestra_pasantia.obtenerValor("nombre_empresa")
										 rubro_empresa5 = f_muestra_pasantia.obtenerValor("rubro_empresa")
										 cargo_empresa5 = f_muestra_pasantia.obtenerValor("cargo_empresa")
										 web_empresa5 = f_muestra_pasantia.obtenerValor("web_empresa")
									   %>
									     <tr borderColor="#999999" bgColor="#ffffff"><%tabla_actividades = tabla_actividades & "<tr borderColor='#999999' bgColor='#ffffff'>"%>
											<TD bgcolor="#FFFFFF"><%=nombre_empresa5%></TD><%tabla_actividades = tabla_actividades & "<TD bgcolor='#FFFFFF'>"&nombre_empresa5&"</TD>"%>
											<TD bgcolor="#FFFFFF"><%=rubro_empresa5%></TD><%tabla_actividades = tabla_actividades & "<TD bgcolor='#FFFFFF'>"&rubro_empresa5&"</TD>"%>
											<TD bgcolor="#FFFFFF"><%=cargo_empresa5%></TD><%tabla_actividades = tabla_actividades & "<TD bgcolor='#FFFFFF'>"&cargo_empresa5&"</TD>"%>
											<TD bgcolor="#FFFFFF"><%=web_empresa5%></TD><%tabla_actividades = tabla_actividades & "<TD bgcolor='#FFFFFF'>"&web_empresa5&"</TD>"%>
										</tr><%tabla_actividades = tabla_actividades & "</tr>"%>
									   <%wend
									  else%>
                    					    <tr bgcolor="#FFFFFF"><td colspan="4" align="center">No existe información de actividades tempranas registradas para el alumno</td></tr>
									        <%tabla_actividades = tabla_actividades & "<tr bgcolor='#FFFFFF'><td colspan='4' align='center'>No existe información de actividades tempranas registradas para el alumno</td></tr>"%>
									  <%end if%>
								</table><%tabla_actividades = tabla_actividades & "</table>"%>							
							</td>
						  </tr>
						  <input type="hidden" name="tabla_actividades" value="<%=tabla_actividades%>">
						  <tr>
						  	<td colspan="3" align="right"><a href="#curriculum_sup"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_violeta_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3" id="f_idiomas">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01t">&nbsp;</td>
					<td height="10" class="t02t">&nbsp;</td>
					<td width="10" height="10" class="t03t">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_violeta_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05t">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>IDIOMAS</strong></font></td>
						  </tr>
						  <tr>
							<td colspan="3">&nbsp;</td>
						  </tr>
						  <tr>
							<td colspan="3">
							    <% tabla_idiomas = "" %>
								<table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
								<% tabla_idiomas = tabla_idiomas & "<table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>" %>
									<tr borderColor="#999999" bgColor="#c4d7ff"><% tabla_idiomas = tabla_idiomas & "<tr borderColor='#999999' bgColor='#c4d7ff'>" %>
										<TH><FONT color=#333333>Idioma</FONT></TH><% tabla_idiomas = tabla_idiomas & "<TH><FONT color=#333333>Idioma</FONT></TH>" %>
										<TH><FONT color=#333333>Nivel</FONT></TH><% tabla_idiomas = tabla_idiomas &  "<TH><FONT color=#333333>Nivel</FONT></TH>" %>
										<TH><FONT color=#333333>Habla</FONT></TH><% tabla_idiomas = tabla_idiomas &  "<TH><FONT color=#333333>Habla</FONT></TH>" %>
										<TH><FONT color=#333333>Lee</FONT></TH><% tabla_idiomas = tabla_idiomas   &  "<TH><FONT color=#333333>Lee</FONT></TH>" %>
										<TH><FONT color=#333333>Escribe</FONT></TH><% tabla_idiomas = tabla_idiomas & "<TH><FONT color=#333333>Escribe</FONT></TH>" %>
									</tr><% tabla_idiomas = tabla_idiomas & "</tr>" %>
									<%if f_muestra_idioma.nroFilas > 0 then
									   while f_muestra_idioma.siguiente
									     idioma1 = f_muestra_idioma.obtenerValor("idioma")
										 nivel1 = f_muestra_idioma.obtenerValor("nivel")
										 h1 = f_muestra_idioma.obtenerValor("habla")
										 lee1 = f_muestra_idioma.obtenerValor("lee")
										 escribe1 = f_muestra_idioma.obtenerValor("escribe")
									   %>
									     <tr borderColor="#999999" bgColor="#ffffff"><% tabla_idiomas = tabla_idiomas & "<tr borderColor='#999999' bgColor='#ffffff'>" %>
											<TD bgcolor="#FFFFFF"><%=idioma1%></TD><% tabla_idiomas = tabla_idiomas   & "<TD bgcolor='#FFFFFF'>"&idioma1&"</TD>" %>
											<TD bgcolor="#FFFFFF"><%=nivel1%></TD><% tabla_idiomas = tabla_idiomas    & "<TD bgcolor='#FFFFFF'>"&nivel1&"</TD>" %>
											<TD bgcolor="#FFFFFF" align="center"><%=habla1%></TD><% tabla_idiomas = tabla_idiomas    & "<TD bgcolor='#FFFFFF'>"&lee1&"</TD>" %>
											<TD bgcolor="#FFFFFF" align="center"><%=lee1%></TD><% tabla_idiomas = tabla_idiomas & "<TD bgcolor='#FFFFFF' align='center'>"&lee1&"</TD>" %>
											<TD bgcolor="#FFFFFF" align="center"><%=escribe1%></TD><% tabla_idiomas = tabla_idiomas & "<TD bgcolor='#FFFFFF' align='center'>"&escribe1&"</TD>" %>
										</tr><% tabla_idiomas = tabla_idiomas & "</tr>" %>
									   <%wend
									  else%>
                 					    <tr bgcolor="#FFFFFF"><td colspan="5" align="center">No existe información de conocimientos de idiomas registrados para el alumno</td></tr>
									    <% tabla_idiomas = tabla_idiomas & "<tr bgcolor='#FFFFFF'><td colspan='5' align='center'>No existe información de conocimientos de idiomas registrados para el alumno</td></tr>" %>
									  <%end if%>
								</table><% tabla_idiomas = tabla_idiomas & "</table>" %>							
							</td>
						  </tr>
						  <input type="hidden" name="tabla_idiomas" value="<%=tabla_idiomas%>">
						  <tr>
						  	<td colspan="3" align="right"><a href="#curriculum_sup"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_violeta_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3" id="f_software">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01t">&nbsp;</td>
					<td height="10" class="t02t">&nbsp;</td>
					<td width="10" height="10" class="t03t">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_violeta_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05t">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>DOMINIO DE SOFTWARE</strong></font></td>
						  </tr>
						  <tr>
							<td colspan="3">&nbsp;</td>
						  </tr>
						  <tr>
							<td colspan="3">
							    <%tabla_software = "" %>
								<table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
								<%tabla_software = tabla_software & "<table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>" %>
									<tr borderColor="#999999" bgColor="#c4d7ff"><%tabla_software = tabla_software & "<tr borderColor='#999999' bgColor='#c4d7ff'>" %>
										<TH><FONT color=#333333>Nombre del Software</FONT></TH><%tabla_software = tabla_software & "<TH><FONT color=#333333>Nombre del Software</FONT></TH>" %>
										<TH><FONT color=#333333>Nivel de conocimiento</FONT></TH><%tabla_software = tabla_software& "<TH><FONT color=#333333>Nivel de conocimiento</FONT></TH>" %>
									</tr><%tabla_software = tabla_software & "</tr>" %>
									<%if f_muestra_habilidades_programa.nroFilas > 0 then
									   while f_muestra_habilidades_programa.siguiente
									     software1 = f_muestra_habilidades_programa.obtenerValor("programa")
										 nivel1    = f_muestra_habilidades_programa.obtenerValor("nivel")
									   %>
									     <tr borderColor="#999999" bgColor="#ffffff"><%tabla_software = tabla_software & "<tr borderColor='#999999' bgColor='#ffffff'>" %>
											<TD bgcolor="#FFFFFF"><%=software1%></TD><%tabla_software = tabla_software & "  <TD bgcolor='#FFFFFF'>"&software1&"</TD>" %>
											<TD bgcolor="#FFFFFF"><%=nivel1%></TD><%tabla_software = tabla_software    & "  <TD bgcolor='#FFFFFF'>"&nivel1&"</TD>" %>
										 </tr><%tabla_software = tabla_software & "</tr>" %>
									   <%wend
									  else%>
                 					     <tr bgcolor="#FFFFFF"><td colspan="2" align="center">No existe información de dominio de software registrados para el alumno</td></tr>
									     <%tabla_software = tabla_software & "<tr bgcolor='#FFFFFF'><td colspan='2' align='center'>No existe información de dominio de software registrados para el alumno</td></tr>" %>
									  <%end if%>
								</table><%tabla_software = tabla_software & "</table>" %>							
							</td>
						  </tr>
						  <input type="hidden" name="tabla_software" value="<%=tabla_software%>">
						  <tr>
						  	<td colspan="3" align="right"><a href="#curriculum_sup"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_violeta_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3" id="f_habilidades">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01t">&nbsp;</td>
					<td height="10" class="t02t">&nbsp;</td>
					<td width="10" height="10" class="t03t">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_violeta_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05t">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>HABILIDADES</strong></font></td>
						  </tr>
						  <tr>
							<td colspan="3">&nbsp;
															
							</td>
						  </tr>
						  <tr>
							<td colspan="3">
								<table width="98%"  border="0" align="center">
                        			<tr>						
									  <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>HABILIDADES PROFESIONALES</strong></font></td>
									</tr>
									<tr>						
									  <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%f_habilidades.dibujaCampo("chal_thabilidades_profesionales")%></font></td>
									  <input type="hidden" name="profesionales" value="<%=f_habilidades.dibujaCampo("chal_thabilidades_profesionales")%>">
									</tr>
									<tr>						
									  <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>HABILIDADES TÉCNICAS</strong></font></td>
									</tr>
									<tr>						
									  <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%f_habilidades.dibujaCampo("chal_thabilidades_tecnica")%></font></td>
									  <input type="hidden" name="tecnicas" value="<%=f_habilidades.dibujaCampo("chal_thabilidades_tecnica")%>">
									</tr>
									<tr>						
									  <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>HABILIDADES PERSONALES</strong></font></td>
									</tr>
									<tr>						
									  <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%f_habilidades.dibujaCampo("chal_thabilidades_personales")%></font></td>
									  <input type="hidden" name="personales" value="<%=f_habilidades.dibujaCampo("chal_thabilidades_personales")%>">
									</tr>
									<tr>						
									  <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>AREAS EN LAS QUE DESEA TRABAJAR</strong></font></td>
									</tr>
									<tr>						
									  <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%f_habilidades.dibujaCampo("chal_tarea_trabajo")%></font></td>
									  <input type="hidden" name="laborales" value="<%=f_habilidades.dibujaCampo("chal_tarea_trabajo")%>">
									</tr>
									<tr>
										<td align="right"><a href="#curriculum_sup"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
   								    </tr>
								</table>
							</td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_violeta_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 </form>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
    </table>
  </div> 
  <div id="west4" class="x-layout-inactive-content">
      <table width="98%" align="center" cellpadding="0" cellspacing="0">
         <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01f">&nbsp;</td>
					<td height="10" class="t02f">&nbsp;</td>
					<td width="10" height="10" class="t03f">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_cafe_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05f">
					  <table width="100%" align="left" cellpadding="0" cellspacing="0">
						<tr>
							<td width="75%" align="left">
							  <table width="100%" cellpadding="0" cellspacing="0">
								  <tr>
									<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>HISTORIAL DE BLOQUEOS</strong></font></td>
								  </tr>
								  <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=rut%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nombre%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=carrera%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=estado%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Per&iacute;odo</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=periodo%></font></td>
								 </tr>
							  </table>
							</td>
							<td width="25%" align="center">
							  <table width="95%" cellpadding="0" cellspacing="0" border="0">
							  	 <tr>
								 	<td width="100%">
									 <div align="center" class="noprint">
									  <table width="100%" cellpadding="0" cellspacing="0">
									  	<tr>
											<td width="26" height="26"><a href="javascript:imprimir('west4','Historial de bloqueos');"><img width="26" height="26" src="images/btn_imprimir.png" border="0" title="Historial de bloqueos"></a></td>
											<td width="90%"><a href="javascript:imprimir('west4','Historial de bloqueos');" title="Historial de bloqueos">Imprimir</a></td>
										</tr>
										<tr>
											<td width="26" height="35"><a href="javascript:reporte_excel(10);"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte Excel"></a></td>
											<td width="90%"><a href="javascript:reporte_excel(10);">Excel</a></td>
										</tr>
									  </table>
									 </div>
									</td>
								 </tr>
							  </table>
							</td>
						</tr>
					</table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_cafe_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01f">&nbsp;</td>
					<td height="10" class="t02f">&nbsp;</td>
					<td width="10" height="10" class="t03f">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_cafe_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05f">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>HISTORIAL DE BLOQUEOS</strong></font></td>
						  </tr>
					      <tr>
							<td colspan="3">
							  <form name="bloqueos" action="bloqueos_excel.asp" method="post" target="_blank">
							   <input type="hidden" name="rut" value="<%=rut%>">
							   <input type="hidden" name="nombres" value="<%=nombre%>">
							   <input type="hidden" name="carrera" value="<%=carrera%>">
							   <input type="hidden" name="estado" value="<%=estado%>">
							   <input type="hidden" name="periodo" value="<%=periodo%>">
							   <input type="hidden" name="especialidad_plan" value="<%=especialidad_plan%>">
							  <%tabla_bloqueos = "" %>
							  <table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
							  <%tabla_bloqueos = tabla_bloqueos & "<table class='v1' width='98%' border='1' bordercolor='#999999' bgcolor='#adadad' cellspacing='0' cellpadding='0'>" %>
									<tr borderColor="#999999" bgColor="#c4d7ff"><%tabla_bloqueos = tabla_bloqueos & "<tr borderColor='#999999' bgColor='#c4d7ff'>" %>
										<TH><FONT color=#333333>Per&iacute;odo</FONT></TH><%tabla_bloqueos = tabla_bloqueos & "<TH><FONT color=#333333>Per&iacute;odo</FONT></TH>" %>
										<TH><FONT color=#333333>Sede</FONT></TH><%tabla_bloqueos = tabla_bloqueos & "<TH><FONT color=#333333>Sede</FONT></TH>" %>
										<TH><FONT color=#333333>Tipo</FONT></TH><%tabla_bloqueos = tabla_bloqueos & "<TH><FONT color=#333333>Tipo</FONT></TH>" %>
										<TH><FONT color=#333333>Estado</FONT></TH><%tabla_bloqueos = tabla_bloqueos & "<TH><FONT color=#333333>Estado</FONT></TH>" %>
										<TH><FONT color=#333333>Fecha Bloqueo</FONT></TH><%tabla_bloqueos = tabla_bloqueos & "<TH><FONT color=#333333>Fecha Bloqueo</FONT></TH>" %>
										<TH><FONT color=#333333>Fecha Desbloqueo</FONT></TH><%tabla_bloqueos = tabla_bloqueos & "<TH><FONT color=#333333>Fecha Desbloqueo</FONT></TH>" %>
										<TH><FONT color=#333333>Observación</FONT></TH><%tabla_bloqueos = tabla_bloqueos & "<TH><FONT color=#333333>Observación</FONT></TH>" %>
									</tr><%tabla_bloqueos = tabla_bloqueos & "</tr>" %>
									<%if f_bloqueos.nroFilas > 0 then
									   while f_bloqueos.siguiente
									     periodo7 = f_bloqueos.obtenerValor("periodo")
										 sede7 = f_bloqueos.obtenerValor("sede")
										 tipo7 = f_bloqueos.obtenerValor("tipo")
										 estado7 = f_bloqueos.obtenerValor("estado")
										 fecha_bloqueo7 = f_bloqueos.obtenerValor("fecha_bloqueo")
										 fecha_desbloqueo7 = f_bloqueos.obtenerValor("fecha_desbloqueo")
										 observacion7 = f_bloqueos.obtenerValor("observacion")
									   %>
									     <tr borderColor="#999999" bgColor="#ffffff"><%tabla_bloqueos = tabla_bloqueos & "<tr borderColor='#999999' bgColor='#ffffff'>" %>
											<TD bgcolor="#FFFFFF"><%=periodo7%></TD><%tabla_bloqueos = tabla_bloqueos & "<TD bgcolor='#FFFFFF'>"&periodo7&"</TD>" %>
											<TD bgcolor="#FFFFFF"><%=sede7%></TD><%tabla_bloqueos = tabla_bloqueos & "<TD bgcolor='#FFFFFF'>"&sede7&"</TD>" %>
											<TD bgcolor="#FFFFFF"><%=tipo7%></TD><%tabla_bloqueos = tabla_bloqueos & "<TD bgcolor='#FFFFFF'>"&tipo7&"</TD>" %>
											<TD bgcolor="#FFFFFF"><%=estado7%></TD><%tabla_bloqueos = tabla_bloqueos & "<TD bgcolor='#FFFFFF'>"&estado7&"</TD>" %>
											<TD bgcolor="#FFFFFF"><%=fecha_bloqueo7%></TD><%tabla_bloqueos = tabla_bloqueos & "<TD bgcolor='#FFFFFF'>"&fecha_bloqueo7&"</TD>" %>
											<TD bgcolor="#FFFFFF"><%=fecha_desbloqueo7%></TD><%tabla_bloqueos = tabla_bloqueos & "<TD bgcolor='#FFFFFF'>"&fecha_desbloqueo7&"</TD>" %>
											<TD bgcolor="#FFFFFF"><%=observacion7%></TD><%tabla_bloqueos = tabla_bloqueos & "<TD bgcolor='#FFFFFF'>"&observacion7&"</TD>" %>
										</tr><%tabla_bloqueos = tabla_bloqueos & "</tr>" %>
									   <%wend
									  else%>
                 					    <tr bgcolor="#FFFFFF"><td colspan="7" align="center">No existe información de bloqueos registrados para el alumno</td></tr>
										<%tabla_bloqueos = tabla_bloqueos & "<tr bgcolor='#FFFFFF'><td colspan='7' align='center'>No existe información de bloqueos registrados para el alumno</td></tr>" %>
									  <%end if%>
								</table><%tabla_bloqueos = tabla_bloqueos & "</table>" %>
								   <input type="hidden" name="tabla_bloqueos" value="<%=tabla_bloqueos%>">
								</form>
							</td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_cafe_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" height="300">&nbsp;</td>
		 </tr>
      </table>
  </div>
	 
  
  <div id="north" class="x-layout-inactive-content">
    <table width="100%" height="100%" cellpadding="0" cellspacing="0" align="left" background="images/fondo_enc_pie.jpg">
		<tr valign="top">
			<td width="150" height="50" align="left"><img width="150" height="50" src="../imagenes/logo_upa_rojo_2011.png"></td>
			<td width="20" height="50" align="left">&nbsp;</td>
			<td align="left">
			    <form name="buscador">
					<table width="100%" cellpadding="0" cellspacing="0">
					  <tr>
                        <td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>R.U.T. Alumno </strong></font></td>
                        <td width="2%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
                        <td width="22%"><%f_busqueda.DIbujaCampo("pers_nrut")%> - <%f_busqueda.DibujaCampo("pers_xdv")%></td>
						<td align="left">&nbsp;</td>
                      </tr>
					  <tr>
                        <td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong><strong>Periodo</strong></font></td>
                        <td width="2%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong><strong>:</strong></font></td>
                        <td width="22%"><%f_busqueda.DIbujaCampo("peri_ccod")%></td>
						<td align="left"><!--<input type="submit" value="Buscar" class="boton" title="Buscar Alumno por período">-->
						    <table width="16%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="26" height="26"><a href="javascript:document.buscador.submit();" title="buscar datos para el alumno o período"><img width="26" height="26" src="images/btn_buscar.png" border="1"></a></td>
									<td align="left"><a href="javascript:document.buscador.submit();" title="buscar datos para el alumno o período">Buscar</a></td>
								</tr>
							</table>
						</td>
                      </tr>
					</table>
				</form>
			</td>
		</tr>
	</table> 
  </div>
  <div id="autoTabs" class="x-layout-inactive-content">
      <table width="100%" cellpadding="0" cellspacing="0" background="images/fondo.jpg">
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td colspan="3" align="center">
			<table width="270" border="0" cellspacing="0" cellpadding="0" align="left">
			  <tr>
				<td width="10" height="10" class="t01v">&nbsp;</td>
				<td height="10" class="t02v">&nbsp;</td>
				<td width="10" height="10" class="t03v">&nbsp;</td>
			  </tr>
			  <tr>
				<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_verde_04.jpg" width="10" height="98" /></td>
				<td align="left" valign="top" class="t05v">
				  <table width="100%" align="left" cellpadding="0" cellspacing="0">
				    <tr valign="top">
						<td colspan="3" align="center"><img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=nombre_foto%>" border="2"></td>
					</tr>
					<tr>
						<td colspan="3" align="center">&nbsp;</td>
					</tr>
					<tr>
						<td width="17%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>R.U.T</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="80%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=rut%></font></td>
					</tr>
					<tr>
						<td width="17%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="80%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nombre%></font></td>
					</tr>
					<tr>
						<td width="17%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Sexo</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="80%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=sexo%></font></td>
					</tr>
					<tr>
						<td width="17%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Pa&iacute;s</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="80%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=pais%></font></td>
					</tr>
					<tr>
						<td width="17%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Direcci&oacute;n</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="80%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=direccion%></font></td>
					</tr>
					<tr>
						<td width="17%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Comuna</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="80%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=comuna%></font></td>
					</tr>
					<tr>
						<td width="17%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Tel&eacute;fono</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="80%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=fono%></font></td>
					</tr>
					<tr>
						<td width="17%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Celular</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="80%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=celular%></font></td>
					</tr>
					<tr>
						<td width="17%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Email 1</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="80%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><a href="mailto:<%=email_u%>?subject=Mensaje escuela&body=Estimado(a) Alumno(a):%0D%0A %0D%0A"><%=email_u%></a></font></td>
					</tr>
					<tr>
						<td width="17%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Email 2</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="80%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=email_p%></font></td>
					</tr>
				  </table>
				</td>
				<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_verde_06.jpg" width="10" height="98" /></td>
			  </tr>
			  <tr>
				<td width="10" height="17" class="t07">&nbsp;</td>
				<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
				<td width="10" height="17" class="t09">&nbsp;</td>
			  </tr>
			</table>
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
			<table width="270" border="0" cellspacing="0" cellpadding="0" align="left">
			  <tr>
				<td width="10" height="10" class="t01v">&nbsp;</td>
				<td height="10" class="t02v">&nbsp;</td>
				<td width="10" height="10" class="t03v">&nbsp;</td>
			  </tr>
			  <tr>
				<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_verde_04.jpg" width="10" height="98" /></td>
				<td align="left" valign="top" class="t05v">
				  <table width="100%" align="left" cellpadding="0" cellspacing="0">
				    <tr>
						<td colspan="3" align="left"><%=mensaje_cae%></td>
					</tr>
					<tr>
						<td width="27%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Ingreso Carrera</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="70%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=ano_ingreso_carrera%></font></td>
					</tr>
					<tr>
						<td colspan="3" align="left"><hr color="#999999"></td>
					</tr>
					<tr>
						<td width="27%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Moroso</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="70%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=es_moroso%></font></td>
					</tr>
					<tr>
						<td colspan="3" align="left"><hr color="#999999"></td>
					</tr>
					<tr>
						<td width="27%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nivel Base</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="70%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nivel_base%></font></td>
					</tr>
					<tr>
						<td colspan="3" align="left"><hr color="#999999"></td>
					</tr>
					<tr>
						<td width="27%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nivel Superior</strong></font></td>
						<td width="3%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
						<td width="70%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nivel_superior%></font></td>
					</tr>
				  </table>
			   </td>
				<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_verde_06.jpg" width="10" height="98" /></td>
			  </tr>
			  <tr>
				<td width="10" height="17" class="t07">&nbsp;</td>
				<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
				<td width="10" height="17" class="t09">&nbsp;</td>
			  </tr>
			</table>
			</td>
		</tr>
	</table>
  </div>
  <div id="center2" class="x-layout-inactive-content">
       <table width="98%" align="center" cellpadding="0" cellspacing="0">
	     <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01a">&nbsp;</td>
					<td height="10" class="t02a">&nbsp;</td>
					<td width="10" height="10" class="t03a">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_amarillo_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05a">
					  <table width="100%" align="left" cellpadding="0" cellspacing="0">
						<tr>
							<td width="75%" align="left">
							  <table width="100%" cellpadding="0" cellspacing="0">
								  <tr>
									<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>AVANCE ACADEMICO ALUMNO(A)</strong></font></td>
								  </tr>
								  <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=rut%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nombre%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=carrera%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=estado%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Per&iacute;odo</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=periodo%></font></td>
								 </tr>
							  </table>
							</td>
							<td width="25%" align="center">
							  <table width="95%" cellpadding="0" cellspacing="0" border="0">
							  	 <tr>
								 	<td width="100%">
									<div align="center" class="noprint">
									  <table width="100%" cellpadding="0" cellspacing="0">
									  	<tr>
											<td width="26" height="26"><a href="javascript:imprimir('center2','Avance Academico');"><img width="26" height="26" src="images/btn_imprimir.png" border="0" title="Imprimir avance académico"></a></td>
											<td width="40%"><a href="javascript:imprimir('center2','malla curricular');" title="Imprimir avance académico" >Imprimir</a></td>
											<%if datos_plan.nroFilas > 0 then%>
											<td width="26" height="26"><a href="javascript:reporte_excel(1);"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte Excel"></a></td>
											<td width="40%"><a href="javascript:reporte_excel(1);">Excel</a></td>
											<%else%>
											<td width="26" height="26"><a href="javascript:alert('No existe información del avance académico del alumno');"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte Excel"></a></td>
											<td width="40%"><a href="javascript:alert('No existe información del avance académico del alumno');">Excel</a></td>
											<%end if%>
										</tr>
									  </table>
									 </div>
									</td>
								 </tr>
							  </table>
							</td>
						</tr>
					</table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_amarillo_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <%if datos_plan.nroFilas > 0 then%>
		 <tr>
			<td colspan="3" align="left">
              <form name="avance_academico" action="avance_academico_excel.asp" method="post" target="_blank">
			   <input type="hidden" name="rut" value="<%=rut%>">
			   <input type="hidden" name="nombres" value="<%=nombre%>">
			   <input type="hidden" name="carrera" value="<%=carrera%>">
			   <input type="hidden" name="estado" value="<%=estado%>">
		 	   <input type="hidden" name="periodo" value="<%=periodo%>">
			   <input type="hidden" name="especialidad_plan" value="<%=especialidad_plan%>">
			    <table width="98%" border="0" cellspacing="0" cellpadding="0" id="avance">
				  <tr>
					<td width="10" height="10" class="t01a">&nbsp;</td>
					<td height="10" class="t02a">&nbsp;</td>
					<td width="10" height="10" class="t03a">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_amarillo_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05a">
					<table width="98%">
					    <tr> 
							<td height="20"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Avance acad&eacute;mico por nivel de estudios</strong></font></td>
						</tr>
						<tr> 
							<td><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>&nbsp;</strong></font></td>
						</tr>
						<tr> 
							<td align="center"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong><%=especialidad_plan%></strong></font></td>
						</tr>
				     </table>
					  <table width="100%" cellpadding="0" cellspacing="0">
						 <% datos_plan.primero
							datos_plan.siguiente
							nivel = datos_plan.obtenerValor("nive_ccod")
							datos_plan.primero%>
						 <tr>
							<td colspan="3">
							  <table width="98%" cellpadding="2" cellspacing="2" border="1" bordercolor="#999999">
							  <tr>
								<td width="100%">
								  <table width="100%" cellpadding="0" cellspacing="0">
													   <tr>
															<td colspan="4" align="center" bgcolor="#feb528"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>NIVEL <%=nivel%></strong></font></td>
													   </tr>
													   <tr>
															<td width="3%" align="center" bgcolor="#feb528"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>&nbsp;</strong></font></td>
															<td width="6%" align="center" bgcolor="#feb528"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>NIVEL</strong></font></td>
															<td width="77%" align="left" bgcolor="#feb528"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>ASIGNATURA</strong></font></td>
															<td width="14%" align="center" bgcolor="#feb528"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>ESTADO</strong></font></td>
															<input type="hidden" name="color_1" value="#feb528">
															<input type="hidden" name="avance_1_1" value="NIVEL">
															<input type="hidden" name="avance_1_2" value="ASIGNATURA">
															<input type="hidden" name="avance_1_3" value="ESTADO">															
													   </tr>
													   <% fila = 1
													     while datos_plan.siguiente
															nivel_actual = datos_plan.obtenerValor("nive_ccod")
															asignatura = datos_plan.obtenerValor("asignatura")
															aprobado = datos_plan.obtenerValor("aprobado")
															color = "images/pelota_roja.gif"
															if aprobado = "" then
																color= "images/pelota_roja.gif"
																color_cuadro = "#EEECEC"
															elseif aprobado = "CA" then
																aprobado=periodo_mostrar
																color= "images/pelota_amarilla.gif"
																color_cuadro = "#fbe19b"
															else
																color= "images/pelota_verde.gif"
																color_cuadro = "#bff8be"
															end if
														 if cint(nivel) = cint(nivel_actual) then 	
													   %>
													   <tr>
															<td width="3%" align="center" bgcolor="#ffffff"><img width="8" height="8" src="<%=color%>"></td>
															<td width="6%" align="center" bgcolor="#ffffff"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=nivel_actual%></font></td>
															<td width="77%" align="left" bgcolor="#ffffff"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=asignatura%></font></td>
															<td width="14%" align="center" bgcolor="#ffffff"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=aprobado%></font></td>
													        <%fila = fila + 1%>
															<input type="hidden" name="color_<%=fila%>" value="<%=color_cuadro%>">
															<input type="hidden" name="avance_<%=fila%>_1" value="<%=nivel_actual%>">
															<input type="hidden" name="avance_<%=fila%>_2" value="<%=asignatura%>">
															<input type="hidden" name="avance_<%=fila%>_3" value="<%=aprobado%>">
													   </tr>
													   <%else
														   nivel = nivel_actual
														   datos_plan.anterior%>
														   </table>
														   </td>
														  </tr>
														  </table>
														  </td>
														</tr>
														<tr>
															<td colspan="3">&nbsp;</td>
														</tr>
														<tr>
															<td colspan="3">
															  <table width="98%" cellpadding="2" cellspacing="2" border="1" bordercolor="#999999">
															  <tr>
																<td width="100%">
																<table width="100%" cellpadding="0" cellspacing="0">
																   <tr>
																		<td colspan="4" align="center" bgcolor="#feb528"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>NIVEL <%=nivel%></strong></font></td>
																   </tr>
																   <tr>
																		<td width="3%" align="center" bgcolor="#feb528"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>&nbsp;</strong></font></td>
																		<td width="6%" align="center" bgcolor="#feb528"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>NIVEL</strong></font></td>
																		<td width="77%" align="left" bgcolor="#feb528"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>ASIGNATURA</strong></font></td>
																		<td width="14%" align="center" bgcolor="#feb528"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>ESTADO</strong></font></td>
																   </tr>
													   <%end if%>
													   <%wend
													   %>
													   <input type="hidden" name="total_filas" value="<%=fila%>">
													</table>
													</td>
												</tr>
											  </table>
							</td>
						 </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_amarillo_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			  </form>
			</td>
		 </tr>
		 <%end if 'cuando no retorna registros%>
	  </table>
  </div>
  <div id="center1" class="x-layout-inactive-content">
  <table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
         <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01">&nbsp;</td>
					<td height="10" class="t02">&nbsp;</td>
					<td width="10" height="10" class="t03">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_naranja_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05">
					<table width="100%" align="left" cellpadding="0" cellspacing="0">
						<tr>
							<td width="75%" align="left">
							  <table width="100%" cellpadding="0" cellspacing="0">
								  <tr>
									<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>MALLA CURRICULAR ALUMNO(A)</strong></font></td>
								  </tr>
								  <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=rut%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nombre%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=carrera%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=estado%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Per&iacute;odo</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=periodo%></font></td>
								 </tr>
							  </table>
							</td>
							<td width="25%" align="center">
							  <table width="95%" cellpadding="0" cellspacing="0" border="0">
							  	 <tr>
								 	<td width="100%">
									 <div align="center" class="noprint">
									  <table width="100%" cellpadding="0" cellspacing="0">
									  	<tr>
											<td width="26" height="26"><a href="javascript:imprimir('center1','malla curricular');"><img width="26" height="26" src="images/btn_imprimir.png" border="0" title="Imprimir malla curricular"></a></td>
											<td width="40%"><a href="javascript:imprimir('center1','malla curricular');" title="Imprimir malla curricular">Imprimir</a></td>
											<%if datos_plan.nroFilas > 0 then%>
											<td width="26" height="26"><a href="javascript:reporte_excel(2);"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte Excel"></a></td>
											<td width="40%"><a href="javascript:reporte_excel(2);">Excel</a></td>
											<%else%>
											<td width="26" height="26"><a href="javascript:alert('No existe información de Malla Curricular de alumnos');"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte Excel"></a></td>
											<td width="40%"><a href="javascript:alert('No existe información de Malla Curricular de alumnos');">Excel</a></td>
											<%end if%>
										</tr>
									  </table>
									 </div>
									</td>
								 </tr>
							  </table>
							</td>
						</tr>
					</table>
					  
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_naranja_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <%if datos_plan.nroFilas > 0 then%>
		 <tr>
			<td colspan="3" align="left">
			    <form name="malla_curricular" action="malla_curricular_excel.asp" method="post" target="_blank">
			      <input type="hidden" name="rut" value="<%=rut%>">
				  <input type="hidden" name="nombres" value="<%=nombre%>">
				  <input type="hidden" name="carrera" value="<%=carrera%>">
				  <input type="hidden" name="estado" value="<%=estado%>">
				  <input type="hidden" name="periodo" value="<%=periodo%>">
				  <input type="hidden" name="especialidad_plan" value="<%=especialidad_plan%>">
			    
			    <table width="98%" border="0" cellspacing="0" cellpadding="0" id="mallita">
				  <tr>
					<td width="10" height="10" class="t01">&nbsp;</td>
					<td height="10" class="t02">&nbsp;</td>
					<td width="10" height="10" class="t03">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_naranja_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05">
					   <table width="98%">
						<tr> 
							<td height="20"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Malla Curricular del alumno</strong></font></td>
						</tr>
						<tr> 
							<td><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>&nbsp;</strong></font></td>
						</tr>
						<tr> 
							<td align="center"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong><%=especialidad_plan%></strong></font></td>
						</tr>
					   </table>
					  <table width="100%" cellpadding="0" cellspacing="0">
						<%  datos_plan.primero
							datos_plan.siguiente
							nivel = datos_plan.obtenerValor("nive_ccod")
							datos_plan.primero%>
						 <tr>
							<td colspan="3" align="center">
							
							<table width="98%" align="center" cellpadding="2" cellspacing="2">
							<tr>
							  <td width="100%" align="center"><br>
								<table width="95%" cellpadding="0" cellspacing="0">
									<tr>
										<td bgcolor="#d1e3fa" bordercolor="#0033CC" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nivel<br><%=nivel%></strong></font></td>
										  <input type="hidden" name="malla_0_1" value="Nivel <%=nivel%>">
										  <input type="hidden" name="color_0_1" value="#d1e3fa">
										<td width="20">&nbsp;</td>
										  <input type="hidden" name="malla_0_2" value="">
										  <input type="hidden" name="color_0_2" value="#ffffff">
										<%total_columnas = 2
										 while datos_plan.siguiente
											 nivel_paso = datos_plan.obtenerValor("nive_ccod")
											 if cint(nivel) <> cint(nivel_paso) then
												nivel = nivel_paso
												response.write("<td bgcolor='#d1e3fa' bordercolor='#0033CC' align='center'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'><strong>Nivel<br>"&nivel&"</strong></font></td><td width='20'>&nbsp;</td>")		
												%>
											    <input type="hidden" name="malla_0_<%=total_columnas + 1%>" value="Nivel <%=nivel%>">
										        <input type="hidden" name="color_0_<%=total_columnas + 1%>" value="#d1e3fa">
												<input type="hidden" name="malla_0_<%=total_columnas + 2%>" value="">
										        <input type="hidden" name="color_0_<%=total_columnas + 2%>" value="#ffffff">
												<%
												total_columnas = total_columnas + 2
											 end if
										 wend
										 
										 datos_plan.primero%>
									</tr>
									<tr>
										<td colspan="<%=total_columnas%>">&nbsp;</td>
									</tr>
									
									<input type="hidden" name="total_columnas" value="<%=total_columnas%>">
									
									<%datos_plan.siguiente
									  nivel = datos_plan.obtenerValor("nive_ccod")
									  datos_plan.primero
									  fila_malla = 1 
									  columna_malla = 1 
									  total_filas = 1%>
									<tr valign="top">
									   <td align="center">
									   	  <%while datos_plan.siguiente
												nivel_paso = datos_plan.obtenerValor("nive_ccod")
												asig_ccod = datos_plan.obtenerValor("asig_ccod")
												asignatura = datos_plan.obtenerValor("asignatura")
												aprobado = datos_plan.obtenerValor("aprobado")
												color_cuadro = "#ffffff"
												imagen_estado = "images/gris.png"
												if aprobado = "CA" then
													color_cuadro = "#fbe19b"
													imagen_estado = "images/naranjo.png"
												elseif aprobado <> "CA" and aprobado <> "" then
													color_cuadro = "#bff8be"
													imagen_estado = "images/verde.png"
												elseif aprobado = "" then
													color_cuadro = "#EEECEC"
													imagen_estado = "images/gris.png"
												end if
												
												if cint(nivel) <> cint(nivel_paso) then
												   nivel = nivel_paso
												    if fila_malla > total_filas then
														total_filas = fila_malla
													end if
												   fila_malla = 1
												   columna_malla = columna_malla + 2
												   response.write("</td>")
												   response.write("<td width='20'>&nbsp;</td>")
												   response.write("<td align='center'>")
												   response.write("<table width='100%' cellpadding='0' cellspacing='0' >")
												   response.write("<tr>")
												   response.Write(" <td width='15' height='18'><img width='15' height='18' src='"+imagen_estado+"'></td>")
												   response.write(" <td width='98%' bgcolor='"+color_cuadro+"'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'>"+asig_ccod+"<br>"+asignatura+"</font></td>")
												   fila_malla  = fila_malla  + 1%>
												   <input type="hidden" name="malla_<%=fila_malla%>_<%=columna_malla%>" value="<%=asig_ccod+"<br>"+asignatura%>">
										           <input type="hidden" name="color_<%=fila_malla%>_<%=columna_malla%>" value="<%=color_cuadro%>">
												   <%
												   response.write("</tr>")
												   response.write("<tr>")
												   response.write(" <td colspan='2'>&nbsp;</td>")
												   fila_malla  = fila_malla  + 1%>
												   <input type="hidden" name="malla_<%=fila_malla%>_<%=columna_malla%>" value="">
												   <input type="hidden" name="color_<%=fila_malla%>_<%=columna_malla%>" value="#FFFFFF">
												  <%
												   response.write("</tr>")
												   response.write("</table>")		
												else
												   response.write("<table width='100%' cellpadding='0' cellspacing='0' >")
												   response.write("<tr>")
												   response.Write(" <td width='15' height='18'><img width='15' height='18' src='"+imagen_estado+"'></td>")
												   response.write(" <td width='100%' bgcolor='"+color_cuadro+"'><font face='Times New Roman, Times, serif' size='1' color='#085fbc'>"+asig_ccod+"<br>"+asignatura+"</font></td>")
												   fila_malla  = fila_malla  + 1%>
												   <input type="hidden" name="malla_<%=fila_malla%>_<%=columna_malla%>" value="<%=asig_ccod+"<br>"+asignatura%>">
										           <input type="hidden" name="color_<%=fila_malla%>_<%=columna_malla%>" value="<%=color_cuadro%>">
												   <%
												   response.write("</tr>")
												   response.write("<tr>")
												   response.write(" <td  colspan='2'>&nbsp;</td>")
												   fila_malla  = fila_malla  + 1%>
												   <input type="hidden" name="malla_<%=fila_malla%>_<%=columna_malla%>" value="">
												   <input type="hidden" name="color_<%=fila_malla%>_<%=columna_malla%>" value="#FFFFFF">
												  <%
												   response.write("</tr>")
												   response.write("</table>")
												end if
											wend
										 datos_plan.primero%>		
									   </td>
									   <td width="20">&nbsp;</td>
									   <input type="hidden" name="total_filas" value="<%=total_filas%>">
									</tr>
								</table>
							   </td>
							  </tr>
							  <tr>
							  	<td width="100%" align="right">
									<table width="50%">
										<tr>
											<td width="18" height="18"><img width="15" height="18" src="images/verde.png"></td>
											<td width="30%" height="18" align="left"><font face='Times New Roman, Times, serif' size='1' color='#085fbc'>:Asignatura Aprobada</font></td>
											<td width="18" height="18"><img width="15" height="18" src="images/naranjo.png"></td>
											<td width="30%" height="18" align="left"><font face='Times New Roman, Times, serif' size='1' color='#085fbc'>:Asignatura en curso</font></td>
										    <td width="18" height="18"><img width="15" height="18" src="images/gris.png"></td>
											<td width="30%" height="18" align="left"><font face='Times New Roman, Times, serif' size='1' color='#085fbc'>:Asignatura sin cursar</font></td>
										</tr>
									</table>
								</td>
							  </tr>
							</table>
						   </td>
						 </tr>		 
					  
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_naranja_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			 </form>
			</td>
		 </tr>
		 <%end if'para cuando tiene registros%>
		  
  </table>
  </div>
  <div id="center3" class="x-layout-inactive-content">
  <table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
         <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01c">&nbsp;</td>
					<td height="10" class="t02c">&nbsp;</td>
					<td width="10" height="10" class="t03c">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_celeste_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05c">
					  <table width="100%" align="left" cellpadding="0" cellspacing="0" id="horario" >
						<tr>
							<td width="75%" align="left">
							  <table width="100%" cellpadding="0" cellspacing="0">
								  <tr>
									<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>CARGA ACADEMICA DEL PERIODO</strong></font></td>
								  </tr>
								  <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=rut%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nombre%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=carrera%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=estado%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Per&iacute;odo</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=periodo%></font></td>
								 </tr>
							  </table>
							</td>
							<td width="25%" align="center">
							  <table width="95%" cellpadding="0" cellspacing="0" border="0">
							  	 <tr>
								 	<td width="100%">
									 <div align="center" class="noprint">
									  <table width="100%" cellpadding="0" cellspacing="0">
									  	<tr>
											<td width="26" height="26"><a href="javascript:imprimir('center3','carga academica');"><img width="26" height="26" src="images/btn_imprimir.png" border="0" title="Imprimir carga académica"></a></td>
											<td width="40%"><a href="javascript:imprimir('center3','carga academica');" title="Imprimir carga académica">Imprimir</a></td>
											<%if f_alumno.nroFilas > 0 then %>
											<td width="26" height="26"><a href="javascript:reporte_excel(3);"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte Excel"></a></td>
											<td width="40%"><a href="javascript:reporte_excel(3);">Excel</a></td>
											<%else%>
											<td width="26" height="26"><a href="javascript:alert('No existe información de carga académica registrada en el período consultado');"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte Excel"></a></td>
											<td width="40%"><a href="javascript:alert('No existe información de carga académica registrada en el período consultado');">Excel</a></td>
											<%end if%>																					
										</tr>
									  </table>
									 </div>
									</td>
								 </tr>
							  </table>
							</td>
						</tr>
					</table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_celeste_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <%if f_alumno.nroFilas > 0 then %>
		 <form name="carga_academica" action="carga_academica_excel.asp" method="post" target="_blank">
		     <input type="hidden" name="rut" value="<%=rut%>">
		     <input type="hidden" name="nombres" value="<%=nombre%>">
			 <input type="hidden" name="carrera" value="<%=carrera%>">
			 <input type="hidden" name="estado" value="<%=estado%>">
			 <input type="hidden" name="periodo" value="<%=periodo%>">
			 <input type="hidden" name="especialidad_plan" value="<%=especialidad_plan%>">
		 <tr>
			<td colspan="3">
			   <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01c">&nbsp;</td>
					<td height="10" class="t02c">&nbsp;</td>
					<td width="10" height="10" class="t03c">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_celeste_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05c">
					 <table width="98%">
					    <tr> 
							<td height="20"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Listado de Cargas del per&iacute;odo</strong></font></td>
						</tr>
						<tr> 
							<td height="20"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>&nbsp;</strong></font></td>
						</tr>
					  </table>
					  <table width="98%" cellpadding="2" cellspacing="2" border="1" bordercolor="#999999">
						<tr>
							<td width="100%" align="center">
								<table width="100%" cellspacing="0">
									<tr>
										<th bgcolor="#d1e3fa"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>C&oacute;digo</strong></font></th>
										<th bgcolor="#d1e3fa"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Asignatura</strong></font></th>
										<th bgcolor="#d1e3fa"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Secci&oacute;n</strong></font></th>
										<th bgcolor="#d1e3fa"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Tipo</strong></font></th>
										<th bgcolor="#d1e3fa"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Cr&eacute;ditos</strong></font></th>
									</tr>
								<% fila_carga = 1
								  while f_alumno.siguiente
									 asig_ccod = f_alumno.obtenerValor("cod_asignatura")
									 asignatura = f_alumno.obtenerValor("asignatura")
									 seccion = f_alumno.obtenerValor("seccion")
									 tipo = f_alumno.obtenerValor("tipo")
									 creditos = f_alumno.obtenerValor("creditos")%>
									<tr>
										<td><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=asig_ccod%></font></td>
										<td><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=asignatura%></font></td>
										<td><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=seccion%></font></td>
										<td><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=tipo%></font></td>
										<td><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=creditos%></font></td>
										<input type="hidden" name="carga_<%=fila_carga%>_1" value="<%=asig_ccod%>">
										<input type="hidden" name="carga_<%=fila_carga%>_2" value="<%=asignatura%>">
										<input type="hidden" name="carga_<%=fila_carga%>_3" value="<%=seccion%>">
										<input type="hidden" name="carga_<%=fila_carga%>_4" value="<%=tipo%>">
										<input type="hidden" name="carga_<%=fila_carga%>_5" value="<%=creditos%>">										
									</tr>
								 <%fila_carga = fila_carga + 1
								   wend
								   %>
								   <input type="hidden" name="total_fila_carga" value="<%=fila_carga%>">
							   </table>
							 </td>
						  </tr>
					   </table> 
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_celeste_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			
			</td>
		 </tr>
		 <tr>
		 	<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
		 	<td colspan="3">
			   <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01c">&nbsp;</td>
					<td height="10" class="t02c">&nbsp;</td>
					<td width="10" height="10" class="t03c">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_celeste_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05c">
					   <table width="100%" cellpadding="0" cellspacing="0">
						 <tr>
							<td colspan="3"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Horario de clases</strong></font></td>
						 </tr>
						 <tr>
							<td colspan="3">&nbsp;</td>
						 </tr>
						 <tr>
							<td colspan="3" align="center">
							  <%
								 response.write("<table width='98%' border='1' bordercolor='#999999' bgcolor='#FFFFFF' cellspacing='2' cellpadding='2'>")
								 contador1 = 0
								     while ( contador1 <= total_sede)
									  contador2 = 0
									  response.write("<tr>")
													while ( contador2 <=6 )
													  valor_muestra = arreglo(contador1,contador2)
													  color_celda = "#ffffff"
													  alineacion = "left"
													  if contador1 = 0 then
														color_celda = "#d1e3fa"
														alineacion = "center"
													  end if
													  'color  = $colores_horario[$contador1][$contador2];
													  response.write("		<td  align='"+alineacion+"' bgcolor='"+color_celda+"'><font face='Times New Roman, Times, serif' size='2' color='#085fbc'>"&valor_muestra&"</font></td>")
													  %>
													    <input type="hidden" name="horario_<%=contador1%>_<%=contador2%>" value="<%=valor_muestra%>">
													  <%contador2 = contador2 +1
													wend
													contador1 = contador1 + 1
									  response.write("</tr>")
									wend
									response.write("</table>")
							   %>
							   <br>
							   <input type="hidden" name="total_sede" value="<%=total_sede%>">
							</td>
						 </tr>
					   </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_celeste_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>			
			</td>
		 </tr>
		 </form>
		 <%else%>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01c">&nbsp;</td>
					<td height="10" class="t02c">&nbsp;</td>
					<td width="10" height="10" class="t03c">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_celeste_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05c">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="center"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong><br><br>NO EXITE INFORMACI&Oacute;N DE CARGA ACAD&Eacute;MICA REGISTRADA EN EL PER&Iacute;ODO</strong></font></td>
						  </tr>
		      		  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_celeste_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" height="300">&nbsp;</td>
		 </tr>
		 <%end if'para cuando retorna registros%>
		 <tr>
		 	<td colspan="3">&nbsp;</td>
		 </tr>
		 
  </table>
  </div>
  <div id="center4" class="x-layout-inactive-content">
  <table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
         <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01i">&nbsp;</td>
					<td height="10" class="t02i">&nbsp;</td>
					<td width="10" height="10" class="t03i">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_calipso_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05i">
					  <table width="100%" align="left" cellpadding="0" cellspacing="0" id="horario" >
						<tr>
							<td width="75%" align="left">
							  <table width="100%" cellpadding="0" cellspacing="0">
								  <tr>
									<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>EVALUACI&Oacute;N DOCENTE</strong></font></td>
								  </tr>
								  <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=rut%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nombre%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=carrera%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=estado%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Per&iacute;odo</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=periodo%></font></td>
								 </tr>
							  </table>
							</td>
							<td width="25%" align="center">
							  <table width="95%" cellpadding="0" cellspacing="0" border="0">
							  	 <tr>
								 	<td width="100%">
									 <div align="center" class="noprint">
									  <table width="100%" cellpadding="0" cellspacing="0">
									  	<tr>
											<td width="26" height="26"><a href="javascript:imprimir('center4','evaluacion docente');"><img width="26" height="26" src="images/btn_imprimir.png" border="0" title="Imprimir Ev. Docente"></a></td>
											<td width="40%"><a href="javascript:imprimir('center4','evaluacion docente');" title="Imprimir Ev. docente">Imprimir</a></td>
											<%if f_ramos.nroFilas > 0 then%>
											<td width="26" height="26"><a href="javascript:reporte_excel(4);"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte Excel"></a></td>
											<td width="40%"><a href="javascript:reporte_excel(4);">Excel</a></td>
											<%else%>
											<td width="26" height="26"><a href="javascript:alert('No existe información de evaluación docente para el alumno');"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte Excel"></a></td>
											<td width="40%"><a href="javascript:alert('No existe información de evaluación docente para el alumno');">Excel</a></td>
											<%end if%>
										</tr>
									  </table>
									 </div>
									</td>
								 </tr>
							  </table>
							</td>
						</tr>
					</table>					  
					  
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_calipso_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <%if f_ramos.nroFilas > 0 then%>
		 <form name="ev_docente" action="ev_docente_excel.asp" method="post" target="_blank">
		     <input type="hidden" name="rut" value="<%=rut%>">
		     <input type="hidden" name="nombres" value="<%=nombre%>">
			 <input type="hidden" name="carrera" value="<%=carrera%>">
			 <input type="hidden" name="estado" value="<%=estado%>">
			 <input type="hidden" name="periodo" value="<%=periodo%>">
			 <input type="hidden" name="especialidad_plan" value="<%=especialidad_plan%>">
		 <tr>
			<td colspan="3" align="left">
				<table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01i">&nbsp;</td>
					<td height="10" class="t02i">&nbsp;</td>
					<td width="10" height="10" class="t03i">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_calipso_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05i">
					  <table width="98%">
					    <tr> 
							<td height="20"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Listado de Cargas del per&iacute;odo</strong></font></td>
						</tr>
						<tr> 
							<td height="20"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>&nbsp;</strong></font></td>
						</tr>
					  </table>
					  <table width="98%" align="center" cellpadding="2" cellspacing="2" border="1" bordercolor="#999999">
						<tr>
						  <td width="100%" align="center">
							   <table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#ADADAD' id='tb_ramos'>
															<tr bgcolor='#C4D7FF'>
																<th><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Código</strong></font></th>
																<th><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Asignatura</strong></font></th>
																<th><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Periodo</strong></font></th>
																<th><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Docente</strong></font></th>
																<th width="40"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Avance</strong></font></th>
															</tr>
															<%f_ramos.primero
															  codigo = "C-ID"
															  validador = 0
															  fila = 1
															  while f_ramos.siguiente
															  secc_ccod = f_ramos.obtenerValor("secc_ccod")
															  pers_ncorr_profesor = f_ramos.obtenerValor("pers_ncorr")
															  asig_ccod = f_ramos.obtenerValor("asig_ccod")
															  asig_tdesc = f_ramos.obtenerValor("asig_tdesc")
															  semestre = f_ramos.obtenerValor("semestre")
															  docente = f_ramos.obtenerValor("docente")
															  encuestado = f_ramos.obtenerValor("encuestado")
															  antigua = conexion.consultaUno("select count(*) from evaluacion_docente where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr&"' and cast(pers_ncorr_destino as varchar)='"&pers_ncorr_profesor&"'")
															  fase_1 = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"' and isnull(parte_2_1,7) <> 7")
															  fase_2 = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"' and isnull(parte_3_1,7) <> 7")
															  fase_3 = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"' and isnull(parte_4_1,7) <> 7")
															  fase_4 = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"' and isnull(parte_5_1,7) <> 7")
															  fase_5 = conexion.consultaUno("select count(*) from cuestionario_opinion_alumnos where cast(secc_Ccod as varchar)='"&secc_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(pers_ncorr_profesor as varchar)='"&pers_ncorr_profesor&"' and isnull(parte_6_1,7) <> 7")
															  cuadro1 = "<img width='8' height='14' border='0' src='../imagenes/sinevaluar.jpg'>"
															  cuadro2 = "<img width='8' height='14' border='0' src='../imagenes/sinevaluar.jpg'>"
															  cuadro3 = "<img width='8' height='14' border='0' src='../imagenes/sinevaluar.jpg'>"
															  cuadro4 = "<img width='8' height='14' border='0' src='../imagenes/sinevaluar.jpg'>"
															  cuadro5 = "<img width='8' height='14' border='0' src='../imagenes/sinevaluar.jpg'>"
															  if  antigua <> "0" then
																cuadro1 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
																cuadro2 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
																cuadro3 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
																cuadro4 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
																cuadro5 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
																porcentaje_avance = 100
																codigo = codigo & "|" & secc_ccod
																validador = validador + cdbl(secc_ccod)
															  else
															    porcentaje_avance = 0
																if fase_1 <> "0" then
																    porcentaje_avance = porcentaje_avance + 20
																	cuadro1 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
																end if
																if fase_2 <> "0" then
																    porcentaje_avance = porcentaje_avance + 20
																	cuadro2 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
																end if
																if fase_3 <> "0" then
																    porcentaje_avance = porcentaje_avance + 20
																	cuadro3 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
																end if
																if fase_4 <> "0" then
																    porcentaje_avance = porcentaje_avance + 20
																	cuadro4 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
																end if
																if fase_5 <> "0" then
																    porcentaje_avance = porcentaje_avance + 20
																	cuadro5 = "<img width='8' height='14' border='0' src='../imagenes/evaluada.jpg'>"
																	'acá agregaremos los validadores 
																	codigo = codigo & "|" & secc_ccod
																	validador = validador + cdbl(secc_ccod)
																end if
															  end if
															  %>
															  <tr bgcolor="#FFFFFF"> 
																	<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=asig_ccod%></font></td>
																	<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=asig_tdesc%></font></td>
																	<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=semestre%></font></td>
																	<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=docente%></font></td>
																	<td>
																			<table width="40" height="5" border="1" bordercolor="#e41712">
																			   <tr>
																					<td width="8"><%=cuadro1%></td>
																					<td width="8"><%=cuadro2%></td>
																					<td width="8"><%=cuadro3%></td>
																					<td width="8"><%=cuadro4%></td>
																					<td width="8"><%=cuadro5%></td>
																			   </tr>
																			</table>
																	</td>
																	<input type="hidden" name="encuesta_<%=fila%>_asig_ccod" value="<%=asig_ccod%>">
																	<input type="hidden" name="encuesta_<%=fila%>_asig_tdesc" value="<%=asig_tdesc%>">
																	<input type="hidden" name="encuesta_<%=fila%>_semestre" value="<%=semestre%>">
																	<input type="hidden" name="encuesta_<%=fila%>_docente" value="<%=docente%>">
																	<input type="hidden" name="encuesta_<%=fila%>_avance" value="<%=porcentaje_avance%>">
															 </tr>
															<% POS_IMAGEN = POS_IMAGEN + 5
															   fila = fila + 1
															   wend
															   
															   codigo = codigo &"PNC"&pers_ncorr_temporal 
															   validador = validador + cdbl(anos_ccod)
															%>
															<input type="hidden" name="total_filas" value="<%=fila%>">
								</table>
								<br>
							</td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_calipso_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
		 	<td colspan="3" height="200">&nbsp;</td>
		 </tr>
		 </form>
		 <%else%>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01i">&nbsp;</td>
					<td height="10" class="t02i">&nbsp;</td>
					<td width="10" height="10" class="t03i">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_calipso_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05i">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="center"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong><br><br>NO EXISTE INFORMACI&Oacute;N DE EVALUACI&Oacute;N DOCENTE EN EL PER&Iacute;ODO</strong></font></td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_calipso_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" height="300">&nbsp;</td>
		 </tr>
		 <%end if ' para cuando retorna registros%>
  </table>
  </div>
  <div id="center5" class="x-layout-inactive-content">
  <table width="98%" align="center" cellpadding="0" cellspacing="0">
         <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01f">&nbsp;</td>
					<td height="10" class="t02f">&nbsp;</td>
					<td width="10" height="10" class="t03f">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_cafe_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05f">
					  <table width="100%" align="left" cellpadding="0" cellspacing="0" id="horario" >
						<tr>
							<td width="60%" align="left">
							  <table width="100%" cellpadding="0" cellspacing="0">
								  <tr>
									<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>FICHA ACADEMICA ALUMNO</strong></font></td>
								  </tr>
								  <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=rut%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nombre%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=carrera%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=estado%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Per&iacute;odo</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=periodo%></font></td>
								 </tr>
							  </table>
							</td>
							<td width="40%" align="center">
							  <table width="95%" cellpadding="0" cellspacing="0" border="0">
							  	 <tr>
								 	<td width="100%">
									<div align="center" class="noprint">
									  <table width="100%" cellpadding="0" cellspacing="0">
									  	<tr>
											<td width="26" height="26"><a href="javascript:imprimir('center5','Ficha Alumno');"><img width="26" height="26" src="images/btn_imprimir.png" border="0" title="Imprimir Ficha Académica"></a></td>
											<td width="30%"><a href="javascript:imprimir('center5','Ficha Alumno');" title="Imprimir Ficha Académica">Imprimir</a></td>
											<td width="26" height="26"><a href="javascript:reporte_word();"><img width="26" height="26" src="images/btn_word.png" border="0" title="Generar Reporte"></a></td>
											<td width="30%"><a href="javascript:reporte_word();">Reporte</a></td>
											<td width="26" height="26"><a href="#i_alumno"><img width="26" height="26" src="images/btn_alumno.png" border="0" title="Ir a Identificaci&oacute;n del Alumno"></a></td>
											<td width="30%"><a href="#i_alumno">Alumno</a></td>
										</tr>
										<tr>
											<td width="26" height="30"><a href="#a_educacionales"><img width="26" height="26" src="images/btn_escuela.png" border="0" title="Ir a antecedentes educacionales"></a></td>
											<td width="30%"><a href="#a_educacionales" title="Ir a antecedentes educacionales">Colegio</a></td>
											<td width="26" height="30"><a href="#i_sostenedor"><img width="26" height="26" src="images/btn_sostenedor.png" border="0" title="Ver sostenedor económico"></a></td>
											<td width="30%"><a href="#i_sostenedor"  title="Ver sostenedor económico">Sostenedor</a></td>
											<td width="26" height="30"><a href="#a_padre"><img width="26" height="26" src="images/btn_papa.png" border="0" title="Ver datos del padre"></a></td>
											<td width="30%"><a href="#a_padre"  title="Ver datos del padre" >Padre</a></td>
										</tr>
										<tr>
											<td width="26" height="26"><a href="#a_padre"><img width="26" height="26" src="images/btn_mama.png" border="0" title="Ver datos de la madre"></a></td>
											<td width="30%"><a href="#a_padre" title="Ver datos de la madre">Madre</a></td>
											<td width="26" height="26"><a href="#d_admision"><img width="26" height="26" src="images/btn_documentos.png" border="0" title="Ver documentos entregados"></a></td>
											<td width="30%"><a href="#d_admision"  title="Ver documentos entregados">Documentos</a></td>
											<td width="26" height="26">&nbsp;</td>
											<td width="30%">&nbsp;</td>
										</tr>
									  </table>
									  </div>
									</td>
								 </tr>
							  </table>
							</td>
						</tr>
					</table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_cafe_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01f">&nbsp;</td>
					<td height="10" class="t02f">&nbsp;</td>
					<td width="10" height="10" class="t03f">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_cafe_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05f"> 
  					  <table id="i_alumno" width="100%" border="0" cellpadding="1" cellspacing="3">
						  <tr> 
							<td width="30%"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td width="20%"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td width="25%"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
						  </tr>
						  <tr> 
							<td height="20" colspan="4"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Identificaci&oacute;n del Alumno</strong></font></td>
						  </tr>
						  <tr> 
							<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
						  </tr>
						  <tr> 
							<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombres :</strong></font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT :</strong></font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Pasaporte :</strong></font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Fecha Nacimiento :</strong></font></td>
						  </tr>
						  <tr> 
							<td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("nombre")%></font></td>
								</tr>
							  </table></td>
							<td><table width="80%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("rut")%></font></td>
								</tr>
							  </table></td>
							<td><table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("pasaporte")%></font></td>
								</tr>
							  </table></td>
							<td><table width="50%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("fecha_nac")%></font></td>
								</tr>
							  </table></td>
						  </tr>
						  <tr> 
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
						  </tr>
						  <tr><td colspan="4" height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>E-mail Alumno</strong></font></td></tr>
						  <tr><td colspan="4" height="20"><table width="80%" border="0" cellpadding="0" cellspacing="0">
															<tr> 
															  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("email_alumno")%></font></td>
															</tr>
														  </table>
							 </td>
						  </tr> 
						  <tr> 
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
						  </tr>
						  <tr> 
							<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Direcci&oacute;n :</strong></font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Ciudad : </strong></font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Comuna :</strong></font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Regi&oacute;n :</strong></font></td>
						  </tr>
						  <tr> 
							<td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("Direccion")%></font></td>
								</tr>
							  </table></td>
							<td> <table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("comuna")%></font></td>
								</tr>
							  </table></td>
							<td> <table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("ciudad")%></font></td>
								</tr>
							  </table></td>
							<td> <table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("region")%></font></td>
								</tr>
							  </table></td>
						  </tr>
						  <tr> 
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
						  </tr>
						  <tr> 
							<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Fonos : </strong></font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nacionalidad :</strong></font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera :</strong></font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>A&ntilde;o Ingreso :</strong></font></td>
						  </tr>
						  <tr> 
							<td> <table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("fono")%></font></td>
								</tr>
							  </table></td>
							<td> <table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("nacionalidad")%></font></td>
								</tr>
							  </table></td>
							<td> <table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("Carrera")%></font></td>
								</tr>
							  </table></td>
							<td> <table width="40%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("ano_ingr")%></font></td>
								</tr>
							  </table></td>
						  </tr>
						  <tr> 
							<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
						  </tr>
						  <tr> 
							<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado Civil :</strong></font></td>
							<td colspan="2"><p><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Qui&eacute;n financia sus estudios 
								:</strong></font></p></td>
							<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>&nbsp;</strong></font></td>
						  </tr>
						  <tr> 
							 <td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("Estado_civil")%></font></td>
								</tr>
							  </table></td>
							<td colspan="2"><table width="55%" border="0" cellpadding="0" cellspacing="0">
								<tr> 
								  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("FinanciaEst")%></font></td>
								</tr>
							  </table></td>
							<td align="right"><a href="#horario"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
						</tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_cafe_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01f">&nbsp;</td>
					<td height="10" class="t02f">&nbsp;</td>
					<td width="10" height="10" class="t03f">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_cafe_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05f">
					  <table id="a_educacionales" width="100%" cellpadding="0" cellspacing="3">
			                  <tr> 
								<td height="20" colspan="4"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Antecedentes Educacionales</strong></font></td>
							  </tr>
							  <tr> 
								<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Colegio de Egreso</strong></font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>A&ntilde;o de Egreso</strong></font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Proc. de Educaci&oacute;n</strong></font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Tipo de Establecimiento</strong></font></td>
							  </tr>
							  <tr> 
								<td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("colegio_egreso")%></font></td>
									</tr>
								  </table></td>
								<td> <table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("ano_egreso")%></font></td>
									</tr>
								  </table></td>
								<td> <table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("proced_educ")%></font></td>
									</tr>
								  </table></td>
								<td> <table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%'=fDatosPer.dibujaCampo("Estado_civil")%></FONT></td>
									</tr>
								  </table></td>
							  </tr>
							  <tr> 
								<td height="5"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="20" colspan="2"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Universidad (Si estuvo 
								  en otra anteriormente)</strong></font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="20" colspan="2"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("inst_educ_sup")%></font></td>
									</tr>
								  </table></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td align="right"><a href="#horario"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
							  </tr>
	                   </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_cafe_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
 		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01f">&nbsp;</td>
					<td height="10" class="t02f">&nbsp;</td>
					<td width="10" height="10" class="t03f">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_cafe_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05f">
					  <table id="i_sostenedor" width="100%" cellpadding="0" cellspacing="3">
		                      <tr> 
								<td height="20" colspan="4"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Identificaci&oacute;n del sostenedor acad&eacute;mico</strong></font></td>
							  </tr>
							  <tr> 
								<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre :</strong></font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT :</strong></font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Fecha Nacimiento :</strong></font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Edad :</strong></font></td>
							  </tr>
							  <tr> 
								<td height="20"><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("nombre_sost_ec")%></font></td>
									</tr>
								  </table></td>
								<td><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("RUT_sost_ec")%></font></td>
									</tr>
								  </table></td>
								<td><table width="50%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("fnac_sost_ec")%></font></td>
									</tr>
								  </table></td>
								<td><table width="30%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20" align="right"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("edad_sost")%></font></td>
									</tr>
								  </table></td>
							  </tr>
							  <tr> 
								<td height="5"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="5"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="5"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="5"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr><td colspan="4" height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>E-mail sostenedor</strong></font></td></tr>
							  <tr><td colspan="4" height="20"><table width="80%" border="0" cellpadding="0" cellspacing="0">
																<tr> 
																  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("email_sost")%></font></td>
																</tr>
															  </table>
								 </td>
							  </tr>
							  <tr> 
								<td height="5"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Direcci&oacute;n :</strong></font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Ciudad:</strong></font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Comuna : </strong></font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Regi&oacute;n :</strong></font></td>
							  </tr>
							  <tr> 
								<td height="20"><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("dire_tdesc_sost_ec")%></font></td>
									</tr>
								  </table></td>
								<td><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("comu_sost_ec")%></font></td>
									</tr>
								  </table></td>
								<td><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("ciud_sost_ec")%></font></td>
									</tr>
								  </table></td>
								<td><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("regi_sost_ec")%></font></td>
									</tr>
								  </table></td>
							  </tr>
							  <tr> 
								<td height="5"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Fono :</strong></font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Parentesco</strong></font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("fono_sost_ec")%></font></td>
									</tr>
								  </table></td>
								<td><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer.dibujaCampo("pare_sost_ec")%></font></td>
									</tr>
								  </table></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td align="right"><a href="#horario"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
							  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_cafe_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
 		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01f">&nbsp;</td>
					<td height="10" class="t02f">&nbsp;</td>
					<td width="10" height="10" class="t03f">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_cafe_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05f">
					  <table id="a_padre" width="100%" cellpadding="0" cellspacing="0">
		                      <tr> 
								<td height="10" colspan="4"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Antecedentes del Padre</strong></font></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT :</strong></font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombres :</strong></font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Fono :</strong></font></td>
							  </tr>
							  <tr> 
								<td height="10">
								  <table width="56%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("RUT_p")%></font></td>
									</tr>
								  </table>
								</td>
								<td height="10" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("Nombre_p")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><%=fDatosPer2.dibujaCampo("fono_p")%></font></td>
									</tr>
								  </table></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Direcci&oacute;n :</strong></font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Ciudad :</strong></font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Comuna :</strong></font></td>
							  </tr>
							  <tr> 
								<td height="10" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("Direccion_p")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("comuna_p")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("ciudad_p")%></font></td>
									</tr>
								  </table></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td align="right"><a href="#horario"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
							  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_cafe_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
 		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01f">&nbsp;</td>
					<td height="10" class="t02f">&nbsp;</td>
					<td width="10" height="10" class="t03f">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_cafe_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05f">
					  <table id="a_madre" width="100%" cellpadding="0" cellspacing="0">
		                      <tr> 
								<td height="10" colspan="4"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Antecedentes de la madre</strong></font></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT :</strong></font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombres :</strong></font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Fono :</strong></font></td>
							  </tr>
							  <tr> 
								<td height="10"><table width="50%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20" ><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("RUT_m")%></font></td>
									</tr>
								  </table></td>
								<td height="10" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20" ><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("Nombre_m")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" >
									<tr> 
									  <td height="20" ><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("fono_m")%></font></td>
									</tr>
								  </table></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Direcci&oacute;n :</strong></font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Ciudad :</strong></font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Comuna :</strong></font></td>
							  </tr>
							  <tr> 
								<td height="10" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0" >
									<tr> 
									  <td height="20" ><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("Direccion_m")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" >
									<tr> 
									  <td height="20" ><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("comuna_m")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" >
									<tr> 
									  <td height="20"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("ciudad_m")%></font></td>
									</tr>
								  </table></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td align="right"><a href="#horario"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
							  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_cafe_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
 		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01f">&nbsp;</td>
					<td height="10" class="t02f">&nbsp;</td>
					<td width="10" height="10" class="t03f">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_cafe_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05f">
					  <table id="d_admision" width="100%" cellpadding="0" cellspacing="0">
			                  <tr> 
								<td height="10" colspan="4"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Datos entregados para admisión</strong></font></td>
							  </tr>
							  <tr> 
								<td height="10" colspan="2"><em><font face="Times New Roman, Times, serif" size="2" color="#085fbc">ACAD&Eacute;MICOS</font></em></td>
								<td height="10" colspan="2"><em><font face="Times New Roman, Times, serif" size="2" color="#085fbc">FORMA 
								  DE ADMISI&Oacute;N</font></em></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Prom. Notas Ens. Media </strong></font></td>
								<td height="10"> <table width="50%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20" align="right" ><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("promNotas_em")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Admisi&oacute;n Regular</strong></font></td>
								<td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" >
									<tr> 
									  <td height="20" align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("adm_regular")%></font></td>
									</tr>
								  </table></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>A&ntilde;o que rinde la PAA /PSU</strong></font></td>
								<td height="10"><table width="50%" border="0" cellpadding="0" cellspacing="0" >
									<tr> 
									  <td height="20" align="right"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("ano_PAA")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Admisi&oacute;n por Convalidaci&oacute;n</strong></font></td>
								<td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" >
									<tr> 
									  <td height="20" align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("adm_por_conv")%></font></td>
									</tr>
								  </table></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Ptje. promedio PAA/PSU </strong></font></td>
								<td height="10"><table width="50%" border="0" cellpadding="0" cellspacing="0" >
									<tr> 
									  <td height="20" align="right">
										 <font face="Times New Roman, Times, serif" size="2" color="#000000">
										<% puntaje_PSU = fDatosPer2.obtenerValor("pje_prom_PAA") 
											if puntaje_PSU="" or puntaje_PSU < "475" then
											   response.Write("Ingreso Especial")
											else   
											   response.Write(fDatosPer2.dibujaCampo("pje_prom_PAA"))
											end if%>
											</font>
									  </td>
									</tr>
								  </table></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="10" valign="top"><font face="Times New Roman, Times, serif" size="2" color="#085fbc">(Verbal - Matem&aacute;ticas)</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="10"><em><font face="Times New Roman, Times, serif" size="2" color="#085fbc">ANTECEDENTES 
								  ENTREGADOS</font></em></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>C&eacute;dula de Identidad o Pasaporte</strong></font></td>
								<td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20" align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("CI_pas")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Licencia de Ense&ntilde;anza Media</strong></font></td>
								<td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0" >
									<tr> 
									  <td height="20" align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("lic_EM")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Concentraci&oacute;n de Notas E.M.</strong></font></td>
								<td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20" align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("concen_notas")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Puntaje PAA / PSU</strong></font></td>
								<td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20" align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("ptje_paa_psu")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>2 Fotos tama&ntilde;o Carnet</strong></font></td>
								<td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20" align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("fotos_carnet")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Certificado de Residencia</strong></font></td>
								<td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20" align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("certif_residencia")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Seguro de Salud (Extranjeros)</strong></font></td>
								<td height="10"><table width="30%" border="0" cellpadding="0" cellspacing="0">
									<tr> 
									  <td height="20" align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=fDatosPer2.dibujaCampo("seguro_salud")%></font></td>
									</tr>
								  </table></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
							  </tr>
							  <tr> 
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td height="10"><font face="Times New Roman, Times, serif" size="2" color="#000000">&nbsp;</font></td>
								<td align="right"><a href="#horario"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
							  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_cafe_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
	 </table>
  </div>
  <div id="center6" class="x-layout-inactive-content">
  <table width="98%" align="center" cellpadding="0" cellspacing="0">
         <tr>
			<td colspan="3" id="cta_corriente">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="95%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01r">&nbsp;</td>
					<td height="10" class="t02r">&nbsp;</td>
					<td width="10" height="10" class="t03r">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_rojo_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05r">
					  <table width="100%" align="left" cellpadding="0" cellspacing="0" id="horario" >
						<tr>
							<td width="60%" align="left">
							  <table width="100%" cellpadding="0" cellspacing="0">
								  <tr>
									<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>CUENTA CORRIENTE</strong></font></td>
								  </tr>
								  <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=rut%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nombre%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=carrera%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=estado%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Per&iacute;odo</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=periodo%></font></td>
								 </tr>
							  </table>
							</td>
							<td width="40%" align="center">
							  <table width="95%" cellpadding="0" cellspacing="0" border="0">
							  	 <tr>
								 	<td width="100%">
									<div align="center" class="noprint">
									  <table width="100%" cellpadding="0" cellspacing="0">
									  	<tr>
											<td width="26" height="26"><a href="javascript:imprimir('center6','Cuenta Corriente');"><img width="26" height="26" src="images/btn_imprimir.png" border="0" title="Imprimir Cuenta Corriente"></a></td>
											<td width="30%"><a href="javascript:imprimir('center6','Cuenta Corriente');" title="Imprimir Cuenta Corriente">Imprimir</a></td>
											<%if f_cta_cte.nroFilas > 0 then%>
											<td width="26" height="26"><a href="javascript:reporte_excel(6);"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte"></a></td>
											<td width="30%"><a href="javascript:reporte_excel(6);">Reporte</a></td>
											<%else%>
											<td width="26" height="26"><a href="javascript:alert('No existe información de cuenta corriente registrada');"><img width="26" height="26" src="images/btn_excel.png" border="0" title="Generar Reporte"></a></td>
											<td width="30%"><a href="javascript:alert('No existe información de cuenta corriente registrada');">Reporte</a></td>
											<%end if%>
											<td width="26" height="26"><a href="#d_compromisos"><img width="26" height="26" src="images/btn_sostenedor.png" border="0" title="Ir a Detalle de Compromisos"></a></td>
											<td width="30%"><a href="#d_compromisos">Compromisos</a></td>
										</tr>
										<tr>
											<td width="26" height="30"><a href="#becas"><img width="26" height="26" src="images/btn_becas.png" border="0" title="Ir a Becas y descuentos"></a></td>
											<td width="30%"><a href="#becas" title="Ir a Becas y descuentos">Becas y Desc.</a></td>
											<td width="26" height="30"><a href="#comentarios"><img width="26" height="26" src="images/btn_escuela.png" border="0" title="Ver Comentarios"></a></td>
											<td width="30%"><a href="#comentarios"  title="Ver Comentarios">Comentarios</a></td>
											<td width="26" height="30"><a href="#morosidad"><img width="26" height="26" src="images/btn_morosidad.png" border="0" title="Ver Morosidad"></a></td>
											<td width="30%"><a href="#morosidad"  title="Ver Morosidad" >Morosidad</a></td>
										</tr>
			                          </table>
									 </div>
									</td>
								 </tr>
							  </table>
							</td>
						</tr>
					</table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_rojo_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
			  </table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <form name="cta_cte" action="cta_cte_excel.asp" method="post" target="_blank">
		     <input type="hidden" name="rut" value="<%=rut%>">
		     <input type="hidden" name="nombres" value="<%=nombre%>">
			 <input type="hidden" name="carrera" value="<%=carrera%>">
			 <input type="hidden" name="estado" value="<%=estado%>">
			 <input type="hidden" name="periodo" value="<%=periodo%>">
			 <input type="hidden" name="especialidad_plan" value="<%=especialidad_plan%>">
    	 <tr>
			<td colspan="3" align="left">
				<table width="95%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01r">&nbsp;</td>
					<td height="10" class="t02r">&nbsp;</td>
					<td width="10" height="10" class="t03r">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_rojo_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05r">
					   <table id="d_compromisos" width="100%" cellpadding="0" cellspacing="0">
					   <tr>
					   		<td colspan="3"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Detalle de Compromisos</strong></font></td>
					   </tr>
					   <tr>
					   		<td colspan="3">&nbsp;</td>
					   </tr>
					   <tr>
							<td colspan="3" align="left">
								<div id="example_3">
									 <ul class="pagination" id="example_3_table_paginator"></ul>
									 <div style="clear:both;"></div>
									<table width="95%" id="example_3_table" cellpadding="0" cellspacing="0" border="1">
											  <thead>
												<tr valign="top" bgcolor="#feb528">
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>PERIODO</strong></font></th>
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>NUM COMPROMISO CONTRATO</strong></font></th>
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>ITEM</strong></font></th>
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>NUM CUOTA</strong></font></th>
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>FECHA EMISION</strong></font></th>
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>FECHA VENCIMIENTO</strong></font></th>
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>DOCTO PACTADO</strong></font></th>
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>NUM DOCTO</strong></font></th>
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>ESTADO DOC</strong></font></th>
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>MONTO</strong></font></th>
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>ABONO</strong></font></th>
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>ABONOS DOC</strong></font></th>
													<th align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>SALDO</strong></font></th>
												</tr>
												<input type="hidden" name="detalle_0_periodo" value="PERIODO">
												<input type="hidden" name="detalle_0_num_compromiso" value="NUM COMPROMISO CONTRATO">
												<input type="hidden" name="detalle_0_item" value="ITEM">
												<input type="hidden" name="detalle_0_num_cuota" value="NUM CUOTA">
												<input type="hidden" name="detalle_0_fecha_emision" value="FECHA EMISION">
												<input type="hidden" name="detalle_0_fecha_vencimiento" value="FECHA VENCIMIENTO">
												<input type="hidden" name="detalle_0_docto_pactado" value="DOCTO PACTADO">
												<input type="hidden" name="detalle_0_num_docto" value="NUM DOCTO">
												<input type="hidden" name="detalle_0_estado_doc" value="ESTADO DOC">
												<input type="hidden" name="detalle_0_monto" value="MONTO">
												<input type="hidden" name="detalle_0_abono" value="ABONO">
												<input type="hidden" name="detalle_0_abonos_doc" value="ABONOS DOC">
												<input type="hidden" name="detalle_0_saldo" value="SALDO">
												<input type="hidden" name="detalle_0_color" value="#feb528">
											</thead>
											<tbody>
											<%clase = "#ffeed0"
											 if f_cta_cte.nroFilas > 0 then
											  fila_detalle = 1
											  while f_cta_cte.siguiente
												 periodo_m = f_cta_cte.obtenerValor("periodo")
												 ncompromiso = f_cta_cte.obtenerValor("ncompromiso")
												 tcom_tdesc = f_cta_cte.obtenerValor("tcom_tdesc")
												 ncuota = f_cta_cte.obtenerValor("ncuota")
												 comp_fdocto = f_cta_cte.obtenerValor("comp_fdocto")
												 dcom_fcompromiso = f_cta_cte.obtenerValor("dcom_fcompromiso")
												 ting_ccod = f_cta_cte.obtenerValor("ting_ccod")
												 ding_ndocto = f_cta_cte.obtenerValor("ding_ndocto")
												 edin_tdesc  = f_cta_cte.obtenerValor("edin_tdesc")
												 dcom_mcompromiso = f_cta_cte.obtenerValor("dcom_mcompromiso")
												 abonos = f_cta_cte.obtenerValor("abonos")
												 documentado = f_cta_cte.obtenerValor("documentado")
												 saldo = f_cta_cte.obtenerValor("saldo")
												 %>
												<tr bgcolor="<%=clase%>">
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=periodo_m%>&nbsp;</font></td>
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=ncompromiso%>&nbsp;</font></td>
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=tcom_tdesc%>&nbsp;</font></td>
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=ncuota%>&nbsp;</font></td>
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=comp_fdocto%>&nbsp;</font></td>
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=dcom_fcompromiso%>&nbsp;</font></td>
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=ting_ccod%>&nbsp;</font></td>
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=ding_ndocto%>&nbsp;</font></td>
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=edin_tdesc%>&nbsp;</font></td>
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=formatCurrency(dcom_mcompromiso,0)%>&nbsp;</font></td>
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=formatCurrency(abonos,0)%>&nbsp;</font></td>
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=formatCurrency(documentado,0)%>&nbsp;</font></td>
													<td><font face="Times New Roman, Times, serif" size="2" color="#000000"><%=formatCurrency(saldo,0)%>&nbsp;</font></td>
												</tr>
												<input type="hidden" name="detalle_<%=fila_detalle%>_periodo" value="<%=periodo_m%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_num_compromiso" value="<%=ncompromiso%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_item" value="<%=tcom_tdesc%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_num_cuota" value="<%=ncuota%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_fecha_emision" value="<%=comp_fdocto%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_fecha_vencimiento" value="<%=dcom_fcompromiso%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_docto_pactado" value="<%=ting_ccod%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_num_docto" value="<%=ding_ndocto%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_estado_doc" value="<%=edin_tdesc%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_monto" value="<%=formatCurrency(dcom_mcompromiso,0)%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_abono" value="<%=formatCurrency(abonos,0)%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_abonos_doc" value="<%=formatCurrency(documentado,0)%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_saldo" value="<%=formatCurrency(saldo,0)%>">
												<input type="hidden" name="detalle_<%=fila_detalle%>_color" value="<%=clase%>">
											 <%
											   if clase = "#ffeed0" then
													clase = "#ffffff"
											   else
													clase = "#ffeed0"
											  end if
											  fila_detalle = fila_detalle + 1
											wend
											else%>
											 <tr>
												<td colspan="13" align="center" bgcolor="#FFFFFF">No se encontraron Cargos asociados a cuenta corriente del alumno...</td>
											 </tr>
										   <%end if%>
										     <input type="hidden" name="fila_detalle" value="<%=fila_detalle%>">
										   </tbody>
										</table>
										<script type="text/javascript">
										  /*window.addEvent( 'domready', function(){
										  new PaginatingTable(
															'example_3_table',
															'example_3_table_paginator', {
															  per_page: 10 }
											)
										});*/
										</script>
									  </div>
									  <div align="right"><a href="#cta_corriente"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></div>
							</td>
						</tr>
					   </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_rojo_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>		
			</td>
		 </tr>
		 <tr>
		    <td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="95%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01r">&nbsp;</td>
					<td height="10" class="t02r">&nbsp;</td>
					<td width="10" height="10" class="t03r">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_rojo_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05r">
					  <table id="becas" width="100%" cellpadding="0" cellspacing="0">
					   <tr>
					   		<td colspan="3"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Becas y Descuentos</strong></font></td>
					   </tr>
					   <tr>
					   		<td colspan="3">&nbsp;</td>
					   </tr>
					   <tr>
					   		<td colspan="3" align="left">
							   <table width="95%" cellpadding="0" cellspacing="0" border="1">
							     <tr>
								     <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Num Contrato</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Tipo</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Beneficio</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Fecha</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Monto Beneficio</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>%(Matrícula)</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>%(Colegiatura)</strong></font></th>
								     <input type="hidden" name="becas_0_num_contrato" value="Num Contrato">
									 <input type="hidden" name="becas_0_tipo" value="Tipo">
									 <input type="hidden" name="becas_0_beneficio" value="Beneficio">
									 <input type="hidden" name="becas_0_fecha" value="Fecha">
									 <input type="hidden" name="becas_0_monto_beneficio" value="Monto Beneficio">
									 <input type="hidden" name="becas_0_porc_matricula" value="%(Matrícula)">
									 <input type="hidden" name="becas_0_porc_colegiatura" value="%(Colegiatura)">
									 <input type="hidden" name="becas_0_color" value="#feb528">
								 </tr>
								 <%color_fila = "#ffeed0" 
								   if f_becas_descuentos.nroFilas > 0 then
								   filas_becas = 1 
								   while f_becas_descuentos.siguiente
								      contrato = f_becas_descuentos.obtenerValor("contrato")
									  cont_ncorr = f_becas_descuentos.obtenerValor("cont_ncorr")
									  stde_ccod  = f_becas_descuentos.obtenerValor("stde_ccod")
									  stde_tdesc = f_becas_descuentos.obtenerValor("stde_tdesc")
									  bene_mmonto = f_becas_descuentos.obtenerValor("bene_mmonto")
									  mone_ccod   = f_becas_descuentos.obtenerValor("mone_ccod")
									  porce_matricula = f_becas_descuentos.obtenerValor("bene_nporcentaje_matricula")
									  porce_colegiatura = f_becas_descuentos.obtenerValor("bene_nporcentaje_colegiatura")
									  tben_ccod = f_becas_descuentos.obtenerValor("tben_ccod")
									  bene_fbeneficio = f_becas_descuentos.obtenerValor("bene_fbeneficio")
								 %>
								 <tr bgcolor="<%=color_fila%>">
								     <td align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=contrato%></strong></font></td>
									 <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=tben_ccod%></strong></font></td>
									 <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=stde_tdesc%></strong></font></td>
									 <td align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=bene_fbeneficio%></strong></font></td>
									 <td align="right"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=formatCurrency(bene_mmonto,0)%></strong></font></td>
									 <td align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=porce_matricula%>%</strong></font></td>
									 <td align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=porce_colegiatura%>%</strong></font></td>
								 </tr>
								     <input type="hidden" name="becas_<%=filas_becas%>_num_contrato" value="<%=contrato%>">
									 <input type="hidden" name="becas_<%=filas_becas%>_tipo" value="<%=tben_ccod%>">
									 <input type="hidden" name="becas_<%=filas_becas%>_beneficio" value="<%=stde_tdesc%>">
									 <input type="hidden" name="becas_<%=filas_becas%>_fecha" value="<%=bene_fbeneficio%>">
									 <input type="hidden" name="becas_<%=filas_becas%>_monto_beneficio" value="<%=formatCurrency(bene_mmonto,0)%>">
									 <input type="hidden" name="becas_<%=filas_becas%>_porc_matricula" value="<%=porce_matricula%>%">
									 <input type="hidden" name="becas_<%=filas_becas%>_porc_colegiatura" value="<%=porce_colegiatura%>%">
									 <input type="hidden" name="becas_<%=filas_becas%>_color" value="<%=color_fila%>">
								 <%
									   if color_fila = "#ffeed0" then
											color_fila = "#ffffff"
									   else
											color_fila = "#ffeed0"
									   end if
									   
									   filas_becas = filas_becas + 1								 
								   wend
								   else%>
								     <tr>
									 	<td colspan="7" align="center" bgcolor="#FFFFFF">No se encontraron Becas o descuentos asociados al alumno...</td>
									 </tr>
								   <%end if%>
								   <input type="hidden" name="filas_becas" value="<%=filas_becas%>"> 
							   </table>
							</td>
					   </tr>
					   <tr>
					   		<td colspan="3" align="right"><a href="#cta_corriente"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
					   </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_rojo_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
			  </table>
			</td>
		 </tr>
         <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="95%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01r">&nbsp;</td>
					<td height="10" class="t02r">&nbsp;</td>
					<td width="10" height="10" class="t03r">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_rojo_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05r">
					  <table id="comentarios" width="100%" cellpadding="0" cellspacing="0">
					   <tr>
					   		<td colspan="3"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Comentarios</strong></font></td>
					   </tr>
					   <tr>
					   		<td colspan="3">&nbsp;</td>
					   </tr>
					   <tr>
					   		<td colspan="3" align="left">
							   <table width="95%" cellpadding="0" cellspacing="0" border="1">
							     <tr>
								     <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Fecha Comentario</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Detalle Comentario</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Tipo Comentario</strong></font></th>
								</tr>
								<input type="hidden" name="comentarios_0_fecha_comentario" value="Fecha Comentario">
								<input type="hidden" name="comentarios_0_detalle_comentario" value="Detalle Comentario">
								<input type="hidden" name="comentarios_0_tipo_comentario" value="Tipo Comentario">
								<input type="hidden" name="comentarios_0_color" value="#feb528">
								 <%color_fila = "#ffeed0" 
								 if f_comentarios.nroFilas > 0 then
								   filas_comentarios = 1
								   while f_comentarios.siguiente
								      fecha_comentario = f_comentarios.obtenerValor("COME_FCOMENTARIO")
									  texto_comentario = f_comentarios.obtenerValor("COME_TCOMENTARIO")
									  tico_ccod        = f_comentarios.obtenerValor("TICO_CCOD")
								 %>
								 <tr bgcolor="<%=color_fila%>">
								     <td align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=fecha_comentario%></strong></font></td>
									 <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=texto_comentario%></strong></font></td>
									 <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=tico_ccod%></strong></font></td>
								 </tr>
								 <input type="hidden" name="comentarios_<%=filas_comentarios%>_fecha_comentario" value="<%=fecha_comentario%>">
								 <input type="hidden" name="comentarios_<%=filas_comentarios%>_detalle_comentario" value="<%=texto_comentario%>">
								 <input type="hidden" name="comentarios_<%=filas_comentarios%>_tipo_comentario" value="<%=tico_ccod%>">
								 <input type="hidden" name="comentarios_<%=filas_comentarios%>_color" value="<%=color_fila%>">
								 <%
									   if color_fila = "#ffeed0" then
											color_fila = "#ffffff"
									   else
											color_fila = "#ffeed0"
									   end if
									   
									   filas_comentarios = filas_comentarios + 1								 
								   wend
								   else%>
								     <tr>
									 	<td colspan="3" align="center" bgcolor="#FFFFFF">No se encontraron comentarios...</td>
									 </tr>
								   <%end if%>
								   <input type="hidden" name="filas_comentarios" value="<%=filas_comentarios%>">
							   </table>
							</td>
					   </tr>
					   <tr>
					   		<td colspan="3" align="right"><a href="#cta_corriente"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
					   </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_rojo_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
			  </table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="95%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01r">&nbsp;</td>
					<td height="10" class="t02r">&nbsp;</td>
					<td width="10" height="10" class="t03r">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_rojo_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05r">
					  <table id="morosidad" width="100%" cellpadding="0" cellspacing="0">
					   <tr>
					   		<td colspan="3"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Morosidad</strong></font></td>
					   </tr>
					   <tr>
					   		<td colspan="3">&nbsp;</td>
					   </tr>
					   <tr>
					   		<td colspan="3" align="left">
							   <table width="95%" cellpadding="0" cellspacing="0" border="1">
							     <tr>
								     <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>&Iacute;tem</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>N°Cuota</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Fecha Vencimiento</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Docto. Pactado</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>N° Docto</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Estado Doc.</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Monto</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Abono</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Saldo</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>D&iacute;as</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>Interes</strong></font></th>
									 <th bgcolor="#feb528" align="center"><font face="Times New Roman, Times, serif" size="2" color="#ffffff"><strong>A Pagar</strong></font></th>
								</tr>
								<input type="hidden" name="morosidad_0_item" value="&Iacute;tem">
								<input type="hidden" name="morosidad_0_n_cuota" value="N°Cuota">
								<input type="hidden" name="morosidad_0_fecha_vencimiento" value="Fecha Vencimiento">
								<input type="hidden" name="morosidad_0_docto_pactado" value="Docto. Pactado">
								<input type="hidden" name="morosidad_0_n_docto" value="N° Docto">
								<input type="hidden" name="morosidad_0_estado_doc" value="Estado Doc.">
								<input type="hidden" name="morosidad_0_monto" value="Monto">
								<input type="hidden" name="morosidad_0_abono" value="Abono">
								<input type="hidden" name="morosidad_0_saldo" value="Saldo">
								<input type="hidden" name="morosidad_0_dias" value="D&iacute;as">
								<input type="hidden" name="morosidad_0_interes" value="Interes">
								<input type="hidden" name="morosidad_0_a_pagar" value="A Pagar">
								<input type="hidden" name="morosidad_0_a_color" value="#feb528">
								<%color_fila = "#ffeed0" 
								 if f_morosidad.nroFilas > 0 then
								   filas_morosidad = 1
								   while f_morosidad.siguiente
								      tcom_tdesc       = f_morosidad.obtenerValor("tcom_tdesc")
									  ncuota           = f_morosidad.obtenerValor("ncuota")
									  dcom_fcompromiso = f_morosidad.obtenerValor("dcom_fcompromiso")
									  ting_ccod        = f_morosidad.obtenerValor("ting_ccod")
									  ding_ndocto      = f_morosidad.obtenerValor("ding_ndocto")
									  edin_tdesc       = f_morosidad.obtenerValor("edin_tdesc")
									  dcom_mcompromiso = f_morosidad.obtenerValor("dcom_mcompromiso")
									  abonos           = f_morosidad.obtenerValor("abonos")
									  saldo            = f_morosidad.obtenerValor("saldo")
									  dias_mora        = f_morosidad.obtenerValor("dias_mora")
									  interes          = f_morosidad.obtenerValor("interes")
									  a_pagar          = f_morosidad.obtenerValor("a_pagar")
								 %>
								 <tr bgcolor="<%=color_fila%>">
								     <td align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=tcom_tdesc%></strong></font></td>
									 <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=ncuota%></strong></font></td>
									 <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=dcom_fcompromiso%></strong></font></td>
									 <td align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=ting_ccod%></strong></font></td>
									 <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=ding_ndocto%></strong></font></td>
									 <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=edin_tdesc%></strong></font></td>
									 <td align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=dcom_mcompromiso%></strong></font></td>
									 <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=abonos%></strong></font></td>
									 <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=saldo%></strong></font></td>
									 <td align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=dias_mora%></strong></font></td>
									 <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=interes%></strong></font></td>
									 <td align="left"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=a_pagar%></strong></font></td>
								 </tr>
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_item" value="<%=tcom_tdesc%>">
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_n_cuota" value="<%=ncuota%>">
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_fecha_vencimiento" value="<%=dcom_fcompromiso%>">
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_docto_pactado" value="<%=ting_ccod%>">
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_n_docto" value="<%=ding_ndocto%>">
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_estado_doc" value="<%=edin_tdesc%>">
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_monto" value="<%=dcom_mcompromiso%>">
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_abono" value="<%=abonos%>">
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_saldo" value="<%=saldo%>">
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_dias" value="<%=dias_mora%>">
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_interes" value="<%=interes%>">
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_a_pagar" value="<%=a_pagar%>">
								 <input type="hidden" name="morosidad_<%=filas_morosidad%>_a_color" value="<%=color_fila%>">
								
								 <%
									   if color_fila = "#ffeed0" then
											color_fila = "#ffffff"
									   else
											color_fila = "#ffeed0"
									   end if
									   filas_morosidad = filas_morosidad + 1								 
									   
								   wend
								   							   
								   else%>
								     <tr>
									 	<td colspan="12" align="center" bgcolor="#FFFFFF">No existen compromisos por pagar para este alumno....</td>
									 </tr>
								   <%end if%>
								   <input type="hidden" name="filas_morosidad" value="<%=filas_morosidad%>">
							   </table>
							</td>
					   </tr>
					   <tr>
					   		<td colspan="3" align="right"><a href="#cta_corriente"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
					   </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_rojo_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
			  </table>
			</td>
		 </tr>
		 </form>
	</table>
  </div>
  <div id="center7" class="x-layout-inactive-content">
  <table width="98%" align="center" cellpadding="0" cellspacing="0">
         <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" id="matriculas_sup">
				  <tr>
					<td width="10" height="10" class="t01g">&nbsp;</td>
					<td height="10" class="t02g">&nbsp;</td>
					<td width="10" height="10" class="t03g">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_gris_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05g">
					  <table width="100%" align="left" cellpadding="0" cellspacing="0"  >
						<tr>
							<td width="60%" align="left">
							  <table width="100%" cellpadding="0" cellspacing="0">
								  <tr>
									<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#777777"><strong>MATR&Iacute;CULAS</strong></font></td>
								  </tr>
								  <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>RUT</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=rut%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Nombre</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=nombre%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Carrera</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=carrera%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Estado</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=estado%></font></td>
								 </tr>
								 <tr>
									<td width="10%"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>Per&iacute;odo</strong></font></td>
									<td width="2%" align="center"><font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>:</strong></font></td>
									<td width="88%"><font face="Times New Roman, Times, serif" size="2" color="#404040"><%=periodo%></font></td>
								 </tr>
							  </table>
							</td>
							<td width="40%" align="center">
							  <table width="95%" cellpadding="0" cellspacing="0" border="0">
							  	 <tr>
								 	<td width="100%">
									 <div align="center" class="noprint">
									  <table width="100%" cellpadding="0" cellspacing="0">
									  	<tr>
											<td width="26" height="26"><a href="javascript:imprimir('center7','matriculas');"><img width="26" height="26" src="images/btn_imprimir.png" border="0" title="Imprimir Matrículas"></a></td>
											<td width="30%"><a href="javascript:imprimir('center7','matriculas');" title="Imprimir Matrículas">Imprimir</a></td>
											<td width="26" height="26"><a href="#matriculas"><img width="26" height="26" src="images/btn_matriculas.png" border="0" title="Ir a Historial de matrículas"></a></td>
											<td width="30%"><a href="#matriculas">Matrículas</a></td>
											<td width="26" height="26"><a href="#rendimiento"><img width="26" height="26" src="images/btn_rendimiento.png" border="0" title="Ir a gráficas de rendimiento"></a></td>
											<td width="30%"><a href="#rendimiento">Rendimiento</a></td>
										</tr>
			                          </table>
									  </div>
									</td>
								 </tr>
							  </table>
							</td>
						</tr>
					</table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_gris_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
			<td colspan="3">&nbsp;</td>
		 </tr>
		 <%if f_matriculas.nroFilas > 0 then%>
		 <tr>
			<td colspan="3" align="left">
				<table id="matriculas" width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01g">&nbsp;</td>
					<td height="10" class="t02g">&nbsp;</td>
					<td width="10" height="10" class="t03g">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_gris_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05g">
					  <table width="100%" cellpadding="0" cellspacing="0">
					   <tr>
					   		<td colspan="3"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Matr&iacute;culas y Rendimiento</strong></font></td>
					   </tr>
					   <tr>
					   		<td colspan="3">&nbsp;</td>
					   </tr>
					   <tr>
					   		<td colspan="3" align="left">							
							  <table width="100%" cellpadding="0" cellspacing="0" align="left">
									<tr>
										<%distintos = 0
										  f_matriculas.siguiente
										  ano_matricula =  f_matriculas.obtenerValor("anos_ccod") 
										  f_matriculas.primero
										  
										  while f_matriculas.siguiente
										    ano_matricula2 = f_matriculas.obtenerValor("anos_ccod") 
											if cint(ano_matricula) <> cint(ano_matricula2) or distintos = 0 then%>
												<td width="15%" bgcolor="#d1e3fa" bordercolor="#0033CC" align="center">
												 <font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong><%=ano_matricula2%></strong></font>
												</td>
												<td width="1%" bgcolor="#0099FF">&nbsp;</td>
												<%ano_matricula = ano_matricula2
												  distintos = distintos + 1
											end if
										  wend
										  restantes = distintos
										  while restantes <= 6 %>
												<td  width="15%" align="center">
												 <font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>&nbsp;</strong></font>
												</td>
												<td width="1%">&nbsp;</td>  
										  <% restantes = restantes + 1
										  wend
										  f_matriculas.primero%>
									</tr>
									<tr>
										<td colspan="<%=(restantes*2)-2%>">&nbsp;</td>
									</tr>
									<tr>
										<td colspan="<%=(restantes*2)-2%>">&nbsp;</td>
									</tr>
									<tr valign="top">
										<%distintos = 0
										  cadena_rendimiento = ""
										  f_matriculas.siguiente
										  ano_matricula =  f_matriculas.obtenerValor("anos_ccod") 
										  f_matriculas.primero
										  while f_matriculas.siguiente
										    ano_matricula2        = f_matriculas.obtenerValor("anos_ccod")
											peri_matricula        = f_matriculas.obtenerValor("periodo") 
											sede_matricula        = f_matriculas.obtenerValor("sede")
											carrera_matricula     = f_matriculas.obtenerValor("carrera")
											jornada_matricula     = f_matriculas.obtenerValor("jornada")
											emat_matricula        = f_matriculas.obtenerValor("emat_ccod")
											estado_matricula      = f_matriculas.obtenerValor("estado")
											cargas_matricula      = f_matriculas.obtenerValor("cargas")
											aprobados_matricula   = f_matriculas.obtenerValor("aprobados")
											rendimiento_matricula = f_matriculas.obtenerValor("rendimiento")
											
											if cadena_rendimiento = "" then
											  cadena_rendimiento = rendimiento_matricula
											else
											  cadena_rendimiento = cadena_rendimiento&","&rendimiento_matricula
											end if
											
											letra = ""
											color_cuadro = "naranja"
											
											if emat_matricula="1" then
											   letra="c"
											   color_cuadro="celeste"
											elseif emat_matricula ="2" then
											   color_cuadro="amarillo"
											   letra ="a"
											elseif emat_matricula ="3" then
												color_cuadro="naranja"
												letra = ""
											elseif emat_matricula ="4" then	
											    color_cuadro="calipso"
												letra="i"
											elseif emat_matricula ="5" then
												color_cuadro="rojo"
												letra="r"
											elseif emat_matricula ="6" then
												color_cuadro="cafe"
												letra="f"
											elseif emat_matricula ="7" then
												color_cuadro="violeta"
												letra="t"
											elseif emat_matricula ="8" then
												color_cuadro="verde"
												letra="v"
											elseif emat_matricula ="9" then
												color_cuadro="rojo"
												letra="r"
											elseif emat_matricula ="10" then
												color_cuadro="amarillo"
												letra="a"
											elseif emat_matricula ="11" then
												color_cuadro="cafe"
												letra="f"
											elseif emat_matricula ="12" then
												color_cuadro="celeste"
												letra="c"
											elseif emat_matricula ="13" then
												color_cuadro="amarillo"
												letra="a"
											elseif emat_matricula ="14" then
												color_cuadro="rojo"
												letra="r"
											elseif emat_matricula ="15" then
												color_cuadro="violeta"
												letra="t"
											elseif emat_matricula ="16" then
												color_cuadro="celeste"
												letra="c"
											end if
											
											if distintos = 0 and cint(ano_matricula) = cint(ano_matricula2) then%>
												<td width="15%" align="center">
										  <%distintos = distintos + 1
										    elseif cint(ano_matricula) <> cint(ano_matricula2) then%>
												</td>
												<td width="1%">&nbsp;</td>
												<td width="15%" align="center">
												<%ano_matricula = ano_matricula2
												  distintos = distintos + 1
											end if%>
											<table width="98%" border="0" cellspacing="0" cellpadding="0">
											  <tr>
												<td width="10" height="10" class="t01<%=letra%>">&nbsp;</td>
												<td height="10" class="t02<%=letra%>">&nbsp;</td>
												<td width="10" height="10" class="t03<%=letra%>">&nbsp;</td>
											  </tr>
											  <tr>
												<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_<%=color_cuadro%>_04.jpg" width="10" height="98" /></td>
												<td align="center" valign="top" class="t05<%=letra%>">
													 <table width="99%" cellpadding="0" cellspacing="0">
														<tr>
															<td colspan="5" align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=peri_matricula%></strong></font></td>
														</tr>
														<tr>
															<td colspan="5" align="center"><font face="Times New Roman, Times, serif" size="1" color="#000000"><%=sede_matricula%><br><%=carrera_matricula%><br><%=jornada_matricula%></font></td>
														</tr>
														<tr>
															<td width="30%" align="center"><font face="Times New Roman, Times, serif" size="1" color="#000000">Cargas<br><%=cargas_matricula%></font></td>
															<td width="5%" align="center">&nbsp;</td>
															<td width="30%" align="center"><font face="Times New Roman, Times, serif" size="1" color="#000000">Aprobados<br><%=aprobados_matricula%></font></td>
															<td width="5%" align="center">&nbsp;</td>
															<td width="30%" align="center"><font face="Times New Roman, Times, serif" size="1" color="#990000">Rendimiento<br><%=rendimiento_matricula%>%</font></td>
														</tr>
														<tr>
															<td colspan="5" align="center"><font face="Times New Roman, Times, serif" size="2" color="#000000"><strong><%=estado_matricula%></strong></font></td>
														</tr>
													</table>
												</td>
												<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_<%=color_cuadro%>_06.jpg" width="10" height="98" /></td>
											  </tr>
											  <tr>
												<td width="10" height="17" class="t07">&nbsp;</td>
												<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
												<td width="10" height="17" class="t09">&nbsp;</td>
											  </tr>
											</table>
											<br>
										  <%wend
										   %>
										  </td>
										  <td width="1%">&nbsp;</td>
										  <%restantes = distintos
										  while restantes <= 6 %>
												<td  width="15%" align="center">
												 <font face="Times New Roman, Times, serif" size="2" color="#085fbc"><strong>&nbsp;</strong></font>
												</td>
												<td width="1%">&nbsp;</td>  
										  <% restantes = restantes + 1
										  wend
										  f_matriculas.primero%>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="3" align="right"><a href="#matriculas_sup"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
						</tr>
					  </table
					></td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_gris_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <tr>
		 	<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
			<td colspan="3" align="left">
			  <table id="rendimiento" width="98%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10" height="10" class="t01g">&nbsp;</td>
					<td height="10" class="t02g">&nbsp;</td>
					<td width="10" height="10" class="t03g">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="10" height="104" align="right" valign="top" class="t04"><img src="images/degradado_gris_04.jpg" width="10" height="98" /></td>
					<td align="left" valign="top" class="t05g">
					  <table width="100%" cellpadding="0" cellspacing="0">
						  <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>Gr&aacute;fica de Rendimiento</strong></font></td>
						  </tr>
					      <tr>
							<td colspan="3" align="left"><font face="Times New Roman, Times, serif" size="3" color="#085fbc"><strong>&nbsp;</strong></font></td>
						  </tr>
						  <tr>
							<td colspan="3" align="left">
							<% f_matriculas.primero
							   total_graficos = f_matriculas.nroFilas%>
							   <table width="100%" cellpadding="0" cellspacing="0">
							     <tr>
								     <%contador_celdas = 0
									   while f_matriculas.siguiente
									     aprobado = cdbl(f_matriculas.obtenerValor("rendimiento"))
										 peri_matricula2 = f_matriculas.obtenerValor("periodo")
										 carrera2 = f_matriculas.obtenerValor("carrera")
										 cargas2  = f_matriculas.obtenerValor("cargas")
										 reprobado = 100 - aprobado
										 contador_celdas = contador_celdas + 1 
										 if contador_celdas <= 5 then%>	
										   <td width="20%" align="center">
										      <table width="100%" cellpadding="0" cellspacing="0">
											  	<tr>
													<td colspan="2" align="center"><%=peri_matricula2%></td>
												</tr>
												<tr>
													<td colspan="2" align="center"><%=carrera2%></td>
												</tr>
												<tr>
													<td colspan="2" align="center">Carga del Semestre: <%=cargas2%> Ramos</td>
												</tr>
												<tr>
													<td colspan="2" align="center"><img src="http://admision.upacifico.cl/graficos/graphtorta.php?dat=<%=reprobado%>,<%=aprobado%>&bkg=FFFFFF" title="Con <%=cargas2%> (Ramos) el rendimiento del semestre es: <%=aprobado%>%"></td>
												</tr>
												<tr>
													<td width="50%" align="center">Aprobado: <%=aprobado%>%</td>
													<td width="50%" align="center">Reprobado: <%=reprobado%>%</td>
												</tr>
											  </table>
										   </td>
										<%else
										    contador_celdas = 1
										 %>
										 </tr>
										 <tr><td colspan="5">&nbsp;</td></tr>
										 <tr><td colspan="5"><hr color="#999999"></td></tr>
										 <tr><td colspan="5">&nbsp;</td></tr>
										 <tr>
										     <td width="20%" align="center">
										      <table width="100%" cellpadding="0" cellspacing="0">
											  	<tr>
													<td colspan="2" align="center"><%=peri_matricula2%></td>
												</tr>
												<tr>
													<td colspan="2" align="center"><%=carrera2%></td>
												</tr>
												<tr>
													<td colspan="2" align="center">Carga del Semestre: <%=cargas2%> Ramos</td>
												</tr>
												<tr>
													<td colspan="2" align="center"><img src="http://admision.upacifico.cl/graficos/graphtorta.php?dat=<%=reprobado%>,<%=aprobado%>&bkg=FFFFFF" title="Con <%=cargas2%> (Ramos) el rendimiento del semestre es: <%=aprobado%>%"></td>
												</tr>
												<tr>
													<td width="50%" align="center">Aprobado: <%=aprobado%>%</td>
													<td width="50%" align="center">Reprobado: <%=reprobado%>%</td>
												</tr>
											  </table>
										     </td>
									  <%end if
									 wend
									 if contador_celdas < 5 then%>
									 		<td colspan="<%=5-contador_celdas%>">&nbsp;</td>
								   <%end if%>
								 </tr>
							   </table>
							</td>
						  </tr>
						  <tr>
						  	<td colspan="3" align="right"><a href="#matriculas_sup"><img width="26" height="26" src="images/btn_arriba.png" border="0" title="Ir a menú superior"></a></td>
						  </tr>
					  </table>
					</td>
					<td width="10" align="left" valign="top" class="t06"><img src="images/degradado_gris_06.jpg" width="10" height="98" /></td>
				  </tr>
				  <tr>
					<td width="10" height="17" class="t07">&nbsp;</td>
					<td height="17" align="right" valign="top" class="t08"><img src="images/degradado_08.png" width="129" height="17" /></td>
					<td width="10" height="17" class="t09">&nbsp;</td>
				  </tr>
				</table>
			</td>
		 </tr>
		 <%end if'para cuando retorna registros%>
		 <tr>
		 	<td colspan="3">&nbsp;</td>
		 </tr>
		 <tr>
		 	<td colspan="3">&nbsp;</td>
		 </tr>
  </table>
  </div>	 
  <div id="props-panel" class="x-layout-inactive-content" style="width:200px;height:200px;overflow:hidden;">
  </div>
  <div id="south" class="x-layout-inactive-content">
    <table width="100%" height="100%" align="left" cellpadding="0" cellspacing="0" background="images/fondo_enc_pie.jpg">
		<tr valign="top">
			<td width="70" height="90" align="center"><a href="#" onclick="Example.toggleWest(this);return false;"><img width="60" height="60" src="images/btn_otros_reportes.png" border="0"></a></td>
			<td align="left"><font face="Times New Roman, Times, serif" size="2" color="#666666"><strong>--> Hist&oacute;rico de Notas<br>--> Notas Parciales<br>--> Curriculum Alumno<br>--> Historial de Bloqueos.</strong></font></td>
		</tr>
	</table>
  </div>
</div>
 </body>
</html>
