<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_dcur_ncorr = request.querystring("b[0][dcur_ncorr]")
v_sede_ccod = request.querystring("b[0][sede_ccod]")

dgso_ncorr = 0

set pagina = new CPagina
pagina.Titulo = "Buscador de Cambio estado Secciones Otec"

set botonera =  new CFormulario
botonera.carga_parametros "estado_secciones_otec.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores

'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "estado_secciones_otec.xml", "f_busqueda" 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "dcur_ncorr", v_dcur_ncorr
 f_busqueda.AgregaCampoCons "sede_ccod", v_sede_ccod
 
set formulario = new CFormulario
formulario.Carga_Parametros "estado_secciones_otec.xml", "datos_seccion"
formulario.Inicializar conexion
 
if v_dcur_ncorr <> "" and v_sede_ccod <> "" then 
 
sql_solicitudes="SELECT dgso_ncorr,dg.dcur_ncorr,dc.dcur_tdesc,sede_tdesc,protic.Trunc(dgso_finicio)  AS dgso_finicio,protic.Trunc(dgso_ftermino) AS dgso_ftermino,e.esot_tdesc " &_
"FROM   datos_generales_secciones_otec dg,diplomados_cursos dc ,estado_seccion_otec e, sedes s " &_
"WHERE  Cast(dg.dcur_ncorr AS VARCHAR) ='"&v_dcur_ncorr&"' " &_
"AND Cast(dg.sede_ccod AS VARCHAR) ='"&v_sede_ccod&"' " &_
"and  dg.dcur_ncorr=dc.dcur_ncorr " &_
"and dg.esot_ccod = e.esot_ccod " &_
"and dg.sede_ccod = s.sede_ccod"

else
	sql_solicitudes="select ''"

end if
'response.Write(sql_solicitudes)
formulario.Consultar sql_solicitudes
formulario.Siguiente




set historial_estado = new CFormulario
historial_estado.Carga_Parametros "estado_secciones_otec.xml", "historial_estado"
historial_estado.Inicializar conexion
 
if v_dcur_ncorr <> "" and v_sede_ccod <> "" then 
 
dgso_ncorr=formulario.obtenerValor("dgso_ncorr")
 
sql_historial="select e.esot_tdesc,sohe_observacion, protic.obtener_nombre_completo(p.pers_ncorr, 'n') as audi_tusuario, s.audi_fmodificacion " &_
"from secciones_otec_historial_estado s, estado_seccion_otec e, personas p " &_
"WHERE  Cast(s.dcur_ncorr AS VARCHAR) ='"&v_dcur_ncorr&"' " &_
"AND Cast(s.sede_ccod AS VARCHAR) ='"&v_sede_ccod&"' " &_
"and s.esot_ccod = e.esot_ccod " &_
"and s.audi_tusuario = p.pers_nrut " &_
"order by audi_fmodificacion DESC"

else
	sql_historial="select ''"

end if
'response.Write(sql_historial)
historial_estado.Consultar sql_historial

if dgso_ncorr = "" then
dgso_ncorr = 0
session("mensaje_error")="No se encuentra Seccion Otec.\nVuelva a intentarlo."
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

function VentanaCambio(){

	window.open("crea_cambio_estado.asp?modulo="+<%=v_dcur_ncorr%>+"&sede="+<%=v_sede_ccod%>+"&dgso_ncorr="+<%=dgso_ncorr%>+" ","nuevo_comentario"," width=750, height=400,scrollbars,  toolbar=false, resizable");

}
	
</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();">

<table width="656" height="100%">
<tr valign="top" height="30">
	<td width="648" bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="95%">
	<tr>
		<td align="center">
	
	<table width="50%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
              <table width="98%"  border="0" align="center">
                <tr>
                    <td width="20%"><div align="center"><strong>Módulo</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><% f_busqueda.dibujaCampo ("dcur_ncorr") %></td>
                 </tr>
				  <tr>
                    <td width="20%"><div align="center"><strong>Sede</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td><% f_busqueda.dibujaCampo ("sede_ccod") %></td>
                 </tr>
				 <tr> 
				  <td colspan="3"><table width="100%">
				                      <tr>
										<td width="50%" align="right"><%botonera.dibujaboton "buscar"%></td>
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
	</td>
	</tr>
	</table>
	</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">
	<table width="93%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td><form name="edicion">
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"><%pagina.DibujarTituloPagina%> <br> </div></td>
                  </tr>	  
                </table>
                <%if v_dcur_ncorr <> "" and v_sede_ccod <> "" and dgso_ncorr <> "0" then %>
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="15%">&nbsp;</td>
                    <td width="1%">&nbsp;</td>
                    <td width="34%">&nbsp;</td>
                    <td width="16%">&nbsp;</td>
                   </tr>	 
                   <tr>
                    <td><strong>Módulo</strong></td>
                    <td><strong>:</strong></td>
                    <td colspan="3"><%formulario.dibujaCampo("dcur_tdesc")%></td>
                   </tr>
				   <tr>
                    <td><strong>Sede</strong></td>
                    <td><strong>:</strong></td>
                    <td><%formulario.dibujaCampo("sede_tdesc")%></td>
                    <td>&nbsp;</td>
                    <td width="32%">&nbsp;</td>
                   </tr>
                   <tr>
                    <td><strong>Fecha Inicio</strong></td>
                    <td><strong>:</strong></td>
                    <td><%formulario.dibujaCampo("dgso_finicio")%></td>
                    <td><strong>Fecha Final :</strong></td>
                    <td><%formulario.dibujaCampo("dgso_ftermino")%></td>
                   </tr>                   
                   <tr>
                    <td><strong>Estado Actual</strong></td>
                    <td><strong>:</strong></td>
                    <td><%formulario.dibujaCampo("esot_tdesc")%></td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                   </tr>
                   <tr>
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                   </tr>
                </table>              
                 <table border ="0" align="center" width="100%">
								<tr valign="top">
								  <td><center><%historial_estado.DibujaTabla()%></center></td>
						    </tr>
								<tr valign="top">                                
								<td>&nbsp;</td>
								</tr>																
							  </table>
                              <%end if%>
            </form></td></tr>
        </table></td>       
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>	  
    </table>
    <table width="93%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
                <tr width="9" height="8">
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="241" bgcolor="#D8D8DE">
				  <table width="100%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr><%if v_dcur_ncorr <> "" and v_sede_ccod <> "" and dgso_ncorr <> "0" then %>
                      <td><%botonera.dibujaboton "cambio"%></td>
                      <%end if%>
                    </tr>
                  </table>                </td>
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
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
