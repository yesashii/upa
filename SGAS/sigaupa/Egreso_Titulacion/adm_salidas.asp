<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION				:	
'FECHA CREACIÓN				:
'CREADO POR					:
'ENTRADA					: NA
'SALIDA						: NA
'MODULO QUE ES UTILIZADO	: EGRESO Y TITULACIÓN
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 18/02/2013
'ACTUALIZADO POR			: Luis Herrera G.
'MOTIVO						: Corregir código, eliminar sentencia *=
'LINEA						: 111, 117
'********************************************************************

q_carr_ccod = Request.QueryString("b[0][carr_ccod]")
q_espe_ccod = Request.QueryString("b[0][espe_ccod]")
q_plan_ccod = Request.QueryString("b[0][plan_ccod]")
q_peri_ccod = Request.QueryString("b[0][peri_ccod]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Adm. Salidas Plan de Estudios"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set errores = new CErrores

'---------------------------------------------------------------------------------------------------
v_sede_ccod = negocio.ObtenerSede

'---------------------------------------------------------------------------------------------------
set f_botonera_g = new CFormulario
f_botonera_g.Carga_Parametros "botonera_generica.xml", "botonera"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_salidas.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "adm_salidas.xml", "busqueda"
f_busqueda.Inicializar conexion

f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "carr_ccod", q_carr_ccod
f_busqueda.AgregaCampoCons "espe_ccod", q_espe_ccod
f_busqueda.AgregaCampoCons "plan_ccod", q_plan_ccod
f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod


SQL = " select distinct c.carr_ccod, c.carr_tdesc, b.espe_ccod, b.espe_tdesc, d.plan_ccod, d.plan_tdesc "
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
f_encabezado.Carga_Parametros "adm_salidas.xml", "encabezado"
f_encabezado.Inicializar conexion

SQL = " select c.carr_tdesc, b.espe_tdesc, a.plan_tdesc"
SQL = SQL &  " from planes_estudio a, especialidades b, carreras c"
SQL = SQL &  " where a.espe_ccod = b.espe_ccod"
SQL = SQL &  "   and b.carr_ccod = c.carr_ccod"
SQL = SQL &  "   and cast(a.plan_ccod as varchar)= '" & q_plan_ccod & "'"
'response.Write(SQL)
f_encabezado.Consultar SQL

if f_encabezado.NroFilas > 0 then
	f_encabezado.AgregaCampoCons "peri_ccod", q_peri_ccod
	f_encabezado.AgregaCampoCons "plan_ccod", q_plan_ccod
end if


'---------------------------------------------------------------------------------------------------
set f_salidas = new CFormulario
f_salidas.Carga_Parametros "adm_salidas.xml", "salidas"
f_salidas.Inicializar conexion



'SQL = " select a.tspl_ccod, a.sapl_ncorr, a.tspl_tdesc, a.sapl_tdesc, a.peri_ccod, a.sede_ccod, a.plan_ccod, a.sapl_npond_asignaturas, a.asignaturas,"& vbCrLf & _
'      "        count(b.repl_ncorr) as adicionales, sum(b.repl_nponderacion) as pond_adicionales"& vbCrLf & _
'      " from (  select a.tspl_ccod, a.sapl_ncorr, b.tspl_tdesc, a.sapl_tdesc, a.peri_ccod, a.sede_ccod, a.plan_ccod, a.sapl_npond_asignaturas, "& vbCrLf & _
'      " 		       count(c.mall_ccod) as asignaturas "& vbCrLf & _
'      " 		from salidas_plan a, tipos_salidas_plan b, asignaturas_salidas c    "& vbCrLf & _
'      " 		where a.tspl_ccod = b.tspl_ccod "& vbCrLf & _
'      " 		  and a.sapl_ncorr *= c.sapl_ncorr "& vbCrLf & _
'      "       and cast(a.plan_ccod as varchar)= '" & q_plan_ccod & "' "& vbCrLf & _
'      "       and cast(a.peri_ccod as varchar)= '" & q_peri_ccod & "' "& vbCrLf & _
'      "       and cast(a.sede_ccod as varchar)= '" & v_sede_ccod & "' "& vbCrLf & _
'      " 		group by a.tspl_ccod, a.sapl_ncorr, b.tspl_tdesc, a.sapl_tdesc, a.peri_ccod, a.sede_ccod, a.plan_ccod, a.sapl_npond_asignaturas "& vbCrLf & _
'      " 		) a, requisitos_plan b "& vbCrLf & _
'      " where a.sapl_ncorr *= b.sapl_ncorr "& vbCrLf & _
'      " group by a.tspl_ccod, a.sapl_ncorr, a.tspl_tdesc, a.sapl_tdesc, a.peri_ccod, a.sede_ccod, a.plan_ccod, a.sapl_npond_asignaturas, a.asignaturas "& vbCrLf & _
'      " order by a.tspl_ccod, a.sapl_ncorr "
SQL = "select a.tspl_ccod, "& vbCrLf & _
	"	a.sapl_ncorr, "& vbCrLf & _
	"	a.tspl_tdesc, "& vbCrLf & _
	"	a.sapl_tdesc, "& vbCrLf & _
	"	a.peri_ccod, "& vbCrLf & _
	"	a.sede_ccod, "& vbCrLf & _
	"	a.plan_ccod, "& vbCrLf & _
	"	a.sapl_npond_asignaturas, "& vbCrLf & _
	"	a.asignaturas, "& vbCrLf & _
	"	count(b.repl_ncorr) as adicionales, "& vbCrLf & _
	"	sum(b.repl_nponderacion) as pond_adicionales "& vbCrLf & _
	"from "& vbCrLf & _
	"	( "& vbCrLf & _ 
	"		select a.tspl_ccod, "& vbCrLf & _
	"			a.sapl_ncorr, "& vbCrLf & _
	"			b.tspl_tdesc, "& vbCrLf & _
	"			a.sapl_tdesc, "& vbCrLf & _
	"			a.peri_ccod, "& vbCrLf & _
	"			a.sede_ccod, "& vbCrLf & _
	"			a.plan_ccod, "& vbCrLf & _
	"			a.sapl_npond_asignaturas, "& vbCrLf & _
	"			count(c.mall_ccod) as asignaturas "& vbCrLf & _
	"		from salidas_plan a "& vbCrLf & _
	"		join tipos_salidas_plan b "& vbCrLf & _
	"			on a.tspl_ccod = b.tspl_ccod "& vbCrLf & _
	"			and cast(a.plan_ccod as varchar)= '" & q_plan_ccod & "' "& vbCrLf & _
	"			and cast(a.peri_ccod as varchar)= '" & q_peri_ccod & "' "& vbCrLf & _
	"			and cast(a.sede_ccod as varchar)= '" & v_sede_ccod & "' "& vbCrLf & _
	"		left outer join asignaturas_salidas c "& vbCrLf & _	
	"			on a.sapl_ncorr = c.sapl_ncorr 	"& vbCrLf & _
	"		group by a.tspl_ccod, "& vbCrLf & _
	"			a.sapl_ncorr, "& vbCrLf & _
	"			b.tspl_tdesc, "& vbCrLf & _
	"			a.sapl_tdesc, "& vbCrLf & _
	"			a.peri_ccod, "& vbCrLf & _
	"			a.sede_ccod, "& vbCrLf & _
	"			a.plan_ccod, "& vbCrLf & _
	"			a.sapl_npond_asignaturas "& vbCrLf & _
	"	) as a "& vbCrLf & _
	"left outer join requisitos_plan b "& vbCrLf & _	
	"	on a.sapl_ncorr = b.sapl_ncorr "& vbCrLf & _
	"group by a.tspl_ccod, "& vbCrLf & _
	"	a.sapl_ncorr, "& vbCrLf & _
	"	a.tspl_tdesc, "& vbCrLf & _
	"	a.sapl_tdesc, "& vbCrLf & _
	"	a.peri_ccod, "& vbCrLf & _
	"	a.sede_ccod, "& vbCrLf & _
	"	a.plan_ccod, "& vbCrLf & _
	"	a.sapl_npond_asignaturas, "& vbCrLf & _
	"	a.asignaturas "& vbCrLf & _
	"order by a.tspl_ccod, "& vbCrLf & _
	"	a.sapl_ncorr "
'response.Write("<pre>"&SQL&"</pre>")

f_salidas.Consultar SQL


'---------------------------------------------------------------------------------------------------
if f_encabezado.NroFilas = 0 then
	f_botonera.AgregaBotonParam "agregar", "deshabilitado", "TRUE"	
end if

if f_salidas.NroFilas = 0 then
	f_botonera.AgregaBotonParam "eliminar", "deshabilitado", "TRUE"
end if

f_botonera.AgregaBotonUrlParam "agregar", "peri_ccod", q_peri_ccod
f_botonera.AgregaBotonUrlParam "agregar", "plan_ccod", q_plan_ccod
f_botonera.AgregaBotonUrlParam "agregar", "sede_ccod", v_sede_ccod

'---------------------------------------------------------------------------------------------------



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

<% f_busqueda.GeneraJS %>

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
                  <td width="91%"><div align="center">
                    <table width="98%"  border="0">
                      <tr>
                        <td><strong>Carrera</strong></td>
                        <td><strong>:</strong></td>
                        <td colspan="5"><%f_busqueda.DibujaCampoLista "busqueda", "carr_ccod"%></td>
                      </tr>
					  <tr>
                        <td><strong>Especialidad</strong></td>
                        <td><strong>:</strong></td>
                        <td colspan="5"><%f_busqueda.DibujaCampoLista "busqueda", "espe_ccod"%></td>
                      </tr>
                      <tr>
                        <td><strong>Plan</strong></td>
                        <td><strong>:</strong></td>
                        <td><%f_busqueda.DibujaCampoLista "busqueda", "plan_ccod"%></td>
                        <td>&nbsp;</td>
                        <td><strong>Per&iacute;odo de Egreso </strong></td>
                        <td><strong>:</strong></td>
                        <td><%f_busqueda.DibujaCampo "peri_ccod"%></td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
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
                  <td width="9%"><div align="center"> </div></td>
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
                  <td scope="col"><div align="center">
                    <%f_encabezado.DibujaRegistro%>
                  </div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Salidas del plan"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col"><div align="center"><%f_salidas.DibujaTabla%></div></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton "eliminar"%></div></td>
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
