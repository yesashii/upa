<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Vencimiento de Convenios"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "convenios_rrii.xml", "botonera"

'************CAPTURA ANIO Y MES******************
sql_anio= "select DATEPART(year, getdate()) as anio_actual" 
v_sql_anio=conexion.consultaUno(sql_anio)	

sql_mes_actual= "select DATEPART(month ,getdate()) as mes_actual" 
v_sql_mes_actual=conexion.consultaUno(sql_mes_actual)

sql_mes= "select DATEPART(month ,dateadd(month,6,getdate())) as mes_actual" 
v_sql_mes=conexion.consultaUno(sql_mes)

'v_sql_mes_actual = 11
'v_sql_mes = 5

if v_sql_mes < 6 and v_sql_mes_actual > 7 then
	v_sql_anio = v_sql_anio +1
end if 
'response.Write("anio "&v_sql_anio&"</br> ")
'response.Write("mes restado "&v_sql_mes&"</br> ")
'response.Write("mes actual "&v_sql_mes_actual&"</br> ")
'***********************************************

set f_convenio = new CFormulario
f_convenio.Carga_Parametros "convenios_rrii.xml", "termino_convenios"
f_convenio.Inicializar conexion

sql="select a.daco_ncorr, univ_tdesc, pais_tdesc, ciex_tdesc, protic.trunc(daco_ffin_clase_sem2)as fin_convenio2, DATEPART(year, daco_ffin_clase_sem2) as anio_convenio,DATEPART(month, daco_ffin_clase_sem2) as mes_convenio" & vbCrLf &_
"from datos_convenio a,universidad_ciudad b,universidades c,carreras_convenio d,ciudades_extranjeras e,paises f" & vbCrLf &_
"where a.unci_ncorr=b.unci_ncorr" & vbCrLf &_
"and b.univ_ccod=c.univ_ccod" & vbCrLf &_
"and b.ciex_ccod=e.ciex_ccod" & vbCrLf &_
"and a.daco_ncorr=d.daco_ncorr" & vbCrLf &_
"and a.anos_ccod= DATEPART(year, getdate())" & vbCrLf &_
"and d.ecco_ccod=1" & vbCrLf &_
"and e.pais_ccod=f.pais_ccod" & vbCrLf &_
"and DATEPART(year, daco_ffin_clase_sem2) ="&v_sql_anio&"" & vbCrLf &_
"and DATEPART(month, daco_ffin_clase_sem2) ="&v_sql_mes&"" & vbCrLf &_
"group by univ_tdesc,daco_ffin_clase_sem2,a.daco_ncorr,pais_tdesc,ciex_tdesc" & vbCrLf &_
"order by daco_ffin_clase_sem2"
			
'response.Write("<pre>"&sql&"</pre>")
'response.End()

f_convenio.Consultar sql

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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	
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
            <td><%pagina.DibujarLenguetas Array("Vencimiento de Convenios"), 1 %></td>
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
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
             <form name="edicion">			  
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Vencimiento de Convenios"%>
					
                      <table width="98%"  border="0" align="center">
					  <!-- <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_convenio.accesopagina%>
                             </td>
                            </tr>-->
                            <br>
                            <tr>						
                                <td align="center">
									<%f_convenio.Dibujatabla()%>
							   </td>						  
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><p><br> </p>
                            </td>
                        </tr>
                      </table></td>
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
            <td width="20%" height="20"><div align="center">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td> 
                  <td><div align="center"><%f_botonera.DibujaBoton("Crear_siguiente")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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