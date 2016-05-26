<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<% 
'------------------------------------------------------
 q_npag	= Request.QueryString("npag")
 traspaso 	= Request.QueryString("traspaso")
 if traspaso = "" then
 	tipo_traspaso="0"
 else
 	tipo_traspaso="1"
 end if	

 
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
  pers_ncorr=conexion.consultaUno("Select protic.obtener_pers_ncorr("&q_pers_nrut&")")
  
  'response.write(q_npag)
 
 'periodo_actual = "210"
 

 '-- Botones de la pagina -----------
 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "curriculum_alumno.xml", "botonera"
 
 '---------------------------------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "curriculum_alumno.xml", "busqueda"
 f_busqueda.Inicializar conexion

 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
 f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
'---------------------------------------------------------------------------------------------------
  set f_datos_antecedentes = new CFormulario
 f_datos_antecedentes.Carga_Parametros "curriculum_alumno.xml", "f_datos_antecedentes"
 f_datos_antecedentes.Inicializar conexion

					
selec_antecedentes=	"select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
					"protic.trunc(pers_fnacimiento)fnacimiento,"& vbCrLf &_
					"pers_temail,"& vbCrLf &_
					"pers_temail2,"& vbCrLf &_
					"(select sexo_tdesc from sexos bb where a.sexo_ccod=bb.sexo_ccod )as sexo,"& vbCrLf &_
					"(select eciv_tdesc from estados_civiles aa where a.eciv_ccod=aa.eciv_ccod)as estado_civil,"& vbCrLf &_
					"(select pais_tnacionalidad from paises aa where aa.pais_ccod=a.pais_ccod)as nacionalidad,"& vbCrLf &_
					"dire_tcalle+' #'+dire_tnro as direccion,"& vbCrLf &_
					"dire_tpoblacion,"& vbCrLf &_
					"dire_tblock,"& vbCrLf &_
					"dire_tdepto,"& vbCrLf &_
					"dire_tfono,"& vbCrLf &_
					"dire_tcelular,"& vbCrLf &_
					"ciud_tdesc,"& vbCrLf &_
					"ciud_tcomuna,"& vbCrLf &_
					"(select regi_tdesc from regiones cc where cc.regi_ccod=c.regi_ccod)as regi_tdesc"& vbCrLf &_
					"from personas a, direcciones b,ciudades c "& vbCrLf &_
					"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
					"and b.ciud_ccod=c.ciud_ccod"& vbCrLf &_
					"and pers_nrut="&q_pers_nrut&""& vbCrLf &_
					"and tdir_ccod=1"
 f_datos_antecedentes.Consultar selec_antecedentes
 f_datos_antecedentes.Siguiente
 'response.Write(selec_antecedentes)
'------------------------------------------------------------------------------------------ 
 set f_muestra_seminario = new CFormulario
 f_muestra_seminario.Carga_Parametros "curriculum_alumno.xml", "seminario_curso_muestra"
 f_muestra_seminario.Inicializar conexion

					
				 selec_seminario=	"select * from curso_seminario_curriculum where pers_ncorr="&pers_ncorr&" "
 f_muestra_seminario.Consultar selec_seminario
 
'response.Write(selec_seminario)
 '------------------------------------------------------------------------------------------ 
 
 set f_idioma = new CFormulario
 f_idioma.Carga_Parametros "curriculum_alumno.xml", "idioma"
 f_idioma.Inicializar conexion
				 
	f_idioma.Consultar "select '' "
 


'------------------------------------------------------------------------------------------ 
 set f_muestra_idioma = new CFormulario
 f_muestra_idioma.Carga_Parametros "curriculum_alumno.xml", "idioma_muestra"
 f_muestra_idioma.Inicializar conexion

				horaiomuestra=	"select idal_ncorr,a.idio_ccod,idal_habla,idal_lee,idal_escribe,a.nidi_ccod,nidi_tdesc,case when a.idio_ccod=8 then idal_otro else idio_tdesc end as idio_tdesc from idioma_alumno a,niveles_idioma b,idioma c where pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&") and a.nidi_ccod=b.nidi_ccod and a.idio_ccod=c.idio_ccod"

 f_muestra_idioma.Consultar horaiomuestra

 
 
 '------------------------------------------------------------------------------------------
  set f_muestra_trabajo = new CFormulario
 f_muestra_trabajo.Carga_Parametros "curriculum_alumno.xml", "trabajo_muestra"
 f_muestra_trabajo.Inicializar conexion

					
				 trabajomuestra=	"select top 1 a.dlpr_ncorr,exal_ncorr ,dlpr_nombre_empresa,dlpr_rubro_empresa,dlpr_cargo_empresa,dlpr_web_empresa from direccion_laboral_profesionales a,experiencia_alumno b where a.dlpr_ncorr=b.dlpr_ncorr and tiea_ccod=1 and a.pers_ncorr="&pers_ncorr&" order  by exal_fini desc"

 f_muestra_trabajo.Consultar trabajomuestra

 '------------------------------------------------------------------------------------------
  set f_muestra_trabajo_antiguo = new CFormulario
 f_muestra_trabajo_antiguo.Carga_Parametros "curriculum_alumno.xml", "trabajo_antiguo_muestra"
 f_muestra_trabajo_antiguo.Inicializar conexion

					
				 TrabajoAntiguoMuestra=	"select a.dlpr_ncorr,exal_ncorr ,dlpr_nombre_empresa,dlpr_rubro_empresa,dlpr_cargo_empresa,dlpr_web_empresa from direccion_laboral_profesionales a,experiencia_alumno b "& vbCrLf &_
"where a.dlpr_ncorr=b.dlpr_ncorr and tiea_ccod=1 and a.pers_ncorr="&pers_ncorr&" "& vbCrLf &_
"and a.dlpr_ncorr <>(select top 1 a.dlpr_ncorr  from direccion_laboral_profesionales a,experiencia_alumno b where a.dlpr_ncorr=b.dlpr_ncorr and tiea_ccod=1 and a.pers_ncorr="&pers_ncorr&" order  by exal_fini desc)"& vbCrLf &_
"order  by exal_fini desc "

 f_muestra_trabajo_antiguo.Consultar TrabajoAntiguoMuestra
 'response.write(TrabajoAntiguoMuestra)
 
  '------------------------------------------------------------------------------------------
  set f_muestra_pasantia = new CFormulario
 f_muestra_pasantia.Carga_Parametros "curriculum_alumno.xml", "pasantia_muestra"
 f_muestra_pasantia.Inicializar conexion

					
				MuestraPasantia=	"select a.dlpr_ncorr,pers_ncorr ,dlpr_nombre_empresa,dlpr_rubro_empresa,dlpr_cargo_empresa,dlpr_web_empresa from direccion_laboral_profesionales a,experiencia_alumno b where a.dlpr_ncorr=b.dlpr_ncorr and tiea_ccod=3 and a.pers_ncorr="&pers_ncorr&" order by exal_fini desc "

 f_muestra_pasantia.Consultar MuestraPasantia

 
   '------------------------------------------------------------------------------------------
  set f_muestra_practica = new CFormulario
 f_muestra_practica.Carga_Parametros "curriculum_alumno.xml", "practica_muestra"
 f_muestra_practica.Inicializar conexion

					
				MuestraPractica=	"select a.dlpr_ncorr, pers_ncorr,dlpr_nombre_empresa,dlpr_rubro_empresa,dlpr_cargo_empresa,dlpr_web_empresa from direccion_laboral_profesionales a,experiencia_alumno b where a.dlpr_ncorr=b.dlpr_ncorr and tiea_ccod=2 and a.pers_ncorr="&pers_ncorr&" order by exal_fini desc" 

 f_muestra_practica.Consultar MuestraPractica
 
 
 
 
  set f_habilidades = new CFormulario
 f_habilidades.Carga_Parametros "curriculum_alumno.xml", "habilidades"
 f_habilidades.Inicializar conexion

					tiene=conexion.consultaUno("select count(*) from curriculum_habilidades_alumno where pers_ncorr="&pers_ncorr&"")
				if tiene=0 then
				MuestraHabilidades="select ''"
				
				else
				
				MuestraHabilidades=	"select chal_ncorr,chal_tarea_trabajo,chal_thabilidades_tecnica,chal_thabilidades_personales,chal_thabilidades_profesionales from curriculum_habilidades_alumno where pers_ncorr="&pers_ncorr&"" 
end if
 f_habilidades.Consultar MuestraHabilidades
	f_habilidades.Siguiente



  set f_muestra_habilidades_programa = new CFormulario
 f_muestra_habilidades_programa.Carga_Parametros "curriculum_alumno.xml", "habilidades_programas_muestra"
 f_muestra_habilidades_programa.Inicializar conexion

					
				MuestraHabilidadesPrograma=	"select pers_ncorr,cdpa_ncorr,cdpa_tprograma,nidi_ccod from curriculum_dominio_programa_alumno where pers_ncorr="&pers_ncorr&"" 

 f_muestra_habilidades_programa.Consultar MuestraHabilidadesPrograma
 '---------------------------------------------------------------------------------------------
 
'response.write(selec_antecedentes)
	
	if q_npag = "" or isnull(q_npag) then
	q_npag = 1
	end if

'-------------------------------------------------------------------------
 dir_a = "curriculum.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=1"
 dir_b = "curriculum.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=2" 
 if traspaso = "" then
	 if q_npag = 1 then
		'f_botonera.AgregaBotonParam "pagina2", "texto", "Ir a página 2"
		dir_JS = "curriculum.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=2"
	 end if
	 if q_npag = 2 then
		dir_JS = "curriculum.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=1"
		'f_botonera.AgregaBotonParam "pagina2", "texto", "Ir a página 1"
	 end if
 else
	 if q_npag = 1 then
		'f_botonera.AgregaBotonParam "pagina2", "texto", "Ir a página 2"
		dir_JS = "curriculum.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=2&traspaso=1"
	  end if
	 if q_npag = 2 then
		dir_JS = "curriculum.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&npag=1&traspaso=2"
		'f_botonera.AgregaBotonParam "pagina2", "texto", "Ir a página 1"
	 end if
 end if

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bienvenido a Universidad del Pac&iacute;fico Online</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function mensaje(){
	<%if es_alumno = 0 then%>
	alert('La persona ingresada no se ha matriculado en el período académico actual.')
	<%end if%>
}

function irPagina2(){
	window.location = '<%=dir_JS%>';
}

function salir_aplicacion(){
    var tipo_traspaso = '<%=tipo_traspaso%>';
	if (tipo_traspaso=='0')
	 {window.location = '../lanzadera/lanzadera.asp';}
	else
	 {window.close();} 
}
function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa Ficha de antecedentes personales, le entrega información al alumnado de cuales son los datos que tenemos registrados en el sistema;\n" +
	       	  "Datos que deben ser corroborados por cada alumno y en caso de presentar alguna anomalía o que requiera ser cambiado, rogamos comunicarse con departamento de registro curricular\n"+
		      "Los botones de esta función permiten navegar entre las dos páginas, para ver datos personales, domicilios, datos académicos y familiares.\n"+
		      "En una futura versión se pretende desarrollar la opción para que el alumno modifique sus datos directamente desde cualquier PC conectado a Internet.";
		   
		   
	alert(mensaje);
}
function maximaLongitud(texto,maxlong) {
var tecla, in_value, out_value;

if (texto.value.length > maxlong) {
in_value = texto.value.toUpperCase();
out_value = in_value.substring(0,maxlong);
texto.value = out_value;

return false;
}
return true;
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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<%if q_npag=1 then%>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>FICHA DE ANTECEDENTES PERSONALES</strong></font></td>
	</tr>
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="252"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Datos Personales  del Alumno</strong></font></td>
										   <td width="344"><hr></td>
										   <td width="68" height="38">
										        <%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?">												</a>										   </td>
										</tr>
									</table>								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td width="28%"  height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombres :</strong></font></td>
										<td width="27%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fecha Nacimiento :</strong></font></td>
										<td width="24%">&nbsp;</td>
										<td width="21%">&nbsp;</td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("nombre")%></font></td>
													</tr>
											  </table>											</td>
											<td>
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("fnacimiento")%></font></td>
													</tr>
												 </table>											</td>
											<td>
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
												 </table>											</td>
											<td>
												 <table width="96%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
											  </table>											</td>
									  </tr>
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Direcci&oacute;n :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Comuna : </strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Ciudad :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Regi&oacute;n :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
										<td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("direccion")%></font></td>
											</tr>
										  </table>									    </td>
										 <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("ciud_tdesc")%></font></td>
											</tr>
										  </table>									    </td>
										  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("ciud_tcomuna")%></font></td>
											</tr>
										  </table>										  </td>
										  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("regi_tdesc")%></font></td>
											</tr>
										  </table>										  </td>
									  </tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Celular : </strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Telefono :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Nacionalidad :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
										<td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("dire_tcelular")%></font></td>
											</tr>
										  </table>										</td>
										<td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("dire_tfono")%></font></td>
											</tr>
										  </table>										</td>
										<td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("nacionalidad")%></font></td>
											</tr>
										  </table>										</td>
										<td> <table width="40%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr>											</tr>
										  </table>										</td>
									  </tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Estado Civil :</strong></font></td>
										<td colspan="1"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Sexo  :</strong></font></td>
										<td>&nbsp;</td>
									  </tr>
									  <tr valign="top"> 
										<td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("estado_civil")%></font></td>
											</tr>
										  </table></td>
										<td colspan="1"><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("sexo")%></font></td>
											</tr>
										  </table></td>
										<td><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                          <tr>                                          </tr>
                                        </table></td>
									  </tr>
									   <tr> 
										<td height="20" colespan "2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Email 1 : </strong></font></td
										
										><td></td>
									  </tr>
									  <tr valign="top"> 
										<td colspan="2"  > <table width="100%"  border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr > 
											  <td height="20"  bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("pers_temail")%></font></td>
											</tr>
										  </table></td>
										<td colspan="1"><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr>											</tr>
										  </table></td>
										<td><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                          <tr>                                          </tr>
                                        </table></td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Email 2 : </strong></font></td>
										
										<td></td>
									  </tr>
									  <tr valign="top"> 
										<td colspan="2"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("pers_temail2")%></font></td>
											</tr>
										  </table></td>
										<td colspan="1"><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr>											</tr>
										  </table></td>
										<td><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                          <tr>                                          </tr>
                                        </table></td>
									  </tr>            
                                       <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_22.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_21.png';return true ">
												<img src="imagenes/IR_A_PAGINA_21.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 2">												</a>										</td>
										<td height="10" align="left">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
												<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME">												</a>										</td>
									  </tr>
								  </table>								</td>
							</tr>
						</table>					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>		</td>
	</tr>
	<!--Antecedentes educacionales-->
	<!--Identificación del sostenedor académico-->
</table>
<%end if%>
<%if q_npag=2 then%>

<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>FICHA PROFESIONAL </strong></font></td>
	</tr>
	<form name="formacion_extra_academica">
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										    <td width="37%" height="23"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Cursos/Diplomados </strong></font></td>
										    <td width="52%"><hr></td>
										   <TD width="11%">
										   		<%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?">												</a>										  </TD>
										</tr>
									</table>								</td>
							</tr>
							<tr>
							  <td width="100%" align="center">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										
										
										<td width="26%">&nbsp;</td>
										<td width="34%">&nbsp;</td>
										<td width="14%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td colspan="6"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													 <td ><%f_muestra_seminario.DibujaTabla()%></td>
													</tr>
											  </table>											</td>
											
									  </tr>
                                      <tr> 
									  <tr valign="top"> 
										<td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr>											</tr>
										  </table>									    </td>
										 <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr>											</tr>
										  </table>									    </td>
										  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr> 
											  <td height="20" >&nbsp;</td>
											</tr>
										  </table>										  </td>
										  <td width="14%"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr> 
											  <td height="20" >&nbsp;</td>
											</tr>
									    </table>									    </td>
									  </tr>
									   <tr>
    <td height="10">&nbsp;</td>
    <td height="10" colspan="2"><hr></td>
    <td height="10">&nbsp;</td>
  </tr>
									  <td></td>
								        <td height="10" align="right">
										<%POS_IMAGEN = POS_IMAGEN + 1%>
										<a href="javascript:_Navegar(this, 'curso_diplomado.asp?pers_nrut=<%=q_pers_nrut%>', 'FALSE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR1.png';return true ">       <img src="imagenes/AGREGAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"></a></td>
																<td height="10" align="right">
										<%POS_IMAGEN = POS_IMAGEN + 1%>
										<a href="javascript:_Eliminar(this, document.forms['formacion_extra_academica'], 'proc_elimima_curso_diplomado.asp', '', 'TRUE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR1.png';return true ">       <img src="imagenes/ELIMINAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"></a></td>
										<td height="10" align="right"><%POS_IMAGEN = POS_IMAGEN + 1%>
      <a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true "><img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 1"></a></td>
    <td width="12%" height="10" align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
      <a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a> </td>
                                       <tr>
								  </table>								</td>
							</tr>
						</table>					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>		</td>
	</tr>
	</form>
	<tr>
		<td width="100%" height="20"><font size="-1">&nbsp;</font></td>
	</tr>
	<!--Antecedentes educacionales-->
	<form name="experiencia_profesional">
	<tr>
		<td width="100%" height="351" align="left">
		
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="40%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Experiencia Laboral</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>								</td>
							</tr>
							<tr>
							  <td width="100%" align="center"><table width="100%" border="0" cellpadding="1" cellspacing="3">
                                <tr>
                                  <td colspan="2" height="20">&nbsp;</td>
                                  <td width="12%"></td>
                                  <td width="13%"></td>
                                </tr>
                                <tr>
                                  <td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Trabajo Actual</strong></font></td>
                                  <td colspan="2"></td>
                                </tr>
                                <tr valign="top">
                                  <td height="20" colspan="6"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%f_muestra_trabajo.DibujaTabla()%></td>
                                      </tr>
                                  </table></td>
                                  
                                  <td width="1%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr> </tr>
                                    </table>                                </tr>
                                
                                <tr>
                                  <td width="33%" height="10">&nbsp;</td>
                                  <td width="28%" height="10">&nbsp;</td>
                                  <td height="10">&nbsp;</td>
                                </tr>
                                
  <tr>
    <td height="10">&nbsp;</td>
    <td height="10" colspan="2"><hr></td>
    <td height="10">&nbsp;</td>
  </tr>
 
 
  <tr valign="top">
  <tr valign="top">
  <tr>
  <tr>
    <td height="10">&nbsp;</td>
     <td height="10" align="right">
										<%POS_IMAGEN = POS_IMAGEN + 1%>
										<a href="javascript:_Navegar(this, 'laboral_practica_pasantia.asp?tiea_ccod=1&pers_nrut=<%=q_pers_nrut%>', 'FALSE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR1.png';return true ">       <img src="imagenes/AGREGAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"></a></td>
																<td height="10" align="right">
										<%POS_IMAGEN = POS_IMAGEN + 1%>
										<a href="javascript:_Eliminar(this, document.forms['experiencia_profesional'], 'proc_elimima_laboral_actual.asp', '', 'TRUE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR1.png';return true ">       <img src="imagenes/ELIMINAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"></a></td>
																
																
    <td height="10" align="right"><%POS_IMAGEN = POS_IMAGEN + 1%>
      <a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true "><img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 1"></a></td>
    <td width="12%" height="10" align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
      <a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a> </td>
  </tr>
                              </table></td>
							</tr>
						</table>					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
		</table>		</td>
	</tr>
	</form>
	<form name="trabajo_anterior">
	<tr>
		<td width="100%" height="400" align="left">
		
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="40%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Experiencia Laboral</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>								</td>
							</tr>
							<tr>
							  <td width="100%" align="center"><table width="100%" border="0" cellpadding="1" cellspacing="3">
                                <tr>
                                  <td colspan="2" height="20">&nbsp;</td>
                                  <td width="13%"></td>
                                  <td width="13%"></td>
                                </tr>
                               
                                <tr>
                                  <td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Trabajos Anteriores : </strong></font></td>
                                  <td colspan="2"></td>
                                </tr>
                                <tr valign="top">
                                  <td height="20" colspan="6"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr>
                                        <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%f_muestra_trabajo_antiguo.DibujaTabla()%></td>
                                      </tr>
                                  </table></td>
                                 
                                  <td width="1%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                      <tr> </tr>
                                  </table>                                </tr>
                                <tr>
                                  <td width="33%" height="10">&nbsp;</td>
                                  <td width="27%" height="10">&nbsp;</td>
                                  <td height="10">&nbsp;</td>
                                </tr>
                                
  <tr>
    <td height="10">&nbsp;</td>
    <td height="10" colspan="2"><hr></td>
    <td height="10">&nbsp;</td>
  </tr>
 
 
  <tr valign="top">
  <tr valign="top">
  <tr>
  <tr>
    <td height="10">&nbsp;</td>
     <td height="10" align="right">
										<%POS_IMAGEN = POS_IMAGEN + 1%>
										<a href="javascript:_Navegar(this, 'laboral_practica_pasantia.asp?tiea_ccod=1&pers_nrut=<%=q_pers_nrut%>', 'FALSE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR1.png';return true "><img src="imagenes/AGREGAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"></a></td>
																<td height="10" align="right">
										<%POS_IMAGEN = POS_IMAGEN + 1%>
										<a href="javascript:_Eliminar(this, document.forms['trabajo_anterior'], 'proc_elimima_laboral_antigua.asp', '', 'TRUE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR1.png';return true ">       <img src="imagenes/ELIMINAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"></a></td>
																
																
    <td height="10" align="right"><%POS_IMAGEN = POS_IMAGEN + 1%>
      <a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true "><img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 1"></a></td>
    <td width="12%" height="10" align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
      <a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a> </td>
  </tr>
                              </table></td>
							</tr>
						</table>					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>		</td>
	</tr>
	</form>
	
	
	
	<form name="practica">
	<tr>
		<td width="100%" height="331" align="left"><table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
          <tr>
            <td><font size="-1">&nbsp;</font></td>
          </tr>
          <tr valign="middle">
            <td width="100%" align="center"><table width="98%" border="0" bgcolor="#f7faff">
                <tr>
                  <td width="100%" align="center"><table width="100%">
                      <tr>
                        <td width="40%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Pr&aacute;ctica Profesional </strong></font></td>
                        <td><hr></td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td width="100%" align="center"><table width="100%" border="0" cellpadding="1" cellspacing="3">
                    <tr>
                      <td colspan="2" height="20">&nbsp;</td>
                      <td width="12%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
                      <td width="14%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
                    </tr>
                    
                          <td colspan="4"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Pr&aacute;cticas </strong></font></td>
                      
                    </tr>
                    <tr valign="top">
                      <td height="20" colspan="6"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                          <tr>
                            <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%f_muestra_practica.DibujaTabla()%></td>
                          </tr>
                      </table>                      </tr>
                    <tr>
                      <td width="22%" height="10">&nbsp;</td>
                      <td width="36%" height="10">&nbsp;</td>
                      <td height="10">&nbsp;</td>
                    </tr>
                    <tr>
                      <td height="10">&nbsp;</td>
                      <td height="10" colspan="2"><hr></td>
                      <td height="10">&nbsp;</td>
                    </tr>
                    <tr valign="top">
                    <tr valign="top">
                    <tr>
                    <tr>
                      <td height="10">&nbsp;</td>
                      <td height="10" align="right"><%POS_IMAGEN = POS_IMAGEN + 1%>
                        <a href="javascript:_Navegar(this, 'laboral_practica_pasantia.asp?tiea_ccod=2&pers_nrut=<%=q_pers_nrut%>', 'FALSE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR1.png';return true "> <img src="imagenes/AGREGAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"></a></td>
																<td height="10" align="right">
										<%POS_IMAGEN = POS_IMAGEN + 1%>
										<a href="javascript:_Eliminar(this, document.forms['practica'], 'proc_elimima_practica.asp', '', 'TRUE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR1.png';return true ">       <img src="imagenes/ELIMINAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"></a></td>
                      <td height="10" align="right"><%POS_IMAGEN = POS_IMAGEN + 1%>
                        <a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true "><img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 1"></a></td>
                      <td width="16%" height="10" align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
                        <a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a> </td>
                    </tr>
                  </table></td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td><font size="-1">&nbsp;</font></td>
          </tr>
        </table></td>
	</tr>
	</form>
	<form name="pasantia">
	<tr>
		<td width="100%" height="355" align="left"><table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
          <tr>
            <td><font size="-1">&nbsp;</font></td>
          </tr>
          <tr valign="middle">
            <td width="100%" align="center"><table width="98%" border="0" bgcolor="#f7faff">
                <tr>
                  <td width="100%" align="center"><table width="100%">
                      <tr>
                        <td width="67%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Actividades Tempranas de Formación en la Profesión</strong></font></td>
                        <td width="33%"><hr></td>
                      </tr>
                  </table></td>
                </tr>
                <tr>
                  <td width="100%" align="center"><table width="100%" border="0" cellpadding="1" cellspacing="3">
                    <tr>
                      <td colspan="2" height="20">&nbsp;</td>
                      <td width="12%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
                      <td width="12%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
                    </tr>
                    
                        <td colspan="4"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Pasant&iacute;as </strong></font></td>
                      
                    </tr>
                    <tr valign="top">
                      <td height="20" colspan="6"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                          <tr>
                            <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><%f_muestra_pasantia.DibujaTabla()%></td>
                          </tr>
                      </table>                      </tr>
                    <tr>
                      <td width="22%" height="10">&nbsp;</td>
                      <td width="37%" height="10">&nbsp;</td>
                      <td height="10">&nbsp;</td>
                    </tr>
                    <tr>
                      <td height="10">&nbsp;</td>
                      <td height="10" colspan="2"><hr></td>
                      <td height="10">&nbsp;</td>
                    </tr>
                    <tr valign="top">
                    <tr valign="top">
                    <tr>
                    <tr>
                      <td height="10">&nbsp;</td>
                      <td height="10" align="right"><%POS_IMAGEN = POS_IMAGEN + 1%>
                        <a href="javascript:_Navegar(this, 'laboral_practica_pasantia.asp?tiea_ccod=3&pers_nrut=<%=q_pers_nrut%>', 'FALSE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR1.png';return true "> <img src="imagenes/AGREGAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"></a></td>
																<td height="10" align="right">
										<%POS_IMAGEN = POS_IMAGEN + 1%>
										<a href="javascript:_Eliminar(this, document.forms['pasantia'], 'proc_elimima_pasantia.asp', '', 'TRUE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR1.png';return true ">       <img src="imagenes/ELIMINAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"></a></td>
                      <td height="10" align="right"><%POS_IMAGEN = POS_IMAGEN + 1%>
                        <a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "

												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true "> <img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 1"> </a> </td>
                      <td width="17%" height="10" align="left"><%POS_IMAGEN = POS_IMAGEN + 1%>
                        <a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true "> <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> </a> </td>
                    </tr>
                  </table></td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td><font size="-1">&nbsp;</font></td>
          </tr>
        </table></td>
	</tr>
	</form>
	<form name="idioma">	
	<tr>
		<td width="100%" height="350" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="40%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Idiomas</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td width="25%" height="20">&nbsp;</td>
										<td width="36%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td width="13%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td width="12%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
									  </tr>
									  <tr> 
										
										<td colspan="6" ><%f_muestra_idioma.DibujaTabla()%></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="55%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
											  </table>											</td>
											<td colspan="2">
												 <table width="45%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
											  </table>											</td>
											<td>
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
												 </table>											</td>
									  </tr>
                                    
									   
									    <tr> 
										<td height="10">&nbsp;</td>
										<td height="10" colspan="2"><hr></td>
										<td height="10">&nbsp;</td>
									  </tr>
						
                                      <tr> 
										<td height="10">&nbsp;</td>
											<td height="10" align="right">
															<%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:_Navegar(this, 'idioma.asp?pers_nrut=<%=q_pers_nrut%>', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR1.png';return true ">
																<img src="imagenes/AGREGAR1.png" border="0" width="70" height="70" alt="Agregar un Idioma">															</a>										</td>
										<td height="10" align="right">
										<%POS_IMAGEN = POS_IMAGEN + 1%>
										<a href="javascript:_Eliminar(this, document.forms['idioma'], 'proc_elimima_idioma.asp', '', 'TRUE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR1.png';return true ">       <img src="imagenes/ELIMINAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"></a></td>
									
										<td height="10" align="right">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true ">
												<img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 1">												</a>										</td>
										<td width="14%" height="10" align="left">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
									  <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME">												</a>									  </tr>
								  </table>								</td>
							</tr>
						</table>					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
	  </table>		</td>
	</tr>
	</form>
	<form name="programas">
	
	<tr>
		<td width="100%" height="386" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="40%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Dominio de Programas </strong></font></td>
										   <td><hr></td>
										</tr>
									</table>								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td width="25%" height="20">&nbsp;</td>
										<td width="38%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td width="13%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
										<td width="13%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>&nbsp;</strong></font></td>
									  </tr>
									  <tr> 
										
										<td colspan="6" ><%f_muestra_habilidades_programa.DibujaTabla()%></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="55%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
											  </table>											</td>
											<td colspan="2">
												 <table width="45%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
											  </table>											</td>
											<td>
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
												 </table>											</td>
									  </tr>
                                     
									  
									   
									    <tr> 
										<td height="10">&nbsp;</td>
										<td height="10" colspan="2"><hr></td>
										<td height="10">&nbsp;</td>
									  </tr>
						
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
															<%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:_Navegar(this, 'habilidades_programa.asp?pers_nrut=<%=q_pers_nrut%>', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/AGREGAR1.png';return true ">
																<img src="imagenes/AGREGAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave">															</a>										</td>
																<td height="10" align="right">
										<%POS_IMAGEN = POS_IMAGEN + 1%>
										<a href="javascript:_Eliminar(this, document.forms['programas'], 'proc_elimima_habilidades_programa.asp', '', 'TRUE');"
																onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR2.png';return true "
																onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ELIMINAR1.png';return true ">       <img src="imagenes/ELIMINAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave"></a></td>
										<td height="10" align="right">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true ">
												<img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 1">												</a>										</td>
										<td width="11%" height="10" align="left">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
									  <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME">												</a>									  </tr>
								  </table>								</td>
							</tr>
						</table>					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
	  </table>		</td>
	</tr>
	</form>
	<form name="habilidades">
	
	<input type="hidden" name="habi[0][pers_nrut]" value="<%=q_pers_nrut%>">
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="40%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Habilidades </strong></font></td>
										   <td><hr></td>
										</tr>
									</table>								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
									<td colspan="4"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Habilidades Profesionales</strong></font></td>
										
										
										
									  </tr>
									  <tr> 
										
										<td colspan="4" ><%f_habilidades.dibujaCampo("chal_thabilidades_profesionales")%></td>
										
									  </tr>
									  
									   <tr> 
										<td colspan="4"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Habilidades Tecnicas</strong></font></td>
										
										
										
									  </tr>
									  <tr> 
										
										<td colspan="4" ><%f_habilidades.dibujaCampo("chal_thabilidades_tecnica")%></td>
										
									  </tr>
									  <tr> 
										<td colspan="4"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Habilidades Personales</strong></font></td>
										
										
										
									  </tr>
									  <tr> 
										
										<td colspan="4" ><%f_habilidades.dibujaCampo("chal_thabilidades_personales")%></td>
										
									  </tr><tr> 
										<td colspan="4"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Areas en las que deseas trabajar</strong></font></td>
										
										
										
									  </tr>
									  <tr> 
										
										<td colspan="4" ><%f_habilidades.dibujaCampo("chal_tarea_trabajo")%></td>
										
									  </tr>
									  <tr valign="top"> 
											<td width="27%" height="20"> 
												 <table width="55%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
									    </table>											</td>
											<td colspan="2">
												 <table width="45%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
											  </table>											</td>
											<td width="12%">
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
									    </table>											</td>
									  </tr>
                                     
									    <tr> 
										<td height="10">&nbsp;</td>
										<td height="10" colspan="2"><hr></td>
										<td height="10">&nbsp;</td>
									  </tr>
						
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td width="48%" height="10" align="right">
															<%POS_IMAGEN = POS_IMAGEN + 1%>
												<a href="javascript:_Guardar(this, document.forms['habilidades'], 'proc_habilidades.asp','', '', '', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR1.png';return true ">
										<img src="imagenes/GUARDAR1.png" border="0" width="70" height="70" alt="Guardar nueva Clave">															</a>										</td>
										<td width="13%" height="10" align="right">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_12.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_11.png';return true ">
										<img src="imagenes/IR_A_PAGINA_11.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 1">												</a>										</td>
										<td height="10" align="left">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
									  <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME">												</a>									  </tr>
								  </table>								</td>
							</tr>
						</table>					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>		</td>
	</tr>
	</form>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<!--Datos entregados para admisión-->
	<tr>
		<td width="100%" align="left">		</td>
	</tr>
</table>
<%end if%>

<%if q_npag=3 then%>
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>FICHA DE ANTECEDENTES PERSONALES</strong></font></td>
	</tr>
	<tr>
		<td width="100%" align="left">
			<table width="700" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="252"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Identificación del Alumno</strong></font></td>
										   <td width="344"><hr></td>
										   <td width="68" height="38">
										        <%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?">												</a>										   </td>
										</tr>
									</table>								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td width="24%"  height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombres :</strong></font></td>
										<td width="25%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Fecha Nacimiento :</strong></font></td>
										<td width="27%">&nbsp;</td>
										<td width="13%">&nbsp;</td>
									  </tr>
									  <tr valign="top"> 
											<td height="20"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("nombre")%></font></td>
													</tr>
											  </table>											</td>
											<td>
												 <table width="80%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr> 
													  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("fnacimiento")%></font></td>
													</tr>
												 </table>											</td>
											<td>
												 <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
												 </table>											</td>
											<td>
												 <table width="96%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
													<tr>													</tr>
											  </table>											</td>
									  </tr>
                                      <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Direcci&oacute;n :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Comuna : </strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Ciudad :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Regi&oacute;n :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
										<td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("direccion")%></font></td>
											</tr>
										  </table>									    </td>
										 <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("ciud_tdesc")%></font></td>
											</tr>
										  </table>									    </td>
										  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("ciud_tcomuna")%></font></td>
											</tr>
										  </table>										  </td>
										  <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("regi_tdesc")%></font></td>
											</tr>
										  </table>										  </td>
									  </tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Celular : </strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Telefono :</strong></font></td>
										<td><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Nacionalidad :</strong></font></td>
									  </tr>
									  <tr valign="top"> 
										<td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("dire_tcelular")%></font></td>
											</tr>
										  </table>										</td>
										<td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("dire_tfono")%></font></td>
											</tr>
										  </table>										</td>
										<td> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("")%></font></td>
											</tr>
										  </table>										</td>
										<td> <table width="40%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr>											</tr>
										  </table>										</td>
									  </tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Estado Civil :</strong></font></td>
										<td colspan="1"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Sexo  :</strong></font></td>
										<td>&nbsp;</td>
									  </tr>
									  <tr valign="top"> 
										<td height="20"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("estado_civil")%></font></td>
											</tr>
										  </table></td>
										<td colspan="1"><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("sexo")%></font></td>
											</tr>
										  </table></td>
										<td><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                          <tr>                                          </tr>
                                        </table></td>
									  </tr>
									   <tr> 
										<td height="20" colespan "2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Email 1 : </strong></font></td
										
										><td></td>
									  </tr>
									  <tr valign="top"> 
										<td colspan="2"  > <table width="100%"  border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr > 
											  <td height="20"  bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("pers_temail")%></font></td>
											</tr>
										  </table></td>
										<td colspan="1"><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr>											</tr>
										  </table></td>
										<td><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                          <tr>                                          </tr>
                                        </table></td>
									  </tr>
									  <tr> 
										<td height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><strong>Email 2 : </strong></font></td>
										
										<td></td>
									  </tr>
									  <tr valign="top"> 
										<td colspan="2"> <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr> 
											  <td height="20" bordercolor="#CCCCCC" bgcolor="#F0F0F0"><font size="2" face="Courier New, Courier, mono" color="#496da6"><%=f_datos_antecedentes.dibujaCampo("pers_temail2")%></font></td>
											</tr>
										  </table></td>
										<td colspan="1"><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
											<tr>											</tr>
										  </table></td>
										<td><table width="99%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                                          <tr>                                          </tr>
                                        </table></td>
									  </tr>            
                                       <tr> 
										<td height="10">&nbsp;</td>
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
											    <%POS_IMAGEN = POS_IMAGEN + 1%>
										   		<a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_24.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_23.png';return true ">
												<img src="imagenes/IR_A_PAGINA_23.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 2">												</a>										</td>
										<td height="10" align="right"><%POS_IMAGEN = POS_IMAGEN + 1%>										  <a href="javascript:_Navegar(this, 'javascript:irPagina2();', 'FALSE');"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_32.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IR_A_PAGINA_31.png';return true ">
										<img src="imagenes/IR_A_PAGINA_31.png" border="0" width="70" height="70" alt="VER INFORMACIÓN DE LA PÁGINA 2"></a></td>
										<td width="11%" height="10" align="left">
											    <%POS_IMAGEN = POS_IMAGEN + 2%>
										   		<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
										 <img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME">												</a>										</td>
									  </tr>
								  </table>								</td>
							</tr>
						</table>					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>		</td>
	</tr>
	<!--Antecedentes educacionales-->
	<!--Identificación del sostenedor académico-->
</table>
<%end if%>
</center>
</body>
</html>

