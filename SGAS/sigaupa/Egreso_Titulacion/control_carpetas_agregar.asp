<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
pers_ncorr= request.QueryString("pers_ncorr")
carr_ccod= request.QueryString("carr_ccod")

'response.Write("lalalal")
'response.End()

set pagina = new CPagina
pagina.Titulo = "Control Carpeta de Título"

set botonera =  new CFormulario
botonera.carga_parametros "control_carpetas.xml", "btn_edita_carpeta"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

rut = conexion.consultaUno("Select cast(pers_nrut as varchar)+ '-'+pers_xdv  from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
nombre = conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno  from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "control_carpetas.xml", "edicion_carpeta"
formulario.inicializar conexion
if carr_ccod <> "" and pers_ncorr <> "" then
	consulta=  " select a.pers_ncorr,a.carr_ccod,protic.trunc(fecha_envio) as fecha_envio, " & vbCrlf & _
			   " p1.pers_tnombre + ' ' + p1.pers_tape_paterno as enviada_por2, a.enviada_por, " & vbCrlf & _
			   " p2.pers_tnombre + ' ' + p2.pers_tape_paterno as recepcionada_por2, a.recepcionada_por, " & vbCrlf & _
			   " protic.trunc(fecha_recepcion) as fecha_recepcion,observacion " & vbCrlf & _
			   " from carpetas_titulo a join personas p1  " & vbCrlf & _
			   "	on  a.enviada_por = p1.pers_nrut  " & vbCrlf & _
			   " left outer join personas p2  " & vbCrlf & _
			   "	on  a.recepcionada_por = p2.pers_nrut  " & vbCrlf & _
			   " where cast(a.pers_ncorr as varchar)= '"&pers_ncorr&"' and a.carr_ccod= '"&carr_ccod&"'" 

else
   usuario_sesion = negocio.obtenerUsuario
   enviada_por2 = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno from personas where cast(pers_nrut as varchar)='"&usuario_sesion&"'")
   consulta = "select '"&pers_ncorr&"' as pers_ncorr, '"&usuario_sesion&"' as enviada_por,'"&enviada_por2&"' as enviada_por2 "
   enviada_por = usuario_sesion
end if		   

'response.write("<pre>"&consulta&"</pre>")
'response.Write("pers_ncorr "&pers_ncorr)
'response.End()
formulario.consultar consulta 

consulta_carreras = "(select distinct d.carr_ccod,d.carr_tdesc " & vbCrlf & _
					" from alumnos a, ofertas_academicas b, especialidades c, carreras d " & vbCrlf & _
					" where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrlf & _
					" and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod " & vbCrlf & _
					" and a.emat_ccod in (1,2,4,8,10,13))a"

formulario.agregaCampoParam "carr_ccod","destino",consulta_carreras
if carr_ccod = "" then
	formulario.agregacampoparam "fecha_recepcion","deshabilitado","true"
	formulario.agregacampoparam "fecha_recepcion","id","FE-S"
end if

if carr_ccod <> "" and pers_ncorr <> "" then
	existe_carpeta = conexion.consultaUno("select case isnull(cast(fecha_recepcion as varchar),'N') when 'N' then 'N' else 'S' end from carpetas_titulo where cast(carr_ccod as varchar)='"&carr_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
    'response.Write("select case isnull(cast(fecha_recepcion as varchar),'N') when null then 'N' else 'S' end from carpetas_titulo where cast(carr_ccod as varchar)='"&carr_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
	'response.Write("Existe carpeta "&existe_carpeta)
	if existe_carpeta = "N" then
		usuario_sesion = negocio.obtenerUsuario
        recepcionada_por2 = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno from personas where cast(pers_nrut as varchar)='"&usuario_sesion&"'")
        
		formulario.agregaCampoParam "fecha_recepcion","deshabilitado","false"
		formulario.agregacampoparam "fecha_recepcion","id","FE-N"
		formulario.agregaCampoCons  "recepcionada_por",usuario_sesion
		formulario.agregaCampoCons  "recepcionada_por2",recepcionada_por2
		formulario.agregaCampoParam "fecha_envio","deshabilitado","true"
		formulario.agregaCampoParam "enviada_por","deshabilitado","true"

    else
	    formulario.agregaCampoParam "fecha_envio","deshabilitado","true"
		formulario.agregaCampoParam "enviada_por","deshabilitado","true"
		formulario.agregaCampoParam "fecha_recepcion","deshabilitado","true"
		formulario.agregaCampoParam "recepcionada_por","deshabilitado","true"
		formulario.agregacampoparam "fecha_envio","id","FE-S"
		formulario.agregacampoparam "fecha_recepcion","id","FE-S"
		botonera.agregaBotonParam "guardar","deshabilitado","true"
    end if

end if

formulario.siguiente

lenguetas_carpetas = Array(Array("Carpeta de Título", "control_carpetas_agregar.asp?pers_ncorr="&pers_ncorr))

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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function guardar(formulario){
	if(preValidaFormulario(formulario)){	
    	formulario.action ='proc_control_carpetas_agregar.asp';
		formulario.submit();
	}
}
function volver(){
	window.navigate("busca_asignaturas.asp?asig_ccod="+"<%=codigo%>")
}

function validaCambios(){
	alert("..");
	return false;
}

</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "m[0][fecha_envio]","1","edicion","fecha_oculta_fecha_envio"
	calendario.MuestraFecha "m[0][fecha_recepcion]","2","edicion","fecha_oculta_fecha_recepcion"
	calendario.FinFuncion
	
%>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>

<table width="550" border="0" align="center" cellpadding="0" cellspacing="0">
   <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
            <td><%pagina.DibujarLenguetas lenguetas_carpetas, 1%> </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              <form name="edicion" method="post"><table width="100%"  border="0">
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>
 				</table>
                <table width="90%" align="center">
                      <tr> 
                        <td width="29%"><strong>RUT Alumno</strong></td>
                        <td width="61%">:<%=rut%></td>
                      </tr>
                      <tr> 
                        <td><strong>Nombre Alumno</strong></td>
                        <td>:<%=nombre%>
							<%'if carr_ccod = "" then%>
							   <input type="hidden" name="m[0][pers_ncorr]" value="<%=pers_ncorr%>">
							<%'end if%>
						</td>
                      </tr>
					  <tr> 
                        <td nowrap><strong>Carrera</strong></td>
                        <td >:<%=formulario.dibujaCampo("carr_ccod")%></td>
                      </tr>
					  <tr> 
                        <td nowrap><strong>Fecha Envio a Escuela</strong></td>
                        <td width="50%" nowrap>: <%=formulario.dibujaCampo("fecha_envio")%> 
						 <% 'if carr_ccod  = "" then
						    calendario.DibujaImagen "fecha_oculta_fecha_envio","1","edicion" 
							'end if
						%>
                          (dd/mm/yyyy) </td>
                      </tr>
                      <tr> 
                        <td nowrap><strong>Enviada Por</strong></td>
                        <td >:<%=formulario.dibujaCampo("enviada_por2")%><%=formulario.dibujaCampo("enviado_por")%>
						    <%if enviada_por <> "" then%>
							   <input type="hidden" name="m[0][enviada_por]" value="<%=enviada_por%>">
							<%end if%>
						</td>
                      </tr>
					  <%if carr_ccod <> "" then %>
					  <tr> 
                        <td nowrap><strong>Recepcionada Por</strong></td>
                        <td >:<%=formulario.dibujaCampo("recepcionada_por2")%><%=formulario.dibujaCampo("recepcionada_por")%></td>
                      </tr>
                      <tr> 
                        <td nowrap><strong>Fecha Devolución a Títulos y Grados </strong></td>
                        <td >:<%=formulario.dibujaCampo("fecha_recepcion")%> <%calendario.DibujaImagen "fecha_oculta_fecha_recepcion","2","edicion" %>
                          (dd/mm/yyyy) </td>
                      </tr>
					  <%end if%>
                      <tr> 
                        <td nowrap><strong>Observacion </strong></td>
                        <td >:<%=formulario.dibujaCampo("observacion")%></td>
                      </tr>
                    </table>
                          
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%botonera.dibujaboton "guardar"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "volver"%></div></td>
                  <td><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
