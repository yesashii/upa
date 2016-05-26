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
'response.End()


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
v_num_alumnos	= 	request.Form("num_alumnos")
v_limite_fac	=	15

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
			compromiso_oc=v_comp_ndocto
		indice=indice+1
		end if	' fin si fue checkeado
	next
'################	FIN CREACION DE ABONOS POR FACTURACION	###############
'response.Write("<br>Estado 4: "&conectar.obtenerEstadoTransaccion)

if v_tdet_ccod="" or EsVacio(v_tdet_ccod) then
	v_tdet_ccod=7
end if

sql_cambio_anio=	"select (year(dgso_ftermino)- year(dgso_finicio)) as diferencia "& vbcrlf &_
					" from diplomados_cursos a, datos_generales_secciones_otec b "& vbcrlf &_
					" where a.dcur_ncorr=b.dcur_ncorr "& vbcrlf &_
					" and tdet_ccod="&v_tdet_ccod

v_cambio_anio = conectar.consultaUno(sql_cambio_anio) 
'#############################################################################
' CREAR COMPROMISO PARA FACTURA QUE LUEGO SERA PAGADA.
'#############################################################################


fin_division=	v_num_alumnos \ v_limite_fac
resto		= 	v_num_alumnos mod v_limite_fac
if resto=0 then
	fin_division=fin_division-1
end if

v_monto_alumno=clng(suma/v_num_alumnos)  '#### Monto correspondiente a cada alumno

'v_cambio_anio=1 ' Se dividen las facturas
if v_cambio_anio=1 then
	sql_tramos_curso =	"select protic.trunc(dgso_finicio) as f_inicio, protic.trunc(dgso_ftermino) as f_fin, "& vbcrlf &_
						" (year(dgso_ftermino)- year(dgso_finicio)) as diferencia, datediff(day,dgso_finicio,dgso_ftermino) as total_dias, "& vbcrlf &_
						" datediff(day,dgso_finicio,'31-12-'+cast(year(dgso_finicio) as varchar)) as primer_tramo, "& vbcrlf &_
						" datediff(day,'31-12-'+cast(year(dgso_finicio) as varchar),dgso_ftermino) as segundo_tramo "& vbcrlf &_
						" from diplomados_cursos a, datos_generales_secciones_otec b "& vbcrlf &_
						" where a.dcur_ncorr=b.dcur_ncorr "& vbcrlf &_
						" and tdet_ccod="&v_tdet_ccod

	set tramos_curso	=	new cformulario
	tramos_curso.inicializar		conectar
	tramos_curso.carga_parametros	"tabla_vacia.xml", "tabla"
	tramos_curso.consultar			sql_tramos_curso
	tramos_curso.siguiente
	
	v_primer_tramo	=	tramos_curso.ObtenerValor("primer_tramo")
	v_segundo_tramo	=	tramos_curso.ObtenerValor("segundo_tramo")
	v_total_dias	=	tramos_curso.ObtenerValor("total_dias")
	v_f_inicio		=	tramos_curso.ObtenerValor("f_inicio")
	v_f_fin			=	tramos_curso.ObtenerValor("f_fin")

							
	fin_division=1 ' aca aunmentar para uno o mas años
	suma_total=suma	
	vdario = suma_total \ v_total_dias

end if
'response.Write("<pre>"&sql_tramos_curso&"</pre><br>")
'response.Write("<b>Primer Tramo: </b>"&v_primer_tramo&" <br><b>Segundo Tramo: </b>"&v_segundo_tramo&"<br><b>Total: </b>"&v_total_dias)
'response.Write("<hr>Suma total ---> "&suma_total)


'#### for generara tantas facturas como divisiones existan (casos de ordenes de compra con muchos alumnos)
for ind = 0 to fin_division

	if v_cambio_anio=1 then '### para cuando es cambio de año (UN CURSO PASA DE UN AÑO PARA OTRO)
		
		if v_tfac_ccod=1 then
			if ind=0 then
				'bruto_ocupado	= clng(suma_total\2) valor al dividir en 2 cuotas iguales
				bruto_ocupado	= clng(vdario * v_primer_tramo)
				v_monto_neto	= clng(bruto_ocupado*0.81)   
				v_monto_iva 	= clng(bruto_ocupado-v_monto_neto)
			else
				saldo_bruto=clng(suma_total-bruto_ocupado)
				v_monto_neto=clng(saldo_bruto*0.81) 
				v_monto_iva =clng(saldo_bruto-v_monto_neto)
			end if
		else ' EXENTAS
			if ind=0 then
				'v_monto_neto=clng(suma_total\2)  valor al dividir en 2 cuotas iguales
				v_monto_neto=clng(vdario * v_primer_tramo)     
				v_monto_iva =0
				ocupado_neto=v_monto_neto
			else
				v_monto_neto=clng(suma_total-ocupado_neto)
				v_monto_iva =0
			end if
			
		end if	

	else ' ### para facturas con mas de 15 alumnos (ACA SE DEBE VERIFICAR QUE SI CAMBIA DE AÑO Y ADEMAS TIENE MAS DE 15 ALUMNOS)
	
		if v_num_alumnos>v_limite_fac and fin_division>0 then
			'response.Write(ind&"<<<"&fin_division)
			suma_alumnos=suma_alumnos+v_limite_fac
				divi=ind-1
				if divi=0 then
					divi=1
				else
					divi=ind-1
				end if	
	'#### segun tipos de facuras se calculan los montos			
			if v_tfac_ccod=1 then
				if ind=fin_division then
					restantes=v_num_alumnos-(v_limite_fac* ind ) '#### los alumnos que sobran de dividir las facturas
					v_monto_neto=clng((v_monto_alumno*restantes)*0.81)
					v_monto_iva=clng((v_monto_alumno*restantes)-v_monto_neto)
				else
					v_monto_neto=clng((v_monto_alumno*v_limite_fac)*0.81)
					v_monto_iva=clng((v_monto_alumno*v_limite_fac)-v_monto_neto)
				end if
			else ' EXENTAS
			
				if ind=fin_division then
					restantes=v_num_alumnos-(v_limite_fac*ind) '#### los alumnos que sobran de dividir las facturas
					v_monto_neto=v_monto_alumno*restantes
					v_monto_iva=0
				'response.Write("restantes "&restantes)				
				else
					v_monto_neto=v_monto_alumno*v_limite_fac
					v_monto_iva=0
				end if
	
			end if	
		else
			if v_tfac_ccod=1 then
				v_monto_neto=clng(suma*0.81)
				v_monto_iva=suma-v_monto_neto
			else
				v_monto_neto=suma
				v_monto_iva=0
			end if	
		end if

	end if ' Fin if tipos divisiones (por cambio de año o por cantidad de alumnos)
'response.Write("<hr>")				
'response.Write("<b>Suma:</b> "&suma_total&"<br>")			
'response.Write("<b>Factura N°"&ind&" Valor Neto:</b> "&v_monto_neto)
'response.Write("<br><b>Factura N°"&ind&" Valor Iva:</b> "&v_monto_iva)
'conectar.EstadoTransaccion false


		v_comp_ndocto=conectar.consultauno("exec ObtenerSecuencia 'compromisos'")
		
		'*****************************************************************
		' ********** 	CREAR EL COMPROMISO DE LA FACTURA 	**************
		suma=clng(v_monto_neto)+clng(v_monto_iva)	
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
		'response.Write("<pre>"&sql_inserta_detalles&"</pre>")
		'response.Write("<br><b>Estado Conexion 3: </b> "&conectar.obtenerEstadoTransaccion)
			
		'*******************************************************************
		' ********** 	DOCUMENTAR EL COMPROMISO CON FACTURAS 	************	
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
		

	
	'#####################################################################
	'###################	CREACION DE FACTURA		######################
	'#####################################################################
	
		
		v_fact_ncorr 	= conectar.consultauno("exec ObtenerSecuencia 'facturas'")
		
		SQL_INSERTA_FACTURA= 	" Insert into facturas (fact_ncorr,fact_nfactura,tfac_ccod,efac_ccod,fact_ffactura,pers_ncorr_alumno, "& vbcrlf &_
								"INGR_NFOLIO_REFERENCIA,FOLIO_ABONO_FACTURA, empr_ncorr,mcaj_ncorr,audi_fmodificacion,audi_tusuario, sede_ccod) " & vbcrlf &_
								" Values("&v_fact_ncorr&","&v_fact_nfactura&","&v_tfac_ccod&",1,getdate(),"&empr_ncorr&","& vbcrlf &_
								" "&v_folio_ref_fac&","&v_folio_abono&", "&empr_ncorr&","&v_mcaj_ncorr&",getdate(),"&v_usuario&","&v_sede&") "
		'response.Write("<pre>"&SQL_INSERTA_FACTURA&"</pre>")
		'response.Write("<br>Estado factura: "&conectar.obtenerEstadoTransaccion)
		conectar.EstadoTransaccion conectar.EjecutaS(SQL_INSERTA_FACTURA)

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
	
	
			end if	' fin si fue checkeado
		next
	'response.Write("<br>Estado antes de dividir: "&conectar.obtenerEstadoTransaccion)
	

		sql_actualiza_factura="update facturas set  fact_mtotal="&suma&", fact_miva="&v_monto_iva&", fact_mneto="&v_monto_neto&" where fact_ncorr="&v_fact_ncorr
		conectar.EstadoTransaccion conectar.EjecutaS(sql_actualiza_factura)
		'response.Write("<br><pre>"&sql_actualiza_factura&"</pre>")
	'******************************************************************			
set f_listado_alumnos	= new cformulario
f_listado_alumnos.Carga_Parametros "consulta.xml", "consulta"
	
	sql_alumnos =" select c.pote_ncorr,c.comp_ndocto, "& vbCrLf &_
				" protic.obtener_rut(a.pers_ncorr)as rut "& vbCrLf &_
				" from postulacion_otec a, personas b,postulantes_cargos_otec c "& vbCrLf &_
				" where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
				" and a.pote_ncorr=c.pote_ncorr "& vbCrLf &_
				" and c.comp_ndocto="&compromiso_oc
				
'response.Write("<pre>"&sql_alumnos&"</pre>")
			
f_listado_alumnos.inicializar conectar
f_listado_alumnos.consultar sql_alumnos
v_nro_alumnos = f_listado_alumnos.nroFilas		
'response.Write("<br>antes del listado alumnos: "&conectar.obtenerEstadoTransaccion)
if v_nro_alumnos > 0 then

	if ind=0 then
		inicio=0
		tope = v_limite_fac-1
	else
		inicio	=	inicio+v_limite_fac
		if ind=fin_division then
			tope	=	f_listado_alumnos.nroFilas-1
		else
			tope 	= 	(inicio+v_limite_fac)-1
		end if
	end if

	for k=0 to f_listado_alumnos.nroFilas-1
		f_listado_alumnos.siguiente
		
		if v_cambio_anio=1 then ' si hay que dividir por cambio de año
				pote_ncorr	= 	f_listado_alumnos.obtenerValor("pote_ncorr")
				comp_ndocto	= 	f_listado_alumnos.obtenerValor("comp_ndocto")
				rut			= 	f_listado_alumnos.obtenerValor("rut")
				sql_inserta_alumno= "Insert into postulantes_cargos_factura (pote_ncorr,fact_ncorr,comp_ndocto_oc,audi_tusuario,audi_fmodificacion) "& vbCrLf &_
									"Values ("&pote_ncorr&","&v_fact_ncorr&","&comp_ndocto&",'"&v_usuario&"-paga oc',getdate()) "
				conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_alumno)		
				'response.Write("<pre>"&sql_inserta_alumno&"</pre>")											
		else ' en caso normal sin considerar cambio de año
			if inicio=0 then
				if k<=tope then
					pote_ncorr	= 	f_listado_alumnos.obtenerValor("pote_ncorr")
					comp_ndocto	= 	f_listado_alumnos.obtenerValor("comp_ndocto")
					rut			= 	f_listado_alumnos.obtenerValor("rut")
					'response.Write("<br>comp_ndocto:"&comp_ndocto&"************ Pote_ncorr: "&pote_ncorr&" -> Rut"&rut&"**************")
					sql_inserta_alumno= "Insert into postulantes_cargos_factura (pote_ncorr,fact_ncorr,comp_ndocto_oc,audi_tusuario,audi_fmodificacion) "& vbCrLf &_
										"Values ("&pote_ncorr&","&v_fact_ncorr&","&comp_ndocto&",'"&v_usuario&"-paga oc',getdate()) "
					'response.Write("<b>1</b><pre>"&sql_inserta_alumno&"</pre>")
					conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_alumno)									
				end if
			else
				if k>=inicio and k<=tope then
					pote_ncorr	= 	f_listado_alumnos.obtenerValor("pote_ncorr")
					comp_ndocto	= 	f_listado_alumnos.obtenerValor("comp_ndocto")
					rut			= 	f_listado_alumnos.obtenerValor("rut")
					sql_inserta_alumno= "Insert into postulantes_cargos_factura (pote_ncorr,fact_ncorr,comp_ndocto_oc,audi_tusuario,audi_fmodificacion) "& vbCrLf &_
										"Values ("&pote_ncorr&","&v_fact_ncorr&","&comp_ndocto&",'"&v_usuario&"-paga oc',getdate()) "
					conectar.EstadoTransaccion conectar.EjecutaS(sql_inserta_alumno)	
					'response.Write("<b>2</b><pre>"&sql_inserta_alumno&"</pre>")								
				end if
			end if
			'response.Write("<br>If alumnos "&k&": "&conectar.obtenerEstadoTransaccion&"<br>")
		end if ' fin 
	next
end if	
	'------------------------------------------------------------------		
'	response.Write("<br>Estado normal: "&conectar.obtenerEstadoTransaccion)
%>
<script language="JavaScript" type="text/javascript">
	url = 'imprimir_factura.asp?factura='+<%=v_fact_nfactura%>+'&tipo_factura='+<%=v_tfac_ccod%>+'&pers_ncorr='+<%=empr_ncorr%>+'&fact_ncorr='+<%=v_fact_ncorr%>;	
	window.open(url,"<%=v_fact_ncorr%>");		  
</script> 
<%	
	v_fact_nfactura=factura_actual	
	next  ' Fin for que crea ene facturas
end if

'response.Write("<br>Estado Final: "&conectar.obtenerEstadoTransaccion)
'conectar.EstadoTransaccion false
'response.End()	

if session("crear")=1 then
	session("crear")=2
end if


	
%>
<script language="JavaScript" type="text/javascript">
window.close();
</script> 

</body>
</html>

