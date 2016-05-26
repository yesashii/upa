 <!-- #include file="../biblioteca/_conexion.asp" -->
 <!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 Response.Buffer = True
 Response.ExpiresAbsolute = Now() - 1
 Response.Expires = 0
 Response.CacheControl = "no-cache" 
 
set pagina = new CPagina
pagina.Titulo = "Asignación de Carga Académica Alumnos"

matr_ncorr = Request.QueryString("enca[0][carreras_alumno]")

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'sede_ccod = negocio.obtenerSede()

'response.Write("sede "&sede_ccod)
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "toma_carga_alumno.xml", "BotoneraTomaCarga"

set f_botoneraEQ = new CFormulario
f_botoneraEQ.Carga_Parametros "toma_carga_alumno.xml", "BotoneraEQ"

'---------------------------------------------------------------------------------------------------
'response.Write("<hr>1")

set formulario 	= new cformulario
set errores 	= new cErrores
set alumno 		= new cAlumno
set tresumen	= new cformulario
set tresumen_otrasede = new cformulario
set datos		=	new cFormulario




datos.inicializar	conectar
datos.carga_parametros	"toma_carga_alumno.xml","tabla"

formulario.carga_parametros "toma_carga_alumno.xml", "toma_carga"
formulario.inicializar conectar
tresumen.inicializar conectar
tresumen_otrasede.inicializar conectar

'q_peri_ccod = negocio.obtenerPeriodoAcademico("Planificacion")
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
if esVacio(q_pers_nrut) then
	q_pers_nrut = negocio.obtenerUsuario
	q_pers_xdv = conectar.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

pers_nrut=q_pers_nrut
actividad = session("_actividad")
'response.Write("a "&actividad)
if (actividad = "7")  then
	peri_ccod = negocio.obtenerPeriodoAcademico("TOMACARGA")
else
	peri_ccod = negocio.obtenerPeriodoAcademico("CLASES18")
end if
peri_ccod="202"
if not esVacio(q_pers_nrut) then
	pers_ncorr_temporal=conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

carrera = conectar.consultaUno("Select carr_ccod from alumnos a, ofertas_Academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( matr_ncorr as varchar)='"&matr_ncorr&"'")

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "carga_alumno.xml", "encabezado"
f_encabezado.Inicializar conectar

consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       ltrim(rtrim(protic.obtener_nombre_carrera(b.ofer_ncorr, 'C'))) as carrera, protic.ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod " 
		   if not esVacio(carrera) then
		   		consulta=consulta & " and cast(d.carr_ccod as varchar)='"&carrera&"'"
		   else
				consulta=consulta & "  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) " 
		   end if
		   consulta=consulta &"  --and b.emat_ccod <> 9 " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
		   
consulta_carrera= "(select distinct a.matr_ncorr , ltrim(rtrim(d.carr_tdesc)) as carr_tdesc " & vbCrLf &_
				  " from alumnos a, ofertas_academicas b, especialidades c, carreras d " & vbCrLf &_
				  " where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' " & vbCrLf &_
				  " and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
				  " and b.espe_ccod=c.espe_ccod " & vbCrLf &_
				  " and c.carr_ccod=d.carr_ccod  and a.emat_ccod in (1,4,8)" & vbCrLf &_
				  " and cast(b.peri_ccod as varchar)='"&peri_ccod&"')s"
 				 
'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.AgregaCampoParam "carreras_alumno","permiso","LECTURAESCRITURA"
f_encabezado.AgregaCampoParam "carrera","permiso","OCULTO"				 

cantidad_matriculas = conectar.consultaUno("select count(*) from "&consulta_carrera&"")

'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
f_encabezado.AgregaCampoCons "carreras_alumno", matr_ncorr
f_encabezado.AgregaCampoParam "carreras_alumno","destino",consulta_carrera
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")

nombre_carrera=f_encabezado.obtenerValor("carrera")

'response.Write(matr_ncorr)
'-----------------------------------------------------------------------------------------------------------
'response.Write("<hr>2")
'if not EsVacio(pers_nrut) then
'    url="../CERTIFICADOS/HISTORICO_NOTAS.ASP?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv&"&ocultar=1"
'	v_plec_ccod = conectar.ConsultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar) = '" & peri_ccod & "'")
'	if v_plec_ccod = "2" then
'		sentencia = " exec crear_matricula_seg_semestre '" & sede_ccod & "', '" & pers_nrut & "', '" & peri_ccod& "'"
'		conectar.EjecutaS(sentencia)
'	end if
'	bloqueado = false
	'if not EsVacio(msj_bloqueo) then
		'bloqueado = true
		'conectar.MensajeError(msj_bloqueo)
	'end if
'end if

'-----------------------------------------------------------------------------------------------------------

tresumen.carga_parametros	"toma_carga_alumno.xml","tabla_resumen"

tresumen_otrasede.carga_parametros	"toma_carga_alumno.xml","tabla_resumen_otra_sede"

' texto_1 = " SELECT matr_ncorr " _
 '        & " FROM personas a, alumnos b, ofertas_academicas c " _
'         & " WHERE a.pers_ncorr = b.pers_ncorr " _
'         & " AND b.ofer_ncorr = c.ofer_ncorr " _
'         & " AND cast(pers_nrut as varchar) = '"& pers_nrut &"' " _
'         & " AND cast(peri_ccod as varchar)= '"& peri_ccod &"' " _
'         & " and emat_ccod = 1 " 		

'response.Write(texto_1)
 'matr_ncorr =  conectar.consultaUno(texto_1) 
 if matr_ncorr<>"" then 
 
       sede_ccod = conectar.consultaUno("select sede_ccod from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
       '----------------------------------------------En caso de alumnos nuevos se buscará el filtro para que solo muestre el primer nivel-------
	   '-------------------------------------------------------------msandoval 22-02-2005--------------------------------------------------------
	   v_pers_ncorr = conectar.consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar)  = '"&pers_nrut&"'")		   
       primer_periodo = conectar.consultaUno(" select top 1 min(b.peri_ccod)as periodo from postulantes a, periodos_academicos b where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and a.peri_ccod=b.peri_ccod order by periodo asc")
       ano_ingreso= conectar.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&primer_periodo&"'")
	   ano_proceso= conectar.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
	   'response.Write("ano "&ano_ingreso&" ano_proceso "&ano_proceso)
	   if cint(ano_ingreso)=cint(ano_proceso) then
	   		alumno_nuevo=1
	   else
			alumno_nuevo=0	
	   end if
	   'response.Write("alumno_nuevo "&alumno_nuevo)
	   '------------------------------------------------------------------------------------------------------------------------------------------
		sql_espe_ccod = " select espe_ccod from alumnos a, ofertas_academicas b " & _
						" where a.ofer_ncorr = b.ofer_ncorr " & _
						" and cast(matr_ncorr as varchar)= '"&matr_ncorr&"'" 
		
		sql_jorn_ccod = " select jorn_ccod from alumnos a, ofertas_academicas b " & _
						" where a.ofer_ncorr = b.ofer_ncorr " & _
						" and cast(matr_ncorr as varchar)= '"&matr_ncorr&"'" 
		'response.Write(sql_jorn_ccod)				
		 v_espe_ccod  = conectar.consultauno(sql_espe_ccod)
		 v_jorn_ccod  = conectar.consultauno(sql_jorn_ccod)		 
		 
		 
		 sql_pers_ncorr = " select pers_ncorr from personas where cast(pers_nrut as varchar) = '"&negocio.obtenerusuario&"'"	
		 'response.Write(sql_pers_ncorr)
		 pers_ncorr_usuario = conectar.consultauno(sql_pers_ncorr)
		 sql_especialidades = " select count(*) " & _
	     					  " from sis_especialidades_usuario " & _
		 					  " where cast(pers_ncorr as varchar) = '"&pers_ncorr_usuario&"' " & _
							  " and cast(espe_ccod as varchar) = '"&v_espe_ccod&"'" & _
							  " and cast(jorn_ccod as varchar)= '"&v_jorn_ccod&"'"
		 'response.Write(sql_especialidades)
		 acceso_usuario = conectar.consultauno(sql_especialidades)
end if 

'response.Write("sede "&sede_ccod)
' if (acceso_usuario = 0 and pers_nrut <>"" ) then
'	pers_ncorr = "-1"
'	es_nuevo = "-1"
'	sede_ccod = "-1"
'	plan_ccod = "-1"
'	peri_ccod = "-1"
'	es_nuevo = "-1"
'	matr_ncorr = ""
	
'	session("mensajeError") = "Usuario No Tiene Acceso Para\nAsignar Carga A Este Alumno"
'	set errx = new cErrores
	
'end if 
 'matr_ncorr = conectar.consultaUno ("select matr_ncorr from personas a, alumnos b, ofertas_academicas c where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and pers_nrut='" & pers_nrut & "' and peri_ccod='" & peri_ccod & "'  ")
 pers_ncorr = conectar.consultaUno ("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "' ")
 nombre = conectar.consultaUno ("select cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) + ', ' + cast(pers_tnombre as varchar) from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
 carrera = conectar.consultaUno ("select carr_tdesc from carreras a, especialidades b, planes_estudio c, alumnos d where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod and c.plan_ccod=d.plan_ccod and cast(matr_ncorr as varchar)='" & matr_ncorr & "' and d.emat_ccod=1")
 v_carr_ccod  = conectar.consultaUno ("select a.carr_ccod from carreras a, especialidades b, planes_estudio c, alumnos d where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod and c.plan_ccod=d.plan_ccod and cast(matr_ncorr as varchar)='" & matr_ncorr & "' and d.emat_ccod=1")
 alumno.inicializa conectar, matr_ncorr
 alumno.construyeSituacionAsignaturas
'response.Write("==> "&pers_ncorr)
 if isnull(pers_ncorr) then
	pers_ncorr = "-1"
	es_nuevo = "-1"
	sede_ccod = "-1"
	plan_ccod = "-1"
	es_nuevo = "-1"
 else
	'sede_ccod = conectar.consultaUno ("select sede_ccod from ofertas_academicas a, alumnos b where a.ofer_ncorr=b.ofer_ncorr and cast(matr_ncorr as varchar)='" & matr_ncorr & "' and b.emat_ccod=1")
	plan_ccod = conectar.consultaUno ("select plan_ccod from  alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
	es_nuevo = conectar.consultaUno ("select protic.alumno_es_nuevo('" & matr_ncorr & "')")
	'response.Write("Es nuevo= "&es_nuevo)
	area_ccod = conectar.consultaUno ("select area_ccod from alumnos a, planes_estudio b, especialidades c, carreras d where a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
 end if

peri_tdesc = conectar.consultaUno("Select protic.initCap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
if ((isnull(cantidad_matriculas)) or (cantidad_matriculas="0")) and (pers_nrut<>"") then
	session("mensajeError") = "Imposible hacer la toma de Ramos debido a que no registras matricula para "&peri_tdesc
	set errx = new cErrores
end if
 
'response.Write("--> "&plan_ccod)

 asignaturas_disponibles_cons = "" & vbCrlf & _
"select distinct c.asig_ccod,c.asig_ccod asig_ccod_paso, c.asig_tdesc as asignatura, asig_nhoras, b.secc_ccod, '" & matr_ncorr & "' as matr_ncorr " & vbCrlf & _
"	  , a.nive_ccod, isnull(d.reprobado,0) as reprobado  from (SELECT DISTINCT b.asig_ccod, b.nive_ccod " & vbCrlf & _
"  FROM malla_curricular b" & vbCrlf & _
" WHERE cast(b.plan_ccod as varchar) = '" & plan_ccod & "'"
if alumno_nuevo=1 then
  asignaturas_disponibles_cons =  asignaturas_disponibles_cons & " and b.nive_ccod=1 "
end if
asignaturas_disponibles_cons =  asignaturas_disponibles_cons & " AND protic.completo_requisitos_asignatura (mall_ccod, '" & pers_ncorr & "') = 0" & vbCrlf & _
"   AND NOT (  " & vbCrlf & _
"			EXISTS (SELECT 1 " & vbCrlf & _
"                    FROM secciones sa," & vbCrlf & _
"                         cargas_academicas sb," & vbCrlf & _
"                         alumnos sc," & vbCrlf & _
"                         situaciones_finales sd" & vbCrlf & _
"                   WHERE sa.secc_ccod = sb.secc_ccod" & vbCrlf & _
"                     AND sa.asig_ccod = b.asig_ccod" & vbCrlf & _
"                     AND sb.matr_ncorr = sc.matr_ncorr" & vbCrlf & _
"                     AND sb.sitf_ccod = sd.sitf_ccod" & vbCrlf & _
"                     AND cast(sd.sitf_baprueba as varchar) = 'S'" & vbCrlf & _
"                     AND sc.emat_ccod = 1" & vbCrlf & _
"                     AND cast(sc.pers_ncorr as varchar) = '" & pers_ncorr & "')" & vbCrlf & _
"        OR  " & vbCrlf & _
"           EXISTS (  select 1 " & vbCrlf & _
		"			from  " & vbCrlf & _
		"				 convalidaciones a " & vbCrlf & _
		"				 , alumnos b1 " & vbCrlf & _
		"				 ,personas c " & vbCrlf & _
		"				 , actas_convalidacion d " & vbCrlf & _
		"				 , ofertas_academicas e " & vbCrlf & _
		"				 , planes_estudio f " & vbCrlf & _
		"				 ,especialidades g " & vbCrlf & _
		"				 ,situaciones_finales h " & vbCrlf & _
		"			where " & vbCrlf & _
		"				 a.matr_ncorr=b1.matr_ncorr " & vbCrlf & _
		"				 and b1.pers_ncorr=c.pers_ncorr " & vbCrlf & _
		"				 and a.acon_ncorr=d.acon_ncorr " & vbCrlf & _
		"				 and b1.ofer_ncorr=e.ofer_ncorr " & vbCrlf & _
		"				 and b1.plan_ccod=f.plan_ccod " & vbCrlf & _
		"				 and f.espe_ccod=g.espe_ccod " & vbCrlf & _
		"				 and a.asig_ccod=b.asig_ccod " & vbCrlf & _
		"				 and a.sitf_ccod=h.sitf_ccod " & vbCrlf & _
		"				 and cast(h.sitf_baprueba as varchar)='S' " & vbCrlf & _
		"			     and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"')" & vbCrlf & _	
"        OR  " & vbCrlf & _
"           /*EXISTS ( SELECT 1 " & vbCrlf & _
"                		from homologacion_destino hd, homologacion_fuente hf,homologacion h,asignaturas asig, " & vbCrlf & _
"                		secciones secc,cargas_academicas carg, alumnos al, personas pers, situaciones_finales s2c " & vbCrlf & _
"                		where hd.homo_ccod=h.homo_ccod " & vbCrlf & _
"                		and hf.homo_ccod=h.homo_ccod " & vbCrlf & _
"                		and asig.asig_ccod=hd.asig_ccod " & vbCrlf & _
"                		and asig.asig_ccod=secc.asig_ccod " & vbCrlf & _
"                		and secc.secc_ccod=carg.secc_ccod " & vbCrlf & _
"                     	AND hf.asig_ccod  = b.asig_ccod" & vbCrlf & _
"                		and al.matr_ncorr=carg.matr_ncorr " & vbCrlf & _
"                		and pers.pers_ncorr=al.pers_ncorr " & vbCrlf & _
"        		 		and hd.asig_ccod <> hf.asig_ccod " & vbCrlf & _
"                     	AND carg.sitf_ccod = s2c.sitf_ccod" & vbCrlf & _
"                     	AND cast(s2c.sitf_baprueba as varchar) = 'S'" & vbCrlf & _
"                		and cast(carg.sitf_ccod as varchar) <>'EQ' " & vbCrlf & _
"          		 		and h.THOM_CCOD = 1 " & vbCrlf & _
"                       AND al.emat_ccod = 1" & vbCrlf & _
"                		and cast(pers.pers_ncorr as varchar)='" & pers_ncorr & "')" & vbCrlf & _
"		OR */EXISTS (select  1 " & vbCrlf & _
"		   		  		   from " & vbCrlf & _
"								equivalencias a " & vbCrlf & _
"								, cargas_academicas b1 " & vbCrlf & _
"								, secciones c " & vbCrlf & _
"								, ofertas_academicas d " & vbCrlf & _
"								, planes_estudio e " & vbCrlf & _
"								, especialidades f " & vbCrlf & _
"								, alumnos g " & vbCrlf & _
"								, personas h " & vbCrlf & _
"								, situaciones_finales sf " & vbCrlf & _
"							where " & vbCrlf & _
"								 a.matr_ncorr=b1.matr_ncorr " & vbCrlf & _
"								 and a.secc_ccod=b1.secc_ccod " & vbCrlf & _
"								 and b1.secc_ccod=c.secc_ccod " & vbCrlf & _
"								 and b1.matr_ncorr=g.matr_ncorr " & vbCrlf & _
"								 and d.ofer_ncorr=g.ofer_ncorr " & vbCrlf & _
"								 and e.plan_ccod=g.plan_ccod " & vbCrlf & _
"								 and e.espe_ccod=f.espe_ccod " & vbCrlf & _
"								 and g.pers_ncorr=h.pers_ncorr " & vbCrlf & _
"								 and a.asig_ccod=b.asig_ccod " & vbCrlf & _
"								 and isnull(b1.sitf_ccod,sf.sitf_ccod)=sf.sitf_ccod " & vbCrlf & _
"								 and cast(sf.sitf_baprueba as varchar)='S' " & vbCrlf & _
"								 and cast(h.pers_ncorr as varchar)='" & pers_ncorr & "') " & vbCrlf & _
"        ) " & vbCrlf & _
"   AND cast(b.plan_ccod as varchar)= '" & plan_ccod & "'" & vbCrlf & _
"   AND NOT EXISTS (SELECT 1 " & vbCrlf & _
"                      FROM  " & vbCrlf & _
"                      MALLA_CURRICULAR MC, " & vbCrlf & _
"                      (SELECT HOMO_CCOD,ASIG_CCOD_DESTINO, COUNT(*) NREQUISITOS, count(asig_ccod)NAPROBADOS " & vbCrlf & _
"                      FROM  " & vbCrlf & _
"                      (SELECT HD.HOMO_CCOD,HD.ASIG_CCOD ASIG_CCOD_DESTINO,HF.ASIG_CCOD ASIG_CCOD_FUENTE  " & vbCrlf & _
"                       FROM HOMOLOGACION_FUENTE HF,  " & vbCrlf & _
"                       HOMOLOGACION_DESTINO HD " & vbCrlf & _
"                       WHERE HF.HOMO_CCOD=HD.HOMO_CCOD ) HOM, " & vbCrlf & _
"                      (SELECT S.ASIG_CCOD  " & vbCrlf & _
"                       FROM " & vbCrlf & _
"                       SECCIONES S, " & vbCrlf & _
"                       CARGAS_ACADEMICAS CA, " & vbCrlf & _
"                       ALUMNOS A, " & vbCrlf & _
"                       SITUACIONES_FINALES SF " & vbCrlf & _
"                       WHERE S.SECC_CCOD = CA.SECC_CCOD " & vbCrlf & _
"                       	   AND CA.MATR_NCORR = A.MATR_NCORR  " & vbCrlf & _
"                      	   AND SF.SITF_CCOD=CA.SITF_CCOD " & vbCrlf & _
"                      	   AND SF.SITF_BAPRUEBA='S'   " & vbCrlf & _
"                      	   AND cast(A.PERS_NCORR as varchar) = '" & pers_ncorr & "') APRO ---PONER PERS_NCORR  " & vbCrlf & _
"                      WHERE HOM.ASIG_CCOD_FUENTE *=APRO.ASIG_CCOD  " & vbCrlf & _
"                      group by HOMO_CCOD,asig_ccod_destino)	PRUEBA " & vbCrlf & _
"                      WHERE MC.ASIG_CCOD=ASIG_CCOD_DESTINO " & vbCrlf & _
"                      AND MC.ASIG_CCOD=B.ASIG_CCOD " & vbCrlf & _
"					  AND NREQUISITOS=NAPROBADOS " & vbCrlf & _
"                      AND cast(PLAN_CCOD as varchar)='" & plan_ccod & "') " & vbCrlf & _
") a, " & vbCrlf & _
"	(SELECT a.asig_ccod, a.secc_ccod, c.matr_ncorr  " & vbCrlf & _
"	   FROM secciones a, cargas_academicas b, alumnos c " & vbCrlf & _
"	  WHERE a.secc_ccod = b.secc_ccod " & vbCrlf & _
"	   AND b.matr_ncorr = c.matr_ncorr and b.sitf_ccod is null" & vbCrlf & _
"      AND c.emat_ccod = 1" & vbCrlf & _
"      AND cast(a.sede_ccod as varchar) = '" & sede_ccod & "' " & vbCrlf & _
"      AND cast(a.peri_ccod as varchar) = '" & peri_ccod & "' " & vbCrlf & _
"	   AND cast(c.pers_ncorr as varchar) = '" & pers_ncorr & "'"& vbCrlf & _
" 	   AND cast(c.emat_ccod as varchar)='1'"& vbCrlf & _
"      union"& vbCrlf & _
"	   select null,null,null) b, " & vbCrlf & _
"	  asignaturas c, " & vbCrlf & _ 
"   ( select a.asig_ccod, 1 as reprobado  " & vbCrlf & _
"       from secciones a, cargas_academicas b, situaciones_finales c, alumnos d " & vbCrlf & _
"      where a.secc_ccod=b.secc_ccod  " & vbCrlf & _
"        and b.sitf_ccod=c.sitf_ccod  " & vbCrlf & _
"        and b.matr_ncorr=d.matr_ncorr " & vbCrlf & _
"        AND d.emat_ccod = 1" & vbCrlf & _
"        and cast(d.pers_ncorr as varchar)='" & pers_ncorr & "' " & vbCrlf & _
"        and cast(sitf_baprueba as varchar)='N' " & vbCrlf & _
"        and cast(b.sitf_ccod as varchar) not in ('EE') " & vbCrlf & _
"	  union all" & vbCrlf & _
"	  	select  " & vbCrlf & _
"			a.asig_ccod,1 as reprobado  " & vbCrlf & _
"		from  " & vbCrlf & _
"			 equivalencias a,  " & vbCrlf & _
"			 cargas_academicas b,  " & vbCrlf & _
"			 secciones c,  " & vbCrlf & _
"			 situaciones_finales d,  " & vbCrlf & _
"			 alumnos e,  " & vbCrlf & _
"			 personas f " & vbCrlf & _
"	  where a.matr_ncorr=b.matr_ncorr " & vbCrlf & _
"		  and a.secc_ccod=b.secc_ccod  " & vbCrlf & _
"		  and b.secc_ccod=c.secc_ccod " & vbCrlf & _
"		  and b.sitf_ccod=d.sitf_ccod " & vbCrlf & _
"		  and b.matr_ncorr=e.matr_ncorr " & vbCrlf & _
"		  and e.pers_ncorr=f.pers_ncorr " & vbCrlf & _
"		  and b.sitf_ccod not in ('EE') " & vbCrlf & _
"		  and d.sitf_baprueba='N'" & vbCrlf & _
"		  and cast(f.pers_ncorr as varchar)='"& pers_ncorr &"'"& vbCrlf & _
"          union "& vbCrlf & _
"		  select null,null) d" & vbCrlf & _
"  where a.asig_ccod *=b.asig_ccod  " & vbCrlf & _
"    and a.asig_ccod *=d.asig_ccod  " & vbCrlf & _
"    and a.asig_ccod=c.asig_ccod " & vbCrLf & _
"  " & vbCrLf
	
'response.Write("<pre>"&asignaturas_disponibles_cons&"</pre>")
formulario.consultar asignaturas_disponibles_cons

'response.Write("<pre>"&asignaturas_disponibles_cons&"</pre>")
'response.End()
filas_asig = formulario.nrofilas

set datos_elec		=	new cFormulario
datos_elec.inicializar	conectar
datos_elec.carga_parametros	"toma_carga_alumno.xml","tabla"

for i_=0 to filas_asig-1
	formulario.siguiente
	v_asig_ccod =formulario.obtenervalor("asig_ccod")
	sql_electivos = " select b.asig_ccod " & _
					" from electivos a,secciones b "& _
					" where a.secc_ccod = b.secc_ccod  " & _
					" and cast(a.asig_ccod as varchar) ='"&v_asig_ccod&"' "  & _
					" and cast(peri_ccod as varchar) ='"&peri_ccod&"'"
	datos_elec.consultar sql_electivos
	for j_=0 to datos_elec.nrofilas	-1
		datos_elec.siguiente
		asig_ccod_elec=datos_elec.obtenervalor("asig_ccod")
		if asig_ccod_elec<>"" then
			if arr_asignatura_elec <>"" then
				arr_asignatura_elec =arr_asignatura_elec &",'"&asig_ccod_elec&"'" 
			else
				arr_asignatura_elec= "'"&asig_ccod_elec&"'"
			end if	
		end if
	next			
	if arr_asignatura <>"" then
		arr_asignatura =  arr_asignatura &",'"&v_asig_ccod&"'" 
	else
		arr_asignatura ="'"&v_asig_ccod&"'" 
	end if	
next
if arr_asignatura_elec<>"" then
arr_asignatura=arr_asignatura&","&arr_asignatura_elec
end if
'RESPONSE.Write(arr_asignatura&"<br>")
'RESPONSE.Write(arr_asignatura_elec&"<br>")
'RESPONSE.End()
formulario.primero

destino =" (SELECT a.carr_ccod,a.asig_ccod, a.secc_tdesc, a.secc_ccod,  " & vbCrLf &  _
"	  case a.carr_ccod when '"&v_carr_ccod&"'  " & vbCrLf & _
"	  then '(*)' + cast(a.asig_ccod as varchar)+ '-' + cast(a.secc_tdesc as varchar)+  ' -> ' + cast(protic.horario(a.secc_ccod) as varchar)  " & vbCrLf & _
"	  else cast(a.asig_ccod as varchar)+ '-' + cast(a.secc_tdesc as varchar) + ' -> ' + cast(protic.horario(a.secc_ccod) as varchar) " & vbCrLf & _
"	  end horario--, a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0)  " & vbCrLf & _
"	  FROM secciones a, cargas_academicas c  " & vbCrLf & _
"	  WHERE a.secc_ccod *= c.secc_ccod   " & vbCrLf & _
"	  AND cast(a.sede_ccod as varchar)='"&sede_ccod&"'  " & vbCrLf & _
"	  and cast(a.peri_ccod as varchar)= '"&peri_ccod&"'  " & vbCrLf & _
"	  and cast(a.asig_ccod as varchar) in ("&arr_asignatura&")  " & vbCrLf & _
"	  and cast(a.carr_ccod as varchar) ='"&v_carr_ccod&"'  " & vbCrLf & _
"	  GROUP BY a.asig_ccod, a.secc_ccod, a.secc_tdesc, a.secc_ncupo,carr_ccod " & vbCrLf & _
"	  HAVING a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0) > 0) a  " & vbCrLf  

'response.Write("<pre>"&destino&"</pre>")
'response.End()


filtro = "    asig_ccod in (select '%asig_ccod%' as asig_ccod ) " & vbCrLf  & _
"	 or	asig_ccod in ( select b.asig_ccod from electivos a,secciones b  " & vbCrLf  & _
" 	   			 	 where a.secc_ccod = b.secc_ccod  " & vbCrLf  & _
" 	   			 	 and  cast(b.carr_ccod as varchar) ='"&v_carr_ccod&"'  " & vbCrLf  & _
"				     and a.asig_ccod ='%asig_ccod%'  )" 
'response.Write("<pre>"&filtro&"</pre>")

formulario.agregaCampoParam "secc_ccod", "filtro", filtro
formulario.agregaCampoParam "secc_ccod", "destino", destino



Secciones =	" SELECT isnull(C.ASIG_CCOD,A.ASIG_CCOD) asig_ccod, b.secc_ccod,case a.carr_ccod when '"&v_carr_ccod&"' then " & _
	 	   	"	 	  '(*)'+cast(a.asig_ccod as varchar) + '-' + cast(a.secc_tdesc as varchar) + ' -> ' + cast(protic.horario(a.secc_ccod) as varchar)" & _
		   	" else  " & _
		   	" 	   cast(a.asig_ccod as varchar)+ '-' + cast(a.secc_tdesc as varchar)+ ' -> ' +cast(protic.horario(a.secc_ccod) as varchar)  " & _
		 	" end    horario " & _
			" FROM secciones  a, cargas_academicas b, ELECTIVOS C " & _
			" WHERE cast(b.MATR_NCORR as varchar) = '"&matr_ncorr&"' " & _
			"  AND B.SECC_CCOD *= C.SECC_CCOD" & _
			" and a.secc_ccod = b.secc_ccod " 

conectar.Ejecuta Secciones
set rec_secciones = conectar.ObtenerRS







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
rec_secciones = new Array();
<%

if (rec_secciones.BOF <> rec_secciones.EOF) then
rec_secciones.MoveFirst
j = 0
while not rec_secciones.Eof
%>
rec_secciones[<%=j%>] = new Array();
rec_secciones[<%=j%>]["asig_ccod"] = '<%=rec_secciones("asig_ccod")%>';
rec_secciones[<%=j%>]["secc_ccod"] = '<%=rec_secciones("secc_ccod")%>';
rec_secciones[<%=j%>]["horario"] = '<%=rec_secciones("horario")%>';
<%	
	rec_secciones.MoveNext
	j = j + 1
wend
end if
%>

function ver_notas()
{
//alert("muestra historico de notas");
self.open('<%=url%>','notas','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function horario(){
	self.open('horario_alumno.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}
function dibujar(formulario){
    document.getElementById("texto_alerta").style.visibility="visible";
	formulario.submit();
}
function iniciopagina(formulario){
j_ = 0
nro_filas=<%=filas_asig%>

	if (nro_filas>0) {
			for (i = 0; i < rec_secciones.length; i++) {
				for (j=0; j< nro_filas;j++){
					if(rec_secciones[i]["asig_ccod"] == formulario.elements["toma_carga["+j+"][asig_ccod]"].value){
					   	alert(formulario.elements["toma_carga["+j+"][asig_ccod]"].value)
						formulario.elements["toma_carga["+j+"][secc_ccod]"].value =rec_secciones[i]["secc_ccod"]
					}
				}
			}
	}
}


function enviar(formulario){ 
    formulario.dv.value =formulario.dv.value.toUpperCase();
  	if(preValidaFormulario(formulario)){
	   if(!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))){
	      alert('El RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
	      formulario.rut.focus();
	      formulario.rut.select();
	   }
       else{	
	      formulario.submit();
	   }
	}   
 }
 
function guardar(formulario){
formulario.method="post"
formulario.action="toma_carga_proc.asp"
formulario.submit();
}
function abrir2(){
		var matricula 	= '<%=matr_ncorr%>';
		var pers 		= '<%=pers_ncorr%>';
		var sede		= '<%=sede_ccod%>';
		var plan		= '<%=plan_ccod%>';
		var periodo     = '<%=peri_ccod%>';
		
		direccion = "busca_secciones.asp?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo;
		resultado=window.open(direccion, "ventana1","scrollbars=yes,resizable,width=750,height=400");
}
function abrir(){
		var matricula 	= '<%=matr_ncorr%>';
		var pers 		= '<%=pers_ncorr%>';
		var sede		= '<%=sede_ccod%>';
		var plan		= '<%=plan_ccod%>';
		var periodo     = '<%=peri_ccod%>';
		
		direccion = "busca_secciones_forzadas.asp?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo;
		resultado=window.open(direccion, "ventana1","scrollbars=yes,resizable,width=750,height=400");
}
function eliminar (formulario){
	if (verifica_check(formulario)){
		formulario.method="post"
		formulario.action="eliminar_equivalencias.asp";
		formulario.submit();
	}
	else{
		alert('No ha seleccionado ninguna equivalencia.');
	}
}
function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("secc_ccod","gi");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				c=c+1;
			}
		}
	}
	if (c>0) {
		return (true);
	}
	else {
		return (false);
	}
}

</script>
<STYLE type="text/css">
 <!-- 
 A {color: #000000;  text-decoration: none; font-weight: bold;}
 A:hover {COLOR: #63ABCC; }

 // -->
 </STYLE>
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.anchofijo {
	font-family: "Courier New", Courier, mono;
	font-size: 10px;
	width: 350px;
}
-->
</style>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="iniciopagina(document.edicion);MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
	<br>
	<%if not ((isnull(cantidad_matriculas)) or (cantidad_matriculas="0")) and (pers_nrut<>"") then%>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="10%"><div align="left"><strong>Carrera</strong></div></td>
				  <td width="3%"><div align="center"><strong>:</strong></div></td>
				  <td width="87%" colspan="3"><div align="left"> 
                            <%f_encabezado.DibujaCampo("carrera")%>
                            <%f_encabezado.DibujaCampo("carreras_alumno")%>
                          </div></td>
				  
                </tr>
				 <tr> 
                                <td width="13%"> <div align="left"></div></td>
								<td width="2%"> <div align="center"></div> </td>
								<td colspan="2"><div  align="center" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
                              </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	<%end if%>
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
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <%if not esVacio(q_pers_nrut) then%>
			   <table width="98%"  border="0">
                <tr>
                  <td colspan="6">&nbsp;</td>
                </tr>
				<tr>
                  <td colspan="6">&nbsp;</td>
                </tr>
				<tr>
                  <td width="64" align="left"><strong>RUT</strong></td>
				  <td width="11"  align="center"><strong>:</strong></td>
				  <td width="83"  align="left"><%f_encabezado.DibujaCampo("rut")%></td>
				  <td width="182" align="right"><strong>Nombre&nbsp;</strong></td>
				  <td width="14"  align="center"><strong>:</strong></td>
				  <td width="266"  align="left"><%f_encabezado.DibujaCampo("nombre")%></td>
                </tr>
				<tr>
                  <td width="64" align="left"><strong>Carrera</strong></td>
				  <td width="11"  align="center"><strong>:</strong></td>
				  <td  align="left" colspan="4"><%=nombre_carrera%></td>
			    </tr>
				 <tr>
                  <td width="64" align="left"><strong>Duraci&oacute;n</strong></td>
				  <td width="11"  align="center"><strong>:</strong></td>
				  <td width="83"  align="left"><%f_encabezado.DibujaCampo("duas_tdesc")%></td>
				          <td width="182" align="right"><strong>Año Ingreso &nbsp;</strong></td>
				  <td width="14"  align="center"><strong>:</strong></td>
				  <td width="266"  align="left"><%f_encabezado.DibujaCampo("ano_ingreso_plan")%></td>
                </tr>
				<%if not ((isnull(cantidad_matriculas)) or (cantidad_matriculas="0")) and (pers_nrut<>"") then%>
				<%if matr_ncorr = "" then%>
				<tr>
                  <td colspan="6">&nbsp;</td>
				</tr>
				<tr>
                  <td colspan="6" align="center"><font size="2" color="#0000FF"><strong>Debes seleccionar una carrera, del listado superior, para poder realizar la toma de carga</strong></font></td>
                </tr>
				<%else%>
				<tr>
                  <td colspan="6">&nbsp;</td>
				</tr>
				<tr>
                  <td colspan="6" align="center"><font size="2" color="#0000FF"><strong>Si presenta cualquier problema con la toma de ramos, <br>
                  comunicarte con Registro Curricular, ubicado en el 5º piso de la sede Casa Central de nuestra casa de estudios.</strong></font></td>
                </tr>
				<%end if
				else%>
				<tr>
                  <td colspan="6">&nbsp;</td>
				</tr>
				<tr>
                  <td colspan="6" align="center"><font size="2" color="#0000FF"><strong>No Existe matricula registrada en el sistema, si la tienes, <br>comunicate con la oficina de Registro Curricular 5º piso de la Sede Casa Central de nuestra casa de Estudios.</strong></font></td>
                </tr>
				<%end if%>
              </table>
			  <%end if%>

              <form name="edicion"><input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
			  <%if nombre <> "" and not bloqueado and matr_ncorr <> "" then%>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Asignaturas Asignables"%>
                      <br>
                      (*) Secciones Planificadas Para la Carrera :  <%= carrera %> </td>
                  </tr>
                </table><table width="100%" border="0">
          <tr> 
            <td align="right"><strong><font color="000000" size="1"> 
              <% formulario.pagina%>
              &nbsp;&nbsp;&nbsp;&nbsp; 
              <% formulario.accesoPagina%>
              </font></strong></td>
          </tr>
          <tr> 
            <td><strong><font color="000000" size="1"> 
              <% formulario.dibujaTabla%>
              </font></strong></td>
          </tr>
          <tr> 
            <td align="right">&nbsp;</td>
          </tr>
          <tr>
                        <td align="right">
                          <%  if filas_asig = 0 then
						          f_botonera.agregabotonparam "guardar", "deshabilitado" ,"TRUE"
						      end if
						      f_botonera.DibujaBoton "GUARDAR"%>
                        </td>
          </tr>
        </table>
        <%end if%>
    		  <input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>"> 
              <input name="b[0][pers_xdv]" type="hidden" value="<%=q_pers_xdv%>">
			  <input name="b[0][peri_ccod]" type="hidden" value="<%=q_peri_ccod%>">
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="22%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%if not((isnull(cantidad_matriculas)) or (cantidad_matriculas="0")) and (pers_nrut<>"") then%>
				                             <% if matr_ncorr= "" then
				  									f_botonera.agregaBotonParam "HORARIO","deshabilitado",""
				  							  end if
				                              f_botonera.DibujaBoton "HORARIO"%>
										   <%end if%>	  
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "SALIR"%>
                  </div></td>
                  <td><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="78%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
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
