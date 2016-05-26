<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
on error resume next
set conexion = new cConexion
set formulario = new cFormulario

set vars = new cVariables

matr_ncorr = request.Form("matr_ncorr")
secc_ccod = request.Form("asig[0][SECC_CCOD]")
asig_ccod = request.Form("asig[0][ASIG_CCOD]")
conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usuario_sesion = negocio.obtenerUsuario
pers_ncorr = conexion.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'") 

msj_topones = ""
msj_cupos = ""

suma_creditos = 0.0 

	
		if secc_ccod <> "" then
			topones_cons = "select sum(protic.topones_alumno('" & secc_ccod & "','" & matr_ncorr & "'))"
			'response.Write(topones_cons)
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
			 negocio.inicializa conexion
			 usuario=negocio.obtenerusuario
			 
			'----------------*******************----------------***********************--------------------*************************
			if cInt(topones) > 0 then
				'conexion.estadoTransaccion false
				msj_topones = msj_topones & conexion.ConsultaUno("select protic.detalle_topones_alumno('" & secc_ccod & "','" & matr_ncorr & "')")
			elseif cInt(cupo_disponible) < 1 then
				'conexion.estadoTransaccion false
				msj_cupos = msj_cupos & "   - " & asig_sin_cupo & "\n"
			else
			   	  inserta_carga_cons = " insert into cargas_academicas (matr_ncorr, secc_ccod,acse_ncorr, audi_tusuario, audi_fmodificacion) " & vbCrLf &_
				                       " select '" & matr_ncorr & "','" & secc_ccod & "',4,'" & negocio.obtenerusuario & "', getDate()  " & vbCrLf &_
									   " where not exists (select 1 from cargas_academicas a2 where cast(a2.matr_ncorr as varchar)= '" & matr_ncorr & "' and cast(secc_ccod as varchar) = '" & secc_ccod & "')"
				
				 'response.Write(inserta_Carga_cons)
				 conexion.ejecutaS inserta_carga_cons		
				 actualiza_alumno_cons = "update alumnos set etca_ccod=2 where cast(matr_ncorr as varchar)='" & matr_ncorr & "'"		
				 conexion.ejecutaS actualiza_alumno_cons
			end if
		end if

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


'------------------------------------------------------------------------------------------------------------------------
if not EsVacio(msj_errores) then	
	conexion.MensajeError "No se ha asignado la carga de minors al alumno, ya que se han producido los siguientes errores : \n\n" & msj_errores
else
	conexion.MensajeError "Se ha agregado correctamente la carga del minors al alumno."
end if
'------------------------------------------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------------------------------------------
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>