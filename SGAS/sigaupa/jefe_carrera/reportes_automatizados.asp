<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "reportes_automatizados.xml", "botonera"

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion
ano = conexion.consultaUno("select datepart(year,getDate())")

consulta_periodos  =  " select distinct peri_ccod,peri_tdesc " & vbCrLf &_
					  " from periodos_academicos " & vbCrLf &_
					  " where anos_ccod >= 2006 and anos_ccod <='"&ano&"' "

consulta_anos  =  " select distinct anos_ccod,anos_tdesc " & vbCrLf &_
				  " from anos " & vbCrLf &_
				  " where anos_ccod >= 2008 and anos_ccod <= datepart(year,getDate())"					   
					 
set f_busqueda_th = new CFormulario
 f_busqueda_th.Carga_Parametros "reportes_automatizados.xml", "busqueda_se"
 f_busqueda_th.Inicializar conexion
 f_busqueda_th.Consultar "select ''"
 f_busqueda_th.Siguiente

 f_busqueda_th.AgregaCampoParam "peri_ccod","destino","("&consulta_periodos&")a"

set f_busqueda_eq = new CFormulario
 f_busqueda_eq.Carga_Parametros "reportes_automatizados.xml", "busqueda_an"
 f_busqueda_eq.Inicializar conexion
 f_busqueda_eq.Consultar "select ''"
 f_busqueda_eq.Siguiente

 f_busqueda_eq.AgregaCampoParam "anos_ccod","destino","("&consulta_anos&")a"

%>


<html>
<head>
<title>Reportes Automatizados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--
function enviar(formulario){
	formulario.action = 'plan_academica.asp';
  	formulario.submit();
 }

function enviar2(formulario){
   formulario.action = 'borrar_bloque.asp';
   formulario.submit();
 }


function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}

function enviar_datos(){
var url='<%=url_horario%>';
//alert("hola "+url);
self.open('<%=url_horario%>','horario_carrera','width=700px, height=600px, scrollbars=yes, resizable=yes')

}
//-->
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif','../imagenes/botones/salir_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="201" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Reportes Semestrales</font><font size="1" face="Verdana, Arial, Helvetica, sans-serif"></font></div></td>
                    <td width="252" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="107" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                    <td width="105" align="right" bgcolor="#D8D8DE"><%'=formu_resul.dibujaCampo("peri_tdesc")%></td>
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
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador_th" method="get">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="100%"><table cellspacing=0 cellpadding=0 width="100%" border=0>
                        <tbody>
						<tr><td colspan="3">&nbsp;</td></tr>
                          <tr>
                            <td width="20%">
                              <div align="left"><strong>Período a consultar</strong></div></td>
                            <td width="2%" align="center">:</td>
                            <td width="78%" align="left"><% f_busqueda_th.dibujaCampo("peri_ccod")%></td>
                          </tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr>
						  	<td colspan="3">
								<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#666666">
									<tr>
										<td width="33%" align="center">
										   <%botonera.dibujaboton "excel_th"%>
										</td>
										<td width="34%" align="center">
										   <%botonera.dibujaboton "excel_eq"%>
										</td>
										<td width="33%" align="center">
										   <%botonera.dibujaboton "excel_fp"%>
										</td>
									</tr>
									<tr valign="top">
										<td width="33%" align="left" bgcolor="#99FF99">
										   <font color="#666666">Reporte Excel que da cuenta de los topones horarios registrados en toma de carga del período.</font>
										</td>
										<td width="34%" align="left" bgcolor="#CCFF99">
										   <font color="#666666">Reporte Excel que da cuenta de las equivalencias entre ramos de distintos nombres, que se realizaron durante el período</font>
										</td>
										<td width="33%" align="left" bgcolor="#FFFF99">
										   <font color="#666666">Reporte Excel que da cuenta de la toma de ramos de formación profesional que no presentan la equivalencia correspondiente.</font> 
										</td>
									</tr>
									<tr>
										<td width="33%" align="center">
										   <%botonera.dibujaboton "excel_fgo"%>
										</td>
										<td width="34%" align="center">
										   <%botonera.dibujaboton "excel_ps"%>
										</td>
										<td width="33%" align="center">&nbsp;
										   
										</td>
									</tr>
									<tr valign="top">
										<td width="33%" align="left" bgcolor="#CCFFCC">
										   <font color="#666666">Reporte Excel que da cuenta de la toma de ramos de formación general optativa que no presentan la equivalencia correspondiente.</font>
										</td>
										<td width="34%" align="left" bgcolor="#CCCCFF">
										   <font color="#666666">Reporte Excel que da cuenta del resultado parcial de alumnos en controles solemnes por asignatura. Sólo considera asignaturas que tengas controles solemnes programados.</font>
										</td>
										<td width="33%" align="left">
										   <font color="#666666">&nbsp;</font> 
										</td>
									</tr>
								</table>
							</td>
						  </tr>
                        </tbody>
                      </table></td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<br>
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
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="201" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Reportes Anuales</font><font size="1" face="Verdana, Arial, Helvetica, sans-serif"></font></div></td>
                    <td width="252" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="107" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                    <td width="105" align="right" bgcolor="#D8D8DE"><%'=formu_resul.dibujaCampo("peri_tdesc")%></td>
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
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<table width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
				<form name="buscador_eq" method="get">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="100%"><table cellspacing=0 cellpadding=0 width="100%" border=0>
                        <tbody>
                          <tr>
                            <td width="20%">
                              <div align="left"><strong>Año a consultar</strong></div></td>
                            <td width="2%" align="center">:</td>
                            <td width="78%" align="left"><% f_busqueda_eq.dibujaCampo("anos_ccod")%></td>
                          </tr>
						  <tr><td colspan="3">&nbsp;</td></tr>
						  <tr>
						  	<td colspan="3">
								<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#666666">
									<tr>
										<td width="33%" align="center">
										   <%botonera.dibujaboton "excel_nm"%>
										</td>
										<td width="34%" align="center">
										   <%botonera.dibujaboton "excel_ce"%>
										</td>
										<td width="33%" align="center">
										   <%botonera.dibujaboton "excel_ca"%>
										</td>
									</tr>
									<tr valign="top">
										<td width="33%" align="left" bgcolor="#FF9900">
										   <font color="#666666">Reporte Excel que da cuenta de los alumnos activos el año consultado, que no presentan matrícula para el año siguiente.</font>
										</td>
										<td width="34%" align="left" bgcolor="#FFCC00">
										   <font color="#666666">Reporte Excel que da cuenta de los alumnos que puedan caer en causal de eliminación académica por total de créditos reprobados en el año consultado.</font>
										</td>
										<td width="33%" align="left" bgcolor="#FFFF66">
										   <font color="#666666">Reporte Excel que da cuenta de la carga anual que presentan los alumnos por cada semestre del año consultado.</font> 
										</td>
									</tr>
								</table>
							</td>
						  </tr>
                        </tbody>
                      </table>
					  </td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>
	<br>
    </td>
  </tr>  
</table>
</body>
</html>