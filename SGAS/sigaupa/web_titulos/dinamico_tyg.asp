<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
set conectar = new CConexion
conectar.Inicializar "upacifico"
usuario = session("rut_tyg") 'negocio.obtenerUsuario
if usuario = "" then
	session("mensajeerror")= "Debe ingresar con un usuario y clave para ver esta opción, acceso sólo egresados y titulados de la Universidad."
	response.Redirect("index.asp?eea=0") 
end if
nombre = conectar.consultaUno("select protic.initcap(pers_tnombre) from personas where cast(pers_nrut as varchar)='"&usuario&"'")
pers_ncorr = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
id_ceremonia = conectar.consultaUno("select id_ceremonia from detalles_titulacion_carrera where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="description" content="Your description goes here" />
  <meta name="keywords" content="your,keywords,goes,here" />
  <link rel="stylesheet" type="text/css" href="andreas01.css" media="screen,projection" />
  <title>Web de T&iacute;tulos y Grados</title>
<script src="Scripts/AC_RunActiveContent.js" type="text/javascript"></script>
</head>

<body>
<div id="wrap">
    <div id="header">
      <script type="text/javascript">
AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0','width','760','height','100','src','swf/top_2','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','swf/top_2' ); //end AC code
      </script>
      <noscript>
      <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="760" height="100">
        <param name="movie" value="swf/top_2.swf" />
        <param name="quality" value="high" />
        <embed src="swf/top_2.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="760" height="100"></embed>
      </object>
      </noscript>
    </div>
<hr color="#CCCCCC">

<div id="avmenu">
  <script type="text/javascript">
AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0','width','154','height','400','src','menu_2','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','menu_2' ); //end AC code
        </script>
  <noscript>
  <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="154" height="400">
    <param name="movie" value="menu_2.swf" />
    <param name="quality" value="high" />
    <embed src="menu_2.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="154" height="400"></embed>
  </object>
  </noscript>
  </li>
    </ul>
  </div>
<div id="content2">
  <table width="100%" bgcolor="#FFFFFF" border="0">
    <tr>
      <td width="100%" align="left">
	  		<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr valign="bottom">
					<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_sup_izq.png"></td>
					<td bgcolor="#FFFFFF" height="18" background="img/superior.png">&nbsp;</td>
					<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_sup_der.png"></td>
				</tr>
				<tr>
					<td bgcolor="#FFFFFF" width="8" background="img/izquierda.png">&nbsp;</td>
					<td bgcolor="#FFFFFF">
										 <table width="100%" cellpadding="0" cellspacing="0">
										   <tr>
											   <td width="100%" align="left">
														<font size="3"><strong>Bienvenidos a la Web de Títulos y Grados</strong></font>
											   </td>
										   </tr>
										   <tr>
											   <td width="100%" align="left">&nbsp;</td>
										   </tr>
										   <tr>
											   <td width="100%" align="left">
														<font size="2">El   Departamento  de  Títulos y Grados dependiente  de   Secretaría    General,   es    el     encargado    del proceso  de  titulación  y certificación de egresados y titulados de pre y post-grado de nuestra Universidad.</font><br><br>
											   </td>
										   </tr>
										 </table>
					 </td>
				 	 <td bgcolor="#FFFFFF" width="12" background="img/derecha.png">&nbsp;</td>
				</tr>
				<tr valign="top">
				   <td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_inf_izq.png"></td>
				   <td bgcolor="#FFFFFF" height="18" background="img/inferior.png">&nbsp;</td>
				   <td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_inf_der.png"></td>
				</tr>
		 </table>
	  </td>
    </tr>
	<tr>
		<td width="100%" align="left">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr valign="bottom">
					<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_sup_izq.png"></td>
					<td bgcolor="#FFFFFF" height="18" background="img/superior.png">&nbsp;</td>
					<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_sup_der.png"></td>
				</tr>
				<tr>
					<td bgcolor="#FFFFFF" width="8" background="img/izquierda.png">&nbsp;</td>
					<td bgcolor="#FFFFFF">
						<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="100%" align="left">
									<font size="2"><strong>Estimado(a) <%=nombre%>, acá podrás realizar:</strong></font>
							</td>
						</tr>
						<tr>
							<td width="100%" align="left">&nbsp;</td>
						</tr>
						<tr>
							<td width="100%" align="left">
								<li><font size="2">Solicitud de uno o más certificados, entregados en la sede que lo desees.</font></li>
								<!--<li><font size="2">Revisar la nómina de convocados a la ceremonia, horario y lugar.</font></li>
								<li><font size="2">Actualizar tus datos personales para mejorar la comunicación con la universidad.</font></li>-->
								<br><br>
							</td>
						</tr>
						</table>
					</td>
					<td bgcolor="#FFFFFF" width="12" background="img/derecha.png">&nbsp;</td>
				</tr>
				<tr valign="top">
					<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_inf_izq.png"></td>
					<td bgcolor="#FFFFFF" height="18" background="img/inferior.png">&nbsp;</td>
					<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_inf_der.png"></td>
				</tr>
		    </table>
		</td>
	 </tr>							
  </table>
  </div>

<div id="footer">
      <p>Universidad del Pacífico - Derechos Reservados / Sitio desarrollado para Explorer 8, o superior; Firefox o Safari</p>
    </div>
  </div>
  <script type="text/javascript">
<!--

//-->
  </script>
</body>
</html>
