<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
tici_ccod=request.QueryString("tici_ccod")
pers_ncorr=request.QueryString("pers_ncorr")

'-----------------------------------------------------
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next
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

usu=negocio.obtenerUsuario

q_doie_ncorr=request.Form("a[0][doie_ncorr]")
paie_ncorr=request.Form("a[0][paie_ncorr]")
set f_agrega = new CFormulario
f_agrega.Carga_Parametros "alumnos_intercambio_extranjero.xml", "muestra_proceso"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
		
		if q_doie_ncorr=""then		
		q_doie_ncorr= conectar.ConsultaUno("execute obtenersecuencia 'documen_intercambio_extranjero'")
		'response.Write("doie_ncorr=>"&q_doie_ncorr)
		f_agrega.agregacampopost "doie_ncorr",q_doie_ncorr
		end if
		
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
 response.Redirect("proceso_alumnos_intercambio_extranjero.asp?paie_ncorr="&paie_ncorr&"&pers_nrut="&pers_nrut&"&pers_xdv="&pers_xdv&"&pais_ccod="&pais_ccod&"&ciex_ccod="&ciex_ccod&"&univ_ccod="&univ_ccod&"&peri_ccod="&peri_ccod&"&tici_ccod="&tici_ccod&"&pers_ncorr="&pers_nccor&"")

  'response.Redirect("proceso_alumnos_intercambio_extranjero.asp?paie_ncorr="&paie_ncorr&"")










%>


