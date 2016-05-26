<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
'-----------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------------------
set botonera = new Cformulario
botonera.Carga_Parametros "Mant_Cajeros.xml", "botonera"

'-----------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Cajeros.xml", "busqueda"

rut_persona = request.QueryString("busqueda[0][pers_nrut]")
digito_persona = request.QueryString("busqueda[0][pers_xdv]")

if rut_persona = "" then
  rut_persona = request.QueryString("busqueda[-1][pers_nrut]")
  digito_persona = request.QueryString("busqueda[-1][pers_xdv]")
end if


set persona = new CPersona
persona.Inicializar conexion, rut_persona
formulario.Inicializar conexion

if persona.ObtenerPersNCorr <> "" then
   consulta ="select PERS_NCORR, PERS_NRUT, pers_xdv, PERS_TNOMBRE, PERS_TAPE_PATERNO, PERS_TAPE_MATERNO, PERS_NCORR as C_PERS_NCORR from personas WHERE PERS_NRUT='" & rut_persona & "'"
 else
   if rut_persona <> "" then
      session("mensajeError")= "Persona no ingresada..."
   end if
	 consulta = "select '' as PERS_NCORR, '' as PERS_NRUT, '' as pers_xdv, '' as PERS_TNOMBRE, '' as PERS_TAPE_PATERNO, '' as PERS_TAPE_MATERNO, '' as C_PERS_NCORR from dual"
 end if 
' response.Write(consulta)
 formulario.Consultar consulta
 formulario.siguiente
 correlativo = formulario.obtenervalor("pers_ncorr") 
 existe = formulario.obtenervalor("pers_nrut")    'solo para verificar si viene vacio o no
'-------------------------------------------------------------------

  set f_datos = new CFormulario
  f_datos.Carga_Parametros "Mant_Cajeros.xml", "f_edicion"
  f_datos.Inicializar conexion
 

  'set f2 = new CFormulario
  'f2.Carga_Parametros "Mant_Usuarios.xml", "f1_edicion"
  'f2.Inicializar conexion
  
  'if existe <> "" then
   ' consulta= "select pers_ncorr, pers_ncorr as c_pers_ncorr, susu_tlogin, susu_tclave from sis_usuarios where pers_ncorr =" & correlativo
	'f2.Consultar consulta
   ' f2.siguiente
   ' login = f2.obtenervalor("susu_tlogin")
	'if login = "" then
	'  consulta = "select " & correlativo & " as PERS_NCORR, '' as susu_tlogin, '' as susu_tclave, " & correlativo & " as C_PERS_NCORR from dual"
    '  f2.Consultar consulta
   '   f2.siguiente
   ' end if
   ' f2.AgregaCampoCons "susu_fmodificacion", date()
 ' end if


  set f_sedes = new CFormulario
  f_sedes.Carga_Parametros "Mant_cajeros.xml", "f_sedes_cajero"
  f_sedes.Inicializar conexion 
      
  if existe <> "" then
	sql = "SELECT decode (c.sede_ccod,'', '0','1') as tiene_sede, b.pers_ncorr, a.sede_ccod, "&_ 
			     "a.sede_tdesc, a.SEDE_TCALLE || ' ' || a.SEDE_TNRO as direccion_sede  "&_
		  "FROM sedes a, sis_sedes_usuarios b, cajeros c  "&_
		  "WHERE a.sede_ccod = b.sede_ccod   "&_
		    "and b.pers_ncorr = c.pers_ncorr (+) "&_
		    "and b.sede_ccod = c.sede_ccod (+) "&_
		    "AND b.pers_ncorr (+) ='" & persona.ObtenerPersNCorr & "'"
 else
    sql = "select '' from dual where 1=2 "
 end if	   

f_sedes.Consultar sql

%>


<html>
<head>
<title>Mantenedor de Cajeros</title>
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
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	  		
	return true;
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="500" height="380" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<BR><BR>
	<table width="51%" border="0" align="center" cellpadding="0" cellspacing="0">
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
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="400" height="8" border="0" alt=""></td>
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
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="400" height="2" border="0" alt=""></td>
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
                      <td width="81%" height="82"><table width="100%" border="0">
                              <tr> 
                                <td width="21%">Rut</td>
                                <td width="7%">:</td>
                                <td width="72%"><%formulario.DibujaCampo("pers_nrut") %>
                                  - 
                                  <% formulario.DibujaCampo("pers_xdv") %> </td>
                              </tr>
                              <tr> 
                                <% if existe <> "" then%>
                                <td>Nombre</td>
                                <td>:</td>
                                <td><%  nombre = formulario.obtenervalor("pers_tnombre") & " " & formulario.obtenervalor("pers_tape_paterno")' & " " & formulario.obtenervalor("pers_tape_materno") 
	    response.Write(nombre)
	'formulario.DibujaCampo("pers_tnombre") %> </td>
                                <%end if%>
                              </tr>
                            </table>
</td>
                      <td width="19%"><div align="center"><% botonera.dibujaboton "buscar" %>
                        <%  'pagina.DibujarBoton "Cancelar", "CERRAR", ""
						'botonera.dibujaboton "cancelar"	 %>
                      </div></td>
                    </tr>
                  </table>
				  </form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="400" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
<BR>
	<table width="51%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          del Cajero</font></div></td>
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
                  <td width="9" align="left" background="../imagenes/izq.gif"></td>
                  <td bgcolor="#D8D8DE">
				    
				    <form name="edicion"><BR>
                    <BR>
                    <%pagina.DibujarSubtitulo "Sedes asociadas al Cajero"%>
                    <div align="center"><BR>
                      <br>
                     <% f_sedes.dibujatabla %> <BR>
                    </div>
                  </form>
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="108" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center">
					  <%
					    if existe <> "" then
					      botonera.agregabotonparam "guardar_nuevo_cajero", "deshabilitado", "FALSE"
						else
                          botonera.agregabotonparam "guardar_nuevo_cajero", "deshabilitado", "TRUE"
						end if
						  botonera.dibujaboton "guardar_nuevo_cajero"
					  %>
					  </div></td>
                      <td><div align="center"><%'pagina.DibujarBoton "Eliminar", "ELIMINAR-edicion", "eliminar.asp" %></div></td>
                      <td><div align="center">
                        <%pagina.DibujarBoton "Cancelar", "CERRAR", "" %>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="120" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="179" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			
		  </td>
        </tr>
      </table>
    <br>
    <p></p>		
	</td>
  </tr>  
</table>
</body>
</html>
