<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Directores de carrera"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
v_sede_ccod = negocio.ObtenerSede
'response.Write("v_sede_ccod = "&v_sede_ccod)
'response.End
'--v_sede_ccod = 1 -->>LAS CONDES
'--v_sede_ccod = 4 -->>MELIPILLA

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_directores_carrera.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_carreras = new CFormulario
f_carreras.Carga_Parametros "adm_directores_carrera.xml", "carreras"
f_carreras.Inicializar conexion

'consulta = "select nvl(to_char(c.pers_nrut), ' ') as pers_nrut, a.sede_ccod, a.carr_ccod, a.carr_tdesc, obtener_nombre_completo(b.pers_ncorr) as nombre_director, obtener_rut(b.pers_ncorr) as rut_director " & vbCrLf &_
'          "from (select distinct a.sede_ccod, c.carr_ccod, c.carr_tdesc " & vbCrLf &_
'		   "      from ofertas_academicas a, especialidades b, carreras c " & vbCrLf &_
'		   "	  where a.espe_ccod = b.espe_ccod " & vbCrLf &_
'		   "	    and b.carr_ccod = c.carr_ccod " & vbCrLf &_
'		   "		and a.sede_ccod = '" & v_sede_ccod & "' " & vbCrLf &_
'		   "	  ) a, cargos_carrera b, personas c " & vbCrLf &_
'		   "where a.carr_ccod = b.carr_ccod (+) " & vbCrLf &_
'		   "  and a.sede_ccod = b.sede_ccod (+) " & vbCrLf &_
'		   "  and b.pers_ncorr = c.pers_ncorr (+) " & vbCrLf &_
'		   "  and b.tcar_ccod (+) = 1 " & vbCrLf &_
'		   "order by a.carr_tdesc asc"
		   
consulta = " select isnull(cast(c.pers_nrut as varchar), ' ') as pers_nrut, a.sede_ccod, a.carr_ccod, a.carr_tdesc, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_director, " & vbCrLf &_
		   " protic.obtener_rut(b.pers_ncorr) as rut_director, " & vbCrLf &_
		   " (select sede_tdesc from sedes se where se.sede_ccod=a.sede_ccod) as sede,a.jorn_ccod, " & vbCrLf &_
		   " (select jorn_tdesc from jornadas jj where jj.jorn_ccod=a.jorn_ccod) as jornada " & vbCrLf &_
		   " from " & vbCrLf &_
		   " (select distinct a.sede_ccod, c.carr_ccod, c.carr_tdesc,a.jorn_ccod " & vbCrLf &_
		   "  from ofertas_academicas a, especialidades b, carreras c " & vbCrLf &_
		   "	  where a.espe_ccod = b.espe_ccod " & vbCrLf &_
		   "	    and b.carr_ccod = c.carr_ccod " & vbCrLf &_
		   "		and cast(a.sede_ccod as varchar)= '"&v_sede_ccod&"' " & vbCrLf &_
		   " ) a left outer join cargos_carrera b " & vbCrLf &_
		   "        on  a.carr_ccod = b.carr_ccod  and a.sede_ccod = b.sede_ccod and 1 = b.tcar_ccod and a.jorn_ccod = b.jorn_ccod " & vbCrLf &_
		   "    left outer join personas c " & vbCrLf &_
		   "        on  b.pers_ncorr = c.pers_ncorr " & vbCrLf &_
		   " order by a.carr_tdesc asc"		   
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_carreras.Consultar consulta
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
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<%if false then%>
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
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center"></div></td>
                  <td width="19%"><div align="center">BUSCAR</div></td>
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
	<%end if%>
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
              <br>
              <table width="98%"  border="0">
                <tr>
                  <td scope="col"><div align="center"></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Carreras"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col"><div align="center"><%f_carreras.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
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
            <td width="15%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "salir"%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="85%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
