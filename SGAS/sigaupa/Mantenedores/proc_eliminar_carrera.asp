<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next

set conectar = new CConexion
conectar.Inicializar "upacifico"

set formulario = new CFormulario
formulario.carga_parametros "adm_carreras.xml", "eliminar_carreras"
formulario.inicializar conectar
formulario.procesaForm

v_tran = formulario.mantienetablas 	(false)
'response.End()
if v_tran = False then
	Session("mensajeError") = "Imposible Eliminar\nVerifique Que La Carrera no Tenga Especialidad,Plan Y Malla Curricular"
end if 
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
//	self.location.reload();
//	window.close();
</script>
