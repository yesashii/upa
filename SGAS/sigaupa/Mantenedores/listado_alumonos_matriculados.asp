<!--construido 02/06/2015 V1.0 -->

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
emat_ccod 	= 	Request.QueryString("buscador[0][emat_ccod]")
inicio 		= 	Request.QueryString("inicio")
termino 	= 	Request.QueryString("termino")


set pagina = new CPagina
pagina.Titulo = "listado de alumnos matriculados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "listado_alumonos_matriculados.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "listado_alumonos_matriculados.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "emat_ccod", emat_ccod
f_busqueda.AgregaCampoCons "inicio", inicio
f_busqueda.AgregaCampoCons "termino", termino
f_busqueda.Siguiente

if inicio  <> "" and termino  <> "" then
emat_ccod = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16"
end if


if emat_ccod <> "" and inicio  <> "" and termino  <> "" then

set datos = new CFormulario
datos.Carga_Parametros "listado_alumonos_matriculados.xml", "listado" 
datos.Inicializar conexion

consulta="select distinct b.post_ncorr,a.pers_nrut, protic.obtener_rut(a.pers_ncorr) as rut,protic.trunc(isnull(co.cont_fcontrato,i.alum_fmatricula)) as fecha_matricula, " & vbCrLf &_
"a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre, " & vbCrLf &_
"a.pers_tfono as fono, case a.pers_temail when null then '' else ''+a.pers_temail+'' end  as email, " & vbCrLf &_
"'' + j.emat_tdesc +'' as estado, h.sede_tdesc,f.carr_tdesc, g.jorn_tdesc, p.peri_tdesc, case p.PLEC_CCOD when 1 then (case b.post_bnuevo when 'N' then 'ANTIGUO' when 'S' then 'NUEVO'end) when 2 then 'ANTIGUO' end as tipo_alumno " & vbCrLf &_
",i.audi_fmodificacion as fecha_ultimo_estado " & vbCrLf &_
",(select case count(*) when 0 then 'SIN CAE' else 'CON CAE' end from sdescuentos sd where post_ncorr in (select post_ncorr from postulantes where pers_ncorr=a.PERS_NCORR and peri_ccod < p.PERI_CCOD) and sd.STDE_CCOD='1402') as tipo_alumno_cae " & vbCrLf &_
"from   personas_postulante a, postulantes b,ofertas_academicas d,especialidades e,carreras f,jornadas g, sedes h, alumnos i, estados_matriculas j, periodos_academicos p , contratos co" & vbCrLf &_
"where a.pers_ncorr = b.pers_ncorr  " & vbCrLf &_
"and b.ofer_ncorr = d.ofer_ncorr  " & vbCrLf &_
"and d.espe_ccod = e.espe_ccod  " & vbCrLf &_
"and e.carr_ccod = f.carr_ccod  " & vbCrLf &_
"and d.jorn_ccod = g.jorn_ccod  " & vbCrLf &_
"and b.peri_ccod = p.peri_ccod  " & vbCrLf &_
"and d.sede_ccod = h.sede_ccod  " & vbCrLf &_
"and b.epos_ccod = 2            " & vbCrLf &_
"and b.post_ncorr=i.post_ncorr  " & vbCrLf &_
"and b.ofer_ncorr=i.ofer_ncorr  " & vbCrLf &_
"and b.pers_ncorr=i.pers_ncorr  " & vbCrLf &_
"and i.emat_ccod in ("&emat_ccod&")         " & vbCrLf &_
"and i.emat_ccod=j.emat_ccod    " & vbCrLf &_
"and i.MATR_NCORR = co.MATR_NCORR  " & vbCrLf &_
"and  exists (select 1 from alumnos alu where b.post_ncorr=alu.post_ncorr and alu.emat_ccod in ("&emat_ccod&") and isnull(alum_nmatricula,0) <> '7777') " & vbCrLf &_
"and protic.trunc(isnull(co.cont_fcontrato,i.alum_fmatricula)) between  convert(datetime,'"&inicio&"',103) and convert(datetime,'"&termino&"',103) " 
'response.Write("<pre>"&consulta&"</pre>")
datos.Consultar consulta


if datos.nroFilas > 0 then
	cantidad_encontrados=conexion.consultaUno("Select Count(*) from ("&consulta&")a")
else
	cantidad_encontrados=0
end if


end if

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

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();"onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
    <td height="65"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="2">
                      <tr>
                        <td width="32%"><div align="left"><strong>Estado Alumno</strong>.</div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("emat_ccod")%></td>
                      </tr>
                       <tr>
                        <td width="32%"><div align="left"><strong>Fecha inicio</strong>.</div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><input type="text" id="FE-N" name="inicio" maxlength="10" size="12" value="<%=inicio%>"><%calendario.DibujaImagen "fecha_oculta_inicio","1","buscador" %>
                            (dd/mm/aaaa)</td>
                      </tr>
                       <tr>
                        <td width="32%"><div align="left"><strong>Fecha termino</strong>.</div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><input type="text" id="FE-N" name="termino" maxlength="10" size="12" value="<%=termino%>"><%calendario.DibujaImagen "fecha_oculta_termino","2","buscador" %>
                              (dd/mm/aaaa)</td>
                      </tr>
                    </table>
                    </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>	
              <br>	
</div>		
	<%if emat_ccod <> "" and inicio  <> "" and termino  <> "" then%>
			<form name="edicion">
            <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><strong>Cantidad Encontrados :&nbsp;&nbsp;</strong><%=cantidad_encontrados%>&nbsp; Alumnos
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                             <td align="right">P&aacute;gina:
                                 <%datos.accesopagina%>
                             </td>
                             </tr>
                               <tr>
                                 <td align="center">
                                    <%datos.dibujaTabla()%>
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
			 </form>  
            <%end if%>          
            </td></tr>            
      </table>
		
        </td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td width="45%"><div align="center">
                            <%if cantidad_encontrados = 0 then
								f_botonera.agregabotonparam "excel","deshabilitado","TRUE"    
							end if							
							f_botonera.DibujaBoton("excel")%>
                          </div></td>
                        <td width="55%"><div align="center">
                            <%f_botonera.DibujaBoton("salir")%>
                          </div></td>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>