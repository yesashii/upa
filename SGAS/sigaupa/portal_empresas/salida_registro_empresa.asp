<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_registro_empresa.asp" -->
<% 
'------------------------------------------------------

 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion

  q_rut =Request("daem[0][rut]")
  q_dv=Request("daem[0][dv]")

 '-- Botones de la pagina -----------
 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "empresa.xml", "botonera"
 
 '---------------------------------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "empresa.xml", "busqueda"
 f_busqueda.Inicializar conexion

 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
'---------------------------------------------------------------------------------------------------
 if q_rut <>"" then
existe=conexion.consultaUno("select count(*) from empresas where empr_nrut="&q_rut&"")

exiete_empre_daem=conexion.consultaUno("select count(*)from empresas a,datos_empresa b where empr_nrut="&q_rut&" and a.empr_ncorr=b.empr_ncorr")

else
existe=99
exiete_empre_daem=99
end if
 'response.write(exiete_empre_daem)
   set f_datos_empresa = new CFormulario
 f_datos_empresa.Carga_Parametros "empresa.xml", "f_datos_empresas"
 f_datos_empresa.Inicializar conexion
 
				if q_rut ="" then	
				 selec_antecedentes="select ''"
				 else
				 
				 if existe=1 then
				selec_antecedentes="select empr_ncorr,empr_tnombre,empr_trazon_social,empr_nrut ,empr_xdv,isnull(b.ciud_ccod,0)as ciud_ccod,isnull(regi_ccod,0)as regi_ccod,dire_tcalle,dire_tnro,dire_tdepto,isnull(pais_ccod,0)as pais_ccod"& vbCrLf &_
				"from empresas a, direcciones b,ciudades c,personas d"& vbCrLf &_
				"where a.empr_ncorr=b.pers_ncorr"& vbCrLf &_
				"and empr_nrut="&q_rut&""& vbCrLf &_
				"and tdir_ccod=1"& vbCrLf &_
				"and a.empr_ncorr=d.pers_ncorr"& vbCrLf &_
				"and b.ciud_ccod=c.ciud_ccod"
				
				else
				selec_antecedentes="select "&q_rut&" as rut,"&q_dv&" as rut"
				end if
				 end if
 f_datos_empresa.Consultar selec_antecedentes
 f_datos_empresa.Siguiente
f_datos_empresa.AgregaCampoCons "rut",q_rut
f_datos_empresa.AgregaCampoCons "dv",q_dv
f_datos_empresa.AgregaCampoCons "rut2",q_rut
f_datos_empresa.AgregaCampoCons "dv2",q_dv
'-----------------------------------------------------------------------------------------------
consulta_ciudades = "select regi_ccod, ciud_ccod, ciud_tdesc, ciud_tcomuna from ciudades order by ciud_tdesc asc"

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/dicc_ciudades.js"></script>

<script language="JavaScript">




</script>
<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
.Estilo1 {
	color: #FF0000;
	font-weight: bold;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
 <form name="empresa">
<center>

  <table width="793" height="705" align="center">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center">&nbsp;</td>
	</tr>
	<tr valign="top">
		<td width="100%" height="623" align="left">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="97%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										
									</table>							  </td>
							</tr>
							
							
									<tr>
									<td>
										</td>
							</tr>	
							<tr>
									<td>
										<table width="100%">
								
								
										
										
								<tr>
									<td>
										<table width="718">
                                <tr>
								
                                  <td colspan="3">&nbsp;</td> 
                                </tr>
                                <tr valign="top">
                                  <td colspan="3" align="center" ><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>HAS SIDO REGISTRADO EXITOSAMENTE </strong></font></td>
								
                                </tr>
								
                                <tr>
                                  <td height="20" colspan="3" align="center">
								   <%POS_IMAGEN = 0%>
								  <a href="javascript:_Navegar(this, 'portada_registro_empresa.asp', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a>
								  </td>
                                </tr>
                                <tr valign="top">
                                  <td colspan="2">
								  	<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" bgcolor="#f7faff"></td>
                                      </tr>
                                  	</table>								  </td>
                                  <td colspan="1">
								  	<table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff">
                                      <tr>
									  	<td>&nbsp;</td>
									  </tr>
                                  	</table>								  </td>
                                </tr>
									 </table>									</td>
										</tr>
						</table>					</td>
				</tr>
				 </table>
	  </td>
	</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>		</td>
	</tr>
		 
	<!--Antecedentes educacionales-->
	<!--Identificación del sostenedor académico-->
</table>




</center>
 <form>
</body>
</html>
