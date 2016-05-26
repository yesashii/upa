<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Ingreso de alumnos a eventos"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'--------------------------------------------------------------------------------------------


'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "eventos_upa.xml", "botonera"
'--------------------------------------------------------------------------------------------
folio_envio = Request.QueryString("folio_envio")
set f_envio = new CFormulario

f_envio.Carga_Parametros "eventos_upa.xml", "f_eventos"
f_envio.Inicializar conexion


 consulta=	"select (select cole_tdesc from colegios where cole_ccod=a.cole_ccod) as colegio, "& vbCrLf &_
 			" a.even_ncorr as c_even_ncorr, a.* from eventos_upa a where a.even_ncorr=  " & folio_envio 


 f_envio.Consultar consulta
 f_envio.siguiente
'----------------------------------------------------------------------------
set f_detalle_envio = new CFormulario
f_detalle_envio.Carga_Parametros "eventos_upa.xml", "f_detalle_alumnos"
f_detalle_envio.Inicializar conexion

consulta="select isnull(c.pers_nrut,0) as pers_nrut ,CASE c.pers_xdv WHEN 'k' THEN 10 WHEN 'N' THEN 11 ELSE 0 END as pers_xdv , c.pers_tnombre,"& vbCrLf &_
			" c.pers_tape_paterno ,c.pers_tape_materno,c.PERS_TDIRECCION, c.PERS_TEMAIL,a.even_ncorr, "& vbCrLf &_
			" cast(isnull(c.pers_nrut,0) as varchar)+'-'+cast(isnull(c.pers_xdv,0) as varchar) as rut_alumno,"& vbCrLf &_
			" c.pers_ncorr_alumno,a.even_ncorr as evento "& vbCrLf &_
			" from eventos_upa a, eventos_alumnos b, personas_eventos_upa c "  & vbCrLf &_
			" where a.even_ncorr=b.even_ncorr "  & vbCrLf &_
			" and b.pers_ncorr_alumno=c.pers_ncorr_alumno "  & vbCrLf &_
			" and a.even_ncorr='" & folio_envio & "'  "& vbCrLf &_
			" order by pers_nrut desc "
			
'response.Write("<pre>"&consulta&"</pre>")
'response.End()

f_detalle_envio.Consultar consulta
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
  function agregar_alumno(v_evento,tipo){
  	if (tipo==1){
  		window.open("../eventos/agregar_ficha_alumno.asp?evento="+v_evento,"agregar_alumno","");
	}else{
		window.open("../eventos/agregar_ficha_alumno_sin_rut.asp?evento="+v_evento,"agregar_alumno","");
	}
  }
  
  function navega(v_evento,v_pers_ncorr_alumno,v_pers_nrut,v_pers_xdv){
   
	   if 	(v_pers_nrut==0 ){
			v_url="agregar_ficha_alumno_sin_rut.asp?evento="+v_evento+"&pers_ncorr_alumno="+v_pers_ncorr_alumno;
	   }else{
			v_url="agregar_ficha_alumno.asp?evento="+v_evento+"&pers_ncorr_alumno="+v_pers_ncorr_alumno+"&rut_alumno="+v_pers_nrut+"&digito_v="+v_pers_xdv;
	   }
	  
		window.open(v_url,"agregar"," scrollbars, resizable, width=650, height=650 ");
  }
  
</script>
<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                <td>
                  <%pagina.dibujarLenguetas array (array("Detalle Cuotas","Envios_Tarjetas_Agregar1.asp")),1 %>
                </td>
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
                  
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
                    <BR><BR>
                  </div>
                  <table width="100%" border="0">
                    <tr> 
                      <td width="8%"><strong>N&ordm; Folio</strong></td>
                      <td width="2%">:</td>
                      <td width="14%"><font size="2"> 
                        <% f_envio.DibujaCampo("even_ncorr")%>
                        </font></td>
                      <td width="8%"><strong>Colegio</strong></td>
                      <td width="2%">:</td>
                      <td width="37%"><font size="2"> 
                        <% f_envio.DibujaCampo("colegio") %>
                        </font></td>
                      <td width="7%"><strong>Fecha</strong></td>
                      <td width="2%">:</td>
                      <td width="20%"><font size="2"> 
                        <% f_envio.DibujaCampo("even_fevento") %>
                        </font></td>
                    </tr>
                    <tr>
                      <td><strong>Evento</strong></td>
                      <td><strong>:</strong></td>
                      <td><font size="2"> 
                        <% f_envio.DibujaCampo("even_tnombre") %>
                        </font></td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                      <td>&nbsp;</td>
                    </tr>
                  </table>
                  <BR><BR>
				  <div align="center"> 
                    <table width="665" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_detalle_envio.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                 
                  <form name="edicion">
				    <% f_detalle_envio.DibujaTabla() %>
				  </form>
				   </div>  
                  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="126" bgcolor="#D8D8DE"><table width="97%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="14%"> <div align="left"> 
                          <%  botonera.agregabotonparam "anterior", "url", "ingreso_evento.asp?even_ncorr="& folio_envio
						      botonera.DibujaBoton "anterior"  %>
                        </div></td>
                      <td width="14%"> <%    if estado_envio = "2" or estado_envio = "4" then
						         				botonera.agregabotonparam "agregar_alumnos", "deshabilitado" ,"TRUE"
							  				end if
					              botonera.agregabotonparam "agregar_alumnos", "url" ,"javascript: agregar_alumno("& folio_envio& ",1);"
					              botonera.DibujaBoton "agregar_alumnos"
					   %> </td>
                      <td width="14%">
					  	<% 	if estado_envio = "2" or estado_envio = "4" then
								botonera.agregabotonparam "eliminar", "deshabilitado" ,"TRUE"
						 	end if 
						   		botonera.agregabotonparam "eliminar", "url", "proc_elimina_alumno_evento.asp"
						   		botonera.dibujaboton "eliminar"
						%> 
					</td>
					<td><%
							botonera.agregabotonparam "agregar_alumnos_sin_rut", "url" ,"javascript: agregar_alumno("& folio_envio& ",2);"
					    	botonera.DibujaBoton "agregar_alumnos_sin_rut"
						%>
					</td>
                      
                    </tr>
                  </table>                    
                  </td>
                  <td width="369" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="182" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
