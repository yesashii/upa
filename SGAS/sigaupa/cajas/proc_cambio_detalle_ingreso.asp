<!--Versión 1.0 creada por Sinezio da Silva fecha 24-04-2015 supervisionada por Michael Shaw
hay dos paginas que estan viculadas a este XML proc_modifica_folio.xml y modifica_folio.asp-->

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()


'---------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new CFormulario
formulario.Carga_Parametros "cambio_detalle_ingreso.xml", "detalle_ingreso"
formulario.ProcesaForm
rut_usuario = negocio.ObtenerUsuario
i=0

for fila=0 to formulario.CuentaPost -1
ingr_ncorr=formulario.ObtenerValorPost(fila,"ingr_ncorr")
'response.Write(ingr_ncorr)
if ingr_ncorr <> "" then 
'response.Write(ingr_ncorr&"<br>")
sql_ingr_ncorr="update DETALLE_INGRESOS set EDIN_CCOD=1, AUDI_TUSUARIO='"&rut_usuario&"', AUDI_FMODIFICACION=getdate()  WHERE  INGR_NCORR in("&ingr_ncorr&")"
conectar.EstadoTransaccion conectar.EjecutaS(sql_ingr_ncorr)
i=i+1
end if
'response.Write(fila&"<br>")
next
'response.End()
if i = "0" then
session("mensaje_error") = "Seleccione documento."
else
session("mensaje_error") = "Se Realizo el Cambio con Exito"
end if 



response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
