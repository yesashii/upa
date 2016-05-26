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
response.Redirect("bd_oferta_academica_nueva_csv.asp?arch="&arch&"")
 elseif tisa_ccod="2" then
 response.Redirect("bd_respaldados_cae.asp?arch="&arch&"")
 elseif tisa_ccod="3" then
 response.Redirect("bd_matricula_1.asp?arch="&arch&"")
 elseif tisa_ccod="4" then
 response.Redirect("bd_matricula_final.asp?arch="&arch&"")
 elseif tisa_ccod="5" then 
 response.Redirect("bd_renovantes_egresados.asp?arch="&arch&"")
 elseif tisa_ccod="6" then
 response.Redirect("bd_renovantes_no_egresados.asp?arch="&arch&"")
 elseif tisa_ccod="7" then
 response.Redirect("bd_apelantes_b_ingreso_ies.asp?arch="&arch&"")
 elseif tisa_ccod="8" then
 response.Redirect("bd_nivel_estudios_b_renovantes.asp?arch="&arch&"")
 elseif tisa_ccod="9" then
 response.Redirect("bd_oferta_academica_existente.asp?arch="&arch&"")
 end if
 %>