<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Mantenedor de Colegios"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "m_colegios.xml", "botonera"
'-------------------------------------------------------------------------------
 regi_ccod   =   request.QueryString("busqueda[0][carr_ccod]")
 ciud_tcomuna	=	request.querystring("busqueda[0][asig_ccod]")
 ciud_ccod	=	request.querystring("busqueda[0][jorn_ccod]")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "m_colegios.xml", "busqueda"
 f_busqueda.Inicializar conexion

 consulta="Select '"&regi_ccod&"' as regi_ccod, '"&ciud_tcomuna&"' as ciud_tcomuna, '"&ciud_ccod"' as ciud_ccod"
 f_busqueda.consultar consulta

 consulta = " select a.regi_tdesc,a.regi_ccod,b.ciud_ccod,b.ciud_tcomuna, b.ciud_tdesc " & vbCrLf & _
			" from regiones a, ciudades b " & vbCrLf & _
			" where a.regi_ccod=b.regi_ccod " & vbCrLf & _
			" order by a.regi_ccod,ciud_tcomuna,ciud_tdesc " 

'response.Write("<pre>"&consulta&"</pre>")	
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta

 f_busqueda.Siguiente
 
 'f_busqueda.AgregaCampoCons "nombre_asig", nombre
 'f_busqueda.AgregaCampoCons "codigo_asig", codigo

'----------------------------------------------------------------------------------
set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "asignaturas_sedes.xml", "f_asignaturas"
f_asignaturas.Inicializar conexion

set f_copia = new CFormulario
f_copia.Carga_Parametros "asignaturas_sedes.xml", "f_asignaturas"
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
   
 consulta = "SELECT  a.ASIG_CCOD, a.ASIG_TDESC , secc_tdesc ,b.secc_ccod,c.carr_tdesc  "& vbCrLf &_
		   "FROM asignaturas a, secciones b,carreras c  "& vbCrLf &_
		   "WHERE a.asig_ccod=b.asig_ccod and b.carr_ccod=c.carr_ccod"& vbCrLf &_
		   "  and cast(b.sede_ccod as varchar) = '" & Sede & "'"& vbCrLf &_
		   "  and cast(b.peri_ccod as varchar)='" & Periodo & "'"& vbCrLf &_
		   "  and cast(b.jorn_ccod as varchar)='" & jorn_ccod & "'"& vbCrLf &_
		   "  and cast(b.carr_ccod as varchar)='" & carr_ccod & "'"& vbCrLf &_
		   "  and (cast(a.asig_ccod as varchar) = '" & codigo & "' or '" & codigo & "' is null )"& vbCrLf &_
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
		sql  =    " select count(a.matr_ncorr) from cargas_academicas a , alumnos b "& _
				   " where a.matr_ncorr=b.matr_ncorr "&_
				   " and b.emat_ccod in (1,2) "& _
				   " and cast(a.secc_ccod as varchar)='" & seccion & "'"& _
				   " and a.carg_nsence is  null "& _
				   " and a.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where cast(secc_ccod_destino as varchar)='" & seccion & "') "& _
				   " and a.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=a.matr_ncorr and cast(asig_ccod as varchar)='" & asignatura & "') " 
	    cant_alumnos = conexion.consultaUno(sql)
		f_asignaturas.agregacampofilacons fila, "cant_alumnos", cant_alumnos
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
			formulario.action ="asignaturas_sede.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
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
                                <td width="5%"> <div align="left">Carrera &nbsp; </div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Asignatura &nbsp; </div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Jornada &nbsp; </div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left"></div></td>
								<td width="1%"> <div align="center"></div> </td>
								<td><div id="texto_alerta" style="position:absolute; visibility: hidden; left: 401px; top: 217px; width:418px; height: 16px;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
                              </tr>
                            </table></td>
                        <td width="19%"><div align="center"><%botonera.dibujaboton "buscar"%></div></td>
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
                    <table width="100%" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_asignaturas.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Asignaturas impartidas en la sede " & sede_tdesc%>
                      <br>
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
