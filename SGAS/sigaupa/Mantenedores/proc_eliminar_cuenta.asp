<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set conectar = new CConexion
conectar.Inicializar "upacifico"

set formulario = new CFormulario
formulario.carga_parametros "adm_cuentas.xml", "eliminar_cuentas"
formulario.inicializar conectar
formulario.procesaForm

v_tran = formulario.mantienetablas 	(false)
if v_tran = False then
	Session("mensajeError") = "Imposible Eliminar\nVerifique Que La cuenta no Tenga Ingresos/Cargos asociados"
end if 
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
//	self.location.reload();
//	window.close();
</script>
