<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.QueryString
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'	next
'response.End()

q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_tdet_ccod =Request.QueryString("b[0][tdet_ccod]")
q_sede_ccod= request.QueryString("b[0][sede_ccod]")
daco_ncorr= request.QueryString("b[0][daco_ncorr]")
daco_ncorr2= request.QueryString("daco_ncorr")
debusqueda=request.QueryString("desdebusca")

pais_ccod=request.QueryString("pais_ccod")
ciex_ccod=request.QueryString("ciex_ccod")
univ_ccod=request.QueryString("univ_ccod")
carr_ccod=request.QueryString("carr_ccod")
ini_fecha1=request.QueryString("fecha_ini_1")
fin_fecha1=request.QueryString("fecha_fin_1")
ini_fecha2=request.QueryString("fecha_ini_2")
fin_fecha2=request.QueryString("fecha_fin_2")
ano_ccod=request.QueryString("anos_ccod")



if daco_ncorr="" then
daco_ncorr=daco_ncorr2
end if
if daco_ncorr="" then
daco_ncorr=request.Form("b[0][daco_ncorr]")
end if
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Becas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "becas.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "convenios_rrii.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "becas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "convenios_rrii.xml", "convenio_final"
f_cheques.Inicializar conexion


sql_descuentos= "select d.pais_ccod as pais_ccod2 ,b.ciex_ccod as ciex_ccod2,b.univ_ccod as univ_ccod2,a.unci_ncorr as unci_ncorr2,univ_tdesc,"& vbCrLf &_
 "ciex_tdesc,"& vbCrLf &_
 "pais_tdesc,"& vbCrLf &_
 "daco_tweb,isnull(protic.trunc(daco_fconvenio_ini),'') as daco_fconvenio_ini,protic.trunc(daco_fconvenio_fin) as daco_fconvenio_fin,"& vbCrLf &_
 "protic.obtener_carreras_convenio_rrii(a.daco_ncorr)as carreras_convenio,"& vbCrLf &_
 "protic.trunc(daco_flimite_pos_sem1_upa)as daco_flimite_pos_sem1_upa,"& vbCrLf &_
 "protic.trunc(daco_flimite_pos_sem1)as daco_flimite_pos_sem1,"& vbCrLf &_
 "protic.trunc(daco_fini_clase_sem1)as daco_fini_clase_sem1,"& vbCrLf &_
 "protic.trunc(daco_ffin_clase_sem1)as daco_ffin_clase_sem1,"& vbCrLf &_
 "protic.trunc(daco_flimite_pos_sem2_upa)as daco_flimite_pos_sem2_upa,"& vbCrLf &_
 "protic.trunc(daco_flimite_pos_sem2)as daco_flimite_pos_sem2,"& vbCrLf &_
 "protic.trunc(daco_fini_clase_sem2)as daco_fini_clase_sem2,"& vbCrLf &_
 "protic.trunc(daco_ffin_clase_sem2)as daco_ffin_clase_sem2,"& vbCrLf &_
 "daco_ttest_idioma,"& vbCrLf &_
 "daco_tescala_avalu,"& vbCrLf &_
 "daco_ncupo,"& vbCrLf &_
 "daco_tcomentario_cupo,"& vbCrLf &_
 "daco_tramos_cursar,"& vbCrLf &_
 "anos_ccod,idio_tdesc "& vbCrLf &_
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
	
'response.Write("<br>"&sql_descuentos&"<br>")
			
'response.End()

f_cheques.Consultar sql_descuentos
f_cheques.siguiente


set f_costo= new CFormulario
f_costo.Carga_Parametros "convenios_rrii.xml", "costos_"
f_costo.Inicializar conexion

sql_descuentos="select protic.initcap(tcvi_tdesc)as tcvi_tdesc,covi_monto,covi_comentario"& vbCrLf &_ 
"from costo_vida a,"& vbCrLf &_ 
"universidad_ciudad b,"& vbCrLf &_ 
"datos_convenio c, "& vbCrLf &_
"tipo_costo_vida d"& vbCrLf &_
"where a.ciex_ccod=b.ciex_ccod"& vbCrLf &_
"and b.unci_ncorr=c.unci_ncorr"& vbCrLf &_
"and c.daco_ncorr="&daco_ncorr&""& vbCrLf &_
"and a.tcvi_ccod=d.tcvi_ccod"

f_costo.Consultar sql_descuentos


set f_contacto= new CFormulario
f_contacto.Carga_Parametros "convenios_rrii.xml", "contacto"
f_contacto.Inicializar conexion

sql_descuentos="select euco_tnombre,euco_tcargo,euco_temail,euco_tfono,euco_tfax,euco_direccion "& vbCrLf &_ 
"from encargado_universidad_convenio a"& vbCrLf &_
"where a.daco_ncorr="&daco_ncorr&""
f_contacto.Consultar sql_descuentos


pais_ccod2 = f_cheques.ObtenerValor("pais_ccod2")
ciex_ccod2 = f_cheques.ObtenerValor("ciex_ccod2")
univ_ccod2 = f_cheques.ObtenerValor("univ_ccod2")
unci_ncorr2 = f_cheques.ObtenerValor("unci_ncorr2")

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
function abre_ventana_mensaje()
{
	daco_ncorr=<%=daco_ncorr%>
	window.open("pdf_muestra_alumno.asp?daco_ncorr="+daco_ncorr+"", "ventana1" , "width=1024,height=850,scrollbars=YES,resizable =YES,location=0,left=300,top=200");
	
}
function abre_ventana_mensaje2()
{
	daco_ncorr=<%=daco_ncorr%>
	window.open("pdf_muestra.asp?daco_ncorr="+daco_ncorr+"", "ventana1" , "width=1024,height=850,scrollbars=YES,resizable =YES,location=0,left=300,top=200");
	
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  
          <tr>
            <td>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Convenio"%>
						  <table width="100%"  border="0" align="center">
							<tr>
							  <td>
							  	<table align="center" width="100%">
									<tr>
										<td width="11%"><strong>Institución:</strong></td>
										<td width="41%"><%=f_cheques.ObtenerValor("univ_tdesc")%></td>
										<td width="5%"><strong>Pais:</strong></td>
										<td width="16%"><%=f_cheques.ObtenerValor("pais_tdesc")%></td>
										<td width="8%"><strong>Ciudad:</strong> </td>
										<td width="19%"><%=f_cheques.ObtenerValor("ciex_tdesc")%></td>
									</tr>
									<tr>
										<td width="11%"><strong>Web:</strong></td>
										<td width="41%" colspan="5"><%=f_cheques.ObtenerValor("daco_tweb")%></td>
										
									</tr>
                                    <tr>
								  	  <td width="27%" valign="top"><strong>Inicio Convenio:</strong> </td>
									  <td valign="top"><%=f_cheques.ObtenerValor("daco_fconvenio_ini")%></td>
									  <td width="12%" colspan="2" valign="top"><strong>Termino Convenio:</strong> </td>
                                      <td ><%=f_cheques.ObtenerValor("daco_fconvenio_fin")%></td>
								  </tr>

								</table>
								<br>
							    <table align="center" width="100%">
                                  <tr>
                                    <td width="16%" valign="top"><strong>Carreras UPA en Convenio:</strong> </td>
									 <td width="25%" valign="top"><%=f_cheques.ObtenerValor("carreras_convenio")%></td>
									<td width="13%" valign="top"><strong>Cupo Total:</strong> </td>
									<td width="4%" valign="top"><%=f_cheques.ObtenerValor("daco_ncupo")%></td>
									<td width="16%" valign="top"><strong>Comentario Cupo:</strong></td>
									<td width="26%" valign="top"><%=f_cheques.ObtenerValor("daco_tcomentario_cupo")%></td>
                                  </tr>
								</table>
								<br>
							    <table align="center" width="100%">
                                  <tr>
                                    <td width="19%" valign="top"><strong>Escala de Evaluacion:</strong> </td>
									 <td width="81%" valign="top"><%=f_cheques.ObtenerValor("daco_tescala_avalu")%></td>
                                  </tr>
								</table>
									<br>
							    <table align="center" width="100%">
                                  <tr>
                                    <td width="26%" valign="top"><strong>Maximo Asignaturas a cursar:</strong> </td>
									 <td width="74%" valign="top"><%=f_cheques.ObtenerValor("daco_tramos_cursar")%></td>
                                  </tr>
								</table>
								<br>
								 <table align="center" width="100%">
								 <tr>
								 	<td colspan="6">
										<strong><u>1° Semestre</u></strong>
									</td>
								 </tr>
								 <tr>
								 <td width="27%" valign="top"><strong>Fecha Limite Postulaci&oacute;n UPA:</strong> </td>
                                    <td width="13%" valign="top"><%=f_cheques.ObtenerValor("daco_flimite_pos_sem1_upa")%></td>
								 </tr>
                                  <tr>
                                   <td width="27%" valign="top"><strong>Fecha Limite Postulaci&oacute;n:</strong> </td>
                                    <td width="13%" valign="top"><%=f_cheques.ObtenerValor("daco_flimite_pos_sem1")%></td>
									 <td width="12%" valign="top"><strong>Incio Clases: </strong> </td>
                                    <td width="15%" valign="top"><%=f_cheques.ObtenerValor("daco_fini_clase_sem1")%></td>
									<td width="14%" valign="top"><strong>Termino Clases: </strong></td>
									<td width="19%" valign="top"><%=f_cheques.ObtenerValor("daco_ffin_clase_sem1")%></td>
                                  </tr>
								  <tr>
								  	<td colspan="6">
										<strong><u>2° Semestre</u></strong>
									</td>
								  </tr>
								   <tr>
								 <td width="27%" valign="top"><strong>Fecha Limite Postulaci&oacute;n UPA:</strong> </td>
                                    <td width="13%" valign="top"><%=f_cheques.ObtenerValor("daco_flimite_pos_sem2_upa")%></td>
								 </tr>
								  <tr>
								  	  <td width="27%" valign="top"><strong>Fecha Limite Postulaci&oacute;n:</strong> </td>
									  <td valign="top"><%=f_cheques.ObtenerValor("daco_flimite_pos_sem2")%></td>
									 <td width="12%" valign="top"><strong>Incio Clases:</strong> </td>
                                     <td valign="top"><%=f_cheques.ObtenerValor("daco_fini_clase_sem2")%></td>
									  <td width="14%" valign="top"><strong>Termino Clases:</strong> </td>
									  <td valign="top"><%=f_cheques.ObtenerValor("daco_ffin_clase_sem2")%></td>	
								  </tr>
                                </table>
								
								 <br>
								 <table align="center" width="100%">
								 	<tr>
										<td width="16%">
											<strong>Idioma Necesario:</strong></td>
										<td width="23%"><%=f_cheques.ObtenerValor("idio_tdesc")%></td>
										<td width="25%">
											<strong>Test de Idiomas Requeridos: </strong>										
										</td>
										<td width="35%"><%=f_cheques.ObtenerValor("daco_ttest_idioma")%></td>
									</tr>
								 </table>
								<br>
								 <table align="center" width="100%">
								 	<tr>
										<td>
											<strong>COSTOS DE VIDA</strong>
										</td>
									</tr>
								 </table>
								 <%while f_costo.siguiente%>
								  <table align="center" width="100%"><td>
											<strong><u><%=f_costo.ObtenerValor("tcvi_tdesc")%></u></strong>
										</td>
								 	<tr>
										
									</tr>
								 </table>
								  <table align="center" width="100%">
								 	<tr>
										<td width="6%"><strong>Monto:</strong></td>
										<td width="30%"><%=f_costo.ObtenerValor("covi_monto")%></td>
										<td width="12%" valign="top">
											<strong>Comentarios:</strong></td>
										<td width="52%"><%=f_costo.ObtenerValor("covi_comentario")%></td>
									</tr>
								 </table>
								 <%wend%>
								 <br>
								 <%while f_contacto.siguiente%>
								 <table align="center" width="100%">
								 	<tr>
										<td>
											<strong>DATOS DE CONTACTO </strong>
										</td>
									</tr>
								 </table>
								 <table align="center" width="100%">
								 	<tr>
										<td width="8%">
											<strong>Nombre: </strong></td>
										<td width="38%"><%=f_contacto.ObtenerValor("euco_tnombre")%></td>
								      <td width="7%"><strong>Cargo:</strong></td>
										<td width="47%"><%=f_contacto.ObtenerValor("euco_tcargo")%></td>
									</tr>
								 </table>
								 <table width="100%">
								 	<tr>
										<td width="10%">
											<strong>Dirección:</strong>										</td>
										<td width="90%">
											<%=f_contacto.ObtenerValor("euco_direccion")%>
									  </td>
									</tr>
								 </table>
								 <table width="100%">
								 	<tr>
										<td width="5%">
											<strong>Fono:</strong>										
										</td>
									  <td width="16%"><%=f_contacto.ObtenerValor("euco_tfono")%></td>
										<td width="5%"><strong>Fax: </strong></td>
									  <td width="18%"><%=f_contacto.ObtenerValor("euco_tfax")%></td>
										<td width="7%"><strong>E-mail: </strong></td>
									  <td width="49%"><%=f_contacto.ObtenerValor("euco_temail")%></td>
									</tr>
								 </table>
								  <br>
								  <%wend
								  f_botonera.AgregaBotonParam "editar", "url","agrega_convenio.asp?b[0][daco_ncorr]="&daco_ncorr&"&b[0][pais_ccod]="&pais_ccod2&"&b[0][ciex_ccod]="&ciex_ccod2&"&b[0][univ_ccod]="&univ_ccod2&"&b[0][unci_ncorr]="&unci_ncorr2&""
								  f_botonera.DibujaBoton("editar")
								  %>
							  </td>
							</tr>
						  </table>
						 
					</td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
		  <%if debusqueda="S" then%>
            <td width="18%" height="20" align="center">
				<%
				f_botonera.AgregaBotonParam "volver2", "url", "http://fangorn.upacifico.cl/sigaupa/RRII/busca_convenio.asp?buscar=&b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Buniv_ccod%5D="&univ_ccod&"&b%5B0%5D%5Bcarr_ccod%5D="&carr_ccod&"&b%5B0%5D%5Bfecha_ini_1%5D="&ini_fecha1&"&b%5B0%5D%5Bfecha_fin_1%5D="&fin_fecha1&"&b%5B0%5D%5Bfecha_ini_2%5D="&ini_fecha2&"&b%5B0%5D%5Bfecha_fin_2%5D="&fin_fecha2&"&b%5B0%5D%5Banos_ccod%5D="&ano_ccod&""
				f_botonera.DibujaBoton("volver2")%>
              </td>
			    <td width="18%" height="20" align="center">
				<%f_botonera.DibujaBoton("imprimir_alu")%>
              </td>
			   <td width="18%" height="20" align="center">
				<%f_botonera.DibujaBoton("imprimir")%>
              </td>
			    <%else %>
			    <td width="18%" height="20" align="center">
				<%f_botonera.DibujaBoton("terminar")%>
              </td>
			   <%end if%>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
		  	<%if debusqueda="S" then%>
            <td height="8" colspan="3" background="../imagenes/abajo_r2_c2.gif"></td>
			<%else %>
			 <td height="8"  background="../imagenes/abajo_r2_c2.gif"></td>
			<%end if%>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>