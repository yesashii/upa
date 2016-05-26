<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next

peri_ccod=request.Form("a[0][peri_ccod]")


set conectar = new cconexion
conectar.inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conectar


set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conectar							





'acre_ncorr=10000
 usu=negocio.obtenerUsuario
 
	p_insert="update semestre_activo set peri_ccod="&peri_ccod&" , audi_tusuario='"&usu&"' , audi_fmodificacion=getdate()"		  
	'response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)


'response.Write(existe)
'sresponse.End()

Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------


	
	
	if Respuesta = true then
	session("mensajeerror")= "El Semestre ha sido Activado"
	else
	  session("mensajeerror")= "Error al guardar "
	end if
	'response.End()
	response.Redirect("activar_semestre_sicologas.asp")





%>


