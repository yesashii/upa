<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

docto=request.querystring("comp_ndocto")
compromiso=request.querystring("dcom_ncompromiso")
q_inst_ccod = Request.QueryString("inst_ccod")
q_tcom_ccod = Request.QueryString("tcom_ccod")

set conectar = new cconexion
set formulario = new cformulario
set negocio= new cnegocio

conectar.inicializar "desauas"

'sede = 1

'usuario = 14492361
negocio.inicializa conectar
sede       = negocio.obtenersede

formulario.carga_parametros "detalle_compromiso.xml", "detalle_compromiso"

formulario.inicializar conectar

tabla = "select i.ingr_mefectivo, i.ingr_mdocto, i.ingr_mtotal, i.ingr_nfolio_referencia, a.abon_mabono, " &_
        "       a.abon_fabono, b.inst_trazon_social, c.ting_tdesc, a.comp_ndocto " &_
		"from ingresos i, abonos a, instituciones b, tipos_ingresos c " &_
		"where a.comp_ndocto = '" & docto & "' " &_
		"  and a.dcom_ncompromiso = '" & compromiso & "' " &_
		"  and a.tcom_ccod = '" & q_tcom_ccod & "' " &_
		"  and a.inst_ccod = '" & q_inst_ccod & "' " &_
		"  and i.ingr_ncorr = a.ingr_ncorr " &_
		"  and b.inst_ccod = a.inst_ccod " &_
		"  and c.ting_ccod = i.ting_ccod " &_
		"  and i.eing_ccod = 1 " &_
		"order by a.abon_fabono"
   
'response.Write(tabla)
formulario.consultar tabla

%>


<html>
<head>
<title>An&aacute;lisis Cuenta Corriente</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
<!--


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
	/*if (c>0) {
		return (true);
	}
	else {
		return (false);
	}*/


function enviar(formulario){
		if(!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))){
		    alert('ERROR.\nEl RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
			formulario.rut.focus();
			formulario.rut.select();
		 }
		else{
			formulario.action = 'rev_ctacte.asp';
			formulario.submit();
		}
}


function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td></td>
  </tr>
 <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="88%" border="0" cellpadding="0" cellspacing="0">
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
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Detalle
                        Pago Compromiso</font></div></td>
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
				    <form name="edicion">
		            <table width="97%" align="center" cellpadding="0" cellspacing="0">
                              <tr> 
                                <td></td>
                              </tr>
                              <tr> 
                                <td height="13" align="center"><strong>ABONOS 
                                  REALIZADOS</strong></td>
                              </tr>
                              <tr> 
                                <td align="right"><strong>P&aacute;ginas&nbsp;:&nbsp;</strong>&nbsp; 
                                  <%formulario.accesoPagina%>
                                </td>
                              </tr>
                              <tr> 
                                <td align="center"><%formulario.dibujaTabla()%></td>
                              </tr>
                              <tr> 
                                <td align="center">&nbsp; </td>
                              </tr>
                      </table>
					</form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="91" bgcolor="#D8D8DE"><table width="73%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="43%"><div align="center">
                        <%pagina.DibujarBoton "Salir", "CERRAR", "" %>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="271" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
