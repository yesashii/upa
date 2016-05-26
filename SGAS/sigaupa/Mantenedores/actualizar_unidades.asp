<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
upro_ccod = request.Form("upro_ccod")
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

for each k in request.form
	response.write(k&"="&request.Form(k)&"<br>")

next

formulario.carga_parametros "programa_asignatura.xml", "mantiene_tablas"
formulario.inicializar conectar

pras_ccod = conectar.consultauno("select pras_ccod from asignaturas where asig_ccod = '"&request.Form("asig_ccod")&"'")
if pras_ccod="" or isnull(pras_ccod) or isempty(pras_ccod) then
	pras_ccod= conectar.consultauno("exec ObtenerSecuencia 'programa_asignaturas'")
end if	
if upro_ccod="" or isnull(upro_ccod) or isempty(upro_ccod) then
	upro_ccod= conectar.consultauno("exec ObtenerSecuencia 'unidades_programa'")
end if	

formulario.procesaForm
formulario.agregacampopost "pras_ccod",pras_ccod
formulario.agregacampopost "upro_ccod",upro_ccod
formulario.agregacampopost "asig_ccod",request.Form("asig_ccod")
valor = formulario.mantienetablas (false)
if valor=false then
	Session("mensajeError") = "La Unidad No Pudo Ser Gurdada\nVerifique si La Asignatura Existe"
end if	
'response.write(request.ServerVariables("HTTP_REFERER"))
response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.Redirect("busca_asignaturas.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))
%>