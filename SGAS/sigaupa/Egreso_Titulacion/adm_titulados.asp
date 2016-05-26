<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_carr_ccod = Request.QueryString("b[0][carr_ccod]")
q_espe_ccod = Request.QueryString("b[0][espe_ccod]")
q_plan_ccod = Request.QueryString("b[0][plan_ccod]")
q_peri_ccod = Request.QueryString("b[0][peri_ccod]")
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_solo_rut = Request.QueryString("b[0][solo_rut]")
'response.Write("solo_rut "&q_solo_rut)
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Adm. Histórico de Alumnos Titulados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new cErrores
'---------------------------------------------------------------------------------------------------
set f_botonera_g = new CFormulario
f_botonera_g.Carga_Parametros "botonera_generica.xml", "botonera"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_titulados.xml", "botonera"

'---------------------------------------------------------------------------------------------------
v_sede_ccod = negocio.ObtenerSede

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "adm_titulados.xml", "busqueda"
f_busqueda.Inicializar conexion

f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "carr_ccod", q_carr_ccod
f_busqueda.AgregaCampoCons "espe_ccod", q_espe_ccod
f_busqueda.AgregaCampoCons "plan_ccod", q_plan_ccod
f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "solo_rut", q_solo_rut


SQL = " select distinct c.carr_ccod, c.carr_tdesc, b.espe_ccod, b.espe_tdesc, d.plan_ccod, d.plan_tdesc"
SQL = SQL &  " from ofertas_academicas a, especialidades b, carreras c, planes_estudio d, periodos_academicos e"
SQL = SQL &  " where a.espe_ccod = b.espe_ccod"
SQL = SQL &  "   and b.carr_ccod = c.carr_ccod"
SQL = SQL &  "   and b.espe_ccod = d.espe_ccod	  "
SQL = SQL &  "   and a.peri_ccod = e.peri_ccod"
SQL = SQL &  "   and cast(a.sede_ccod as varchar)= '" & v_sede_ccod & "'"
SQL = SQL &  " order by c.carr_tdesc asc, b.espe_tdesc asc, d.plan_tdesc desc"

f_busqueda.InicializaListaDependiente "busqueda", SQL


'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "adm_titulados.xml", "encabezado"
f_encabezado.Inicializar conexion

SQL = " select c.carr_tdesc, b.espe_tdesc, a.plan_ncorrelativo,a.plan_tdesc"
SQL = SQL &  " from planes_estudio a, especialidades b, carreras c"
SQL = SQL &  " where a.espe_ccod = b.espe_ccod"
SQL = SQL &  "   and b.carr_ccod = c.carr_ccod"
SQL = SQL &  "   and cast(a.plan_ccod as varchar)= '" & q_plan_ccod & "'"

f_encabezado.Consultar SQL

if f_encabezado.NroFilas > 0 then
	f_encabezado.AgregaCampoCons "peri_ccod", q_peri_ccod
end if


'---------------------------------------------------------------------------------------------------
set f_titulados = new CFormulario
f_titulados.Carga_Parametros "adm_titulados.xml", "titulados"
f_titulados.Inicializar conexion

'SQL = " select a.egre_ncorr, a.pers_ncorr, a.egre_fmatricula, a.egre_ftitulacion, a.egre_nregistro_titulo, a.egre_nfolio_titulo, a.egre_nfolio_titulo || ' / ' || a.egre_nregistro_titulo as folio_reg, 1 as q, "
'SQL = SQL &  "        to_char(a.egre_nnota_titulacion, '0.0') as egre_nnota_titulacion, a.egre_bingr_manual, a.peri_ccod, a.plan_ccod, "
'SQL = SQL &  " 	   obtener_rut(a.pers_ncorr) as rut, obtener_nombre_completo(a.pers_ncorr, 'PM,N') as nombre, b.pers_nrut, b.pers_xdv"
'SQL = SQL &  " from egresados a, personas b "
'SQL = SQL &  " where a.pers_ncorr = b.pers_ncorr "
'SQL = SQL &  "   and a.peri_ccod = '" & q_peri_ccod & "' "
'SQL = SQL &  "   and a.plan_ccod = '" & q_plan_ccod & "'"
'SQL = SQL &  " order by nombre asc"


SQL = "  select a.salu_ncorr, a.pers_ncorr, protic.obtener_rut(a.pers_ncorr) as rut, protic.initcap(protic.obtener_nombre_completo(a.pers_ncorr, 'PM,N')) as nombre,"& vbCrLf &_
      "         a.salu_nregistro, a.salu_nfolio, cast(a.salu_nnota as decimal(2,1)) as salu_nnota, a.salu_fsalida,"& vbCrLf &_
      " 		b.peri_ccod, b.plan_ccod, b.sede_ccod, c.pers_nrut, c.pers_xdv,       "& vbCrLf &_
      "      cast(a.salu_nfolio as varchar) + ' / ' + cast(a.salu_nregistro as varchar) as folio_reg, protic.initcap(d.tspl_tdesc + ' : ' + b.sapl_tdesc) as titulo_grado "& vbCrLf &_
      " from salidas_alumnos a, salidas_plan b, personas c,"& vbCrLf &_
      "       tipos_salidas_plan d"& vbCrLf &_
      "  where a.sapl_ncorr = b.sapl_ncorr "& vbCrLf &_
      "    and a.pers_ncorr = c.pers_ncorr "& vbCrLf &_
      "    and b.tspl_ccod = d.tspl_ccod "& vbCrLf &_
      "    and b.tspl_ccod in (2, 3, 4) "
	  if q_solo_rut = "0" then
		   SQL = SQL & "    and cast(b.peri_ccod as varchar)= '" & q_peri_ccod & "' "& vbCrLf &_
					   "    and cast(b.plan_ccod as varchar)= '" & q_plan_ccod & "' "
	  else
	  		SQL = SQL & " and cast(c.pers_nrut as varchar)='"&q_pers_nrut&"' and c.pers_xdv='"&q_pers_xdv&"' "
	  end if			  
            SQL = SQL & " order by nombre asc, b.tspl_ccod asc"

'response.Write("<pre>"&SQL&"</pre>")

f_titulados.Consultar SQL

if q_solo_rut <> "0" then 
	q_plan_ccod = conexion.consultaUno("select plan_ccod from alumnos a, personas b where a.pers_ncorr=b.pers_ncorr and a.emat_ccod=8 and cast(b.pers_nrut as varchar)= '"&q_pers_nrut&"'")
	q_peri_ccod = conexion.consultaUno("select peri_ccod from alumnos a, ofertas_academicas b, personas c where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=8 and a.pers_ncorr=c.pers_ncorr and cast(c.pers_nrut as varchar)= '"&q_pers_nrut&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"'")
end if


'------------------------------------------------------------------------------------------------
if f_encabezado.NroFilas = 0 then
	f_botonera.AgregaBotonParam "agregar", "deshabilitado", "TRUE"
	f_botonera.AgregaBotonParam "eliminar", "deshabilitado", "TRUE"
else
	f_botonera.AgregaBotonUrlParam "agregar", "dp[0][plan_ccod]", q_plan_ccod
	f_botonera.AgregaBotonUrlParam "agregar", "dp[0][peri_ccod]", q_peri_ccod
end if
'response.Write(q_plan_ccod)
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

<% f_busqueda.GeneraJS %>


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
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0">
                      <tr>
                        <td width="10%"><strong>Carrera</strong></td>
                        <td width="2%"><strong>:</strong></td>
                        <td colspan="4">                          <%f_busqueda.DibujaCampoLista "busqueda", "carr_ccod"%></td>
                      </tr>
					  <tr>
                        <td width="10%"><strong>Especialidad</strong></td>
                        <td width="2%"><strong>:</strong></td>
                        <td colspan="4"><%f_busqueda.DibujaCampoLista "busqueda", "espe_ccod"%></td>
                      </tr>
                      <tr>
                        <td width="10%"><strong>Plan</strong></td>
                        <td width="2%"><strong>:</strong></td>
                        <td width="38%"><%f_busqueda.DibujaCampoLista "busqueda", "plan_ccod"%></td>
                        <td width="25%" align="right"><strong>Periodo Titulación </strong></td>
                        <td width="2%"><strong>:</strong></td>
                        <td width="28%"><%f_busqueda.DibujaCampo "peri_ccod"%></td>
                      </tr>
					  <tr><td colspan="6"><hr></td></tr>
					  <tr>
                        <td width="10%"><strong>Sólo Rut</strong></td>
                        <td width="2%"><strong>:</strong></td>
                        <td width="38%"><%f_busqueda.DibujaCampo("solo_rut")%></td>
                        <td width="25%" align="right"><strong>Rut</strong></td>
                        <td width="2%"><strong>:</strong></td>
                        <td width="28%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('b[0][pers_nrut]', 'b[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                                <td>
                                  <%f_botonera_g.DibujaBoton "buscar"%>
                                </td>
                      </tr>
                    </table>
                  </div></td>
                  
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
			  <%if q_solo_rut = "0" then%>
              <table width="98%"  border="0">
                <tr>
                  <td scope="col"><div align="center"><%f_encabezado.DibujaRegistro%></div></td>
                </tr>
              </table>
			  <%end if%>
               </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Listado de alumnos titulados"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col"><div align="right">P&aacute;ginas : <%f_titulados.AccesoPagina%></div></td>
                        </tr>
                        <tr>
                          <td scope="col"><div align="center"><%f_titulados.DibujaTabla%></div></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "agregar"%></div></td>
                  <td><div align="center">
                  </div></td>
                  <td><div align="center"><%f_botonera_g.DibujaBoton "salir"%></div></td>
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
