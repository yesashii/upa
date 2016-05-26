<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pers_ncorr = Request.QueryString("pers_ncorr")
set pagina = new CPagina
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Mant_Bloqueos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
Sede = negocio.ObtenerSede()
set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Bloqueos.xml", "f_nuevo"
formulario.Inicializar conexion

consulta = "select '' as bloq_tobservacion from dual"

formulario.Consultar consulta
'formulario.AgregaCampoCons "envi_fenvio", date()
formulario.Siguiente

'-------------------------------------------------------------
consulta = "SELECT * FROM cuentas_corrientes where sede_ccod=" & Sede
conexion.Ejecuta consulta
set rec_cuentas = conexion.ObtenerRS

%>


<html>
<head>
<title>Nuevo Bloqueo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
arr_especialidades = new Array();

<%
rec_cuentas.MoveFirst
i = 0
while not rec_cuentas.Eof
%>
arr_especialidades[<%=i%>] = new Array();
arr_especialidades[<%=i%>]["ccte_ccod"] = '<%=rec_cuentas("ccte_ccod")%>';
arr_especialidades[<%=i%>]["ccte_tdesc"] = '<%=rec_cuentas("ccte_tdesc")%>';
arr_especialidades[<%=i%>]["inen_ccod"] = '<%=rec_cuentas("inen_ccod")%>';
<%	
	rec_cuentas.MoveNext
	i = i + 1
wend
%>

function CargarCuentas(formulario, inen_ccod)
{
	formulario.elements["envio[0][ccte_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Cuenta Corriente";
	formulario.elements["envio[0][ccte_ccod]"].add(op)
	for (i = 0; i < arr_especialidades.length; i++)
	  { 
		if (arr_especialidades[i]["inen_ccod"] == inen_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_especialidades[i]["ccte_ccod"];
			op.text = arr_especialidades[i]["ccte_tdesc"];
			formulario.elements["envio[0][ccte_ccod]"].add(op)			
		 }
	}	
}

</script>

</head>
<body  bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="416" border="0" align="center" cellpadding="0" cellspacing="0">
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td width="482" valign="top" bgcolor="#EAEAEA">
	<table width="47%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="400" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="400" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Nuevo 
                          Bloqueo</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="400" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    <BR>
				    <form name="edicion">
				    <table width="386" border="0">
                      <tr> 
                        <td width="12">&nbsp;</td>
                        <td width="81">Tipo Bloqueo</td>
                        <td width="11">:</td>
                        <td width="264"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                          <%formulario.DibujaCampo("tblo_ccod") %>
                          </font></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>Descripci&oacute;n</td>
                        <td>:</td>
                        <td><%formulario.dibujacampo ("bloq_tobservacion")%>
                          &nbsp; </td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                    </table>
			        </form>							  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="133" bgcolor="#D8D8DE"> 
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="21%"><% 
						botonera.agregabotonparam "guardar_nuevo_bloqueo","url","Proc_Mant_Bloqueos_Nuevo.asp?pers_ncorr=" & pers_ncorr
						botonera.dibujaboton "guardar_nuevo_bloqueo"%>
</td>
                        <td width="79%"><%botonera.dibujaboton "cancelar" %>
                        </td>
                      </tr>
                    </table>
</td>
                  <td width="73" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="201" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
