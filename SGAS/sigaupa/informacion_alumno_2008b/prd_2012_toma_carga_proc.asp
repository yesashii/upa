<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<%
on error resume next
set conexion = new cConexion
set formulario = new cFormulario

set vars = new cVariables

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()


matr_ncorr = session("matr_ncorr")
conexion.inicializar "upacifico"


etca_ccod = conexion.consultaUno ("select etca_ccod from  alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
if isnull(etca_ccod) or etca_ccod=1 then
	pers_ncorr = conexion.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'") 
	vars.procesaForm
	var = "TOMA_CARGA"
	nroVars = vars.nroFilas(var)
	
	'------------debemos ver si la gente que inicia seción es de registro curricular o nop
	'----------si lo es puede eliminar carga normal y carga sin requisitos, sino lo es slo elimina carga normal, hay que tener cuidado con optativos deportivos
	'--------- y con las cargas extraordinarias qe no se eliminan por acá sino en la lengueta correspondiente.
	
	filtro_eliminacion = " and isnull(acse_ncorr,6) = 6 " 'solo elimina carga normal
	
	actualiza = true
	msj_topones = ""
	msj_cupos = ""
	msj_jornadas = ""

	tipo_plan = conexion.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
    suma_creditos = 0.0  
	    msj_topones=""
		msj_cupos=""
	for i = 0 to nroVars - 1
	  
		secc_ccod = vars.obtenerValor(var,i,"secc_ccod")
		asig_ccod = vars.obtenerValor(var,i,"asig_ccod")
		homo_ccod = " NULL "
		asig_ccod_secc = conexion.consultaUno("select asig_ccod from secciones where cast(secc_ccod as varchar) = '" & secc_ccod & "'")
		'-----------------------para evitar que elimine toda la carga del alumno y luego la vuelva a tomar, probocando que en casos asignaturas que 
		'----------------habian sido tomadas con anterioridad ya queden sin tomar por motivos de que una anterior termino con los créditos o con la 
		'----------------regla de máximo 3 asignaturas de jornadas distinta.------agregado por MSandoval 13-04-2006----------------------------
		tiene_agregada_carga = conexion.consultaUno("Select count(*) from cargas_academicas where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
		
		if tiene_agregada_carga = "0" and secc_ccod <> "" then
			'------- en caso de no estar agregada la carga debemos ver si cambio sección o si la esta agregando como carga nueva
			'--------------debemos sacar la asignatura de la sección y ver si tiene el alumno alguna otra carga para esa asignatura 
			'-------------y eliminarle la carga para que la pueda grabar nuevamente.
			consulta_busqueda= " Select count(*) from cargas_academicas a, secciones b where b.asig_ccod ='"&asig_ccod_secc&"' and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.secc_ccod = b.secc_ccod "&_
			                   " and a.sitf_ccod is null and isnull(a.carg_afecta_promedio,'S') <> 'N' "&filtro_eliminacion& vbCrlf & _
							   " and not exists (select 1 from calificaciones_alumnos c  "& vbCrlf & _
					 						 " where c.matr_ncorr = a.matr_ncorr "& vbCrlf & _
											 " and c.secc_ccod = a.secc_ccod)  "& vbCrlf & _
							   " and not exists (select 1 from equivalencias bb "& vbCrlf & _
											 " where bb.matr_ncorr = a.matr_ncorr  "& vbCrlf & _
											 " and bb.secc_ccod = a.secc_ccod) "
			
			tiene_agregada_asignatura = conexion.consultaUno(consulta_busqueda)
			'response.Write("<hr><pre>"&consulta_busqueda&"</pre><br>")
			consulta_parciales= " Select count(*) from cargas_academicas a, secciones b where b.asig_ccod ='"&asig_ccod_secc&"' and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.secc_ccod = b.secc_ccod "&_
			                    " "&filtro_eliminacion& vbCrlf & _
							    " and exists (select 1 from calificaciones_alumnos c  "& vbCrlf & _
					 						 " where c.matr_ncorr = a.matr_ncorr "& vbCrlf & _
											 " and c.secc_ccod = a.secc_ccod)  "
			tiene_parciales = conexion.consultaUno(consulta_parciales)
			'response.Write(tiene_parciales)
			if tiene_agregada_asignatura <> "0" and tiene_parciales = "0" then
			'response.Write("entre")
				consulta_busqueda= " Select distinct b.secc_ccod from cargas_academicas a, secciones b where b.asig_ccod ='"&asig_ccod_secc&"' and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.secc_ccod = b.secc_ccod "&_
			                       " and a.sitf_ccod is null and isnull(a.carg_afecta_promedio,'S') <> 'N' "&filtro_eliminacion& vbCrlf & _
							       " and not exists (select 1 from calificaciones_alumnos c  "& vbCrlf & _
					 						 " where c.matr_ncorr = a.matr_ncorr "& vbCrlf & _
											 " and c.secc_ccod = a.secc_ccod)  "& vbCrlf & _
							        " and not exists (select 1 from equivalencias bb "& vbCrlf & _
											 " where bb.matr_ncorr = a.matr_ncorr  "& vbCrlf & _
											 " and bb.secc_ccod = a.secc_ccod) "
				
				consulta_delete = "delete from cargas_academicas where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and secc_ccod in ("&consulta_busqueda&")"							 
			    conexion.ejecutaS consulta_delete
								
				'response.Write(consulta_delete)
				'response.Write("entre en el segundo pa eliminar")
			end if
			
		'response.End()
		if asig_ccod <> asig_ccod_secc then
			area_ccod = conexion.consultaUno("select area_ccod from alumnos a, planes_estudio b, especialidades c, carreras d where a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and cast(a.matr_ncorr as varchar)='" & matr_ncorr & "'")
			homo_ccod = "'" & conexion.consultaUno("select homo_ccod from homologacion a, homologacion_fuente b, homologacion_destino c where a.homo_ccod=b.homo_ccod and a.homo_ccod=c.homo_ccod and cast(a.area_ccod as varchar)='" & area_ccod & "' ") & "'"
		end if
       
	    if tipo_plan <> "0" and asig_ccod_secc <> "" and not esVacio(asig_ccod_secc)  then
		   cred_asignatura = conexion.consultaUno("select cred_valor from asignaturas a,creditos_Asignatura b where a.cred_ccod=b.cred_ccod  and asig_ccod = '"&asig_ccod_secc&"'")
		   suma_creditos = suma_creditos + cdbl(cred_asignatura)
		end if
	       '----------agregaremos un filtro por si tiene  notas parciales ya ingresadas
			 if  tiene_parciales <> "0" then
			 	msj_parciales = "Imposible realizar la toma de carga solicitada, el alumno presenta notas parciales en algunas asignaturas."
			 end if
		if secc_ccod <> "" then
			topones_cons = "select sum(protic.topones_alumno_nuevo_2('" & secc_ccod & "','" & matr_ncorr & "'))"
			'response.Write(topones_cons)
			'response.End()
			topones = conexion.consultaUno(topones_cons)
			cupo_disponible_cons = " SELECT  secc_ncupo - count(b.secc_ccod) " _
			                     & " FROM secciones a, cargas_academicas b, alumnos c " _
								 & " WHERE a.secc_ccod *= b.secc_ccod  " _
								 & " AND b.matr_ncorr  =* c.matr_ncorr " _
								 & " AND c.emat_ccod   = 1 " _
          						 & " AND cast(a.secc_ccod as varchar) = '" & secc_ccod & "' " _
          						 & " group by secc_ncupo"
				 
			cupo_disponible = conexion.consultaUno(cupo_disponible_cons)
			secc_sin_cupo_cons="select cast(asig_ccod as varchar) + '->' + cast(secc_tdesc as varchar) from secciones where cast(secc_ccod as varchar) = '" & secc_ccod & "' " 
			asig_sin_cupo=conexion.consultaUno(secc_sin_cupo_cons)
			 '******************* usuario que puede tomar carga sin topones **************
			 '****************** debemos revisar la suma de los creditos que tiene asignado el alumno mas los de la nueva asignatura
			 '********************en caso que el este en el plan de créditos, si pasa de 27 no debe dejar tomar la asignatura.
			 '**********************************agregado por msandoval 08-03-2006*********************************************
     		 'response.Write("<br>tipo_plan "&tipo_plan)
			 if tipo_plan <> "0"  and matr_ncorr <> "" then 
			 	cred_asignatura = conexion.consultaUno("select cred_valor from asignaturas a,creditos_Asignatura b where a.cred_ccod=b.cred_ccod  and asig_ccod = '"&asig_ccod_secc&"'")
             	cred_totales = conexion.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
			    'response.Write("<br>cred_asignatura "&cred_asignatura&" cred_totales "&cred_totales)
				total_a_asignar = cdbl(cred_asignatura) + cdbl(cred_totales)
				'response.Write("<br>total a asignar "&total_a_asignar)
				if cint(total_a_asignar) > 27 then
				    'response.Write("asigna mensaje")
					msje_creditos = "Imposible realizar la toma de carga solicitada, con ello se excedería el límite de 27 créditos."
				end if
				'response.Write("total "&total_a_asignar&" "&msje_creditos)
			end if
			'----------------*******************----------------***********************--------------------*************************
			
			'-----------------debemos ver si se excede el máximo de cupos disponibles para asignaturas de otra jornada-----------
			jornada_matricula = conexion.consultaUno("select b.jorn_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr")
			distinta_jornada = conexion.consultaUno("select count(*) + 1 from cargas_academicas a, secciones b where a.secc_ccod=b.secc_ccod and cast(b.jorn_ccod as varchar) <> '"&jornada_matricula&"' and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
			jornada_seccion = conexion.consultaUno("select jorn_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
			
			if cstr(jornada_matricula) <> cstr(jornada_seccion) then
				if distinta_jornada > "3" then
					msj_jornadas = " Imposible realizar la toma de carga ya que excede el límite de jornadas distintas que permite el reglamento (máx.3)"
				end if
			end if
			'--------------------------------------------------------------------------------------------------------------------


			
			if cInt(topones) > 0 then
				'conexion.estadoTransaccion false
				msj_topones = msj_topones & conexion.ConsultaUno("select protic.detalle_topones_alumno_nuevo_2('" & secc_ccod & "','" & matr_ncorr & "')")
			elseif cInt(cupo_disponible) < 1 then
				'conexion.estadoTransaccion false
				msj_cupos = msj_cupos & "   - " & asig_sin_cupo & "\n"
			elseif tipo_plan <> "0" and msje_creditos <> "" then
				'conexion.estadoTransaccion false
				msj_creditos = " - " & msje_creditos
			elseif  msj_jornadas <> "" then
				msj_jornadas = " - " & msj_jornadas	
			elseif  msj_parciales <> "" then
				msj_parciales = " - " & msj_parciales							
    		else
			    '-----debemos ver si el alumno le estan asignado carga sin requisitos (sólo por gente de registro curricular)
				'-----de ser así debemos marcar la carga con acse_ncorr = 3 como carga sin pre-requisitos.
				mall_ccod_control=conexion.consultaUno("select mall_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
				pers_ncorr_control=conexion.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
				completo_requisitos = conexion.consultaUno("select protic.completo_requisitos_asignatura ("&mall_ccod_control&", '" & pers_ncorr_control & "')")
			    pers_nrut = conexion.consultaUno("select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_control&"'")
				'response.Write("<br> grabo")
				if completo_requisitos = "0" then
				  inserta_carga_cons = "insert into cargas_academicas (matr_ncorr, secc_ccod, audi_tusuario, audi_fmodificacion,fecha_ingreso_carga,usuario,tipo_carga) " & vbCrLf &_
				                       "select '" & matr_ncorr & "','" & secc_ccod & "','" & pers_nrut & " (Online)', getDate(),getDate(),'Alumno','Carga Plan'  " & vbCrLf &_
									   "where not exists (select 1 from cargas_academicas a2 where cast(a2.matr_ncorr as varchar)= '" & matr_ncorr & "' and cast(secc_ccod as varchar) = '" & secc_ccod & "')"
				else
				  inserta_carga_cons = " insert into cargas_academicas (matr_ncorr, secc_ccod,acse_ncorr, audi_tusuario, audi_fmodificacion,fecha_ingreso_carga,usuario,tipo_carga) " & vbCrLf &_
				                       " select '" & matr_ncorr & "','" & secc_ccod & "',3,'" & pers_nrut & " (Online)', getDate(),getDate(),'Alumno','Carga Plan'  " & vbCrLf &_
									   " where not exists (select 1 from cargas_academicas a2 where cast(a2.matr_ncorr as varchar)= '" & matr_ncorr & "' and cast(secc_ccod as varchar) = '" & secc_ccod & "')"
				end if					
				'response.Write(inserta_carga_cons) 
				conexion.ejecutaS inserta_carga_cons		
				actualiza_alumno_cons = "update alumnos set etca_ccod=2 where cast(matr_ncorr as varchar)='" & matr_ncorr & "'"		
				conexion.ejecutaS actualiza_alumno_cons
				'response.End()
			end if
		end if
		End if ''''''''fin del if por si ya tiene agregada la sección ahí no se hace nada 
	next
end if
'------------------------------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------
msj_errores = ""
'response.End()
if msj_topones <> "" then
	msj_errores = msj_errores & "- El alumno tiene los siguientes topes horarios : \n" & msj_topones
end if

if msj_cupos <> "" then
	msj_errores = msj_errores & "- Las siguientes secciones no tienen cupos : \n" & msj_cupos	
end if

if msj_creditos <> "" then
	msj_errores = msj_errores & msj_creditos
end if

if msj_jornadas <> "" then
	msj_errores = msj_errores & msj_jornadas
end if

if msj_parciales <> "" then
	msj_errores = msj_errores & msj_parciales
end if

'response.Write(msj_errores)
'------------------------------------------------------------------------------------------------------------------------
if msj_errores <> "" then	
	conexion.MensajeError "No se guardó la toma de carga por completo, ya que se han producido los siguientes errores : \n\n" & msj_errores
else
	conexion.MensajeError "Se ha guardado toda la carga."
end if
'------------------------------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------
'response.End()
response.Redirect("toma_carga_nuevo.asp?activar=1")

%>