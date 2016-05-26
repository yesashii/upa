<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

v_area_ccod			=	request.Form("area_ccod")
v_ccen_ccod			=	request.Form("busqueda[0][ccen_ccod]")
v_descripcion		=	request.Form("descripcion")
v_cantidad			=	request.Form("cantidad")
v_tipo				=	request.Form("tipo")
v_mes				=	request.Form("mes")
v_sede				= 	request.Form("sede_ccod")

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

v_anio_actual	= conexion2.ConsultaUno("select year(getdate())")
v_prox_anio	=	v_anio_actual+1

if v_area_ccod <>"" and v_ccen_ccod <>"" and v_descripcion <> "" and v_cantidad <> "" then
	
	select case (v_tipo)
	case 1:
			v_ccau_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'audiovisual'")						
			sql_ingreso_solicitud= " Insert Into presupuesto_upa.protic.centralizar_solicitud_audiovisual (mes_ccod,tpre_ccod,ccau_ncorr,ccau_tdesc,ccau_ncantidad,area_ccod,anio_ccod,esol_ccod,ccen_ccod, audi_tusuario, audi_fmodificacion) " &_
					" values ("&v_mes&","&v_tipo&","&v_ccau_ncorr&",'"&v_descripcion&"',"&v_cantidad&","&v_area_ccod&","&v_prox_anio&",1,'"&v_ccen_ccod&"','"&v_usuario&"', getdate())"
 	case 2:
			v_ccbi_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'biblioteca'")						
			sql_ingreso_solicitud= " Insert Into presupuesto_upa.protic.centralizar_solicitud_biblioteca (mes_ccod,tpre_ccod,ccbi_ncorr,ccbi_tdesc,ccbi_ncantidad,area_ccod,anio_ccod,esol_ccod,ccen_ccod,audi_tusuario, audi_fmodificacion) " &_
					" values ("&v_mes&","&v_tipo&","&v_ccbi_ncorr&",'"&v_descripcion&"',"&v_cantidad&","&v_area_ccod&","&v_prox_anio&",1,'"&v_ccen_ccod&"','"&v_usuario&"', getdate())"

	case 3:
			v_ccco_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'computacion'")						
			sql_ingreso_solicitud= " Insert Into presupuesto_upa.protic.centralizar_solicitud_computacion (mes_ccod,tpre_ccod,ccco_ncorr,ccco_tdesc,ccco_ncantidad,area_ccod,anio_ccod,esol_ccod,ccen_ccod,audi_tusuario, audi_fmodificacion) " &_
					" values ("&v_mes&","&v_tipo&","&v_ccco_ncorr&",'"&v_descripcion&"',"&v_cantidad&","&v_area_ccod&","&v_prox_anio&",1,'"&v_ccen_ccod&"','"&v_usuario&"', getdate())"

	case 4:
			v_ccsg_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'servicios_generales'")						
			sql_ingreso_solicitud= " Insert Into presupuesto_upa.protic.centralizar_solicitud_servicios_generales (sede_ccod,mes_ccod,tpre_ccod,ccsg_ncorr,ccsg_tdesc,ccsg_ncantidad,area_ccod,anio_ccod,esol_ccod,ccen_ccod,audi_tusuario, audi_fmodificacion) " &_
					" values ("&v_sede&","&v_mes&","&v_tipo&","&v_ccsg_ncorr&",'"&v_descripcion&"',"&v_cantidad&","&v_area_ccod&","&v_prox_anio&",1,'"&v_ccen_ccod&"','"&v_usuario&"', getdate())"

	case 5:
			v_ccpe_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'personal'")						
			sql_ingreso_solicitud= " Insert Into presupuesto_upa.protic.centralizar_solicitud_personal (mes_ccod,tpre_ccod,ccpe_ncorr,ccpe_tdesc,ccpe_ncantidad,area_ccod,anio_ccod,esol_ccod,ccen_ccod,audi_tusuario, audi_fmodificacion) " &_
					" values ("&v_mes&","&v_tipo&","&v_ccpe_ncorr&",'"&v_descripcion&"',"&v_cantidad&","&v_area_ccod&","&v_prox_anio&",1,'"&v_ccen_ccod&"','"&v_usuario&"', getdate())"

	end select

	v_estado_transaccion=conexion2.ejecutaS(sql_ingreso_solicitud)
	
end if

'response.Write("<pre>"&sql_ingreso_solicitud&"</pre>")
'response.End()


if v_estado_transaccion=false  then
	'response.Write("<br>Todo MAL")
	session("mensaje_error")="La solicitud no pudo ser ingresada correctamente.\nAsegurece de ingresar la informacion correcta y vuelva a intentarlo."
else	
	'response.Write("<br>Todo bien")
	session("mensaje_error")="La solicitud fue ingresada correctamente."
end if
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>