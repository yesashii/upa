<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Gestion Matricula OTEC"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion


sede_ccod= request.QueryString("sede_ccod")
ano_ccod  = request.querystring("ano_ccod")
epot_ccod= request.QueryString("epot_ccod")
dgso_ncorr = request.querystring("dgso_ncorr")
if ano_ccod ="" then 
ano_ccod=0
end if
'response.Write("<pre> sede= "&sede_ccod&"</pre>")
'response.Write("<pre> año= "&ano_ccod&"</pre>")
'response.Write("<pre>epot= "&epot_ccod&"</pre>")
'response.Write("<pre> dgso= "&dgso_ncorr&"</pre>")
'response.End()


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "gestion_matricula_otec.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
if epot_ccod="4" then
epot_ccod="3,4"
end if
 




set f_botonera = new CFormulario
f_botonera.Carga_Parametros "gestion_matricula_otec.xml", "botonera"

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

set lista = new CFormulario
lista.carga_parametros "gestion_matricula_otec.xml", "detalle_gestion_matricula"
lista.inicializar conexion


sede_tdesc=conexion.consultaUno("select sede_tdesc from sedes where sede_ccod='"&sede_ccod&"'")
 
consulta ="select distinct upper(pers_tape_paterno)+' '+upper(pers_tape_materno)+' '+upper(pers_tnombre) as nombre, "& vbcrlf & _
			" cast(pers_nrut as varchar)+'-'+pers_xdv as rut,a.dgso_ncorr, "& vbcrlf & _
			" (select epot_tdesc from estados_postulacion_otec where epot_ccod=a.epot_ccod)as estado , "& vbcrlf & _
			" protic .trunc (a.fecha_postulacion) as fecha_post,protic .trunc (a.audi_fmodificacion) as fecha_matr, "& vbcrlf & _
			" (select empr_trazon_social from empresas where empr_ncorr=a.empr_ncorr_empresa)as empresa, "& vbcrlf & _
			" (select empr_trazon_social from empresas where empr_ncorr=a.empr_ncorr_otic)as otic, "& vbcrlf & _
			" (select cast(empr_nrut as varchar)+'-'+empr_xdv as rut from empresas where empr_ncorr=a.empr_ncorr_empresa)as rut_empresa, "& vbcrlf & _
			" (select cast(empr_nrut as varchar)+'-'+empr_xdv as rut from empresas where empr_ncorr=a.empr_ncorr_otic)as rut_otic, "& vbcrlf & _
			"  protic.ES_MOROSO_OTEC(a.pers_ncorr,(select comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.pers_ncorr and tipo_institucion=1)) as deuda_particuar, "& vbcrlf & _
			"  protic.ES_MOROSO_OTEC(a.empr_ncorr_empresa,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.empr_ncorr_empresa and tipo_institucion=2)) as deuda_empresa, "& vbcrlf & _
			"  protic.ES_MOROSO_OTEC(a.empr_ncorr_otic,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.empr_ncorr_otic and tipo_institucion=3)) as deuda_otic "& vbcrlf & _
			" from postulacion_otec a "& vbcrlf & _
			" join personas b"& vbcrlf & _
			" on a.pers_ncorr=b.pers_ncorr"& vbcrlf & _
			" and a.epot_ccod in ("&epot_ccod&")"& vbcrlf & _
			" and a.dgso_ncorr="&dgso_ncorr&""& vbcrlf & _
			" join datos_generales_secciones_otec c"& vbcrlf & _
			" on a.dgso_ncorr=c.dgso_ncorr"& vbcrlf & _
			" and sede_ccod="&sede_ccod&""& vbcrlf & _
			" left outer join postulantes_cargos_otec d"& vbcrlf & _
			" on d.pote_ncorr=a.pote_ncorr"& vbcrlf & _
			" order by nombre"


 'response.Write("<pre>"&consulta&"</pre>")
 'response.end()

lista.Consultar consulta




'response.Write("<pre>"&consulta&"</pre>")	
'response.Write("<pre>"&sede_tdesc&"</pre>")
'response.Write("<pre>"&sede_ccod&"</pre>")	


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


function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}

</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "inicio","1","buscador","fecha_oculta_inicio"
	calendario.FinFuncion
%><style type="text/css">
<!--
body {
	background-color: #D8D8DE;
}
-->
</style></head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<%calendario.ImprimeVariables%>
<table width="650" border="0" align="center" cellpadding="0" cellspacing="0">
  
 
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td><br><div align="center"> 
                    <%pagina.DibujarTituloPagina%>
                </div>
              <form name="edicion" method="post" action="">
			     
				 <table width="93%" border="1" align="center">
  <tr borderColor="#999999"> 
  
  <td width="10%" bgColor="#c4d7ff"><div align="center"><strong>Mora</strong></div></td>
  <td width="13%" height="17" bgColor="#c4d7ff"><div align="center"><strong>Sede</strong></div></td>
  <td width="31%" height="17" bgColor="#c4d7ff"><div align="center"><strong>Nombre</strong></div></td>
  <td width="17%" bgColor="#c4d7ff"><div align="center"><strong>Rut</strong></div></td>
  <td width="14%" bgColor="#c4d7ff"><div align="center"><strong>Fecha Postulacion </strong></div></td>
  <td width="14%" bgColor="#c4d7ff"><div align="center"><strong>Fecha Matricula </strong></div></td>
  <td width="11%" bgColor="#c4d7ff"><div align="center"><strong>Estado</strong></div></td>
  <td width="11%" bgColor="#c4d7ff"><div align="center"><strong>Empresa</strong></div></td>
  <td width="11%" bgColor="#c4d7ff"><div align="center"><strong>Rut Empresa</strong></div></td>
  <td width="11%" bgColor="#c4d7ff"><div align="center"><strong>Otic</strong></div></td> 
  <td width="11%" bgColor="#c4d7ff"><div align="center"><strong>Rut Otic</strong></div></td>
  <td width="11%" bgColor="#c4d7ff"><div align="center"><strong>Deuda particular</strong></div></td>
  <td width="11%" bgColor="#c4d7ff"><div align="center"><strong>Deuda Empresa</strong></div></td> 
  <td width="11%" bgColor="#c4d7ff"><div align="center"><strong>Deuda Otic</strong></div></td>	 
  </tr>
   
  <%  while lista.Siguiente 
  v_deuda= clng(lista.Obtenervalor("deuda_otic")) +clng(lista.Obtenervalor("deuda_empresa")) + clng(lista.Obtenervalor("deuda_particuar"))
  'response.Write("<br>"&v_deuda) 
  if v_deuda>0 then
	img_deuda="stop_x_mora.gif"
  else
  	img_deuda="on_x_mora.gif"
  end if
  %>
  <tr borderColor="#999999"> 
    
    <td bgcolor="#FFECC6"><div align="left"><img src="../imagenes/<%=img_deuda%>"/></div></td>
	<td bgcolor="#FFECC6"><div align="left"><%=sede_tdesc%></div></td>
	<td bgcolor="#FFECC6"><div align="left"><%=lista.Obtenervalor("nombre")%></div></td>
	<td bgcolor="#FFECC6" ><div align="right"><%=lista.Obtenervalor("rut")%></div></td>
	<td bgcolor="#FFECC6" ><div align="right"><%=lista.Obtenervalor("fecha_post")%></div></td>
	<td bgcolor="#FFECC6" ><div align="right"><%=lista.Obtenervalor("fecha_matr")%></div></td>
	<td bgcolor="#FFECC6" ><div align="right"><strong><%=lista.Obtenervalor("estado")%></strong></div></td>
	<td bgcolor="#FFECC6" ><div align="right"><strong><%=lista.Obtenervalor("empresa")%></strong></div></td>
	<td bgcolor="#FFECC6" ><div align="right"><strong><%=lista.Obtenervalor("rut_empresa")%></strong></div></td>
	<td bgcolor="#FFECC6" ><div align="right"><strong><%=lista.Obtenervalor("otic")%></strong></div></td>
	<td bgcolor="#FFECC6" ><div align="right"><strong><%=lista.Obtenervalor("rut_otic")%></strong></div></td>
	<td bgcolor="#FFECC6" ><div align="right"><strong><%=lista.Obtenervalor("deuda_particuar")%></strong></div></td>
	<td bgcolor="#FFECC6" ><div align="right"><strong><%=lista.Obtenervalor("deuda_empresa")%></strong></div></td>
	<td bgcolor="#FFECC6" ><div align="right"><strong><%=lista.Obtenervalor("deuda_otic")%></strong></div></td>

  </tr>
   
  
  
   <%  wend %>
	 
	   
	   
 
 
</table>
				 
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				<td width="51%"><div align="center">
                    <%f_botonera.AgregaBotonParam "Atras", "url", "gestion_matricula_matriculados.asp?sede_ccod="&sede_ccod&"&ano_ccod="&ano_ccod
					f_botonera.DibujaBoton "Atras"%></div></td>
                
				
				   <td><div align="center">
                    
				<%f_botonera.AgregaBotonParam "excel2", "url", "detalle_gestion_matricula_matriculados_excel.asp?ano_ccod="&ano_ccod&"&sede_ccod="&sede_ccod&"&epot_ccod="&epot_ccod&"&dgso_ncorr="&dgso_ncorr
				   f_botonera.DibujaBoton"excel2"  %></div></td>
				   
				 </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
