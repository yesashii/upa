<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Registro asistencias realizadas en papel"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

periodo = negocio.obtenerPeriodoAcademico("PLANIFICACION")
periodo_tdesc = conexion.consultaUno("select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar) ='"&periodo&"'")
'-------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "seleccionar_curso_asistencia.xml", "botonera"
'-------------------------------------------------------------------------------
 sede_ccod	 =	request.querystring("busqueda[0][sede_ccod]")
 carr_ccod   =  request.QueryString("busqueda[0][carr_ccod]")
 jorn_ccod	 =	request.querystring("busqueda[0][jorn_ccod]")
 secc_ccod	 =	request.querystring("busqueda[0][secc_ccod]")
 
 Sede = sede_ccod
 sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&Sede&"'")
 carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar) ='"&carr_ccod&"'")
 jorn_tdesc = conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar) ='"&jorn_ccod&"'")
 asig_tdesc = conexion.consultaUno("select a.asig_ccod + ' --> '+ asig_tdesc from secciones a, asignaturas b where cast(secc_ccod as varchar) ='"&secc_ccod&"' and a.asig_ccod=b.asig_ccod ")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "seleccionar_curso_asistencia.xml", "busqueda_seccion"
 f_busqueda.Inicializar conexion
 peri = periodo
 
 consulta="Select '"&sede_ccod&"' as sede_ccod, '"&carr_ccod&"' as carr_ccod, '"&secc_ccod&"' as secc_ccod, '"&jorn_ccod&"' as jorn_ccod"
 f_busqueda.consultar consulta

usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")


 consulta = " select a.secc_ccod,b.sede_ccod,b.sede_tdesc,c.carr_ccod,c.carr_tdesc,d.jorn_ccod,d.jorn_tdesc, " & vbCrLf & _
			" ltrim(rtrim(e.asig_ccod)) + ':' + e.asig_tdesc + ' sec:'+a.secc_tdesc as asignatura  " & vbCrLf & _
			" from secciones a, sedes b,carreras c, jornadas d, asignaturas e " & vbCrLf & _
			" where a.sede_ccod=b.sede_ccod and a.carr_ccod=c.carr_ccod and a.jorn_ccod=d.jorn_ccod " & vbCrLf & _
			" and a.asig_ccod=e.asig_ccod and cast(a.peri_ccod as varchar)='"&peri&"' " & vbCrLf & _
			" and c.tcar_ccod=1 " & vbCrLf & _
			" and exists (select 1 from cargas_academicas tt where tt.secc_ccod=a.secc_ccod) " & vbCrLf & _
			" order by sede_tdesc,carr_tdesc,jorn_tdesc, asig_tdesc,secc_tdesc " 

f_busqueda.inicializaListaDependiente "lBusqueda", consulta
f_busqueda.Siguiente

set formulario = new CFormulario
formulario.Carga_Parametros "seleccionar_curso_asistencia.xml", "listado_diario_tardio"
formulario.Inicializar conexion 

consulta = " select a.secc_ccod,ltrim(rtrim(c.asig_ccod))+':'+c.asig_tdesc as asignatura,secc_tdesc as seccion, " &vbcrlf &_
		   " sala_tdesc as sala, dias_tdesc as dia, hora_ccod as modulo, " &vbcrlf &_
		   " protic.trunc(f.cale_fcalendario) as fecha_clase,f.cale_fcalendario,  " &vbcrlf &_
		   " (select case count(*) when 0 then '' else 'OK' end from asistencia_diaria tt, detalle_asistencia_diaria tt2 " &vbcrlf &_ 
  		   " where tt.secc_ccod = a.secc_ccod and protic.trunc(tt.fecha_ingreso)=protic.trunc(f.cale_fcalendario) " &vbcrlf &_
		   " and tt.adia_ncorr=tt2.adia_ncorr and tt.secc_ccod=tt2.secc_ccod )  as grabado " &vbcrlf &_
		   " from secciones a, bloques_horarios b,asignaturas c,salas d,dias_semana e,calendario f " &vbcrlf &_
		   " where a.secc_ccod=b.secc_ccod " &vbcrlf &_
		   " and a.asig_ccod=c.asig_ccod " &vbcrlf &_
		   " and b.sala_ccod=d.sala_ccod and b.dias_ccod=e.dias_ccod " &vbcrlf &_
		   " and convert(datetime,protic.trunc(f.cale_fcalendario),103) >= convert(datetime,protic.trunc(b.bloq_finicio_modulo),103) " &vbcrlf &_
		   " and convert(datetime,protic.trunc(f.cale_fcalendario),103) <= convert(datetime,protic.trunc(b.bloq_ftermino_modulo),103) " &vbcrlf &_
		   " and convert(datetime,protic.trunc(f.cale_fcalendario),103) <= convert(datetime,protic.trunc(getDate()),103) " &vbcrlf &_
		   " and datePart(weekday,f.cale_fcalendario) = b.dias_ccod " &vbcrlf &_
		   " and cast(a.secc_ccod as varchar)='"&secc_ccod&"' " &vbcrlf &_
		   " and not exists (select 1 from asistencia_diaria tt where tt.secc_ccod = a.secc_ccod and 			protic.trunc(tt.fecha_ingreso)=protic.trunc(f.cale_fcalendario) and estado_registro=2) " &vbcrlf &_
		   " order by cale_fcalendario asc,modulo asc " 
		   
formulario.Consultar consulta
'response.Write("<pre>"&consulta&"</pre>") 
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

<script language="JavaScript">
function enviar(formulario){
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="registro_asistencias_pasadas.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
}
</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
								<td width="31%"> <div align="center"><%botonera.dibujaboton "buscar_seccion"%></div> </td>
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
                                <td width="13%"> <div align="left">Asignatura</div></td>
								<td width="2%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "secc_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left"></div></td>
								<td width="2%"> <div align="center"></div> </td>
								<td colspan="2"><div  align="right" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
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
						<td width="90%" align="left"><font color="#993300"><%=sede_tdesc%></font></td>
                      </tr>
					  <tr> 
                        <td width="9%">Carrera</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><font color="#993300"><%=carr_tdesc%></font></td>
                      </tr>
					  <tr> 
                        <td width="9%">Jornada</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><font color="#993300"><%=jorn_tdesc%></font></td>
                      </tr>
					  <tr> 
                        <td width="9%">Asignatura</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><font color="#993300"><%=asig_tdesc%></font></td>
                      </tr>
					  <tr> 
                        <td width="9%">Periodo</td>
						<td width="1%">:</td>
						<td width="90%" align="left"><font color="#993300"><%=periodo_tdesc%></font></td>
                      </tr>
					  <%end if%>
                    </table>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                        <td><div align="right">P&aacute;ginas: &nbsp; 
                            <%formulario.AccesoPagina%>
                          </div></td>
                  </tr>
				  <tr>
                    <td>
                      <br>
					  <%formulario.dibujaTabla()%>
					  </td>
                  </tr>
				  <tr>
				      <td>&nbsp;</td>
				  </tr>
                </table>
                          <br>
            </form></td></tr>
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
                        <td><div align="center"><%botonera.dibujaBoton "salir"%></div></td>
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
