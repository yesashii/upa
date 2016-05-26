<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
set conectar = new CConexion
conectar.Inicializar "upacifico"

carr_ccod = request.querystring("busqueda[0][carr_ccod]")
retorno = request.querystring("retorno")
usuario =  session("rut_tyg") 'negocio.obtenerUsuario
if usuario = "" then
	session("mensajeerror")= "Debe ingresar con un usuario y clave para ver esta opción, acceso sólo egresados y titulados de la Universidad."
	response.Redirect("index.asp?eea=0") 
end if
rut = conectar.consultaUno("select cast(pers_nrut as varchar)+'-'+pers_xdv from personas where cast(pers_nrut as varchar)='"&usuario&"'")
nombre = conectar.consultaUno("select protic.initcap(pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno) from personas where cast(pers_nrut as varchar)='"&usuario&"'")
pers_ncorr = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
email = conectar.consultaUno("select lower(email_nuevo) from cuentas_email_upa where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
con_certificado_titulo = conectar.consultaUno("SELECT count(*) FROM certificados_emitidos WHERE CERT_TIPO IN ('Certificado de título','Certificado de título técnico') AND CAST(PERS_NCORR AS VARCHAR)='"&pers_ncorr&"'")
'response.Write(con_certificado_titulo)
if con_certificado_titulo = "0" then
 valor_cert_titulo = "Sin costo"
 valor2 = 0
else
 valor_cert_titulo = "$30.000'"
 valor2 = 30000
end if

con_certificado_notas = conectar.consultaUno("SELECT count(*) FROM certificados_emitidos WHERE CERT_TIPO IN ('Certificado de concentración de notas','Certificado Con. Notas titulado') AND CAST(PERS_NCORR AS VARCHAR)='"&pers_ncorr&"'")
'response.Write(con_certificado_titulo)
if con_certificado_notas = "0" then
 valor_cert_notas = "Sin costo"
 valor_notas = 0
else
 valor_cert_notas = "$5.500'"
 valor_notas = 5500
end if

total_carreras = conectar.consultaUno("select count(distinct d.carr_ccod) from alumnos a, ofertas_academicas b, especialidades c, carreras d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and a.emat_ccod in (4,8) and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'")
if total_carreras = "1" and carr_ccod="" then
	carr_ccod = conectar.consultaUno("select  top 1 d.carr_ccod from alumnos a, ofertas_academicas b, especialidades c, carreras d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and a.emat_ccod in (4,8) and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'")
	plan_ccod = conectar.consultaUno("select top 1 plan_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and a.emat_ccod in (4,8) order by b.peri_ccod desc")
	total_asignaturas = conectar.consultaUno("select count(*) from ASIGNATURAS_CERTIFICADO where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and carr_ccod='"&carr_ccod&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and ACER_ENVIADA='NO' ")
	'response.Write(total_asignaturas)
end if

pendientes = "0"

set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 
f_listado.Inicializar conectar

c_listado = " select protic.initCap(tctg_tdesc) as tipo,protic.trunc(sctg_fsolicitud) fecha_solicitud, "& vbCrLf &_ 
			" protic.trunc(sctg_fmodificacion) as actualizado, protic.initCap(esctg_tdesc) as estado, "& vbCrLf &_ 
			" lower(observacion) as observacion  "& vbCrLf &_ 
			" from solicitud_certificados_tyg a, tipos_certificados_tyg b,estados_solicitud_certificados_tyg c, sedes d "& vbCrLf &_ 
			" where a.tctg_ccod=b.tctg_ccod and a.esctg_ccod=c.esctg_ccod  "& vbCrLf &_ 
			" and a.sede_ccod=d.sede_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.carr_ccod='"&carr_ccod&"' "& vbCrLf &_ 
			" and a.ESCTG_CCOD <> 7 "& vbCrLf &_ 
			" order by tipo "

f_listado.consultar c_listado

pendientes = f_listado.nroFilas

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Especialidades.xml", "f_busqueda"
 consulta = "(select distinct ltrim(rtrim(d.carr_ccod))+'*'+cast((select count(*) from ASIGNATURAS_CERTIFICADO tt "&_
            "                                        where tt.pers_ncorr=a.pers_ncorr and tt.carr_ccod=d.carr_ccod collate SQL_Latin1_General_CP1_CI_AS "&_
            "                                        and ACER_ENVIADA='NO') as varchar) as carr_ccod, "&_
			" protic.initCap(d.carr_tdesc) as carr_tdesc "&_
            " from alumnos a, ofertas_academicas b, especialidades c, carreras d "&_
			" where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod "&_
			" and a.emat_ccod in (4,8) and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' )a "
 f_busqueda.Inicializar conectar
 f_busqueda.Consultar "select '' "
 'if  EsVacio(carr_ccod) then
 ' 		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "1=2"
 'end if
 f_busqueda.AgregaCampoParam "carr_ccod","destino",consulta
 f_busqueda.AgregaCampoParam "carr_ccod","mensajeVacio",""
 f_busqueda.AgregaCampoParam "carr_ccod","mensajeNulo",""
 f_busqueda.AgregaCampoParam "carr_ccod","anulable","false"
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
 f_busqueda.Siguiente
 
 egresado = conectar.consultaUno("select count(*) from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and emat_ccod=4 ")
 titulado = conectar.consultaUno("select count(*) from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and c.carr_ccod='"&carr_ccod&"' and emat_ccod=8 ")

 bloqueo_egresado = "disabled"
 bloqueo_titulado = "disabled"
 
 if titulado <> "0" then
 	bloqueo_titulado = ""
 else 
 	bloqueo_egresado = ""
 end if
 
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
  <meta name="description" content="Your description goes here" />
  <meta name="keywords" content="your,keywords,goes,here" />
  <link rel="stylesheet" type="text/css" href="andreas01.css" media="screen,projection" />
  <title>Web de T&iacute;tulos y Grados</title>
<script src="Scripts/AC_RunActiveContent.js" type="text/javascript"></script>
<style>
a {
	color: #000000;
	text-decoration: none;
	font-weight:bold;	
}

a:hover {
	color: #63ABCC;
}
</style>
<script language="JavaScript" type="text/javascript">
function calcular(check)
{
 var valor_total = 0;
 var activar = 0;
 var formulario = document.edicion;
 var indice = formulario.elements["busqueda[0][carr_ccod]"].selectedIndex;
 var valor = formulario.elements["busqueda[0][carr_ccod]"].options[indice].value;
 var cadena = valor.split("*"); 
 formulario.elements["total_asignaturas"].value= cadena[1];
 var total_asignaturas = formulario.elements["total_asignaturas"].value * 1;
 if ( formulario.elements["cert_alumno_egresado"].checked )
  { valor_total = valor_total + (formulario.elements["valor1"].value * 1 ); 
    activar = activar + 1;}
 
  if ( formulario.elements["cert_titulo"].checked )
  { valor_total = valor_total + (formulario.elements["valor2"].value * 1 ); 
    activar = activar + 1; }
  
  if ( formulario.elements["cert_conc_notas"].checked )
  { valor_total = valor_total + (formulario.elements["valor3"].value * 1 ); 
    activar = activar + 1; } 
  
  /*if ( formulario.elements["copia_diploma"].checked )
  { valor_total = valor_total + (formulario.elements["valor4"].value * 1 ); 
    activar = activar + 1; } */

  if ( formulario.elements["prog_por_asignatura"].checked )
  { valor_total = valor_total + (formulario.elements["valor5"].value * 1 * total_asignaturas ); 
    activar = activar + 1; }   

   if (valor_total > 0)
   {
   		formulario.elements["resultado"].value = "El costo total de los certificados es: $"+valor_total;
		formulario.elements["costo_total"].value = valor_total;
   }
   else
   {
        formulario.elements["resultado"].value = "";
		formulario.elements["costo_total"].value = 0;
   }
   //Para activar el botón de las asignaturas
   if ( formulario.elements["prog_por_asignatura"].checked ) 
   {
   		formulario.agregar_asignaturas.disabled=false;
   }
   else
   {
   		formulario.agregar_asignaturas.disabled=true;
   }
   
   //Para activar el botón de envio de solicitud
   if (activar > 0)
   {
        formulario.enviar_solicitud.disabled=false;
   }
   else
   {
    	formulario.enviar_solicitud.disabled=true;
   }
   
   	
} 

function mandar_email(formulario)
{
	var valor = formulario.elements["costo_total"].value;
	var indice = formulario.elements["busqueda[0][carr_ccod]"].selectedIndex;
	var valor = formulario.elements["busqueda[0][carr_ccod]"].options[indice].value;
	var cadena = valor.split("*"); 
	formulario.elements["total_asignaturas"].value= cadena[1];
	var carrera = cadena[0];
	var estatus = true;
	if (( formulario.elements["prog_por_asignatura"].checked )&&(cadena[1]*1 <= 0))
	{
		estatus = false;
		alert("Para incorporar el programa por asignatura debe seleccionarlas previamente y el costo es $8000 por programa.")
	}
	
	if (estatus)
	{
		if (valor > 0) 
		{	var respuesta = confirm("¿Desea enviar esta solicitud al departamento de títulos y grados?\n Recuerde que antes de retirar los certificados debe cancelar $ "+valor+" en cualquier caja de la universidad \ny presentar el comprobante de pago");}
		else
		{	var respuesta = confirm("¿Desea enviar esta solicitud al departamento de títulos y grados?");}
		if (respuesta)
		{ 
		   formulario.action = 'http://admision.upacifico.cl/postulacion/www/proc_envia_solicitud_tyg.php?carr_ccod='+carrera;
		   formulario.submit();
		}   
	}	
}
function asignaturas()
{
 var formulario = document.edicion;
 var indice = formulario.elements["busqueda[0][carr_ccod]"].selectedIndex;
 var valor = formulario.elements["busqueda[0][carr_ccod]"].options[indice].value;
 var cadena = valor.split("*"); 
 formulario.elements["total_asignaturas"].value= cadena[1];
 var carrera = cadena[0];
 var url = "cargar_asignaturas.asp?pers_ncorr="+<%=pers_ncorr%>+"&carr_ccod="+carrera;
 window.open(url,"v1","height=400,width=500,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes");


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
<div id="content2">
  <table width="100%" bgcolor="#FFFFFF" border="0">
    <tr>
      <td width="100%" align="left">
	  		<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr valign="bottom">
					<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_sup_izq.png"></td>
					<td bgcolor="#FFFFFF" height="18" background="img/superior.png">&nbsp;</td>
					<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_sup_der.png"></td>
				</tr>
				<tr>
					<td bgcolor="#FFFFFF" width="8" background="img/izquierda.png">&nbsp;</td>
					<td bgcolor="#FFFFFF">
										 <table width="100%" cellpadding="0" cellspacing="0">
														<tr>
															<td width="100%" align="left">
																<font size="3"><strong>Solicitud de certificados</strong></font>
															</td>
														</tr>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
														</tr>
														<tr>
															<td width="100%" align="left">
																<table width="100%" cellpadding="0" cellspacing="0">
																	<tr>
																		<td width="19%" align="left"><font size="2"><strong>Rut</strong></font></td>
																		<td width="1%" align="center"><font size="2"><strong>:</strong></font></td>
																		<td align="left"><font size="2"><%=rut%></font></td>
																	</tr>
																	<tr>
																		<td width="19%" align="left"><font size="2"><strong>Nombre</strong></font></td>
																		<td width="1%" align="center"><font size="2"><strong>:</strong></font></td>
																		<td align="left"><font size="2"><%=nombre%></font></td>
																	</tr>
																	<tr>
																		<td width="19%" align="left"><font size="2"><strong>Email</strong></font></td>
																		<td width="1%" align="center"><font size="2"><strong>:</strong></font></td>
																		<td align="left"><font size="2"><%=email%></font></td>
																	</tr>
																	<tr>
																		<td colspan="3">&nbsp;</td>
																	</tr>
																</table>
															</td>
														</tr>
													</table>
					 </td>
				 	 <td bgcolor="#FFFFFF" width="12" background="img/derecha.png">&nbsp;</td>
				</tr>
				<tr valign="top">
				   <td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_inf_izq.png"></td>
				   <td bgcolor="#FFFFFF" height="18" background="img/inferior.png">&nbsp;</td>
				   <td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_inf_der.png"></td>
				</tr>
		 </table>
	  </td>
    </tr>
	<tr>
		<td width="100%" align="left">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr valign="bottom">
					<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_sup_izq.png"></td>
					<td bgcolor="#FFFFFF" height="18" background="img/superior.png">&nbsp;</td>
					<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_sup_der.png"></td>
				</tr>
				<tr>
					<td bgcolor="#FFFFFF" width="8" background="img/izquierda.png">&nbsp;</td>
					<td bgcolor="#FFFFFF">
												<table width="100%" cellpadding="0" cellspacing="0">
														<tr>
															<td width="100%" align="left">
																<font size="2"><strong>Marque los certificados que desea solicitar</strong></font>
															</td>
														</tr>
														<tr>
															<td width="100%" align="center">&nbsp;
																<%if retorno="1" then
																    response.Write("<font color='#339933' size='3'>Su solicitud ha sido enviada exitosamente.</font>")
																  elseif retorno ="0" then
																    response.Write("<font color='#CC3300' size='3'>Se ha presentado un error en su solicitud, inténtelo nuevamente.</font>")
																  END IF%>
															</td>
														</tr>
														
														<form name="edicion" method="post">
														  <input type="hidden" name="pers_ncorr" value="<%=pers_ncorr%>">
														<tr>
															<td width="100%" align="left">
																<table width="100%" cellpadding="0" cellspacing="0">
																	<tr>
																		<td width="35%"><font size="2"><strong>Carrera</strong></font></td>
																		<td colspan="5" align="left"><%f_busqueda.dibujaCampo("carr_ccod")%>
                                                                        </td>
																	</tr>
																	<tr>
																		<td width="35%"><font size="2"><strong>Alumno Egresado</strong></font></td>
																		<td width="10%"><font size="1" color="#0066FF"><strong>Sin costo</strong></font><input type="hidden" name="valor1" value="0"></td>
																		<td width="5%" align="center"><input type="checkbox" name="cert_alumno_egresado" value="1" onClick="calcular(1);" <%=bloqueo_egresado%> ></td>
																		<td width="35%"><font size="2"><strong>Certificado de título</strong></font></td>
																		<td width="10%"><font size="1" color="#0066FF"><strong><%=valor_cert_titulo%></strong></font><input type="hidden" name="valor2" value="<%=valor2%>"></td>
																		<td width="5%" align="center"><input type="checkbox" name="cert_titulo" value="1"  onClick="calcular(2);" <%=bloqueo_titulado%>></td>
																	</tr>
																	<tr>
																		<td width="35%"><font size="2"><strong>Concentración de Notas</strong></font></td>
																		<td width="10%"><font size="1" color="#0066FF"><strong><%=valor_cert_notas%></strong></font><input type="hidden" name="valor3" value="<%=valor_notas%>"></td>
																		<td width="5%" align="center"><input type="checkbox" name="cert_conc_notas" value="1" onClick="calcular(3);"></td>
																		<td width="35%"><font size="2"><strong>&nbsp;</strong></font></td>
																		<td width="10%"><font size="1" color="#0066FF"><strong>&nbsp;</strong></font><input type="hidden" name="valor4" value="0"></td>
																		<td width="5%" align="center"><!--<input type="checkbox" name="copia_diploma" value="1" onClick="calcular(4);">--></td>
																	</tr>
																	<tr>
																		<td width="35%"><font size="2"><strong>Programa de cada asignatura (<%=total_asignaturas%>)</strong></font></td>
																		<td width="10%"><font size="1" color="#0066FF"><strong>$8.000 p/a</strong></font><input type="hidden" name="valor5" value="8000"><input type="hidden" name="total_asignaturas" value="<%=total_asignaturas%>"></td>
																		<td width="5%" align="center"><input type="checkbox" name="prog_por_asignatura" value="1" onClick="calcular(5);" ></td>
																		<td colspan="3" align="center"><input type="button" name="agregar_asignaturas" value="Agregar Asignaturas" onclick="javascript:asignaturas();" disabled></td>
																	</tr>
																	<tr>
																		<td width="35%"><font size="2"><strong>Sede de retiro </strong></font></td>
																		<td colspan="5" align="left">
																			<select name='sede_ccod' >
																				<option value='8' >BAQUEDANO</option>
																				<option value='7' >CONCEPCION</option>
																				<option value='1'  selected >LAS CONDES</option>
																				<option value='2' >LYON</option>
																				<option value='4' >MELIPILLA</option>
																			</select>
                                                                        </td>
																	</tr>
																	<tr>
																		
                            <td height="20" colspan="6">&nbsp;</td>
																	</tr>
																	<tr>
																		<td colspan="6" align="center">
																			<input type="text" name="resultado" value="" size="70" maxlength="70" style="color=#0066FF;border: none;">
																			<input type="hidden" name="costo_total" value="">
																		</td>
																	</tr><tr>
																		<td colspan="6">&nbsp;</td>
																	</tr>
																	<tr>
																		<td colspan="6" align="right"><input type="button" name="enviar_solicitud" value="Enviar Solicitud" disabled onClick="mandar_email(document.edicion);"></td>
																	</tr>
																</table>
															</td>
														</tr>
														</form>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
														</tr>
													</table>
													<%if pendientes <> "0" then%>
													 <table width="100%" cellpadding="0" cellspacing="0">
														<tr>
															<td width="100%" align="left">
																<font size="2"><strong>Detalle solicitud de certificados</strong></font>
															</td>
														</tr>
														<tr>
															<td width="100%" align="center">&nbsp;
																<%if retorno="1" then
																    response.Write("<font color='#339933' size='3'>Su solicitud ha sido enviada exitosamente.</font>")
																  elseif retorno ="0" then
																    response.Write("<font color='#CC3300' size='3'>Se ha presentado un error en su solicitud, inténtelo nuevamente.</font>")
																  END IF%>
															</td>
														</tr>
														<tr>
															<td width="100%" align="left">
																<table align="center" width="98%" cellpadding="0" cellspacing="0" border="1" bordercolor="#99CCFF">
																	<tr valign="top">
																		<td align="center" bgcolor="#99CCFF"><strong>Certificado</strong></td>
																		<td align="center" bgcolor="#99CCFF"><strong>Fecha solicitud</strong></td>
																		<td align="center" bgcolor="#99CCFF"><strong>Actualizado</strong></td>
																		<td align="center" bgcolor="#99CCFF"><strong>Estado</strong></td>
																		<td align="center" bgcolor="#99CCFF"><strong>Observación</strong></td>
																	</tr>
																	<%while f_listado.siguiente
																	   tipo = f_listado.obtenerValor("tipo")%>
																	<tr valign="top">
																		<td align="left" bgcolor="#FFFFFF"><%=f_listado.obtenerValor("tipo")%>
																			<%if tipo = "Programa De Cada Asignatura" then
																				set f_asignaturas = new CFormulario
																				f_asignaturas.Carga_Parametros "consulta.xml", "consulta" 
																				f_asignaturas.Inicializar conectar
																				
																				c_asignaturas = " select ltrim(rtrim(c.asig_ccod))+ ' ' + c.asig_tdesc as asignatura  "& vbCrLf &_
																								" from asignaturas_certificado a, malla_curricular b, asignaturas c  "& vbCrLf &_
																								" where a.mall_ccod=b.mall_ccod and b.asig_ccod=c.asig_ccod and acer_enviada='SI'  "& vbCrLf &_ 
																								" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.carr_ccod='"&carr_ccod&"' "& vbCrLf &_ 
																								" order by asignatura "
																				f_asignaturas.consultar c_asignaturas
																				if f_asignaturas.nroFilas > 0 then %>
																				<table width="100%" cellpadding="0" cellspacing="0">
																				<%  while f_asignaturas.siguiente
																						asig_mostrar = f_asignaturas.obtenerValor("asignatura") %>
																						<tr valign="top">
																						    <td width="4%" align="center"><font size="-3">-</font></td>
																							<td width="96%" align="left"><font size="-3"><%=asig_mostrar%></font></td>
																						</tr>
																				  <%wend%>
																			    </table>
																			  <%end if
																			 end if
																			%>
																		</td>
																		<td align="left" bgcolor="#FFFFFF"><%=f_listado.obtenerValor("fecha_solicitud")%></td>
																		<td align="left" bgcolor="#FFFFFF"><%=f_listado.obtenerValor("actualizado")%></td>
																		<td align="left" bgcolor="#FFFFFF"><%=f_listado.obtenerValor("estado")%></td>
																		<td align="left" bgcolor="#FFFFFF"><%=f_listado.obtenerValor("observacion")%>&nbsp;</td>
																	</tr>
																	<%wend%>
																</table>
															</td>
														</tr>
														<tr>
															<td width="100%" align="right"><font color="#FF9900">Revise su solicitud 3 días después de la fecha en que lo solicita.</font></td>
														</tr>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
														</tr>
													</table>
												    <%end if%>
					</td>
					<td bgcolor="#FFFFFF" width="12" background="img/derecha.png">&nbsp;</td>
				</tr>
				<tr valign="top">
					<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_inf_izq.png"></td>
					<td bgcolor="#FFFFFF" height="18" background="img/inferior.png">&nbsp;</td>
					<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_inf_der.png"></td>
				</tr>
		    </table>
		</td>
	 </tr>							
  </table>
  </div>

<div id="footer">
      <p>Universidad del Pacífico - Derechos Reservados / Sitio desarrollado para Explorer 8, o superior; Firefox o Safari</p>
    </div>
  </div>
  <script type="text/javascript">
<!--

//-->
  </script>
</body>
</html>
