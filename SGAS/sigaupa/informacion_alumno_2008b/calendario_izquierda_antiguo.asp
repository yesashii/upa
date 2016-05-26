<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
'conexión a servidor de producción consultas que requieran actualización al minuto
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores
 
 set negocio = new CNegocio
 negocio.Inicializa conexion

  q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
  q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
  if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
  end if
  usuario = q_pers_nrut
  nombre_alumno = conexion.consultaUno("Select protic.initcap(pers_tnombre + ' ' + pers_tape_paterno) from personas_postulante where cast(pers_nrut as varchar)='"&usuario&"'")
  pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&usuario&"'")
  'response.Write("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&usuario&"'")
  tiene_foto = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&usuario&"'")
  anio = "2012"
  'response.Write(tienen_foto)
  'response.End()
  if tiene_foto="S" then 
  	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(foto_truta)) from fotos_alumnos where cast(pers_nrut as varchar)='"&usuario&"'")
  else
    nombre_foto = "user.png"
  end if
 
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: white;
}
        .calFondoCalendario {background-color:#84a6d3}
		.calEncabe {font-family:Arial, Helvetica, sans-serif; font-size:11px; color:white}
		.calFondoEncabe {background-color:#4b73a6}
		.calDias {font-family:Arial, Helvetica, sans-serif; font-size:11px; font-weight:900}
		.calSimbolo {font-family:Arial, Helvetica, sans-serif; font-size:13px; text-decoration:none; font-weight:500; color:white}
		.calResaltado {font-family:Arial, Helvetica, sans-serif; font-size:13px; text-decoration:none; font-weight:700}
		.calCeldaResaltado {background-color:lightyellow}
		.calEvaluado {font-family:Arial, Helvetica, sans-serif; font-size:13px; text-decoration:none; font-weight:700; color:white}
		.calCeldaEvaluado {background-color:#e41712}
</style>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
function muestra (dia, mes,anio,codigo)
{
	//alert ("día "+dia+" mes "+mes+" anio "+anio);
	var direccion = "ver_evaluaciones.asp?dia="+ dia+"&mes="+mes+"&anio="+anio+"&codigo="+codigo;
	window.open(direccion,"ventana1","width=310, height=400, scrollbars=no, menubar=no, location=no, resizable=no"); 

}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="270">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="left">
			<table width="270" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="90%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="40%">
									<table width="95%" border="1" align="center" bordercolor="#cccccc">
										<tr valign="middle">
											<td><img width="90" height="98" src="imagenes/alumnos/<%=nombre_foto%>"></td>
										</tr>
									</table>
								</td>
								<td width="60%" align="center">
									<table width="100%">
										<tr><td><font size="3" face="Courier New, Courier, mono" color="#496da6"><strong>Bienvenido</strong></font></td></tr>
										<tr><td><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=nombre_alumno%></font></td></tr>
										<tr><td><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=Date%></font></td></tr>
									</table>
								</td>
								
							</tr>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="left">
			<table width="270" cellpadding="0" cellspacing="0" border="0" bgcolor="#84a6d3">
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="90%" border="0" bgcolor="#84a6d3">
							<tr>
								<td width="100%">
								<%Const URLDestino = "OtraPagina.asp" 
									Dim MyMonth 'Month of calendar
									Dim MyYear 'Year of calendar
									Dim FirstDay 'First day of the month. 1 = Monday
									Dim CurrentDay 'Used to print dates in calendar
									Dim Col 'Calendar column
									Dim Row 'Calendar row
									
									MyMonth = Request.Querystring("Month")
									MyYear = Request.Querystring("Year")
									
									If IsEmpty(MyMonth) then MyMonth = Month(Date)
									if IsEmpty(MyYear) then MyYear = Year(Date)
									
									'invocar a la busqueda de evaluaciones del elaumno apra este año.-
									set f_evaluaciones = new CFormulario
									f_evaluaciones.Carga_Parametros "tabla_vacia.xml", "tabla"
									f_evaluaciones.Inicializar conexion
									consulta =  "  select distinct cali_fevaluacion,datepart(day,cali_fevaluacion) as dia_evaluacion, datepart(month,cali_fevaluacion) as mes_evaluacion, "& vbCrLf &_	
												"  datepart(year,cali_fevaluacion) as anio_evaluacion  "& vbCrLf &_	
												"  from alumnos a, ofertas_academicas b, periodos_academicos c, cargas_academicas d, "& vbCrLf &_	
												"  calificaciones_seccion e "& vbCrLf &_	
											    "  where a.ofer_ncorr=b.ofer_ncorr "& vbCrLf &_	
												"  and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbCrLf &_	
												"  and cast(datepart(month,cali_fevaluacion) as varchar)='"&MyMonth&"' "& vbCrLf &_
												"  and b.peri_ccod=c.peri_ccod and cast(c.anos_ccod as varchar)='"&MyYear&"' "& vbCrLf &_	
											    "  and a.matr_ncorr=d.matr_ncorr and d.secc_ccod=e.secc_ccod "& vbCrLf &_	
												"  order by cali_fevaluacion asc"
									f_evaluaciones.Consultar consulta 
																	
									Call ShowHeader (MyMonth, MyYear)
									
									FirstDay = WeekDay(DateSerial(MyYear, MyMonth, 1)) -1
									CurrentDay = 1
									
									'Let's build the calendar
									For Row = 0 to 5
										For Col = 0 to 6
											If Row = 0 and Col < FirstDay then
												response.write "<td>&nbsp;</td>"
											elseif CurrentDay > LastDay(MyMonth, MyYear) then
												response.write "<td>&nbsp;</td>"
											else
												response.write "<td"
												
												f_evaluaciones.primero
												coincide = 0 ' indica si el dia a dibujar corresponde a un día para evaluar
												while f_evaluaciones.siguiente
													dia_eva  = f_evaluaciones.obtenerValor("dia_evaluacion")
													mes_eva  = f_evaluaciones.obtenerValor("mes_evaluacion")
													anio_eva = f_evaluaciones.obtenerValor("anio_evaluacion")
													if cInt(MyYear) = cInt(anio_eva) and cInt(MyMonth) = cInt(mes_eva) and CurrentDay = Cint(dia_eva) then 
														coincide = 1	
													end if
												wend
												
												if coincide = 1 then
													response.write " class='calCeldaEvaluado' align='center'>"
												else
													if cInt(MyYear) = Year(Date) and cInt(MyMonth) = Month(Date) and CurrentDay = Day(Date) then 
														response.write " class='calCeldaResaltado' align='center'>"
													else 
														response.write " align='center'>"
													end if
												end if 
												if coincide = 1 then
													response.write "<a href='javascript: muestra(" & CurrentDay _
																& "," & MyMonth & "," & MyYear & "," & pers_ncorr & ");'>" 
												end if
												if coincide = 1 then
													Response.Write "<div class='calEvaluado'>" 
												else
													if cInt(MyYear) = Year(Date) and cInt(MyMonth) = Month(Date) and CurrentDay = Day(Date) then 
														Response.Write "<div class='calResaltado'>" 
													else
														Response.Write "<div class='calSimbolo'>" 
													end if
												end if
												Response.Write CurrentDay & "</div>"
												if coincide = 1 then
													Response.Write "</a>"
												end if
												Response.Write "</td>"
												CurrentDay = CurrentDay + 1
											End If
										Next
										response.write "</tr>"
									Next
								    response.write "</table>"%>
								</td>
							</tr>
							<tr><td><font color="#FFFFFF"><strong>* Los números en rojo indican evaluaciones programadas para ese día.</strong></font></td></tr>
						</table>		
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
</table>
</center>
</body>
</html>

<%Sub ShowHeader(MyMonth,MyYear)
%>
<table border='1' cellspacing='3' cellpadding='3' width='230' align='center' class="calFondoCalendario" bordercolor="#FFFFFF">
	<tr align='center'> 
		<td colspan='7'>
			<table border='0' cellspacing='1' cellpadding='1' width='100%' class="calFondoEncabe">
				<tr valign="TOP">
					<td align='left' valign="middle">
						<%
						response.write "<a href = 'calendario_izquierda.asp?"
						if MyMonth - 1 = 0 then 
							response.write "month=12&year=" & MyYear -1
						else 
							response.write "month=" & MyMonth - 1 & "&year=" & MyYear
						end if
						response.write "'><span class='calSimbolo'><img width='22' height='22' src='imagenes/anterior_cal.jpg' border='0'></span></a>"

						response.write "<span class='calEncabe'> " & MonthName(MyMonth) & " </span>"

						response.write "<a href = 'calendario_izquierda.asp?"
						if MyMonth + 1 = 13 then 
							response.write "month=1&year=" & MyYear + 1
						else 
							response.write "month=" & MyMonth + 1 & "&year=" & MyYear
						end if
						response.write "'><span class='calSimbolo'><img width='22' height='22' src='imagenes/siguiente_cal.jpg' border='0'></span></a>"
						%>
					</td>
					<td align='center'>
						<%
						response.write "<a href = 'calendario_izquierda.asp?"
						response.write "month=" & Month(Date()) & "&year=" & Year(Date())
						response.write "'><div class='calSimbolo'>Atención</div></a>"
						%>						
					</td>
					<td align='right'>
						<%
						response.write "<a href = 'calendario_izquierda.asp?"
						response.write "month=" & MyMonth & "&year=" & MyYear -1
						response.write "'><span class='calSimbolo'><img width='22' height='22' src='imagenes/anterior_cal.jpg' border='0'></span></a>"

						response.write "<span class='calEncabe'> " & MyYear & " </span>"
						response.write "<a href = 'calendario_izquierda.asp?"
						response.write "month=" & MyMonth & "&year=" & MyYear + 1
						response.write "'><span class='calSimbolo'><img width='22' height='22' src='imagenes/siguiente_cal.jpg' border='0'></span></a>"
						%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr align='center'> 
		<td bgcolor="#4b73a6"><div class='calDias'>Do</div></td>
		<td bgcolor="#4b73a6"><div class='calDias'>Lu</div></td>
		<td bgcolor="#4b73a6"><div class='calDias'>Ma</div></td>
		<td bgcolor="#4b73a6"><div class='calDias'>Mi</div></td>
		<td bgcolor="#4b73a6"><div class='calDias'>Ju</div></td>
		<td bgcolor="#4b73a6"><div class='calDias'>Vi</div></td>
		<td bgcolor="#4b73a6"><div class='calDias'>Sa</div></td>
	</tr>
<%
End Sub

Function MonthName(MyMonth)
	Select Case MyMonth
		Case 1
			MonthName = "Enero"
		Case 2
			MonthName = "Febr."
		Case 3
			MonthName = "Marzo"
		Case 4
			MonthName = "Abril"
		Case 5
			MonthName = "Mayo"
		Case 6
			MonthName = "Junio"
		Case 7
			MonthName = "Julio"
		Case 8
			MonthName = "Ago."
		Case 9
			MonthName = "Sept."
		Case 10
			MonthName = "Oct."
		Case 11
			MonthName = "Nov."
		Case 12
			MonthName = "Dic."
		Case Else
			MonthName = "ERROR!"
	End Select
End Function

Function LastDay(MyMonth, MyYear)
' Returns the last day of the month. Takes into account leap years
' Usage: LastDay(Month, Year)
' Example: LastDay(12,2000) or LastDay(12) or Lastday


	Select Case MyMonth
		Case 1, 3, 5, 7, 8, 10, 12
			LastDay = 31

		Case 4, 6, 9, 11
			LastDay = 30

		Case 2
			If IsDate(MyYear & "-" & MyMonth & "-" & "29") Then LastDay = 29 Else LastDay = 28

		Case Else
			LastDay = 0
	End Select
End Function
%>
