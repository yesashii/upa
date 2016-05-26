<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "R.U.T."

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------Modificacion 11/08/2014 para incluir datos de personas a alumni
'traspasa_personas =  " insert into alumni_personas "&_
'					 " select a.* from personas a (nolock) "&_
'					 " where not exists (select 1 from alumni_personas bb (nolock) "&_
'					 "                   where a.pers_ncorr = bb.pers_ncorr) "&_
'					 " and exists (select 1 from alumnos b (nolock) "&_
'					 "             where a.pers_ncorr=b.pers_ncorr and b.emat_ccod in (4,8)) " 
'					 
''response.write traspasa_personas
''response.write "<br><br>"
'conexion.ejecutaS(traspasa_personas)
'traspasa_direccion = " insert into alumni_direcciones "&_
'					 " select b.* from personas a (nolock), direcciones b (nolock) "&_
'					 " where a.pers_ncorr=b.pers_ncorr "&_
'					 " and not exists (select 1 from alumni_direcciones bb (nolock) "&_
'					 "				   where a.pers_ncorr = bb.pers_ncorr and b.tdir_ccod=bb.tdir_ccod) "&_
'					 " and exists (select 1 from alumnos b (nolock) "&_
'					 "				  where a.pers_ncorr=b.pers_ncorr and b.emat_ccod in (4,8))" 
''response.write traspasa_direccion
''response.write "<br><br>"
'conexion.ejecutaS(traspasa_direccion)
'---------------------------------------------------------------------------------------------Modificacion 11/08/2014
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "estadisticas_egreso_titulacion.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_rut = new CFormulario
f_rut.Carga_Parametros "estadisticas_egreso_titulacion.xml", "ingreso_rut_persona"
f_rut.Inicializar conexion
f_rut.Consultar "select '' "
f_rut.Siguiente

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
<script type="text/javascript" src="estadisticasEgresoTitulacion/js/jquery.js"></script>
<script type="text/javascript" src="estadisticasEgresoTitulacion/js/funciones_1.js" ></script>
<script type="text/javascript" src="estadisticasEgresoTitulacion/js/jquery.Rut.js"> </script>
<script language="JavaScript">
var t_rut;

function Validar()
{
//	rut = t_rut.ObtenerValor(0, "pers_nrut") + '-' + t_rut.ObtenerValor(0, "pers_xdv");
//	if (!valida_rut(rut)) {
//		alert('Ingrese un R.U.T. válido.');
//		t_rut.filas[0].campos["pers_xdv"].objeto.select();
//		return false;
//	}
//	
//	return true;
}
function InicioPagina()
{
	$("#rut_alumni_1").focus();
}
</script>





</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="InicioPagina();" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#CC6600"><table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr bgcolor="#EAEAEA">
	  	<td colspan="3">&nbsp;</td>
	  </tr>
	  <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Ingrese rut"), 1 %></td>			
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td> <form id="edicion" action="rut_alumni_proc.asp" name="edicion" method="post">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><strong>R.U.T.</strong></div></td>
                          <td width="25"><div align="center"><strong>:</strong></div></td>                          
						  <td>
                           	<input type="text" id="rut_alumni_1" name="rut_alumni_1" onBlur="verificarNan()" onKeyUp="verificarNan()" /> - 
							<input type="text" id="digito_verificador" name="digito_verificador" size="1" />
							<a href="javascript:buscar_persona('rut_alumni_1', 'digito_verificador');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a>
                          </td>
                        </tr>                    	
                      </table></td></tr>
                </table>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("aceptar_rut")%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton("cancelar")%></div></td>
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
	  <tr bgcolor="#EAEAEA">
	  	<td colspan="3">&nbsp;</td>
	  </tr>
    </table>
	<br>
	<br>	</td>
  </tr>
</table>
</body>
</html>
