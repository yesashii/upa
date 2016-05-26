<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

q_leng	=request.QueryString("q_leng")



if EsVacio(q_leng) or q_leng="" then
	q_leng=1
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Cargar Archivo"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.carga_parametros "archivo_pago_electronico.xml", "botonera"
'---------------------------------------------------------------------------------------------------

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

v_usuario=negocio.ObtenerUsuario()

v_mcaj_ncorr=cajero.ObtenerCajaAbierta()


if v_mcaj_ncorr="" then
	session("sin_caja")= "No puede cargar archivos sin tener una caja abierta"
else
	session("sin_caja")=""
end if

 set f_cargados = new CFormulario
 f_cargados.Carga_Parametros "archivo_pago_electronico.xml", "archivos_cargados"
 f_cargados.Inicializar conexion

sql_existentes= " SELECT protic.trunc(getdate()) as fecha,count(*) as cantidad, sum (pele_mmonto_recaudado) as  total , "&_ 
				" min (pele_nidentificacion) as  desde , max(pele_nidentificacion) as hasta, isnull(epel_ccod,1) as estado, "&_
				" '<a href=""javascript:UltimoEstado('+ cast(pele_ccod as varchar)+ ', '+ cast(isnull(epel_ccod,1) as varchar)+ ' )"">'+ 'Ver' + '</a>' as revisar " &_
				" FROM pago_electronico_letras "&_
				" group by pele_ccod, epel_ccod "

f_cargados.Consultar sql_existentes
					



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
<script language="javascript">

function Mensaje(){
<% if session("mensaje_error") <> "" then %>
	alert("<%=session("mensaje_error")%>");
<%
	session("mensaje_error")=""
	end if
 if session("sin_caja") <> "" then %>
	alert("<%=session("sin_caja")%>");
<%
	v_estado_btn="disabled"
	end if
%>
}


function UltimoEstado(pele_ccod,estado)
{
	var url;
	if (estado==1){
		location.href="pagar_archivo_pago_electronico.asp?q_leng=2&pele_ccod="+pele_ccod;
	}else if(estado==4){
		location.href="comprobante_archivo_pago_electronico.asp?q_leng=4&pele_ccod="+pele_ccod;
	}
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="400" height="250" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0" >
          <tr>
            <td>
             <%pagina.DibujarLenguetasFClaro Array(array("Carga Archivo","cargar_archivo_pago_electronico.asp?q_leng=1"), array("Revision Archivo","revisar_archivo_pago_electronico.asp?q_leng=2"), array("Pago Letras","pagar_archivo_pago_electronico.asp?q_leng=3"), array("Impresion de comprobantes","comprobante_archivo_pago_electronico.asp?q_leng=4")), q_leng %>
			</td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			<br/>
			<%
			pagina.DibujarSubtitulo "Resumen con cargas de letras"
			f_cargados.DibujaTabla()
			%>
			<form enctype="multipart/form-data" method="post" action="cargar_archivo_pago_proc.asp" name="datos" >
              <br>
			<%pagina.DibujarSubtitulo "Cargar archivo de letras"%>			  
              <table width="90%"  border="0" align="center">
			    
                <tr>
					<td width="85%"> 
					
					<span class="Estilo2"></span><strong>Archivo</strong><br>
					  <input name="subir" size=30 type="file"/>
					  <INPUT type="submit" value="Subir" <%=v_estado_btn%>>
					</td>
					</tr>
				<tr> 
					<td align="left"></td>
			   </tr>
			</table>
            </form>
			</td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
   <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td></td>
					<td><div align="center">
                    
					<%botonera.DibujaBoton"salir" %></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28">
            </td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
    <br>
    </td>
  </tr>  
</table>
</body>
</html>