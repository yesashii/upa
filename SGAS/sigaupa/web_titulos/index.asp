<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

 'Session.Contents.RemoveAll() 
  
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 
 mensaje_devuelto = request.QueryString("eea")
 rut_usuario = session("rut_tyg")
' response.Write(rut_usuario)
 if rut_usuario <> "" then
 	nombre = conexion.consultaUno("Select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno) from personas where cast(pers_nrut as varchar)='"&rut_usuario&"'")
	url_cierre = "cierre_tyg.asp"
 else
    nombre = ""
 	url_cierre = "controla_login_tyg.asp"
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
  <title>Web de T&iacute;tulos y Grados</title>
<script src="Scripts/AC_RunActiveContent.js" type="text/javascript"></script>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

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
                <p><br/>
              		<font size="-3" color="#CC0000">Para solicitar certificación de Postítulos, Diplomados, Cursos, Seminarios, etc. dirigirlas a este correo:</font><a href="mailto:titulosygrados@upacifico.cl?subject=Solicitud de certificados y consultas&body=Sres. Títulos y Grados:%0D%0A %0D%0A"><img width="142" height="11" src="img/direccionTG.png" title="Consultas y solicitudes de certificados de otros programas" border="0"></a>
				</p>
			   <%else%>
			    <input type="submit" name="salir" id="salir" value="Cerrar Sesión" /> 
				<p><br />
              		<font size="-3" color="#CC0000">Para solicitar certificación de Postítulos, Diplomados, Cursos, Seminarios, etc. dirigirlas a este correo:</font><a href="mailto:titulosygrados@upacifico.cl?subject=Solicitud de certificados y consultas&body=Sres. Títulos y Grados:%0D%0A %0D%0A"><img width="142" height="11" src="img/direccionTG.png" title="Consultas y solicitudes de certificados de otros programas" border="0"></a>
			    </p>
			   <%end if%>	
              </div>
            </label>
			</td>
          </tr>
		  <!--<tr>
		  	<td colspan="2" align="left">
				 <table width="142" cellpadding="0" cellspacing="0">
					<tr>
						<td width="100%" align="center">
							<font size="-3" color="#CC0000">Para solicitar certificación de Postítulos, Diplomados, Cursos, Seminarios, etc. dirigirlas a este correo:</font><a href="mailto:titulosygrados@upacifico.cl?subject=Solicitud de certificados y consultas&body=Sres. Títulos y Grados:%0D%0A %0D%0A"><img width="142" height="11" src="img/direccionTG.png" title="Consultas y solicitudes de certificados de otros programas" border="0"></a>
						</td>
					</tr>
				 </table>
		   </td>
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

    <div id="content">
      <h4>
        <script type="text/javascript">
AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0','width','440','height','400','src','swf/Tex/colores/bienve_2','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','swf/Tex/colores/bienve_2' ); //end AC code
        </script>
		<%
		v_dia_actual 	= 	Day(now())
		v_mes_actual	= 	Month(now())
	    if ((v_mes_actual=2 and v_dia_actual <= 21)) then
		%>
		<p>
           <font color="#003399" size="2"> 
              Depto de Titulos y Grados, se encuentra en período de vacaciones desde el 3 al 21 de Febrero de 2014. 
              <br />
              Se solicita enviarnos un email a TITULOSYGRADOS@UPACIFICO.CL con sus requerimientos y/o consultas el cual responderemos en cuanto finalice el período señalado.
              <br />
			  <br />
              Agradeciendo su atención,
              <br />
              DEPTO. DE TITULOS Y GRADOS
		   </font>
		</p>
        <%end if%>
        <noscript>
        <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="440" height="400">
          <param name="movie" value="swf/Tex/colores/bienve_2.swf" />
          <param name="quality" value="high" />
          <embed src="swf/Tex/colores/bienve_2.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="440" height="400"></embed>
        </object>
        </noscript>
      </h4>
      <h2><strong></strong></h2>
      <strong>
      <!--<h2 style="color:red; text-align: center;">Esta area se encuentra de vacaciones desde el Lunes 4 de Febrero  hasta el Viernes 15 de Febrero.</h2>-->
  </strong>  </div>

<div id="footer">
      <p>Universidad del Pacífico - Derechos Reservados / Sitio desarrollado para Explorer 8, o superior; Firefox o Safari</p>
    </div>
  </div>
<script type="text/javascript">
	/*function mensaje_logeo()
	{
		var valor = '<%=mensaje_devuelto%>';
		if (valor=='0')
		{
			alert("Debe estar Egresado o Titulado\ny autentificarse para ingresar a esta opción");
		}
	}*/
	window.onload = function() {   
		var valor = '<%=mensaje_devuelto%>';
		if (valor=='0')
		{
			alert("Debe estar Egresado o Titulado\ny autentificarse para ingresar a esta opción");
		}
	}

	function clave() {
	  direccion = "http://admision.upacifico.cl/web_titulos/www/olvido_clave.php";
	  window.open(direccion ,"ventana1","width=370,height=225,scrollbars=no, left=313, top=200");
	}
</script>
</body>
</html>
