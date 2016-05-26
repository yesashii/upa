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


anos_ccod=request.Form("b[0][anos_ccod]")
pais_ccod=request.Form("b[0][pais_ccod]")
ciex_ccod=request.Form("b[0][ciex_ccod]")

set f_agrega = new CFormulario
f_agrega.Carga_Parametros "convenios_rrii.xml", "convenio_final"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

daco_ncorr= f_agrega.ObtenerValorPost (filai, "daco_ncorr")
 'acre_ncorr=1000
 
 Respuesta=cdbl(conectar.ConsultaUno("exec GENERA_CONVENIO_INTERNACIONAL_NUEVO_ANO "&daco_ncorr&""))

next

'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()
if Respuesta = 0 then
  session("mensajeerror")= " Se ha Guardado con exito"
elseif  Respuesta = 99 then
  session("mensajeerror")= "El Convenio ya esta creado para el año"
elseif  Respuesta = 1 or Respuesta = 2 then
  session("mensajeerror")= "Error al Guardar "
 else 
  session("mensajeerror")= "Error al Guardar "
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("editar_convenio.asp?buscar=S&b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Banos_ccod%5D="&anos_ccod&"")









%>


