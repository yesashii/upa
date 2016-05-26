<!-- #include file="../biblioteca/_conexion.asp" -->

<%
set conectar = new CConexion
set formulario = new cformulario

conectar.Inicializar "desauas"

formulario.Carga_Parametros "busca_docentes.xml", "eliminar_docente"
formulario.Inicializar conectar

formulario.ProcesaForm 

VALOR = formulario.MantieneTablas (FALSE)
if VALOR=false then
	Session("mensajeError") = "Imposible Eliminar Al Profesor Tiene Asignaturas Programadas"
end if	


response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

