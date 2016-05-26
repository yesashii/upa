<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pais_ccod =Request.QueryString("b[0][pais_ccod]")
ciex_ccod = Request.QueryString("b[0][ciex_ccod]")
univ_ccod =Request.QueryString("b[0][univ_ccod]")
unci_ncorr=Request.QueryString("b[0][unci_ncorr]")
'q_anos_ccod= request.QueryString("b[0][anos_ccod]")

daco_ncorr =Request.QueryString("b[0][daco_ncorr]")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Convenios Internacionales"

'---------------------------------------------------------------------------------------------------
set errores = new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "convenios_rrii.xml", "botonera"



'------------------------------------PAISES---------------------------------------------------------------
set f_pais = new CFormulario
f_pais.Carga_Parametros "convenios_rrii.xml", "convenio"
f_pais.Inicializar conexion

if daco_ncorr="" then
consulta="select ''"
else
consulta="select a.daco_ncorr,univ_tdesc,"& vbCrLf &_
 "ciex_tdesc,"& vbCrLf &_
 "pais_tdesc,"& vbCrLf &_
 "daco_tweb as web,"& vbCrLf &_
 "protic.obtener_carreras_convenio_rrii(a.daco_ncorr)as carreras_convenio,"& vbCrLf &_
 "protic.trunc(daco_flimite_pos_sem1_upa)as flimite_post_sem1_upa,"& vbCrLf &_
 "protic.trunc(daco_flimite_pos_sem1)as flimite_post_sem1,"& vbCrLf &_
 "protic.trunc(daco_fini_clase_sem1)as fini_clase_sem1,"& vbCrLf &_
 "protic.trunc(daco_ffin_clase_sem1)as ffin_clase_sem1,"& vbCrLf &_
 "protic.trunc(daco_flimite_pos_sem2_upa) as flimite_post_sem2_upa,"& vbCrLf &_
 "protic.trunc(daco_flimite_pos_sem2)as flimite_post_sem2,"& vbCrLf &_
 "protic.trunc(daco_fini_clase_sem2)as fini_clase_sem2,"& vbCrLf &_
 "protic.trunc(daco_ffin_clase_sem2)as ffin_clase_sem2,"& vbCrLf &_
 "protic.trunc(daco_fconvenio_ini)as daco_fconvenio_ini,"& vbCrLf &_
 "protic.trunc(daco_fconvenio_fin)as daco_fconvenio_fin,"& vbCrLf &_ 
 "daco_ttest_idioma as test_idioma,"& vbCrLf &_
 "daco_tescala_avalu as escala,"& vbCrLf &_
 "daco_ncupo as cupo,"& vbCrLf &_
 "daco_tcomentario_cupo,"& vbCrLf &_
 "daco_tramos_cursar as asig,"& vbCrLf &_
 "anos_ccod,a.idio_ccod,daco_alojamiento_comentario,daco_alojamiento,daco_tcomentario_gral "& vbCrLf &_
 "from datos_convenio a,"& vbCrLf &_
 "universidad_ciudad b,"& vbCrLf &_
 "universidades c,"& vbCrLf &_
 "ciudades_extranjeras d,"& vbCrLf &_
 "paises e,"& vbCrLf &_
 "idioma f"& vbCrLf &_
 "where a.unci_ncorr=b.unci_ncorr"& vbCrLf &_
 "and b.univ_ccod=c.univ_ccod"& vbCrLf &_
 "and b.ciex_ccod=d.ciex_ccod"& vbCrLf &_
 "and d.pais_ccod=e.PAIS_CCOD"& vbCrLf &_
 "and a.idio_ccod=f.idio_ccod"& vbCrLf &_
 "and a.daco_ncorr="&daco_ncorr&""
end if
'response.Write(consulta)

f_pais.Consultar consulta
f_pais.Siguiente
f_pais.AgregaCampoCons "pais_ccod", pais_ccod
f_pais.AgregaCampoCons "univ_ccod", univ_ccod

'------------------------------------CIUDADES EXTRANJERAS---------------------------------------------------------------
set f_ciudades_extranjeras = new CFormulario
f_ciudades_extranjeras.Carga_Parametros "convenios_rrii.xml", "ciudad_extranjera"
f_ciudades_extranjeras.Inicializar conexion

if pais_ccod<>"" then
 consulta_ciu="select ciex_ccod,ciex_tdesc from ciudades_extranjeras where pais_ccod="&pais_ccod&""
else
 consulta_ciu="select ''"
end if
f_ciudades_extranjeras.Consultar consulta_ciu


'------------------------------------UNIVERSIDADES EXTRANJERAS---------------------------------------------------------------
set f_universidades_extranjeras = new CFormulario
f_universidades_extranjeras.Carga_Parametros "convenios_rrii.xml", "universidades_extranjeras"
f_universidades_extranjeras.Inicializar conexion

if pais_ccod<>"" and ciex_ccod<>"" then
 consulta_uni="select b.univ_ccod,univ_tdesc from universidad_ciudad a, universidades b where a.univ_ccod=b.univ_ccod and ciex_ccod="&ciex_ccod&""
else
 consulta_uni="select ''"
end if
f_universidades_extranjeras.Consultar consulta_uni



set f_cheques = new CFormulario
f_cheques.Carga_Parametros "becas.xml", "cheques"
f_cheques.Inicializar conexion

sql_descuentos="select ''"				
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_cheques.Consultar sql_descuentos

aloja = f_pais.ObtenerValor("daco_alojamiento")
if aloja="SI" then
alo_select_si="selected"
end if
if aloja="NO" then
alo_select_no="selected"
end if

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

function cambiar_pais()
{
		document.convenio.elements["b[0][ciex_ccod]"].value=''
		document.convenio.action ='agrega_convenio.asp';
		document.convenio.method = "get";
		document.convenio.submit();
	

}

function alcargar()
{
ciex_ccod='<%=ciex_ccod%>'
univ_ccod='<%=univ_ccod%>'
daco_ncorr='<%=daco_ncorr%>'
	if (ciex_ccod!="")
	{
		document.convenio.elements["b[0][ciex_ccod]"].value=ciex_ccod
	}
	document.convenio.elements["b[0][ciex_ccod]"].disabled=true	
	document.convenio.elements["b[0][pais_ccod]"].disabled=true	
	document.convenio.elements["b[0][univ_ccod]"].disabled=true	
	if (daco_ncorr!="")
	{
		document.convenio.elements["b[0][anos_ccod]"].disabled=true	
	}
	else
	{
		document.convenio.elements["b[0][anos_ccod]"].disabled=false	
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
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
		 
          <tr>
            <td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				  	<td width="6" ><img src="../imagenes/izq2.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo2.gif" >
					   <div align="center"><font color="#333333" face="Verdana, Arial, Helvetica, sans-serif">1)  Ubicación</font></div></td>
					<td width="6"><img src="../imagenes/der2.gif" width="6" height="17" ></td>
				  
					<td width="6" ><img src="../imagenes/izq_1.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo1.gif" >
					   <div align="center"><font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif">2)  Datos del Convenio</font></div></td>
					<td width="6"><img src="../imagenes/derech1.gif" width="6" height="17" ></td>
					
					<td width="6"><img src="../imagenes/izq2.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo2.gif">
					   <div align="center"><font color="#333333" face="Verdana, Arial, Helvetica, sans-serif">3)  Datos Representantes </font></div></td>
					<td width="6"><img src="../imagenes/der2.gif" width="6" height="17" ></td>
					
					<td width="6" ><img src="../imagenes/izq2.gif" width="6" height="17"></td>
					<td valign="middle" nowrap background="../imagenes/fondo2.gif">
					   <div align="center"><font color="#333333" face="Verdana, Arial, Helvetica, sans-serif">4)  Carreras en Convenio</font></div></td>
					<td width="6"><img src="../imagenes/der2.gif" width="6" height="17" ></td>
					<td width="100%" bgcolor="#D8D8DE">
				  </tr>
				</table>
			</td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
				 <form name="convenio">
				 <input type="hidden" name="b[0][ciex]" value="<%=ciex_ccod%>" />
				 <input type="hidden" name="b[0][pais]" value="<%=pais_ccod%>"/>
				 <input type="hidden" name="b[0][unci]" value="<%=unci_ncorr%>"/>
				 <input type="hidden" name="b[0][univ]" value="<%=univ_ccod%>"/>
				  <input type="hidden" name="b[0][daco_ncorr]" value="<%=f_pais.ObtenerValor("daco_ncorr")%>"/>
				 	<table align="center" width="100%">
						<tr>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td align="right">&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
					  </tr>
						<tr>
							<td width="4%"><strong>Pais:</strong></td>
						  <td width="13%"><%f_pais.DibujaCampo("pais_ccod")%> </td>
							<td width="7%" align="right"><strong>Ciudad:</strong></td>
							<td width="19%">
								<select name="b[0][ciex_ccod]" id="TO-N">
						   <% if pais_ccod<>"" then
						  	while f_ciudades_extranjeras.siguiente%>
						  	<option value="<%=f_ciudades_extranjeras.ObtenerValor("ciex_ccod")%>"><%=f_ciudades_extranjeras.ObtenerValor("ciex_tdesc")%></option>
						  	<%wend
						     end if%>
								</select>
						  </td>
						  <td width="22%"><strong>Periodo Acad&eacute;mico:</strong></td>
						  <td width="35%"><%f_pais.DibujaCampo("anos_ccod")%></td>
							
					  </tr>
					</table>
					<table width="100%">
						<tr>
							<td width="12%"><strong>Universidad:</strong></td>
							<td width="88%"><%f_pais.DibujaCampo("univ_ccod")%></td>
						</tr>
					</table>
					<table width="100%">
						<tr>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
					  </tr>
						<tr>
							<td width="12%"><strong>Página Web:</strong></td>
							<td width="88%"><%f_pais.DibujaCampo("web")%></td>
					  </tr>
					</table>
				  <table width="99%">
						<tr>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
						  <td>&nbsp;</td>
					  </tr>
						<tr>
							<td width="6%" height="33"><strong>Cupo:</strong></td>
							<td width="13%" height="33"><%f_pais.DibujaCampo("cupo")%></td>
						 <td width="12%"><strong>Alojamiento:</strong></td>
						  <td width="17%" height="33"><select name="b[0][daco_alojamiento]">
						    <option value=" ">Seleccione</option>
						    <option value="NO" <%=alo_select_no%>>No</option>
						    <option value="SI" <%=alo_select_si%>>Si</option>
					      </select></td>
						  <td width="23%"><strong>Comentario alojamiento:</strong></td>
							<td width="29%">&nbsp;
						    <textarea name="b[0][daco_alojamiento_comentario]" rows="2" cols="29"><%=f_pais.ObtenerValor("daco_alojamiento_comentario")%></textarea></td>
                      </tr>
					</table>
					<table width="100%">
						<tr>
						  <td valign="top">&nbsp;</td>
						  <td>&nbsp;</td>
					  </tr>
						<tr>
							<td width="18%" valign="top"><strong>Comentario Cupo:</strong></td>
						  <td width="82%"><textarea name="b[0][daco_tcomentario_cupo]" id="TO-S" rows="5" cols="80"><%=f_pais.ObtenerValor("daco_tcomentario_cupo")%></textarea></td>
					  </tr>
					</table>
					<table width="100%">
						<tr>
							<td width="18%" valign="top"><strong>Máximo de Asignaturas a cursar:</strong></td>
						  <td width="82%" valign="top"><textarea name="b[0][asig]" id="TO-S" rows="5" cols="80"><%=f_pais.ObtenerValor("asig")%></textarea></td>
					  </tr>
					</table>
					<table width="100%">
						<tr>
							<td width="18%" valign="top"><strong>Escala de Evaluación:</strong></td>
						  <td width="82%"><textarea name="b[0][escala]" id="TO-S" rows="5" cols="80"><%=f_pais.ObtenerValor("escala")%></textarea></td>
						</tr>
					</table>
					<table align="center" width="100%">                    
                   		<tr>
                   		  <td align="left">&nbsp;</td>
                   		  <td>&nbsp;</td>
                   		  <td>&nbsp;</td>
                   		  <td>&nbsp;</td>
               		  </tr>
                   		<tr>
                   		  <td align="left">&nbsp;</td>
                   		  <td><strong>dd/mm/aaaa</strong></td>
                   		  <td>&nbsp;</td>
                   		  <td><strong>dd/mm/aaaa</strong></td>
               		  </tr>
                   		<tr>
							<td width="27%" align="left"><strong>Fecha limite de Postulacion 1 semestre UPA:</strong> </td>
							<td width="22%"><%f_pais.DibujaCampo("flimite_post_sem1_upa")%></td>
							<td width="27%"><strong>Fecha limite de Postulacion 2 semestre UPA:</strong></td>
							<td width="24%"><%f_pais.DibujaCampo("flimite_post_sem2_upa")%></td>
					  </tr>
							<tr>
							<td width="27%" align="left">&nbsp;</td>
							<td width="22%">&nbsp;</td>
							<td width="27%">&nbsp;</td>
							<td width="24%">&nbsp;</td>
							</tr>
							<tr>
							<td width="27%" height="29" align="left"><strong>Fecha limite de Postulacion 1 semestre: </strong></td>
							<td width="22%"><%f_pais.DibujaCampo("flimite_post_sem1")%></td>
							<td width="27%"><strong>Fecha  limite de Postulacion 2 semestre:</strong></td>
							<td width="24%"><%f_pais.DibujaCampo("flimite_post_sem2")%></td>
							</tr>
							<tr>
							<td width="27%" align="left">&nbsp;</td>
							<td width="22%">&nbsp;</td>
							<td width="27%">&nbsp;</td>
							<td width="24%">&nbsp;</td>
							</tr>
							<tr>
							<td width="27%" align="left"><strong>Fecha de Inicio de Clases 1 semestre:</strong></td>
							<td width="22%"><%f_pais.DibujaCampo("fini_clase_sem1")%></td>
							<td width="27%"><strong>Fecha de Inicio de Clases 2 semestre: </strong></td>
							<td width="24%"><%f_pais.DibujaCampo("fini_clase_sem2")%></td>
							</tr>
							<tr>
							<td width="27%" align="left">&nbsp;</td>
							<td width="22%">&nbsp;</td>
							<td width="27%">&nbsp;</td>
							<td width="24%">&nbsp;</td>
							</tr>
							<tr>
							<td width="27%" align="left"><strong>Fecha de Termino de Clases 1 semestre:</strong></td>
							<td width="22%"><%f_pais.DibujaCampo("ffin_clase_sem1")%></td>
							<td width="27%"><strong>Fecha de Termino de Clases 2 semestre</strong>: </td>
							<td width="24%"><%f_pais.DibujaCampo("ffin_clase_sem2")%></td>
							</tr>
                            <tr>
                              <td align="left">&nbsp;</td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>                            
							
					</table>
					<table align="center" width="100%">
			  <tr>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    </tr>
			  <tr>
								<td width="17%"><strong>Idioma Necesario:</strong></td>
								<td width="83%"><strong>
							  <%f_pais.DibujaCampo("idio_ccod")%></strong></td>
					  </tr>
							<tr>
								<td valign="top"><strong>Test de Idioma:</strong></td>
								<td><textarea name="b[0][test_idioma]" id="TO-S" rows="5" cols="50"><%=f_pais.ObtenerValor("test_idioma")%></textarea></td>
							</tr>
                           
                            </table>
                            <table align="center" width="100%">                        		
                                <tr>
                                <td width="27%" align="left">&nbsp;</td>
                                <td width="22%">&nbsp;</td>
                                <td width="27%">&nbsp;</td>
                                <td width="24%">&nbsp;</td>
                                </tr>
                                <tr>
                                <td width="27%" align="left"><strong><em>FECHA DE CONVENIO</em></strong></td>
                                <td width="22%">&nbsp;</td>
                                <td width="27%">&nbsp;</td>
                                <td width="24%">&nbsp;</td>
                                </tr>
                                <tr>
                                <td width="27%" align="left"><strong>Inicio de Convenio:</strong></td>
                                <td width="22%"><%f_pais.DibujaCampo("daco_fconvenio_ini")%></td>
                                <td width="27%"><strong>Termino de Convenio</strong>: </td>
                                <td width="24%"><%f_pais.DibujaCampo("daco_fconvenio_fin")%></td>
                                </tr>
                        </table>
                           <table> 
                            <tr>
								<td valign="top"><strong>Comentarios Generales:</strong></td>
								<td><textarea name="b[0][daco_tcomentario_gral]" id="TO-S" rows="5" cols="50"><%=f_pais.ObtenerValor("daco_tcomentario_gral")%></textarea></td>
							</tr>
					</table>
				  </form>
			</td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				 <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>	
                  <td><div align="center">
					<%f_botonera.DibujaBoton"agregar_cconvenio"%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>

<script language="JavaScript">

if(document.convenio.elements["b[0][flimite_post_sem1_upa]"].value=='01/01/1900')
	document.convenio.elements["b[0][flimite_post_sem1_upa]"].value= '';	
	
if(document.convenio.elements["b[0][flimite_post_sem1]"].value=='01/01/1900')
	document.convenio.elements["b[0][flimite_post_sem1]"].value= '';
	
if(document.convenio.elements["b[0][fini_clase_sem1]"].value=='01/01/1900')
	document.convenio.elements["b[0][fini_clase_sem1]"].value= '';
	
if(document.convenio.elements["b[0][ffin_clase_sem1]"].value=='01/01/1900')
	document.convenio.elements["b[0][ffin_clase_sem1]"].value= '';	
	
if(document.convenio.elements["b[0][flimite_post_sem2_upa]"].value=='01/01/1900')
	document.convenio.elements["b[0][flimite_post_sem2_upa]"].value= '';
	
if(document.convenio.elements["b[0][flimite_post_sem2]"].value=='01/01/1900')
	document.convenio.elements["b[0][flimite_post_sem2]"].value= '';
	
if(document.convenio.elements["b[0][fini_clase_sem2]"].value=='01/01/1900')
	document.convenio.elements["b[0][fini_clase_sem2]"].value= '';
	
if(document.convenio.elements["b[0][ffin_clase_sem2]"].value=='01/01/1900')
	document.convenio.elements["b[0][ffin_clase_sem2]"].value= '';		
	
if(document.convenio.elements["b[0][daco_fconvenio_ini]"].value=='01/01/1900')
	document.convenio.elements["b[0][daco_fconvenio_ini]"].value= '';
	
if(document.convenio.elements["b[0][daco_fconvenio_fin]"].value=='01/01/1900')
	document.convenio.elements["b[0][daco_fconvenio_fin]"].value= '';	
</script>	