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
formulario.Carga_Parametros "factura.xml", "f_facturas"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1
   v_fact_ncorr		= formulario.ObtenerValorPost (fila, "fact_ncorr")
   v_fact_nfactura	= formulario.ObtenerValorPost (fila, "fact_nfactura")
   v_tfac_ccod		= formulario.ObtenerValorPost (fila, "c_tfac_ccod")

   if v_fact_ncorr <> "" and v_fact_nfactura <> "" then
		
		formulario.AgregaCampoFilaPost fila, "efac_ccod", "2"
		
		sql_consulta_rango 	=	"Select top 1 case when  "&v_fact_nfactura&" >= rfac_ninicio and "&v_fact_nfactura&" <= rfac_nfin then 1 else 0 end as pertenece"& vbCrLf &_ 
								" from rangos_facturas_sedes "& vbCrLf &_ 
								" where sede_ccod="&sede_ccod&" "& vbCrLf &_ 
								" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_ 
								" order by pertenece desc "
	
		v_pertenece_rango	=	conexion.consultaUno(sql_consulta_rango)
		v_pertenece_rango="1" 		' modificado por el constante movimiento de cajeros
		if v_pertenece_rango = "1" then
			sql_boleta_existe=	"select count(fact_nfactura) from facturas where sede_ccod="&sede_ccod&" and fact_nfactura="&v_fact_nfactura&" and tfac_ccod="&v_tfac_ccod&" And fact_ncorr <> "&v_fact_ncorr&" And efac_ccod  in (2) "
			v_boleta_existe	=	conexion.consultaUno(sql_boleta_existe)
			'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion&" ->"&v_boleta_existe)

			if v_boleta_existe >="1" then
					'response.Write("<hr>entre<hr>")
					'conexion.EstadoTransaccion false
					session("mensajeError")="ERROR: El numero de factura ingresado ya existe en el sistema "
					response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			end if
			
			
			sql_pers_ncorr="Select pers_ncorr from personas where pers_nrut='"&usuario&"'"
			v_pers_ncorr	=	conexion.consultaUno(sql_pers_ncorr)
			
	
			  sql_consulta_rango_cajero =	" select count(*) from RANGOS_FACTURAS_CAJEROS  "& vbCrLf &_
											" where tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_
											" and erfa_ccod not in (3) "& vbCrLf &_
											" and cast(pers_ncorr as varchar) in ('"&v_pers_ncorr&"')"& vbCrLf &_
											" and "&v_fact_nfactura&" >=rfca_ninicio "& vbCrLf &_
											" and "&v_fact_nfactura&" <=rfca_nfin "

			'response.Write("<pre>"&sql_consulta_rango_cajero&"</pre>")
			'response.End()
	
			v_pertenece_rango_cajero	=	conexion.consultaUno(sql_consulta_rango_cajero)

		
			if v_pertenece_rango_cajero = "0" then
				'conexion.EstadoTransaccion false
				session("mensajeError")="ERROR: El numero de factura ingresado no pertenece al rango del cajero"
				response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			end if

			
			'sql_boleta_mayor=	"select max(bole_nboleta) as mayor from boletas where sede_ccod="&sede_ccod&" and tbol_ccod="&v_tbol_ccod
			'v_boleta_mayor	=	conexion.consultaUno(sql_boleta_mayor)
			'if v_boleta_mayor > v_fact_nfactura then
			'	conexion.EstadoTransaccion false
			'	session("mensajeError")="el numero ingresado es menor a la ultima boleta ingresada"
			'end if
		else
			conexion.EstadoTransaccion false
			session("mensajeError")="ERROR: el numero de factura ingresado, no esta dentro del rango permitido para su SEDE."	
			response.Redirect(Request.ServerVariables("HTTP_REFERER"))
		end if
'else
'	formulario.AgregaCampoFilaPost fila, "fact_ncorr", "null"											
   end if
next

formulario.MantieneTablas false
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Las Facturas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar una o mas facturas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>