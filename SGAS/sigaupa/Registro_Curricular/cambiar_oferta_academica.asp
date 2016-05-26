<!--construido 02/06/2015 V1.0 -->

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
q_pers_nrut 	= 	Request.QueryString("buscador[0][pers_nrut]")
q_pers_xdv 		= 	Request.QueryString("buscador[0][pers_xdv]")


set pagina = new CPagina
pagina.Titulo = "Cambio oferta Postulante"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "cambio_oferta_academica.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "cambio_oferta_academica.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.Siguiente

v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")

consulta_alumno = conexion.ConsultaUno("select count(*) as contar from personas where cast( pers_ncorr as varchar) = '" & v_pers_ncorr& "'" )

if q_pers_nrut <> ""  then
'---------------------------------------------------------------------------------------------------
if consulta_alumno = "0" then
session("mensaje_error") = "El Rut no esta registrado."
end if 

set formulario = new CFormulario
formulario.Carga_Parametros "cambio_oferta_academica.xml", "datos_alumno"
formulario.Inicializar conexion
sql_comentarios ="Select protic.obtener_rut(pers_ncorr) as rut,protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre from personas where pers_nrut="&q_pers_nrut

formulario.Consultar sql_comentarios
formulario.Siguiente

'---------------------------------------------------------------------------------------------------

set datos = new CFormulario
datos.Carga_Parametros "cambio_oferta_academica.xml", "detalle_ingreso" 
datos.Inicializar conexion

consulta_documento="select distinct b.ofer_ncorr as num_ofe,b.post_ncorr as " & vbCrLf &_
"num_pos,c.peri_ccod,protic.initcap(f.peri_tdesc) as periodo," & vbCrLf &_
"protic.initcap(g.sede_tdesc) as sede, protic.initcap(e.carr_tdesc) as carrera," & vbCrLf &_
"case h.jorn_ccod when 1 then '(D)' else '(V)' end as jornada," & vbCrLf &_
"cast(d.espe_ccod as varchar)+ '-->' + protic.initcap(d.espe_tdesc) as mension," & vbCrLf &_
"case a.epos_ccod when 1 then 'No enviada' when 2 then 'Enviada' end as estado_pos, " & vbCrLf &_
"protic.initcap(i.eepo_tdesc) as estado_examen,f.anos_ccod,f.plec_ccod, h.jorn_ccod, a.pers_ncorr, b.ofer_ncorr, a.POST_BNUEVO, b.post_ncorr, c.sede_ccod, c.peri_ccod, e.carr_ccod, d.espe_ccod " & vbCrLf &_
"from postulantes a, detalle_postulantes b, ofertas_academicas c, especialidades d," & vbCrLf &_ 
"carreras e, periodos_Academicos f, sedes g, jornadas h,estado_examen_postulantes i " & vbCrLf &_
"where cast(a.pers_ncorr as varchar)= '" & v_pers_ncorr & "'" & vbCrLf &_
"and a.post_ncorr = b.post_ncorr " & vbCrLf &_
"and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
"and c.espe_ccod  = d.espe_ccod " & vbCrLf &_
"and d.carr_ccod  = e.carr_ccod " & vbCrLf &_
"and c.peri_ccod  = f.peri_ccod " & vbCrLf &_
"and c.sede_ccod  = g.sede_ccod " & vbCrLf &_
"and c.jorn_ccod  = h.jorn_ccod " & vbCrLf &_
"and b.eepo_ccod  = i.eepo_ccod " & vbCrLf &_
"and b.POST_NCORR NOT IN (SELECT POST_NCORR FROM ALUMNOS WHERE POST_NCORR=B.POST_NCORR)" & vbCrLf &_
"order by f.anos_ccod asc,f.plec_ccod asc,b.post_ncorr asc "

datos.Consultar consulta_documento

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

<script language="JavaScript">

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}


function ValidaBusqueda()
{
	rut=document.buscador.elements['buscador[0][pers_nrut]'].value+'-'+document.buscador.elements['buscador[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['buscador[0][pers_nrut]'].focus()
		document.buscador.elements['buscador[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}


</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();"onBlur="revisaVentana();">
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
                        <td width="32%"><div align="right"><strong>R.U.T</strong>.</div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("pers_nrut")%>
      -
        <%f_busqueda.DibujaCampo("pers_xdv")%>
        <%pagina.DibujarBuscaPersonas "buscador[0][pers_nrut]", "buscador[0][pers_xdv]" %></td>
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
	<%if q_pers_nrut <> "" then%>
			<form name="edicion">
			  <table width="80%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
                    <td width="15%"><strong>Rut</strong></td>
                    <td width="85%"><%formulario.dibujaCampo("rut")%></td>
                </tr>
				<tr>
                    <td><strong>Nombre</strong></td>
                    <td><%formulario.dibujaCampo("nombre")%></td>
                </tr>
                <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                <tr><td colspan="2">&nbsp;</td></tr>
               

              </table> 
              <table width="60%" border="0" align="center">
                      <tr>
						<td width="800" align="center"><%datos.DibujaTabla%></td>
						</tr>
                    </table>
              <table>
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
                        <td width="45%">&nbsp;</td>
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