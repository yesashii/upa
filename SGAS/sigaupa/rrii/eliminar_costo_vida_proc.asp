<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

pais_ccod=request.Form("b[0][pais_ccod]")
ciex_ccod=request.Form("b[0][ciex_ccod]")
anos_ccod=request.Form("b[0][anos_ccod]")

response.Write(pais_ccod&" "&ciud_ccod&" "&anos_ccod)


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "convenios_rrii.xml", "agrega_costo_vida"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

covi_ncorr = f_agrega.ObtenerValorPost (filai, "covi_ncorr")
 'acre_ncorr=1000
 usu=negocio.obtenerUsuario
 if  covi_ncorr<>"" then
	p_insert="delete from costo_vida  where covi_ncorr="&covi_ncorr&""		  
	response.Write("<pre>"&p_insert&"</pre>")
	conectar.ejecutaS (p_insert)
	Respuesta = conectar.ObtenerEstadoTransaccion()
end if
next
'response.End()

'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()
if Respuesta = true then
'session("mensajeerror")= " La Carrera fue Borrada"
else
  session("mensajeerror")= "Error al Borrar "
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("agrega_costo_vida.asp?b%5B0%5D%5Bcovi_ncorr%5D=&b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Banos_ccod%5D="&anos_ccod&"&b%5B0%5D%5Btcvi_ccod%5D=&b%5B0%5D%5Bmonto%5D=&b%5B0%5D%5Bcomentario%5D=")









%>


