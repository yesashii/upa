<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
matr_ncorr = Request.QueryString("enca[0][carreras_alumno]")
'---------------------------------------------------------------------------------------------------
'response.Write(matr_ncorr)
set pagina = new CPagina
pagina.Titulo = "Carga Registrada"

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "inicio_toma_carga_alfa.xml", "botonera"

set botonera = new CFormulario
botonera.Carga_Parametros "toma_carga_alfa.xml", "BotoneraTomaCarga"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "inicio_toma_carga_alfa.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


hora = time()
response.Write(hora)
'---------- asignamos por defecto el primer semestre año 2006 para el proseso de toma de carga
actividad = session("_actividad")
'response.Write("a "&actividad)
if (actividad = "7")  then
	v_peri_ccod = negocio.obtenerPeriodoAcademico("TOMACARGA")
else
	v_peri_ccod = negocio.obtenerPeriodoAcademico("CLASES18")
end if
sede_ccod = negocio.obtenerSede

'----------------------Si el periodo es segundo semestre debemos crear la matricula del alumno para tomarle ramos.
if not EsVacio(q_pers_nrut) then
    pers_ncorr_temporal = conexion.consultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
   	'response.Write("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	if pers_ncorr_temporal <> "" then
		es_moroso = conexion.consultaUno("select protic.es_Moroso("&pers_ncorr_temporal&",getDate())")
		tiene_bloqueos = conexion.consultaUno("select count(*) from bloqueos where eblo_ccod=1 and cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
		tipo_bloqueo = conexion.consultaUno("select protic.initcap(tblo_tdesc) from bloqueos a, tipos_bloqueos b where a.tblo_ccod=b.tblo_ccod and eblo_ccod=1 and cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
	end if

'caso especial de forma de pago
if  pers_ncorr_temporal="13340" or pers_ncorr_temporal="22682" or pers_ncorr_temporal="20886" or pers_ncorr_temporal="98891" or pers_ncorr_temporal="18366" or pers_ncorr_temporal="22207" or pers_ncorr_temporal="22448" then
	es_moroso="N"
end if

'response.Write(es_moroso)	
	v_plec_ccod = conexion.ConsultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar) = '" & v_peri_ccod & "'")
	if v_plec_ccod = "2" and es_moroso <> "S" and sede_ccod <> "" and tiene_bloqueos = "0" then
		sentencia = "exec CREAR_MATRICULA_SEG_SEMESTRE_VERSION_2 '" & sede_ccod & "', '" & q_pers_nrut & "', '" & v_peri_ccod& "'"
		'response.Write(sentencia)
		conexion.EjecutaPsql(sentencia)
	end if
	
	if v_plec_ccod = "3" and es_moroso <> "S" and sede_ccod <> "" and tiene_bloqueos = "0" then
		sentencia = "exec CREAR_MATRICULA_TER_TRIMESTRE_VERSION_2 '" & sede_ccod & "', '" & q_pers_nrut & "', '" & v_peri_ccod& "'"
		'response.Write(sentencia)
		conexion.EjecutaPsql(sentencia)
	end if
	
end if
'response.End()

pers_ncorr_temporal = conexion.consultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
peri_tdesc= conexion.consultaUno("Select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")


'response.Write(pers_ncorr_temporal)
rut = conexion.consultaUno("select cast(pers_nrut as varchar)+ '-'+pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
nombre = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

'buscamos la cantidad de matriculas, para distintas carreras, que el alumnos tenga en el sistema......................................
c_cantidad_carreras = " select count(*) " & vbCrLf &_
					" from alumnos a, ofertas_academicas b, especialidades c " & vbCrLf &_
					" where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"'  " & vbCrLf &_
					" and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
					" and b.espe_ccod=c.espe_ccod " & vbCrLf &_
					" and a.emat_ccod = 1 " & vbCrLf &_
					" and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"' " & vbCrLf &_
					" and cast(sede_ccod as varchar)= '"&sede_ccod&"'"
					
cantidad_carreras = conexion.consultaUno(c_cantidad_carreras)




if cantidad_carreras = "1" then 
    if esVacio(matr_ncorr) then
			consulta_matr=" Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
						  " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and emat_ccod in (1,2,4,8,10) "&_
						  " and cast(c.peri_ccod as varchar)='"&v_peri_ccod&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
							
			matr_ncorr= conexion.consultaUno(consulta_matr)	
    end if
	
	carrera = conexion.consultaUno("select carr_tdesc + ' -- ' + c.espe_tdesc from alumnos a, ofertas_academicas b, especialidades c, carreras d where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"' and cast(b.sede_ccod as varchar)='"&sede_ccod&"' and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and emat_ccod in (1,2,4,8,10) ")

elseif  cantidad_carreras = "0" then 
	c_cantidad_carreras = " select count(*) " & vbCrLf &_
					" from alumnos a, ofertas_academicas b, especialidades c " & vbCrLf &_
					" where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"'  " & vbCrLf &_
					" and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
					" and b.espe_ccod=c.espe_ccod " & vbCrLf &_
					" and a.emat_ccod = 1 " & vbCrLf &_
					" and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"' " 
	
	if conexion.consultaUno(c_cantidad_carreras) > "0" then
		sede_tdesc = conexion.consultaUno("Select protic.initCap(sede_tdesc) from alumnos a, ofertas_academicas b, sedes c where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr  and b.sede_ccod=c.sede_ccod and a.emat_ccod = 1 and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"'")
		mensaje = "El alumno no presenta matricula activa en el sistema para esta sede, tiene una en la sede " & sede_tdesc
	else
	     consulta_no_activa = "Select protic.initCap(emat_tdesc) from alumnos a, ofertas_academicas b, estados_matriculas c where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr  and a.emat_ccod = c.emat_ccod and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"'"
	     no_activa= conexion.consultaUno(consulta_no_activa)
		 if not Esvacio(no_activa) and no_activa <> "" then
		 	mensaje = "El alumno no presenta matricula activa en el sistema, su última matricula esta en estado "& no_activa
		 else
		 	mensaje = "El Alumno no presenta matricula activa para el periodo consultado."	
		 end if
	end if

elseif cantidad_carreras > "1" then

if esVacio(matr_ncorr) then
	consulta_matr=" Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
	              " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and emat_ccod in (1,2,4,8,10) "&_
				  " and cast(c.peri_ccod as varchar)='"&v_peri_ccod&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
				  	
	matr_ncorr= conexion.consultaUno(consulta_matr)	
end if

carrera = conexion.consultaUno("Select carr_ccod from alumnos a, ofertas_Academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( matr_ncorr as varchar)='"&matr_ncorr&"'")
'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "inicio_toma_carga_alfa.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       ltrim(rtrim(protic.obtener_nombre_carrera(b.ofer_ncorr, 'C'))) as carrera, protic.ano_ingreso_carrera(b.pers_ncorr, d.carr_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod " 
		   if not esVacio(carrera) then
		   		consulta=consulta & " and cast(d.carr_ccod as varchar)='"&carrera&"'"
		   else
				consulta=consulta & "  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) " 
		   end if
		   consulta=consulta &"  and b.emat_ccod in (1,2,4,8,10) " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
		   
consulta_carrera= "(select distinct a.matr_ncorr , ltrim(rtrim(d.carr_tdesc)) as carr_tdesc " & vbCrLf &_
				  " from alumnos a, ofertas_academicas b, especialidades c, carreras d " & vbCrLf &_
				  " where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' " & vbCrLf &_
				  " and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
				  " and b.espe_ccod=c.espe_ccod " & vbCrLf &_
				  " and c.carr_ccod=d.carr_ccod  and a.emat_ccod in (1,2,4,8,10) " & vbCrLf &_
				  " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"')s"
 				 
'response.Write("<pre>"&consulta_carrera&"</pre>")
f_encabezado.AgregaCampoParam "carreras_alumno","permiso","LECTURAESCRITURA"
f_encabezado.AgregaCampoParam "carrera","permiso","OCULTO"				 



'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
f_encabezado.AgregaCampoCons "carreras_alumno", matr_ncorr
f_encabezado.AgregaCampoParam "carreras_alumno","destino",consulta_carrera
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")

'---------------------------------------------------------------------------------------------------	
	
end if 

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
		   " union " & vbCrLf &_
		   " select c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
		   " protic.horario_con_sala(b.secc_ccod) as horario,case isnull(acse_ncorr,0) when 0 then 'Equivalencia' else 'Carga Extraordinaria' end as tipo, " & vbCrLf &_
		   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
           "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
		   " from equivalencias a, secciones b, asignaturas c,cargas_academicas ca " & vbCrLf &_
		   " where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
		   " and a.secc_ccod=b.secc_ccod  and a.matr_ncorr=ca.matr_ncorr and a.secc_ccod = ca.secc_ccod" & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod "

if v_plec_ccod = "2" and matr_ncorr <> "" then
	carrera_a_consultar= conexion.consultaUno("select carr_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
    primer_peri_ccod = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod = 1")    
    'response.Write("carrera "&carrera_a_consultar&" periodo "&primer_peri_ccod&" pers_ncorr "&pers_ncorr_temporal)
	consulta = consulta & "union      select f.asig_ccod as cod_asignatura, f.asig_tdesc as asignatura,e.secc_tdesc as seccion, " & vbCrLf &_
			   "     protic.horario_con_sala(e.secc_ccod) as horario, case acse_ncorr when 3 then 'Carga sin Pre-requisitos' else case d.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, " & vbCrLf &_
			   "     isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb " & vbCrLf &_
			   "             where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=f.asig_ccod),0) as creditos " & vbCrLf &_
			   "    from alumnos a, ofertas_academicas b, especialidades c, cargas_academicas d, secciones e, asignaturas f " & vbCrLf &_
			   "    where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
			   "    and cast(b.peri_ccod as varchar)='"&primer_peri_ccod&"' and b.espe_ccod=c.espe_ccod  " & vbCrLf &_
			   "    and c.carr_ccod='"&carrera_a_consultar&"' and a.emat_ccod in (1,4,8) and f.duas_ccod=3 " & vbCrLf &_
			   "    and not exists (Select 1 from equivalencias eq where eq.matr_ncorr=d.matr_ncorr and eq.secc_ccod=d.secc_ccod)  " & vbCrLf &_
			   "    and a.matr_ncorr=d.matr_ncorr and d.secc_ccod=e.secc_ccod and e.asig_ccod=f.asig_ccod " & vbCrLf &_
			   " union " & vbCrLf &_
			   "    select f.asig_ccod as cod_asignatura, f.asig_tdesc as asignatura,e.secc_tdesc as seccion, " & vbCrLf &_
			   "    protic.horario_con_sala(e.secc_ccod) as horario, case isnull(acse_ncorr,0) when 0 then 'Equivalencia' else 'Carga Extraordinaria' end as tipo, " & vbCrLf &_
			   "    isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb " & vbCrLf &_
			   "            where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=f.asig_ccod),0) as creditos " & vbCrLf &_
    		   "    from alumnos a, ofertas_academicas b, especialidades c, equivalencias d, secciones e, asignaturas f,cargas_academicas ca " & vbCrLf &_
			   "    where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
			   "    and cast(b.peri_ccod as varchar)='"&primer_peri_ccod&"' and b.espe_ccod=c.espe_ccod  " & vbCrLf &_
		       "    and c.carr_ccod='"&carrera_a_consultar&"' and a.emat_ccod in (1,4,8) " & vbCrLf &_
			   "    and a.matr_ncorr=d.matr_ncorr and d.secc_ccod=e.secc_ccod and e.asig_ccod=f.asig_ccod and f.duas_ccod=3 " & vbCrLf &_
			   "    and d.matr_ncorr=ca.matr_ncorr and d.secc_ccod=ca.secc_ccod"
	
end if

'response.Write("<pre>"&consulta&"</pre>")
f_alumno.Consultar consulta

if matr_ncorr <> "" then

	tipo_plan = conexion.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and emat_ccod in (1,2,4,8,10)")
	if tipo_plan = "0" then
		mensaje_plan = "El Alumno Esta cursando un plan de estudios regulado por Sesiones"
	else
		mensaje_plan = "El Alumno esta cursando un plan de Estudios regulado por Sistema Créditos."
	end if		
	es_moroso = conexion.consultaUno("select protic.es_Moroso("&pers_ncorr_temporal&",getDate())")


'caso especial de forma de pago 
if  pers_ncorr_temporal="13340" or pers_ncorr_temporal="22682" or  pers_ncorr_temporal="20886" or pers_ncorr_temporal="98891" or pers_ncorr_temporal="18366" or pers_ncorr_temporal="22207" or pers_ncorr_temporal="22448"  then
	es_moroso="N"
end if

carrera_a_consultar= conexion.consultaUno("select carr_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")

if sys_considerar_evaluacion_docente <> false then 	

			if v_plec_ccod = "1" then
					
				ano_consulta = cint(anos_ccod) -1
				consulta_contestadas= " select count(*) " & vbCrLf &_	
									  " from alumnos a, ofertas_academicas b,especialidades c,cargas_academicas d " & vbCrLf &_	
									  " where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' " & vbCrLf &_	
									  " and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_	
									  " and b.peri_ccod in (select peri_ccod from periodos_Academicos where cast(anos_ccod as varchar)='"&ano_consulta&"') " & vbCrLf &_	
									  " and b.espe_ccod=c.espe_ccod and c.carr_ccod ='"&carrera_a_consultar&"' " & vbCrLf &_	
									  " and a.matr_ncorr=d.matr_ncorr and emat_ccod in (1,2,4,8,10) " & vbCrLf &_	
									  " and exists (select 1 from bloques_horarios bb,bloques_profesores cc where bb.secc_ccod=d.secc_ccod and bb.bloq_ccod=cc.bloq_ccod and cc.tpro_ccod=1)  " & vbCrLf &_	
									  " and not exists (select 1 from evaluacion_docente ed where ed.secc_ccod=d.secc_ccod and ed.pers_ncorr_encuestado=a.pers_ncorr) " 							  
			
				con_encuesta = conexion.consultaUno(consulta_contestadas)
				
			elseif v_plec_ccod = "2" then
				consulta_contestadas= " select count(*) from personas a, alumnos b, ofertas_academicas c, especialidades d, " & vbCrLf &_
									  " cargas_academicas e,secciones f, asignaturas g  " & vbCrLf &_
									  " where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' " & vbCrLf &_
									  " and a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and isnull(sitf_ccod,'N')<>'N'" & vbCrLf &_
									  " and c.peri_ccod = (select peri_ccod from periodos_academicos where plec_ccod=1 and anos_ccod='"&anos_ccod&"') " & vbCrLf &_
									  " and b.emat_ccod in (1,2,4,8,10) and c.espe_ccod=d.espe_ccod and cast(d.carr_ccod as varchar)='"&carrera_a_consultar&"' " & vbCrLf &_
									  " and b.matr_ncorr=e.matr_ncorr and e.secc_ccod=f.secc_ccod and f.asig_ccod=g.asig_ccod and g.duas_ccod <> 3 " & vbCrLf &_
									  " and exists (select 1 from bloques_horarios bb,bloques_profesores cc where bb.secc_ccod=f.secc_ccod and bb.bloq_ccod=cc.bloq_ccod and cc.tpro_ccod=1) " & vbCrLf &_
									  " and not exists (select 1 from evaluacion_docente ed where ed.secc_ccod=f.secc_ccod and ed.pers_ncorr_encuestado=a.pers_ncorr) "
			
			  con_encuesta = conexion.consultaUno(consulta_contestadas)
			  'response.Write("<pre>"&consulta_contestadas&"</pre>")
			elseif v_plec_ccod = "3" then
				consulta_contestadas= " select count(*) from personas a, alumnos b, ofertas_academicas c, especialidades d, " & vbCrLf &_
									  " cargas_academicas e,secciones f, asignaturas g  " & vbCrLf &_
									  " where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' " & vbCrLf &_
									  " and a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and isnull(sitf_ccod,'N')<>'N'" & vbCrLf &_
									  " and c.peri_ccod = (select peri_ccod from periodos_academicos where plec_ccod=2 and anos_ccod='"&anos_ccod&"') " & vbCrLf &_
									  " and b.emat_ccod in (1,2,4,8,10) and c.espe_ccod=d.espe_ccod and cast(d.carr_ccod as varchar)='"&carrera_a_consultar&"' " & vbCrLf &_
									  " and b.matr_ncorr=e.matr_ncorr and e.secc_ccod=f.secc_ccod and f.asig_ccod=g.asig_ccod and g.duas_ccod <> 3 " & vbCrLf &_
									  " and exists (select 1 from bloques_horarios bb,bloques_profesores cc where bb.secc_ccod=f.secc_ccod and bb.bloq_ccod=cc.bloq_ccod and cc.tpro_ccod=1) " & vbCrLf &_
									  " and not exists (select 1 from evaluacion_docente ed where ed.secc_ccod=f.secc_ccod and ed.pers_ncorr_encuestado=a.pers_ncorr) "
			
			  con_encuesta = conexion.consultaUno(consulta_contestadas)
			  'con_encuesta = "0"
			  'response.Write("<pre>"&consulta_contestadas&"</pre>")
			end if
			
			'--------------no se le podra tomar carga a los alumnos que no hallan contestado la evaluación docente.
			'con_encuesta = conexion.consultaUno("select count(*)  from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr_temporal&"'")
			if con_encuesta > "0" then
				'response.Write("entre")
				mensaje_encuesta = "El Alumno no ha realizado todas las evaluaciones de docentes que le corresponden, esto es necesario para poder hacer la toma de ramos."
			end if
	end if '------------------------para no considerar encuesta docente

	
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

'response.Write("tipo_plan "&tipo_plan&" matr_ncorr "&matr_ncorr)

if tipo_plan <> "0" and matr_ncorr <> "" then
    'response.Write("<br>select protic.obtener_creditos_asignados("&matr_ncorr&")")
	suma_creditos = conexion.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
end if


'response.Write("suma_creditos " &suma_creditos)

url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&ocultar=1"

'-------------buscamos el año de el periodo si es mayor a 2005 agregamos a la tabla asignaturas_comunes-----------
anos_ccod= conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
if anos_ccod > "2005" then 
 consulta_insercion = " insert into asignaturas_comunes (mall_ccod,carr_ccod,asig_ccod,plan_ccod,peri_ccod,audi_tusuario,audi_fmodificacion) " & vbCrLf &_
					  " select distinct a.mall_ccod,a.carr_ccod,a.asig_ccod,b.plan_ccod,a.peri_ccod,'Agregado Sistema' as audi_tusuario, getDate() as audi_tusuario " & vbCrLf &_
					  " from secciones a,malla_curricular b, planes_estudio c " & vbCrLf &_
					  "	where cast(peri_ccod as varchar)='"&v_peri_ccod&"' and a.mall_ccod=b.mall_ccod and b.plan_ccod=c.plan_ccod " & vbCrLf &_
					  "	and isnull(c.plan_tcreditos,0) = 0 " & vbCrLf &_
					  " and not exists( select 1 from asignaturas_comunes ac where b.mall_ccod=ac.mall_ccod) " & vbCrLf &_
					  "	and a.carr_ccod <> '820' "

'response.Write("<pre>"&consulta_insercion&"</pre>")					  
conexion.ejecutaS(consulta_insercion)					  
end if

'----------------------debemos ver si el alumno esta bien encasillado con el plan de estudios y la especialidad
'-----------------------------agregado por Marcelo Sandoval-----------------------------------------
especialidad_plan = conexion.consultaUno("select b.espe_ccod from alumnos a, planes_estudio b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.plan_ccod=b.plan_ccod")
especialidad_oferta = conexion.consultaUno("select b.espe_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr")
'response.Write("especialidad_plan "&especialidad_plan&" especialidad_oferta "&especialidad_plan&" matr_ncorr "&matr_ncorr)
if especialidad_plan <> especialidad_oferta and matr_ncorr <> "" then 
    'response.Write("entro")
	mensaje_distintos = "Imposible realizar la toma de carga del alumno, ya que presenta problemas con el plan de estudios asignado, haga el favor de corregir este tema en el <strong>Mantenedor de cambio de especialidades</strong>. Luego podrá tomarle las asignaturas."
end if	

'response.End()	
'---------------------------------------------------------------------------------------------------------
'response.Write(matr_ncorr)
'debemos cerrar el proceso de toma de carga académica para cuaquier persona que tenga acceso a ella exceptuando registro curricular.
jornada_matricula = conexion.consultaUno("select b.jorn_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr")
usuario_sesion = negocio.obtenerUsuario
sin_restriccion = conexion.consultaUno("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=2 and cast(a.pers_nrut as varchar)='"&usuario_sesion&"'")

'response.Write("jornada_matricula "	&jornada_matricula&" sin_restriccion "&sin_restriccion)

if jornada_matricula ="1" and sin_restriccion ="0" then
	cerrar_carga_diurno = true 
end if


cerrar_carga_diurno = false

'response.Write(cerrar_carga_diurno)

'if q_pers_nrut = "12108410" then
'	es_moroso = "N"
'end if
bloquear_toma_diurnos="S"

if not EsVacio(q_pers_nrut) and pers_ncorr_temporal <> "" then
    'response.Write("select protic.ultima_oferta_matriculado('"&pers_ncorr_temporal&"')")
	ultima_oferta_prueba = conexion.consultaUno("select protic.ultima_oferta_matriculado('"&pers_ncorr_temporal&"')")
	'response.Write("select protic.ultima_oferta_matriculado('"&pers_ncorr_temporal&"')")
	jornada_prueba = conexion.consultaUno("select jorn_ccod from ofertas_academicas where cast(ofer_ncorr as varchar)='"&ultima_oferta_prueba&"'")
	carrera_prueba = conexion.consultaUno("select ltrim(rtrim(carr_ccod)) from ofertas_academicas a, especialidades b  where cast(a.ofer_ncorr as varchar)='"&ultima_oferta_prueba&"' and a.espe_ccod=b.espe_ccod")
	
	if jornada_prueba = "1" then
		fecha_prueba=  conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'31/03/2007',103) then 'S' else 'N' end ")
	else
		fecha_prueba=  conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'13/04/2007',103) then 'S' else 'N' end ")
	end if	
	
	'response.Write("fecha "&fecha_prueba&" carr "&carrera_prueba&" jor "&jornada_prueba)
	if fecha_prueba = "S" then 'and carrera_prueba <> "45" and jornada_prueba <> "2" then
		bloquear_toma_diurnos = "S"
	else
		bloquear_toma_diurnos = "N"	
	end if
	
	'response.Write(carrera_prueba)
	if carrera_prueba = "45" then
		fecha_prueba=  conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'31/03/2007',103) then 'S' else 'N' end ")
		if fecha_prueba = "S" then 'and carrera_prueba <> "45" and jornada_prueba <> "2" then
			bloquear_toma_diurnos = "S"
		else
			bloquear_toma_diurnos = "N"	
		end if
	end if
	
	if carrera_prueba  = "12" or carrera_prueba="890" or carrera_prueba="900" or carrera_prueba="910" then
		fecha_prueba=  conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'30/12/2007',103) then 'S' else 'N' end ")
		if fecha_prueba = "S" then 'and carrera_prueba <> "45" and jornada_prueba <> "2" then
			bloquear_toma_diurnos = "S"
		else
			bloquear_toma_diurnos = "N"	
		end if
	end if
	
	if carrera_prueba  = "920" or carrera_prueba="930" then
		fecha_prueba=  conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'13/04/2007',103) then 'S' else 'N' end ")
		if fecha_prueba = "S" then 'and carrera_prueba <> "45" and jornada_prueba <> "2" then
			bloquear_toma_diurnos = "S"
		else
			bloquear_toma_diurnos = "N"	
		end if
	end if
	
	'response.Write(bloquear_toma_diurnos)
end if

if v_plec_ccod = "3" then
		bloquear_toma_diurnos = "N"
end if
'if sin_restriccion <> "0" then
'	bloquear_toma_diurnos = "N"
'end if	

if sede_ccod = "7" and es_moroso <> "S" then
	bloquear_toma_diurnos = "N"
end if
response.Write("vamos acá ")
'response.End()	
'response.Write(bloquear_toma_diurnos)
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
function dibujar(formulario){
	formulario.submit();
}
function ver_notas()
{
self.open('<%=url%>','notas','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function horario(){
	self.open('horario.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function imprimir() {
  var direccion;
  direccion="impresion_carga.asp";
  window.open(direccion ,"ventana1","width=520,height=540,scrollbars=yes, left=313, top=200");
}

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
            <td><%pagina.DibujarLenguetas Array("Toma de Asignaturas Escuela"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right"><strong>R.U.T. Alumno </strong></div></td>
                        <td width="50"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.DIbujaCampo("pers_nrut")%> - <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
              <%pagina.Titulo = "Carga Registrada <br>(" &peri_tdesc&")"
			    pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
				  	<td colspan="3">&nbsp;<input type="hidden" name="busqueda[0][pers_nrut]" value="<%=q_pers_nrut%>">
					<input type="hidden" name="busqueda[0][pers_xdv]" value="<%=q_pers_xdv%>">
					</td>
				  </tr>
				  <tr>
				  	<td colspan="3">&nbsp;</td>
				  </tr>
				  <%if q_pers_nrut <> "" then %>
				  <tr>
				  	<td width="10%"><strong>Rut</strong></td>
				  	<td width="1%"><strong>:</strong></td>
				  	<td><%=rut%></td>
				  </tr>
				  <tr>
				  	<td width="10%"><strong>Nombre</strong></td>
				  	<td width="1%"><strong>:</strong></td>
				  	<td><%=nombre%></td>
				  </tr>
				  <%end if%>
				  <%if cantidad_carreras = "1" then %>
				  <tr>
				  	<td width="10%"><strong>Carrera</strong></td>
				  	<td width="1%"><strong>:</strong></td>
				  	<td><%=carrera%></td>
				  </tr>
				  <%elseif cantidad_carreras > "1" then %>
				  <tr>
				  	<td colspan="3">&nbsp;</td>
				  </tr>
				  <tr>
				  	<td colspan="3"><strong>Se ha detectado que tiene más de una matricula activa para el periodo.<br> Seleccione la carrera a consultar: </strong>
				  	  <%f_encabezado.DibujaCampo("carreras_alumno")%></td>
				  </tr>
				  <%end if%>
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
				  <%if matr_ncorr <> "" then %>
				  <tr>
                    <td colspan="3"><%pagina.DibujarSubtitulo "Carga Académica Registrada"%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="right">Pagina <%f_alumno.accesoPagina%></div></td>
                        </tr>
						<tr>
                          <td><div align="center"><%f_alumno.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
				  <%end if%>
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
				  <%if mensaje_plan <> "" then%>
				  <tr>
				  	<td colspan="3" align="center"><font  size="2"color="#0000FF"><strong><%=mensaje_plan%></strong></font>
					</td>
				  </tr>
				  <%end if%>
				  <%if tipo_plan <> "0" then%>
					  <%if cdbl(suma_creditos) >= 9 and cdbl(suma_creditos) <= 27 and f_alumno.nroFilas > 0 then%>
					  <tr>
						<td colspan="3" align="center"><font  size="2"color="#0000FF"><strong>Total de Cr&eacute;ditos Asignados <%=suma_creditos%></strong></font>
						</td>
					  </tr>
				     <%end if%>  
				  <%end if%>
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
				  <%if q_pers_nrut <> ""  then%>
				  <tr>
				  	<td colspan="3" align="center">
							<table width="90%" border="2" align="center">
								<tr>
									<td align="center"><font  size="2"></font><strong>Si presenta problemas para tomar asignaturas se puede deber a los siguientes motivos:</strong></font>
									</td>
								</tr>
								 <%if tipo_plan <> "0" and (cdbl(suma_creditos) < 9 or cdbl(suma_creditos) > 27) and f_alumno.nroFilas > 0 then%>
								  <tr>
									<td align="left">- El total de Cr&eacute;ditos Asignados (<%=suma_creditos%>), esta fuera del rango permitido (9-27).</strong></font>
									</td>
								  </tr>
								  <%end if%>
								   <%if mensaje <> "" and q_pers_nrut <> ""  then %>
								  <tr>
									<td align="left">- Se ha detectado que : <%=mensaje%></td>
								  </tr>
								  <%end if%>
								  <%if es_moroso = "S" and q_pers_nrut <> ""  then %>
								  <tr>
									<td align="left">- Se ha detectado que presenta una morosidad en su cuenta corriente, su deuda debe estar saldada para poder hacer la toma de ramos.</td>
								  </tr>
								  <%end if%>
								  <%if mensaje_encuesta<> "" then %>
								  <tr>
									<td align="left">- <%=mensaje_encuesta%></td>
								  </tr>
								  <%end if%>
								  <%if mensaje_distintos <> "" and q_pers_nrut <> ""  then %>
								  <tr>
									<td align="left">- <%=mensaje_distintos%></td>
								  </tr>
								  <%end if%>
								  <%if tiene_bloqueos <>"0" then %>
								  <tr>
									<td align="left">- Se ha detectado que presenta un bloqueo del  tipo: <%=tipo_bloqueo%></td>
								  </tr>
								  <%end if%>
								  <%if cerrar_carga_diurno then%>
								  <tr>
									 <td align="left">- Lo sentimos pero el proceso de toma de Asignaturas Online finalizó el día 08 de Agosto del presente.</td>
								  </tr>
								  <%end if%>
								
							</table>
					</td>
				  </tr>
				  <%end if%>
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
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
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                  <td><div align="center"><% if cerrar_carga_diurno then
				                                 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"       
				  							 end if
				                            
											 if matr_ncorr = "" or mensaje_distintos <> "" then 
				                             	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if 
											 if  mensaje_encuesta <> "" then 
											     f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											 if  es_moroso ="S" then
											 	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											 if tiene_bloqueos <> "0" then
											 	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											  if bloquear_toma_diurnos = "S" then
											   f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if 
											 if sin_restriccion <> "0" then
											 	f_botonera.AgregaBotonParam "siguiente","deshabilitado","FALSE"
											 end if	 

											 f_botonera.DibujaBoton("siguiente")%></div></td>
                  
				  <%if matr_ncorr <> "" then%>
				  <td><div align="center">
                    <%botonera.DibujaBoton "HORARIO"%>
                  </div></td>
                  <td><div align="center"><% botonera.DibujaBoton "NOTAS"%></div></td>
    			   <td><div align="center"><%f_botonera.DibujaBoton ("imprimir")%></div></td>
				  <%end if%>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
