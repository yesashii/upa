<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
response.Write("<br> AQUI<br>")
	
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
	
 
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar
'
'
set f_agrega = new CFormulario
f_agrega.Carga_Parametros "tabla_vacia.xml", "tabla"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1	

I_preg_1= f_agrega.ObtenerValorPost (filai, "preg_0")
response.Write("<BR>"&I_preg_1)

next	

response.end()
%>