<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		: FACTORIZACIÓN DE DOCUMENTOS
'FECHA CREACIÓN		: 08/09/2014
'CREADO POR 		: JAIME PAINEMAL ALCAMAN
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:COMPRAS Y AUT. DE GIRO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:
'ACTUALIZADO POR	:
'MOTIVO			:
'LINEA			:
'*******************************************************************
'OPCION		= request.QueryString("OPCION")

'if OPCION="" then
'OPCION=1
'end if

set pagina = new CPagina
pagina.Titulo = "FACTORIZACIÓN DE DOCUMENTOS"

set botonera = new CFormulario
botonera.carga_parametros "factorizar_documentos.xml", "botonera"

v_sogi_ncorr	= request.querystring("datos_1[0][sogi_ncorr]")
v_dsgi_ndocto		= request.querystring("datos_1[0][dsgi_ndocto]")
v_pers_nrut		= request.querystring("datos_1[0][pers_nrut]")
v_pers_xdv		= request.querystring("datos_1[0][pers_xdv]")

'RESPONSE.WRITE("v_sogi_ncorr: "&v_sogi_ncorr&"<BR>")
'RESPONSE.WRITE("v_dsgi_ndocto: "&v_dsgi_ndocto&"<BR>")
'RESPONSE.WRITE("v_pers_nrut: "&v_pers_nrut&"<BR>")
'RESPONSE.WRITE("v_pers_xdv: "&v_pers_xdv&"<BR>")

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "factorizar_documentos.xml", "buscador"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "sogi_ncorr", v_sogi_ncorr
f_busqueda.AgregaCampoCons "dsgi_ndocto", v_dsgi_ndocto
f_busqueda.AgregaCampoCons "pers_nrut", v_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", v_pers_xdv

' 88888888888888888888888888888888888888888888888888888888888888888888888888888

 set f_cheques = new CFormulario
 f_cheques.Carga_Parametros "factorizar_documentos.xml", "cheques"
 
f_cheques.Inicializar conectar
 
' 888888888888888888888888888888888888888888888888888888888888888888888888888888888

if v_sogi_ncorr<>"" then
	filtro_01="and a.sogi_ncorr = "&v_sogi_ncorr&" "
else
	filtro_01=""
end if

if v_pers_nrut<>"" then
	filtro_02="and B.PERS_NRUT="&v_pers_nrut&" "
else
	filtro_02=""
end if

if v_dsgi_ndocto<>"" then
	filtro_03="and c.dsgi_ndocto="&v_dsgi_ndocto&" "
else
	filtro_03=""
end if

			sql_cheques	=	" select "& vbCrLf &_
										" B.PERS_NRUT, (CAST(B.PERS_NRUT AS VARCHAR)+ '-' + CAST(B.PERS_XDV AS VARCHAR)) AS RUT  "& vbCrLf &_
										" , (B.PERS_TNOMBRE + ' ' + B.PERS_TAPE_PATERNO + ' ' +B.PERS_TAPE_MATERNO) AS NOMBRE  "& vbCrLf &_
										" , c.sogi_ncorr, c.tmon_ccod, f.tdoc_tdesc, c.dsgi_ndocto, c.dsgi_mdocto, c.dsgi_mexento, c.dsgi_mafecto, c.dsgi_miva, c.dogi_fecha_documento  "& vbCrLf &_
										" , (isnull(c.dsgi_mafecto,0) + isnull(c.dsgi_miva ,0)) AS TOTAL  "& vbCrLf &_
										" , E.DPVA_FPAGO  "& vbCrLf &_
 										" from ocag_solicitud_giro a   "& vbCrLf &_
										"  INNER JOIN personas b   "& vbCrLf &_
										"  ON a.pers_ncorr_proveedor = b.pers_ncorr and a.vibo_ccod=7 "&filtro_01&" "&filtro_02&" "& vbCrLf &_
										"  INNER JOIN ocag_detalle_solicitud_giro c   "& vbCrLf &_
										"  ON a.sogi_ncorr = c.sogi_ncorr AND c.tdoc_ccod IN (2,3,9,10) "&filtro_03&" "& vbCrLf &_
										"  INNER JOIN ocag_validacion_contable D  "& vbCrLf &_
										"  ON a.sogi_ncorr=D.cod_solicitud and D.tsol_ccod = 1  "& vbCrLf &_
										"  INNER JOIN ocag_detalle_pago_validacion E  "& vbCrLf &_
										"  ON D.vcon_ncorr=E.vcon_ncorr  "& vbCrLf &_
										"  INNER JOIN ocag_tipo_documento f  "& vbCrLf &_
										"  ON c.tdoc_ccod=f.tdoc_ccod  "& vbCrLf &_
										"  AND NOT EXISTS (SELECT x.dsgi_ndocto, x.PERS_NRUT  "& vbCrLf &_
										"  FROM [ocag_factorizacion] AS x  "& vbCrLf &_
										"  WHERE x.dsgi_ndocto = c.dsgi_ndocto  "& vbCrLf &_
										"  AND x.PERS_NRUT =B.PERS_NRUT)   "& vbCrLf &_
										"  ORDER BY C.dogi_fecha_documento "
			
			'RESPONSE.WRITE("sql_cheques: "&sql_cheques&"<br>")

f_cheques.Consultar sql_cheques

v_fecha_actual=conectar.consultaUno("select protic.trunc(getdate()) as fecha")
 
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<style>
.Mimetismo { background-color:#ADADAD;border: 1px #ADADAD solid; font-size:10px; font-style:oblique; font:bold;}
</style>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.10.1.min.js"></script>

<script language="JavaScript">

function Mensaje()
{
	<% 
		if session("mensaje_error")<>"" then
	%>
		alert("<%=session("mensaje_error")%>");
	<%
		session("mensaje_error")=""
		end if
	%>
}

function Enviar(){
	return true;
}

//88888888888888888888888888888888888

function ImprimirOC(){
	url="imprimir_oc.asp?ordc_ncorr=<%=ordc_ncorr%>";
	window.open(url,'ImpresionOC', 'scrollbars=yes, menubar=no, resizable=yes, width=700,height=700');	
	
	ocation.href="buscar_orden_compra.asp?ordc_ncorr=<%=ordc_ncorr%>&busqueda[0][area_ccod]="+v_area+"&v_boleta="+v_valor+"&pers_nrut="+v_rut+"&pers_xdv="+v_xdv;
}

//88888888888888888888888888888888888

function CambiaFechaGeneral(valor){
	formulario = document.datos;
	filas=<%=f_cheques.Nrofilas%>;
	for(i=0;i<filas;i++){
		formulario.elements["datos["+i+"][rche_frevalidacion]"].value=valor;
	}
}

//88888888888888888888888888888888888888888888888888888888888888888888888888888888888

function genera_digito (rut){

 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 var formulario = document.forms["datos_1"];
 
 posicion_guion = texto_rut.indexOf("-");
 
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    //document.datos.elements["datos_1[0][pers_nrut]"].value= texto_rut;
    formulario.elements["datos_1[0][pers_nrut]"].value=texto_rut;
	rut = texto_rut;
 }
 // texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 

   IgStringVerificador = '32765432';

   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;

   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   
   //alert(IgDigitoVerificador);
		//datos.elements["datos_1[0][pers_xdv]"].value=IgDigitoVerificador;
		formulario.elements["datos_1[0][pers_xdv]"].value=IgDigitoVerificador;
	//formulario = document.datos;
	//formulario.elements["datos[0][pers_xdv]"].value=5;

}

//88888888888888888888888888888888888888888888888888888888888888888888888888


function verificar(){
	//alert("verificar");

var formulario = document.forms["datos"];

var check=document.datos.getElementsByTagName('input');
var cantidadCheck=0;
var checkbox=new Array();
//var tabla = document.getElementById('tb_busqueda_detalle');

var Count = 0

 for (y=0;y<check.length;y++){
	 if (check[y].type=="checkbox"){
		 checkbox[cantidadCheck++]=check[y];
	}
}
	for (x=0;x<cantidadCheck;x++){
		if (checkbox[x].checked) {
			//alert(x)
			Count++;  
		}
	 }
	 
	if (Count==1){
		return true;
	}else{
		alert("Seleccione una opción")
		return false;
	}

}

//88888888888888888888888888888888888888888888888888888888888888888888888888

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">FACTORIZACIÓN DE DOCUMENTOS</font></div></td>
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
								<div align="right">P&aacute;ginas : <%f_cheques.AccesoPagina%></div>
								<BR>
					  
					  
<!-- AQUI ESTA EL INICIO DEL FORM DE BUSQUEDA -

								<br>
								<TABLE BORDER="0">
									<TR>
										<TD align="left">
											<%
											'pagina.DibujarLenguetasFClaro Array(array("Cheques Entregados","reemision_cheques_vencidos.asp?OPCION=1"),array("Cheques No Entregados","reemision_cheques_vencidos.asp?OPCION=2")), OPCION 
											%>
											
										<TD>
									</TR>
								</TABLE>
								<div align="right">P&aacute;ginas : <%f_cheques.AccesoPagina%></div>
								<br>
								
 AQUI ESTA EL FIN FORM DE BUSQUEDA -->					  
					  
					  
					  
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
					<tr>

		            <form name="datos_1">

						<td align="center">
							<table width="90%" border='1' bordercolor='#999999'>
							<th colspan="5">Busqueda de Facturas</th>
							&nbsp;
							</tr>
								<tr> 
								
									<td width="15%"><strong>N&deg; de Factura :</strong></td>
									<td width="35%"><%f_busqueda.dibujaCampo("dsgi_ndocto")%></td>
								    <td width="15%"><strong>N&deg; de Solicitud :</strong></td>
								    <td width="35%"><%f_busqueda.dibujaCampo("sogi_ncorr")%></td>
									
								</tr>
								<tr> 
								
									<td width="15%"><strong>Rut : </strong></td>
									<td width="35%"><%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
									<td colspan="2" align="center" ><%botonera.DibujaBoton "buscar" %></td>
									
								</tr>

							</table>
						</td>
					</form>
					</tr>
                  <tr> 
						<td>
						<br/>

							<form name="datos" method="post">
							
							<table align="right" width="100%"><tr>
									<td width="85%" align="right"></td>
								  	<td width="15%" align="left"></td>
							</tr></table>
							
							<p>&nbsp;</p>
								<table width="98%"  border="0" align="center">
								  <tr bgcolor='#C4D7FF'>
								    <th width="2%"></th>
									<th width="13%">Proveedor</th>
									<th width="29%">Tipo Factura</th>
                                    <th width="10%">N° Factura</th>
                                    <th width="10%">N° Solicitud</th>
									<th width="10%">Monto</th>
									<th width="13%">Fecha Documento </th>
									<th width="13%">Fecha de Pago</th>
								  </tr>
								  <%
								  ind=0
								  while f_cheques.Siguiente 
								  %>

								  <input type="hidden" name="datos[<%=ind%>][RUT]" value="<%=f_cheques.obtenerValor("RUT")%>" />
								  <input type="hidden" name="datos[<%=ind%>][dsgi_ndocto]" value="<%=f_cheques.obtenerValor("dsgi_ndocto")%>" />
								  <input type="hidden" name="datos[<%=ind%>][PERS_NRUT]" value="<%=f_cheques.obtenerValor("PERS_NRUT")%>" />
								  
								  <tr bgcolor='#FFFFFF'>
								   <td><div align="right"><input type="checkbox" name="datos[<%=ind%>][sogi_ncorr]" value="<%=f_cheques.obtenerValor("sogi_ncorr")%>"  /></div></td>
								   
									<td><div align="right"><%=f_cheques.obtenerValor("RUT")%></div></td>
									<td><div align="right"><%=f_cheques.obtenerValor("tdoc_tdesc")%></div></td>
                                    <td><div align="right"><%=f_cheques.obtenerValor("dsgi_ndocto")%></div></td>
                                    <td><div align="right"><%=f_cheques.obtenerValor("sogi_ncorr")%></div></td>
									<td><div align="right"><%=f_cheques.obtenerValor("TOTAL")%></div></td>
									<td><div align="right"><%=f_cheques.obtenerValor("dogi_fecha_documento")%></div></td>
									<td><div align="right"><%=f_cheques.obtenerValor("DPVA_FPAGO")%></div></td>
									
								  </tr>
								  <%
								  ind=ind+1
								  wend%>
								</table>
							</form>
							<br>
							<table width="98%"  border="0" align="center">
							  <tr>
								<td  width="85%" >
									<div align="right">
										<%
											'botonera.DibujaBoton "guardar_2"
										%>
									</div>
								</td>
								<td  width="15%" >
									<div align="right">
										<%
											botonera.DibujaBoton "guardar"
										%>
									</div>
								</td>
							  </tr>
							</table>							
						</td>
                  </tr>
                </table>
	  <br/>
				  
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="108" bgcolor="#D8D8DE">
				  <table width="23%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
					  <td><%botonera.dibujaboton "salir"%></td>
                    </tr>
                  </table>                </td>
                  <td width="252" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
