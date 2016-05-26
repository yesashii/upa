<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_tdet_ccod = Request.QueryString("busqueda[0][tdet_ccod]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Mantenedor de Cursos e impresión de Certificados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "impresion_certificados_cursos.xml", "botonera"

'f_botonera.AgregaBotonUrlParam "agregar", "tcom_ccod", q_tcom_ccod


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "impresion_certificados_cursos.xml", "busqueda_cursos"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
'---------------------------------------------------------------------------------------------------
set f_lista_incritos = new CFormulario
f_lista_incritos.Carga_Parametros "impresion_certificados_cursos.xml", "f_cursos"
f_lista_incritos.Inicializar conexion
'response.Write("Largo:"&len(Request.QueryString))
if len(Request.QueryString) > 1 then
	if esVacio(v_tdet_ccod) then
		sql_filtro = ""
	else
		sql_filtro = " and cast(c.tdet_ccod as varchar)='"&v_tdet_ccod&"' "
		f_busqueda.agregaCampoCons "tdet_ccod", v_tdet_ccod
	end if


sql_cursos = " Select g.ingr_nfolio_referencia as comprobante,protic.trunc(max(g.ingr_fpago)) as fecha_inscrito, "& vbCrLf &_
				" d.tdet_tdesc, protic.obtener_nombre(b.pers_ncorr,'n') nombre_persona, "& vbCrLf &_
				" protic.obtener_rut(b.pers_ncorr) as rut, isnull(e.pers_tfono,'s/n') as telefono ,"& vbCrLf &_
				" protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB') as direccion "& vbCrLf &_
				"    From compromisos a "& vbCrLf &_
				"    join detalle_compromisos b  " & vbCrLf &_  
				"		on a.tcom_ccod = b.tcom_ccod  "& vbCrLf &_      
				"		and a.inst_ccod = b.inst_ccod  "& vbCrLf &_      
				"		and a.comp_ndocto = b.comp_ndocto "& vbCrLf &_
				"        and a.ecom_ccod = '1' "& vbCrLf &_
				"     join detalles c "& vbCrLf &_
				"        on c.tcom_ccod = b.tcom_ccod  "& vbCrLf &_ 
				"		and c.inst_ccod = b.inst_ccod  "& vbCrLf &_  
				"		and c.comp_ndocto = b.comp_ndocto "& vbCrLf &_
				"    	and c.tdet_ccod not in (909) " & vbCrLf &_
				"     join tipos_detalle d "& vbCrLf &_
				"        on c.tdet_ccod=d.tdet_ccod "& vbCrLf &_
				"     join personas e "& vbCrLf &_
				"        on b.pers_ncorr=e.pers_ncorr "& vbCrLf &_
				"     join abonos f "& vbCrLf &_
				"        on b.tcom_ccod = f.tcom_ccod  " & vbCrLf &_
				"		 and b.inst_ccod = f.inst_ccod  " & vbCrLf &_ 
				"		 and b.comp_ndocto = f.comp_ndocto "& vbCrLf &_
				"        and b.dcom_ncompromiso = f.dcom_ncompromiso "& vbCrLf &_
				"     join ingresos g "& vbCrLf &_
				"        on f.ingr_ncorr=g.ingr_ncorr "& vbCrLf &_
				"        and ting_ccod=33 "& vbCrLf &_
				" Where a.tcom_ccod=7 " &sql_filtro& " "& vbCrLf &_
				" Group by g.ingr_nfolio_referencia,b.pers_ncorr,c.tdet_ccod,d.tdet_tdesc,e.pers_tfono"
else
	sql_cursos="select '' where 1=2"			
end if
'response.Write("<pre>"&sql_cursos&"</pre>")
f_lista_incritos.Consultar sql_cursos


fue_grabado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_cursos where cast(tdet_ccod as varchar)='"&v_tdet_ccod&"'")

if fue_grabado = "N" then 
     nombre_curso = conexion.consultaUno("select tdet_tdesc from tipos_detalle where cast(tdet_ccod as varchar)='"&v_tdet_ccod&"'")
	 consulta_datos = "select '"&v_tdet_ccod&"' as tdet_ccod, '"&nombre_curso&"' as nombre_curso"
	 
	 grabado = 0
	 
else
	 consulta_datos = " select tdet_ccod,nombre_curso,horas_curso,tipo_curso,organizado_por,periodo "&_
					  " from datos_cursos where cast(tdet_ccod as varchar)='"&v_tdet_ccod&"'"	 

end if

set f_datos = new CFormulario
f_datos.Carga_Parametros "impresion_certificados_cursos.xml", "datos_cursos"
f_datos.Inicializar conexion

f_datos.Consultar consulta_datos
f_datos.Siguiente
'response.Write(promedio_tesis)
'grabado = f_datos.nroFilas

'response.Write(grabado)
'---------------------------------------------------------------------------------------------------
if fue_grabado <> "N" then
	f_botonera.AgregaBotonUrlParam "imprimir_certificado", "tdet_ccod", v_tdet_ccod
	
	if f_datos.obtenerValor("tipo_curso")= "1" then 
		f_botonera.AgregaBotonUrlParam "imprimir_certificado", "tipo_curso", v_tdet_ccod
		f_botonera.AgregaBotonParam "imprimir_certificado", "texto", "Imprimir Cert. Diplomados"
		f_botonera.AgregaBotonUrlParam "imprimir_certificado", "tipo_curso", "2"
	elseif f_datos.obtenerValor("tipo_curso")= "2" then 
		f_botonera.AgregaBotonUrlParam "imprimir_certificado", "tipo_curso", v_tdet_ccod
		f_botonera.AgregaBotonParam "imprimir_certificado", "texto", "Imprimir Cert. Cursos"
		f_botonera.AgregaBotonUrlParam "imprimir_certificado", "tipo_curso", "1"
	end if	
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../mantenedores/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../mantenedores/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../mantenedores/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../mantenedores/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
			<form name="buscador">
                    <table width="438" border="0">
                      <tr> 
                        <td width="105">Cursos</td>
                        <td width="17">:</td>
                        <td width="150"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                            <% f_busqueda.dibujaCampo ("tdet_ccod")%>
                            </font></div></td>
                        <td width="148"><% f_botonera.DibujaBoton ("buscar")%>
                        </td>
                      </tr>
                    </table>
				  </form> 
                  </div>
				  <br>
				  <br>
			<center><%pagina.DibujarTituloPagina%> </center> 
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
					  <tr>
					  <td><div align="right"> <%f_lista_incritos.AccesoPagina%></div></td>
					  </tr>
                        <tr>
                          <td><div align="center"><%f_lista_incritos.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
				  <%if v_tdet_ccod <> "" then %>
				  <tr><td>&nbsp;</td></tr>
				  <tr>
				      <td align="center">
					      <table width="90%" border="1">
					       <tr>
						      <td><table width="100%">
							      <tr><input type="hidden" value="<%=v_tdet_ccod%>" name="d_cursos[0][tdet_ccod]">
								      <%tipo = f_datos.obtenerValor("tipo_curso")%>
								      <td colspan="2" align="center"> <%if tipo = "1" then%>
									                                     <input type="radio" name="d_cursos[0][tipo_curso]" value="1" checked> 
																	  <%else%>	 
																	     <input type="radio" name="d_cursos[0][tipo_curso]" value="1"> 
																	  <%end if%> <strong>: Diplomado.</strong></td>
									  <td colspan="2" align="center"><%if tipo = "2" then%>
									                                     <input type="radio" name="d_cursos[0][tipo_curso]" value="2" checked> 
																	  <%else%>	 
																	     <input type="radio" name="d_cursos[0][tipo_curso]" value="2"> 
																	  <%end if%> <strong>: Seminarios, Cursos, etc.</strong></td>
								  </tr>
								  <tr>
								      <td width="25%" align="left"><strong>Nombre a Imprimir</strong></td>
									  <td colspan="3" align="left"><strong> : </strong><%f_datos.dibujaCampo("nombre_curso")%></td>
								  </tr>
								  <tr>
								      <td width="25%" align="left"><strong>Horas Curso</strong></td>
									  <td colspan="3" align="left"><strong> : </strong><%f_datos.dibujaCampo("horas_curso")%></td>
								  </tr>
								  <tr>
								      <td width="25%" align="left"><strong>Organizado por</strong></td>   
								      <td colspan="3" align="left"><strong> : </strong><%f_datos.dibujaCampo("organizado_por")%></td>
								  </tr> 
								  <tr>
								      <td width="25%" align="left"><strong>Periodo</strong></td>
									  <td colspan="3" align="left"><strong> : </strong><%f_datos.dibujaCampo("periodo")%></td>
								  </tr>
								  <tr>
								      <td colspan="3" align="left"><strong>&nbsp;</strong></td>
									  <td width="25%" align="center"><%f_botonera.DibujaBoton "grabar"%></td>
								  </tr> 
								  </table>							  
							  </td>
						    </tr>
					      </table>
					  </td>
				  </tr>
				  <%end if%>
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
                <tr>
                  <td width="49%"><div align="center"><%f_botonera.DibujaBoton "salir"%></div></td>
                  <td width="35%"><div align="center">
                            <% f_botonera.DibujaBoton "excel"
							  'f_botonera.agregabotonparam "excel", "url", "inscritos_cursos_excel.asp?tdet_ccod=" & folio_envio
							%>
                          </div></td>
                  <td width="16%"><div align="center"><% if fue_grabado <> "N" then
				                                         	f_botonera.DibujaBoton "imprimir_certificado"
														 end if	%> </div></td>
                </tr>
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
