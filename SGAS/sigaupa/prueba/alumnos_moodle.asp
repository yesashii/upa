<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Nóminas de alumnos para Matriculación Moodle"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

peri_ccod  		= request.querystring("busqueda[0][peri_ccod]")
codigo_id  		= request.querystring("busqueda[0][codigo_id]")
response.Write(peri_ccod)
if codigo_id <> "" then
arreglo = Split(codigo_id,"-")
sede=arreglo(0)
carrera=arreglo(1)
jornada=arreglo(2)
asignatura =arreglo(3)
seccion = arreglo(4)
end if
sql_periodo= "(select distinct peri_ccod , peri_tdesc From periodos_academicos Where anos_ccod >= 2009) as tabla "

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "alumnos_moodle.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.siguiente
 
f_busqueda.AgregaCampoParam "peri_ccod", "destino", sql_periodo
f_busqueda.AgregaCampoCons "peri_ccod", peri_ccod
f_busqueda.AgregaCampoCons "codigo_id", codigo_id

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "alumnos_moodle.xml", "botonera"

set formulario = new CFormulario
formulario.carga_parametros "alumnos_moodle.xml", "alumnos"
formulario.Inicializar conexion
consulta = " select distinct d.pers_nrut as rut, d.pers_xdv as dv, d.pers_tnombre as nombres, "& vbCrLf &_
		   " d.pers_tape_paterno + ' ' + d.pers_tape_materno as apellidos, g.carr_tdesc as carrera,'Alumno' as tipo  "& vbCrLf &_
			" from cargas_academicas a,secciones b, alumnos c, personas d, ofertas_academicas e, especialidades f, carreras g  "& vbCrLf &_
			" where a.secc_ccod=b.secc_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod&"'  "& vbCrLf &_
			" and a.matr_ncorr=c.matr_ncorr and c.pers_ncorr=d.pers_ncorr  "& vbCrLf &_
			" and c.ofer_ncorr=e.ofer_ncorr  "& vbCrLf &_
			" and e.espe_ccod=f.espe_ccod and f.carr_ccod=g.carr_ccod  "& vbCrLf &_
			" and cast(b.sede_ccod as varchar)='"&sede&"'  "& vbCrLf &_
			" and b.carr_ccod ='"&carrera&"'  "& vbCrLf &_
			" and cast(b.jorn_ccod as varchar)='"&jornada&"'  "& vbCrLf &_
			" and b.asig_ccod ='"&asignatura&"'  "& vbCrLf &_
			" and substring(secc_tdesc,1,1) = '"&seccion&"'  "& vbCrLf &_
			" union "& vbCrLf &_
			" select distinct d.pers_nrut as rut, d.pers_xdv as dv, d.pers_tnombre as nombres,  "& vbCrLf &_
			" d.pers_tape_paterno + ' ' + d.pers_tape_materno as apellidos, '' as carrera,'Profesor' as tipo  "& vbCrLf &_
			" from secciones b, bloques_horarios a, bloques_profesores c, personas d "& vbCrLf &_
			" where a.secc_ccod=b.secc_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod&"'  "& vbCrLf &_
			" and a.bloq_ccod = c.bloq_ccod and c.pers_ncorr=d.pers_ncorr and c.tpro_ccod=1 "& vbCrLf &_
			" and cast(b.sede_ccod as varchar)='"&sede&"'  "& vbCrLf &_
			" and b.carr_ccod ='"&carrera&"'  "& vbCrLf &_
			" and cast(b.jorn_ccod as varchar)='"&jornada&"' "& vbCrLf &_ 
			" and b.asig_ccod ='"&asignatura&"'  "& vbCrLf &_
			" and substring(secc_tdesc,1,1) = '"&seccion&"' "& vbCrLf &_
			" union  "& vbCrLf &_
			" select distinct a.pers_nrut as rut, a.pers_xdv as dv, a.pers_tnombre as nombres,  "& vbCrLf &_
			" a.pers_tape_paterno + ' ' + a.pers_tape_materno as apellidos, '' as carrera,'Profesor' as tipo "& vbCrLf &_ 
			" from personas a "& vbCrLf &_
			" where a.pers_nrut='7139878' "

'response.Write("<pre>"&consulta&"</pre>")
formulario.Consultar consulta & " order by apellidos"

total = conexion.consultaUno("select count(*) from ("&consulta&")a")
'response.Write(total)
'response.End()
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

function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                <td height="60">
<form name="buscador" method="get" action="">
              <br>
			   <table width="98%"  border="0" align="center">
                <tr>
                  <td width="82%"><div align="center">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                         <tr> 
                          <td width="27%"><strong>ID Curso</strong></td>
                          <td width="2%">:</td>
                          <td width="71%"><div align="left"></div>
                            <%f_busqueda.DibujaCampo("codigo_id")%></td>
                        </tr>
						 <tr> 
                          <td width="27%"><strong>Periodo</strong></td>
                          <td width="2%">:</td>
                          <td width="71%"><div align="left"></div>
                            <%f_busqueda.DibujaCampo("peri_ccod")%></td>
                        </tr>
                    </table>
                  </div></td>
                  <td width="18%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td><br><div align="center"> 
                    <%pagina.DibujarTituloPagina%>
                </div>
              <form name="edicion" method="post" action="">
			     <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
						<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        	<tr>
							    <td align="left"><strong>Total listado :</strong><%=total%> <strong> Personas</strong></td>
						    </tr>
							<tr>
                             <td align="right"><br><%pagina.DibujarSubtitulo "Alumnos actualmente activos."%>
							                   <%formulario.AccesoPagina()%></td>
                            </tr>
                               <tr>
                                 <td align="center">
								 	 <%formulario.dibujaTabla()%>
									<br>
                                 </td>
                             </tr>
						  </table>
                     </td>
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
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  	  <td width="33%"><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
					  <td width="34%"> <div align="center">  
														   <%if peri_ccod <> "" and total <> "" then 
															  f_botonera.agregaBotonParam "reporte","url","reporte_moodle_222.asp?peri_ccod="&peri_ccod&"&codigo_id="&codigo_id
															  f_botonera.dibujaboton "reporte"
															 end if
															 %>
						 </div>
					  </td>
					  <td width="33%"> <div align="center"><% 
															  f_botonera.agregaBotonParam "reporte","texto","Reporte General"
					                                          f_botonera.agregaBotonParam "reporte","url","reporte_total_moodle.asp"
															  f_botonera.dibujaboton "reporte"
															%>
						 </div>
					  </td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
