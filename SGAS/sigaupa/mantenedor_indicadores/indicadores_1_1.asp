<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new cPagina
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
'set negocio = new CNegocio
'negocio.Inicializa conexion

'Buscamos los datos pertenecientes al cuadro 1.1a
estimado_2009a = conexion.consultaUno("select sum(indi_1_1_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2009'")
estimado_2010a = conexion.consultaUno("select sum(indi_1_1_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2010'")
estimado_2011a = conexion.consultaUno("select sum(indi_1_1_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2011'")
estimado_2012a = conexion.consultaUno("select sum(indi_1_1_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2012'")
estimado_2013a = conexion.consultaUno("select sum(indi_1_1_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2013'")

base2008a = conexion.consultaUno("select sum(indi_1_1_a) from mantenedor_dato_base_anual")

real_2009a = conexion.consultaUno("select sum(indi_1_1_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2009'")
real_2010a = conexion.consultaUno("select sum(indi_1_1_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2010'")
real_2011a = conexion.consultaUno("select sum(indi_1_1_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2011'")
real_2012a = conexion.consultaUno("select sum(indi_1_1_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2012'")
real_2013a = conexion.consultaUno("select sum(indi_1_1_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2013'")

'Buscamos los datos pertenecientes al cuadro 1.1b
estimado_2009b = conexion.consultaUno("select sum(indi_1_1_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2009'")
estimado_2010b = conexion.consultaUno("select sum(indi_1_1_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2010'")
estimado_2011b = conexion.consultaUno("select sum(indi_1_1_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2011'")
estimado_2012b = conexion.consultaUno("select sum(indi_1_1_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2012'")
estimado_2013b = conexion.consultaUno("select sum(indi_1_1_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2013'")

base2008b = "10"'conexion.consultaUno("select cast(avg(indi_1_1_b) as decimal(3,0)) from mantenedor_dato_base_escuela where isnull(indi_1_1_b,0) <> 0")

real_2009b = conexion.consultaUno("select cast(avg(indi_1_1_b) as decimal(3,0)) from mantenedor_dato_real_escuela where cast(anos_ccod as varchar)='2009' and isnull(indi_1_1_b,0) <> 0")
real_2010b = conexion.consultaUno("select cast(avg(indi_1_1_b) as decimal(3,0)) from mantenedor_dato_real_escuela where cast(anos_ccod as varchar)='2010' and isnull(indi_1_1_b,0) <> 0")
real_2011b = conexion.consultaUno("select cast(avg(indi_1_1_b) as decimal(3,0)) from mantenedor_dato_real_escuela where cast(anos_ccod as varchar)='2011' and isnull(indi_1_1_b,0) <> 0")
real_2012b = conexion.consultaUno("select cast(avg(indi_1_1_b) as decimal(3,0)) from mantenedor_dato_real_escuela where cast(anos_ccod as varchar)='2012' and isnull(indi_1_1_b,0) <> 0")
real_2013b = conexion.consultaUno("select cast(avg(indi_1_1_b) as decimal(3,0)) from mantenedor_dato_real_escuela where cast(anos_ccod as varchar)='2013' and isnull(indi_1_1_b,0) <> 0")


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
								<strong>1.	Posicionar un modelo educativo que articule una comunidad de aprendizaje en un proceso continuo de evaluación y aseguramiento de calidad.</strong>
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
								<strong>1.1 Desarrollar un modelo educativo que reconozca el perfil de ingreso del alumno, apoye su formación integral e incorpore la cultura organizacional de la Universidad del Pacífico</strong>
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
									<td width="40%" align="center"><div align="justify"><font size="3" color="#FFCC66">(Número de alumnos 1er. Año en Programa de Apoyo y Seguimiento)/(Número total de alumnos de 1er. Año)</font></div></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=base2008a%>%</strong></font></td>
									<%if not esVacio(real_2009a) and not esVacio(estimado_2009a) then 
											if cint(real_2009a) >= cint(estimado_2009a) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El número de alumnos en programa de Apoyo es superior al estimado para el año'>"	
											elseif cint(real_2009a) < cint(estimado_2009a) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El número de alumnos en programa de Apoyo es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2009a%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2009a%>%</strong></font></td>
									<%if not esVacio(real_2010a) and not esVacio(estimado_2010a) then 
											if cint(real_2010a) >= cint(estimado_2010a) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El número de alumnos en programa de Apoyo es superior al estimado para el año'>"	
											elseif cint(real_2010a) < cint(estimado_2010a) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El número de alumnos en programa de Apoyo es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2010a%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2010a%>%</strong></font></td>
									  <%if not esVacio(real_2011a) and not esVacio(estimado_2011a) then 
											if cint(real_2011a) >= cint(estimado_2011a) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El número de alumnos en programa de Apoyo es superior al estimado para el año'>"	
											elseif cint(real_2011a) < cint(estimado_2011a) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El número de alumnos en programa de Apoyo es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2011a%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2011a%>%</strong></font></td>
									   <%if not esVacio(real_2012a) and not esVacio(estimado_2012a) then 
											if cint(real_2012a) >= cint(estimado_2012a) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El número de alumnos en programa de Apoyo es superior al estimado para el año'>"	
											elseif cint(real_2012a) < cint(estimado_2012a) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El número de alumnos en programa de Apoyo es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>	
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2012a%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2012a%>%</strong></font></td>
									  <%if not esVacio(real_2013a) and not esVacio(estimado_2013a) then 
											if cint(real_2013a) >= cint(estimado_2013a) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El número de alumnos en programa de Apoyo es superior al estimado para el año'>"	
											elseif cint(real_2013a) < cint(estimado_2013a) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El número de alumnos en programa de Apoyo es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2013a%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2013a%>%</strong></font></td>
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
							<table width="85%" cellpadding="0" cellspacing="0" border="2" bordercolor="#d45502">
								<tr>
									<td width="40%" align="center" bgcolor="d45502"><font size="3" color="#000000"><strong>Indicador de desempeño</strong></font></td>
									<td width="10%" align="center" bgcolor="d45502"><font size="3" color="#000000"><strong>Base</strong></font></td>
									<td width="10%" align="center" bgcolor="d45502"><font size="3" color="#000000"><strong>2009</strong></font></td>
									<td width="10%" align="center" bgcolor="d45502"><font size="3" color="#000000"><strong>2010</strong></font></td>
									<td width="10%" align="center" bgcolor="d45502"><font size="3" color="#000000"><strong>2011</strong></font></td>
									<td width="10%" align="center" bgcolor="d45502"><font size="3" color="#000000"><strong>2012</strong></font></td>
									<td width="10%" align="center" bgcolor="d45502"><font size="3" color="#000000"><strong>2013</strong></font></td>
								</tr>
								<tr>
									<td width="40%" align="center"><div align="justify"><font size="3" color="#d45502">(Número de alumnos participantes en Programa de Formación General Optativa)/(Número total de alumnos)</font></div></td>
									<td width="10%" align="center"><font size="3" color="#d45502"><strong><%=base2008b%>%</strong></font></td>
									  <%if not esVacio(real_2009b) and not esVacio(estimado_2009b) then 
											if cint(real_2009b) >= cint(estimado_2009b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El número de alumnos en programa de Formación General Optativa es superior al estimado para el año'>"	
											elseif cint(real_2009b) < cint(estimado_2009b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El número de alumnos en programa de Formación General Optativa es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#d45502"><strong><%=estimado_2009b%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2009b%>%</strong></font></td>
									  <%if not esVacio(real_2010b) and not esVacio(estimado_2010b) then 
											if cint(real_2010b) >= cint(estimado_2010b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El número de alumnos en programa de Formación General Optativa es superior al estimado para el año'>"	
											elseif cint(real_2010b) < cint(estimado_2010b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El número de alumnos en programa de Formación General Optativa es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>									
									<td width="10%" align="center"><font size="3" color="#d45502"><strong><%=estimado_2010b%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2010b%>%</strong></font></td>
									  <%if not esVacio(real_2011b) and not esVacio(estimado_2011b) then 
											if cint(real_2011b) >= cint(estimado_2011b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El número de alumnos en programa de Formación General Optativa es superior al estimado para el año'>"	
											elseif cint(real_2011b) < cint(estimado_2011b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El número de alumnos en programa de Formación General Optativa es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>									
									<td width="10%" align="center"><font size="3" color="#d45502"><strong><%=estimado_2011b%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2011b%>%</strong></font></td>
									  <%if not esVacio(real_2012b) and not esVacio(estimado_2012b) then 
											if cint(real_2012b) >= cint(estimado_2012b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El número de alumnos en programa de Formación General Optativa es superior al estimado para el año'>"	
											elseif cint(real_2012b) < cint(estimado_2012b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El número de alumnos en programa de Formación General Optativa es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>									
									<td width="10%" align="center"><font size="3" color="#d45502"><strong><%=estimado_2012b%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2012b%>%</strong></font></td>
									  <%if not esVacio(real_2013b) and not esVacio(estimado_2013b) then 
											if cint(real_2013b) >= cint(estimado_2013b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El número de alumnos en programa de Formación General Optativa es superior al estimado para el año'>"	
											elseif cint(real_2013b) < cint(estimado_2013b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El número de alumnos en programa de Formación General Optativa es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>									
									<td width="10%" align="center"><font size="3" color="#d45502"><strong><%=estimado_2013b%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2013b%>%</strong></font></td>
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
