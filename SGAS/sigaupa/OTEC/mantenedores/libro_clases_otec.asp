<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
anio_admision = request.querystring("busqueda[0][anio_admision]")
dgso_ncorr = Request.QueryString("busqueda[0][dgso_ncorr]")

''-------------------------------------------------------------------
'for each k in request.querystring
'	response.write(k&"="&request.querystring(k)&"<br>")
'next
'response.End()
'-------------------------------------------------------------------
'response.Write("seot_ncorr "&seot_ncorr)

session("url_actual")="../mantenedores/libro_clases_otec.asp?busqueda[0][dcur_ncorr]="&dcur_ncorr&"&busqueda[0][dgso_ncorr]="&dgso_ncorr&"&busqueda[0][mote_ccod]="&mote_ccod&"&busqueda[0][seot_ncorr]="&seot_ncorr&"&busqueda[0][anio_admision]="&anio_admision
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Libros de Clases por curso"

set botonera =  new CFormulario
botonera.carga_parametros "libro_clases_otec.xml", "botonera"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
set errores 	= new cErrores
'response.Write(carr_ccod)


dcur_ncorr = conexion.consultaUno("select dcur_ncorr from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
dcur_nsence = conexion.consultaUno("select isnull(dcur_nsence,'-.') from diplomados_cursos where cast(dcur_ncorr as varchar)= '" & dcur_ncorr & "'")
if dcur_nsence = "" then
	dcur_nsence = "-."
end if
var_fecha = conexion.consultaUno("select protic.trunc(getdate())")
nombreSence = conexion.consultaUno("select dcur_nombre_sence from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
programa = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
'response.Write("nombreSence = "&dcur_ncorr)

'response.write("select dcur_ncorr from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
'----------------------------------------------------------------------- 
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "libro_clases_otec.xml", "busqueda"
f_busqueda.Inicializar conexion
 
consulta="" & vbCrLf & _
"Select '"&anio_admision&"' as anio_admision,'"&dgso_ncorr&"' as dgso_ncorr"
'response.Write(consulta)
f_busqueda.consultar consulta
'************************************************************************'
'*					CONSULTA QUE LLENA LOS COMBOS						*'
'************************************************************************'
consulta = "select distinct anio_admision,                        " & vbCrLf & _
"       a.dgso_ncorr,                                    " & vbCrLf & _
"       sede_tdesc + ' : ' + c.dcur_tdesc as dgso_tdesc  " & vbCrLf & _
"from   datos_generales_secciones_otec a,                " & vbCrLf & _
"       sedes b,                                         " & vbCrLf & _
"       diplomados_cursos c,                             " & vbCrLf & _
"       --secciones_otec d,                                " & vbCrLf & _
"       --mallas_otec e,                                   " & vbCrLf & _
"       --modulos_otec f,                                  " & vbCrLf & _
"       ofertas_otec tt                                  " & vbCrLf & _
"where  a.sede_ccod = b.sede_ccod                        " & vbCrLf & _
"       and a.dcur_ncorr = c.dcur_ncorr                  " & vbCrLf & _
"       --and esot_ccod in (1,2,3)                         " & vbCrLf & _
"       --and a.dgso_ncorr = d.dgso_ncorr                  " & vbCrLf & _
"       --and d.maot_ncorr = e.maot_ncorr                  " & vbCrLf & _
"       --and e.mote_ccod = f.mote_ccod                    " & vbCrLf & _
"       and a.dgso_ncorr = tt.dgso_ncorr                 " & vbCrLf & _
"       and exists (select 1 from postulacion_otec tt where tt.dgso_ncorr=a.dgso_ncorr and tt.epot_ccod=4 )" & vbCrLf & _
"order  by anio_admision desc, dgso_tdesc asc  "
'************************************************************************'
'response.write("<pre>"&consulta&"</pre>")
f_busqueda.inicializaListaDependiente "lBusqueda", consulta
f_busqueda.Siguiente 
'f_busqueda.Listar()

set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "libro_clases_otec.xml", "alumnos"
f_alumnos.Inicializar conexion
'************************************************************************'
'*				CONSULTA QUE LLENA LA TABLA DE ALUMNOS 					*'
'************************************************************************'
consulta = "" & vbCrLf & _
"select distinct cast(c.pers_nrut as varchar) + '-' + c.pers_xdv                         as rut,       " & vbCrLf & _
"                c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', ' + c.pers_tnombre as alumno,    " & vbCrLf & _
"                lower(c.pers_temail)                          							as pers_temail " & vbCrLf & _
"from   personas as c                                                                                  " & vbCrLf & _
"       inner join postulacion_otec as b                                                               " & vbCrLf & _
"               on c.pers_ncorr = b.pers_ncorr                                                         " & vbCrLf & _
"                  and epot_ccod = 4                                                                   " & vbCrLf & _
"       inner join datos_generales_secciones_otec as d                                                 " & vbCrLf & _
"               on b.dgso_ncorr = d.dgso_ncorr                                                         " & vbCrLf & _
"where  cast(d.dcur_ncorr as varchar) = '"&dcur_ncorr&"'                                               " & vbCrLf & _
"order  by alumno                                                                                      " 
'************************************************************************'
f_alumnos.Consultar consulta
nmrosDeFilas = f_alumnos.nroFilas 


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
var opcion = 1;
function nueva_ventana(opcion)
{	
	if(opcion == 1)
	{
		window.open("pdfLibroClasesOtecPortada.asp?dcur_ncorr=<%= dcur_ncorr %>","_blank"," width=750, height=570,scrollbars,  toolbar=false, resizable");
	}
	if(opcion == 2)
	{
		window.open("pdfAntecedentesParticipantes.asp?dcur_ncorr=<%= dcur_ncorr %>","_blank"," width=750, height=570,scrollbars,  toolbar=false, resizable");
	}
	if(opcion == 3)
	{
		window.open("pdfAsistencia.asp?dcur_ncorr=<%= dcur_ncorr %>","_blank"," width=750, height=570,scrollbars,  toolbar=false, resizable");
	}
	if(opcion == 4)
	{
		window.open("pdfEvaluaciones.asp?dcur_ncorr=<%= dcur_ncorr %>","_blank"," width=750, height=570,scrollbars,  toolbar=false, resizable");
	}
	if(opcion == 5)
	{
		window.open("pdfContenidos.asp","_blank"," width=750, height=570,scrollbars,  toolbar=false, resizable");
	}
	if(opcion == 6)
	{
		window.open("libro_de_clases_excel.asp?dcur_ncorr=<%= dcur_ncorr %>&programa=<%= programa %>&dcur_nsence=<%= dcur_nsence %>&var_fecha=<%= var_fecha %>","_blank"," width=750, height=570,scrollbars,  toolbar=false, resizable");
	}
}
function enviar(formulario){
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
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
	
	<table width="68%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
              <table width="98%"  border="0">
                      <tr>
                        <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5%"> <div align="left">Año</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "anio_admision"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Programa</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "dgso_ncorr"%></td>
                             </tr>
							 
							  
							  <tr>
							  	<td colspan="3" align="center"><%botonera.dibujaboton "buscar"%></td>
							  </tr>
							  <tr> 
                                <td width="5%"> <div align="left"></div></td>
								<td width="1%"> <div align="center"></div> </td>
								<td><div id="texto_alerta" style="position:absolute; visibility: hidden; width:418px; height: 16px;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
                              </tr>
							</table></td>
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
            <td><%pagina.DibujarLenguetas Array("Ingreso de calificaciones"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
				  	<td align="center">
						<form name="edicion">
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
						  <tr><input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>">
						      <input type="hidden" name="b[0][pers_xdv]" value="<%=q_pers_xdv%>">
							  <input type="hidden" name="dgso_ncorr" value="<%=dgso_ncorr%>">
							<td>
							  <br> 
							  <%if dcur_ncorr <> "" then %>                 
							  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
							  <tr>
								<td align="right">Pagina <%f_alumnos.accesoPagina%></td>
							  </tr>
							  <tr>
								<td align="Left"><font size="2" >Programa	: <% response.Write(programa) %>.-<hr/></font></td>
							  </tr>
							  <tr>							  
							  <%if nombreSence <> "" then%>
								<td align="Left"><font size="2" >Sence: <% response.Write(nombreSence) %>.-<hr/></font></td>	
							  <%end if%>		
							  </tr>								  
							  <td align="Left"><font size="2" color="#0033FF">Listado de Alumnos del curso.-</font></td>	
							  <tr>
								<td align="center"><%f_alumnos.dibujatabla()%></td>
							  </tr>
							  </table>
							  <%end if%> 
							  
							</td>
						  </tr>
						</table>
                          <br>
     					</form>
					</td>
				  </tr>
				  <tr>
                    <td><table width="200" border="0">
                      <tr>
                        <td>
							<%							
								if nmrosDeFilas > 0 then
									botonera.agregaBotonParam "portada", "deshabilitado", "FALSE"
								else
									botonera.agregaBotonParam "portada", "deshabilitado", "TRUE"
								end if
								botonera.dibujaboton "portada"
							%>
						</td>						
                        <td><%
								if nmrosDeFilas > 0 then
									botonera.agregaBotonParam "antecedentes", "deshabilitado", "FALSE"
								else
									botonera.agregaBotonParam "antecedentes", "deshabilitado", "TRUE"
								end if
								botonera.dibujaboton "antecedentes"
							%>
						</td>
                        <td><%
								if nmrosDeFilas > 0 then
									botonera.agregaBotonParam "asistencia", "deshabilitado", "FALSE"
								else
									botonera.agregaBotonParam "asistencia", "deshabilitado", "TRUE"
								end if
								botonera.dibujaboton "asistencia"
							%>
						</td>
                        <td><%
								if nmrosDeFilas > 0 then
									botonera.agregaBotonParam "evaluaciones", "deshabilitado", "FALSE"
								else
									botonera.agregaBotonParam "evaluaciones", "deshabilitado", "TRUE"
								end if
								botonera.dibujaboton "evaluaciones"
							%>
						</td>
                        <td><%
								if nmrosDeFilas > 0 then
									botonera.agregaBotonParam "contenidos", "deshabilitado", "FALSE"
								else
									botonera.agregaBotonParam "contenidos", "deshabilitado", "TRUE"
								end if
								botonera.dibujaboton "contenidos"
							%>
						</td>
                        <td><%
								if nmrosDeFilas > 0 then
									botonera.agregaBotonParam "generaExcel", "deshabilitado", "FALSE"
								else
									botonera.agregaBotonParam "generaExcel", "deshabilitado", "TRUE"
								end if
								botonera.dibujaboton "generaExcel"
							%>
						</td>
                      </tr>
                    </table></td>
                  </tr>
                </table>
              <br>
            </td></tr>
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
