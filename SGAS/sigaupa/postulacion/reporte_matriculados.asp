<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera =  new CFormulario
pagina.Titulo = "Alumnos Matriculados"

botonera.carga_parametros "reporte_matriculados.xml", "btn_matriculados"

set conectar = new cConexion
set negocio = new cnegocio
set f_matriculados = new cformulario
set f_sedes = new cformulario
conectar.inicializar "desauas"
negocio.inicializaPortal conectar

f_sedes.carga_parametros "reporte_matriculados.xml","sede"
f_sedes.inicializar conectar
f_sedes.Consultar "select '' from dual"
f_sedes.Siguiente

sede = request.QueryString("busqueda[0][sede_ccod]")
rut = request.QueryString("busqueda[0][pers_nrut]")

f_sedes.AgregaCampoCons "sede_ccod", sede


f_matriculados.carga_parametros "reporte_matriculados.xml","matriculados"
f_matriculados.inicializar conectar

periodo=negocio.ObtenerPeriodoAcademico("CLASES18")
		

consulta = "select a.pers_ncorr, pers_tape_paterno || ' ' ||  pers_tape_materno || ' ' || pers_tnombre as alumno, " & _
		"espe_tdesc, f.carr_tdesc as carrera, pers_nrut || '-' || pers_xdv as rut, alum_fmatricula " & _
		"from alumnos a, personas b, postulantes c, ofertas_academicas d, especialidades e, carreras f " & _
		"where a.pers_ncorr = b.pers_ncorr " & _
		"and a.post_ncorr = c.post_ncorr " & _
		"and a.ofer_ncorr = d.ofer_ncorr " & _
		"and d.espe_ccod = e.espe_ccod " & _
		"and e.carr_ccod = f.carr_ccod " & _
		"and a.EMAT_CCOD='1' " & _
		"and c.peri_ccod = '" & periodo &  "' " & _
		"and d.sede_ccod = '" & sede &  "' " & _
		"and b.pers_nrut = '" & rut &  "' " 
response.Write(consulta)
f_matriculados.Consultar consulta
'f_matriculados.Siguiente


%>


<html>
<head>
<title>Alumnos Matriculados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">


</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
            <td><%pagina.DibujarLenguetas Array("Búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			<form name="buscador" method="get" >
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                        <td width="81%" height="50">
<div align="center"> 
                            <table width="100%" height="30" border="0" align="center" cellpadding="0" cellspacing="0">
                              <tr align="center" valign="middle"> 
                                <td width="46%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Sede 
                                  <%f_sedes.dibujacampo("sede_ccod")%>
                                  </font></td>
                                <td width="54%" height="30"> <font face="Verdana, Arial, Helvetica, sans-serif" size="1"><br>
                                  </font><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  Rut Alumno 
                                  <%f_sedes.dibujacampo("pers_nrut")%>
                                  </font> <font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp;- 
                                  <%f_sedes.dibujacampo("pers_xdv")%><br>
                                  </font><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  </font></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.dibujaboton "buscar"%></div></td>
                </tr>
              </table>
                    <br>
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
                <td>
                  <%pagina.DibujarLenguetas Array("Alumnos"), 1 %>
                </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                    <p align="left">&nbsp; </p>
                    <table width="100%" border="0">
                      <%if RegistrosN>0 then%>
                      <tr> 
                        <td align="center"><strong>
                          <%pagina.DibujarSubtitulo "Lista de evaluaciones a nivel nacional"%>
                          </strong></td>
                      </tr>
                      <tr> 
                        <td align="center">&nbsp; </td>
                      </tr>
                      <%end if%>
                      <tr> 
                        <td align="center"><strong>
                          <%pagina.DibujarSubtitulo "Alumnos Matriculados"%>
                          </strong></td>
                      </tr>
                    </table>
                    <form name="edicion">
                      <div align="left">
                        <input name="url" type="hidden" value="<%=request.ServerVariables("HTTP_REFERER")%>">
                      </div>
                      <table width="98%" align="center">
                        <tr>
                          <td align="center"> <div align="right">P&aacute;ginas: 
                              <%f_matriculados.AccesoPagina()%>
                            </div></td>
                        </tr>
                        <tr> 
                          <td align="center">&nbsp; <%f_matriculados.dibujatabla()%> </td>
                        </tr>
                      </table>
                    </form>
                    <br>
                    <br>
                  </div>
                </td>
              </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"> </div></td>
                  <td><div align="center"> </div></td>
                  <td><div align="center"> </div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
