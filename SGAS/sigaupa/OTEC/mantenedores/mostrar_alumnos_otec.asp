<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.QueryString
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'	next
v_fact_ncorr =Request.QueryString("fact_ncorr")
v_dgso_ncorr =Request.QueryString("dgso_ncorr")
'response.Write(v_fact_ncorr)
'---------------------------------------------------------------------------------------------------
set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Alumnos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new cPagina

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "mantenedor_facturas.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_resumen_convenio = new CFormulario
f_resumen_convenio.Carga_Parametros "mantenedor_facturas.xml", "alumnos"
f_resumen_convenio.Inicializar conexion

if v_fact_ncorr <> "" then
sql_descuentos="select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut, pers_temail as email, epot_tdesc" & vbCrLf &_
"from postulacion_otec po, personas p, postulantes_cargos_factura pcf, estados_postulacion_otec epo" & vbCrLf &_
"where po.pote_ncorr = pcf.pote_ncorr"& vbCrLf &_
"and po.pers_ncorr = p.PERS_NCORR"& vbCrLf &_
"and po.epot_ccod = epo.epot_ccod"& vbCrLf &_
"and pcf.fact_ncorr ="&v_fact_ncorr&""

'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
f_resumen_convenio.Consultar sql_descuentos
else 

f_resumen_convenio.Consultar "select ''"
end if


set cursos_otic = new CFormulario
cursos_otic.Carga_Parametros "mantenedor_facturas.xml", "alumnos"
cursos_otic.Inicializar conexion

if v_dgso_ncorr <> "" then
sql_descuentos="select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut, pers_temail as email, epot_tdesc" & vbCrLf &_
"from postulacion_otec po, personas p, estados_postulacion_otec epo" & vbCrLf &_
"where po.pers_ncorr = p.PERS_NCORR"& vbCrLf &_
"and po.epot_ccod = epo.epot_ccod"& vbCrLf &_
"and po.dgso_ncorr ="&v_dgso_ncorr&""

'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
cursos_otic.Consultar sql_descuentos
else 

cursos_otic.Consultar "select ''"
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
 
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%pagina.DibujarTituloPagina%>
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<%if request.QueryString.count > 0 and buscar<>"N" then%> 
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  
            <td><br>
  
             <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Alumnos"%>
				
                      <table width="98%"  border="0" align="center">
					   <tr>
                       	 <%if v_fact_ncorr <> "" then%>                       
                             <td align="right">P&aacute;gina:
                                 <%f_resumen_convenio.accesopagina%>
                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
									<%f_resumen_convenio.Dibujatabla()%>
							   </td>
						  <%end if%>
                          
                           <%if v_dgso_ncorr <> "" then%>                       
                             <td align="right">P&aacute;gina:
                                 <%cursos_otic.accesopagina%>
                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
									<%cursos_otic.Dibujatabla()%>
							   </td>
						  <%end if%>
                        </tr>
                      </table>
                      
                  </tr>
                </table>
                          <br>
            </form>
        </table>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="20%" height="20"><div align="center">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir_alu")%></div></td>
				</tr>
              </table>
            </div></td>
            <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	 <%end if%><br>
	 <%buscar=""%>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>