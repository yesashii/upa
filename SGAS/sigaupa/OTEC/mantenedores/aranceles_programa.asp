<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
DCUR_NCORR = request.querystring("b[0][DCUR_NCORR]")
sede_ccod = request.querystring("b[0][sede_ccod]")
'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/aranceles_programa.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&detalle=2"
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Administrador de Aranceles para Diplomados y Cursos"

set botonera =  new CFormulario
botonera.carga_parametros "aranceles_programa.xml", "botonera"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores



'response.Write(carr_ccod)
dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM diplomados_cursos WHERE cast(dcur_ncorr as varchar)= '" & DCUR_NCORR & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "aranceles_programa.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' as dcur_ncorr, '' as sede_ccod"

 f_busqueda.AgregaCampoCons "DCUR_NCORR", DCUR_NCORR
 f_busqueda.AgregaCampoCons "SEDE_CCOD", SEDE_CCOD
 f_busqueda.Siguiente

tiene_datos_generales = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")

dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
dcur_nsence = conexion.consultaUno("select dcur_nsence from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")


'tiene_datos_generales = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")
dgso_ncorr = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")


'---------------------------------------------------------------------------------------------------
set datos_generales = new cformulario
datos_generales.carga_parametros "aranceles_programa.xml", "datos_generales"
datos_generales.inicializar conexion


consulta= " select a.dgso_ncorr,a.dcur_ncorr,a.sede_ccod,protic.trunc(dgso_finicio) as dgso_finicio,protic.trunc(dgso_ftermino) as dgso_ftermino," & vbCrlf & _
			" dgso_ncupo,dgso_nquorum,ofot_nmatricula,ofot_narancel, anio_admision,udpo_ccod, nro_resolucion, protic.trunc(fecha_resolucion)as fecha_resolucion,isnull(activa_web ,'N')as ofer_bpublica,cod_presupuestario " & vbCrlf & _
		  	" from datos_generales_secciones_otec a left outer join ofertas_otec  b" & vbCrlf & _
		  	"  on a.dgso_ncorr = b.dgso_ncorr " & vbCrlf &_
		  	" where cast(a.dcur_ncorr as varchar)='"&DCUR_NCORR&"'  " & vbCrlf & _
		  	" and cast(a.sede_ccod as varchar)='"&sede_ccod&"' " 

if tiene_datos_generales = "N" then
	consulta = "select '' as dgso_ncorr"
end if
'response.write("<pre>"&consulta&"</pre>")
datos_generales.consultar consulta 
if codigo <> "" then
	datos_generales.agregacampocons "sede_ccod", sede_ccod
	datos_generales.agregacampocons "dcur_ncorr", dcur_ncorr
	datos_generales.agregacampocons "udpo_ccod", udpo_ccod
end if
datos_generales.siguiente


dgso=datos_generales.ObtenerValor("dgso_ncorr")
if dgso<>"" then 
tiene_encargado=conexion.ConsultaUno("select case count(*) when 0 then 'NO' else 'SI' end from responsable_programa where dgso_ncorr="&dgso&" and esre_ccod=1")
else
tiene_encargado="NN"
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


<script language="JavaScript">
function enviar(formulario){
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
function abrir() {
	
	direccion = "editar_diplomados_curso.asp";
	resultado=window.open(direccion, "ventana1","width=550,height=250,scrollbars=no, left=380, top=150");
	
 // window.close();
}
function abrir_programa() {
	var DCUR_NCORR = '<%=DCUR_NCORR%>';
	direccion = "editar_programas_dcurso.asp?dcur_ncorr=" + DCUR_NCORR;
	resultado=window.open(direccion, "ventana2","width=550,height=400,scrollbars=yes, left=380, top=100");
	
 // window.close();
}
function deshabilita_web()
{
tiene_encargado='<%=tiene_encargado%>'

	if (tiene_encargado!='NN')
	{checkbox=document.edicion.elements["_m[0][ofer_bpublica]"]
	
		if (tiene_encargado=='SI')
			{
			 checkbox.disabled=false
			}
		else
			{
			 checkbox.disabled=true
			}
	}
		
}
</script>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');deshabilita_web();" onBlur="revisaVentana();">
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="90%">
	<tr>
		<td align="center">
	
	<table width="50%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td align="left"><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                    <td width="20%"><div align="center"><strong>Módulo</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><% f_busqueda.dibujaCampo ("dcur_ncorr") %></td>
                 </tr>
				  <tr>
                    <td width="20%"><div align="center"><strong>Sede</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><% f_busqueda.dibujaCampo ("sede_ccod") %></td>
                 </tr>
				 <tr> 
				  <td colspan="3"><input type="hidden" name="detalle" value=""></td>
                </tr>
				 <tr> 
				  <td colspan="3"><table width="100%">
				                      <tr>
									  	<td width="50%" align="center"><%'botonera.dibujaboton "crear_dcurso"%></td>
										<td width="50%" align="right"><%botonera.dibujaboton "buscar"%></td>
									  </tr>
				                  </table>
			       </td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
	</tr>
	</table>
	</td></tr>
	
	
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="edicion">
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if dcur_ncorr <> "" and not esVacio(dcur_ncorr) then %>
				  <tr>
                    <td><%response.Write("PROGRAMA: <strong>"&dcur_tdesc&"</strong>")
						%></td>
                  </tr>
				  <tr>
                    <td><%response.Write("SEDE: <strong>"&sede_tdesc&"</strong>")
						%></td>
                  </tr>
				  <tr>
                    <td><%response.Write("CÓDIGO SENCE: <strong>"&dcur_nsence&"</strong>")
						%></td>
                  </tr>
				  <%end if%>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if (dcur_ncorr <> "" ) and tiene_datos_generales = "S" then %>
                  
                  <tr>
                    <td align="center">
					   <table width="90%" border="1">
					                   <tr> 
									   <td align="center">
									     <table width="100%">
											   <tr>
												   <td width="20%">Fecha Inicio</td>
												   <td width="2%">:</td>
												   <td width="32%"><strong>
											     <%datos_generales.dibujaCampo("dgso_finicio")%></strong></td>
												   <td width="18%" align="right">Fecha Término</td>
												   <td width="2%">:</td>
												   <td width="26%"><strong>
											     <%datos_generales.dibujaCampo("dgso_ftermino")%></strong></td>
											   </tr>
											   <tr>
												   <td width="20%">Cupo Máximo</td>
												   <td width="2%">:</td>
												   <td width="32%"><strong>
											     <%datos_generales.dibujaCampo("dgso_ncupo")%></strong></td>
												   <td width="18%" align="right">Quorum</td>
												   <td width="2%">:</td>
												   <td width="26%"><strong>
											     <%datos_generales.dibujaCampo("dgso_nquorum")%></strong></td>
											   </tr>
											   <tr>
												   <td width="20%">Valor Matrícula</td>
												   <td width="2%">:</td>
												   <td width="32%"><strong>
											     <%datos_generales.dibujaCampo("ofot_nmatricula")%></strong> (*$)</td>
												   <td width="18%" align="right">Valor Arancel</td>
												   <td width="2%">:</td>
												   <td width="26%"><strong>
											     <%datos_generales.dibujaCampo("ofot_narancel")%></strong> ($)</td>
											   </tr>
											   <tr>
												   <td width="20%">Año Admisión</td>
												   <td width="2%">:</td>
												   <td width="32%"><strong>
											     <%datos_generales.dibujaCampo("anio_admision")%></strong> (Ej:2008)</td>
												   <td width="18%" align="right">Nro Resolución</td>
												   <td width="2%">:</td>
											     <td width="26%"><%datos_generales.dibujaCampo("nro_resolucion")%></td>
											   </tr>
											   <tr>
												   <td width="20%">Fecha Resolución</td>
												   <td width="2%">:</td>
												   <td width="32%"><strong>
											     <%datos_generales.dibujaCampo("fecha_resolucion")%></strong> (dd/mm/aaaa)</td>
												   <td width="18%" align="right">Publica WEB </td>
												   <td width="2%">:</td>
											     <td width="26%"><%datos_generales.dibujaCampo("ofer_bpublica")%>**</td>
											   </tr>											   
											   <tr>
												   <td width="20%"><p>Unidad que lo dicta </p>
										         </td>
												   <td width="2%">:</td>
												   <td colspan="4"><strong>
											     <%datos_generales.dibujaCampo("udpo_ccod")%></strong></td>
											   </tr>
											   <tr>
												   <td width="20%"><p>Responsable Asignado </p>
										         </td>
												   <td width="2%">:</td>
												   <td colspan="4"><strong><%=tiene_encargado%></strong></td>
											   </tr>
											   <tr>
												   <td width="20%"><p>Codigo Presupuestario</p>
										         </td>
												   <td width="2%">:</td>
												   <td colspan="4"><strong> <%datos_generales.dibujaCampo("cod_presupuestario")%></strong></td>
											   </tr>
											   <tr><td colspan="6" align="right"><%botonera.dibujaboton "guardar_arancel"%></td></tr>
											   <tr><td colspan="6" align="right">&nbsp;
											       <input type="hidden" name="m[0][dgso_ncorr]" value="<%=dgso_ncorr%>">
												   <input type="hidden" name="m[0][dcur_ncorr]" value="<%=dcur_ncorr%>">
												   <input type="hidden" name="m[0][sede_ccod]" value="<%=sede_ccod%>">
											       </td>
											   </tr>
											   <tr><td colspan="6" align="left">* En el caso que el programa no considere matrícula dejar este valor en cero(0).</td></tr>
											   <tr>
											     <td colspan="6" align="left">** Para que el programa pueda ser Público en la WEB debe tener un responsable asignado .</td>
											   </tr>
											
											</table>
										</td>
									   </tr>
									 </table>
				    </td>
                  </tr>
				  <%end if
				    if (dcur_ncorr <> "" ) and tiene_datos_generales = "N" then%>
					<tr>
                    <td align="center"><font color="#993300"><strong>AÚN NO SE HA CREADO UNA DEFINICIÓN ACADÉMICA DEL PROGRAMA SOLICITADO</strong></font></td>
                  </tr>
				  <%end if%>	
                </table>
                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</td>
</tr>
</table>
</body>
</html>
