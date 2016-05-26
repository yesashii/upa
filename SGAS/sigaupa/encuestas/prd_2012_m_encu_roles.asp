<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Asignación de encuestas a usuarios"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "m_encu_roles.xml", "botonera"
'------------------------------------------------------------------

encu_ncorr = request.querystring("busqueda[0][encu_ncorr]")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "m_encu_roles.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.AgregaCampoCons "encu_ncorr", encu_ncorr 
 f_busqueda.Siguiente
 
 

set formulario = new CFormulario
formulario.Carga_Parametros "m_encu_roles.xml", "fconsultalarga"
formulario.Inicializar conexion
if encu_ncorr  <> "" then
  consulta = " SELECT a.srol_ncorr, a.srol_ncorr as c_srol_ncorr,  " & vbcrlf & _ 
  			 "  a.srol_tdesc, "  & encu_ncorr & " as encu_ncorr, " & encu_ncorr & " as c_encu_ncorr,  " & vbcrlf & _ 
             " convert(varchar,b.srus_fmodificacion,103) as srus_fmodificacion,   " & vbcrlf & _ 
			 " case isnull(b.srol_ncorr,0)  " & vbcrlf & _ 
			 " when 0 then 0  " & vbcrlf & _ 
			 " else 1 end as tiene_rol  " & vbcrlf & _ 
			  " FROM sis_roles a, roles_encuestas b   " & vbcrlf & _ 
			  " where a.srol_ncorr *= b.srol_ncorr  " & vbcrlf & _ 
			  " and b.encu_ncorr  = " & encu_ncorr & "  " & vbcrlf & _ 
			  "ORDER BY a.srol_tdesc"
  formulario.Consultar consulta
end if

set f_datos = new CFormulario
f_datos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_datos.Inicializar conexion
if encu_ncorr  <> "" then
  consulta = " SELECT encu_tnombre as nombre, encu_ttitulo as titulo  " & vbcrlf & _ 
  			 " FROM encuestas    " & vbcrlf & _ 
			 " where cast(encu_ncorr as varchar) = '" & encu_ncorr & "'  " 
			 
  f_datos.Consultar consulta
  f_datos.siguiente
end if


'response.Write(consulta)
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
function Validar()
{
	formulario = document.buscador;	
	if (formulario.elements["busqueda[0][encu_ncorr]"].value  == '')
  	{	alert('Seleccione una encuesta a buscar.');
		return false;
    }
	return true;
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
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
        <td>&nbsp;</td>
      </tr>
    </table>
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
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="100" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
				<form name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table width="100%" border="0">
                              <tr> 
                                <td width="12%"><div align="left">Encuesta</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><% f_busqueda.dibujaCampo ("encu_ncorr") %></td>
                              </tr>
                            </table></td>
                      <td width="19%"><div align="center"><%botonera.dibujaboton "buscar"%></div></td>
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
          </td>
      </tr>
    </table>	
	<br>
<p><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Listado
                        de Roles</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; <BR>
                    <%pagina.DibujarTituloPagina%>
                    <table width="665" border="0">
                      <%if encu_ncorr <> "" then %>
					  <tr> 
                        <td colspan="3">&nbsp;</td>
                      </tr>
					  <tr> 
                        <td width="10%" align="left"><strong>Nombre</strong></td>
						<td width="1%" align="center"><strong>:</strong></td>
                        <td><%=f_datos.obtenerValor("nombre")%></td>
                      </tr>
					  <tr> 
                        <td width="10%" align="left"><strong>Título</strong></td>
						<td width="1%" align="center"><strong>:</strong></td>
                        <td><%=f_datos.obtenerValor("titulo")%></td>
                      </tr>
					  <%end if%>
                    </table>
                  </div>
                  <form name="edicion">
					<div align="center">
				      <% 
					  if encu_ncorr <> "" then%>
					  
					  <table width="665" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%formulario.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
  					<%formulario.dibujatabla
					else
					    response.Write("Debe seleccionar una encuesta antes...")
					end if%>
		              </div>
				    </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="96" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="13%"><div align="left"> 
                          <%
					  if encu_ncorr <>"" then
					  botonera.dibujaboton "actualizar"
					  end if %>
                        </div></td>
                      <td width="73%"> <div align="left"> 
                          <% botonera.dibujaboton "cancelar" %>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="266" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			
		  </td>
        </tr>
      </table>		
      </p>
	  <BR>
	</td>
  </tr>  
</table>
</body>
</html>
