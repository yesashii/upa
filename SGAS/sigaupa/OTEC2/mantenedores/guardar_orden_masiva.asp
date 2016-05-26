<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

for each k in request.form
	response.write(k&"="&request.Form(k)&"<br>")
next



usuario = negocio.obtenerUsuario
forma_pago = request.form("b[0][fpot_ccod]")
nord_compra = request.form("b[0][nord_compra]")
rut_empresa = request.form("e[0][empr_nrut]")
rut_otic    = request.Form("o[0][empr_nrut]")
numero_alumnos = request.Form("o[0][ocot_nalumnos]")
monto_empresa = request.Form("o[0][ocot_monto_empresa]")
monto_otic = request.Form("o[0][ocot_monto_otic]")
seleccionado = request.Form("seleccionado")
dcur_ncorr = request.Form("b[0][dcur_ncorr]")
sede_ccod = request.Form("b[0][sede_ccod]")

dgso_ncorr = conectar.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&dcur_ncorr&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")

miArreglo = Split(seleccionado, "*")
tdet_ccod = miArreglo(0)
monto_descuento = miArreglo(1)

pers_ncorr_empresa = conectar.consultaUno("select empr_ncorr from empresas where cast(empr_nrut as varchar)='"&rut_empresa&"'")
pers_ncorr_otic    = conectar.consultaUno("select empr_ncorr from empresas where cast(empr_nrut as varchar)='"&rut_otic&"'")

if forma_pago = "4" then
	c_orden = " update ordenes_compras_otec  set ocot_nalumnos ="&numero_alumnos&",ocot_monto_otic="&monto_otic&",ocot_monto_empresa="&monto_empresa&",AUDI_TUSUARIO='"&usuario&"', AUDI_FMODIFICACION=getDate(), tdet_ccod="&tdet_ccod&",ddcu_mdescuento="&monto_descuento&_
			  " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'"
else
	c_orden = " update ordenes_compras_otec  set ocot_nalumnos ="&numero_alumnos&",ocot_monto_empresa="&monto_empresa&",AUDI_TUSUARIO='"&usuario&"', AUDI_FMODIFICACION=getDate(), tdet_ccod="&tdet_ccod&",ddcu_mdescuento="&monto_descuento&_
			  " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'"
end if

conectar.ejecutaS c_orden 
'response.End()

response.Redirect("postulacion_masiva_otec.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&b[0][nord_compra]="&nord_compra&"&b[0][fpot_ccod]="&forma_pago)
%>
