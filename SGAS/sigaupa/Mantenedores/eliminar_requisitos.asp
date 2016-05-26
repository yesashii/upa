<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
estado_transaccion=true
set conectar = new CConexion
conectar.Inicializar "upacifico"



set formulario = new cformulario
formulario.carga_parametros "editar_malla.xml", "AsgReq"
formulario.inicializar conectar
formulario.procesaForm

'formulario.ListarPost

v_mall_ccod = Request.Form("mall_ccod")

'response.Write(v_mall_ccod)



for iFila = 0 to formulario.CuentaPost - 1
	if formulario.ObtenerValorPost(iFila, "mall_crequisito") <> "" then		
		v_mall_crequisito = formulario.ObtenerValorPost(iFila, "mall_crequisito")
		

		 consulta = "delete requisitos  where mall_crequisito = '"&v_mall_crequisito &"' and mall_ccod = "&v_mall_ccod&" "
		response.Write(consulta)
		estado=conectar.EjecutaS (consulta)
		'if estado=false then
		'	estado_transaccion=false
		'end if	

	end if
next
response.redirect(request.ServerVariables("HTTP_REFERER"))
%>