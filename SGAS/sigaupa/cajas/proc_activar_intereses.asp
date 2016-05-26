<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x))
'next
'response.end()

rut = request.Form("pers_nrut")
digito = request.Form("pers_xdv")

set conexion = new CConexion
conexion.Inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conexion

set formulario = new CFormulario
formulario.Carga_Parametros "calcular_intereses.xml", "detalle_intereses"
formulario.Inicializar conexion

formulario.ProcesaForm	
formulario.Agregacampopost	"esin_ccod", "3"

for fila = 0 to formulario.CuentaPost - 1
	v_comp_ndocto	=	formulario.ObtenerValorPost(fila, "comp_ndocto_referencia")
	v_sint_ccod		= 	formulario.ObtenerValorPost(fila, "sint_ccod")
next


if v_comp_ndocto<>"" then

		v_monto=conexion.consultaUno("select sum(comp_mdocumento) from compromisos Where comp_ndocto="&v_comp_ndocto&" and tcom_ccod=6 and inst_ccod=1 ")

		if v_monto>"0" then
			cod_estado=1 'Activo
		else
			cod_estado=3 'Nlo
		end if

		sql_actualiza_compromiso= 	" Update compromisos set ecom_ccod="&cod_estado&""& vbCrLf &_ 
									" Where comp_ndocto="&v_comp_ndocto&" and tcom_ccod=6 and inst_ccod=1 " 

		sql_actualiza_detalle_compromiso= 	" Update detalle_compromisos set ecom_ccod="&cod_estado&" "& vbCrLf &_ 
											" Where comp_ndocto="&v_comp_ndocto&"  and tcom_ccod=6 and inst_ccod=1 and dcom_ncompromiso=1 " 

		conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_compromiso)
		conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_detalle_compromiso)
end if

formulario.MantieneTablas false
'conexion.estadoTransaccion false
'response.End()

%>
<script language="JavaScript">
   location.reload("activar_intereses.asp?busqueda[0][pers_nrut]=<%=rut%>&busqueda[0][pers_xdv]=<%=digito%>&sint_ccod=<%=v_sint_ccod%>") 
</script>
