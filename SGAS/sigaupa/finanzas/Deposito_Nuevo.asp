<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Depositos.xml", "botonera"

'---------------------------------------------------------------------------------------------------

set formulario = new CFormulario
formulario.Carga_Parametros "Depositos.xml", "f_nuevo"
formulario.Inicializar conexion
' eenv_ccod=1, estado envio (Pendiente)
' tenv_ccod=2 , tipo_envio (Deposito)
consulta = "select '1' as eenv_ccod, '2' as tenv_ccod ,'' as caje_ncorr "
formulario.Consultar consulta
formulario.Siguiente


'-------------------------------------------------------------
consulta = "SELECT * FROM cuentas_corrientes"
conexion.Ejecuta consulta
set rec_cuentas = conexion.ObtenerRS
%>


<html>
<head>
<title>Agregar dep&oacute;sito</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--
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

function CargarEspecialidades(formulario, inen_ccod)
{
	formulario.elements["deposito[0][ccte_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Cuenta Corriente";
	formulario.elements["deposito[0][ccte_ccod]"].add(op)
	for (i = 0; i < arr_especialidades.length; i++)
	  { 
		if (arr_especialidades[i]["inen_ccod"] == inen_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_especialidades[i]["ccte_ccod"];
			op.text = arr_especialidades[i]["ccte_tdesc"];
			formulario.elements["deposito[0][ccte_ccod]"].add(op)			
		 }
	}	
}


function VerificaTipoDeposito(form,valor){

	if (valor==3){
		form.elements["deposito[0][envi_mefectivo]"].disabled=false;
		form.elements["deposito[0][envi_mefectivo]"].focus();
	}else{
		form.elements["deposito[0][envi_mefectivo]"].disabled=true;
	}
}

//-->
</script>


</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	 		
	  <table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td width="365"><table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
              
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="262" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="384" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td>
				<%pagina.DibujarLenguetas Array("Agregar depósito"), 1 %></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="384" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <div align="center">
              <table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
                    <br>
                    <form name="edicion">
                      <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr> 
                          <td width="96">Banco</td>
                          <td width="29"><div align="center">: </div></td>
                          <td width="176"><%formulario.DibujaCampo ("inen_ccod")%> <%formulario.DibujaCampo ("tenv_ccod")%> <%formulario.DibujaCampo ("eenv_ccod")%></td>
                        </tr>
                        <tr> 
                          <td>Cuenta Corriente </td>
                          <td width="29"><div align="center">:</div></td>
                          <td><% formulario.DibujaCampo ("ccte_ccod")%></td>
                        </tr>
                        <tr> 
                          <td>Tipo documentos</td>
                          <td><div align="center">:</div></td>
                          <td><% formulario.DibujaCampo ("tdep_ccod")%></td>
                        </tr>
                        <tr> 
                          <td>Monto Efectivo</td>
                          <td><div align="center">:</div></td>
                          <td><input type="text" name="deposito[0][envi_mefectivo]" value="" size="15" disabled id="NU-N"></td>
                        </tr>
                        <tr> 
                          <td>Descripcion deposito</td>
                          <td><div align="center">:</div></td>
                          <td><input type="text" name="deposito[0][envi_tdescripcion]" value="" size="50" maxlength="50" id="TO-N" ></td>
                        </tr>
                        <tr>
                          <td>Fecha de la Caja</td>
                          <td><div align="center">:</div></td>
                          <td>
                            <% formulario.DibujaCampo("envi_fenvio")%>(dd/mm/aaaa)
                          </td>
                        </tr>
                      </table>
		            </form>
			      <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
              </table>
              <table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <td><div align="center">
                            <% botonera.DibujaBoton ("guardar_nuevo_deposito")%>
                          </div></td>
                        <td><div align="center"><% botonera.DibujaBoton ("cancelar")%></div></td>
                      </tr>
                    </table>                    
                  </td>
                  <td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
              </table>
              </div>
         </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
