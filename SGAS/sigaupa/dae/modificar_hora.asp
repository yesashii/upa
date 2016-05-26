<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

hoto_ncorr=request.QueryString("hoto_ncorr")
peri_ccod=request.QueryString("peri_ccod")
indice=request.QueryString("indice")
sede_ccod=request.QueryString("sede_ccod")
fecha_consulta=request.QueryString("fecha_consulta")
'response.Write(peri_ccod&"<br>"&sede_ccod&"<br>"&fecha)
'---------------------------------------------------------------------------------------------------

set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "modifica_hora.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "modifica_hora.xml", "botonera"

'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------

set f_horas = new CFormulario
f_horas.Carga_Parametros "modifica_hora.xml", "hora"
f_horas.Inicializar conexion
'if sede_ccod<>"" then  
sql_hora="select a.pers_ncorr,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,isnull(dasi_email,pers_temail)as email,isnull(dasi_celular,pers_tcelular)as celular,isnull(dasi_telefono,a.PERS_TFONO)as fono,e.esho_ccod,protic.trunc(hoto_fecha)as fecha"& vbcrlf & _
"from personas a"& vbcrlf & _
"left outer join datos_alumnos_sicologas d"& vbcrlf & _
"on a.PERS_NCORR=d.pers_ncorr"& vbcrlf & _
"join horas_tomadas e"& vbcrlf & _
"on a.PERS_NCORR=e.pers_ncorr"& vbcrlf & _
"join estado_horas f"& vbcrlf & _
"on e.esho_ccod=f.esho_ccod"& vbcrlf & _
"where e.hoto_ncorr="&hoto_ncorr&""

'else
'sql_hora="select ''"
'end if

'response.Write("<br>"&sql_hora)
f_horas.Consultar sql_hora
f_horas.siguiente




asistio=conexion.ConsultaUno("select case count(*) when 0 then 'No' else 'Si' end asistio from horas_tomadas where hoto_ncorr="&hoto_ncorr&" and esho_ccod=2")
anulada=conexion.ConsultaUno("select case count(*) when 0 then 'No' else 'Si' end anulo from horas_tomadas where hoto_ncorr="&hoto_ncorr&" and esho_ccod in (4,5)")
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


</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">
<form name="edicion">
<input type="hidden" name="hoto_ncorr" value="<%=hoto_ncorr%>">
<input type="hidden" name="peri_ccod" value="<%=peri_ccod%>">
<input type="hidden" name="sede_ccod" value="<%=sede_ccod%>">
<input type="hidden" name="fecha" value="<%=fecha_consulta%>">
<input type="hidden" name="indice" value="<%=indice%>">
<table width="750" height="250" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	
	<br>
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
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  
          <tr>
            <td>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="50%">
						  <table width="100%"  border="0" align="center">
								 <tr>						
								 	<td width="17%"><strong>Nombre Alumno:</strong></td>
									<td width="32%"><%f_horas.DibujaCampo("nombre")%></td>
									<td width="12%"><strong>Fecha Hora:</strong></td>
									<td colspan="3"><%f_horas.DibujaCampo("fecha")%></td>
						         </tr>
								 <tr>
								 	<td>
										<strong>Email:</strong></td>
									<td>
										<%f_horas.DibujaCampo("email")%>
									</td>
									<td>
										<strong>Telefono:</strong>
									</td>
									<td width="14%">
										<%f_horas.DibujaCampo("fono")%>
								   </td>
									<td width="7%">
										<strong>Celular:</strong>									
									</td>
									<td width="18%">
										<%f_horas.DibujaCampo("celular")%>
								   </td>
								 </tr>
								 
						  </table>
				   </td>
                  </tr>
                </table>
                <br>
				
           </td>
		</tr>
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
				
                  <td align="center"><%
				  
				  					  if asistio="Si"  then
				  						f_botonera.AgregaBotonParam "anular","deshabilitado","TRUE"  
				  					   end if
									   
									   if anulada="Si"  then
				  						f_botonera.AgregaBotonParam "anular","deshabilitado","TRUE"  
				  					   end if
									   
				 					    f_botonera.DibujaBoton("anular")
									 %>
				  </td>
				  <td align="center"><%
				  					   if asistio="Si" then
				  						f_botonera.AgregaBotonParam "asiste","deshabilitado","TRUE"  
				  					   end if
									   
									    if anulada="Si"  then
				  						f_botonera.AgregaBotonParam "asiste","deshabilitado","TRUE"  
				  					   end if
				  						f_botonera.DibujaBoton("asiste")
				  					 %>
				  </td>
							 
                  <td><div align="center"><%f_botonera.AgregaBotonParam "volver", "url", "muestra_horas.asp?sede_ccod="&sede_ccod&"&peri_ccod="&peri_ccod&"&fecha_consulta="&fecha_consulta&"&indice="&indice&""
											f_botonera.DibujaBoton("volver")%></div></td>
				  
				  
				 
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table>
		
		</td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table> </form>
</body>
</html>