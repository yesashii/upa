<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_post_ncorr = Session("post_ncorr")
if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if

'-------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"


set f_personas = new CFormulario
f_personas.Carga_Parametros "postulacion_2.xml", "datos_personales"
f_personas.Inicializar conexion
f_personas.ProcesaForm


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
'f_direcciones.AgregaCampoFilaPost 0, "ciud_ccod", f_personas.ObtenerValorPost(0, "ciud_ccod_particular")
if f_personas.ObtenerValorPost(0, "pais_ccod") = "1" then
    f_direcciones.AgregaCampoFilaPost 0, "ciud_ccod", f_personas.ObtenerValorPost(0, "ciud_ccod_particular")
else
    f_direcciones.AgregaCampoFilaPost 0, "ciud_ccod",""  
end if
f_direcciones.AgregaCampoFilaPost 0, "dire_tcalle", f_personas.ObtenerValorPost(0, "dire_tcalle_particular")
f_direcciones.AgregaCampoFilaPost 0, "dire_tnro", f_personas.ObtenerValorPost(0, "dire_tnro_particular")
f_direcciones.AgregaCampoFilaPost 0, "dire_tpoblacion", f_personas.ObtenerValorPost(0, "dire_tpoblacion_particular")
f_direcciones.AgregaCampoFilaPost 0, "dire_tfono", f_personas.ObtenerValorPost(0, "pers_tfono")
f_direcciones.AgregaCampoFilaPost 0, "dire_tblock", f_personas.ObtenerValorPost(0, "dire_tblock_particular")

f_direcciones.AgregaCampoFilaPost 1, "tdir_ccod", "2"
f_direcciones.AgregaCampoFilaPost 1, "ciud_ccod", f_personas.ObtenerValorPost(0, "ciud_ccod_academico")
f_direcciones.AgregaCampoFilaPost 1, "dire_tcalle", f_personas.ObtenerValorPost(0, "dire_tcalle_academico")
f_direcciones.AgregaCampoFilaPost 1, "dire_tnro", f_personas.ObtenerValorPost(0, "dire_tnro_academico")
f_direcciones.AgregaCampoFilaPost 1, "dire_tpoblacion", f_personas.ObtenerValorPost(0, "dire_tpoblacion_academico")
f_direcciones.AgregaCampoFilaPost 1, "dire_tfono", f_personas.ObtenerValorPost(0, "dire_tfono_academico")
f_direcciones.AgregaCampoFilaPost 1, "dire_tblock", f_personas.ObtenerValorPost(0, "dire_tblock_academico")


f_direcciones.MantieneTablas false
'conexion.estadotransaccion false

'---------------------------------------------------------------------------------------------------------------
Response.Redirect("postulacion_3.asp")
%>
