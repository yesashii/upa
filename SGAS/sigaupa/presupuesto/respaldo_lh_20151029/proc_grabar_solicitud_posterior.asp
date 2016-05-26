<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

v_area_ccod			=	request.Form("area_ccod")
v_codcaja			=	request.Form("codcaja")
v_dpre_ncorr		=	request.Form("detalle")


set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

  set formulario = new CFormulario
  formulario.Carga_Parametros "solicitud_presupuestaria.xml", "solicitud"
  formulario.Inicializar conexion2
  formulario.ProcesaForm

v_anio_actual	= 	conexion2.ConsultaUno("select year(getdate())")
'v_anio_actual	=	v_anio_actual-1 ' se agrego por que el 2010 el presupuesto paso de año


if v_codcaja <>"" then
	sql_filtro=sql_filtro & " and cod_pre='"&v_codcaja&"' "
end if

if v_dpre_ncorr <>"" then
	txt_detalle	= conexion2.ConsultaUno("select detalle_pre from presupuesto_upa.protic.codigos_presupuesto where cast(cpre_ncorr as varchar)='"&v_dpre_ncorr&"'")
	sql_filtro	= sql_filtro & " and detalle='"&txt_detalle&"'"
end if

sql_solicitud_presu="select count(*) as cantidad from presupuesto_upa.protic.solicitud_presupuesto_upa where cod_anio="&v_anio_actual&" and cod_area="&v_area_ccod&" "&sql_filtro&" "
v_cantidad	= conexion2.ConsultaUno(sql_solicitud_presu)
		
if v_codcaja <>"" and v_area_ccod <>"" and v_dpre_ncorr<>"" then
'response.Write("<pre> Todos los parametros ok...</pre>")	
	'##################################################################
	'###############SI EXISTIAN REGISTROS SE BORRAN####################
	if v_cantidad>0 then
		sql_elimina="delete from presupuesto_upa.protic.solicitud_presupuesto_upa where cod_anio="&v_anio_actual&" and cod_area="&v_area_ccod&" "&sql_filtro&" "
		v_estado_transaccion=conexion2.ejecutaS(sql_elimina)
		'response.Write("<pre> ELIMINANDO...</pre>")	
	end if	
		
	'###############################################################
	'###############	SE RECORREN LOS MESES	####################
	v_total=0
	for fila = 0 to formulario.CuentaPost - 1
		v_solicitado= 	formulario.ObtenerValorPost (fila, "solicitado")
		v_total		=	v_total+v_solicitado
	
		Select Case (fila)
		   Case 0:v_enero	=v_solicitado
		   Case 1:v_febrero	=v_solicitado
		   Case 2:v_marzo	=v_solicitado
		   Case 3:v_abril	=v_solicitado
		   Case 4:v_mayo	=v_solicitado
		   Case 5:v_junio	=v_solicitado
		   Case 6:v_julio	=v_solicitado
		   Case 7:v_agosto	=v_solicitado
		   Case 8:v_septiembre	=v_solicitado
		   Case 9:v_octubre		=v_solicitado
		   Case 10:v_noviembre	=v_solicitado
		   Case 11:v_diciembre	=v_solicitado
		end select 
	next
	
	'###############################################################
	'###############	INSERTA NUEVO REGISTRO	####################
		
		v_concepto=conexion2.ConsultaUno("select top 1 concepto_pre from presupuesto_upa.protic.codigos_presupuesto where cod_pre='"&v_codcaja&"' and cod_area="&v_area_ccod&" ")
		v_area_tdesc=conexion2.ConsultaUno("select top 1 area_tdesc from presupuesto_upa.protic.area_presupuestal where area_ccod="&v_area_ccod&" ")

		v_existe= conexion2.ConsultaUno("Select count(*) from presupuesto_upa.protic.presupuesto_upa_2013 where concepto='"&v_concepto&"' and cod_pre='"&v_codcaja&"' and cod_area="&v_area_ccod&"  and detalle='"&txt_detalle&"' and cod_anio=2010")

'response.Write("Select count(*) from presupuesto_upa.protic.presupuesto_upa_2010 where concepto='"&v_concepto&"' and cod_pre='"&v_codcaja&"' and cod_area="&v_area_ccod&"  and detalle='"&txt_detalle&"' and cod_anio=2010")

		if v_existe>0 then
		
			sql_insert= " update presupuesto_upa.protic.presupuesto_upa_2013 " &_
						 "	set enero='"&v_enero&"',febrero='"&v_febrero&"',marzo='"&v_marzo&"',abril='"&v_abril&"' " &_
						 "	,mayo='"&v_mayo&"',junio='"&v_junio&"',julio='"&v_julio&"', agosto='"&v_agosto&"' " &_
						 "	,septiembre='"&v_septiembre&"',octubre='"&v_octubre&"',noviembre='"&v_noviembre&"',diciembre='"&v_diciembre&"' " &_
						 "  ,enero_prox=0, febrero_prox=0, total='"&v_total&"' " &_
						 " where concepto='"&v_concepto&"' and cod_pre='"&v_codcaja&"' and detalle='"&txt_detalle&"' and cod_anio=2010 and cod_area="&v_area_ccod&" " 
		else
		
			sql_insert= "insert into presupuesto_upa.protic.presupuesto_upa_2013 " &_
						" (cod_anio,cod_pre,cod_area,descripcion_area,concepto,detalle,enero,febrero,marzo,abril,mayo,junio,julio,agosto,septiembre,octubre,noviembre,diciembre,total) " &_
						" values " &_
						" ("&v_anio_actual&",'"&v_codcaja&"',"&v_area_ccod&",'"&v_area_tdesc&"','"&v_concepto&"','"&txt_detalle&"',"&v_enero&","&v_febrero&","&v_marzo&","&v_abril&", "&_
						" "&v_mayo&","&v_junio&","&v_julio&","&v_agosto&","&v_septiembre&","&v_octubre&","&v_noviembre&","&v_diciembre&","&v_total&") "	
		

		end if
		'response.Write("<pre>"&sql_insert&"</pre>")		
		v_estado_transaccion=conexion2.ejecutaS(sql_insert)
end if

'response.End()
if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="No fue posible grabar los datos ingresados para su solicitud.\n Asegúrese de completar correctamente la información y vuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="La solicitud para los parametros seleccionados fue grabada exitosamente"
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>