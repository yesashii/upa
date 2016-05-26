<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_sapl_ncorr = Request.QueryString("sapl_ncorr")
q_pers_nrut = Request.QueryString("pers_nrut")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Agregar requisitos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_requisitos_titulacion.xml", "botonera"

set f_botonera_g = new CFormulario
f_botonera_g.Carga_Parametros "botonera_generica.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "adm_requisitos_titulacion.xml", "encabezado"
f_encabezado.Inicializar conexion

'SQL = " select d.carr_tdesc, c.espe_tdesc, b.plan_ncorrelativo, e.tspl_tdesc, a.sapl_tdesc, f.peri_tdesc," & vbCrlf & _
'      "        obtener_rut(g.pers_ncorr) as rut, obtener_nombre_completo(g.pers_ncorr) as nombre" & vbCrlf & _
'      " from salidas_plan a, planes_estudio b, especialidades c, carreras d, tipos_salidas_plan e, periodos_academicos f, personas g" & vbCrlf & _
'      " where a.plan_ccod = b.plan_ccod" & vbCrlf & _
'      "   and b.espe_ccod = c.espe_ccod" & vbCrlf & _
'      "   and c.carr_ccod = d.carr_ccod" & vbCrlf & _
'      "   and a.tspl_ccod = e.tspl_ccod" & vbCrlf & _
'      "   and a.peri_ccod = f.peri_ccod" & vbCrlf & _
'      "   and g.pers_nrut = '" & q_pers_nrut & "'" & vbCrlf & _
'      "   and a.sapl_ncorr = '" & q_sapl_ncorr & "'" 
	  
SQL = " select d.carr_tdesc, c.espe_tdesc, b.plan_tdesc, e.tspl_tdesc, a.sapl_tdesc, f.peri_tdesc," & vbCrlf & _
      "        protic.obtener_rut(g.pers_ncorr) as rut, protic.obtener_nombre_completo(g.pers_ncorr,'n') as nombre" & vbCrlf & _
      " from salidas_plan a, planes_estudio b, especialidades c, carreras d, tipos_salidas_plan e, periodos_academicos f, personas g" & vbCrlf & _
      " where a.plan_ccod = b.plan_ccod" & vbCrlf & _
      "   and b.espe_ccod = c.espe_ccod" & vbCrlf & _
      "   and c.carr_ccod = d.carr_ccod" & vbCrlf & _
      "   and a.tspl_ccod = e.tspl_ccod" & vbCrlf & _
      "   and a.peri_ccod = f.peri_ccod" & vbCrlf & _
      "   and cast(g.pers_nrut as varchar)= '" & q_pers_nrut & "'" & vbCrlf & _
      "   and cast(a.sapl_ncorr as varchar)= '" & q_sapl_ncorr & "'" 

f_encabezado.Consultar SQL
'response.Write("<pre>"&SQL&"</pre>")

'---------------------------------------------------------------------------------------------------
set f_requisitos = new CFormulario
f_requisitos.Carga_Parametros "adm_requisitos_titulacion.xml", "requisitos_persona"
f_requisitos.Inicializar conexion

'SQL = " select d.teva_ccod, b.repl_ncorr, c.pers_ncorr, d.treq_tdesc, e.teva_tdesc, b.repl_nponderacion" & vbCrlf & _
'      " from salidas_plan a, requisitos_plan b, personas c, tipos_requisitos_titulo d, tipos_evaluacion_requisitos e" & vbCrlf & _
'      " where a.sapl_ncorr = b.sapl_ncorr" & vbCrlf & _
'      "   and b.treq_ccod = d.treq_ccod" & vbCrlf & _
'      "   and d.teva_ccod = e.teva_ccod" & vbCrlf & _
'      "   and c.pers_nrut = '" & q_pers_nrut & "'" & vbCrlf & _
'      "   and a.sapl_ncorr = '" & q_sapl_ncorr & "'" & vbCrlf & _
'      "   and not exists (select 1" & vbCrlf & _
'      "                   from requisitos_titulacion a2" & vbCrlf & _
'      " 				  where a2.pers_ncorr = c.pers_ncorr" & vbCrlf & _
'      " 				    and a2.repl_ncorr = b.repl_ncorr)" & vbCrlf & _
'      " order by b.treq_ccod" 
	  
SQL = " select d.teva_ccod, b.repl_ncorr, c.pers_ncorr, d.treq_tdesc, e.teva_tdesc, b.repl_nponderacion" & vbCrlf & _
      " from salidas_plan a, requisitos_plan b, personas c, tipos_requisitos_titulo d, tipos_evaluacion_requisitos e" & vbCrlf & _
      " where a.sapl_ncorr = b.sapl_ncorr" & vbCrlf & _
      "   and b.treq_ccod = d.treq_ccod" & vbCrlf & _
      "   and d.teva_ccod = e.teva_ccod" & vbCrlf & _
      "   and cast(c.pers_nrut as varchar) = '" & q_pers_nrut & "'" & vbCrlf & _
      "   and cast(a.sapl_ncorr as varchar)= '" & q_sapl_ncorr & "'" & vbCrlf & _
      "   and not exists (select 1" & vbCrlf & _
      "                   from requisitos_titulacion a2" & vbCrlf & _
      " 				  where a2.pers_ncorr = c.pers_ncorr" & vbCrlf & _
      " 				    and a2.repl_ncorr = b.repl_ncorr)" & vbCrlf & _
      " order by b.treq_ccod" 

'response.Write("<pre>"&SQL&"</pre>")
'response.End()
f_requisitos.Consultar SQL

i_ = 0
while f_requisitos.Siguiente
	v_teva_ccod = f_requisitos.ObtenerValor("teva_ccod")
	
	if v_teva_ccod = "2" then
		f_requisitos.AgregaCampoFilaParam i_, "reti_nnota", "permiso", "LECTURA"
	end if
	
	i_ = i_ + 1
wend

f_requisitos.Primero

'---------------------------------------------------------------------------------------------------

if f_requisitos.NroFilas = 0 then
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
var v_nota_aprobacion = parseFloat('<%=negocio.ObtenerParametroSistema("NOTA_APROBACION")%>');

function reti_nnota_change(p_objeto)
{
	var v_reti_nnota = p_objeto.value;
	
	if (isNumber(v_reti_nnota)) {		
		if (parseFloat(v_reti_nnota) >= v_nota_aprobacion) {
			t_requisitos.AsignarValor(_FilaCampo(p_objeto), "ereq_ccod", 1);
		}
		else {
			t_requisitos.AsignarValor(_FilaCampo(p_objeto), "ereq_ccod", 2);
		}
	}
}


function HabilitarFila()
{
	var objeto = event.srcElement;	
	t_requisitos.filas[_FilaCampo(objeto)].HabilitarPorCampo(objeto.checked, "repl_ncorr");
}


var t_requisitos;

function Inicio()
{
	t_requisitos = new CTabla("rt");
	
	for (var i = 0; i < t_requisitos.filas.length; i++) {
		t_requisitos.filas[i].campos["repl_ncorr"].objeto.attachEvent('onclick', HabilitarFila);
	}
}


</script>



</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); Inicio();" onBlur="revisaVentana();">
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
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Requisitos por agregar"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center">
                            <%f_requisitos.DibujaTabla%>
                          </div></td>
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
                  <td><div align="center">
                    <%f_botonera_g.DibujaBoton "cancelar"%>
                  </div></td>
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
