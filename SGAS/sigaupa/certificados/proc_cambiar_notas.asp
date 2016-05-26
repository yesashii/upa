<!-- #include file="../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
pers_nrut=request.Form("busqueda[0][pers_nrut]")
pers_xdv=request.Form("busqueda[0][pers_xdv]")
plan_ccod=request.Form("ch[0][plan_ccod]")
url="cambiar_notas.asp?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv
'if plan_ccod<>"" then
'	url=url&"&ch[0][plan_ccod]="&plan_ccod
'end if	
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

formulario.carga_parametros "cambiar_notas.xml", "asignaturas"
formulario.inicializar conectar
formulario.procesaForm
formulario.mantienetablas false
'conectar.EstadoTransaccion false
'response.End()
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
url='<%=url%>';
window.location=url;
//CerrarActualizar();
</script>