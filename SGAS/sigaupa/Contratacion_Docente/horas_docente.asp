<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Mantenedor de horas por docente"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

Periodo = negocio.ObtenerPeriodoAcademico("PLANIFICACION")
peri = negocio.ObtenerPeriodoAcademico("CLASES18")
Sede = negocio.ObtenerSede()

peri_tdesc = conexion.consultaUno("select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

'-------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "horas_docente.xml", "botonera"
'-------------------------------------------------------------------------------
 carr_ccod   =   request.QueryString("busqueda[0][carr_ccod]")
 asig_ccod	=	request.querystring("busqueda[0][asig_ccod]")
 jorn_ccod	=	request.querystring("busqueda[0][jorn_ccod]")
 codigo = asig_ccod
 sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&Sede&"'")
 carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar) ='"&carr_ccod&"'")
 asig_tdesc = conexion.consultaUno("select asig_ccod + ' --> ' + asig_tdesc from asignaturas where cast(asig_ccod as varchar) ='"&asig_ccod&"'")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "horas_docente.xml", "busqueda"
 f_busqueda.Inicializar conexion
 'peri = negocio.obtenerPeriodoAcademico ( "planificacion" ) 
 sede = negocio.obtenerSede
 
 consulta="Select '"&carr_ccod&"' as carr_ccod, '"&asig_ccod&"' as asig_ccod, '"&jorn_ccod&"' as jorn_ccod"
 f_busqueda.consultar consulta

' consulta = "select distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod, a.carr_tdesc,ltrim(rtrim(d.asig_ccod))as asig_ccod,d.asig_tdesc+' - '+cast(d.asig_ccod as varchar) as asig_tdesc,e.jorn_ccod,e.jorn_tdesc " & vbCrLf & _
'		   " from carreras a,secciones b, asignaturas d,jornadas e--, bloques_horarios c " & vbCrLf & _
'		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
'		   " --and  b.secc_ccod=c.secc_ccod " & vbCrLf & _
'		   " and b.asig_ccod=d.asig_ccod " & vbCrLf & _
'		   " and b.jorn_ccod=e.jorn_ccod " & vbCrLf &_
'		   " and cast(b.sede_ccod as varchar)='"&sede&"' " & vbCrLf & _
'		   " and b.secc_tdesc <>'Poblamiento' " & vbCrLf & _
'		   " and cast(b.peri_ccod as varchar)= case d.duas_ccod when 3 then '"&peri&"' else '"&periodo&"' end order by a.carr_tdesc,d.asig_tdesc,d.asig_ccod asc" 
'---------------------------------------------------------------------------ACTUALIZACIÓN 17/04/2013 LUIS HERRERA
consulta = ""
consulta = consulta & "select distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod, " & vbCrLf
consulta = consulta & "                a.carr_tdesc, " & vbCrLf
consulta = consulta & "                ltrim(rtrim(d.asig_ccod))                  as asig_ccod, " & vbCrLf
consulta = consulta & "                d.asig_tdesc + ' - ' " & vbCrLf
consulta = consulta & "                + cast(d.asig_ccod as varchar)             as asig_tdesc, " & vbCrLf
consulta = consulta & "                e.jorn_ccod, " & vbCrLf
consulta = consulta & "                e.jorn_tdesc " & vbCrLf
consulta = consulta & "from   carreras a, " & vbCrLf
consulta = consulta & "       secciones b, " & vbCrLf
consulta = consulta & "       asignaturas d, " & vbCrLf
consulta = consulta & "       jornadas e " & vbCrLf
consulta = consulta & "--, bloques_horarios c   " & vbCrLf
consulta = consulta & "where  a.carr_ccod = b.carr_ccod " & vbCrLf
consulta = consulta & "       --and  b.secc_ccod=c.secc_ccod   " & vbCrLf
consulta = consulta & "       and b.asig_ccod = d.asig_ccod " & vbCrLf
consulta = consulta & "       and b.jorn_ccod = e.jorn_ccod " & vbCrLf
consulta = consulta & "       and cast(b.sede_ccod as varchar) = '"&sede&"' " & vbCrLf
consulta = consulta & "       and b.secc_tdesc <> 'Poblamiento' " & vbCrLf
consulta = consulta & "       and cast(b.peri_ccod as varchar) = case d.duas_ccod " & vbCrLf
consulta = consulta & "                                            when 3 then '"&peri&"' " & vbCrLf
consulta = consulta & "                                            else '"&periodo&"' " & vbCrLf
consulta = consulta & "                                          end " & vbCrLf
consulta = consulta & "order  by a.carr_tdesc, " & vbCrLf
consulta = consulta & "          asig_tdesc, " & vbCrLf
consulta = consulta & "          asig_ccod asc "
'---------------------------------------------------------------------------ACTUALIZACIÓN 17/04/2013 LUIS HERRERA		   
'response.Write("<pre>"&consulta&"</pre>")	
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta

 f_busqueda.Siguiente
 
 'f_busqueda.AgregaCampoCons "nombre_asig", nombre
 'f_busqueda.AgregaCampoCons "codigo_asig", codigo

'----------------------------------------------------------------------------------
set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "horas_docente.xml", "f_asignaturas"
f_asignaturas.Inicializar conexion

set f_copia = new CFormulario
f_copia.Carga_Parametros "horas_docente.xml", "f_asignaturas"
f_copia.Inicializar conexion

 if asig_ccod = "" and carr_ccod= "" then
    codigo = "  "
	f_asignaturas.consultar "select '' "
	f_asignaturas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
 end if
 
 ' consulta = "SELECT  a.ASIG_CCOD, a.ASIG_TDESC , secc_tdesc ,b.secc_ccod  "& vbCrLf &_
 '		   "FROM asignaturas a, secciones b  "& vbCrLf &_
 '		   "WHERE a.asig_ccod=b.asig_ccod "& vbCrLf &_
 '		   "  and cast(b.sede_ccod as varchar) = '" & Sede & "'"& vbCrLf &_
 '		   "  and cast(b.peri_ccod as varchar)='" & Periodo & "'"& vbCrLf &_
 '		   "  and (cast(a.asig_ccod as varchar) = '" & codigo & "' or '" & codigo & "' is null )"& vbCrLf &_
 '		   "  and b.secc_finicio_sec is not null "& vbCrLf &_
 ' 		   "  and b.secc_ftermino_sec is not null "& vbCrLf &_
 '		   "ORDER BY a.asig_tdesc, b.secc_tdesc"& vbCrLf
   
 consulta = "SELECT  a.ASIG_CCOD, a.ASIG_TDESC , secc_tdesc ,b.secc_ccod, a.asig_nhoras  "& vbCrLf &_
		   "FROM asignaturas a, secciones b,carreras c  "& vbCrLf &_
		   "WHERE a.asig_ccod=b.asig_ccod and b.carr_ccod=c.carr_ccod"& vbCrLf &_
		   "  and cast(b.sede_ccod as varchar) = '" & Sede & "'"& vbCrLf &_
		   "  and cast(b.peri_ccod as varchar)= case a.duas_ccod when 3 then '"&peri&"' else '" & Periodo & "' end"& vbCrLf &_
		   "  and cast(b.jorn_ccod as varchar)='" & jorn_ccod & "'"& vbCrLf &_
		   "  and cast(b.carr_ccod as varchar)='" & carr_ccod & "'"& vbCrLf &_
		   "  and cast(a.asig_ccod as varchar) = '" & codigo & "' "& vbCrLf &_
		   "  and b.secc_finicio_sec is not null "& vbCrLf &_
  		   "  and b.secc_ftermino_sec is not null "& vbCrLf &_
		   "ORDER BY a.asig_tdesc, b.secc_tdesc"& vbCrLf		   
'response.Write("<pre>"&consulta&"</pre>")			   
'response.End()
  if Request.QueryString <> "" then
      f_asignaturas.consultar consulta
	  f_copia.consultar consulta
	  fila = 0
	  while f_copia.Siguiente
	    seccion = trim(f_copia.obtenerValor ("secc_ccod"))
		asignatura = trim(f_copia.obtenerValor ("asig_ccod"))
		sql  =    " select count(distinct b.pers_ncorr) from bloques_horarios a , bloques_profesores b "& _
				   " where a.bloq_ccod = b.bloq_ccod "&_
				   " and b.tpro_ccod=1 "& _
				   " and cast(a.secc_ccod as varchar)='" & seccion & "'"
				   
		cant_docentes = conexion.consultaUno(sql)
		f_asignaturas.agregacampofilacons fila, "cant_docentes", cant_docentes
		fila = fila + 1 
		'response.Write(seccion & " - "  & asignatura & " -  " & cant_alumnos & "<BR>")
	  wend	  
  else
	f_asignaturas.consultar "select '' "
	f_asignaturas.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
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
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="horas_docente.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
}
</script>
<% f_busqueda.generaJS %>
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
              <table width="98%"  border="0">
                      <tr>
                        <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="10%"> <div align="left">Carrera </div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="10%"> <div align="left">Asignatura</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td colspan="2"><% f_busqueda.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="10%"> <div align="left">Jornada</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td width="74%"><% f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
                                <td width="15%"><div align="center"><%botonera.dibujaboton "buscar"%></div></td>
							  </tr>
							  <tr> 
                                <td width="10%"> <div align="left"></div></td>
								<td width="1%"> <div align="center"></div> </td>
								<td><div id="texto_alerta" style="position:absolute; visibility: hidden; left: 401px; top: 217px; width:418px; height: 16px;"><font color="#0000FF" size="-1">Espere 
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
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
			      <%if not esVacio(carr_ccod) and not esVacio(asig_ccod) then%>
                    <table width="100%" border="0">
                      <tr><td colspan="3">&nbsp;</td></tr>
					  <tr> 
                        <td width="10%"><strong>Sede</strong></td>
                        <td width="1%"><strong>:</strong></td>
                        <td><%=sede_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="10%"><strong>Carreras</strong></td>
                        <td width="1%"><strong>:</strong></td>
                        <td><%=carr_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="10%"><strong>Asignaturas</strong></td>
                        <td width="1%"><strong>:</strong></td>
                        <td><%=asig_tdesc%></td>
                      </tr>
					  <tr> 
                        <td width="10%"><strong>Periodo</strong></td>
                        <td width="1%"><strong>:</strong></td>
                        <td><%=peri_tdesc%></td>
                      </tr>
					</table>
					<%end if%>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr><td><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_asignaturas.AccesoPagina%>
                          </div></td>
				  </tr>
				  <br>
				  <tr>
                        <td> 
                          <%f_asignaturas.dibujaTabla()%>
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
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
