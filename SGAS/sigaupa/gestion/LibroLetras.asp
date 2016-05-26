<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
mes=request.QueryString("busqueda[0][mes]")
ano=request.QueryString("busqueda[0][ano]")
'response.Write("mes "&mes)
set pagina = new CPagina
pagina.Titulo = "Listado Letras Mensuales"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'obtiene la sede
Sede = negocio.ObtenerSede()

sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&Sede&"'")
'filtro  ="(select distinct to_char(co.comp_fdocto,'YYYY') ano, to_char(co.comp_fdocto,'YYYY') ano2 "& vbCrLf &_
'		 " from compromisos co, "& vbCrLf &_
'		 " abonos ab "& vbCrLf &_
'		 " where co.comp_ndocto=ab.comp_ndocto "& vbCrLf &_
'		 " and ab.peri_ccod='"&Periodo&"'"& vbCrLf &_
'		 " and co.comp_fdocto>='01/12/2003')"
		 
filtro = "(select distinct datepart(year,co.comp_fdocto) ano, datepart(year,co.comp_fdocto) ano2 "& vbCrLf &_
			" from compromisos co, "& vbCrLf &_
			" abonos ab "& vbCrLf &_
			" where co.comp_ndocto=ab.comp_ndocto "& vbCrLf &_
			" and cast(ab.peri_ccod as varchar)='"&Periodo&"'"& vbCrLf &_
			" ) a	"

'-------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "LibroLetras.xml", "botonera"
'-------------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "LibroLetras.xml", "busqueda_documentos"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
've que cuando refresque quede con el mismo campo
 f_busqueda.Agregacampocons "mes",mes 
 f_busqueda.Agregacampocons "ano",ano
'manda el filtro al xml  
 f_busqueda.Agregacampoparam "ano","destino",filtro 

'----------------------------------------------------------------------------------
set f_libroletras = new CFormulario
f_libroletras.Carga_Parametros "LibroLetras.xml", "f_libroletras"
f_libroletras.Inicializar conexion

consulta = "select cast(pp.pers_nrut as varchar)  + '-' + pp.pers_xdv pers_nrut,pp.pers_nrut pers_nrut2,"& vbCrLf &_
			"        protic.OBTENER_NOMBRE_COMPLETO(Pp.PERS_NCORR,'n') NOMBRE,"& vbCrLf &_
			"        ti.ting_ccod,ti.ting_tdesc,d.ding_ndocto,d.ding_mdetalle,"& vbCrLf &_
			"        d.ding_mdocto,d.ding_fdocto,pp.pers_ncorr,co.comp_fdocto,convert(varchar,co.comp_fdocto,103) fechaletra"& vbCrLf &_
			"    from detalle_ingresos d,ingresos i,personas pp,abonos ab,tipos_ingresos ti,compromisos co"& vbCrLf &_
			"    where d.ingr_ncorr = i.ingr_ncorr"& vbCrLf &_
			"        and d.PERS_NCORR_CODEUDOR=pp.pers_ncorr"& vbCrLf &_
			"        and i.ingr_ncorr=ab.ingr_ncorr"& vbCrLf &_
			"        and d.ting_ccod=ti.ting_ccod"& vbCrLf &_
			"        and ab.comp_ndocto=co.comp_ndocto"& vbCrLf &_
			"        and ab.tcom_ccod=co.tcom_ccod"& vbCrLf &_
			"        and i.eing_ccod=4"& vbCrLf &_
			"        and cast(ab.peri_ccod as varchar)='"&Periodo&"'"& vbCrLf &_
			"        and cast(co.sede_ccod as varchar)='"&Sede&"'"& vbCrLf &_
			"        and d.TING_CCOD=4"& vbCrLf &_
			"        and co.audi_tusuario not in ('ACTIVAR_CONTRATO')"
			
    		'--------- busca por año y por mes si año y mes tienen valores
			if mes<>"" and ano<>"" then 			   
			     consulta=consulta & " and cast(datePart(month,co.comp_fdocto) as numeric)="&cint(mes)& " and cast(datePart(year,co.comp_fdocto) as numeric)="&cint(ano)&""
			end if
			
			'-------------------------------------------------------------
			'si mes tiene valor pero año no
			if mes<>"" and ano="" then 			   
			     consulta=consulta & " and cast(datePart(month,co.comp_fdocto) as numeric)="&cint(mes)
			end if
			
			'---------------------------------------------------
			' si mes no tiene valor pero año si
			if mes="" and ano<>"" then 			   			   
			     consulta=consulta & "and cast(datePart(year,co.comp_fdocto) as numeric)="&cint(ano)&""			   
			end if
						
			consulta=consulta & "order by co.COMP_FDOCTO asc,pp.pers_nrut desc,d.DING_FDOCTO asc"					
'response.Write("<pre>"&consulta&"</pre>")
'response.end()

   f_libroletras.consultar consulta
   
 botonera.AgregaBotonUrlParam "excel", "busqueda[0][mes]", mes
 botonera.AgregaBotonUrlParam "excel", "busqueda[0][ano]", ano
'--------------------------------------------------------------------------------
'response.Write("<pre>"&consulta&"</pre>")			
'response.End()
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../Registro_Curricular/im&#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../Registro_Curricular/im&#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../Registro_Curricular/im&#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../Registro_Curricular/im&#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	  <p>&nbsp;</p>
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
                <td><%pagina.DibujarLenguetas Array("Antecedentes de Matricula"), 1 %></td>
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
                            <table width="514" border="0">
                              <tr>
                                <td width="105"><div align="left">A&ntilde;o<font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                                </font></div></td>
                                <td width="17">:</td>
                                <td width="150"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                                  <% f_busqueda.dibujaCampo ("ano")%>
</font> </td>
                                <td width="55">Mes</td>
                                <td width="13">&nbsp;</td>
                                <td width="148"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                                  <% f_busqueda.dibujaCampo ("mes")%>
</font></td>
                              </tr>
                              <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                                </font></div></td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp;
                                </font></td>
                              </tr>
                              <!-- 
					    <tr>
                          <td>Rut Alumno</td>
                          <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <%'f_busqueda.DibujaCampo("pers_nrut") %>
                                  - 
                                  <%'f_busqueda.DibujaCampo("pers_xdv") %>
                                  </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut
                              Apoderado</font></td>
                          <td>:</td>
                          <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <%'f_busqueda.DibujaCampo("code_nrut")%>
                                    -
                                    <%'f_busqueda.DibujaCampo("code_xdv")%>
                                    </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div>
                          </td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
						-->
                            </table>
                        </div></td>
                        <td width="19%"><div align="center">
                            <% botonera.DibujaBoton ("buscar")%>
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
	  <p><br>
        <br>
      </p>
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
                    <br>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_libroletras.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td><%pagina.DibujarSubtitulo "Libro de Letras de Sede " & sede_tdesc%> <br> <%f_libroletras.dibujaTabla()%> </td>
                      </tr>
                    </table>
                    <br>
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td colspan="3"> 
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="72" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="19%"> <div align="left"> 
                          <%botonera.dibujaboton "excel"%>
                        </div></td>
                      <td width="81%"> <div align="left"> 
                          <%botonera.dibujaBoton "lanzadera"%>
                        </div></td>
                    </tr>
                  </table></td>
                <td width="290" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr> 
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table></td>
        </tr>
      </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
