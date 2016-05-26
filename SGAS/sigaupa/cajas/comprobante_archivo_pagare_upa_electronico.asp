<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

q_leng		=request.QueryString("q_leng")
pepu_ccod	=request.QueryString("pepu_ccod")


if EsVacio(q_leng) or q_leng="" then
	q_leng=1
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Pagar Pagare UPA"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new CErrores

set botonera = new CFormulario
botonera.carga_parametros "archivo_pagare_upa_electronico.xml", "botonera"


peri_ccod 	= negocio.ObtenerPeriodoAcademico("POSTULACION")
'---------------------------------------------------------------------------------------------------

 set f_formulario = new CFormulario
 f_formulario.Carga_Parametros "archivo_pagare_upa_electronico.xml", "tabla_pago_electronico_pagare_upa"
 f_formulario.Inicializar conexion


sql_subido=" select tcom_ccod,comp_ndocto, dcom_ncompromiso,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre,protic.trunc(pepu_fvencimiento) as  fvencimiento, "&_
			" pepu_ccod,edin_ccod, b.pers_ncorr, pepu_nidentificacion as num_letra,pepu_mmonto_recaudado as monto_letra, protic.obtener_rut(b.pers_ncorr) as rut_alumno, "&_
			" protic.trunc(pepu_frecaudacion) as  frecaudacion, pepu_nidentificacion,pepu_mvalor_cuota,pepu_mmonto_recaudado,  "&_
			" isnull('<a href=""javascript:imprimir('+ cast(a.ingr_nfolio_referencia as varchar)+ ',16,'+cast(b.pers_ncorr as varchar) +','+ cast(a.pepu_mmonto_recaudado as varchar)+','+ cast("&peri_ccod&" as varchar)+')"">'+ 'Imprimir' + '</a>',' <font color=red>No generó pago</font>') as imprimir " & vbCrlf & _
			" from pago_electronico_pagare_upa a join personas b  "&_
			"  on a.pers_nrut=b.pers_nrut "&_
			" join detalle_ingresos c  "&_
			"on LEFT(pepu_nidentificacion,LEN(pepu_nidentificacion)-2)=c.ding_ndocto  "&_
			"     and c.ting_ccod=66 "&_
			" join ingresos d "&_
			"     on c.ingr_ncorr=d.ingr_ncorr "&_
			" join  abonos e "&_
			"     on d.ingr_ncorr=e.ingr_ncorr "&_ 
			" where cast(pepu_ccod as varchar)='"&pepu_ccod&"' "&_
			" and d.eing_ccod=4 "&_
			" and a.pepu_nidentificacion= protic.obtener_numero_pagare_upa_softland(d.ingr_ncorr)" 
'response.Write(sql_subido)
'response.End()					
 
 f_formulario.Consultar sql_subido
 'f_formulario.SiguienteF

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


function imprimir(nfolio,tipo_doc,pers_ncorr,total,periodo)
{var url;
    if ((tipo_doc=='16')||(tipo_doc=='34')||(tipo_doc=='17')){
	     url="comp_ingreso.asp?nfolio="+ nfolio + "&nro_ting_ccod="+ tipo_doc + "&pers_ncorr="+pers_ncorr+"&total="+total+"&peri_ccod="+periodo+"&reimp=1";
	   }
	//alert(url);
	irA(url, "1", 700, 500)
    //return true;
}


function imprimir_comprobante()
{
	var url;
	url="imprimir_comprobante_pagare_upa.asp?pepu_ccod=<%=pepu_ccod%>";
	window.open(url,"comprobante","resizable=yes,width=700,height=800,scrollbars=no");
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../archivos asp/im&aacute;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../archivos asp/im&aacute;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../archivos asp/im&aacute;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../archivos asp/im&aacute;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
             <%pagina.DibujarLenguetasFClaro Array(array("Carga Archivo","cargar_archivo_pagare_upa_electronico.asp?q_leng=1"), array("Revision Archivo","revisar_archivo_pagare_upa_electronico.asp"), array("Pago Pagare UPA","pagar_archivo_pagare_upa_electronico.asp"), array("Impresion de comprobantes","comprobante_archivo_pagare_upa_electronico.asp")), q_leng %>
			</td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form method="post" action="../archivos asp/pagar_archivo_pagare_upa_proc.asp" name="datos" >
			  <br/>
			  <%if nombre_archivo <>"" then%>
			  <font color="#0033FF" size="+1">Archivo Cargado: <b><%=nombre_archivo%></b></font>
			  <%end if%>
			  <br/>
			  
			  <%f_formulario.dibujaTabla()%>

            </form>
			<br/>
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
                    
					<%botonera.DibujaBoton "imprimir"%></div></td>
					<td><div align="center">
                    
					<%botonera.DibujaBoton "salir" %></div></td>
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