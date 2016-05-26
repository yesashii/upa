<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
	

anos_ccod=request.Form("bu[0][anos_ccod]")	
tipo_mantenedora=request.Form("bu[0][tipo_mantenedora]")
tipo_indi=request.Form("bu[0][tipo_indi]") 


'response.write("<br>anos_ccod= "&anos_ccod)
'response.write("<br>tipo_mantenedora= "&tipo_mantenedora)
'response.write("<br>tipo_indi= "&tipo_indi)	
'response.End()
'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
'secc_ccod=request.Form("secc")
'anos_ccod=request.Form("anos_ccod")

set pagina = new cPagina
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "mantenedor_anuales.xml", "botonera"

set f_mantenedor = new CFormulario
f_mantenedor.Carga_Parametros "mantenedor_anuales.xml", "f_mantenedor_1_8_e"
f_mantenedor.Inicializar conexion
'response.End()
if tipo_mantenedora="1" then
	pre="base"
	anos="2009"
elseif tipo_mantenedora="2"  then
	pre="real"
	anos=anos_ccod
elseif tipo_mantenedora="3"  then
	pre="estimativo"
end if



total_base =conexion.ConsultaUno("select count(*) from mantenedor_dato_base_anual")
total_real=conexion.ConsultaUno("select count(*) from mantenedor_dato_real_anual  where anos_ccod="&anos_ccod&"")
total_estimativo=conexion.ConsultaUno("select count(indi_1_8_e) from mantenedor_dato_estimativo_anual")


if total_base > 0 then
	consulta_base ="(select isnull(indi_1_8_e,0) as base_indi_1_8_e from mantenedor_dato_base_anual)as base_indi_1_8_e"
else
	consulta_base ="(select 0)as base_indi_1_8_e"
end if

if total_real > 0 then
	
 	consulta_real =",(select isnull(indi_1_8_e,0) as real_indi_1_8_e from mantenedor_dato_real_anual where anos_ccod="&anos_ccod&")as real_indi_1_8_e"
else
	consulta_real =",(select 0)as real_indi_1_8_e"
end if

if total_estimativo > 0 then
	consulta_estimativo =",(select isnull(indi_1_8_e,0) as estimativo_indi_1_8_e from mantenedor_dato_estimativo_anual where anos_ccod=2009) as estimativo_indi_1_8_e_2009,"&_
	                     " (select isnull(indi_1_8_e,0) as estimativo_indi_1_8_e from mantenedor_dato_estimativo_anual where anos_ccod=2010) as estimativo_indi_1_8_e_2010,"&_
						 " (select isnull(indi_1_8_e,0) as estimativo_indi_1_8_e from mantenedor_dato_estimativo_anual where anos_ccod=2011) as estimativo_indi_1_8_e_2011,"&_
						 " (select isnull(indi_1_8_e,0) as estimativo_indi_1_8_e from mantenedor_dato_estimativo_anual where anos_ccod=2012) as estimativo_indi_1_8_e_2012,"&_
						 " (select isnull(indi_1_8_e,0) as estimativo_indi_1_8_e from mantenedor_dato_estimativo_anual where anos_ccod=2013) as estimativo_indi_1_8_e_2013"
else
	consulta_estimativo=",(select 0 )as estimativo_indi_1_8_e_2009,"&_
	                    " (select 0 )as estimativo_indi_1_8_e_2010,"&_
	                    " (select 0 )as estimativo_indi_1_8_e_2011,"&_
						" (select 0 )as estimativo_indi_1_8_e_2012,"&_
						" (select 0 )as estimativo_indi_1_8_e_2013"
end if

'response.End()

consulta="select "&consulta_base&" "&consulta_real&" "&consulta_estimativo&"" 
'0response.write(consulta)
'response.end()
f_mantenedor.Consultar consulta
'f_mantenedor.Siguiente


'Ano =conexion.ConsultaUno("select anos_ccod from ")

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<title>- Universidad del Pac&iacute;fico</title>
<style type="text/css">
.Estilo35 {
	font-weight: bold;
	font-size: 26px;
	font-style: Arial, Helvetica, sans-serif;
	color: #000000;
}
.Estilo36 {
	font-weight: bold;
	font-size: 18px;
	font-style: Arial, Helvetica, sans-serif;
	color: #000000;
}
</style>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function bloquea_tabla(){
var mant=<%=tipo_mantenedora%>;

 if (mant==1){
 
 document.edicion.elements["ma[0][real_indi_1_8_e]"].disabled=true;
 document.edicion.elements["ma[0][estimativo_indi_1_8_e_2009]"].disabled=true;
 document.edicion.elements["ma[0][estimativo_indi_1_8_e_2010]"].disabled=true;
 document.edicion.elements["ma[0][estimativo_indi_1_8_e_2011]"].disabled=true;
 document.edicion.elements["ma[0][estimativo_indi_1_8_e_2012]"].disabled=true;
 document.edicion.elements["ma[0][estimativo_indi_1_8_e_2013]"].disabled=true;
 }
 else if (mant==2){
 document.edicion.elements["ma[0][base_indi_1_8_e]"].disabled=true;
 document.edicion.elements["ma[0][estimativo_indi_1_8_e_2009]"].disabled=true;
 document.edicion.elements["ma[0][estimativo_indi_1_8_e_2010]"].disabled=true;
 document.edicion.elements["ma[0][estimativo_indi_1_8_e_2011]"].disabled=true;
 document.edicion.elements["ma[0][estimativo_indi_1_8_e_2012]"].disabled=true;
 document.edicion.elements["ma[0][estimativo_indi_1_8_e_2013]"].disabled=true;
 }
 else if (mant==3){
 document.edicion.elements["ma[0][base_indi_1_8_e]"].disabled=true;
 document.edicion.elements["ma[0][real_indi_1_8_e]"].disabled=true;
 }


}
</script>
</head>

<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'),bloquea_tabla()" >
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA"><br>
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
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
				<table width="700" border="0">
					<tr valign="top" align="center">
						<td width="100%" align="center">
						<form name="edicion">
						<input type="hidden" name="ma[0][anos_ccod]" value="<%=anos_ccod%>">
						<input type="hidden" name="ma[0][tipo_mantenedora]" value="<%=tipo_mantenedora%>">
						<input type="hidden" name="ma[0][tipo_indi]" value="<%=tipo_indi%>">
  						<table>
						  <tr>
							<td align="center">
							<%if tipo_mantenedora="1" then%>
							<p class="Estilo35"><strong>Informaci&oacute;n  Base para</strong></p>
							<%elseif tipo_mantenedora="2" then%>
							<p class="Estilo35"><strong>Informaci&oacute;n Real para el Año <%=anos_ccod%> de </strong></p>
							<%elseif tipo_mantenedora="3" then%>
							<p class="Estilo35"><strong>Informaci&oacute;n Estimativa para el Año <%=anos_ccod%> de </strong></p>
							<%end if%>
							</td>
						  </tr>
						  <tr>
							<td>
							<p class="Estilo36" align="center"><strong>Nº de nuevos convenios de doble certificación </strong></p>
							</td>
						  </tr>
						  <tr valign="top" align="center">
						    <td width="80%" align="center">
							 <%f_mantenedor.DibujaTabla()%>
						     </td>	
						  </tr>
						  <tr>
							 <td>
							 	<strong>* Para la Casilla Dato Real el valor ingresado será asociado al año seleccionado</strong> 
							 </td>
						</tr>
                      </table>
                    </form>
                </td>
             </tr>
         </table>
        </td>
        </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td>
				      <div align="center">
                  		<%f_botonera.AgregaBotonParam "guardar", "url", "m_1_8_e_proc.asp"
					    f_botonera.DibujaBoton"guardar"%>
					  </div>
				  </td>
				  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                </tr>
              </table>
            </td>
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
	</td>
  </tr>  
</table> 

</body>

</html>
