<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: NA 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 03/04/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *= , =*
'LINEA				          : 100, 101
'********************************************************************
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

on error resume next
set conexion = new cConexion
set formulario = new cFormulario

set vars = new cVariables

conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

pers_nrut = request.Form("b[0][pers_nrut]")
pers_xdv  = request.Form("b[0][pers_xdv]")
dgso_ncorr = request.Form("dgso_ncorr")
dcur_ncorr = request.Form("b[0][dcur_ncorr]")

pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='" & pers_nrut & "'") 

pote_ncorr = conexion.consultaUno("select pote_ncorr from postulacion_otec where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'") 
'response.Write("select pote_ncorr from postulacion_otec where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
'response.End()
'response.Write("entre0")
if pote_ncorr <> "" and dgso_ncorr <> "" then
'response.Write("entre1")
	vars.procesaForm
	var = "r"
	nroVars = vars.nroFilas(var)
	
	actualiza = true
	msj_topones = ""
	msj_cupos = ""
	msj_jornadas = ""

 set formulario = new cformulario
 formulario.carga_parametros "toma_carga_otec.xml", "f_carga"
 formulario.inicializar conexion
 formulario.procesaForm

	for i=0 to formulario.cuentaPost - 1
	     seot_ncorr=formulario.obtenerValorPost(i,"seot_ncorr")
	     maot_ncorr=formulario.obtenerValorPost(i,"maot_ncorr")
	     'response.Write("entre2")
		 'seot_ncorr = vars.obtenerValor(var,i,"seot_ncorr")
		 'maot_ncorr = vars.obtenerValor(var,i,"maot_ncorr")
		
		tiene_agregada_carga = conexion.consultaUno("Select count(*) from cargas_academicas_otec where cast(seot_ncorr as varchar)='"&seot_ncorr&"' and cast(pote_ncorr as varchar)='"&pote_ncorr&"'")
		
		if tiene_agregada_carga = "0" then
			'------- en caso de no estar agregada la carga debemos ver si cambio sección o si la esta agregando como carga nueva
			'--------------debemos sacar la asignatura de la sección y ver si tiene el alumno alguna otra carga para esa asignatura 
			'-------------y eliminarle la carga para que la pueda grabar nuevamente.
			consulta_busqueda= " Select count(*) from cargas_academicas_otec a, secciones_otec b where b.maot_ncorr ='"&maot_ncorr&"' and cast(a.pote_ncorr as varchar)='"&pote_ncorr&"' and a.seot_ncorr = b.seot_ncorr "&_
			                   " and a.sitf_ccod is null  "
			
			tiene_agregada_asignatura = conexion.consultaUno(consulta_busqueda)
			
			if tiene_agregada_asignatura <> "0" and seot_ncorr <> "" then
			'response.Write("entre")
				consulta_busqueda= " Select distinct b.seot_ncorr from cargas_academicas_otec a, secciones_otec b where b.maot_ncorr ='"&maot_ncorr&"' and cast(a.pote_ncorr as varchar)='"&pote_ncorr&"' and a.seot_ncorr = b.seot_ncorr "&_
			                       " and a.sitf_ccod is null "
				
				consulta_delete = "delete from cargas_academicas_otec where cast(pote_ncorr as varchar)='"&pote_ncorr&"' and seot_ncorr in ("&consulta_busqueda&")"							 
			    conexion.ejecutaS consulta_delete
								
				'response.Write(consulta_delete)
				'response.Write("entre en el segundo pa eliminar")
			end if
			
			if seot_ncorr <> "" then
			
			topones_cons = "select sum(protic.topones_alumno_otec('" & seot_ncorr & "','" & pote_ncorr & "'))"
			'response.Write(topones_cons)
			'response.End()
			topones = conexion.consultaUno(topones_cons)
'			cupo_disponible_cons = " SELECT  seot_ncupo - count(b.seot_ncorr) " _
'			                     & " FROM secciones_otec a, cargas_academicas_otec b, postulacion_otec c " _
'								 & " WHERE a.seot_ncorr *= b.seot_ncorr  " _
'								 & " AND b.pote_ncorr  =* c.pote_ncorr " _
'								 & " AND c.epot_ccod   <> 4 " _
'          						 & " AND cast(a.seot_ncorr as varchar) = '" & seot_ncorr & "' " _
'          						 & " group by seot_ncupo"

'----------------------------------------------------------------------------------nueva consulta 2008
cupo_disponible_cons = " select seot_ncupo - count(b.seot_ncorr)        " _
& "from   secciones_otec as a                                           " _
& "       left outer join (cargas_academicas_otec as b                  " _
& "                        right outer join postulacion_otec as c       " _
& "                                      on b.pote_ncorr = c.pote_ncorr " _
& "                                         and c.epot_ccod <> 4)       " _
& "                    on a.seot_ncorr = b.seot_ncorr                   " _
& "where  cast(a.seot_ncorr as varchar) = '" & seot_ncorr & "'          " _
& "group  by seot_ncupo                                                 " _
'----------------------------------------------------------------------------------fin nueva consulta 2008
				 
			cupo_disponible = conexion.consultaUno(cupo_disponible_cons)
			secc_sin_cupo_cons="select cast(mote_ccod as varchar) + '-> Sección ' + cast(secc_tdesc as varchar) from secciones_otec a, mallas_otec b where cast(mote_ncorr as varchar) = '" & mote_ncorr & "' and a.maot_ncorr=b.maot_ncorr " 
			asig_sin_cupo=conexion.consultaUno(secc_sin_cupo_cons)
					 			
			if cInt(topones) > 0 then
				msj_topones = msj_topones & conexion.ConsultaUno("select protic.DETALLE_TOPONES_ALUMNO_OTEC('" & seot_ncorr & "','" & pote_ncorr & "')")
			elseif cInt(cupo_disponible) < 1 then
				msj_cupos = msj_cupos & "   - " & asig_sin_cupo & "\n"
    		else
			      inserta_carga_cons = "insert into cargas_academicas_otec (pote_ncorr, seot_ncorr, caot_fecha_carga) " & vbCrLf &_
				                       "select '" & pote_ncorr & "','" & seot_ncorr & "', getDate()  " & vbCrLf &_
									   "where not exists (select 1 from cargas_academicas_otec a2 where cast(a2.pote_ncorr as varchar)= '" & pote_ncorr & "' and cast(seot_ncorr as varchar) = '" & seot_ncorr & "')"
				'response.Write("<pre>"&inserta_carga_cons&"</pre>")
				conexion.ejecutaS inserta_carga_cons		
			end if
		end if
	End if ''''''''fin del if por si ya tiene agregada la sección ahí no se hace nada 
  next
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