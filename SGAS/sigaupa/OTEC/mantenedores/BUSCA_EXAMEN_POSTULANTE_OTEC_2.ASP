<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'------------------------------------------------------------------- 
'	for each k in request.QueryString
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'	next	
'-------------------------------------------------------------------   
pers_nrut = request.QueryString("b[0][pers_nrut]")
pote_ncorr= request.QueryString("b[0][pote_ncorr]")
dgso_ncorr= request.QueryString("b[0][dgso_ncorr]")
'------------------------------------------------------------
set pagina = new CPagina		   
pagina.Titulo = "Examen Postulante "		   
set botonera =  new CFormulario		  
botonera.carga_parametros "BUSCA_EXAMEN_POSTULANTE_OTEC_2.XML", "btn_actualiza_examen"' aca cae
'------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"   
set negocio = new CNegocio
negocio.Inicializa conectar
'------------------------------------------------------------
'=====================================================================================================================================cambiar
'------------------------------------
imp_rut = request.QueryString("b[0][pers_nrut]")
'=====================================================================================================================================cambiar
'------------------------------------------------------------
   
consulta = "select a.pers_ncorr,                                        " & vbCrlf & _
"       cast(a.pers_nrut as varchar) + '-'                              " & vbCrlf & _
"       + a.pers_xdv            as rut,                                 " & vbCrlf & _
"       a.pers_tnombre + ' ' + a.pers_tape_paterno + ' '                " & vbCrlf & _
"       + a.pers_tape_materno   as nombre_completo,                     " & vbCrlf & _
"       d.dcur_tdesc            as programa,                            " & vbCrlf & _
"       d.dcur_ncorr,                                                   " & vbCrlf & _
"       fpot_tdesc              as carrera,                             " & vbCrlf & _
"       b.fpot_ccod             as mediopago,                           " & vbCrlf & _
"       b.epot_ccod             as estadomat,                           " & vbCrlf & _
"       f.eepo_ccod             as eepo_ccod,                           " & vbCrlf & _
"       protic.trunc(getdate()) as dpos_fexamen,                        " & vbCrlf & _
"       b.pote_ncorr            as pote_ncorr,                          " & vbCrlf & _
"       f.dpos_tobservacion     as dpos_tobservacion,                   " & vbCrlf & _
"       f.Dpos_nnota          	as Dpos_nnota	                        " & vbCrlf & _
"from   personas as a                                                   " & vbCrlf & _
"       inner join postulacion_otec as b                                " & vbCrlf & _
"               on a.pers_ncorr = b.pers_ncorr                          " & vbCrlf & _
"                  and cast(b.dgso_ncorr as varchar) = '"&dgso_ncorr&"' " & vbCrlf & _
"       inner join datos_generales_secciones_otec as c                  " & vbCrlf & _
"               on b.dgso_ncorr = c.dgso_ncorr                          " & vbCrlf & _
"       inner join diplomados_cursos as d                               " & vbCrlf & _
"               on c.dcur_ncorr = d.dcur_ncorr                          " & vbCrlf & _
"       inner join forma_pago_otec as e                                 " & vbCrlf & _
"               on b.fpot_ccod = e.fpot_ccod                            " & vbCrlf & _
"       left outer join detalle_postulacion_otec as f                   " & vbCrlf & _
"                    on b.pote_ncorr = f.pote_ncorr                     " & vbCrlf & _
"where  cast(a.pers_nrut as varchar) = '"&pers_nrut&"'                  " 
           
           'response.Write("<br>"&consulta&"<br>")
           set formulario 		= 		new cFormulario
           formulario.carga_parametros	"BUSCA_EXAMEN_POSTULANTE_OTEC_2.XML","tabla_valores"
           formulario.inicializar		conectar
           formulario.consultar 		consulta
           formulario.siguientef
           '-----------------------------------------------------------------vars----------------------------------------------------
           medioDePago = formulario.obtenerValorFormateado("medioPago")
           estadoMatricula = formulario.obtenerValorFormateado("estadomat")
		   'formulario.Listar
		   formulario.AgregaCampoCons "dgso_ncorr", dgso_ncorr
		  ' formulario.dibujacampo("dgso_ncorr")
        '   nomMedioPago = conectar.consultaUno("select fpot_tdesc from forma_pago_otec where fpot_ccod = '"& medioDePago & "'")
        '	editar.Listar
   '-----------------------------------------------------------------vars----------------------------------------------------
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
         function agregar(formulario)
		 {
		 //función encargada para ir al archivo que procesa la consulta
         	formulario.action = 'PROC_BUSCA_EXAMEN_POSTULANTE_OTEC.asp';
           	if(preValidaFormulario(formulario)){	
         	formulario.submit();
         	}
          }
         function salir()
         {
         	window.close();
         }
         function Habilita(opcion)
         {
         	objeto_nota=document.editar.elements["em[0][Dpos_tobservacion]"];
         		if ((opcion==2)||(opcion==3))
         		{
         			objeto_nota.disabled=false;
         		}
         	else{
         		objeto_nota.value="";
         		objeto_nota.disabled=true;
         	}
         }
         function Mensaje(){
         <% if session("mensaje_error")<>"" then%>
         alert("<%=session("mensaje_error")%>");
         <%
            session("mensaje_error")=""
            end if%>
         }
         
         function mandar_email(formulario)
         {
         	formulario.action = 'http://admision.upacifico.cl/postulacion/www/proc_edita_examen.php';
           	if(preValidaFormulario(formulario))
         	{
         	formulario.elements["eepo_ccod"].value = formulario.elements["em[0][eepo_ccod]"].value;
         	formulario.elements["Dpos_tobservacion"].value = formulario.elements["em[0][Dpos_tobservacion]"].value;
         	formulario.elements["dpos_tobservacion"].value = formulario.elements["em[0][dpos_tobservacion]"].value;	
         	formulario.elements["post_ncorr"].value = formulario.elements["em[0][post_ncorr]"].value;
         	formulario.elements["ofer_ncorr"].value = formulario.elements["em[0][ofer_ncorr]"].value;
         	formulario.submit();
         	}
          }
      </script>
   <body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
      <table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                     <td>
                        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td><%pagina.DibujarLenguetas Array("Examen Postulante"), 1 %></td>
                           </tr>
                           <tr>
                              <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                           </tr>
                           <tr>
                              <td>
                                 <form name="editar" method="post">
								 <%formulario.dibujacampo("dgso_ncorr")%>
								 <%formulario.dibujacampo("Dpos_fexamen")%>
								 
                                    <input type="hidden" name="audi_tusuario" value="<%=negocio.obtenerUsuario%>">
                                    <table width="90%" border="0" align="c<%response.Write(carr_ccod)%>enter">
                                       <tr>
                                          <td width="17%"><font color="#CC3300">&nbsp;</font> Rut</td>
                                          <td width="83%">: <strong><%formulario.dibujacampo("rut")%></strong></td>
                                       </tr>
                                       <tr>
                                          <td><font color="#CC3300">&nbsp;</font> Nombre</td>
                                          <td>: <%formulario.dibujacampo("nombre_completo")%></td>
                                       </tr>
                                       <tr>
                                          <td><font color="#CC3300">&nbsp;</font> Programa</td>
                                          <td>: <%formulario.dibujacampo("programa")%></td>
                                       </tr>
                                       <tr>
                                          <td><font color="#CC3300">&nbsp;</font> Forma de pago</td>
                                          <td>: <%formulario.dibujacampo("carrera")%></td>
                                       </tr>
                                       <tr>
                                          <td><font color="#CC3300">&nbsp;</font> Examen</td>
                                          <td>: <%formulario.dibujacampo("Eepo_ccod")%></td>
                                       </tr>
                                       <tr>
                                          <td><font color="#CC3300">&nbsp;</font> Calificacion</td>
                                          <td>: <%formulario.dibujacampo("Dpos_nnota")%></td>
                                       </tr>
                                       <tr>
                                          <td><font color="#CC3300">&nbsp;</font> Observaciones         :</td>
                                          <td><p> 
                                            <%formulario.dibujacampo("Dpos_tobservacion")%>
                                          </p></td>
                                       </tr>
                                       <tr>
                                          <td><%formulario.dibujacampo("pote_ncorr")%>
                                          </td>
                                          <td>&nbsp;</td>
                                       <tr>
                                          <td colspan="2"><font size="2" color="#0033FF">
                                             <%
                                                messaje_1 = ""
												if estadoMatricula = "4" then
												messaje_1 = "No es necesaria la evaluaci&oacuten, debido a que ya est&aacute matriculado"
												end if
                                                if medioDePago <> "1" and estadoMatricula = "4" then
                                                messaje_1 = "No es necesaria la evaluaci&oacuten, debido a que ya est&aacute matriculado"	
                                                end if
												if medioDePago <> "1" and estadoMatricula <> "4"then
                                                messaje_1 = "No es necesaria la evaluaci&oacuten, debido a que no es persona natural"	
                                                end if
												response.Write(messaje_1)
                                                %>
                                             </font>
                                          </td>
                                       </tr>
                                    </table>
                                 </form>
                              </td>
                           </tr>
                        </table>
                     </td>
                     <td width="7" background="../imagenes/der.gif">&nbsp;</td>
                  </tr>
                  <tr>
                     <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                     <td height="28">
                        <table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                           <tr>
                              <td width="38%" height="20">
                                 <div align="center">
                                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                                       <tr>
                                          <td>
                                             <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">    
											 <%
											 '*****************'
											 '* BOTON GUARDAR *'
											 '*****************'
											 if medioDePago <> "1" or estadoMatricula = "4" then
                                                botonera.agregaBotonParam "GUARDAR","deshabilitado","true"
                                             end if 
                                             botonera.dibujaboton "GUARDAR"'PROGRAMAR PARA QUE GUARDE LO QUE DEBE
											 '*****************'
                                               %>																									   
                                                </font>
                                             </div>
                                          </td>
                                          <td>
                                             <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "SALIR"%>
                                                </font> 
                                             </div>
                                          </td>
                                       </tr>
                                    </table>
                                 </div>
                              </td>
                              <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                           </tr>
                           <tr>
                              <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
                           </tr>
                        </table>
                     </td>
                     <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                  </tr>
               </table>
               <br>
            </td>
         </tr>
      </table>
   </body>
</html>