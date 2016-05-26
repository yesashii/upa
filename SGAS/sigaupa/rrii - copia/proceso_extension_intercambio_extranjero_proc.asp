<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()


peri_ccod=request.form("peri_ccod")
ciex_ccod=request.form("ciex_ccod")
univ_ccod=request.form("univ_ccod")
pers_nrut=request.form("pers_nrut")
pers_xdv=request.form("pers_xdv")
pais_ccod=request.form("pais_ccod")

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

paie_ncorr=request.Form("a[0][paie_ncorr]")
set f_agrega = new CFormulario
f_agrega.Carga_Parametros "extension_intercambio_extranjero.xml", "muestra_proceso"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
		
		
		
		f_agrega.MantieneTablas false


		Respuesta = conectar.ObtenerEstadoTransaccion()
			
'next
'response.End()

'----------------------------------------------------
'response.Write("<br>respuesta "&Respuesta)
'response.End()
if Respuesta=true then
  session("mensajeerror")= "La información ha sido Guardada"
 else
 session("mensajeerror")= "No se ha podido guardar la información"
 end if
 response.Redirect("proceso_extension_intercambio_extranjero.asp?paie_ncorr="&paie_ncorr&"&pers_nrut="&pers_nrut&"&pers_xdv="&pers_xdv&"&pais_ccod="&pais_ccod&"&ciex_ccod="&ciex_ccod&"&univ_ccod="&univ_ccod&"&peri_ccod="&peri_ccod&"")

  'response.Redirect("proceso_alumnos_intercambio_extranjero.asp?paie_ncorr="&paie_ncorr&"")
%>