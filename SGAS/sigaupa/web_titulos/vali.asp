<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

mensaje_devuelto = request.QueryString("eea")
rut_usuario = session("rut_tyg")
'response.Write(rut_usuario)
 if rut_usuario <> "" then
 	nombre = conexion.consultaUno("Select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno) from personas where cast(pers_nrut as varchar)='"&rut_usuario&"'")
	url_cierre = "cierre_tyg.asp"
 else
    nombre = ""
 	url_cierre = "controla_login_tyg.asp"
 end if

rut_consultado = request.Form("rut")
dv_consultado = request.Form("dv")
folio_consultado = request.Form("folio")
rut_e_consultado = request.Form("rut_e")
dv_e_consultado = request.Form("dv_e")
consultor = request.Form("consultor")

set f_certificados = new CFormulario
f_certificados.Carga_Parametros "tabla_vacia.xml", "tabla"
f_certificados.Inicializar conexion
		   
consulta = " select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) as nombre,  "& vbCrLf &_ 
		   " b.tsca_ccod, protic.initCap(tsca_tdesc) as tipo, protic.initCap(linea_1_certificado + ' ' + linea_2_certificado) as titulo   "& vbCrLf &_ 
		   " from alumnos_salidas_carrera a, salidas_carrera b, tipos_salidas_carrera c, personas d  "& vbCrLf &_ 
		   " where a.saca_ncorr=b.saca_ncorr and b.tsca_ccod=c.tsca_ccod and a.pers_ncorr=d.pers_ncorr  "& vbCrLf &_ 
		   " and cast(d.pers_nrut as varchar)='"&rut_consultado&"' and d.pers_xdv='"&dv_consultado&"'  "& vbCrLf &_ 
		   " and a.asca_nfolio='"&folio_consultado&"'  "& vbCrLf &_ 
		   " order by b.tsca_ccod "
			
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_certificados.Consultar consulta

total = f_certificados.nroFilas

if total > 0 then 
	busqueda="exitosa"
	nombre_alumno = conexion.consultaUno("select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_nrut as varchar)='"&rut_consultado&"'")
else
	busqueda="fallida"	
end if

set f_ceremonia = new CFormulario
f_ceremonia.Carga_Parametros "tabla_vacia.xml", "tabla"
f_ceremonia.Inicializar conexion
		   
consulta = " select protic.initcap(mes_tdesc)+'  '+cast(datepart(day,fecha_ceremonia) as varchar)+' de '+  cast(datepart(year,fecha_ceremonia) as varchar) as fechita, "& vbCrLf &_ 
		   " protic.initCap(sede_tdesc) as sede,lugar as lugar, hora_inicio as horario, fecha_ceremonia "& vbCrLf &_ 
		   " from ceremonias_titulacion a, sedes b, meses c "& vbCrLf &_ 
		   " where fecha_ceremonia > getDate() "& vbCrLf &_ 
		   " and a.sede_ccod=b.sede_ccod and datepart(month,fecha_ceremonia)=mes_ccod "& vbCrLf &_ 
		   " and isnull(hora_inicio,'')<>'' and isnull(lugar,'') <> '' "& vbCrLf &_ 
		   " order by fecha_ceremonia asc "
			
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_ceremonia.Consultar consulta

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="description" content="Your description goes here" />
  <meta name="keywords" content="your,keywords,goes,here" />
  <link rel="stylesheet" type="text/css" href="andreas00.css" media="screen,projection" />
  <title>Procedimiento para Cancelaci&oacute;n de Certificados</title>
  <style type="text/css">
<!--
#apDiv1 {
	position:fixed;
	left:312px;
	top:152px;
	width:410px;
	height:360px;
	z-index:1;
	overflow: auto;
	border: 3px double #663399;
	padding: 8px;
	text-align: justify;
}
.fondo {
	background-image: url(../Copia%20de%20%20web_tit_grad/img/fondoUPA.jpg);
}
-->
  </style>
  <script src="Scripts/AC_RunActiveContent.js" type="text/javascript"></script>
  <script language="JavaScript" src="../biblioteca/funciones.js"></script>
  <script language="JavaScript" src="../biblioteca/validadores.js"></script>
  
  <script type="text/javascript">
  function buscar_certificados()
  { 
  	var formulario = document.buscador;
		if((valida_rut(formulario.elements["rut"].value + '-' + formulario.elements["dv"].value)))
		{
			if ((formulario.elements["folio"].value !="" )&&(formulario.elements["consultor"].value !="" )&&(formulario.elements["rut"].value!="")&&(formulario.elements["dv"].value!="")&&(formulario.elements["rut_e"].value!="")&&(formulario.elements["dv_e"].value!=""))
			{
				if((valida_rut(formulario.elements["rut_e"].value + '-' + formulario.elements["dv_e"].value)))
				{
					formulario.submit();
				}
				else
				{
					alert("El Rut de la empresa solicitante no es válido");
				}	
			}
			else
			{
				alert("Debe ingresar los datos de Rut, folio y quién consulta para procesar la búsqueda");
			}    
		}
		else
		{
			alert("El Rut ingresado no es válido");
		}
	}
</script>

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
      <ul>
        <li>
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
        <li></li>
      </ul>
    </div>
    <div id="extras">
    <form id="form1" method="post" action="controla_login_tyg.asp" target="_top">
        <table width="148">
          <%if nombre = "" then%>
		  <tr>
          <td colspan="2"><strong>Si requiere Certificados:<br/>
            </strong>
				<%if nombre = "" then %>
                	<strong>Ingrese sus Datos</strong> <strong>Aqu&iacute;</strong>
				<%end if%>
			</td>
          </tr>
		  <tr valign="middle">
            <td width="33%">Usuario</td>
            <td width="67%">
				<label>
		            <input type="text" name="usuario" id="usuario" />(12345678-9)
                </label>
			</td>
          </tr>
          <tr>
            <td width="33%">Clave</td>
            <td width="67%">
				<label>
              		<input type="password" name="clave" id="clave" />
            	</label>
			</td>
          </tr>
		  <%else%>
		  <tr>
            <td colspan="2" align="left"><strong><font color="#0066FF">Usted se ha autentificado como:<br></font><font color="#565a5e"><%=nombre%></font></strong></td>
          </tr>
		  <%end if%>
          <tr valign="top">
            <td colspan="2" align="center">
			<%if mensaje_devuelto="0" then%>
				<font color="#CC0000"><strong>Requiere datos de acceso y estar titulado o egresado</strong></font>			
			<%end if%>
			<label>
              <div align="center">
			   <%if nombre = "" then%>
                <table width="98%" cellpadding="0" cellspacing="0">
					<tr valign="top">
						<td width="50%" align="center">
							<input type="submit" name="ingreso" id="ingreso" value="Ingresar" />
						</td>
						
                  <td width="50%" align="center"> <a href="javascript:clave();">¿Recuperar 
                    Clave?</a> </td>
					</tr>
				</table>
				<p><br />
              		<font size="-3" color="#CC0000">Para solicitar certificación de Postítulos, Diplomados, Cursos, Seminarios, etc. dirigirlas a este correo:</font><a href="mailto:titulosygrados@upacifico.cl?subject=Solicitud de certificados y consultas&body=Sres. Títulos y Grados:%0D%0A %0D%0A"><img width="142" height="11" src="img/direccionTG.png" title="Consultas y solicitudes de certificados de otros programas" border="0"></a>
			    </p>
			   <%else%>
			    <input type="submit" name="salir" id="salir" value="Cerrar Sesión" />
				<p><br />
              		<font size="-3" color="#CC0000">Para solicitar certificación de Postítulos, Diplomados, Cursos, Seminarios, etc. dirigirlas a este correo:</font><a href="mailto:titulosygrados@upacifico.cl?subject=Solicitud de certificados y consultas&body=Sres. Títulos y Grados:%0D%0A %0D%0A"><img width="142" height="11" src="img/direccionTG.png" title="Consultas y solicitudes de certificados de otros programas" border="0"></a>
			    </p> 
			   <%end if%>	
              </div>
            </label></td>
          </tr>
		  <!--<tr>
		  	<td colspan="2" align="center"><img width="142" height="11" src="img/direccionTG.png"></td>
		  </tr>-->
        </table>
    </form>
      <p>
	  <marquee id=marco scrollamount=1 scrolldelay=3 direction=up width="148" height=70 name="marco">
		  <%while f_ceremonia.siguiente
		      fechita = f_ceremonia.obtenerValor("fechita")
			  sede = f_ceremonia.obtenerValor("sede")
			  lugar = f_ceremonia.obtenerValor("lugar")
			  horario = f_ceremonia.obtenerValor("horario")%>
			<b>
				<font color="#b90000"><%=fechita%><BR></font>
				<font color="#565a5e">Ceremonia de Titulación, <%=sede%>.<br><%=lugar%>&nbsp;<%=horario%><BR></font>
			</b>
			<hr color="#fbfed9">  
		  <%wend%>	
		</marquee>
	  </p>
    </div>

    <div class="fondo" id="content">
      <table width="430" cellpadding="0" cellspacing="0" border="0" bgcolor="#FFFFFF">
				<tr>
					<td bgcolor="#FFFFFF" width="100%">
										 <table width="100%" cellpadding="0" cellspacing="0">
										   <tr>
											   <td colspan="3" width="100%" align="left">
														<font size="2"><strong>Validación de Certificados títulos y grado académico</strong></font>
											   </td>
										   </tr>
										   <tr>
											   <td colspan="3" width="100%" align="left">
														<font size="2">Ingrese los datos solicitados para verificar la existencia del certificado:</font>
											   </td>
										   </tr>
										   <form name="buscador" method="post" action="vali.asp">
										   <tr>
										   		<td width="34%" align="left"><font size="2">Rut certificado</font></td>
												<td width="1%" align="center"><font size="2">:</font></td>
												<td width="65%" align="left"><input type="text" size="12" maxlength="9" name="rut" value="<%=rut_consultado%>">-
												                             <input type="text" size="2" maxlength="1" name="dv" value="<%=dv_consultado%>"><font size="-1"> (Ej:12345678-9)</font></td>
										   </tr>
										   <tr>
										   		<td width="34%" align="left"><font size="2">N° Folio</font></td>
												<td width="1%" align="center"><font size="2">:</font></td>
												<td width="65%" align="left"><input type="text" size="20" maxlength="20" name="folio" value="<%=folio_consultado%>"></td>
										   </tr>
										   <tr>
										   		<td width="34%" align="left"><font size="2">Rut empresa solicitante</font></td>
												<td width="1%" align="center"><font size="2">:</font></td>
												<td width="65%" align="left"><input type="text" size="12" maxlength="9" name="rut_e" value="<%=rut_e_consultado%>">-
												                             <input type="text" size="2" maxlength="1" name="dv_e" value="<%=dv_e_consultado%>"><font size="-1"> (Ej:12345678-9)</font></td>
										   </tr>
										   <tr>
										   		<td width="34%" align="left"><font size="2">Razón Social empresa solicitante</font></td>
												<td width="1%" align="center"><font size="2">:</font></td>
												<td width="65%" align="left"><input type="text" name="consultor" size="35" maxlength="120" value="<%=consultor%>"></td>
										   </tr>
										   <%if total = 0 and rut_consultado <> "" and folio_consultado <> "" then%>
										   <tr>
											   <td colspan="3" width="100%" align="center">
													<font color="#b90000"><strong>Los datos consultados no se encuentran registrados en los sistemas de la Universidad, favor comunicarse con personal del Departamento de Títulos y Grados.</strong></font>
											   </td>
										   </tr>
										   <%end if%>
										   <tr>
											   <td colspan="3" width="100%" align="right">
														<input type="button" name="buscar" value="Buscar Certificado" onClick="javascript: buscar_certificados()">
											   </td>
										   </tr>
										   </form>
										 </table>
					 </td>
				</tr>
		 </table>
		 <%if total > 0 then%>
		 <table width="430" cellpadding="0" cellspacing="0" border="0" bgcolor="#FFFFFF">
			<tr>
				<td width="100%">El alumno <strong><%=nombre_alumno%></strong> registra los siguientes certificados para el folio <strong><%=folio_consultado%></strong>:</td>
			</tr>
			<tr>
				<td width="100%" align="center">
					<table width="90%" align="center" cellpadding="0" cellspacing="0">
						<tr>
							<td align="center"><font color="#b90000"><strong>Tipo</strong></font></td>
							<td align="center"><font color="#b90000"><strong>Título</strong></font></td>
						</tr>
						<%while f_certificados.siguiente%>
						<tr>
							<td align="left"><font color="#565a5e"><%=f_certificados.obtenerValor("tipo")%></font></td>
							<td align="left"><font color="#565a5e"><%=f_certificados.obtenerValor("titulo")%></font></td>
						</tr>
						<%wend%>
					</table>				
				</td>
			</tr>
		 </table> 
		 <%end if%>
    </div>

    <div id="footer">
      <p>Universidad del Pacífico - Derechos Reservados / Sitio desarrollado para Explorer 8, o superior; Firefox o Safari</p>
    </div>
  </div>
<script type="text/javascript">
	function clave() {
	  direccion = "http://admision.upacifico.cl/web_titulos/www/olvido_clave.php";
	  window.open(direccion ,"ventana1","width=370,height=225,scrollbars=no, left=313, top=200");
	}
</script>
</body>
</html>
