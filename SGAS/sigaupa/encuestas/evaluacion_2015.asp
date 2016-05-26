<!-- #include file = "evaluacion_2015_proc.asp" -->

<%
'---------------------------------------------------------------------------------------------------

Set encuesta_controlador = new controlador_encuesta

set pagina = new CPagina
pagina.Titulo = "Resumen Evaluacion"


if encuesta_controlador.esDocente() then
	srut = encuesta_controlador.Usuario()
	peri_ccod = request.Form("periodo")
	
else
	srut = request.Form("rut")
	peri_ccod = request.Form("periodo")

end if
if srut <> "" AND peri_ccod <> "" then
	valores = encuesta_controlador.valores(srut)
	pers_ncorr1 = valores(0)
	personas = encuesta_controlador.obtener_persona(pers_ncorr1)
	nombre1 = personas(1)
	rut =personas(0)

	eva_auto = encuesta_controlador.promedio_autoevaluacion(pers_ncorr1, peri_ccod)
	eva_alum = encuesta_controlador.promedio_alumno(pers_ncorr1, peri_ccod)
	eva_dire = encuesta_controlador.promedio_director(pers_ncorr1, peri_ccod)
	carreras = encuesta_controlador.obtener_asignatura(pers_ncorr1, peri_ccod)
	periodo = peri_ccod
	
	promedio_final= round((cint(eva_auto)/10*0.2)+(cint(eva_alum)/10*0.5)+(cint(eva_dire)/10*0.3),1)
	
	obs = encuesta_controlador.obtener_observaciones_alumnos(srut)
	auto_obs = encuesta_controlador.obtener_observaciones_propias(srut)
else
	if srut<> "" AND peri_ccod= "" then
		valores = encuesta_controlador.valores(srut)
		pers_ncorr1 = valores(0)
		personas = encuesta_controlador.obtener_persona(pers_ncorr1)
		nombre1 = personas(1)
		rut =personas(0)
	end if
end if




%>
<html>
<head>
<title><% response.write pagina.Titulo %></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script>
	function goBack() {
		window.history.back();
	}
	function Abrir() {
		url = "evaluacion_2015_imprimible.asp?rut=<%=srut%>&periodo=<%=peri_ccod%>";
		window.open(url,'_blank');
	}
	
	function Validar()
	{
		formulario = document.buscador;
		
		srut = document.getElementById["rut"].value + "-" + document.getElementById["digito"].value;	
		if (document.getElementById["rut"].value  != '')
		{
			if (!valida_rut(rut_alumno)) {
				alert('Ingrese un RUT válido.');
				document.getElementById["rut"].focus();
				document.getElementById["digito"].select();
				return false;
			}
		}
		
		return true;
	}
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
    <td height="65"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
		  <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>          
          <tr>
            <td>
				<div align="center"><br>
					<%pagina.DibujarTituloPagina%><br><br>
					<h4>ENCUESTA DOCENTE A PARTIR DEL 2015</h4><br>
				</div> 
				<% if rut <> "" AND peri_ccod <> "" then %>
				<table>
					<tr>
						<td><strong>Nombre</strong></td>
						<td>:</td>
						<td><% response.write nombre1%></td>
					</tr>
					<tr>
						<td><strong>Rut</strong></td>
						<td>:</td>
						<td><% response.write rut%></td>
					</tr>
					<tr>
						<td><strong>Carreras</strong></td>
						<td>:</td>
						<td>
							<table>
								<% for each carrera IN carreras %>
									<tr><td> <% response.write carrera %></td></tr>
								<% next %>
							</table>
						</td>
					</tr>
				</table>
				<br>
				<center><h4>Rango de la escala es de 1 al 4</h4></center>
				<table>
					<tr>
						<td>Evaluación del Director</td>
						<td>:</td>
						<td><% response.write eva_dire %></td>
					</tr>
					<tr>
						<td>Evaluación en el Cuestionario estudiantil</td>
						<td>:</td>
						<td><% response.write eva_alum %></td>
					</tr>
					<tr>
						<td>Auto-Evaluación docente</td>
						<td>:</td>
						<td><% response.write eva_auto %></td>
					</tr>
				</table>
				<center><h5>Nota Final <% response.write promedio_final %></h5></center>
				
				<br><br>
				<%
					'<table width="100%">
					'	<tr>
					'		<td align="center"><strong>OBSERVACIONES DE LOS ALUMNOS</strong></td>
					'		<td align="center"><strong>AUTO OBSERVACIONES</strong></td>
					'	</tr>
					'	<tr>
					'		<td><div style="width: 350px; padding-right:7px; height: 200px; overflow-y: scroll; text-align: justify; white-space: normal;"> response.write obs </div></td>
					'		<td><div style="width: 350px; height: 200px; overflow-y: scroll; text-align: justify; white-space: normal;"> response.write auto_obs </div></td>
					'	</tr>
					'</table>
				%>
				<% else %>
				<table>
					<form name="buscador" method="post">
						<tr>
							<%
							if encuesta_controlador.esDocente() then
							%>
									<td><strong>Nombre</strong></td>
									<td>:</td>
									<td><% response.write nombre1%></td>
								</tr>
								<tr>
									<td><strong>Rut</strong></td>
									<td>:</td>
									<td><% response.write rut%>
									<input type="submit" value="Buscar">
									</td>
								</tr>
							<%
							else 
							%>
									<td><strong>Rut</strong></td>
									<td>:</td>
									<td>
										<input type="text" name="rut" id="rut">-<input type="text" name="digito" id="digito" maxlength="1" size="1">
											<a href="javascript:buscar_persona('rut', 'digito');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a>
										<input type="submit" value="Buscar">
									</td>
							<%
							end if
							%>
						</tr>
						<tr>
							<td><strong>Periodo</strong></td>
							<td>:</td>
							<td>
								<select name="periodo" id="periodo">
									<% 
									periodos = encuesta_controlador.obtener_periodo()

									for i=0 to UBOUND(periodos) %>
									<option value="<%=periodos(i,0)%>"><%=periodos(i,1)%></option>
									<% next %>
								</select>
							</td>
						
						</tr>
					</form>
				</table>
				<% end if %>
            </td></tr>            
      </table>	
<br>	  
        </td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="32%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td width="55%">
							<div align="center">
								<input type="button" value="salir" onClick="goBack()">
								<% if rut <> "" AND peri_ccod <> "" then %>
								<input type="button" value="Version Completa" onClick="Abrir()">
								<% end if %>
							</div>
						</td>
                      </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>