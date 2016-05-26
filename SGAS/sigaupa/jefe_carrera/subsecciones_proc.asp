<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%

set conexion = new cConexion
set fsecc_asig = new cFormulario
set negocio = new cNegocio

conexion.inicializar "upacifico"

'eliminar = request.Form("E.x")
'actualizar = request.Form("A.x")
'insertar = request.Form("I.x")

if request.form("btn_clickeado") = "1" then  insertar = "1" end if
if request.form("btn_clickeado") = "2" then  actualizar = "2" end if
if request.form("btn_clickeado") = "3" then  eliminar = "3" end if

secc_ccod = request.Form("secc_ccod")
sede_ccod = request.Form("sede_ccod")
carr_ccod = request.Form("carr_ccod")
jorn_ccod = request.Form("jorn_ccod")
moda_ccod = request.Form("moda_ccod")
peri_ccod = request.Form("peri_ccod")
asig_ccod = request.Form("asig_ccod")
'response.Write("<br>sede "&sede_ccod& " peri "&peri_ccod&" asig "&asig_ccod& " carr "& carr_ccod)

tsse_ccod = 2
		
if insertar <> "" then
	fsecc_asig.carga_parametros "parametros.xml", "5.1"
	fsecc_asig.inicializar conexion
	fechaInicioClases = conexion.consultaUno("select convert(varchar,secc_finicio_sec,103) from secciones where secc_ccod=" & secc_ccod)
	fechaTerminoClases = conexion.consultaUno("select convert(varchar,secc_ftermino_sec,103) from secciones where secc_ccod=" & secc_ccod)
	fsecc_asig.creaFilaPost
	fsecc_asig.agregaCampoPost "ssec_finicio_sec", fechaInicioClases
	fsecc_asig.agregaCampoPost "ssec_ftermino_sec", fechaTerminoClases
	fsecc_asig.agregaCampoPost "ssec_ncorr", ""
	fsecc_asig.agregaCampoPost "secc_ccod", secc_ccod
	fsecc_asig.agregaCampoPost "sede_ccod", sede_ccod
	fsecc_asig.agregaCampoPost "jorn_ccod", jorn_ccod
	fsecc_asig.agregaCampoPost "carr_ccod", carr_ccod
	fsecc_asig.agregaCampoPost "moda_ccod", moda_ccod
	fsecc_asig.agregaCampoPost "peri_ccod", peri_ccod
	fsecc_asig.agregaCampoPost "asig_ccod", asig_ccod
	fsecc_asig.agregaCampoPost "ssec_ncupo", ""
	fsecc_asig.agregaCampoPost "ssec_nquorum", ""
	fsecc_asig.agregaCampoPost "tsse_ccod", tsse_ccod
	fsecc_asig.mantieneTablas false
end if
if actualizar <> "" then
	fsecc_asig.carga_parametros "parametros.xml", "5.1"
	fsecc_asig.inicializar conexion
	fsecc_asig.procesaForm
	fsecc_asig.mantieneTablas false
end if
if eliminar <> "" then
	fsecc_asig.carga_parametros "parametros.xml", "5.2"
	fsecc_asig.inicializar conexion
	fsecc_asig.procesaForm
	fsecc_asig.intercambiaCampoPost "secc_ccod_paso", "secc_ccod"
	fsecc_asig.mantieneTablas false
end if	

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>