<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		        :
'FECHA CREACIÓN		        :
'CREADO POR 		        :
'ENTRADA			        :NA
'SALIDA			            :NA
'MODULO QUE ES UTILIZADO    :GESTIÓN DE DOCUMENTOS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	    :08/02/2013
'ACTUALIZADO POR		    :Luis Herrera G.
'MOTIVO			            :Corregir código, eliminar sentencia *=
'LINEA			            :71
'********************************************************************

Response.AddHeader "Content-Disposition", "attachment;filename=detalle_envios_transbank.xls"
Response.ContentType = "application/vnd.ms-excel"

'------------------------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'------------------------------------------------------------------------------------
set f_envio = new CFormulario
f_envio.Carga_Parametros "Envios_Notaria.xml", "f_envios"
f_envio.Inicializar conexion

consulta = "SELECT envios.eenv_ccod, envios.envi_ncorr, envios.envi_fenvio, envios.inen_ccod, "& vbCrLf &_
         "instituciones_envio.inen_tdesc,cuentas_corrientes.ccte_tdesc   "& vbCrLf &_
         "FROM envios, instituciones_envio, cuentas_corrientes "& vbCrLf &_
         "WHERE envios.inen_ccod = instituciones_envio.inen_ccod "& vbCrLf &_
		 "AND envios.ccte_ccod = cuentas_corrientes.ccte_ccod "& vbCrLf &_
         "AND envios.envi_ncorr = " & folio_envio 
		 
 f_envio.Consultar consulta
 f_envio.siguiente

 '------------------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "Envios_Notaria.xml", "excel"
f_detalle_envio.Inicializar conexion

		  
'consulta = "SELECT a.envi_ncorr, b.ting_ccod, b.ding_ndocto as c_ding_ndocto, b.ingr_ncorr ," & vbCrLf &_
'			"    b.ding_ndocto,  protic.total_recepcionar_cuota (ab.tcom_ccod ,ab.inst_ccod,ab.comp_ndocto,ab.dcom_ncompromiso) as ding_mdocto, convert(varchar,d.ingr_fpago,103) as ingr_fpago,  " & vbCrLf &_
'			"    convert(varchar,c.ding_fdocto,103)  as ding_fdocto, c1.edin_ccod, c1.edin_tdesc, cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno,  " & vbCrLf &_
'			"    cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado,c.ding_tcuenta_corriente as num_tarjeta," & vbCrLf &_
'			"     case when len(isnull(c.ding_ndocto,0))<=4 then protic.obtener_numero_pagare_pagado(c.ingr_ncorr) else cast(c.ding_ndocto as varchar) end as numero_pagare, "& vbCrLf &_
'			"    protic.obtener_nombre(f.pers_ncorr,'n') as nombre_apoderado " & vbCrLf &_
'			"FROM envios a, detalle_envios b, detalle_ingresos c, estados_detalle_ingresos c1,  " & vbCrLf &_
'			"ingresos d, personas e, personas f, abonos ab   " & vbCrLf &_
'			"WHERE a.envi_ncorr = b.envi_ncorr  " & vbCrLf &_
'			"and b.ting_ccod = c.ting_ccod  " & vbCrLf &_
'			"and b.ding_ndocto = c.ding_ndocto  " & vbCrLf &_
'			"and b.ingr_ncorr = c.ingr_ncorr  " & vbCrLf &_
'			"and c.ingr_ncorr = d.ingr_ncorr  " & vbCrLf &_
'			"and b.edin_ccod = c1.edin_ccod  " & vbCrLf &_
'			"and d.pers_ncorr = e.pers_ncorr " & vbCrLf &_
'			"and c.PERS_NCORR_CODEUDOR *= f.pers_ncorr  " & vbCrLf &_
'			"and a.envi_ncorr='" & folio_envio & "' " & vbCrLf &_
'			" and c.DING_NCORRELATIVO = 1  " & vbCrLf &_
'			" and c.ting_ccod=52 "& vbCrLf &_
'			" and ab.ingr_ncorr=d.ingr_ncorr "& vbCrLf &_
'			"ORDER BY  nombre_apoderado, b.ding_ndocto"

consulta = "select a.envi_ncorr, " & vbCrLf &_
            "	b.ting_ccod, " & vbCrLf &_
            "	b.ding_ndocto as c_ding_ndocto, " & vbCrLf &_
            "	b.ingr_ncorr , " & vbCrLf &_
            "	b.ding_ndocto, " & vbCrLf &_ 
            "	protic.total_recepcionar_cuota (ab.tcom_ccod, ab.inst_ccod,ab.comp_ndocto,ab.dcom_ncompromiso) as ding_mdocto," & vbCrLf &_
            "	convert(varchar,d.ingr_fpago,103) as ingr_fpago, " & vbCrLf &_ 
            "	convert(varchar,c.ding_fdocto,103)  as ding_fdocto, " & vbCrLf &_
            "	c1.edin_ccod, " & vbCrLf &_
            "	c1.edin_tdesc, " & vbCrLf &_
            "	cast(e.pers_nrut as varchar) + '-' + e.pers_xdv as rut_alumno, " & vbCrLf &_
            "	cast(f.pers_nrut as varchar) + '-' + f.pers_xdv as rut_apoderado, " & vbCrLf &_
            "	c.ding_tcuenta_corriente as num_tarjeta, " & vbCrLf &_
            "	case when len(isnull(c.ding_ndocto,0))<=4 then protic.obtener_numero_pagare_pagado(c.ingr_ncorr) else cast(c.ding_ndocto as varchar) end as numero_pagare, " & vbCrLf &_
            "	protic.obtener_nombre(f.pers_ncorr,'n') as nombre_apoderado " & vbCrLf &_
            "from envios a " & vbCrLf &_
            "join detalle_envios b " & vbCrLf &_
            "	on a.envi_ncorr = b.envi_ncorr " & vbCrLf &_
            "join detalle_ingresos c " & vbCrLf &_	 
            "	on b.ting_ccod = c.ting_ccod " & vbCrLf &_ 
            "	and b.ding_ndocto = c.ding_ndocto " & vbCrLf &_ 
            "	and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
            "join ingresos d " & vbCrLf &_	  
            "	on c.ingr_ncorr = d.ingr_ncorr " & vbCrLf &_
            "join estados_detalle_ingresos c1 " & vbCrLf &_
            "	on b.edin_ccod = c1.edin_ccod " & vbCrLf &_
            "join personas e " & vbCrLf &_	 
            "	on d.pers_ncorr = e.pers_ncorr " & vbCrLf &_
            "left outer join personas f	" & vbCrLf &_ 
            "	on c.PERS_NCORR_CODEUDOR = f.pers_ncorr " & vbCrLf &_
            "join abonos ab " & vbCrLf &_
            "	on ab.ingr_ncorr=d.ingr_ncorr " & vbCrLf &_
            "where a.envi_ncorr ='" & folio_envio & "' " & vbCrLf &_
            "	and c.DING_NCORRELATIVO = 1 " & vbCrLf &_ 
            "	and c.ting_ccod = 52 " & vbCrLf &_	
            "order by  nombre_apoderado, b.ding_ndocto "
            			  
'response.Write("<pre>"&consulta&"</pre>")
f_detalle_envio.Consultar consulta

%>
<html>
<head>
<title> Detalle Envio a Notaria</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td width="10%">&nbsp;</td>
    <td width="34%">&nbsp;</td>
  </tr>
  <tr> 
    <td><strong>N&ordm; Folio</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("envi_ncorr") %> </td>
    <td><div align="left"><font size="2"> </font></div></td>
    <td><strong>Fecha</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("envi_fenvio") %> </td>
  </tr>
  <tr> 
    <td><strong>Banco</strong></td>
    <td><strong>:</strong> <% =f_envio.DibujaCampo("inen_tdesc") %> </td>
    <td>&nbsp;</td>
    <td><strong>Cta. Cte</strong></td>
    <td><% f_envio.DibujaCampo("ccte_tdesc") %></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%">&nbsp;</td>
    <td width="26%">&nbsp;</td>
    <td width="14%"><div align="left"><font size="2"> </font></div></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

<table width="114%" border="1">
  <tr> 
    
	<td width="20%"><div align="center"><strong>N&ordm; Pagare</strong></div></td>
	<td width="20%"><div align="center"><strong>N&ordm; Tarjeta</strong></div></td>
	<td width="20%"><div align="center"><strong>Banco</strong></div></td>
    <td width="20%"><div align="center"><strong>Estado</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut Alumno</strong></div></td>
    <td width="16%"><div align="center"><strong>Rut Apoderado</strong></div></td>
    <td width="11%"><div align="center"><strong>Apoderado</strong></div></td>
    <td width="14%"><div align="center"><strong>Fecha Emisi&oacute;n</strong></div></td>
    <td width="14%"><div align="center"><strong>Fecha Vencimiento</strong> </div></td>
    <td width="19%"><div align="center"><strong>Monto </strong></div></td>
  </tr>
  <%  while f_detalle_envio.Siguiente %>
  <tr> 
  
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("numero_pagare")%></div></td>
    <td><%=f_detalle_envio.ObtenerValor("num_tarjeta")%></td>
	<td><div align="center"><%=f_detalle_envio.ObtenerValor("banco")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("edin_tdesc")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_alumno")%></div></td>
    <td><div align="center"><%=f_detalle_envio.ObtenerValor("rut_apoderado")%></div></td>
    <td><%=f_detalle_envio.ObtenerValor("nombre_apoderado")%></td>
    <td><div align="center">&nbsp;<%=f_detalle_envio.ObtenerValor("ingr_fpago")%></div></td>
    <td><div align="center">&nbsp;<%=f_detalle_envio.ObtenerValor("ding_fdocto")%></div></td>
    <td><div align="right"><%=f_detalle_envio.ObtenerValor("ding_mdocto")%></div></td>
  </tr>
    <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>