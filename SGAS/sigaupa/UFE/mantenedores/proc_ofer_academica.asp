<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()

sede_ccod=request.Form("em[0][sede_ccod]")
jorn_ccod=request.Form("em[0][jorn_ccod]")
car_ing_ncorr=request.Form("em[0][car_ing_ncorr]")
ofai_ncorr=request.Form("em[0][ofai_ncorr]")
anos_ccod=request.Form("em[0][anos_ccod]")
ttie_ccod=request.Form("em[0][ttie_ccod]")

set conexion = new CConexion
conexion.Inicializar "upacifico"

sql="select case when count(*)>0 then 'S' end as existe from  ufe_oferta_academica_ing where sede_ccod="&sede_ccod&   vbCrlf & _
	" and jorn_ccod= "&jorn_ccod&   vbCrlf & _
	" and car_ing_ncorr="&car_ing_ncorr&   vbCrlf & _
	" and ttie_ccod="&ttie_ccod&   vbCrlf & _
	" and anos_ccod="&anos_ccod&   vbCrlf & _
	" group by ofai_ncorr"
existe= conexion.ConsultaUno(sql)

if existe="S" and ofai_ncorr="" then
session("mensaje_error")="La oferta ya esta Creada."
response.Redirect(request.ServerVariables("HTTP_REFERER"))
end if


set f_mantiene_ofer = new CFormulario
f_mantiene_ofer.Carga_Parametros "adm_ofer_academica.xml", "mantiene_ofer_academica"
f_mantiene_ofer.Inicializar conexion
f_mantiene_ofer.ProcesaForm


for filai = 0 to f_mantiene_ofer.CuentaPost - 1
	
	ofai_ncorr=f_mantiene_ofer.ObtenerValorPost (filai, "ofai_ncorr")
	if ofai_ncorr="" then
		ofai_ncorr= conexion.ConsultaUno("execute obtenersecuencia 'ufe_oferta_academica_ing'")
		f_mantiene_ofer.agregacampopost "ofai_ncorr",ofai_ncorr
	end if
	'v_estado_transaccion=conexion.ejecutaS(sql_carrera)
	'response.Write("<b>estado:</b>"&conexion.obtenerEstadoTransaccion)
next


v_estado_transaccion=f_mantiene_ofer.MantieneTablas (false)


if v_estado_transaccion=false  then
	session("mensaje_error")="La carrera no pudo ser ingresada correctamente.\nVuelva a intentarlo."
else	
	session("mensaje_error")="La carrera fue ingresada correctamente."
end if

'conexion.estadoTransaccion false
'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	//self.opener.location.reload();
	//window.close();
</script>
