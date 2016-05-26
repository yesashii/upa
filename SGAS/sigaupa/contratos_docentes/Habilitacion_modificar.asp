<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


set pagina = new CPagina

if cole_ccod <> "" then
   pagina.Titulo = "Modificar Habilitacion"
else
   pagina.Titulo = "Agregar Habilitacion"
end if


carr_ccod = request.querystring("carr_ccod")
pers_ncorr = request.querystring("pers_ncorr")
sede_ccod = request.querystring("sede_ccod")
JORN_ccod = request.querystring("JORN_ccod")

'response.write("pers_ncorr "&pers_ncorr)
'for each x in request.form
'	response.write("<br>"&x&"->"&request.form(x))
'next
'response.end()

anio=year(now)
anio_anterior=anio-2 ' se agrega (-2) en reemplazo de (-1) para llamar las categorias del 2013 durnte la primera semana de 2014

'response.Write(anio_anterior)

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Habilitacion_docentes.xml", "botonera"
'----------------------------------------------------------------
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE cast(carr_ccod as varchar)= '" & carr_ccod & "'")
Nombres = conexion.consultauno("SELECT isnull(PERS_TNOMBRE,'') + ' ' + isnull(PERS_TAPE_PATERNO,'') + ' ' + isnull(PERS_TAPE_MATERNO,'') FROM personas WHERE cast(pers_ncorr as varchar)= '" & pers_ncorr & "'")

jcod_ccod = conexion.consultauno("SELECT top 1 isnull(jdoc_ccod,0) FROM profesores WHERE cast(pers_ncorr as varchar)= '" & pers_ncorr & "' and sede_ccod="&sede_ccod& " ")

v_anio_ingreso = conexion.consultauno("SELECT top 1 isnull(prof_ingreso_uas,year(audi_fmodificacion)) FROM profesores WHERE cast(pers_ncorr as varchar)= '" & pers_ncorr & "' and sede_ccod="&sede_ccod& " ")

peri_ccod= negocio.obtenerPeriodoAcademico("planificacion")
'response.Write(peri_ccod)

if jdoc_ccod=0 then
	session("mensaje_error")="no existe una jerarquizacion para este docente"
%>
<script language="JavaScript">
CerrarActualizar();
</script>
<% 
end if
'----------------------------------------------------------------
set f_nueva = new CFormulario
f_nueva.Carga_Parametros "Habilitacion_docentes.xml", "f_nuevoM"
f_nueva.Inicializar conexion

   consulta ="select B.pers_ncorr, B.carr_ccod, B.OBSERVACIONES1, B.OBSERVACIONES2, B.TCAT_CCOD,B.TCAT_CCOD_1,B.TCAT_CCOD_2,B.TCAT_CCOD_3, "&jcod_ccod&" as jdoc_ccod " & vbCrlf & _
   				" ,(select top 1 F.GRAC_TDESC  from GRADOS_PROFESOR D, GRADOS_ACADEMICOS F where D.PERS_NCORR = B.pers_ncorr and F.GRAC_CCOD = D.GRAC_CCOD order by D.GRAC_CCOD desc) as Grado_Acad" & vbCrlf & _
				"from CARRERAS_DOCENTE B" & vbCrlf & _
				"where cast(B.pers_ncorr as varchar) ='" & pers_ncorr & "' " & vbCrlf & _
				"and cast(B.carr_ccod as varchar) ='" & carr_ccod  & "'" & vbCrlf & _
				" and peri_ccod='"&peri_ccod&"'"
				
 ' response.Write("<pre>"&consulta&"</pre>")
   f_nueva.Consultar consulta
'end if
'response.Write("Año ingreso :"&v_anio_ingreso)
'response.End()
if v_anio_ingreso<="2006" then
	f_nueva.Agregacampoparam "TCAT_CCOD", 	"destino" , "(select TCAT_CCOD, TCAT_TDESC + ' (' + CAST(TCAT_VALOR AS VARCHAR) + ')-->' + CAST(ANOS_CCOD AS VARCHAR) AS TCAT_TDESC from TIPOS_CATEGORIA where anos_ccod >="&anio_anterior&" ) A"
	f_nueva.Agregacampoparam "TCAT_CCOD_1", "destino" , "(select TCAT_CCOD, TCAT_TDESC + ' (' + CAST(TCAT_VALOR AS VARCHAR) + ')-->' + CAST(ANOS_CCOD AS VARCHAR) AS TCAT_TDESC from TIPOS_CATEGORIA where anos_ccod >="&anio_anterior&") B"
	f_nueva.Agregacampoparam "TCAT_CCOD_2", "destino" , "(select TCAT_CCOD, TCAT_TDESC + ' (' + CAST(TCAT_VALOR AS VARCHAR) + ')-->' + CAST(ANOS_CCOD AS VARCHAR) AS TCAT_TDESC from TIPOS_CATEGORIA where anos_ccod >="&anio_anterior&") C"
	f_nueva.Agregacampoparam "TCAT_CCOD_3", "destino" , "(select TCAT_CCOD, TCAT_TDESC + ' (' + CAST(TCAT_VALOR AS VARCHAR) + ')-->' + CAST(ANOS_CCOD AS VARCHAR) AS TCAT_TDESC from TIPOS_CATEGORIA where anos_ccod >="&anio_anterior&") D"
else
	f_nueva.Agregacampoparam "TCAT_CCOD", 	"destino" , "(select TCAT_CCOD, TCAT_TDESC + ' (' + CAST(TCAT_VALOR AS VARCHAR) + ')-->' + CAST(ANOS_CCOD AS VARCHAR) AS TCAT_TDESC from TIPOS_CATEGORIA where jdoc_ccod="&jcod_ccod&" and anos_ccod >"&anio_anterior&" ) A"
	f_nueva.Agregacampoparam "TCAT_CCOD_1", "destino" , "(select TCAT_CCOD, TCAT_TDESC + ' (' + CAST(TCAT_VALOR AS VARCHAR) + ')-->' + CAST(ANOS_CCOD AS VARCHAR) AS TCAT_TDESC from TIPOS_CATEGORIA where jdoc_ccod="&jcod_ccod&" and anos_ccod >"&anio_anterior&" ) B"
	f_nueva.Agregacampoparam "TCAT_CCOD_2", "destino" , "(select TCAT_CCOD, TCAT_TDESC + ' (' + CAST(TCAT_VALOR AS VARCHAR) + ')-->' + CAST(ANOS_CCOD AS VARCHAR) AS TCAT_TDESC from TIPOS_CATEGORIA where jdoc_ccod="&jcod_ccod&" and anos_ccod >"&anio_anterior&" ) C"
	f_nueva.Agregacampoparam "TCAT_CCOD_3", "destino" , "(select TCAT_CCOD, TCAT_TDESC + ' (' + CAST(TCAT_VALOR AS VARCHAR) + ')-->' + CAST(ANOS_CCOD AS VARCHAR) AS TCAT_TDESC from TIPOS_CATEGORIA where jdoc_ccod="&jcod_ccod&" and anos_ccod >"&anio_anterior&" ) D"

end if
f_nueva.Siguiente
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

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
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
                <td><%pagina.DibujarLenguetas Array("Agregar Especialidad"), 1 %>
</td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <br><BR>
                  </div>
				   
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td><table width="100%" border="0">
                      <tr>
                        <td><table width="99%" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Carrera</font></b></font></td>
    <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=Carrera%>
   </font></b></font></td>
  </tr>
  <tr> 
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Nombre</font></b></font></td>
    <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=Nombres%></font></b></font></td>
  </tr>
  <tr> 
    <td height="0" colspan="3"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
  </tr>
</table></td>
                      </tr>
                    </table>
                          <table width="100%" border="0">
                            <tr>
                              <td width="2%"><font color="#CC3300">*</font></td> 
                              <td width="44%">Campos Obligatorios</td>
                              <td width="3%"><div align="center"></div></td>
                              <td width="51%" colspan="3">&nbsp; </td>
                            </tr>
                            <tr>
                              <td>&nbsp;</td> 
                              <td> Observacion 1</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><% f_nueva.DibujaCampo "OBSERVACIONES1"%> 
                            </tr>
                            <tr>
                              <td>&nbsp;</td> 
                              <td> Observacion 2</td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"><% f_nueva.DibujaCampo "OBSERVACIONES2"%> 
                            </tr>
														
							<tr>
							  <td><font color="#CC3300">*</font></td> 
                              <td> Tipo Categoría</td>
                              <td><div align="center">:</div></td>
                              <td><div ><% f_nueva.DibujaCampo "TCAT_CCOD"%> 
                              </div></td>
							</tr>
							
							<%grado_Acad = f_nueva.ObtenerValor("Grado_Acad")
							if grado_Acad <> ""  and not EsVacio(grado_acad) then%>
							<tr>
							  <td>&nbsp;</td> 
                              <td>Grado Acad&eacute;mico</td>
                              <td><div align="center">:</div></td>
                              <td><div ><% f_nueva.DibujaCampo "Grado_Acad"%> 
                              </div></td>
							</tr>
							<%end if%>
							<tr>
							  <td>&nbsp;</td>
							  <td>Jerarquia</td>
							  <td>:</td>
							  <td><strong>
						        <%f_nueva.DibujaCampo "jdoc_ccod"%>
							    </strong></td>
							</tr>
							<tr>
							  <td>&nbsp;</td> 
                              <td> Tipo Categoría Ayudantia </td>
                              <td><div align="center">:</div></td>
                              <td><div ><% f_nueva.DibujaCampo "TCAT_CCOD_1"%> 
                              </div></td>
							</tr>
							<tr>
							  <td>&nbsp;</td> 
                              <td> Tipo Categoría Laboratorio </td>
                              <td><div align="center">:</div></td>
                              <td><div ><% f_nueva.DibujaCampo "TCAT_CCOD_2"%> 
                              </div></td>
							</tr>
							<tr>
							  <td>&nbsp;</td> 
                              <td> Tipo Categoría Terreno</td>
                              <td><div align="center">:</div></td>
                              <td><div ><% f_nueva.DibujaCampo "TCAT_CCOD_3"%> 
                              </div></td>
							</tr>																					
                          </table>
                          <br></td>
                      </tr>
                    </table>
                    <br>
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
							  if carr_ccod <> "" then
							     botonera.agregaBotonParam "guardar_nueva", "url", "Proc_Habilitacion_modificar.asp?carr_ccod=" & carr_ccod & "&tcat_ccod=" & tcat_ccod & "&cole_tdesc=" & cole_tdesc& "&pers_ncorr=" & pers_ncorr & "&SEDE_CCOD=" & SEDE_CCOD & "&JORN_CCOD=" & JORN_CCOD 
							  else
  							     botonera.agregaBotonParam "guardar_nueva", "url", "Proc_Habilitacion_modificar.asp"
							  end if
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
