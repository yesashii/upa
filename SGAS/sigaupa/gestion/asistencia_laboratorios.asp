<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
inicio = request.querystring("inicio")
termino = request.querystring("termino")
 
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Listados de Asistencia Laboratorio de Computación"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "asistencia_laboratorios.xml", "botonera"


'------------------------------------------------------------------------------------------------------
'----------------------------buscamos la información de listado de alumnos ----------------------------
set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "asistencia_laboratorios.xml", "alumnos"
f_alumnos.Inicializar conexion
consulta_alumnos =  "  select cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as alumno, "& vbCrLf &_
					"  c.sede_tdesc as sede,e.carr_tdesc as carrera,f.jorn_tdesc as jornada, protic.trunc(fecha_asistencia) as fecha,fecha_asistencia "& vbCrLf &_
				    "  from asistencia_laboratorios a, personas b,ofertas_academicas oa,sedes c, especialidades d, carreras e, jornadas f "& vbCrLf &_
					"  where a.pers_ncorr=b.pers_ncorr "

if inicio <> "" then				
				    consulta_alumnos = consulta_alumnos & "  and convert(varchar,fecha_asistencia,103)>=convert(datetime,'"&inicio&"',103) "
end if
if termino <> "" then				
				    consulta_alumnos = consulta_alumnos & "  and convert(varchar,fecha_asistencia,103)<=convert(datetime,'"&termino&"',103) "
end if					
					consulta_alumnos = consulta_alumnos & "  and oa.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) "& vbCrLf &_
					"  and oa.sede_ccod=c.sede_ccod "& vbCrLf &_
					"  and oa.espe_ccod=d.espe_ccod and d.carr_ccod = e.carr_ccod "& vbCrLf &_
					"  and oa.jorn_ccod=f.jorn_ccod "
					

if inicio = "" and termino = "" then
   consulta_alumnos = "select '' as fecha_asistencia, '' as alumno,* from personas where 1=2"
end if
f_alumnos.Consultar consulta_alumnos & "  order by fecha_asistencia asc,alumno asc"
f_alumnos.siguiente

'------------------------------------------------------------------------------------------------------
'response.Write("<pre>"&consulta_alumnos&"</pre>")
cantidad_alumnos = conexion.consultaUno("select count(*) from ("&consulta_alumnos&")tabla_a")

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

function enviar(formulario)
{

document.buscador.method="get";
document.buscador.action="asistencia_laboratorios.asp";
document.buscador.submit();

}
function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}
function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}


</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "inicio","1","buscador","fecha_oculta_inicio"
	calendario.MuestraFecha "termino","2","buscador","fecha_oculta_termino"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<%calendario.ImprimeVariables%>
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
            <td><form name="buscador" method="get" action="">
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="91%"><div align="center">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                          <td><strong>Inicio</strong></td>
                          <td>:</td>
                          <td><div align="left"></div>
                            <input type="text" name="inicio" maxlength="10" size="12" value="<%=inicio%>"><%calendario.DibujaImagen "fecha_oculta_inicio","1","buscador" %>
                            (dd/mm/aaaa) </td>
                          <td>&nbsp;</td>
                          <td><strong>T&eacute;rmino</strong></td>
                          <td>:</td>
                          <td><div align="left"> 
                             <input type="text" name="termino" maxlength="10" size="12" value="<%=termino%>">
                              <%calendario.DibujaImagen "fecha_oculta_termino","2","buscador" %>
                              (dd/mm/aaaa) </div></td>
                    </tr>
                    </table>
                  </div></td>
                  <td width="9%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
            <td><div align="center"> <br>
                    <%pagina.DibujarTituloPagina%>
                </div>
              <form name="edicion" method="post" action="">
			      			  
                  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><strong>Cantidad Encontrados :&nbsp;&nbsp;</strong><%=cantidad_alumnos%>&nbsp; Alumnos
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                             <td align="right">P&aacute;gina:
                                 <%f_alumnos.accesopagina%>
                             </td>
                             </tr>
                               <tr>
                                 <td align="center">
                                    <%f_alumnos.dibujaTabla()%>
                                  </td>
                             </tr>
							 <tr>
							    <td>&nbsp;
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
                  <td width="51%"><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  <td width="49%"> <div align="center">  <% if cantidad_alumnos = 0 then
				                                                f_botonera.agregabotonparam "excel","deshabilitado","TRUE"    
															end if																             
					                       f_botonera.agregabotonparam "excel", "url", "asistencia_laboratorios_excel.asp?inicio="&inicio&"&termino="&termino
										   f_botonera.dibujaboton "excel"
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
