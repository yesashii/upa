<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Listados Alumnos egresados o Titulados"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "alumnos_x_fecha.xml", "botonera"

'-----------------------------------------------------------------------
inicio = request.querystring("inicio")
termino = request.querystring("termino")
tipo = request.querystring("tipo")

if tipo="4" then
	if inicio <> "" and termino <> "" then
				filtro_fecha = " AND convert(datetime,protic.trunc(a.fecha_egreso),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
	elseif inicio <> "" and termino = "" then	
				filtro_fecha = " AND convert(datetime,protic.trunc(a.fecha_egreso),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
	elseif inicio = "" and termino <> "" then	
				filtro_fecha = " AND convert(datetime,protic.trunc(a.fecha_egreso),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
	end if	
	filtro_orden =  " fecha_egreso, "		
elseif tipo="8" then 
   if inicio <> "" and termino <> "" then
				filtro_fecha = " AND convert(datetime,protic.trunc(asca_fsalida),103) between convert(datetime,'" & inicio & "',103) and convert(datetime,'" & termino & "',103)"& vbCrLf
	elseif inicio <> "" and termino = "" then	
				filtro_fecha = " AND convert(datetime,protic.trunc(asca_fsalida),103) >= convert(datetime,'" & inicio & "',103) "& vbCrLf
	elseif inicio = "" and termino <> "" then	
				filtro_fecha = " AND convert(datetime,protic.trunc(asca_fsalida),103) <= convert(datetime,'" & termino & "',103) "& vbCrLf	
	end if		
	filtro_orden =  " fecha_titulacion, "		

end if
	 

'---------------------------------------------------------------------------------------------------
set f_lista = new CFormulario
f_lista.Carga_Parametros "alumnos_x_fecha.xml", "f_lista"
f_lista.Inicializar conexion
 consulta = "  select distinct * "& vbCrLf &_
 			"  from "& vbCrLf &_
			" (  "& vbCrLf &_
			"  select distinct d.carr_tdesc, cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut,  "& vbCrLf &_
			"  pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as alumno,   "& vbCrLf &_
			"  cast(replace(asca_nnota,',','.') as varchar) as nota,  "& vbCrLf &_
			"  (select top 1 anos_ccod from alumnos tt,ofertas_academicas t2, especialidades t3, periodos_academicos t4  "& vbCrLf &_
			"   where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.peri_ccod=t4.peri_ccod  "& vbCrLf &_
			"   and tt.pers_ncorr=e.pers_ncorr and t3.carr_ccod=d.carr_ccod and tt.emat_ccod in (8) ) as anos_ccod,  "& vbCrLf &_
			"   cast(g.asca_nfolio as varchar) as folio,   "& vbCrLf &_
			"   protic.trunc(fecha_egreso) as m_fecha_egreso, fecha_egreso,   "& vbCrLf &_
			"   protic.trunc(asca_fsalida) as m_fecha_titulacion, asca_fsalida as fecha_titulacion   "& vbCrLf &_
			"   from detalles_titulacion_carrera a, planes_estudio b, especialidades c,carreras d,personas e,   "& vbCrLf &_
			"        salidas_carrera f, alumnos_salidas_carrera g  "& vbCrLf &_
			"   where a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod   "& vbCrLf &_
			"   and  not exists (select 1 from alumnos_salidas_carrera tt, salidas_carrera t2  "& vbCrLf &_
            "				     where tt.saca_ncorr=t2.saca_ncorr and tt.saca_ncorr=b.plan_ccod  "& vbCrLf &_
            "				     and tt.pers_ncorr=e.pers_ncorr and t2.tsca_ccod in (4,6) ) "& vbCrLf &_
			"   and a.pers_ncorr=e.pers_ncorr and a.carr_ccod= f.carr_ccod and f.saca_ncorr=g.saca_ncorr and g.pers_ncorr=a.pers_ncorr  "& vbCrLf &_
			" "& filtro_fecha
			if tipo = "4" then 
				consulta = consulta & " union "& vbCrLf &_
				" select d.carr_tdesc, cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, "& vbCrLf &_
				" pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as alumno, "& vbCrLf &_
				" null as nota, null as anos_ccod, null as folio, "& vbCrLf &_
				" protic.trunc(fecha_egreso) as m_fecha_egreso, fecha_egreso, "& vbCrLf &_
				" null as m_fecha_titulacion, null as fecha_titulacion "& vbCrLf &_
				" from detalles_titulacion_carrera a, planes_estudio b, especialidades c,carreras d,personas e"& vbCrLf &_
				" where a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod "& vbCrLf &_
				" and a.pers_ncorr=e.pers_ncorr "& vbCrLf &_
				" and not exists (select 1 from alumnos_salidas_carrera aa, salidas_carrera bb 			"& vbCrLf &_
				"	  where aa.pers_ncorr=a.pers_ncorr and aa.saca_ncorr=bb.saca_ncorr 			"& vbCrLf &_
				"	  and bb.carr_ccod=a.carr_ccod) "& vbCrLf &_
				" and  not exists (select 1 from alumnos_salidas_carrera tt, salidas_carrera t2  "& vbCrLf &_
                "				     where tt.saca_ncorr=t2.saca_ncorr and tt.saca_ncorr=b.plan_ccod  "& vbCrLf &_
                "				     and tt.pers_ncorr=e.pers_ncorr and t2.tsca_ccod in (4,6) ) "& vbCrLf &_
				" "& filtro_fecha 
			end if
			consulta = consulta & " ) ee "
'response.Write("<pre>"&consulta & " order by "&filtro_orden&" alumno desc</pre>")
			
f_lista.Consultar consulta & " order by "&filtro_orden&" alumno desc"
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>


<script language="JavaScript">
function cargar()
{
  buscador.action="Especialidades.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
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
							  <td><strong>Inicio</strong></td>
							  <td>:</td>
							  <td><div align="left"></div>
								<input type="text" name="inicio" maxlength="10" size="12" value="<%=inicio%>"><%calendario.DibujaImagen "fecha_oculta_inicio","1","buscador" %>
								</td>
							  <td>&nbsp;</td>
							  <td><strong>T&eacute;rmino</strong></td>
							  <td>:</td>
							  <td><div align="left"> 
								 <input type="text" name="termino" maxlength="10" size="12" value="<%=termino%>">
								  <%calendario.DibujaImagen "fecha_oculta_termino","2","buscador" %>
								  </div></td>
							</tr>
								<tr>
								<td ><strong>Egresado</strong></td>
								<td>:</td>
								<td>
								    <p align="left">
									                <%if tipo = "4" then %>
									                    <input name="tipo" type="radio" value="4" checked/>
													<%else%>
													    <input name="tipo" type="radio" value="4"/>	
													<%end if%>	
									</p>
								</td>
								<td>&nbsp;</td>
								<td><strong>Titulado</strong></td>
								<td>:</td>
								<td>
								    <p align="left">
									                <%if tipo = "8" then %>
									                    <input name="tipo" type="radio" value="8" checked/>
													<%else%>
													    <input name="tipo" type="radio" value="8"/>	
													<%end if%>	
									</p>
								</td>
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
                            <% if tipo <> "" then
							      botonera.AgregaBotonParam "excel" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "excel" , "deshabilitado", "TRUE"
							   end if
							   botonera.AgregaBotonParam "excel", "url", "alumnos_x_fecha_excel.asp?inicio=" & inicio&"&termino="&termino&"&tipo="&tipo
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
