

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_tdet_ccod =Request.QueryString("b[0][tdet_ccod]")
q_sede_ccod= request.QueryString("b[0][sede_ccod]")
q_anos_ccod= request.QueryString("b[0][anos_ccod]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Marcado Masivo"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.carga_parametros "comparador.xml", "botonera"
'---------------------------------------------------------------------------------------------------

set f_subida = new CFormulario
f_subida.Carga_Parametros "comparador.xml", "compara"
f_subida.Inicializar conexion
f_subida.Consultar "select ''"
f_subida.Siguiente

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

<SCRIPT LANGUAGE="JavaScript">
function bloquea_desde_hasta(valor)
{
	ValorSelect=document.edicion.elements["a[0][peri_solo]"].value
	//alert(valor)
	if (ValorSelect!="") 
	{
		document.edicion.elements["a[0][desde]"].disabled=true
		document.edicion.elements["a[0][hasta]"].disabled=true
	}
	else
	{
	
		document.edicion.elements["a[0][desde]"].disabled=false
		document.edicion.elements["a[0][hasta]"].disabled=false
		
	}


}

function verifica_desde_hasta()
{
	ValorSelect=document.edicion.elements["a[0][peri_solo]"].value
	desde=document.edicion.elements["a[0][desde]"].value;
	hasta=document.edicion.elements["a[0][hasta]"].value;
	valor_retorno=true;	
		
   //alert("desde"+ desde)
  // alert("hasta"+ hasta)
if ((ValorSelect=="") && ((hasta!="") || (desde!="")))
{	
		if ((hasta!="")&&(desde!=""))
		{
		
			if (desde>hasta) 
			{
				document.edicion.elements["a[0][hasta]"].focus;
				valor_retorno=false;
				alert("El periodo desde no puede ser menor al campo hasta");				
			}			
		}
		else
		{
			valor_retorno=false;
			alert("Debe seleccionar 2 valores para el intervalo");
		}
 }
 //alert (valor_retorno);
return valor_retorno;


}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="400" height="250" border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td><%lenguetas=Array("Homologaciones")
						pagina.DibujarLenguetas lenguetas, 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><FORM  name="edicion" >
              <br>
              <table width="90%"  border="0" align="center">
			    
                <tr>
					<td width="85%"> 
					<span class="Estilo2"></span><strong>Lista de Archivos cargados para Homologaciones</strong><br>
                    <br>
					  <SELECT NAME="selCombo" SIZE=1 >
                      <OPTION VALUE="1">Seleccionar</OPTION>
					  <OPTION VALUE="2">UFE Licitados Ingresa</OPTION>
                    </SELECT>
					</td>
				</tr>
					<tr>
					  
					  <td>	
					    
					    
					    </td>
					  </tr>
			</table>
            </form>
			</td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				
                  <td><div align="center">
                    
					<%botonera.DibujaBoton"ver_arancel"%></div></td>
                    <td><div align="center">
                    
					<%botonera.DibujaBoton"ver_carreras"%></div></td>
                    <td><div align="center">
                    
					<%botonera.DibujaBoton"ver_general"%></div>
			  
							 
                  <td><div align="center"><%botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28">
           
            </td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
     <br>
	</td>
  </tr>  
</table>
</body>
</html>