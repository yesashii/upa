<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
ofai_ncorr = request.QueryString("ofai_ncorr")
viene = request.QueryString("viene")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Carrera "
set botonera =  new CFormulario
botonera.carga_parametros "adm_ofer_academica.xml", "btn_agregar_carrera"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

if ofai_ncorr <>"" then


consulta= 	"select  a.ofai_ncorr, c.car_ing_ncorr,  e.sede_ccod, b.jorn_ccod, d.ttie_ccod, a.ofai_nduracion, f.anos_ccod  " & vbCrlf & _
 			"from ufe_oferta_academica_ing a, jornadas b, ufe_carreras_ingresa c , ufe_tipo_titulo_ies d , sedes e, anos f " & vbCrlf & _
			"where a.jorn_ccod=b.jorn_ccod and a.car_ing_ncorr = c.car_ing_ncorr " & vbCrlf & _
			"and a.ttie_ccod=d.ttie_ccod " & vbCrlf & _
			"and a.sede_ccod=e.sede_ccod " & vbCrlf & _
			"and a.anos_ccod=f.anos_ccod " & vbCrlf & _
			"and a.ofai_ncorr=" & ofai_ncorr
'response.Write(consulta)
'response.end()
else
consulta= "select ''"
end if
'response.Write(consulta)
'response.end()

set formulario 		= 		new cFormulario
formulario.carga_parametros	"adm_ofer_academica.xml",	"tabla_valores"
formulario.inicializar		conectar
formulario.consultar 		consulta
formulario.siguientef

filas = formulario.nrofilas

 'set f_ingreso = new CFormulario
' f_ingreso.Carga_Parametros "adm_aranceles_ext.xml", "f_ingreso"
' 
' f_ingreso.Inicializar conectar
' 
' consulta = "Select '"&anos_ccod&"' as anos_ccod, '"&jorn_ccod&"' as jorn_ccod, '"&carr_ccod&"' as carr_ccod "
' f_ingreso.consultar consulta
'
' consulta = "select c.carr_ccod,c.carr_tdesc,d.jorn_ccod,d.jorn_tdesc,anos_ccod" & vbCrlf & _
'			"from  ofertas_academicas a, especialidades b ,carreras c, jornadas d, periodos_Academicos e" & vbCrlf & _
'			"where a.espe_ccod=b.espe_ccod" & vbCrlf & _
'			"and b.carr_ccod=c.carr_ccod" & vbCrlf & _
'			"and a.jorn_ccod=d.jorn_ccod " & vbCrlf & _
'			"and a.peri_ccod=e.peri_ccod" & vbCrlf & _
'			"and c.carr_ccod not in (820,001)" & vbCrlf & _
'			"and anos_ccod >2005" & vbCrlf & _
'			"and (select count(*) from ufe_aranceles_ext zz where zz.jorn_ccod=a.jorn_ccod and zz.carr_ccod COLLATE Modern_Spanish_CI_AS=b.carr_ccod and zz.anos_ccod=e.anos_ccod)< 1 " & vbCrlf & _
'			"group by c.carr_ccod,c.carr_tdesc,d.jorn_ccod,d.jorn_tdesc,anos_ccod" & vbCrlf & _
'			"order by anos_ccod,c.carr_tdesc"
'			
' f_ingreso.inicializaListaDependiente "lBusqueda", consulta
' 
' f_ingreso.Siguiente
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
function agregar(formulario){
	
	
	formulario.action = 'proc_ofer_academica.asp';
  	
	if(preValidaFormulario(formulario)){
		formulario.submit();
	}
 }
 
function salir(){
viene ='<%=viene%>'
if (viene !=1){
	self.opener.location.reload();
}
else{
	self.opener.close();
	self.opener.opener.location.reload();
}	
window.close();
}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}



</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="800" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	<br>
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
            <td><%pagina.DibujarLenguetas Array("Mantenedor Oferta academica"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br><%pagina.DibujarSubtitulo "Datos De La Carrera "%>
<font color="#CC3300">*</font>Campos Obligatorios            
  <form name="editar" method="post">
                <table width="100%" border="0" align="center">
                  
                   <tr>
                    <td width="15%">Año</td>
                    <td width="85%">:<%	formulario.dibujacampo("anos_ccod")														
						%></td>
                  </tr>
                  <tr>
                    <td >Sede</td>
                    <td >:<% formulario.dibujacampo("sede_ccod") %>
					<input type="hidden" value="<%=ofai_ncorr%>" name="em[0][ofai_ncorr]" />					</td>
                  </tr>
                   <tr>
                    <td>Jornada</td>
                    <td>:<%	formulario.dibujacampo("jorn_ccod")														
						%></td>
                  </tr>
				  <tr>
                  <tr>
                    <td>Carrera</td>
                    <td>:<% formulario.dibujacampo("car_ing_ncorr")										
						%></td>
                  </tr>
                 <tr>
                    <td>Tipo Titulo</td>
                    <td>:<% formulario.dibujacampo("ttie_ccod")										
						%></td>
                  </tr>
                    <td>Duracion (Años)</td>
                    <td>:<%formulario.dibujacampo("ofai_nduracion")%></td>
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
            <td width="21%" height="20"><div align="center">
              <table width="82%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "GUARDAR"%>
                  </font>
                  </div></td>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "SALIR"%>
                  </font> </div></td>
                  <td><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="79%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
