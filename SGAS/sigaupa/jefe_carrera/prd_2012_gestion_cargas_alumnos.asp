<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'response.Flush()
'for each k in request.QueryString()
'	response.Write(k&"<br>")
'next

'sede = request.QueryString("sede_ccod")
espe_ccod = request.QueryString("busqueda[0][espe_ccod]")
jorn_ccod = request.QueryString("busqueda[0][jorn_ccod]")
carr_ccod = request.QueryString("busqueda[0][carr_ccod]")
emat_ccod = "1"
nuevo = request.QueryString("nuevo")

set conectar = new cConexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conectar

set pagina = new CPagina

set botonera =  new CFormulario
botonera.carga_parametros "gestion_cargas_alumnos.xml","botones_carga"
tituloPag = "Nómina de Alumnos"

if nuevo="S" then tituloPag = tituloPag + " Nuevos"
if nuevo="N" then tituloPag = tituloPag + " Antiguos"
tituloPag = tituloPag + " por Carrera"

tituloPag = tituloPag + " Matriculados a la fecha, según Nro de Asignaturas Inscritas"

pagina.Titulo = tituloPag

'----------------------Debemos buscar solo aquellas carreras en las que el usuario tiene permiso de ver-------------
usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
	

'-----------------------------------------AGREGAR FILTROS ----------------------------------------------------------------
'----------------------------------------( 11 - 03 - 2005 )---------------------------------------------------------------
set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "gestion_cargas_alumnos.xml", "busqueda"
 f_busqueda.Inicializar conectar
 peri = negocio.obtenerPeriodoAcademico ( "TOMACARGA" ) 
 sede = negocio.obtenerSede
 
 consulta="Select '"&carr_ccod&"' as carr_ccod, '"&espe_ccod&"' as espe_ccod, '"&jorn_ccod&"' as jorn_ccod"
 f_busqueda.consultar consulta
 
 consulta = "select distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod, a.carr_tdesc,b.espe_ccod,b.espe_tdesc,d.jorn_ccod,d.jorn_tdesc " & vbCrLf & _
		   " from carreras a, especialidades b ,ofertas_academicas c,jornadas d" & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " and b.espe_ccod=c.espe_ccod " & vbCrLf & _
		   " and b.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
		   " and c.jorn_ccod=d.jorn_ccod " & vbCrLf &_
		   " and cast(c.sede_ccod as varchar)='"&sede&"' " & vbCrLf & _
		   " and cast(c.peri_ccod as varchar)='"&peri&"' order by a.carr_tdesc,b.espe_tdesc asc" 
		   'response.Write("<pre>"&consulta&"</pre>")
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta
 f_busqueda.Siguiente
'-------------------------------------------------------------------------------------------------------------------------
set f_matriculados = new cformulario
f_matriculados.carga_parametros "gestion_cargas_alumnos.xml","matriculados_carga"
f_matriculados.inicializar conectar

periodo=negocio.ObtenerPeriodoAcademico("TOMACARGA")
filtro_nuevo = ""
if nuevo = "S" or nuevo="N" then 
	filtro_nuevo = "  having protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) = '"&nuevo&"'"
end if
consulta=""		

' asigna valores nulos
'if espe_ccod="" then espe_ccod=0 end if
'if sede="" then sede=0 end if

if emat_ccod = "1" and espe_ccod<>"" then

	consulta = " select distinct tabla.pers_ncorr,tabla.carr_ccod,tabla.peri_ccod,tabla.rut, " & vbCrLf &_
			 " tabla.nombre,a.matr_ncorr, " & vbCrLf &_
			 " count(a.matr_ncorr) as suma_total,case count(a.matr_ncorr) when 0 then 'Sin Inscripción' else '' end as estado," & vbCrLf &_
			 " isnull(protic.ANO_INGRESO_CARRERA(tabla.pers_ncorr, (select protic.obtener_nombre_carrera((select top 1 ofer_ncorr " & vbCrLf &_
	   		 " From alumnos where matr_ncorr=a.matr_ncorr order by matr_ncorr desc),'CC'))) ,  " & vbCrLf &_
	         " protic.ANO_INGRESO_CARRERA(tabla.pers_ncorr,tabla.carr_ccod) )as ano_ingreso" & vbCrLf &_
			 " from cargas_academicas a, " & vbCrLf &_
			 " (select distinct a.pers_ncorr, e.carr_ccod, c.peri_ccod, " & vbCrLf &_
			 " cast(pers_nrut as varchar)+'-'+cast(pers_xdv as varchar) as rut, " & vbCrLf &_
			 " pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre as nombre, " & vbCrLf &_
			 "   pers_fnacimiento,protic.es_nuevo_carrera(a.pers_ncorr,e.carr_ccod,c.peri_ccod) as nuevo, " & vbCrLf &_
			 "   d.matr_ncorr " & vbCrLf &_
			 " from personas a, ofertas_academicas c, alumnos d,especialidades e" & vbCrLf &_
			 " where a.pers_ncorr = d.pers_ncorr " & vbCrLf &_
			 " and c.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_
			 " and c.espe_ccod  = e.espe_ccod " & vbCrLf &_
			 " and c.peri_ccod = '"&periodo&"' " & vbCrLf &_
			 " and e.espe_ccod = '"&espe_ccod&"' " & vbCrLf &_
			 " and c.sede_ccod = '"&sede&"' " & vbCrLf &_
			 " and d.emat_ccod in (1,4) " & vbCrLf &_
			 " and d.audi_tusuario not in ('AgregaNota2T','AgregaNota3','AgregaNota37','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46'," & vbCrLf  & _
			 "		    'AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp'," & vbCrLf  & _
			 "          'AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80'," & vbCrLf  & _
			 "          'AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNota3Nuevo','AgregaNotaProtix','AgregaNotaprotix1') " & vbCrLf  & _
			 " group by a.pers_ncorr, e.carr_ccod, c.peri_ccod,pers_nrut, pers_xdv, pers_tnombre,pers_tape_paterno, " & vbCrLf &_
			 "          pers_tape_materno,pers_fnacimiento,d.matr_ncorr " & vbCrLf &_
			 " "&filtro_nuevo & " ) as tabla " & vbCrLf &_
			 " where tabla.matr_ncorr *= a.matr_ncorr " & vbCrLf &_
			 " group by tabla.pers_ncorr,tabla.carr_ccod,tabla.peri_ccod,tabla.rut,tabla.nombre,tabla.pers_fnacimiento,tabla.nuevo, " & vbCrLf &_
			 "         a.matr_ncorr " & vbCrLf &_
			 " order by tabla.nombre asc"				

else
     consulta = "Select * from niveles where 1=2"
	
end if

'response.Write("<pre>"&consulta&"</pre>")
'response.Flush()


f_matriculados.Consultar consulta
'f_matriculados.Siguiente

url_excel="gestion_cargas_alumnos_excel.asp?sede="&sede&"&espe_ccod="&espe_ccod&"&emat_ccod="&emat_ccod&"&nuevo="&nuevo

carrera = conectar.consultaUno("Select carr_tdesc from especialidades a, carreras b where a.carr_ccod=b.carr_ccod and cast(a.espe_ccod as varchar)='"&espe_ccod&"'")
especialidad = conectar.consultaUno("Select espe_tdesc from especialidades a where cast(a.espe_ccod as varchar)='"&espe_ccod&"'")

peri_tdesc = conectar.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

sede_tdesc = conectar.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede&"'")
%>
<html>
<head>
<title>Alumnos Matriculados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function enviar(formulario){
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="gestion_cargas_alumnos.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
}

</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0">
                      <tr>
                        <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="14%" align="left">Carrera &nbsp; </td>
								<td width="0%" align="center">:</td>
								<td colspan="4"><% f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="14%" align="left">Especialidad  </td>
								<td width="0%" align="center">:</td>
								<td colspan="4"><% f_busqueda.dibujaCampoLista "lBusqueda", "espe_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="14%" align="left">Jornada &nbsp; </td>
								<td width="0%" align="center">:</td>
								<td width="30%"><% f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
								<td width="9%" align="left">Alumnos </td>
								<td width="0%" align="center">:</td>
								<td width="60%"><select name="nuevo" onChange="direccionar(this.value)">
								                <%if nuevo="" then%>
													<option value="" selected>Todos</option>
												<%else%>
												    <option value="">Todos</option>
												<%end if
												  if nuevo="S" then %>		
													<option value="S" selected>Nuevos</option>
												<%else%>
												    <option value="S">Nuevos</option>
												<%end if
												  if nuevo="N" then%>
													<option value="N" selected>Antiguos</option>
												  <%else%>
												    <option value="N">Antiguos</option>
												  <%end if%>		
												</select>
								</td>
                              </tr>
							  <tr> 
                                <td width="14%" align="left">&nbsp;</td>
								<td width="0%" align="center">&nbsp; </td>
								<td colspan="4"><div id="texto_alerta" style="position:absolute; visibility: hidden; left: 343px; top: 194px; width:418px; height: 16px;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
                              </tr>
                            </table></td>
                        <td width="19%" align="center"><%botonera.dibujaboton "buscar"%></td>
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
            <td><%pagina.DibujarLenguetas Array(tituloPag), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                    <form name="edicion">
                      <div align="left">
                        <input name="url" type="hidden" value="<%=request.ServerVariables("HTTP_REFERER")%>">
                      </div>
                      <table width="98%" align="center">
                        <tr>
                          <td colspan="3"><strong>&nbsp;</strong></td>
						</tr>
						<%if carr_ccod <> "" then%>
							<tr>
							  <td width="10%"><strong>Sede</strong></td>
							  <td width="3%"><strong>:</strong></td>
							  <td><%=sede_tdesc%></td>
							</tr>
							<tr>
							  <td width="10%"><strong>Carrera</strong></td>
							  <td width="3%"><strong>:</strong></td>
							  <td><%=carrera%></td>
							</tr>
							<tr>
							  <td width="10%"><strong>Especialidad</strong></td>
							  <td width="3%"><strong>:</strong></td>
							  <td><%=especialidad%></td>
							</tr>
							<tr>
							  <td width="10%"><strong>Periodo</strong></td>
							  <td width="3%"><strong>:</strong></td>
							  <td><%=peri_tdesc%></td>
							</tr>
							
						<%end if%>
						<tr>
                          <td align="center" colspan="3"> <div align="right">P&aacute;ginas: 
                              <%f_matriculados.AccesoPagina()%>
                            </div></td>
                        </tr>
						<tr> 
                          <td align="center" colspan="3">&nbsp; <%f_matriculados.dibujatabla()%> </td>
                        </tr>
                      </table>
                    </form>
                    <br>
                    <br>
                  </div>
                </td>
              </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28">
		 <table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
			 
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                            <% botonera.dibujaboton("salir") %>
                          </div></td>
				  <td> <div align="center">  <%
					                       botonera.agregabotonparam "excel", "url", url_excel
										   botonera.dibujaboton "excel"
										%>
					 </div>  
                  </td>
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
