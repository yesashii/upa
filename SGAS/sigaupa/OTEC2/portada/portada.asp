<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"

'set negocio = new CNegocio
'negocio.Inicializa conexion
'------------------------------------------------------
ip_usuario=Request.ServerVariables("REMOTE_ADDR")
 set errores = new CErrores

'------------------------------------------------------  
 set botonera = new Cformulario
 botonera.carga_parametros "portada.xml", "btn_portada"
'------------------------------------------------------

'---------------------------------------------------------------------
 set f_datos = new CFormulario
 f_datos.Carga_Parametros "portada.xml", "f_datos"
 f_datos.Inicializar conexion
 f_datos.Consultar "select ''"
 f_datos.Siguiente
 
 'f_datos.AgregaCampoCons "login","admin"
 'f_datos.AgregaCampoCons "clave","admin"
 
 if ip_usuario="172.16.11.79" or ip_usuario="172.16.11.67" or ip_usuario="172.16.100.160" then
if ip_usuario="172.16.11.79" then
	v_persenecor=30126 	 
end if
if ip_usuario="172.16.11.67" then
	v_persenecor=27720 	 
end if
if ip_usuario="172.16.100.160" then
			v_persenecor=123361 	 
end if
	 set f_datos_usuario = new CFormulario
 		f_datos_usuario.Carga_Parametros "portada.xml", "f_datos"
 		f_datos_usuario.Inicializar conexion
			consulta_login="select susu_tlogin, susu_tclave from sis_usuarios where pers_ncorr="&v_persenecor
 		f_datos_usuario.Consultar consulta_login
		f_datos_usuario.Siguiente
		
		v_login=f_datos_usuario.ObtenerValor("susu_tlogin")
		v_clave=f_datos_usuario.ObtenerValor("susu_tclave")
		
  	f_datos.AgregaCampoCons "login",v_login
 	f_datos.AgregaCampoCons "clave",v_clave		
 end if
 'response.Write("<p>ip usuario :</p><b>"&ip_usuario&"</b>")
%>
<html>
<head>
<title>Bienvenidos al Sistema OTEC</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">
function clave() {
  direccion = "olvido_clave.asp";
  window.open(direccion ,"ventana1","width=370,height=310,scrollbars=no, left=313, top=200");
}
function salir() {
  window.close();
}
</script>

<style type="text/css">
<!--
.Estilo2 {
	color: #000000;
	font-weight: bold;
}
.Estilo4 {font-family: "Book Antiqua"; color: #000000; }
-->
</style>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#e1eae0">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top" colspan="3"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <tr>
    <td width="3%" valign="top" bgcolor="#CCCCCC">&nbsp;</td>
    <td width="32%" align="center" valign="top" bgcolor="#CCCCCC">
		<table width="95%" border="00">

		     <tr>
			     <td>
			       <span class="Estilo2"><font size="3" face="Times New Roman, Times, serif">Bienvenido 
                            al Sistema OTEC<br>
                            Universidad del Pacífico</font></span></td>
			 </tr>
			 <tr>
			     <td><hr></td>
			 </tr>
			 <tr>

			     <td><font size="2"><span class="Estilo4">En esta aplicaci&oacute;n podrá hacer las siguientes actividades:</span></font></td>
			 </tr>
			 <tr>
			     <td><font size="2"><span class="Estilo4"><strong>Funcionario : </strong>Crear Cursos o Diplomados (Malla y aranceles), planificarlos (horarios y relatores) y gestionarlos.</span></font></td>
			 </tr>
			 <tr>
			     <td><font size="2"><span class="Estilo4"><strong>Escuela : </strong>Postular Alumnos y generar listados.</span></font></td>
			 </tr>
			 <tr>
			     <td><font size="2"><span class="Estilo4"><strong>Relatores : </strong>Imprimir nóminas de Curso.</span></font></td>
			 </tr>
			 
		</table>	</td>
    <td width="65%" rowspan="2" align="center" valign="bottom" bgcolor="#FFFFFF"><img src="../imagenes/derecha_superior_2007.jpg" width="422" height="242" border="0"></td> 
  </tr>
  <tr>
    <td height="25"  colspan="2" valign="bottom" bgcolor="#CCCCCC"><img src="../imagenes/esquina_izquierda_2007.gif" width="89" height="18" border="0"></td>
  </tr>
  <tr>

    <td  colspan="2" rowspan="2" valign="top" bgcolor="#003366"><br>
		<table width="95%">
		<tr>
		  <td width="25%" align="center" valign="middle"><img src="../imagenes/flecha.jpg" width="56" height="56" border="0"></td>
		  <td valign="middle" width="3%">&nbsp;</td>

		  <td valign="top" width="72%">
		  		<table width="100%" border="0">
					<tr>
						<td width="10%"><img src="../imagenes/a1.jpg" width="13" height="13" border="0"></td>
						<td width="2%">&nbsp;</td>
						<td><font size="2" color="#FFFFFF" face="Times New Roman, Times, serif">Seleccionar Perfil.</font></td>
					</tr>
					<tr>

						<td width="10%"><img src="../imagenes/a2.jpg" width="13" height="13" border="0"></td>
						<td width="2%">&nbsp;</td>
						<td><font size="2" color="#FFFFFF" face="Times New Roman, Times, serif">Escriba su Login de usuario y Clave.</font></td>
					</tr>
					<tr>
						<td width="10%"><img src="../imagenes/a3.jpg" width="13" height="13" border="0"></td>
						<td width="2%">&nbsp;</td>
						<td><font size="2" color="#FFFFFF" face="Times New Roman, Times, serif">Presione Aceptar.</font></td>
					</tr>
				</table>		  </td>
		</tr>
	</table></td>
    <td bgcolor="#CCCCCC" width="55%" align="justify">&nbsp;</td> 
  </tr>
   <tr>
    <form name="valida" action="" method="post">
    <td bgcolor="#CCCCCC" width="55%" align="center" valign="top">
		<table width="98%">
		    <tr>
				<td width="172" align="left">
					<table width="100%" border="0" cellpadding="0">
						<tr><td width="10%" align="center"><input type="radio" name="tipo_usuario" value="D.Extensión" checked></td>
						    <td width="2%" align="center"><strong>:</strong></td>
							<td align="left"><strong>Direcci&oacute;n de Extensi&oacute;n.</strong></td>
					    </tr>
						<tr><td width="10%" align="center"><input type="radio" name="tipo_usuario" value="D.Docencia"></td>
						    <td width="2%" align="center"><strong>:</strong></td>
							<td align="left"><strong>Direcci&oacute;n de Docencia.</strong></td>
					    </tr>
						<tr><td width="10%" align="center"><input type="radio" name="tipo_usuario" value="R.Curricular"></td>
						    <td width="2%" align="center"><strong>:</strong></td>
							<td align="left"><strong>Registro Curricular.</strong></td>
					    </tr>
						<tr><td width="10%" align="center"><input type="radio" name="tipo_usuario" value="Escuela"></td>
						    <td width="2%" align="center"><strong>:</strong></td>
							<td align="left"><strong>Escuela.</strong></td>
					    </tr>
						<tr><td width="10%" align="center"><input type="radio" name="tipo_usuario" value="Personal"></td>
						    <td width="2%" align="center"><strong>:</strong></td>
							<td align="left"><strong>Recursos Humanos.</strong></td>
					    </tr>
						<tr><td width="10%" align="center"><input type="radio" name="tipo_usuario" value="Relator"></td>
						    <td width="2%" align="center"><strong>:</strong></td>
							<td align="left"><strong>Relator.</strong></td>
					    </tr>
						<tr><td width="10%" align="center"><input type="radio" name="tipo_usuario" value="Cajero"></td>
						    <td width="2%" align="center"><strong>:</strong></td>
							<td align="left"><strong>Cajero.</strong></td>
					    </tr>
						<tr><td width="10%" align="center"><input type="radio" name="tipo_usuario" value="Contabilidad"></td>
						    <td width="2%" align="center"><strong>:</strong></td>
							<td align="left"><strong>Finanzas.</strong></td>
					    </tr>
						<tr><td width="10%" align="center"><input type="radio" name="tipo_usuario" value="Títulos"></td>
						    <td width="2%" align="center"><strong>:</strong></td>
							<td align="left"><strong>Títulos y Grados.</strong></td>
					    </tr>
                        <tr><td width="10%" align="center"><input type="radio" name="tipo_usuario" value="Call Center"></td>
						    <td width="2%" align="center"><strong>:</strong></td>
							<td align="left"><strong>Call Center.</strong></td>
					    </tr>
						 <tr><td width="10%" align="center"><input type="radio" name="tipo_usuario" value="Asistente"></td>
						    <td width="2%" align="center"><strong>:</strong></td>
							<td align="left"><strong>Asistente</strong></td>
					    </tr>
					</table>
				</td>
				<td width="2" background="../imagenes/separador.jpg">&nbsp;</td>
				<td width="150" align="center">
				    <table width="98%" border="0" cellpadding="0">
						<tr>
							<td width="30%"><%f_datos.dibujaCampo "login"%></td>
							<td><font size="2" color="#000000" face="Times New Roman, Times, serif"><strong>Usuario </strong></font></td>
						</tr>
						<tr>
							<td width="30%"><%f_datos.dibujaCampo "clave"%> </td>
							<td><font size="2" color="#000000" face="Times New Roman, Times, serif"><strong>Clave</strong></font></td>
						</tr>
					</table>
					<hr>
					<table>
						<tr><td colspan="2" align="center"><strong>Sede Asociada</strong></td></tr>
						<tr>
						  <td>Sede:</td>
							<td><select name="sede">
									<option value="1">Las Condes</option>
									<option value="8">Baquedano</option>
									<option value="2">Lyon</option>
									<option value="4">Melipilla</option>
									<option value="7">Concepcion</option>
								</select>
							</td>
						</tr>
					</table>
				</td>
				<td width="2" background="../imagenes/separador.jpg">&nbsp;</td>
				<td width="128" align="left">
						<%botonera.DibujaBoton("aceptar")%>
				</td>
			</tr>
		   
			
			<tr>
				<td colspan="6"><hr></td>
			</tr>
		</table>	</td>
	</form> 
  </tr>
  <tr>
    <td  colspan="3" valign="top" background="../imagenes/inferior_nuevo.jpg" height="28"><div align="left" class="Estilo2"><font size="2" face="Times New Roman, Times, serif" color="#FFFFFF">Derechos Reservados Universidad del Pacífico Chile</font></div></td>
  </tr>
</table>
<center><p>Sistema desarrollado para Internet Explorer 6.0 y versiones superiores
<br/>Resolución óptima: 1280 x 1024 pixeles</p></center>
</td>
</tr>
</table>
</body>
</html>