<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<% Server.ScriptTimeOut = 150000
 
' set conexion_directa = new CAlternativa
' conexion_directa.Inicializa 

q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
matr_ncorr = Request.QueryString("enca[0][carreras_alumno]")
'response.Write(matr_ncorr)
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Bienvenido a Toma de Asignaturas (Online)"

set errores = new CErrores
'conexion a servidor de alumnos consultas generales
'set conexion2 = new CConexion
'conexion2.Inicializar "upacifico"

'conexión a servidor de producción consultas que requieran actualización al minuto
set conexion = new CConexion
conexion.Inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "inicio_toma_carga_alfa.xml", "botonera"

set botonera = new CFormulario
botonera.Carga_Parametros "toma_carga_alfa.xml", "BotoneraTomaCarga"
periodo_defecto = "228"

if esVacio(q_pers_nrut) then
	q_pers_nrut = negocio.obtenerUsuario
end if


set f_datos = new CFormulario
f_datos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_datos.Inicializar conexion

c_datos = " select tabla_a.*, " & vbCrLf &_
		  " case when total_matriculas = 0 then '' " & vbCrLf &_
		  " else cast((   select top 1 matr_ncorr  " & vbCrLf &_
		  "         from alumnos a1, ofertas_academicas b1  " & vbCrLf &_
		  "         where a1.pers_ncorr=tabla_a.pers_ncorr and a1.ofer_ncorr = b1.ofer_ncorr  " & vbCrLf &_
		  "         and b1.peri_ccod = tabla_a.periodo and a1.emat_ccod in (1) " & vbCrLf &_
		  "      )as varchar)  " & vbCrLf &_
		  " end as matr_ncorr,  " & vbCrLf &_
		  " case when total_matriculas = 0 then '' " & vbCrLf &_
		  " else cast((   select top 1 sede_ccod  " & vbCrLf &_
		  "         from alumnos a1, ofertas_academicas b1  " & vbCrLf &_
		  "         where a1.pers_ncorr=tabla_a.pers_ncorr and a1.ofer_ncorr = b1.ofer_ncorr  " & vbCrLf &_
		  "         and b1.peri_ccod = tabla_a.periodo and a1.emat_ccod in (1) " & vbCrLf &_
		  "      ) as varchar)  " & vbCrLf &_
		  " end as sede_ccod,  " & vbCrLf &_
		  " case when total_matriculas = 0 then '' " & vbCrLf &_
		  " else (   select top 1 ltrim(rtrim(carr_ccod))  " & vbCrLf &_
		  "         from alumnos a1, ofertas_academicas b1,especialidades c1  " & vbCrLf &_
		  "         where a1.pers_ncorr=tabla_a.pers_ncorr and a1.ofer_ncorr = b1.ofer_ncorr and b1.espe_ccod=c1.espe_ccod " & vbCrLf &_
		  "         and b1.peri_ccod = tabla_a.periodo and a1.emat_ccod in (1) " & vbCrLf &_
		  "      )  " & vbCrLf &_
		  " end as carr_ccod, " & vbCrLf &_
		  " case when total_matriculas = 0 then '' " & vbCrLf &_
		  " else cast((   select top 1 jorn_ccod " & vbCrLf &_
		  "         from alumnos a1, ofertas_academicas b1  " & vbCrLf &_
		  "         where a1.pers_ncorr=tabla_a.pers_ncorr and a1.ofer_ncorr = b1.ofer_ncorr  " & vbCrLf &_
		  "         and b1.peri_ccod = tabla_a.periodo and a1.emat_ccod in (1) " & vbCrLf &_
		  "      )as varchar)  " & vbCrLf &_
		  " end as jorn_ccod, " & vbCrLf &_
		  " case when total_matriculas = 0 then '' " & vbCrLf &_
		  " else (   select top 1 carr_tdesc + ' -- ' + espe_tdesc  " & vbCrLf &_
		  "         from alumnos a1, ofertas_academicas b1,especialidades c1, carreras d1  " & vbCrLf &_
		  "         where a1.pers_ncorr=tabla_a.pers_ncorr and a1.ofer_ncorr = b1.ofer_ncorr " & vbCrLf &_
		  "         and b1.espe_ccod=c1.espe_ccod and c1.carr_ccod=d1.carr_ccod  " & vbCrLf &_
		  "         and b1.peri_ccod = tabla_a.periodo and a1.emat_ccod in (1) " & vbCrLf &_
		  "      )  " & vbCrLf &_
		  " end as carrera, " & vbCrLf &_
		  " case when total_matriculas = 0 then '' " & vbCrLf &_
		  " else cast((   select top 1 plan_ccod  " & vbCrLf &_
		  "         from alumnos a1, ofertas_academicas b1  " & vbCrLf &_
		  "         where a1.pers_ncorr=tabla_a.pers_ncorr and a1.ofer_ncorr = b1.ofer_ncorr  " & vbCrLf &_
		  "         and b1.peri_ccod = tabla_a.periodo and a1.emat_ccod in (1) " & vbCrLf &_
		  "      )as varchar)  " & vbCrLf &_
		  " end as plan_ccod, " & vbCrLf &_
		  " case when total_matriculas = 0 then '' " & vbCrLf &_
		  " else (  select top 1 post_bnuevo " & vbCrLf &_
		  "         from alumnos a1, ofertas_academicas b1  " & vbCrLf &_
		  "         where a1.pers_ncorr=tabla_a.pers_ncorr and a1.ofer_ncorr = b1.ofer_ncorr  " & vbCrLf &_
		  "         and b1.peri_ccod = tabla_a.periodo and a1.emat_ccod in (1) " & vbCrLf &_
		  "      ) " & vbCrLf &_
		  " end as post_bnuevo, " & vbCrLf &_
		  " case when total_matriculas = 0 then '' " & vbCrLf &_
		  " else cast((   select top 1 isnull(plan_tcreditos,0)  " & vbCrLf &_
		  "         from alumnos a1, ofertas_academicas b1,planes_estudio c1  " & vbCrLf &_
		  "         where a1.pers_ncorr=tabla_a.pers_ncorr and a1.ofer_ncorr = b1.ofer_ncorr  " & vbCrLf &_
		  "         and a1.plan_ccod=c1.plan_ccod " & vbCrLf &_
		  "         and b1.peri_ccod = tabla_a.periodo and a1.emat_ccod in (1) " & vbCrLf &_
		  "      )as varchar)  " & vbCrLf &_
		  " end as tipo_plan " & vbCrLf &_     
		  " from " & vbCrLf &_
		  " ( " & vbCrLf &_
		  "    select a.pers_ncorr,a.pers_nrut, a.pers_xdv,cast(pers_nrut as varchar)+ '-'+pers_xdv as rut, " & vbCrLf &_
		  "    pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno as nombre, " & vbCrLf &_
		  "    b.peri_ccod as periodo,b.peri_tdesc, b.anos_ccod, " & vbCrLf &_
		  "    (select bb.peri_ccod from periodos_academicos bb where bb.anos_ccod=b.anos_ccod and bb.plec_ccod=1) as primer_semestre,  " & vbCrLf &_
		  "    (select bb.peri_ccod from periodos_academicos bb where bb.anos_ccod=b.anos_ccod and bb.plec_ccod=2) as segundo_semestre, " & vbCrLf &_
	      "    (select count(*) from bloqueos tt where tt.eblo_ccod=1 and tt.pers_ncorr = a.pers_ncorr) as  cantidad_bloqueos, " & vbCrLf &_
		  "    (select protic.initcap(tblo_tdesc) from bloqueos aa, tipos_bloqueos ba where aa.tblo_ccod=ba.tblo_ccod and aa.eblo_ccod=1 and aa.pers_ncorr = a.pers_ncorr) as tipo_bloqueo, " & vbCrLf &_
		  "    (select count(*) from alumnos aa, ofertas_academicas bb " & vbCrLf &_
		  "     where aa.ofer_ncorr=bb.ofer_ncorr and aa.pers_ncorr=a.pers_ncorr " & vbCrLf &_
		  "     and bb.peri_ccod=b.peri_ccod and aa.emat_ccod=1) as total_matriculas " & vbCrLf &_
		  "    from personas a, periodos_academicos b " & vbCrLf &_
		  "    where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' and cast(b.peri_ccod as varchar)='"&periodo_defecto&"' " & vbCrLf &_
		  " )tabla_a "

f_datos.Consultar c_datos
f_datos.siguiente


pers_ncorr_temporal = f_datos.obtenerValor("pers_ncorr")
q_pers_xdv = f_datos.obtenerValor("pers_xdv")
anos_ccod = f_datos.obtenerValor("anos_ccod")
primer_semestre = f_datos.obtenerValor("primer_semestre")
segundo_semestre= f_datos.obtenerValor("segundo_semestre")
v_peri_ccod = periodo_defecto
'response.Write(pers_ncorr_temporal)
'response.End()
if pers_ncorr_temporal <> "" then
	sede_ccod = f_datos.obtenerValor("sede_ccod")
	tiene_bloqueos = conexion.consultaUno("select count(*) from bloqueos where eblo_ccod=1 and cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
	tipo_bloqueo = conexion.consultaUno("select protic.initcap(tblo_tdesc) from bloqueos a, tipos_bloqueos b where a.tblo_ccod=b.tblo_ccod and eblo_ccod=1 and cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
    es_moroso = "N"'conexion.ConsultaUno("select protic.es_Moroso("&pers_ncorr_temporal&",getDate())")
	peri_tdesc = f_datos.obtenerValor("peri_tdesc")
	rut = f_datos.obtenerValor("rut")
	nombre = f_datos.obtenerValor("nombre")
	matr_ncorr = f_datos.obtenerValor("matr_ncorr")
	carrera = f_datos.obtenerValor("carrera")
	carr_ccod = f_datos.obtenerValor("carr_ccod")
	plan_ccod = f_datos.obtenerValor("plan_ccod")
	tipo_plan = f_datos.obtenerValor("tipo_plan")
	estado_produccion = ""
	if matr_ncorr <> "" then
		'vemos estado de matrícula en producción.-
		estado_produccion = conexion.consultaUno("Select emat_ccod from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
	end if
	if len(matr_ncorr)=0 or estado_produccion <> "1" then
		consulta_matr = " Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
				        " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and emat_ccod in (1) "&_
				        " and cast(c.peri_ccod as varchar)='"&periodo_defecto&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
		matr_ncorr= conexion.consultaUno(consulta_matr)	
		carrera = conexion.consultaUno("select carr_tdesc + ' -- ' + c.espe_tdesc from alumnos a, ofertas_academicas b, especialidades c, carreras d where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod")
		carr_ccod = conexion.consultaUno("Select ltrim(rtrim(carr_ccod)) from alumnos a, ofertas_Academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( matr_ncorr as varchar)='"&matr_ncorr&"'")
		plan_ccod = conexion.consultaUno("Select plan_ccod from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
	end if
end if
sede_ccod = conexion.consultaUno("Select ltrim(rtrim(sede_ccod)) from alumnos a, ofertas_Academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
ano_ingreso = conexion.consultaUno("select isnull(protic.ano_ingreso_carrera (pers_ncorr,'"&carr_ccod&"'),2010) from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")		
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
v_anio_actual	= 	Year(now())
habilitar_toma = "N"
pers_ncorr=pers_ncorr_temporal
'RESPONSE.Write(carr_ccod)
		 facu_ccod    = conexion.consultaUno("select facu_ccod from carreras a, areas_academicas b where a.area_ccod=b.area_ccod and a.carr_ccod='"&carr_ccod&"'")
		 if facu_ccod="1" then
		     if v_mes_actual=1 and v_dia_actual>=15 and v_dia_actual <=18 then
				habilitar_toma="S"
			 end if
	     elseif facu_ccod = "2" then 	
			 if v_mes_actual=1 and v_dia_actual>=15 and v_dia_actual <=18 and carr_ccod="16" then
				habilitar_toma="S"
			 elseif v_mes_actual=1 and v_dia_actual>=15 and v_dia_actual <=16 and carr_ccod="21" and cdbl(ano_ingreso) <=2006 then
				habilitar_toma="S"
			 elseif v_mes_actual=1 and v_dia_actual>=17 and v_dia_actual <=18 and carr_ccod="21" and cdbl(ano_ingreso) =2007 then
				habilitar_toma="S"
			 elseif v_mes_actual=1 and v_dia_actual>=19 and v_dia_actual <=20 and carr_ccod="21" and cdbl(ano_ingreso) =2008 then
				habilitar_toma="S"				
			 end if
		elseif facu_ccod = "4" then
			 if v_mes_actual=1 and v_dia_actual>=19 and v_dia_actual <=23 then
				habilitar_toma="S"
			 end if
		elseif facu_ccod = "3" then
			 if v_mes_actual=1 and v_dia_actual>=27 and v_dia_actual <=28 and carr_ccod="45" and cdbl(ano_ingreso) <=2006 then
				habilitar_toma="S"
			 elseif v_mes_actual=1 and v_dia_actual>=29 and v_dia_actual <=30 and carr_ccod="45" and cdbl(ano_ingreso) =2007 then
				habilitar_toma="S"
			 elseif v_mes_actual=1 and v_dia_actual=31 and carr_ccod="45" and cdbl(ano_ingreso) =2008 then
				habilitar_toma="S"
			 elseif v_mes_actual=2 and v_dia_actual=1 and carr_ccod="45" and cdbl(ano_ingreso) =2008 then
				habilitar_toma="S"
			 elseif v_mes_actual=1 and v_dia_actual>= 24 and v_dia_actual <= 26 and carr_ccod <> "45" then
				habilitar_toma="S"					
			 end if
		end if
		if v_mes_actual=2 and v_dia_actual>= 2 and v_dia_actual <= 28 then
				habilitar_toma="S"					
		end if
		
'response.Write(habilitar)
'pers_ncorr_temporal = conexion.consultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo_defecto&"'")
'primer_semestre = conexion.consultaUno("Select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=1")
'segundo_semestre = conexion.consultaUno("Select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=2")


'if pers_ncorr_temporal <> "" then
'    sede_ccod = conexion.consultaUno("select sede_ccod from alumnos a, ofertas_academicas b where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.ofer_ncorr = b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&periodo_defecto&"' and emat_ccod in (1)")
'	es_moroso = conexion.ConsultaUnoDirecta("select protic.es_Moroso("&pers_ncorr_temporal&",getDate())")
'	tiene_bloqueos = conexion.consultaUno("select count(*) from bloqueos where eblo_ccod=1 and cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
'	tipo_bloqueo = conexion.consultaUno("select protic.initcap(tblo_tdesc) from bloqueos a, tipos_bloqueos b where a.tblo_ccod=b.tblo_ccod and eblo_ccod=1 and cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
'	'v_plec_ccod = conexion.ConsultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar) = '" & v_peri_ccod & "'")
'	'if v_plec_ccod = "2" and es_moroso <> "S" and sede_ccod <> "" and tiene_bloqueos = "0" then
'	'	sentencia = "exec CREAR_MATRICULA_SEG_SEMESTRE_VERSION_2 '" & sede_ccod & "', '" & q_pers_nrut & "', '" & v_peri_ccod& "'"
'	'	conexion.EjecutaPsql(sentencia)
'	'end if
'	'if v_plec_ccod = "3" and es_moroso <> "S" and sede_ccod <> "" and tiene_bloqueos = "0" then
'	'	sentencia = "exec CREAR_MATRICULA_TER_TRIMESTRE_VERSION_2 '" & sede_ccod & "', '" & q_pers_nrut & "', '" & v_peri_ccod& "'"
'	'	conexion.EjecutaPsql(sentencia)
'	'end if
'	peri_tdesc= conexion.consultaUno("Select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo_defecto&"'")
'	rut = conexion.consultaUno("select cast(pers_nrut as varchar)+ '-'+pers_xdv from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'	nombre = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'	matr_ncorr = ""
'	consulta_matr=" Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
'				  " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and emat_ccod in (1) "&_
'				  " and cast(c.peri_ccod as varchar)='"&periodo_defecto&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
								
'	matr_ncorr= conexion.consultaUno(consulta_matr)	
'	carrera = conexion.consultaUno("select carr_tdesc + ' -- ' + c.espe_tdesc from alumnos a, ofertas_academicas b, especialidades c, carreras d where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod")
'	carr_ccod = conexion.consultaUno("Select ltrim(rtrim(carr_ccod)) from alumnos a, ofertas_Academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( matr_ncorr as varchar)='"&matr_ncorr&"'")
'	plan_ccod = conexion.consultaUno("Select plan_ccod from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
'end if




set f_alumno = new CFormulario
f_alumno.Carga_Parametros "inicio_toma_carga_alfa.xml", "carga_tomada"
f_alumno.Inicializar conexion

consulta = " select c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
		   " protic.horario_con_sala(b.secc_ccod) as horario, case acse_ncorr when 3 then 'Carga sin Pre-requisitos' else case a.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, "& vbCrLf &_
		   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
           "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
		   " from cargas_Academicas a, secciones b, asignaturas c " & vbCrLf &_
		   " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
		   " and a.secc_ccod=b.secc_ccod " & vbCrLf &_
		   " and not exists (Select 1 from equivalencias eq where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod " & vbCrLf &_
		   " union all " & vbCrLf &_
		   " select c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
		   " protic.horario_con_sala(b.secc_ccod) as horario,case isnull(acse_ncorr,0) when 0 then 'Equivalencia' else 'Carga Extraordinaria' end as tipo, " & vbCrLf &_
		   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
           "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
		   " from equivalencias a, secciones b, asignaturas c,cargas_academicas ca " & vbCrLf &_
		   " where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
		   " and a.secc_ccod=b.secc_ccod  and a.matr_ncorr=ca.matr_ncorr and a.secc_ccod = ca.secc_ccod" & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod "
'response.Write("<pre>"&consulta&"</pre>")
f_alumno.Consultar consulta

if matr_ncorr <> "" then
'	tipo_plan = conexion.consultaUno("select isnull(plan_tcreditos,0) from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")
	if tipo_plan = "0" then
		mensaje_plan = "Esta cursando un plan de estudios basado en Sesiones."
	else
		mensaje_plan = "Esta cursando un plan de estudios basado en Créditos."
	end if		
	con_encuesta="1"
end if
  
session("pers_ncorr_alumno") = pers_ncorr_temporal
session("matr_ncorr") = matr_ncorr
suma_creditos=0.0
if tipo_plan <> "0" then
	while f_alumno.siguiente 
			suma_creditos= suma_creditos + cdbl(f_alumno.obtenerValor("creditos"))
	wend
	f_alumno.primero
end if

if tipo_plan <> "0" and matr_ncorr <> "" then
	suma_creditos = conexion.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
end if

url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&ocultar=1"

'----------------------debemos ver si el alumno esta bien encasillado con el plan de estudios y la especialidad
'-----------------------------agregado por Marcelo Sandoval-----------------------------------------
especialidad_plan = conexion.consultaUno("select b.espe_ccod from alumnos a, planes_estudio b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.plan_ccod=b.plan_ccod")
especialidad_oferta = conexion.consultaUno("select b.espe_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr")
if especialidad_plan <> especialidad_oferta and matr_ncorr <> "" then 
	mensaje_distintos = "Presenta Problemas por mala asignación de plan de estudios, comuniquese con la Dirección de su Escuela para solucionarlo."
end if	

cerrar_carga_diurno = false

'debemos ver si el alumno completo toda la evaluacion docente del año 2007------------------------
if matr_ncorr <> "" then
c_encuestas = "select cantidad_carga - con_evaluacion_docente as diferencia "& vbCrLf &_
			  " from "& vbCrLf &_
		  	  " ( "& vbCrLf &_
			  " select cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut, d.pers_tnombre + ' ' + d.pers_tape_paterno + ' ' + d.pers_tape_materno as alumno, "& vbCrLf &_
			  " (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc "& vbCrLf &_
			  " where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr "& vbCrLf &_
			  " and bb.peri_ccod in (212,213) "& vbCrLf &_
			  " and not exists (select 1 from secciones sec,convalidaciones conv "& vbCrLf &_
              " where sec.secc_ccod=cc.secc_ccod and cc.matr_ncorr=conv.matr_ncorr and sec.asig_ccod=conv.asig_ccod) "& vbCrLf &_
			  " and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc "& vbCrLf &_
			  "             where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod  "& vbCrLf &_
			  "             and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1 "& vbCrLf &_
			  "             and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'17-11-2008',103))) as cantidad_carga, "& vbCrLf &_
			  " (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc "& vbCrLf &_
			  " where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr "& vbCrLf &_
			  " and bb.peri_ccod in (212,213) "& vbCrLf &_
			  " and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc "& vbCrLf &_
			  "             where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod  "& vbCrLf &_
			  "             and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1 "& vbCrLf &_
			  "             and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'17-11-2008',103)) "& vbCrLf &_
			  " and exists (select 1 from cuestionario_opinion_alumnos ffff where ffff.pers_ncorr=aa.pers_ncorr  "& vbCrLf &_
			  "             and ffff.secc_ccod=cc.secc_ccod "& vbCrLf &_
			  "             union "& vbCrLf &_
              "             select 1 from evaluacion_docente ffff where ffff.pers_ncorr_encuestado=aa.pers_ncorr  "& vbCrLf &_
              "             and ffff.secc_ccod=cc.secc_ccod)) as con_evaluacion_docente               "& vbCrLf &_
			  " from alumnos a, ofertas_academicas b, especialidades c,personas d "& vbCrLf &_
			  " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "& vbCrLf &_
			  " and c.carr_ccod='"&carr_ccod&"' and cast(b.peri_ccod as varchar)='"&periodo_defecto&"' "& vbCrLf &_
			  " and a.emat_ccod <> 9 and a.alum_nmatricula <> '7777' "& vbCrLf &_
			  " and a.pers_ncorr = d.pers_ncorr "& vbCrLf &_
			  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'"& vbCrLf &_
			  " ) tabla_1"
              'response.Write("<pre>"&c_encuestas&"</pre>")
			  'response.Write("<pre>"&pers_ncorr_temporal&"</pre>")
			  '  response.Write("<pre>"&q_pers_nrut&"</pre>")
              diferencia_encuestas = conexion.consultaUno(c_encuestas)
			  mensaje_encuesta = ""
			  if diferencia_encuestas > "0" then 
			  	mensaje_encuesta = "Resta(n) "&diferencia_encuestas&" encuesta(s) por evaluar"
			  end if
			  
			  if q_pers_nrut="15482098" or q_pers_nrut="15774250" or q_pers_nrut="16017870" or q_pers_nrut="16096437" or q_pers_nrut="16097423" or q_pers_nrut="16098917" then
				mensaje_encuesta = ""
			  end if
			  if q_pers_nrut="16099227" or q_pers_nrut="16205595" or q_pers_nrut="16207638" or q_pers_nrut="16209412" or q_pers_nrut="16212795" or q_pers_nrut="16366178" then
			     mensaje_encuesta = ""
			  end if
 			  if q_pers_nrut="16366588" or q_pers_nrut="16592080" or q_pers_nrut="16606471" or q_pers_nrut="16639500" or q_pers_nrut="16657125" or q_pers_nrut="16935727" or q_pers_nrut="17061070" or q_pers_nrut="17202140" then 
			     mensaje_encuesta = ""
			  end if
			  cumple_fecha_matricula = conexion.consultaUno("select case when convert(datetime,protic.trunc(alum_fmatricula),103) <= convert(datetime,'25-12-2007',103) then 'S' else 'N' end from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
			  
			  mensaje_convocatoria = ""
			  'response.Write(carr_ccod)
			 ' if carr_ccod ="830" or carr_ccod ="850" or carr_ccod ="880" or carr_ccod ="870" or carr_ccod ="940" or carr_ccod ="950" or carr_ccod = "860" then
			  '	mensaje_convocatoria = "La toma de carga para alumnos de tu carrera debe ser a través de tu coordinacion de escuela."
			  'end if
			  
			  email_escuela = conexion.consultaUno("select email from sd_email_carrera where cod_carrera='"&carr_ccod&"'")
			  c_bloqueo_notas = " select case count(*) when 0 then 'Libre' else 'Bloqueado' end  "& vbCrLf &_
			  					" from causal_eliminacion where cast(rut as varchar)='"&q_pers_nrut&"' "

              bloqueo_notas = conexion.consultaUno(c_bloqueo_notas)  
			  mensaje_bloqueo_notas = ""
			  if bloqueo_notas = "Bloqueado" then
			  	 mensaje_bloqueo_notas = "El alumno presenta un bloqueo académico en el sistema, lo que inpide la toma de carga, haga el favor de comunicarse con su escuela para solucionar la situación."
			  end if
end if

if matr_ncorr = "" then
	consulta_no_activa = "Select protic.initCap(emat_tdesc) from alumnos a, ofertas_academicas b, estados_matriculas c where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr  and a.emat_ccod = c.emat_ccod and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"' and a.emat_ccod <> 1"
	no_activa= conexion.consultaUno(consulta_no_activa)
	if not Esvacio(no_activa) and no_activa <> "" then
				mensaje = "No presenta matricula activa en el sistema, su última matricula esta en estado "& no_activa
	else
				mensaje = "No presenta matricula activa para este periodo."	
	end if
	
end if	
es_nuevo = conexion.consultaUno("Select post_bnuevo from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
'response.Write(es_nuevo)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Toma de Carga Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa toma de carga online permite al alumno adelantar este proceso ajustando su carga horaria a los días que más le acomoden. Para ello: \n\n" +
	       	  "- Hacer click en el botón para inscribir carga.\n"+
			  "- Seleccionar carga del plan de estudios,formación profecional electiva y/o carga de optativos deportivos y DAE.\n"+
			  "- Dejar una copia impresa de su horario y carga asignada para el periodo.";
		   
	alert(mensaje);
}

function horario(){
	self.open('horario_alumno.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function imprimir() {
  var direccion;
  direccion="impresion_carga.asp";
  window.open(direccion ,"ventana1","width=520,height=540,scrollbars=yes, left=313, top=200");
}
function tomar_carga(valor)
{
	var formulario = document.edicion;
	if (valor==2)
	 { formulario.submit();}
	else
	 { alert("Imposible tomar carga, debe regularizar lo expuesto en lista superior con íconos 'rojos'");} 
}
</script>
<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong><%pagina.Titulo = "Toma de Asignaturas Online <br>(" &peri_tdesc&")"
			    pagina.DibujarTituloPagina%></strong></font></td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<!--Antecedentes educacionales-->
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
						<form name="edicion" action="toma_carga_nuevo.asp">
						<input type="hidden" name="busqueda[0][pers_nrut]" value="<%=q_pers_nrut%>">
						<input type="hidden" name="busqueda[0][pers_xdv]" value="<%=q_pers_xdv%>">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="33%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Solicitud de Certificados</strong></font></td>
										   <td><hr></td>
										   <TD width="10%">
										   		<%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?"> 
												</a>
											</TD>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Rut</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=rut%></font></td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=nombre%></font></td>
									  </tr>
									  <tr valign="top"> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carrera</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=carrera%></font></td>
									  </tr>
									  <tr>
									  	<td colspan="4">&nbsp;</td>
									  </tr>
									  <%if matr_ncorr <> "" then %>
									  <tr>
									  	<td colspan="4">
											<table width="100%">
												<tr>
												   <td width="38%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Carga Académica Registrada</strong></font></td>
												   <td><hr></td>
												</tr>
											</table>
										</td>
									  </tr>
									  <tr>
									  	<td colspan="4"><div align="right">Pagina <%f_alumno.accesoPagina%></div></td>
									  </tr>
									  <tr>
									  	<td colspan="4"><table width="95%" align="center"><tr><td><div align="center"><%f_alumno.DibujaTabla%></div></td></tr></table></td>
									  </tr>
									  <%end if%>
									  <tr>
									  	<td colspan="4">&nbsp;</td>
									  </tr>
									  <%if mensaje_plan <> "" then%>
									  <tr>
										<td colspan="4" align="center"><font  size="2"color="#0000FF"><strong><%=mensaje_plan%></strong></font>
										</td>
									  </tr>
									  <%end if%>
									  <tr>
									  	<td colspan="4">&nbsp;</td>
									  </tr>
									  <tr>
									  <td colspan="4" align="center">
											<table width="90%" border="2" align="center">
												<tr>
													<td align="center" bgcolor="#c4d7ff">
																	   <%if email_escuela <> "" then %>
																		Si presentas problemas en la toma de carga, comunicate con tu escuela en <b><%=email_escuela%></b>
																	   <%end if%>
													</td>
												</tr>
    											<tr>
													<td align="left">
													  <table width="100%" cellpadding="0" cellspacing="0" border="0">
														 	<tr>
														        <%if tipo_plan <> "0" and (cdbl(suma_creditos) < 9 or cdbl(suma_creditos) > 27) and f_alumno.nroFilas > 0 then 
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/nones.png"></td>
																    <td align="left">- El total de Cr&eacute;ditos Asignados (<%=suma_creditos%>), esta fuera del rango permitido (9-27).</td>
																<%else
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/okey.png"></td>
																    <td align="left">- El Total de créditos se encuentra dentro del rango permitido.</td>
																<%end if%>
															</tr>
													  </table>			
													</td>
												  </tr>
												  <tr>
													<td align="left">
														<table width="100%" cellpadding="0" cellspacing="0" border="0">
														 	<tr>
														        <%if mensaje <> "" and q_pers_nrut <> ""  then 
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/nones.png"></td>
																    <td align="left">Se ha detectado que : <%=mensaje%>.</td>
																<%else
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/okey.png"></td>
																    <td align="left">- Alumno matriculado para el periodo consultado.</td>
																<%end if%>
															</tr>
													  </table>
													</td>
												  </tr>
												  <tr>
													<td align="left">
														<table width="100%" cellpadding="0" cellspacing="0" border="0">
														 	<tr>
																<%if es_moroso = "S" and q_pers_nrut <> ""  then 
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/nones.png"></td>
																    <td align="left">- Se ha detectado que presenta una morosidad en su cuenta corriente, su deuda debe estar saldada para poder hacer la toma de ramos (Contáctese con departamento de cobranzas).</td>
																<%else
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/okey.png"></td>
																    <td align="left">- Situación financiera al día</td>
																<%end if%>
															</tr>
														 </table>
													</td>
												  </tr>
												 <tr>
													<td align="left">
													     <table width="100%" cellpadding="0" cellspacing="0" border="0">
														 	<tr>
																<%if mensaje_encuesta<> "" then 
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/nones.png"></td>
																    <td align="left">- <%=mensaje_encuesta%></td>
																<%else
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/okey.png"></td>
																    <td align="left">- Evaluación docente completada</td>
																<%end if%>
															</tr>
														 </table>
													</td>
												  </tr>
												  <tr>
													<td align="left">
														<table width="100%" cellpadding="0" cellspacing="0" border="0">
														 	<tr>
																<%if mensaje_distintos <> "" and q_pers_nrut <> ""  then
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/nones.png"></td>
																    <td align="left">- <%=mensaje_distintos%></td>
																<%else
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/okey.png"></td>
																    <td align="left">- El alumno se encuentra bien encasillado en la carrera.</td>
																<%end if%>
															</tr>
														 </table>
													 </td>
												  </tr>
												  <tr>
													<td align="left">
														<table width="100%" cellpadding="0" cellspacing="0" border="0">
														 	<tr>
																<%if tiene_bloqueos <>"0" then
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/nones.png"></td>
																    <td align="left">- Se ha detectado que presenta un bloqueo del  tipo: <%=tipo_bloqueo%></td>
																<%else
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/okey.png"></td>
																    <td align="left">- No presenta bloqueos académicos ni financieros.</td>
																<%end if%>
															</tr>
														 </table>
													</td>
												  </tr>
												  <tr>
													<td align="left">
														<table width="100%" cellpadding="0" cellspacing="0" border="0">
														 	<tr>
																<%if mensaje_bloqueo_notas <> "" then
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/nones.png"></td>
																    <td align="left">- <%=mensaje_bloqueo_notas%></td>
																<%else
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/okey.png"></td>
																    <td align="left">- No presenta bloqueos de notas.</td>
																<%end if%>
															</tr>
														 </table>
													</td>
												  </tr>
												  <tr>
													<td align="left">
														<table width="100%" cellpadding="0" cellspacing="0" border="0">
														 	<tr>
																<%if habilitar_toma = "N" then
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/nones.png"></td>
																    <td align="left">- La fecha actual no corresponde con la asignada a tu toma de carga.</td>
																<%else
																  POS_IMAGEN = POS_IMAGEN + 1%>
																	<td width="20"><img width="20" height="20" border="0" src="imagenes/okey.png"></td>
																    <td align="left">- Fecha activa para toma de carga.</td>
																<%end if%>
															</tr>
														 </table>
													</td>
												  </tr>
											</table>
									</td>
								  </tr>
								  <tr>
									<td colspan="4">&nbsp;
									</td>
								  </tr>
                                  <tr>
								     <td height="20" colspan="4">&nbsp;</td></tr>
									  <tr>
									      <td height="20" colspan="4" align="center">
									        <table width="60%" cellpadding="0" cellspacing="0">
												<tr valign="middle">
												    <td width="25%" align="center">
													         <%  deshabilitado = false
															     if cerrar_carga_diurno then
																     'RESPONSE.Write("1")
																	 deshabilitado = true     
																 end if
																 if matr_ncorr = "" or mensaje_distintos <> "" then
																 	'RESPONSE.Write("2")
																	 deshabilitado = true  
																 end if 
																 if  mensaje_encuesta <> "" then 
																 	'RESPONSE.Write("3")
																	 deshabilitado = true  
																 end if
																 if es_moroso ="S" then
																 	'RESPONSE.Write("4")
																	 deshabilitado = true  
																 end if
																 if tiene_bloqueos <> "0" then
																 	'RESPONSE.Write("5")
																	 deshabilitado = true  
																 end if
																 if mensaje_bloqueo_notas <> "" then
																 	'RESPONSE.Write("6")
																	 deshabilitado = true  
																 end if
																 if mensaje_convocatoria <> "" then
																 	'RESPONSE.Write("7")
																	 deshabilitado = true  
																 end if
																 'if es_nuevo = "S" then
																     'RESPONSE.Write("8")
																 '	 deshabilitado = true  
																 'end if
																 'RESPONSE.Write(habilitar_toma)
																 if habilitar_toma ="N" then ' en caso de no cumplir con las fechas
																 'RESPONSE.Write("9")
																 	 deshabilitado = true	
																 end if
																 %>
													        <%if deshabilitado then%>
																<%POS_IMAGEN = POS_IMAGEN + 1%>
																<a href="javascript:tomar_carga(1);"
																	onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGA_CARGA2.png';return true "
																	onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGA_CARGA1.png';return true ">
																	<img src="imagenes/AGREGA_CARGA1.png" border="0" width="70" height="70" alt="Agregar Carga Horaria"> 
																</a>
															<%else%>
																<%POS_IMAGEN = POS_IMAGEN + 1%>
																<a href="javascript:tomar_carga(2);"
																	onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGA_CARGA2.png';return true "
																	onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGA_CARGA1.png';return true ">
																	<img src="imagenes/AGREGA_CARGA1.png" border="0" width="70" height="70" alt="Agregar Carga Horaria"> 
																</a>	
															<%end if%>&nbsp;
													</td>
													<td width="25%" align="center">
														<%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:horario();"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/HORARIO2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/HORARIO1.png';return true ">
																<img src="imagenes/HORARIO1.png" border="0" width="70" height="70" alt="IMPRIMIR HORARIO DE CLASES"> 
															</a>
													</td>
													<td width="25%" align="center">
															<%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:imprimir();"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IMPRIMIR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IMPRIMIR1.png';return true ">
																<img src="imagenes/IMPRIMIR1.png" border="0" width="70" height="70" alt="Imprimir carga horaria"> 
															</a>
													</td>
													<td width="25%" align="center">
													       <%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
																<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
															</a>
													</td>
												</tr>
											</table>
									      </td>
									  </tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
                             
								  </table>
                  
								</td>
							</tr>
						 </form>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
</table>
</center>
</body>
</html>

