<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")

set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.InicializaPortal conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "portada_alumno.xml", "botonera_olvido_clave"

set errores = new CErrores
'---------------------------------------------------------------------------------------------------

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "portada_alumno.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
estado = False
if q_pers_nrut = "" then
 titulo = "¿OLVIDASTE TU NOMBRE DE USUARIO O LA CLAVE?"
 mensaje = "Para recuperar tu nombre de <strong>usuario</strong> o la <strong>clave</strong>, debes ingresar tu RUT y automáticamente enviaremos tus datos al <strong>Email</strong> que tengas registrado en el sistema.<br>"
else
 titulo = "SOLICITUD ENVIO DATOS DE ACCESO"
 nombre = conexion.consultaUno("Select pers_tnombre + ' ' + pers_tape_paterno as nombre from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"' and pers_xdv='"&q_pers_xdv&"'")
 email  = conexion.consultaUno("Select pers_temail from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'  and pers_xdv='"&q_pers_xdv&"'")
 login  = conexion.consultaUno("Select susu_tlogin from personas_postulante a, sis_usuarios b, sis_roles_usuarios c where cast(pers_nrut as varchar)='"&q_pers_nrut&"'  and pers_xdv='"&q_pers_xdv&"' and a.pers_ncorr=b.pers_ncorr and b.pers_ncorr = c.pers_ncorr and c.srol_ncorr = 4")
 clave  = conexion.consultaUno("Select susu_tclave from personas_postulante a, sis_usuarios b, sis_roles_usuarios c where cast(pers_nrut as varchar)='"&q_pers_nrut&"'  and pers_xdv='"&q_pers_xdv&"' and a.pers_ncorr=b.pers_ncorr and b.pers_ncorr = c.pers_ncorr and c.srol_ncorr = 4")


 if nombre = "" or EsVacio(nombre) then
	 mensaje = "Lo Sentimos pero el RUT ingresado <strong>NO</strong> se encuentra registrado como usuario del sistema."
 else 
 	 mensaje = " Sr(ita): "&nombre&"<br>"
	 if (email = "" or EsVAcio(email))  then
			mensaje = mensaje & "<br> Lo sentimos pero no tenemos registrado su <strong>Email</strong> en el sistema, imposible hacer llegar la información solicitada."
	 else
	  	if EsVacio(login) or EsVacio(clave) then
	 		mensaje = mensaje & "<br> Lo sentimos pero usted no tiene permisos de <strong>Alumno</strong> en el sistema, comuníquese con la Universidad para solucionar dicha situación."
		else
   	        email  = conexion.consultaUno("Select protic.initCap(pers_temail) from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'  and pers_xdv='"&q_pers_xdv&"'")
			mensaje = mensaje & "<br> Se ha detectado que <strong>"&email&"</strong> es el email que usted tiene registrado en el sistema, si esta correcto presione 'Solicitar', de no ser así comuníquese con la Universidad para realizar los cambios correspondientes."
		    estado = true
		end if
	 end if
 end if
 
end if

%>


<html>
<head>
<title>Contrase&ntilde;as</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function enviar(formulario){
 if (formulario.rut.value ==''){
   alert('Debe ingresar RUT.');
   formulario.rut.focus();
 }
 else{
   if(formulario.dv.value == ''){
     alert('Debe ingresar DV.');
	 formulario.dv.focus();
   }
   else{
     if(comilla(formulario.rut.value)){
	   alert('RUT no debe llevar comilla simple.');
	 }
	 else{
	   if(comilla(formulario.dv.value)){
	      alert('DV no debe llevar comilla simple.');
	   }
	   else{
	     formulario.action = 'olvido_clave.asp';
	     formulario.submit();
	   }
	 }
   }
 }
}



function mensaje(){
<%if session("error_clave") <> "" then %>
    alert('<%=session("error_clave")%>');
    <%session("error_clave") = "" 
  end if %>
}
</script>

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">  
  <tr>
    <td valign="top" bgcolor="#FFFFFF">

	    <form name="buscador" method="get" action="olvido_clave.asp">
      <table width="367" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
        <tr>
          <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="5%">&nbsp;</td>
                <td width="89%" height="5">&nbsp;</td>
                <td width="6%">&nbsp;</td>
              </tr>
              <tr> 
                <td width="5%">&nbsp;</td>
                <td width="89%"> 
                  <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF">
                    <tr> 
                      <td height="30" bgcolor="#ABABAB"> 
                        <div align="center"><b><%=titulo%></b></div>
                      </td>
                    </tr>
                    <tr> 
                      <td><div align="justify"><br><%=mensaje%><br>
                      </div></td>
                    </tr>
					<%if estado = False then%>
                    <tr> 
                      <td height="25"><div align="center">RUT<b> :</b><font color="#FFFFFF"><b> 
                          <%f_busqueda.DIbujaCampo("pers_nrut")%>
                          </b></font><b> - </b><font color="#FFFFFF"><b> 
                          <%f_busqueda.DibujaCampo("pers_xdv")%>
                        </b></font></div></td>
                    </tr>
					<%end if%>
                    <tr> 
                      <td height="30"> 
                        <div align="center"><br>
                          <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td><div align="center">
                                    <% if estado = True then
									   		f_botonera.DibujaBoton("solicitar2")
										else
											f_botonera.DibujaBoton("buscar")
										end if	%>
                              </div></td>
                              <td><div align="center">
                                    <%f_botonera.DibujaBoton("cancelar")%>
                              </div></td>
                            </tr>
                          </table>
                           
                        </div>
                      </td>
                    </tr>
                  </table>
                </td>
                <td width="6%">&nbsp;</td>
              </tr>
              <tr> 
                <td width="5%" height="5">&nbsp;</td>
                <td width="89%">&nbsp;
				<input  type="hidden" name="rut" value="<%=q_pers_nrut%>-<%=q_pers_xdv%>">
				<input  type="hidden" name="nombre" value="<%=nombre%>">
				<input  type="hidden" name="email" value="<%=email%>">
				<input  type="hidden" name="login" value="<%=login%>">
				<input  type="hidden" name="clave" value="<%=clave%>">
				</td>
                <td width="6%">&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
          </form>
</td>
  </tr>  
</table>
</body>
</html>
