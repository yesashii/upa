<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------
set botonera = new Cformulario
botonera.Carga_Parametros "m_personas_especialidades.xml", "botonera"

'---------- IP DE PRUEBA ----------
ip_usuario = Request.ServerVariables("REMOTE_ADDR")
'response.Write("ip_usuario = "&ip_usuario&"</br>") 
ip_de_prueba = "172.16.100.91"
'----------------------------------

'------------------------------------------------------- --------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "m_personas_especialidades.xml", "fconsulta"

c_carr = request.QueryString("personas[0][carr_ccod]")
c_sede = request.QueryString("personas[0][sede_ccod]")

if ip_usuario = ip_de_prueba then
response.Write("ip_usuario = "&ip_usuario&"</br>") 
response.Write("c_carr = "&c_carr&"</br>") 
response.Write("c_sede = "&c_sede&"</br>") 
'response.Write("XXXXX = "&XXXXX&"</br>") 
'response.Write("XXXXX = "&XXXXX&"</br>") 
'response.Write("XXXXX = "&XXXXX&"</br>") 
'response.Write("XXXXX = "&XXXXX&"</br>") 
'response.Write("XXXXX = "&XXXXX&"</br>") 
'response.Write("XXXXX = "&XXXXX&"</br>") 
end if

rut_persona = request.QueryString("rut")
digito_persona = request.QueryString("digito")
pers_ncorr = conexion.ConsultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='" & rut_persona & "'")
'response.Write("pers_ncorr= " & pers_ncorr)
if rut_persona = "" then
  rut_persona = request.QueryString("busqueda[-1][pers_nrut]")
  digito_persona = request.QueryString("busqueda[-1][pers_xdv]")
end if


set persona = new CPersona
persona.Inicializar conexion, rut_persona
'response.Write("pers_ncorr = " & persona.ObtenerPersNCorr & "<BR><BR>")

'response.Write(rut_persona & "-" & digito_persona)

formulario.Inicializar conexion

 if persona.ObtenerPersNCorr <> "" then
   consulta ="select '" & c_carr &"' as carr_ccod,'" & c_sede &"' as sede_ccod ,PERS_NCORR, PERS_NRUT, pers_xdv, PERS_TNOMBRE, PERS_TAPE_PATERNO, PERS_TAPE_MATERNO, PERS_NCORR as C_PERS_NCORR from personas WHERE cast(PERS_NRUT as varchar)='" & rut_persona & "'"
 else
   if rut_persona <> "" then
      session("mensajeError")= "Persona no ingresada..."
   end if
	 consulta = "select ''  as PERS_NCORR, '' as PERS_NRUT, '' as pers_xdv, '' as PERS_TNOMBRE, '' as PERS_TAPE_PATERNO, '' as PERS_TAPE_MATERNO, '' as C_PERS_NCORR "
 end if 
 'response.Write(consulta)
 formulario.Consultar consulta
 
 periodo_actual = negocio.ObtenerPeriodoAcademico("Postulacion")


 
 consulta = "SELECT a.sede_ccod, a.sede_tdesc ,c.carr_ccod, carr_tdesc " & vbcrlf & _
            " FROM sedes a, sis_sedes_usuarios b, carreras c, ofertas_Academicas d, especialidades e " & vbcrlf & _  
			" WHERE a.sede_ccod = b.sede_ccod " & vbcrlf & _  
        	" AND b.pers_ncorr  =cast(cast('" & pers_ncorr & "' as real) as numeric) " & vbcrlf & _
			" and d.peri_ccod=" & periodo_actual & vbcrlf & _
        	" and a.sede_ccod = d.sede_ccod " & vbcrlf & _
        	" and d.espe_ccod=e.espe_ccod " & vbcrlf & _ 
        	" and e.carr_ccod=c.carr_ccod  "& vbcrlf & _
			" UNION "& vbcrlf & _
			" select a.sede_ccod, max(a.sede_tdesc), '', '* Todas' "& vbcrlf & _
 	        " FROM sedes a, sis_sedes_usuarios b, carreras c, ofertas_Academicas d, especialidades e " & vbcrlf & _  
			" WHERE a.sede_ccod = b.sede_ccod " & vbcrlf & _  
        	" AND b.pers_ncorr  =cast(cast('" & pers_ncorr & "' as real) as numeric) " & vbcrlf & _
			" and d.peri_ccod=" & periodo_actual & vbcrlf & _
        	" and a.sede_ccod = d.sede_ccod " & vbcrlf & _
        	" and d.espe_ccod=e.espe_ccod " & vbcrlf & _ 
			" group by a.sede_ccod " & vbcrlf & _ 
			" order by a.sede_tdesc, carr_tdesc asc"

 formulario.inicializaListaDependiente "lBusqueda", consulta
 
'response.Write("<BR><BR>Existe:" & consulta)
  
 formulario.siguiente
 correlativo = formulario.obtenervalor("pers_ncorr") 
 existe = formulario.obtenervalor("pers_nrut")    'solo para verificar si viene vacio o no
 'response.Write("<BR><BR>Existe:" & existe)
 'response.End()
'-------------------------------------------------------------------
  set f_sedes = new CFormulario
  f_sedes.Carga_Parametros "m_personas_especialidades.xml", "f_sedes_usuario"
  f_sedes.Inicializar conexion 
   
  if existe <> "" then 

	  if c_carr<>""then
		v_filtro_carrera= " and cast(c.carr_ccod as varchar)='" & c_carr & "' "
		v_filtro_optativos= " union " & vbcrlf & _
							" select c.espe_tdesc, '--' as jorn_tdesc,1 as jorn_ccod,c.espe_ccod, '" & pers_ncorr & "' as pers_ncorr " & vbcrlf & _
							" from especialidades c " & vbcrlf & _
							" where cast(carr_ccod as varchar)='" & c_carr & "' " & vbcrlf & _
							" and cast(c.espe_nplanificable as varchar)='2' " & vbcrlf & _
							" and not exists (Select 1 from sis_especialidades_usuario x  " & vbcrlf & _
							"              where cast(pers_ncorr as varchar)='" & pers_ncorr & "' and x.espe_ccod=c.espe_ccod  " & vbcrlf & _
							"             and x.jorn_ccod=1)"	
	  end if
 

 
   sql = " Select distinct espe_tdesc, " & vbcrlf & _
          " case a.jorn_ccod " & vbcrlf & _
          "  when 1 then 'DIURNO' " & vbcrlf & _
          "  when 2 then 'VESPERTINO' " & vbcrlf & _
          "  end as jorn_tdesc, a.jorn_ccod,b.espe_ccod,'" & pers_ncorr & "' as pers_ncorr " & vbcrlf & _
		  " from ofertas_Academicas a, especialidades b, carreras c " & vbcrlf & _
		  " where cast(a.sede_ccod as varchar)='" & c_sede & "' " & vbcrlf & _
          " and a.peri_ccod=" & periodo_actual & vbcrlf & _
          " and a.espe_ccod=b.espe_ccod " & vbcrlf & _
          " and b.carr_ccod=c.carr_ccod " & vbcrlf & _
          " " & v_filtro_carrera & " " &vbcrlf & _
          " and not exists (Select 1 from sis_especialidades_usuario x  " & vbcrlf & _
          "              where cast(pers_ncorr as varchar)='" & pers_ncorr & "' and x.espe_ccod=a.espe_ccod  " & vbcrlf & _
          "             and x.jorn_ccod=a.jorn_ccod) " & vbcrlf & _
		  " " & v_filtro_optativos & " " 
		  
else
	sql="Select '' where 1=2"					
end if	 
 'response.Write("<pre>"&sql&"</pre>")
  f_sedes.Consultar sql


%>


<html>
<head>
<title>Permisos para Especialidades</title>
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
	rut_alumno = formulario.elements["personas[0][pers_nrut]"].value + "-" + formulario.elements["personas[0][pers_xdv]"].value;	
	if (formulario.elements["personas[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["personas[0][pers_xdv]"].focus();
		formulario.elements["personas[0][pers_xdv]"].select();
		return false;
	  }
	  		
	return true;
}
</script>
<% formulario.generaJS %>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="600" height="380" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
		<table width="60%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="500" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="500" height="8" border="0" alt=""></td>
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
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="500" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td width="400" bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%" height="82"><table width="100%" border="0">
                              <tr> 
                                <td width="21%">Rut</td>
                                <td width="7%">:<input type="hidden" name="rut" value="<%=rut_persona%>">
								<input type="hidden" name="digito" value="<%=digito_persona%>"></td>
                                <td width="72%"><%formulario.DibujaCampo("pers_nrut") %>-<% formulario.DibujaCampo("pers_xdv") %></td>
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
							  <tr> 
                                <td width="21%">Sede</td>
                                <td width="7%">:</td>
                                <td width="72%"><% formulario.dibujaCampoLista "lBusqueda", "sede_ccod"%><% 'botonera.dibujaboton "buscar" %></td>
                              </tr>
							  <tr> 
                                <td width="21%">Carrera</td>
                                <td width="7%">:</td>
                                <td width="72%"><% formulario.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="21%"></td>
                                <td width="7%"></td>
                                <td width="72%" align="right"><% botonera.dibujaboton "buscar" %></td>
                              </tr>
                            </table>
</td>
                      <td ><div align="center"><% 'botonera.dibujaboton "buscar" %>
                        </div></td>
                    </tr>
                  </table>
				  </form>
                </div></td>
                <td width="16" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="500" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
<BR>
	<table width="60%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="500" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="500" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Especialidades</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="500" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="left" background="../imagenes/izq.gif"></td>
                <td bgcolor="#D8D8DE" align="right"><%f_sedes.accesopagina()%></td>
                <td align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
			  <tr> 
                <td width="9" align="left" background="../imagenes/izq.gif"></td>
                <td bgcolor="#D8D8DE"> <form name="edicion">
                    <div align="center"><BR>
                      <% 
					 f_sedes.dibujatabla
					  %>
                      <BR>
                    </div>
                  </form></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center">
					  <%
					    if f_sedes.nroFilas = 0 then
					      botonera.agregabotonparam "guardar", "deshabilitado", "TRUE"
						else
                          botonera.agregabotonparam "guardar", "deshabilitado", "FALSE"
						end if
						botonera.agregabotonparam "guardar", "url", "proc_personas_especialidades_agregar.asp"
						botonera.dibujaboton "guardar"
					  %></div></td>
                      <td><div align="center"><%'pagina.DibujarBoton "Eliminar", "ELIMINAR-edicion", "eliminar.asp" %></div></td>
                      <td><div align="center">
                        <%pagina.DibujarBoton "Cancelar", "CERRAR", "" %>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
