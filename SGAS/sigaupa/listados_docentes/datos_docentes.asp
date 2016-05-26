<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

q_peri_ccod = Request.QueryString("b[0][peri_ccod]")


if q_peri_ccod ="" then

q_peri_ccod = 0
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
 
f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod


c_profesores =   " select count(distinct d.pers_ncorr)   " & vbCrLf &_
				 "	from secciones a join bloques_horarios b   " & vbCrLf &_
				 "		on a.secc_ccod=b.secc_ccod  " & vbCrLf &_
				 "	join bloques_profesores c   " & vbCrLf &_
				 "		on b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
				 "	join personas d  " & vbCrLf &_
				 "		on c.pers_ncorr=d.pers_ncorr  " & vbCrLf &_ 
				 "	left outer join sexos e  " & vbCrLf &_
				 "		on d.sexo_ccod = e.sexo_ccod  " & vbCrLf &_
				 "	left outer join estados_civiles f  " & vbCrLf &_
				 "		on d.eciv_ccod = f.eciv_ccod  " & vbCrLf &_
				 "	left outer join paises g  " & vbCrLf &_
				 "		on d.pais_ccod=g.pais_ccod  " & vbCrLf &_
				 "	where (isnull(d.sexo_ccod,-1)=-1 or isnull(d.eciv_ccod,-1)=-1 or isnull(d.pais_ccod,-1)=-1)  " & vbCrLf &_
				 "	and cast(a.peri_ccod as varchar)='"&peri_ccod&"'" 

profesores = conexion.consultaUno(c_profesores)
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
	<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
          <table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                    <td bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td  bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                    <td  align="right" bgcolor="#D8D8DE"><%'=formu_resul.dibujaCampo("peri_tdesc")%></td>
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
				  <table cellspacing=0 cellpadding=0 align="centerr" width="47%" border=0 >
                    <tbody>
                     
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
							<td>&nbsp;</td> 
						 </tr>
						
						 
						
                    </tbody>
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
			<br><br>
            <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td>
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
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
           
     		<table align="center">
			<tr>
                            <td width="44%" height=40 align=middle valign=top>
                              <div align="center"><strong><font size="3"> Listado de Docentes </font></strong><br>
                             Presione bot&oacute;n para generar archivo</div>
                            </td>
                                                      
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
                  <td>
                    <% if cint(q_peri_ccod) >0  then
							botonera.AgregaBotonParam "excel", "url", "datos_docentes_excel.asp?peri_ccod="&q_peri_ccod
							 botonera.AgregaBotonParam "excel", "texto", "Generar"
					  	     botonera.dibujaboton "excel"
					   end if%>  
                  </td>
                  <td>
                    <% if cint(q_peri_ccod) >0  then
							botonera.AgregaBotonParam "excel", "url", "SIES_general_excel.asp?peri_ccod="&q_peri_ccod
							 botonera.AgregaBotonParam "excel", "texto", "SIES General"
					  	     botonera.dibujaboton "excel"
					   end if%>  
                  </td>
                  <td>
                    <% if cint(q_peri_ccod) >0  then
							botonera.AgregaBotonParam "excel", "url", "SIES_general_excel.asp?peri_ccod="&q_peri_ccod&"&tipo=T"
							 botonera.AgregaBotonParam "excel", "texto", "SIES Técnicas"
					  	     botonera.dibujaboton "excel"
					   end if%>  
                  </td>
                  <td>
                    <% if cint(q_peri_ccod) >0  then
							botonera.AgregaBotonParam "excel", "url", "SIES_general_excel.asp?peri_ccod="&q_peri_ccod&"&tipo=P"
							 botonera.AgregaBotonParam "excel", "texto", "SIES Profesionales"
					  	     botonera.dibujaboton "excel"
					   end if%>  
                  </td>
                  <td>
                    <% if cint(q_peri_ccod) >0  then
							botonera.AgregaBotonParam "excel", "url", "SIES_general_excel.asp?peri_ccod="&q_peri_ccod&"&tipo=O"
							 botonera.AgregaBotonParam "excel", "texto", "SIES Otras"
					  	     botonera.dibujaboton "excel"
					   end if%>  
                  </td>
                  <td>
                    <% if cint(q_peri_ccod) >0  and profesores <> "0" then
							botonera.AgregaBotonParam "excel", "url", "docentes_datos_faltantes_excel.asp?peri_ccod="&q_peri_ccod
							 botonera.AgregaBotonParam "excel", "texto", "Con datos faltantes"
					  	     botonera.dibujaboton "excel"
					   end if%>  
                  </td>
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