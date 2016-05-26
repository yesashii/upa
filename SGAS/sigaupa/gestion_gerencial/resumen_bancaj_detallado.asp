<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "funciones_bancaj.asp" -->
<%
Server.ScriptTimeout = 150000
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Control presupuestario ingresos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

v_anos  = request.querystring("busqueda[0][v_anos]")
v_opcion_bancaj  = request.querystring("opcion_bancaj")




sql_anos= " (Select anos_ccod as v_anos, 'Año '+cast(anos_ccod as varchar) as  anos_tdesc  "& vbCrLf &_
		  " From anos where anos_ccod between '2004' and datepart(year,getdate()) ) as tabla"
			
sql_anos= "(select distinct anos_ccod as v_anos, 'Proceso Admisión '+cast(anos_ccod as varchar) as  anos_tdesc From periodos_academicos Where anos_ccod >=2005) as tabla "

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "resumen_bancaj_detallado.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.siguiente
 
f_busqueda.AgregaCampoParam "v_anos", "destino", sql_anos 

f_busqueda.AgregaCampoCons "v_anos", v_anos

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "resumen_bancaj_detallado.xml", "botonera"


Select Case v_opcion_bancaj
	Case 1
		v_cheked1="checked"
		f_botonera.AgregaBotonParam "excel", "url", "resumen_bancaj_detallado_sede_excel.asp"
		set casa_central = new CFormulario
		casa_central.carga_parametros "resumen_bancaj_detallado.xml", "resumen_caja_detalle"
		casa_central.inicializar conexion 
		
		set providencia = new CFormulario
		providencia.carga_parametros "resumen_bancaj_detallado.xml", "resumen_caja_detalle"
		providencia.inicializar conexion 
		
		set melipilla = new CFormulario
		melipilla.carga_parametros "resumen_bancaj_detallado.xml", "resumen_caja_detalle"
		melipilla.inicializar conexion 
		
		set totales = new CFormulario
		totales.carga_parametros "resumen_bancaj_detallado.xml", "resumen_caja_final"
		totales.inicializar conexion 
		
		sql_casa_central=ObtenerConsultaSede(1,v_anos)
		sql_providencia=ObtenerConsultaSede(2,v_anos)
		sql_melipilla=ObtenerConsultaSede(4,v_anos)
		'sql_resumen=ObtenerTotales()
		'response.Write("<pre>"&sql_resumen&"</pre>")		
		
		if not Esvacio(Request.QueryString) then
			casa_central.Consultar sql_casa_central
			providencia.Consultar sql_providencia
			melipilla.Consultar sql_melipilla
		else
		
			vacia = "select '' where 1=2 "
			 
			melipilla.Consultar vacia
			melipilla.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
			
			providencia.Consultar vacia
			providencia.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
			
			casa_central.Consultar vacia
			casa_central.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
		
			'totales.Consultar vacia
			'totales.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
		
		end if
		
	Case 2
		v_cheked2="checked"
		
		f_botonera.AgregaBotonParam "excel", "url", "resumen_bancaj_detallado_facultad_excel.asp"
		set facu_marketing = new CFormulario
		facu_marketing.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_facultad"
		facu_marketing.inicializar conexion 
		
		set facu_diseno = new CFormulario
		facu_diseno.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_facultad"
		facu_diseno.inicializar conexion 
		
		set facu_comunicaciones = new CFormulario
		facu_comunicaciones.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_facultad"
		facu_comunicaciones.inicializar conexion 
		
		set facu_ciencias = new CFormulario
		facu_ciencias.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_facultad"
		facu_ciencias.inicializar conexion 
		
		set facu_tecnologias = new CFormulario
		facu_tecnologias.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_facultad"
		facu_tecnologias.inicializar conexion 
		
		set facu_institucionales = new CFormulario
		facu_institucionales.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_facultad"
		facu_institucionales.inicializar conexion 
		
		
		sql_facu_marketing		=	ObtenerConsultaFacultad(1,v_anos)
		sql_facu_diseno			=	ObtenerConsultaFacultad(2,v_anos)
		sql_facu_comunicaciones	=	ObtenerConsultaFacultad(3,v_anos)
		sql_facu_ciencias		=	ObtenerConsultaFacultad(4,v_anos)
		sql_facu_tecnologias	=	ObtenerConsultaFacultad(5,v_anos)
		sql_facu_institucionales=	ObtenerConsultaFacultad(8,v_anos)

		if not Esvacio(Request.QueryString) then
			facu_marketing.Consultar sql_facu_marketing
			facu_diseno.Consultar sql_facu_diseno
			facu_comunicaciones.Consultar sql_facu_comunicaciones
			facu_ciencias.Consultar sql_facu_ciencias
			facu_tecnologias.Consultar sql_facu_tecnologias
			facu_institucionales.Consultar sql_facu_institucionales
		else
		
			vacia = "select '' where 1=2 "
			 
			facu_marketing.Consultar vacia
			facu_marketing.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
			
			facu_diseno.Consultar vacia
			facu_diseno.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
			
			facu_diseno.Consultar vacia
			facu_diseno.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"

			facu_ciencias.Consultar vacia
			facu_ciencias.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
			
			facu_tecnologias.Consultar vacia
			facu_tecnologias.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
			
			facu_institucionales.Consultar vacia
			facu_institucionales.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
		
			'totales.Consultar vacia
			'totales.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
		
		end if

	Case 3
		v_cheked3="checked"
		f_botonera.AgregaBotonParam "excel", "url", "resumen_bancaj_detallado_consolidado_excel.asp"
		set consolidado = new CFormulario
		consolidado.carga_parametros "resumen_bancaj_detallado.xml", "resumen_detalle_consolidado"
		consolidado.inicializar conexion 

		sql_consolidado		=	ObtenerConsultaConsolidado(v_anos)
		
		if not Esvacio(Request.QueryString) then
			consolidado.Consultar sql_consolidado
		else
			vacia = "select '' where 1=2 "
			 
			consolidado.Consultar vacia
			consolidado.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
		end if	
		
End select


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

<script language="JavaScript">

function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}
function NoDisponible(){
	alert("Funcion aun no disponible");
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
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
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td height="60">
			<form name="buscador" method="get" action="">
              <br>
			   <table width="98%"  border="0" align="center">
                <tr>
                  <td width="82%"><div align="center">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                          <td width="27%"><strong>Años Finacieros </strong></td>
                          <td width="2%">:</td>
                          <td width="71%"><div align="left"></div>
                            <%f_busqueda.DibujaCampo("v_anos")%></td>
                        </tr>
                    </table>
                  </div></td>
                  <td width="18%" rowspan="2"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
                </tr>
                <tr>
                  <td>
					  <table width="100%" align="right" border="0">
						  <tr>
							  <td><strong>Opciones:</strong></td>
							  <td><input type="radio" name="opcion_bancaj" value="1" <%=v_cheked1%>>
							  Por Sedes</td>
							  <td><input type="radio" name="opcion_bancaj" value="2" <%=v_cheked2%>>
							    Por Facultad</td>
							  <td><input type="radio" name="opcion_bancaj" value="3" <%=v_cheked3%>>
							    Consolidado</td>
						  </tr>
					  </table>
				  </td>
                 
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br><div align="center"> 
                    <%pagina.DibujarTituloPagina%>
                </div>
              <form name="edicion" method="post" action="">
			  
			     <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
					<% Select Case v_opcion_bancaj
			   				Case 1 %>
					<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                             <td align="right"></td>
                            </tr>
                               <tr>
                                 <td align="center">
								 	<%pagina.DibujarSubtitulo "Casa Central"%><br>
                                    <%casa_central.dibujaTabla()%>
									<br>
                                 </td>
                             </tr>
							 <tr>
							 	<td align="center">
									<br>
									<%pagina.DibujarSubtitulo "Providencia"%><br>
									<%providencia.dibujaTabla()%>
									<br>
								</td>
							 </tr>
							 <tr>
							 	<td align="center">
								    <br>
									<%pagina.DibujarSubtitulo "Melipilla"%><br>									
									<%melipilla.dibujaTabla()%>
									<br>
								</td>
							 </tr>
							 <tr>
							 	<td align="center">
								</td>
							 </tr>												 
							 <tr>
							    <td>&nbsp;
								</td>
							</tr>
						  </table>
						  <%Case 2 %>
							  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
									<tr>
										<td align="right"></td>
									</tr>
									<tr>
										 <td align="center">
											<%pagina.DibujarSubtitulo "Facultad de Administracion y Marketing"%><br>
											<%facu_marketing.dibujaTabla()%>
											<br>
										 </td>
									</tr>
								 <tr>
									<td align="center">
										<br>
										<%pagina.DibujarSubtitulo "Facultad de Diseño"%><br>
										<%facu_diseno.dibujaTabla()%>
										<br>
									</td>
								 </tr>
								 <tr>
									<td align="center">
										<br>
										<%pagina.DibujarSubtitulo "Facultad de Comunicaciones"%><br>									
										<%facu_comunicaciones.dibujaTabla()%>
										<br>
									</td>
								 </tr>
								 <tr>
									<td align="center">
										<br>
										<%pagina.DibujarSubtitulo "Facultad de Ciencias Humanas y Educacion"%><br>									
										<%facu_ciencias.dibujaTabla()%>
										<br>
									</td>
								 </tr>
								 <tr>
									<td align="center">
										<br>
										<%pagina.DibujarSubtitulo "Facultad de Tecnologias de la Informacion y Comunicacion"%><br>									
										<%facu_tecnologias.dibujaTabla()%>
										<br>
									</td>
								 </tr>
								 <tr>
									<td align="center">
										<br>
										<%pagina.DibujarSubtitulo "Area Ciencias Agropecuarias y de Salud"%><br>									
										<%facu_institucionales.dibujaTabla()%>
										<br>
									</td>
								 </tr>												 
								 <tr>
									<td>&nbsp;
									</td>
								</tr>
							  </table>
							  <%Case 3%>
								  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
									<tr>
										<td align="right"></td>
									</tr>
									<tr>
										<td align="center">
											<%pagina.DibujarSubtitulo "Consolidado"%><br>
											<%consolidado.dibujaTabla()%>
											<br>
										</td>
									</tr>
								 </table>
							  <%Case Else  %>
							  <p align="center"><font color="#FF3333" size="2" style=" font-weight:bold"></font></p>
							  
						  <%End Select%>
                     </td>
                  </tr>
                </table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="51%"><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  <td width="49%"> <div align="center">  <%f_botonera.dibujaboton "excel"%>
					 </div>
                  </td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
	</td>
  </tr>  
</table>
</body>
</html>
