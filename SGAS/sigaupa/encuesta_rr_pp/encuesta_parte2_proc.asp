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
'LINEA			:108
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

preg_9= f_agrega.ObtenerValorPost (filai, "preg_9")
preg_10= f_agrega.ObtenerValorPost (filai, "preg_10")
preg_11= f_agrega.ObtenerValorPost (filai, "preg_11")
preg_12= f_agrega.ObtenerValorPost (filai, "preg_12")
preg_13= f_agrega.ObtenerValorPost (filai, "preg_13")
preg_14= f_agrega.ObtenerValorPost (filai, "preg_14")
preg_15= f_agrega.ObtenerValorPost (filai, "preg_15")
preg_16= f_agrega.ObtenerValorPost (filai, "preg_16")
preg_17= f_agrega.ObtenerValorPost (filai, "preg_17")
preg_18= f_agrega.ObtenerValorPost (filai, "preg_18")
preg_19_a= f_agrega.ObtenerValorPost (filai, "preg_19_a")
preg_19_b= f_agrega.ObtenerValorPost (filai, "preg_19_b")
preg_19_c= f_agrega.ObtenerValorPost (filai, "preg_19_c")
preg_20= f_agrega.ObtenerValorPost (filai, "preg_20")
preg_20_otro= f_agrega.ObtenerValorPost (filai, "preg_20_otro")
preg_21_otro= f_agrega.ObtenerValorPost (filai, "preg_21_otro")
pers_nrut= f_agrega.ObtenerValorPost (filai, "pers_nrut")

preg_20_a=0	
preg_20_b=0
preg_20_c=0
preg_21_a=0	
preg_21_b=0
preg_21_c=0

'response.Write(" que waaa "&nom_var)

for ind = 0 to 26-1
	nom_var=cstr("preg_20_"&ind)
	valor_preg=f_agrega.ObtenerValorPost (filai, nom_var)
	'response.Write(" assdfsd "&nom_var)
	if(valor_preg<>"") then
		'response.Write("<br>Esta variable <B>"&nom_var&"</B> tiene valor: "&valor_preg )

		if preg_20_a=0 then
		preg_20_a=valor_preg
		end if
		if  preg_20_a >0 and preg_20_b=0 and preg_20_a<>valor_preg then
		preg_20_b=valor_preg
		end if
		if preg_20_a >0  and preg_20_b>0  and  preg_20_c=0 and preg_20_a<>valor_preg and preg_20_b<>valor_preg then
		preg_20_c=valor_preg
		end if
		
	end if
next

	for ind = 0 to 26-1
		nom_var=cstr("preg_21_"&ind)
		valor_preg=f_agrega.ObtenerValorPost (filai, nom_var)
		'response.Write(" assdfsd "&nom_var)
		if(valor_preg<>"") then
			'response.Write("<br>Esta variable <B>"&nom_var&"</B> tiene valor: "&valor_preg )

			if preg_21_a=0 then
			preg_21_a=valor_preg
			end if
			if  preg_21_a >0 and preg_21_b=0 and preg_21_a<>valor_preg then
			preg_21_b=valor_preg
			end if
			if preg_21_a >0  and preg_21_b>0  and  preg_21_c=0 and preg_21_a<>valor_preg and preg_21_b<>valor_preg then
			preg_21_c=valor_preg
			end if
			
		end if
	next

	if preg_3 ="" then
	preg_3=""
	end if

	'strUpdt="update  encuesta_rr_pp set preg_9="&preg_9&",preg_10="&preg_10&",preg_11="&preg_11&",preg_12="&preg_12&",preg_13="&preg_13&",preg_14="&preg_14&",preg_15="&preg_15&",preg_16="&preg_16&",preg_17="&preg_17&",preg_18="&preg_18&",preg_19_a="&preg_19_a&",preg_19_b="&preg_19_b&",preg_19_c="&preg_19_c&",preg_20_a="&preg_20_a&",preg_20_b="&preg_20_b&",preg_20_c="&preg_20_c&",preg_20_otro='"&preg_20_otro&"',preg_21_a="&preg_21_a&",preg_21_b="&preg_21_b&",preg_21_c="&preg_21_c&" ,preg_21_otro='"&preg_21_otro&"' where pers_nrut="&pers_nrut&" "
	
	strUpdt="update  encuesta_rr_pp_02 set preg_9="&preg_9&",preg_10="&preg_10&",preg_11="&preg_11&",preg_12="&preg_12&",preg_13="&preg_13&",preg_14="&preg_14&",preg_15="&preg_15&",preg_16="&preg_16&",preg_17="&preg_17&",preg_18="&preg_18&",preg_19_a="&preg_19_a&",preg_19_b="&preg_19_b&",preg_19_c="&preg_19_c&",preg_20_a="&preg_20_a&",preg_20_b="&preg_20_b&",preg_20_c="&preg_20_c&",preg_20_otro='"&preg_20_otro&"',preg_21_a="&preg_21_a&",preg_21_b="&preg_21_b&",preg_21_c="&preg_21_c&" ,preg_21_otro='"&preg_21_otro&"' where pers_nrut="&pers_nrut&" "

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
	url="encuesta_parte3.asp"
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
response.Redirect(url)
'end if
' if pag=3 then
' response.Redirect("encuesta_parte4.asp")
'end if

 %>