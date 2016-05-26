<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

peri_ccod=request.QueryString("peri_ccod")
sede_ccod=request.QueryString("sede_ccod")
fecha_consulta=request.QueryString("fecha_consulta")
indice=request.QueryString("indice")
if indice="" then

indice=-99
end if
'response.Write(peri_ccod&"<br>"&sede_ccod&"<br>"&fecha)
'---------------------------------------------------------------------------------------------------

set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "crea_modulos_sicologos.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "crea_modulos_sicologos.xml", "botonera"

'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "crea_modulos_sicologos.xml", "cheques"
f_cheques.Inicializar conexion


sql_descuentos= "select ''"

f_cheques.Consultar sql_descuentos
f_cheques.Siguiente
 usu=negocio.obtenerUsuario
 f_cheques.agregaCampoCons "peri_ccod",peri_ccod
 f_cheques.agregaCampoCons "sede_ccod",sede_ccod
 f_cheques.agregaCampoCons "fecha_consulta",fecha_consulta
 
 
 set f_sedes_sicologos = new CFormulario
f_sedes_sicologos.Carga_Parametros "crea_modulos_sicologos.xml", "sede_sicologos"
f_sedes_sicologos.Inicializar conexion


sql_descuentos= "select c.sede_ccod,sede_tdesc "& vbcrlf & _
 "from sicologos a,"& vbcrlf & _
 "sicologos_sede b,"& vbcrlf & _
 "sedes c"& vbcrlf & _
"where a.sico_ncorr=b.sico_ncorr"& vbcrlf & _
"and b.sede_ccod=c.SEDE_CCOD"& vbcrlf & _
"and a.pers_ncorr=protic.obtener_pers_ncorr("&usu&") order by c.sede_ccod"

f_sedes_sicologos.Consultar sql_descuentos
'response.Write(sql_descuentos)
 




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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">


function carga()
{
var indice =<%=indice%> 

	if (indice!="-99")
	{
		document.edicion.elements["a[0][sede_ccod]"].selectedIndex=indice;
	}
}
function buscar()
{
//alert("entro")
formulario=document.edicion;
	if (preValidaFormulario(formulario)) 
	{		
		//alert("se va")
		var indice =document.edicion.elements["a[0][sede_ccod]"].selectedIndex; 
		var sede_ccod =document.edicion.elements["a[0][sede_ccod]"].value; 
		var peri_ccod=document.edicion.elements["a[0][peri_ccod]"].value;
		var fecha=document.edicion.elements["a[0][fecha_consulta]"].value;
		
		p_url="muestra_horas.asp?peri_ccod="+peri_ccod+"&fecha_consulta="+fecha+"&indice="+indice+"&sede_ccod="+sede_ccod+"";
		
		location.href=p_url			
			
	}
}

function CambiarHora(hoto)
{

var sede_ccod =document.edicion.elements["a[0][sede_ccod]"].value; 
var peri_ccod=document.edicion.elements["a[0][peri_ccod]"].value;
var fecha=document.edicion.elements["a[0][fecha_consulta]"].value;
var indice=<%=indice%>		
		p_url="modificar_hora.asp?peri_ccod="+peri_ccod+"&fecha_consulta="+fecha+"&indice="+indice+"&sede_ccod="+sede_ccod+"&hoto_ncorr="+hoto+"";
		
		location.href=p_url	

}

</script>


</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'),carga();" onBlur="revisaVentana();">
<form name="edicion">
<table width="750" height="300" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	
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
				
              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="50%">
						  <table width="75%"  border="0" align="center">
								 <tr>				
								   <td width="20%"><span class="Estilo2"></span><strong>Año Académico</strong><br><%f_cheques.DibujaCampo("anos_ccod")%></td>
												
								   <td width="20%"><span class="Estilo2"></span><strong>Sede</strong><br>  
									   <select name="a[0][sede_ccod]"  id='NU-S' >
										<option value=''>Todas</option>
										<%while f_sedes_sicologos.Siguiente%>
										<option value='<%=f_sedes_sicologos.Obtenervalor("sede_ccod")%>' ><%=f_sedes_sicologos.Obtenervalor("sede_tdesc")%></option>
										<%wend%>
									 </select>
								   </td>
						    </tr>
						  </table>
						   <table width="75%" align="center">
								   <tr>
									  <td width="33%" align="up"><span class="Estilo2"></span><strong> Mes </strong><br>
									    <% f_cheques.dibujaCampo "mes_ccod"%>
									 </td>
									   <td width="33%" align="up"><span class="Estilo2"></span><strong>Estado Hora</strong><br><%f_cheques.DibujaCampo("esho_ccod")%></td>
										<td width="34%" align="up">&nbsp;</td>
								   </tr>
						  </table>
				   </td>
                  </tr>
                </table>
                <br>
           </td>
		</tr>
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
				
                  <td align="center"><%f_botonera.DibujaBoton"excel_alum"%>
				  
				  </td>
				  
							 
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  
				  
				 
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table>
		
		</td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table> </form>
</body>
</html>