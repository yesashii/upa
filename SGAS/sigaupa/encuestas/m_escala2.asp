<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Escala de la  Encuesta" 


encu_ncorr = request.querystring("encu_ncorr")
'--------------------------------------------------------------------------
set conectar = new cconexion
conectar.inicializar "upacifico"

nombre_encuesta=conectar.consultaUno("Select encu_tnombre from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")

set negocio = new CNegocio
negocio.Inicializa conectar

set botonera = new CFormulario
botonera.Carga_Parametros "m_escala2.xml", "botonera"
'-------------------------------------------------------------------------------

set f_escala = new CFormulario
f_escala.Carga_Parametros "m_escala2.xml", "f_escala"
f_escala.Inicializar conectar

  sql = "SELECT '"&encu_ncorr&"' as encu_ncorr,'<a href=""javascript:editar('+cast(a.resp_ncorr as varchar)+')"">'+ cast(a.resp_ccod as varchar) + '</a>' as resp_ccod,a.resp_ncorr,a.resp_tabrev,a.resp_tdesc,a.resp_nnota,a.resp_bpondera,a.resp_norden"& vbcrlf & _		
		"FROM respuestas a "& vbcrlf & _
		"WHERE cast(a.encu_ncorr as varchar)= '"&encu_ncorr&"' ORDER BY a.resp_norden ASC" 
        if encu_ncorr <> "" then
		 f_escala.Consultar sql		 
	   else
		f_escala.consultar "select '' from sexos where 1 = 2"
	  end if

lenguetas_encuesta = Array(Array("Críterios","m_criterios2.asp?encu_ncorr="&encu_ncorr),Array("Escala","m_escala2.asp?encu_ncorr="&encu_ncorr),Array("Ver encuesta","m_ver2.asp?encu_ncorr="&encu_ncorr))		

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


var tabla;

function inicio()
{
   var cantidad;
   tabla = new CTabla("solicitudes");  
   if (tabla.filas.length == 1 )
   {
     document.edicion.elements["solicitudes[0][soli_ncorr]"].checked=true;
	 seleccionar(document.edicion.elements["solicitudes[0][soli_ncorr]"]);	
   }   
}

function volver()
{
   location.href ="m_encuestas2.asp";
}
function editar(valor){
    var encu;
	encu=<%=encu_ncorr%>;
    irA("edita_escala2.asp?resp_ncorr="+ valor +"&encu_ncorr="+encu, "1", 600, 350)
}
</script>

</head>
<body bgcolor="#EBEBEB" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
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
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
					   <td><%				
							pagina.DibujarLenguetas lenguetas_encuesta, 2
							%></td>
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
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"><div align="center">
                        <div align="center"> 
                        <%pagina.DibujarTituloPagina%>
                      </div>
                      <BR>
                      <table width="100%"  border="0" align="center">
                        <tr> 
                          <td width="75%"> <table width="100%" border="0" align="center">
                               <tr> 
                                <td width="32%"><strong><%=nombre_encuesta%>/
								Escala</strong></td>
                              </tr>
                              
                            </table></td>
                          <td width="25%"> 
                          </td>
                        </tr>
                      </table>
                   
					
                    <form name="f_escala">
                      <table width="98%" border="0">
                        <tr> 
                          <td> <div align="right">P&aacute;gina 
                              <%f_escala.AccesoPagina%>
                            </div></td>
                        </tr>
                      </table>
                      <div align="center"> 
                        <% f_escala.dibujatabla  %>
                        <table width="98%" border="0">
                          <tr> 
                            <td>&nbsp; </td>
                          </tr>
                        </table>
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
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="28%"><%botonera.agregabotonparam "agregar","url","edita_escala2.asp?encu_ncorr="&encu_ncorr
						                botonera.dibujaBoton "agregar" %></td>
                      <td width="30%"><% botonera.dibujaBoton "eliminar"  %></td>
                      <td width="42%"><% botonera.dibujaBoton "Volver"  %></td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
