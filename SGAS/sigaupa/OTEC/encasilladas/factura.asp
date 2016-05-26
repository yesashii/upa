<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next

f_nrut = Request.Form("rut")
f_nombre = Request.Form("nombre")
rut=left(trim(f_nrut),len(trim(f_nrut))-2)
'--------------------------------------------------

set conectar	=	new cconexion
conectar.inicializar "upacifico"
set negocio		=	new cnegocio
negocio.inicializa conectar

set pagina = new CPagina
pagina.Titulo = "Ingreso datos Factura"

sede	=	negocio.obtenersede
session("crear")=1

set cajero = new ccajero
cajero.inicializar conectar,negocio.obtenerUsuario,sede
mcaj_ncorr = cajero.obtenercajaabierta
'--------------------------------------------------
set botonera = new CFormulario
botonera.carga_parametros "factura.xml", "btn_factura"

v_empr_ncorr	=	conectar.consultauno("select empr_ncorr from empresas where empr_nrut = '"& rut &"'")
v_existe	=	conectar.consultauno("select count(empr_ncorr) from empresas where empr_nrut = '"& rut &"'")

if v_existe<=0 then
	crea_empresa="Exec TRASPASA_EMPRESA "& rut &" "
	v_salida=conectar.ejecutaS(crea_empresa)
end if

set facturas	=	new cformulario
facturas.inicializar		conectar
facturas.carga_parametros	"factura.xml","factura"

cons_factura	=	"Select a.empr_nrut as rut,a.empr_xdv as dv,a.empr_nrut,a.empr_xdv,"&_
					" a.empr_trazon_social,a.empr_tdireccion, c.ciud_tdesc as comuna,"&_
					" a.ciud_ccod as ciud_ccod, a.empr_tfono,a.empr_tfax ,empr_tgiro "&_
					" from empresas a, ciudades c "&_
					"	where a.ciud_ccod=c.ciud_ccod  "&_
					"	and cast(empr_nrut as varchar)='"& rut &"'"
'response.Write("<pre>"&cons_factura&"</pre>")
facturas.consultar	cons_factura
facturas.siguiente
'--------------------------------------------------



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
			formulario.method="post";
			formulario.action="proc_factura.asp";
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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
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
 <br>
				   <center><%pagina.DibujarTituloPagina%></center> <br>
				    <form method="get" name="factura">
<%

suma=0
indice=0
monto_saldo_cuota=0

v_mcaj_ncorr 	= cajero.obtenercajaabierta
v_fact_nfactura = conectar.consultauno("select isnull(max(fact_nfactura),0)+1 from facturas where tfac_ccod=2")

  set formulario = new CFormulario
  formulario.Carga_Parametros "factura.xml", "detalle_pagos"
  formulario.Inicializar conectar
  formulario.ProcesaForm

  	for fila = 0 to formulario.CuentaPost - 1
		v_comp_ndocto		= formulario.ObtenerValorPost (fila, "comp_ndocto")
	   	v_tcom_ccod			= formulario.ObtenerValorPost (fila, "tcom_ccod")
	   	v_inst_ccod			= formulario.ObtenerValorPost (fila, "inst_ccod")
		v_dcom_ncompromiso	= formulario.ObtenerValorPost (fila, "dcom_ncompromiso")

		if v_dcom_ncompromiso <> "" then
			monto_saldo_cuota=conectar.ConsultaUno("select cast(protic.total_recepcionar_cuota("&v_tcom_ccod&","&v_inst_ccod&","&v_comp_ndocto&","&v_dcom_ncompromiso&") as varchar)")
			suma = suma + monto_saldo_cuota
			%>				
			<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][tcom_ccod]" value="<%=v_tcom_ccod%>" />
			<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][comp_ndocto]" value="<%=v_comp_ndocto%>"/>
			<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][inst_ccod]" value="<%=v_inst_ccod%>" />
			<input type="hidden" name="cc_compromisos_pendientes[<%=indice%>][dcom_ncompromiso]" value="<%=v_dcom_ncompromiso%>" />
			<%
			indice=indice+1
		end if	' fin si fue checkeado
	next
'response.Write("array :"&array_ingreso)
%>
<%pagina.DibujarSubtitulo "Datos Empresa"%>
<table width="80%" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="2%" nowrap><font color="#FF0000">*&nbsp;</font></td>
                          <td width="28%" nowrap><strong>Rut</strong></td>
                          <td width="10%" nowrap><strong>: 
                            <%facturas.dibujacampo("rut")%><%facturas.dibujacampo("empr_nrut")%>
                            - 
                            <%facturas.dibujacampo("dv")%><%facturas.dibujacampo("empr_xdv")%>
                            </strong></td>
                          <td width="16%" align="right" nowrap><font color="#FF0000">*</font>Campos Obligatorios</td>
                          <td width="44%" align="right" nowrap>&nbsp;</td>
                        </tr>
                        <tr> 
                          <td nowrap><font color="#FF0000">*</font></td>
                          <td nowrap><strong> Nombre o Raz&oacute;n Social</strong></td>
                          <td colspan="2" nowrap><strong>:<%facturas.dibujacampo("empr_trazon_social")%></strong></td>
                          <td nowrap>
                          </td>
                        </tr>
                        <tr> 
                          <td nowrap><font color="#FF0000">*</font></td>
                          <td nowrap><strong>Direcci&oacute;n</strong></td>
                          <td colspan="2" nowrap><strong>: 
                            <%facturas.dibujacampo("empr_tdireccion")%>
                            </strong></td>
                          <td nowrap><strong> </strong></td>
                        </tr>
                        <tr> 
                          <td nowrap><font color="#FF0000">*</font></td>
                          <td nowrap><strong>Giro</strong></td>
                          <td nowrap><strong>: 
                            <%facturas.dibujacampo("empr_tgiro")%>
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
                            <%facturas.dibujacampo("empr_tfono")%>
                            </strong></td>
                          <td align="left" nowrap>&nbsp;</td>
                          <td nowrap>&nbsp;</td>
                        </tr>
                        <tr>
                          <td nowrap>&nbsp;</td>
                          <td nowrap><strong>Fax</strong></td>
                          <td nowrap><strong>: <%facturas.dibujacampo("empr_tfax")%></strong></td>
                          <td align="left" nowrap>&nbsp;</td>
                          <td nowrap>&nbsp;</td>
                        </tr>
                      </table>
<br/>
<br/>
<%pagina.DibujarSubtitulo "Datos Factura"%>
<table>
<tr>
	<td><strong>N° Factura</strong></td>
	<td>

<input type="text" name="fact_n" value="<%=v_fact_nfactura%>" size="7" maxlength="6">

</td>
	<td>&nbsp;&nbsp;&nbsp;</td>
	<td><strong>Tipo Factura</strong></td>
	<td>
		<select name="tfac_ccod" >
			<option Value="1"> Afecta</option>
			<option Value="2" selected>Exenta</option>
		</select>
	</td>
</tr>
<tr>
	<td><strong>Monto a Facturar</strong></td>
	<td><%=formatcurrency(suma,0)%></td>
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
      </table>   </td>
  </tr>  
</table>
</body>
</html>
