<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

sede_ccod= negocio.obtenerSede

usuario = negocio.ObtenerUsuario()

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

set formulario = new CFormulario
formulario.Carga_Parametros "boletas_venta.xml", "f_boletas"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1
   v_bole_ncorr		= formulario.ObtenerValorPost (fila, "bole_ncorr")
   v_bole_nboleta	= formulario.ObtenerValorPost (fila, "bole_nboleta")
   v_tbol_ccod		= formulario.ObtenerValorPost (fila, "c_tbol_ccod")

   if v_bole_ncorr <> "" and v_bole_nboleta <> "" then
		
		formulario.AgregaCampoFilaPost fila, "ebol_ccod", "2"
		
		sql_consulta_rango 	=	"Select top 1 case when  "&v_bole_nboleta&" >= rbol_ninicio and "&v_bole_nboleta&" <= rbol_nfin then 1 else 0 end as pertenece"& vbCrLf &_ 
								" from rangos_boletas_sedes "& vbCrLf &_ 
								" where sede_ccod="&sede_ccod&" "& vbCrLf &_ 
								" and tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_ 
								" order by pertenece desc "
	
		v_pertenece_rango	=	conexion.consultaUno(sql_consulta_rango)
v_pertenece_rango="1" 		' modificado por el constante movimiento de cajeros
		if v_pertenece_rango = "1" then
			sql_boleta_existe=	"select count(bole_nboleta) from boletas where sede_ccod="&sede_ccod&" and bole_nboleta="&v_bole_nboleta&" and tbol_ccod="&v_tbol_ccod&" And bole_ncorr <> "&v_bole_ncorr&" And ebol_ccod  in (2) "
			v_boleta_existe	=	conexion.consultaUno(sql_boleta_existe)
			'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion&" ->"&v_boleta_existe)

			if v_boleta_existe >="1" then
					'response.Write("<hr>entre<hr>")
					'conexion.EstadoTransaccion false
					session("mensajeError")="ERROR: El numero de boleta ingresado ya existe en el sistema "
					response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			end if
			
			
			sql_pers_ncorr="Select pers_ncorr from personas where pers_nrut='"&usuario&"'"
			v_pers_ncorr	=	conexion.consultaUno(sql_pers_ncorr)
			
	
			  sql_consulta_rango_cajero =	" select count(*) from RANGOS_BOLETAS_CAJEROS  "& vbCrLf &_
											" where tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_
											" and erbo_ccod not in (3) "& vbCrLf &_
											" and cast(pers_ncorr as varchar) in ('"&v_pers_ncorr&"')"& vbCrLf &_
											" and "&v_bole_nboleta&" >=rbca_ninicio "& vbCrLf &_
											" and "&v_bole_nboleta&" <=rbca_nfin "

			'response.Write("<pre>"&sql_consulta_rango_cajero&"</pre>")
			'response.End()
	
			v_pertenece_rango_cajero	=	conexion.consultaUno(sql_consulta_rango_cajero)

		
			if v_pertenece_rango_cajero = "0" then
				'conexion.EstadoTransaccion false
				'session("mensajeError")="ERROR: El numero de boleta ingresado no pertenece al rango del cajero"
				'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			end if

			
			'sql_boleta_mayor=	"select max(bole_nboleta) as mayor from boletas where sede_ccod="&sede_ccod&" and tbol_ccod="&v_tbol_ccod
			'v_boleta_mayor	=	conexion.consultaUno(sql_boleta_mayor)
			'if v_boleta_mayor > v_bole_nboleta then
			'	conexion.EstadoTransaccion false
			'	session("mensajeError")="el numero ingresado es menor a la ultima boleta ingresada"
			'end if
		else
			conexion.EstadoTransaccion false
			session("mensajeError")="ERROR: el numero de boleta ingresado, no esta dentro del rango permitido para su SEDE."	
			response.Redirect(Request.ServerVariables("HTTP_REFERER"))
		end if
											
   end if
next

formulario.MantieneTablas false
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Las Boletas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar una o mas boletas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>