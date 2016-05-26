<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION				:	
'FECHA CREACIÓN				:
'CREADO POR					:
'ENTRADA					: NA
'SALIDA						: NA
'MODULO QUE ES UTILIZADO	: EGRESO Y TITULACION
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 20/02/2013
'ACTUALIZADO POR			: Luis Herrera G.
'MOTIVO						: Corregir código, eliminar sentencia *=
'LINEA						: 61
'********************************************************************

q_sapl_ncorr = Request.QueryString("sapl_ncorr")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Agregar requisitos adicionales"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

q_plan_ccod = conexion.consultaUno("Select plan_ccod from salidas_plan where cast(sapl_ncorr as varchar)='"&q_sapl_ncorr&"'")
'response.Write("plan "&q_plan_ccod)
'---------------------------------------------------------------------------------------------------
set f_botonera_g = new CFormulario
f_botonera_g.Carga_Parametros "botonera_generica.xml", "botonera"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_requisitos_adicionales.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "adm_requisitos_adicionales.xml", "encabezado"
f_encabezado.Inicializar conexion

'SQL = " select a.plan_ccod, b.espe_ccod, c.carr_ccod, a.peri_ccod, d.tspl_tdesc, a.sapl_tdesc, e.carr_tdesc, c.espe_tdesc, b.plan_tdesc," & vbCrLf &_
'      "        f.peri_tdesc, a.sapl_npond_asignaturas," & vbCrLf &_
'      " 	   sum(g.repl_nponderacion) as pond_adicionales," & vbCrLf &_
'      " 	   isnull(a.sapl_npond_asignaturas, 0) + isnull(sum(g.repl_nponderacion), 0) as pond_total " & vbCrLf &_
'      " from salidas_plan a, planes_estudio b, especialidades c, tipos_salidas_plan d, carreras e, periodos_academicos f," & vbCrLf &_
'      "      requisitos_plan g" & vbCrLf &_
'      " where a.plan_ccod = b.plan_ccod" & vbCrLf &_
'      "   and b.espe_ccod = c.espe_ccod" & vbCrLf &_
'      "   and a.tspl_ccod = d.tspl_ccod" & vbCrLf &_
'      "   and c.carr_ccod = e.carr_ccod " & vbCrLf &_
'      "   and a.peri_ccod = f.peri_ccod" & vbCrLf &_
'      "   and a.sapl_ncorr *= g.sapl_ncorr " & vbCrLf &_
'      "   and cast(a.sapl_ncorr as varchar)= '" & q_sapl_ncorr & "'" & vbCrLf &_
'      " group by a.plan_ccod, b.espe_ccod, c.carr_ccod, a.peri_ccod, d.tspl_tdesc, a.sapl_tdesc, e.carr_tdesc, c.espe_tdesc, b.plan_tdesc," & vbCrLf &_
'      "        f.peri_tdesc, a.sapl_npond_asignaturas"

SQL = "select a.plan_ccod, " & vbCrLf &_
		"	b.espe_ccod, " & vbCrLf &_
		"	c.carr_ccod, " & vbCrLf &_
		"	a.peri_ccod, " & vbCrLf &_
		"	d.tspl_tdesc, " & vbCrLf &_
		"	a.sapl_tdesc, " & vbCrLf &_
		"	e.carr_tdesc, " & vbCrLf &_
		"	c.espe_tdesc, " & vbCrLf &_
		"	b.plan_tdesc, " & vbCrLf &_
		"	f.peri_tdesc, " & vbCrLf &_
		"	a.sapl_npond_asignaturas, " & vbCrLf &_
		"   sum(g.repl_nponderacion) as pond_adicionales, " & vbCrLf &_
		"	isnull(a.sapl_npond_asignaturas, 0) + isnull(sum(g.repl_nponderacion), 0) as pond_total " & vbCrLf &_
		"from salidas_plan a " & vbCrLf &_	
		"join planes_estudio b " & vbCrLf &_	
		"	on a.plan_ccod = b.plan_ccod " & vbCrLf &_
		"join especialidades c " & vbCrLf &_
		"	on b.espe_ccod = c.espe_ccod " & vbCrLf &_
		"join tipos_salidas_plan d " & vbCrLf &_
		"	on a.tspl_ccod = d.tspl_ccod " & vbCrLf &_
		"join carreras e " & vbCrLf &_
		"	on c.carr_ccod = e.carr_ccod " & vbCrLf &_
		"join periodos_academicos f " & vbCrLf &_
		"	on a.peri_ccod = f.peri_ccod " & vbCrLf &_
		"left outer join requisitos_plan g " & vbCrLf &_
		"	on a.sapl_ncorr = g.sapl_ncorr " & vbCrLf &_
		"where cast(a.sapl_ncorr as varchar)= '" & q_sapl_ncorr & "'" & vbCrLf &_
		"group by a.plan_ccod, " & vbCrLf &_
		"	b.espe_ccod, " & vbCrLf &_
		"	c.carr_ccod, " & vbCrLf &_
		"	a.peri_ccod, " & vbCrLf &_
		"	d.tspl_tdesc, " & vbCrLf &_
		"	a.sapl_tdesc, " & vbCrLf &_
		"	e.carr_tdesc, " & vbCrLf &_
		"	c.espe_tdesc, " & vbCrLf &_
		"	b.plan_tdesc, " & vbCrLf &_
		"	f.peri_tdesc, " & vbCrLf &_
		"	a.sapl_npond_asignaturas "
'response.Write("<pre>"&SQL&"</pre>")
f_encabezado.Consultar SQL
f_encabezado.Siguiente


'---------------------------------------------------------------------------------------------------
set f_requisitos_disponibles = new CFormulario
f_requisitos_disponibles.Carga_Parametros "adm_requisitos_adicionales.xml", "tipos_requisitos"
f_requisitos_disponibles.Inicializar conexion


SQL = " select a.treq_ccod, a.treq_tdesc, b.teva_ccod, b.teva_tdesc" & vbCrLf &_
      " from tipos_requisitos_titulo a, tipos_evaluacion_requisitos b" & vbCrLf &_
      " where a.teva_ccod = b.teva_ccod" & vbCrLf &_
      "   and not exists (select 1" & vbCrLf &_
      "                   from requisitos_plan a2" & vbCrLf &_
      " 				  where a2.treq_ccod = a.treq_ccod" & vbCrLf &_
      " 				    and cast(a2.sapl_ncorr as varchar)= '" & q_sapl_ncorr & "')" & vbCrLf &_
      " order by a.treq_ccod"

f_requisitos_disponibles.Consultar SQL

i_ = 0
while f_requisitos_disponibles.Siguiente
	if f_requisitos_disponibles.ObtenerValor("teva_ccod") = "2" then
		f_requisitos_disponibles.AgregaCampoFilaParam i_, "repl_nponderacion", "permiso", "LECTURA"
	end if
	
	f_requisitos_disponibles.AgregaCampoFilaCons i_, "sapl_ncorr", q_sapl_ncorr
	
	i_ = i_ + 1
wend

f_requisitos_disponibles.Primero


'---------------------------------------------------------------------------------------------------
if f_requisitos_disponibles.NroFilas = 0 then
	f_botonera.AgregaBotonParam "aceptar", "deshabilitado", "TRUE"
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

<script language="JavaScript">


function HabilitarFila()
{
	var objeto = event.srcElement;	
	t_requisitos.filas[_FilaCampo(objeto)].HabilitarPorCampo(objeto.checked, "treq_ccod");
}


var t_requisitos;

function InicioPagina()
{
	t_requisitos = new CTabla("rp");
	
	for (var i = 0; i < t_requisitos.filas.length; i++) {
		t_requisitos.filas[i].campos["treq_ccod"].objeto.attachEvent('onclick', HabilitarFila);
	}
}


</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetas Array("Agregar"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <table width="98%"  border="0" align="center">
              <tr>
                <td><div align="center"><%f_encabezado.DibujaRegistro%></div></td>
              </tr>
            </table>
                  <form name="edicion">
				  <input type="hidden" name="plan_ccod" value="<%=q_plan_ccod%>">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Requisitos disponibles"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_requisitos_disponibles.DibujaTabla%></div></td>
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
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "aceptar"%></div></td>
                  <td><div align="center"><%f_botonera_g.DibujaBoton "cancelar"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
