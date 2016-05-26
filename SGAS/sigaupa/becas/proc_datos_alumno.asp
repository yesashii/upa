<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next


'-------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo = negocio.obtenerPeriodoAcademico("Postulacion")
pers_ncorr = session("pers_ncorr_alumno")'request.Form("dp[0][pers_ncorr]")
carr_ccod = request.Form("carrera_beca")
'session("pers_ncorr_alumno")=pers_ncorr

pobe_ncorr = conexion.consultaUno("select pobe_ncorr from postulacion_becas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(carr_ccod as varchar)='"&carr_ccod&"' and cast(peri_ccod as varchar)='"&periodo&"'" )
'response.Write("select pobe_ncorr from postulacion_becas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(carr_ccod as varchar)='"&carr_ccod&"' and cast(peri_ccod as varchar)='"&periodo&"'")
set f_personas = new CFormulario
f_personas.Carga_Parametros "inicio_becas.xml", "datos_personales"
f_personas.Inicializar conexion
f_personas.ProcesaForm


f_personas.MantieneTablas false


'---------------------------------------------------------------------------------
set f_direcciones = new CFormulario
f_direcciones.Carga_Parametros "inicio_becas.xml", "direcciones"
f_direcciones.Inicializar conexion
f_direcciones.ProcesaForm
'f_direcciones.ClonaFilaPost 0

f_direcciones.AgregaCampoFilaPost 0, "tdir_ccod", "2"
f_direcciones.AgregaCampoFilaPost 0, "ciud_ccod", f_personas.ObtenerValorPost(0, "ciud_ccod_academico")
f_direcciones.AgregaCampoFilaPost 0, "dire_tcalle", f_personas.ObtenerValorPost(0, "dire_tcalle_academico")
f_direcciones.AgregaCampoFilaPost 0, "dire_tnro", f_personas.ObtenerValorPost(0, "dire_tnro_academico")
f_direcciones.AgregaCampoFilaPost 0, "dire_tpoblacion", f_personas.ObtenerValorPost(0, "dire_tpoblacion_academico")
f_direcciones.AgregaCampoFilaPost 0, "dire_tfono", f_personas.ObtenerValorPost(0, "dire_tfono_academico")
f_direcciones.AgregaCampoFilaPost 0, "dire_tblock", f_personas.ObtenerValorPost(0, "dire_tblock_academico")

f_direcciones.MantieneTablas false

'---------------------------------------------------------------------------------
set f_becas = new CFormulario
f_becas.Carga_Parametros "inicio_becas.xml", "becas"
f_becas.Inicializar conexion
f_becas.ProcesaForm
'pobe_ncorr = request.Form("pobe_ncorr")
if Esvacio(pobe_ncorr) then
	pobe_ncorr=conexion.consultauno("execute obtenersecuencia 'postulacion_becas'")
end if	 

ano_nacimiento = conexion.consultaUno("select datepart(year,convert(datetime,'"&request.form("dp[0][pers_fnacimiento]")&"'))")
consulta_oferta = " select b.ofer_ncorr from postulantes a, detalle_postulantes b, ofertas_Academicas c,especialidades d"&_
                  " where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'"&_
				  " and a.post_ncorr=b.post_ncorr " &_
				  " and cast(a.peri_ccod as varchar)='"&periodo&"'"&_
				  " and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod"&_
				  " and cast(d.carr_ccod as varchar)='"&request.Form("carrera_beca")&"'"

'response.Write(consulta_oferta)				  
oferta_academica = conexion.consultaUno(consulta_oferta)
f_becas.AgregaCampoFilaPost 0, "pobe_ncorr" ,cint(pobe_ncorr)
f_becas.AgregaCampoFilaPost 0, "pobe_nfolio", request.Form("pobe_nfolio")
epob_ccod = conexion.consultaUno("select epob_ccod from postulacion_becas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(carr_ccod as varchar)='"&carr_ccod&"' and cast(peri_ccod as varchar)='"&periodo&"'" )

if epob_ccod = "" or isnull(epob_ccod) then
	f_becas.AgregaCampoFilaPost 0, "epob_ccod",1
else
	f_becas.AgregaCampoFilaPost 0, "epob_ccod",cint(epob_ccod)
end if
f_becas.AgregaCampoFilaPost 0, "peri_ccod",cint(periodo)
f_becas.AgregaCampoFilaPost 0, "ano_nacimiento",ano_nacimiento
f_becas.AgregaCampoFilaPost 0, "ano_ingr_carrera", request.Form("ano_ingr_carrera")
f_becas.AgregaCampoFilaPost 0, "pobe_nnivel", request.Form("pobe_nnivel")
f_becas.AgregaCampoFilaPost 0, "carr_ccod",request.Form("carrera_beca")
f_becas.AgregaCampoFilaPost 0, "post_ncorr",clng(session("post_ncorr_alumno"))
f_becas.AgregaCampoFilaPost 0, "ofer_ncorr",clng(oferta_academica)
f_becas.MantieneTablas false

'conexion.estadotransaccion true
'response.End()


'---------------------------------------------------------------------------------------------------------------
Response.Redirect("grupo_familiar.asp")
%>
