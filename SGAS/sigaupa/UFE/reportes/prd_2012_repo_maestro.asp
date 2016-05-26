<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Filtro Maestro"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo= negocio.obtenerPeriodoAcademico("POSTULACION")
sede= negocio.obtenerSede
usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
anos_ccod=conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "reporte_maestro.xml", "botonera"

'-----------------------------------------------------------------------
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
'carr_ccod = request.querystring("busqueda[0][carr_ccod]")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "reporte_maestro.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"

 consulta_carreras= "(select distinct ltrim(rtrim(cast(c.carr_ccod as varchar))) as carr_ccod, carr_tdesc " & vbCrLf &_
				    " from ofertas_Academicas a, especialidades b,carreras c, periodos_Academicos d " & vbCrLf &_
				    " where a.espe_ccod=b.espe_ccod and carr_tdesc<>'ACTIVIDADES ACADEMICAS COMPLEMENTARIAS' and carr_tdesc<>'ACTIVIDADES DIRECCION DE DOCENCIA' and tcar_ccod=1" & vbCrLf &_
				    " and b.espe_ccod in ( " & vbCrLf &_
				    "                    Select b.espe_ccod " & vbCrLf &_
				    "                    from alumnos aa, ofertas_Academicas bb, especialidades cc " & vbCrLf &_
					"                    where aa.ofer_ncorr=bb.ofer_ncorr and bb.espe_ccod=cc.espe_ccod  and emat_ccod=1 group by b.espe_ccod) " & vbCrLf &_
					" and b.carr_ccod=c.carr_ccod " & vbCrLf &_
					" --and cast(d.anos_ccod as varchar) ='"&anos_ccod&"' " & vbCrLf &_
					" and a.peri_ccod = d.peri_ccod " & vbCrLf &_
				    " /*and cast(a.sede_ccod as varchar)='"&sede&"'*/)d "					
' response.Write(consulta_carreras)					
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
 f_busqueda.AgregaCampoParam "carr_ccod", "destino",consulta_carreras 
 f_busqueda.AgregaCampoParam "peri_ccod", "destino","(select peri_ccod,peri_tdesc from periodos_academicos where cast(anos_ccod as varchar)>'2005') a" 
 f_busqueda.AgregaCampoParam "aran_nano_ingreso", "destino","(select distinct aran_nano_ingreso from ofertas_academicas a, periodos_academicos b, aranceles c where a.peri_ccod = b.peri_ccod and cast(b.anos_ccod as varchar)='"&anos_ccod&"' and a.aran_ncorr = c.aran_ncorr and isnull(aran_nano_ingreso,0)<>0 ) a" 
 f_busqueda.AgregaCampoParam "post_nano_paa", "destino","(select distinct post_nano_paa from postulantes a, periodos_Academicos b where a.peri_ccod=b.peri_ccod and cast(b.anos_ccod as varchar)='"&anos_ccod&"' and isnull(post_nano_paa,1) <> 1 ) a" 
 f_busqueda.Siguiente


'---------------------------------------------------------------------------------------------------

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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript" src="jquery-1.6.4.min.js"></script>

<script language="JavaScript">
function cliquearTodo()
{
	form=document.buscador
	nro = form.elements.length;
   	num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = form.elements[i];
	  str  = form.elements[i].name;
	  if((comp.type == 'checkbox')&&(comp.name!="_busqueda[0][escae]")&&(comp.name!="_busqueda[0][noescae]")&&(comp.name!="_busqueda[0][beca_mineduc]")&&(comp.name!="_busqueda[0][nobeca_mineduc]") ){
	     comp.checked=true
	  }
	}
}
function descliquearTodo()
{
	form=document.buscador
	nro = form.elements.length;
   	num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = form.elements[i];
	  str  = form.elements[i].name;
	  if((comp.type == 'checkbox')&&(comp.name!="_busqueda[0][escae]")&&(comp.name!="_busqueda[0][noescae]")&&(comp.name!="_busqueda[0][beca_mineduc]")&&(comp.name!="_busqueda[0][nobeca_mineduc]") ){
	   //  alert(comp.name)
		 comp.checked=false
	  }
	}
}

function bloquea_taca()
{
	if(document.buscador.elements('_busqueda[0][escae]').checked)
	{
		document.buscador.elements('busqueda[0][taca_ccod]').disabled=false;
		document.buscador.elements('_busqueda[0][noescae]').disabled=true;
		ManejaChebox('busqueda[0][banco]','S')
		ManejaChebox('busqueda[0][tipo_alumno_cae]','S')
		
		$("#trrr").slideDown()
	}
	else
	{
		document.buscador.elements('busqueda[0][taca_ccod]').disabled=true;
		document.buscador.elements('_busqueda[0][noescae]').disabled=false;
		ManejaChebox('busqueda[0][banco]','N')
		ManejaChebox('busqueda[0][tipo_alumno_cae]','N')
		$("#trrr").slideUp()

	}
}

function bloquea_tdet()
{
	if(document.buscador.elements('_busqueda[0][beca_mineduc]').checked)
	{
		document.buscador.elements('busqueda[0][tdet_ccod]').disabled=false;
		document.buscador.elements('busqueda[0][nobeca_mineduc]').disabled=true;
		ManejaChebox('busqueda[0][monto_beca_mineduc]','S')
		ManejaChebox('busqueda[0][ano_adjudicacion_beca]','S')
		

		$("#trrr2").slideDown()
		
	}
	else
	{
		document.buscador.elements('busqueda[0][tdet_ccod]').disabled=true;
		document.buscador.elements('busqueda[0][nobeca_mineduc]').disabled=false;
		ManejaChebox('busqueda[0][monto_beca_mineduc]','N')
		ManejaChebox('busqueda[0][ano_adjudicacion_beca]','N')
		

		$("#trrr2").slideUp()
	}
}

function bloquea_escae()
{
	if(document.buscador.elements('_busqueda[0][noescae]').checked)
	{
		document.buscador.elements('_busqueda[0][escae]').disabled=true;
	}
	else
	{
		document.buscador.elements('_busqueda[0][escae]').disabled=false;
	}
}

function bloquea_beca_mineduc()
{
	if(document.buscador.elements('_busqueda[0][nobeca_mineduc]').checked)
	{
		document.buscador.elements('_busqueda[0][beca_mineduc]').disabled=true;
	}
	else
	{
		document.buscador.elements('_busqueda[0][beca_mineduc]').disabled=false;
	}
}

function ManejaChebox(nom_ele,visible)
{
elemento1=nom_ele;
elemento2='_'+nom_ele
	
	if (visible='S')
	{
		document.buscador.elements(elemento1).disabled=false
		document.buscador.elements(elemento2).disabled=false
		document.buscador.elements(elemento2).checked=true
	}
	else
	{
		document.buscador.elements(elemento1).disabled=true
		document.buscador.elements(elemento2).disabled=true
		document.buscador.elements(elemento2).checked=false
	
	}

}


function bloquea_periodos(){
peri_desde=document.buscador.elements('busqueda[0][peri_ccod_desde]').value
peri_hasta=document.buscador.elements('busqueda[0][peri_ccod_hasta]').value

//alert(peri_desde+' '+peri_hasta)

	if ((peri_desde!="")||(peri_hasta!=""))
	{
		document.buscador.elements('busqueda[0][peri_ccod]').disabled=true
		document.buscador.elements('busqueda[0][peri_ccod_desde]').id="TO-N"
        document.buscador.elements('busqueda[0][peri_ccod_hasta]').id="TO-N"
	}else if ((peri_desde=="")&&(peri_hasta==""))
	{
		document.buscador.elements('busqueda[0][peri_ccod]').disabled=false
		document.buscador.elements('busqueda[0][peri_ccod_desde]').id="TO-S"
		document.buscador.elements('busqueda[0][peri_ccod_hasta]').id="TO-S"
	}

}
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Filtros Maestro</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; <BR>
                    <%pagina.DibujarTituloPagina%>
                  </div>
				  <form name="buscador">
				  <input type="hidden" name="usuario" value="<%=usuario%>" />
                  <table width="98%" >
                    <tr> 
                      <td width="100%">
                            <table width="100%" border="0">
                              <tr> 
							  	<td width="100%">
									<table width="100%" border="1">
										<tr>
										  <td width="9%">Tipo Alumno (Nuevo o Antiguo):</td>
										  <td width="4%"><%f_busqueda.dibujaCampo ("tipo_alumno")%></td>
											<td width="8%">Es Moroso:</td>
										  <td width="4%"><% f_busqueda.dibujaCampo ("esmoroso")%></td>
										  	<td width="6%">Email upa</td>
										  <td width="4%"><%f_busqueda.dibujaCampo ("emailupa")%></td>
											<td width="8%">A&ntilde;o ingreso carrera:</td>
										  <td width="4%"><%f_busqueda.dibujaCampo ("ano_ingreso")%></td>
										  <td width="17%">Facultad</td>
										  <td width="4%"><%f_busqueda.dibujaCampo ("facultad")%></td>
										<td width="11%">PSU Matematica</td>
										  <td width="4%"><%f_busqueda.dibujaCampo ("psu_matematica")%></td>
											<td width="11%">PSU Lenguaje</td>
										  <td width="4%"><%f_busqueda.dibujaCampo ("psu_lenguaje")%></td>
										</tr>
										<tr>  
											<td width="20%">PSU Promedio</td>
										  <td width="4%"><%f_busqueda.dibujaCampo ("psu_promedio")%></td>
										  <td width="17%">NEM (Nota Enseñanza Media)</td>
										  <td width="4%"><%f_busqueda.dibujaCampo ("nem")%></td>
										  <td width="10%">Direccion:</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("direccion")%></td>
										<td width="9%">Celular </td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("celular")%></td>
											<td width="12%">Telefono</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("telefono")%></td>
											<td width="12%">Region</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("region")%></td>
										  <td width="13%">Ciudad</td>
										    <td width="3%"><%f_busqueda.dibujaCampo ("ciudad")%></td>
										</tr>
										<tr>  
										  <td width="16%">Nombre Codeudor</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("codeudor")%></td>
										   <td width="16%">Nombre Codeudor</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("codeudor")%></td>
										   <td width="16%">Nombre Codeudor</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("codeudor")%></td>
										  <td width="9%">Codigo Carrera Min</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("codigo_carrera_mineduc")%></td>
										   <td width="9%">Codigo Carrera Ingresa</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("codigo_carrera_ingresa")%></td>
										  <td width="9%">Codigo Sede Min</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("codigo_sede_mineduc")%></td>
										   <td width="9%">Codigo Sede Ingresa</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("codigo_sede_ingresa")%></td>
										  
										</tr>
										<tr>
											<td width="9%">Modalidad Carrera Mineduc</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("ofam_nmodalidad_car")%></td>
										   <td width="9%">Version Carrera Mineduc</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("ofam_nversion_car")%></td>
										  <td width="9%">Nivel Estudio</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("nivel_estudio")%></td>
										  <td colspan="8">&nbsp;</td>
										</tr>
										<tr id="trrr" style="display:none" >
											<td width="9%">Banco </td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("banco")%></td>
										  <td width="9%">Rut Banco</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("rut_banco")%></td>
										  <td width="9%">Tipo Alumno CAE </td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("tipo_alumno_cae")%></td>
										  <td width="9%">Codigo Estado Renovante </td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("codigo_estado_renovante")%></td>
										  <td width="9%">A&ntilde;o Licitacion</td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("ano_licitacion")%></td>
										</tr>
										<tr id="trrr2" style="display:none" >
											<td width="9%">Monto Beneficio  </td>
										    <td width="5%"><%f_busqueda.dibujaCampo ("monto_beca_mineduc")%></td>
										  <td width="9%">A&ntilde;o Adjudicacion </td>
										  <td width="5%"><%f_busqueda.dibujaCampo ("ano_adjudicacion_beca")%></td>
										  
										</tr>
									</table>
								</td>
                              </tr>
                            </table>
					  </td>
                   </tr>
				   <tr>
				   	<td>
						<table>
							<tr>
								<td>
									<%'botonera.dibujaboton "sel_todo"%>
								</td>
								<td>
									<%'botonera.dibujaboton "desel_todo"%>
								</td>
							</tr>
						</table>
					 </td>
				   </tr>
                  </table> 
				  
				   <hr>
				   <br>
				  <table width="98%" border="0">
                    <tr> 
                      <td width="100%"><div align="center">
                            <table width="100%" border="1">
                              <tr> 
                                <td  colspan="3"><div align="center"><strong>Filtros adicionales de búsqueda</strong></div></td>
                              </tr>
							  <tr> 
                                <td width="33%"><div align="center"><strong>Carrera</strong></div></td>
                                <td width="33%"><div align="center"><strong>Periodo</strong></div></td>
                              </tr>
							  <tr> 
                                <td width="33%"><div align="center"><%  f_busqueda.dibujaCampo ("carr_ccod") %></div></td>
                                <td width="33%"><div align="center"><% f_busqueda.dibujaCampo ("peri_ccod") %></div></td>
                              </tr>
							  <tr>
							  	<td><div align="center"><strong>Desde</strong></div></td>
								<td><div align="center"><strong>Hasta</strong></div></td>
							  </tr>
							  <tr>
							  	<td width="33%"><div align="center"><%  f_busqueda.dibujaCampo ("peri_ccod_desde") %></div></td>
                                <td width="33%"><div align="center"><% f_busqueda.dibujaCampo ("peri_ccod_hasta") %></div></td>
							  </tr>
							  <tr> 
                                <td width="33%"><div align="center"><strong>Según año de ingreso</strong></div></td>
                                <td width="33%"><div align="center"><strong>Según Estado de Matricula</strong></div></td>
                              </tr>
							  <tr> 
                                <td width="33%"><div align="center"><% f_busqueda.dibujaCampo ("aran_nano_ingreso") %></div></td>
                                <td width="33%"><div align="center"><% f_busqueda.dibujaCampo ("emat_ccod") %></div></td>
                              </tr>
							   <tr> 
                                <td width="33%">
												<table width="100%" border="1">
													<tr>
														<td width="50%">
															<div align="center"><strong>No&nbsp;Tenga&nbsp;CAE</strong></div>
													    </td>
														<td width="50%">
															<div align="center"><strong>Tiene&nbsp;CAE</strong></div>
													  </td>
													</tr>
												</table>
								</td>
                                <td width="33%"><div align="center"><strong>Tipo Alumno CAE</strong></div></td>
                              </tr>
							  <tr> 
                                <td width="33%">
												<table width="100%"  border="1">
													<tr>
														<td>
															<div align="center"><% f_busqueda.dibujaCampo ("noescae") %></div>
														</td>
														<td>
															<div align="center"><% f_busqueda.dibujaCampo ("escae") %></div>
														</td>
													</tr>
												</table>
								</td>
                                <td width="33%"><div align="center"><% f_busqueda.dibujaCampo ("taca_ccod") %></div></td>
                              </tr>
							  <tr> 
                                <td width="33%">
												<table width="100%" border="1">
													<tr>
														<td width="50%">
															<div align="center"><strong>No&nbsp;Tiene&nbsp;Becas Mineduc</strong></div>
														</td>
														<td>
															<div align="center"><strong>Tiene&nbsp;Becas Mineduc</strong></div>
														</td>
													</tr>
												</table>
								 </td>
                                <td width="33%"><div align="center"><strong>Tipo&nbsp;Becas Mineduc</strong></div></td>
                              </tr>
							  <tr> 
                                <td width="33%">
												<table width="100%"  border="1">
													<tr>
														<td>
															<div align="center"><% f_busqueda.dibujaCampo ("nobeca_mineduc") %></div>
														</td>
														<td>
															<div align="center"><% f_busqueda.dibujaCampo ("beca_mineduc") %></div>
														</td>
													</tr>
												</table>
															
								</td>
                                <td width="33%"><div align="center"><% f_busqueda.dibujaCampo ("tdet_ccod") %></div></td>
                              </tr>
							 
							  <tr> 
                                <td  colspan="3"><div align="center">&nbsp;</div></td>
                              </tr>
							  
                            </table>
                          </div>
					  </td>
                   </tr>
                  </table> 
				  </form>
                  <br></td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="129" nowrap bgcolor="#D8D8DE"><table width="57%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="33%"><%botonera.agregabotonparam "excel", "url", "repo_maestro_excel.asp"
					                    'botonera.agregabotonparam "excel", "deshabilitado","true"
								  botonera.dibujaboton "excel"%></td>
                      <td width="34%">
                        <% botonera.agregabotonparam "lanzadera", "url", "../lanzadera/lanzadera.asp"
						botonera.dibujaboton "lanzadera"%>
                      </td>
					  <td width="33%">
                        <!--<a href="javascript:_Guardar(this, document.forms['buscador'], 'listado_matriculas_totales_rev.asp','', '', '', 'FALSE');">.</a>-->
                      </td>
                    </tr>
                  </table></td>
                  <td width="281" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>
    </td>
  </tr>  
</table>
</body>
</html>
