<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------
periodo = negocio.obtenerPeriodoAcademico("PLANIFICACION")
periodo_tdesc = conexion.consultaUno("select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar) ='"&periodo&"'")
'-------------------------------------------------------------------------------
pagina.Titulo = "Reserva de salas de laboratorio <br>"&periodo_tdesc
set botonera = new CFormulario
botonera.Carga_Parametros "reserva_laboratorio.xml", "botonera"
'-------------------------------------------------------------------------------
'*******************************************************************************************
'####### Elimina las reservas que tengan fecha de antiguedad mayor a una semana. ##########
' sql_limpia="delete from RESERVA_HORAS_LABORATORIOS where datediff(day,fecha_reserva,getdate()) >=7"
' v_borrado=conexion.consultaUno("delete from RESERVA_HORAS_LABORATORIOS where datediff(day,fecha_reserva,getdate()) >=7")
'*******************************************************************************************

 
 sala_ccod   	 =   request.QueryString("busqueda[0][sala_ccod]")
 sede_ccod	 	 =	request.querystring("busqueda[0][sede_ccod]")
 fecha_consulta	 =	request.querystring("busqueda[0][fecha_consulta]")
 Sede = sede_ccod
 sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&Sede&"'")
 sala_tdesc = conexion.consultaUno("select sala_tdesc from salas where cast(sala_ccod as varchar) ='"&sala_ccod&"'")
 equipamiento = conexion.consultaUno("select equipamiento from salas where cast(sala_ccod as varchar) ='"&sala_ccod&"'")
 if not esVacio(fecha_consulta) then
 	 dia_semana = conexion.consultaUno("select datepart(weekday,convert(datetime,'"&fecha_consulta&"',103))") 
 end if
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "reserva_laboratorio.xml", "busqueda"
 f_busqueda.Inicializar conexion
 peri = periodo
 
 consulta="Select '"&sede_ccod&"' as sede_ccod, '"&sala_ccod&"' as sala_ccod "
 f_busqueda.consultar consulta

 usuario=negocio.ObtenerUsuario()
 pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")


 consulta = " select a.sede_ccod, a.sede_tdesc as sede,b.sala_ccod, b.sala_tdesc as sala " & vbCrLf & _
			" from sedes a, salas b " & vbCrLf & _
			" where a.sede_ccod=b.sede_ccod " & vbCrLf & _
			" and b.sala_ccod in (30,32,31,29,43,274,65,25,175,176,102,161,133,167,266,85,336) " & vbCrLf & _
			" order by sede, sala " 
			
'response.Write("<pre>"&consulta&"</pre>")	
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta
 f_busqueda.Siguiente
 f_busqueda.agregaCampoCons "fecha_consulta",fecha_consulta
 
 set f_dias = new CFormulario
 f_dias.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_dias.Inicializar conexion

 sql_dias =   "select dias_ccod,dias_tdesc from dias_semana order by dias_ccod "
 f_dias.consultar sql_dias
 
 set f_horas = new CFormulario
 f_horas.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_horas.Inicializar conexion

if sede_ccod = "" then
	sede_ccod = negocio.obtenerSede
end if

 sql_horas = "select hora_ccod, cast(datepart(hour,hora_hinicio) as varchar)+':'+case when datepart(minute,hora_hinicio) < 10 then '0' else '' end + cast(datepart(minute,hora_hinicio) as varchar) as hora_hinicio,"&_
             " cast(datepart(hour,hora_htermino) as varchar)+':'+case when datepart(minute,hora_htermino) < 10 then '0' else '' end + cast(datepart(minute,hora_htermino) as varchar) as hora_htermino from horarios_sedes where cast(sede_ccod as varchar)='"&sede_ccod&"' and datepart(hour,hora_hinicio) > 0 order by hora_ccod"
 f_horas.consultar sql_horas
 
 fecha_trabajo = Array("","","","","","","","")
 if not esVacio(fecha_consulta) then
 	 if dia_semana = "1" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+4")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+5")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+6")
	 elseif dia_semana = "2" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+4")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+5")
	 elseif dia_semana = "3" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+4") 
     elseif dia_semana = "4" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-3")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+3") 
	 elseif dia_semana = "5" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-4")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-3")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+2") 
	 elseif dia_semana = "6" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-5")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-4")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-3")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)+1") 
	 elseif dia_semana = "7" then
		  fecha_trabajo(1) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-6")
		  fecha_trabajo(2) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-5")
		  fecha_trabajo(3) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-4")
		  fecha_trabajo(4) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-3")
		  fecha_trabajo(5) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-2")
		  fecha_trabajo(6) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)-1")
		  fecha_trabajo(7) = conexion.consultaUno("select convert(datetime,'"&fecha_consulta&"',103)") 	  
     end if
 end if
 
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function enviar(formulario){
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="reserva_laboratorio.asp";
			formulario.submit();
}
function reservar(sala,dia,hora,fecha)
{
	var url = "reservar_sala.asp?sala="+sala+"&dia="+dia+"&hora="+hora+"&fecha="+fecha;
	//alert(url);
	window.open(url,"v1","width=450,height=400,scrollbars=yes");
}
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][fecha_consulta]","1","buscador","fecha_consulta_oculta"
	calendario.FinFuncion
%>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0">
                      <tr>
                        <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="13%"> <div align="left">Sede</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td width="54%"><% f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod"%></td>
								<td width="31%"> <div align="center"><%botonera.dibujaboton "buscar"%></div> </td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Laboratorio</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "sala_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Fecha</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2">
										<% f_busqueda.dibujaCampo "fecha_consulta"%>
										<a style='cursor:hand;' onClick='PopCalendar.show(document.buscador.fecha_consulta_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11");'></a> 
                                <%calendario.DibujaImagen "fecha_consulta_oculta","1","buscador" %>
								</td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left"></div></td>
								<td width="2%"> <div align="center"></div> </td>
								<td colspan="2"><div  align="right" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se carga la disponibilidad del laboratorio...</font></div></td>
                              </tr>
                            </table></td>
                       </tr>
                    </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
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
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                    <table width="100%" border="0">
                      <tr> 
                        <td colspan="3">&nbsp;</td>
                      </tr>
					  <%if Request.QueryString <> "" then%>
					  <tr> 
                        <td width="9%">Sede</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><font color="#990000"><%=sede_tdesc%></font></td>
                      </tr>
					  <tr> 
                        <td width="9%">Laboratorio</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><font color="#990000"><%=sala_tdesc%></font></td>
                      </tr>
					  <tr valign="top"> 
                        <td width="9%">Equipamiento</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><font color="#990000"><%=equipamiento%></font></td>
                      </tr>
					  <tr> 
                        <td width="9%">Fecha</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><font color="#990000"><%=fecha_consulta%></font></td>
                      </tr>
					  <tr> 
                        <td colspan="3">&nbsp;</td>
                      </tr>
					  <tr> 
                        <td colspan="3">
						        <table width="98%" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" border="2" bordercolor="#666666">
								<tr> 
									<td colspan="8" align="center"><font color="#990000">Presione sobre el día y bloque que desea reservar.</font></td>
								</tr>
								<tr>
									<td align="center"><font size="3" color="#666666">HORA</font></td>
									<td align="center"><font size="3" color="#666666">LUNES</font><br><font color="#990000"><%=fecha_trabajo(1)%></font></td>
									<td align="center"><font size="3" color="#666666">MARTES</font><br><font color="#990000"><%=fecha_trabajo(2)%></font></td>
									<td align="center"><font size="3" color="#666666">MIERCOLES</font><br><font color="#990000"><%=fecha_trabajo(3)%></font></td>
									<td align="center"><font size="3" color="#666666">JUEVES</font><br><font color="#990000"><%=fecha_trabajo(4)%></font></td>
									<td align="center"><font size="3" color="#666666">VIERNES</font><br><font color="#990000"><%=fecha_trabajo(5)%></font></td>
									<td align="center"><font size="3" color="#666666">SABADO</font><br><font color="#990000"><%=fecha_trabajo(6)%></font></td>
									<td align="center"><font size="3" color="#666666">DOMINGO</font><br><font color="#990000"><%=fecha_trabajo(7)%></font></td>
								</tr>
								<form name="horarios">
								<%while f_horas.siguiente
								    hora = f_horas.obtenerValor("hora_ccod")
									inicio = f_horas.obtenerValor("hora_hinicio")
									fin = f_horas.obtenerValor("hora_htermino")%>
								    <tr>
									    <td align="center"><font  size="+2" color="#000000"><%=hora%></font><br><font color="#990000"><%=inicio%><br>a<br><%=fin%></font></td>
										<%while f_dias.siguiente
										    dia = f_dias.obtenerValor("dias_ccod")
											c_topon = "select protic.detalle_sala_con_carrera("&sala_ccod&","&dia&","&hora&",'"&fecha_trabajo(dia)&"','"&fecha_trabajo(dia)&"',"&periodo&") as topon"
											topon = conexion.consultaUno(c_topon)
											color= "#FFFFFF"
											%>
													<td align="center" bgcolor="<%=color%>">
													   <font color="#000000">
													      <%if topon <> "" then
														     response.Write(topon)
															else%>
															<input type="button" name="boton_<%=dia%>_<%=hora%>" value="Reservar" onClick="javascript:reservar(<%=sala_ccod%>,<%=dia%>,<%=hora%>,'<%=fecha_trabajo(dia)%>');">
															<%end if%>
													   </font>
													</td>
									    <%wend
										  f_dias.primero%>
									</tr>
								<%wend%>
								</form>
						        </table>
						</td>
                      </tr>
					  <tr> 
                        <td colspan="3" align="right"><font color="#990000">Presione sobre el día y bloque que desea reservar.</font></td>
                      </tr>
					  <%end if%>
                    </table>
                  </div>
              </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
						<td width="14%">&nbsp;</td>
						 <td width="14%">&nbsp;</td>
						 <td width="14%">&nbsp;</td>
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
