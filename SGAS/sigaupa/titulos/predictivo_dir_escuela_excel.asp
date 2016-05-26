<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=predictivo_dir_escuela.xls"
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

consulta =" select sede, jornada,pers_ncorr,      "& vbCrLf & _
				   " rut, ap_paterno + ' ' + ap_materno + ' ' + nombres as nombre_completo,    "& vbCrLf & _
				   " ano_ingreso_carrera, ultimo_estado, ultimo_periodo, ultimo_plan  as plan_ccod,'"&carr_ccod&"' as carr_ccod, "& vbCrLf & _
				   " isnull((select case isnull(tt.CEGR_NVB_ESCUELA,'0') when '0' then '' else 'SI' end from CANDIDATOS_EGRESO tt where tt.pers_ncorr=table1.pers_ncorr and tt.plan_ccod=table1.ultimo_plan and tt.carr_ccod='"&carr_ccod&"'),'') as V_B_Escuela, "& vbCrLf & _
				   " isnull((select case isnull(tt.CEGR_NVB_TITULOS,'0') when '0' then '' else 'SI' end from CANDIDATOS_EGRESO tt where tt.pers_ncorr=table1.pers_ncorr and tt.plan_ccod=table1.ultimo_plan and tt.carr_ccod='"&carr_ccod&"'),'') as V_B_Titulos "& vbCrLf & _
				   " from    "& vbCrLf & _
				   " (    "& vbCrLf & _
				   "   select distinct sede_tdesc as sede, jorn_tdesc as jornada,    "& vbCrLf & _
				   "   g.pers_ncorr,cast(g.pers_nrut as varchar)+'-'+g.pers_xdv as rut, g.pers_tnombre as nombres,   "& vbCrLf & _ 
				   "   g.pers_tape_paterno as ap_paterno, g.pers_tape_materno as ap_materno,    "& vbCrLf & _
				   "   protic.ano_ingreso_carrera_egresa2(a.pers_ncorr,e.carr_ccod) as ano_ingreso_carrera,      "& vbCrLf & _
				   "  (select top 1 emat_tdesc    "& vbCrLf & _
				   "   from alumnos tt (nolock), ofertas_academicas t2,  "& vbCrLf & _ 
				   "        especialidades t3, estados_matriculas t4    "& vbCrLf & _
				   "   where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod    "& vbCrLf & _
				   "   and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=e.carr_ccod  "& vbCrLf & _
				   "   and tt.emat_ccod=t4.emat_ccod    "& vbCrLf & _
				   "   order by t2.peri_ccod desc, tt.audi_tusuario desc) as ultimo_estado,    "& vbCrLf & _
				   "  (select top 1 peri_tdesc    "& vbCrLf & _
				   "   from alumnos tt (nolock), ofertas_academicas t2,  "& vbCrLf & _
				   "   	    especialidades t3, periodos_academicos t4    "& vbCrLf & _
				   "   where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod    "& vbCrLf & _
				   "	 and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=e.carr_ccod  "& vbCrLf & _
				   "	 and t2.peri_ccod=t4.peri_ccod    "& vbCrLf & _
				   "     order by t2.peri_ccod desc, tt.audi_tusuario desc) as ultimo_periodo,   "& vbCrLf & _  
				   "  (select top 1 tt.plan_ccod    "& vbCrLf & _
				   "   from alumnos tt (nolock), ofertas_academicas t2,  "& vbCrLf & _ 
				   "        especialidades t3, estados_matriculas t4    "& vbCrLf & _
				   "   where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod    "& vbCrLf & _
				   "   and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=e.carr_ccod  "& vbCrLf & _
				   "   and tt.emat_ccod=t4.emat_ccod    "& vbCrLf & _
				   "   order by t2.peri_ccod desc, tt.audi_tusuario desc) as ultimo_plan    "& vbCrLf & _    
				   " from alumnos a (nolock), ofertas_academicas b, sedes c, especialidades d,  "& vbCrLf & _
				   "      carreras e, jornadas f, personas g  (nolock), periodos_academicos h   "& vbCrLf & _
				   " where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod    "& vbCrLf & _
				   " and b.espe_ccod=d.espe_ccod and d.carr_ccod=e.carr_ccod    "& vbCrLf & _
				   " and b.jorn_ccod=f.jorn_ccod    "& vbCrLf & _
				   " and a.pers_ncorr=g.pers_ncorr and b.peri_ccod = h.peri_ccod   "& vbCrLf & _
				   " and (select count(*)  "& vbCrLf & _  
				   "      from alumnos tt (nolock), ofertas_academicas t2, especialidades t3    "& vbCrLf & _
				   "      where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod    "& vbCrLf & _
				   "      and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=e.carr_ccod    "& vbCrLf & _ 
				   "  	  and tt.emat_ccod = 1 and isnull(tt.alum_nmatricula,0) <> 7777 ) >= 2    "& vbCrLf & _
				   " and not exists(select 1    "& vbCrLf & _
				   " 			    from alumnos tt (nolock), ofertas_academicas t2, especialidades t3    "& vbCrLf & _
				   "  			    where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod    "& vbCrLf & _
				   "			    and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=e.carr_ccod     "& vbCrLf & _
				   "				and tt.emat_ccod in (4,8))      "& vbCrLf & _        
				   " and cast(d.carr_ccod as varchar)='"&carr_ccod&"'    "& vbCrLf & _
				   " )table1   "& vbCrLf & _ 
				   " where protic.PREDICTIVO_EGRESO_ESCUELA(table1.pers_ncorr,'"&carr_ccod&"',table1.ultimo_plan) = 1  "& vbCrLf & _ 
				   " order by sede, jornada, nombre_completo asc"

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
	<td><div align="left"><%=tabla.ObtenerValor("V_B_Escuela")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("V_B_Titulos")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>