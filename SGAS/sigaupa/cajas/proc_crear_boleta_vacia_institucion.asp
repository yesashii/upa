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


v_num_caja 		= request.Form("busqueda[0][mcaj_ncorr]")
v_tipo_boleta 	= request.Form("busqueda[0][tbol_ccod]")
v_inst_ccod 	= request.Form("busqueda[0][inst_ccod]")
'response.Write("inst_ccod: "&v_inst_ccod)
'response.End()
' si la boleta es afecta se asocia a la universidad

if v_inst_ccod <>"" and v_tipo_boleta <> "" then

	set formulario = new CFormulario
	formulario.Carga_Parametros "boletas_venta.xml", "f_boletas"
	formulario.Inicializar conexion
	formulario.ProcesaForm		

			
  	v_nuevo_bole_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'boletas'")  
		

	'********************************************************************************************			
	'  Obtiene el numero actual de la boleta

        sql_actual="select isnull(rbca_nactual,rbca_ninicio) as actual from rangos_boletas_cajeros "& vbCrLf &_ 
							" where pers_ncorr=(select top 1 pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"') "& vbCrLf &_ 
							" and tbol_ccod="&v_tipo_boleta&" "& vbCrLf &_ 
							" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
							" and erbo_ccod=1 "		
		
		'response.Write("<pre>"&sql_actual&"</pre>")
		v_numero_actual = conexion.ConsultaUno(sql_actual)
		

		
	'********************************************************************************************			
	'  Inserta nuevo registro para una boleta Vacia

		sql_inserta_boleta= "Insert into boletas  "& vbCrLf &_ 
		"select  "&v_nuevo_bole_ncorr&" as bole_ncorr,"&v_numero_actual&" as bole_nboleta,4 as ebol_ccod,"&v_tipo_boleta&" as tbol_ccod,null as bole_mtotal, getdate() as bole_fboleta, "& vbCrLf &_ 
		" null as ingr_nfolio_referencia,"&sede_ccod&" as sede_ccod, null as pers_ncorr, null as pers_ncorr_aval,"&v_num_caja&" as mcaj_ncorr,"& vbCrLf &_ 
		" "&usuario&" as audi_tusuario,getdate() as audi_fmodificacion, "&inst_ccod&" "
		
		'response.Write("<pre>"&sql_inserta_boleta&"</pre>")
		conexion.EjecutaS(sql_inserta_boleta)
		


	'********************************************************************************************
	' Actualiza el numero de boleta

			v_numero_actual=Clng(v_numero_actual) + 1
			sql_actualiza_numero=" Update rangos_boletas_cajeros set rbca_nactual="&v_numero_actual&"  "& vbCrLf &_ 
									" where pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut='"&usuario&"') "& vbCrLf &_ 
									" and tbol_ccod="&v_tipo_boleta&" "& vbCrLf &_ 
									" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
									" and erbo_ccod=1"
			
			'response.Write("<pre>"&sql_actualiza_numero&"</pre>")											
			conexion.EjecutaS(sql_actualiza_numero)
			
	'********************************************************************************************

				
	'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
	'conexion.EstadoTransaccion false
	'Response.End()
else
	conexion.EstadoTransaccion false
end if

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Las Boletas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar una o mas boletas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>