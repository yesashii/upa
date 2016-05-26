<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 q_pers_ncorr 	= Request.QueryString("pers_ncorr")
 q_pais_tdesc=Request.QueryString("pais_tdesc")
 q_ciex_tdesc=Request.QueryString("ciex_tdesc")
 q_univ_tdesc=Request.QueryString("univ_tdesc")
 
'-----------------------------
 set conexion = new CConexion
 conexion.Inicializar "upacifico"

 set negocio = new CNegocio
 negocio.Inicializa conexion
'-----------------------------
 set pagina = new CPagina
 pagina.Titulo = "Ficha Alumnos Extranjeros"
 
'-- Botones de la pagina -----------
 set f_botonera = new CFormulario
 f_botonera.Carga_Parametros "alumnos_intercambio_extranjero.xml", "botonera"

'---------------------------------------------------------------------------------------------------
 
set f_antec_extranjeros = new CFormulario
f_antec_extranjeros.Carga_Parametros "alumnos_intercambio_extranjero.xml", "f_datos_antecedentes"
f_antec_extranjeros.Inicializar conexion

sql_info= "select top 1 a.paie_ncorr,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,e.dpie_quiere_curso_espanol,p.pers_tpasaporte,p.pers_tape_paterno,p.pers_tape_materno,p.PERS_TNOMBRE,p.PERS_FNACIMIENTO,d.diai_tfono,p.PERS_TEMAIL,case p.SEXO_CCOD when 2 then 'FEMENINO' when 1 then 'MASCULINO' else '' end  as SEXO,"& vbCrLf &_
				"d.diai_direccion, s.PAIS_TDESC,d.diai_ciudad,d.diai_codigo_postal,c.coem_nombre,c.coem_fono,c.coem_email,c.coem_emal_opc,pa.PARE_TDESC,"& vbCrLf &_
				"case a.tdin_ccod when 1 then 'PERÍODO MARZO -JULIO (Primer Semestre UPA)' when 2 then 'PERÍODO AGOSTO -DICIEMBRE (Segundo Semestre UPA)' when 3 then 'PERIODO MARZO -DICIEMBRE (Un año académico)' when 4 then 'PERIODO AGOSTO - JULIO (Un año académico)' else '' end as periodo ,"& vbCrLf &_
				"e.dpie_carr_proce,case e.tcarr_ccod when 1 then 'Pregrado' when 2 then 'Postgrado' else '' end as tipo_grado,e.dpie_anos_cursados,(select CARR_TDESC from carreras ca where a.carr_ccod = ca.CARR_CCOD)as CARR_TDESC"& vbCrLf &_
				"from personas p, rrii_direccion_alumno_intercambio d,rrii_postulacion_alumnos_intercambio_extranjero a,rrii_contacto_emergencia  c,rrii_datos_postulacion_intercambio_extranjero e, paises s,parentescos pa"& vbCrLf &_
				"where p.PERS_NCORR = d.pers_ncorr"& vbCrLf &_
				"and d.PERS_NCORR = a.pers_ncorr"& vbCrLf &_
				"and a.paie_ncorr = c.paie_ncorr"& vbCrLf &_
				"and c.paie_ncorr = e.paie_ncorr"& vbCrLf &_
				"and d.pais_ccod = s.PAIS_CCOD"& vbCrLf &_
				"and e.dpie_carr_proce is not null"& vbCrLf &_
				"and c.coem_pare_ccod =pa.PARE_CCOD"& vbCrLf &_
				"and p.PERS_NCORR ="&q_pers_ncorr&""

'response.Write("<pre>"&sql_info&"</pre>")
'response.End()
f_antec_extranjeros.Consultar sql_info
f_antec_extranjeros.siguiente

set f_antec_extranjeros2 = new CFormulario
f_antec_extranjeros2.Carga_Parametros "alumnos_intercambio_extranjero.xml", "f_datos_antecedentes"
f_antec_extranjeros2.Inicializar conexion

sql_lenguaje="select m.paie_ncorr,i.idio_tdesc, n.nidi_tdesc ,m.maes_semestres_espanol "& vbCrLf &_
			"from rrii_manejo_espanol_eidiomas m, idioma i,niveles_idioma n, rrii_postulacion_alumnos_intercambio_extranjero po"& vbCrLf &_
			"where po.paie_ncorr = m.paie_ncorr"& vbCrLf &_
			"and m.idio_ccod = i.idio_ccod"& vbCrLf &_
			"and m.nidi_ccod = n.nidi_ccod"& vbCrLf &_
			"and po.pers_ncorr ="&q_pers_ncorr&""

f_antec_extranjeros2.Consultar sql_lenguaje
f_antec_extranjeros2.siguiente
'-- Fin (datos alumno ) -------------------------------------------

%>
<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicial.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<style>
@media print{ .noprint {visibility:hidden;display: none; }}


</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function imprimir() 
   {window.print()}
   
   
</script>
</head>
<body bgcolor="#FFFFFF">
<table width="714" height="" border="1" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="714"   bgcolor="#FFFFFF"> 
	<table width="100%">
	<tr>
	<td width="14%" align="center"><img src="../imagenes/logo_upa_nuevo.jpg"><br clear=all> UNIVERSIDAD DEL PACIFICO</td>
	<td width="76%"> <p align="center"><%pagina.DibujarTituloPagina%> </p>
	  <div align="center" class="noprint"><%f_botonera.DibujaBoton ("imprimir")%></div>
	  </td>
	<td width="10%"></td>
	</tr>
	</table>
     <br> 
      <table  width="676" height="596" border="0" cellpadding="1" cellspacing="3" bordercolor="#CCCCCC" bgcolor="#FFFFFF" >
				  <tr>
				  	<td>
						<h1>Información Alumno</h1>
					  <table  width="100%" >	
							<tr>
								<td colspan="4" align="left">&nbsp;</td>
							</tr>	
							<tr>
							  <td><font color="#000066">Rut :</font></td>
							  <td><%=f_antec_extranjeros.DibujaCampo("rut")%></td>
							  <td>&nbsp;</td>
							  <td colspan="2">&nbsp;</td>
					    </tr>
							<tr>
							  <td width="22%"><font color="#000066">Pasaporte:</font></td>
							  <td width="22%"><%=f_antec_extranjeros.DibujaCampo("pers_tpasaporte")%></td>
								<td width="22%"><font color="#000066">Email:</font></td>
							    <td colspan="2"><%=f_antec_extranjeros.dibujaCampo("pers_temail")%></td>
							</tr>
							<tr>
							  <td><font color="#000066">Apellido Paterno:</font></td>
							  <td><%=f_antec_extranjeros.DibujaCampo("pers_tape_paterno")%></td>
								<td><font color="#000066">Telefono:</font></td>
								<td width="30%"><%=f_antec_extranjeros.dibujaCampo("diai_tfono")%></td>
							</tr>
							<tr>
							  <td><font color="#000066">Apellido Materno:</font></td>
							  <td><%=f_antec_extranjeros.DibujaCampo("pers_tape_materno")%></td>
								<td><font color="#000066">Fecha de Nacimiento:</font></td>
								<td ><%=f_antec_extranjeros.dibujaCampo("pers_fnacimiento")%></font></td>
							</tr>
							<tr>
							  <td><font color="#000066">Nombre:</font></td>
							  <td><%=f_antec_extranjeros.DibujaCampo("pers_tnombre")%></td>
								<td><font color="#000066">Sexo:</font></td>
								<td><%=f_antec_extranjeros.dibujaCampo("sexo")%></td>
							</tr>	
							<tr>
							  <td><font color="#000066">Pais: </font></td>
							  <td><%=f_antec_extranjeros.dibujaCampo("pais_tdesc")%></td>
								<td><font color="#000066">Direcci&oacute;n:</font></td>
								<td><%=f_antec_extranjeros.dibujaCampo("diai_direccion")%></font></td>
							</tr>
							<tr>
							  <td><font color="#000066">Ciudad:</font></td>
							  <td><%=f_antec_extranjeros.dibujaCampo("diai_ciudad")%></td>
								<td><font color="#000066">Codigo Postal:</font></td>
								<td><%=f_antec_extranjeros.dibujaCampo("diai_codigo_postal")%></td>
							</tr>
							<tr>
							  <td>&nbsp;</td>
							  <td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
						</table>
						<br/><hr/>
						<table width="100%">
							<tr>
								<td colspan="2"><font><strong>Contacto en caso de Emergencia</strong></font></td>
							</tr>
							<tr>
								<td colspan="2" >&nbsp;</td>
							</tr>
							<tr>
							  <td><font color="#000066">Nombre de Contacto:</font></td>
							  <td><%=f_antec_extranjeros.dibujaCampo("coem_nombre")%></td>
						  </tr>
							<tr>
							  <td><font color="#000066">Parentesco:</font></td>
							  <td><%=f_antec_extranjeros.dibujaCampo("pare_tdesc")%></td>
						  </tr>
							<tr>
							  <td width="23%"><font color="#000066">Telefono Contacto:</font></td>
								<td width="77%"><%=f_antec_extranjeros.dibujaCampo("coem_fono")%></font></td>
							</tr>
							<tr>
							  <td><font color="#000066">Email Contacto:</font></td>
							  <td><%=f_antec_extranjeros.dibujaCampo("coem_email")%></td>
						  </tr>
							<tr>
							  <td><font color="#000066">Email Contacto otro:</font></td>
								<td><%=f_antec_extranjeros.dibujaCampo("coem_emal_opc")%></td>
							</tr>
							<tr>
							  <td height="20" valign="top">&nbsp;</td>
								<td valign="top">&nbsp;</td>
						    </tr>
						</table>
                        <hr>
						<table  border="0" width="100%" align="center">
							<tr>
								<td colspan="2"><font><strong>Duración</strong></font></td>
							</tr>
							<tr>
								<td colspan="2"><font color="#000066">Fecha de inicio y término de tu intercambio</font></td>
							</tr>
							<tr>
							<td><%=f_antec_extranjeros.dibujaCampo("periodo")%></td>
							</tr>
					   </table>
					   <br>	
					   <hr>
					   <table width="100%" align="center">
							<tr>
								<td colspan="2"><strong>Antecedentes Académicos</strong></td>
							</tr>
							<tr>
							  <td><font color="#000066">Universidad de procedencia:</font></td>
							  <td><%=q_univ_tdesc%></td>
					     </tr>
							<tr>
								<td width="33%"><font color="#000066">Carrera de procedencia:</font></td>
								<td width="67%"><%=f_antec_extranjeros.dibujaCampo("dpie_carr_proce")%></td>
							</tr>
							
							<tr>
								<td width="33%"><font color="#000066">Tipo Grado:</font></td>
								<td><%=f_antec_extranjeros.dibujaCampo("tipo_grado")%></td>
							</tr>
							<tr>
								<td width="33%"><font color="#000066">Años cursados:</font></td>
								<td width="67%"><%=f_antec_extranjeros.dibujaCampo("dpie_anos_cursados")%></td>
							</tr>							
							<tr>
								<td width="33%"><font color="#000066">Carrera a la que deseas ingresar en la UPA:</font></td>
								<td><%=f_antec_extranjeros.dibujaCampo("CARR_TDESC")%></td>
							</tr>
					   </table>	
					   <br>
						<hr>
					   <table  width="100%" align="center">
							<tr>
								<td colspan="2"><strong>Conocimientos de Español (Para alumnos de habla no-hispana)</strong></td>
							</tr>
							<tr>
								<td width="26%"><font color="#000066">Lengua materna: </font></td>
								<td><%=f_antec_extranjeros2.dibujaCampo("idio_tdesc")%></td>
							</tr>
							<tr>
								<td width="26%"><font color="#000066">Nivel de español: </font></td>
								<td><%=f_antec_extranjeros2.dibujaCampo("nidi_tdesc")%></td>
							</tr>
							<tr>
							  <td><font color="#000066">Semestres de espa&ntilde;ol cursados:</font></td>
							  <td><%=f_antec_extranjeros2.dibujaCampo("maes_semestres_espanol")%></td>
					     </tr>
							<tr>
								<td width="33%"><font color="#000066">R</font><font color="#000066">ealizar un curso de espa&ntilde;ol(UPACIFICO) :</font></td>
								<td width="67%"><%=f_antec_extranjeros.dibujaCampo("dpie_quiere_curso_espanol")%></td>
							</tr>
					   </table>	
						
						<br/><hr/>
						
					</td>
			</tr>
	   </table>
	  <br/>
	  <div  align="center" class="noprint"><%f_botonera.DibujaBoton ("imprimir")%></div>
     </td>
  </tr>
</table>
</body>
</html>
