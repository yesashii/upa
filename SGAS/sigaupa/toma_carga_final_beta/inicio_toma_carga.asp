<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
q_peri_ccod = Request.QueryString("busqueda[0][peri_ccod]")
q_sede_ccod = Request.QueryString("busqueda[0][sede_ccod]")
matr_ncorr = Request.QueryString("enca[0][carreras_alumno]")
'response.write(matr_ncorr)
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Carga Registrada"

set errores = new CErrores

'conexion a servidor de alumnos consultas generales
'set conexion2 = new CConexion2
'conexion2.Inicializar "upacifico"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set conexion2 = new CConexion2
'conexion2.Inicializar "upacifico"

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
f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod
f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod
'response.Write("1")
'actividad = session("_actividad")
'if (actividad = "7")  then
'	v_peri_ccod = negocio.obtenerPeriodoAcademico("TOMACARGA")
'else
'	v_peri_ccod = negocio.obtenerPeriodoAcademico("CLASES18")
'end if
v_peri_ccod = q_peri_ccod
'sede_ccod = negocio.obtenerSede
sede_ccod = q_sede_ccod
session("_actividad")= 7
session("_periodo_TOMACARGA") 	= v_peri_ccod
session("_periodo")= v_peri_ccod
session("sede") = sede_ccod		
usur= negocio.obtenerUsuario
'response.Write(usur)
'----------------------Si el periodo es segundo semestre debemos crear la matricula del alumno para tomarle ramos.
if not EsVacio(q_pers_nrut) then
    pers_ncorr_temporal = conexion.consultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	if pers_ncorr_temporal <> "" then
	      consulta_datos_act = " select case count(*) when 0 then 'NO' else 'SI' end "&_
							   " from act_datos_personales "&_
							   " where cast(pers_ncorr as varchar) = '"&pers_ncorr_temporal&"'"
			
			datos_act = conexion.consultaUno(consulta_datos_act)
		    if datos_act <> "SI" and q_peri_ccod="228" then	
		    	response.Redirect("Act_Usuarios.asp?pers_nrut="&q_pers_nrut)
		    end if
		'es_moroso = conexion.consultaUno("select protic.es_Moroso("&pers_ncorr_temporal&",getDate())")
		tiene_bloqueos = conexion.consultaUno("select count(*) from bloqueos where eblo_ccod=1 and cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
		tipo_bloqueo = conexion.consultaUno("select protic.initcap(tblo_tdesc) from bloqueos a, tipos_bloqueos b where a.tblo_ccod=b.tblo_ccod and eblo_ccod=1 and cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
	end if
    
    'response.Write(tiene_bloqueos)
	'caso especial de forma de pago
	'if  pers_ncorr_temporal="13340" or pers_ncorr_temporal="22682" or pers_ncorr_temporal="20886" or pers_ncorr_temporal="98891" or pers_ncorr_temporal="18366" or pers_ncorr_temporal="22207" or pers_ncorr_temporal="22448"  then
		es_moroso="N"
	'end if
	'response.Write(es_moroso)	
		v_plec_ccod = conexion.ConsultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar) = '" & v_peri_ccod & "'")
        if v_plec_ccod <> "1" and pers_ncorr_temporal <> "" then
			es_moroso = conexion.consultaUno("select protic.es_Moroso("&pers_ncorr_temporal&",getDate())")
		end if
        
		if pers_ncorr_temporal="195125" then
			es_moroso="N"
		End if
		
		tiene_matr_ajuste = conexion.consultaUno("select count(*) from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"' and isnull(a.alum_nmatricula,0) = 7777 ")
		
		if v_plec_ccod = "2" and es_moroso <> "S" and sede_ccod <> "" and tiene_bloqueos = "0" and tiene_matr_ajuste = "0" then
			sentencia = "execute CREAR_MATRICULA_SEG_SEMESTRE_VERSION_2 "&sede_ccod&","&q_pers_nrut&","&v_peri_ccod
			'response.Write(sentencia)
			conexion.EjecutaPsql(sentencia)
		end if
	    'response.End()
		
		if v_plec_ccod = "3" and es_moroso <> "S" and sede_ccod <> "" and tiene_bloqueos = "0" and tiene_matr_ajuste = "0" then
			sentencia = "exec CREAR_MATRICULA_TER_TRIMESTRE_VERSION_2 '" & sede_ccod & "', '" & q_pers_nrut & "', '" & v_peri_ccod& "'"
			conexion.EjecutaPsql(sentencia)
		end if
		'response.Write(sentencia)
		
		
end if
'response.End()

pers_ncorr_temporal = conexion.consultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
peri_tdesc= conexion.consultaUno("Select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
primer_semestre= conexion.consultaUno("Select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=1")
segundo_semestre= conexion.consultaUno("Select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=2")
'response.Write("4")
rut = conexion.consultaUno("select cast(pers_nrut as varchar)+ '-'+pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
nombre = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'response.Write("5")
'buscamos la cantidad de matriculas, para distintas carreras, que el alumnos tenga en el sistema......................................
c_cantidad_carreras = " select count(*) " & vbCrLf &_
					" from alumnos a (nolock), ofertas_academicas b, especialidades c " & vbCrLf &_
					" where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"'  " & vbCrLf &_
					" and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
					" and b.espe_ccod=c.espe_ccod " & vbCrLf &_
					" and a.emat_ccod in (1,4) and isnull(alum_nmatricula,0) <> 7777 " & vbCrLf &_
					" and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"' " & vbCrLf &_
					" and cast(sede_ccod as varchar)= '"&sede_ccod&"'"
					
cantidad_carreras = conexion.consultaUno(c_cantidad_carreras)

'response.Write("<pre>"&c_cantidad_carreras&"</pre>")

'response.Write("."&cantidad_carreras)
if cantidad_carreras = "1" then 
'response.Write(matr_ncorr)
    if esVacio(matr_ncorr) then
			consulta_matr=" Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
						  " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and emat_ccod in (1,2,4,8,10) and cast(c.sede_ccod as varchar)= '"&sede_ccod&"' "&_
						  " and cast(c.peri_ccod as varchar)='"&v_peri_ccod&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'  and isnull(alum_nmatricula,0) <> 7777 "&_
						  " order by b.emat_ccod asc "
							
			matr_ncorr= conexion.consultaUno(consulta_matr)	
			
    end if
	carrera = conexion.consultaUno("select carr_tdesc from alumnos a, ofertas_academicas b, especialidades c, carreras d where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"' and cast(b.sede_ccod as varchar)='"&sede_ccod&"' and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and emat_ccod in (1,2,4,8,10)  and isnull(alum_nmatricula,0) <> 7777 ")
	
	especialidad = conexion.consultaUno("select espe_tdesc from alumnos a, ofertas_academicas b, especialidades c, carreras d where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"' and cast(b.sede_ccod as varchar)='"&sede_ccod&"' and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and emat_ccod in (1,2,4,8,10)  and isnull(alum_nmatricula,0) <> 7777 ")
	
	tipo_alumnoUpa = conexion.consultaUno("select talu_tdesc from alumnos a, ofertas_academicas b, tipos_alumnos c where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"' and a.talu_ccod=c.talu_ccod  and isnull(alum_nmatricula,0) <> 7777 ")
	'response.write(tipo_alumnoUpa)

elseif  cantidad_carreras = "0" then 

	c_cantidad_carreras = " select count(*) " & vbCrLf &_
					" from alumnos a, ofertas_academicas b, especialidades c " & vbCrLf &_
					" where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"'  " & vbCrLf &_
					" and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
					" and b.espe_ccod=c.espe_ccod " & vbCrLf &_
					" and a.emat_ccod in (1,4) and isnull(alum_nmatricula,0) <> 7777 " & vbCrLf &_
					" and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"' " 

'--->>> OJO <<<---
	if conexion.consultaUno(c_cantidad_carreras) > "0" then
		sede_tdesc = conexion.consultaUno("Select protic.initCap(sede_tdesc) from alumnos a, ofertas_academicas b, sedes c where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr  and b.sede_ccod=c.sede_ccod and a.emat_ccod in (1,4) and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"'  and isnull(alum_nmatricula,0) <> 7777 ")
		mensaje = "El alumno no presenta matricula activa en el sistema para esta sede, tiene una en la sede " & sede_tdesc
	else
	     consulta_no_activa = "Select protic.initCap(emat_tdesc) from alumnos a, ofertas_academicas b, estados_matriculas c where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr  and a.emat_ccod = c.emat_ccod and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"'"
		 
	     no_activa= conexion.consultaUno(consulta_no_activa)
		 'response.write(c_cantidad_carreras)
		 if not Esvacio(no_activa) and no_activa <> "" then
		 	mensaje = "El alumno no presenta matricula activa en el sistema, su �ltima matricula esta en estado "& no_activa
		 else
		 	mensaje = "El Alumno presenta impedimentos que bloquean su toma de asignaturas para el semestre solicitado."	
		 end if
	end if

elseif cantidad_carreras > "1" then

	if esVacio(matr_ncorr) then
		consulta_matr=" Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
					  " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and emat_ccod in (1,2,4,8,10)  and isnull(alum_nmatricula,0) <> 7777 "&_
					  " and cast(c.peri_ccod as varchar)='"&v_peri_ccod&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' order by b.emat_ccod asc"
						
		matr_ncorr= conexion.consultaUno(consulta_matr)	
	end if
	carrera = conexion.consultaUno("Select carr_ccod from alumnos a, ofertas_Academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( matr_ncorr as varchar)='"&matr_ncorr&"'  and isnull(alum_nmatricula,0) <> 7777 ")
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
					  " and c.carr_ccod=d.carr_ccod  and a.emat_ccod in (1,2,4,8,10)  and isnull(alum_nmatricula,0) <> 7777 " & vbCrLf &_
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
		   " protic.horario_con_sala(b.secc_ccod) as horario, case acse_ncorr when 3 then 'Carga Adicional' when 4 then 'Carga Sin Pre-requisitos' else case a.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, "& vbCrLf &_
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
'response.Write(matr_ncorr)	   
if v_plec_ccod = "2" and matr_ncorr <> "" then
	carrera_a_consultar= conexion.consultaUno("select carr_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
    primer_peri_ccod = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod = 1")    
    'response.Write("carrera "&carrera_a_consultar&" periodo "&primer_peri_ccod&" pers_ncorr "&pers_ncorr_temporal)
	consulta = consulta & "union      select f.asig_ccod as cod_asignatura, f.asig_tdesc as asignatura,e.secc_tdesc as seccion, " & vbCrLf &_
			   "     protic.horario_con_sala(e.secc_ccod) as horario, case acse_ncorr when 3 then 'Carga Adicional' when 4 then 'Carga Sin Pre-requisitos' else case d.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, " & vbCrLf &_
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
		mensaje_plan = "El Alumno esta cursando un plan de Estudios regulado por Sistema Cr�ditos."
	end if		
	'es_moroso = conexion.consultaUno("select protic.es_Moroso("&pers_ncorr_temporal&",getDate())")

	carrera_a_consultar= conexion.consultaUno("select carr_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
	primer_semestre = conexion.consultaUno("select peri_ccod from periodos_academicos where plec_ccod=1 and cast(anos_ccod as varchar)='"&anos_ccod&"'")	
	segundo_semestre = conexion.consultaUno("select peri_ccod from periodos_academicos where plec_ccod=2 and cast(anos_ccod as varchar)='"&anos_ccod&"'")	
end if

suma_creditos=0.0
'if tipo_plan <> "0" then
'	while f_alumno.siguiente 
'	suma_creditos= conexion.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")") 'suma_creditos + cdbl(f_alumno.obtenerValor("creditos"))
'	wend
'	f_alumno.primero
'end if

'response.Write("tipo_plan "&tipo_plan&" matr_ncorr "&matr_ncorr)

if tipo_plan <> "0" and matr_ncorr <> "" then
   'response.Write("<br>select protic.obtener_creditos_asignados("&matr_ncorr&")")
	suma_creditos = conexion.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
end if


'response.Write("suma_creditos " &suma_creditos)

url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&ocultar=1"

'-------------buscamos el a�o de el periodo si es mayor a 2005 agregamos a la tabla asignaturas_comunes-----------
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
	mensaje_distintos = "Imposible realizar la toma de carga del alumno, ya que presenta problemas con el plan de estudios asignado, haga el favor de corregir este tema en el <strong>Mantenedor de cambio de especialidades</strong>. Luego podr� tomarle las asignaturas."
end if	

'response.End()	
'---------------------------------------------------------------------------------------------------------
'response.Write(matr_ncorr)
'debemos cerrar el proceso de toma de carga acad�mica para cuaquier persona que tenga acceso a ella exceptuando registro curricular.
jornada_matricula = conexion.consultaUno("select b.jorn_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr")
usuario_sesion = negocio.obtenerUsuario
sin_restriccion = conexion.consultaUno("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr in(2,143,95) and cast(a.pers_nrut as varchar)='"&usuario_sesion&"'")
'response.Write(usuario_sesion)
'response.Write("select b.jorn_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr")

if jornada_matricula ="1" and sin_restriccion ="0" then
	cerrar_carga_diurno = true 
end if


cerrar_carga_diurno = false

bloquear_toma_diurnos="N"
if pers_ncorr_temporal <> "" then
    'response.Write("select protic.ultima_oferta_matriculado('"&pers_ncorr_temporal&"')")
	ultima_oferta_prueba = conexion.consultaUno("select protic.ultima_oferta_matriculado('"&pers_ncorr_temporal&"')")
	'response.Write("select protic.ultima_oferta_matriculado('"&pers_ncorr_temporal&"')")
	jornada_prueba = conexion.consultaUno("select jorn_ccod from ofertas_academicas where cast(ofer_ncorr as varchar)='"&ultima_oferta_prueba&"'")
	sede_prueba = conexion.consultaUno("select sede_ccod from ofertas_academicas where cast(ofer_ncorr as varchar)='"&ultima_oferta_prueba&"'")
	carrera_prueba = conexion.consultaUno("select ltrim(rtrim(carr_ccod)) from ofertas_academicas a, especialidades b  where cast(a.ofer_ncorr as varchar)='"&ultima_oferta_prueba&"' and a.espe_ccod=b.espe_ccod")
	'response.Write(carrera_prueba)
	
	if cdbl(v_peri_ccod) < 218 then  'para a�os inferiores a 2009
		bloquear_toma_diurnos = conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'22/08/2008',103) then 'S' else 'N' end ")
		'response.Write("1")
		if sede_prueba ="4" then
			bloquear_toma_diurnos = conexion.consultaUno("select case when convert(varchar,getDate(),103) < convert(datetime,'11/08/2008',103) OR convert(varchar,getDate(),103) > convert(datetime,'05/09/2008',103) then 'S' else 'N' end ")
		end if
		if carrera_prueba= "890" or carrera_prueba= "900" or carrera_prueba= "910" then
			bloquear_toma_diurnos = conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'30/01/2009',103) then 'S' else 'N' end ")
		end if
		if carrera_prueba= "870" or carrera_prueba= "880" then
			bloquear_toma_diurnos = conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'17/09/2008',103) then 'S' else 'N' end ")
		end if
		if carrera_prueba= "99" and sede_prueba= "8" then
			bloquear_toma_diurnos = conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'25/09/2008',103) then 'S' else 'N' end ")
		end if
		pers_ncorr_usuario=negocio.obtenerUsuario
		if pers_ncorr_usuario="7037083" or pers_ncorr_usuario="9977341" or pers_ncorr_usuario="10536399" or pers_ncorr_usuario="11404850"  then
			bloquear_toma_diurnos =conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'31/08/2008',103) then 'S' else 'N' end ")
		end if
		if v_plec_ccod = "3" and v_peri_ccod = "213" then
			bloquear_toma_diurnos =conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'20/01/2009',103) then 'S' else 'N' end ")
		end if
		if sede_prueba = "7" then
			bloquear_toma_diurnos = "N" 'habilitado para siempre seg�n solicitud jefa registro curricular
		end if
		
		if carrera_prueba= "900" and (v_peri_ccod = "210" or v_peri_ccod = "212" or v_peri_ccod = "213") then
			bloquear_toma_diurnos =conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'01/04/2009',103) then 'S' else 'N' end")
		end if
		
	else
		v_dia_actual 	= 	Day(now())
		v_mes_actual	= 	Month(now())
		 anio_ingreso = conexion.consultaUno("select isnull(protic.ano_ingreso_carrera("&pers_ncorr_temporal&",'"&carrera_prueba&"'),2015)")
		 facu_ccod    = conexion.consultaUno("select facu_ccod from carreras a, areas_academicas b where a.area_ccod=b.area_ccod and a.carr_ccod='"&carrera_prueba&"'")
		 crear_acceso=false
		 
			'FECHAS DE CALENDARIO TOMA CARGA PRESENCIAL (TODAS LAS ESCUELAS)
			if v_peri_ccod = "240" and (v_mes_actual = 7 and v_dia_actual >= 17) or (v_mes_actual = 8 and v_dia_actual <= 14) then
			    crear_acceso = true
			end if
			'if v_peri_ccod = "240" and (v_mes_actual = 7 and v_dia_actual >= 17) or (v_mes_actual = 8 and v_dia_actual <= 14) then
			'    crear_acceso = true
			'end if
			
			'FECHAS DE CALENDARIO TOMA CARGA PRESENCIAL (ESCUELAS ESPECIALES)
			if v_peri_ccod = "240" and ((v_mes_actual = 7 and v_dia_actual >= 13) or (v_mes_actual = 8 and v_dia_actual <= 14)) and carrera_prueba = "45" then 'Para la Carrera de Publicidad
			    crear_acceso = true
			end if
			'if v_peri_ccod = "240"  and  v_mes_actual = 7 and v_dia_actual >= 17 and v_dia_actual <= 26 and carrera_prueba = "43" then 'Para la Carrera de Psicologia
			    'crear_acceso = true
			'end if
			'if v_peri_ccod = "240"  and  v_mes_actual = 7 and v_dia_actual >= 17 and v_dia_actual <= 26 and carrera_prueba = "47" then 'Para la Carrera de Relaciones Publicas
			 '   crear_acceso = true
			'end if
			
			'LA ARAUCANA			
			if sede_prueba = "9" and ((v_mes_actual = 7 and v_dia_actual >= 27) or (v_mes_actual = 8 and v_dia_actual <= 14))  then
			     'response.write ("entro")
			    crear_acceso = true
			end if	
			
			'FECHAS DE CALENDARIO TOMA CARGA PRESENCIAL MAGISTER Y LICENCIATURA
			tcar_ccod = conexion.consultaUno("select tcar_ccod from carreras where carr_ccod='"&carrera_prueba&"'")
			if tcar_ccod = "2" or carrera_prueba = "600" then
				crear_acceso = true
			end if 
			
			'PAE y CONTADOR AUDITOR SANTIAGO 
			'if carrera_prueba="900"  then
			'    crear_acceso = true
			'end if
			
			if crear_acceso then
				bloquear_toma_diurnos ="N"
			else
				bloquear_toma_diurnos ="S"
			end if	
			
			
			'response.End()

			'response.Write(v_mes_actual)
			'response.Write(bloquear_toma_diurnos)	
	end if
	
end if


'bloquear_toma_diurnos="N"
'response.Write(v_plec_ccod)
'response.Write(bloquear_toma_diurnos)
'response.Write(carrera_prueba)

if matr_ncorr <> "" then
c_encuestas = "select cantidad_carga - con_evaluacion_docente as diferencia "& vbCrLf &_
			  " from "& vbCrLf &_
		  	  " ( "& vbCrLf &_
			  " select cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut, d.pers_tnombre + ' ' + d.pers_tape_paterno + ' ' + d.pers_tape_materno as alumno, "& vbCrLf &_
			  " (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc,secciones dd, asignaturas ee "& vbCrLf &_
			  " where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr "& vbCrLf &_
			  " and bb.peri_ccod in (232,233) and cc.secc_ccod=dd.secc_ccod and dd.asig_ccod=ee.asig_ccod and ee.duas_ccod <> 3 "& vbCrLf &_
			  " and convert(datetime,protic.trunc(isnull(cc.fecha_ingreso_carga,'04-08-2013')),103) < convert(datetime,'03-08-2013',103) "& vbCrLf &_
			  " and not exists (select 1 from secciones sec,convalidaciones conv "& vbCrLf &_
              " where sec.secc_ccod=cc.secc_ccod and cc.matr_ncorr=conv.matr_ncorr and sec.asig_ccod=conv.asig_ccod) "& vbCrLf &_
			  " and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc "& vbCrLf &_
			  "             where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod  "& vbCrLf &_
			  "             and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1 "& vbCrLf &_
			  "             and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'04-08-2013',103))) as cantidad_carga, "& vbCrLf &_
			  " (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc,secciones dd, asignaturas ee "& vbCrLf &_
			  " where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr "& vbCrLf &_
			  " and bb.peri_ccod in (232,233) and cc.secc_ccod=dd.secc_ccod and dd.asig_ccod=ee.asig_ccod and ee.duas_ccod <> 3 "& vbCrLf &_
			  " and convert(datetime,protic.trunc(isnull(cc.fecha_ingreso_carga,'04-08-2013')),103) < convert(datetime,'03-08-2013',103) "& vbCrLf &_
			  " and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc "& vbCrLf &_
			  "             where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod  "& vbCrLf &_
			  "             and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1 "& vbCrLf &_
			  "             and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'04-08-2013',103)) "& vbCrLf &_
			  " and exists (select 1 from evaluacion_docente_alumnos_2015 ffff where ffff.pers_ncorr=aa.pers_ncorr  "& vbCrLf &_
			  "             and ffff.secc_ccod=cc.secc_ccod "& vbCrLf &_
			  "             union "& vbCrLf &_
              "             select 1 from evaluacion_docente ffff where ffff.pers_ncorr_encuestado=aa.pers_ncorr  "& vbCrLf &_
              "             and ffff.secc_ccod=cc.secc_ccod)) as con_evaluacion_docente               "& vbCrLf &_
			  " from alumnos a, ofertas_academicas b, especialidades c,personas d "& vbCrLf &_
			  " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "& vbCrLf &_
			  " and c.carr_ccod='"&carrera_prueba&"' and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"' "& vbCrLf &_
			  " and a.emat_ccod <> 9 and a.alum_nmatricula <> '7777' "& vbCrLf &_
			  " and a.pers_ncorr = d.pers_ncorr "& vbCrLf &_
			  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'"& vbCrLf &_
			  " ) tabla_1"
			  'response.Write("<pre>"&c_encuestas&"</pre>")
			if v_plec_ccod = "2" and v_peri_ccod = "240" then
			c_encuestas = " select cantidad_carga - con_evaluacion_docente as diferencia  "& vbCrLf &_
						  "	 from  "& vbCrLf &_
						  "	  (  "& vbCrLf &_
						  "		 select cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut, d.pers_tnombre + ' ' + d.pers_tape_paterno + ' ' +  d.pers_tape_materno as alumno,  "& vbCrLf &_
						  "		(select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc,secciones dd, asignaturas ee  "& vbCrLf &_
						  "		 where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr  "& vbCrLf &_
						  "		 and cc.secc_ccod=dd.secc_ccod and dd.asig_ccod=ee.asig_ccod and ee.duas_ccod<>3 "& vbCrLf &_
						  "		 and bb.peri_ccod in ('"&primer_semestre&"')  "& vbCrLf &_
						  "      and convert(datetime,protic.trunc(isnull(cc.fecha_ingreso_carga,'29-04-2015')),103) < convert(datetime,'28-04-2015',103) "& vbCrLf &_
						  "		 and not exists (select 1 from secciones sec,convalidaciones conv  "& vbCrLf &_
						  "						 where sec.secc_ccod=cc.secc_ccod and cc.matr_ncorr=conv.matr_ncorr and sec.asig_ccod=conv.asig_ccod)  "& vbCrLf &_
						  "		 and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc  "& vbCrLf &_
						  "					 where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod   "& vbCrLf &_
						  "					 and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1  "& vbCrLf &_
						  "					 and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'29-04-2015',103)))  "& vbCrLf &_
						  "		 as cantidad_carga,  "& vbCrLf &_
						  "		 (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc,secciones dd, asignaturas ee   "& vbCrLf &_
						  "		 where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr "& vbCrLf &_
						  "		 and cc.secc_ccod=dd.secc_ccod and dd.asig_ccod=ee.asig_ccod and ee.duas_ccod<>3  "& vbCrLf &_
						  "		 and bb.peri_ccod in ('"&primer_semestre&"')  "& vbCrLf &_
						  "      and convert(datetime,protic.trunc(isnull(cc.fecha_ingreso_carga,'29-04-2015')),103) < convert(datetime,'28-04-2015',103) "& vbCrLf &_
						  "		 and not exists (select 1 from secciones sec,convalidaciones conv  "& vbCrLf &_
						  "						 where sec.secc_ccod=cc.secc_ccod and cc.matr_ncorr=conv.matr_ncorr and sec.asig_ccod=conv.asig_ccod) "& vbCrLf &_
						  "		 and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc  "& vbCrLf &_
						  "					  where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod   "& vbCrLf &_
						  "					  and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1  "& vbCrLf &_
						  "					  and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'29-04-2015',103))  "& vbCrLf &_
						  "		 and exists (select 1 from evaluacion_docente_alumnos_2015 ffff where ffff.pers_ncorr=aa.pers_ncorr   "& vbCrLf &_
						  "					 and ffff.secc_ccod=cc.secc_ccod   "& vbCrLf &_
						  "					 union   "& vbCrLf &_
						  "					 select 1 from evaluacion_docente ffff where ffff.pers_ncorr_encuestado=aa.pers_ncorr   "& vbCrLf &_
						  "					 and ffff.secc_ccod=cc.secc_ccod)  "& vbCrLf &_
						  "		 ) as con_evaluacion_docente  "& vbCrLf &_      
						  "		 from alumnos a, ofertas_academicas b, especialidades c,personas d  "& vbCrLf &_
						  "		 where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod  "& vbCrLf &_
						  "		 and c.carr_ccod='"&carrera_prueba&"' and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"' "& vbCrLf &_
						  "		 and a.emat_ccod <> 9 and a.alum_nmatricula <> '7777'  "& vbCrLf &_
						  "		 and a.pers_ncorr = d.pers_ncorr  "& vbCrLf &_
						  "		 and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'  "& vbCrLf &_
						  "	) tabla_1 "
			end if
			if v_plec_ccod = "3" and v_peri_ccod = "229" then
			c_encuestas = "select cantidad_carga - con_evaluacion_docente as diferencia "& vbCrLf &_
						  " from "& vbCrLf &_
						  " ( "& vbCrLf &_
						  " select cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut, d.pers_tnombre + ' ' + d.pers_tape_paterno + ' ' + d.pers_tape_materno as alumno, "& vbCrLf &_
						  " (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc "& vbCrLf &_
						  " where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr "& vbCrLf &_
						  " and cast(bb.peri_ccod as varchar) in ('"&segundo_semestre&"') "& vbCrLf &_
						  " and not exists (select 1 from secciones sec,convalidaciones conv "& vbCrLf &_
						  " where sec.secc_ccod=cc.secc_ccod and cc.matr_ncorr=conv.matr_ncorr and sec.asig_ccod=conv.asig_ccod) "& vbCrLf &_
						  " and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc "& vbCrLf &_
						  "             where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod  "& vbCrLf &_
						  "             and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1 "& vbCrLf &_
						  "             and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'30-07-2010',103))) as cantidad_carga, "& vbCrLf &_
						  " (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc "& vbCrLf &_
						  " where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr "& vbCrLf &_
						  " and cast(bb.peri_ccod as varchar) in ('"&segundo_semestre&"') "& vbCrLf &_
						  " and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc "& vbCrLf &_
						  "             where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod  "& vbCrLf &_
						  "             and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1 "& vbCrLf &_
						  "             and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'30-07-2010',103)) "& vbCrLf &_
						  " and exists (select 1 from evaluacion_docente_alumnos_2015 ffff where ffff.pers_ncorr=aa.pers_ncorr   "& vbCrLf &_
						  "	            and ffff.secc_ccod=cc.secc_ccod   "& vbCrLf &_
						  "  		 union   "& vbCrLf &_
						  " 			select 1 from evaluacion_docente ffff where ffff.pers_ncorr_encuestado=aa.pers_ncorr   "& vbCrLf &_
						  "  		    and ffff.secc_ccod=cc.secc_ccod )  ) as con_evaluacion_docente               "& vbCrLf &_
						  " from alumnos a, ofertas_academicas b, especialidades c,personas d "& vbCrLf &_
						  " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "& vbCrLf &_
						  " and c.carr_ccod='"&carrera_prueba&"' and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"' "& vbCrLf &_
						  " and a.emat_ccod <> 9 and a.alum_nmatricula <> '7777' "& vbCrLf &_
						  " and a.pers_ncorr = d.pers_ncorr "& vbCrLf &_
						  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'"& vbCrLf &_
						  " ) tabla_1"
			end if			  
			  'response.Write("<pre>"&c_encuestas&"</pre>")
              diferencia_encuestas = conexion.consultaUno(c_encuestas)
		  
			  'justificado_encuesta = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from justificados_ev_docente b where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' ")
              'IF justificado_encuesta = "S" THEN
			  '	diferencia_encuestas = "0"
			  'END IF
			  
			  mensaje_encuesta = ""
'			  if diferencia_encuestas > "0" or justificado_encuesta = "0" then 
  			  if diferencia_encuestas > "0" then 
			  	mensaje_encuesta = "El alumno no contest� todas las evaluaciones docentes correspondientes al a�o 2013-01, le restan "&diferencia_encuestas&" encuestas por evaluar"
			  end if
			  
			  '/////////////////////////Direcci�n de docencia pide cancelar requisito Ev.Docente 10-08-2009---------------------------
			  '/////////////////////////Direcci�n de docencia pide cancelar requisito Ev.Docente 16-06-2014---------------------------
			  mensaje_encuesta = ""
			  diferencia_encuestas = "0"
			  
			 
			  tcar_ccod = conexion.consultaUno("select tcar_ccod from carreras where cast(carr_ccod as varchar)='"&carrera_prueba&"'")
			  if tcar_ccod="2" or carrera_prueba = "600" then
				mensaje_encuesta = ""
				diferencia_encuestas = "0"
			  end if
'			  if q_pers_nrut="16099227" or q_pers_nrut="16205595" or q_pers_nrut="16207638" or q_pers_nrut="16209412" or q_pers_nrut="16212795" or q_pers_nrut="16366178" then
'			     mensaje_encuesta = ""
'			  end if
'			  if q_pers_nrut="16366588" or q_pers_nrut="16592080" or q_pers_nrut="16606471" or q_pers_nrut="16639500" or q_pers_nrut="16657125" or q_pers_nrut="16935727" or q_pers_nrut="17061070" or q_pers_nrut="17202140" then 
'		     mensaje_encuesta = ""
'			  end if
			  
			  'mensaje_convocatoria = ""
			 ' carr_ccod = carrera_a_consultar
			 ' if carr_ccod ="830" or carr_ccod ="850" or carr_ccod ="880" or carr_ccod ="870" or carr_ccod ="940" or carr_ccod ="950" or carr_ccod = "860" then
			 ' 	mensaje_convocatoria = "La toma de carga para alumnos de tu escuela comienza en Marzo."
			 ' end if
			  
			 c_bloqueo_notas = " select case count(*) when 0 then 'Libre' else 'Bloqueado' end  "& vbCrLf &_
			 				   " from causal_eliminacion where cast(rut as varchar)='"&q_pers_nrut&"' "
								
             bloqueo_notas = conexion.consultaUno(c_bloqueo_notas)  
			 mensaje_bloqueo_notas = ""
			 if bloqueo_notas = "Bloqueado" then
			 	 mensaje_bloqueo_notas = "El alumno presenta un bloqueo acad�mico en el sistema, lo que impide la toma de carga, haga el favor de comunicarse con su escuela para solucionar la situaci�n."
			 end if
end if
rut_usu=negocio.obtenerUsuario
tiene_rol = conexion.consultaUno("select case count(srol_ncorr) when 1 then 'S' else 'N'end from personas a,sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and srol_ncorr=156 and pers_nrut="&rut_usu&" ")

if carrera_prueba = "900" then 
	diferencia_encuestas = "0"
	mensaje_encuesta = ""
end if
'response.Write(bloquear_toma_diurnos)

'habilitaci�n de encargados de deportes las condes, lyon y baquedano
if rut_usu="11404850" or rut_usu="7037083" or rut_usu="10536399" then
	if v_mes_actual = 1 and v_dia_actual <= 31 and v_peri_ccod="226" then
		crear_acceso=true					
	end if
	if crear_acceso then
		bloquear_toma_diurnos ="N"
	else
		bloquear_toma_diurnos ="S"
	end if
end if
'habilitaci�n encargados de deportes melipilla
if  rut_usu="11404850" or rut_usu="7037083" or rut_usu="10536399" then
	if v_mes_actual = 1 and v_dia_actual <= 31 and v_peri_ccod="226" then
		crear_acceso=true					
	end if
	if crear_acceso then
		bloquear_toma_diurnos ="N"
	else
		bloquear_toma_diurnos ="S"
	end if
end if
if  rut_usu="9211353" or rut_usu="12884063" then
	if v_mes_actual = 1 and v_dia_actual = 31 and v_peri_ccod="226" then
		crear_acceso=true					
	end if
	if crear_acceso then
		bloquear_toma_diurnos ="N"
	else
		bloquear_toma_diurnos ="S"
	end if
end if

'if  pers_ncorr_temporal ="100476" or pers_ncorr_temporal ="100498" or pers_ncorr_temporal ="100492" or pers_ncorr_temporal ="100472" or pers_ncorr_temporal ="100487" or pers_ncorr_temporal ="100843" or pers_ncorr_temporal ="100490" or pers_ncorr_temporal ="100496" or pers_ncorr_temporal ="100489" or pers_ncorr_temporal ="100493" or pers_ncorr_temporal ="100478" or pers_ncorr_temporal ="109532" or pers_ncorr_temporal ="100499" or pers_ncorr_temporal ="100494" or pers_ncorr_temporal ="100501" or pers_ncorr_temporal ="110263" or pers_ncorr_temporal ="100491"   or pers_ncorr_temporal ="21513" then
'	sin_restriccion = "1"
'end if
'response.Write(matr_ncorr)

session("pers_ncorr_alumno") = pers_ncorr_temporal
session("matr_ncorr") = matr_ncorr
'RESPONSE.Write(matr_ncorr)

tiene_foto  = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from rut_fotos_2010 where cast(rut as varchar)='"&q_pers_nrut&"'")
tiene_foto2 = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

if tiene_foto="S" then 
 	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(imagen)) from rut_fotos_2010 where cast(rut as varchar)='"&q_pers_nrut&"'")
elseif tiene_foto="N" and tiene_foto2="S" then 
  	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(foto_truta)) from fotos_alumnos where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")	
else
    nombre_foto = "user.png"
end if

promedio_semestral = conexion.consultaUno("select cast(promedio as varchar) + ' Al d�a ' + protic.trunc(audi_fmodificacion) from PROMEDIOS_ALUMNOS_CARRERA where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and carr_ccod='"&carrera_prueba&"' and peri_ccod=238")

plan_ccod = conexion.consultaUno("select plan_ccod from alumnos a where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
v_espe_ccod = conexion.consultaUno("select espe_ccod from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")
url_malla="../MANTENEDORES/malla_curricular_imprimible.ASP?a[0][CARR_CCOD]="&carrera_prueba&"&a[0][ESPE_CCOD]="&v_espe_ccod&"&a[0][PLAN_CCOD]="&plan_ccod

c_cae = " select case count(*) when 0 then '' else 'Matriculado CAE' end "& vbCrLf &_
		" from sdescuentos a, alumnos b where a.post_ncorr=b.post_ncorr and a.ofer_ncorr=b.ofer_ncorr "& vbCrLf &_
        " and a.esde_ccod = 1 and a.stde_ccod=1402 and cast(b.matr_ncorr as varchar)='"&matr_ncorr&"'"
en_cae = conexion.consultaUno(c_cae)		  

'response.Write(crea_acceso)
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
function ver_malla()
{
	self.open('<%=url_malla%>','malla','width=700px, height=550px, scrollbars=yes, resizable=yes')
}
function horario(){
	self.open('horario.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function imprimir() {
  var direccion;
  direccion="impresion_carga.asp";
  window.open(direccion ,"ventana1","width=520,height=540,scrollbars=yes, left=313, top=200");
}

function abrir_info_persona(rut)
{
	if (confirm("La carga de datos puede tardar algunos segundos,�Desea continuar?"))
	{
	  window.open("../condensador/alumno.asp?busqueda[0][pers_nrut]="+rut,"fullscreen", 'top=0,left=0,width='+(screen.availWidth)+',height ='+(screen.availHeight)+',toolbar=0 ,location=0,directories=0,status=0,resizable=1,scrolling=1,scrollbars=1');
    }
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
					  <tr>
                        <td><div align="right"><strong>Sede</strong></div></td>
                        <td width="50"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.DIbujaCampo("sede_ccod")%></td>
                      </tr>
					  <tr>
                        <td><div align="right"><strong>Periodo</strong></div></td>
                        <td width="50"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.DIbujaCampo("peri_ccod")%></td>
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
	<%IF q_pers_nrut <> "" then %>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la b�squeda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				 <tr valign="top">
				 	<td colspan="3">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="85%" align="left">
									<table width="100%" cellpadding="0" cellspacing="0">
									 <tr>
										<td colspan="3">
											<div align="center"><br>
											  <%pagina.Titulo = "Carga Registrada <br>(" &peri_tdesc&")"
												pagina.DibujarTituloPagina%><br>
											</div>
										</td>
									  </tr>
									  <tr>
										<td colspan="3">&nbsp;<input type="hidden" name="busqueda[0][pers_nrut]" value="<%=q_pers_nrut%>">
										<input type="hidden" name="busqueda[0][pers_xdv]" value="<%=q_pers_xdv%>">
										<input type="hidden" name="busqueda[0][peri_ccod]" value="<%=q_peri_ccod%>">
										<input type="hidden" name="busqueda[0][sede_ccod]" value="<%=q_sede_ccod%>">
										</td>
									  </tr>
									  <tr>
										<td colspan="3">&nbsp;</td>
									  </tr>
									  <%if q_pers_nrut <> "" then %>
									  <tr>
										<td width="13%"><strong>Rut</strong></td>
										<td width="1%"><strong>:</strong></td>
										<td width="86%"><%=rut%></td>
									  </tr>
									  <tr>
										<td width="13%"><strong>Nombre</strong></td>
										<td width="1%"><strong>:</strong></td>
										<td><%=nombre%></td>
									  </tr>
									  <%end if%>
									  <%if cantidad_carreras = "1" then %>
									  <tr>
										<td width="13%"><strong>Carrera</strong></td>
										<td width="1%"><strong>:</strong></td>
										<td><%=carrera%></td>
									  </tr>
									  <tr>
										<td width="13%"><strong>Especialidad</strong></td>
										<td width="1%"><strong>:</strong></td>
										<td><%=especialidad%></td>
									  </tr>
									  <tr>
										<td width="13%"><strong>Tipo Alumno</strong></td>
										<td width="1%"><strong>:</strong></td>
										<td><%=tipo_alumnoUpa%></td>
									  </tr>
									  <tr>
										<td width="13%" bgcolor="#009933"><font color="#FFFFFF"><strong>PROMEDIO</strong></font></td>
										<td width="1%"><strong>:</strong></td>
										<td><font color="#009900"><strong>&nbsp;&nbsp;<%=promedio_semestral%></strong></font></td>
									  </tr>
									  <%elseif cantidad_carreras > "1" then %>
									  <tr>
										<td colspan="3">&nbsp;</td>
									  </tr>
									  <tr>
										<td colspan="3"><strong>Se ha detectado que tiene m�s de una matricula activa para el periodo.<br> Seleccione la carrera a consultar: </strong>
										  <%f_encabezado.DibujaCampo("carreras_alumno")%></td>
									  </tr>
									  <%end if%>
									  <%if en_cae="Matriculado CAE" then%>
									  <tr>
									    <td width="13%">&nbsp;</td>
										<td width="1%">&nbsp;</td> 
										<td bgcolor="#990000" align="center"><font color="#FFFFFF"><strong>ALUMNO CON BENEFICIO CAE</strong></font></td>
									  </tr>
									  <%end if%>
									</table>
								</td>
								<td width="15%" align="center">
								    <table width="100%" cellpadding="0" cellspacing="0">
										<tr valign="top">
											<td colspan="2"><br><img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=nombre_foto%>" border="2"></td>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
										</tr>
										<tr title="Acceder a informaci�n del Alumno" onClick="abrir_info_persona(<%=q_pers_nrut%>)" style="CURSOR: hand">
											<td width="33" height="31" align="center"><img width="31" height="31" src="../imagenes/magic-1.png" border="0"></td>
											<td align="left"><font color="#000066"><strong>Bot�n M�gico</strong></font></td>
										</tr>
										
									</table>
									
								</td>
							</tr>
						</table>
					</td>
				 </tr>
                  
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
				  <%if matr_ncorr <> "" then %>
				  <tr>
                    <td colspan="3"><%pagina.DibujarSubtitulo "Carga Acad�mica Registrada"%>
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
									<td align="center"><font  size="2">&nbsp;</font><strong>Si presenta problemas para tomar asignaturas se puede deber a los siguientes motivos:</strong></font>
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
								   <%if mensaje_convocatoria <> "" then %>
								  <tr>
									<td align="left">- <%=mensaje_convocatoria%></td>
								  </tr>
								  <%end if%>
								  <%if mensaje_bloqueo_notas <> "" then%>
								  <tr>
									<td align="left">- <%=mensaje_bloqueo_notas%></td>
								  </tr>
								  <%end if%>
								  <%if cerrar_carga_diurno then%>
								  <tr>
									 <td align="left">- Lo sentimos pero el proceso de toma de Asignaturas Online finaliz� el d�a 08 de Agosto del presente.</td>
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
												' response.Write("1")
				                                 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"       
				  							 end if
				                            
											 if matr_ncorr = "" or mensaje_distintos <> "" then 
											      'response.Write("2")
				                             	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if 
											 if  mensaje_encuesta <> "" then 
											 	 'response.Write("3")			  
											     f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											 if  es_moroso ="S" then
											     'response.Write("4")
											 	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											 if tiene_bloqueos <> "0" then
											     'response.Write("5")
											 	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											  if bloquear_toma_diurnos = "S" then
											     '  response.Write("6")
												   f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if 
											 if sede_ccod = "7" and es_moroso <> "S" then
											    'response.Write("7") 
											    f_botonera.AgregaBotonParam "siguiente","deshabilitado","FALSE"
											 end if
                                             if mensaje_bloqueo_notas <> "" then
											    'response.Write("8")
											 	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											 'if mensaje_convocatoria <> "" then
											     'response.Write("9")
											 '	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 'end if  
											 if sin_restriccion <> "0" then
											    'response.Write("10")
											 	f_botonera.AgregaBotonParam "siguiente","deshabilitado","FALSE"
											 end if	
											  if tiene_rol = "S" then
											    'response.Write("11")
											 	f_botonera.AgregaBotonParam "siguiente","deshabilitado","FALSE"
											 end if	
											 
											 if sede_prueba= "9" and carrera_prueba =110  then
			    								' response.write ("entro2")
			    								f_botonera.AgregaBotonParam "siguiente","deshabilitado","FALSE"
											 end if
											 
											 'if usur=""then
											 'f_botonera.AgregaBotonParam "siguiente","deshabilitado","FALSE"
											 'end if
											 'f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 f_botonera.DibujaBoton("siguiente")%></div></td>
                  
				  <%if matr_ncorr <> "" then%>
				  <td><div align="center">
                    <%botonera.DibujaBoton "HORARIO"%>
                  </div></td>
                  <td><div align="center">
                    <% botonera.DibujaBoton "NOTAS"%>
                  </div></td>
				  <td><div align="center">
                    <% botonera.DibujaBoton "MALLA"%>
                  </div></td>
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
	<%end if ' para ocultar el cuadro cuando no han ingresado el Rut%>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
