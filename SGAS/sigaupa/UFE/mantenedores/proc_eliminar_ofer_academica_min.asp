<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()
set conectar = new CConexion
conectar.Inicializar "upacifico"

set formulario = new CFormulario
formulario.carga_parametros "adm_ofer_academica_min.xml", "eliminar_ofer_academica_min"
formulario.inicializar conectar
formulario.procesaForm

for filai = 0 to formulario.CuentaPost - 1
    eliminar=formulario.ObtenerValorPost (filai, "eliminar")
	
	if eliminar = "" then
	    formulario.EliminaFilaPost filai
    end if 
'response.Write(k&" = "&request.Form(k)&"<br>")
next
v_tran = formulario.mantienetablas 	(false)
'conectar.estadotransaccion FALSE
'response.End()
if v_tran = False then
	Session("mensajeError") = "Imposible Eliminar"
end if 
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
//	self.location.reload();
//	window.close();
</script>
