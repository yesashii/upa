<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "convenios_rrii.xml", "agrega_ciudad_extranjera"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm
for filai = 0 to f_agrega.CuentaPost - 1

univ_tdesc = f_agrega.ObtenerValorPost (filai, "univ_tdesc")

 univ_ccod=conectar.ConsultaUno("exec ObtenerSecuencia 'universidades'")
 'acre_ncorr=1000
 usu=negocio.obtenerUsuario
 
	p_insert="insert into universidades(univ_ccod,univ_tdesc,audi_tusuario,audi_fmodificacion) values("&univ_ccod&",'"&univ_tdesc&"','"&usu&"',getDate())"		  
	response.Write("<pre>"&p_insert&"</pre>")
	
	conectar.ejecutaS (p_insert)
	Respuesta = conectar.ObtenerEstadoTransaccion()

next


'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'response.End()
if Respuesta = true then
session("mensajeerror")= " La Universidad fue Guardada"
else
  session("mensajeerror")= "Error al Guardar "
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("universidad_convenio.asp")









%>


