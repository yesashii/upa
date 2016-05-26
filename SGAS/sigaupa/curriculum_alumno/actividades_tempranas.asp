<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_pers_ncorr=Request.QueryString("pers_ncorr")'16355200
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Historial de Documentos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "alumnos_taller.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "alumnos_taller.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "alumnos_taller.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
if q_pers_nrut = "" and q_pers_ncorr <>""  then
q_pers_nrut=conexion.consultaUno("Select pers_nrut from personas where pers_ncorr="&q_pers_ncorr&"")
q_pers_xdv=conexion.consultaUno("Select pers_xdv from personas where pers_nrut="&q_pers_nrut&"")
end if

if q_pers_nrut = "" and q_pers_ncorr="" then
q_pers_nrut=0
end if

f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


 pers_ncorr=conexion.consultaUno("Select protic.obtener_pers_ncorr("&q_pers_nrut&")")
					

  set f_muestra_pasantia = new CFormulario
 f_muestra_pasantia.Carga_Parametros "curriculum_alumno.xml", "pasantia_muestra_sga"
 f_muestra_pasantia.Inicializar conexion

					
				MuestraPasantia=	"select a.dlpr_ncorr,pers_ncorr ,dlpr_nombre_empresa,dlpr_rubro_empresa,dlpr_cargo_empresa,dlpr_web_empresa from direccion_laboral_profesionales a,experiencia_alumno b where a.dlpr_ncorr=b.dlpr_ncorr and tiea_ccod=3 and a.pers_ncorr="&pers_ncorr&" order by exal_fini desc "

 f_muestra_pasantia.Consultar MuestraPasantia




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
function abrir_pdf()
{
irA('curriculum_pdf.asp?pers_nrut=<%=q_pers_nrut%>', '1', 1240, 768);
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="74%"  border="0" align="center">
                <tr>
					
					<td width="18%"><strong>Rut  :</strong></td>
					
					<td width="10%"><div align="center"><%f_busqueda.DibujaCampo("pers_nrut")%></div></td>
					<td width="4%">-</td>
					<td width="5%"><div align="center"><%f_busqueda.DibujaCampo("pers_xdv")%>
					</div></td>
					<td width="7%"><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
                  	<td width="42%"></div></td>
					<td width="14%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
	<table width="90%" height="0" border="0" align="center" cellpadding="0" cellspacing="0" >
	
	 			<tr valign="bottom" bgcolor="#D8D8DE">	
		 			<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        			<td height="8" background="../imagenes/top_r1_c2.gif"></td>
        			<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
	 				
		 			<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        			<td height="8" background="../imagenes/top_r1_c2.gif"></td>
        			<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
	 		
		 			<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        			<td height="8" background="../imagenes/top_r1_c2.gif"></td>
        			<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
					
					<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        			<td height="8" background="../imagenes/top_r1_c2.gif"></td>
        			<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>

      			</tr>
				<tr>
				 <td  height="2" background="../imagenes/izq.gif"></td>
				 <td bgcolor="#D8D8DE"><strong></strong><a href=datos_personales.asp?pers_ncorr=<%=pers_ncorr%>>DATOS PERSONALES </a></td>
				 <td height="2" background="../imagenes/der.gif"></td>
				 
				 <td height="2" background="../imagenes/izq.gif"></td>
				 <td bgcolor="#D8D8DE"><strong></strong><a href=cursos_diplomados.asp?pers_ncorr=<%=pers_ncorr%>>CURSOS DIPLOMADOS </a></td>
				 <td height="2" background="../imagenes/der.gif"></td>
				 
				 <td height="2" background="../imagenes/izq.gif"></td>
				 <td bgcolor="#D8D8DE"><strong></strong><a href=experiencia_laboral.asp?pers_ncorr=<%=pers_ncorr%>>EXPERIENCIA LABORAL</a></td>
				 <td height="2" background="../imagenes/der.gif"></td>

				 <td height="2" background="../imagenes/izq.gif"></td>
				 <td bgcolor="#D8D8DE"><strong></strong><a href=practica_laboral.asp?pers_ncorr=<%=pers_ncorr%>>PRACTICA LABORAL </a></td>
				 <td height="2" background="../imagenes/der.gif"></td>


				</tr>
	</table>
		<table width="90%" height="0" border="0" align="center" cellpadding="0" cellspacing="0" >
	
	 			<tr valign="bottom" bgcolor="#D8D8DE">	
					<td width="9" height="8" background="../imagenes/izq.gif"></td>
					<td height="8" background="../imagenes/top_r1_c2.gif"></td>
        			<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
	 				
		 			<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        			<td height="8" background="../imagenes/top_r1_c2.gif"></td>
        			<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
	 		
		 			<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        			<td height="8" background="../imagenes/top_r1_c2.gif"></td>
        			<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>

		 			<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        			<td height="8" background="../imagenes/top_r1_c2.gif"></td>
					<td width="7" height="8" background="../imagenes/der.gif"></td>
					
      			</tr>
				<tr>
				 <td height="2" background="../imagenes/izq.gif"></td>
				 <td bgcolor="#D8D8DE"><strong>ACTIVIDADES TEMPRANAS</strong></td>
				 <td height="2" background="../imagenes/der.gif"></td>
				 
				 <td height="2" background="../imagenes/izq.gif"></td>
				 <td bgcolor="#D8D8DE"><strong></strong><a href=idiomas.asp?pers_ncorr=<%=pers_ncorr%>>IDIOMAS</a></td>
				 <td height="2" background="../imagenes/der.gif"></td>
				 
				 <td height="2" background="../imagenes/izq.gif"></td>
				 <td bgcolor="#D8D8DE"><strong></strong><a href=dominios_programas.asp?pers_ncorr=<%=pers_ncorr%>>DOMINIO DE PROGRAMAS</a></td>
				 <td height="2" background="../imagenes/der.gif"></td>
				 
				 <td height="2" background="../imagenes/izq.gif"></td>
				 <td bgcolor="#D8D8DE"><strong></strong><a href=habilidades.asp?pers_ncorr=<%=pers_ncorr%>>HABILIDADES</a></td>
				 <td height="2" background="../imagenes/der.gif"></td>


				</tr>
	</table>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
		<td width="9" height="8" background="../imagenes/izq.gif"></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
		<td width="7" height="8" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Actividades Tempranas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  <td><div align="center">
                    <br>
                    <table width="100%" border="0">
                     
                    </table>
			  </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%'pagina.DibujarSubtitulo "Detalles Taller"%>
                      <table width="98%"  border="0" align="center">
                        
                        <tr>						
                          <td align="center"><%f_muestra_pasantia.DibujaTabla()%></td>
                        </tr>
                        </table>
					     
                        <br>

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
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<td align="center"><%f_botonera.DibujaBoton"pdf"%></td>
				   
				  
						
				   
				   	 
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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