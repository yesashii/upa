<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

'--------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
'--------------------------------------------------------------------------


set pagina = new CPagina
pagina.Titulo = "Datos de alumnos para exportar"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion



' set f_busqueda = new CFormulario
' f_busqueda.Carga_Parametros "info_alumnos_dae.xml", "busqueda_usuarios_nuevo"
' f_busqueda.Inicializar conexion
' f_busqueda.Consultar "select '' "
' f_busqueda.Siguiente
' 
' f_busqueda.AgregaCampoCons "pers_nrut", rut
' f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "cuenta_corriente_masiva.xml", "botonera"
'--------------------------------------------------------------------------

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

function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	
	return true;
}

function genera_digito (rut, indice){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 
 posicion_guion = texto_rut.indexOf("-");
// alert(texto_rut);
 
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.buscador.elements["busqueda["+indice+"][pers_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 

   
   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   buscador.elements["busqueda["+indice+"][pers_xdv]"].value=IgDigitoVerificador;

}

function exporta_excel(){
	document.buscador.method="Post";
	document.buscador.action="planilla_cuenta_corriente_masiva_excel_v2.asp";
	document.buscador.submit();
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          para exportar </font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; 
                    <BR>
					<%pagina.DibujarTituloPagina%>
                  </div>
				  <form name="buscador" method="post">
				  <table width="100%" border="0">
                    <tr> 
                      <td align="left" width="11%"><strong>R.U.T.</strong></td>
					  <td align="left" width="1%"><strong>:</strong></td>
					  <td width="37%" align="left">
					  		<input type='text'  name='busqueda[0][pers_nrut]' value='' onBlur="genera_digito(this.value,0);" size='10'  maxlength='8'  id='NU-S' >-
  							<input type='text'  name='busqueda[0][pers_xdv]' value='' onBlur="this.value=this.value.toUpperCase();" size='1'  maxlength='1'  id='LN-S' >
					  </td>
					  <td align="left" width="13%"><strong>R.U.T.</strong></td>
					  <td align="left" width="3%"><strong>:</strong></td>
					  <td width="35%" align="left">					  		
					<input type='text'  name='busqueda[1][pers_nrut]' value=''onBlur="genera_digito(this.value,1);" size='10'  maxlength='8'  id='NU-S' >-
  					<input type='text'  name='busqueda[1][pers_xdv]' value=''onBlur="this.value=this.value.toUpperCase();" size='1'  maxlength='1'  id='LN-S' >
					</td>
					</tr>
					<tr> 
                      <td align="left" width="11%"><strong>R.U.T.</strong></td>
					  <td align="left" width="1%"><strong>:</strong></td>
					  	<td align="left">					  		
					  <input type='text'  name='busqueda[2][pers_nrut]' value=''onBlur="genera_digito(this.value,2);" size='10'  maxlength='8'  id='NU-S' >-
  					  <input type='text'  name='busqueda[2][pers_xdv]' value=''onBlur="this.value=this.value.toUpperCase();" size='1'  maxlength='1'  id='LN-S' >
						</td>
					  <td align="left" width="13%"><strong>R.U.T.</strong></td>
					  <td align="left" width="3%"><strong>:</strong></td>
					  	<td align="left">					  		
					  <input type='text'  name='busqueda[3][pers_nrut]' value=''onBlur="genera_digito(this.value,3);" size='10'  maxlength='8'  id='NU-S' >-
  					  <input type='text'  name='busqueda[3][pers_xdv]' value=''onBlur="this.value=this.value.toUpperCase();" size='1'  maxlength='1'  id='LN-S' >
						</td>
					  
					</tr>
					<tr> 
                      <td align="left" width="11%"><strong>R.U.T.</strong></td>
					  <td align="left" width="1%"><strong>:</strong></td>
					  	<td align="left">					  		
					  <input type='text'  name='busqueda[4][pers_nrut]' value=''onBlur="genera_digito(this.value,4);" size='10'  maxlength='8'  id='NU-S' >-
  					  <input type='text'  name='busqueda[4][pers_xdv]' value=''onBlur="this.value=this.value.toUpperCase();" size='1'  maxlength='1'  id='LN-S' >
						</td>
					  <td align="left" width="13%"><strong>R.U.T.</strong></td>
					  <td align="left" width="3%"><strong>:</strong></td>
					  	<td align="left">					  		
					  <input type='text'  name='busqueda[5][pers_nrut]' value=''onBlur="genera_digito(this.value,5);" size='10'  maxlength='8'  id='NU-S' >-
  					  <input type='text'  name='busqueda[5][pers_xdv]' value=''onBlur="this.value=this.value.toUpperCase();" size='1'  maxlength='1'  id='LN-S' >
						</td>
					</tr>
					<tr>
					  <td align="left"><strong>R.U.T.</strong></td>
					  <td align="left"><strong>:</strong></td>
					  	<td align="left">					  		
					  <input type='text'  name='busqueda[6][pers_nrut]' value=''onBlur="genera_digito(this.value,6);" size='10'  maxlength='8'  id='NU-S' >-
  					  <input type='text'  name='busqueda[6][pers_xdv]' value=''onBlur="this.value=this.value.toUpperCase();" size='1'  maxlength='1'  id='LN-S' >
						</td>
					  <td align="left"><strong>R.U.T.</strong></td>
					  <td align="left"><strong>:</strong></td>
					  	<td align="left">					  		
					  <input type='text'  name='busqueda[7][pers_nrut]' value=''onBlur="genera_digito(this.value,7);" size='10'  maxlength='8'  id='NU-S' >-
  					  <input type='text'  name='busqueda[7][pers_xdv]' value=''onBlur="this.value=this.value.toUpperCase();" size='1'  maxlength='1'  id='LN-S' >
						</td>
				    </tr>
					<tr>
					  <td align="left"><strong>R.U.T.</strong></td>
					  <td align="left"><strong>:</strong></td>
					  	<td align="left">					  		
					  <input type='text'  name='busqueda[8][pers_nrut]' value=''onBlur="genera_digito(this.value,8);" size='10'  maxlength='8'  id='NU-S' >-
  					  <input type='text'  name='busqueda[8][pers_xdv]' value=''onBlur="this.value=this.value.toUpperCase();" size='1'  maxlength='1'  id='LN-S' >
						</td>
					  <td align="left"><strong>R.U.T.</strong></td>
					  <td align="left"><strong>:</strong></td>
					  	<td align="left">					  		
					  <input type='text'  name='busqueda[9][pers_nrut]' value=''onBlur="genera_digito(this.value,9);" size='10'  maxlength='8'  id='NU-S' >-
  					  <input type='text'  name='busqueda[9][pers_xdv]' value=''onBlur="this.value=this.value.toUpperCase();" size='1'  maxlength='1'  id='LN-S' >
						</td>
				    </tr>
                  </table>
				  <table width="100%" border="0">
					<tr> 
                      <td align="Right"></td>
                    </tr>
                  </table> 
            </form>      
				  <br>				  
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
			
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                       <td width="54%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
					  <td width="40%">
					   <%botonera.dibujaboton "planilla"%>
					  </td>
					  <td width="40%">
					   <%botonera.dibujaboton "planilla2"%>
					  </td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
