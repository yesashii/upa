<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Detalle Evaluación Asignatura"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------
secc_ccod = request.querystring("secc_ccod")

Periodo = negocio.ObtenerPeriodoAcademico("TOMACARGA")
'Sede = negocio.ObtenerSede()
'sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='" & Sede & "'")
'-------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "listado_evaluaciones.xml", "botonera"
'-------------------------------------------------------------------------------
asignatura = conexion.consultaUno ("select ltrim(rtrim(asig_ccod)) from secciones where cast(secc_ccod as varchar)='" & secc_ccod & "'" )
carrera = conexion.consultaUno ("select ltrim(rtrim(cast(carr_ccod as varchar))) from secciones where cast(secc_ccod as varchar)='" & secc_ccod & "'" )
jornada = conexion.consultaUno ("select jorn_ccod from secciones where cast(secc_ccod as varchar)='" & secc_ccod & "'" )
sede = conexion.consultaUno ("select sede_ccod from secciones where cast(secc_ccod as varchar)='" & secc_ccod & "'" )
sede_tdesc = conexion.consultaUno ("select sede_tdesc from sedes where cast(sede_ccod as varchar)='" & sede & "'" )

'-----------------------si la asignatura es anual y el periodo es priemr sem 2006 no considere estados matr. 
'---------------------------si es semestral o trimestral y el periodo mayor a 202 entonces no considere matr.
duracion_asig = conexion.consultaUno("select duas_ccod from asignaturas where asig_ccod ='"&asignatura&"'")
filtro_matr = " and b.emat_ccod in (1,2) "
if duracion_asig = "3" and periodo >= "202" then
	filtro_matr = " "
elseif (duracion_asig = "1" or duracion_asig ="2") and periodo > "202" then
    filtro_matr = " "
end if
'-----------------------------------------------------------------------------------------------------------





botonera.AgregaBotonUrlParam "imprimir_acta", "secc_ccod", secc_ccod

set f_datos = new CFormulario
f_datos.Carga_Parametros "parametros.xml", "tabla"
f_datos.inicializar conexion

	 sql =  "select c.asig_ccod, a.secc_tdesc, b.peri_tdesc, c.asig_tdesc, d.sede_tdesc, e.jorn_tdesc,f.carr_tdesc "& vbCrLf &_
			"from secciones a , periodos_academicos b, asignaturas c, sedes d, jornadas e,carreras f "& vbCrLf &_
			"where a.peri_ccod = b.peri_ccod  "& vbCrLf &_
			"  and a.asig_ccod = c.asig_ccod  "& vbCrLf &_
			"  and a.sede_ccod = d.sede_ccod "& vbCrLf &_
			"  and a.jorn_ccod = e.jorn_ccod and a.carr_ccod = f.carr_ccod "& vbCrLf &_
			"  and cast(a.secc_ccod as varchar) = '" & secc_ccod & "'"& vbCrLf

f_datos.consultar sql
f_datos.siguiente
'------------------------------------------------------------------------------------
'------------------debemos buscar el horario de la asignatura------------------------
set formu_conectar = new cformulario
formu_conectar.carga_parametros "listado_evaluaciones.xml", "bloque_muestra"
formu_conectar.inicializar conexion


consulta="select distinct a.bloq_ccod as c_bloq_ccod, a.bloq_ccod ,a.bloq_finicio_modulo as Inicio,a.bloq_ftermino_modulo as Termino, d.sala_ciso, " & vbCrLf & _ 
"d.sala_tdesc as sala, " & vbCrLf & _
"protic.profesores_bloque(a.bloq_ccod) as profesor, b.pers_ncorr, " & vbCrLf & _
"cast(g.asig_ccod as varchar)+' '+cast(g.asig_tdesc as varchar) as asignatura, " & vbCrLf & _
"e.hora_ccod as hora, " & vbCrLf & _
"h.dias_tdesc as Dia, h.dias_ccod, " & vbCrLf & _
" case when a.pers_ncorr is null then 1 else 2 end as asig_docente " & vbCrLf & _
"    from  " & vbCrLf & _
"    bloques_horarios a, " & vbCrLf & _
"    personas b,  salas d, horarios e, secciones f, asignaturas g, dias_semana h " & vbCrLf & _
"    where  a.pers_ncorr *=b.pers_ncorr " & vbCrLf & _
"    and a.sala_ccod=d.sala_ccod " & vbCrLf & _
"    and e.hora_ccod=a.hora_ccod " & vbCrLf & _
"    and f.asig_ccod=g.asig_ccod " & vbCrLf & _
"    and a.secc_ccod=f.secc_ccod " & vbCrLf & _
"    and cast(f.secc_ccod as varchar)='"&secc_ccod&"'" & vbCrLf & _
"    and a.dias_ccod=h.dias_ccod " & vbCrLf & _
"	 order by asig_docente, h.dias_ccod, e.hora_ccod "
'response.Write("<pre>"&consulta&"</pre>")
formu_conectar.consultar consulta
'-------------------------------------------------------------------------------------
'----------------------------listado de evaluaciones sección--------------------------
set formu_evaluaciones = new cformulario
formu_evaluaciones.carga_parametros "listado_evaluaciones.xml", "evaluaciones"
formu_evaluaciones.inicializar conexion

consulta_evaluaciones = " select a.cali_ncorr,a.cali_nevaluacion,cali_nponderacion, " & vbCrLf & _
						" protic.trunc(cali_fevaluacion) as cali_fevaluacion,protic.initcap(b.teva_tdesc) as teva_tdesc, " & vbCrLf & _
						" (select count(*) from calificaciones_alumnos c where c.secc_ccod=a.secc_ccod and c.cali_ncorr=a.cali_ncorr) as num_alumnos, " & vbCrLf & _
						" (select count(*) from calificaciones_alumnos c where c.secc_ccod=a.secc_ccod and c.cali_ncorr=a.cali_ncorr and isnull(cast(cala_nnota as varchar),'-') = '-') as num_sp " & vbCrLf & _
						" from calificaciones_seccion a, tipos_evaluacion b " & vbCrLf & _
						" where a.teva_ccod=b.teva_ccod  " & vbCrLf & _
						" and cast(a.secc_ccod as varchar)='"&secc_ccod&"' " & vbCrLf & _
						" order by a.cali_nevaluacion " 

formu_evaluaciones.consultar consulta_evaluaciones
'response.Write("<pre>"&consulta_evaluaciones&"</pre>")

'set f_alumnos = new CFormulario
'f_alumnos.Carga_Parametros "listado_evaluaciones.xml", "f_alumnos"
'f_alumnos.inicializar conexion

'	  sql = "select a.secc_ccod, b.matr_ncorr, b.alum_nmatricula, c.PERS_TAPE_PATERNO, c.PERS_TAPE_MATERNO, c.PERS_TNOMBRE, f.carr_ccod,  f.CARR_TDESC, e.ESPE_TDESC  "& vbCrLf &_
'			"from cargas_academicas a, alumnos b, personas c, ofertas_academicas d, especialidades e, carreras f "& vbCrLf &_
'			"where a.matr_ncorr = b.matr_ncorr "& vbCrLf &_
'			"  and b.emat_ccod in (1,2) "& vbCrLf &_
'			"  and b.pers_ncorr = c.pers_ncorr "& vbCrLf &_
'			"  and b.ofer_ncorr = d.ofer_ncorr "& vbCrLf &_
'			"  and d.espe_ccod = e.espe_ccod "& vbCrLf &_
'			"  and e.carr_ccod = f.carr_ccod "& vbCrLf &_
'			"  and cast(a.secc_ccod as varchar)= '" & secc_ccod & "'  "& vbCrLf &_ 
'			"ORDER BY c.PERS_TAPE_PATERNO, c.PERS_TAPE_MATERNO, c.PERS_TNOMBRE "

'f_alumnos.consultar sql
'response.Write("<pre>"&sql&"</pre>")

botonera.agregabotonurlparam "Planilla_notas_excel","secc_ccod",secc_ccod

'-------------Devemos buscar información sobre las notas finales de los alumnos.-----------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion

consulta= "select a.secc_ccod, isnull(secc_con_examen,'S') as secc_con_examen, " & vbCrLf &_
		  " replace(case a.secc_nota_presentacion when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else isnull(cast(a.secc_nota_presentacion as varchar),'3,0') end,',','.')as secc_nota_presentacion, " & vbCrLf &_
		  "	isnull(a.secc_porcentaje_presentacion, 70) as secc_porcentaje_presentacion, " & vbCrLf &_
		  "	replace(cast(isnull(a.secc_porcentaje_presentacion, 70) / 100 as numeric (3,2)),',','.') as porcentaje_presentacion, " & vbCrLf &_
		  " isnull(a.secc_eval_mini, 2) as secc_eval_mini, " & vbCrLf &_
		  " isnull(a.secc_porce_asiste, 75) as secc_porce_asiste, " & vbCrLf &_
		  " replace(case a.secc_nota_ex when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else isnull(cast(a.secc_nota_ex as varchar),'4,0') end,',','.')as secc_nota_ex,  " & vbCrLf &_
		  " replace(case a.secc_min_examen when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else isnull(cast(a.secc_min_examen as varchar),'3,0') end,',','.')as secc_min_examen, " & vbCrLf &_  
		  " isnull(a.secc_eximision, 'S') as secc_eximision, " & vbCrLf &_
		  " replace(cast(1 - (isnull(secc_porcentaje_presentacion, 70) / 100) as decimal(2,2)),',','.') as porc_examen " & vbCrLf &_
		  " from secciones a " & vbCrLf &_
		  " where cast(a.secc_ccod as varchar)= '"&secc_ccod&"'"
		   		   
f_consulta.Consultar consulta
f_consulta.Siguiente

porcentaje_asistencia = f_consulta.ObtenerValor("secc_porce_asiste")
NOTA_PRESENTACION = f_consulta.ObtenerValor("secc_nota_presentacion")
NOTA_EXIMICION = f_consulta.ObtenerValor("secc_nota_ex")
NOTA_MIN_EXAMEN = f_consulta.ObtenerValor("secc_min_examen")
PORCENTAJE_PRESENTACION = f_consulta.ObtenerValor("porcentaje_presentacion")
v_porcentaje_presentacion = f_consulta.ObtenerValor("secc_porcentaje_presentacion")
PORCENTAJE_EXAMEN = f_consulta.ObtenerValor("porc_examen")
SECC_EXIMISION = f_consulta.ObtenerValor("secc_eximision")
CON_EXAMEN = f_consulta.ObtenerValor("secc_con_examen")

parametro= CON_EXAMEN

anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
'response.Write(anos_ccod)
if anos_ccod < "2006" then
	parametro= CON_EXAMEN
else
	parametro="N"	 
end if


set alumnos			=	new cformulario
alumnos.inicializar			conexion
'response.Write(nota_eximicion)
if porcentaje_asistencia = "75" and nota_presentacion ="3.0" and nota_eximicion ="4.0"  and nota_min_examen = "3.0" and v_porcentaje_presentacion = "70"  and secc_eximision="S" and con_examen = "S" then
	mensaje_configuracion = "La Asignatura no ha sido configurada para hacer el cálculo de la nota final, lo está realizando con los valores asignados por defecto."
end if 

if parametro <> "N" then
	alumnos.carga_parametros		"listado_evaluaciones.xml","alumnos_f"
else
	botonera.agregabotonurlparam "Planilla_notas_excel","parametro",parametro
	alumnos.carga_parametros		"listado_evaluaciones.xml","alumnos_sin_examen"

porcentaje_asistencia = 75
NOTA_PRESENTACION = 1.0
NOTA_EXIMICION = 4.0
NOTA_MIN_EXAMEN = 1.0
PORCENTAJE_PRESENTACION = 100
v_porcentaje_presentacion = 100
PORCENTAJE_EXAMEN = 0
SECC_EXIMISION = "S"
end if

if f_consulta.NroFilas = 0 then	
	PORCENTAJE_PRESENTACION = "0"
	PORCENTAJE_EXAMEN = "0"
end if

consulta_alumnos="select distinct " & vbCrlf & _
				 " isnull(c.carg_justi,0) as carg_justi," & vbCrlf & _
				 " isnull(c.estado_cierre_ccod,1)as estado_cierre_ccod,c.matr_ncorr,c.matr_ncorr as v_matr_ncorr,  pers_tape_paterno,pers_tape_materno,pers_tnombre, " & vbCrlf & _
				 " case b.alum_trabajador when 0 then  '<font color=blue>' + cast(a.pers_nrut as varchar) + ' - ' + a.pers_xdv + '</font>' else" & vbCrlf & _
				 "      cast(a.pers_nrut as varchar)+ ' - ' + a.pers_xdv end as rut, " & vbCrlf & _
				 " case b.alum_trabajador when 0 then '<font color=blue>' + pers_tape_paterno + ' '+ pers_tape_materno + ', ' + pers_tnombre + '</font>' else" & vbCrlf & _
				 "      pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre end as alumno," & vbCrlf & _
				 " replace(case protic.NOTA_PRESENTACION(c.matr_ncorr,'"&secc_ccod&"') when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else isnull(protic.NOTA_PRESENTACION(c.matr_ncorr,'"&secc_ccod&"'),1) end,',','.') as carg_nnota_presentacion, " & vbCrlf & _
				 " replace(case protic.NOTA_PRESENTACION(c.matr_ncorr,'"&secc_ccod&"') when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else isnull(protic.NOTA_PRESENTACION(c.matr_ncorr,'"&secc_ccod&"'),1) end,',','.') as carg_nnota_presentacion_paso, " & vbCrlf & _
				 " replace(case c.carg_nnota_examen when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else c.carg_nnota_examen end,',','.') as carg_nnota_examen," & vbCrlf & _
				 " --replace(case c.carg_nnota_repeticion when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else c.carg_nnota_repeticion end,',','.') as carg_nnota_repeticion, " & vbCrlf & _
				 " case isnull(carg_nnota_final,0) when 0 then" & vbCrlf & _
				 " 	   replace(case protic.ALUMNOS_EXIMIDOS(c.matr_ncorr,'"&secc_ccod&"') when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else protic.ALUMNOS_EXIMIDOS(c.matr_ncorr,'"&secc_ccod&"') end,',','.') else " & vbCrlf & _
				 "       replace(case carg_nnota_final when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else carg_nnota_final end ,',','.') end as carg_nnota_final,cast(isnull(c.carg_nnota_final,0) as decimal(2,1)) as nfinal2, " & vbCrlf & _
				 " ltrim(rtrim(c.sitf_ccod)) as sitf_ccod,isnull(c.carg_nasistencia, 100) as carg_nasistencia,isnull(b.talu_ccod,1) as talu_ccod ,isnull(b.alum_trabajador,1) as alum_trabajador, isnull(eexa_ccod,'NP') as EEXA_CCOD, eexa_ccod_rep as EEXA_CCOD_REP, " & vbCrlf & _
				 " (select count(*) from calificaciones_alumnos ca where cast(ca.secc_ccod as varchar)='"&secc_ccod&"' and ca.matr_ncorr=c.matr_ncorr and cala_nnota is null) as parciales_nulas  " & vbCrlf & _
				 "	from  " & vbCrlf & _
				 "		personas a, " & vbCrlf & _
				 "		alumnos b, " & vbCrlf & _
				 "		cargas_academicas c, " & vbCrlf & _
				 "		secciones f " & vbCrlf & _
				 "	where  " & vbCrlf & _
				 "		a.pers_ncorr        =   b.pers_ncorr  " & vbCrlf & _
				 "		and b.matr_ncorr    =   c.matr_ncorr  " & vbCrlf & _
				 "		 "& filtro_matr & vbCrlf & _
				 "		and c.carg_nsence is null  " & vbCrlf & _
				 "		and c.secc_ccod     =   f.secc_ccod " & vbCrlf & _
				 "		and c.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where cast(secc_ccod_destino as varchar)='"&secc_ccod&"') " & vbCrlf & _
				 "      and c.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=c.matr_ncorr and cast(asig_ccod as varchar)='"&asig_ccod&"') " & vbCrlf & _
				 " 		and (c.sitf_ccod <> 'EE' or c.sitf_ccod is null) " & vbCrlf & _
				 "		and cast(c.secc_ccod as varchar) =   '"&secc_ccod&"' " & vbCrlf & _
				 " group by c.carg_justi,c.estado_cierre_ccod,c.matr_ncorr,a.pers_nrut,a.pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,c.carg_nnota_presentacion, c.carg_nnota_examen,c.carg_nnota_repeticion, c.carg_nnota_final,c.sitf_ccod,c.carg_nasistencia,b.talu_ccod,b.alum_trabajador,eexa_ccod,eexa_ccod_rep  " 

'----------------------------------------------------------------------------

alumnos.consultar consulta_alumnos & "  order by pers_tape_paterno"
cantidad_01=alumnos.nroFilas
'response.End()

'response.Write("<pre>"&consulta_alumnos & "  order by pers_tape_paterno </pre>")

'i_ = 0
'examen = true
'while alumnos.Siguiente	
'	alumnos.AgregaCampoFilaParam i_, "EEXA_CCOD", "script", "readOnly"
	
		
'	if CDbl(alumnos.ObtenerValor("carg_nnota_presentacion")) < CDBL(NOTA_PRESENTACION) then
'		alumnos.AgregaCampoFilaParam i_, "carg_nnota_examen", "script", "readOnly"
'		if EsVacio(alumnos.ObtenerValor("EEXA_CCOD_REP")) then
'			alumnos.AgregaCampoFilaCons	i_,	"carg_nnota_final",	alumnos.ObtenerValor("carg_nnota_presentacion")
'		end if
		
'		alumnos.AgregaCampoFilaCons	i_,	"EEXA_CCOD", "SD"
'	else
'	    alumnos.AgregaCampoFilaCons	i_,	"EEXA_CCOD", ""
'	end if
'	if CDbl(alumnos.ObtenerValor("carg_nnota_presentacion")) >= CDBL(NOTA_EXIMICION) and SECC_EXIMISION = "S" then
'		if EsVacio(alumnos.ObtenerValor("sitf_ccod")) then
'		        alumnos.agregacampofilacons	i_,	"carg_nnota_final",	alumnos.ObtenerValor("carg_nnota_presentacion")
'				alumnos.agregacampofilacons	i_,	"EEXA_CCOD", "EX"
'		end if
'	end if 
	
'	if alumnos.ObtenerValor("parciales_nulas") >  "0" then
'				alumnos.agregacampofilacons	i_,	"EEXA_CCOD", "SP"
'				alumnos.AgregaCampoFilaParam i_, "carg_nnota_examen", "script", "readOnly"
'	end if 
'	
'	if EsVacio(alumnos.ObtenerValor("sitf_ccod")) then
'		examen = false
'	end if
'	i_ = i_ + 1
'wend
'alumnos.Primero


'alumnos.AgregaCampoParam "cala_nnota", "descripcion", "Nota " & nro_nota
'alumnos.AgregaCampoParam "carg_nnota_presentacion", "script", "readOnly"

'if secc_ccod <> ""  then
'	tipo_asignatura	= conexion.consultauno("	select isnull(b.tasg_ccod,a.tasg_ccod) "  & vbcrlf & _
'											"	from  " & vbcrlf & _
'											"		asignaturas a, secciones b " & vbcrlf & _
'											"	where " & vbcrlf & _
'											"		a.asig_ccod=b.asig_ccod " & vbcrlf & _
'											"		and cast(b.secc_ccod as varchar)='"&secc_ccod&"'")
'end if

'set notas_asig		=	new cformulario
'notas_asig.inicializar		conexion	
'notas_asig.carga_parametros		"paulo.xml","tabla"

'if CInt(tipo_asignatura) <> 1 then
'	notas_asig.Consultar consulta_alumnos
'	for i_ = 0 to notas_asig.NroFilas - 1
'		notas_asig.Siguiente
'		alumnos.AgregaCampoFilaCons	i_,	"carg_nnota_final", notas_asig.obtenervalor("carg_nnota_presentacion")
'	next
	
'	alumnos.agregacampoparam		"carg_nnota_examen",		"tipo",		"hidden"
'	alumnos.agregacampoparam		"carg_nnota_examen",		"permiso",	"oculto"
'end if

'alumnos.agregacampoparam		"erep" ,	"tipo" , "hidden"
'alumnos.agregacampoparam		"erep" ,	"permiso" , "oculto"
'------------------------------------------------------------------------------------------------------------------------------

'debemos buscar las variables que nos indicarán las pertinentes observaciones que debemos mostrar en el sistema.
total_horarios = conexion.consultaUno("Select count(*) from bloques_horarios where cast(secc_ccod as varchar)='"&secc_ccod&"'")
total_sin_profesor = conexion.consultaUno("Select count(*) from bloques_horarios a where cast(a.secc_ccod as varchar)='"&secc_ccod&"' and not exists (select 1 from bloques_profesores b where a.bloq_ccod=b.bloq_ccod)")
'response.Write("tota_horarios "&total_horarios)
if total_horarios > "0" then
	if cint(total_horarios) < cint(total_sin_profesor) then
		mensaje_profesor = "Esta asignatura si dicta en "&total_horarios&" clases a la semana de las cuales "&total_sin_profesor&" estan sin profesor asignado<br> se debe regularizar dicha situación, agregando más profesores o eliminando dichos bloques horarios."
	end if
else
	mensaje_profesor= " Esta asignatura aún no ha sido planificada."
end if

consulta = " select count(aa.matr_ncorr) from cargas_academicas aa , alumnos b "& vbCrLf	&_
		   " where aa.matr_ncorr=b.matr_ncorr "& vbCrLf	&_
		   "  " & filtro_matr & vbCrLf	&_
		   " and cast(aa.secc_ccod as varchar)= '"&secc_ccod&"'"& vbCrLf	&_
		   " and aa.carg_nsence is  null "& vbCrLf	&_
		   " and aa.matr_ncorr not in (select matr_ncorr_destino from resoluciones_homologaciones  where cast(secc_ccod_destino as varchar)= '"&secc_ccod&"') "& vbCrLf	&_
		   " and aa.matr_ncorr not in (select matr_ncorr from convalidaciones where matr_ncorr=aa.matr_ncorr and asig_ccod = '"&asignatura&"')"

cantidad_alumnos = conexion.consultaUno(consulta)
total_profesores = conexion.consultaUno("Select count(*) from bloques_horarios a where cast(a.secc_ccod as varchar)='"&secc_ccod&"' and exists (select 1 from bloques_profesores b where a.bloq_ccod=b.bloq_ccod)")

if cantidad_alumnos = "0" and total_profesores > "0" then
	mensaje_alumnos = "La Asignatura se encuentra planificada y con docentes, pero no hay alumnos asignados a dicha sección. Revisar situación por contratos de docentes."
end if

total_evaluaciones = conexion.consultaUno("Select sum(cali_nponderacion)  from calificaciones_seccion where cast(secc_ccod as varchar)='"&secc_ccod&"'")

if total_evaluaciones < "100" or esvacio(total_evaluaciones) then
	mensaje_evaluaciones = "No se ha completado el 100% de las evaluaciones de la Asignatura."
end if

notas_parciales = conexion.consultaUno("Select count(*) from calificaciones_alumnos where cast(secc_ccod as varchar)='"&secc_ccod&"'")

if not(total_evaluaciones < "100") and notas_parciales= "0" then
	mensaje_parciales = " La Asignatura tiene el 100% de las evaluaciones creadas pero aún no se han ingresado sus notas parciales."
end if

situacion_pendiente = conexion.consultaUno("Select count(*) from cargas_academicas where cast(secc_ccod as varchar)='"&secc_ccod&"' and sitf_ccod='SP'")

if situacion_pendiente > "0" then
	mensaje_final = " La asignatura ya presenta alumnos con notas finales guardadas, pero "&situacion_pendiente&" de ellos estan con situación pendiente."  
end if

estado_cierre = conexion.consultaUno("Select isnull(estado_cierre_ccod,1) from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")

if estado_cierre = "2" then
	mensaje_cierre = "La evaluación de la asignatura ya se encuentra cerrada."
else
	mensaje_cierre = "La evaluación de la asignatura aún no ha sido cerrada."	
end if

usuario=negocio.obtenerUsuario
pers_usuario=conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")

es_administrador = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios where cast(pers_ncorr as varchar)='"&pers_usuario&"' and srol_ncorr in (1,2,27)")

contador_total = 0
contador_reprobados = 0
contador_aprobados = 0
contador_pendientes = 0
nota_promedio =  cdbl("0,0")
menores_a_4 = 0
mayores_a_4 = 0
entre_1_2 = 0
entre_2_3 = 0
entre_3_4 = 0
entre_4_5 = 0
entre_5_6 = 0
entre_6_7 = 0

while alumnos.siguiente 
	contador_total = contador_total + 1
	if alumnos.obtenerValor("sitf_ccod")="R" or alumnos.obtenerValor("sitf_ccod")="RI" then
		contador_reprobados= contador_reprobados + 1
	elseif alumnos.obtenerValor("sitf_ccod")="A" then
		contador_aprobados= contador_aprobados + 1
	end if
	if alumnos.obtenerValor("sitf_ccod")="SP" then
		contador_pendientes= contador_pendientes + 1
	end if		
	'nota_promedio = formatnumber(cdbl(nota_promedio) + cdbl(alumnos.obtenerValor("carg_nnota_final")),1,-1,0,0)
	nota_promedio = cdbl(nota_promedio) + cdbl(alumnos.obtenerValor("nfinal2"))
	'response.Write(alumnos.obtenerValor("carg_nnota_final")&"-" & formatnumber(cdbl(alumnos.obtenerValor("nfinal2")),1,-1,0,0)&"<br>")
	if cdbl(alumnos.obtenerValor("nfinal2")) < cdbl("4,0") then
			menores_a_4 = menores_a_4 + 1
	else
		    mayores_a_4 = mayores_a_4 + 1		
	end if		
	
	if ((cdbl(alumnos.obtenerValor("nfinal2")) >= cdbl("1,0"))and (cdbl(alumnos.obtenerValor("nfinal2")) < cdbl("2,0"))) then
		entre_1_2 = entre_1_2 + 1
	elseif ((cdbl(alumnos.obtenerValor("nfinal2")) >= cdbl("2,0"))and (cdbl(alumnos.obtenerValor("nfinal2")) < cdbl("3,0"))) then
		entre_2_3 = entre_2_3 + 1
	elseif ((cdbl(alumnos.obtenerValor("nfinal2")) >= cdbl("3,0"))and (cdbl(alumnos.obtenerValor("nfinal2")) < cdbl("4,0"))) then
		entre_3_4 = entre_3_4 + 1		
	elseif ((cdbl(alumnos.obtenerValor("nfinal2")) >= cdbl("4,0"))and (cdbl(alumnos.obtenerValor("nfinal2")) < cdbl("5,0"))) then
		entre_4_5 = entre_4_5 + 1
	elseif ((cdbl(alumnos.obtenerValor("nfinal2")) >= cdbl("5,0"))and (cdbl(alumnos.obtenerValor("nfinal2")) < cdbl("6,0"))) then
		entre_5_6 = entre_5_6 + 1		
	elseif ((cdbl(alumnos.obtenerValor("nfinal2")) >= cdbl("6,0"))and (cdbl(alumnos.obtenerValor("nfinal2")) <= cdbl("7,0"))) then
		entre_6_7 = entre_6_7 + 1	
	end if	
wend
alumnos.primero
'response.Write(nota_promedio & "contador_total "&contador_total)

if contador_total <> 0 then
	promedio_curso = formatnumber((cdbl(nota_promedio) / cdbl(contador_total)),1,-1,0,0)
	valor = (menores_a_4 * 100) / contador_total
	porc_menores_a_4 = formatnumber(valor,2)
else
	promedio_curso = 0
	porc_menores_a_4 = 0
end if		


cantidad_retirados = conexion.consultaUno ("select count(*) from cargas_academicas a, alumnos b where cast(a.secc_Ccod as varchar)='"&secc_ccod&"' and a.matr_ncorr=b.matr_ncorr and b.emat_ccod not in (1,2,4,8)")
'response.Write("<br>prom "&promedio_curso& " menores_a_4 "&menores_a_4&" mayores_a_4 "&mayores_a_4&" retirados "&cantidad_retirados)
if contador_reprobados > 0 then
    valor = (contador_reprobados * 100) / contador_total
	porc_reprobados = formatnumber(valor,2)
else
	porc_reprobados = 0
end if
if contador_aprobados > 0 then
    valor = (contador_aprobados * 100) / contador_total
	porc_aprobados = formatnumber(valor,2)
else
	porc_aprobados = 0
end if
if contador_pendientes > 0 then
    valor = (contador_pendientes * 100) / contador_total
	porc_pendientes = formatnumber(valor,2)
else
	porc_pendientes = 0
end if
'response.Write("<hr>"&porc_pendientes&"<hr>")
	


%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
      <br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br><BR><BR>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="20%"><strong>Asignatura</strong></td>
                        <td width="3%"><div align="center"><strong>:</strong></div></td>
                        <td width="41%"><%="(" & f_datos.obtenerValor("asig_ccod") & ") "  & f_datos.obtenerValor("asig_tdesc")%></td>
                        <td width="9%"><strong>Sede</strong></td>
                        <td width="3%"><div align="center"><strong>:</strong></div></td>
                        <td width="24%"><%=f_datos.obtenerValor("sede_tdesc")%></td>
                      </tr>
                      <tr> 
                        <td><strong>Periodo Acad&eacute;mico</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_datos.obtenerValor("peri_tdesc")%></td>
                        <td><strong>Carrera</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_datos.obtenerValor("carr_tdesc")%></td>
                      </tr>
                      <tr> 
                        <td><strong>Secci&oacute;n</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_datos.obtenerValor("secc_tdesc")%></td>
                        <td><strong>Jornada</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_datos.obtenerValor("jorn_tdesc")%></td>
					 </tr>
                    </table>
                       <BR>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">&nbsp;
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Horario de la Asignatura"%>
                      <br>
					  <% formu_conectar.dibujaTabla()%>
					  </td>
                  </tr>
				   <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Evaluaciones de la asignatura"%>
                      <br>
					  <% formu_evaluaciones.dibujaTabla()%>
					  </td>
                  </tr>
				  <tr>
                    <td align="right"><%botonera.dibujaboton "Planilla_notas_excel"%> </td>
                  </tr>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
				  	<td><table width="98%"  border="1">
						   <%if parametro="N" and anos_ccod < "2006" then%>
                            <tr>
                              <td colspan="3"><font color="#0000FF">*</font>&nbsp; Esta asignatura no presenta examen final.</td>
                            </tr>
							<%elseif parametro <> "N" then%>
							<tr>
                              <td>Nota Presentaci&oacute;n : <b><%=NOTA_PRESENTACION%></b></td>
                              <td>Nota Eximici&oacute;n : <b> 
                                <%if SECC_EXIMISION = "S" then Response.Write(NOTA_EXIMICION) else Response.Write("Sin Eximición")%>
                                </b></td>
                              <td>Porcentaje Asistencia : <b><%=porcentaje_asistencia%></b> % </td>
                            </tr>
                            <tr>
                              <td>Nota M&iacute;n. Examen : <b><%=NOTA_MIN_EXAMEN%></b></td>
                              <td>Porc. Nota. Presentaci&oacute;n : <b><%=v_porcentaje_presentacion%></b> %</td>
                              <td>&nbsp;</td>
                            </tr>
							<%end if%>
                          </table>
					</td>
				  </tr>
				  <tr>
				  	<td>&nbsp;</td>
				  </tr>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Listado de alumnos y Situación Final"%>
                      <br>
					  <% alumnos.dibujaTabla()%>
					  </td>
                  </tr>
				  <tr>
				  	  <td align="right">- Para el cálculo de nota de presentación se consideran como 1.0 a aquellas notas en situación pendiente (SP)
					  </td>
				   </tr>
				   <tr>
				  	  <td align="right">&nbsp;
					  </td>
				   </tr>
				   <tr>
				   	<td align="center">
						<table width="90%" border="1">
							<tr>	
								<td colspan="3" align="center" bgcolor="#7A8B8B" ><font size="3" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>Total Evaluados <%=contador_total%> Alumnos</strong></font></td>
							</tr>
							<tr>	
								<td width="33%" align="center">Aprobados <strong><%=contador_aprobados%></strong> Alumnos</td>
								<td width="33%" align="center">Reprobados <strong><%=contador_reprobados%></strong> Alumnos</td>
								<td width="33%" align="center">Pendientes <strong><%=contador_pendientes%></strong> Alumnos</td>
							</tr>
							<tr>	
								<td width="33%" align="center"><strong><%=porc_aprobados%> %</strong></td>
								<td width="33%" align="center"><strong><%=porc_reprobados%> %</strong></td>
								<td width="33%" align="center"><strong><%=porc_pendientes%> %</strong></td>
							</tr>
						</table>
					</td>
				   </tr>
				   <tr>
				  	  <td align="right">&nbsp;
					  </td>
				   </tr>
				   <tr>
				   	<td align="center">
						<table width="90%" border="1">
							<tr>	
								<td colspan="2" align="center" bgcolor="#7A8B8B"><font size="3" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>Resumen</strong></font></td>
							</tr>
							<tr>	
								<td width="50%" align="left">Nota Promedio Curso</td>
								<td width="50%" align="center"><strong><%=promedio_curso%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="left">Notas bajo 4.0</td>
								<td width="50%" align="center"><strong><%=menores_a_4%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="left">Notas iguales o superiores a 4.0</td>
								<td width="50%" align="center"><strong><%=mayores_a_4%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="left">Alumnos no Activos</td>
								<td width="50%" align="center"><strong><%=cantidad_retirados%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="left">% curso bajo 4.0</td>
								<td width="50%" align="center"><strong><%=porc_menores_a_4%> %</strong></td>
    						</tr>
						</table>
					</td>
				   </tr>
				   <tr>
				  	  <td align="right">&nbsp;
					  </td>
				   </tr>
				   <tr>
				   	<td align="center">
						<table width="90%" border="1">
							<tr>	
								<td colspan="2" align="center" bgcolor="#7A8B8B"><font size="3" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>Intervalos</strong></font></td>
							</tr>
							<tr>	
								<td width="50%" align="center">1.0 a 1.9</td>
								<td width="50%" align="center"><strong><%=entre_1_2%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center">2.0 a 2.9</td>
								<td width="50%" align="center"><strong><%=entre_2_3%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center">3.0 a 3.9</td>
								<td width="50%" align="center"><strong><%=entre_3_4%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center">4.0 a 4.9</td>
								<td width="50%" align="center"><strong><%=entre_4_5%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center">5.0 a 5.9</td>
								<td width="50%" align="center"><strong><%=entre_5_6%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center">6.0 a 7.0</td>
								<td width="50%" align="center"><strong><%=entre_6_7%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center">Alumnos no Activos</td>
								<td width="50%" align="center"><strong><%=cantidad_retirados%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center"><strong>Total Alumnos</strong></td>
								<td width="50%" align="center"><strong><%=contador_total%></strong></td>
    						</tr>
						</table>
					</td>
				   </tr>
				   <tr>
				  	  <td align="right">&nbsp;
					  </td>
				   </tr>
				   <%if mensaje_profesor <> "" or mensaje_alumnos<> "" or mensaje_evaluaciones <> "" or mensaje_parciales <> "" or mensaje_final <> "" or mensaje_cierre <> "" then %>
				   <tr>
				   		<td align="center">
							<table width="90%" border="1">
							<tr>
								<td align="Center" bgcolor="#7A8B8B"><font size="3" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>Observaciones</strong></font>
								</td>
							</tr>
							<%if mensaje_profesor <> "" then%>
							<tr>
								<td align="left"><font color="#0000FF">*</font> <%=mensaje_profesor%>
								</td>
							</tr>
							<%end if%>
							<%if mensaje_alumnos <> "" then%>
							<tr>
								<td align="left"><font color="#0000FF">*</font> <%=mensaje_alumnos%>
								</td>
							</tr>
							<%end if%>
							<%if mensaje_evaluaciones <> "" then%>
							<tr>
								<td align="left"><font color="#0000FF">*</font> <%=mensaje_evaluaciones%>
								</td>
							</tr>
							<%end if%>
							<%if mensaje_parciales <> "" then%>
							<tr>
								<td align="left"><font color="#0000FF">*</font> <%=mensaje_parciales%>
								</td>
							</tr>
							<%end if%>
							<%if mensaje_configuracion <> "" then %>
							<tr>
								<td align="left"><font color="#0000FF">*</font> <%=mensaje_configuracion%>
								</td>
							</tr>
							<%end if%>
							<%if mensaje_final <> "" then%>
							<tr>
								<td align="left"><font color="#0000FF">*</font> <%=mensaje_final%>
								</td>
							</tr>
							<%end if%>
							<%if mensaje_cierre <> "" then%>
							<tr>
								<td align="left"><font color="#0000FF">*</font> <%=mensaje_cierre%>
								</td>
							</tr>
							<%end if%>
							
							<%if estado_cierre = "2" and es_administrador="S" then%>
							 <tr>
								<td align="center">
								<%botonera.AgregaBotonParam "imprimir_acta_resumen", "url", "acta_notas_final.asp?secc_ccod=" & secc_ccod 
						      	botonera.dibujaBoton "imprimir_acta_resumen"%>
								</td>
							</tr>
						        
						    <%end if%>
							</table>
						</td>
				   </tr>
				   <%end if%>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="10%" height="20"><div align="center"><% botonera.AgregaBotonParam "anterior", "url", "listado_evaluaciones.asp?busqueda[0][sede_ccod]=" & sede &"&busqueda[0][carr_ccod]="&carrera&"&busqueda[0][jorn_ccod]="&jornada&"&busqueda[0][todas]=S"
						  botonera.dibujaBoton "anterior"%></div></td>
			<td width="15%" height="20"><div align="center"> <% 
			              if estado_cierre = "2" and es_administrador="S" then
						  	botonera.AgregaBotonParam "abrir", "url", "abrir_evaluacion.asp?secc_ccod=" & secc_ccod 
						  	botonera.dibujaBoton "abrir"
						  end if
						  %></div> </td>
			<td width="10%" height="20"><div align="center"> <% 
			              if estado_cierre = "2" then
						  	  	botonera.dibujaBoton "imprimir_acta"
						  end if
						  %></div> </td>			  
            <td width="65%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
			<td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
			<td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
