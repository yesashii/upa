<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

'q_pers_nrut = session("rut_tyg")
'if usuario = "" then
'	session("mensajeerror")= "Debe ingresar con un usuario y clave para ver esta opción, acceso sólo egresados y titulados de la Universidad."
'	response.Redirect("index.asp?eea=0") 
'end if

'q_pers_xdv  = conexion.consultaUno("Select pers_xdv from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'---------------------------------------------------------------------------------------------------
'set f_botonera = new CFormulario
'f_botonera.Carga_Parametros "adm_salidas_alumnos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
'set f_titulado = new CFormulario
'f_titulado.Carga_Parametros "adm_salidas_alumnos.xml", "editar_dpersonales"
'f_titulado.Inicializar conexion

'SQL = " select a.pers_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, " & vbCrLf & _
'	  " b.dire_tcalle, b.dire_tnro, b.dire_tpoblacion, b.ciud_ccod,rtrim(ltrim(cast(a.pers_nnota_ens_media as decimal(2,1)))) pers_nnota_ens_media," & vbCrLf & _
'	  " a.pers_nano_egr_media, a.sexo_ccod, a.cole_ccod, " & vbCrLf & _
'	  " c.ciud_ccod as ciud_ccod_colegio " & vbCrLf & _
'	  " from " & vbCrLf & _
'	  " personas a " & vbCrLf & _
'	  " left outer join direcciones b " & vbCrLf & _
'	  "    on a.pers_ncorr = b.pers_ncorr   and 1 = b.tdir_ccod  " & vbCrLf & _
'	  " left outer join colegios c " & vbCrLf & _
	'  "    on a.cole_ccod = c.cole_ccod " & vbCrLf & _
'	  " where cast(a.pers_nrut as varchar)= '"&q_pers_nrut&"' "

'f_titulado.Consultar SQL
'f_titulado.SiguienteF
'response.Write("entre")

'f_titulado.AgregaCampoCons "pers_nrut", q_pers_nrut
'f_titulado.AgregaCampoCons "pers_xdv", q_pers_xdv

'----------------------------------------------------------------------------------------------------

'set f_colegio_egreso = new CFormulario
'f_colegio_egreso.Carga_Parametros "adm_salidas_alumnos.xml", "colegio_egreso"
'f_colegio_egreso.Inicializar conexion
'f_colegio_egreso.Consultar SQL
'f_colegio_egreso.Siguiente
'f_colegio_egreso.AgregaCampoCons "x", "x"

'---------------------------------------------------------------------------------------------------
'f_botonera.AgregaBotonUrlParam "siguiente", "pers_nrut", q_pers_nrut
'f_botonera.AgregaBotonUrlParam "siguiente", "pers_xdv", q_pers_xdv
'---------------------------------------------------------------------------------------------------
'for each k in request.Form
'	response.Write("<br>" & k & " : " & request.Form(k))
'next

'if not EsVacio(Request.Form) then
'	f_titulado.AgregaCampoCons "pers_tape_paterno", Request.Form("dp[0][pers_tape_paterno]")	
'	f_titulado.AgregaCampoCons "pers_tape_materno", Request.Form("dp[0][pers_tape_materno]")	
'	f_titulado.AgregaCampoCons "pers_tnombre", Request.Form("dp[0][pers_tnombre]")
'	f_titulado.AgregaCampoCons "sexo_ccod", Request.Form("dp[0][sexo_ccod]")
'	f_titulado.AgregaCampoCons "dire_tcalle", Request.Form("dp[0][dire_tcalle]")
'	f_titulado.AgregaCampoCons "dire_tnro", Request.Form("dp[0][dire_tnro]")
'	f_titulado.AgregaCampoCons "dire_tpoblacion", Request.Form("dp[0][dire_tpoblacion]")
'	f_titulado.AgregaCampoCons "ciud_ccod", Request.Form("dp[0][ciud_ccod]")
'	f_titulado.AgregaCampoCons "pers_nnota_ens_media", Request.Form("dp[0][pers_nnota_ens_media]")
'	f_titulado.AgregaCampoCons "pers_nano_egr_media", Request.Form("dp[0][pers_nano_egr_media]")	
'	f_colegio_egreso.AgregaCampoCons "ciud_ccod_colegio", Request.Form("dp[0][ciud_ccod_colegio]")
'	v_ciud_ccod_colegio = Request.Form("dp[0][ciud_ccod_colegio]")	
'end if


'f_colegio_egreso.AgregaCampoParam "cole_ccod", "filtro", " cast(ciud_ccod as varchar)='" & f_colegio_egreso.ObtenerValor("ciud_ccod_colegio") & "'"



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
<style>
a {
	color: #000000;
	text-decoration: none;
	font-weight:bold;	
}

a:hover {
	color: #63ABCC;
}
</style>
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
    <div id="menu2"> 
      
      <div align="left">
        <script type="text/javascript">
AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0','width','485','height','28','src','menu_2b','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','menu_2b' ); //end AC code
        </script>
        <noscript>
          <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="485" height="28">
            <param name="movie" value="menu_2b.swf" />
            <param name="quality" value="high" />
            <embed src="menu_2b.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="485" height="28"></embed>
          </object>
        </noscript>
      </div>
  </div>

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
																<font size="3"><strong>Actualización datos personales</strong></font>
															</td>
														</tr>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
														</tr>
														<!--<form name="edicion">
														<tr>
															<td width="100%" align="left">
																<table width="98%"  border="0" align="center">
																	<tr>
																	  <td width="15%"><font size="2"><strong><font color="#FF0000">(*)</font>RUT</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%" colspan="4"><font size="2"><%'f_titulado.dibujaCampo("pers_nrut")%> - <%'f_titulado.dibujaCampo("pers_xdv")%><%'f_titulado.dibujaCampo("pers_ncorr")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong><font color="#FF0000">(*)</font>Ap. Paterno</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%"><font size="2"><%'f_titulado.dibujaCampo("pers_tape_paterno")%></font></td>
																	  <td width="15%"><font size="2"><strong><font color="#FF0000">(*)</font>Ap. Materno</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%"><font size="2"><%'f_titulado.dibujaCampo("pers_tape_materno")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong><font color="#FF0000">(*)</font>Nombres</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td colspan="4"><font size="2"><%'f_titulado.dibujaCampo("pers_tnombre")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong>Sexo</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td colspan="4"><font size="2"><%'f_titulado.dibujaCampo("sexo_ccod")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong>Calle</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%"><font size="2"><%'f_titulado.dibujaCampo("dire_tcalle")%></font></td>
																	  <td width="15%"><font size="2"><strong>N°</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%"><font size="2">&nbsp;</font><%'f_titulado.dibujaCampo("dire_tnro")%></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong>Poblaci&oacute;n-Villa</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%" colspan="4"><font size="2"><%'f_titulado.dibujaCampo("dire_tpoblacion")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong>Ciudad</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td colspan="4"><font size="2"><%'f_titulado.dibujaCampo("ciud_ccod")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong>Nota E.M.</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%"><font size="2"><%'f_titulado.dibujaCampo("pers_nnota_ens_media")%></font></td>
																	  <td width="15%"><font size="2"><strong>A&ntilde;o Egreso E.M.</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%"><font size="2"><%'f_titulado.dibujaCampo("pers_nano_egr_media")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2">&nbsp;</font></td>
																	  <td width="1%"><font size="2">&nbsp;</font></td>
																	  <td width="35%"><font size="2">&nbsp;</font></td>
																	  <td width="15%" colspan="3"><font size="2"><strong><font color="#FF0000">(*)</font></strong>Campos Obligatorios</font></td>
																	</tr>
																 </table>
															</td>
														</tr>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
														</tr>
														
														<tr>
															<td width="100%" align="left">
															    <font size="2">
																<div align="center">
									                                <%'f_colegio_egreso.DibujaRegistro%>
										                        </div>
																</font>
															</td>
														</tr>
														</form>-->
														<tr>
															<td width="100%" align="left"><font size="3">En Espera de una respuesta....</font></td>
														</tr>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
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
