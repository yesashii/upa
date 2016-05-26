<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
pais_ccod =Request.QueryString("b[0][pais_ccod]")
ciex_ccod =Request.QueryString("b[0][ciex_ccod]")
univ_ccod =Request.QueryString("b[0][univ_ccod]")
carr_ccod =Request.QueryString("b[0][carr_ccod]")
anos_ccod =Request.QueryString("b[0][anos_ccod]")
fecha_fin_1 =Request.QueryString("b[0][fecha_fin_1]")
fecha_ini_1 =Request.QueryString("b[0][fecha_ini_1]")
fecha_fin_2 =Request.QueryString("b[0][fecha_fin_2]")
fecha_ini_2 =Request.QueryString("b[0][fecha_ini_2]")
buscar	=Request.QueryString("buscar")

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
f_botonera.Carga_Parametros "convenios_rrii.xml", "botonera"



'------------------------------------PAISES---------------------------------------------------------------
set f_pais = new CFormulario
f_pais.Carga_Parametros "convenios_rrii.xml", "busqueda"
f_pais.Inicializar conexion
f_pais.Consultar "select ''"
f_pais.Siguiente
f_pais.AgregaCampoCons "pais_ccod", pais_ccod
f_pais.AgregaCampoCons "carr_ccod", carr_ccod
f_pais.AgregaCampoCons "anos_ccod", anos_ccod
f_pais.AgregaCampoCons "fecha_ini_1", fecha_ini_1
f_pais.AgregaCampoCons "fecha_fin_1", fecha_fin_1
f_pais.AgregaCampoCons "fecha_ini_2", fecha_ini_2
f_pais.AgregaCampoCons "fecha_fin_2", fecha_fin_2
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


if  pais_ccod <>""  then
filtro2=filtro2&"and e.pais_ccod="&pais_ccod&""
end if

if  ciex_ccod <>"" then
filtro=filtro&"and e.ciex_ccod="&ciex_ccod&""
end if




if univ_ccod<>"" then
filtro3=filtro3&"and b.univ_ccod="&univ_ccod&""
end if
 
 
if carr_ccod<> "" then
filtro4=filtro4&"and d.carr_ccod="&carr_ccod&""
end if


if fecha_fin_1<> ""  and  fecha_ini_1<> "" then
filtro6=filtro6&"and convert(datetime,daco_flimite_pos_sem1_upa,103) between convert(datetime,'"&fecha_ini_1&"',103) and convert(datetime,'"&fecha_fin_1&"',103)"
end if

if fecha_fin_2<> ""  and  fecha_ini_2<> "" then
filtro7=filtro7&"and convert(datetime,daco_flimite_pos_sem2_upa,103) between convert(datetime,'"&fecha_ini_2&"',103) and convert(datetime,'"&fecha_fin_2&"',103)"
end if







if request.QueryString.count > 0 and buscar<>"N" then
set f_resumen_convenio = new CFormulario
f_resumen_convenio.Carga_Parametros "convenios_rrii.xml", "muestra_resumen_convenio"
f_resumen_convenio.Inicializar conexion

sql_descuentos="select a.daco_ncorr,univ_tdesc,pais_tdesc,ciex_tdesc,"& vbCrLf &_
"'"&pais_ccod&"' as pais_ccod,'"&ciex_ccod&"' as ciex_ccod,'"&univ_ccod&"' as univ_ccod, '"&carr_ccod&"' as carr_ccod, '"&fecha_ini_1&"' as fecha_ini_1, '"&fecha_fin_1&"' as fecha_fin_1, '"&fecha_ini_2&"' as fecha_ini_2, '"&fecha_fin_2&"' as fecha_fin_2 ,'"&anos_ccod&"' as anos_ccod, "& vbCrLf &_
"protic.obtener_carreras_convenio_rrii(a.daco_ncorr)as carreras_convenio,"& vbCrLf &_
"protic.trunc(daco_flimite_pos_sem1_upa)as daco_flimite_pos_sem1_upa,"& vbCrLf &_
"protic.trunc(daco_flimite_pos_sem2_upa)as daco_flimite_pos_sem2_upa,"& vbCrLf &_
"daco_ncupo"& vbCrLf &_
"from datos_convenio a,"& vbCrLf &_
"universidad_ciudad b,"& vbCrLf &_
"universidades c,"& vbCrLf &_
"carreras_convenio d,"& vbCrLf &_
"ciudades_extranjeras e,"& vbCrLf &_
"paises f"& vbCrLf &_
"where a.unci_ncorr=b.unci_ncorr"& vbCrLf &_
"and b.univ_ccod=c.univ_ccod"& vbCrLf &_
"and b.ciex_ccod=e.ciex_ccod"& vbCrLf &_
"and a.daco_ncorr=d.daco_ncorr"& vbCrLf &_
"and a.anos_ccod="&anos_ccod&""& vbCrLf &_
"and d.ecco_ccod=1"& vbCrLf &_
"and e.pais_ccod=f.pais_ccod"& vbCrLf &_
""&filtro&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
""&filtro6&""& vbCrLf &_
""&filtro7&""& vbCrLf &_
"group by univ_tdesc,a.daco_ncorr,daco_flimite_pos_sem1_upa,daco_flimite_pos_sem2_upa,daco_ncupo,pais_tdesc,ciex_tdesc"				
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_resumen_convenio.Consultar sql_descuentos

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
		document.buscador.elements["b[0][ciex_ccod]"].value=''
		document.buscador.elements["b[0][univ_ccod]"].value=''
		document.buscador.elements["buscar"].value='N'
		document.buscador.action ='busca_convenio.asp';
		document.buscador.method = "get";
		document.buscador.submit();
	

}
function cambiar_ciud()
{
		document.buscador.elements["buscar"].value='N'
		document.buscador.action ='busca_convenio.asp';
		document.buscador.method = "get";
		document.buscador.submit();
	

}

function alcargar()
{
ciex_ccod='<%=ciex_ccod%>'
univ_ccod='<%=univ_ccod%>'
	if (ciex_ccod!="")
	{
		document.buscador.elements["b[0][ciex_ccod]"].value=ciex_ccod
	}
		
	if (univ_ccod!="")
	{
		document.buscador.elements["b[0][univ_ccod]"].value=univ_ccod
	}	

}

function nueva_ventana()
{


pais_ccod='<%=pais_ccod%>'
ciex_ccod='<%=ciex_ccod%>'
univ_ccod='<%=univ_ccod%>'
carr_ccod='<%=carr_ccod%>'
ini_fecha1='<%=ini_fecha1%>'
fin_fecha1='<%=fin_fecha1%>'
ini_fecha2='<%=ini_fecha2%>'
fin_fecha2='<%=fin_fecha2%>'
anos_ccod='<%=anos_ccod%>'
pagina="muestra_convenio_resumen_pdf.asp?b%5B0%5D%5Bpais_ccod%5D="+pais_ccod+"&b%5B0%5D%5Bciex_ccod%5D="+ciex_ccod+"&b%5B0%5D%5Buniv_ccod%5D="+univ_ccod+"&b%5B0%5D%5Bcarr_ccod%5D="+carr_ccod+"&b%5B0%5D%5Bfecha_ini_1%5D="+ini_fecha1+"&b%5B0%5D%5Bfecha_fin_1%5D="+fin_fecha1+"&b%5B0%5D%5Bfecha_ini_2%5D="+ini_fecha2+"&b%5B0%5D%5Bfecha_fin_2%5D="+fin_fecha2+"&b%5B0%5D%5Banos_ccod%5D="+anos_ccod+""


window.open(pagina, "ventana1" , "width=1024,height=850,scrollbars=YES,resizable =YES,location=0,left=300,top=200");
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
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
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
							<td width="5%">Pais</td>
						  <td width="17%"><%f_pais.DibujaCampo("pais_ccod")%> </td>
							<td width="11%" align="right">Ciudad</td>
							<td width="17%">
								<select name="b[0][ciex_ccod]" OnChange="cambiar_ciud();">
								<option value="">Todas</option>
						   <% if pais_ccod<>"" then
						  	while f_ciudades_extranjeras.siguiente%>
						  	<option value="<%=f_ciudades_extranjeras.ObtenerValor("ciex_ccod")%>"><%=f_ciudades_extranjeras.ObtenerValor("ciex_tdesc")%></option>
						  	<%wend
						     end if%>
								</select>
						  </td>
							<td width="11%">Universidad</td>
							<td width="39%">
								<select name="b[0][univ_ccod]">
							<option value="">Todas</option>
							<% if pais_ccod<>"" and ciex_ccod<>"" then
						  	while f_universidades_extranjeras.siguiente%>
						  	<option value="<%=f_universidades_extranjeras.ObtenerValor("univ_ccod")%>"><%=f_universidades_extranjeras.ObtenerValor("univ_tdesc")%></option>
						  	<%wend
						     end if%>
								</select>
						  </td>
					  </tr>
					</table>
					<table align="center" width="100%">
							<tr>
							<td width="13%">Carreras UPA</td>
							<td width="87%"><%f_pais.DibujaCampo("carr_ccod")%></td>
							</tr>
					</table>
					<table align="center" width="100%">
							<tr>
							<td width="19%" align="left">Fecha de Postulaci&oacute;n 1° Semestre</td>
							<td width="81%"><strong>entre el</strong>
							  <%f_pais.DibujaCampo("fecha_ini_1")%> <strong>y el</strong> <%f_pais.DibujaCampo("fecha_fin_1")%> 
							  <strong>dd/mm/aaaa  * debe indicar ambas fechas </strong></td>
							</tr>
					</table>
					<table align="center" width="100%">
							<tr>
							<td width="19%" align="left">Fecha de Postulaci&oacute;n 2° Semestre </td>
							<td width="81%"><strong>entre el</strong>
							  <%f_pais.DibujaCampo("fecha_ini_2")%> <strong>y el</strong> <%f_pais.DibujaCampo("fecha_fin_2")%> 
							  <strong>dd/mm/aaaa  * debe indicar ambas fechas </strong></td>
							</tr>
					</table>
					<table align="center" width="100%">
							<tr>
							<td width="17%">Periodo Acad&eacute;mico</td>
							<td width="83%"><%f_pais.DibujaCampo("anos_ccod")%></td>
					</tr>
					</table>
					<table align="left">
						<tr valign="bottom">
							<td><%f_botonera.DibujaBoton("buscar")%></td>
						</tr>
					</table>
                 </form>
			</td>
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
	<%if request.QueryString.count > 0 and buscar<>"N" then%> 
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
		  <td><div align="center">
                    <br>
                    <table width="100%" border="0">
                     
                    </table>
			  </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
             <form name="edicion">

			  
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Convenios"%>
					
                      <table width="98%"  border="0" align="center">
					   <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_resumen_convenio.accesopagina%>
                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
									<%f_resumen_convenio.Dibujatabla()%>
							   </td>
						  
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><p><br> </p>
                            </td>
                        </tr>
                      </table></td>
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
            <td width="20%" height="20"><div align="center">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  <td><div align="center"><%f_botonera.AgregaBotonParam "excel", "url", "muestra_convenio_resumen_excel.asp?b%5B0%5D%5Bpais_ccod%5D="&pais_ccod&"&b%5B0%5D%5Bciex_ccod%5D="&ciex_ccod&"&b%5B0%5D%5Buniv_ccod%5D="&univ_ccod&"&b%5B0%5D%5Bcarr_ccod%5D="&carr_ccod&"&b%5B0%5D%5Bfecha_ini_1%5D="&ini_fecha1&"&b%5B0%5D%5Bfecha_fin_1%5D="&fin_fecha1&"&b%5B0%5D%5Bfecha_ini_2%5D="&ini_fecha2&"&b%5B0%5D%5Bfecha_fin_2%5D="&fin_fecha2&"&b%5B0%5D%5Banos_ccod%5D="&anos_ccod&""
				  							f_botonera.DibujaBoton("excel")%></div></td>
				  <td><div align="center"><%f_botonera.DibujaBoton("pdf")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	 <%end if%><br>
	 <%buscar=""%>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>