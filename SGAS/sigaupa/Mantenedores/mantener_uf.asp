<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
anos_ccod = request.QueryString("b[0][anos_ccod]")

set pagina = new CPagina
pagina.Titulo = "Unidad de Fomento"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_buscar = new CFormulario
 f_buscar.Carga_Parametros "mantener_ufomento.xml", "busqueda"
 f_buscar.Inicializar conexion
 f_buscar.Consultar "select '' "
 f_buscar.Siguiente
've que cuando refresque quede con el mismo campo
 f_buscar.Agregacampocons "anos_ccod", anos_ccod


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "mantener_ufomento.xml", "botonera"

set f_uf = new CFormulario
f_uf.Carga_parametros  "mantener_ufomento.xml" , "uf"
f_uf.Inicializar conexion



if anos_ccod <> "" then
SQL = " select "& vbCrLf &_
	  " DIA,'<A HREF=mantener_ufo.asp?fecha='+cast(dia as varchar)+'/01/"&anos_ccod&">'+isnull(cast(ENERO as varchar),'ingresar')+'</A>'AS ENERO,"& vbCrLf &_
	  " '<A HREF=mantener_ufo.asp?fecha='+cast(dia as varchar)+'/02/"&anos_ccod&">'+isnull(cast(FEBRERO as varchar),'ingresar')+'</A>'AS FEBRERO,"& vbCrLf &_
	  " '<A HREF=mantener_ufo.asp?fecha='+cast(dia as varchar)+'/03/"&anos_ccod&">'+isnull(cast(MARZO as varchar),'ingresar')+'</A>'AS MARZO,"& vbCrLf &_
	  " '<A HREF=mantener_ufo.asp?fecha='+cast(dia as varchar)+'/04/"&anos_ccod&">'+isnull(cast(ABRIL as varchar),'ingresar')+'</A>'AS ABRIL,"& vbCrLf &_
	  " '<A HREF=mantener_ufo.asp?fecha='+cast(dia as varchar)+'/05/"&anos_ccod&">'+isnull(cast(MAYO as varchar),'ingresar')+'</A>'AS MAYO,"& vbCrLf &_
	  " '<A HREF=mantener_ufo.asp?fecha='+cast(dia as varchar)+'/06/"&anos_ccod&">'+isnull(cast(JUNIO as varchar),'ingresar')+'</A>'AS JUNIO,"& vbCrLf &_
	  " '<A HREF=mantener_ufo.asp?fecha='+cast(dia as varchar)+'/07/"&anos_ccod&">'+isnull(cast(JULIO as varchar),'ingresar')+'</A>'AS JULIO,"& vbCrLf &_
	  " '<A HREF=mantener_ufo.asp?fecha='+cast(dia as varchar)+'/08/"&anos_ccod&">'+isnull(cast(AGOSTO as varchar),'ingresar')+'</A>'AS AGOSTO,"& vbCrLf &_
	  " '<A HREF=mantener_ufo.asp?fecha='+cast(dia as varchar)+'/09/"&anos_ccod&">'+isnull(cast(SEPTIEMBRE as varchar),'ingresar')+'</A>'AS SEPTIEMBRE,"& vbCrLf &_
	  " '<A HREF=mantener_ufo.asp?fecha='+cast(dia as varchar)+'/10/"&anos_ccod&">'+isnull(cast(OCTUBRE as varchar),'ingresar')+'</A>'AS OCTUBRE,"& vbCrLf &_
	  " '<A HREF=mantener_ufo.asp?fecha='+cast(dia as varchar)+'/11/"&anos_ccod&">'+isnull(cast(NOVIEMBRE as varchar),'ingresar')+'</A>'AS NOVIEMBRE,"& vbCrLf &_
	  " '<A HREF=mantener_ufo.asp?fecha='+cast(dia as varchar)+'/12/"&anos_ccod&">'+isnull(cast(DICIEMBRE as varchar),'ingresar')+'</A>'AS DICIEMBRE"& vbCrLf &_
	  "  from ( "& vbCrLf &_
	  "    SELECT DIA, "& vbCrLf &_
	  "   MAX(CASE    when MES='01' then ufom_mvalor  end) AS ENERO,"& vbCrLf &_
	  "   MAX(CASE    when MES='02' then ufom_mvalor  end) AS FEBRERO ,"& vbCrLf &_
	  "   MAX(CASE    when MES='03' then ufom_mvalor  end) AS MARZO ,"& vbCrLf &_
	  "   MAX(CASE    when MES='04' then ufom_mvalor  end) AS ABRIL ,"& vbCrLf &_
	  "   MAX(CASE    when MES='05' then ufom_mvalor  end) AS MAYO ,"& vbCrLf &_
	  "   MAX(CASE    when MES='06' then ufom_mvalor  end) AS JUNIO,"& vbCrLf &_
	  "   MAX(CASE    when MES='07' then ufom_mvalor  end) AS JULIO,"& vbCrLf &_
	  "   MAX(CASE    when MES='08' then ufom_mvalor  end) AS AGOSTO ,"& vbCrLf &_
	  "   MAX(CASE    when MES='09' then ufom_mvalor  end) AS SEPTIEMBRE ,"& vbCrLf &_
	  "   MAX(CASE    when MES='10' then ufom_mvalor  end) AS OCTUBRE ,"& vbCrLf &_
	  "   MAX(CASE    when MES='11' then ufom_mvalor  end) AS NOVIEMBRE ,"& vbCrLf &_
	  "   MAX(CASE    when MES='12' then ufom_mvalor  end) AS DICIEMBRE   "& vbCrLf &_
	  "  FROM "& vbCrLf &_
	  "  (SELECT isnull(datepart(day,ufom_fuf),diam_ccod) as dia,datepart(month,ufom_fuf) AS MES,ufom_mvalor as ufom_mvalor "& vbCrLf &_
	  "      from dias_mes "& vbCrLf &_
	  " 	 left outer join  uf  "& vbCrLf &_
	  " 	 on diam_ccod=datepart(day,ufom_fuf) "& vbCrLf &_
	  "      and datepart(year,ufom_fuf) = " & anos_ccod & ") as tabla "& vbCrLf &_
	  "      GROUP BY DIA "& vbCrLf &_
	  "  	) as tabla2 "
'response.Write("<pre>"&SQL&"</pre>")
	f_uf.consultar SQL
else 
	f_uf.consultar "select '' "
end if


'---------------------------------------------------------------------------------------------------
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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                  <td width="41%"></td>
                  <td width="40%"><b>INGRESA AÑO DE BUSQUEDA:</b>
                    <% f_buscar.dibujaCampo ("anos_ccod")%></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton "buscar"%></div></td>
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
                <%pagina.DibujarTituloPagina%>
                <br>
              <br>
              <table width="98%"  border="0">
                <tr>
                  <td scope="col"><div align="center"></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "DETALLE UNIDAD DE FOMENTO AÑO: " & anos_ccod &" "%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col"><div align="center">
                            <%f_uf.DibujaTabla%>
                          </div></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "salir"%></div></td>
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
