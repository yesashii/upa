<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "edicion_credito.xml", "cheques"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

monto_bene = f_agrega.ObtenerValorPost (filai, "monto_bene")
observacion = f_agrega.ObtenerValorPost (filai, "observacion")
acre_ncorr = f_agrega.ObtenerValorPost (filai, "acre_ncorr")
post_ncorr = f_agrega.ObtenerValorPost (filai, "post_ncorr")
tdet_ccod = f_agrega.ObtenerValorPost (filai, "tdet_ccod")



response.Write("<pre>llll= "&monto_bene&"</pre>")
response.Write("<pre>"&observacion&"</pre>")
response.Write("<pre>acre_ncorr= "&acre_ncorr&"</pre>")
response.Write("<pre>post_ncorr= "&post_ncorr&"</pre>")
response.Write("<pre>tdet_ccod= "&tdet_ccod&"</pre>")



 usu=negocio.obtenerUsuario
 
 if cstr(monto_bene)="" and cstr(acre_ncorr) <>"" then
 	p_update1="update  alumno_credito set observacion='"&observacion&"',audi_tusuario='"&usu&"',audi_fmodificacion=getDate() where acre_ncorr="&acre_ncorr&""	
	'conectar.ejecutaS (p_update1).
	
	response.Write("<pre>"&p_update1&"</pre>")
	end if
	 if cstr(monto_bene)<>"" and cstr(acre_ncorr) <>"" then
		p_update2="update  alumno_credito set monto_bene="&monto_bene&",observacion='"&observacion&"',audi_tusuario='"&usu&"',audi_fmodificacion=getDate() where acre_ncorr="&acre_ncorr&""	
		'conectar.ejecutaS (p_update2)	  
		response.Write("<pre>"&p_update2&"</pre>")

	
	end if


'response.Write("respuesta "&Respuesta)	

if acre_ncorr="" then




pers_ncorr=conectar.ConsultaUno("select pers_ncorr from postulantes where post_ncorr="&post_ncorr&"")
tipo_alumno_cae=conectar.ConsultaUno("select protic.tipo_alumno_CAE ("&pers_ncorr&","&post_ncorr&")") 
acre_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'alumno_credito'")

if cstr(monto_bene) <>"" then

		p_insert1= "insert into alumno_credito (acre_ncorr,post_ncorr,tdet_ccod,audi_tusuario,audi_fmodificacion,monto_bene,observacion,tipo_alumno_cae) values ("&acre_ncorr&","&post_ncorr&","&tdet_ccod&",'"&usu&"',getDate(),"&monto_bene&",'"&observacion&"','"&tipo_alumno_cae&"')"
		'conectar.ejecutaS (p_insert1)
		response.Write("<pre>1 "&p_insert1&"</pre>")
	else	
		
				p_insert2= "insert into alumno_credito (acre_ncorr,post_ncorr,tdet_ccod,audi_tusuario,audi_fmodificacion,observacion,tipo_alumno_cae) values ("&acre_ncorr&","&post_ncorr&","&tdet_ccod&",'"&usu&"',getDate(),'"&observacion&"','"&tipo_alumno_cae&"')"
		conectar.ejecutaS (p_insert2)
		response.Write("<pre>2 "&p_insert2&"</pre>")
end if 		
end if
	

'response.Write("<pre>"&p_insert&"</pre>")	

	
next




'response.End()












Respuesta = conectar.ObtenerEstadoTransaccion()


'----------------------------------------------------
response.Write("respuesta "&Respuesta)

'response.End()
if Respuesta = true then
session("mensajeerror")= " El alumno fue editado con Éxito"
else
  session("mensajeerror")= "Error al guardar "
end if
'response.End()


'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("creditos.asp")
%>


