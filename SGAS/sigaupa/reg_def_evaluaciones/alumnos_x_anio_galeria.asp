<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Listado de Alumnos por Año"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

periodo = negocio.obtenerPeriodoAcademico("POSTULACION")
'-------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "alumnos_x_anio_galeria.xml", "botonera"
'-------------------------------------------------------------------------------
 carr_ccod     =    request.QueryString("busqueda[0][carr_ccod]")
 anos_ccod     =	request.querystring("busqueda[0][anos_ccod]")
 pers_nrut     =    request.QueryString("busqueda[0][pers_nrut]")
 pers_xdv      =	request.querystring("busqueda[0][pers_xdv]")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "alumnos_x_anio_galeria.xml", "busqueda"
 f_busqueda.Inicializar conexion
 
 consulta="Select '"&carr_ccod&"' as carr_ccod, '"&anos_ccod&"' as anos_ccod,'"&pers_nrut&"' as pers_nrut,'"&pers_xdv&"' as pers_xdv"
 f_busqueda.consultar consulta

 consulta = " select distinct anos_ccod,d.carr_ccod,d.carr_tdesc " & vbCrLf & _
			" from periodos_academicos a, ofertas_Academicas b (nolock), especialidades c, carreras d " & vbCrLf & _
			" where a.peri_ccod = b.peri_ccod " & vbCrLf & _
			" and b.espe_ccod=c.espe_ccod " & vbCrLf & _
			" and exists (select 1 from alumnos alu (nolock) where alu.ofer_ncorr = b.ofer_ncorr and alu.emat_ccod <> 9 and alu.alum_nmatricula <> 7777) " & vbCrLf & _
			" and c.carr_ccod=d.carr_ccod order by anos_ccod desc, carr_tdesc asc" 


 f_busqueda.inicializaListaDependiente "lBusqueda", consulta

 f_busqueda.Siguiente
 
 'f_busqueda.AgregaCampoCons "nombre_asig", nombre
 'f_busqueda.AgregaCampoCons "codigo_asig", codigo
 if pers_nrut <> "" and pers_xdv <> "" then
  filtro = " and cast(c.pers_nrut as varchar)='"&pers_nrut&"' and c.pers_xdv ='"&pers_xdv&"'"
  filtro_anteriores = ""
  filtro_anteriores_jorn = ""
 else
  filtro = " and cast(d.anos_ccod as varchar)='"&anos_ccod&"' "
  filtro_anteriores =   " and not exists (select 1 from alumnos alu (nolock), ofertas_academicas ofe (nolock), periodos_academicos pea,especialidades esp "& vbCrLf &_
						"                 where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.peri_ccod=pea.peri_ccod "& vbCrLf &_
						"                 and pea.anos_ccod < d.anos_ccod  and ofe.espe_ccod=esp.espe_ccod and esp.carr_ccod=e.carr_ccod) "
  filtro_anteriores_jorn =   " and not exists (select 1 from alumnos alu (nolock), ofertas_academicas ofe (nolock), periodos_academicos pea,especialidades esp "& vbCrLf &_
							 "                 where alu.pers_ncorr=a.pers_ncorr and alu.ofer_ncorr=ofe.ofer_ncorr and ofe.peri_ccod=pea.peri_ccod "& vbCrLf &_
							 "                 and pea.anos_ccod < d.anos_ccod  and ofe.espe_ccod=esp.espe_ccod and esp.carr_ccod=e.carr_ccod and ofe.jorn_ccod=b.jorn_ccod) "
 end if

'----------------------------------------------------------------------------------
set tabla_personas = new CFormulario
tabla_personas.Carga_Parametros "tabla_vacia.xml", "tabla"
tabla_personas.Inicializar conexion

 consulta = " select distinct a.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbCrLf &_
			" protic.initCap(protic.initcap(substring(isnull(ltrim(rtrim(pers_tnombre)),'NN'),0, case charindex(' ' ,isnull(ltrim(rtrim(pers_tnombre)),'NN')) when 0 then 20 else charindex(' ' ,isnull(ltrim(rtrim(pers_tnombre)),'NN')) end  )) ) as nombre,protic.initCap(c.pers_tape_paterno) as apellido, "& vbCrLf &_
			" isnull(isnull((Select top 1 ltrim(rtrim(imagen)) from rut_fotos_2010 tt where tt.rut = c.pers_nrut), "& vbCrLf &_
			"       (Select top 1 ltrim(rtrim(foto_truta)) from fotos_alumnos tr where tr.pers_nrut= c.pers_nrut)), "& vbCrLf &_
			"       case c.sexo_ccod when 2 then 'mujer.png' else 'hombre.png' end ) as foto, "& vbCrLf &_
			" pers_tape_paterno + ' ' + pers_tape_materno + ' ' + pers_tnombre as nombres_alfabeticos         "& vbCrLf &_
			" from alumnos a (nolock), ofertas_academicas b (nolock), personas c (nolock), periodos_academicos d,especialidades e "& vbCrLf &_
			" where a.ofer_ncorr=b.ofer_ncorr and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" and b.peri_ccod = d.peri_ccod and b.espe_ccod = e.espe_ccod and a.emat_ccod <> 9"& vbCrLf &_
			" "&filtro&" and e.carr_ccod='"&carr_ccod&"' "& filtro_anteriores & ""& vbCrLf &_
			" order by nombres_alfabeticos"		   
'response.Write("<pre>"&consulta&"</pre>")
tabla_personas.consultar consulta
	  
carr_tdesc = conexion.consultaUno("Select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
filas_p = tabla_personas.nroFilas


'----------------------------Para sacar cantidad de diurnas y vespertinas----------------------
set tabla_personas_jorn = new CFormulario
tabla_personas_jorn.Carga_Parametros "tabla_vacia.xml", "tabla"
tabla_personas_jorn.Inicializar conexion

 consulta = " select distinct a.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbCrLf &_
			" protic.initCap(protic.initcap(substring(isnull(ltrim(rtrim(pers_tnombre)),'NN'),0, case charindex(' ' ,isnull(ltrim(rtrim(pers_tnombre)),'NN')) when 0 then 20 else charindex(' ' ,isnull(ltrim(rtrim(pers_tnombre)),'NN')) end  )) ) as nombre,protic.initCap(c.pers_tape_paterno) as apellido, "& vbCrLf &_
			" isnull(isnull((Select top 1 ltrim(rtrim(imagen)) from rut_fotos_2010 tt where tt.rut = c.pers_nrut), "& vbCrLf &_
			"       (Select top 1 ltrim(rtrim(foto_truta)) from fotos_alumnos tr where tr.pers_nrut= c.pers_nrut)), "& vbCrLf &_
			"       case c.sexo_ccod when 2 then 'mujer.png' else 'hombre.png' end ) as foto, "& vbCrLf &_
			" pers_tape_paterno + ' ' + pers_tape_materno + ' ' + pers_tnombre as nombres_alfabeticos, b.jorn_ccod "& vbCrLf &_
			" from alumnos a (nolock), ofertas_academicas b (nolock), personas c (nolock), periodos_academicos d,especialidades e "& vbCrLf &_
			" where a.ofer_ncorr=b.ofer_ncorr and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" and b.peri_ccod = d.peri_ccod and b.espe_ccod = e.espe_ccod and a.emat_ccod <> 9"& vbCrLf &_
			" "&filtro&" and e.carr_ccod='"&carr_ccod&"' "& filtro_anteriores_jorn & ""& vbCrLf &_
			" order by nombres_alfabeticos"		   
'response.Write("<pre>"&consulta&"</pre>")
tabla_personas_jorn.consultar consulta
total_diurnos = 0
total_vespertinos = 0
while tabla_personas_jorn.siguiente
	if tabla_personas_jorn.obtenerValor("jorn_ccod") = "1" then
		total_diurnos = total_diurnos + 1
	else
		total_vespertinos = total_vespertinos + 1
	end if
wend

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
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="alumnos_x_anio_galeria.asp";
			formulario.submit();
}

function abrir_datos(codigo)
{
    direccion = "alumnos_x_anio_galeria_detalle.asp?pers_ncorr="+codigo+"&carr_ccod="+'<%=carr_ccod%>'+"&anos_ccod="+'<%=anos_ccod%>';
    resultado = window.open(direccion, "ventana_aviso","width=500,height=360,scrollbars=yes, left=0, top=0");
}

</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                        <td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="20%"> <div align="left">Año Ingreso</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								
                              <td width="79%"> 
                                <% f_busqueda.dibujaCampoLista "lBusqueda", "anos_ccod"%>
                                o por Rut de alumno: 
                                <%f_busqueda.dibujaCampo("pers_nrut")%>
                                - 
                                <%f_busqueda.dibujaCampo("pers_xdv")%>
                              </td>
                              </tr>
							  <tr> 
                                <td width="20%"> <div align="left">Carrera</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td colspan="3" align="right"><%botonera.dibujaboton "buscar"%></td>
							  </tr>
							  <tr> 
                                <td width="20%"> <div align="left"></div></td>
								<td width="1%"> <div align="center"></div> </td>
								<td><div  align="center" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
                              </tr>
							</table>
							</td>
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
	<%if filas_p > 0 then %>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
	              <%pagina.DibujarTituloPagina%><br>
              <br><br>
			 <table width="98%"  border="1">
			 <tr><td>
			  <table width="98%">
				<tr>
					<td width="16%" align="left"><strong>Año Ingreso</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><%=anos_ccod%></td>
				</tr>
				<tr>
					<td width="16%" align="left"><strong>Carrera</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><%=carr_tdesc%></td>
				</tr>
				<tr>
					<td width="16%" align="left"><strong>Total</strong></td>
					<td width="2%" align="center"><strong>:</strong></td>
					<td align="left" colspan="4"><%=tabla_personas.nroFilas%> (<%=total_diurnos%> Diurnos y <%=total_vespertinos%> Vespertinos)</td>
				</tr>
    		  </table></td></tr>
			  </table>
			 
			  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr><td colspan="3" align="right"><font color="#993300">* Presione sobre la fotografía para ver el avance curricular del alumno.</font></td></tr>
					<tr>
					  <td colspan="3">
						 <table width="651" align="center" cellpadding="0" cellspacing="0">
						  <tr valign="top">
						    <%columna = 1
							  while tabla_personas.siguiente 
							    rut = tabla_personas.obtenerValor("rut")
								nombre = tabla_personas.obtenerValor("nombre")
								apellido = tabla_personas.obtenerValor("apellido")
								foto = tabla_personas.obtenerValor("foto")
								generico = rut&": "&nombre&" "&apellido
								pers = tabla_personas.obtenerValor("pers_ncorr")
								
								if columna > 7 then
								   columna = 1
								   %>
								 </tr>
								 <tr valign="top">
								<%end if%> 
								<td width="93" align="center">
								   <table width="100%" cellpadding="0" cellspacing="0" align="center">
										<tr>
											<td width="100%" height="98" align="center"><a href="javascript:abrir_datos(<%=pers%>)"><img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=foto%>" border="0" title="<%=generico%>"></a></td>
										</tr>
										<tr>
											<td width="100%" align="center"><font size="-1"><%=nombre&"<br>"&apellido%></font></td>
										</tr>
								   </table>
								</td>
								<%columna = columna + 1%>
						    <%wend%>
							 <%if columna - 1 < 7 then %>
							 	<td colspan="<%=7 - (columna-1)%>">&nbsp;</td>
							 <%end if%>
						  </tr>
						 </table>
					  </td>
					</tr>
					 <tr><td colspan="3" align="right"><font color="#993300">* Presione sobre la fotografía para ver el avance curricular del alumno.</font></td></tr>
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
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"><%botonera.dibujaBoton "lanzadera"%></div></td>
						<td><div align="center"><% if pers_nrut="" and pers_xdv="" and anos_ccod <> "" then
						                           		botonera.agregaBotonParam "excel","url","alumnos_x_anio_galeria_excel.asp?carr_ccod="&carr_ccod&"&anos_ccod="&anos_ccod
						                           		botonera.dibujaBoton "excel"
												   end if%></div></td>
						<td><div align="center"><% if pers_nrut="" and pers_xdv="" and anos_ccod <> "" then
						                           		botonera.agregaBotonParam "excel_promedio","url","alumnos_x_anio_galeria_excel_promedios.asp?carr_ccod="&carr_ccod&"&anos_ccod="&anos_ccod
						                           		botonera.dibujaBoton "excel_promedio"
												   end if%></div></td>
						<td><div align="center"><% if anos_ccod <> "" then
						                           		botonera.agregaBotonParam "excel_total","url","alumnos_x_anio_galeria_jorn_excel.asp?anos_ccod="&anos_ccod
						                           		botonera.dibujaBoton "excel_total"
												   end if%></div></td>
		              </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<%end if%>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
