<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
dgso_ncorr = Request.QueryString("busqueda[0][dgso_ncorr]")
mote_ccod = Request.QueryString("busqueda[0][mote_ccod]")
seot_ncorr = Request.QueryString("busqueda[0][seot_ncorr]")
'for each k in request.querystring
'	response.write(k&"="&request.querystring(k)&"<br>")
'next
'response.End()

'response.Write("seot_ncorr "&seot_ncorr)

session("url_actual")="../mantenedores/libro_clases_otec.asp?busqueda[0][dgso_ncorr]="&dgso_ncorr&"&busqueda[0][mote_ccod]="&mote_ccod&"&busqueda[0][seot_ncorr]="&seot_ncorr
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Libros de Clases por curso"

set botonera =  new CFormulario
botonera.carga_parametros "libro_clases_otec.xml", "botonera"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores



'response.Write(carr_ccod)
'----------------------------------------------------------------------- 
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "libro_clases_otec.xml", "busqueda"
f_busqueda.Inicializar conexion
 
consulta="Select '"&dgso_ncorr&"' as dgso_ncorr, '"&mote_ccod&"' as mote_ccod, '"&seot_ncorr&"' as seot_ncorr"
f_busqueda.consultar consulta


consulta = "  select a.dgso_ncorr,sede_tdesc + ' : ' + c.dcur_tdesc as dgso_tdesc, " & vbCrLf & _
		   "  f.mote_ccod,f.mote_tdesc,seot_ncorr, seot_tdesc " & vbCrLf & _
		   "  from datos_generales_secciones_otec a, sedes b,diplomados_cursos c,secciones_otec d,mallas_otec e, modulos_otec f  " & vbCrLf & _
		   "  where a.sede_ccod = b.sede_ccod  " & vbCrLf & _
		   "  and a.dcur_ncorr=c.dcur_ncorr and esot_ccod=1  " & vbCrLf & _
		   "  and a.dgso_ncorr=d.dgso_ncorr and isnull(a.seot_ncorr_comun,0)=0 " & vbCrLf & _
		   "  and d.maot_ncorr=e.maot_ncorr and e.mote_ccod=f.mote_ccod  " & vbCrLf & _
		   "  union " & vbCrLf & _
		   "  select a.dgso_ncorr,sede_tdesc + ' : ' + c.dcur_tdesc as dgso_tdesc,  " & vbCrLf & _
		   "  f.mote_ccod,f.mote_tdesc,seot_ncorr, seot_tdesc  " & vbCrLf & _
		   "  from datos_generales_secciones_otec a, sedes b,diplomados_cursos c,secciones_otec d,mallas_otec e, modulos_otec f  " & vbCrLf & _
		   "  where a.sede_ccod = b.sede_ccod  " & vbCrLf & _
		   "  and a.dcur_ncorr=c.dcur_ncorr and esot_ccod=1  " & vbCrLf & _
		   "  and a.seot_ncorr_comun=d.seot_ncorr and isnull(a.seot_ncorr_comun,0)<> 0 " & vbCrLf & _
		   "  and d.maot_ncorr=e.maot_ncorr and e.mote_ccod=f.mote_ccod  "

 

 f_busqueda.inicializaListaDependiente "lBusqueda", consulta

 f_busqueda.Siguiente 

set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "libro_clases_otec.xml", "alumnos"
f_alumnos.Inicializar conexion
	
consulta =  " select a.seot_ncorr,a.pote_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, " & vbCrLf &_
			" c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', ' + c.pers_tnombre as alumno, " & vbCrLf &_
			" (select sitf_tdesc from situaciones_finales bb where bb.sitf_ccod=a.sitf_ccod) as estado,replace(caot_nnota_final,',','.') as caot_nnota_final,isnull(caot_nasistencia,100) as caot_nasistencia " & vbCrLf &_
			" from cargas_academicas_otec a, postulacion_otec b,personas c " & vbCrLf &_
			" where cast(a.seot_ncorr as varchar)='"&seot_ncorr&"'" & vbCrLf &_
			" and a.pote_ncorr=b.pote_ncorr and b.pers_ncorr=c.pers_ncorr order by alumno" 
	
f_alumnos.Consultar consulta
 
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


function enviar(formulario){
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}

</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="90%">
	<tr>
		<td align="center">
	
	<table width="68%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td align="left"><form name="buscador">
              <br>
              <table width="98%"  border="0">
                      <tr>
                        <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5%"> <div align="left">Programa</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "dgso_ncorr"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Curso</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "mote_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Sección</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "seot_ncorr"%></td>
                              </tr>
							  
							  <tr> 
                                <td width="5%"> <div align="left"></div></td>
								<td width="1%"> <div align="center"></div> </td>
								<td><div id="texto_alerta" style="position:absolute; visibility: hidden; width:418px; height: 16px;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
                              </tr>
                            </table></td>
                        <td width="19%"><div align="center"><%botonera.dibujaboton "buscar"%></div></td>
                      </tr>
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
	</td>
	</tr>
	</table>
	</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">
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
            <td><%pagina.DibujarLenguetas Array("Ingreso de calificaciones"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
				  	<td align="center">
						<form name="edicion">
						  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
						  <tr><input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>">
						      <input type="hidden" name="b[0][pers_xdv]" value="<%=q_pers_xdv%>">
							  <input type="hidden" name="dgso_ncorr" value="<%=dgso_ncorr%>">
							<td>
							  <br> 
							  <%if seot_ncorr <> "" then %>                 
							  <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
							  <tr>
								<td align="right">&nbsp;</td>
							  </tr>
							  <tr>
								<td align="Left"><font size="2" color="#0033FF">Listado de Alumnos del curso.-</font></td>
							  </tr>
							  <tr>
								<td align="center"><%f_alumnos.dibujatabla()%></td>
							  </tr>
							  </table>
							  <%end if%> 
							  
							</td>
						  </tr>
						</table>
                          <br>
     					</form>
					</td>
				  </tr>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
                </table>
              <br>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</td>
</tr>
</table>
</body>
</html>
