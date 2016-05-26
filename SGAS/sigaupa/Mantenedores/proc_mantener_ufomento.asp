<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x))
'next


ufom_ncorr=	request.Form("ufomento[0][ufom_ncorr]")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

conexion.EstadoTransaccion TRUE

set f_ufomento = new CFormulario
f_ufomento.Carga_parametros  "mantener_ufomento.xml" , "ufomento"
f_ufomento.Inicializar conexion
f_ufomento.ProcesaForm

if ufom_ncorr = "" or ESVACIO(ufom_ncorr) then
	ufom_ncorr 		= conexion.consultauno("exec ObtenerSecuencia 'uf'")
	f_ufomento.AgregaCampoPost "ufom_ncorr" ,ufom_ncorr
end if

'f_ufomento.AgregaCampoPost "ufom_fuf", "ufom_fuf"

'f_ufomento.ListarPost

f_ufomento.MantieneTablas False  
'response.end()
Response.Redirect "../Mantenedores/mantener_uf.asp?b%5B0%5D%5Banos_ccod%5D=" & request.QueryString("var")& ""                                                                                                                                                                                                                                                                                                                                                                              
%>
