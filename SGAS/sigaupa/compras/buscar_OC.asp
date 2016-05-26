<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Buscador de OC"

v_inicio	= request.querystring("busqueda[0][inicio]")
v_termino	= request.querystring("busqueda[0][termino]")
pers_nrut	= request.querystring("busqueda[0][pers_nrut]")
pers_xdv	= request.querystring("busqueda[0][pers_xdv]")
tgas_ccod	= request.querystring("busqueda[0][tgas_ccod]")
contar = request.querystring.Count
buscar	=Request.QueryString("buscar")

set botonera = new CFormulario
botonera.carga_parametros "buscar_OC.xml", "botonera"


set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "buscar_OC.xml", "datos_solicitud"
f_busqueda.Inicializar conectar
 
if v_inicio<>"" then
sql_filtro=" AND convert(datetime,fecha_solicitud,103) >=  convert(datetime,'"&v_inicio&"',103) "
	if v_inicio<>"" and v_termino<>"" then
	sql_filtro = "" 
		sql_filtro=" AND convert(datetime,fecha_solicitud,103) BETWEEN  isnull(convert(datetime,'"&v_inicio&"',103),convert(datetime,fecha_solicitud,103)) and isnull(convert(datetime,'"&v_termino&"',103)+1,convert(datetime,fecha_solicitud,103)) "
	end if
end if
if v_inicio="" and v_termino<>"" then
	sql_filtro = "" 
		sql_filtro=" AND convert(datetime,fecha_solicitud,103) <=  convert(datetime,'"&v_termino&"',103) "
	end if


if pers_nrut<>"" then
	sql_filtro=sql_filtro& " and pers_nrut =  "&pers_nrut
end if

if tgas_ccod<>"" then
	sql_filtro=sql_filtro& " and tg.tgas_ccod = "&tgas_ccod
end if


if  contar > 0 and buscar = "S" then

 sql_solicitudes="select distinct ordc_ndocto,ordc_mmonto,ordc_fentrega, protic.trunc(fecha_solicitud) as fecha_solicitud ,protic.obtener_nombre_completo(oc.pers_ncorr, 'n') as nombre_proveedor, " &_
"protic.obtener_rut(oc.pers_ncorr) as rut_proveedor,'<a href=""javascript:VerOrdenCompra('+ cast(area_ccod as varchar)+ ','+ cast(oc.ordc_ncorr as varchar)+')"">'+ 'Ver' + '</a>' as ver "&_
", (select protic.obtener_nombre_completo(k.pers_ncorr, 'n') as nombre from personas k where k.pers_nrut = oc.ocag_generador)  as generador, vibo_tdesc, '('+pu.cod_pre+')-'+concepto as pruebas  " &_
"from ocag_orden_compra oc, personas p, ocag_visto_bueno vb, ocag_Detalle_orden_compra doc, ocag_tipo_gasto tg, ocag_presupuesto_solicitud pc, presupuesto_upa pu " &_
"where oc.pers_ncorr = p.pers_ncorr " &_
"and oc.vibo_ccod = vb.vibo_ccod " &_
"and oc.ordc_ndocto = doc.ordc_ncorr " &_
"and doc.tgas_ccod = tg.tgas_ccod " &_
"and oc.ordc_ncorr = cod_solicitud " &_
"and pc.cod_pre = pu.cod_pre COLLATE MODERN_SPANISH_CI_AS " &_
"" & sql_filtro & " " &_
"order by ordc_ndocto"				
 
 'response.Write("<pre>"&sql_solicitudes&"</pre>")
 'response.End()

 'else
 
 'sql_solicitudes="select ''"
 f_busqueda.Consultar sql_solicitudes
 end if
 
  

set f_buscador = new CFormulario
f_buscador.Carga_Parametros "buscar_OC.xml", "buscador"
f_buscador.Inicializar conectar
f_buscador.Consultar " select '' "
f_buscador.Siguiente

f_buscador.agregaCampoCons "inicio", v_inicio
f_buscador.agregaCampoCons "termino", v_termino
f_buscador.agregaCampoCons "pers_nrut", pers_nrut
f_buscador.agregaCampoCons "pers_xdv", pers_xdv
f_buscador.agregaCampoCons "tgas_ccod", tgas_ccod

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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">

function Validar()
{
	formulario = document.buscador;
	formulario.elements["buscar"].value='S'
		
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }	
	return true;
}

function VerOrdenCompra(area_ccod,ordc_ncorr){
	window.open("buscar_orden_compra2.asp?area_ccod="+area_ccod+"&busqueda[0][ordc_ncorr]="+ordc_ncorr , "nuevo_comentario"," width=800, height=600,scrollbars,  toolbar=false, resizable");	
}

</script>

<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][inicio]","1","buscador","fecha_oculta_inicio"
	calendario.MuestraFecha "busqueda[0][termino]","2","buscador","fecha_oculta_termino"
	calendario.FinFuncion
%>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
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
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Buscador de Ordenes de Compra</font></div></td>
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
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
					
                      <table width="100%" border="0">
                        <tr> 
                          <td>
						<form name="buscador"> 
                        <input type="hidden" name="buscar">
							<table width="90%" border='1' bordercolor='#999999'>
							<tr  bgcolor='#ADADAD'>
								<th colspan="5"><p>Criterios de busqueda</p></th>
							</tr>
								<tr>
								  <td>Rut:</td>
								  <td><%f_buscador.dibujaCampo("pers_nrut")%>
								    -
							        <%f_buscador.dibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]" %></td>
                                    
								  <td width="13%">&nbsp;</td>
								  <td>&nbsp;</td>
								  <td>&nbsp;</td>
								  </tr>
								<tr>
								  <td>Inicio:</td>
								  <td><% f_buscador.DibujaCampo ("inicio")%>
                                    <%calendario.DibujaImagen "fecha_oculta_inicio","1","buscador" %>
(dd/mm/aaaa)</td>
								  <td>Termino:</td>
								  <td><% f_buscador.DibujaCampo ("termino") %>
                                    <%calendario.DibujaImagen "fecha_oculta_termino","2","buscador" %>
(dd/mm/aaaa) </td>
								  <td><%botonera.DibujaBoton "buscar" %></td>
								  </tr>
								<tr colspan="2" rowspan="2" valign="top" align="left"> 
									<td width="9%">Tipo Gastos:</td>
									<td colspan="3" rowspan="3" valign="top" align="left"><%f_buscador.dibujaCampo("tgas_ccod") %></td>
								    <td>&nbsp;</td>
								  </tr>
							</table>
					  </form>
						  
						  <hr/>
						  </td>
                        </tr>
						<tr>
							<td>
							<table border ="0" align="center" width="100%">
								<tr valign="top">                                
								<td>
                                <%if  contar > 0 and buscar = "S" then%>
								<form name="datos" method="post">                                
								<center><%f_busqueda.DibujaTabla()%></center>							
								</form>
                                <%end if%>
									</td>
								</tr>																
							  </table>
								
							</td>
						</tr>
                      </table>
                      </td>
                  </tr>
                </table>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="241" bgcolor="#D8D8DE">
				  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%"><%botonera.AgregaBotonParam "excel", "url", "buscar_OC_excel.asp"
				  							botonera.AgregaBotonParam "excel", "accion","GUARDAR"
											botonera.AgregaBotonParam "excel", "formulario","buscador"					  
					  botonera.dibujaboton "excel"%></td>
                      <td width="30%"><%botonera.dibujaboton "salir"%></td>
                    </tr>
                  </table>                </td>
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
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
