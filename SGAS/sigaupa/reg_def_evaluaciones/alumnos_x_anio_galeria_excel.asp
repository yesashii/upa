<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=avance_promoción.xls"
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


consulta =  " select distinct a.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbCrLf &_
			" pers_tape_paterno + ' ' + pers_tape_materno + ' ' + pers_tnombre as nombre         "& vbCrLf &_
			" from alumnos a, ofertas_academicas b, personas c, periodos_academicos d,especialidades e "& vbCrLf &_
			" where a.ofer_ncorr=b.ofer_ncorr and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" and b.peri_ccod = d.peri_ccod and b.espe_ccod = e.espe_ccod and a.emat_ccod <> 9"& vbCrLf &_
			" and cast(d.anos_ccod as varchar)='"&anos_ccod&"' and e.carr_ccod='"&carr_ccod&"'"& vbCrLf &_
			" and not exists (select 1 from alumnos alu, ofertas_academicas ofe, periodos_academicos pea,especialidades esp "& vbCrLf &_
			"                 where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.peri_ccod=pea.peri_ccod "& vbCrLf &_
            "                 and pea.anos_ccod < d.anos_ccod  and ofe.espe_ccod=esp.espe_ccod and esp.carr_ccod=e.carr_ccod) "& vbCrLf &_
			" order by nombre"
			
nomina.consultar consulta 

set periodos = new cformulario
periodos.carga_parametros	"tabla_vacia.xml",	"tabla"
periodos.inicializar		conexion


consulta =  " select distinct peri_ccod, peri_tdesc,anos_ccod, plec_ccod "& vbCrLf &_
			" from periodos_academicos "& vbCrLf &_
			" where cast(anos_ccod as varchar) >= '"&anos_ccod&"' and anos_ccod <= datepart(year,getDate())"& vbCrLf &_
			" order by anos_ccod,plec_ccod "
			
periodos.consultar consulta 

carrera = conexion.consultaUno("select carr_tdesc from carreras where carr_ccod ='"&carr_ccod&"'")

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
		<td><div align="center"><strong>Fila</strong></div></td>
		<td><div align="center"><strong>Rut</strong></div></td>
		<td><div align="center"><strong>Nombre</strong></div></td>
		<%while periodos.siguiente
		    peri_tdesc =  periodos.obtenerValor("peri_tdesc")%>
			<td><div align="center"><strong><%=peri_tdesc%></strong></div></td>
		<%wend
		  periodos.primero%>	
	  </tr>
	  <%  
	  fila=1  
	  while nomina.Siguiente 
	  pers_ncorr = nomina.obtenerValor("pers_ncorr")%>
	  <tr> 
		<td><div align="center"><%=fila%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("rut")%></div></td>
		<td><div align="left"><%=nomina.ObtenerValor("nombre")%></div></td>
		<%while periodos.siguiente
		    peri_ccod =  periodos.obtenerValor("peri_ccod")
			estado = conexion.consultaUno("select lower(emat_tdesc) from alumnos a (nolock), ofertas_academicas b, especialidades c, estados_matriculas d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.emat_ccod=d.emat_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and cast(b.peri_ccod as varchar)='"&peri_ccod&"' order by a.audi_fmodificacion desc")
			if estado <> "" then%>
			    <td><div align="center"><%=estado%></div></td>
			<%else%>
			<td bgcolor="#FFCC66"><div align="center">--Sin Matrícula</div></td>
			<%end if%>
		<%wend
		  periodos.primero%>
	  </tr>
	  <% fila=fila +1 
	   wend %>
	</table>
	
	</td>
  </tr>
  
</table>
</body>
</html>