<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conexion = new cConexion
set formulario = new cFormulario

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

set vars = new cVariables

matr_ncorr = session("matr_ncorr")
conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

pers_ncorr = conexion.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'") 
vars.procesaForm
var = "TOMA_CARGA"
nroVars = vars.nroFilas(var)
actualiza = true
msj_topones = ""
msj_cupos = ""
msj_jornadas = ""
tipo_plan = conexion.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
suma_creditos = 0.0 
for i = 0 to nroVars - 1
	secc_ccod = vars.obtenerValor(var,i,"secc_ccod")
	asig_ccod = vars.obtenerValor(var,i,"asig_ccod")
	tiene_agregada_carga = conexion.consultaUno("Select count(*) from cargas_academicas a, secciones b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.secc_ccod=b.secc_ccod and b.asig_ccod='"&asig_ccod&"'")
	if tiene_agregada_carga = "0" and secc_ccod <> "" then
			consulta_busqueda= " Select count(*) from cargas_academicas a, secciones b where b.asig_ccod ='"&asig_ccod&"' and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.secc_ccod = b.secc_ccod "&_
			                   " and a.sitf_ccod is null and isnull(a.carg_afecta_promedio,'S') <> 'N' "& vbCrlf & _
							   " and not exists (select 1 from calificaciones_alumnos c  "& vbCrlf & _
					 						 " where c.matr_ncorr = a.matr_ncorr "& vbCrlf & _
											 " and c.secc_ccod = a.secc_ccod)  "& vbCrlf & _
							   " and not exists (select 1 from equivalencias bb "& vbCrlf & _
											 " where bb.matr_ncorr = a.matr_ncorr  "& vbCrlf & _
											 " and bb.secc_ccod = a.secc_ccod) "
			
			tiene_agregada_asignatura = conexion.consultaUno(consulta_busqueda)

			consulta_parciales= " Select count(*) from cargas_academicas a, secciones b where b.asig_ccod ='"&asig_ccod&"' and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.secc_ccod = b.secc_ccod "&_
							    " and exists (select 1 from calificaciones_alumnos c  "& vbCrlf & _
					 						 " where c.matr_ncorr = a.matr_ncorr "& vbCrlf & _
											 " and c.secc_ccod = a.secc_ccod)  "
			tiene_parciales = conexion.consultaUno(consulta_parciales)

			if tiene_agregada_asignatura <> "0" and tiene_parciales = "0" then
				consulta_busqueda= " Select distinct b.secc_ccod from cargas_academicas a, secciones b where b.asig_ccod ='"&asig_ccod&"' and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.secc_ccod = b.secc_ccod "&_
			                       " and a.sitf_ccod is null and isnull(a.carg_afecta_promedio,'S') <> 'N' "& vbCrlf & _
							       " and not exists (select 1 from calificaciones_alumnos c  "& vbCrlf & _
					 						 " where c.matr_ncorr = a.matr_ncorr "& vbCrlf & _
											 " and c.secc_ccod = a.secc_ccod)  "& vbCrlf & _
							        " and not exists (select 1 from equivalencias bb "& vbCrlf & _
											 " where bb.matr_ncorr = a.matr_ncorr  "& vbCrlf & _
											 " and bb.secc_ccod = a.secc_ccod) "
				
				consulta_delete = "delete from cargas_academicas where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and secc_ccod in ("&consulta_busqueda&")"							 
			    conexion.ejecutaS consulta_delete
			end if
			
	    if tipo_plan <> "0" and asig_ccod <> "" and not esVacio(asig_ccod)  then
		   cred_asignatura = conexion.consultaUno("select cred_valor from asignaturas a,creditos_Asignatura b where a.cred_ccod=b.cred_ccod  and asig_ccod = '"&asig_ccod&"'")
		   suma_creditos = suma_creditos + cdbl(cred_asignatura)
		end if

		if  tiene_parciales <> "0" then
		 	msj_parciales = "Imposible realizar la toma de carga solicitada, el alumno presenta notas parciales en algunas asignaturas."
		end if
		if secc_ccod <> "" and tiene_parciales = "0" then
			topones_cons = "select sum(protic.topones_alumno_nuevo_2('" & secc_ccod & "','" & matr_ncorr & "'))"
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
			
			if tipo_plan <> "0"  and matr_ncorr <> "" then 
			 	cred_asignatura = conexion.consultaUno("select cred_valor from asignaturas a,creditos_Asignatura b where a.cred_ccod=b.cred_ccod  and asig_ccod = '"&asig_ccod&"'")
             	cred_totales = conexion.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
				total_a_asignar = cdbl(cred_asignatura) + cdbl(cred_totales)
				if cint(total_a_asignar) > 27 then
					msje_creditos = "Imposible realizar la toma de carga solicitada, con ello se excedería el límite de 27 créditos."
				end if
			end if
			jornada_matricula = conexion.consultaUno("select b.jorn_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr")
			distinta_jornada = conexion.consultaUno("select count(*) + 1 from cargas_academicas a, secciones b where a.secc_ccod=b.secc_ccod and cast(b.jorn_ccod as varchar) <> '"&jornada_matricula&"' and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
			jornada_seccion = conexion.consultaUno("select jorn_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
			
			if cstr(jornada_matricula) <> cstr(jornada_seccion) then
				if distinta_jornada > "3" then
					msj_jornadas = " Imposible realizar la toma de carga ya que excede el límite de jornadas distintas que permite el reglamento (máx.3)"
				end if
			end if


			if cInt(topones) > 0 then
				msj_topones = msj_topones & conexion.ConsultaUno("select protic.detalle_topones_alumno_nuevo_2('" & secc_ccod & "','" & matr_ncorr & "')")
			elseif cInt(cupo_disponible) < 1 then
				msj_cupos = msj_cupos & "   - " & asig_sin_cupo & "\n"
			elseif tipo_plan <> "0" and msje_creditos <> "" then
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
				if completo_requisitos = "0" then
				  inserta_carga_cons = "insert into cargas_academicas (matr_ncorr, secc_ccod, audi_tusuario, audi_fmodificacion) " & vbCrLf &_
				                       "select '" & matr_ncorr & "','" & secc_ccod & "','" & negocio.obtenerusuario & " (Online)', getDate()  " & vbCrLf &_
									   "where not exists (select 1 from cargas_academicas a2 where cast(a2.matr_ncorr as varchar)= '" & matr_ncorr & "' and cast(secc_ccod as varchar) = '" & secc_ccod & "')"
				else
				  inserta_carga_cons = " insert into cargas_academicas (matr_ncorr, secc_ccod,acse_ncorr, audi_tusuario, audi_fmodificacion) " & vbCrLf &_
				                       " select '" & matr_ncorr & "','" & secc_ccod & "',3,'" & negocio.obtenerusuario & " (Online)', getDate()  " & vbCrLf &_
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
'------------------------------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------
msj_errores = ""
'response.End()
if not EsVacio(msj_topones) then
	msj_errores = msj_errores & "- El alumno tiene los siguientes topes horarios : \n" & msj_topones
end if

if not EsVacio(msj_cupos) then
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
if not EsVacio(msj_errores) then	
	conexion.MensajeError "No se guardó la toma de carga por completo, ya que se han producido los siguientes errores : \n\n" & msj_errores
else
	conexion.MensajeError "Se ha guardado toda la carga."
end if
'------------------------------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>