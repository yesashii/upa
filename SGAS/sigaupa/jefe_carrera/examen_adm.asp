<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "examen_adm.xml", "btn_examen_adm"

rut=request.querystring("rut")
dv=request.querystring("dv")
jornada=request.QueryString("ale[0][jorn_ccod]")
especialidad=request.QueryString("ale[0][carrera]")

set conectar 	= 	new cconexion
set ftabla 		= 	new cformulario
set fpersona	=	new cformulario
set negocio		= 	new cnegocio

conectar.inicializar "upacifico"

negocio.inicializa conectar

ftabla.carga_parametros 	"examen_adm.xml", 	"examen"
fpersona.carga_parametros	"examen_adm.xml",	"alum_exa"
ftabla.inicializar conectar
fpersona.inicializar conectar

sede_ccod = negocio.obtenersede
peri_ccod=negocio.obtenerperiodoacademico("postulacion")

cons="SELECT '' as carrera, '' as jorn_ccod, '" & jornada & "' as jornada, '" & especialidad & "' as programa"


personas = "select distinct " & vbCrLf &_
" cast(a.pers_nrut as varchar) + ' - ' + a.pers_xdv as rut, a.pers_tape_paterno + ' ' + a.pers_tape_materno + ', ' + a.pers_tnombre as alumno, b.post_ncorr, c.peri_ccod " & vbCrLf &_
" from " & vbCrLf &_
" personas a, postulantes b, ofertas_academicas c, especialidades d, sedes e, jornadas f " & vbCrLf &_
" where " & vbCrLf &_
" a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
" and b.ofer_ncorr=c.ofer_ncorr " & vbCrLf &_
" and c.espe_ccod=d.espe_ccod "& vbCrLf &_
" and c.sede_ccod=e.sede_ccod " & vbCrLf &_
" and c.jorn_ccod=f.jorn_ccod " & vbCrLf &_
" and b.peri_ccod=c.peri_ccod " & vbCrLf &_
" and cast(e.sede_ccod as varchar)='" & sede_ccod & "' " & vbCrLf &_
" and cast(d.espe_ccod as varchar)='" & especialidad & "' " & vbCrLf &_
" and cast(f.jorn_ccod as varchar)='" & jornada & "' " & vbCrLf &_
" and cast(c.peri_ccod as varchar)='" & peri_ccod & "' " & vbCrLf &_
" order by alumno"

'response.Write("<pre>"&personas&"</pre>")
'response.Flush()


ftabla.consultar cons
fpersona.consultar personas

ftabla.agregaCampoParam "carrera", "filtro", " cast(sede_ccod as varchar)= '" & sede_ccod &"'" 
ftabla.agregaCampoParam "jornada", "filtro", " cast(jorn_ccod as varchar)= '" & jornada &"'" 
ftabla.agregaCampoParam "programa", "filtro", " cast(sede_ccod as varchar)= '" & sede_ccod &"'" 

ftabla.agregaCampoCons "jorn_ccod",jornada
ftabla.agregaCampoCons "carrera",especialidad
ftabla.siguiente


%>


<html>
<head>
<title>Examen de Admisi&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
<!--
function abrir() {
	if (verifica_check(document.edicion)){
		if(preValidaFormulario(document.edicion)){
			direccion = "about:blank";
			resultado=window.open(direccion, "ventana1","width=780,height=400,scrollbars=YES, resizable=yes, left=0, top=0");
			document.edicion.target = 'ventana1';
			document.edicion.action = 'edicion_pago.asp';
			document.edicion.submit();
		}
	}
	else {
		alert('Error: \nDebe seleccionar al menos el primer compromiso');
	}
}

function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("dcom_ncompromiso","gi");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				return (true);
			}
			else {
				return (false);
			}
		}
	}
}

function enviar(formulario){
	formulario.action = 'examen_adm.asp';
	formulario.submit();
}

function guardar(formulario){
	formulario.action='actualizar_examen.asp';
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
//-->
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
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
                    <td width="100" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                <td width="9" height="92" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador" method="get">
                  <table width="98%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                  <td width="8%"><div align="center"><font face="Arial, Helvetica, sans-serif" size="2">Carrera </font></div></td>
								  <td width="2%"><div align="center"><strong>:</strong></div></td>
                                  <td><div align="left"><%=ftabla.dibujaCampo("carrera")%></div></td>
                                </tr>
								<tr> 
                                  <td width="8%"><div align="center"><font face="Arial, Helvetica, sans-serif" size="2">Jornada</font></div></td>
								  <td width="2%"><div align="center"><strong>:</strong></div></td>
                                  <td><div align="left"><%=ftabla.dibujaCampo("jorn_ccod")%></div></td>
                                </tr>
								<tr> 
                                    <td colspan="3"><div align="right"><%botonera.dibujaboton "buscar"%></div></td>
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
                      <td width="10" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="212" valign="middle" background="../imagenes/fondo1.gif">
                        <div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><b><font color="#CC3300"><font color="#FFFFFF">EXAMEN
                      DE ADMISIÓN</font></font></b><b></b></font></div></td>
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
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
				    <form name="edicion" method="post">
			         
                            <%if jornada <> "" and especialidad <> "" then %>
<table width="50%" align="left" cellpadding="0" cellspacing="0">
                              <tr> 
                                <td>Resultado de la B&uacute;squeda</td>
                              </tr>
                              <tr> 
                                <td nowrap><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Programa 
                                  de estudio: <strong><%=ftabla.dibujaCampo("programa")%></strong> Jornada:<strong> <%=ftabla.dibujaCampo("jornada")%></strong></font></td>
                              </tr>
                      </table>
							<%else 
							response.Write("Debe Seleccionar un programa de estudio y una jornada.")
							end if%>
                            <br>
                             <br> <br> 
                            <table width="97%" align="center" cellpadding="0" cellspacing="0">
                              <tr> 
                                <td></td>
                              </tr>
                              <tr> 
                                <td height="13" align="center"><strong>POSTULANTES 
                                  INSCRITOS PARA RENDIR EXAMEN</strong></td>
                              </tr>
                              <tr>
                                <td align="right">&nbsp;</td>
                              </tr>
                              <tr> 
                               <%if jornada <>"" and especialidad <> "" then%>
							    <td align="right"><strong>Páginas:</strong> <%fpersona.accesoPagina%> </td>
								<%end if%>
                              </tr>
                              <tr> 
                                <td align="center">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td align="center"> <%fpersona.dibujaTabla()%> </td>
                              </tr>
                            </table>
                            <br>
                            <table width="50%" align="right" cellpadding="0" cellspacing="0">
                              <tr>
                                <td width="76%">&nbsp;</td>
                                <td width="24%" align="center"><%botonera.dibujaboton "guardar"%></td>
                              </tr>
                            </table> <br> <br>
				    </form>
				    <p>
                    <p>                                        <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="89" bgcolor="#D8D8DE"> <div align="right"><%botonera.dibujaboton "salir"%></div></td>
                  <td width="273" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			  <br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
