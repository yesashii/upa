<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

v_area_ccod			=	request.Form("busqueda[0][area_ccod]")
v_codcaja			=	request.Form("busqueda[0][codcaja]")
v_concepto			=	request.Form("busqueda[0][concepto]")
v_dpre_ncorr		=	request.Form("busqueda[0][detalle]")


set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

v_anio_actual	= 	conexion2.ConsultaUno("select year(getdate())")
v_cod_anio		=	v_anio_actual+1
'v_cod_anio	=	v_anio_actual ' se agrego por que el 2010 el presupuesto paso de año y deben seguir entrando al 2011


if v_codcaja <>"" then
	sql_filtro=sql_filtro & " and cod_pre='"&v_codcaja&"' "
end if

if v_concepto <>"" then
	sql_filtro=sql_filtro & " and concepto='"&v_concepto&"'"
end if

if v_dpre_ncorr <>"" then
 	txt_detalle= conexion2.ConsultaUno("select detalle_pre from presupuesto_upa.protic.codigos_presupuesto where cast(cpre_ncorr as varchar)='"&v_dpre_ncorr&"'")
	sql_filtro= sql_filtro & " and detalle='"&txt_detalle&"'"
end if


sql_presu_anterior="select cod_pre,cod_area,concepto,detalle,isnull(enero,0) as enero,isnull(febrero,0) as febrero,isnull(marzo,0) as marzo,isnull(abril,0) as abril," &_
					" isnull(mayo,0) as mayo, isnull(junio,0) as junio,isnull(julio,0) as julio,isnull(agosto,0) as agosto,isnull(septiembre,0) as septiembre," &_
					" isnull(octubre,0) as octubre,isnull(noviembre,0) as noviembre,isnull(diciembre,0) as diciembre,isnull(total,0) as total " &_
					" from presupuesto_upa.protic.presupuesto_upa_2011 where cod_anio=year(getdate()) and cod_area="&v_area_ccod&" "&sql_filtro&" "

'response.Write("<pre>"&sql_presu_anterior&"</pre>")
'response.End()


set f_presupuesto_anterior = new CFormulario
 	f_presupuesto_anterior.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
 	f_presupuesto_anterior.Inicializar conexion2
	f_presupuesto_anterior.consultar sql_presu_anterior


sql_solicitud_presu="select count(*) as cantidad from presupuesto_upa.protic.solicitud_presupuesto_upa where cod_anio="&v_cod_anio&" and cod_area="&v_area_ccod&" "&sql_filtro&" "
v_cantidad= conexion2.ConsultaUno(sql_solicitud_presu)

'response.Write("<pre>"&v_cantidad&"</pre>")
'response.End()

if v_cantidad>0 then
	sql_elimina="delete from presupuesto_upa.protic.solicitud_presupuesto_upa where cod_anio="&v_cod_anio&" and cod_area="&v_area_ccod&" "&sql_filtro&" "
	'response.Write("<pre>"&sql_elimina&"</pre>")	
	v_estado_transaccion=conexion2.ejecutaS(sql_elimina)
end if

while f_presupuesto_anterior.Siguiente
	
	v_cod_pre	=f_presupuesto_anterior.ObtenerValor("cod_pre")
	v_cod_area	=f_presupuesto_anterior.ObtenerValor("cod_area")
	v_concepto	=f_presupuesto_anterior.ObtenerValor("concepto")
	v_detalle	=f_presupuesto_anterior.ObtenerValor("detalle")
	v_enero		=f_presupuesto_anterior.ObtenerValor("enero")
	v_febrero	=f_presupuesto_anterior.ObtenerValor("febrero")
	v_marzo		=f_presupuesto_anterior.ObtenerValor("marzo")
	v_abril		=f_presupuesto_anterior.ObtenerValor("abril")
	v_mayo		=f_presupuesto_anterior.ObtenerValor("mayo")
	v_junio		=f_presupuesto_anterior.ObtenerValor("junio")
	v_julio		=f_presupuesto_anterior.ObtenerValor("julio")
	v_agosto	=f_presupuesto_anterior.ObtenerValor("agosto")
	v_septiembre=f_presupuesto_anterior.ObtenerValor("septiembre")
	v_octubre	=f_presupuesto_anterior.ObtenerValor("octubre")
	v_noviembre	=f_presupuesto_anterior.ObtenerValor("noviembre")
	v_diciembre	=f_presupuesto_anterior.ObtenerValor("diciembre")
	v_total		=f_presupuesto_anterior.ObtenerValor("total")
	
	
	v_spru_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'solicitud_presupuesto'")
	
	sql_insert= "insert into presupuesto_upa.protic.solicitud_presupuesto_upa " &_
				" (spru_ncorr,cod_anio,cod_pre,cod_area,concepto,detalle,enero,febrero,marzo,abril,mayo,junio,julio,agosto,septiembre,octubre,noviembre,diciembre,total,audi_tusuario, audi_fmodificacion) " &_
				" values " &_
				" ("&v_spru_ncorr&","&v_cod_anio&",'"&v_cod_pre&"',"&v_cod_area&",'"&v_concepto&"','"&v_detalle&"',"&v_enero&","&v_febrero&","&v_marzo&","&v_abril&", "&_
				" "&v_mayo&","&v_junio&","&v_julio&","&v_agosto&","&v_septiembre&","&v_octubre&","&v_noviembre&","&v_diciembre&","&v_total&",'"&v_usuario&"', getdate()) "	

	'response.Write("<pre>"&sql_insert&"</pre>")	
	v_estado_transaccion=conexion2.ejecutaS(sql_insert)

			
wend

'conexion2.EstadoTransaccion false
'response.End()

if v_estado_transaccion=false  then
	session("mensaje_error")="La solicitud de presupuesto para los parametros seleccionados no pudo ser ingresada.\nVuelva a intentarlo."
else	
	session("mensaje_error")="La solicitud de presupuesto para los parametros seleccionados fue ingresada correctamente."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>