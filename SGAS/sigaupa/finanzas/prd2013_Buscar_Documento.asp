<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
fila = 0
set pagina = new CPagina
pagina.Titulo = "informe de documentos"
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'--------------------------------------------------------------------
 num_doc = request.querystring("busqueda[0][ding_ndocto]")
 'if EsVacio(num_doc) then 
 '	num_doc = " "
 'end if	
 tipo_doc = request.querystring("busqueda[0][ting_ccod]")
 estado_doc = request.querystring("busqueda[0][edin_ccod]")
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Buscar_Documento.xml", "busqueda_documentos"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "ding_ndocto", num_doc
 f_busqueda.AgregaCampoCons "ting_ccod", tipo_doc
 f_busqueda.AgregaCampoCons "edin_ccod", estado_doc
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
 f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
 f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Buscar_Documento.xml", "botonera"
'-----------------------------------------------------------------------
set fconsulta = new CFormulario
fconsulta.Carga_Parametros "Buscar_Documento.xml", "f_documento"
fconsulta.Inicializar conexion

set fconsulta_doc = new CFormulario
fconsulta_doc.Carga_Parametros "Buscar_Documento.xml", "f_documento"
fconsulta_doc.Inicializar conexion

set f_resultado = new CFormulario
f_resultado.Carga_Parametros "Buscar_Documento.xml", "f_documento"
f_resultado.Inicializar conexion
f_resultado.Consultar  "select * from ingresos where 1 = 2"


function dibujar(num_documento)
   set f_documentos = new CFormulario
   f_documentos.Carga_Parametros "Buscar_Documento.xml", "f_documento"
   f_documentos.Inicializar conexion
  
   sql =   "SELECT c.comp_ndocto " & vbCrLf &_
		   "FROM detalle_ingresos a, ingresos b, abonos c  " & vbCrLf &_
		   "WHERE a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
			 "AND b.ingr_ncorr = c.ingr_ncorr  " 
			
			 if tipo_doc <> "" then
			 	sql=sql & vbCrLf & " AND cast(a.ting_ccod as varchar) = '" & tipo_doc & "'"	
			 end if
			 if num_documento <> "" then
			 	sql=sql & vbCrLf & " AND cast(a.ding_ndocto as varchar) = '" & num_documento & "'"
			 end if
			 if estado_doc <>"" then
			 	sql=sql & vbCrLf & " AND cast(a.edin_ccod as varchar) = '" & estado_doc & "'"	
			 end if
			  
             '"AND cast(a.ding_ndocto as varchar) = isnull('" & num_documento & "', a.ding_ndocto) " & vbCrLf &_
			 '"AND cast(a.edin_ccod as varchar) = isnull('" & estado_doc & "', a.edin_ccod)"
	'response.Write("<pre>"&sql&"</pre>")		 		 
   
   f_documentos.Consultar sql     
    while f_documentos.Siguiente
     contrato = f_documentos.obtenervalor ("comp_ndocto")
	 fconsulta.Inicializar conexion
     sql = "select protic.compromiso_origen_repactacion(" & contrato & ",'comp_ndocto') as cont_original"
     'response.Write(sql & "<BR><BR>")
	 fconsulta.Consultar  sql        
     fconsulta.Siguiente
	 contrato_origen = fconsulta.obtenervalor ("cont_original")	 	 	
	 mostrar_todo (contrato_origen)		 
   wend
 end function

%>
   
<%
function mostrar_todo (contrato)
    set fconsulta = new CFormulario
    fconsulta.Carga_Parametros "Buscar_Documento.xml", "f_documento"
    fconsulta.Inicializar conexion
	sql = consulta_detalle_contrato (contrato) 
	'response.Write(sql & "<BR> <BR>")
     'response.End()
	fconsulta.Consultar sql
	while fconsulta.Siguiente
	   'response.Write("SIIIIIIII <BR><BR>")
	   repa_ncorr = fconsulta.obtenervalor ("repa_ncorr")
	   ingreso = fconsulta.obtenervalor ("ingr_ncorr")
	   num_doc  = fconsulta.obtenervalor ("ding_ndocto")
	   contrato = fconsulta.obtenervalor ("comp_ndocto")
	   if repa_ncorr <> "" then
	       sql = consulta_documento_completo(num_doc, ingreso)		  
           agregar_filas (sql)		   
		   ok = hacia_adelante (repa_ncorr, ingreso, num_doc)	       
	   else      
		   sql = consulta_documento_completo(num_doc,ingreso)		   		   
		   agregar_filas (sql)		  
	   end if	  
    wend	
 end function

function consulta_detalle_contrato(contrato)
	consulta = "select a.comp_ndocto,a1.tcom_tdesc, e.ding_ndocto, e.ding_ndocto as c_ding_ndocto,  e.ingr_ncorr, e.ting_ccod, " & vbCrLf &_
		   				"f.ting_tdesc,e.ding_mdetalle, e.edin_ccod, g.edin_tdesc as estado, e.repa_ncorr " & vbCrLf &_
				"from compromisos a, tipos_compromisos a1, detalle_compromisos b, " & vbCrLf &_
					 "abonos c, ingresos d,  detalle_ingresos e, tipos_ingresos f, estados_detalle_ingresos g " & vbCrLf &_
				"where a.tcom_ccod = a1.tcom_ccod " & vbCrLf &_
				  "and a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
				  "and a.inst_ccod = b.inst_ccod " & vbCrLf &_
				  "and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
				  "and b.tcom_ccod = c.tcom_ccod " & vbCrLf &_
				  "and b.inst_ccod = c.inst_ccod " & vbCrLf &_
				  "and b.comp_ndocto = c.comp_ndocto " & vbCrLf &_
				  "and b.dcom_ncompromiso = c.dcom_ncompromiso " & vbCrLf &_
				  "and c.ingr_ncorr = d.ingr_ncorr " & vbCrLf &_
				  "and d.ingr_ncorr = e.ingr_ncorr " & vbCrLf &_
				  "and e.ting_ccod = f.ting_ccod " & vbCrLf &_
				  "and e.edin_ccod = g.edin_ccod " & vbCrLf &_
				  "and cast(a.comp_ndocto as varchar) =" & contrato  & " order by e.ting_ccod, e.ding_ndocto" 
	'response.Write("<pre>"&consulta&"</pre>")		 
	consulta_detalle_contrato = consulta
 end function 

 function consulta_documento_completo(num_doc, num_ingreso)
  consulta = "select a.comp_ndocto,a1.tcom_tdesc, e.ding_ndocto, e.ding_ndocto as c_ding_ndocto, e.ingr_ncorr, e.ting_ccod, f.ting_tdesc, " & vbCrLf &_
				    "e.ding_mdetalle, e.edin_ccod, g.edin_tdesc as estado, e.repa_ncorr	" & vbCrLf &_
			 "from contratos z, compromisos a, tipos_compromisos a1,  detalle_compromisos b, abonos c, " & vbCrLf &_
				  "ingresos d, detalle_ingresos e, tipos_ingresos f, estados_detalle_ingresos g   " & vbCrLf &_
			 "where z.cont_ncorr  =* a.comp_ndocto " & vbCrLf &_
			   "and a.tcom_ccod = a1.tcom_ccod " & vbCrLf &_
			   "and a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
			   "and a.inst_ccod = b.inst_ccod " & vbCrLf &_
			   "and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
			   "and b.tcom_ccod = c.tcom_ccod " & vbCrLf &_
			   "and b.inst_ccod = c.inst_ccod " & vbCrLf &_
			   "and b.comp_ndocto = c.comp_ndocto " & vbCrLf &_
			   "and b.dcom_ncompromiso = c.dcom_ncompromiso " & vbCrLf &_
			   "and c.ingr_ncorr = d.ingr_ncorr " & vbCrLf &_
			   "and d.ingr_ncorr = e.ingr_ncorr " & vbCrLf &_
			   "and e.ting_ccod = f.ting_ccod " & vbCrLf &_
			   "and e.edin_ccod = g.edin_ccod " & vbCrLf &_
			   "and cast(e.ding_ndocto as varchar) ='" & num_doc  & " '" & vbCrLf &_
			   "and cast(e.ingr_ncorr as varchar) ='" & num_ingreso& "'"
	'response.Write("<pre>"&consulta&"</pre>")		 
   consulta_documento_completo = consulta
end function 
 
 function hacia_adelante (repa_ncorr, ingreso, num_doc)
    set f_documento = new CFormulario
    f_documento.Carga_Parametros "Buscar_Documento.xml", "f_documento"
    f_documento.Inicializar conexion
	
	if repa_ncorr <> "" then
		   sql = consulta_detalle_contrato (repa_ncorr) 
		   agregar_filas(sql)		  
		   f_documento.Consultar  sql		   
		   while f_documento.Siguiente
		      repa_ncorr = f_documento.obtenervalor ("repa_ncorr")
	          ingreso = f_documento.obtenervalor ("ingr_ncorr")
	          num_doc  = f_documento.obtenervalor ("ding_ndocto")
			  ok = hacia_adelante (repa_ncorr, ingreso, num_doc)
		   wend
	end if	  
 end function
 
 function agregar_filas(sql_consulta)
    'response.Write(sql_consulta &"<BR><BR>")
	set f_documento = new CFormulario
    f_documento.Carga_Parametros "Buscar_Documento.xml", "f_documento"
    f_documento.Inicializar conexion  
    f_documento.Consultar  sql_consulta
    
	while f_documento.Siguiente
      f_resultado.clonafilacons(0)
	  f_resultado.agregacampofilacons fila, "comp_ndocto", f_documento.obtenerValor("comp_ndocto")
	  f_resultado.agregacampofilacons fila, "tcom_tdesc", f_documento.obtenerValor("tcom_tdesc")
	  f_resultado.agregacampofilacons fila, "c_ding_ndocto", f_documento.obtenerValor("ding_ndocto")
	  f_resultado.agregacampofilacons fila, "ding_ndocto", f_documento.obtenerValor("ding_ndocto")
	  f_resultado.agregacampofilacons fila, "ingr_ncorr", f_documento.obtenerValor("ingr_ncorr")
	  f_resultado.agregacampofilacons fila, "ting_ccod", f_documento.obtenerValor("ting_ccod")
	  f_resultado.agregacampofilacons fila, "ting_tdesc", f_documento.obtenerValor("ting_tdesc")
	  f_resultado.agregacampofilacons fila, "ding_mdetalle", f_documento.obtenerValor("ding_mdetalle")
	  f_resultado.agregacampofilacons fila, "edin_ccod", f_documento.obtenerValor("edin_ccod")
	  f_resultado.agregacampofilacons fila, "estado", f_documento.obtenerValor("estado")
	  f_resultado.agregacampofilacons fila, "repa_ncorr", f_documento.obtenerValor("repa_ncorr")	  
	  fila = fila + 1	
     'response.Write("<tr bgcolor=""#AEC7E3""><td>" & f_documento.obtenerValor("comp_ndocto")& "</td></TR>")
   
   wend
 end function

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



</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="183" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      de Documentos</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="458" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
              </table></td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%" height=""><table width="514" border="0">
                        <tr>
                          <td width="105">
                            <div align="left">N&ordm; Documento</div>
                          </td>
                          <td width="17">:</td>
                                <td width="150">
                                  <% f_busqueda.dibujaCampo ("ding_ndocto")%>
                                </td>
                          <td width="55">&nbsp;</td>
                          <td width="13">&nbsp;</td>
                          <td width="148">&nbsp;</td>
                        </tr>
                        <tr>
                          <td>Tipo</td>
                          <td>:</td>
                          <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <% f_busqueda.dibujaCampo ("ting_ccod")%>
                                    </font></div>
                          </td>
                          <td>Estado</td>
                          <td>:</td>
                                <td>
                                  <% f_busqueda.dibujaCampo ("edin_ccod")%>
                                </td>
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
                      </table></td>
                      <td width="19%"><div align="center"><% botonera.DibujaBoton ("buscar")%></div></td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Documentos
                          Encontrados</font></div>
                    </td>
                    <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
              </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
                  </div>
                  <BR>
                  <form name="edicion">
                    <div align="center"> 
                      <% 
					       if num_doc <> "" then						    
						      dibujar num_doc							   							
					       else
						      f_resultado.consultar "select ''"
	                          f_resultado.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
						   end if
					    f_resultado.DibujaTabla()						
					  %>
                    </div>
                  </form>
                    
                  <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="135" bgcolor="#D8D8DE"><table width="84%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="left"></div>                        
                        <div align="left">
                          <% botonera.dibujaBoton "salir"%>
                          </div></td>
                    </tr>
                  </table>
                </td>
                <td width="227" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr>
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table>
        </td>
      </tr>
    </table>
	<BR></td>
  </tr>  
</table>
</body>
</html>