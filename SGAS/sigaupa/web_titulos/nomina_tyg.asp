 <!-- #include file = "../biblioteca/_conexion.asp" -->
<%

v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
habilitar_texto =   "0"
if (v_mes_actual = 12 and v_dia_actual >=10 ) or (v_mes_actual = 1 and v_dia_actual <=30 ) then
	habilitar_texto =   "1"
end if

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


set f_ceremonia = new CFormulario
f_ceremonia.Carga_Parametros "tabla_vacia.xml", "tabla"
f_ceremonia.Inicializar conexion
		   
consulta = " select protic.initcap(mes_tdesc)+'  '+cast(datepart(day,fecha_ceremonia) as varchar)+' de '+  cast(datepart(year,fecha_ceremonia) as varchar) as fechita, "& vbCrLf &_ 
		   " protic.initCap(sede_tdesc) as sede,lugar as lugar, hora_inicio as horario, fecha_ceremonia "& vbCrLf &_ 
		   " from ceremonias_titulacion a, sedes b, meses c "& vbCrLf &_ 
		   " where fecha_ceremonia >= protic.trunc(getDate()) "& vbCrLf &_ 
		   " and a.sede_ccod=b.sede_ccod and datepart(month,fecha_ceremonia)=mes_ccod "& vbCrLf &_ 
		   " and isnull(hora_inicio,'')<>'' and isnull(lugar,'') <> '' "& vbCrLf &_ 
		   " and exists (select 1 from detalles_titulacion_carrera tt (nolock) where tt.id_ceremonia=a.id_ceremonia) "& vbCrLf &_ 
		   " order by fecha_ceremonia asc "
			
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_ceremonia.Consultar consulta

set listado_sedes = new CFormulario
listado_sedes.Carga_Parametros "tabla_vacia.xml", "tabla"
listado_sedes.Inicializar conexion
		   
consulta = " select protic.initcap(mes_tdesc)+'  '+cast(datepart(day,fecha_ceremonia) as varchar)+' de '+  cast(datepart(year,fecha_ceremonia) as varchar) as fechita, "& vbCrLf &_ 
		   " protic.initCap(sede_tdesc) as sede,lugar as lugar, hora_inicio as horario, fecha_ceremonia, b.sede_ccod,a.id_ceremonia "& vbCrLf &_ 
		   " from ceremonias_titulacion a, sedes b, meses c "& vbCrLf &_ 
		   " where fecha_ceremonia >= protic.trunc(getDate()) "& vbCrLf &_ 
		   " and a.sede_ccod=b.sede_ccod and datepart(month,fecha_ceremonia)=mes_ccod "& vbCrLf &_ 
		   " and isnull(hora_inicio,'')<>''"& vbCrLf &_ 
		   " and exists (select 1 from detalles_titulacion_carrera tt (nolock) where tt.id_ceremonia=a.id_ceremonia) "& vbCrLf &_ 
		   " order by fecha_ceremonia asc "
			
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
listado_sedes.Consultar consulta

set listado_carreras = new CFormulario
listado_carreras.Carga_Parametros "tabla_vacia.xml", "tabla"
listado_carreras.Inicializar conexion

set listado_alumnos = new CFormulario
listado_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
listado_alumnos.Inicializar conexion

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
  <SCRIPT type=text/javascript src="http://code.jquery.com/jquery-latest.js"></SCRIPT>
	<SCRIPT type=text/javascript> 
	$(document).ready(function(){
	
	$('.acc_container').hide();
	$('.acc_trigger:first')
		.addClass('active')
		.next()
		.show();
	
	$('.acc_trigger').click(function(){
		if( $(this).next().is(':hidden') ) {
			$('.acc_trigger')
				.removeClass('active')
				.next()
				.slideUp();
			$(this).toggleClass('active')
				.next()
				.slideDown();
		}
		return false;
	});
	
	});
	</SCRIPT> 
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
<STYLE type=text/css>
.container {
	width: 420px;
	margin: 0 auto;
}
h2.acc_trigger {
	padding: 0;	margin: 0 0 5px 0;
	background: url(h2_trigger_a.gif) no-repeat;
	height: 46px;	line-height: 46px;
	width: 420px;
	font-size: 2em;
	font-weight: normal;
	float: left;
}
h2.acc_trigger a {
	color: #fff;
	text-decoration: none;
	display: block;
	padding: 0 0 0 50px;
}
h2.acc_trigger a:hover {
	color: #ccc;
}
h2.active {background-position: left bottom;}
.acc_container {
	margin: 0 0 5px; padding: 0;
	overflow: hidden;
	font-size: 1.2em;
	width: 420px;
	clear: both;
	background: #f0f0f0;
	border: 1px solid #d6d6d6;
	-webkit-border-bottom-right-radius: 5px;
	-webkit-border-bottom-left-radius: 5px;
	-moz-border-radius-bottomright: 5px;
	-moz-border-radius-bottomleft: 5px;
	border-bottom-right-radius: 5px;
	border-bottom-left-radius: 5px;
}
.acc_container .block {
	padding: 20px;
}
</STYLE>
  <script src="Scripts/AC_RunActiveContent.js" type="text/javascript"></script>
  <script language="JavaScript" src="../biblioteca/funciones.js"></script>
  <script language="JavaScript" src="../biblioteca/validadores.js"></script>
  
  <script type="text/javascript">
  
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
			  horario = f_ceremonia.obtenerValor("horario")
			  %>
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
	<p><center><font size="3" color="#666666">
	              En caso de consultas, tome contacto con el Depto. de Títulos y Grados.
			   </font><br><br></center>
			   
	   
	</p>
      <table width="430" cellpadding="0" cellspacing="0" border="0" bgcolor="#FFFFFF">
				<tr>
					<td bgcolor="#FFFFFF" width="100%">
					<%while listado_sedes.siguiente
					   sede_ccod = listado_sedes.obtenerValor("sede_ccod")
					   id_ceremonia = listado_sedes.obtenerValor("id_ceremonia")
					   fechita = listado_sedes.obtenerValor("fechita")
					   sede = listado_sedes.obtenerValor("sede")
					   lugar = listado_sedes.obtenerValor("lugar")
					   horario = listado_sedes.obtenerValor("horario")
					   consulta = " select isnull(carrera2,carr_tdesc) as carrera,alumno  "& vbCrLf &_
								  " from  "& vbCrLf &_
								  " (  "& vbCrLf &_
								  " select c.carr_tdesc,protic.initCap(b.pers_tape_paterno + ' ' + b.pers_tape_materno + ', ' + b.pers_tnombre) as alumno,(select top 1 saca_tdesc from alumnos_salidas_intermedias tt, alumnos_salidas_carrera t2, salidas_carrera t3  "& vbCrLf &_
								  "        where tt.pers_ncorr=a.pers_ncorr and tt.saca_ncorr=a.plan_ccod and tt.pers_ncorr=t2.PERS_NCORR  "& vbCrLf &_
								  "        and tt.saca_ncorr=t2.saca_ncorr and t2.saca_ncorr=t3.saca_ncorr and t3.tsca_ccod=4) as carrera2  "& vbCrLf &_
								  " from detalles_titulacion_carrera a, personas b, carreras c  "& vbCrLf &_
								  " where cast(id_ceremonia as varchar)='"&id_ceremonia&"' and a.pers_ncorr=b.pers_ncorr  "& vbCrLf &_
								  " and a.carr_ccod=c.carr_ccod  "& vbCrLf &_
								  " )table2 "& vbCrLf &_
								  " order by carrera,alumno "

					  listado_alumnos.Consultar consulta
					  listado_alumnos.siguiente
					  carrera_mostrar = listado_alumnos.obtenerValor("carrera")
					  listado_alumnos.primero
					  fila = 1
					%>
					   <H2 class=acc_trigger>  
						   <A href="#"><%=fechita%> -> <%=sede%></A>
					   </H2>  
					   <DIV class=acc_container>  
						  <DIV class=block>  
						        <table width="390" cellpadding="0" cellspacing="0" align="center">
									<tr valign="top">
										<td align="center" colspan="2">
											<table width="95%" cellpadding="0" cellspacing="10" border="1" bordercolor="#FFFFFF">
												<tr>
													<td width="15%" bgcolor="#61aae1"><strong>Lugar</strong></td>
													<td width="85%" bgcolor="#61aae1">: <%=lugar%></td>
												</tr>
												<tr>
													<td width="15%" bgcolor="#61aae1"><strong>Horario</strong></td>
													<td width="85%" bgcolor="#61aae1">: <%=horario%></td>
												</tr>
											</table>
										</td>
									</tr>
									<%if sede_ccod <> "4" and 1 = 2 then %>
									<tr valign="top">
										<td colspan="2" align="center" height="25">
									       <font size="2" color="#FF3300" face="Verdana, Arial, Helvetica, sans-serif">
											  "RETIRAR INVITACIONES EN :
											   <br>
											   DEPTO. DE TITULOS Y GRADOS 
											   <br>
											   HORARIO DE ATENCIÓN LUNES A VIERNES DE 8:30 A 13:30 HRS Y DE 15:00 A 18:30 HRS.”
										   </font>
								   	    </td>
									</tr>
									<%end if%>
									<tr valign="top">
										<td colspan="2" align="center" height="25"><font color="#993300"><strong><%=carrera_mostrar%></strong></font></td>
									</tr>
									<%while listado_alumnos.siguiente
									    carrera = listado_alumnos.obtenerValor("carrera")
										alumno = listado_alumnos.obtenerValor("alumno")
											if carrera <> carrera_mostrar then
												carrera_mostrar = carrera
												fila = 1
												%>
												<tr valign="top">
													<td colspan="2" align="center" height="25"><font color="#993300"><strong><%=carrera_mostrar%></strong></font></td>
												</tr>
											<%	
											end if
										%>
										<tr>
											<td width="3%" align="center"><%=fila%></td>
											<td width="97%" align="left">:&nbsp;<%=alumno%></td>
										</tr>
								   <% fila = fila + 1
								     wend%>
								</table>  
						  </DIV>  
					   </DIV> 
					 <%wend%> 
    				</td>
				</tr>
		 </table>
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
