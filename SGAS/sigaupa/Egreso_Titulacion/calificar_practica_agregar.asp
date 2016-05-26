<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

secc_ccod = request.querystring("secc_ccod")
matr_ncorr = request.querystring("matr_ncorr")
mall_ccod = request.querystring("mall_ccod")




'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "calificar_practica.xml", "botonera"
'----------------------------------------------------------------

asig_tdesc = conexion.consultauno("SELECT asig_tdesc FROM malla_curricular a, asignaturas b WHERE cast(a.mall_ccod as varchar)= '" & mall_ccod & "' and a.asig_ccod = b.asig_ccod")


pagina.Titulo = "Calificar "&asig_tdesc

rut = conexion.consultauno("SELECT cast(b.pers_nrut as varchar)+ '-' +b.pers_xdv  FROM alumnos a, personas b WHERE cast(a.matr_ncorr as varchar)= '" & matr_ncorr & "' and a.pers_ncorr = b.pers_ncorr")
nombre = conexion.consultauno("SELECT b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno  FROM alumnos a, personas b WHERE cast(a.matr_ncorr as varchar)= '" & matr_ncorr & "' and a.pers_ncorr = b.pers_ncorr")
carrera = conexion.consultauno("SELECT carr_tdesc FROM secciones a, carreras b WHERE cast(a.secc_ccod as varchar)='"&secc_ccod&"' and a.carr_ccod = b.carr_ccod ")

'----------------------------------------------------------------
set f_nueva = new CFormulario
f_nueva.Carga_Parametros "calificar_practica.xml", "f_nueva"
f_nueva.Inicializar conexion

consulta = "select '"&matr_ncorr&"' as matr_ncorr,'"&secc_ccod&"' as secc_ccod,'"&mall_ccod&"' as mall_ccod,nombre_empresa,protic.trunc(fecha_inicio) as fecha_inicio,protic.trunc(fecha_termino) as fecha_termino ,nombre_supervisor,sitf_ccod,replace(carg_nnota_final,',','.') as carg_nnota_final,observacion from ANTECEDENTES_PRACTICAS where cast(matr_ncorr as varchar) ='" & matr_ncorr & "' and cast(secc_ccod as varchar) ='" & secc_ccod & "' and cast(mall_ccod as varchar) ='" & mall_ccod & "'"
f_nueva.Consultar consulta

if f_nueva.nroFilas = "0" then
	consulta = "select '"&matr_ncorr&"' as matr_ncorr,'"&secc_ccod&"' as secc_ccod,'"&mall_ccod&"' as mall_ccod"
    f_nueva.Consultar consulta
end if
f_nueva.Siguiente

'response.Write(consulta)
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
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "p[0][fecha_inicio]","1","edicion","fecha_oculta_fecha_inicio"
	calendario.MuestraFecha "p[0][fecha_termino]","2","edicion","fecha_oculta_fecha_termino"
	calendario.FinFuncion
	
%>


</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="500" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr> 
          <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><%pagina.DibujarLenguetas Array("Cálificar asignatura"), 1 %></td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <br>
                  </div>
				   <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
					      <input type="hidden" name="p[0][matr_ncorr]" value="<%=matr_ncorr%>">
						  <input type="hidden" name="p[0][secc_ccod]" value="<%=secc_ccod%>">
						  <input type="hidden" name="p[0][mall_ccod]" value="<%=mall_ccod%>">
                        <td>
						    <table width="100%" border="0">
                            <tr> 
                              <td width="21%"><strong>RUT</strong></td>
                              <td width="5%"><strong>:</strong></td>
                              <td colspan="3"><%=rut%></td>
                            </tr>
							<tr> 
                              <td width="21%"><strong>Nombre</strong></td>
                              <td width="5%"><strong>:</strong></td>
                              <td colspan="3"><%=nombre%></td>
                            </tr>
							<tr> 
                              <td width="21%"><strong>Carrera</strong></td>
                              <td width="5%"><strong>:</strong></td>
                              <td colspan="3"><%=carrera%></td>
                            </tr>
                            <tr> 
                              <td><strong>Lugar Práctica</strong></td>
                              <td><strong>:</strong></td>
                              <td colspan="3"><% f_nueva.DibujaCampo "nombre_empresa"%></td>
                            </tr>
                            <tr> 
                              <td><strong>Fecha Inicio</strong></td>
                              <td><strong>:</strong></td>
                              <td colspan="3">
                                <% f_nueva.DibujaCampo "fecha_inicio" %>
                                <%calendario.DibujaImagen "fecha_oculta_fecha_inicio","1","edicion" %>
                                (dd/mm/aaaa) </td>
                            </tr>
							<tr> 
                              <td><strong>Fecha Término</strong></td>
                              <td><strong>:</strong></td>
                              <td colspan="3">
                                <% f_nueva.DibujaCampo "fecha_termino" %>
                                <%calendario.DibujaImagen "fecha_oculta_fecha_termino","2","edicion" %>
                                (dd/mm/aaaa) </td>
                            </tr>
							<tr> 
                              <td><strong>Nombre Supervisor</strong></td>
                              <td><strong>:</strong></td>
                              <td colspan="3"><% f_nueva.DibujaCampo "nombre_supervisor"%></td>
                            </tr>
							<tr> 
                              <td><strong>Concepto</strong></td>
                              <td><strong>:</strong></td>
                              <td colspan="3"><% f_nueva.DibujaCampo "sitf_ccod"%></td>
                            </tr>
							<tr> 
                              <td><strong>Nota</strong></td>
                              <td><strong>:</strong></td>
                              <td colspan="3"><% f_nueva.DibujaCampo "carg_nnota_final"%></td>
                            </tr>
							<tr> 
                              <td><strong>Observación</strong></td>
                              <td><strong>:</strong></td>
                              <td colspan="3"><% f_nueva.DibujaCampo "observacion"%></td>
                            </tr>
                          </table>
                         </td>
                      </tr>
                    </table>
                    
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="47%"><div align="center">
                            <%
							botonera.agregaBotonParam "guardar_nueva", "url", "proc_calificar_practica_agregar.asp"
							botonera.dibujaBoton "guardar_nueva" %>
                          </div></td>
                        <td width="53%"><div align="center">
                            <%botonera.dibujaBoton "cancelar" %>
                          </div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> </td>
  </tr>
</table>
</body>
</html>
