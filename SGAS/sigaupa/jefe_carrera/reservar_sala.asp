<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

sala_ccod  = request.querystring("sala")
hora  = request.querystring("hora")
dia   = request.querystring("dia")
fecha = request.querystring("fecha")

pagina.Titulo = "Reservar Laboratorio"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "reserva_laboratorio.xml", "botonera"
'----------------------------------------------------------------
sala_tdesc = conexion.consultauno("SELECT sala_tdesc FROM salas WHERE cast(sala_ccod as varchar)= '" & sala_ccod & "'")
sede_ccod = conexion.consultauno("SELECT sede_ccod FROM salas WHERE cast(sala_ccod as varchar)= '" & sala_ccod & "'")
dias_tdesc = conexion.consultauno("SELECT dias_tdesc FROM dias_semana WHERE cast(dias_ccod as varchar)= '" & dia & "'")
sede_tdesc = conexion.consultauno("SELECT sede_tdesc FROM salas a, sedes b WHERE a.sede_ccod=b.sede_ccod and cast(sala_ccod as varchar)= '" & sala_ccod & "'")
horario = conexion.consultaUno("select cast(datepart(hour,hora_hinicio) as varchar)+':'+case when datepart(minute,hora_hinicio) < 10 then '0' else '' end + cast(datepart(minute,hora_hinicio) as varchar) + ' --> ' + cast(datepart(hour,hora_htermino) as varchar)+':'+case when datepart(minute,hora_htermino) < 10 then '0' else '' end + cast(datepart(minute,hora_htermino) as varchar) as horario from horarios_sedes where cast(hora_ccod as varchar)='"&hora&"' and cast(sede_ccod as varchar)='"&sede_ccod&"'")
'region = conexion.consultauno("SELECT regi_tdesc FROM regiones WHERE cast(regi_ccod as varchar) = '" & regi_ccod & "'")

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
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="450" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr> 
          <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><%pagina.DibujarLenguetas Array("Reservar sala"), 1 %></td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <br>
					</div>
				    <form name="edicion" action="reservar_sala_proc.asp" method="post">
					<input type="hidden" name="sala_ccod" value="<%=sala_ccod%>"> 
					<input type="hidden" name="dias_ccod" value="<%=dia%>"> 
					<input type="hidden" name="hora_ccod" value="<%=hora%>"> 
					<input type="hidden" name="fecha" value="<%=fecha%>"> 
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td>
                          <table width="100%" border="0">
						   <tr> 
                              <td width="15%">Sede</td>
                              <td width="1%"><div align="center">:</div></td>
                              <td width="84%"><%=sede_tdesc%></td>
                            </tr>
							<tr> 
                              <td width="15%">Sala</td>
                              <td width="1%"><div align="center">:</div></td>
                              <td width="84%"><%=sala_tdesc%></td>
                            </tr>
							<tr> 
                              <td width="15%">Día</td>
                              <td width="1%"><div align="center">:</div></td>
                              <td width="84%"><%=dias_tdesc%></td>
                            </tr>
							<tr> 
                              <td width="15%">Fecha</td>
                              <td width="1%"><div align="center">:</div></td>
                              <td width="84%"><%=fecha%></td>
                            </tr>
							<tr> 
                              <td width="15%">Horario</td>
                              <td width="1%"><div align="center">:</div></td>
                              <td width="84%"><%=horario%></td>
                            </tr>
							<tr> 
                              <td width="15%">Motivo</td>
                              <td width="1%"><div align="center">:</div></td>
                              <td width="84%"><input type="text" size="45" maxlength="100" name="motivo" id="TO-N"></td>
                            </tr>
							<tr> 
                              <td width="15%">Responsable</td>
                              <td width="1%"><div align="center">:</div></td>
                              <td width="84%"><input type="text" size="45" maxlength="50" name="responsable"  id="TO-N"></td>
                            </tr>
							<tr> 
                              <td width="15%">N° Alumnos</td>
                              <td width="1%"><div align="center">:</div></td>
                              <td width="84%"><input type="text" size="3" maxlength="3" name="num_nalumnos"  id="NU-N"></td>
                            </tr>
	                      </table>
                          </td>
                      </tr>
                    </table>
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="100%"><div align="center">
                            <%botonera.dibujaBoton "cancelar" %>
                          </div></td>
						<td width="100%"><div align="center">
                            <%botonera.dibujaBoton "reservar_sala" %>
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
