<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
nombre_campo = request.QueryString("campo")
campo2 = request.QueryString("campo2")
ofer_ncorr   = request.QueryString("ofer_ncorr") 
fecha_entrevista =request.QueryString("fecha_entrevista")

set pagina = new CPagina
'---------------------------------------------------------------------------------------------------
'----------------------------------------------------------	
set conexion = new cconexion
conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-------------------------------------------------------------------------------

mensaje = "Asignación de Horarios a Test o entrevistas" 
sede_tdesc = conexion.consultaUno("select sede_tdesc from ofertas_academicas a, sedes b where a.sede_ccod=b.sede_ccod and cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"'")
sede_ccod  = conexion.consultaUno("select sede_ccod from ofertas_academicas where cast(ofer_ncorr as varchar)='"&ofer_ncorr&"'")
jorn_tdesc = conexion.consultaUno("select jorn_tdesc from ofertas_academicas a, jornadas b where a.jorn_ccod=b.jorn_ccod and cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"'")
jorn_ccod  = conexion.consultaUno("select jorn_ccod from ofertas_academicas  where cast(ofer_ncorr as varchar)='"&ofer_ncorr&"'")
carr_tdesc = conexion.consultaUno("select carr_tdesc from ofertas_academicas a, especialidades b,carreras c where a.espe_ccod=b.espe_ccod and b.carr_ccod=c.carr_ccod and cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"'")
carr_ccod  = conexion.consultaUno("select carr_ccod from ofertas_academicas a, especialidades b where a.espe_ccod=b.espe_ccod and cast(a.ofer_ncorr as varchar)='"&ofer_ncorr&"'")
dia_semana = conexion.consultaUno("select datepart(weekday,convert(datetime,'"&fecha_entrevista&"',103))")
dia_en_palabras = conexion.consultaUno("select dias_tdesc from dias_semana where cast(dias_ccod as varchar)='"&dia_semana&"'")

set f_horarios = new cformulario
f_horarios.carga_parametros "tabla_vacia.xml","tabla"
f_horarios.inicializar conexion

consulta  = " select htes_ccod, '<font color=blue><strong>'+cast(htes_ccod as varchar)+'</strong></font>: '+htes_hinicio+'-'+htes_htermino as horario, " & vbCrLf &_
			" htes_hinicio as horario2, " & vbCrLf &_
			" isnull(( select isnull(estado,1) from DISPONIBILIDAD_TEST tt where cast(sede_ccod as varchar)='"&sede_ccod&"' " & vbCrLf &_
			"   and carr_ccod = '"&carr_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"'  " & vbCrLf &_
			"   and cast(dias_ccod as varchar) = '"&dia_semana&"' and tt.htes_ccod = a.htes_ccod ),1) as estado, " & vbCrLf &_
			" ( select count(*) from observaciones_postulacion tt, ofertas_academicas t2, especialidades t3 " & vbCrLf &_
			"   where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod " & vbCrLf &_
			"   and cast(t2.sede_ccod as varchar)='"&sede_ccod&"' and t3.carr_ccod='"&carr_ccod&"' and cast(t2.jorn_ccod as varchar)='"&jorn_ccod&"' " & vbCrLf &_
			"   and convert(datetime,protic.trunc(fecha_entrevista),103) = convert(datetime,'"&fecha_entrevista&"',103) " & vbCrLf &_
			"   and tt.htes_ccod = a.htes_ccod ) as total_asignados   " & vbCrLf &_
			" from horarios_test a " & vbCrLf &_
			" order by htes_ccod asc "

f_horarios.Consultar consulta

'------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_criterios.xml", "botonera"
'-------------------------------------------------------------------------------
%>
<html>
<head>
<title><%=mensaje%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function Salir()
{ 
  window.close();
}

function validar()
{
  if (document.edicion.elements["crit_ccod"].value != "")
   {
      if (document.edicion.elements["crit_tdesc"].value != "")
       {
	      if (document.edicion.elements["crit_norden"].value != "")
     	   {
            		  codigo= document.edicion.elements["crit_ccod"].value;
					  texto = document.edicion.elements["crit_tdesc"].value;
					  orden = document.edicion.elements["crit_norden"].value;
					  encu_ncorr = '<%=encu_ncorr%>';
					  crit_ncorr = '<%=crit_ncorr%>';
					
					  url = "proc_Editar_criterios2.asp?crit_ccod=" + codigo + "&crit_tdesc=" + texto + "&crit_norden=" + orden +"&encu_ncorr=" + encu_ncorr + "&crit_ncorr=" + crit_ncorr;
					  document.edicion.method = "POST";
 				      document.edicion.action = url;
				      document.edicion.submit();
         }
   		else
  	   { alert("Ingrese un número de orden correcto"); document.edicion.elements["crit_norden"].focus();}
	 }
   	else
    { alert("Ingrese el un texto descriptivo del críterio"); document.edicion.elements["crit_tdesc"].focus();}
  }
  else
  { alert("Ingrese el código del críterio"); document.edicion.elements["crit_ccod"].focus();}
}
function obtener(horario,bloque,estado)
{
	if (estado == "0")
	{
		alert("Imposible asignar el horario, fue bloqueado a petición de la escuela");
	}
	else
	{
		//alert(horario);
		/*if ('<%=nombre_campo%>' == 'undefined')
		{
			num=opener.document.forms[0].elements.length;
			c=0;
			for (i=0;i<num;i++)
			{
				nombre = opener.document.forms[0].elements[i].name;
				var elem = new RegExp("rut","gi");
				if (elem.test(nombre))
				{
					opener.document.forms[0].elements[i].value=nrut;		
				}
			   var elem2 = new RegExp("dv","gi");
				if (elem2.test(nombre))
				{
				   opener.document.forms[0].elements[i].value=ndv;		
				   opener.document.forms[0].elements[i].focus();		
				}
			}
		}
		else 
		{*/
			opener.document.forms[0].elements["<%=nombre_campo%>"].value = horario;
			opener.document.forms[0].elements["<%=campo2%>"].value = bloque;
		//	opener.document.forms[0].elements["{campo_dv}"].value = ndv;
		//}
		
		window.close();
	}	
}


</script>


</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="550" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
 <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br>
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
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
           </table>
			<div align="center">
			  <form action="JAVASCRIPT:Enviar();" method="post" enctype="multipart/form-data" name="edicion" id="edicion">
                <table width="100%" border="0">
				<tr>
					<td colspan="3" align="center">
						<font size="3"><strong><%=mensaje%></strong></font>
					</td>
				</tr>
				<tr>
					<td colspan="3"><br></td>
				</tr>
				<tr>
					<td width="15%" align="left"><strong>Sede</strong></td>
					<td width="1%" align="center"><strong>:</strong></td>
					<td width="84%" align="left"><%=sede_tdesc%></td>
				</tr>
				<tr>
					<td width="15%" align="left"><strong>Carrera</strong></td>
					<td width="1%" align="center"><strong>:</strong></td>
					<td width="84%" align="left"><%=carr_tdesc%></td>
				</tr>
				<tr>
					<td width="15%" align="left"><strong>Jornada</strong></td>
					<td width="1%" align="center"><strong>:</strong></td>
					<td width="84%" align="left"><%=jorn_tdesc%></td>
				</tr>
				<tr>
					<td width="15%" align="left"><strong>Fecha</strong></td>
					<td width="1%" align="center"><strong>:</strong></td>
					<td width="84%" align="left"><%=dia_en_palabras %>, <%=fecha_entrevista%></td>
				</tr>
				<tr>
					<td colspan="3" align="center"><font color="#0066CC"><strong>Seleccione el horario en que el alumno desea realizar el test o entrevista.</strong></font></td>
				</tr>
				<tr>
					<td colspan="3" align="center">
						<table width="98%" cellpadding="0" cellspacing="2" border="1">
							<%bloque = 0
							  while f_horarios.siguiente
							  bloque = bloque + 1
							  htes_ccod = f_horarios.obtenerValor("htes_ccod")
							  horario   = f_horarios.obtenerValor("horario")
							  horario2   = f_horarios.obtenerValor("horario2")
							  estado    = f_horarios.obtenerValor("estado")
							  total     = f_horarios.obtenerValor("total_asignados")
							  color     = "#FFFFFF"
							  if estado = "0" then
							  	color     = "#FF3300"
							  end if
							 %>
						     <tr>
							 	<td width="20%" align="center" bgcolor="<%=color%>" onClick="obtener('<%=horario2%>',<%=htes_ccod%>,<%=estado%>);">
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td colspan="4" align="center"><%=horario%></td>
										</tr>
										<tr>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center" title="Total de postulantes agendados al horario"><%=total%></td>
										</tr>
									</table>
								</td>
								<%
								  f_horarios.siguiente
								  bloque = bloque + 1
								  htes_ccod = f_horarios.obtenerValor("htes_ccod")
								  horario   = f_horarios.obtenerValor("horario")
								  horario2   = f_horarios.obtenerValor("horario2")
								  estado    = f_horarios.obtenerValor("estado")
								  total     = f_horarios.obtenerValor("total_asignados")
								  color     = "#FFFFFF"
								  if estado = "0" then
									color     = "#FF3300"
								  end if	
								%>
								<td width="20%" align="center" bgcolor="<%=color%>" onClick="obtener('<%=horario2%>',<%=htes_ccod%>,<%=estado%>);">
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td colspan="4" align="center"><%=horario%></td>
										</tr>
										<tr>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center" title="Total de postulantes agendados al horario"><%=total%></td>
										</tr>
									</table>
								</td>
								<%
								  f_horarios.siguiente
								  bloque = bloque + 1
								  htes_ccod = f_horarios.obtenerValor("htes_ccod")
								  horario   = f_horarios.obtenerValor("horario")
								  horario2   = f_horarios.obtenerValor("horario2")
								  estado    = f_horarios.obtenerValor("estado")
								  total     = f_horarios.obtenerValor("total_asignados")
								  color     = "#FFFFFF"
								  if estado = "0" then
									color     = "#FF3300"
								  end if	
								%>
								<td width="20%" align="center" bgcolor="<%=color%>" onClick="obtener('<%=horario2%>',<%=htes_ccod%>,<%=estado%>);">
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td colspan="4" align="center"><%=horario%></td>
										</tr>
										<tr>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center" title="Total de postulantes agendados al horario"><%=total%></td>
										</tr>
									</table>
								</td>
								<%
								  f_horarios.siguiente
								  bloque = bloque + 1
								  htes_ccod = f_horarios.obtenerValor("htes_ccod")
								  horario   = f_horarios.obtenerValor("horario")
								  horario2   = f_horarios.obtenerValor("horario2")
								  estado    = f_horarios.obtenerValor("estado")
								  total     = f_horarios.obtenerValor("total_asignados")
								  color     = "#FFFFFF"
								  if estado = "0" then
									color     = "#FF3300"
								  end if
								  
								  if total <> "0" then
								    color     = "#FF6633"
								  end if	
								%>
								<td width="20%" align="center" bgcolor="<%=color%>" onClick="obtener('<%=horario2%>',<%=htes_ccod%>,<%=estado%>);">
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td colspan="4" align="center"><%=horario%></td>
										</tr>
										<tr>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center" title="Total de postulantes agendados al horario"><%=total%></td>
										</tr>
									</table>
								</td>
								<%
								  f_horarios.siguiente
								  bloque = bloque + 1
								  htes_ccod = f_horarios.obtenerValor("htes_ccod")
								  horario   = f_horarios.obtenerValor("horario")
								  horario2  = f_horarios.obtenerValor("horario2")
								  estado    = f_horarios.obtenerValor("estado")
								  total     = f_horarios.obtenerValor("total_asignados")
								  color     = "#FFFFFF"
								  if estado = "0" then
									color     = "#FF3300"
								  end if
								  if total <> "0" then
								    color     = "#FF6633"
								  end if	
								%>
								<td width="20%" align="center" bgcolor="<%=color%>" onClick="obtener('<%=horario2%>',<%=htes_ccod%>,<%=estado%>);">
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td colspan="4" align="center"><%=horario%></td>
										</tr>
										<tr>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center">&nbsp;</td>
											<td width="25%" align="center" title="Total de postulantes agendados al horario"><%=total%></td>
										</tr>
									</table>
								</td>
							 </tr>
							<%wend%>
						</table>
					</td>
				</tr>
				</table>
                </form>
            </div>
			</td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="47%">&nbsp;</td>
                        <td width="53%"><div align="center">
                            <%botonera.DibujaBoton "cerrar_actualizar"%>
                          </div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> </td>
  </tr>
</table>
</body>
</html>
