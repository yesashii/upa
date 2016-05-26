<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Gestión cuentas de Email institucional Docentes"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "clave_email.xml", "busqueda_usuarios_nuevo"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "clave_email.xml", "botonera"
'--------------------------------------------------------------------------
rut=negocio.obtenerUsuario
nombre = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)= '"&rut&"'")
es_usuario = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from personas a, sis_usuarios b where cast(a.pers_nrut as varchar)= '"&rut&"' and a.pers_ncorr=b.pers_ncorr ")

tiene=conexion.consultaUno("select count(*) from TEMPORALES_CLAVES_DOCENTE where pers_ncorr=protic.Obtener_pers_ncorr("&rut&")")
'response.Write(es_usuario)
digito=conexion.consultaUno("select pers_xdv from personas where cast(pers_nrut as varchar)= '"&rut&"'")
if es_usuario = "S" then
 set f_datos = new CFormulario
 f_datos.Carga_Parametros "clave_email.xml", "f1_edicion"
 f_datos.Inicializar conexion
 'response.End()
 f_datos.Consultar "select top 1 a.pers_ncorr, b.susu_tlogin,b.susu_tclave,'"&negocio.obtenerUsuario&"' as actualizado_por,(select email_upa from sd_cuentas_email_totales tt where tt.rut=a.pers_nrut) as email_upa from   personas a, sis_usuarios b where cast(a.pers_nrut as varchar)= '"&rut&"' and a.pers_ncorr=b.pers_ncorr"
 f_datos.Siguiente
 
 clave_antigua = f_datos.obtenerValor("susu_tclave")
 pers_ncorr= conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)= '"&rut&"'")
else
	
end if
mensaje = "TU CAMBIO HA SIDO REGISTRADO"
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

function ValClaveAlfaNumerica()
{

var primera;
var restante;
var clave;
var largo;
var letras="abcdefghyjklmnñopqrstuvwxyz";
var numeros="0123456789";


clave=document.edicion.elements["usuarios[0][susu_tnuclave]"].value;
 largo_clave=clave.length;
 
 //alert(largo_clave);
 if (( largo_clave >5)&&(largo_clave <9))
 
 	{
 
		  clave = clave.toLowerCase();
		  primera=clave.substring(0,1);
		 //alert(primera);
		 for(i=0; i< primera.length; i++)
		  {
			 if (letras.indexOf(primera.charAt(i),0)!=-1)
			 {
			  //alert('SI');
			  //largo=clave.length;
			  //restante=clave.substring(1,largo);
			  //alert(restante);
			  var nletras=0;
			  var nnumero=0;
			  var signos=0;
			  for(i=0; i<clave.length; i++)
			  {
				  if (letras.indexOf(clave.charAt(i),0)!=-1)
				  {
					nletras=nletras+1;
				  }
			  }
			  
			  for(i=0; i<clave.length; i++)
			  {
				  if (numeros.indexOf(clave.charAt(i),0)!=-1)
				  {
					 nnumero=nnumero+1;
				  }
		      }
		
			
		
			  //alert(nletras);
				  //alert(nnumero);
				  if ((nletras>0)&&(nnumero>0))
				  {
					return true;
				  }
				  else
				  {
				   alert('La Clave debe ser Alfanúmerica')
				  }
			 }
			else
			{
			alert('El primer caracter de la clave de ser una letra');
			}
		  }
		 
		  
	}
	 else
	 {
	   alert('el largo de la clave no puede ser menor a 6 ni mayor 8');
	 }
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
                      Encontrados</font></div></td>
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
                  <table width="100%" border="0">
					<tr>
					  <td colspan="3">&nbsp;</td>	
					</tr>
					<form name="edicion" method="post">
					<input type="hidden" name="usuarios[0][pers_ncorr]" value="<%=pers_ncorr%>">
					<%%>
					<tr> 
                      <td align="left" width="16%"><strong>R.U.T.</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left" colspan="2"><%=rut%>-<%=digito%></td>
					</tr>
					<tr> 
                      <td align="left" width="16%"><strong>Nombre</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left" colspan="2"><%=nombre%></td>
					</tr>
					<%if tiene = "0" then%>
					<tr> 
                      <td align="left" width="16%"><strong>Email Registrado</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left" colspan="2"><%f_datos.dibujaCampo("email_upa")%></td>
					</tr>
					<tr> 
                      <td align="left" width="16%"><strong>Clave Registrada</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left" colspan="2"><%f_datos.dibujaCampo("clave_anterior")%></td>
					</tr>
					<tr>
					 <td colspan="4"> 
						<table width="100%">
						  <tr>
						  <td align="left" width="20%" ><strong>Clave</strong></td>
						  <td align="left" width="1%" ><strong>:</strong></td>
						  <td width="7%" align="left"><%f_datos.dibujaCampo("susu_tnuclave")%></td>
						   <td width="72%" align="left">  <font color="#000033"><strong>La clave debe tener un minimo de 6 y un máximo de 8 caracteres</strong></font></td>
						   </tr>
						</table>
					 </td>	   
					</tr>
					<tr>
						<td colspan="4">
						<font size="1" color="#000000"><strong>Recuerde que su clave debe tener letras y n&uacute;meros y  comenzar con una letra.</strong></font></td>
					</tr>
					<tr>
						<td colspan="4">
						<font size="2" color="#000000"><strong>Ejemplo a12345</strong></font></td>
					</tr>
					<tr>
						<td colspan="4">
						<font size="2" color="#FF0000"><strong>* Esta clave será utilizada apartir del segundo semestre.</strong></font></td>
					</tr>
					
					<%else%>
					<tr><td align="center" colspan="3"><font size="2" color="#FF0033"><strong><%=mensaje%></strong></font></td></tr>
					<%end if%>
					</form>
				  </table>
				  <br></td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    
					<tr> 
                       <td width="54%">
                        <%  botonera.dibujaboton "salir"%>                      </td>
					  <td width="40%"><%if tiene = "0" then
					                        botonera.dibujaboton "guardar"
										end if%></td>
                    </tr>
					
						
					
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>		  </td>
        </tr>
      </table>
     
    </td>
  </tr>  
</table>
</body>
</html>
