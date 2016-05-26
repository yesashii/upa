<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = " Gestion Matricula OTEC"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

inicio = request.querystring("inicio")
ano_ccod  = request.querystring("busqueda[0][ano_ccod]")
ano_ccod2  = request.querystring("ano_ccod")

if ano_ccod2 ="" then
ano_ccod2=0
end if
if ano_ccod="" then
ano_ccod=ano_ccod2
end if

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "gestion_matricula_otec.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "ano_ccod", ano_ccod
 




set f_botonera = new CFormulario
f_botonera.Carga_Parametros "gestion_matricula_otec.xml", "botonera"

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

set lista = new CFormulario
lista.carga_parametros "gestion_matricula_otec.xml", "lista_contratos"
lista.inicializar conexion



consulta = "select sede_tdesc,mm.sede_ccod,count(pendiente)as pendiente,count(aprobado) as aprobado,count(matriculado)as matriculado,"& vbcrlf & _


"(select total" & vbcrlf & _
"from (select sede_ccod,sum(dgso_nquorum)as total from(select dcur_ncorr,sede_ccod,dgso_nquorum  from"& vbcrlf & _
"(select dgot.sede_ccod,dgso_nquorum,dgot.dcur_ncorr,"& vbcrlf & _
"case when epot_ccod =1 then epot_ccod end as  pendiente,"& vbcrlf & _
"case when epot_ccod =2 then epot_ccod end as  aprobado,"& vbcrlf & _
"case when epot_ccod in (3,4) then epot_ccod end as  matriculado"& vbcrlf & _
"from postulacion_otec pot right outer join datos_generales_secciones_otec dgot"& vbcrlf & _
"on dgot.dgso_ncorr= pot.dgso_ncorr"& vbcrlf & _
"join ofertas_otec oot"& vbcrlf & _
"on dgot.dcur_ncorr=oot.dcur_ncorr"& vbcrlf & _
"and anio_admision="&ano_ccod&")as nnn"& vbcrlf & _
"group by dcur_ncorr,sede_ccod,dgso_nquorum)aaa"& vbcrlf & _
"group by sede_ccod)aaaa"& vbcrlf & _
"where aaaa.sede_ccod=mm.sede_ccod)as meta"& vbcrlf & _
  
"from(select dgot.sede_ccod,dgso_nquorum,dgot.dcur_ncorr,"& vbcrlf & _
"case when epot_ccod =1 then epot_ccod end as  pendiente,"& vbcrlf & _
"case when epot_ccod =2 then epot_ccod end as  aprobado,"& vbcrlf & _
"case when epot_ccod in (3,4) then epot_ccod end as  matriculado"& vbcrlf & _
"from postulacion_otec pot right outer join datos_generales_secciones_otec dgot"& vbcrlf & _
"on  pot.dgso_ncorr=dgot.dgso_ncorr"& vbcrlf & _
"right outer join ofertas_otec oot"& vbcrlf & _
"on dgot.dcur_ncorr=oot.dcur_ncorr"& vbcrlf & _
"and anio_admision="&ano_ccod&")as mm,sedes s"& vbcrlf & _
"where mm.sede_ccod=s.sede_ccod"& vbcrlf & _
"group by sede_tdesc,mm.sede_ccod"

'response.Write(consulta)
'"select sede_tdesc,count(pendiente)as pendiente,count(aprobado) as aprobado,count(matriculado)as matriculado  from"& vbcrlf & _
'"(select dgot.sede_ccod,"& vbcrlf & _
'"case when epot_ccod =1 then epot_ccod end as  pendiente,"& vbcrlf & _
'"case when epot_ccod =2 then epot_ccod end as  aprobado,"& vbcrlf & _
'"case when epot_ccod in (3,4) then epot_ccod end as  matriculado"& vbcrlf & _
'"from postulacion_otec pot,datos_generales_secciones_otec dgot,ofertas_otec oot"& vbcrlf & _
'"where pot.dgso_ncorr=dgot.dgso_ncorr"& vbcrlf & _
'"and dgot.dcur_ncorr=oot.dcur_ncorr"& vbcrlf & _
'"and anio_admision="&ano_ccod&")as mm,sedes s"& vbcrlf & _
'"where mm.sede_ccod=s.sede_ccod"& vbcrlf & _
'"group by sede_tdesc"

lista.Consultar consulta

'response.Write("<pre>"&ano_ccod&"</pre>")	
'response.Write("<pre>"&consulta&"</pre>")	


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

function enviar(formulario)
{
document.buscador.method="get";
document.buscador.action="contratos_x_dias.asp";
document.buscador.submit();
}
function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}

</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "inicio","1","buscador","fecha_oculta_inicio"
	calendario.FinFuncion
%>
<style type="text/css">
<!--
body {
	background-color: #D8D8DE;
}
-->
</style></head>
<body#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<%calendario.ImprimeVariables%>
<table width="620" border="0" align="center" cellpadding="0" cellspacing="0">
  
 
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                <td height="60">
<form name="buscador" method="get" action="">
              <br>
			   <table width="98%"  border="0" align="center">
                <tr>
                  <td width="82%"><div align="center">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                     
                   
                          <td width="27%"><strong>Periodo Academico </strong></td>
                            <td width="2%">:</td>
                        <td width="71%"><% f_busqueda.DibujaCampo ("ano_ccod") %></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="18%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
			     
				 <table width="52%" border="1" align="center">
  <tr borderColor="#999999"> 
  
  <td width="39%" height="17" bgColor="#c4d7ff"><div align="center"><strong>Sedes</strong></div></td>
  <td width="20%" bgColor="#c4d7ff"><div align="center"><strong>Pendientes</strong></div></td>
  <td width="19%" bgColor="#c4d7ff"><div align="center"><strong>Aprobados</strong></div></td>
  <td width="22%" bgColor="#c4d7ff"><div align="center"><strong>Matriculados</strong></div></td>
  <td width="22%" bgColor="#c4d7ff"><div align="center"><strong>Meta</strong></div></td>
  

   
  </tr>
   
  <%  while lista.Siguiente
  total_pendiente = total_pendiente  + cdbl(lista.Obtenervalor("pendiente"))
		total_aprobado = total_aprobado  + cdbl(lista.Obtenervalor("aprobado"))
		total_matriculado = total_matriculado  + cdbl(lista.Obtenervalor("matriculado"))
		total_meta = total_meta  + cdbl(lista.Obtenervalor("meta"))
		 %>
  
  
  <tr borderColor="#999999"> 
    
    <td bgcolor="#FFFFFF"><div align="left"><%=lista.Obtenervalor("sede_tdesc")%></div></td>
	<td bgcolor="#FFFFFF" class='click' onClick='irA("gestion_matricula_matriculados.asp?sede_ccod=<%=lista.obtenervalor("sede_ccod")%>&ano_ccod=<%=ano_ccod%>", "2", 600, 400)'><div align="right"><%=lista.Obtenervalor("pendiente")%></div></td>
	<td bgcolor="#FFFFFF" class='click' onClick='irA("gestion_matricula_matriculados.asp?sede_ccod=<%=lista.obtenervalor("sede_ccod")%>&ano_ccod=<%=ano_ccod%>", "2", 600, 400)'><div align="right"><%=lista.Obtenervalor("aprobado")%></div></td>
	<td bgcolor="#FFFFFF" class='click' onClick='irA("gestion_matricula_matriculados.asp?sede_ccod=<%=lista.obtenervalor("sede_ccod")%>&ano_ccod=<%=ano_ccod%>", "2", 600, 400)'><div align="right"><%=lista.Obtenervalor("matriculado")%></div></td>
	<td bgcolor="#FFFFFF" class='click' onClick='irA("gestion_matricula_matriculados.asp?sede_ccod=<%=lista.obtenervalor("sede_ccod")%>&ano_ccod=<%=ano_ccod%>", "2", 600, 400)'><div align="right"><strong><%=lista.Obtenervalor("meta")%></strong></div></td>
	
  </tr>
   
  
 
      <%  wend %>
	   
	   
	   
   
  <tr borderColor="#999999"> 
    
    <td bgColor="#c4d7ff"><div align="center"><strong>Total</strong></div></td>
	<td bgcolor="#FFFFFF" ><div align="right"><strong><%=total_pendiente%></strong></div></td>
	<td bgcolor="#FFFFFF"><div align="right"><strong><%=total_aprobado%></strong></div></td>
	 <td bgcolor="#FFFFFF"><div align="right"><strong><%=total_matriculado%></strong></div></td>
	  <td bgcolor="#FFFFFF"><div align="right"><strong><%=total_meta%></strong></div></td>
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
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  
				  <td><div align="center">
                    
					<%f_botonera.AgregaBotonParam "excel", "url", "gestion_matricula_otec_excel.asp?ano_ccod="&ano_ccod
				   f_botonera.DibujaBoton"excel"  %></div></td>
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
