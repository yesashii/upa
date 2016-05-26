<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()
v_cuenta 	= request.QueryString("cuenta_cc")
viene 		= request.QueryString("viene")



set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


sql_nombre_cc="Select ccos_tdesc from centros_costo where ccos_tcodigo='"&v_cuenta&"'"
v_nombre_cc=conexion.consultaUno(sql_nombre_cc)

'response.Write("Query: "&sql_nombre_cc&"<br>aer<pre>"&v_nombre_cc&"</pre>")
'response.End()


if EsVacio(v_nombre_cc) or isnull(v_nombre_cc) then
	v_mensaje_error="Error, el centro de costo ingresado aun no ha sido creado en el sistema"

	session("mensajeerror")=v_mensaje_error
	%>
	<script language="javascript" src="../biblioteca/funciones.js"></script>
	<script language="javascript">
		self.opener.location.reload();
		window.close();
	</script>
	<%

	response.End()
end if


'########################################################### 
'########## Cheque	##########
pre_cuenta="1-10-040-30-"&v_cuenta
v_nom_cuenta="Cta. Cte. "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)

if v_existe =0 then
	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_cta_cte= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','N','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"

v_estado_transaccion=conexion.ejecutaS(sql_cta_cte)
'response.Write("<pre>"&sql_cheque&"</pre>")
end if
'############################################################



'########################################################### 
'########## Cheque	##########
pre_cuenta="1-10-050-10-"&v_cuenta
v_nom_cuenta="D.x.Cobrar "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)

if v_existe =0 then
	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_cheque= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"

v_estado_transaccion=conexion.ejecutaS(sql_cheque)
'response.Write("<pre>"&sql_cheque&"</pre>")
end if
'############################################################




'###########################################################  
'########## Letra	##########
pre_cuenta="1-10-050-20-"&v_cuenta
v_nom_cuenta="L.x.Cobrar "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)
if v_existe =0 then

	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_letra= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
v_estado_transaccion=conexion.ejecutaS(sql_letra)
'response.Write("<pre>"&sql_letra&"</pre>")
end if
'############################################################



'############################################################  
'######### Pagare TBK	########
pre_cuenta="1-10-050-40-"&v_cuenta
v_nom_cuenta="Pag.TBK. "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)
if v_existe =0 then

	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_pagare_tbk= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
v_estado_transaccion=conexion.ejecutaS(sql_pagare_tbk)
'response.Write("<pre>"&sql_pagare_tbk&"</pre>")
end if
'############################################################



'############################################################  
'########## T. Credito	##########
pre_cuenta="1-10-050-50-"&v_cuenta
v_nom_cuenta="T.Cred.TBK. "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)
if v_existe =0 then

	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_credito= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"

v_estado_transaccion=conexion.ejecutaS(sql_credito)
'response.Write("<pre>"&sql_credito&"</pre>")
end if
'############################################################




'############################################################
'########## T. Credito 3 cuotas	#########
pre_cuenta="1-10-050-60-"&v_cuenta
v_nom_cuenta="TBK.3 Ctas.P.C. "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)
if v_existe =0 then

	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_credito_3c= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
v_estado_transaccion=conexion.ejecutaS(sql_credito_3c)
'response.Write("<pre>"&sql_credito_3c&"</pre>")
end if
'############################################################




'#############################################################
'########## T. debito (Redbanc)	##########
pre_cuenta="1-10-050-70-"&v_cuenta
v_nom_cuenta="Red.Compra "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)
if v_existe =0 then

	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_debito= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
v_estado_transaccion=conexion.ejecutaS(sql_debito)
'response.Write("<pre>"&sql_debito&"</pre>")
end if
'############################################################




'###############################################################
'########## Gasto Protesto	##########
pre_cuenta="1-10-050-25-"&v_cuenta
v_nom_cuenta="G.P. Cobrar "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)
if v_existe =0 then

	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_gasto_protesto= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
v_estado_transaccion=conexion.ejecutaS(sql_gasto_protesto)
'response.Write("<pre>"&sql_gasto_protesto&"</pre>")
end if
'############################################################




'############################# 
'########## Pagare	##########
pre_cuenta="1-10-050-30-"&v_cuenta
v_nom_cuenta="P.x.Cobrar "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)
if v_existe =0 then

	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_pagare= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"

v_estado_transaccion=conexion.ejecutaS(sql_pagare)
'response.Write("<pre>"&sql_pagare&"</pre>")
end if
'############################################################ 




'############################# 
'########## Factura	##########
pre_cuenta="1-10-040-10-"&v_cuenta
v_nom_cuenta="F.x.Cobrar "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)
if v_existe =0 then

	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_factura= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"

v_estado_transaccion=conexion.ejecutaS(sql_factura)
'response.Write("<pre>"&sql_pagare&"</pre>")
end if
'############################################################ 


'#####################################
'########## Orde de Compra	##########
pre_cuenta="1-10-040-15-"&v_cuenta
v_nom_cuenta="OC.x.Cobrar "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)
if v_existe =0 then

	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_oc= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"

v_estado_transaccion=conexion.ejecutaS(sql_oc)
'response.Write("<pre>"&sql_pagare&"</pre>")
end if
'############################################################ 


'############################################################  
'######### MULTIDEBITO	########
pre_cuenta="1-10-050-80-"&v_cuenta
v_nom_cuenta="T.Mul. "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)
if v_existe =0 then

	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_multidebito= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
v_estado_transaccion=conexion.ejecutaS(sql_multidebito)
'response.Write("<pre>"&sql_multidebito&"</pre>")
end if
'############################################################



'############################################################  
'######### PAGARE UPA	########
pre_cuenta="1-10-050-35-"&v_cuenta
v_nom_cuenta="P.UPA. "&v_nombre_cc

sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
v_existe=conexion.consultaUno(sql_existe_cuenta)
if v_existe =0 then

	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_pagare_upa= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
v_estado_transaccion=conexion.ejecutaS(sql_pagare_upa)
'response.Write("<pre>"&sql_multidebito&"</pre>")
end if
'############################################################


conexion.estadoTransaccion v_estado_transaccion
'response.Write("estado_transaccion: "&conexion.ObtenerEstadoTransaccion)
'conexion.estadoTransaccion false
'response.End()




if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensajeerror")="una o mas cuentas NO fueron ingresadas.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensajeerror")="Las cuentas fueron ingresadas correctamente."
end if

'conexion.estadoTransaccion false
'response.End()

'response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	self.opener.location.reload();
	window.close();
</script>