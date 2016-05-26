<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
on error resume next
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()
mote_ccod = request.Form("m[0][mote_ccod]")
modifica = request.Form("modifica")
esta_grabado = conectar.consultaUno("select count(*) from modulos_otec where cast(mote_ccod as varchar)='"&mote_ccod&"'")
'response.Write("esta_grabado "&esta_grabado&" modifica "&modifica)
'response.End()  
if esta_grabado = "0" or modifica <> "" then
	formulario.carga_parametros "editar_modulos.xml", "mantiene_modulos"
	formulario.inicializar conectar
	formulario.procesaForm
	formulario.mantienetablas false
	if conectar.obtenerEstadoTransaccion then 
		conectar.MensajeError "Módulo guardado exitosamente"
	end if
elseif esta_grabado <> "0" and modifica = "" then
	conectar.MensajeError "Ya existe un módulo con este código en el sistema."
end if 
'response.write(request.ServerVariables("HTTP_REFERER"))
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.End()
'response.Redirect("editar_asignatura.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))

%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
//var grabado = '<%=esta_grabado%>';
//if (grabado != '0')
//{
	CerrarActualizar();
//}
//else
//{
//	window.close();
//}	
</script>