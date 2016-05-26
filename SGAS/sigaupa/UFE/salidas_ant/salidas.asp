
<%
'RUT= request.QueryString("a")
'if RUT="" and session("rut_usuario")="" then
'response.Redirect("http://fangorn.upacifico.cl/sigaupa/ufe/portada/portada.asp")
'elseif RUT<>"" and session("rut_usuario")="" then
'session("rut_usuario") = RUT
'end if
'_sbd01
%>
<!-- #include file = "../biblioteca/_conexion_sbd01.asp" -->
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
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "salidas.xml", "botonera"

set f_subida = new CFormulario
f_subida.Carga_Parametros "comparador.xml", "subida"
f_subida.Inicializar conexion
f_subida.Consultar "select ''"
f_subida.Siguiente
usu=negocio.obtenerusuario()

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "salidas.xml", "busqueda2"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

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
extArray = new Array(".xls",".xlsx");
function limitar_archivo() 
{
	var val_pes;
	formulario=document.subida;
	file=formulario.elements["subir"].value;
	permitir_archivo = false;
	if (!file) 
	{
	alert('Debe selecionar un archivo');
	}	
	else
	{
		while (file.indexOf("\\") != -1)
		file = file.slice(file.indexOf("\\") + 1);
		ext = file.slice(file.indexOf(".")).toLowerCase();
		for (var i = 0; i < extArray.length; i++) 
		{
			//alert('paso '+i+' archivo='+ext)
			
			if (extArray[i]==ext)
			 { 
				 permitir_archivo = true; 
				 break;
			 }
	
		}
			if (permitir_archivo)
			{
				
				
				formulario.submit();
				
			}
			else
			{
			alert("Solo archivos Excel" 
			+ "\nPor favor, seleccione ese tipo de archivo"
			+ "\ne intentelo nuevamente.");
			}
	  }	
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
            <td><%pagina.DibujarLenguetas Array("Seleccione el Tipo de Salida"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  <td><div align="center">
                    <br>
                    <table width="100%" border="0">
                     
                    </table>
			  </tr>
          <tr>
            <td>
              <form name="edicion">
			  <input type="hidden" name="arch" value="<%=arch%>" />
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
						<table width="100%">
							<tr>                            		
								<td><p>Ac&aacute; se encuentran las salidas que no consideran rut como  filtros.</p></td>
							</tr>
                            <tr>
                            		
								<td><%f_busqueda.dibujacampo("tisa_ccod")%></td>
							</tr>
						</table>
					</td>
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

                  <td><div align="center">
					<%f_botonera.AgregaBotonParam "excel", "url", "redirecciona2.asp"
				   f_botonera.DibujaBoton"excel"  %></div></td>
				  
							 
                  <td><div align="center"><%f_botonera.AgregaBotonParam "salir", "url", "http://fangorn.upacifico.cl/sigaupa/ufe/lanzadera/lanzadera.asp"
				  f_botonera.DibujaBoton("salir")%></div></td>
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
            <td><%lenguetas=Array("Subir Archivo")
						pagina.DibujarLenguetas lenguetas, 1%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><FORM enctype="multipart/form-data" ACTION="sube_archivo_proc.asp" METHOD="POST" id="form1" name="subida" >
              <br>
              <table width="90%"  border="0" align="center">
			    
                <tr>
					<td width="85%"> 
					<span class="Estilo2"></span><strong>Archivo</strong><br>
					  <input name="subir" size=30 type="file"/>
					</td>
				</tr>
				<tr> 
					<td align=left>El formato de la columna rut, no debe contener puntos,guion,  DV para poder devolver el cruce de datos.</td>
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
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<%botonera.DibujaBoton"continuar"%></div></td>
					<td><div align="center">
					  <%botonera.AgregaBotonParam "salir", "url", "http://fangorn.upacifico.cl/sigaupa/ufe/lanzadera/lanzadera.asp"
					  'botonera.AgregaBotonParam "salir", "url", "../lanzadera/lanzadera.asp"  
					botonera.DibujaBoton"salir" %>
					</div></td>
                  </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28">
            
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