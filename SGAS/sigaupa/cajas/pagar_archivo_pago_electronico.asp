<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

q_leng		=request.QueryString("q_leng")
pele_ccod	=request.QueryString("pele_ccod")

if session("nombre_archivo") = "" and pele_ccod="" then
	session("mensaje_error")="Aun no se ha cargado un archivo valido para realizar el pago de Letras"
	response.Redirect("cargar_archivo_pago_electronico.asp")
end if

if EsVacio(q_leng) or q_leng="" then
	q_leng=1
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Pagar Letras"

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

 set f_formulario = new CFormulario
 f_formulario.Carga_Parametros "archivo_pago_electronico.xml", "tabla_pago_electronico_letras"
 f_formulario.Inicializar conexion

sql_subido=" select tcom_ccod,comp_ndocto, dcom_ncompromiso,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre,protic.trunc(pele_fvencimiento) as  fvencimiento, "&_
			" pele_ccod,edin_ccod, b.pers_ncorr, pele_nidentificacion as num_letra,pele_mmonto_recaudado as monto_letra, protic.obtener_rut(b.pers_ncorr) as rut_alumno, "&_
			" protic.trunc(pele_frecaudacion) as  frecaudacion, pele_nidentificacion,pele_mvalor_cuota,pele_mmonto_recaudado, "&_
			" '<font color=#CC3300 size=1> por generar...</font>' as imprimir  "&_
			" from pago_electronico_letras a join personas b  "&_
			"  on a.pers_nrut=b.pers_nrut "&_
			" join detalle_ingresos c  "&_
			"     on a.pele_nidentificacion=c.ding_ndocto "&_
			"     and c.ting_ccod=4 "&_
			" join ingresos d "&_
			"     on c.ingr_ncorr=d.ingr_ncorr "&_
			" join  abonos e "&_
			"     on d.ingr_ncorr=e.ingr_ncorr "&_ 
			" where pele_ccod="&pele_ccod&" "&_
			" and d.eing_ccod=4 "&_
			" and a.pele_bpagada in ('N') "
					
 
f_formulario.Consultar sql_subido
v_num_filas= f_formulario.nroFilas 
'v_num_filas=1
 'f_formulario.SiguienteF

 set f_pagadas = new CFormulario
 f_pagadas.Carga_Parametros "archivo_pago_electronico.xml", "tabla_letras_pagada"
 f_pagadas.Inicializar conexion

	sql_pagadas=" select tcom_ccod,comp_ndocto, dcom_ncompromiso,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre,protic.trunc(pele_fvencimiento) as  fvencimiento, "&_
				" pele_ccod,edin_ccod, b.pers_ncorr, pele_nidentificacion as num_letra,pele_mmonto_recaudado as monto_letra, protic.obtener_rut(b.pers_ncorr) as rut_alumno, "&_
				" protic.trunc(pele_frecaudacion) as  frecaudacion, pele_nidentificacion,pele_mvalor_cuota,pele_mmonto_recaudado, "&_
				" '<font color=#CC3300 size=1>&nbsp;&nbsp;-No Aplica- </font>' as imprimir  "&_
				" from pago_electronico_letras a join personas b  "&_
				"  on a.pers_nrut=b.pers_nrut "&_
				" join detalle_ingresos c  "&_
				"     on a.pele_nidentificacion=c.ding_ndocto "&_
				"     and c.ting_ccod=4 "&_
				" join ingresos d "&_
				"     on c.ingr_ncorr=d.ingr_ncorr "&_
				" join  abonos e "&_
				"     on d.ingr_ncorr=e.ingr_ncorr "&_ 
				" where pele_ccod="&pele_ccod&" "&_
				" and d.eing_ccod=4 "&_
				" and a.pele_bpagada in ('S') "
					
 
 f_pagadas.Consultar sql_pagadas

nombre_archivo=session("nombre_archivo")

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

<SCRIPT LANGUAGE="JavaScript">

function Mensaje(){
<% if session("mensaje_error") <> "" then %>
alert("<%=session("mensaje_error")%>");
<%end if%>
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
            <td><form method="post" action="pagar_archivo_pago_proc.asp" name="datos" >
			  <br/>
			  <%if nombre_archivo <>"" then%>
			  <font color="#0033FF" size="+1">Archivo Cargado: <b><%=nombre_archivo%></b></font>

			  <%end if%>
	  			<p>&nbsp;</p>	
			  <%pagina.DibujarSubtitulo "Letras disponibles para pagar"%>		
						<%f_formulario.dibujaTabla()%>
				<p>&nbsp;</p>		
			  <%pagina.DibujarSubtitulo "Letras ya pagadas"%>
						<%f_pagadas.dibujaTabla()%>			 	
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
                  <td><div align="center">
                    
					<%
					if v_num_filas=0 then
						botonera.AgregaBotonParam "pagar", "deshabilitado", "TRUE"
					end if 
					botonera.DibujaBoton "pagar"
					%></div></td>
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