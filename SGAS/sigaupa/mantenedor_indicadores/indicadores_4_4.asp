<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new cPagina
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
'set negocio = new CNegocio
'negocio.Inicializa conexion

'Buscamos los datos pertenecientes al cuadro 4.4a
estimado_2009a = conexion.consultaUno("select sum(indi_4_4_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2009'")
estimado_2010a = conexion.consultaUno("select sum(indi_4_4_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2010'")
estimado_2011a = conexion.consultaUno("select sum(indi_4_4_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2011'")
estimado_2012a = conexion.consultaUno("select sum(indi_4_4_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2012'")
estimado_2013a = conexion.consultaUno("select sum(indi_4_4_a) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2013'")

base2008a = conexion.consultaUno("select sum(indi_4_4_a) from mantenedor_dato_base_anual")

real_2009a = conexion.consultaUno("select sum(indi_4_4_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2009'")
real_2010a = conexion.consultaUno("select sum(indi_4_4_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2010'")
real_2011a = conexion.consultaUno("select sum(indi_4_4_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2011'")
real_2012a = conexion.consultaUno("select sum(indi_4_4_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2012'")
real_2013a = conexion.consultaUno("select sum(indi_4_4_a) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2013'")

'Buscamos los datos pertenecientes al cuadro 4.4b
estimado_2009b = conexion.consultaUno("select sum(indi_4_4_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2009'")
estimado_2010b = conexion.consultaUno("select sum(indi_4_4_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2010'")
estimado_2011b = conexion.consultaUno("select sum(indi_4_4_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2011'")
estimado_2012b = conexion.consultaUno("select sum(indi_4_4_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2012'")
estimado_2013b = conexion.consultaUno("select sum(indi_4_4_b) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2013'")

base2008b = conexion.consultaUno("select sum(indi_4_4_b) from mantenedor_dato_base_anual")

real_2009b = conexion.consultaUno("select sum(indi_4_4_b) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2009'")
real_2010b = conexion.consultaUno("select sum(indi_4_4_b) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2010'")
real_2011b = conexion.consultaUno("select sum(indi_4_4_b) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2011'")
real_2012b = conexion.consultaUno("select sum(indi_4_4_b) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2012'")
real_2013b = conexion.consultaUno("select sum(indi_4_4_b) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2013'")

'Buscamos los datos pertenecientes al cuadro 4.4c
estimado_2009c = conexion.consultaUno("select sum(indi_4_4_c) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2009'")
estimado_2010c = conexion.consultaUno("select sum(indi_4_4_c) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2010'")
estimado_2011c = conexion.consultaUno("select sum(indi_4_4_c) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2011'")
estimado_2012c = conexion.consultaUno("select sum(indi_4_4_c) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2012'")
estimado_2013c = conexion.consultaUno("select sum(indi_4_4_c) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2013'")

base2008c = conexion.consultaUno("select sum(indi_4_4_c) from mantenedor_dato_base_anual")

real_2009c = conexion.consultaUno("select sum(indi_4_4_c) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2009'")
real_2010c = conexion.consultaUno("select sum(indi_4_4_c) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2010'")
real_2011c = conexion.consultaUno("select sum(indi_4_4_c) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2011'")
real_2012c = conexion.consultaUno("select sum(indi_4_4_c) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2012'")
real_2013c = conexion.consultaUno("select sum(indi_4_4_c) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2013'")

'Buscamos los datos pertenecientes al cuadro 4.4d
estimado_2009d = conexion.consultaUno("select sum(indi_4_4_d) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2009'")
estimado_2010d = conexion.consultaUno("select sum(indi_4_4_d) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2010'")
estimado_2011d = conexion.consultaUno("select sum(indi_4_4_d) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2011'")
estimado_2012d = conexion.consultaUno("select sum(indi_4_4_d) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2012'")
estimado_2013d = conexion.consultaUno("select sum(indi_4_4_d) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2013'")

base2008d = conexion.consultaUno("select sum(indi_4_4_d) from mantenedor_dato_base_anual")

real_2009d = conexion.consultaUno("select sum(indi_4_4_d) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2009'")
real_2010d = conexion.consultaUno("select sum(indi_4_4_d) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2010'")
real_2011d = conexion.consultaUno("select sum(indi_4_4_d) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2011'")
real_2012d = conexion.consultaUno("select sum(indi_4_4_d) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2012'")
real_2013d = conexion.consultaUno("select sum(indi_4_4_d) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2013'")

'Buscamos los datos pertenecientes al cuadro 4.4e
estimado_2009e = conexion.consultaUno("select sum(indi_4_4_e) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2009'")
estimado_2010e = conexion.consultaUno("select sum(indi_4_4_e) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2010'")
estimado_2011e = conexion.consultaUno("select sum(indi_4_4_e) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2011'")
estimado_2012e = conexion.consultaUno("select sum(indi_4_4_e) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2012'")
estimado_2013e = conexion.consultaUno("select sum(indi_4_4_e) from mantenedor_dato_estimativo_anual where cast(anos_ccod as varchar)='2013'")

base2008e = conexion.consultaUno("select sum(indi_4_4_e) from mantenedor_dato_base_anual")

real_2009e = conexion.consultaUno("select sum(indi_4_4_e) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2009'")
real_2010e = conexion.consultaUno("select sum(indi_4_4_e) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2010'")
real_2011e = conexion.consultaUno("select sum(indi_4_4_e) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2011'")
real_2012e = conexion.consultaUno("select sum(indi_4_4_e) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2012'")
real_2013e = conexion.consultaUno("select sum(indi_4_4_e) from mantenedor_dato_real_anual where cast(anos_ccod as varchar)='2013'")
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
								<strong>4.4 Implementar un sistema de capacitación del personal.</strong>
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
									<td width="40%" align="center"><div align="justify"><font size="3" color="#FFCC66">N° de programas corporativos de capacitación anual</font></div></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=base2008a%></strong></font></td>
									<%if not esVacio(real_2009a) and not esVacio(estimado_2009a) then 
											if cint(real_2009a) >= cint(estimado_2009a) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de programas corporativos de capacitación anual es superior al estimado para el año'>"	
											elseif cint(real_2009a) < cint(estimado_2009a) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de programas corporativos de capacitación anual es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2009a%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2009a%></strong></font></td>
									<%if not esVacio(real_2010a) and not esVacio(estimado_2010a) then 
											if cint(real_2010a) >= cint(estimado_2010a) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de programas corporativos de capacitación anual es superior al estimado para el año'>"	
											elseif cint(real_2010a) < cint(estimado_2010a) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de programas corporativos de capacitación anual es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2010a%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2010a%></strong></font></td>
									  <%if not esVacio(real_2011a) and not esVacio(estimado_2011a) then 
											if cint(real_2011a) >= cint(estimado_2011a) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de programas corporativos de capacitación anual es superior al estimado para el año'>"	
											elseif cint(real_2011a) < cint(estimado_2011a) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de programas corporativos de capacitación anual es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2011a%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2011a%></strong></font></td>
									  <%if not esVacio(real_2012a) and not esVacio(estimado_2012a) then 
											if cint(real_2012a) >= cint(estimado_2012a) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de programas corporativos de capacitación anual es superior al estimado para el año'>"	
											elseif cint(real_2012a) < cint(estimado_2012a) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de programas corporativos de capacitación anual es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2012a%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2012a%></strong></font></td>
									  <%if not esVacio(real_2013a) and not esVacio(estimado_2013a) then 
											if cint(real_2013a) >= cint(estimado_2013a) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de programas corporativos de capacitación anual es superior al estimado para el año'>"	
											elseif cint(real_2013a) < cint(estimado_2013a) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de programas corporativos de capacitación anual es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
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
									<td width="40%" align="center"><div align="justify"><font size="3" color="#FFCC66">N° de empleados capacitados</font></div></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=base2008b%></strong></font></td>
									<%if not esVacio(real_2009b) and not esVacio(estimado_2009b) then 
											if cint(real_2009b) >= cint(estimado_2009b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de empleados capacitados es superior al estimado para el año'>"	
											elseif cint(real_2009b) < cint(estimado_2009b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de empleados capacitados es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2009b%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2009b%></strong></font></td>
									<%if not esVacio(real_2010b) and not esVacio(estimado_2010b) then 
											if cint(real_2010b) >= cint(estimado_2010b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de empleados capacitados es superior al estimado para el año'>"	
											elseif cint(real_2010b) < cint(estimado_2010b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de empleados capacitados es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									   <td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2010b%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2010b%></strong></font></td>
									  <%if not esVacio(real_2011b) and not esVacio(estimado_2011b) then 
											if cint(real_2011b) >= cint(estimado_2011b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de empleados capacitados es superior al estimado para el año'>"	
											elseif cint(real_2011b) < cint(estimado_2011b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de empleados capacitados es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2011b%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2011b%></strong></font></td>
									  <%if not esVacio(real_2012b) and not esVacio(estimado_2012b) then 
											if cint(real_2012b) >= cint(estimado_2012b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de empleados capacitados es superior al estimado para el año'>"	
											elseif cint(real_2012b) < cint(estimado_2012b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de empleados capacitados es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2012b%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2012b%></strong></font></td>
									  <%if not esVacio(real_2013b) and not esVacio(estimado_2013b) then 
											if cint(real_2013b) >= cint(estimado_2013b) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de empleados capacitados es superior al estimado para el año'>"	
											elseif cint(real_2013b) < cint(estimado_2013b) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de empleados capacitados es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2013b%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2013b%></strong></font></td>
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
									<td width="40%" align="center"><div align="justify"><font size="3" color="#FFCC66">N° de horas dedicadas a la capacitación</font></div></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=base2008c%></strong></font></td>
									<%if not esVacio(real_2009c) and not esVacio(estimado_2009c) then 
											if cint(real_2009c) >= cint(estimado_2009c) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de horas dedicadas a la capacitación es superior al estimado para el año'>"	
											elseif cint(real_2009c) < cint(estimado_2009c) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de horas dedicadas a la capacitación es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2009c%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2009c%></strong></font></td>
									<%if not esVacio(real_2010c) and not esVacio(estimado_2010c) then 
											if cint(real_2010c) >= cint(estimado_2010c) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de horas dedicadas a la capacitación es superior al estimado para el año'>"	
											elseif cint(real_2010c) < cint(estimado_2010c) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de horas dedicadas a la capacitación es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									   <td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2010c%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2010c%></strong></font></td>
									  <%if not esVacio(real_2011c) and not esVacio(estimado_2011c) then 
											if cint(real_2011c) >= cint(estimado_2011c) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de horas dedicadas a la capacitación es superior al estimado para el año'>"	
											elseif cint(real_2011c) < cint(estimado_2011c) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de horas dedicadas a la capacitación es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									   <td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2011c%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2011c%></strong></font></td>
									  <%if not esVacio(real_2012c) and not esVacio(estimado_2012c) then 
											if cint(real_2012c) >= cint(estimado_2012c) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de horas dedicadas a la capacitación es superior al estimado para el año'>"	
											elseif cint(real_2012c) < cint(estimado_2012c) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de horas dedicadas a la capacitación es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2012c%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2012c%></strong></font></td>
									  <%if not esVacio(real_2013c) and not esVacio(estimado_2013c) then 
											if cint(real_2013c) >= cint(estimado_2013c) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El N° de horas dedicadas a la capacitación es superior al estimado para el año'>"	
											elseif cint(real_2013c) < cint(estimado_2013c) then
											  	flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El N° de horas dedicadas a la capacitación es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2013c%><hr><%=flecha%>&nbsp;&nbsp;<%=real_2013c%></strong></font></td>
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
									<td width="40%" align="center"><div align="justify"><font size="3" color="#FFCC66">Porcentaje renta imponible del personal destinado para su desarrollo, perfeccionamiento y capacitación</font></div></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=base2008d%>%</strong></font></td>
									<%if not esVacio(real_2009d) and not esVacio(estimado_2009d) then 
											if cint(real_2009d) >= cint(estimado_2009d) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje renta imponible del personal destinado para su desarrollo, perfeccionamiento y capacitación es superior al estimado para el año'>"	
											elseif cint(real_2009d) < cint(estimado_2009d) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje renta imponible del personal destinado para su desarrollo, perfeccionamiento y capacitación es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2009d%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2009d%>%</strong></font></td>
									<%if not esVacio(real_2010d) and not esVacio(estimado_2010d) then 
											if cint(real_2010d) >= cint(estimado_2010d) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje renta imponible del personal destinado para su desarrollo, perfeccionamiento y capacitación es superior al estimado para el año'>"	
											elseif cint(real_2010d) < cint(estimado_2010d) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje renta imponible del personal destinado para su desarrollo, perfeccionamiento y capacitación es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									   <td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2010d%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2010d%>%</strong></font></td>
									  <%if not esVacio(real_2011d) and not esVacio(estimado_2011d) then 
											if cint(real_2011d) >= cint(estimado_2011d) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje renta imponible del personal destinado para su desarrollo, perfeccionamiento y capacitación es superior al estimado para el año'>"	
											elseif cint(real_2011d) < cint(estimado_2011d) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje renta imponible del personal destinado para su desarrollo, perfeccionamiento y capacitación es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									   <td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2011d%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2011d%>%</strong></font></td>
									  <%if not esVacio(real_2012d) and not esVacio(estimado_2012d) then 
											if cint(real_2012d) >= cint(estimado_2012d) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje renta imponible del personal destinado para su desarrollo, perfeccionamiento y capacitación es superior al estimado para el año'>"	
											elseif cint(real_2012d) < cint(estimado_2012d) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje renta imponible del personal destinado para su desarrollo, perfeccionamiento y capacitación es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2012d%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2012d%>%</strong></font></td>
									  <%if not esVacio(real_2013d) and not esVacio(estimado_2013d) then 
											if cint(real_2013d) >= cint(estimado_2013d) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='El Porcentaje renta imponible del personal destinado para su desarrollo, perfeccionamiento y capacitación es superior al estimado para el año'>"	
											elseif cint(real_2013d) < cint(estimado_2013d) then
											  	flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='El Porcentaje renta imponible del personal destinado para su desarrollo, perfeccionamiento y capacitación es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong><%=estimado_2013d%>%<hr><%=flecha%>&nbsp;&nbsp;<%=real_2013d%>%</strong></font></td>
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
									<td width="40%" align="center"><div align="justify"><font size="3" color="#FFCC66">Inversión total en desarrollo, perfeccionamiento y capacitación por empleado</font></div></td>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong>$<%=base2008e%> por persona</strong></font></td>
									<%if not esVacio(real_2009e) and not esVacio(estimado_2009e) then 
											if cdbl(real_2009e) >= cdbl(estimado_2009e) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='La Inversión total en desarrollo, perfeccionamiento y capacitación por empleado es superior al estimado para el año'>"	
											elseif cdbl(real_2009e) < cdbl(estimado_2009e) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='La Inversión total en desarrollo, perfeccionamiento y capacitación por empleado es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong>$<%=estimado_2009e%> por persona<hr><%=flecha%>&nbsp;&nbsp;$<%=real_2009e%> por persona</strong></font></td>
									<%if not esVacio(real_2010e) and not esVacio(estimado_2010e) then 
											if cdbl(real_2010e) >= cdbl(estimado_2010e) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='La Inversión total en desarrollo, perfeccionamiento y capacitación por empleado es superior al estimado para el año'>"	
											elseif cdbl(real_2010e) < cdbl(estimado_2010e) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='La Inversión total en desarrollo, perfeccionamiento y capacitación por empleado es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									   <td width="10%" align="center"><font size="3" color="#FFCC66"><strong>$<%=estimado_2010e%> por persona<hr><%=flecha%>&nbsp;&nbsp;$<%=real_2010e%> por persona</strong></font></td>
									  <%if not esVacio(real_2011e) and not esVacio(estimado_2011e) then 
											if cdbl(real_2011e) >= cdbl(estimado_2011e) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='La Inversión total en desarrollo, perfeccionamiento y capacitación por empleado es superior al estimado para el año'>"	
											elseif cdbl(real_2011e) < cdbl(estimado_2011e) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='La Inversión total en desarrollo, perfeccionamiento y capacitación por empleado es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									   <td width="10%" align="center"><font size="3" color="#FFCC66"><strong>$<%=estimado_2011e%> por persona<hr><%=flecha%>&nbsp;&nbsp;$<%=real_2011e%> por persona</strong></font></td>
									  <%if not esVacio(real_2012e) and not esVacio(estimado_2012e) then 
											if cdbl(real_2012e) >= cdbl(estimado_2012e) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='La Inversión total en desarrollo, perfeccionamiento y capacitación por empleado es superior al estimado para el año'>"	
											elseif cdbl(real_2012e) < cdbl(estimado_2012e) then
											  flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='La Inversión total en desarrollo, perfeccionamiento y capacitación por empleado es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong>$<%=estimado_2012e%> por persona<hr><%=flecha%>&nbsp;&nbsp;$<%=real_2012e%> por persona</strong></font></td>
									  <%if not esVacio(real_2013e) and not esVacio(estimado_2013e) then 
											if cdbl(real_2013e) >= cdbl(estimado_2013e) then 
											  flecha = "<img width='10' height='10' src='imagenes/verde_arriba.gif' border='0' title='La Inversión total en desarrollo, perfeccionamiento y capacitación por empleado es superior al estimado para el año'>"	
											elseif cdbl(real_2013e) < cdbl(estimado_2013e) then
											  	flecha = "<img width='10' height='10' src='imagenes/roja_abajo.gif' border='0' title='La Inversión total en desarrollo, perfeccionamiento y capacitación por empleado es inferior al estimado para el año'>"	  
											else 
												flecha = "--"
											end if
									   else
									   		flecha = "--"	
									   end if  %>
									<td width="10%" align="center"><font size="3" color="#FFCC66"><strong>$<%=estimado_2013e%> por persona<hr><%=flecha%>&nbsp;&nbsp;$<%=real_2013e%> por persona</strong></font></td>
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
