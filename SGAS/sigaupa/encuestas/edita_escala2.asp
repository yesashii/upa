<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
resp_ncorr = request.querystring("resp_ncorr")
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
if resp_ncorr <> "" then
   mensaje = titulo & "/Modificar Escala " 
else
   mensaje = titulo & "/Agregar Nueva Escala" 
end if
'------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "m_escala2.xml", "botonera"
'-------------------------------------------------------------------------------
set f_nueva = new cformulario
f_nueva.carga_parametros "m_escala2.xml", "f_nueva"
f_nueva.inicializar conectar
 if resp_ncorr <> "" then
   sql ="Select a.resp_ncorr, a.resp_ccod,a.resp_tabrev, a.resp_tdesc,a.resp_nnota,a.resp_bpondera,a.resp_norden from respuestas a where cast(encu_ncorr as varchar)= '" & encu_ncorr & "' and cast(resp_ncorr as varchar)='"&resp_ncorr&"'"
   pondera=conectar.consultaUno("Select resp_bpondera from respuestas where cast(encu_ncorr as varchar)='"&encu_ncorr&"' and cast(resp_ncorr as varchar)='"&resp_ncorr&"'")
 else
   sql = "select '' as resp_ccod "
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
{ //var cantidad_campos;
   //var contador;
   //var elemento;
   //cantidad_campos=document.edicion.length;
   //for(contador=0;contador<cantidad_campos;contador++)
   //{
   //elemento=document.edicion.elements[contador];
   //alert("elemento= "+elemento.name+" con valor= "+elemento.value);
   //}
   
  if (document.edicion.elements["resp_ccod"].value != "")
   {
      if (document.edicion.elements["resp_tabrev"].value != "")
       {
	      if (document.edicion.elements["resp_tdesc"].value != "")
     	   {
		     if (document.edicion.elements["resp_nnota"].value != "")
     	     {
			   if (document.edicion.elements["resp_norden"].value != "")
     	        {
            		  codigo= document.edicion.elements["resp_ccod"].value;
					  abreviatura=document.edicion.elements["resp_tabrev"].value;
					  texto = document.edicion.elements["resp_tdesc"].value;
					  nota=document.edicion.elements["resp_nnota"].value;
					  orden = document.edicion.elements["resp_norden"].value;
					  if (document.edicion.resp_bpondera[0].checked)
					  	pondera="1";
					  else 
					  	pondera="2";
					  encu_ncorr = '<%=encu_ncorr%>';
					  resp_ncorr = '<%=resp_ncorr%>';
					  url = "Proc_Editar_escala2.asp?resp_ccod=" + codigo +"&resp_tabrev="+ abreviatura + "&resp_tdesc=" + texto + "&resp_nnota="+nota+ "&resp_norden=" + orden +"&encu_ncorr=" + encu_ncorr + "&resp_ncorr=" + resp_ncorr+"&resp_bpondera="+pondera;
					  document.edicion.method = "POST";
 				      document.edicion.action = url;
				      document.edicion.submit();
				}
				else
				{
				 alert("Ingrese un número de orden correcto"); document.edicion.elements["resp_norden"].focus();}
		      }
   		     else
  	         { alert("Ingrese un valor de nota correcto"); document.edicion.elements["resp_nnota"].focus();}
	       }
     	else
       { alert("Ingrese un texto descriptivo de la escala"); document.edicion.elements["resp_tdesc"].focus();}
     }
	 else
       { alert("Ingrese una abreviatura correcta"); document.edicion.elements["resp_tabrev"].focus();}
     }
  else
  { alert("Ingrese el código del escala"); document.edicion.elements["resp_ccod"].focus();}
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
                    <td colspan="3"> <strong><%=mensaje%></strong> </td>
                  </tr>
                  <tr> 
                    <td colspan="3"><br> </td>
                  </tr>
                  <tr> 
                    <td width="26%"><div align="right">C&oacute;digo<strong><font color="#FF0000"> 
                        </font></strong></div></td>
                    <td width="4%"><div align="center">:</div></td>
                    <td width="70%"><input name="resp_ccod" type="text" value='<%=f_nueva.obtenerValor("resp_ccod")%>' size="15" maxlength="10"> 
                    </td>
                  </tr>
                  <tr> 
                    <td width="26%"><div align="right">Abrev.<strong><font color="#FF0000"> 
                        </font></strong></div></td>
                    <td width="4%"><div align="center">:</div></td>
                    <td width="70%"><input name="resp_tabrev" type="text" value='<%=f_nueva.obtenerValor("resp_tabrev")%>' size="5" maxlength="4"> 
                    </td>
                  </tr>
                  <tr> 
                    <td width="26%"><div align="right">Texto<strong><font color="#FF0000"> 
                        </font></strong></div></td>
                    <td width="4%"><div align="center">:</div></td>
                    <td width="70%"><input name="resp_tdesc" type="text" value='<%=f_nueva.obtenerValor("resp_tdesc")%>' size="60" maxlength="50"> 
                    </td>
                  </tr>
				  <tr> 
                    <td width="26%"><div align="right">Nota<strong><font color="#FF0000"> 
                        </font></strong></div></td>
                    <td width="4%"><div align="center">:</div></td>
                    <td width="70%"><input name="resp_nnota" type="text" value='<%=f_nueva.obtenerValor("resp_nnota")%>' size="4" maxlength="3"> 
                    </td>
                  </tr>
				  <tr> 
                    <td width="26%"><div align="right">Pondera<strong><font color="#FF0000"> 
                        </font></strong></div></td>
                    <td width="4%"><div align="center">:</div></td>
                    <td width="70%">
					<%if pondera<>"" then
					    if pondera="1" then%>
						<input type="Radio" name="resp_bpondera" value="1" checked> Si
						<input type="Radio" name="resp_bpondera" value="2" >No
						<%else%>
						<input type="Radio" name="resp_bpondera" value="1" >Si
						<input type="Radio" name="resp_bpondera" value="2" checked> No
						<%end if
					else%>
					<input type="Radio" name="resp_bpondera" value="1" checked> Si
					<input type="Radio" name="resp_bpondera" value="2" >No
					<%end if%> 
                    </td>
                  </tr>
                  <tr> 
                    <td><div align="right">Orden</div></td>
                    <td><div align="center">:</div></td>
                    <td> <input name="resp_norden" type="text" id="resp_norden" size="2" maxlength="2" value='<%=f_nueva.obtenerValor("resp_norden")%>'> 
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
