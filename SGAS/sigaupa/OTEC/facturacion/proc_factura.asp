<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body topmargin="0" onUnload="">
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/funciones_formateo.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next


'response.Write(" Sesion: "&session("crear"))


rut				=	request.Form("f[0][empr_nrut]")
dv				=	request.Form("f[0][empr_xdv]")
giro			=	request.Form("f[0][empr_tgiro]")
razon_social	=	request.Form("f[0][empr_trazon_social]")
direccion1		=	request.Form("f[0][empr_tdireccion]")
ciud_ccod		=	request.Form("f[0][ciud_ccod]")
telefono		=	request.Form("f[0][empr_tfono]")
nro				=	request.Form("f[0][dire_tnro]")
v_fact_nfactura	=	request.Form("fact_n")
v_tfac_ccod		= 	request.Form("tfac_ccod")
v_num_alumnos		= 	request.Form("num_alumnos")


'response.Write("<hr> Momentaneamente no disponible<hr>")
'response.End()
'response.Write("Factura"&v_fact_nfactura)
'response.Flush()
if v_tfac_ccod=1 then
	v_ting_ccod=50
else
	v_ting_ccod=49
end if

empr_tnombre	=	razon_social
suma=0

set conectar	= new cconexion
conectar.inicializar	"upacifico"

set negocio		= new cnegocio
negocio.inicializa		conectar
v_periodo 	= 	negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario	=	negocio.obtenerUsuario()
v_sede		=	negocio.obtenersede


set cajero = new ccajero
cajero.inicializar conectar,v_usuario,v_sede
v_mcaj_ncorr 	= cajero.obtenercajaabierta

empr_ncorr		=	conectar.consultauno("select empr_ncorr from empresas where empr_nrut = '"& rut &"'")

set empresa		= new cformulario
empresa.inicializar		conectar
empresa.carga_parametros	"factura.xml" , "empresas"
empresa.procesaform

empresa.agregacampopost		"empr_ncorr"			, empr_ncorr

p	=	empresa.mantienetablas (false)
'_____________________________________________________________________________

'response.Write(conectar.obtenerEstadoTransaccion)
'conectar.estadoTransaccion false
'response.End()	


dia		=	conectar.consultauno("select day(getdate())")
mes		=	conectar.consultauno("select mes_tdesc from meses where mes_ccod=month(getdate())")
agno	=	conectar.consultauno("select year(getdate())")
sede	=	negocio.ObtenerNombreSede


comuna	= conectar.consultauno("select ciud_tdesc from ciudades where ciud_ccod='"& ciud_ccod &"'")
ciudad	= conectar.consultauno("select ciud_tcomuna from ciudades where ciud_ccod='"& ciud_ccod &"'")



if session("crear")=1 then
'#################################################################################
'###################	CREACION DE ABONOS POR FACTURACION	######################

v_folio_abono			= conectar.consultauno("exec ObtenerSecuencia 'ingresos_referencia'")

set formulario = new CFormulario
  formulario.Carga_Parametros "factura.xml", "detalle_pagos"
  formulario.Inicializar conectar
  formulario.ProcesaForm

  	for fila = 0 to formulario.CuentaPost - 1
		v_comp_ndocto		= formulario.ObtenerValorPost (fila, "comp_ndocto")
	   	v_tcom_ccod			= formulario.ObtenerValorPost (fila, "tcom_ccod")
	   	v_inst_ccod			= formulario.ObtenerValorPost (fila, "inst_ccod")
		v_dcom_ncompromiso	= formulario.ObtenerValorPost (fila, "dcom_ncompromiso")

		v_ingr_ncorr = conectar.consultauno("exec ObtenerSecuencia 'ingresos'")
		v_ding_nsecuencia = conectar.consultauno("exec ObtenerSecuencia 'detalle_ingresos'")

'response.Write("<br><b>Estado Conexion 0: </b> "&conectar.obtenerEstadoTransaccion)

		if v_dcom_ncompromiso <> "" then
				monto_saldo_cuota=conectar.ConsultaUno("select cast(protic.total_recepcionar_cuota("&v_tcom_ccod&","&v_inst_ccod&","&v_comp_ndocto&","&v_dcom_ncompromiso&") as varchar)")
				suma = suma + monto_saldo_cuota

				sql_inserta_ingreso=" insert into ingresos (ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mefectivo, ingr_mdocto,ingr_mtotal, "& vbcrlf &_
									"  ingr_nfolio_referencia, ting_ccod, audi_tusuario, audi_fmodificacion, inst_ccod, pers_ncorr, tmov_ccod) "& vbcrlf &_
									" values ("&v_ingr_ncorr&", "&v_mcaj_ncorr&", 1, getdate(), 0, "&monto_saldo_cuota&", "&monto_saldo_cuota&", "& vbcrlf &_
									" "&v_folio_abono&", 12, '"&v_usuario&"', getdate(),1 , "&empr_ncorr&", 1) "
'response.Write("<pre>"&sql_inserta_ingreso&"</pre>")
				conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_ingreso)				

'response.Write("<br><b>Estado Conexion 01: </b> "&conectar.obtenerEstadoTransaccion)
				sql_inserta_abono=	" insert into abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, "& vbcrlf &_
									" abon_mabono, audi_tusuario, audi_fmodificacion, pers_ncorr, peri_ccod) "& vbcrlf &_
									" values ("&v_ingr_ncorr&", "&v_tcom_ccod&", "&v_inst_ccod&", "&v_comp_ndocto&", "&v_dcom_ncompromiso&", getdate(), "& vbcrlf &_
									" "&monto_saldo_cuota&", '"&v_usuario&"', getdate(), "&empr_ncorr&", "&v_periodo&") "
'response.Write("<pre>"&sql_inserta_abono&"</pre>")
				conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_abono)				

'response.Write("<br><b>Estado Conexion 02: </b> "&conectar.obtenerEstadoTransaccion)
				sql_inserta_detalle="insert into detalle_ingresos (ting_ccod,ding_ndocto,ingr_ncorr,ding_nsecuencia,ding_ncorrelativo,ding_fdocto,"& vbcrlf &_
									" ding_mdetalle,ding_mdocto,ding_bpacta_cuota,audi_tusuario,audi_fmodificacion) "& vbcrlf &_
									" values (12,"&v_ding_nsecuencia&","&v_ingr_ncorr&","&v_ding_nsecuencia&",1,getdate(),"& vbcrlf &_
									" "&monto_saldo_cuota&","&monto_saldo_cuota&",'N','"&v_usuario&"',getdate()) "
'response.Write("<pre>"&sql_inserta_detalle&"</pre>")
				conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_detalle)	

sql_tipo_detalle = " Select c.tdet_ccod as detalle "& vbcrlf &_
					" From compromisos a, detalles b, tipos_detalle c "& vbcrlf &_
					" Where a.comp_ndocto="&v_comp_ndocto&" "& vbcrlf &_
					" and a.tcom_ccod="&v_tcom_ccod&" "& vbcrlf &_
					" and a.inst_ccod="&v_inst_ccod&"  "& vbcrlf &_
					" and a.tcom_ccod=b.tcom_ccod"& vbcrlf &_
					" and a.comp_ndocto=b.comp_ndocto"& vbcrlf &_
					" and a.inst_ccod=b.inst_ccod"& vbcrlf &_
					" and b.tdet_ccod=c.tdet_ccod"& vbcrlf &_
					" and isnull(c.tben_ccod,0) not in (1,2,3) "
					
v_tdet_ccod= conectar.ConsultaUno(sql_tipo_detalle)

		indice=indice+1
		end if	' fin si fue checkeado
	next
'################	FIN CREACION DE ABONOS POR FACTURACION	###############
'response.Write("<br>Estado 4: "&conectar.obtenerEstadoTransaccion)

if v_tdet_ccod="" or EsVacio(v_tdet_ccod) then
	v_tdet_ccod=7
end if

if v_tfac_ccod=1 then
	v_monto_neto=clng(suma*0.81)
	v_monto_iva=suma-v_monto_neto
else
	v_monto_neto=suma
	v_monto_iva=0
end if


'#############################################################################
' CREAR COMPROMISO PARA FACTURA QUE LUEGO SERA PAGADA.
'#############################################################################

	v_comp_ndocto=conectar.consultauno("exec ObtenerSecuencia 'compromisos'")
	

	
		sql_inserta_compromisos="insert into compromisos (tcom_ccod, inst_ccod, comp_ndocto, ecom_ccod, pers_ncorr, comp_fdocto, comp_ncuotas, "& vbcrlf &_
				" comp_mneto,comp_miva, comp_mdescuento, comp_mdocumento, audi_tusuario, audi_fmodificacion, sede_ccod) "& vbcrlf &_
				" Values (9, 1, "&v_comp_ndocto&", 1, "&empr_ncorr&", getdate(), 1, '"&v_monto_neto&"','"&v_monto_iva&"', 0, "&suma&", '"&v_usuario&"',getdate(), "&v_sede&" ) "
	'response.Write("<pre>"&sql_inserta_compromisos&"</pre>")	
	conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_compromisos)	
	
	'response.Write("<br><b>Estado Conexion 1: </b> "&conectar.obtenerEstadoTransaccion)
		sql_inserta_detalle_compromiso="insert into detalle_compromisos (tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, dcom_fcompromiso, "& vbcrlf &_
				" dcom_mneto, dcom_mintereses, dcom_mcompromiso, ecom_ccod, pers_ncorr, peri_ccod, audi_tusuario, audi_fmodificacion) "& vbcrlf &_
				" Values (9, 1, "&v_comp_ndocto&", 1, getdate(), '"&v_monto_neto&"', 0, "&suma&", 1, "&empr_ncorr&", "&v_periodo&", '"&v_usuario&"',getdate()) "
	'response.Write("<pre>"&sql_inserta_detalle_compromiso&"</pre>")	
		conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_detalle_compromiso)
	
	'response.Write("<br><b>Estado Conexion 2: </b> "&conectar.obtenerEstadoTransaccion)	
		sql_inserta_detalles="insert into detalles (tcom_ccod, inst_ccod, comp_ndocto, tdet_ccod, deta_ncantidad, deta_mvalor_unitario, "& vbcrlf &_
				" deta_mvalor_detalle, deta_msubtotal, audi_tusuario, audi_fmodificacion) "& vbcrlf &_
				" Values (9, 1, "&v_comp_ndocto&", "&v_tdet_ccod&", 1, "&suma&","&suma&", "&suma&", '"&v_usuario&"',getdate()) "
		conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_detalles)		
	
	'response.Write("<br><b>Estado Conexion 3: </b> "&conectar.obtenerEstadoTransaccion)
		
	'*****************************************************************
		' ********** 	Documentar el compromiso 	************	
			v_folio_ref_fac 		= 	conectar.consultauno("exec ObtenerSecuencia 'ingresos_referencia'")
			v_ingr_ncorr_fac 		= 	conectar.consultauno("exec ObtenerSecuencia 'ingresos'")
			v_ding_nsecuencia_fac 	= 	conectar.consultauno("exec ObtenerSecuencia 'detalle_ingresos'")
	
		sql_inserta_ingreso_fac=" insert into ingresos (ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mefectivo, ingr_mdocto,ingr_mtotal, "& vbcrlf &_
								"  ingr_nfolio_referencia, ting_ccod, audi_tusuario, audi_fmodificacion, inst_ccod, pers_ncorr, tmov_ccod) "& vbcrlf &_
								" values ("&v_ingr_ncorr_fac&", "&v_mcaj_ncorr&", 4, getdate(), 0, "&suma&", "&suma&", "& vbcrlf &_
								" "&v_folio_ref_fac&", 2, '"&v_usuario&"', getdate(),1 , "&empr_ncorr&", 1) "
	'response.Write("<pre>"&sql_inserta_ingreso_fac&"</pre>")
	'response.Write("<b>Estado Conexion 4: </b> "&conectar.obtenerEstadoTransaccion)
		conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_ingreso_fac)				
	
	
		sql_inserta_abono_fac=	" insert into abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, "& vbcrlf &_
							" abon_mabono, audi_tusuario, audi_fmodificacion, pers_ncorr, peri_ccod) "& vbcrlf &_
							" values ("&v_ingr_ncorr_fac&", 9, "&v_inst_ccod&", "&v_comp_ndocto&", 1, getdate(), "& vbcrlf &_
							" "&suma&", '"&v_usuario&"', getdate(), "&empr_ncorr&", "&v_periodo&") "
	'response.Write("<pre>"&sql_inserta_abono_fac&"</pre>")
	'response.Write("<b>Estado Conexion 5: </b> "&conectar.obtenerEstadoTransaccion)
		conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_abono_fac)				
	
	
		sql_inserta_detalle_fac="insert into detalle_ingresos (ting_ccod,ding_ndocto,ingr_ncorr,ding_nsecuencia,ding_ncorrelativo,ding_fdocto,"& vbcrlf &_
							" edin_ccod,ding_mdetalle,ding_mdocto,ding_bpacta_cuota,audi_tusuario,audi_fmodificacion) "& vbcrlf &_
							" values ("&v_ting_ccod&","&v_fact_nfactura&","&v_ingr_ncorr_fac&","&v_ding_nsecuencia_fac&",1,getdate(),"& vbcrlf &_
							" 1, "&suma&","&suma&",'S','"&v_usuario&"',getdate()) "
	'response.Write("<pre>"&sql_inserta_detalle_fac&"</pre>")
	'response.Write("<b>Estado Conexion 6: </b> "&conectar.obtenerEstadoTransaccion)
		conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_detalle_fac)	
	
end if

'#####################################################################
'###################	CREACION DE FACTURA		######################
'#####################################################################

if session("crear")=1 then

	
	v_fact_ncorr 	= conectar.consultauno("exec ObtenerSecuencia 'facturas'")
	
	SQL_INSERTA_FACTURA= 	" Insert into facturas (fact_ncorr,fact_nfactura,tfac_ccod,efac_ccod,fact_ffactura,pers_ncorr_alumno, "& vbcrlf &_
							"INGR_NFOLIO_REFERENCIA,FOLIO_ABONO_FACTURA, empr_ncorr,mcaj_ncorr,audi_fmodificacion,audi_tusuario, sede_ccod) " & vbcrlf &_
							" Values("&v_fact_ncorr&","&v_fact_nfactura&","&v_tfac_ccod&",1,getdate(),"&empr_ncorr&","& vbcrlf &_
							" "&v_folio_ref_fac&","&v_folio_abono&", "&empr_ncorr&","&v_mcaj_ncorr&",getdate(),"&v_usuario&","&v_sede&") "
'response.Write("<pre>"&SQL_INSERTA_FACTURA&"</pre>")

	conectar.EstadoTransaccion conectar.EjecutaS(SQL_INSERTA_FACTURA)
'response.Write("<br>Estado factura: "&conectar.obtenerEstadoTransaccion)
'########################################################################################
          	sql_rango="  select rfca_ncorr "& vbcrlf &_
						"	from rangos_facturas_cajeros a, personas b "& vbcrlf &_
						"	where a.pers_ncorr=b.pers_ncorr "& vbcrlf &_
						"		and b.pers_nrut="&v_usuario&" "& vbcrlf &_
						"		and tfac_ccod="&v_tfac_ccod&" "& vbcrlf &_
						"		and sede_ccod="&v_sede&" "& vbcrlf &_
						"		and erfa_ccod=1 "

			v_rfca_ncorr 	= conectar.consultauno(sql_rango)

          	sql_rango_fin="  select isnull(rfca_nfin,0) "& vbcrlf &_
						"	from rangos_facturas_cajeros a, personas b "& vbcrlf &_
						"	where a.pers_ncorr=b.pers_ncorr "& vbcrlf &_
						"		and b.pers_nrut="&v_usuario&" "& vbcrlf &_
						"		and tfac_ccod="&v_tfac_ccod&" "& vbcrlf &_
						"		and sede_ccod="&v_sede&" "& vbcrlf &_
						"		and erfa_ccod=1 "
			v_rfca_nfin 	= conectar.consultauno(sql_rango_fin)
'response.Write("<br>Facturaaaa: "&v_fact_nfactura)
		if EsVacio(v_rfca_nfin) or v_rfca_nfin="" then
			v_rfca_nfin=0
		end if
		if Clng(v_fact_nfactura)=Clng(v_rfca_nfin) then
			v_estado_rango=2
		else
			v_estado_rango=1
		end if


		factura_actual=v_fact_nfactura+1
        'actualiza el correlativo de la Factura y cambia estado al rango si es necesario
        sql_actualiza_factura=" update rangos_facturas_cajeros set rfca_nactual="&factura_actual&", erfa_ccod="&v_estado_rango&" where cast(rfca_ncorr as varchar)='"&v_rfca_ncorr&"'"
		conectar.EjecutaS(sql_actualiza_factura)
'response.Write("<pre>"&sql_actualiza_factura&"</pre>")		
'response.Write("<br>Estado 3: "&conectar.obtenerEstadoTransaccion)		
		if v_estado_rango=2 then
		' si llego a la ultima factura se actualiza el rango en espera como activo
					sql_update_rango_espera= " update  rangos_facturas_cajeros set  erfa_ccod=1  "& vbcrlf &_
											 " where pers_ncorr=(select top 1 pers_ncorr from personas where pers_nrut="&v_usuario&") "& vbcrlf &_
											 " and tfac_ccod="&v_tfac_ccod&"  "& vbcrlf &_
											 " and sede_ccod="&v_sede&" "& vbcrlf &_
											 " and erfa_ccod=4  " 
'response.Write("<pre>"&sql_update_rango_espera&"</pre>")		
										 
					conectar.EjecutaS(sql_update_rango_espera)
		end if
'########################################################################################
end if
'response.Write("<br>Estado 2: "&conectar.obtenerEstadoTransaccion)

	set formulario = new CFormulario
	formulario.Carga_Parametros "factura.xml", "detalle_pagos"
	formulario.Inicializar conectar
	formulario.ProcesaForm

  	for fila = 0 to formulario.CuentaPost - 1
		v_comp_ndocto		= formulario.ObtenerValorPost (fila, "comp_ndocto")
	   	v_tcom_ccod			= formulario.ObtenerValorPost (fila, "tcom_ccod")
	   	v_inst_ccod			= formulario.ObtenerValorPost (fila, "inst_ccod")
		v_dcom_ncompromiso	= formulario.ObtenerValorPost (fila, "dcom_ncompromiso")

		if v_dcom_ncompromiso <> "" then
			v_ingreso=conectar.ConsultaUno("select top 1 ingr_ncorr from abonos where tcom_ccod="&v_tcom_ccod&" and inst_ccod="&v_inst_ccod&" and comp_ndocto="&v_comp_ndocto&" and dcom_ncompromiso="&v_dcom_ncompromiso&" ")

if session("crear")=1 then
			monto_detalle=conectar.ConsultaUno("select cast(protic.total_recepcionar_cuota("&v_tcom_ccod&","&v_inst_ccod&","&v_comp_ndocto&","&v_dcom_ncompromiso&") as varchar)")
			suma = suma + monto_detalle

			sql_inserta_detalle="insert into detalle_factura (fact_ncorr,comp_ndocto,tcom_ccod,inst_ccod,dcom_ncompromiso, " & vbcrlf &_
								" dfac_mdetalle,audi_tusuario,audi_fmodificacion) "& vbcrlf &_
								" values ("&v_fact_ncorr&","&v_comp_ndocto&","&v_tcom_ccod&","&v_inst_ccod&","&v_dcom_ncompromiso&","& vbcrlf &_
								" "&monto_detalle&",'"&v_usuario&"',getdate()) "
			'response.Write("<pre>"&sql_inserta_detalle&"</pre>")
			conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_detalle)

			sql_actualiza_doc="Update detalle_ingresos set edin_ccod=6, audi_tusuario='"&v_usuario&"-paga oc', audi_fmodificacion=getdate() where cast(ingr_ncorr as varchar)='"&v_ingreso&"' " 
			'response.Write("<pre>"&sql_actualiza_doc&"</pre>")
			conectar.EstadoTransaccion conectar.EjecutaS(sql_actualiza_doc)
end if		

		end if	' fin si fue checkeado
	next
'response.Write("<br>Estado 1: "&conectar.obtenerEstadoTransaccion)

if session("crear")=1 then
	sql_actualiza_factura="update facturas set  fact_mtotal="&suma&", fact_miva="&v_monto_iva&", fact_mneto="&v_monto_neto&" where fact_ncorr="&v_fact_ncorr
	conectar.EstadoTransaccion conectar.EjecutaS(sql_actualiza_factura)
end if
'******************************************************************			

'------------------------------------------------------------------		
'response.Write("<br>Estado Final: "&conectar.obtenerEstadoTransaccion)
'conectar.EstadoTransaccion false
'response.End()

if session("crear")=1 then
	session("crear")=2
end if

%>

<script language="JavaScript" type="text/javascript">
		
	self.location.href = 'imprimir_factura.asp?factura='+<%=v_fact_nfactura%>+'&tipo_factura='+<%=v_tfac_ccod%>+'&pers_ncorr='+<%=empr_ncorr%>+'&fact_ncorr='+<%=v_fact_ncorr%>;	
		  
</script> 


</body>
</html>

