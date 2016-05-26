<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_peri_ccod = Request.QueryString("b[0][peri_ccod]")
q_sede_ccod = Request.QueryString("b[0][sede_ccod]")
q_carr_ccod = Request.QueryString("b[0][carr_ccod]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Gestión Alumnos con Ramos Inscritos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario = negocio.ObtenerUsuario


'---------------------------------------------------------------------------------------------------
set f_botonera_g = new CFormulario
f_botonera_g.Carga_Parametros "botonera_generica.xml", "botonera"


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "rep_inscritos.xml", "botonera"

f_botonera.AgregaBotonUrlParam "excel", "sede_ccod", q_sede_ccod
f_botonera.AgregaBotonUrlParam "excel", "carr_ccod", q_carr_ccod
f_botonera.AgregaBotonUrlParam "excel", "peri_ccod", q_peri_ccod


'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "rep_inscritos.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod
f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod
f_busqueda.AgregaCampoCons "carr_ccod", q_carr_ccod


SQL = " select b.sede_ccod"
SQL = SQL &  " from personas a, sis_sedes_usuarios b"
SQL = SQL &  " where a.pers_ncorr = b.pers_ncorr"
SQL = SQL &  "   and cast(a.pers_nrut as varchar)= '" & v_usuario & "'"

f_busqueda.AgregaCampoParam "sede_ccod", "filtro", "sede_ccod in (" & SQL & ")"


'---------------------------------------------------------------------------------------------------
set f_inscritos = new CFormulario
f_inscritos.Carga_Parametros "rep_inscritos.xml", "inscritos"
f_inscritos.Inicializar conexion

'SQL = " SELECT CARR_TDESC CARRERA,ASIG_TDESC ASIGNATURA,SECC_TDESC SECCION,DECODE(S.JORN_CCOD,1,'D',2,'V') JORNADA,"
'SQL = SQL &  "        MC.NIVE_CCOD, COUNT(*) INSCRITOS"
'SQL = SQL &  " FROM CARGAS_ACADEMICAS CA, SECCIONES S, CARRERAS C, ASIGNATURAS A, MALLA_CURRICULAR MC"
'SQL = SQL &  " WHERE CA.SECC_CCOD=S.SECC_CCOD"
'SQL = SQL &  "   AND S.CARR_CCOD=C.CARR_CCOD"
'SQL = SQL &  "   AND S.ASIG_CCOD=A.ASIG_CCOD"
'SQL = SQL &  "   AND PERI_CCOD = '" & q_peri_ccod & "'"
'SQL = SQL &  "   AND SEDE_CCOD = '" & q_sede_ccod & "'"
'SQL = SQL &  "   AND S.CARR_CCOD = nvl('" & q_carr_ccod & "', S.CARR_CCOD)"
'SQL = SQL &  "   AND S.MALL_CCOD = MC.MALL_CCOD (+)"
'SQL = SQL &  "   AND EXISTS (SELECT 1 FROM ALUMNOS AL WHERE AL.MATR_NCORR=CA.MATR_NCORR AND EMAT_CCOD=1)"
'SQL = SQL &  "   AND EXISTS (SELECT 1 FROM BLOQUES_HORARIOS BH WHERE  BH.SECC_CCOD=S.SECC_CCOD AND EXISTS (SELECT 1 FROM BLOQUES_PROFESORES BP WHERE BP.BLOQ_CCOD=BH.BLOQ_CCOD))"
'SQL = SQL &  " GROUP BY CARR_TDESC,ASIG_TDESC,SECC_TDESC,S.JORN_CCOD, MC.NIVE_CCOD"
'SQL = SQL &  " ORDER BY CARR_TDESC,INSCRITOS"

SQL = " SELECT CARR_TDESC CARRERA,ASIG_TDESC ASIGNATURA,SECC_TDESC SECCION, CASE S.JORN_CCOD WHEN 1 THEN 'D' WHEN 2 THEN 'V' ELSE '' END as JORNADA, " & vbCrLf &_
      "        MC.NIVE_CCOD, COUNT(*) as INSCRITOS, S.SECC_CCOD,a.asig_ccod,s.secc_ncupo " & vbCrLf &_
      " FROM CARGAS_ACADEMICAS CA, SECCIONES S, CARRERAS C, ASIGNATURAS A, MALLA_CURRICULAR MC " & vbCrLf &_
      " WHERE CA.SECC_CCOD=S.SECC_CCOD " & vbCrLf &_
      "   AND S.CARR_CCOD=C.CARR_CCOD " & vbCrLf &_
      "   AND S.ASIG_CCOD=A.ASIG_CCOD " & vbCrLf &_
      "   AND cast(PERI_CCOD as varchar)= '" & q_peri_ccod & "' " & vbCrLf &_
      "   AND cast(SEDE_CCOD as varchar)= '" & q_sede_ccod & "' " & vbCrLf &_
      "   AND cast(S.CARR_CCOD as varchar)=  case '" & q_carr_ccod & "' when '' then S.CARR_CCOD else '" & q_carr_ccod & "' end " & vbCrLf &_
      "   AND S.MALL_CCOD *= MC.MALL_CCOD " & vbCrLf &_
      "   AND EXISTS (SELECT 1 FROM ALUMNOS AL WHERE AL.MATR_NCORR=CA.MATR_NCORR AND EMAT_CCOD=1) " & vbCrLf &_
      "   AND EXISTS (SELECT 1 FROM BLOQUES_HORARIOS BH WHERE  BH.SECC_CCOD=S.SECC_CCOD) " & vbCrLf &_
      " GROUP BY CARR_TDESC,ASIG_TDESC,SECC_TDESC,S.JORN_CCOD, MC.NIVE_CCOD,S.SECC_CCOD,A.ASIG_CCOD,S.SECC_NCUPO" & vbCrLf &_
      " ORDER BY CARR_TDESC,INSCRITOS"
'response.Write("<pre>"&SQL&"</pre>")
f_inscritos.Consultar SQL
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
                  <td width="81%"><div align="center"><%f_busqueda.DibujaRegistro%></div></td>
                  <td width="19%"><div align="center"><%f_botonera_g.DibujaBoton "buscar"%></div></td>
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
                    <td><%pagina.DibujarSubtitulo "Inscritos"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col"><div align="right">P&aacute;ginas : <%f_inscritos.AccesoPagina%></div></td>
                        </tr>
                        <tr>
                          <td scope="col"><div align="center"><%f_inscritos.DibujaTabla%></div></td>
                        </tr>
                        <tr>
                          <td scope="col"><div align="center"><%f_inscritos.Pagina%></div></td>
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
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "excel"%></div></td>
                  <td><div align="center"><%f_botonera_g.DibujaBoton "salir"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

