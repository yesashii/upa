<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "factura.xml", "btn_factura"

rut			=	request.QueryString("rut")
dv			=	request.QueryString("dv")
ingr_ncorr	=	request.QueryString("ingr_ncorr")
ingr_nfolio_referencia	=	request.QueryString("ingr_nfolio_referencia")
set facturas	=	new cformulario
set conectar	=	new cconexion
set datos		=	new cformulario
set impresora	=	new cformulario
set negocio		=	new cnegocio

conectar.inicializar		"desauas"
facturas.inicializar		conectar
negocio.inicializa			conectar

facturas.carga_parametros	"factura.xml","factura"

datos.inicializar			conectar
datos.carga_parametros		"paulo.xml","tabla"

cons_factura	=	"select '' as rut,'' as razon_social,'' as giro,'' as direccion,'' as comuna,'' as c_pago from dual"


facturas.consultar	cons_factura
facturas.siguiente

cons_datos	=	"select b.ciud_ccod as ciud_ccod,pers_trazon_social as razon_social, "&_
				"  dire_tcalle as direccion,dire_tnro as nro, c.ciud_tdesc as ciudad, a.pers_tfono||'  '|| a.pers_tfono_empresa as telefono,pers_tgiro as giro "&_
				" from personas a,direcciones b, ciudades c "&_
				" where a.pers_ncorr=b.pers_ncorr and b.ciud_ccod=c.ciud_ccod and pers_nrut='"& rut &"'"

'response.write(cons_datos)

datos.consultar cons_datos
datos.siguiente
razon_social	= datos.obtenervalor("razon_social")
direccion		= datos.obtenervalor("direccion")
comuna			= datos.obtenervalor("comuna")
telefono		= datos.obtenervalor("telefono")
giro			= datos.obtenervalor("giro")
nro				= datos.obtenervalor("nro")
ciud_ccod		= datos.obtenervalor("ciud_ccod")

facturas.agregacampocons	"rut",					rut
facturas.agregacampocons	"dv",					dv
facturas.agregacampocons	"pers_trazon_social",	razon_social
facturas.agregacampocons	"dire_tcalle",			direccion
facturas.agregacampocons	"dire_tnro",			nro
facturas.agregacampocons	"ciud_ccod",			ciud_ccod
facturas.agregacampocons	"pers_tfono",			telefono
facturas.agregacampocons	"pers_tgiro",			giro


if ingr_nfolio_referencia = "" then 
ingr_nfolio_referencia	=	conectar.consultauno("select ingr_nfolio_referencia from ingresos where ingr_ncorr='"& ingr_ncorr &"'")
end if

sede	=	negocio.obtenersede

impresora.carga_parametros "paulo.xml","impresora"
impresora.inicializar conectar

impres="select impr_truta from impresoras where impr_truta='" & session("impresora") & "'"

impresora.consultar impres
impresora.siguientef
impresora.agregacampoparam "impr_truta","filtro","sede_ccod=" & sede & " "

%>


<html>
<head>
<title>Factura</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--
function imprimir(formulario){
	if(preValidaFormulario(formulario)){
		if(valida_rut(formulario.elements["f[0][rut]"].value + '-' + formulario.elements["f[0][dv]"].value)){
			formulario.method="post";
			formulario.action="imprimir_factura.asp";
			formulario.submit();
		}
	}
}

function BuscarDatos(formulario){
	if (valida_rut(formulario.elements["f[0][rut]"].value + '-' + formulario.elements["f[0][dv]"].value)) {
		rut = formulario.elements["f[0][rut]"].value;
		dv = formulario.elements["f[0][dv]"].value;			
		str_url = "factura.asp?rut="+rut+"&dv="+dv+"&ingr_ncorr="+<%=ingr_ncorr%> ;		
		navigate(str_url);
	}
	else {
		alert('El rut ingresado es incorrecto');
		formulario.elements["f[0][rut]"].focus();
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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
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
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Factura</font></div></td>
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
				    <form method="get" name="factura">
<table width="80%" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="2%" nowrap><font color="#FF0000">*&nbsp;</font></td>
                          <td width="28%" nowrap><strong>Rut</strong></td>
                          <td width="10%" nowrap><strong>: 
                            <%facturas.dibujacampo("rut")%>
                            - 
                            <%facturas.dibujacampo("dv")%>
                            </strong></td>
                          <td width="16%" align="right" nowrap><font color="#FF0000">*</font> 
                            Campos Obligatorios</td>
                          <td width="44%" align="right" nowrap>&nbsp;</td>
                        </tr>
                        <tr> 
                          <td nowrap><font color="#FF0000">*</font></td>
                          <td nowrap><strong> Nombre o Raz&oacute;n Social</strong></td>
                          <td colspan="2" nowrap><strong>: 
                            <%facturas.dibujacampo("pers_trazon_social")%>
                            </strong></td>
                          <td nowrap><input type="hidden" name="ingr_nfolio_referencia" value="<%=ingr_nfolio_referencia%>"> 
                            <input type="hidden" name="ingr_ncorr" value="<%=ingr_ncorr%>"> 
                          </td>
                        </tr>
                        <tr> 
                          <td nowrap><font color="#FF0000">*</font></td>
                          <td nowrap><strong>Direcci&oacute;n</strong></td>
                          <td colspan="2" nowrap><strong>: 
                            <%facturas.dibujacampo("dire_tcalle")%>
                            <font color="#FF0000">*</font> Nro.&nbsp;: 
                            <%facturas.dibujacampo("dire_tnro")%>
                            </strong></td>
                          <td nowrap><strong> </strong></td>
                        </tr>
                        <tr> 
                          <td nowrap><font color="#FF0000">*</font></td>
                          <td nowrap><strong>Giro</strong></td>
                          <td nowrap><strong>: 
                            <%facturas.dibujacampo("pers_tgiro")%>
                            </strong></td>
                          <td align="left" nowrap>&nbsp;</td>
                          <td nowrap>&nbsp;</td>
                        </tr>
                        <tr> 
                          <td nowrap><font color="#FF0000">*</font></td>
                          <td nowrap><strong>Comuna</strong></td>
                          <td nowrap><strong>: 
                            <%facturas.dibujacampo("ciud_ccod")%>
                            </strong></td>
                          <td align="left" nowrap>&nbsp;</td>
                          <td nowrap>&nbsp;</td>
                        </tr>
                        <tr> 
                          <td nowrap><font color="#FF0000">*</font></td>
                          <td nowrap><strong>Tel&eacute;fono</strong></td>
                          <td nowrap><strong>: 
                            <%facturas.dibujacampo("pers_tfono")%>
                            </strong></td>
                          <td align="left" nowrap>&nbsp;</td>
                          <td nowrap>&nbsp;</td>
                        </tr>
                      </table>
<table width="13%" align="right" cellpadding="0" cellspacing="0">
                        <tr>
                          <td nowrap><strong>Impresora:</strong></td>
                          <td nowrap><%=impresora.dibujacampo("impr_truta")%></td>
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
                  <td width="125" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center">
                        <%botonera.DibujaBoton "imprimir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="237" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
