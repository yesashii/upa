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

set f_subida = new CFormulario
f_subida.Carga_Parametros "subida_datos.xml", "subida"
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
extArray = new Array(".xls");
function limitar_archivo(form, file) 
{
	var val_pes;
	formulario=document.subida;
	val_pes=formulario.elements["sub[0][pestana]"].value;
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
		if (extArray[i] == ext)
		 { 
		 permitir_archivo = true; 
		 break;
		 }
	
		}
			if (permitir_archivo)
			{
				if(val_pes=='')
				{
				alert('No puede dejar el nombre de la pestaña en blanco');
				formulario.elements["sub[0][pestana]"].focus();
				formulario.elements["sub[0][pestana]"].select();
				}
				else
				{
				form.submit();
				}
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
            <td><%'pagina.DibujarLenguetas Array("Subir Excel"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><FORM ENCTYPE="multipart/form-data" ACTION="sube_archivo_proc.asp" METHOD=POST id=form1 name="subida" >
              <br>
              <table width="90%"  border="0" align="center">
			    
                <tr>
					<td width="85%"> 
					<span class="Estilo2"></span><strong>Archivo</strong><br>
					  <input name="subir" size=30 type="file"/>
					</td>
					</tr>
					<tr>
					
					<td>
					<span class="Estilo2"></span><strong>Pestaña</strong><br>
					<%f_subida.DibujaCampo("pestana")%>
					</td>
				</tr>
					<tr> 
					
					<td align=left> 
					<INPUT type="button" value="Continuar" onClick="limitar_archivo(this.form,this.form.subir.value);">
					<BR>
					<BR>
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
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</body>
</html>