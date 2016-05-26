<!-- #include file = "../biblioteca/_conexion_alumnos_02.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
matr_ncorr = Request.QueryString("enca[0][carreras_alumno]")

'conexion a servidor de alumnos consultas generales
 set conexion2 = new CConexion2
 conexion2.Inicializar "upacifico"

'conexión a servidor de producción consultas que requieran actualización al minuto
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
 
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conexion2.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if
  
q_peri_ccod = "210"

'if q_pers_nrut <> "" then 
'--------------------------------------actualizaremos listado de notas temporales una vez al día----------------------------------------- 
'Lo primero es ver si ya fue actualizado el listado en el día..........

'consulta_existencia = " select case count(*) when 0 then 'N' else 'S' end as existe " & vbCrLf &_
'					  " from " & vbCrLf &_
'					  " ( " & vbCrLf &_
'					  " select top 1 * " & vbCrLf &_
'					  " from NOTAS_TEMPORALES  " & vbCrLf &_
'					  " where anos_ccod=datepart(year,getDate()) " & vbCrLf &_
'					  " and convert(datetime,protic.trunc(fecha_grabado),103) = convert(datetime,protic.trunc(getDate()),103) " & vbCrLf &_
'					  " )tabla"
'existencia = conexion.consultaUno(consulta_existencia)
''Si no existe una actualización de la tabla para el día consultado, se debe actualizar, priemro eliminando los registros.
'if existencia = "N" then
'    'response.Write("entre 2")
'	c_eliminacion = "delete from NOTAS_TEMPORALES  where anos_ccod = datepart(year,getDate())"
'	conexion.ejecutaS(c_eliminacion)
'	respuesta = conexion.ObtenerEstadoTransaccion 
'	'Si la eliminación fue realizada exitosamente
'	if respuesta then
'	    'response.Write("entre")
'		c_agregar_registros = " insert into  NOTAS_TEMPORALES (PERS_NCORR,MATR_NCORR,SECC_CCOD,CALI_NCORR,CALA_NNOTA,CALI_NEVALUACION,CALI_NPONDERACION,CALI_FEVALUACION,TEVA_TDESC,CARG_NNOTA_FINAL,PERI_TDESC,ANOS_CCOD,ASIG_CCOD,ASIG_TDESC,DUAS_TDESC,CARR_CCOD,CARR_TDESC,JORN_CCOD,ESTADO_CIERRE_CCOD,AUDI_TUSUARIO,AUDI_FMODIFICACION,FECHA_GRABADO) " & vbCrLf &_
'							  " select d.pers_ncorr,b.matr_ncorr,b.secc_ccod,e.cali_ncorr," & vbCrLf &_
'							  " (select ca.cala_nnota from calificaciones_alumnos ca where ca.secc_ccod=b.secc_ccod and ca.matr_ncorr=b.matr_ncorr and ca.cali_ncorr=e.cali_ncorr) as cala_nnota," & vbCrLf &_
'							  " e.cali_nevaluacion, cali_nponderacion,cali_fevaluacion, f.teva_tdesc, " & vbCrLf &_
'							  " b.carg_nnota_final,peri_tdesc, anos_ccod,asi.asig_Ccod,asi.asig_tdesc,duas_tdesc," & vbCrLf &_
'							  " a.carr_ccod,carr_tdesc, case a.jorn_ccod when 1 then '(D)' else '(V)' end as jorn_Ccod,isnull(a.estado_cierre_ccod,1) as estado_cierre_ccod," & vbCrLf &_
'							  " 'sistema alu' as audi_tusuario,getdate() as audi_fmodificacion,getDate() as fecha_grabado" & vbCrLf &_
'							  " from secciones a join cargas_academicas b " & vbCrLf &_
'							  "    on a.secc_ccod=b.secc_ccod  " & vbCrLf &_
'							  " join calificaciones_seccion e " & vbCrLf &_
'							  "    on a.secc_ccod = e.secc_ccod   " & vbCrLf &_
'							  " join tipos_evaluacion f " & vbCrLf &_
'							  "    on e.teva_ccod = f.teva_ccod " & vbCrLf &_   
'							  " join alumnos d " & vbCrLf &_
'							  "    on b.matr_ncorr=d.matr_ncorr " & vbCrLf &_
'							  " join periodos_academicos pea " & vbCrLf &_
'							  "    on a.peri_ccod = pea.peri_ccod  " & vbCrLf &_
'							  " join asignaturas asi " & vbCrLf &_
'							  "    on asi.asig_Ccod = a.asig_Ccod  " & vbCrLf &_
'						      " join duracion_asignatura dua " & vbCrLf &_
'						      "    on asi.duas_ccod=dua.duas_ccod " & vbCrLf &_
'							  " join carreras car " & vbCrLf &_
'							  "    on a.carr_ccod=car.carr_ccod " & vbCrLf &_
'							  " where a.peri_ccod in (select peri_ccod from periodos_academicos where anos_ccod= datePart(year,getDate()))  " 
'	   conexion.ejecutaS(c_agregar_registros)		
'	end if
'end if
'-----------------------------------------------------------------------------------------------------------------
'end if


'---------------------------------------------------------------------------------------------------

set f_botonera = new CFormulario2
f_botonera.Carga_Parametros "notas_alumno.xml", "botonera"

set f_encabezado = new CFormulario2
f_encabezado.Carga_Parametros "notas_alumno.xml", "encabezado"
f_encabezado.Inicializar conexion2

pers_ncorr = conexion2.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

if q_peri_ccod <> "" then
consulta = "select protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       protic.obtener_nombre_carrera(b.ofer_ncorr, 'C') as carrera, protic.ano_ingreso_carrera(b.pers_ncorr, d.carr_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod " & vbCrLf &_
		   "  and b.emat_ccod <> 9 " & vbCrLf &_
		   "  and cast(c.peri_ccod as varchar)= '"&q_peri_ccod&"'" & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
f_encabezado.AgregaCampoParam "carreras_alumno","permiso","OCULTO"
f_encabezado.AgregaCampoParam "carrera","permiso","LECTURA"

consulta_carrera="(Select '' as carr_ccod,'' as carr_tdesc) s"		   
else
consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       ltrim(rtrim(protic.obtener_nombre_carrera(b.ofer_ncorr, 'C'))) as carrera, protic.ano_ingreso_carrera(b.pers_ncorr, d.carr_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod " 
		   if carrera <> "" then
		   		consulta=consulta & " and cast(d.carr_ccod as varchar)='"&carrera&"'"
		   else
				consulta=consulta & "  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) " 
		   end if
		   consulta=consulta &"  and b.emat_ccod <> 9 " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' order by b.alum_fmatricula desc"
		   

consulta_carrera=" (select distinct ltrim(rtrim(a.carr_ccod)) as carr_ccod, ltrim(rtrim(a.carr_tdesc)) as carr_tdesc " & vbCrLf &_
				 " from NOTAS_TEMPORALES a " & vbCrLf &_
				 " where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"') s"

f_encabezado.AgregaCampoParam "carreras_alumno","permiso","LECTURAESCRITURA"
f_encabezado.AgregaCampoParam "carrera","permiso","OCULTO"				 
end if

f_encabezado.Consultar consulta
f_encabezado.Siguiente
f_encabezado.AgregaCampoCons "carreras_alumno", carrera
f_encabezado.AgregaCampoParam "carreras_alumno","destino",consulta_carrera
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")

'---------------------------------------------------------------------------------------------------
anio_consulta = conexion2.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&q_peri_ccod&"'")
set f_asignaturas = new CFormulario2
f_asignaturas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_asignaturas.Inicializar conexion2

		
consulta2 = "  select distinct a.matr_ncorr,a.peri_tdesc, ltrim(rtrim(a.carr_tdesc)) + a.jorn_ccod as carrera, " & vbCrLf &_
		    " a.secc_ccod, ltrim(rtrim(a.asig_ccod)) + ' --> ' + a.asig_tdesc as asignatura,a.duas_tdesc  " & vbCrLf &_
		    " from NOTAS_TEMPORALES a " & vbCrLf &_
			" where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrLf &_
			" and cast(a.anos_ccod as varchar) = '"&anio_consulta&"' " & vbCrLf &_
			" order by a.peri_tdesc asc "
			
'response.Write("<pre>"&consulta2&"</pre>")
f_asignaturas.Consultar consulta2

nombre_carrera=f_encabezado.obtenerValor("carrera")

set f_notas_parciales = new CFormulario2
f_notas_parciales.Carga_Parametros "notas_alumno.xml", "notas_parciales"
f_notas_parciales.Inicializar conexion2

'lenguetas_notas = Array(Array("Notas Parciales del Alumno", "notas_parciales_alumno.asp"), Array("Histórico de notas del alumno", "notas_alumno.asp"))

 
 

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Notas parciales del alumno</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
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
function dibujar(formulario)
{
	formulario.submit();
}
function horario(){
	self.open('horario_alumno.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa función de notas parciales alumno, fue desarrollada para que el alumno tenga concentrada en una sola página todas las evaluaciones del año académico, segmentadas por semestres y asignaturas, desde ella podrá ver:\n\n" +
	       	  "- Asignaturas evaluadas en cada semestre.\n"+
			  "- Distribución de ponderaciones de notas parciales por cada asignatura.\n"+
			  "- Notas parciales obtenidas en cada evaluación.\n"+
			  "- promedios finales por asignatura.\n\n"+
			  "Las notas se reflejarán como máximo 24 hrs. después que el docente las ingrese al sistema. Si a algún alumno no le figura alguna asignatura es por que el docente aún no ingresa la programación de esta."
		   
	alert(mensaje);
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
<table align="center" width="700">
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Calificaciones Parciales</strong></font></td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<!--Antecedentes educacionales-->
	<tr>
		<td width="100%" align="left">
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
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Asignaturas a cursar</strong></font></td>
										   <td><hr></td>
										   <TD width="10%">
										   		<%POS_IMAGEN = 0%>
										   		<a href="javascript:ayuda(1)"
												onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true ">
												<img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?"> 
												</a>
											</TD>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr> 
										<td height="20" width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Rut</strong></font></td>
										<td width="40%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("rut")%></font></td>
										<td width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre</strong></font></td>
										<td width="40%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("nombre")%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carrera</strong></font></td>
										<td width="40%" colspan="3"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%=nombre_carrera%></font></td>
									  </tr>
									  <tr> 
										<td height="20" width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Duraci&oacute;n</strong></font></td>
										<td width="40%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("duas_tdesc")%></font></td>
										<td width="10%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Año Ingreso</strong></font></td>
										<td width="40%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("ano_ingreso_plan")%></font></td>
									  </tr>                        
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
											                 <%POS_IMAGEN = POS_IMAGEN + 1%>
															 <a href="javascript:_Navegar(this, 'notas_alumno.asp', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/NOTAS2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/NOTAS1.png';return true ">
																<img src="imagenes/NOTAS1.png" border="0" width="70" height="70" alt="VER CALIFICACIONES HISTÓRICAS"> 
															</a>
										</td>
										<td height="10" align="left">
															<%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
																<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
															</a>
										</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  
                                  
								  </table>
                  
								</td>
							</tr>
						  <input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>"> 
						  <input name="b[0][pers_xdv]" type="hidden" value="<%=q_pers_xdv%>">
						  <input name="b[0][peri_ccod]" type="hidden" value="<%=q_peri_ccod%>">
						 </form>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
	<tr>
		<td width="100%" align="left">
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
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Asignaturas del Año</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr>
									     <td height="20" colspan="4" align="center">
									  			<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
												 <% if f_asignaturas.NroFilas > 0 then 
													  while f_asignaturas.siguiente 
														  matr_ncorr = f_asignaturas.obtenerValor("matr_ncorr")
														  secc_ccod  = f_asignaturas.obtenerValor("secc_ccod")
														  periodo    = f_asignaturas.obtenerValor("peri_tdesc")
														  carrera    = f_asignaturas.obtenerValor("carrera")
														  asignatura = f_asignaturas.obtenerValor("asignatura")
														  duracion   = f_asignaturas.obtenerValor("duas_tdesc")
													  %>
													  <tr><td>&nbsp;</td></tr>
													  <tr>
														<td align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong><%=periodo & " - " & carrera%></strong></font> </td>
													  </tr>	
													  <tr>
														 <td><font size="2" face="Courier New, Courier, mono" color="#0000FF"><%=asignatura & " (" & duracion &") " %></font></td> 
													   </tr>
													   <tr><td>&nbsp;</td></tr>
													   <tr><td>
														  <table width="100%"  border="0" align="center">
														  <% consulta3 = " select cali_nevaluacion as n,teva_tdesc as tipo,cali_nponderacion as ponderacion, protic.trunc(cali_fevaluacion) as fecha, " & vbCrLf &_
																		  " a.cala_nnota as nota  " & vbCrLf &_
																		  " from NOTAS_TEMPORALES a " & vbCrLf &_
																		  " where cast(a.secc_ccod as varchar)= '"&secc_ccod&"' " & vbCrLf &_
																		  " and cast(a.matr_ncorr as varchar)= '"&matr_ncorr&"'  " & vbCrLf &_
																		  " order by cali_nevaluacion "						
					 
															 f_notas_parciales.Consultar consulta3
															 promedio = conexion2.consultaUno("select cast(cast(carg_nnota_final as decimal(2,1)) as varchar) from NOTAS_TEMPORALES where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='" & secc_ccod & "'")
															 estado = conexion2.consultaUno("select isnull(estado_cierre_ccod,1) from NOTAS_TEMPORALES where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='" & secc_ccod & "'")
															 aprueba = conexion2.consultaUno("select sitf_baprueba from cargas_academicas a, situaciones_finales b where a.sitf_ccod = b.sitf_ccod and cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='" & secc_ccod & "'")
															 if estado <> "2" then
																mensaje_estado = "(Provisorio) "
															 else
																mensaje_estado = "(Definitivo) "
															 end if		
															 %>
															<tr>
															  <td width="100%" align="center"><div align="center"><%f_notas_parciales.DibujaTabla%></div></td>
															</tr>
															<%f_notas_parciales.primero
															  matr_ncorr = ""
															  secc_ccod =  ""
															  consulta3 = ""%>
															  <tr>
															   <%if promedio >= "4.0" and aprueba <> "N" then %>
															   <td width="100%" align="right"><strong>Promedio<%=mensaje_estado%> : <%=promedio %></strong></td>
															   <%else%>
															   <td width="100%" align="right"><font color="#990000"><strong>Promedio<%=mensaje_estado%> : <%=promedio %></strong></font></td>
															   <%end if%>
															  </tr>
														   </table>
														 </td>
													  </tr>
													  <tr><td><hr></td></tr>
													  <%wend
													  else
													  %>
													  <tr><td>&nbsp;</td></tr>
													  <tr><td align="left"><font size="2" color="#0000FF"><strong>Lo sentimos pero no hemos encontrado notas parciales para el año 2007, esto se puede deber a: <br>- No presenta matrícula activa en el año.<br>- No presenta carga académica tomada.<br>- Los docentes aún no configuran el plan de actividades y evaluaciones de sus asignaturas.</strong><br>Sí deseas ver tu histórico presiona sobre la leng&uuml;eta correspondiente.</font></td>
													  </tr>
													  <tr><td><hr></td></tr>
													  <%end if%>
													</table>
									  
									  	  </td>
									  </tr>
									  <tr> 
										<td height="10">&nbsp;</td>
										<td height="10" align="right">
											                 <%POS_IMAGEN = POS_IMAGEN + 1%>
															 <a href="javascript:_Navegar(this, 'notas_alumno.asp', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/NOTAS2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/NOTAS1.png';return true ">
																<img src="imagenes/NOTAS1.png" border="0" width="70" height="70" alt="VER CALIFICACIONES HISTÓRICAS"> 
															</a>
										</td>
										<td height="10" align="left">
															<%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
																<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
															</a>
										</td>
										<td height="10">&nbsp;</td>
									  </tr>
									  
                                  
								  </table>
                  
								</td>
							</tr>
						  <input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>"> 
						  <input name="b[0][pers_xdv]" type="hidden" value="<%=q_pers_xdv%>">
						  <input name="b[0][peri_ccod]" type="hidden" value="<%=q_peri_ccod%>">
						 </form>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
</table>
</center>
</body>
</html>

