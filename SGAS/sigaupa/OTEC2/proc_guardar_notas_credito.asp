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
	'response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

set formulario = new CFormulario
formulario.Carga_Parametros "notacredito.xml", "f_notacredito"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1
   v_ndcr_ncorr			= formulario.ObtenerValorPost (fila, "ndcr_ncorr")
   v_ndcr_nnota_credito	= formulario.ObtenerValorPost (fila, "ndcr_nnota_credito")

   if v_ndcr_ncorr <> "" and v_ndcr_nnota_credito <> "" then
		
		formulario.AgregaCampoFilaPost fila, "encr_ccod", "2"
		
		sql_consulta_rango 	=	"Select top 1 case when  "&v_ndcr_nnota_credito&" >= rncr_ninicio and "&v_ndcr_nnota_credito&" <= rncr_nfin then 1 else 0 end as pertenece"& vbCrLf &_ 
								" from rangos_notas_credito_sedes "& vbCrLf &_ 
								" where sede_ccod="&sede_ccod&" "& vbCrLf &_ 
								" order by pertenece desc "
	
		v_pertenece_rango	=	conexion.consultaUno(sql_consulta_rango)
		v_pertenece_rango="1" 		' modificado por el constante movimiento de cajeros
		if v_pertenece_rango = "1" then
			sql_boleta_existe=	"select count(ndcr_nnota_credito) from notas_de_credito where sede_ccod="&sede_ccod&" and ndcr_nnota_credito="&v_ndcr_nnota_credito&" And ndcr_ncorr <> "&v_ndcr_ncorr&" And encr_ccod  in (2) "
			v_boleta_existe	=	conexion.consultaUno(sql_boleta_existe)
			'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion&" ->"&v_boleta_existe)

			if v_boleta_existe >="1" then
					'response.Write("<hr>entre<hr>")
					'conexion.EstadoTransaccion false
					session("mensajeError")="ERROR: El numero de nota de credito ingresado ya existe en el sistema "
					response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			end if
			
			
			sql_pers_ncorr="Select pers_ncorr from personas where pers_nrut='"&usuario&"'"
			v_pers_ncorr	=	conexion.consultaUno(sql_pers_ncorr)
			
	
			  sql_consulta_rango_cajero =	" select count(*) from rangos_notas_credito_cajeros "& vbCrLf &_
											" where ernc_ccod not in (3) "& vbCrLf &_
											" and cast(pers_ncorr as varchar) in ('"&v_pers_ncorr&"')"& vbCrLf &_
											" and "&v_ndcr_nnota_credito&" >=rncc_ninicio "& vbCrLf &_
											" and "&v_ndcr_nnota_credito&" <=rncc_nfin "

			'response.Write("<pre>"&sql_consulta_rango_cajero&"</pre>")
			'response.End()
	
			v_pertenece_rango_cajero	=	conexion.consultaUno(sql_consulta_rango_cajero)

		
			if v_pertenece_rango_cajero = "0" then
				'conexion.EstadoTransaccion false
				session("mensajeError")="ERROR: El numero de nota de credito ingresado no pertenece al rango del cajero"
				response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			end if

			
			'sql_boleta_mayor=	"select max(bole_nboleta) as mayor from boletas where sede_ccod="&sede_ccod&" and tbol_ccod="&v_tbol_ccod
			'v_boleta_mayor	=	conexion.consultaUno(sql_boleta_mayor)
			'if v_boleta_mayor > v_ndcr_nnota_credito then
			'	conexion.EstadoTransaccion false
			'	session("mensajeError")="el numero ingresado es menor a la ultima boleta ingresada"
			'end if
		else
			conexion.EstadoTransaccion false
			session("mensajeError")="ERROR: el numero de nota de credito ingresado, no esta dentro del rango permitido para su SEDE."	
			response.Redirect(Request.ServerVariables("HTTP_REFERER"))
		end if
											
   end if
next

formulario.MantieneTablas false
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Las notas de creditos selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar una o mas notas de credito.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>