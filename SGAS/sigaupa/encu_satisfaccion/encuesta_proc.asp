<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()



 
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar
'
'
set f_agrega = new CFormulario
f_agrega.Carga_Parametros "encuesta_rr_pp.xml", "encuesta"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1



area= f_agrega.ObtenerValorPost (filai, "area")
nombre= f_agrega.ObtenerValorPost (filai, "nombre")
responsable= f_agrega.ObtenerValorPost (filai, "responsable")
fecha= f_agrega.ObtenerValorPost (filai, "fecha")
preg_I_1= f_agrega.ObtenerValorPost (filai, "I_preg_1")
preg_I_2= f_agrega.ObtenerValorPost (filai, "I_preg_2")
preg_I_3= f_agrega.ObtenerValorPost (filai, "I_preg_3")
preg_I_4= f_agrega.ObtenerValorPost (filai, "I_preg_4")
preg_I_5= f_agrega.ObtenerValorPost (filai, "I_preg_5")
preg_II_1= f_agrega.ObtenerValorPost (filai, "preg_II_1")
preg_II_2= f_agrega.ObtenerValorPost (filai, "preg_II_2")
preg_II_3= f_agrega.ObtenerValorPost (filai, "II_preg_3")
preg_II_4= f_agrega.ObtenerValorPost (filai, "II_preg_4")
preg_II_5= f_agrega.ObtenerValorPost (filai, "II_preg_5")
preg_II_6= f_agrega.ObtenerValorPost (filai, "II_preg_6")
preg_II_6_como= f_agrega.ObtenerValorPost (filai, "II_preg_6_como")
preg_III_1_1= f_agrega.ObtenerValorPost (filai, "III_preg_1_1")
preg_III_1_2= f_agrega.ObtenerValorPost (filai, "III_preg_1_2")
preg_III_1_3= f_agrega.ObtenerValorPost (filai, "III_preg_1_3")
preg_III_1_4= f_agrega.ObtenerValorPost (filai, "III_preg_1_4")
preg_III_1_otro= f_agrega.ObtenerValorPost (filai, "preg_III_1_otro")
comentario= f_agrega.ObtenerValorPost (filai, "comentarios")




ensa_ncorr=conectar.ConsultaUno("exec obtenerSecuencia 'encuesta_satisfaccion'")
audi_fmodificacion=conectar.ConsultaUno("select getdate()")


		strInser="insert into encuesta_satisfaccion (ensa_ncorr,ensa_area,ensa_nombre,ensa_responsable,ensa_fecha,ensa_preg_I_1,ensa_preg_I_2,ensa_preg_I_3,ensa_preg_I_4,ensa_preg_I_5,ensa_preg_II_1,	ensa_preg_II_2,	ensa_preg_II_3,	ensa_preg_II_4,	ensa_preg_II_5	,ensa_preg_II_6,	ensa_II_preg_6_como,	ensa_preg_III_1_1,	ensa_preg_III_1_2,	ensa_preg_III_1_3,	ensa_preg_III_1_4,	preg_III_1_otro,	comentario,	audi_fmodificacion) values("&ensa_ncorr&",'"&area&"','"&nombre&"','"&responsable&"',convert(datetime,'"&fecha&"',103),'"&preg_I_1&"','"&preg_I_2&"','"&preg_I_3&"','"&preg_I_4&"','"&preg_I_5&"','"&preg_II_1&"','"&preg_II_2&"','"&preg_II_3&"','"&preg_II_4&"','"&preg_II_5&"','"&preg_II_6&"','"&preg_II_6_como&"','"&preg_III_1_1&"','"&preg_III_1_2&"','"&preg_III_1_3&"','"&preg_III_1_4&"','"&preg_III_1_otro&"','"&comentario&"',getDate())"


	conectar.ejecutaS (strInser)
next

response.Write("<pre> "&strInser&"</pre>")

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
'response.End()
'if post_ncorr <>""  and tiene_beca="N" then
'if Respuesta = true then
'session("mensajeerror")= " El alumno fue ingresado con Éxito"
'else
'  session("mensajeerror")= "Error al guardar "
''end if
'response.End()
'
response.Redirect("menu_salida.asp")
'end if
'if pag=2 then
'response.Redirect("encuesta_parte3.asp")
'end if
' if pag=3 then
' response.Redirect("encuesta_parte4.asp")
'end if
 %>