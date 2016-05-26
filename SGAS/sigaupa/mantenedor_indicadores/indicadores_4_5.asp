<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new cPagina
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
'set negocio = new CNegocio
'negocio.Inicializa conexion

'Buscamos los datos pertenecientes al cuadro 4.5a
estimado_2009a = conexion.consultaUno("select sum(indi_4_5_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2009'")
estimado_2010a = conexion.consultaUno("select sum(indi_4_5_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2010'")
estimado_2011a = conexion.consultaUno("select sum(indi_4_5_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2011'")
estimado_2012a = conexion.consultaUno("select sum(indi_4_5_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2012'")
estimado_2013a = conexion.consultaUno("select sum(indi_4_5_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2013'")

base2008a = conexion.consultaUno("select sum(indi_4_5_a) from mantenedor_dato_base_anual")

real_2009a = conexion.consultaUno("select sum(indi_4_5_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2009'")
real_2010a = conexion.consultaUno("select sum(indi_4_5_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2010'")
real_2011a = conexion.consultaUno("select sum(indi_4_5_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2011'")
real_2012a = conexion.consultaUno("select sum(indi_4_5_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2012'")
real_2013a = conexion.consultaUno("select sum(indi_4_5_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2013'")

'Buscamos los datos pertenecientes al cuadro 4.5b
estimado_2009b = conexion.consultaUno("select sum(indi_4_5_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2009'")
estimado_2010b = conexion.consultaUno("select sum(indi_4_5_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2010'")
estimado_2011b = conexion.consultaUno("select sum(indi_4_5_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2011'")
estimado_2012b = conexion.consultaUno("select sum(indi_4_5_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2012'")
estimado_2013b = conexion.consultaUno("select sum(indi_4_5_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2013'")

base2008b = conexion.consultaUno("select sum(indi_4_5_b) from mantenedor_dato_base_anual")

real_2009b = conexion.consultaUno("select sum(indi_4_5_b) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2009'")
real_2010b = conexion.consultaUno("select sum(indi_4_5_b) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2010'")
real_2011b = conexion.consultaUno("select sum(indi_4_5_b) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2011'")
real_2012b = conexion.consultaUno("select sum(indi_4_5_b) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2012'")
real_2013b = conexion.consultaUno("select sum(indi_4_5_b) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2013'")

'Buscamos los datos pertenecientes al cuadro 4.5c
estimado_2009c = conexion.consultaUno("select sum(indi_4_5_c) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2009'")
estimado_2010c = conexion.consultaUno("select sum(indi_4_5_c) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2010'")
estimado_2011c = conexion.consultaUno("select sum(indi_4_5_c) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2011'")
estimado_2012c = conexion.consultaUno("select sum(indi_4_5_c) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2012'")
estimado_2013c = conexion.consultaUno("select sum(indi_4_5_c) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2013'")

base2008c = conexion.consultaUno("select sum(indi_4_5_c) from mantenedor_dato_base_anual")

real_2009c = conexion.consultaUno("select sum(indi_4_5_c) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2009'")
real_2010c = conexion.consultaUno("select sum(indi_4_5_c) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2010'")
real_2011c = conexion.consultaUno("select sum(indi_4_5_c) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2011'")
real_2012c = conexion.consultaUno("select sum(indi_4_5_c) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2012'")
real_2013c = conexion.consultaUno("select sum(indi_4_5_c) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2013'")

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Indicadores 1.1</title>

<script language="JavaScript">
function colorear (ide)
{
	var elemento = document.getElementById(ide);
	elemento.bgColor="#7c9efa";
}
function descolorear (ide)
{
	var elemento = document.getElementById(ide);
	elemento.bgColor="#2b3c4e";
}
</script>
</head>

<body bgcolor="#d1d9e0">
<center>
	<table width="790" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3" width="790" background="imagenes/fondo_cuadro.png" align="center">
				<table width="98%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="2%" align="center">&nbsp; </td>
						<td width="96%" align="center">&nbsp; </td>
						<td width="2%" align="center">&nbsp; </td>
					</tr>
					<tr>
						<td width="2%" align="center">&nbsp; </td>
						<td width="96%" align="left" background="imagenes/fondo_cuadro2.png">
							<font size="3" color="#FFFFFF">
								<strong>4.	Desarrollar un modelo de gestión de personas, que contribuya a consolidar una comunicación académica orientada a alcanzar altos niveles de desempeño.</strong>
							</font>						
						</td>
						<td width="2%" align="center">&nbsp; </td>
					</tr>
					<tr>
						<td width="2%" align="center">&nbsp; </td>
						<td width="96%" align="center">&nbsp; </td>
						<td width="2%" align="center">&nbsp; </td>
					</tr>
					<tr>
						<td width="2%" align="center">&nbsp; </td>
						<td width="96%" align="left">
							<font size="3" color="#FFCC66">
								<strong>4.5 Implementar mecanismos de gestión del clima organizacional.</strong>
							</font>						
						</td>
						<td width="2%" align="center">&nbsp; </td>
					</tr>
					<tr>
						<td width="2%" align="center">&nbsp; </td>
						<td width="96%" align="center">&nbsp; </td>
						<td width="2%" align="center">&nbsp; </td>
					</tr>
					<tr>
						<td colspan="3" align="center">
							<table width="85%" cellpadding="0" cellspacing="0" border="2" bordercolor="#FFCC66">
								<tr>
									<td width="40%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>Indicador de desempeño</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>Base</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2009</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2010</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2011</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2012</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2013</strong></font></td>
								</tr>
								<tr>
									<td width="40%" align="center"><div align="justify"><font size="3" color="#FFCC66">Realizar una medición anual de clima laboral</font></div></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=base2008a%></strong></font></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2009a%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2009a%></strong></font></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2010a%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2010a%></strong></font></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2011a%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2011a%></strong></font></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2012a%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2012a%></strong></font></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2013a%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2013a%></strong></font></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td width="2%" align="center">&nbsp; </td>
						<td width="96%" align="center">&nbsp; </td>
						<td width="2%" align="center">&nbsp; </td>
					</tr>
					<tr>
						<td colspan="3" align="center">
							<table width="85%" cellpadding="0" cellspacing="0" border="2" bordercolor="#FFCC66">
								<tr>
									<td width="40%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>Indicador de desempeño</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>Base</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2009</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2010</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2011</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2012</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2013</strong></font></td>
								</tr>
								<tr>
									<td width="40%" align="center"><div align="justify"><font size="3" color="#FFCC66">Porcentaje de ejecución del plan de mejoramiento</font></div></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=base2008b%>%</strong></font></td>
									<%if not esVacio(real_2009b) and not esVacio(estimado_2009b) then 
											if cint(real_2009b) >= cint(estimado_2009b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje de ejecución del plan de mejoramiento es superior al estimado para el año'>"	
											elseif cint(real_2009b) < cint(estimado_2009b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje de ejecución del plan de mejoramiento es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2009b%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2009b%>%</strong></font></td>
									<%if not esVacio(real_2010b) and not esVacio(estimado_2010b) then 
											if cint(real_2010b) >= cint(estimado_2010b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje de ejecución del plan de mejoramiento es superior al estimado para el año'>"	
											elseif cint(real_2010b) < cint(estimado_2010b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje de ejecución del plan de mejoramiento es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									   <td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2010b%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2010b%>%</strong></font></td>
									  <%if not esVacio(real_2011b) and not esVacio(estimado_2011b) then 
											if cint(real_2011b) >= cint(estimado_2011b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje de ejecución del plan de mejoramiento es superior al estimado para el año'>"	
											elseif cint(real_2011b) < cint(estimado_2011b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje de ejecución del plan de mejoramiento es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2011b%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2011b%>%</strong></font></td>
									  <%if not esVacio(real_2012b) and not esVacio(estimado_2012b) then 
											if cint(real_2012b) >= cint(estimado_2012b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje de ejecución del plan de mejoramiento es superior al estimado para el año'>"	
											elseif cint(real_2012b) < cint(estimado_2012b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje de ejecución del plan de mejoramiento es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2012b%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2012b%>%</strong></font></td>
									  <%if not esVacio(real_2013b) and not esVacio(estimado_2013b) then 
											if cint(real_2013b) >= cint(estimado_2013b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje de ejecución del plan de mejoramiento es superior al estimado para el año'>"	
											elseif cint(real_2013b) < cint(estimado_2013b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje de ejecución del plan de mejoramiento es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2013b%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2013b%>%</strong></font></td>
								</tr>
							</table>
						</td>
					</tr>	
					<tr>
						<td width="2%" align="center">&nbsp; </td>
						<td width="96%" align="center">&nbsp; </td>
						<td width="2%" align="center">&nbsp; </td>
					</tr>
					<tr>
						<td colspan="3" align="center">
							<table width="85%" cellpadding="0" cellspacing="0" border="2" bordercolor="#FFCC66">
								<tr>
									<td width="40%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>Indicador de desempeño</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>Base</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2009</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2010</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2011</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2012</strong></font></td>
									<td width="10%" align="center" bgcolor="FFCC66"><font size="3" color="#000000"><strong>2013</strong></font></td>
								</tr>
								<tr>
									<td width="40%" align="center"><div align="justify"><font size="3" color="#FFCC66">Porcentaje de mejoramiento del clima laboral</font></div></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=base2008c%>%</strong></font></td>
									<%if not esVacio(real_2009c) and not esVacio(estimado_2009c) then 
											if cint(real_2009c) >= cint(estimado_2009c) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje de mejoramiento del clima laboral es superior al estimado para el año'>"	
											elseif cint(real_2009c) < cint(estimado_2009c) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje de mejoramiento del clima laboral es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2009c%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2009c%>%</strong></font></td>
									<%if not esVacio(real_2010c) and not esVacio(estimado_2010c) then 
											if cint(real_2010c) >= cint(estimado_2010c) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje de mejoramiento del clima laboral es superior al estimado para el año'>"	
											elseif cint(real_2010c) < cint(estimado_2010c) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje de mejoramiento del clima laboral es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									   <td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2010c%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2010c%>%</strong></font></td>
									  <%if not esVacio(real_2011c) and not esVacio(estimado_2011c) then 
											if cint(real_2011c) >= cint(estimado_2011c) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje de mejoramiento del clima laboral es superior al estimado para el año'>"	
											elseif cint(real_2011c) < cint(estimado_2011c) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje de mejoramiento del clima laboral es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									   <td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2011c%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2011c%>%</strong></font></td>
									  <%if not esVacio(real_2012c) and not esVacio(estimado_2012c) then 
											if cint(real_2012c) >= cint(estimado_2012c) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje de mejoramiento del clima laboral es superior al estimado para el año'>"	
											elseif cint(real_2012c) < cint(estimado_2012c) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje de mejoramiento del clima laboral es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2012c%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2012c%>%</strong></font></td>
									  <%if not esVacio(real_2013c) and not esVacio(estimado_2013c) then 
											if cint(real_2013c) >= cint(estimado_2013c) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje de mejoramiento del clima laboral es superior al estimado para el año'>"	
											elseif cint(real_2013c) < cint(estimado_2013c) then
											  	flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje de mejoramiento del clima laboral es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2013c%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2013c%>%</strong></font></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td width="2%" align="center">&nbsp; </td>
						<td width="96%" align="center">&nbsp; </td>
						<td width="2%" align="center">&nbsp; </td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="3" height="14" width="790">
				<table cellpadding="0" cellspacing="0" width="100%">
					<tr valign="top">
						<td width="4" height="14" background="imagenes/inferiorFondo.png"><img width="4" height="14" src="imagenes/inferior_1.png" border="0"></td>
						<td height="14" background="imagenes/inferiorFondo.png">&nbsp;</td>
						<td width="5" height="14" background="imagenes/inferiorFondo.png"><img width="5" height="14" src="imagenes/inferior_2.png" border="0"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</center>
</body>

</html>
