<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "funcion.asp" -->


<%
'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()

server.ScriptTimeout = 50000 
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


arch= request.form("arch")
tisa_ccod=request.form("b[0][tisa_ccod]")

 
 if tisa_ccod="1" then
 response.Redirect("bd_oferta_academica_existente.asp")
  elseif tisa_ccod="9" then
 response.Redirect("bd_oferta_academica_nueva_csv.asp")
 end if
 %>