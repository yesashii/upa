<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno_2008.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<% 

'**************************************************************
' Validacion para No emitir solicitudes de certificados para RRCC a partir del dia 1 de febrero
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())

if v_dia_actual>=30 or v_mes_actual>1 then
	'msg_rrcc="Las solicitudes de certificados al departamento de Registro Curricular se recibirán a partir del 22 de Febrero"
	'bloqueo_rrcc=true
end if
'**************************************************************

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

if v_mes_actual > 1 and v_mes_actual < 8 then
	q_peri_ccod = "226"
	q_anos_ccod = "2012"
else
	q_peri_ccod = "226"
	q_anos_ccod = "2012"
end if

if q_pers_nrut = "16368515" then
	q_peri_ccod = "226"
	q_anos_ccod = "2012"
end if

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "solicitud_reporte_alumno.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "solicitud_reporte_alumno.xml", "busqueda"
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
f_encabezado.Carga_Parametros "solicitud_reporte_alumno.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       ltrim(rtrim(protic.obtener_nombre_carrera(b.ofer_ncorr, 'C'))) as carrera, protic.ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
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
		   
consulta_carrera= "(select distinct d.carr_ccod , ltrim(rtrim(d.carr_tdesc)) as carr_tdesc " & vbCrLf &_
				  " from alumnos a, ofertas_academicas b, especialidades c, carreras d  " & vbCrLf &_
				  " where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' " & vbCrLf &_
				  " and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
				  " and b.espe_ccod=c.espe_ccod " & vbCrLf &_
				  " and c.carr_ccod=d.carr_ccod  and a.emat_ccod in (1,4,8) " & vbCrLf &_
				  " and b.peri_ccod in (select peri_ccod from periodos_academicos tt where tt.anos_ccod ='"&q_anos_ccod&"') )s "
 				 
'response.Write("<pre>"&consulta_carrera&"</pre>")
f_encabezado.AgregaCampoParam "carreras_alumno","permiso","LECTURAESCRITURA"
				 

email = conexion.consultaUno("select pers_temail from personas_postulante where cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")

'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
f_encabezado.AgregaCampoCons "carreras_alumno", carr_ccod
f_encabezado.AgregaCampoParam "carreras_alumno","destino",consulta_carrera
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")

nombre_carrera=f_encabezado.obtenerValor("carrera")

tiene_matricula_2007 = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and emat_ccod in (1,4)")
carrera_respaldo = conexion.consultaUno("select carr_ccod from alumnos a, ofertas_academicas b,especialidades c  where a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and emat_ccod in (1,4) and b.espe_ccod=c.espe_ccod")
'response.write("select case count(*) when 0 then 'N' else 'S' end from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and emat_ccod in (1,4)")
if pers_ncorr_temporal <> "" then
	es_moroso = conexion.consultaUno("select protic.es_moroso('"&pers_ncorr_temporal&"',getDate())")
	titulado  = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.emat_ccod='8' and cast(b.peri_ccod as varchar) >= '"&q_peri_ccod&"' ")
end if

if pers_ncorr_temporal="21124" or pers_ncorr_temporal="102062" or pers_ncorr_temporal="99080" or pers_ncorr_temporal="126053" or pers_ncorr_temporal="127113" or pers_ncorr_temporal="119780" or pers_ncorr_temporal="114074" or pers_ncorr_temporal="131383" or pers_ncorr_temporal="26005" then
	titulado="N"
end if

if q_pers_nrut = "16578741" or q_pers_nrut="17086932" or q_pers_nrut="17302501" then
	es_moroso = "N"
end if

if q_pers_nrut ="17408790" or q_pers_nrut ="14122872" then
tiene_matricula_2007="S"
end if
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Notas parciales del alumno</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
var t_parametros;

function Inicio()
{
	t_parametros = new CTabla("p")
}

function asigna_carrera(texto)
{
//alert(texto);
document.edicion.elements["nombre_carrera"].value = texto;
}
function asigna_motivo(texto)
{
//alert(texto);
document.edicion.elements["motivo"].value = texto;
}
function asigna_certificado(texto)
{
//alert(texto);
document.edicion.elements["tipo_certificado"].value = texto;
}
function asignar_valor(texto,valor,tipo)
{ var tipo_certificado; 
  var motivo;
  var tiene_matricula_2007 = '<%=tiene_matricula_2007%>';
  var es_moroso = '<%=es_moroso%>';
  var titulado = '<%=titulado%>';
if (tipo == 1)
	{
		document.edicion.elements["tipo_certificado"].value = texto;
	}
else
	{
		document.edicion.elements["motivo"].value = texto;
	}
//--------------------------------ahora debemos validar para emitir certificado gratuito--------------
tipo_certificado = document.edicion.elements["certificado"].value;
motivo = document.edicion.elements["enca[0][tdes_ccod]"].value;
carrera = document.edicion.elements["enca[0][carreras_alumno]"].value;
//alert ("tiene_matricula_2007: " + tiene_matricula_2007 + " es_moroso: " + es_moroso+ " titulado: "+titulado);

if (tipo_certificado == "1" )
	{
//alert ("tiene_matricula_2007: " + tiene_matricula_2007 + " es_moroso: " + es_moroso+ " titulado: "+titulado);	
		if ((motivo=="1")||(motivo=="9")||(motivo=="10")||(motivo=="11")||(motivo=="12")||(motivo=="13")||(motivo=="4")||(motivo=="5")||(motivo=="18")||(motivo=="6")||(motivo=="7")||(motivo=="8")||(motivo=="2")||(motivo=="6")||(motivo=="14")||(motivo=="19"))
		{
		    if ((tiene_matricula_2007=='S') && (es_moroso=='N') && (titulado=='N'))
			{
			 	document.getElementById("tabla_certificado").style.visibility = "visible" ;
				document.getElementById("tabla_boton").style.visibility = "hidden" ;
			}
			else
			{   alert("La impresión de certificados online requiere que el alumno tenga matrícula activa\n y que no presente morosidad en su Cuenta Corriente"); 
			 	document.getElementById("tabla_certificado").style.visibility = "hidden" ;
				if ((es_moroso=='N')&&(titulado=='N'))
				  {
				    document.getElementById("tabla_boton").style.visibility = "hidden" ;
				  }
			}	
		}
		else
		{   
		    if ((motivo!="")&&(es_moroso=='N'))
			 {
			   alert("Este tipo de certificado requiere ser solicitado directamente en La Universidad");  
			 }
			document.getElementById("tabla_certificado").style.visibility = "hidden" ;
			if ((es_moroso=='N')&&(titulado=='N'))
			  {
			    document.getElementById("tabla_boton").style.visibility = "hidden" ;
			  }
		}
	}
	else
	{
	        if ( (motivo!="") && (es_moroso=='N') &&(titulado=='N') )
			{
			  alert("Este tipo de certificado requiere ser solicitado directamente en La Universidad");
			} 
			document.getElementById("tabla_certificado").style.visibility = "hidden" ;
			if ((es_moroso=='N')&&(titulado=='N'))
			{
			  document.getElementById("tabla_boton").style.visibility = "visible" ;
			}   
	}
	
	if (motivo == "" )
	{
		document.getElementById("tabla_certificado").style.visibility = "hidden" ;
		document.getElementById("tabla_boton").style.visibility = "hidden" ;
	}

	
}
function certificado_1(){
   var codigo_carrera = document.edicion.elements["enca[0][carreras_alumno]"].value;
   var formulario=document.edicion;
   var valor=document.edicion.elements["enca[0][tdes_ccod]"].value;
   if (codigo_carrera == "")
   {
   	codigo_carrera = '<%=carrera_respaldo%>';
   }
   direccion = 'certificado_1.asp?carr_ccod='+codigo_carrera+'&pers_nrut=<%=q_pers_nrut%>&tdes_ccod='+ valor;
   //alert(direccion);
   self.open(direccion,'certificado','width=700px, height=550px, scrollbars=yes, resizable=yes')

}

function ayuda (valor)
{ var mensaje="";
    mensaje = "AYUDA\nLa solicitud de reportes de alumnos está disponible para alumnos con matricula año actual y que no presnete morosidad  en su cuenta corriente, a través de ella podrán: \n\n" +
	       	  "- Emitir directamente certificados de alumno regular para los fines que ellos seleccionen e imprimirlos directamente desde la Web.\n"+
			  "- Solicitar directamente la creación de certificados por parte del departamento de Registro curricular, dichos certificados deben ser retirados en la Universidad.\n"+
			  "\n\nLos certificados de alumno regular impresos desde la Web tienen un mes de vigencia y presentan un código de validación.";
		   
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
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong>Solicitud de Certificados</strong></font></td>
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
						<form name="edicion" action="notas_alumno.asp">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="33%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Solicitud de Certificados</strong></font></td>
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
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Rut</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("rut")%></font></td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Nombre</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("nombre")%></font></td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Carrera</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("carreras_alumno")%></font></td>
									  </tr>
									   <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Tipo de Certificado</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><select name="certificado" id="TO-N" onChange="asignar_valor(this.options[this.selectedIndex].text, this.value,1);">
											  <option value="">Seleccione</option>
											  <option value="1">Certificado de Alumno regular</option>
											  <option value="2">Concentraci&oacute;n de Notas</option>
											</select></font></td>
									  </tr>
									  <tr> 
										<td height="20" colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>Motivo de extenci&oacute;n</strong></font></td>
										<td colspan="2"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>: </strong><%f_encabezado.DibujaCampo("tdes_ccod")%></font></td>
									  </tr>
									  <tr><td height="20" colspan="4"><p align="center" style="color:#FF0000; font-size:12px"><%=msg_rrcc%></p></td></tr>
									  <tr>
									      <td height="20" colspan="4" align="center">
									        <table width="60%" cellpadding="0" cellspacing="0">
												<tr valign="middle">
													<td width="33%">
													
														<table width="100%" id="tabla_boton" style="visibility:hidden" cellpadding="0" cellspacing="0">
														<tr>
															<td align="right">
															
																<%POS_IMAGEN = POS_IMAGEN + 1%>
																<%if bloqueo_rrcc then%>
																	<a href="javascript:alert('Las solicitudes de certificados al departamento de Registro Curricular se recibirán a partir del 22 de Febrero');"
																	onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SOLICITAR_A_RRCC2.png';return true "
																	onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SOLICITAR_A_RRCC1.png';return true ">
																<%else%>
																 	<a href="javascript:_Guardar(this, document.forms['edicion'], 'http://www.upacifico.cl/super_test/motor_certificados.php','', '', '', 'FALSE');"
																	onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SOLICITAR_A_RRCC2.png';return true "
																	onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SOLICITAR_A_RRCC1.png';return true ">
																<%end if%>
																<img src="imagenes/SOLICITAR_A_RRCC1.png" border="0" width="70" height="70" alt="Enviar solicitud de certificado para creación por RRCC"> 
																</a>
															</td>
														</tr>
														</table>
													</td>
													<td width="33%" align="center">
													       <%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:_Navegar(this, 'mensajes.asp', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR1.png';return true ">
																<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME"> 
															</a>
													</td>
													<td width="34%">
													<table width="100%" border="0" id="tabla_certificado" style="visibility:hidden">
														<tr>
														    <td align="left">
																<%POS_IMAGEN = POS_IMAGEN + 1%>
																 <a href="javascript:certificado_1();"
																	onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/IMPRIMIR2.png';return true "
																	onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/IMPRIMIR1.png';return true ">
																	<img src="imagenes/IMPRIMIR1.png" border="0" width="70" height="70" alt="Imprimir certificado Online"> 
																</a>
														    </td>
														</tr>
													</table>
													</td>
													
													
												</tr>
											</table>
									      </td>
									  </tr>
									  <tr><td height="20" colspan="4">&nbsp;</td></tr>
                             
								  </table>
                  
								</td>
							</tr>
						  <input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>"> 
						  <input name="b[0][pers_xdv]" type="hidden" value="<%=q_pers_xdv%>">
						  <input name="b[0][peri_ccod]" type="hidden" value="<%=q_peri_ccod%>">
						  <input name="nombre_alumno" type="hidden" value="<%=f_encabezado.obtenerValor("nombre")%>">
						  <input name="rut" type="hidden" value="<%=q_pers_nrut&"-"&q_pers_xdv%>">
						  <input name="motivo" type="hidden" value="">
						  <input name="nombre_carrera" type="hidden" value="">
						  <input name="tipo_certificado" type="hidden" value="">
						  <input name="email" type="hidden" value="<%=email%>">
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

