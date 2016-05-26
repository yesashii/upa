<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=vistos_buenos_egresados.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

carr_ccod = request.querystring("carr_ccod")
carrera = conexion.consultaUno("select carr_tdesc from carreras where carr_ccod='"&carr_ccod&"'")

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

consulta =" select cast(b.pers_nrut as varchar)+'-'+pers_xdv as Rut,  "& vbCrLf & _ 
			" pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as Nombre_completo,  "& vbCrLf & _ 
			" c.plan_tdesc as plan_,protic.trunc(cegr_fsolicitud) as fecha_solicitud,  "& vbCrLf & _ 
			" case isnull(cegr_nvb_escuela,0) when 0 then 'NO' else 'SI' end as vb_escuela, "& vbCrLf & _ 
			" case isnull(cegr_nvb_titulos,0) when 0 then ' ' when 3 then 'NO' else 'SI' end as vb_titulos, a.plan_ccod, a.carr_ccod,a.pers_ncorr, "& vbCrLf & _ 
			" cast(isnull(CEGR_NTOTAL_REINTENTOS,0) as varchar) + ' / ' + cast(isnull(CEGR_NTOTAL_RECHAZOS,0) as varchar) as reenvios_rechazos,"& vbCrLf & _ 
			" (select top 1 emat_tdesc    "& vbCrLf & _ 
			"  from alumnos tt (nolock), ofertas_academicas t2,  "& vbCrLf & _ 
			"	  especialidades t3, estados_matriculas t4   "& vbCrLf & _ 
			" where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod   "& vbCrLf & _  
			" and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=a.carr_ccod  "& vbCrLf & _ 
			" and tt.emat_ccod=t4.emat_ccod   "& vbCrLf & _  
			" order by t2.peri_ccod desc, tt.audi_tusuario desc) as ultimo_estado,   "& vbCrLf & _ 
			" (select top 1 peri_tdesc  "& vbCrLf & _   
			" from alumnos tt (nolock), ofertas_academicas t2, "& vbCrLf & _ 
			"	  especialidades t3, periodos_academicos t4  "& vbCrLf & _   
			" where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod   "& vbCrLf & _ 
			" and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=a.carr_ccod  "& vbCrLf & _ 
			" and t2.peri_ccod=t4.peri_ccod  "& vbCrLf & _   
			" order by t2.peri_ccod desc, tt.audi_tusuario desc) as ultimo_periodo, "& vbCrLf & _ 
			" protic.ano_ingreso_carrera_egresa2(a.pers_ncorr,a.carr_ccod) as ano_ingreso_carrera, "& vbCrLf & _ 
			" (select top 1 sede_tdesc from alumnos tt,ofertas_academicas t2, especialidades t3, sedes t4 "& vbCrLf & _ 
			"  where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.sede_ccod=t4.sede_ccod "& vbCrLf & _ 
			"  and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=a.carr_ccod and tt.emat_ccod <> 9 "& vbCrLf & _ 
			"  order by t2.peri_ccod desc) as sede, "& vbCrLf & _ 
			" (select top 1 jorn_tdesc from alumnos tt,ofertas_academicas t2, especialidades t3, jornadas t4 "& vbCrLf & _ 
			"  where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.jorn_ccod=t4.jorn_ccod "& vbCrLf & _ 
			"  and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=a.carr_ccod and tt.emat_ccod <> 9 "& vbCrLf & _ 
			"  order by t2.peri_ccod desc) as jornada, d.eceg_tdesc as estado_proceso "& vbCrLf & _ 
			" from candidatos_egreso a, personas b, planes_estudio c, ESTADO_CANDIDATOS_EGRESO d "& vbCrLf & _ 
			" where a.pers_ncorr=b.pers_ncorr  "& vbCrLf & _ 
			"  and a.plan_ccod=c.plan_ccod and a.ECEG_CCOD=d.ECEG_CCOD and cast(a.carr_ccod as varchar)='"&carr_ccod&"' "& vbCrLf & _ 
			" order by pers_tape_paterno, pers_tape_materno, pers_tnombre  "

tabla.consultar consulta 

'response.Write("<pre>"&consulta&"</pre>")

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de candidatos a egreso</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="8%"><strong>Carrera</strong></td>
    <td width="92%" colspan="3"><strong>:</strong> <%=Carrera%> </td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>Fila</strong></div></td>
    <td><div align="center"><strong>Sede</strong></div></td>
    <td><div align="center"><strong>Jornada</strong></div></td>
	<td><div align="center"><strong>Rut</strong></div></td>
    <td><div align="center"><strong>Nombre</strong></div></td>
	<td><div align="center"><strong>Año ingreso carrera</strong></div></td>
	<td><div align="center"><strong>Último estado</strong></div></td>
	<td><div align="center"><strong>Último período</strong></div></td>
	<td><div align="center"><strong>V°B° Escuela</strong></div></td>
	<td><div align="center"><strong>V°B° Títulos</strong></div></td>
	<td><div align="center"><strong>Estado Proceso</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("sede")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("jornada")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("rut")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("nombre_completo")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("ano_ingreso_carrera")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("ultimo_estado")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("ultimo_periodo")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("vb_escuela")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("vb_titulos")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("estado_proceso")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>