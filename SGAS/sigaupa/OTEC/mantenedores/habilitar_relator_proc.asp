<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar



'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

dgso_ncorr = request.Form("n[0][dgso_ncorr]")
pers_ncorr = request.Form("n[0][pers_ncorr]")
anos_ccod  = request.Form("n[0][anos_ccod]")
'response.Write(usuario)
if  dgso_ncorr <> "" and pers_ncorr <> "" and anos_ccod <> "" then
	
consulta = " insert into relatores_programa (dgso_ncorr,pers_ncorr,anos_ccod,audi_tusuario,audi_fmodificacion)"&_
    	   " values ("&dgso_ncorr&","&pers_ncorr&","&anos_ccod&",'"&negocio.obtenerUsuario&"',getDate())"
'response.Write("<br>"&consulta)
'response.End()
conectar.ejecutaS (consulta)
'
end if 	

'response.Write(consulta)
'response.End()
'conectar.ejecutaS consulta

if conectar.obtenerEstadoTransaccion then 
		conectar.MensajeError "Habilitación de relator en porgrama logrado exitosamente"
else
conectar.MensajeError "Hubo un error al guardar"
end if
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
