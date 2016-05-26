<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next

'f_dcur_tdesc = Request.Form("b[0][dcur_tdesc]")
'f_dcur_tdesc = Request.Form("b[0][dcur_tdesc]")
f_dcur_ncorr = Request.QueryString("dcur_ncorr")
'--------------------------------------------------

set conectar	=	new cconexion
conectar.inicializar "upacifico"
set negocio		=	new cnegocio
negocio.inicializa conectar

set pagina = new CPagina
pagina.Titulo = "Administra Encuesta"


'--------------------------------------------------
set botonera = new CFormulario
botonera.carga_parametros "administra_encuesta.xml", "botonera"


set f_busqueda	=	new cformulario
f_busqueda.inicializar		conectar
f_busqueda.carga_parametros	"administra_encuesta.xml","f_busqueda_dcur"

consulta	="select ''"
'response.Write("<pre>"&cons_factura&"</pre>")
f_busqueda.consultar	consulta
f_busqueda.siguiente

f_busqueda.AgregaCampoCons "dcur_tdesc", f_dcur_tdesc
'-------------------------------------------------------------------------
set f_resultado	=	new cformulario
f_resultado.inicializar		conectar
f_resultado.carga_parametros	"administra_encuesta.xml","f_dcur_tdesc"
 if f_dcur_tdesc <>"" then
consulta_r	="select distinct dcur_tdesc,dcur_ncorr"& vbCrLf &_
"from diplomados_cursos "& vbCrLf &_
"where dcur_tdesc like '%"&f_dcur_tdesc&"%' order by dcur_tdesc"
else
consulta_r	="select ''"
end if
'response.Write("<pre>"&consulta_r&"</pre>")
f_resultado.consultar	consulta_r
'f_resultado.siguiente
'--------------------------------------------------

dcur_tdesc=conectar.consultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&f_dcur_ncorr&"")


%>


<html>
<head>
<title>Administrador de Encuesta</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="600" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Opciones de Encuesta </font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="600" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <form name="buscador">
				  <input type="hidden" value="<%=f_dcur_ncorr%>" name="b[0]dcur_ncorr">
				  	<table width="75%" align="center">
						<tr>
							<td colspan="5" align="center"><strong><font size="2"> Programa: <%=dcur_tdesc%></font></strong></td>
						</tr>
						<tr>
							<td colspan="5" align="center">&nbsp;</td>
						</tr>
						<tr>
						<td align="center">
										<a href="javascript:_Guardar(this, document.forms['buscador'], 'habilita.asp','', '', '', 'FALSE');">												
						<img src="../gestion_encuesta/imagenes/habilita.png" border="0" width="65" height="65" alt="Creacion de Reporte Final">
							</td>
							<td align="center">
										<a href="javascript:_Guardar(this, document.forms['buscador'], 'estado_encuesta.asp','', '', '', 'FALSE');">												
						<img src="../gestion_encuesta/imagenes/tasks.png" border="0" width="65" height="65" alt="Ver estado Encuestas">					
							 </td>
							 <%aa=0%>
							 <%if aa=0 then%>
							 <td align="center">
										<a href="javascript:_Guardar(this, document.forms['buscador'], 'encuesta_infra_programa.asp','', '', '', 'FALSE');">												
						<img src="../gestion_encuesta/imagenes/infra.png" border="0" width="65" height="65" alt="Ver estado Encuestas">					
							 </td>
							 <%end if%>
							<td align="center">
										<a href="javascript:_Guardar(this, document.forms['buscador'], 'encuesta_relator.asp','', '', '', 'FALSE');">												
						<img src="../gestion_encuesta/imagenes/relatores.png" border="0" width="65" height="65" alt="Destalle Encuesta Relatores">
							</td>
							<td align="center">
										<a href="javascript:_Guardar(this, document.forms['buscador'], 'informe.asp','', '', '', 'FALSE');">												
						<img src="../gestion_encuesta/imagenes/edit2.png" border="0" width="65" height="65" alt="Creacion de Reporte Final">
							</td>
						</tr>
						<tr>
							<td align="center" >Habilitar Encuesta</td>
							<td align="center">Ver estado Encuestas</td>
							 <%if aa=0 then%>
							<td align="center">Detalle Encuesta Programa Infraestructura</td>
							<%end if%>
							<td align="center">Detalle Encuesta Relatores</td>
							<td align="center">Creaci&oacute;n de Reporte Final</td>
						</tr>
					</table>
				  </form>
				  <br>  <br/>
				 </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="125" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td align="center"><%botonera.AgregaBotonParam "salir_habili", "url", "administra_encuesta.asp"
					  						botonera.DibujaBoton"salir_habili"
					  %></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="222" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="300" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
