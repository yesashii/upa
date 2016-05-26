<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
minr_ncorr = request.querystring("minr_ncorr")

set pagina = new CPagina

if minr_ncorr <> "" then
   pagina.Titulo = "Editar Minor" 
else
   pagina.Titulo = "Nuevo Minor" 
end if
'---------------------------------------------------------------------------------------------------
'----------------------------------------------------------	
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar
'-------------------------------------------------------------------------------
'------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_minors.xml", "botonera"
'-------------------------------------------------------------------------------
set f_nueva = new cformulario
f_nueva.carga_parametros "m_minors.xml", "f_nueva"
f_nueva.inicializar conectar
 if minr_ncorr <> "" then
   sql ="select a.minr_ncorr, a.minr_tdesc, a.carr_ccod from minors a where cast(minr_ncorr as varchar)= '" & minr_ncorr & "'"
 else
   sql = "select '' as minr_tdesc"
 end if
'response.Write(sql)
'response.end()
f_nueva.consultar sql
f_nueva.Siguiente

%>
<html>
<head>
<title><%=Pagina.titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function Salir()
{ 
  window.close();
}

function Enviar()
{
  //document.edicion.elements["nueva[0][noti_link]"].value = document.edicion.elements["link"].value;
   
}

function validar()
{
  if (document.edicion.elements["nueva[0][minr_tdesc]"].value != "")
   {
      if (document.edicion.elements["nueva[0][carr_ccod]"].value != "")
       {
	      			  minr_tdesc = document.edicion.elements["nueva[0][minr_tdesc]"].value;
					  carr_ccod  = document.edicion.elements["nueva[0][carr_ccod]"].value;
					  minr_ncorr = '<%=minr_ncorr%>';
					
					  url = "proc_editar_minors.asp?minr_tdesc=" + minr_tdesc +"&carr_ccod=" + carr_ccod + "&minr_ncorr=" + minr_ncorr ;
					  document.edicion.method = "POST";
 				      document.edicion.action = url;
				      document.edicion.submit();

	  }
   	else
    { alert("No olvide seleccionar la carrera de la cual depende el Minors"); document.edicion.elements["nueva[0][carr_ccod]"].focus();}
  }
  else
  { alert("Debe ingresar un nombre distintivo para el Minor"); document.edicion.elements["nueva[0][minr_tdesc]"].focus();}
}

</script>

</head>
<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="570" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr> 
          <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
              <br></td>
              </tr>
            </table>
			<form action="JAVASCRIPT:Enviar();" method="post" enctype="multipart/form-data" name="edicion" id="edicion">
                <table width="100%" border="0">
				<tr> 
                    <td width="26%"><div align="right">Nombre Minor <strong><font color="#FF0000"> 
                        </font></strong></div></td>
                    <td width="4%"><div align="center">:</div></td>
                    <td width="70%"><% f_nueva.DibujaCampo("minr_tdesc")%>  
                    </td>
                  </tr>
				  <tr> 
                    <td width="26%"><div align="right">Carrera de la cual depende<strong><font color="#FF0000"> 
                        </font></strong></div></td>
                    <td width="4%"><div align="center">:</div></td>
                    <td width="70%"><% f_nueva.DibujaCampo("carr_ccod")%> 
                    </td>
                  </tr>
                 </table>
                </form>
			</td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="47%"><div align="center">
                            <%botonera.DibujaBoton "grabar"%>
                          </div></td>
                        <td width="53%"><div align="center">
                            <%botonera.DibujaBoton "cerrar_actualizar"%>
                          </div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> </td>
  </tr>
</table>
</body>
</html>
