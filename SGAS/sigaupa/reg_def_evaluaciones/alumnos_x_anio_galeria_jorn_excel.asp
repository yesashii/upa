<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=avance_promoción_jornada.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

 anos_ccod     =	request.querystring("anos_ccod")

'------------------------------------------------------------------------------------
set nomina = new cformulario
nomina.carga_parametros	"tabla_vacia.xml",	"tabla"
nomina.inicializar		conexion


consulta =  " select distinct f.sede_ccod,f.sede_tdesc, h.carr_ccod,h.carr_tdesc, g.jorn_ccod,g.jorn_tdesc, e.espe_nduracion, "& vbCrLf &_
            " (select gg.Codigo_carrera_programa "& vbCrLf &_
			"  from sd_carreras_anio gg "& vbCrLf &_
			"  where gg.sede_ccod=f.sede_ccod and gg.jorn_ccod=g.jorn_ccod  "& vbCrLf &_
			"  and gg.carr_ccod = h.carr_ccod collate Modern_Spanish_CI_AS "& vbCrLf &_
			"  and gg.duracion_estudios = e.espe_nduracion "& vbCrLf &_
			"  and gg.anio = d.anos_ccod ) as cod_ministerio, "& vbCrLf &_
            " a.pers_ncorr,c.pers_nrut as RUN,c.pers_xdv as DV, "& vbCrLf &_
			" c.pers_tape_paterno as APELLIDO_PATERNO, c.pers_tape_materno as APELLIDO_MATERNO, c.pers_tnombre as NOMBRES, "& vbCrLf &_
			" (select tt.sexo_tdesc from sexos tt where tt.sexo_ccod=c.sexo_ccod) as SEXO, protic.trunc(c.pers_fnacimiento) as FECHA_NACIMIENTO, "& vbCrLf &_
			" (select tr.pais_tdesc from paises tr where tr.pais_ccod=c.pais_ccod) as PAIS, "& vbCrLf &_
			" --(select top 1 lower(emat_tdesc) + '<br>Mat:'+ isnull(protic.trunc(a.alum_fmatricula),' ') +  "& vbCrLf &_
 			" --'<br>Mod:'+ isnull(protic.trunc(a.audi_fmodificacion),' ')  "& vbCrLf &_
			" (select top 1 lower(emat_tdesc) "& vbCrLf &_
  			" from alumnos ta (nolock), ofertas_academicas tb, especialidades tc,  "& vbCrLf &_
     		" estados_matriculas td, periodos_academicos te "& vbCrLf &_
 			" where ta.ofer_ncorr=tb.ofer_ncorr and tb.espe_ccod=tc.espe_ccod and ta.emat_ccod=td.emat_ccod  "& vbCrLf &_
 			" and ta.pers_ncorr = a.pers_ncorr and tb.sede_ccod = f.sede_ccod  "& vbCrLf &_
 			" and tb.jorn_ccod = g.jorn_ccod and tc.carr_ccod = h.carr_ccod "& vbCrLf &_
 			" and tb.peri_ccod = te.peri_ccod and te.anos_ccod=d.anos_ccod and te.plec_ccod = 1  "& vbCrLf &_
 			" order by a.audi_fmodificacion desc) as primer_semestre, "& vbCrLf &_
			" --(select top 1 lower(emat_tdesc) + '<br>Mat:'+ isnull(protic.trunc(a.alum_fmatricula),' ') +  "& vbCrLf &_
 			" --'<br>Mod:'+ isnull(protic.trunc(a.audi_fmodificacion),' ')  "& vbCrLf &_
			" (select top 1 lower(emat_tdesc) "& vbCrLf &_
 			" from alumnos ta (nolock), ofertas_academicas tb, especialidades tc,  "& vbCrLf &_
      		" estados_matriculas td, periodos_academicos te "& vbCrLf &_
 			" where ta.ofer_ncorr=tb.ofer_ncorr and tb.espe_ccod=tc.espe_ccod and ta.emat_ccod=td.emat_ccod  "& vbCrLf &_
 			" and ta.pers_ncorr = a.pers_ncorr and tb.sede_ccod = f.sede_ccod  "& vbCrLf &_
  			" and tb.jorn_ccod = g.jorn_ccod and tc.carr_ccod = h.carr_ccod "& vbCrLf &_
 			" and tb.peri_ccod = te.peri_ccod and te.anos_ccod=d.anos_ccod and te.plec_ccod = 2 "& vbCrLf &_ 
 			" order by a.audi_fmodificacion desc) as segundo_semestre "& vbCrLf &_
			" from alumnos a (nolock), ofertas_academicas b, personas c (nolock), periodos_academicos d,especialidades e, "& vbCrLf &_
			" sedes f, jornadas g, carreras h "& vbCrLf &_
			" where a.ofer_ncorr=b.ofer_ncorr and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" and b.peri_ccod = d.peri_ccod and b.espe_ccod = e.espe_ccod and a.emat_ccod <> 9"& vbCrLf &_
			" and cast(d.anos_ccod as varchar)='"&anos_ccod&"' "& vbCrLf &_
			" and a.emat_ccod <> 9 and isnull(a.alum_nmatricula,0) <> 7777 "& vbCrLf &_
			" and b.sede_ccod = f.sede_ccod and b.jorn_ccod=g.jorn_ccod and e.carr_ccod=h.carr_ccod "& vbCrLf &_
			" order by f.sede_tdesc, h.carr_tdesc, g.jorn_tdesc, apellido_paterno,apellido_materno, nombres "
			
nomina.consultar consulta 

'carrera = conexion.consultaUno("select carr_tdesc from carreras where carr_ccod ='"&carr_ccod&"'")

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Alumnos y avance</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body>
<table width="100%" border="0">
  <tr> 
    <td><div align="left"><font size="+2" face="Arial, Helvetica, sans-serif">Alumnos por estado académico</font></div></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align="left"><%=fecha%></td>
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
		<td><div align="center"><strong>Fila</strong></div></td>
		<td><div align="left"><strong>RUN</strong></div></td>
		<td><div align="center"><strong>DV</strong></div></td>
		<td><div align="left"><strong>APELLIDO PATERNO</strong></div></td>
		<td><div align="left"><strong>APELLIDO MATERNO</strong></div></td>
		<td><div align="left"><strong>NOMBRES</strong></div></td>
		<td><div align="center"><strong>SEXO</strong></div></td>
		<td><div align="center"><strong>FECHA NACIMIENTO</strong></div></td>
		<td><div align="left"><strong>PAIS</strong></div></td>
		<td><div align="left"><strong>CÓDIGO CARRERA</strong></div></td>
		<td><div align="left"><strong>1ER SEMESTRE <%=anos_ccod%></strong></div></td>
	    <td><div align="left"><strong>2DO SEMESTRE <%=anos_ccod%></strong></div></td>
	  </tr>
	  <%  
	  fila=1  
	  while nomina.Siguiente 
	  pers_ncorr = nomina.obtenerValor("pers_ncorr")
	  sede_ccod  = nomina.obtenerValor("sede_ccod")
	  carr_ccod  = nomina.obtenerValor("carr_ccod")
	  jorn_ccod  = nomina.obtenerValor("jorn_ccod")
	  %>
	  <tr> 
		<td><div align="center"><%=fila%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("RUN")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("DV")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("APELLIDO_PATERNO")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("APELLIDO_MATERNO")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("NOMBRES")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("SEXO")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("FECHA_NACIMIENTO")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("PAIS")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("cod_ministerio")%></div></td>
		<%if nomina.obtenerValor("primer_semestre") <> "" then%>
			<td><div align="center"><%=nomina.obtenerValor("primer_semestre")%></div></td>
		<%else%>
			<td bgcolor="#FFCC66"><div align="center">Sin Matrícula</div></td>
		<%end if%>
		<%if nomina.obtenerValor("segundo_semestre") <> "" then%>
			<td><div align="center"><%=nomina.obtenerValor("segundo_semestre")%></div></td>
		<%else%>
			<td bgcolor="#FFCC66"><div align="center">Sin Matrícula</div></td>
		<%end if%>
	  </tr>
	  <% fila=fila +1 
	   wend %>
	</table>
	
	</td>
  </tr>
  
</table>
</body>
</html>