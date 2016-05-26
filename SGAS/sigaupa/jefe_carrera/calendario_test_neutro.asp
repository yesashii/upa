<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Calendario Test o entrevistas de Admisión agendados"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------
periodo = negocio.obtenerPeriodoAcademico("POSTULACION")
periodo_tdesc = conexion.consultaUno("select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar) ='"&periodo&"'")
'-------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "calendario_test.xml", "botonera"
'-------------------------------------------------------------------------------
 carr_ccod   	 =   request.QueryString("busqueda[0][carr_ccod]")
 jorn_ccod	 	 =	request.querystring("busqueda[0][jorn_ccod]")
 sede_ccod	 	 =	request.querystring("busqueda[0][sede_ccod]")
 fecha_consulta	 =	request.querystring("busqueda[0][fecha_consulta]")
 Sede = sede_ccod
 sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&Sede&"'")
 carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar) ='"&carr_ccod&"'")
 jorn_tdesc = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar) ='"&jorn_ccod&"'")
 if not esVacio(fecha_consulta) then
 	 dia_semana = conexion.consultaUno("select datepart(weekday,convert(datetime,'"&fecha_consulta&"',103))") 
	 'response.Write(dia_semana)
 end if
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "calendario_test.xml", "busqueda"
 f_busqueda.Inicializar conexion
 peri = periodo
 
 consulta="Select '"&sede_ccod&"' as sede_ccod, '"&carr_ccod&"' as carr_ccod, '"&asig_ccod&"' as asig_ccod, '"&jorn_ccod&"' as jorn_ccod,'"&todas&"' as todas,'"&sin_alumnos&"' as sin_alumnos,'"&sin_cerrar&"' as sin_cerrar "
 f_busqueda.consultar consulta

 usuario=negocio.ObtenerUsuario()
 pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")


 consulta = " select distinct a.sede_ccod, protic.initCap(e.sede_tdesc) as sede,ltrim(rtrim(c.carr_ccod)) as carr_ccod, " & vbCrLf & _
            " protic.initCap(c.carr_tdesc) as carrera, a.jorn_ccod,protic.initCap(f.jorn_tdesc) as jornada " & vbCrLf & _
			" from ofertas_academicas a, especialidades b, carreras c, aranceles d, sedes e, jornadas f " & vbCrLf & _
			" where a.espe_ccod=b.espe_ccod and b.carr_ccod=c.carr_ccod " & vbCrLf & _
			" and a.aran_ncorr=d.aran_ncorr and cast(a.peri_ccod as varchar)='"&periodo&"' and d.aran_mmatricula > 0 " & vbCrLf & _
			" and d.aran_mcolegiatura > 0 and a.post_bnuevo='S' and a.sede_ccod=e.sede_ccod  " & vbCrLf & _
			" and a.jorn_ccod=f.jorn_ccod " & vbCrLf & _
			" order by sede,carrera,jornada" 
			
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

 sql_horas =   "select htes_ccod, htes_hinicio, htes_htermino from horarios_test order by htes_ccod "
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
 
 set f_alumnos = new CFormulario
 f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
 f_alumnos.Inicializar conexion
 
 facu_ccod = conexion.consultaUno("select facu_ccod from carreras a, areas_academicas b where a.area_ccod=b.area_ccod and a.carr_ccod='"&carr_ccod&"'")
 
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
			formulario.action ="calendario_test.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
}
function calificar_test(rut,postulacion,oferta)
{
	var ruta = "edita_examen_postulante.asp?q_pers_nrut="+rut+"&post_ncorr="+postulacion+"&ofer_ncorr="+oferta;
	window.open(ruta,"2","width=770,height=400");
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
                                <td width="13%"> <div align="left">Carrera</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Jornada</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
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
                                  un momento mientras se carga el calendario...</font></div></td>
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
						<td width="90%" align="left"><%=sede_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Carrera</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=carr_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Jornada</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=jorn_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Fecha</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=fecha_consulta%></td>
                      </tr>
					  <tr> 
                        <td width="9%">Periodo</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><%=periodo_tdesc%></td>
                      </tr>
					  <tr> 
                        <td colspan="3">&nbsp;</td>
                      </tr>
					  <tr> 
                        <td colspan="3">
						        <table width="98%" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" border="2" bordercolor="#0099CC">
								<tr> 
									<td colspan="8" align="center"><font color="#990000">Presione sobre el Rut del alumno al que desee incorporar el estado del test o entrevista.</font></td>
								</tr>
								<tr>
									<td align="center"><font size="3" color="#0099CC">HORA</font></td>
									<%if dia_semana = "1" then %>
										<td align="center" bgcolor="#d7f5fd"><font size="3" color="#0099CC">LUNES</font><br><font color="#990000"><%=fecha_trabajo(1)%></font></td>
									<%else%>
										<td align="center"><font size="3" color="#0099CC">LUNES</font><br><font color="#990000"><%=fecha_trabajo(1)%></font></td>
									<%end if%>	
									<%if dia_semana = "2" then %>
										<td align="center" bgcolor="#d7f5fd"><font size="3" color="#0099CC">MARTES</font><br><font color="#990000"><%=fecha_trabajo(2)%></font></td>
									<%else%>
										<td align="center"><font size="3" color="#0099CC">MARTES</font><br><font color="#990000"><%=fecha_trabajo(2)%></font></td>
									<%end if%>
									<%if dia_semana = "3" then %>
										<td align="center" bgcolor="#d7f5fd"><font size="3" color="#0099CC">MIERCOLES</font><br><font color="#990000"><%=fecha_trabajo(3)%></font></td>
									<%else%>
										<td align="center"><font size="3" color="#0099CC">MIERCOLES</font><br><font color="#990000"><%=fecha_trabajo(3)%></font></td>
									<%end if%>
									<%if dia_semana = "4" then %>
										<td align="center" bgcolor="#d7f5fd"><font size="3" color="#0099CC">JUEVES</font><br><font color="#990000"><%=fecha_trabajo(4)%></font></td>
									<%else%>
										<td align="center"><font size="3" color="#0099CC">JUEVES</font><br><font color="#990000"><%=fecha_trabajo(4)%></font></td>
									<%end if%>
									<%if dia_semana = "5" then %>
										<td align="center" bgcolor="#d7f5fd"><font size="3" color="#0099CC">VIERNES</font><br><font color="#990000"><%=fecha_trabajo(5)%></font></td>
									<%else%>
										<td align="center"><font size="3" color="#0099CC">VIERNES</font><br><font color="#990000"><%=fecha_trabajo(5)%></font></td>
									<%end if%>
									<%if dia_semana = "6" then %>
										<td align="center" bgcolor="#d7f5fd"><font size="3" color="#0099CC">SABADO</font><br><font color="#990000"><%=fecha_trabajo(6)%></font></td>
									<%else%>
										<td align="center"><font size="3" color="#0099CC">SABADO</font><br><font color="#990000"><%=fecha_trabajo(6)%></font></td>
									<%end if%>
									<%if dia_semana = "7" then %>
										<td align="center" bgcolor="#d7f5fd"><font size="3" color="#0099CC">DOMINGO</font><br><font color="#990000"><%=fecha_trabajo(7)%></font></td>
									<%else%>
										<td align="center"><font size="3" color="#0099CC">DOMINGO</font><br><font color="#990000"><%=fecha_trabajo(7)%></font></td>
									<%end if%>
								</tr>
								<%while f_horas.siguiente
								    hora = f_horas.obtenerValor("htes_ccod")
									inicio = f_horas.obtenerValor("htes_hinicio")
									fin = f_horas.obtenerValor("htes_htermino")%>
								    <tr>
									    <td align="center"><font color="#000000"><%=hora%></font><br><font color="#990000"><%=inicio%></font></td>
										<%while f_dias.siguiente
										    dia = f_dias.obtenerValor("dias_ccod")
											c_entrevistas = " select e.pers_ncorr,e.pers_nrut,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, eepo_ccod, " & vbCrLf & _
															" protic.initCap(pers_tnombre + ' ' + pers_tape_paterno) as nombre, a.post_ncorr, a.ofer_ncorr " & vbCrLf & _
											                " from observaciones_postulacion a, postulantes b, ofertas_academicas c," & vbCrLf & _
											                " especialidades d, personas_postulante e, detalle_postulantes f " & vbCrLf & _
											                " where a.post_ncorr=b.post_ncorr and cast(b.peri_ccod as varchar)='"&periodo&"'" & vbCrLf & _
															" and a.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod and b.pers_ncorr = e.pers_ncorr" & vbCrLf & _
															" and a.post_ncorr=f.post_ncorr and a.ofer_ncorr=f.ofer_ncorr " & vbCrLf & _
															" and cast(c.sede_ccod as varchar)='"&sede_ccod&"'" & vbCrLf & _
															" and cast(c.jorn_ccod as varchar)='"&jorn_ccod&"'" & vbCrLf & _
															" and d.carr_ccod='"&carr_ccod&"'" & vbCrLf & _
															" and cast(a.htes_ccod as varchar)='"&hora&"'" & vbCrLf & _
															" and a.fecha_entrevista='"&fecha_trabajo(dia)&"' and eopo_ccod='16'"
											f_alumnos.consultar c_entrevistas
											entrevistas = f_alumnos.nroFilas
											if cstr(dia_semana) = cstr(dia) then
											 color= "#d7f5fd"
											else
											 color= "#FFFFFF"
											end if%>
												<%if entrevistas = 0 then %>
													<td align="center" bgcolor="<%=color%>"><font color="#000000">&nbsp;</font></td>
												<%else%>
													<td align="center" bgcolor="<%=color%>">
													   <font color="#000000">
													      <%while f_alumnos.siguiente
														       pers_ncorr_a = f_alumnos.obtenerValor("pers_ncorr")
															   rut_a = f_alumnos.obtenerValor("rut")
															   nombre_a = f_alumnos.obtenerValor("nombre")
															   pers_nrut_a = f_alumnos.obtenerValor("pers_nrut")
															   ofer_a = f_alumnos.obtenerValor("ofer_ncorr")
															   post_a = f_alumnos.obtenerValor("post_ncorr")
															   estado = f_alumnos.obtenerValor("eepo_ccod")
															   imagen_p = ""
															   if estado = "2" or estado="5" then
															   	  imagen_p = "<img src='../imagenes/pelota_verde.gif' width='8' height='8' title='Aprobado'>"
															   elseif estado="6" then
															   	  imagen_p = "<img src='../imagenes/pelota_lila.gif' width='8' height='8' title='Test convalidado'>"
															   elseif estado="4" or estado="7" then
															   	  imagen_p = "<img src='../imagenes/pelota_celeste.gif' width='8' height='8' title='Indefinido o en espera'>"
															   elseif estado="8" then
															   	  imagen_p = "<img src='../imagenes/pelota_amarilla.gif' width='8' height='8' title='En entrevista'>"
															   elseif estado="3" then
															   	  imagen_p = "<img src='../imagenes/pelota_roja.gif' width='8' height='8' title='No aprobado'>"
															   end if
															   
															   'ruta = "edita_examen_postulante.asp?q_pers_nrut="&pers_nrut_a&"&post_ncorr="&post_a&"&ofer_ncorr="&ofer_a
															   response.Write("<br>"&imagen_p&"<a href='#' title='"&nombre_a&"'>"&rut_a&"</a>")
															wend
															f_alumnos.primero%>
													   </font>
													</td>
												<%end if%>
									    <%wend
										  f_dias.primero%>
									</tr>
								<%wend%>
						        </table>
						</td>
                      </tr>
					  <tr> 
                        <td colspan="3" align="right"><font color="#990000">Presione sobre el Rut del alumno al que desee incorporar el estado del test o entrevista.</font></td>
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
						<td width="14%"><%botonera.agregaBotonParam "excel_facultad","url","entrevistas_facultad.asp?facu_ccod="&facu_ccod
						                  botonera.dibujaBoton "excel_facultad"%></td>
						 <td width="14%"><%botonera.agregaBotonParam "excel_en_entrevista","url","en_entrevistas_carrera.asp?carr_ccod="&carr_ccod
						                  botonera.dibujaBoton "excel_en_entrevista"%></td>
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
