<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

q_sede_ccod =Request.QueryString("b[0][sede_ccod]")
q_peri_ccod = Request.QueryString("b[0][peri_ccod]")
q_tcar_ccod=Request.QueryString("b[0][tcar_ccod]")
q_tido_ccod=Request.QueryString("b[0][tido_ccod2]")

if q_sede_ccod =""  then
q_sede_ccod =0

end if
if q_peri_ccod ="" then

q_peri_ccod = 0
end if
if q_tcar_ccod =""  then
q_tcar_ccod =0

end if
if q_tido_ccod =""  then
q_tido_ccod =0

end if

set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "botonera_generica.xml", "botonera"


set conexion = new cConexion
set negocio = new cNegocio
'set formu_resul= new cformulario
'set resultado_busqueda = new cFormulario
conexion.inicializar "upacifico"
negocio.inicializa conexion

'**********************************************


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "horas_docente_sexo_grado_docente.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod
f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod
f_busqueda.AgregaCampoCons "tcar_ccod", q_tcar_ccod
f_busqueda.AgregaCampoCons "tido_ccod2", q_tido_ccod


'response.Write("<pre>"&q_anos_ccod&"</pre>")
'response.Write("<pre>"&q_mes_ccod&"</pre>")
%>


<html>
<head>
<title>Reporte de Documentos por Vencer</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">

function dibujar(){
formulario = document.buscador;
formulario.submit();
}
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="">
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
                    <td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="106" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador</font><font size="1" face="Verdana, Arial, Helvetica, sans-serif"></font></div></td>
                    <td width="347" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="107" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                    <td width="105" align="right" bgcolor="#D8D8DE"><%'=formu_resul.dibujaCampo("peri_tdesc")%></td>
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
				<table width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
				<form name="buscador" >
				  <table cellspacing=0 cellpadding=0 align="left" width="24%" border=0 >
                    <tbody>
                      <tr>
                        <td width="52%">Sede</td>
                        <td width="48%">
                            <%f_busqueda.DibujaCampo("sede_ccod")%></td>
                        
                        </tr>
                      <tr>
							<td>&nbsp;</td> 
						 </tr>
                      <tr>
                        <td width="52%">Periodo Académico </td>
                          
                        <td width="48%">
                            <%f_busqueda.DibujaCampo("peri_ccod")%></td>
                               
                        </tr>
						 <tr>
							<td>&nbsp;</td> 
						 </tr>
						 <tr>
                        <td width="52%">Tipo Carrera</td>
                           
                        <td width="48%">
                            <%f_busqueda.DibujaCampo("tcar_ccod")%></td>
                            
                        </tr>
						  <tr>
							<td>&nbsp;</td> 
						 </tr>
						
						 <tr>
                        <td width="52%">Tipo Docente</td>
                          
                        <td width="48%">
                            <%f_busqueda.DibujaCampo("tido_ccod2")%></td>
                                
                        </tr>
						
                    </tbody>
                  </table>
				  <table height="60">
			<tr>
                            <td width="44%" height=40 align=middle valign=top>
                              <div align="center"><strong><font size="2">Debe Selecionar la sede,periodo Académico, el tipo carrera y el tipo Docente </font></strong><br> </div></td>
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
				<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Tipos de Listados"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
		  <td><div align="center">
                    <br>
                    <table width="100%" border="0">
                     
                    </table>
					</tr>
          <tr>
            <td><div align="left"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
           
                <table width="30%"  border="0" align="left" cellpadding="0" cellspacing="0">
				
				
						<% if cint(q_peri_ccod) >0 and cint(q_peri_ccod) >0 and cint(q_tcar_ccod) >=0 and cint(q_tido_ccod) >=0 then%>
						  
							<td><% 
							botonera.AgregaBotonParam "excel", "url", "total_horas_docentes_x_grado_sexo_jornada_excel.asp?sede_ccod="&q_sede_ccod&"&peri_ccod="&q_peri_ccod&"&tcar_ccod="&q_tcar_ccod&"&tido_ccod="&q_tido_ccod&""
							 botonera.AgregaBotonParam "excel", "texto", "Generar"
					  	     botonera.dibujaboton "excel"%></td>
						  </tr>
						 
						  <%end if%>
							
				
                </table>
				
				
			<table>
			<tr>
                            <td width="44%" height=40 align=middle valign=top>
                              <div align="center"><strong><font size="3"> Listado de horas docente por sexo grado y sede</font></strong><br>
                             Presione bot&oacute;n para generar archivo</div></td>
                                                      
                          </tr>
			</table>
					
				  
                          <br>
           </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>		
          </td>
      </tr>
    </table>	
	<br>
    </td>
  </tr>  
</table>
</body>
</html>