<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
rut_persona = request.QueryString("personas[0][pers_nrut]")
digito_persona = request.QueryString("personas[0][pers_xdv]")

if rut_persona = "" then
  rut_persona = request.QueryString("personas[-1][pers_nrut]")
  digito_persona = request.QueryString("personas[-1][pers_xdv]")
end if

set pagina = new CPagina
pagina.Titulo = "Mantenedor de Roles de Usuario"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "Mant_Usuroles.xml", "botonera"
'botonera.agregabotonparam "agregar", "url", "Mant_UsuRoles_Edicion.asp?codigo=NUEVO"
'------------------------------------------------------------------

set f2 = new CFormulario
f2.Carga_Parametros "Mant_Usuroles.xml", "fconsulta"

f2.Inicializar conexion
if rut_persona = "" then
  consulta = "SELECT '' as pers_ncorr, '' as pers_nrut, '' as pers_xdv, '' as pers_tnombre, '' as pers_tape_paterno "
else
  consulta = "SELECT pers_ncorr, pers_nrut, pers_xdv, pers_tnombre, pers_tape_paterno FROM personas WHERE pers_nrut=" & rut_persona & " AND pers_xdv='" & digito_persona & "'"
end if
f2.consultar consulta
f2.Siguiente
correlativo = f2.obtenervalor("pers_ncorr") 
existe = f2.obtenervalor("pers_nrut")   'solo para verificar si viene vacio o no

if correlativo = "" then
  f2.Inicializar conexion
  consulta = "SELECT '' as pers_ncorr, '' as pers_nrut, '' as pers_xdv, '' as pers_tnombre, '' as pers_tape_paterno "
  f2.consultar consulta
  f2.Siguiente
  correlativo = f2.obtenervalor("pers_ncorr") 
  existe = f2.obtenervalor("pers_nrut")   'solo para verificar si viene vacio o no
end if


set f3 = new CFormulario
f3.Carga_Parametros "parametros.xml", "tabla"
f3.Inicializar conexion

if existe <> "" then 'ahora verifico si es usuario
  f3.Consultar "select pers_ncorr, susu_tlogin from sis_usuarios WHERE pers_ncorr=" & correlativo
  f3.Siguiente
  login = f3.ObtenerValor("susu_tlogin")
  if login <> "" then
    es_usuario = true
  else
    es_usuario = false
   end if 
else
  es_usuario= false
end if

'-------------------------------------------------------------

set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Usuroles.xml", "fconsultalarga"
formulario.Inicializar conexion
if es_usuario = true then
  consulta = " SELECT a.srol_ncorr, a.srol_ncorr as c_srol_ncorr,  " & vbcrlf & _ 
  			 "  a.srol_tdesc, "  & correlativo & " as pers_ncorr, " & correlativo & " as c_pers_ncorr,  " & vbcrlf & _ 
             " convert(datetime,b.srus_fmodificacion,103) as srus_fmodificacion,   " & vbcrlf & _ 
			 " case isnull(b.srol_ncorr,0)  " & vbcrlf & _ 
			 " when 0 then 0  " & vbcrlf & _ 
			 " else 1 end as tiene_rol  " & vbcrlf & _ 
			  " FROM sis_roles a, sis_roles_usuarios b   " & vbcrlf & _ 
			  " where a.srol_ncorr *= b.srol_ncorr  " & vbcrlf & _ 
			  " and b.pers_ncorr  = " & correlativo & "  " & vbcrlf & _ 
			  "ORDER BY tiene_rol desc, a.srol_tdesc asc"
  formulario.Consultar consulta
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
	rut_persona = formulario.elements["personas[0][pers_nrut]"].value + "-" + formulario.elements["personas[0][pers_xdv]"].value;	
	if (formulario.elements["personas[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_persona)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["personas[0][pers_xdv]"].focus();
		formulario.elements["personas[0][pers_xdv]"].select();
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
                                <td width="18%">Rut</td>
                                <td width="5%"> :</td>
                                <td width="77%"><%f2.DibujaCampo("pers_nrut") %> <% f2.DibujaCampo("pers_xdv") %> <a href="javascript:buscar_persona('personas[0][pers_nrut]', 'personas[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                              </tr>
                              <tr> 
                                <% if existe <> "" then %>
								<td>Nombre</td>
                                <td>:</td>
                                <td><%  nombre = f2.obtenervalor("pers_tnombre") & " " & f2.obtenervalor("pers_tape_paterno")' & " " & formulario.obtenervalor("pers_tape_materno") 
                        	    response.Write(nombre)	%> </td>
								<%end if%>
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
	<p>
	</p>
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
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%formulario.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
                  <form name="edicion">
					<div align="center">
				      <% 
					  if es_usuario = true then
  					    formulario.dibujatabla
					  else
					    response.Write("No es un Usuario del Sistema...")
					  end if
					  %>
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
					  if es_usuario = true then
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
