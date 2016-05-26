<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
paiu_ncorr =Request.QueryString("paiu_ncorr")
pers_nrut=Request.QueryString("pers_nrut")
pers_xdv=Request.QueryString("pers_xdv")
pers_ncorr=Request.QueryString("pers_ncorr")
pais_ccod=Request.QueryString("pais_ccod")
ciex_ccod=Request.QueryString("ciex_ccod")
univ_ccod=Request.QueryString("univ_ccod")
peri_ccod=Request.QueryString("peri_ccod")
'paiu_ncorr=1

'---------------------------------------------------------------------------------------------------
set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Convenios Internacionales"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "alumnos_intercambio_upa.xml", "botonera"

set f_dato_alumno = new CFormulario
f_dato_alumno.Carga_Parametros "alumnos_intercambio_upa.xml", "datos"
f_dato_alumno.Inicializar conexion
sql_descuentos="select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,(select peri_tdesc from periodos_academicos aa where aa.peri_ccod=c.peri_ccod)as peri_tdesc,c.peri_ccod,"& vbCrLf &_
"pais_tdesc,"& vbCrLf &_
"ciex_tdesc,"& vbCrLf &_
"univ_tdesc"& vbCrLf &_
"from personas a,rrii_postulacion_alumnos_intercambio_upa c,universidad_ciudad d,universidades e,ciudades_extranjeras g, paises f"& vbCrLf &_
"where a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"and c.unci_ncorr=d.unci_ncorr"& vbCrLf &_
"and d.univ_ccod=e.univ_ccod"& vbCrLf &_
"and d.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and g.pais_ccod=f.PAIS_CCOD"& vbCrLf &_
"and c.paiu_ncorr="&paiu_ncorr&""& vbCrLf &_
"and c.peri_ccod="&peri_ccod&""

'response.Write("<pre>"&sql_descuentos&"</pre>")

f_dato_alumno.Consultar sql_descuentos
f_dato_alumno.siguiente

tiene_documentacion= conexion.ConsultaUno("select count(*) from rrii_documentacion_intercambio_alumnos_upa where paiu_ncorr="&paiu_ncorr&"")

set f_proceso = new CFormulario
f_proceso.Carga_Parametros "alumnos_intercambio_upa.xml", "muestra_proceso"
f_proceso.Inicializar conexion
if tiene_documentacion<>"0" then
sql_descuentos="select a.paiu_ncorr,unci_ncorr,peri_ccod,pers_ncorr,tdin_ccod,isnull(dtil_ccod,1) as dtil_ccod, "& vbCrLf &_
				"protic.trunc(paiu_finscripcion)as paiu_finscripcion,"& vbCrLf &_
				"protic.trunc(diau_fconsulta_esc)as diau_fconsulta_esc,diau_estado_ramos,"& vbCrLf &_
				"diau_respuesta_esc,diau_tcomentario_consulta_esc,"& vbCrLf &_
				"protic.trunc(diau_fenvio_carta_apoderado)as diau_fenvio_carta_apoderado,"& vbCrLf &_
				"protic.trunc(diau_frecepcion_carta_apoderado)as diau_frecepcion_carta_apoderado,"& vbCrLf &_
				"protic.trunc(diau_frecepcion_certi_alum_reg) as diau_frecepcion_certi_alum_reg,"& vbCrLf &_
				"protic.trunc(diau_fpeticion_certi_alum_reg)as diau_fpeticion_certi_alum_reg,"& vbCrLf &_
				"protic.trunc(diau_frecepcion_certi_notas) as diau_frecepcion_certi_notas,"& vbCrLf &_
				"protic.trunc(diau_fpeticion_certi_notas)as diau_fpeticion_certi_notas,"& vbCrLf &_
				"protic.trunc(diau_frecepcion_acuerdo_preconva)as diau_frecepcion_acuerdo_preconva,"& vbCrLf &_
				"protic.trunc(diau_fenvio_doctos_extranjero)as diau_fenvio_doctos_extranjero,"& vbCrLf &_
				"protic.trunc(diau_frecepcion_carta_acepta)as diau_frecepcion_carta_acepta,"& vbCrLf &_
				"protic.trunc(diau_ffirma) as paiu_ffirma,"& vbCrLf &_
				"diau_comen_recepcion_carta_apoderado,"& vbCrLf &_
				"diau_comen_envio_ramos_esc,"& vbCrLf &_
				"diau_comen_recepcion_certi_alum_reg,"& vbCrLf &_
				"diau_comen_recepcion_certi_notas,"& vbCrLf &_
				"diau_comen_recepcion_acuerdo_preconva,"& vbCrLf &_
				"diau_comen_recepcion_carta_acepta,"& vbCrLf &_
				"diau_comen_envio_doctos_extranjero,"& vbCrLf &_
				"diau_comen_firma,protic.trunc(diau_ffirma) as diau_ffirma,protic.trunc(diau_fenvio_ramos_esc)as diau_fenvio_ramos_esc,"& vbCrLf &_
				"espi_ccod,protic.trunc(diau_fficha_inscripcion) as diau_fficha_inscripcion,protic.trunc(diau_fentrevista_apoderado) as diau_fentrevista_apoderado,protic.trunc(diau_fseguro_salud) as diau_fseguro_salud, "& vbCrLf &_
				"diau_tcomentario_ficha,diau_tcomentario_entrevista,diau_tcomentario_seguro "& vbCrLf &_
				"from rrii_documentacion_intercambio_alumnos_upa a,rrii_postulacion_alumnos_intercambio_upa b"& vbCrLf &_
				"where a.paiu_ncorr=b.paiu_ncorr"& vbCrLf &_
				"and a.paiu_ncorr="&paiu_ncorr&""		
	else

sql_descuentos="select ''"

end if 							
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()
f_proceso.Consultar sql_descuentos
f_proceso.siguiente


%>

<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function alcargar()
{

respuesta_cons_esc='<%=f_proceso.ObtenerValor("diau_respuesta_esc")%>'


	if (respuesta_cons_esc!="")
	{
		document.proceso.elements["a[0][respuesta_cons_esc]"].value=respuesta_cons_esc
	}

}

var patron = new Array(2,2,4)
function mascara(d,sep,pat,nums){
if(d.valant != d.value){
	val = d.value
	largo = val.length
	val = val.split(sep)
	val2 = ''
	for(r=0;r<val.length;r++){
		val2 += val[r]	
	}
	if(nums){
		for(z=0;z<val2.length;z++){
			if(isNaN(val2.charAt(z))){
				letra = new RegExp(val2.charAt(z),"g")
				val2 = val2.replace(letra,"")
			}
		}
	}
	val = ''
	val3 = new Array()
	for(s=0; s<pat.length; s++){
		val3[s] = val2.substring(0,pat[s])
		val2 = val2.substr(pat[s])
	}
	for(q=0;q<val3.length; q++){
		if(q ==0){
			val = val3[q]
		}
		else{
			if(val3[q] != ""){
				val += sep + val3[q]
				}
		}
	}
	d.value = val
	d.valant = val
	}
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); alcargar();" onBlur="revisaVentana();">
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td><%pagina.DibujarLenguetas Array("Datos Alumno"), 1 %></td>
				  </tr>
				  <tr>
					<td height="2" background="../imagenes/top_r3_c2.gif"></td>
				  </tr>
				  <tr>
					<td>
						 <form name="buscador">
						 <input type="hidden" name="buscar">
							<table align="center" width="100%">
								<tr>
									<td width="6%"><strong>Nombre</strong></td>
									<td width="94%"><%f_dato_alumno.DibujaCampo("nombre")%></td>
							  </tr>
							</table>
							<table align="center" width="100%">
								<tr>
									<td width="26%"><strong>A&ntilde;o Acad&eacute;mico Intercambio </strong></td>
								  <td width="74%"><%f_dato_alumno.DibujaCampo("peri_tdesc")%></td>
								</tr>
							</table>
							<table>
								<tr>
									<td width="5%"><strong>Pais</strong></td>
									<td width="17%"><%f_dato_alumno.DibujaCampo("pais_tdesc")%></td>
									<td width="11%" align="right"><strong>Ciudad</strong></td>
								    <td width="17%"><%f_dato_alumno.DibujaCampo("ciex_tdesc")%></td>
									<td width="11%"><strong>Universidad</strong></td>
								  <td width="39%"><%f_dato_alumno.DibujaCampo("univ_tdesc")%></td>
								</tr>
							</table>
							<table>
                            	<tr> 
                                </tr>
                            </table>
						 </form>
					</td>
				  </tr>
        	</table>
		</td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>

	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td><%pagina.DibujarLenguetas Array("Documentación"), 1 %></td>
			  </tr>
			  <tr>
				<td height="2" background="../imagenes/top_r3_c2.gif"></td>
			  </tr>
			  <tr>
				<td><div align="center"><br>
				  <%pagina.DibujarTituloPagina%><br>
					</div>
						 <form name="proceso">
						 <input type="hidden" name="peri_ccod" value="<%=peri_ccod%>">
						  <input type="hidden" name="pais_ccod" value="<%=pais_ccod%>">
						 <input type="hidden" name="ciex_ccod" value="<%=ciex_ccod%>">
						 <input type="hidden" name="univ_ccod" value="<%=univ_ccod%>">
						 <input type="hidden" name="pers_nrut" value="<%=pers_nrut%>">
						 <input type="hidden" name="pers_xdv" value="<%=pers_xdv%>">
							<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
							  <tr>
								<td><%pagina.DibujarSubtitulo "Documentos"%>
								<%f_proceso.DibujaCampo("paiu_ncorr")%>
								  <br/>
								  <hr/>
								  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="12%" align="left">Fecha Inscripción  </td>
                                      <td width="31%" valign="bottom"><%f_proceso.DibujaCampo("paiu_finscripcion")%></td>
                                      <td width="13%" align="left">Duración Intercambio  </td>
                                      <td width="44%"><strong><%f_proceso.DibujaCampo("tdin_ccod")%></strong></td>
                                    </tr>
									<tr>
                                      <td colspan="4">&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td>Estado General:</td>
                                      <td valign="bottom"><%f_proceso.DibujaCampo("espi_ccod")%></td>
                                      <td width="13%" align="left">Doble Titulacion  </td>
                                      <td width="44%"><strong><%f_proceso.DibujaCampo("dtil_ccod")%></strong></td>
                                    </tr>
                                  </table>
                                  <h1 style="font-size:9px">&nbsp;&nbsp;Ficha de inscripción</h1>
							      <table width="98%"  border="0" align="center">
									  <tr>
										 <td width="21%" align="left" valign="top">Fecha de recepcion:</td>
					                    <td width="19%" valign="top"><%f_proceso.DibujaCampo("diau_fficha_inscripcion")%></td>
										 <td width="17%" align="left" valign="top">Comentario </td>
										<td width="43%"><textarea name="a[0][diau_tcomentario_ficha]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_comen_firma")%></textarea></td>
									 </tr>
								  </table>
								  <br/><hr/>	
                                  <h1 style="font-size:9px">&nbsp;&nbsp;Certificados Alumno Regular</h1>
                                  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="8%" align="left" valign="top">Fecha Petici&oacute;n </td>
                                      <td width="13%" valign="top"><%f_proceso.DibujaCampo("diau_fpeticion_certi_alum_reg")%></td>
                                      <td width="10%" align="left" valign="top">Fecha Recepcion </td>
                                      <td width="15%" valign="top"><%f_proceso.DibujaCampo("diau_frecepcion_certi_alum_reg")%></td>
                                      <td width="14%" align="left" valign="top">Comentario </td>
                                      <td width="40%"><textarea name="a[0][diau_comen_recepcion_certi_alum_reg]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_comen_recepcion_certi_alum_reg")%></textarea></td>
                                    </tr>
                                  </table>
                                  <hr/>
                                  <h1 style="font-size:9px">&nbsp;&nbsp;Certificados Notas</h1>
                                  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="8%" align="left" valign="top">Fecha Petici&oacute;n </td>
                                      <td width="12%" valign="top"><%f_proceso.DibujaCampo("diau_fpeticion_certi_notas")%></td>
                                      <td width="11%" align="left" valign="top">Fecha Recepcion </td>
                                      <td width="15%" valign="top"><%f_proceso.DibujaCampo("diau_frecepcion_certi_notas")%></td>
                                      <td width="14%" align="left" valign="top">Comentario </td>
                                      <td width="40%"><textarea name="a[0][diau_comen_recepcion_certi_notas]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_comen_recepcion_certi_notas")%></textarea></td>
                                    </tr>
                                  </table>
								  <hr/>
                                  <h1 style="font-size:9px">&nbsp;&nbsp;Entrevista con el Apoderado</h1>
								    <table width="98%"  border="0" align="center">
									  <tr>
										 <td width="14%" align="left" valign="top">Fecha de recepcion: </td>
					                    <td width="19%" valign="top"><%f_proceso.DibujaCampo("diau_fentrevista_apoderado")%></td>
										 <td width="14%" align="left" valign="top">Comentario </td>
										<td width="53%"><textarea name="a[0][diau_tcomentario_entrevista]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_comen_firma")%></textarea></td>
									 </tr>
								  </table>
								  <br/><hr/>	
                                  <h1 style="font-size:9px">&nbsp;&nbsp;Consulta Escuela</h1>
                                  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="10%" valign="top" align="left">Fecha Consulta </td>
                                      <td width="10%" valign="top"><%f_proceso.DibujaCampo("diau_fconsulta_esc")%></td>
                                      <td width="14%" align="right" valign="top">Respuesta : </td>
                                      <td width="12%" valign="top"><select name="a[0][respuesta_cons_esc]">
                                        <option value="">Seleccione</option>
                                        <option value="No">No</option>
                                        <option value="Si">Si</option>
                                      </select></td>
                                      <td width="14%" align="left" valign="top">Comentarios </td>
                                      <td width="40%" valign="top"><textarea name="a[0][comentario_cons_esc]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_tcomentario_consulta_esc")%></textarea></td>
                                    </tr>
                                  </table>
                                  <br/>
                                  <hr/>
                                  <h1 style="font-size:9px">&nbsp;&nbsp;Carta Apoderado</h1>
                                  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="8%" align="left" valign="top">Fecha Env&iacute;o </td>
                                      <td width="14%" valign="top"><%f_proceso.DibujaCampo("diau_fenvio_carta_apoderado")%></td>
                                      <td width="10%" align="left" valign="top">Fecha Recepci&oacute;n </td>
                                      <td width="14%" valign="top"><%f_proceso.DibujaCampo("diau_frecepcion_carta_apoderado")%></td>
                                      <td width="13%" align="left" valign="top">Comentario</td>
                                      <td width="41%"><textarea name="a[0][diau_comen_recepcion_carta_apoderado]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_comen_recepcion_carta_apoderado")%></textarea></td>
                                    </tr>
                                  </table>
                                  <br/>
                                  <h1 style="font-size:9px">&nbsp;&nbsp;                                  </h1>
                                  <hr/>
                                  <h1 style="font-size:9px">&nbsp;&nbsp;Envío de Ramos a Escuela</h1>
                                  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="13%" valign="top"align="left">Fecha Env&iacute;o </td>
                                      <td width="17%"valign="top"><%f_proceso.DibujaCampo("diau_fenvio_ramos_esc")%></td>
                                      <td width="14%" align="left" valign="top">Comentario </td>
                                      <td width="56%"><textarea name="a[0][diau_comen_envio_ramos_esc]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_comen_envio_ramos_esc")%></textarea></td>
                                    </tr>
                                  </table>
                                  <br/>
                                  <hr/>
								  <h1 style="font-size:9px">&nbsp;&nbsp;Acuerdo de Preconvalidaci&oacute;n</h1>
                                  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="13%" align="left"valign="top">Fecha Recepci&oacute;n </td>
                                      <td width="17%"valign="top"><%f_proceso.DibujaCampo("diau_frecepcion_acuerdo_preconva")%></td>
                                      <td width="14%" align="left" valign="top">Comentario </td>
                                      <td width="56%"><textarea name="a[0][diau_comen_recepcion_acuerdo_preconva]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_comen_recepcion_acuerdo_preconva")%></textarea></td>
                                    </tr>
                                  </table>
                                  <br/>
                                  <hr/>
                                  <h1 style="font-size:9px">&nbsp;&nbsp;Env&iacute;o Docto. Extranjero</h1>
                                  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="13%" align="left" valign="top">Fecha Env&iacute;o </td>
                                      <td width="18%" valign="top"><%f_proceso.DibujaCampo("diau_fenvio_doctos_extranjero")%></td>
                                      <td width="14%" align="right" valign="top">Comentario </td>
                                      <td width="55%" valign="top"><textarea name="a[0][diau_comen_envio_doctos_extranjero]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_comen_envio_doctos_extranjero")%></textarea></td>
                                    </tr>
                                  </table>
                                  <br/>
                                  <hr/>
                                  <h1 style="font-size:9px">&nbsp;&nbsp;Carta Aceptaci&oacute;n </h1>
                                  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="14%" align="left" valign="top">Fecha de Recepci&oacute;n </td>
                                      <td width="18%" valign="top"><%f_proceso.DibujaCampo("diau_frecepcion_carta_acepta")%></td>
                                      <td width="14%" align="left" valign="top">Comentario </td>
                                      <td width="54%"><textarea name="a[0][diau_comen_recepcion_carta_acepta]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_comen_recepcion_carta_acepta")%></textarea></td>
                                    </tr>
                                  </table>
                                  <br/>
                                  <hr/>
                                  <h1 style="font-size:9px">&nbsp;&nbsp;Seguro Médico</h1>
                                  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="14%" align="left" valign="top">Fecha de recepcion: </td>
                                      <td width="19%" valign="top"><%f_proceso.DibujaCampo("diau_fseguro_salud")%></td>
                                      <td width="14%" align="left" valign="top">Comentario</td>
                                      <td width="53%"><textarea name="a[0][diau_tcomentario_seguro]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_comen_firma")%></textarea></td>
                                    </tr>
                                  </table>
                                  <br/>
                                  <hr/>
								  <h1 style="font-size:9px">&nbsp;&nbsp;Carta Compromiso </h1>
                                  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="14%" align="left" valign="top">Fecha de Firma de Compromiso Alumno </td>
                                      <td width="19%" valign="top"><%f_proceso.DibujaCampo("diau_ffirma")%></td>
                                      <td width="14%" align="left" valign="top">Comentario </td>
                                      <td width="53%"><textarea name="a[0][diau_comen_firma]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_comen_firma")%></textarea></td>
                                    </tr>
                                  </table>
<!--
                                  <hr/>
								  <h1 style="font-size:9px">&nbsp;&nbsp; Ramos</h1>
                                  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="15%" align="left" valign="top">Estado Ramos </td>
                                      <td width="85%"><textarea name="a[0][diau_estado_ramos]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("diau_estado_ramos")%></textarea></td>
                                    </tr>
                                  </table>
--> 
								</td>
							 </tr>
						</table>
				  </form>
				</td>
			  </tr>
			</table>
		</td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="20%" height="20">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.AgregaBotonParam "volver", "url", "seguimiento_alumnos_intercambio_upa.asp?buscar=&b%5B0%5D%5Bpers_nrut%5D="&pers_nrut&"&b%5B0%5D%5Bpers_xdv%5D="&pers_xdv&"&b%5B0%5D%5Bperi_ccod%5D="&peri_ccod&"&b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Buniv_ccod%5D="&univ_ccod&"&b%5B0%5D%5Bpers_ncorr="&pers_ncorr&""
				  							f_botonera.DibujaBoton("volver")%></div></td>
				  <td><div align="center"><%f_botonera.DibujaBoton("guardar_proceso")%></div></td>
                  </tr>
              </table>
             </td>
            <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	 <%buscar=""%>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>