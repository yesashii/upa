<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores
 
 ip_usuario=Request.ServerVariables("REMOTE_ADDR")
'response.Write(ip_usuario)

 set negocio = new CNegocio
 negocio.Inicializa conexion
'------------------------------------------------------
 
 usuario = negocio.obtenerUsuario
 
 nombre_alumno = conexion.consultaUno("Select protic.initcap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas_postulante where cast(pers_nrut as varchar)='"&usuario&"'")
'response.Write(nombre_alumno)

'------------------------------------------------------  
 set botonera = new Cformulario
 botonera.carga_parametros "menu_alumno.xml", "btn_portada"
'------------------------------------------------------
 pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&usuario&"'")
 cantidad_matriculas = conexion.consultaUno("select count(*) from alumnos a, ofertas_academicas b, especialidades c where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod  and a.emat_ccod in (1,2,4,8) and carr_ccod in ('193','39')")

ultima_oferta = conexion.consultaUno("select protic.ultima_oferta_matriculado('"&pers_ncorr&"')")
jornada = conexion.consultaUno("select ltrim(rtrim(jorn_ccod)) from ofertas_academicas where cast(ofer_ncorr as varchar)='"&ultima_oferta&"'")
carrera = conexion.consultaUno("select ltrim(rtrim(carr_ccod)) from ofertas_academicas a, especialidades b  where cast(a.ofer_ncorr as varchar)='"&ultima_oferta&"' and a.espe_ccod=b.espe_ccod")
anos_ccod = conexion.consultaUno("select anos_ccod from ofertas_academicas a, periodos_academicos b where cast(a.ofer_ncorr as varchar)='"&ultima_oferta&"' and a.peri_ccod = b.peri_ccod")
ano_ingreso = conexion.consultaUno("select aran_nano_ingreso from ofertas_academicas a, aranceles b where cast(a.ofer_ncorr as varchar)='"&ultima_oferta&"' and a.aran_ncorr = b.aran_ncorr")
nano_ingreso= conexion.consultaUno("select protic.ANO_INGRESO_CARRERA_EGRESADOS('"&pers_ncorr&"','"&carrera&"')")
anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo_defecto&"'")

c_encuestas = "select cantidad_carga_2007 - con_evaluacion_docente as diferencia "& vbCrLf &_
			  " from "& vbCrLf &_
		  	  " ( "& vbCrLf &_
			  " select cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut, d.pers_tnombre + ' ' + d.pers_tape_paterno + ' ' + d.pers_tape_materno as alumno, "& vbCrLf &_
			  " (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc "& vbCrLf &_
			  " where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr "& vbCrLf &_
			  " and bb.peri_ccod in (206,208,209) and isnull(cc.sitf_ccod,'n') <> 'n' "& vbCrLf &_
			  " and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc "& vbCrLf &_
			  "             where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod  "& vbCrLf &_
			  "             and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1 "& vbCrLf &_
			  "             and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'20-10-2007',103))) as cantidad_carga_2007, "& vbCrLf &_
			  " (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc "& vbCrLf &_
			  " where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr "& vbCrLf &_
			  " and bb.peri_ccod in (206,208,209) "& vbCrLf &_
			  " and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc "& vbCrLf &_
			  "             where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod  "& vbCrLf &_
			  "             and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1 "& vbCrLf &_
			  "             and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'20-10-2007',103)) "& vbCrLf &_
			  " and exists (select 1 from evaluacion_docente ffff where ffff.pers_ncorr_encuestado=aa.pers_ncorr  "& vbCrLf &_
			  "             and ffff.secc_ccod=cc.secc_ccod)) as con_evaluacion_docente               "& vbCrLf &_
			  " from alumnos a, ofertas_academicas b, especialidades c,personas d "& vbCrLf &_
			  " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "& vbCrLf &_
			  " and c.carr_ccod='"&carrera&"' and cast(b.peri_ccod as varchar)='210' "& vbCrLf &_
			  " and a.emat_ccod <> 9 and a.alum_nmatricula <> '7777' "& vbCrLf &_
			  " and a.pers_ncorr = d.pers_ncorr "& vbCrLf &_
			  " and b.post_bnuevo='N' "& vbCrLf &_
			  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'"& vbCrLf &_
			  " ) tabla_1"
'response.Write(pers_ncorr)
diferencia_encuestas = conexion.consultaUno(c_encuestas)

con_encuesta = diferencia_encuestas		  
 pers_ncorr_temporal = pers_ncorr
 if pers_ncorr_temporal="27757" or pers_ncorr_temporal="102680" or pers_ncorr_temporal="102665" or pers_ncorr_temporal="103442" or pers_ncorr_temporal="107093" or pers_ncorr_temporal="101924" or pers_ncorr_temporal="106139" or pers_ncorr_temporal="102850" or pers_ncorr_temporal="106379" or pers_ncorr_temporal="102244" or pers_ncorr_temporal="124378" or pers_ncorr_temporal="110818" or pers_ncorr_temporal="102479" or pers_ncorr_temporal="117500" or pers_ncorr_temporal="21513" or pers_ncorr_temporal= "102864" or pers_ncorr_temporal= "112289" or pers_ncorr_temporal="23213" or pers_ncorr_temporal="22652" or pers_ncorr_temporal="98132" or pers_ncorr_temporal="113850" or pers_ncorr_temporal="98383" or pers_ncorr_temporal="102495" or pers_ncorr_temporal="110426" or pers_ncorr_temporal="96971" or pers_ncorr_temporal="23218" or pers_ncorr_temporal="117125"  or pers_ncorr_temporal="97186" or pers_ncorr_temporal="21810" or pers_ncorr_temporal="20622" then 
	con_encuesta = "0"
 end if
		
if con_encuesta = "0"  then
desbloquear_todo="S"
	if carrera ="830" or carrera ="850" or carrera ="880" or carrera ="870" or carrera ="940" or carrera ="950" or carrera = "860" then
		desbloquear_todo="N"
		mensaje_convocatoria = "La toma de carga para alumnos de tu escuela ha sido aplazada hasta el mes de marzo."
		
    end if		
end if

desbloquear_todo = conexion.consultaUno("select case when convert(varchar,getDate(),103) > convert(datetime,'03/03/2008',103) then 'N' else 'S' end ")
if desbloquear_todo ="N" then
	msj_toma_cerrada = "La toma de carga online estará abierta hasta el 03 de marzo, luego se realizará este proceso en cada una de las escuelas."
end if 
if con_encuesta <> "0" then
    desbloquear_todo="N" 
	msj_toma_cerrada = "Para ver la opción de toma de carga online debes completar todas las evaluaciones docentes del año 2007, este proceso se abrirá el día 28 de Enero hasta el 03 de marzo."
end if

bloquear_encuesta = conexion.consultaUno("select case when convert(varchar,getDate(),103) < convert(datetime,'28/01/2008',103) then 'S' else 'N' end ")
'response.Write(desbloquear_todo)
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
<script language="JavaScript"> 
<!-- 
function EncuadraVentana(){
	if(parent.location != self.location)parent.location = self.location;
}
function emprendedores()
{
	window.open('contestar_encuesta_emprendedores.asp','encuesta','with=600 height=600 scrollbars=yes resizable=yes');
}
//--> 
</script>
<style media="screen" type="text/css">
    ul#menu {
      margin: 0;
      padding: 0;
      list-style-type: none;
      width: 100px;
    }
    
    ul#menu li {
      display: block;  
       height: 18px;
       
       margin-bottom: 5px;
          width: 100%;
    }
    
    li#presentacion a:link, li#presentacion a:visited {     
      border-left: 4px solid #3366cc;            
    }
    
    li#encuestas a:link, li#encuestas a:visited {     
      border-left: 4px solid #3300FF;            
    }
	
	li#escuelas a:link, li#escuelas a:visited {     
      border-left: 4px solid #0099CC;            
    }
    
    li#aloja a:link, li#aloja a:visited {     
      border-left: 4px solid #ff0066;            
    }
    
    li#ayudas a:link, li#ayudas a:visited {     
      border-left: 4px solid #cc3300;            
    }
    
    li#matricula a:link, li#matricula a:visited {     
      border-left: 4px solid #006633;            
    }
    
    li#alumnos a:link, li#alumnos a:visited  {     
      border-left: 4px solid #666633;            
    }
    li#toma_carga a:link, li#toma_carga a:visited  {     
      border-left: 4px solid #003300;            
    }
    li#actividades a:link, li#actividades a:visited {     
      border-left: 4px solid #CC9900;            
    }
    
    li#clave a:link, li#clave a:visited {     
      border-left: 4px solid #ff9933;            
    }

    #menu li#presentacion a:hover, #menu li#presentacion a:active {
      background: #3366cc;
    }
    
    #menu li#ayudas a:hover, #menu li#ayudas a:active {
      background: #cc3300;
    }
    
    #menu li#actividades a:hover, #menu li#actividades a:active {
      background: #CC9900;
    }
    
	#menu li#clave a:hover, #menu li#clave a:active {
      background: #CC9900;
    }

    #menu li#alumnos a:hover, #menu li#alumnos a:active {
      background: #666633;
    }
    
    #menu li#matricula a:hover, #menu li#matricula a:active {
      background: #006633;
    }
    
    #menu li#aloja a:hover, #menu li#aloja a:active {
      background: #ff0066;
    }
    
    #menu li#escuelas a:hover, #menu li#escuelas a:active {
      background: #0099CC;
    }
	
	#menu li#encuestas a:hover, #menu li#encuestas a:active {
      background: #3300FF;
    }
	
	#menu li#toma_carga a:hover, #menu li#toma_carga a:active {
      background: #003300;
    }
    
	#menu li#clave a:hover, #menu li#clave a:active {
      background: #ff9933;
    }

    #menu li a {
      font-family: 'Verdana', 'Arial', sans;
      font-size: 13px;
      padding-top: 2px;
      padding-bottom: 6px;
      height: 18px;
      color: #000;
   padding-left: 5px;

    }
    
    #menu li a:link, #menu li a:visited {
      
      text-decoration: none;
      
    }
    
    #menu li a:hover, #menu li a:active {
      color: #FFF;      
    }
  </style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" onLoad="EncuadraVentana();">
<table align="center" width="100%">
	<tr>
		<td align="center"><font size="+1" color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font>
		</td>
	</tr>
	<tr>
		<td align="center"><font size="+3" color="#FFFFFF" face="Georgia, Times New Roman, Times, serif">Bienvenido a Pacífico<br>Online</font>
		</td>
	</tr>
	<tr>
		<td align="center"><font size="+1" color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font>
		</td>
	</tr>
</table>
<table align="center" height="40%">
<tr><td valign="middle">
<table width="680"  height="303" border="0" cellspacing="0" cellpadding="0" align="center" background="../imagenes/menu_2.jpg">
  <tr> 
    <td height="10" colspan="2">&nbsp;</td>
  </tr>
  <ul id="menu">
  <tr valign="top"> 
    <td width="68%">&nbsp;</td>
	<td width="32%"> <li id="encuestas">
     				 	<a href="ficha_alumno.asp" title="Ver Datos Personales">
                           Datos Personales
     					</a>
    				</li>
    </td>

  </tr>
  <tr valign="top"> 
    <td width="68%">&nbsp;</td>
	<td width="32%"> <li id="presentacion">
					 <a href="cuenta_corriente_alumno.asp" title=" Ver Cuenta Corriente">
					  Cuenta Corriente
					 </a>
					</li>

	</td>
  </tr>
  <tr valign="top"> 
    <td width="68%">&nbsp;</td>
	<td width="32%"><li id="escuelas">
					 <a href="carga_alumno.asp" title="Ver Carga Académica">
					 Carga Académica
					 </a>
					</li>

	 </td>
  </tr>
  <% 'response.Write("ojo "&sys_considerar_evaluacion_docente)
    if bloquear_encuesta="N" then %>
  <tr valign="top"> 
    <td width="68%">&nbsp;</td>
	<td width="32%"><li id="alumnos">
								 <a href="seleccionar_docente.asp" title="Contestar Evaluación Docente">
								 Evaluación Docente 
								 </a>
					</li>
	</td>
  </tr>
  <%end if%>
  <tr valign="top"> 
    <td width="68%">&nbsp;</td>
	<td width="32%"><li id="matricula">
					<a href="notas_parciales_alumno.asp" title="Notas Parciales e Histórico">
					 Notas Parciales
					</a>
					</li>

	 </td>
  </tr>
  <% 'desbloquear_todo  = "N"
   if desbloquear_todo = "S" then%>
  <tr valign="top"> 
    <td width="68%">&nbsp;</td>
	<td width="32%"><li id="toma_carga">
					<a href="inicio_toma_carga_2008.asp" title="Toma de Asignaturas Online">
					 Toma de Carga (Online)
					</a>
					</li>

	 </td>
  </tr>
  <%end if%>
  <tr valign="top"> 
    <td width="68%">&nbsp;</td>
	<td width="32%"><li id="ayudas">
					 <a href="solicitud_reporte_alumno.asp" title="Enviar email de solicitud">
					 Solicitar Certificado  
					 </a>
					</li>
	</td>
  </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td><li id="clave"> <a href="cambiar_clave.asp" title="Cambiar Clave"> Cambiar Clave </a></li></td>
  </tr>
  <tr valign="top"> 
    <td width="68%">&nbsp;</td>
	<td width="32%"><li id="actividades">
					 <a href="cerrar_sesion.asp" title="Cerrar Sesión">
					 Cerrar Sesi&oacute;n&nbsp;&nbsp;&nbsp;&nbsp;  
					 </a>
					</li>
    </td>
  </tr>
  </ul>
 
</table>
</td></tr></table>
<table align="center" width="100%">
	<tr>
		<td align="center"><font size="1" color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif"><strong>Bienvenido(a) <%=nombre_alumno%></strong></font>
		</td>
	</tr>
	<%if msj_toma_cerrada <> "" then%>
	<tr>
		<td align="center"><marquee><br><font size="2" color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif"><strong><%=msj_toma_cerrada%></strong></font></marquee>
		</td>
	</tr>
	<%end if%>
	<br>
	<%if carrera = "16" then %>
	<tr>
		<td align="center">&nbsp;
		                  <table width="680" bgcolor="#FFFF66" bordercolor="#FFFF66">
							  <tr valign="top">
								 <td colspan="2" align="left"><font size="4" face="Courier New, Courier, mono" color="#003399"><strong>"Avanzando para tu futuro"</strong></font></td>
							  </tr>	
							  <tr valign="top">
								 <td width="85%" align="left"><font size="4" face="Courier New, Courier, mono" color="#003399"><strong>Te invitamos a responder la encuesta para actualizar el perfil de egreso de tu escuela.</strong></font></td>
								 <td width="15%" align="left"><a href="encuesta_disenio.asp" title="Contestar Evaluación Perfil Egresado de Diseño"><img src="../imagenes/flecha_encuesta.jpg" width="51" height="47" border="0"></a></td>
							  </tr> 
					      </table>
		</td>
	 </tr>
	 <%end if%>
	<%if bloquear_encuesta = "N" then%>
	<tr>
		<td align="center">&nbsp;
		                  <table width="680" bgcolor="#FFFF66" bordercolor="#FFFF66">
							   <tr valign="top">
								 <td width="85%" align="left"><font size="4" face="Courier New, Courier, mono" color="#003399"><strong>No olvides completar la evaluación docente, y así podrás realizar la toma de carga académica 2008</strong></font></td>
								 <td width="15%" align="left"><a href="seleccionar_docente.asp" title="Contestar Evaluación Docente"><img src="../imagenes/flecha_encuesta.jpg" width="51" height="47" border="0"></a></td>
							  </tr> 
					      </table>
		</td>
	 </tr>
	 <%end if%>
</table>
</body>
</html>
