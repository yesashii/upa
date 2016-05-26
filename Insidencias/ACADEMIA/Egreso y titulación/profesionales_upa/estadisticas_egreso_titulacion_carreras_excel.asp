<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=estadisticas_egreso_titulacion_carreras.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 350000
set conexion = new CConexion
conexion.Inicializar "upacifico"

'-----------------------------------------------------------------------
fecha		= conexion.consultaUno("select getDate() ")
registros 	= request.Form("registros")
sede	 	= request.Form("sede")



%>
<html>
<head>
<title>ESTADÍSTICAS EGRESADOS, TITULADOS Y GRADUADOS</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">ESTADÍSTICAS EGRESADOS, TITULADOS Y GRADUADOS</font></div>
	<div align="right"><%=fecha%></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
</table>

<p>&nbsp;</p>
<table width="100%" border="1">
   <tr>
   		<td width="100%" align="center">
			<table class='v1' width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_secciones'>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'>&nbsp;</font></th>
					<th colspan="10"><font color='#333333'>Universidad Pregrado</font></th>
					<th colspan="2"><font color='#333333'>Universidad Postgrado</font></th>
					<th colspan="4"><font color='#333333'>Instituto</font></th>
				</tr>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'><%=sede%></font></th>
					<th colspan="2"><font color='#333333'>Egresados</font></th>
					<th colspan="2"><font color='#333333'>Titulados</font></th>
					<th colspan="2"><font color='#333333'>Grados</font></th>
					<th colspan="2"><font color='#333333'>S.I.E</font></th>
					<th colspan="2"><font color='#333333'>S.I.T</font></th>
					<th colspan="2"><font color='#333333'>Grados</font></th>
					<th colspan="2"><font color='#333333'>Egresados</font></th>
					<th colspan="2"><font color='#333333'>Titulados</font></th>
				</tr>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'>&nbsp;</font></th>
					<th><font color='#333333'>H</font></th>
					<th><font color='#333333'>M</font></th>
					<th><font color='#333333'>H</font></th>
					<th><font color='#333333'>M</font></th>
					<th><font color='#333333'>H</font></th>
					<th><font color='#333333'>M</font></th>
					<th><font color='#333333'>H</font></th>
					<th><font color='#333333'>M</font></th>
					<th><font color='#333333'>H</font></th>
					<th><font color='#333333'>M</font></th>
					<th><font color='#333333'>H</font></th>
					<th><font color='#333333'>M</font></th>
					<th><font color='#333333'>H</font></th>
					<th><font color='#333333'>M</font></th>
					<th><font color='#333333'>H</font></th>
					<th><font color='#333333'>M</font></th>
				</tr>
				<%  fila = 1
			        while fila <= cint(registros)
				%>
				<tr bgcolor="#FFFFFF">
					<td align='LEFT'><%=request.Form("campo_"&fila&"_carrera")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c1")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c2")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c3")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c4")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c5")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c6")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c7")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c8")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c9")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c10")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c11")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c12")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c13")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c14")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c15")%></td>
					<td align='CENTER'><%=request.Form("campo_"&fila&"_c16")%></td>
				</tr>
				<%fila= fila + 1 
				  wend%>
				
			   </table>
		</td>
   </tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>