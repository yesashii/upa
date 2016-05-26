<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
paie_ncorr =Request.QueryString("paie_ncorr")
pers_nrut=Request.QueryString("pers_nrut")
pers_ncorr=Request.QueryString("pers_ncorr")
pers_xdv=Request.QueryString("pers_xdv")
pais_ccod=Request.QueryString("pais_ccod")
ciex_ccod=Request.QueryString("ciex_ccod")
univ_ccod=Request.QueryString("univ_ccod")
peri_ccod=Request.QueryString("peri_ccod")
pers_tpasaporte=Request.QueryString("pers_tpasaporte")
 pais_tdesc=Request.QueryString("pais_tdesc")
 ciex_tdesc=Request.QueryString("ciex_tdesc")
 univ_tdesc=Request.QueryString("univ_tdesc")
 tici_ccod=Request.QueryString("tici_ccod")
 carrera =Request.QueryString("carrera")

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
f_botonera.Carga_Parametros "alumnos_intercambio_extranjero.xml", "botonera"

set f_dato_alumno = new CFormulario
f_dato_alumno.Carga_Parametros "alumnos_intercambio_extranjero.xml", "datos"
f_dato_alumno.Inicializar conexion

if tici_ccod = "" then

sql_descuentos="select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,peri_tdesc,c.peri_ccod,"& vbCrLf &_
 "pais_tdesc,ciex_tdesc,univ_tdesc"& vbCrLf &_
"from personas_postulante a,rrii_postulacion_alumnos_intercambio_extranjero c,universidad_ciudad d,universidades e,ciudades_extranjeras g, paises f,periodos_academicos h"& vbCrLf &_
"where a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"and c.unci_ncorr=d.unci_ncorr"& vbCrLf &_
"and d.univ_ccod=e.univ_ccod"& vbCrLf &_
"and d.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and g.pais_ccod=f.PAIS_CCOD"& vbCrLf &_
"and c.peri_ccod=h.peri_ccod"& vbCrLf &_
"and c.paie_ncorr="&paie_ncorr&""		
'response.Write("<pre>"&sql_descuentos&"</pre>")	
else 

sql_descuentos="select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,peri_tdesc,sa.univ_ccod as univ_tdesc,p.pais_tdesc,ciex_tdesc"& vbCrLf &_
"from personas_postulante a,rrii_postulacion_alumnos_intercambio_extranjero c,periodos_academicos h,rrii_datos_study_abroad sa,paises p,ciudades_extranjeras g"& vbCrLf &_
"where a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"and c.peri_ccod=h.peri_ccod"& vbCrLf &_
"and c.paie_ncorr = sa.paie_ncorr"& vbCrLf &_
"and sa.pais_ccod = p.PAIS_CCOD"& vbCrLf &_
"and sa.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and c.paie_ncorr="&paie_ncorr&""

end if

f_dato_alumno.Consultar sql_descuentos
f_dato_alumno.siguiente

tiene_documentacion= conexion.ConsultaUno("select count(*) from rrii_documentacion_intercambio_extranjero where paie_ncorr="&paie_ncorr&"")

'response.Write("<pre>tiene_documentacion==="&tiene_documentacion&"</pre>")
'tiene_documentacion="1"
set f_proceso = new CFormulario
f_proceso.Carga_Parametros "alumnos_intercambio_extranjero.xml", "muestra_proceso"
f_proceso.Inicializar conexion
if tiene_documentacion<>"0" then
sql_descuentos="select a.paie_ncorr,tdin_ccod,doie_ncorr,unci_ncorr,pers_ncorr,carr_ccod,espi_ccod,peri_ccod,"& vbCrLf &_
				"protic.trunc(paie_finscripcion)as paie_finscripcion,"& vbCrLf &_
				"protic.trunc(doie_fenvio_memo_esc)as doie_fenvio_memo_esc,"& vbCrLf &_
				"protic.trunc(doie_frespuesta_escuela)as doie_frespuesta_escuela,"& vbCrLf &_
				"doie_respuesta_escuela,"& vbCrLf &_
				"doie_tcomentario_respuesta_esc,"& vbCrLf &_
				"protic.trunc(doie_fenvio_ramos)as doie_fenvio_ramos,"& vbCrLf &_
				"protic.trunc(doie_fenvio_carta_acep)as doie_fenvio_carta_acep,"& vbCrLf &_
				"protic.trunc(doie_frecepcion_carga_acad)as doie_frecepcion_carga_acad,"& vbCrLf &_
				"doie_fbienvenida,"& vbCrLf &_
				"doie_tcomentario_memo_esc,"& vbCrLf &_
				"doie_tcomentario_carta_acep,"& vbCrLf &_
				"doie_tcomentario_recep_carg_acad,"& vbCrLf &_
				"doie_fdocument,doie_med_compania,doie_med_poliza,doie_med_telefono,"& vbCrLf &_
				"doie_tcomentario_document,"& vbCrLf &_
				"doie_tcomentario_fbienvenida,"& vbCrLf &_
				"doie_resp_rrii"& vbCrLf &_					
				"from rrii_postulacion_alumnos_intercambio_extranjero a,rrii_documentacion_intercambio_extranjero b"& vbCrLf &_
				"where a.paie_ncorr=b.paie_ncorr"& vbCrLf &_
				"and a.paie_ncorr="&paie_ncorr&""
else

sql_descuentos="select ''"

end if
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()

f_proceso.Consultar sql_descuentos
f_proceso.siguiente
univ = f_dato_alumno.ObtenerValor("univ_tdesc")

documento = f_proceso.ObtenerValor("doie_fdocument")
if documento="SI" then
doc_select_si="selected"
end if
if documento="NO" then
doc_select_no="selected"
end if

escuela = f_proceso.ObtenerValor("doie_respuesta_escuela")
if escuela="SI" then
es_select_si="selected"
end if
if escuela="NO" then
es_select_no="selected"
end if

bienvenido = f_proceso.ObtenerValor("doie_fbienvenida")
if bienvenido="SI" then
bie_select_si="selected"
end if
if escuela="NO" then
bie_select_no="selected"
end if

pers_ncorr = f_proceso.obtenervalor("pers_ncorr")
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

function abre_ventana_mensaje2(){
	window.open("impresion_ficha_antecedentes_extranjeros.asp?pers_ncorr=<%=pers_ncorr%>&univ_tdesc=<%=univ%>", "")
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
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
									<td width="30%"><strong>Periodo Acad&eacute;mico Intercambio </strong></td>
							      <td width="70%"><%f_dato_alumno.DibujaCampo("peri_tdesc")%></td>
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
									<td width="5%"><strong>Carrera</strong></td>
									<td width="40%"><%=carrera%></td>
								</tr>
							</table>
                            <table>
                            	<tr> 
                                <td><%f_botonera.DibujaBoton("informacion_alumno_extranjero")%></td>
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
						 <input type="hidden" name="a[0][doie_ncorr]" value="<%=f_proceso.ObtenerValor("doie_ncorr")%>">
						  <input type="hidden" name="a[0][paie_ncorr]" value="<%=paie_ncorr%>">
						  <input type="hidden" name="peri_ccod" value="<%=peri_ccod%>">
						  <input type="hidden" name="pais_ccod" value="<%=pais_ccod%>">
						 <input type="hidden" name="ciex_ccod" value="<%=ciex_ccod%>">
						 <input type="hidden" name="univ_ccod" value="<%=univ_ccod%>">
						 <input type="hidden" name="pers_nrut" value="<%=pers_nrut%>">
						 <input type="hidden" name="pers_xdv" value="<%=pers_xdv%>">
						 <input type="hidden" name="pers_tpasaporte" value="<%=pers_tpasaporte%>">
                         <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                         <tr>
								<td><%pagina.DibujarSubtitulo "Seguro Medico"%>
                         		 <br/>
								 <hr/>
                                 <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="12%" align="left">Compañia : </td>
                                      <td width="31%" valign="bottom"><%f_proceso.DibujaCampo("doie_med_compania")%></td>
                                      <td width="13%" align="left">Póliza : </td>
                                      <td width="44%"><%f_proceso.DibujaCampo("doie_med_poliza")%></td>
                                    </tr>
									<tr>
                                      <td colspan="4">&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td>Teléfono:</td>
                                      <td valign="bottom" colspan="3"><%f_proceso.DibujaCampo("doie_med_telefono")%></td>
                                    </tr>
                                  </table>
                                 </td>
                          </tr>       
                         
                         </table>
                         
                         
                         
							<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
							  <tr> <br/> <br/>
								<td><%pagina.DibujarSubtitulo "Documentos"%>
								  <br/>
								  <hr/>
								  <table width="98%"  border="0" align="center">
                                    <tr>
                                      <td width="12%" align="left">Fecha Inscripción : </td>
                                      <td width="31%" valign="bottom"><%f_proceso.DibujaCampo("paie_finscripcion")%></td>
                                      <td width="13%" align="left">Duración Intercambio : </td>
                                      <td width="44%"><%f_proceso.DibujaCampo("tdin_ccod")%></td>
                                    </tr>
									<tr>
                                      <td colspan="4">&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td>Estado General:</td>
                                      <td valign="bottom" colspan="3"><%f_proceso.DibujaCampo("espi_ccod")%></td>
                                    </tr>
                                  </table>
								 <br/><hr/>
								    <h1 style="font-size:9px">&nbsp;&nbsp;Recepci&oacute;n de Documentos</h1>
								    <table width="98%"  border="0" align="center">
									  <tr>
										 <td width="17%" align="left" valign="top">Documentos: </td>
										  <td width="15%" valign="top">
											  <select name="a[0][doie_fdocument]" >
													<option value=" ">Seleccione</option>
													<option value="NO" <%=doc_select_no%>>No</option>
													<option value="SI" <%=doc_select_si%>>Si</option>
											</select>										</td>
										<td width="13%" align="right" valign="top">Comentario : </td>
									    <td width="55%" valign="top"><textarea name="a[0][doie_tcomentario_document]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("doie_tcomentario_document")%></textarea></td>										
									 </tr>
								  </table> 								  
								  <br/><hr/>
								  <h1 style="font-size:9px">&nbsp;&nbsp;Env&iacute;o Memo Escuela </h1>
								  <table width="98%"  border="0" align="center">
									  <tr>
										 <td width="19%" valign="top" align="left">Fecha Env&iacute;o : </td>
							             <td width="14%" valign="top" align="left"><%f_proceso.DibujaCampo("doie_fenvio_memo_esc")%></td>
										  <td width="13%" valign="top" align="left">Comentario :</td>
										  <td width="54%" valign="bottom" align="left"><textarea name="a[0][doie_tcomentario_memo_esc]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("doie_tcomentario_memo_esc")%></textarea></td>
									  </tr>
								  </table>
								  <h1 style="font-size:9px">&nbsp;&nbsp;Respuesta Escuela</h1>
								  <table width="98%"  border="0" align="center">
									  <tr>
										 <td width="19%" valign="top" align="left">Fecha Respuesta :</td>
								        <td width="14%" valign="top"><%f_proceso.DibujaCampo("doie_frespuesta_escuela")%></td>
									    <td width="13%" valign="top">Comentarios :</td>
										<td width="54%" align="left" valign="top"><textarea name="a[0][doie_tcomentario_respuesta_esc]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("doie_tcomentario_respuesta_esc")%></textarea></td>
								     </tr>
								  </table><table width="98%"  border="0" align="center">
									  <tr>
										 <td width="19%" valign="top" align="left">Respuesta :</td>
								        <td width="15%" align="right" valign="top"><select name="a[0][doie_respuesta_escuela]">
								          <option value=" ">Seleccione</option>
								          <option value="NO" <%=es_select_no%>>No</option>
								          <option value="SI" <%=es_select_si%>>Si</option>
							            </select></td>
									    <td width="41%" valign="top">&nbsp;</td>
										<td width="25%" align="left" valign="top">&nbsp;</td>
								    </tr>
								  </table>
								  <br/><hr/>
								  <h1 style="font-size:9px">&nbsp;&nbsp;Env&iacute;o de Ramos </h1>
								  <table width="98%"  border="0" align="center">
									  <tr>
										 <td width="19%" align="left">Fecha Env&iacute;o : </td>
							             <td width="81%" valign="bottom" align="left"><%f_proceso.DibujaCampo("doie_fenvio_ramos")%></td>
									 </tr>
								  </table>
								  <br/><hr/>
								  <h1 style="font-size:9px">&nbsp;&nbsp;Env&iacute;o de Carta Aceptaci&oacute;n Extranjero</h1>
								  <table width="98%"  border="0" align="center">
									  <tr>
										 <td width="19%" align="left" valign="top">Fecha Env&iacute;o : </td>
							            <td width="14%" valign="top"><%f_proceso.DibujaCampo("doie_fenvio_carta_acep")%></td>
										<td width="14%" align="right" valign="top">Comentario : </td>
									    <td width="53%" valign="top"><textarea name="a[0][doie_tcomentario_carta_acep]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("doie_tcomentario_carta_acep")%></textarea></td>
									 </tr>
								  </table>
								  <br/><hr/>
								    <h1 style="font-size:9px">&nbsp;&nbsp;Recepci&oacute;n Carga Acad&eacute;mica  </h1>
							      <table width="98%"  border="0" align="center">
									  <tr>
										 <td width="19%" valign="top"align="left">Fecha de Recepci&oacute;n: </td>
						                <td width="14%" valign="top"><%f_proceso.DibujaCampo("doie_frecepcion_carga_acad")%></td>
										<td width="13%" align="right" valign="top">Comentario : </td>
									    <td width="54%" valign="top"><textarea name="a[0][doie_tcomentario_recep_carg_acad]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("doie_tcomentario_recep_carg_acad")%></textarea></td>
									 </tr>
								  </table>
								  <br/><hr/>
								    <h1 style="font-size:9px">&nbsp;&nbsp;Bienvenida</h1>
							      <table width="98%"  border="0" align="center">
									  <tr>
										 <td width="17%" align="left" valign="top">Bienvenida: </td>
										  <td width="16%" valign="top">
											  <select name="a[0][doie_fbienvenida]">
													<option value=" ">Seleccione</option>
													<option value="NO" <%=bie_select_no%>>No</option>
													<option value="SI" <%=bie_select_si%>>Si</option>
											</select>										</td>
										<td width="13%" align="right" valign="top">Comentario : </td>
									    <td width="54%" valign="top"><textarea name="a[0][doie_tcomentario_fbienvenida]" rows="5" style="width:250"><%=f_proceso.ObtenerValor("doie_tcomentario_fbienvenida")%></textarea></td>										
									 </tr>
								  </table>
								  <br/><hr/>								
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
            <td width="20%" height="20"><div align="center">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.AgregaBotonParam "volver", "url", "seguimiento_alumnos_intercambio_extranjero.asp?buscar=&b%5B0%5D%5Bpers_nrut%5D="&rut&"&b%5B0%5D%5Bpers_xdv%5D="&pers_xdv&"&b%5B0%5D%5Bperi_ccod%5D="&peri_ccod&"&b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Buniv_ccod%5D="&univ_ccod&"&b%5B0%5D%5Bpers_ncorr="&pers_ncorr&"&tici_ccod="&tici_ccod&""
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