<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_post_ncorr = Session("post_ncorr")
if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()
'-------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"


set f_personas = new CFormulario
f_personas.Carga_Parametros "postulacion_2.xml", "datos_personales"
f_personas.Inicializar conexion
f_personas.ProcesaForm

if f_personas.ObtenerValorPost(0, "otro_colegio") = "S" then
	f_personas.AgregaCampoPost "cole_ccod", ""
else
	f_personas.AgregaCampoPost "pers_tcole_egreso", ""	
end if

if f_personas.ObtenerValorPost(0, "tens_ccod") <> "4" then
	f_personas.AgregaCampoPost "pers_ttipo_ensenanza", ""
end if
	
if f_personas.ObtenerValorPost(0, "pais_ccod") = "1" then
	f_personas.AgregaCampoPost "tvis_ccod", ""
	f_personas.AgregaCampoPost "pers_tpasaporte", ""
	f_personas.AgregaCampoPost "pers_femision_pas", ""
	f_personas.AgregaCampoPost "pers_fvencimiento_pas", ""
	f_personas.AgregaCampoPost "pers_bdoble_nacionalidad", ""
else
	f_personas.ClonaColumnaPost "pers_nrut_extranjero", "pers_nrut"
	f_personas.ClonaColumnaPost "pers_xdv_extranjero", "pers_xdv"
end if

f_personas.MantieneTablas false


'---------------------------------------------------------------------------------
set f_direcciones = new CFormulario
f_direcciones.Carga_Parametros "postulacion_2.xml", "direcciones"
f_direcciones.Inicializar conexion
f_direcciones.ProcesaForm
f_direcciones.ClonaFilaPost 0


f_direcciones.AgregaCampoFilaPost 0, "tdir_ccod", "1"
f_direcciones.AgregaCampoFilaPost 0, "ciud_ccod", f_personas.ObtenerValorPost(0, "ciud_ccod_particular")
f_direcciones.AgregaCampoFilaPost 0, "dire_tcalle", f_personas.ObtenerValorPost(0, "dire_tcalle_particular")
f_direcciones.AgregaCampoFilaPost 0, "dire_tnro", f_personas.ObtenerValorPost(0, "dire_tnro_particular")
f_direcciones.AgregaCampoFilaPost 0, "dire_tpoblacion", f_personas.ObtenerValorPost(0, "dire_tpoblacion_particular")
f_direcciones.AgregaCampoFilaPost 0, "dire_tfono", f_personas.ObtenerValorPost(0, "pers_tfono")
f_direcciones.AgregaCampoFilaPost 0, "dire_tblock", f_personas.ObtenerValorPost(0, "dire_tblock_particular")


f_direcciones.MantieneTablas false
'conexion.estadotransaccion false
'response.End()

'---------------------------------------------------------------------------------------------------------------
Response.Redirect("postulacion_5_breve.asp")
%>
