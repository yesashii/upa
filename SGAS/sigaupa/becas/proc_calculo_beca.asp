<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()
'-------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_becas = new CFormulario
f_becas.Carga_Parametros "calculo_beca.xml", "becas"
f_becas.Inicializar conexion
f_becas.ProcesaForm

f_becas.AgregaCampoFilaPost 0, "pobe_ncorr" ,cint(request.Form("pobe_ncorr"))
f_becas.AgregaCampoFilaPost 0, "pobe_ningreso_original", clng(request.Form("ing_liquido_original"))
f_becas.AgregaCampoFilaPost 0, "pobe_ncosto_original",clng(request.Form("gasto_general_original"))
f_becas.AgregaCampoFilaPost 0, "pobe_nintegrantes_original",cint(request.Form("num_integrantes_original"))
f_becas.AgregaCampoFilaPost 0, "pobe_nregion_original",cint(request.Form("region_original"))
f_becas.AgregaCampoFilaPost 0, "pobe_ningreso_revisado", clng(request.Form("calculo[0][ingr_liquido_familiar]"))
f_becas.AgregaCampoFilaPost 0, "pobe_ncosto_revisado",clng(request.Form("calculo[0][gasto_total]"))
f_becas.AgregaCampoFilaPost 0, "pobe_nintegrantes_revisado",cint(request.Form("calculo[0][num_integrantes]"))
f_becas.AgregaCampoFilaPost 0, "pobe_nregion_revisado",cint(request.Form("calculo[0][regi_ccod]"))
f_becas.AgregaCampoFilaPost 0, "pobe_ngastos_minimos",clng(request.Form("calculo[0][gasto_minimo]"))
f_becas.AgregaCampoFilaPost 0, "pobe_ncapacidad_pago",clng(request.Form("calculo[0][capacidad_pago]"))
f_becas.AgregaCampoFilaPost 0, "epob_ccod",2
f_becas.MantieneTablas false

'conexion.estadotransaccion true
'response.End()

if conexion.obtenerestadotransaccion = true then
	session("mensajeError") = "El cálculo con la capacidad de pago del alumno ha sido guardado correctamente"
end if

'---------------------------------------------------------------------------------------------------------------
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
