<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
dgso_ncorr = request.QueryString("dgso_ncorr")
empr_ncorr = request.QueryString("empr_ncorr")
nord_compra = request.QueryString("nord_compra")
tipo = request.QueryString("tipo")
empr_ncorr_2= request.QueryString("empr_ncorr_2")
fpot_ccod = request.QueryString("fpot_ccod")

set pagina = new CPagina
pagina.Titulo = "Configurar Orden de Compra"

set botonera =  new CFormulario
botonera.carga_parametros "agrega_postulantes.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

programa = conexion.consultaUno("select dcur_tdesc from datos_generales_secciones_otec a, diplomados_cursos b where a.dcur_ncorr=b.dcur_ncorr and cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'")
matricula = conexion.consultaUno("select isnull(ofot_nmatricula,0) from datos_generales_secciones_otec a, ofertas_otec b where a.dgso_ncorr = b.dgso_ncorr and cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'")
arancel = conexion.consultaUno("select isnull(ofot_narancel,0) from datos_generales_secciones_otec a, ofertas_otec b where a.dgso_ncorr = b.dgso_ncorr and cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'")

empresa_orden = conexion.consultaUno("select empr_trazon_social from empresas where cast(empr_ncorr as varchar)='"&empr_ncorr&"'")
empresa = conexion.consultaUno("select empr_trazon_social from empresas where cast(empr_ncorr as varchar)='"&empr_ncorr_2&"'")
tiene_detalle = conexion.consultaUno(" select count(*) from ordenes_compras_otec  where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'  and cast(empr_ncorr as varchar)='"&empr_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' ")
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "agrega_postulantes.xml", "datos_orden"
formulario.inicializar conexion

if dgso_ncorr <> "" and empr_ncorr <> "" and nord_compra <> "" and tiene_detalle <> "0" then 
consulta= " select dgso_ncorr,empr_ncorr,nord_compra,empr_ncorr_2,fpot_ccod,ocot_nalumnos,ocot_monto_otic,ocot_monto_empresa " & vbCrlf & _
		  " from ordenes_compras_otec " & vbCrlf & _
		  " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' " & vbCrlf & _
		  " and cast(empr_ncorr as varchar)='"&empr_ncorr&"' " & vbCrlf & _
		  " and cast(nord_compra as varchar)='"&nord_compra&"' " 
end if

if tiene_detalle = "0" then
	consulta = "select '"&dgso_ncorr&"' as dgso_ncorr, '"&empr_ncorr&"' as empr_ncorr,'"&nord_compra&"' as nord_compra, '"&fpot_ccod&"' as fpot_ccod,'"&empr_ncorr_2&"' as empr_ncorr_2"
end if
'response.write("<pre>"&consulta&"</pre>")
formulario.consultar consulta 
formulario.siguiente

lenguetas_masignaturas = Array(Array("Configurar Orden de compra", "agregar_orden_compra.asp?mote_ccod="&codigo))
'response.Write("doras "&horas_Asignatura&" duracion "&duracion_asignatura)
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

<script language="JavaScript">
function guardar(formulario){

if(preValidaFormulario(formulario))
    {	
    	formulario.action ='actualizar_modulos.asp';
		formulario.submit();
	}
	
}
function volver(){
	CerrarActualizar();
}


</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="380" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas lenguetas_masignaturas, 1%> </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              <form name="edicion" method="post">
			  <table width="100%"  border="0">
				  <tr>
					<td><strong>Programa : </strong><%=programa%></td>
				  </tr>
				  <tr>
					<td><strong>Matrícula : </strong><%=formatcurrency(matricula,0)%></td>
				  </tr>
				  <tr>
					<td><strong>Arancel : </strong><%=formatcurrency(arancel,0)%></td>
				  </tr>
				   <tr>
					<td><%if tipo=1 then
					       response.Write("<strong>Empresa :</strong> "&empresa_orden)
						  else
						   response.Write("<strong>Otic :</strong> "&empresa_orden)
						  end if%></td>
				  </tr>
				  <tr>
					<td><strong>N° de Orden :</strong><%=nord_compra%></td>
				  </tr>
				  <%if tipo= 2 then%>
				  <tr>
					<td><strong>Empresa :</strong><%=empresa%></td>
				  </tr>
				  <%end if%>
				  <tr>
					<td align="center">
						<table width="90%" border="1">
						<tr><td align="center">
						    	<table width="100%">
									<tr>
									    <td width="44%"><strong>Cant. Alumnos</strong></td>
										<td width="1%"><strong>:</strong></td>
									    <td><%formulario.dibujaCampo("ocot_nalumnos")%></td>
									</tr>
									<%if tipo = "2" then%>
									<tr>
									    <td width="44%"><strong>Monto Otic</strong></td>
										<td width="1%"><strong>:</strong></td>
									    <td><%formulario.dibujaCampo("ocot_monto_otic")%></td>
									</tr>
									<%end if%>
									<tr>
									    <td width="44%"><strong>Monto empresa</strong></td>
										<td width="1%"><strong>:</strong></td>
									    <td><%formulario.dibujaCampo("ocot_monto_empresa")%></td>
									</tr>
									<%formulario.dibujaCampo("dgso_ncorr")%>
									<%formulario.dibujaCampo("empr_ncorr")%>
									<%formulario.dibujaCampo("nord_compra")%>
									<%formulario.dibujaCampo("empr_ncorr_2")%>
									<%formulario.dibujaCampo("fpot_ccod")%>
									<input type="hidden" name="tipo" value="<%=tipo%>">
								</table>
							</td>
						</tr>
						</table>
					</td>
				  </tr>
				</table>
           </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%botonera.dibujaboton "guardar_orden_compra"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "salir"%></div></td>
                  <td><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</body>
</html>
