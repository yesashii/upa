<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%


q_rut = Request.QueryString("b[0][pers_nrut]")
q_consulta = Request.QueryString("consulta")
q_peri_ccod =218

if q_consulta ="" then
q_consulta=0
else
q_consulta=q_consulta
end if

set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "botonera_generica.xml", "botonera"


set conexion = new cConexion
set negocio = new cNegocio
'set formu_resul= new cformulario
'set resultado_busqueda = new cFormulario
conexion.inicializar "upacifico"
negocio.inicializa conexion

'**********************************************


set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "becas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'response.Write("<pre>"&q_anos_ccod&"</pre>")
'response.Write("<pre>"&q_mes_ccod&"</pre>")
if q_consulta= 1  then
tiene_matr=conexion.ConsultaUno("Select count(matr_ncorr) from alumnos a, postulantes b,personas c where a.post_ncorr=b.post_ncorr and emat_ccod=1 and b.pers_ncorr=c.pers_ncorr and b.peri_ccod="&q_peri_ccod&" and pers_nrut="&q_rut&" ")

end if
if tiene_matr="" then
tiene_matr=-1
else
pers_ncorr=conexion.ConsultaUno("Select pers_ncorr from personas  where  pers_nrut="&q_rut&"")

end if
%>


<html>
<head>
<title>Re-impresion de Certificados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
var existe=<%=tiene_matr%>
var consulta=<%=q_consulta%>

function verifica()
{
//alert("existe "+existe+" consulta "+consulta);

	if ((existe >=0)&&(consulta >0))
	{
     	if (existe >0)
		{
			window.open("certificado_2.asp?pers_ncorr=<%=pers_ncorr%>");		
		}
		else
		{
			alert("El alumno no tiene matricula para este semestre");
		}	
	}
}
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="verifica();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
		<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
		  <tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						  <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
						  <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
						  <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
					</tr>
					<tr>
						  <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
						  <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
						  <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
					</tr>
					<tr>
						  <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
						  <td>
							  <table width="100%" border="0" cellspacing="0" cellpadding="0">
								  <tr>
									<td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
									<td width="450" valign="bottom" background="../imagenes/fondo1.gif">
								    <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Ingrese el Rut del Alumno para Reimprimir el Certificado</font></div></td>
									<td width="86" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
									<td width="129" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
									
								  </tr>
							  </table>
						  </td>
						  <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
				   </tr>
				   <tr>
						  <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
						  <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
						  <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
				  </tr>
			   </table>
			   <table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
					<td bgcolor="#D8D8DE" width="80%"> 
						<table width="100%">
						 	<br>
							
							<tr>
								<td width="80%" colspan="4">
									<form name="buscador" >
									<input type="hidden" name="consulta" value="1">
									  <table cellspacing=0 cellpadding=0 align="center" width="100%" border=0 >
									  
									  	  <br>
										  <tr>
										  	<td width="5%">Rut</td>
											<td width="10%"><input type='text'  name='b[0][pers_nrut]' value='' size='10'  maxlength='8'  id='NU-S'></td>
											<td width="2%" align="center">-</td>
											<td width="6%" align="left"><input type='text'  name='b[0][pers_xdv]' value='' size='1'  maxlength='1'  id='TO-S'></td>
											<td width="76%"></td> 
										  </tr>
									  </table>
									   <table cellspacing=0 cellpadding=0 align="center" width="100%" border=0 >
									  
									  	  <br>
										  <tr>
										  	<td width="5%">&nbsp;</td>
											<td colspan="2">&nbsp;</td>
											<td width="6%" align="left">&nbsp;</td>
											<td width="76%"><input type="submit" value="Reimprimir"></td> 
										  </tr>
									  </table>
				  				</form>
								</td>
							</tr>
						</table>
					</td>
					<td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
				  <tr>
					<td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
					<td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
					<td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
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