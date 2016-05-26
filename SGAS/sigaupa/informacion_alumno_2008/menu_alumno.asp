<!-- #include file = "../biblioteca/_conexion.asp" -->
<% 
'------------------------------------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 usuario = "16125125"
 
 nombre_alumno = conexion.consultaUno("Select protic.initcap(pers_tnombre + ' ' + pers_tape_paterno) from personas_postulante where cast(pers_nrut as varchar)='"&usuario&"'")
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


if con_encuesta <> "0" then
    desbloquear_todo="N" 
	msj_toma_cerrada = "Para ver la opción de toma de carga online debes completar todas las evaluaciones docentes del año 2007, este proceso se abrirá el día 28 de Enero."
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
function EncuadraVentana(){
	if(parent.location != self.location)parent.location = self.location;
}
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
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" onLoad="EncuadraVentana();" background="imagenes/fondo.jpg">
<center>
<table align="center" width="1000">
	<tr valign="top">
		<td align="100%">
			<table cellpadding="0" cellspacing="0" align="left" border="0">
				<tr>
					<td width="388" height="73"><img width="388" height="73" src="imagenes/banner1.jpg"></td>
					<td width="612" height="73"><img width="612" height="73" src="imagenes/banner2.jpg"></td>
				</tr>
				<tr valign="top">
					<td width="388" height="50" bgcolor="#4b73a6"><img width="388" height="49" src="imagenes/banner3.jpg"></td>
					<td width="612" height="50" bgcolor="#4b73a6">
					  <table width="100%" height="50" cellpadding="0" cellspacing="0">
					  	<tr valign="middle">
							<td align="left" width="100%">
							<div id="menu"><div class="barraMenu">
								<a class="botonMenu" href="">Datos Personales</a>
								<a class="botonMenu" href="">Cta. Corriente</a>
								<a class="botonMenu" href="">Horario</a>
								<a class="botonMenu" href="">Calificaciones</a>
								<a class="botonMenu" href="">Certificados</a>
								<a class="botonMenu" href="">Cambiar Clave</a>
							</div></div>
							</td>
						</tr>
						<tr valign="middle">
							<td align="left" width="100%">
							<div id="menu"><div class="barraMenu">
								<a class="botonMenu" href="">Ev. Docente</a>
								<a class="botonMenu" href="">Toma de Ramos</a>
								<a class="botonMenu" href="">Cerrar Sesión</a>
							</div></div>
							</td>
						</tr>
					  </table>
						
					</td>
				</tr>
			</table>
		
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1"></font></td>
	</tr>
	<tr>
		<td width="100%">
			<table width="270" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="90%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="40%">
									<table width="95%" border="1" align="center" bordercolor="#cccccc">
										<tr valign="middle">
											<td><img width="90" height="90" src="imagenes/user.png"></td>
										</tr>
									</table>
								</td>
								<td width="60%" align="center">
									<table width="100%">
										<tr><td><font size="3" face="Courier New, Courier, mono" color="#496da6"><strong>Bienvenido</strong></font></td></tr>
										<tr><td><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=nombre_alumno%></font></td></tr>
										<tr><td><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=Date%></font></td></tr>
									</table>
								</td>
								
							</tr>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
</table>
</center>
</body>
</html>
