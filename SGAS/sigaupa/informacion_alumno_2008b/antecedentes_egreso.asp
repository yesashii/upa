<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 
'------------------------------------------------------
matr_ncorr = Request.QueryString("enca[0][carreras_alumno]")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
 
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if
  

consulta_periodo=" select max(b.peri_ccod) "&_
                 " from alumnos a, ofertas_academicas b,personas c "&_
				 " where a.pers_ncorr = c.pers_ncorr and cast(c.pers_nrut as varchar)='"&q_pers_nrut&"'" &_
				 " and a.ofer_ncorr = b.ofer_ncorr and a.emat_ccod <> 9 and a.alum_nmatricula<>7777 --exists (select 1 from cargas_academicas carg where carg.matr_ncorr= a.matr_ncorr) "
				 

q_peri_ccod = conexion.consultaUno(consulta_periodo)


if matr_ncorr = "" then
	consulta_matr=" Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
	              " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr "&_
				  " and cast(c.peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
				  	
	matr_ncorr= conexion.consultaUno(consulta_matr)	
end if
'response.Write(consulta_matr)

carrera = conexion.consultaUno("Select carr_ccod from alumnos a, ofertas_Academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( matr_ncorr as varchar)='"&matr_ncorr&"'")

'---------------------------------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "carga_alumno.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "carga_alumno.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.siguiente

if q_pers_nrut <> "" then
	pers_ncorr_temporal=conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "carga_alumno.xml", "encabezado"
f_encabezado.Inicializar conexion

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
		   consulta=consulta &"  --and b.emat_ccod <> 9 " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
		   
consulta_carrera= "(select distinct a.matr_ncorr , ltrim(rtrim(d.carr_tdesc)) as carr_tdesc " & vbCrLf &_
				  " from alumnos a, ofertas_academicas b, especialidades c, carreras d " & vbCrLf &_
				  " where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' " & vbCrLf &_
				  " and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
				  " and b.espe_ccod=c.espe_ccod " & vbCrLf &_
				  " and c.carr_ccod=d.carr_ccod  --and a.emat_ccod in (1,4,8)" & vbCrLf &_
				  " --and exists (select 1 from cargas_academicas carg where carg.matr_ncorr = a.matr_ncorr)" & vbCrLf &_
				  " and cast(b.peri_ccod as varchar)='"&q_peri_ccod&"')s"
 				 
'response.Write("<pre>"&consulta_carrera&"</pre>")
f_encabezado.AgregaCampoParam "carreras_alumno","permiso","LECTURAESCRITURA"
f_encabezado.AgregaCampoParam "carrera","permiso","OCULTO"				 



'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
f_encabezado.AgregaCampoCons "carreras_alumno", matr_ncorr
f_encabezado.AgregaCampoParam "carreras_alumno","destino",consulta_carrera
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")

'---------------------------------------------------------------------------------------------------
set f_salidas = new CFormulario
f_salidas.Carga_Parametros "antecedentes_egreso.xml", "salidas"
f_salidas.Inicializar conexion

consulta2 = " Select salida,tipo_salida, egresado, titulado, " & vbCrLf &_
            " case when titulado = 'NO' then '' else '<a href=certificados.asp?pers_ncorr='+cast(pers_ncorr as varchar)+'&saca_ncorr='+cast(saca_ncorr as varchar)+'&tsca_ccod='+cast(tsca_ccod as varchar)+' target=_new>Certificado</a>' end as acceso " & vbCrLf &_
            " From ( " & vbCrLf &_
			" Select a.pers_ncorr,c.saca_ncorr,c.tsca_ccod,c.saca_tdesc as salida,d.tsca_tdesc as tipo_salida,  " & vbCrLf &_
			"		   (select case count(*) when 0 then 'NO' else 'SÍ' end  " & vbCrLf &_
			"			from alumnos tt, ofertas_academicas t2, especialidades t3  " & vbCrLf &_
			"			where tt.pers_ncorr=a.pers_ncorr and tt.ofer_ncorr=t2.ofer_ncorr  " & vbCrLf &_
			"			and t2.espe_ccod=t3.espe_ccod and tt.emat_ccod=4) as egresado,  " & vbCrLf &_
			"		   (select case count(*) when 0 then 'NO' else 'SÍ' end  " & vbCrLf &_
			"			from alumnos tt, ofertas_academicas t2, especialidades t3  " & vbCrLf &_
			"			where tt.pers_ncorr=a.pers_ncorr and tt.ofer_ncorr=t2.ofer_ncorr  " & vbCrLf &_
			"			and t2.espe_ccod=t3.espe_ccod and tt.emat_ccod=8) as titulado  " & vbCrLf &_
			"	from candidatos_egreso a, candidatos_egreso_detalle b, salidas_carrera c, tipos_salidas_carrera d  " & vbCrLf &_
			"	where a.CEGR_NCORR=b.CEGR_NCORR and a.ECEG_CCOD = 2  " & vbCrLf &_
			"	and b.saca_ncorr=c.saca_ncorr and c.tsca_ccod=d.tsca_ccod  " & vbCrLf &_
			"	and c.carr_ccod='"&carrera&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'  " & vbCrLf &_
			" ) tt " & vbCrLf &_
			"	order by salida asc " 
			
'response.write("<pre>"&consulta2&"</pre>")
f_salidas.Consultar consulta2
nombre_carrera=f_encabezado.obtenerValor("carrera")


set f_personales = new CFormulario
f_personales.Carga_Parametros "tabla_vacia.xml", "tabla"
f_personales.Inicializar conexion

SQL = " select a.pers_ncorr, b.dire_tcalle, b.dire_tnro, b.dire_tpoblacion,  " & vbCrLf & _
      " (select ciud_tdesc + '-' + ciud_tcomuna from ciudades tt where tt.ciud_ccod=b.ciud_ccod) as comuna_1,  " & vbCrLf & _
	  " rtrim(ltrim(cast(a.pers_nnota_ens_media as decimal(2,1)))) pers_nnota_ens_media," & vbCrLf & _
	  " a.pers_nano_egr_media, (select sexo_tdesc from sexos tt where tt.sexo_ccod=a.sexo_ccod) as sexo, " & vbCrLf & _
	  " (Select cole_tdesc from colegios tt where tt.cole_ccod=a.cole_ccod) as colegio, " & vbCrLf & _
	  " (select ciud_tdesc + '-' + ciud_tcomuna from ciudades tt where tt.ciud_ccod=c.ciud_ccod) as comuna_2 " & vbCrLf & _
	  " from " & vbCrLf & _
	  " personas a " & vbCrLf & _
	  " left outer join direcciones b " & vbCrLf & _
	  "    on a.pers_ncorr = b.pers_ncorr   and 1 = b.tdir_ccod  " & vbCrLf & _
	  " left outer join colegios c " & vbCrLf & _
	  "    on a.cole_ccod = c.cole_ccod " & vbCrLf & _
	  " where cast(a.pers_nrut as varchar)= '"&q_pers_nrut&"' "

f_personales.Consultar SQL
f_personales.Siguiente

	 consulta = " select pers_ncorr,plan_ccod,nombre_empresa,ubicacion_empresa,telefono_empresa,email_empresa,nombre_encargado,protic.trunc(fecha_proceso) as fecha_proceso, "& vbCrLf &_
				" cargo_encargado,protic.trunc(inicio_practica) as inicio_practica,protic.trunc(termino_practica) as termino_practica,observaciones,'"&carrera&"' as carr_ccod, "& vbCrLf &_
			    " descripcion_practica,isnull(horas_practica,(select t2.asig_nhoras from malla_curricular tt, asignaturas t2 "& vbCrLf &_
				" where tt.asig_ccod=t2.asig_ccod and tt.plan_ccod = a.plan_ccod and t2.asig_tdesc = 'PRACTICA PROFESIONAL') ) as horas_practica "& vbCrLf &_
				" from detalles_titulacion_carrera a left outer join situaciones_finales b "& vbCrLf &_
				" 		on a.concepto_practica = b.sitf_ccod "& vbCrLf &_
				" where cast(plan_ccod as varchar)='"&v_plan_ccod&"' "& vbCrLf &_
				" and a.carr_ccod ='"&carrera&"' "& vbCrLf &_
				" and cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'"

set f_practica = new CFormulario
f_practica.Carga_Parametros "tabla_vacia.xml", "tabla"
f_practica.Inicializar conexion

f_practica.Consultar consulta
f_practica.Siguiente

consulta_lista_comision = " select ctes_ncorr, pers_nrut,pers_xdv, a.pers_ncorr, a.plan_ccod, docente, "&_
						  " replace(isnull(calificacion_asignada,1.0),',','.') as calificacion_asignada, cast(isnull(calificacion_asignada,1.0) as decimal(2,1)) as nota " &_
						  " from comision_tesis a, personas b "&_
						  " where a.pers_ncorr=b.pers_ncorr "&_
						  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and cast(a.plan_ccod as varchar)='"&v_plan_ccod&"' "			

set f_lista_comision = new CFormulario
f_lista_comision.Carga_Parametros "antecedentes_egreso.xml", "lista_comision_tesis"
f_lista_comision.Inicializar conexion

f_lista_comision.Consultar consulta_lista_comision


						  

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
function dibujar(formulario)
{
	formulario.submit();
}
function horario(){
	self.open('horario_alumno.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa información desplegada corresponde a la considerada en el expediente de titulación si detecta cualquier diferencia o dato que no corresponda, favor comunicar a la escuela para hacer las correcciones necesarias.";
		   
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
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>ANTECEDENTES DE EGRESO DEL ALUMNO</strong></font></td>
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
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Carrera a Consultar</strong></font></td>
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
								<form name="buscador">
									<table width="100%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td width="16%" height="20"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carrera :</strong></font></td>
										<td colspan="3" align="left"><%f_encabezado.DibujaCampo("carrera")%>
											                         <%f_encabezado.DibujaCampo("carreras_alumno")%>
							            </td>
									  </tr>
									  <tr valign="top"> 
										<td height="10">&nbsp;</td>
										<td width="61%" height="10">&nbsp;</td>
										<td width="12%" height="10">&nbsp;</td>
										<td width="11%" height="10" align="center">
																			<%POS_IMAGEN = POS_IMAGEN + 1%>
																			<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
																				onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																				onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
																				<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
																			</a>
										</td>
									  </tr>
								  </table>
                                  </form>
								</td>
							</tr>
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
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Candidato a egreso</strong></font></td>
										   <td><hr></td>
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
									  <tr><td align="center" colspan="4"><%f_salidas.DibujaTabla%></td></tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
                                 
								  </table>
                  
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Datos de Contacto</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
								&nbsp;
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
								    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
									<tr>
									  <td width="15%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Sexo</strong></font></td>
									  <td width="1%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
									  <td width="35%"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_personales.obtenerValor("sexo")%></font></td>
									  <td width="15%">&nbsp;</td>
									  <td width="1%">&nbsp;</td>
									  <td width="35%">&nbsp;</td>
									</tr>
									<tr>
									  <td width="15%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Calle</strong></font></td>
									  <td width="1%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
									  <td width="35%"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_personales.obtenerValor("dire_tcalle")%></font></td>
									  <td width="15%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>N°</strong></font></td>
									  <td width="1%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
									  <td width="35%"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_personales.obtenerValor("dire_tnro")%></font></td>
									</tr>
									<tr>
									  <td width="15%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Poblaci&oacute;n-Villa</strong></font></td>
									  <td width="1%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
									  <td width="35%"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_personales.obtenerValor("dire_tpoblacion")%></font></td>
									  <td width="15%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Ciudad</strong></font></td>
									  <td width="1%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
									  <td width="35%"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_personales.obtenerValor("comuna_1")%></font></td>
									</tr>
									<tr>
									  <td width="15%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nota E.M.</strong></font></td>
									  <td width="1%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
									  <td width="35%"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_personales.obtenerValor("pers_nnota_ens_media")%></font></td>
									  <td width="15%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>A&ntilde;o Egreso E.M.</strong></font></td>
									  <td width="1%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
									  <td width="35%"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_personales.obtenerValor("pers_nano_egr_media")%></font></td>
									</tr>
									<tr>
									  <td width="15%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Colegio</strong></font></td>
									  <td width="1%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
									  <td width="35%"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_personales.obtenerValor("colegio")%></font></td>
									  <td width="15%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Comuna colegio</strong></font></td>
									  <td width="1%"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
									  <td width="35%"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_personales.obtenerValor("comuna_2")%></font></td>
									</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Práctica Profesional</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
								<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
									<tr> 
                                    <td width="14%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Empresa</strong></font></td>
                                    <td width="1%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
                                    <td width="35%" align="left"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_practica.obtenerValor("nombre_empresa")%></font></td>
                                    <td width="14%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Ubicación</strong></font></td>
                                    <td width="1%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
                                    <td width="35%" align="left"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_practica.obtenerValor("ubicacion_empresa")%></font></td>
                                  </tr>
                                  <tr> 
                                    <td width="14%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Teléfono</strong></font></td>
                                    <td width="1%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
                                    <td width="35%" align="left"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_practica.obtenerValor("telefono_empresa")%></font></td>
                                    <td width="14%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>E-mail</strong></td>
                                    <td width="1%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
                                    <td width="35%" align="left"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_practica.obtenerValor("email_empresa")%></font></td>
                                  </tr>
                                  <tr> 
                                    <td width="14%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Encargado</strong></font></td>
                                    <td width="1%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
                                    <td width="35%" align="left"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_practica.obtenerValor("nombre_encargado")%></font></td>
                                    <td width="14%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Cargo</strong></font></td>
                                    <td width="1%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
                                    <td width="35%" align="left"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_practica.obtenerValor("cargo_encargado")%></font></td>
                                  </tr>
                                  <tr> 
                                    <td width="14%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Inicio</strong></font></td>
                                    <td width="1%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
                                    <td width="35%" align="left"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_practica.obtenerValor("inicio_practica")%></font></td>
                                    <td width="14%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Término</strong></font></td>
                                    <td width="1%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
                                    <td width="35%" align="left"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_practica.obtenerValor("termino_practica")%></font></td>
                                  </tr>
                                  <tr> 
                                    <td width="14%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Des. Trabajo</strong></font></td>
                                    <td width="1%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
                                    <td width="14%" align="left"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_practica.obtenerValor("descripcion_practica")%></font></td>
                                    <td width="14%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>N° Horas</strong></font></td>
                                    <td width="1%" align="left"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>:</strong></font></td>
                                    <td width="35%" align="left"><font size="1" face="Courier New, Courier, mono" color="#496da6"><%=f_practica.obtenerValor("horas_practica")%></font></td>
                                  </tr>
								</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="28%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Comisión Tesis</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
							     <td width="100%" align="center"><div align="center"><%f_lista_comision.dibujaTabla()%></div></td>
    						</tr>
							<tr>
							     <td width="100%" align="center">&nbsp;</td>
    						</tr>
							<tr>
							     <td width="100%" align="center"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#610B0B"><strong>Si detecta diferencias en cualquiera de los datos indicados, favor comunicar a la escuela para realizar los cambios necesarios.</strong></font></td>
    						</tr>
							<tr>
							     <td width="100%" align="center">&nbsp;</td>
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

