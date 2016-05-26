<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:19/08/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ENCUESTAS
'LINEA			: 69
'*******************************************************************
'for each k in request.form
'response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

set f_agrega = new CFormulario
f_agrega.Carga_Parametros "encuesta_rr_pp.xml", "encuesta"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

preg_22= f_agrega.ObtenerValorPost (filai, "preg_22")
preg_23= f_agrega.ObtenerValorPost (filai, "preg_23")
preg_24= f_agrega.ObtenerValorPost (filai, "preg_24")
preg_25= f_agrega.ObtenerValorPost (filai, "preg_25")
preg_26= f_agrega.ObtenerValorPost (filai, "preg_26")
preg_27= f_agrega.ObtenerValorPost (filai, "preg_27")
preg_27_tipo= f_agrega.ObtenerValorPost (filai, "preg_27_tipo")
preg_28=f_agrega.ObtenerValorPost (filai, "preg_28")
preg_29= f_agrega.ObtenerValorPost (filai, "preg_29")
preg_29_otro= f_agrega.ObtenerValorPost (filai, "preg_29_otro")
pers_nrut= f_agrega.ObtenerValorPost (filai, "pers_nrut")

if cstr(preg_22) = "" then
preg_22= "null"
end if

if cstr(preg_23) = "" then
preg_23= ""
end if

if cstr(preg_24) = "" then
preg_24= ""
end if

if cstr(preg_25) = "" then
preg_25= ""
end if

if cstr(preg_26) = "" then
preg_26= ""
end if

if cstr(preg_27) = "" then
preg_27= ""
end if

if cstr(preg_27_tipo) = "" then
preg_27_tipo= ""
end if

if cstr(preg_28) = "" or preg_27="S" then
preg_27=""
end if

'if cstr(preg_29_otro) = "" then
'preg_29_otro="null"
'end if

		'strUpdt="update  encuesta_rr_pp set preg_22="&preg_22&",preg_23="&preg_23&",preg_24="&preg_24&",preg_25="&preg_25&",preg_26="&preg_26&",preg_27='"&preg_27&"',preg_27_tipo="&preg_27_tipo&",preg_28="&preg_28&" ,preg_29="&preg_29&" where pers_nrut="&pers_nrut&" "

		strUpdt="update  encuesta_rr_pp_02 set preg_22='"&preg_22&"',preg_23='"&preg_23&"',preg_24='"&preg_24&"',preg_25='"&preg_25&"',preg_26='"&preg_26&"',preg_27='"&preg_27&"',preg_27_tipo='"&preg_27_tipo&"',preg_28='"&preg_28&"',preg_29='"&preg_29&"',preg_29_otro='"&preg_29_otro&"' where cast(pers_nrut as varchar)='"&pers_nrut&"'"

		'response.Write("<pre>"&strUpdt&"</pre>")
		
		conectar.ejecutaS (strUpdt)
	
next

'response.End()

'response.Write("<pre>rut= "&pers_nrut&"</pre>")	
'response.Write("<pre>xdv= "&pers_xdv&"</pre>")
'response.Write("<pre>usu= "&usu&"</pre>")
'response.Write("<pre>peri= "&peri_ccod&"</pre>")
'response.Write("<pre>pos= "&post_ncorr&"</pre>")
'response.Write("<pre>tdet= "&tdet_ccod&"</pre>")
'response.Write("<pre>tiene = "&tiene_beca&"</pre>")
'response.Write("<pre>tiene = "&cuenta_post&"</pre>")
'response.Write("respuesta "&Respuesta)
'response.End()

Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)

'if post_ncorr <>""  and tiene_beca="N" then

if Respuesta = true then
	'session("mensaje_error")= " El alumno fue ingresado con Éxito"
	url="encuesta_parte4.asp"
else
  session("mensaje_error")= "Error al guardar "
  url=request.ServerVariables("HTTP_REFERER")
end if
'response.End()
'else

'if cuenta_post = 0 then
' session("mensajeerror")= "El alumno no tiene matricula para el periodo seleccionado "
'end if
'if tiene_beca="S" then
' session("mensajeerror")= "El alumno ya registra este credito para el periodo academico seleccionado "
'end if
'end if
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
'if pag=1 then
' response.Redirect("encuesta_parte2.asp")
'end if
'if pag=2 then
'response.Redirect("encuesta_parte3.asp")
'end if
' if pag=3 then
 'response.Redirect("encuesta_parte4.asp")
 response.Redirect(url)
'end if
 %>