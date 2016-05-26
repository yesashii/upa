<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.Write("<hr>")
v_post_ncorr = Session("post_ncorr")
if EsVacio(v_post_ncorr) then
	Response.Redirect("inicio.asp")
end if

'-------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false


'-------------------------------------------------------------------------------------------------------
set f_antecedentes = new CFormulario
f_antecedentes.Carga_Parametros "postulacion_3.xml", "antecedentes"
f_antecedentes.Inicializar conexion
f_antecedentes.ProcesaForm

f_antecedentes.agregacampopost "CIUD_CCOD_COLE",request.Form("antecedentes[0][ciud_ccod_colegio]")

if f_antecedentes.ObtenerValorPost(0, "otro_colegio") = f_antecedentes.ObtenerDescriptor("otro_colegio", "valorFalso") then
	f_antecedentes.AgregaCampoPost "pers_tcole_egreso", ""
else
	f_antecedentes.AgregaCampoPost "cole_ccod", ""
end if

if f_antecedentes.ObtenerValorPost(0, "tens_ccod") <> "4" then
	f_antecedentes.AgregaCampoPost "pers_ttipo_ensenanza", ""
end if

if f_antecedentes.ObtenerValorPost(0, "ties_ccod")  <> "0" then
	f_antecedentes.AgregaCampoPost "post_ttipo_institucion_ant", ""
end if

if f_antecedentes.ObtenerValorPost(0, "otra_institucion") = f_antecedentes.ObtenerDescriptor("otra_institucion", "valorFalso") then
	f_antecedentes.AgregaCampoPost "post_tinstitucion_anterior", ""
else
	f_antecedentes.AgregaCampoPost "iesu_ccod", ""
end if

if f_antecedentes.ObtenerValorPost(0, "post_btitulado") = f_antecedentes.ObtenerDescriptor("post_btitulado", "valorFalso") then
	f_antecedentes.AgregaCampoPost "post_ttitulo_obtenido", ""
end if


if f_antecedentes.ObtenerValorPost(0, "post_btrabaja") = f_antecedentes.ObtenerDescriptor("post_btrabaja", "valorFalso") then
	'f_antecedentes.AgregaCampoPost "pers_tempresa", ""
	'f_antecedentes.AgregaCampoPost "pers_tcargo", ""	
end if



f_antecedentes.MantieneTablas false

'-------------------------------------------------------------------------------------------------------
set f_direccion_laboral = new CFormulario
f_direccion_laboral.Carga_Parametros "postulacion_3.xml", "direccion_laboral"
f_direccion_laboral.Inicializar conexion
f_direccion_laboral.ProcesaForm

f_direccion_laboral.ClonaColumnaPost "ciud_ccod_empresa", "ciud_ccod"
f_direccion_laboral.AgregaCampoPost "tdir_ccod", "3"

f_direccion_laboral.MantieneTablas false

'-------------------------------------------------------------------------------------------------------
set f_actividades_realizadas = new CFormulario
f_actividades_realizadas.Carga_Parametros "postulacion_3.xml", "actividades_realizadas"
f_actividades_realizadas.Inicializar conexion
f_actividades_realizadas.ProcesaForm

set f_elimina_actividades_realizadas = new CFormulario
f_elimina_actividades_realizadas.Carga_Parametros "postulacion_3.xml", "elimina_actividades_realizadas"
f_elimina_actividades_realizadas.Inicializar conexion
f_elimina_actividades_realizadas.ProcesaForm

for i_ = 0 to f_actividades_realizadas.CuentaPost - 1
	v_realizada = f_actividades_realizadas.ObtenerValorPost(i_, "actividad_realizada")
	
	if v_realizada = f_actividades_realizadas.ObtenerDescriptor("actividad_realizada", "valorFalso") then
		f_actividades_realizadas.EliminaFilaPost i_
	else
		f_elimina_actividades_realizadas.EliminaFilaPost i_
	end if	
next

f_actividades_realizadas.MantieneTablas false
f_elimina_actividades_realizadas.MantieneTablas false


'---------------------------------------------------------------------------------------------------------------
set f_actividades_participar = new CFormulario
f_actividades_participar.Carga_Parametros "postulacion_3.xml", "actividades_participar"
f_actividades_participar.Inicializar conexion
f_actividades_participar.ProcesaForm

set f_elimina_actividades_participar = new CFormulario
f_elimina_actividades_participar.Carga_Parametros "postulacion_3.xml", "elimina_actividades_participar"
f_elimina_actividades_participar.Inicializar conexion
f_elimina_actividades_participar.ProcesaForm

for i_ = 0 to f_actividades_participar.CuentaPost - 1
	v_participar = f_actividades_participar.ObtenerValorPost(i_, "bparticipar")
	
	if v_participar = f_actividades_participar.ObtenerDescriptor("bparticipar", "valorFalso") then
		f_actividades_participar.EliminaFilaPost i_
	else
		f_elimina_actividades_participar.EliminaFilaPost i_
	end if	
next

f_actividades_participar.MantieneTablas false
f_elimina_actividades_participar.MantieneTablas false

'---------------------------------------------------------------------------------------------------------------
'conexion.estadotransaccion false
Response.Redirect("postulacion_4.asp")
%>
