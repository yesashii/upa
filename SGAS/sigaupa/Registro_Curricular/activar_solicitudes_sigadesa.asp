<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_inacap.asp"-->

<%
rut       		= 	request.QueryString("rut")
dv		  		= 	request.QueryString("dv")	

set inacap		=	new cinacap
set conectar	=	new cconexion
set	documentos	=	new cFormulario

conectar.inicializar		"siga"
inacap.inicializa 			conectar

documentos.inicializar		conectar
documentos.carga_parametros	"activar_documentos.xml","tabla_documentos"

cons_documentos	= "select a.reso_ncorr,b.tdet_tdesc, b.tdet_mvalor_unitario, " & vbcrlf &_
				"	nvl(to_char(a.reso_fsolicitud,'dd/mm/yyyy'),'&nbsp;') as f_solicitud,c.esol_tdesc  " & vbcrlf &_
				"	from  " & vbcrlf &_
				"		 resoluciones a, tipos_detalle b, estados_solicitudes c " & vbcrlf &_
				"	where  " & vbcrlf &_
				"		  pers_ncorr=(select pers_ncorr from personas where pers_nrut='"& rut &"') " & vbcrlf &_
				"		  and a.tdet_ccod=b.tdet_ccod " & vbcrlf &_
				"		  and a.esol_ccod=4 " & vbcrlf &_
				"		  and a.esol_ccod=c.esol_ccod "

documentos.consultar	cons_documentos

alumno		=	conectar.consultauno("select pers_tape_paterno||' '||pers_tape_materno||', '|| pers_tnombre from personas where pers_nrut='" & rut & "'")

pers_ncorr	=	conectar.consultauno("select pers_ncorr from personas where pers_nrut='" & rut & "'")	

institucion	=	conectar.consultauno("select inst_trazon_social " & vbcrlf &_
									"	from " & vbcrlf &_
									"		alumnos a, " & vbcrlf &_
									"		ofertas_academicas b, " & vbcrlf &_
									"		especialidades c, " & vbcrlf &_
									"		carreras d, " & vbcrlf &_
									"		instituciones e " & vbcrlf &_
									"	where " & vbcrlf &_
									"		 a.ofer_ncorr=b.ofer_ncorr " & vbcrlf &_
									"		 and b.espe_ccod=c.espe_ccod " & vbcrlf &_
									"		 and c.carr_ccod=d.carr_ccod " & vbcrlf &_
									"		 and d.inst_ccod=e.inst_ccod " & vbcrlf &_
									"		 and a.matr_ncorr=(select max(matr_ncorr) from alumnos where pers_ncorr='"& pers_ncorr &"')")

%>
<html>
<head>

<style>
@media print{ .noprint {visibility:hidden; }}
</style>


<title>Activar Solicitudes</title>
<meta http-equiv="Content-Type" content="text/html;">
<link href="file:../estilos/estilos.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/tabla.js" type="text/JavaScript"></script>
<script language="JavaScript" src="../biblioteca/validadores.js" type="text/JavaScript"></script>
<script language="JavaScript" src="../biblioteca/funciones.js" type="text/JavaScript"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("reso_ncorr","gi");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				c=c+1;
			}
		}
	}
	if (c<=0) {
		check = 0;
	}
	else {
		if (c > 1){
			check=2;
		}
		else{
			if (c==1){
				check=1;
			}
		}
	}
	return(check);
}
function enviar(formulario){
		if(!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))){
		    alert('El RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
			formulario.rut.focus();
			formulario.rut.select();
		 }
		else{
			formulario.action = 'activar_solicitudes.asp';
			formulario.submit();
		}
}

function activar(formulario){
	if (verifica_check(formulario)==1){
		formulario.action='activar_compromisos.asp';
		formulario.submit();
	}
	else {
		if (verifica_check(formulario)==2){
			alert('No puede seleccionar mas de un documento para activar.');
		}
		else {
			if ((verifica_check(formulario)==0)){
				alert('No ha seleccionado ningún documento para activar.');
			}
		}
	}
	
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
<STYLE type="text/css">
 <!-- 
 A {color: #000000;  text-decoration: none; font-weight: bold;}
 A:hover {COLOR: #63ABCC; }

 // -->
 </STYLE>
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<!-- Fireworks MX Dreamweaver MX target.  Created Wed Oct 30 14:14:24 GMT+0100 (Hora estándar romance) 2002-->
<link href="../biblioteca/tabla.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#21559C" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/salir_f2.gif','../imagenes/buscador/buscar_f2.gif')">
<br>
<table border="0" cellpadding="0" cellspacing="0" width="754" align="center">
  <!-- fwtable fwsrc="portada.png" fwbase="portada.gif" fwstyle="Dreamweaver" fwdocid = "863525517" fwnested="0" -->
  <tr> 
    <td><img src="../images/spacer.gif" width="9" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="14" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="175" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="535" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="21" height="1" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="1" height="1" border="0" alt=""></td>
  </tr>
  <div class="noprint">
 <tr> 
      <td colspan="2" valign="top">
<div class="noprint"><img name="portada_r2_c1" src="../images/portada_r2_c1.gif" width="23" height="26" border="0" alt=""></div></td>
      <td background="../images/portada_r2_c4.gif">
<div class="noprint">
          <input name="imageField" type="image" src="images/cajero.gif" width="175" height="26" border="0">
        </div></td>
    <td align="right" background="../images/portada_r2_c4.gif""><strong>
        <div class="noprint"></div>
        </strong></td>
    <td><div class="noprint"><img name="portada_r2_c5" src="../images/portada_r2_c5.gif" width="21" height="26" border="0" alt=""></div></td>
    <td><img src="../images/spacer.gif" width="1" height="26" border="0" alt=""></td>
  </tr>
  </div>
  <tr> 
    <td colspan="2" rowspan="2" background="../images/portada_r3_c1.gif">
<div class="noprint"><img name="portada_r3_c1" src="../images/portada_r3_c1.gif" width="23" height="336" border="0" alt=""></div></td>
    <td colspan="2" rowspan="2" valign="top" bgcolor="#2359A3"> 
      <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
        <!-- fwtable fwsrc="marco ancho.png" fwbase="int_ancha.gif" fwstyle="Dreamweaver" fwdocid = "342205829" fwnested="0" -->
        <tr> 
          <td><img src="../images/spacer.gif" width="6" height="1" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="463" height="1" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="19" height="1" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="198" height="1" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="9" height="1" border="0" alt=""></td>
          <td><img src="../images/spacer.gif" width="1" height="1" border="0" alt=""></td>
        </tr>
        <tr> 
          <td colspan="5" valign="top" bgcolor="#F1F1E4"> 
            <div class="noprint">
              <table width="100%" border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
                <tr bordercolor="#FFFFFF"> 
                  <td height="16" bgcolor="#F1F1E4">
<p><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><img src="../images/flecha2.gif" width="7" height="7"> 
                      <b><font color="#CC3300">ACTIVAR SOLICITUDES</font></b></font></p>
                    </td>
                </tr>
              </table>
            <div class="noprint">
		   <form action="" method="get" name="buscador">
					    
                  <table width="97%" border="0" align="right" cellpadding="0" cellspacing="0">
                    <!-- fwtable fwsrc="buscardor.png" fwbase="buscardor.gif" fwstyle="Dreamweaver" fwdocid = "1948393504" fwnested="0" -->
                    <tr> 
                      <td width="8"><img src="../imagenes/buscador/spacer.gif" width="8" height="1" border="0" alt=""></td>
                      <td width="94"><img src="../imagenes/buscador/spacer.gif" width="80" height="1" border="0" alt=""></td>
                      <td width="567"><img src="../imagenes/buscador/spacer.gif" width="381" height="1" border="0" alt=""></td>
                      <td width="21"><img src="../imagenes/buscador/spacer.gif" width="21" height="1" border="0" alt=""></td>
                      <td width="69"><img src="../imagenes/buscador/spacer.gif" width="51" height="1" border="0" alt=""></td>
                      <td width="11"><img src="../imagenes/buscador/spacer.gif" width="7" height="1" border="0" alt=""></td>
                      <td width="22"><img src="../imagenes/buscador/spacer.gif" width="1" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td rowspan="5"><img name="buscardor_r1_c1" src="../imagenes/buscador/buscardor_r1_c1.gif" width="8" height="80" border="0" alt=""></td>
                      <td background="../imagenes/buscador/buscardor_r1_c3.gif"><img name="buscardor_r1_c2" src="../imagenes/buscador/buscardor_r1_c2.gif" width="80" height="17" border="0" alt=""></td>
                      <td background="../imagenes/buscador/buscardor_r1_c3.gif" width="567">&nbsp;</td>
                      <td width="21"rowspan="5" align="center" background="../imagenes/buscador/fondo.gif"><img name="buscardor_r1_c4" src="../imagenes/buscador/buscardor_r1_c4.gif" width="21" height="80" border="0" alt=""></td>
                      <td rowspan="2" background="../imagenes/buscador/buscardor_r1_c5.gif"> 
                        <div align="right"></div></td>
                      <td rowspan="5"><div align="left"><img name="buscardor_r1_c6" src="../imagenes/buscador/buscardor_r1_c6.gif" width="7" height="80" border="0" alt=""></div></td>
                      <td><img src="../imagenes/buscador/spacer.gif" width="1" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td rowspan="3" colspan="2" bgcolor="#E4E4CB"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td nowrap> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut&nbsp;<strong> 
                                <input type="text" name="rut" size="10" maxlength="8" id="rut" value="<%=rut%>">
                                - 
                                <input type="text" name="dv" size="2" maxlength="1" value="<%=dv%>" id="LE-N" 			onKeyUp="this.value=this.value.toUpperCase();">
                                </strong><a href="javascript:buscar_persona();"><img src="../images/lupa_f2.gif" width="16" height="15" border="0"></a><strong> 
                                </strong></font></div>
                              <div align="center"></div></td>
                          </tr>
                        </table></td>
                      <td><img src="../imagenes/buscador/spacer.gif" width="1" height="16" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td align="center" bgcolor="ffffff"> <div align="right"><a href="javascript:enviar(document.buscador);" target="_top" onClick="MM_nbGroup('down','group1','buscardor_r3_c5','',1)" onMouseOver="MM_nbGroup('over','buscardor_r3_c5','../imagenes/buscador/buscar_f2.gif','',1)" onMouseOut="MM_nbGroup('out')"><img name="buscardor_r3_c5" src="../imagenes/buscador/buscar.gif" width="51" height="20" border="0" alt=""></a></div></td>
                      <td><img src="../imagenes/buscador/spacer.gif" width="1" height="20" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td rowspan="2" background="../imagenes/buscador/buscardor_r4_c5.gif"> 
                        <div align="right"></div></td>
                      <td><img src="../imagenes/buscador/spacer.gif" width="1" height="9" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td colspan="2" background="../imagenes/buscador/buscardor_r5_c2.gif">&nbsp;</td>
                      <td><img src="../imagenes/buscador/spacer.gif" width="1" height="18" border="0" alt=""></td>
                    </tr>
                  </table>
                </form></div></div></td>
          <td><img src="../images/spacer.gif" width="1" height="21" border="0" alt=""></td>
        </tr>
        <tr> 
          <td background="../images/int_ancha_r2_c5.gif"> <p>&nbsp;</p>
            <p>&nbsp;</p></td>
          <td colspan="3" valign="top" bgcolor="#F1F1E4"> 
            <form action="" method="post" name="editar" >
             <br>
              <table width="98%" border="1" align="center" cellpadding="5" cellspacing="0" bordercolor="#A0C0EB" bgcolor="#FBFBF7">
                <tr> 
                  <td align="left" valign="top"> 
				   <%if rut <> "" then %>
                    <table width="50%" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td>Resultado de la B&uacute;squeda</td>
                      </tr>
                      <tr> 
                        <td nowrap><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Rut: 
                          <strong><%=rut%>-<%=dv%></strong> Nombre:<strong><%=alumno%> </strong></font></td>
                      </tr>
                      <tr>
                        <td nowrap>Instituci&oacute;n: <strong><%=institucion%></strong></td>
                      </tr>
                      <tr> 
                        <td nowrap>&nbsp;</td>
                      </tr>
                    </table> 
               
                      <%end if%>
                    <input type="hidden" name="act[0][rut]" value="<%=rut%>">
					<input name="act[0][dv]" type="hidden" value="<%=dv%>">
                    <br>
                   
                    <br>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td align="center"><strong>DOCUMENTOS SOLICITADOS</strong></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>P&aacute;ginas: </strong> <%documentos.AccesoPagina%> </td>
                      </tr>
                      <tr> 
                        <td align="center"> <%documentos.dibujatabla()%> <input type="hidden" name="act[0][pers_ncorr]" value="<%=pers_ncorr%>"> 
                        </td>
                      </tr>
                      <tr> 
                        <td align="center"><table width="5%" border="0" align="right" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><input type="button" name="Button" value="Activar" onClick="javascript:activar(document.editar);"></td>
                            </tr>
                          </table></td>
                      </tr>
                      <tr> 
                        <td align="center">&nbsp;</td>
                      </tr>
                    </table>
                   
                    
                  </td>
                </tr>
              </table>
            </form></td>
          <td background="../images/int_ancha_r2_c5.gif" >&nbsp;</td>
          <td><img src="../images/spacer.gif" width="1" height="147" border="0" alt=""></td>
        </tr>
      </table>
      <div align="center">
        <div class="noprint">
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
          <!-- fwtable fwsrc="marco.png" fwbase="botonera.gif" fwstyle="Dreamweaver" fwdocid = "342205829" fwnested="0" -->
          <tr> 
            <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="4" height="1" border="0" alt=""></td>
            <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="318" height="1" border="0" alt=""></td>
            <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="19" height="1" border="0" alt=""></td>
            <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="65" height="1" border="0" alt=""></td>
            <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="67" height="1" border="0" alt=""></td>
            <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="66" height="1" border="0" alt=""></td>
            <td bgcolor="#F1F1E4"><img src="../images/spacer.gif" width="9" height="1" border="0" alt=""></td>
            <td><img src="../images/spacer.gif" width="1" height="1" border="0" alt=""></td>
          </tr>
          <tr> 
            <td rowspan="4" bgcolor="#F1F1E4"><img name="botonera_r1_c1" src="../images/botonera_r1_c1.gif" width="4" height="31" border="0" alt=""></td>
            <td rowspan="2" bgcolor="#F1F1E4">&nbsp;</td>
            <td width="19" rowspan="4"><img name="botonera_r1_c3" src="../images/botonera_r1_c3.gif" width="19" height="31" border="0" alt=""></td>
            <td colspan="3" background="../images/botonera_r1_c4.gif"><img name="botonera_r1_c4" src="../images/botonera_r1_c4.gif" width="280" height="4" border="0" alt=""></td>
            <td rowspan="4"><img name="botonera_r1_c7" src="../images/botonera_r1_c7.gif" width="9" height="31" border="0" alt=""></td>
            <td><img src="../images/spacer.gif" width="1" height="4" border="0" alt=""></td>
          </tr>
          <tr> 
            <td rowspan="2" bgcolor="B2B2B2">&nbsp;</td>
              <td rowspan="2" align="center" bgcolor="B2B2B2">&nbsp;</td>
              <td rowspan="2" align="center" bgcolor="B2B2B2"><a href="portada.asp" target="_top" onClick="MM_nbGroup('down','group1','salir','',1)" onMouseOver="MM_nbGroup('over','salir','../imagenes/botones/salir_f2.gif','',1)" onMouseOut="MM_nbGroup('out')"><img src="../imagenes/botones/salir.gif" name="salir" width="67" height="20" border="0"></a></td>
            <td><img src="../images/spacer.gif" width="1" height="15" border="0" alt=""></td>
          </tr>
          <tr> 
            <td rowspan="2" background="../images/botonera_r3_c2.gif"><img name="botonera_r3_c2" src="../images/botonera_r3_c2.gif" width="1" height="12" border="0" alt=""></td>
            <td><img src="../images/spacer.gif" width="1" height="5" border="0" alt=""></td>
          </tr>
          <tr> 
            <td colspan="3" background="../images/botonera_r4_c4.gif"><img name="botonera_r4_c4" src="../images/botonera_r4_c4.gif" width="198" height="7" border="0" alt=""></td>
            <td><img src="../images/spacer.gif" width="1" height="7" border="0" alt=""></td>
          </tr>
        </table>
		</div>
      </div></td>
    <td rowspan="2" background="../images/portada_r3_c5.gif">
<div class="noprint"></div></td>
    <td><img src="../images/spacer.gif" width="1" height="160" border="0" alt=""></td>
  </tr>
  <tr> 
    <td><img src="../images/spacer.gif" width="1" height="176" border="0" alt=""></td>
  </tr>
</table>
<p>&nbsp;</p>
</body>
</html>
