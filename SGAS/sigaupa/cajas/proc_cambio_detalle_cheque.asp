<!--Versión 1.0 creada por Sinezio da Silva fecha 24-04-2015 supervisionada por Michael Shaw
hay dos paginas que estan viculadas a este XML cambio_detalle_cheque.xml y cambio_detalles_cheques.asp-->

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next

'---------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new CFormulario
formulario.Carga_Parametros "cambio_detalle_cheque.xml", "detalle_ingreso"
formulario.ProcesaForm
rut_usuario = negocio.ObtenerUsuario
i=0
print_r formulario, 0
for fila=0 to formulario.CuentaPost -1

ingr_ncorr=formulario.ObtenerValorPost(fila,"ingr_ncorr2")
tcom_ccod=formulario.ObtenerValorPost(fila,"tcom_ccod2")
comp_ndocto=formulario.ObtenerValorPost(fila,"comp_ndocto2")
dcom_ncompromiso=formulario.ObtenerValorPost(fila,"dcom_ncompromiso2")
dcom_mcompromiso=formulario.ObtenerValorPost(fila,"dcom_mcompromiso2")
monto_cambio=formulario.ObtenerValorPost(fila,"monto_cambio")


if ingr_ncorr <> "" and  tcom_ccod<> "" and comp_ndocto<> "" and dcom_ncompromiso<> "" and COMP_NDOCTO<> "" and dcom_mcompromiso<> "" and monto_cambio<> "" then

sql1="update DETALLE_INGRESOS set DING_MDETALLE='"&monto_cambio&"' , 					DING_MDOCTO='"&monto_cambio&"', AUDI_TUSUARIO='"&rut_usuario&"', AUDI_FMODIFICACION=getdate()  WHERE  INGR_NCORR in("&ingr_ncorr&")"

sql2="update INGRESOS set INGR_MDOCTO='"&monto_cambio&"' , INGR_MTOTAL='"&monto_cambio&"', AUDI_TUSUARIO='"&rut_usuario&"', AUDI_FMODIFICACION=getdate()  WHERE  INGR_NCORR in("&ingr_ncorr&")"

sql3="update ABONOS set ABON_MABONO='"&monto_cambio&"' ,AUDI_TUSUARIO='"&rut_usuario&"', AUDI_FMODIFICACION=getdate()  WHERE  INGR_NCORR in("&ingr_ncorr&") and TCOM_CCOD in("&tcom_ccod&") and COMP_NDOCTO in("&comp_ndocto&") and DCOM_NCOMPROMISO in ("&dcom_ncompromiso&")"

sql4="update DETALLE_COMPROMISOS set DCOM_MNETO='"&monto_cambio&"' ,DCOM_MCOMPROMISO='"&monto_cambio&"',AUDI_TUSUARIO='"&rut_usuario&"', AUDI_FMODIFICACION=getdate()  WHERE   TCOM_CCOD in("&tcom_ccod&") and COMP_NDOCTO in("&comp_ndocto&") and DCOM_NCOMPROMISO in ("&dcom_ncompromiso&")"


conectar.EstadoTransaccion conectar.EjecutaS(sql1)
conectar.EstadoTransaccion conectar.EjecutaS(sql2)
conectar.EstadoTransaccion conectar.EjecutaS(sql3)
conectar.EstadoTransaccion conectar.EjecutaS(sql4)

end if

response.Write(sql1&"<br><br>")
response.Write(sql2&"<br><br>")
response.Write(sql3&"<br><br>")
response.Write(sql4&"<br><br>")

next

session("mensaje_error") = "Se Realizo el Cambio con Exito"




response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
