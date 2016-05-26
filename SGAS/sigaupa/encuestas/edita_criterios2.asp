<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
crit_ncorr = request.querystring("crit_ncorr")
encu_ncorr = request.querystring("encu_ncorr")

set pagina = new CPagina


'---------------------------------------------------------------------------------------------------
'----------------------------------------------------------	
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar
'-------------------------------------------------------------------------------
titulo=conectar.consultaUno("Select encu_tnombre from encuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"'")
if crit_ncorr <> "" and not esVacio(crit_ncorr) then
   mensaje = titulo & "/Modificar Críterios " 
else
   mensaje = titulo & "/Agregar Nuevo Criterio" 
end if
'------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_criterios.xml", "botonera"
'-------------------------------------------------------------------------------
set f_nueva = new cformulario
f_nueva.carga_parametros "m_criterios.xml", "f_nueva"
f_nueva.inicializar conectar
 if crit_ncorr <> "" then
   sql ="Select a.crit_ncorr, a.crit_ccod, a.crit_tdesc, a.crit_norden from criterios a where cast(encu_ncorr as varchar)= '" & encu_ncorr & "' and cast(crit_ncorr as varchar)='"&crit_ncorr&"'"
 else
   sql = "select '' as crit_ccod"
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

function validar()
{
  if (document.edicion.elements["crit_ccod"].value != "")
   {
      if (document.edicion.elements["crit_tdesc"].value != "")
       {
	      if (document.edicion.elements["crit_norden"].value != "")
     	   {
            		  codigo= document.edicion.elements["crit_ccod"].value;
					  texto = document.edicion.elements["crit_tdesc"].value;
					  orden = document.edicion.elements["crit_norden"].value;
					  encu_ncorr = '<%=encu_ncorr%>';
					  crit_ncorr = '<%=crit_ncorr%>';
					
					  url = "proc_Editar_criterios2.asp?crit_ccod=" + codigo + "&crit_tdesc=" + texto + "&crit_norden=" + orden +"&encu_ncorr=" + encu_ncorr + "&crit_ncorr=" + crit_ncorr;
					  document.edicion.method = "POST";
 				      document.edicion.action = url;
				      document.edicion.submit();
         }
   		else
  	   { alert("Ingrese un número de orden correcto"); document.edicion.elements["crit_norden"].focus();}
	 }
   	else
    { alert("Ingrese el un texto descriptivo del críterio"); document.edicion.elements["crit_tdesc"].focus();}
  }
  else
  { alert("Ingrese el código del críterio"); document.edicion.elements["crit_ccod"].focus();}
}

</script>


</head>
<body bgcolor="#EBEBEB" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="600" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
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
           </table>
			<div align="center"><br>
              <br>
              <form action="JAVASCRIPT:Enviar();" method="post" enctype="multipart/form-data" name="edicion" id="edicion">
                <table width="100%" border="0">
				<tr>
					<td colspan="3">
					<strong><%=mensaje%></strong>
					</td>
				</tr>
				<tr>
					<td colspan="3"><br>
					</td>
				</tr>
				<tr> 
                    <td width="26%"><div align="right">C&oacute;digo<strong><font color="#FF0000"> 
                        </font></strong></div></td>
                    <td width="4%"><div align="center">:</div></td>
                    <td width="70%"><input name="crit_ccod" type="text" value='<%=f_nueva.obtenerValor("crit_ccod")%>' size="15" maxlength="10"> 
                    </td>
                  </tr>
				  <tr> 
                    <td colspan="3"><div align="center"> </div></td>
                  </tr>
                  <tr> 
                    <td><div align="right">Texto</div></td>
                    <td><div align="center">:</div></td>
                    <td><textarea name="crit_tdesc" cols="70" rows="2" id="resumen"><%=f_nueva.obtenerValor("crit_tdesc")%></textarea> 
                    </td>
                  </tr>
				  <tr> 
                    <td colspan="3"><div align="center"> </div></td>
                  </tr>
                  
                  <tr> 
                    <td><div align="right">Orden</div></td>
                    <td><div align="center">:</div></td>
                    <td> <input name="crit_norden" type="text" id="crit_norden" size="2" maxlength="2" value='<%=f_nueva.obtenerValor("crit_norden")%>'>
					 </td>
                  </tr>
				</table>
                </form>
            </div>
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
