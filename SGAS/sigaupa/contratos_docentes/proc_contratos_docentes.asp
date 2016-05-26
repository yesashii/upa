<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
Server.ScriptTimeout = 42000
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

cont=0

set formulario = new CFormulario
formulario.Carga_Parametros "contratos_docentes.xml", "generar_contratos"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_persona 	= formulario.ObtenerValorPost (fila, "pers_ncorr")
   v_sede 		= formulario.ObtenerValorPost (fila, "sede_ccod")
   v_carrera 	= formulario.ObtenerValorPost (fila, "carr_ccod")
   v_jornada 	= formulario.ObtenerValorPost (fila, "jorn_ccod")
   v_calcular 	= formulario.ObtenerValorPost (fila, "calcular")
   v_tipo_cont 	= formulario.ObtenerValorPost (fila, "tipo_contrato")
   v_tcdo_ccod 	= formulario.ObtenerValorPost (fila, "tcdo_ccod")

	if v_tipo_cont="" then
		v_tipo_cont=v_tcdo_ccod
	end if

   if v_persona <> "" and v_calcular > 0 then
   		sql_genera="Exec GENERA_CONTRATO_DOCENTE  "&v_persona&", "&v_sede&" ,'"&v_carrera&"', "&v_jornada&","&v_tipo_cont&", '"&usuario&"' "
		'response.Write("<hr>"&sql_genera&"<hr>")
		'response.End()
		v_salida= conexion.ConsultaUno(sql_genera)
		if v_salida="2" then
			v_nombre=conexion.consultaUno("select protic.obtener_nombre("&v_persona&",'an')")
			msg_error=msg_error + "\n-Contrato para "&v_nombre&" que no genero anexos"
		end if
		cont=cont+1	
   end if
next

if conexion.ObtenerEstadoTransaccion  then
	if cont = 0 then
		session("mensajeError")="No se realizo ningun calculo"
	else
		if msg_error <> "" then
			msg_error="\nExcepto :"&msg_error&"\nRevise la integridad de los datos personales, si corresponde la escuela seleccionada, \nsi tiene asociado una categoria para el tipo de bloque, etc... "
		end if
		session("mensajeError")="Los Contratos para los docentes seleccionados fueron creados correctamente."&msg_error
	end if
else
	session("mensajeError")="Ocurrio un error al intentar crear uno o mas contratos para los docentes.\nAsegurece de haber ingresado los datos necesarios y vuelva a intentarlo."
end if
'response.End()
'conexion.estadotransaccion false
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>