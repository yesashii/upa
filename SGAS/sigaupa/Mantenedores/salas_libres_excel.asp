<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=salas_libres.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'-----------------------------------------------------------------------
dias_ccod = request.QueryString("dias_ccod")
hora_ccod = request.QueryString("hora_ccod")
sede_ccod = request.QueryString("sede_ccod")

'------------------------------------------------------------------------------------

dias_tdesc = conexion.consultaUno("Select dias_tdesc from dias_semana where cast(dias_ccod as varchar)='"&dias_ccod&"'")
hora_tdesc = conexion.consultaUno("Select hora_tdesc from horarios where cast(hora_ccod as varchar)='"&hora_ccod&"'")  
if sede_ccod <> "" then
	sede_tdesc = conexion.consultaUno("Select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
	filtro_sede = " and cast(a.sede_ccod as varchar)='"&sede_ccod&"'" 
else
	sede_tdesc = "Todas las sedes"
	filtro_sede = " " 	
end if
peri_ccod = negocio.obtenerPeriodoAcademico("Planificacion")
plec_ccod = conexion.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
if plec_ccod <> "1" then
	anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
	primer_periodo = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=1 ")
else
	primer_periodo= peri_ccod
end if

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set salas = new CFormulario
salas.Carga_Parametros "tabla_vacia.xml", "tabla"
salas.Inicializar conexion
if dias_ccod <> "" and hora_ccod <> "" then
	consulta_salas =  " select sala_ccod, sala_tdesc as sala,c.tsal_tdesc as tipo,sala_ncupo as cupo,b.sede_tdesc as sede " & vbCrLf &_ 
					  "	from salas a, sedes b,tipos_sala c " & vbCrLf &_
					  "	where sala_ccod not in (select sala_ccod from bloques_horarios a, secciones b, asignaturas c " & vbCrLf &_
					  "	where cast(a.hora_ccod as varchar)='"&hora_ccod&"' and a.secc_ccod = b.secc_ccod and b.asig_ccod = c.asig_ccod " & vbCrLf &_
					  "	and cast(b.peri_ccod as varchar)= case duas_ccod when 3 then '"& primer_periodo &"' else '"&peri_ccod&"' end and cast(dias_ccod as varchar)='"&dias_ccod&"') " & vbCrLf &_
					  "	and a.sede_ccod=b.sede_ccod and a.tsal_ccod=c.tsal_ccod "&filtro_sede& vbCrLf &_
					  "	and exists (select 1 from bloques_horarios bh where bh.sala_ccod=a.sala_ccod) " & vbCrLf &_
					  "	order by sede_tdesc asc "
else
	consulta_salas = " select sala_ccod,sala_tdesc from salas where 1=2 "
end if				  

'response.Write("<pre>"&consulta_salas&"</pre>")
'response.End()
salas.Consultar consulta_salas

%>
<html>
<head>
<title> Listado de salas libres de la universidad</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de Salas libres de la Universidad</font></div>
	<div align="right"><%=fecha%></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Día consultado</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <% =dias_tdesc%> </td>
 </tr>
  <tr> 
    <td><strong>Bloque</strong></td>
    <td colspan="3"><strong>:</strong> <%=hora_tdesc %> </td>
  </tr>
    <tr> 
    <td><strong>Sede</strong></td>
    <td colspan="3"><strong>:</strong> <%=sede_tdesc %> </td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="2%"><div align="center"><strong>N°</strong></div></td>
    <td width="20%"><div align="center"><strong>Sala</strong></div></td>
    <td width="20%"><div align="center"><strong>Tipo</strong></div></td>
    <td width="5%"><div align="center"><strong>Cupos</strong></div></td>
	<td width="20%"><div align="center"><strong>Sede</strong></div></td>
  </tr>
  <% fila = 1 
   while salas.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="center"><%=salas.ObtenerValor("sala")%></div></td>
    <td><div align="center"><%=salas.ObtenerValor("tipo")%></div></td>
    <td><div align="left"><%=salas.ObtenerValor("cupo")%></div></td>
    <td><div align="center"><%=salas.ObtenerValor("sede")%></div></td>
  </tr>
  <% fila = fila + 1  
    wend 
  %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>