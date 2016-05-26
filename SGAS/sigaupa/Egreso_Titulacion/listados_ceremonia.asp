<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Listados Alumnos Ceremonia Titulación."
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "listados_ceremonia.xml", "botonera"

'-----------------------------------------------------------------------
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
codigo_fecha = request.querystring("busqueda[0][codigo_fecha]")
'response.Write(codigo_fecha)
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "listados_ceremonia.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 'if  EsVacio(carr_ccod) then
 ' 		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "1=2"
 'end if
 consulta_fechas = "(select distinct protic.initCap(sede_tdesc) + ': ' + protic.trunc(fecha_ceremonia) as fecha_mostrar, "& vbCrLf &_
                   " id_ceremonia as codigo_fecha, fecha_ceremonia  "& vbCrLf &_
                   " from ceremonias_titulacion a, sedes b "& vbCrLf &_ 
				   " where a.sede_ccod=b.sede_ccod "& vbCrLf &_
				   " and exists (select 1 from detalles_titulacion_carrera tt where tt.id_ceremonia = a.id_ceremonia) )bb"
 
 f_busqueda.AgregaCampoParam "codigo_fecha","destino",consulta_fechas
 f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod
 f_busqueda.AgregaCampoCons "codigo_fecha", codigo_fecha 
 f_busqueda.Siguiente
  
 'ultimo = carr_ccod

'---------------------------------------------------------------------------------------------------
set f_lista = new CFormulario
f_lista.Carga_Parametros "listados_ceremonia.xml", "f_lista"
f_lista.Inicializar conexion
 consulta = " select distinct d.carr_tdesc, "& vbCrLf &_
			" case isnull(incluir_mencion,'0') when '0' then '' else nombre_mencion end as mencion, "& vbCrLf &_
			" cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, "& vbCrLf &_
			" pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as alumno, isnull(titulo_grado,'') as grado_academico, "& vbCrLf &_
			" replace(isnull(promedio_final,asca_nnota),',','.') as nota, "& vbCrLf &_
			" datepart(year,g.asca_fsalida) as anos_ccod, "& vbCrLf &_
			" case when "& vbCrLf &_
			" datepart(year,g.asca_fsalida) <= 2005 "& vbCrLf &_
			"                                then case when isnull(promedio_final,asca_nnota) >= 4.0 and isnull(promedio_final,asca_nnota) < 5.0 then 'UNANIMIDAD' "& vbCrLf &_
			"                                          when isnull(promedio_final,asca_nnota) >= 5.0 and isnull(promedio_final,asca_nnota) < 5.5 then 'UN VOTO DE DISTINCION'  "& vbCrLf &_
			"                                          when isnull(promedio_final,asca_nnota) >= 5.5 and isnull(promedio_final,asca_nnota) < 6.0 then 'DOS VOTOS DE DISTINCION' "& vbCrLf &_
			"                                          when isnull(promedio_final,asca_nnota) >= 6.0 and isnull(promedio_final,asca_nnota) < 6.5 then 'TRES VOTOS DE DISTINCION' "& vbCrLf &_
			"                                          when isnull(promedio_final,asca_nnota) >= 6.5 and isnull(promedio_final,asca_nnota) <= 7.0 then 'APROBADO CON DISTINCION MAXIMA' "& vbCrLf &_
			"                                      end  "& vbCrLf &_
			"                                 else case when isnull(promedio_final,asca_nnota) >= 4.0 and isnull(promedio_final,asca_nnota) < 5.0 then 'APROBADO POR UNANIMIDAD' "& vbCrLf &_
			"                                           when isnull(promedio_final,asca_nnota) >= 5.0 and isnull(promedio_final,asca_nnota) < 6.0 then 'APROBADO CON DISTINCION'   "& vbCrLf &_
			"                                           when isnull(promedio_final,asca_nnota) >= 6.0 and isnull(promedio_final,asca_nnota) <= 7.0 then 'APROBADO CON DISTINCION MAXIMA' "& vbCrLf &_
			"                                      end "& vbCrLf &_
			" end as distincion_obtenida,g.asca_nfolio as folio "& vbCrLf &_
			" from detalles_titulacion_carrera a join  planes_estudio b "& vbCrLf &_
			"       on a.plan_ccod = b.plan_ccod "& vbCrLf &_
			"   join  especialidades c "& vbCrLf &_
			"   	   on b.espe_ccod = c.espe_ccod "& vbCrLf &_
			"   join carreras d "& vbCrLf &_
			"   	   on c.carr_ccod = d.carr_ccod "& vbCrLf &_
			"   join personas e "& vbCrLf &_
			"       on a.pers_ncorr = e.pers_ncorr "& vbCrLf &_
			"  join alumnos_salidas_carrera g "& vbCrLf &_ 
			"       on a.pers_ncorr = g.pers_ncorr "& vbCrLf &_
			"   join salidas_carrera f "& vbCrLf &_
			"       on g.saca_ncorr = f.saca_ncorr and a.carr_ccod = f.carr_ccod  "& vbCrLf &_
			"   left outer join requerimientos_titulacion tt  "& vbCrLf &_
			"       on a.pers_ncorr=tt.pers_ncorr "& vbCrLf &_
			" where isnull(id_ceremonia,0) <> 0  "& vbCrLf &_
			" and cast(a.id_ceremonia as varchar) = '"&codigo_fecha&"' "
			
			if carr_ccod <> "" then 
				consulta = consulta & " and d.carr_ccod='"&carr_ccod&"'"
			end if
			
'response.write("<pre>"&consulta&" order by carr_tdesc, mencion, alumno</pre>")
f_lista.Consultar consulta & " order by carr_tdesc, mencion, alumno"

'---------------------------------------------------------------------------------------------------

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
function cargar()
{
  buscador.action="Especialidades.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
}
</script>

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
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td width="20%"><div align="left">Carrera</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="75%"><% f_busqueda.dibujaCampo ("carr_ccod") %></td>
                              </tr>
							  <tr> 
                                <td width="20%"><div align="left">Fecha Ceremonia</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="75%"><% f_busqueda.dibujaCampo ("codigo_fecha") %></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                     
                    <br>
                    <br><%pagina.DibujarSubtitulo carrera%>
                  
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%f_lista.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <%f_lista.DibujaTabla()%>
                          </div></td>
                  </tr>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"> 
                            <% if codigo_fecha <> "" then
							      botonera.AgregaBotonParam "excel" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "excel" , "deshabilitado", "TRUE"
							   end if
							   botonera.AgregaBotonParam "excel", "url", "listados_ceremonia_excel.asp?carr_ccod=" & carr_ccod&"&codigo_fecha="&codigo_fecha
							   botonera.DibujaBoton "excel"
							%>
                          </div></td>
                  <td>&nbsp;</td>
                  <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
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
