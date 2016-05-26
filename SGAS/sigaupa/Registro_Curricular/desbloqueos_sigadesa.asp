<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_inacap.asp" -->

<%
rut	=	request.querystring("rut")
dv	=	request.querystring("dv")

set	inacap			=	new cinacap
set conectar		=	new cconexion
set tabla_desbloqueo	= new cformulario

conectar.inicializar	"siga"
inacap.inicializa		conectar

tabla_desbloqueo.inicializar		conectar
tabla_desbloqueo.carga_parametros	"f_desbloqueos.xml","tabla_desbloqueos"

cons_tabla	=	"select d.sede_tdesc,b.bloq_ncorr,b.pers_ncorr, a.pers_nrut || '-' || a.pers_xdv  as rut " & _
	  " , a.pers_tape_paterno || ' ' ||   a.PERS_TAPE_MATERNO || ' ' || a.pers_tnombre as nombre " & _
      " , decode(b.bloq_nresolucion,null,'',b.bloq_nresolucion) as bloq_nresolucion,decode(to_char(b.bloq_fresolucion,'dd/mm/yyyy'),null,'',to_char(b.bloq_fresolucion,'dd/mm/yyyy')) as  bloq_fresolucion,to_char(b.bloq_fbloqueo,'dd/mm/yyyy') as bloq_fbloqueo, to_char(b.bloq_fbloqueo,'dd/mm/yyyy') as fbloqueo,c.tblo_ccod,c.tblo_tdesc,b.eblo_ccod,b.bloq_tobservacion,b.tblo_ccod,b.eblo_ccod " & _
	  " from  personas a,bloqueos b, tipos_bloqueos c, sedes d " & _
      " where a.pers_ncorr=b.pers_ncorr " & _
	  " and b.tblo_ccod=c.tblo_ccod " & _
	  " and b.sede_ccod=d.sede_ccod " & _
	  " and b.eblo_ccod in (1) " & _
	  " and a.pers_nrut='"& rut &"' " & _
      " and a.pers_xdv='"& dv &"' " & _
      " order by b.eblo_ccod ,bloq_fbloqueo desc "

tabla_desbloqueo.consultar	cons_tabla


registros	=	conectar.consultauno("select count(*) from ("&cons_tabla&")")

alumno	=	conectar.consultauno("select pers_tape_paterno||' '||pers_tape_materno||', '||pers_tnombre as alumno from personas where pers_nrut='"& rut &"'")

 
%>
<html>
<head>
<title>Desactivar Bloqueos</title>
<meta http-equiv="Content-Type" content="text/html;">
<link href="../biblioteca/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/tabla.js" type="text/JavaScript"></script>


<STYLE type="text/css">
 <!-- 
 A {color: #000000;  text-decoration: none; font-weight: bold;}
 A:hover {COLOR: #63ABCC; }

 // -->
 </STYLE>
<!-- Fireworks MX Dreamweaver MX target.  Created Fri Nov 08 14:00:45 GMT+0100 (Hora estándar romance) 2002-->
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
<!--
var n
function enviar(formulario){
		if(!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))){
		    alert('El RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
			formulario.rut.focus();
			formulario.rut.select();
		 }
		else{
			formulario.action = 'desbloqueos.asp';
			formulario.submit();
		}
}

function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("bloq_ncorr","gi");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				c=c+1;
			}
		}
	}
	if (c>0) {
		return(true);
	}
	else {
		return(false);
	}
}

function guardar(formulario){
	if (revisa_form(formulario)){
		formulario.action='actualizar_bloqueos.asp'
		formulario.submit();
	}
}

function revisa_form(formulario){
	elementos=formulario.elements.length;
	for (i=0;i<elementos;i++){
		nombre =  formulario.elements[i].name;
		var campos=new RegExp ("bloq_ncorr","gi");
		if (campos.test(nombre)){
			if (formulario.elements[i].checked==true ){
						if (formulario.elements[i+1].value==''){
							alert('No puede dejar este campo vacío.');
							formulario.elements[i+1].focus();
							return (false);
						}
						else {
							if (!isInteger(formulario.elements[i+1].value)){
								alert('Ingrese un número entero válido.');
								formulario.elements[i+1].focus();
								return (false);
							}
							else{
								if (formulario.elements[i+2].value=='' ){
									alert('No puede dejar este campo vacío.');
									formulario.elements[i+2].focus();
									return (false);
								}
								else {
									if (!isFecha(formulario.elements[i+2].value)){
										alert('Ingrese un formato de fecha válido (dd/mm/aaaa) .');
										formulario.elements[i+2].focus();
										return (false);
									}
									else {
										if(!comparaFechas(formulario.elements[i+2].value,formulario.elements[i+3].value)){
											alert('Las fecha de resolución debe ser mayor a la fecha de bloqueo.');
											formulario.elements[i+2].focus();
											return (false);
										}
									}
								}
							}
						}
			  }
			
		}//if
	}//for
	return(true);
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
<body bgcolor="#21559C" onLoad="MM_preloadImages('../images/items_r1_c1_f2.gif','../images/items_r1_c3_f2.gif','../images/items_r1_c5_f2.gif','../images/items_r1_c7_f2.gif','../images/items_r3_c1_f2.gif','../images/items_r3_c3_f2.gif','../imagenes/buscador/buscar_f2.gif')" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onBlur="revisaVentana();">
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
  <tr> 
    <td colspan="3">&nbsp;</td>
    <td colspan="2">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2"><img name="portada_r2_c1" src="../images/portada_r2_c1.gif" width="23" height="26" border="0" alt=""></td>
    <td><img name="reg_curricular" src="images/reg_curricular.gif" width="175" height="26" border="0" alt=""></td>
    <td width="535" height="26" background="../images/portada_r2_c4.gif"><div align="right"><!-- #BeginLibraryItem "/Library/usuario.lbi" -->
<strong><font color="#FFFFFF"> <%=inacap.obtenerNombreUsuario%> - <%=inacap.obtenerNombreSede%> 
- <%=inacap.obtenerFechaActual%> </font> </strong><!-- #EndLibraryItem --></div></td>
    <td><img name="portada_r2_c5" src="../images/portada_r2_c5.gif" width="21" height="26" border="0" alt=""></td>
    <td><img src="../images/spacer.gif" width="1" height="26" border="0" alt=""></td>
  </tr>
  <tr> 
    <td colspan="2" rowspan="2" background="../images/portada_r3_c1.gif"><img name="portada_r3_c1" src="../images/portada_r3_c1.gif" width="23" height="336" border="0" alt=""></td>
    <td rowspan="2" colspan="2" bgcolor="#2359A3"> <div align="center">
        <table border="0" cellpadding="0" cellspacing="0" width="695" align="center">
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
            <td colspan="5" bgcolor="#F1F1E4"> <table width="100%" border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
                <tr bordercolor="#FFFFFF"> 
                  <td align="left" bgcolor="#F1F1E4"> <font size="1" face="Verdana, Arial, Helvetica, sans-serif"> 
                    <img src="../images/flecha2.gif" width="7" height="7"> <b><font color="#CC3300">DESACTIVAR 
                    BLOQUEOS</font></b></font></td>
                </tr>
              </table></td>
            <td><img src="../images/spacer.gif" width="1" height="21" border="0" alt=""></td>
          </tr>
          <tr> 
            <td height="299" valign="top" background="../images/int_ancha_r2_c1.gif"><img name="int_ancha_r2_c1" src="../images/int_ancha_r2_c1.gif" width="6" height="147" border="0" alt=""></td>
            <td colspan="3" valign="top" bgcolor="#F1F1E4"> 
              <table width="100%" border="0" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td height="50" valign="middle"> <div align="center"> 
                       <form action="" method="get" name="buscador">
					    <table width="97%" border="0" align="right" cellpadding="0" cellspacing="0">
                          <!-- fwtable fwsrc="buscardor.png" fwbase="buscardor.gif" fwstyle="Dreamweaver" fwdocid = "1948393504" fwnested="0" -->
                          <tr> 
                            <td width="8"><img src="../imagenes/buscador/spacer.gif" width="8" height="1" border="0" alt=""></td>
                            <td width="81"><img src="../imagenes/buscador/spacer.gif" width="80" height="1" border="0" alt=""></td>
                            <td width="480"><img src="../imagenes/buscador/spacer.gif" width="381" height="1" border="0" alt=""></td>
                            <td width="21"><img src="../imagenes/buscador/spacer.gif" width="21" height="1" border="0" alt=""></td>
                            <td width="52"><img src="../imagenes/buscador/spacer.gif" width="51" height="1" border="0" alt=""></td>
                            <td width="10"><img src="../imagenes/buscador/spacer.gif" width="7" height="1" border="0" alt=""></td>
                            <td width="16"><img src="../imagenes/buscador/spacer.gif" width="1" height="1" border="0" alt=""></td>
                          </tr>
                          <tr> 
                            <td rowspan="5"><img name="buscardor_r1_c1" src="../imagenes/buscador/buscardor_r1_c1.gif" width="8" height="80" border="0" alt=""></td>
                            <td><img name="buscardor_r1_c2" src="../imagenes/buscador/buscardor_r1_c2.gif" width="80" height="17" border="0" alt=""></td>
                            <td background="../imagenes/buscador/buscardor_r1_c3.gif" width="480">&nbsp;</td>
                            <td width="21" rowspan="5"><img name="buscardor_r1_c4" src="../imagenes/buscador/buscardor_r1_c4.gif" width="21" height="80" border="0" alt=""></td>
                            <td rowspan="2" background="../imagenes/buscador/buscardor_r1_c5.gif"> 
                              <div align="right"></div></td>
                            <td rowspan="5"><div align="left"><img name="buscardor_r1_c6" src="../imagenes/buscador/buscardor_r1_c6.gif" width="7" height="80" border="0" alt=""></div></td>
                            <td><img src="../imagenes/buscador/spacer.gif" width="1" height="17" border="0" alt=""></td>
                          </tr>
                          <tr> 
                            <td rowspan="3" colspan="2" bgcolor="#E4E4CB"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                  <td nowrap> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut&nbsp;<strong> 
                                      <input type="text" name="rut" size="10" maxlength="8" id="NU-N" value="<%=rut%>">
                                      - 
                                      <input type="text" name="dv" size="2" maxlength="1" id="LE-N" 			onKeyUp="this.value=this.value.toUpperCase();" value="<%=dv%>">
                                      </strong><a href="javascript:buscar_persona();"><img src="../images/lupa_f2.gif" width="16" height="15" border="0"></a><strong> 
                                      </strong></font></div>
                                    <div align="center"></div></td>
                                </tr>
                              </table></td>
                            <td><img src="../imagenes/buscador/spacer.gif" width="1" height="16" border="0" alt=""></td>
                          </tr>
                          <tr> 
                            <td><div align="right"><a href="javascript:enviar(document.buscador);" target="_top" onClick="MM_nbGroup('down','group1','buscardor_r3_c5','',1)" onMouseOver="MM_nbGroup('over','buscardor_r3_c5','../imagenes/buscador/buscar_f2.gif','',1)" onMouseOut="MM_nbGroup('out')"><img name="buscardor_r3_c5" src="../imagenes/buscador/buscar.gif" width="51" height="20" border="0" alt=""></a></div></td>
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
                        </table></form>
                      </div></td>
                  </tr>
                  <tr> 
                    
                  <td valign="top"> 
                    <form name="editar" method="post">
                      <table width="95%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0C0EB" bgcolor="#FBFBF7">
                        <tr> 
                          <td align="left">
                            <%if rut <> "" then%>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td colspan="3">Resultado de la b&uacute;squeda:</td>
                              </tr>
                              <tr> 
                                <td width="9%">&nbsp;</td>
                                <td width="1%">&nbsp;</td>
                                <td width="90%">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td nowrap><strong>RUT</strong></td>
                                <td nowrap><strong>:</strong></td>
                                <td nowrap><strong><%=rut%>-<%=dv%></strong></td>
                              </tr>
                              <tr> 
                                <td nowrap><strong>NOMBRE</strong></td>
                                <td nowrap><strong>:</strong></td>
                                <td nowrap><strong><%=alumno%></strong></td>
                              </tr>
                            </table>
                            <%
					  else
							response.Write("Ingrese el Rut del alumno que desea consultar.")
					  end if
					  %>
                            <br>
                            <br>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td align="center"><strong>LISTADO DE BLOQUEOS 
                                  ACTIVOS </strong></td>
                              </tr>
                              <tr>
                                <td align="right"> 
                                  <%if tabla_desbloqueo.nrofilas > 0 then%>
								<strong>Páginas: <%tabla_desbloqueo.accesoPagina()%></strong>
								<% end if %>
                                </td>
                              </tr>
                              <tr>
                                <td>&nbsp;</td>
                              </tr>
                              <tr>
                                <td align="center">
								<%tabla_desbloqueo.dibujatabla()%>
								<input type="hidden" name="registros" value="<%=registros%>">
                                  <input type="hidden" name="rut" value="<%=rut%>">	
                                </td>
                              </tr>
                            </table>
                            * Debe seleccionar el o los bloqueos, completar el 
                            o los Nros. y Fechas de Resoluci&oacute;n y presionar 
                            el bot&oacute;n <em>&quot;Guardar&quot;</em> para 
                            debloquear.<br>
                            <table width="1%" align="right" cellpadding="0" cellspacing="0">
                            <tr> 
                                <td>&nbsp;</td>
                                <td width="5%"><a href="javascript:guardar(document.editar);"><img src="../images/guardar2.gif" width="66" height="20" border="0"></a></td>
                            </tr>
                          </table> </td>
                        </tr>
                      </table>
					  </form>
					  </td>
                  </tr>
                  <tr> 
                  <td >&nbsp;</td>
                  </tr>
                </table>
</td>
            <td valign="top" background="../images/int_ancha_r2_c5.gif"><img name="int_ancha_r2_c5" src="../images/int_ancha_r2_c5.gif" width="9" height="147" border="0" alt=""></td>
            <td valign="top"><img src="../images/spacer.gif" width="1" height="147" border="0" alt=""></td>
          </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td rowspan="4"><img name="botonera_r1_c3" src="../images/botonera_r1_c3.gif" width="19" height="31" border="0" alt=""></td>
            <td colspan="3" background="../images/botonera_r1_c4.gif"><img name="botonera_r1_c4" src="../images/botonera_r1_c4.gif" width="198" height="4" border="0" alt=""></td>
            <td rowspan="4"><img name="botonera_r1_c7" src="../images/botonera_r1_c7.gif" width="9" height="31" border="0" alt=""></td>
            <td><img src="../images/spacer.gif" width="1" height="4" border="0" alt=""></td>
          </tr>
          <tr> 
            <td rowspan="2" bgcolor="#B9B9B9">&nbsp;</td>
            <td rowspan="2" bgcolor="#B9B9B9">&nbsp;</td>
            <td rowspan="2" bgcolor="#B9B9B9"><a href="javascript:window.close();"><img name="botonera_r2_c6" src="../images/botonera_r2_c6.gif" width="66" height="20" border="0" alt=""></a></td>
            <td><img src="../images/spacer.gif" width="1" height="15" border="0" alt=""></td>
          </tr>
          <tr> 
            <td rowspan="2"><img name="botonera_r3_c2" src="../images/botonera_r3_c2.gif" width="465" height="12" border="0" alt=""></td>
            <td><img src="../images/spacer.gif" width="1" height="5" border="0" alt=""></td>
          </tr>
          <tr> 
            <td colspan="3" background="../images/botonera_r4_c4.gif"><img name="botonera_r4_c4" src="../images/botonera_r4_c4.gif" width="198" height="7" border="0" alt=""></td>
            <td><img src="../images/spacer.gif" width="1" height="7" border="0" alt=""></td>
          </tr>
        </table>
      </div></td>
    <td rowspan="2" background="../images/portada_r3_c5.gif">&nbsp;</td>
    <td><img src="../images/spacer.gif" width="1" height="160" border="0" alt=""></td>
  </tr>
  <tr> 
    <td><img src="../images/spacer.gif" width="1" height="176" border="0" alt=""></td>
  </tr>
</table>
</body>
</html>
