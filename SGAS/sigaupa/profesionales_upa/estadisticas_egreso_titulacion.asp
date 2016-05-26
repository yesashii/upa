<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "estadisticasEgresoTitulacion/dlls/dll_1.asp" -->
<%
Response.addHeader "pragma", "no-cache"
Response.CacheControl = "Private"
Response.Expires = 0

set pagina = new CPagina
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------
'**************************************************'
'**		CAPTURA DE LAS VARIABLES DE BÚSQUEDA	 **'
'**************************************************'------------------------

upa_pregrado  =  request.Form("upa_pregrado")
upa_postgrado =  request.Form("upa_postgrado")
instituto     =  request.Form("instituto")
egresados  	  =  request.Form("egresados")
titulados     =  request.Form("titulados")
graduados     =  request.Form("graduados")
salidas_int   =  request.Form("salidas_int")
femenino      =  request.Form("femenino")
masculino     =  request.Form("masculino")
if(request.Form("a[0][facu_ccod]") <> "") then
	facu_ccod     =  request.Form("a[0][facu_ccod]")
else
	facu_ccod	  = "0"	
end if
if(request.Form("a[0][carr_ccod]") <> "") then
	carr_ccod     =  request.Form("a[0][carr_ccod]")
else
	carr_ccod     =  "0"
end if

carr_ccod     =  request.Form("a[0][carr_ccod]")
'**************************************************'------------------------
'**		CAPTURA DE LAS VARIABLES DE BÚSQUEDA	 **'
'**************************************************'
'*****************************************************************************************************************'
'**																												**'
'**								INICIO DEL CÓDIGO DE LA LÓGICA DEL SISTEMA										**'
'**																												**'
'*****************************************************************************************************************'
'**************************************'
'**		INICIALIZANDO VARIABLES		 **'
'**************************************'------------------------
	if facu_ccod = "" then
		facu_ccod = 0
	end if
	if carr_ccod = "" then
		carr_ccod = "0"
	end if
	
	check_pregrado  = ""
	check_postgrado = ""
	check_instituto = ""
	
	check_egresados  = ""
	check_titulados  = ""
	check_graduados  = ""
	check_salidas_int= ""
	
	check_femenino  = ""
	check_masculino = ""
'**************************************'------------------------
'**		INICIALIZANDO VARIABLES		 **'
'**************************************'

'**************************'
'**		BOTONERA 		 **'
'**************************'------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "estadisticas_egreso_titulacion.xml", "botonera"

'for each k in request.QueryString()
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'next

'**************************'------------------------
'**		BOTONERA 		 **'
'**************************'

'**************************'	
'**		BUSQUEDA		 **'
'**************************'------------------------
	set f_busqueda = new CFormulario
	f_busqueda.Carga_Parametros "estadisticas_egreso_titulacion.xml", "buscador"
	f_busqueda.inicializar conexion
'	consulta="Select '"&facu_ccod&"' as facu_ccod, '"&carr_ccod&"' as carr_ccod"	
'	f_busqueda.consultar consulta	
	consulta_facu = 	"" & vbCrLf & _				
				"select distinct ltrim(rtrim(cast(facu_ccod as VARCHAR))) as facu_ccod, 	" & vbCrLf & _
				"facu_tdesc 																" & vbCrLf & _
				"from   facultades   			                       			          	" & vbCrLf & _
				"where  facu_ccod <> 7           					                      	" & vbCrLf & _
				"and  facu_ccod <> 6	           					                      	" & vbCrLf & _
				"order  by facu_tdesc asc                                                  	"  
				f_busqueda.consultar consulta_facu	
'----------------------------------------------------DEBUG			
'response.Write("<pre>"&consulta&"</pre>")
'response.End()	
'----------------------------------------------------DEBUG

'**************************'------------------------
'**		BUSQUEDA		 **'
'**************************'



%>
<html>
<title>Estad&iacute;sticas egresados, titulados y graduados</title>
<head>
<!--<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">-->
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<link href="estadisticasEgresoTitulacion/css/base.css" rel="stylesheet" type="text/css">
<link href="estadisticasEgresoTitulacion/css/jquery-ui-1.10.3.custom.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script type="text/javascript" src="estadisticasEgresoTitulacion/js/jquery.js"></script>
<script type="text/javascript" src="estadisticasEgresoTitulacion/js/funciones_1.js" ></script>
<script type="text/javascript" src="estadisticasEgresoTitulacion/js/jquery_ui.js" ></script>


</head>
<%
	alto_foto = "35"
	if(request.Form("a[0][facu_ccod]") <> "") then
		alto_foto = "64"
	end if 
%>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); estado(); " onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="64px" valign="bottom"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="64px" border="0"></td>
  </tr>
  <% EncodeUTF8(pagina.DibujarEncabezado())%>  
  <tr>
    <td valign="top" height="100px" bgcolor="#EAEAEA">
	<br>
	<table width="90%" style="top:auto;"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><% pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <form id="miForm" name="buscador" method="post">
		  <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="center">
			    <table width="95%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td width="100%">
						   <table width="100%" cellpadding="0" cellspacing="0">
						   	  <tr>
							  	  <td width="13%"><strong>Instituci&oacute;n</strong></td>
                                  <td width="2%"><strong>:</strong></td>
								  <td width="3%" align="center"><input id="chkUpaPreGrado" type="checkbox" name="upa_pregrado" onClick="controlClikPregrado();" value="1" <%=check_pregrado%>></td>
								  <td width="15%" align="left">UPA Pregrado</td>
								  <td width="3%" align="center"><input id="chkUpaPosGrado" type="checkbox" name="upa_postgrado" onClick="controlClikPostgrado();" value="1" <%=check_postgrado%>></td>
								  <td width="15%" align="left">UPA Postgrado</td>
								  <td width="3%" align="center"><input id="chkinstiprofe" type="checkbox" name="instituto" onClick="controlClikInstituto();" value="1" <%=check_instituto%>></td>
								  <td width="15%" align="left">Instituto Profesional</td>
								  <td width="3%" align="center">&nbsp;</td>
								  <td width="28%" align="left">&nbsp;</td>
							  </tr>
						   </table>
						</td>
					</tr>
				</table>
			</td>
          </tr>
		  <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="center">
			    <table width="95%" cellpadding="0" cellspacing="0" border="0" ><hr/>
					<tr>
						<td width="100%">
						   <table width="100%" cellpadding="0" cellspacing="0">
						   	  <tr>
							  	  <td width="13%"><strong>Estado</strong></td>
                                  <td width="2%"><strong>:</strong></td>
								  <td width="3%" align="center"><input id="chKEstaEgre" type="checkbox" name="egresados" onClick="controlClickEgresados();" value="1" <%=check_egresados%>></td>
								  <td width="15%" align="left">Egresados</td>
								  <td width="3%" align="center"><input id="chKEstaTitu"type="checkbox" name="titulados" onClick="controlClickTitulados();" value="1" <%=check_titulados%>></td>
								  <td width="15%" align="left">Titulados</td>
								  <td width="3%" align="center"><input id="chKEstaGradu" type="checkbox" name="graduados" onClick="controlClickGraduados();" value="1" <%=check_graduados%>></td>
								  <td width="15%" align="left">Graduados</td>
								  <td width="3%" align="center"><input id="chkSalInter" type="checkbox" name="salidas_int" onClick="controlClickSalInter();" value="1" <%=check_salidas_int%>></td>
								  <td width="28%" align="left">Salidas Intermedias</td>
							  </tr>
						   </table>
						</td>
					</tr>
				</table>
			</td>
          </tr>
		  <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="center">
			    <table width="95%" cellpadding="0" cellspacing="0" border="0"><hr/>
					<tr>
						<td width="100%">
						   <table width="100%" cellpadding="0" cellspacing="0">
						   	  <tr>
							  	  <td width="13%"><strong>Facultad</strong></td>
                                  <td width="2%"><strong>:</strong></td>
								  <td colspan="8"  align="left"><span id="comboFacultad"><select name="selectFacultad" id="selectFacultad" onChange="traeComboCarreras(this.value);">
                                  <option value="0">TODAS</option>
								  <% while f_busqueda.siguiente %>                                  
                                  <option value="<%=f_busqueda.ObtenerValor("facu_ccod")%>"><%=EncodeUTF8(f_busqueda.ObtenerValor("facu_tdesc"))%></option>
                                  <% wend %>
                                  </select>
                                  </span></td>
							  </tr>
						   </table>
						</td>
					</tr>
				</table>
			</td>
          </tr>
		  <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td align="center">
			    <table width="95%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td width="100%">
						   <table width="100%" cellpadding="0" cellspacing="0">
						   	  <tr>
							  	  <td width="13%"><strong>Carrera</strong></td>
                                  <td width="2%"><strong>:</strong></td>
								  <td colspan="8" align="left"><span id="comboCarrera">
									<select name="selectCarrera" id="selectCarrera">
										<option value="0">TODAS</option>								  
									</select>
								  </span></td>
							  </tr>
						   </table>
						</td>
					</tr>
				</table>
			</td>
          </tr>
		  <tr>
            <td>&nbsp;</td>
          </tr>
		  
          	<tr>          	
            	<td align="center" > 
                <table width="95%" > <hr/>
                	<tr>
                		<td><div id="anioPromo"></div></td>
                        <td><div id="anioEgre" ></div></td>
                        <td><div id="anioTitu" ></div></td> 						
                    </tr>
                   </table>                                                   	
            	</td>                           
          	</tr>
          
		  <tr>
            <td>&nbsp;</td>
          </tr>                    
          <tr>
            <td align="center">
			    <table width="95%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td width="100%">
						   <table width="100%" cellpadding="0" cellspacing="0">
                           <hr/>
						   	  <tr>
							  	  <td width="13%"><strong>G&eacute;nero</strong></td>
                                  <td width="2%"><strong>:</strong></td>
								  <td width="3%" align="center"><input id="chekFeme" type="checkbox"  name="Femenino" onClick="controlClickFeme();" value="1" <%=check_femenino%>></td>								  <td width="15%" align="left">Femenino</td>
								  <td width="3%" align="center"><input id="chekMascu" type="checkbox" name="Masculino" onClick="controlClickMascu();" value="1" <%=check_masculino%>></td>
								  <td width="15%" align="left">Masculino</td>                                  
								  <td width="3%" align="center">&nbsp;</td>
								  <td width="15%" align="left">&nbsp;</td>
								  <td width="3%" align="center">&nbsp;</td>
								  <td width="28%" align="left">&nbsp;</td>
							  </tr>
						   </table>
						</td>
					</tr>
				</table>
			</td>
          </tr>
		  <tr>
            <td>&nbsp;</td>
          </tr>
		  <tr>
            <td align="right">
			 <table width="35%">
			 	<tr>
					<td width="50%" align="left"><%botonera.dibujaboton "rut_alumni"%></td>
					<td width="50%" align="left"><span id = "bt_buscar"><%botonera.dibujaboton "buscar"%></span></td>
				</tr>
			 </table>
			</td>
          </tr>
		  </form>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
    <br/>
      <div id="gifCarga" ></div>  
	<br>
  <div id="tResutados1" ><div style="width:500px; height:500px;"></div></div>  
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
