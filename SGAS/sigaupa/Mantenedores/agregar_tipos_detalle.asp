<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_tcom_ccod = Request.QueryString("tcom_ccod")
q_tdet_ccod = Request.QueryString("tdet_ccod")


set pagina = new CPagina
pagina.Titulo = "Tipo de Ítemes"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "edicion_tipos_compromisos.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_tipos_detalle = new CFormulario
f_tipos_detalle.Carga_Parametros "edicion_tipos_compromisos.xml", "agregar_tipos_detalle"
f_tipos_detalle.Inicializar conexion


if EsVacio(q_tdet_ccod) then
	f_tipos_detalle.Consultar "select 'S' as tdet_bvigente, 'N' as tdet_bdescuento"
	f_tipos_detalle.AgregaCampoCons "tcom_ccod", q_tcom_ccod
	
	if q_tcom_ccod <> "7" then
		f_tipos_detalle.AgregaCampoCons "tdet_bcargo", "S"
	end if	
	
	v_accion = "Agregar"
	
else
	consulta = 	" Select a.tdet_ccod, a.tdet_tdesc, isnull(a.tdet_mvalor_unitario,0) as tdet_mvalor_unitario, " & vbCrLf &_  
				" isnull(a.tdet_bvigente,'N') as tdet_bvigente, a.tdet_cuenta_softland, a.tdet_detalle_softland," & vbCrLf &_  
			   	" a.tcom_ccod, a.tdet_bcargo, isnull(a.tdet_bdescuento,'N')as tdet_bdescuento, "& vbCrLf &_
				" isnull(a.tdet_bboleta,'N') as tdet_bboleta, a.tbol_ccod,isnull(a.tdet_institucion,1) as tdet_institucion " & vbCrLf &_
	           	" From tipos_detalle a  " & vbCrLf &_
			   	" Where cast(a.tdet_ccod as varchar) = '" & q_tdet_ccod & "' "
			   
	f_tipos_detalle.Consultar consulta			   
	
	v_accion = "Editar"
end if
'response.write(consulta)
'response.flush()
f_tipos_detalle.Siguiente
v_usa_boleta=f_tipos_detalle.ObtenerValor("tdet_bboleta")
v_tipo_boleta=f_tipos_detalle.ObtenerValor("tbol_ccod")
'response.Write("Usa Boleta:"&v_usa_boleta)

if v_tipo_boleta="1" then
	opcion_afecta="Checked"
end if

if v_tipo_boleta="2" then
	opcion_exenta="Checked"
end if


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
<script>
/*
function HabilitaBoletas(elemento){
cambiaOculto(elemento, 'S', 'N');
	if (!elemento.checked){ // si ha sido despinchado
		document.edicion.tipo_boleta[0].disabled=true;
		document.edicion.tipo_boleta[1].disabled=true;
		document.edicion.elements["tipos_detalle[0][tbol_ccod]"].value=null;

	}else{
		document.edicion.tipo_boleta[0].disabled=false;
		document.edicion.tipo_boleta[1].disabled=false;
		document.edicion.elements["tipos_detalle[0][tbol_ccod]"].disabled=false;
		if((!document.edicion.tipo_boleta[0].checked)&&(!document.edicion.tipo_boleta[1].checked)){
			//alert("no hay nada seleccionado")
			document.edicion.tipo_boleta[0].checked=true;
			AsignaTipoBoleta(1);
		}
	}
}
function AsignaTipoBoleta(tipo_boleta){
	if (tipo_boleta==1){
		document.edicion.elements["tipos_detalle[0][tbol_ccod]"].value=1;
	}else{
		document.edicion.elements["tipos_detalle[0][tbol_ccod]"].value=2;
	}
}*/



</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array(v_accion), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
						<%pagina.DibujarSubtitulo "Ítem"%>
                      	<br>
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
							  <td><div align="center"><%f_tipos_detalle.DibujaRegistro%></div></td>
							</tr>
							
							<tr>
								<td>
								</td>
							</tr>
							
						  </table>
					  </td>
                  </tr>
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("aceptar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cancelar")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
