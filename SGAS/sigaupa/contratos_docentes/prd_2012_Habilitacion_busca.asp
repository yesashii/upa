<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Habilitar Docentes"
'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Habilitacion_docentes.xml", "botonera"

'-----------------------------------------------------------------------
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
parametro = carr_ccod
'response.Write("Carrera:"&carr_ccod)
dim Jornada2
IF LEN(carr_ccod) = 3 THEN 
	Jornada2=RIGHT(carr_ccod,1)
	carr_ccod= MID(carr_ccod,1,LEN(carr_ccod)-2)
elseIF LEN(carr_ccod) = 4 THEN 
	Jornada2=RIGHT(carr_ccod,1)
	'response.Write("<br>Jornada:"&Jornada2)
	carr_ccod= MID(carr_ccod,1,LEN(carr_ccod)-1)
	'response.Write("<br>Carrera final:"&carr_ccod)	
END IF
'carr_ccod = request.QueryString("carr_ccod")

carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")

'buscamos el periodo que deseamos ocupar para hacer la habilitación docente para esto recurrimos a planificación
'--------------------------------------agregado por MSandoval------------------------------------------
peri_ccod= negocio.obtenerPeriodoAcademico("PLANIFICACION")
peri_tdesc = conexion.consultaUno("Select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")


'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Habilitacion_docentes.xml", "f_busqueda"
 
 sede_ccod = negocio.obtenersede
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 
 consulta_select= "( SELECT DISTINCT cast(A.CARR_CCOD as varchar) + cast(b.jorn_ccod as varchar) as carr_ccod, " &vbCrlf &_ 
					" A.CARR_TDESC + ' '  + case b.JORN_CCOD WHEN 1 THEN '(D)' ELSE '(V)' END AS CARR_TDESC    " &vbCrlf &_
					" FROM CARRERAS A, secciones B   " &vbCrlf &_
					" WHERE  A.CARR_CCOD = B.CARR_CCOD " &vbCrlf &_   
					" AND CAST(b.PERI_CCOD AS VARCHAR)='"&peri_ccod&"'  " &vbCrlf &_ 
					" AND cast(b.SEDE_CCOD as varchar)= '"& sede_ccod &"' 	" &vbCrlf &_
					" )h"				
					
 f_busqueda.AgregaCampoParam "carr_ccod","destino",consulta_select				  
 f_busqueda.Siguiente
 f_busqueda.AgregaCampoCons "carr_ccod", cstr(parametro)  
 'ultimo = carr_ccod

'---------------------------------------------------------------------------------------------------

'response.Write("<pre>"&consulta_select&"</pre>")

set formulario = new cformulario

formulario.carga_parametros "Habilitacion_docentes.xml", "filtro_docentes"
formulario.inicializar conexion 'conectar

consulta= " select " &vbCrlf &_
		  " a.pers_ncorr, cast(a.pers_nrut as varchar)+ '-' + cast(a.pers_xdv as varchar)  as rut, " &vbCrlf &_
		  " cast(a.pers_tape_paterno as varchar) + ' ' +  cast(a.PERS_TAPE_MATERNO as varchar)+ ' ' + cast(a.pers_tnombre as varchar) as nom, " &vbCrlf &_
		  " B.CARR_CCOD, c.TCAT_TDESC, C.TCAT_VALOR, b.OBSERVACIONES1, b.OBSERVACIONES2, " &vbCrlf &_
		  " -- (select top 1 F.GRAC_TDESC  from GRADOS_PROFESOR D, GRADOS_ACADEMICOS F where D.PERS_NCORR = B.pers_ncorr and F.GRAC_CCOD = D.GRAC_CCOD order by F.GRAC_NORDEN asc) as Grado_Acad, " &vbCrlf &_		    
		  " protic.obtener_grado_docente(a.pers_ncorr,'G') as Grado_Acad ,"&vbCrlf &_		  
		  " b.SEDE_CCOD, " &vbCrlf &_	
		  " b.JORN_CCOD, (select top 1 isnull(jdoc_ccod,0) from profesores where pers_ncorr=a.pers_ncorr) as jdoc_ccod " &vbCrlf &_			  
 		  " from " &vbCrlf &_
 		  " personas a , CARRERAS_DOCENTE b, TIPOS_CATEGORIA c,periodos_academicos d " &vbCrlf &_
 		  " where " &vbCrlf &_
 		  " a.pers_ncorr=b.pers_ncorr " &vbCrlf &_
 		  " AND C.TCAT_CCOD=*b.TCAT_CCOD " &vbCrlf &_		  
		  " and b.peri_ccod = d.peri_ccod and cast(d.anos_ccod as varchar)='"&anos_ccod&"'" &vbCrlf &_
		  " AND CAST(B.CARR_CCOD AS VARCHAR)='" & carr_ccod & "'" &vbCrlf &_
		  " AND CAST(B.JORN_CCOD AS VARCHAR)='" & Jornada2 & "'" &vbCrlf &_		
   		  " AND cast(B.sede_ccod as varchar) ='" & sede_ccod &"'"&vbCrlf &_	
		  " AND b.peri_ccod =" & peri_ccod &" "&vbCrlf &_	
		" Order by a.pers_tape_paterno,a.pers_tape_materno"
	   
'response.Write("<pre>"& consulta & "</pre>")
'response.End()
formulario.consultar consulta

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

function ChekeaCHek(){
for (i = 0; i < tabla.filas.length; i++) 
     {  	    
	   valor = document.edicion.elements["_cajas[" + i + "][Solicitar]"].checked;
	   if (valor == true)	 
	     contador++;
    }
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
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                              <!--DWLayoutTable-->
                              <tr> 
                                <td><div align="left">Carrera</div></td>
                                <td><div align="center">:</div></td>
                                <td width="426"> 
                                  <% f_busqueda.dibujaCampo ("carr_ccod") %>
                                  <input type="hidden" name="carrjorn"  value="<%=carr_ccod & " " & Jornada2%>"> 
                                </td>
								<td width="84"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
                              </tr>
                            </table>
                          </div></td>
                  
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
            <td><div align="center">
                    <br> <%if carrera <> "" then%>
                    <table width="100%" border="0">
                      <tr>
                        <td><table width="99%" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Carrera</font></b></font></td>
    <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=carrera%></font></b></font></td>
  </tr>
  <tr> 
    <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Año</font></b></font></td>
    <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=anos_ccod%></font></b></font></td>
  </tr>
  <tr> 
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b></b></font></td>
    <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b></b></font></div></td>
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b></b></font></td>
  </tr>
  <tr> 
    <td height="0" colspan="3"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
  </tr>
</table></td>
                      </tr>
                    </table> <%end if%>
                    <br>
                  </div>
              <form name="edicion"  method="post">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%formulario.AccesoPagina 'f_planes.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <%formulario.dibujaTabla()%>
                          </div></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
              <form name="Botones" method="post">						  
                <tr>
                  <td><div align="center"> 
                            <% if carr_ccod <> "" then
							      botonera.AgregaBotonParam "nueva" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "nueva" , "deshabilitado", "TRUE"
							   end if
							   botonera.AgregaBotonParam "nueva", "ancho","750"
							   botonera.AgregaBotonParam "nueva", "alto","600"
							   botonera.AgregaBotonParam "nueva", "url", "busca_docentes.asp?carr_ccod=" & carr_ccod & " " & Jornada2
							   botonera.DibujaBoton "nueva"
							%>
                          </div></td>
                  <td><div align="center">
                            <% if carr_ccod <> "" then
							      botonera.AgregaBotonParam "eliminar" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "eliminar" , "deshabilitado", "TRUE"
							   end if
							   botonera.AgregaBotonParam "eliminar", "url", "Habilitacion_Eliminar.asp?carr_ccod=" & carr_ccod & "&jorn_ccod=" & Jornada2 & "&sede_ccod=" & sede_ccod
							   
							   botonera.DibujaBoton "eliminar"%>
							<input type="hidden" name="carr_ccod2"  value="<%=carr_ccod & " " & Jornada2%>">
							<input type="hidden" name="SEDE_CCOD"  value="<%=sede_ccod%>">
                          </div></td>
                  <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
                </tr>
			  </form>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
