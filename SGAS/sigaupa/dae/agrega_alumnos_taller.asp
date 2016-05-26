<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut =Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_tdsi_ncorr =Request.QueryString("tdsi_ncorr")
pagi1 =Request.QueryString("pagi")
pagi2 =Request.QueryString("b[0][pagi]")
z_tdsi_ncorr =Request.QueryString("b[0][tdsi_ncorr]")
'

'---------------------------------------------------------------------------------------------------
set errores= new CErrores
set pagina = new CPagina
pagina.Titulo = ""

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "agrega_alumnos_taller.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "agrega_alumnos_taller.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "agrega_alumnos_taller.xml", "ingreso"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "agrega_alumnos_taller.xml", "cheques"
f_cheques.Inicializar conexion

if pagi1="" then
pagi=pagi2
end if
if pagi2="" then
pagi=pagi1
end if



if q_pers_nrut="" then
sql_descuentos=  "select ''"
f_cheques.Consultar sql_descuentos
else
 
if q_tdsi_ncorr="" and z_tdsi_ncorr <> "" then
x_tdsi_ncorr=z_tdsi_ncorr
elseif q_tdsi_ncorr <> "" and z_tdsi_ncorr ="" then
x_tdsi_ncorr=q_tdsi_ncorr
end if

sql_descuentos="select pers_ncorr , '"&x_tdsi_ncorr&"' as tdsi_ncorr ,'"&pagi&"' as pagi,pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre  from personas where pers_nrut="&q_pers_nrut&""


					
response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()

f_cheques.Consultar sql_descuentos
'f_busqueda.Siguiente
end if

set f_listado = new CFormulario
f_listado.Carga_Parametros "agrega_alumnos_taller.xml", "listado"
f_listado.Inicializar conexion


if q_tdsi_ncorr="" and z_tdsi_ncorr <> "" then
x_tdsi_ncorr=z_tdsi_ncorr
end if
if q_tdsi_ncorr <> "" and z_tdsi_ncorr ="" then
x_tdsi_ncorr=q_tdsi_ncorr
end if

sql_lista="select pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre from personas a, alumnos_talleres_psicologia b where  a.pers_ncorr=b.pers_ncorr and tdsi_ncorr= "&x_tdsi_ncorr&" "

					
'response.Write("<pre>"&sql_listas&"</pre>")
'response.Write("<pre>pers_ncorr="&q_pers_ncorr&"</pre>")
'response.Write("<pre>q_tdsi_ncorr="&q_tdsi_ncorr&"</pre>")
'response.End()

f_listado.Consultar sql_lista



'response.Write("<pre>pagi="&pagi&"</pre>")

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
function Validar_rut_papa()
{
	formulario = document.buscador;
	rut_alumno = formulario.elements["b[0][pers_nrut]"].value + "-" + formulario.elements["b[0][pers_xdv]"].value;	
	if (formulario.elements["b[0][pers_nrut]"].value  != ''){
	  	  if (!valida_rut(rut_alumno)) {
		  alert("Ingrese un RUT válido");
		formulario.elements["b[0][pers_nrut]"].focus();
		formulario.elements["b[0][pers_nrut]"].select();
		return false;
	  }
	}

	return true;
}



</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
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
            <td><%pagina.DibujarLenguetas Array("Agrega Alumnos"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
			<input type="hidden" name="b[0][tdsi_ncorr]" value="<%=q_tdsi_ncorr%>">
			<input type="hidden" name="b[0][pagi]" value="<%=pagi%>">
              <br>
              <table width="74%"  border="0" align="center">
                <tr>
					
					<td width="18%"><strong>Rut  :</strong></td>
					
					<td width="10%"><div align="center"><%f_busqueda.DibujaCampo("pers_nrut")%></div></td>
					<td width="4%">-</td>
					<td width="5%"><div align="center"><%f_busqueda.DibujaCampo("pers_xdv")%>
					</div></td>
					<td width="7%"><%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
                  	<td width="42%"></div></td>
					<td width="14%"><div align="center"><%f_botonera.DibujaBoton("agregar")%></div></td
					></tr>
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
            <td>&nbsp;</td>
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
                    <td><%pagina.DibujarSubtitulo "Nombre Alumno"%>
					
                      <table width="98%"  border="0" align="center">
					  
                            <tr>						
                                <td align="center">
						       <%f_cheques.DibujaTabla()%>
							   </td>
						  
                        </tr>
                      </table>
					   <br><%pagina.DibujarSubtitulo "Listado de Alumnos Inscritos"%>
					   
					     <table width="98%"  border="0" align="center">
					   <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_listado.accesopagina%>
                             </td>
                            </tr>
                            <tr>						
                                <td align="center">
						       <%f_listado.DibujaTabla()%>
							   </td>
						  
                        </tr>
                      </table>
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
            <td width="31%" height="20"><div align="center">
              <table width="41%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                
                  <td><div align="left"><%f_botonera.DibujaBoton("salir")%></div></td>
				  
				  <td><div align="left"><%f_botonera.DibujaBoton("guardar")%></div></td>
				  
				   <td><div align="left"><%if pagi="2" then
				   f_botonera.AgregaBotonParam "volver", "url", "edicion_alumnos_talleres.asp?tdsi_ncorr="&x_tdsi_ncorr&""
				   f_botonera.DibujaBoton("volver")
				   end if%></div></td>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>