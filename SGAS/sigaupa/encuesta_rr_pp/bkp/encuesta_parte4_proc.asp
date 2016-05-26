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
'LINEA			:77
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

preg_30= f_agrega.ObtenerValorPost (filai, "preg_30")
preg_31= f_agrega.ObtenerValorPost (filai, "preg_31")
preg_32= f_agrega.ObtenerValorPost (filai, "preg_32")
preg_33= f_agrega.ObtenerValorPost (filai, "preg_33")
preg_34_cual= f_agrega.ObtenerValorPost (filai, "preg_34_cual")
come_1= f_agrega.ObtenerValorPost (filai, "come_1")
come_2= f_agrega.ObtenerValorPost (filai, "come_2")
pers_nrut= f_agrega.ObtenerValorPost (filai, "pers_nrut")

preg_34_a=0	
preg_34_b=0
preg_34_c=0


if cstr(preg_34_cual)="" then
preg_34_cual="null"
end if

'response.Write(" que waaa "&nom_var)

for ind = 0 to 8
	nom_var=cstr("preg_34_"&ind)
	valor_preg=f_agrega.ObtenerValorPost (filai, nom_var)
	'response.Write(" assdfsd "&nom_var)
	if(valor_preg<>"") then
		response.Write("<br>Esta variable <B>"&nom_var&"</B> tiene valor: "&valor_preg )

		if preg_34_a=0 then
		preg_34_a=valor_preg
		end if
		if  preg_34_a >0 and preg_34_b=0 and preg_34_a<>valor_preg then
		preg_34_b=valor_preg
		end if
		if preg_34_a >0  and preg_34_b>0  and  preg_34_c=0 and preg_34_a<>valor_preg and preg_34_b<>valor_preg then
		preg_34_c=valor_preg
		end if
		
	end if
next

'strUpdt="update  encuesta_rr_pp set preg_30="&preg_30&",preg_31="&preg_31&",preg_32="&preg_32&",preg_33="&preg_33&",preg_34_a="&preg_34_a&",preg_34_b="&preg_34_b&",preg_34_c="&preg_34_c&",preg_34_cual='"&preg_34_cual&"',come_1='"&come_1&"',come_2='"&come_2&"'  where pers_nrut="&pers_nrut&" "

strUpdt="update  encuesta_rr_pp_02 set preg_30="&preg_30&",preg_31="&preg_31&",preg_32="&preg_32&",preg_33="&preg_33&",preg_34_a="&preg_34_a&",preg_34_b="&preg_34_b&",preg_34_c="&preg_34_c&",preg_34_cual='"&preg_34_cual&"',come_1='"&come_1&"',come_2='"&come_2&"'  where pers_nrut="&pers_nrut&" "

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
	url="menu_salida.asp"
else
	session("mensaje_error")="Error al guardar "
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
 'response.Redirect("menu_salida.asp")
 response.Redirect(url)
'end if
 %>