<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_apoderado.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion

  q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
  q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
  if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
  end if
  usuario = q_pers_nrut
 
 nombre_alumno = conexion.consultaUno("Select protic.initcap(pers_tnombre + ' ' + pers_tape_paterno+' ' + pers_tape_materno) from personas_postulante where cast(pers_nrut as varchar)='"&usuario&"'")
 pers_ncorr    = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&usuario&"'")

 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "mensajes.xml", "botonera"
 
 
'response.Write(total)

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumno.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

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
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="730">
	<tr>
		<td width="100%" align="center"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Intranet Apoderados<br>
		</strong></font>
	  </td>
	</tr>
	<tr>
		<td width="100%" align="center">
		</td>
	</tr>
		
	<tr>
		<td width="100%" align="center">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
						<form name="edicion" action="carga_alumno.asp">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="185"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Estimado Apoderado: </strong></font></td>
										   <td width="441"><hr></td>
										   <td width="38" height="38">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
										  <td><font size="3" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>
           </strong></font><div align="justify">
             <p><font color="#23354d" size="3" face="Georgia, Times New Roman, Times, serif"><strong>Actualmente se encuentra visualizando la informaci&oacute;n correspondiente   al alumno(a): </strong></font><font size="3" face="Georgia, Times New Roman, Times, serif" color="#00CCCC"><strong><%=nombre_alumno%></strong></font></p>
             <p><font color="#23354d" size="3" face="Georgia, Times New Roman, Times, serif"><strong>Le invitamos a navegar por las opciones del men&uacute; que se encuentran en la parte superior de la p&aacute;gina y revisar los datos personales y financieros asociados al alumno.</strong></font> </p>
             <p align="center">&nbsp;</p>
           </div>
										  </td>
										</tr>
										
								  </table>
                               </td>
							</tr>
						 </form>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		
		</td>
	</tr>
</table>
 <td width="100%" height="38">
  </td>

</center>

</body>
</html>
