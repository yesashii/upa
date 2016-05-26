<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: modulo tesorero
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:12/04/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			: 149 - 284 -352
'*******************************************************************
Server.ScriptTimeout = 3000 
Response.AddHeader "Content-Disposition", "attachment;filename=planilla_cuenta_corriente_masiva_excel.xls"
Response.ContentType = "application/vnd.ms-excel"
 
'---------------------------------------------------------------------------------------------------
'for each x in request.QueryString
'	response.Write("<br>"&x&"->"&request.QueryString(x))
'next
For I = 0 to 10
	q_pers_nrut 	= 	Request.QueryString("busqueda["&I&"][pers_nrut]")

	if q_pers_nrut<>"" then
		filtro_rut=filtro_rut&coma&q_pers_nrut
	end if
	coma=","
Next
'response.Write("<br>"&filtro_rut&"--")
'response.End()


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

v_anos  = request.querystring("busqueda[0][v_anos]")
q_pers_nrut 	= 	Request.QueryString("buscador[0][pers_nrut]")

fecha_01 = conexion.ConsultaUno("Select protic.trunc(getdate())")

'**********************************************************************************

		set consolidado = new CFormulario
		consolidado.carga_parametros "tabla_vacia.xml", "tabla_vacia"
		consolidado.inicializar conexion 
		
'		sql_consolidado="select protic.obtener_rut(a.pers_ncorr) as rut, b.inst_ccod, b.comp_ndocto,b.tcom_ccod,b.dcom_ncompromiso, case when b.tcom_ccod in (1,2) then cast(b.comp_ndocto as varchar)+ ' ('+protic.numero_contrato(b.comp_ndocto)+')'else cast(b.comp_ndocto as varchar) end as ncompromiso, " & vbCrLf &_
'						"     case " & vbCrLf &_
'						"   when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35 or b.tcom_ccod=15 " & vbCrLf &_
'						"		then " & vbCrLf &_
'						"       (Select top 1 a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod " & vbCrLf &_
'						"        and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) " & vbCrLf &_
'						" 	when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') "& vbCrLf &_
'						"   else " & vbCrLf &_
'						"        (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod) " & vbCrLf &_
'						"    end as tcom_tdesc, " & vbCrLf &_
'						"    cast(b.dcom_ncompromiso as varchar) + ' de ' + cast(a.comp_ncuotas as varchar)  as ncuota," & vbCrLf &_
'						"    protic.trunc(a.comp_fdocto) as fecha_emision, protic.trunc(b.dcom_fcompromiso) as fecha_vencimiento, isnull(b.dcom_mcompromiso,0) as dcom_mcompromiso," & vbCrLf &_
'						"    (select ting_tdesc from tipos_ingresos where ting_ccod=isnull(protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod'),0)) as ting_ccod," & vbCrLf &_
'						"    case  "& vbCrLf &_
'						"    when a.tcom_ccod=2 and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')=52 "& vbCrLf &_
'						"        then  "& vbCrLf &_
'						"          (select pag.PAGA_NCORR from  pagares pag 	where  pag.cont_ncorr =a.comp_ndocto and isnull(pag.opag_ccod,1) not in (2)) "& vbCrLf &_
'						"        else "& vbCrLf &_
'						"            protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') "& vbCrLf &_
'						"        end as ding_ndocto, "& vbCrLf &_
'						"    protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, " & vbCrLf &_
'						"    protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado," & vbCrLf &_
'						"    isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, " & vbCrLf &_
'						"(select d.edin_ccod from  estados_detalle_ingresos d" & vbCrLf &_
'						"    where c.edin_ccod = d.edin_ccod) as edin_ccod," & vbCrLf &_
'						"(select d.edin_tdesc+protic.obtener_institucion(c.ingr_ncorr) from estados_detalle_ingresos d" & vbCrLf &_
'						"    where c.edin_ccod = d.edin_ccod) as edin_tdesc,protic.obtener_nombre_carrera(protic.ultima_oferta_matriculado(a.pers_ncorr),'CJ') as carrera, " & vbCrLf &_
'						"	 protic.ANO_INGRESO_CARRERA(a.pers_ncorr,(select top 1 carr_ccod from ofertas_academicas oa, especialidades esp " & vbCrLf &_
'						"												where oa.espe_ccod=esp.espe_ccod " & vbCrLf &_
'						"												and oa.ofer_ncorr=protic.ultima_oferta_matriculado(a.pers_ncorr))) as promocion    " & vbCrLf &_
'						" from compromisos a,detalle_compromisos b,detalle_ingresos c, personas d" & vbCrLf &_
'						" where a.tcom_ccod = b.tcom_ccod" & vbCrLf &_
'						"    and a.inst_ccod = b.inst_ccod " & vbCrLf &_
'						"    and a.comp_ndocto = b.comp_ndocto" & vbCrLf &_
'						"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') *= c.ting_ccod" & vbCrLf &_
'						"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') *= c.ding_ndocto" & vbCrLf &_
'						"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') *= c.ingr_ncorr" & vbCrLf &_
'						"    and a.ecom_ccod = '1' " & vbCrLf &_
'						"    and b.ecom_ccod <> '3' " & vbCrLf &_
'						"    and a.pers_ncorr = d.pers_ncorr " & vbCrLf &_
'						"    and cast(d.pers_nrut as varchar) in ("& filtro_rut & ") " & vbCrLf &_
'						"    order by rut,b.dcom_fcompromiso desc"

		sql_consolidado="select protic.obtener_rut(a.pers_ncorr) as rut, b.inst_ccod, b.comp_ndocto,b.tcom_ccod,b.dcom_ncompromiso, case when b.tcom_ccod in (1,2) then cast(b.comp_ndocto as varchar)+ ' ('+protic.numero_contrato(b.comp_ndocto)+')'else cast(b.comp_ndocto as varchar) end as ncompromiso, " & vbCrLf &_
						"     case " & vbCrLf &_
						"   when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35 or b.tcom_ccod=15 " & vbCrLf &_
						"		then " & vbCrLf &_
						"       (  " & vbCrLf &_
						"		Select top 1 a1.tdet_tdesc  " & vbCrLf &_
						"		from tipos_detalle a1  " & vbCrLf &_
						"		INNER JOIN detalles a2  " & vbCrLf &_
						"		ON a1.tdet_ccod = a2.tdet_ccod " & vbCrLf &_
						"		and a2.tcom_ccod = a.tcom_ccod  " & vbCrLf &_
						"		and a2.inst_ccod = a.inst_ccod  " & vbCrLf &_
 						"       and a2.comp_ndocto = a.comp_ndocto " & vbCrLf &_
						"	) " & vbCrLf &_
						" 	when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') "& vbCrLf &_
						"   else " & vbCrLf &_
						"        (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod) " & vbCrLf &_
						"    end as tcom_tdesc, " & vbCrLf &_
						"    cast(b.dcom_ncompromiso as varchar) + ' de ' + cast(a.comp_ncuotas as varchar)  as ncuota," & vbCrLf &_
						"    protic.trunc(a.comp_fdocto) as fecha_emision, protic.trunc(b.dcom_fcompromiso) as fecha_vencimiento, isnull(b.dcom_mcompromiso,0) as dcom_mcompromiso," & vbCrLf &_
						"    (select ting_tdesc from tipos_ingresos where ting_ccod=isnull(protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod'),0)) as ting_ccod," & vbCrLf &_
						"    case  "& vbCrLf &_
						"    when a.tcom_ccod=2 and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')=52 "& vbCrLf &_
						"        then  "& vbCrLf &_
						"          (select pag.PAGA_NCORR from  pagares pag 	where  pag.cont_ncorr =a.comp_ndocto and isnull(pag.opag_ccod,1) not in (2)) "& vbCrLf &_
						"        else "& vbCrLf &_
						"            protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') "& vbCrLf &_
						"        end as ding_ndocto, "& vbCrLf &_
						"    protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, " & vbCrLf &_
						"    protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado," & vbCrLf &_
						"    isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, " & vbCrLf &_
						"(select d.edin_ccod from  estados_detalle_ingresos d" & vbCrLf &_
						"    where c.edin_ccod = d.edin_ccod) as edin_ccod," & vbCrLf &_
						"(select d.edin_tdesc+protic.obtener_institucion(c.ingr_ncorr) from estados_detalle_ingresos d" & vbCrLf &_
						"    where c.edin_ccod = d.edin_ccod) as edin_tdesc,protic.obtener_nombre_carrera(protic.ultima_oferta_matriculado(a.pers_ncorr),'CJ') as carrera, " & vbCrLf &_
						"	 protic.ANO_INGRESO_CARRERA(a.pers_ncorr,( " & vbCrLf &_
						"										select top 1 carr_ccod " & vbCrLf &_
						"										from ofertas_academicas oa " & vbCrLf &_
						"										INNER JOIN especialidades esp " & vbCrLf &_
						"										ON oa.espe_ccod = esp.espe_ccod " & vbCrLf &_
						"										and oa.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) " & vbCrLf &_
						"										)) as promocion    " & vbCrLf &_
						" from compromisos a " & vbCrLf &_
						"INNER JOIN detalle_compromisos b " & vbCrLf &_
						"ON a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
						"and a.inst_ccod = b.inst_ccod " & vbCrLf &_
						"and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
						"and a.ecom_ccod = '1' " & vbCrLf &_
						"and b.ecom_ccod <> '3' " & vbCrLf &_
						"LEFT OUTER JOIN detalle_ingresos c " & vbCrLf &_
						"ON protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod " & vbCrLf &_
						"and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto " & vbCrLf &_
						"and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr " & vbCrLf &_
						"INNER JOIN personas d " & vbCrLf &_
						"ON a.pers_ncorr = d.pers_ncorr " & vbCrLf &_
						"and cast(d.pers_nrut as varchar) in ("& filtro_rut & ") " & vbCrLf &_
						"    order by rut,b.dcom_fcompromiso desc"

'response.Write(sql_consolidado)		
'response.End()

		if not Esvacio(Request.QueryString) then
			consolidado.Consultar sql_consolidado

		else
			vacia = "select '' where 1=2 "
			
			consolidado.Consultar vacia
			consolidado.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
		end if

%>
<html>
<head>
<title>Detalle Cuenta Corriente</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="3"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">  Planilla Cuenta Corriente Alumno &quot;Masiva&quot; </font></div>
	  <div align="right"></div></td>
  </tr>
  <tr>
    <td width="8%"><strong>Fecha actual: </strong></td>
	<td width="91%" align="left" colspan="2"><%=fecha_01%></td>
 </tr>
</table>

<p></p>
<font color="#0000FF" size="+1" ><strong>Detalle cuenta corriente</strong></font>
<table width="100%" border="0">
  <tr>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Promocion</strong></div></td>  	  
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Rut</strong></div></td> 
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>N° compromiso/(contrato)</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Item</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>N&deg; Cuota</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Fecha Emisi&oacute;n</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Fecha Vencimiento</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Docto pactado</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>N° Docto</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Estado</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Monto</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Abonado</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Documentado</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Saldo</strong></div></td>
	<td></td>
	<td width="10%" bgcolor="#66CC99" ><div align="center"><strong>Fecha abono</strong></div></td>
	<td width="10%" bgcolor="#66CC99"><div align="center"><strong>Monto</strong></div></td>
	<td width="10%" bgcolor="#66CC99"><div align="center"><strong>Estado Ingreso</strong></div></td>
	<td width="10%" bgcolor="#66CC99"><div align="center"><strong>Docto. Emitido</strong></div></td>
	<td width="10%" bgcolor="#66CC99"><div align="center"><strong>Folio</strong></div></td>
	<td width="10%" bgcolor="#66CC99"><div align="center"><strong>Efectivo</strong></div></td>
	<td width="10%" bgcolor="#66CC99"><div align="center"><strong>Monto Documento</strong></div></td>
	<td width="10%" bgcolor="#66CC99"><div align="center"><strong>Tipo Docto</strong></div></td>
	<td width="10%" bgcolor="#66CC99"><div align="center"><strong>N° Docto</strong></div></td>
	<td width="10%" bgcolor="#66CC99"><div align="center"><strong>Fecha Docto</strong></div></td>
	<td width="10%" bgcolor="#66CC99"><div align="center"><strong>Estado Docto</strong></div></td>	
	<td width="10%" bgcolor="#66CC99"><div align="center"><strong>Banco</strong></div></td>

  </tr>
  <% fila = 1 
     while consolidado.Siguiente 
	 q_tcom_ccod=consolidado.ObtenerValor("tcom_ccod")
	 q_inst_ccod=consolidado.ObtenerValor("inst_ccod")
	 q_comp_ndocto=consolidado.ObtenerValor("comp_ndocto")
 	 q_dcom_ncompromiso=consolidado.ObtenerValor("dcom_ncompromiso")
	 %>
  <tr>
  	<td><div align="center"><%=consolidado.ObtenerValor("carrera")%></div></td>
  	<td><div align="center"><%=consolidado.ObtenerValor("promocion")%></div></td>  
	<td><div align="center"><%=consolidado.ObtenerValor("rut")%></div></td> 
	<td><div align="center"><%=consolidado.ObtenerValor("ncompromiso")%></div></td>
    <td><div align="center"><%=consolidado.ObtenerValor("tcom_tdesc")%></div></td>
	<td><div align="center"><%=consolidado.ObtenerValor("ncuota")%></div></td>
	<td><div align="center"><%=consolidado.ObtenerValor("fecha_emision")%></div></td>
	<td><div align="center"><%=consolidado.ObtenerValor("fecha_vencimiento")%></div></td>
	<td><div align="center"><%=consolidado.ObtenerValor("ting_ccod")%></div></td>
	<td><div align="center"><%=consolidado.ObtenerValor("ding_ndocto")%></div></td>
	<td><div align="center"><%=consolidado.ObtenerValor("edin_tdesc")%></div></td>
    <td><div align="center"><%=FormatCurrency(consolidado.ObtenerValor("dcom_mcompromiso"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(consolidado.ObtenerValor("abonos"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(consolidado.ObtenerValor("documentado"),0)%></div></td>
	<td><div align="center"><%=FormatCurrency(consolidado.ObtenerValor("saldo"),0)%></div></td>
	<td colspan="15"></td>
  </tr>
<%
'*****************************************************************************
		set f_abonos = new CFormulario
		f_abonos.carga_parametros "tabla_vacia.xml", "tabla_vacia"
		f_abonos.inicializar conexion 

'		consulta_abonos = "select cast(case d.ting_brebaje when 'S' then -a.abon_mabono else a.abon_mabono end as numeric) as abon_mabono" & vbCrLf &_
'							" , protic.trunc(a.abon_fabono) as fecha_abono, (select eing_tdesc from estados_ingresos where eing_ccod=b.eing_ccod) as estado_ingreso, " & vbCrLf &_
'							"  b.ingr_fpago, isnull(b.ingr_mefectivo,0) as efectivo, b.ingr_mdocto as documentado, d.ting_tdesc as docto_emitido, b.ingr_nfolio_referencia as folio," & vbCrLf &_
'							" (select ting_tdesc from tipos_ingresos where ting_ccod in (select isnull(ting_ccod,0) from detalle_ingresos where ingr_ncorr=b.ingr_ncorr)) as documento,"  & vbCrLf &_
'							" c.ding_ndocto as num_docto, c.ding_mdocto, protic.trunc(c.ding_fdocto) as fecha_docto , " & vbCrLf &_
'							" (select banc_tdesc from bancos where banc_ccod=isnull(c.banc_ccod,0)) as banco " & vbCrLf &_
'							"    from abonos a,ingresos b,detalle_ingresos c,tipos_ingresos d" & vbCrLf &_
'							"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
'							"        and b.ingr_ncorr *= c.ingr_ncorr" & vbCrLf &_
'							"        and b.ting_ccod = d.ting_ccod" & vbCrLf &_
'							"        and protic.estado_origen_ingreso(a.ingr_ncorr) in (1, 5)" & vbCrLf &_
'							"        and isnull(c.ding_bpacta_cuota, 'N') = 'N' " & vbCrLf &_
'							"        and a.tcom_ccod = '" & q_tcom_ccod & "' " & vbCrLf &_
'							"        and a.inst_ccod = '" & q_inst_ccod & "' " & vbCrLf &_
'							"        and a.comp_ndocto = '" & q_comp_ndocto & "' " & vbCrLf &_
'							"        and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & " ' "

		consulta_abonos = "select cast(case d.ting_brebaje when 'S' then -a.abon_mabono else a.abon_mabono end as numeric) as abon_mabono" & vbCrLf &_
							" , protic.trunc(a.abon_fabono) as fecha_abono, (select eing_tdesc from estados_ingresos where eing_ccod=b.eing_ccod) as estado_ingreso, " & vbCrLf &_
							"  b.ingr_fpago, isnull(b.ingr_mefectivo,0) as efectivo, b.ingr_mdocto as documentado, d.ting_tdesc as docto_emitido, b.ingr_nfolio_referencia as folio," & vbCrLf &_
							" (select ting_tdesc from tipos_ingresos where ting_ccod in (select isnull(ting_ccod,0) from detalle_ingresos where ingr_ncorr=b.ingr_ncorr)) as documento,"  & vbCrLf &_
							" c.ding_ndocto as num_docto, isnull(c.ding_mdocto,0) as ding_mdocto, protic.trunc(c.ding_fdocto) as fecha_docto , " & vbCrLf &_
							" (select banc_tdesc from bancos where banc_ccod=isnull(c.banc_ccod,0)) as banco " & vbCrLf &_
							"    from abonos a " & vbCrLf &_
 							"    INNER JOIN ingresos b " & vbCrLf &_
 							"    ON a.ingr_ncorr = b.ingr_ncorr and protic.estado_origen_ingreso(a.ingr_ncorr) in (1, 5)  " & vbCrLf &_
							"    and a.tcom_ccod = '" & q_tcom_ccod & "' " & vbCrLf &_
							"        and a.inst_ccod = '" & q_inst_ccod & "' " & vbCrLf &_
							"        and a.comp_ndocto = '" & q_comp_ndocto & "' " & vbCrLf &_
							"        and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "' " & vbCrLf &_
							"    LEFT OUTER JOIN detalle_ingresos c " & vbCrLf &_
 							"    ON b.ingr_ncorr = c.ingr_ncorr and isnull(c.ding_bpacta_cuota, 'N') = 'N' " & vbCrLf &_
 							"    INNER JOIN tipos_ingresos d " & vbCrLf &_
							"    ON b.ting_ccod = d.ting_ccod "
							
						f_abonos.Consultar consulta_abonos	
			if f_abonos.NroFilas >0 then
				while f_abonos.Siguiente 
			%>
					  <tr bgcolor="#CCCCCC">
						<td colspan="16"><div align="right"><strong>Abonos activos</strong></td>
						<td><div align="center"><%=f_abonos.ObtenerValor("fecha_abono")%></div></td>
						<td><div align="center"><%=formatcurrency(f_abonos.ObtenerValor("abon_mabono"),0)%></div></td>
						<td><div align="center"><%=f_abonos.ObtenerValor("estado_ingreso")%></div></td>
						<td><div align="center"><%=f_abonos.ObtenerValor("docto_emitido")%></div></td>
						<td><div align="center"><%=f_abonos.ObtenerValor("folio")%></div></td>
						<td><div align="center"><%=formatcurrency(f_abonos.ObtenerValor("efectivo"),0)%></div></td>
						<td><div align="center"><%=formatcurrency(f_abonos.ObtenerValor("documentado"),0)%></div></td>
						<td><div align="center"><%=f_abonos.ObtenerValor("documento")%></div></td>
						<td><div align="center"><%=f_abonos.ObtenerValor("num_docto")%></div></td>
						<td><div align="center"><%=f_abonos.ObtenerValor("fecha_docto")%></div></td>
						<td><div align="center"><%=f_abonos.ObtenerValor("estado_docto")%></div></td>
						<td><div align="center"><%=f_abonos.ObtenerValor("banco")%></div></td>
					  </tr>
					<%
				wend
			end if	
			
'*****************************************************************************
'################		ABONOS DOCUMENTADOS		##############################
'*****************************************************************************

		set f_documentado = new CFormulario
		f_documentado.carga_parametros "tabla_vacia.xml", "tabla_vacia"
		f_documentado.inicializar conexion 

'		consulta_documentado = "select cast(case d.ting_brebaje when 'S' then -a.abon_mabono else  a.abon_mabono end as numeric) as abon_mabono, " & vbCrLf &_
'					"         protic.trunc(a.abon_fabono) as fecha_abono, (select eing_tdesc from estados_ingresos where eing_ccod=b.eing_ccod) as estado_ingreso," & vbCrLf &_
'					"		   b.ingr_fpago, isnull(b.ingr_mefectivo,0) as efectivo, b.ingr_mdocto, d.ting_tdesc as docto_emitido, b.ingr_nfolio_referencia as folio," & vbCrLf &_
'					"         (select ting_tdesc from tipos_ingresos where ting_ccod=c.ting_ccod) as documento, c.ding_ndocto as num_docto, c.ding_mdocto as documentado, " & vbCrLf &_
'					"         protic.trunc(c.ding_fdocto) as fecha_docto, c.ting_ccod as documento," & vbCrLf &_
'					" 		 (select edin_tdesc from estados_detalle_ingresos where edin_ccod=isnull(c.edin_ccod,0)) as estado_docto, " & vbCrLf &_
'					" 		 (select banc_tdesc from bancos where banc_ccod=isnull(c.banc_ccod,0)) as banco " & vbCrLf &_
'					"    from abonos a,ingresos b,detalle_ingresos c,tipos_ingresos d" & vbCrLf &_
'					"    where a.ingr_ncorr = b.ingr_ncorr" & vbCrLf &_
'					"        and b.ingr_ncorr *= c.ingr_ncorr" & vbCrLf &_
'					"        and b.ting_ccod = d.ting_ccod" & vbCrLf &_
'					"        and protic.estado_origen_ingreso(a.ingr_ncorr) = 4 " & vbCrLf &_
'					"        and a.tcom_ccod = '" & q_tcom_ccod & "' " & vbCrLf &_
'					"        and a.inst_ccod = '" & q_inst_ccod & "' " & vbCrLf &_
'					"        and a.comp_ndocto = '" & q_comp_ndocto & "' " & vbCrLf &_
'					"        and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "'"

		consulta_documentado = "select cast(case d.ting_brebaje when 'S' then -a.abon_mabono else  a.abon_mabono end as numeric) as abon_mabono, " & vbCrLf &_
					"         protic.trunc(a.abon_fabono) as fecha_abono, (select eing_tdesc from estados_ingresos where eing_ccod=b.eing_ccod) as estado_ingreso," & vbCrLf &_
					"		   b.ingr_fpago, isnull(b.ingr_mefectivo,0) as efectivo, b.ingr_mdocto, d.ting_tdesc as docto_emitido, b.ingr_nfolio_referencia as folio," & vbCrLf &_
					"         (select ting_tdesc from tipos_ingresos where ting_ccod=c.ting_ccod) as documento, c.ding_ndocto as num_docto, c.ding_mdocto as documentado, " & vbCrLf &_
					"         protic.trunc(c.ding_fdocto) as fecha_docto, c.ting_ccod as documento," & vbCrLf &_
					" 		 (select edin_tdesc from estados_detalle_ingresos where edin_ccod=isnull(c.edin_ccod,0)) as estado_docto, " & vbCrLf &_
					" 		 (select banc_tdesc from bancos where banc_ccod=isnull(c.banc_ccod,0)) as banco " & vbCrLf &_
					"    from abonos a " & vbCrLf &_
 					"    INNER JOIN ingresos b " & vbCrLf &_
 					"    ON a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
 					"    and protic.estado_origen_ingreso(a.ingr_ncorr) = 4 " & vbCrLf &_
					"        and a.tcom_ccod = '" & q_tcom_ccod & "' " & vbCrLf &_
					"        and a.inst_ccod = '" & q_inst_ccod & "' " & vbCrLf &_
					"        and a.comp_ndocto = '" & q_comp_ndocto & "' " & vbCrLf &_
					"        and a.dcom_ncompromiso = '" & q_dcom_ncompromiso & "' " & vbCrLf &_
 					"    LEFT OUTER JOIN detalle_ingresos c " & vbCrLf &_
 					"    ON b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
 					"    INNER JOIN tipos_ingresos d " & vbCrLf &_
					"     ON b.ting_ccod = d.ting_ccod  "
	
			f_documentado.Consultar consulta_documentado	
			if f_documentado.NroFilas >0 then
				while f_documentado.Siguiente 
			%>
					  <tr bgcolor="#CCCCCC">
						<td colspan="16"><div align="right"><strong>Documentado</strong></div></td>
						<td><div align="center"><%=f_documentado.ObtenerValor("fecha_abono")%></div></td>
						<td><div align="center"><%=formatcurrency(f_documentado.ObtenerValor("abon_mabono"),0)%></div></td>
						<td><div align="center"><%=f_documentado.ObtenerValor("estado_ingreso")%></div></td>
						<td><div align="center"><%=f_documentado.ObtenerValor("docto_emitido")%></div></td>
						<td><div align="center"><%=f_documentado.ObtenerValor("folio")%></div></td>
						<td><div align="center"><%=formatcurrency(f_documentado.ObtenerValor("efectivo"),0)%></div></td>
						<td><div align="center"><%=formatcurrency(f_documentado.ObtenerValor("documentado"),0)%></div></td>
						<td><div align="center"><%=f_documentado.ObtenerValor("documento")%></div></td>
						<td><div align="center"><%=f_documentado.ObtenerValor("num_docto")%></div></td>
						<td><div align="center"><%=f_documentado.ObtenerValor("fecha_docto")%></div></td>
						<td><div align="center"><%=f_documentado.ObtenerValor("estado_docto")%></div></td>
						<td><div align="center"><%=f_documentado.ObtenerValor("banco")%></div></td>
					  </tr>
					<%
				wend
			end if		
'*****************************************************************************					
  wend %>
</table>
<p></p>
<p></p>
</body>
</html>