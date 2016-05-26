<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
mcol_ncorr = Request.QueryString("codigo")

set pagina = new CPagina
pagina.Titulo = "Mantener Categoria Colacion"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

peri_ccod = negocio.obtenerPeriodoAcademico("PLANIFICACION")
anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
'------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "colacion_docentes.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "colacion_docentes.xml", "f1_edicion"
formulario.Inicializar conexion

if mcol_ncorr = "NUEVO" then
  mcol_ncorr = conexion.consultauno("exec ObtenerSecuencia 'colacion'")
  consulta = "select "&mcol_ncorr&" as mcol_ncorr, '' as mcol_tdesc "
else
  consulta = "select * from monto_colacion where mcol_ncorr = " & mcol_ncorr
end if
formulario.Consultar consulta
formulario.Siguiente

%>


<html>
<head>
<title>Mantenedor de Roles</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="540" border="0" align="center" cellpadding="0" cellspacing="0">
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	    <p><br>		
     
	 </p><table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="400" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="400" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">
	 					<% 
	  						if mcol_ncorr = "NUEVO" then
        						Response.Write("Agrege la Nueva Categoria <BR>")
      						else
        						Response.Write("Modifique la Categoria <BR>") 
      						end if    
      						
   						%>
	  					</font></div></td>
                       <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="400" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; <BR>
                    <%pagina.DibujarTituloPagina%>
                  </div>
                  <form name="edicion">
                    <table width="99%" border="0">
                      <tr> 
                        <td width="14%"> <div align="right"><strong> 
                            <%formulario.DibujaCampo("mcol_ncorr") %>
                            Categoria </strong></div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="79%"> <%formulario.DibujaCampo("mcol_tdesc")  %> </td>					
                      </tr>
                      <tr> 
                        <td width="14%"> <div align="right"><strong> 
                            Valor</strong></div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="79%"> <%formulario.DibujaCampo("mcol_mmonto")  %> </td>					
                      </tr>
					  <tr> 
                        <td width="14%"> <div align="right"><strong> 
                            Año</strong></div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="79%"> <%=anos_ccod%> </td>					
                      </tr>	
                    </table>
                    </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="176" bgcolor="#D8D8DE"> 
                    <table width="58%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="32%"><%'pagina.DibujarBoton "Aceptar", "GUARDAR-edicion", "Proc_Mant_Roles_Edicion.asp"
						botonera.dibujaboton "guardar"%>
                        <td width="32%"><%'pagina.DibujarBoton "Cancelar", "CERRAR", ""
						botonera.dibujaboton "cancelar"%>
                      </tr>
                    </table>
</td>
                  <td width="47" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="184" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		    <p><br>
            </p>
            <p>&nbsp; </p></td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
