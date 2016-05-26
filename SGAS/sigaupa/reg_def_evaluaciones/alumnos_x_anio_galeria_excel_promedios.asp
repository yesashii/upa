<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=promedios_promoción.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

 carr_ccod     =    request.QueryString("carr_ccod")
 anos_ccod     =	request.querystring("anos_ccod")

'------------------------------------------------------------------------------------
set nomina = new cformulario
nomina.carga_parametros	"tabla_vacia.xml",	"tabla"
nomina.inicializar		conexion


consulta =  " select distinct sede_tdesc as sede, carr_tdesc as carrera,jorn_tdesc as jornada,a.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbCrLf &_
			" pers_tape_paterno + ' ' + pers_tape_materno + ' ' + pers_tnombre as nombre,         "& vbCrLf &_
			" (select cast(avg(carg_nnota_final) as decimal(3,2))  "& vbCrLf &_
            "     from alumnos aa, ofertas_academicas bb, especialidades cc,  "& vbCrLf &_
            "     cargas_academicas dd, secciones ee, asignaturas ff  "& vbCrLf &_
            "     where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and bb.espe_ccod=cc.espe_ccod  "& vbCrLf &_
            "     and aa.matr_ncorr=dd.matr_ncorr and dd.secc_ccod=ee.secc_ccod and ee.asig_ccod=ff.asig_ccod  "& vbCrLf &_
            "     and cc.carr_ccod = e.carr_ccod and isnull(carg_nnota_final,0.0) <> 0.0  "& vbCrLf &_
            "    ) as promedio_acumulado, lower(c.pers_temail) as email, "& vbCrLf &_
			"    (select top 1 lower(email_nuevo) from cuentas_email_upa tr where tr.pers_ncorr= a.pers_ncorr order by fecha_creacion desc) as email_institucional, "& vbCrLf &_
			"  protic.obtener_direccion_letra(a.pers_ncorr,1,'CNPB') as direccion,  "& vbCrLf &_
			"  protic.obtener_direccion_letra(a.pers_ncorr,1,'C-C') as comuna_ciudad, c.pers_tfono as teléfono, c.pers_tcelular as celular,  "& vbCrLf &_
			"    (select top 1 emat_tdesc   " & vbCrLf & _
		    "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3, estados_matriculas t4   " & vbCrLf & _
		    "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod   " & vbCrLf & _
		    "         and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=e.carr_ccod and tt.emat_ccod=t4.emat_ccod   " & vbCrLf & _
		    "         and tt.emat_ccod <> 9 order by t2.peri_ccod desc) as ultimo_estado,   " & vbCrLf & _
		    "    (select top 1 peri_tdesc   " & vbCrLf & _
		    "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3, periodos_academicos t4   " & vbCrLf & _
		    "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod   " & vbCrLf & _
		    "         and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=e.carr_ccod and t2.peri_ccod=t4.peri_ccod   " & vbCrLf & _
		    "         and tt.emat_ccod <> 9 order by t2.peri_ccod desc) as ultimo_periodo        " & vbCrLf & _
			" from alumnos a, ofertas_academicas b, personas c, periodos_academicos d,especialidades e, sedes f, jornadas g, carreras h  "& vbCrLf &_
			" where a.ofer_ncorr=b.ofer_ncorr and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" and b.peri_ccod = d.peri_ccod and b.espe_ccod = e.espe_ccod and a.emat_ccod <> 9"& vbCrLf &_
			" and cast(d.anos_ccod as varchar)='"&anos_ccod&"' and e.carr_ccod='"&carr_ccod&"'"& vbCrLf &_
			" and b.sede_ccod = f.sede_ccod and b.jorn_ccod = g.jorn_ccod and e.carr_ccod=h.carr_ccod "& vbCrLf &_
			" and not exists (select 1 from alumnos alu, ofertas_academicas ofe, periodos_academicos pea,especialidades esp "& vbCrLf &_
			"                 where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.peri_ccod=pea.peri_ccod "& vbCrLf &_
            "                 and pea.anos_ccod < d.anos_ccod  and ofe.espe_ccod=esp.espe_ccod and esp.carr_ccod=e.carr_ccod) "& vbCrLf &_
			" order by promedio_acumulado desc"
			
nomina.consultar consulta 

carrera = conexion.consultaUno("select carr_tdesc from carreras where carr_ccod ='"&carr_ccod&"'")

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Alumnos y promedio</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body>
<table width="100%" border="0">
  <tr> 
    <td><div align="left"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de Alumnos y promedio</font></div></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align="left"><%=fecha%></td>
  </tr>
  <tr>
    <td align="left"><%=carrera%></td>
  </tr>
  <tr>
    <td align="left"><%=anos_ccod%></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td align="left">
	<table width="100%" border="1">
	  <tr> 
		<td bgcolor="#66CC99"><div align="center"><strong>Fila</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Sede</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Carrera</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Jornada</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Rut</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Nombre</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Promedio acumulado</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Email</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Email Institucional</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Dirección</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Ciudad</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Teléfono</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Celular</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Último Estado</strong></div></td>
		<td bgcolor="#66CC99"><div align="center"><strong>Último Período</strong></div></td>
	  </tr>
	  <%  
	  fila=1  
	  while nomina.Siguiente 
	  pers_ncorr = nomina.obtenerValor("pers_ncorr")%>
	  <tr> 
		<td><div align="center"><%=fila%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("sede")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("carrera")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("jornada")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("rut")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("nombre")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("promedio_acumulado")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("email")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("email_institucional")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("direccion")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("comuna_ciudad")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("teléfono")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("celular")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("ultimo_estado")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("ultimo_periodo")%></div></td>
	  </tr>
	  <% fila=fila +1 
	   wend %>
	</table>
	
	</td>
  </tr>
  
</table>
</body>
</html>