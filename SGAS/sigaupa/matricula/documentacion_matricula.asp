<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")

'---------- IP DE PRUEBA ----------
ip_usuario = Request.ServerVariables("REMOTE_ADDR")
'response.Write("ip_usuario = "&ip_usuario&"</br>") 
ip_de_prueba = "172.16.100.91"
'----------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Recepción de documentación de matrícula"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "documentacion_matricula.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "documentacion_matricula.xml", "busqueda"
f_busqueda.Inicializar conexion

f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

if ip_usuario = ip_de_prueba then
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
end if

'---------------------------------------------------------------------------------------------------
set f_documentos = new CFormulario
f_documentos.Carga_Parametros "documentacion_matricula.xml", "documentos2"
f_documentos.Inicializar conexion

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

v_pers_ncorr = conexion.consultauno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)  = '"&q_pers_nrut&"'")	

consulta = " select pers_ncorr,doma_ccod,doma_entregado,doma_tdesc,case doma_entregado when 0 then 'N' else 'S' end as entregado, " & vbcrlf & _
		   " case doma_retirado when 0 then 'N' else 'S' end as retirado,protic.trunc(fecha_retiro) as fecha_retiro " & vbcrlf & _
		   " from " & vbcrlf & _
		   " ( " & vbcrlf & _
		   "    select '"&v_pers_ncorr&"' as pers_ncorr,a.*, " & vbcrlf & _
		   "    (select count(*) from documentos_postulantes b " & vbcrlf & _
		   "    where a.doma_ccod=b.doma_ccod and cast(b.pers_ncorr as varchar)='"&v_pers_ncorr&"' and isnull(b.entregado,'S') <> 'N') as doma_entregado,   " & vbcrlf & _
		   "    (select count(*) from documentos_postulantes b " & vbcrlf & _
		   "    where a.doma_ccod=b.doma_ccod and cast(b.pers_ncorr as varchar)='"&v_pers_ncorr&"' and isnull(b.retirado,'N') = 'S') as doma_retirado,   " & vbcrlf & _
		   "    (select ltrim(rtrim(fecha_retiro)) from documentos_postulantes b " & vbcrlf & _
		   "    where a.doma_ccod=b.doma_ccod and cast(b.pers_ncorr as varchar)='"&v_pers_ncorr&"') as fecha_retiro   " & vbcrlf & _
		   "    from documentos_matricula a where a.doma_ccod not in (4,8) " & vbcrlf & _
		   " )table_1 " 
			
if ip_usuario = ip_de_prueba then
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("v_peri_ccod = "&v_peri_ccod&"</br>") 
'response.Write("v_pers_ncorr = "&v_pers_ncorr&"</br>") 
'response.Write("consulta = "&consulta&"</br>") 
end if
			
f_documentos.Consultar consulta

if f_documentos.NroFilas = 0 then
	f_botonera.AgregaBotonParam "guardar", "deshabilitado", "TRUE"
end if

set f_forma = new CFormulario
f_forma.Carga_Parametros "documentacion_matricula.xml", "f_forma_mat"
 
 f_forma.Inicializar conexion
 f_forma.Consultar "select ''"
 'if  EsVacio(carr_ccod) then
 ' 		f_busqueda.Agregacampoparam "carr_ccod", "filtro" , "1=2"
 'end if
 
 tfma_ccod = conexion.consultaUno("select tfma_ccod from ALUMNOS_FORMA_MATRICULA where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' order by audi_fmodificacion desc")
 f_forma.AgregaCampoCons "tfma_ccod", tfma_ccod 
 f_forma.Siguiente

if ip_usuario = ip_de_prueba then
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("v_peri_ccod = "&v_peri_ccod&"</br>") 
'response.Write("v_pers_ncorr = "&v_pers_ncorr&"</br>") 
'response.Write("consulta = "&consulta&"</br>") 
'response.Write("tfma_ccod = "&tfma_ccod&"</br>") 
end if

'--------------------------------------------------------------------------------------------------
set fc_datos = new CFormulario
fc_datos.Carga_Parametros "consulta.xml", "consulta"
fc_datos.Inicializar conexion

'consulta = "select a.pers_nrut || ' - ' || a.pers_xdv as rut, a.pers_tnombre || ' ' || a.pers_tape_paterno || ' ' || a.pers_tape_materno as nombre_completo " & vbCrLf &_
'           "from personas_postulante a " & vbCrLf &_
'		   "where a.pers_nrut = '" & q_pers_nrut & "'"
		   
consulta_1 = "select cast(a.pers_nrut as varchar) + ' - ' + a.pers_xdv as rut," & vbCrLf &_
			"         a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo " & vbCrLf &_
			"from personas_postulante a " & vbCrLf &_
			"where cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "'"
	   
fc_datos.Consultar consulta_1
fc_datos.Siguiente
'response.Write(fc_datos.nrofilas)

if ip_usuario = ip_de_prueba then
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("v_peri_ccod = "&v_peri_ccod&"</br>") 
'response.Write("v_pers_ncorr = "&v_pers_ncorr&"</br>") 
'response.Write("consulta = "&consulta&"</br>") 
'response.Write("tfma_ccod = "&tfma_ccod&"</br>") 
'response.Write("consulta_1 = "&consulta_1&"</br>") 
'response.Write("fc_datos = "&fc_datos.nrofilas&"</br>") 
end if

'response.write "select MAX(peri_ccod) from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"'"
max_periodo_matricula = conexion.consultaUno("select MAX(peri_ccod) from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"'")
'response.Write("select carr_ccod from alumnos a, ofertas_academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&max_periodo_matricula&"' and b.espe_ccod = c.espe_ccod")
'max_periodo_matricula="214"

if ip_usuario = ip_de_prueba then
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("v_peri_ccod = "&v_peri_ccod&"</br>") 
'response.Write("v_pers_ncorr = "&v_pers_ncorr&"</br>") 
'response.Write("consulta = "&consulta&"</br>") 
'response.Write("tfma_ccod = "&tfma_ccod&"</br>") 
'response.Write("consulta_1 = "&consulta_1&"</br>") 
'response.Write("fc_datos = "&fc_datos.nrofilas&"</br>") 
'response.Write("max_periodo_matricula = "&max_periodo_matricula&"</br>") 
end if

if not esVacio(max_periodo_matricula) and max_periodo_matricula <> "" then
	'response.write "select carr_ccod from alumnos a, ofertas_academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&max_periodo_matricula&"' and b.espe_ccod = c.espe_ccod"
	cod_carrera = conexion.consultaUno("select carr_ccod from alumnos a, ofertas_academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&max_periodo_matricula&"' and b.espe_ccod = c.espe_ccod")
	carrera = conexion.consultaUno("select protic.initCap(carr_tdesc) from carreras where carr_ccod ='"&cod_carrera&"'")	
	ano_ingreso = conexion.consultaUno("select protic.ANO_INGRESO_CARRERA_egresa2("&v_pers_ncorr&",'"&cod_carrera&"')")
	sede_ccod = conexion.consultaUno("select sede_ccod from alumnos a, ofertas_academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&max_periodo_matricula&"' and b.espe_ccod = c.espe_ccod and cast(c.carr_ccod as varchar)='"&cod_carrera&"'")
	sede = conexion.consultaUno("select protic.initCap(sede_tdesc) from sedes where sede_ccod ='"&sede_ccod&"'")	
	jornada = conexion.consultaUno("select case b.jorn_ccod when 1 then 'Diurna' else 'Vespertina' end from alumnos a, ofertas_academicas b,especialidades c where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(peri_ccod as varchar)='"&max_periodo_matricula&"' and b.espe_ccod = c.espe_ccod and cast(c.carr_ccod as varchar)='"&cod_carrera&"'")
end if

	v_periodo = negocio.ObtenerPeriodoAcademico("postulacion")
	sql_periodo="select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&v_periodo&"'"
	v_anio_admision=conexion.consultaUno(sql_periodo)

sql_entregados=" Select count(*) from documentos_postulantes "&_
				" where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' "&_
				" and doma_ccod in (1,2,4,6) "
'response.Write("<pre>"&sql_entregados&"</pre>")

v_entregados=conexion.consultaUno(sql_entregados)
'response.Write(v_entregados&"<br>")
'response.Flush()

if cint(ano_ingreso)=cint(v_anio_admision) and v_entregados < 4 then
	v_constancia=1
end if

if ip_usuario = ip_de_prueba then
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("v_peri_ccod = "&v_peri_ccod&"</br>") 
'response.Write("v_pers_ncorr = "&v_pers_ncorr&"</br>") 
'response.Write("consulta = "&consulta&"</br>") 
'response.Write("tfma_ccod = "&tfma_ccod&"</br>") 
'response.Write("consulta_1 = "&consulta_1&"</br>") 
'response.Write("fc_datos = "&fc_datos.nrofilas&"</br>") 
'response.Write("max_periodo_matricula = "&max_periodo_matricula&"</br>") 
'response.Write("cod_carrera = "&cod_carrera&"</br>") 
'response.Write("carrera = "&carrera&"</br>") 
'response.Write("ano_ingreso = "&ano_ingreso&"</br>") 
'response.Write("sede_ccod = "&sede_ccod&"</br>") 
'response.Write("sede = "&sede&"</br>") 
'response.Write("jornada = "&jornada&"</br>") 
'response.Write("v_periodo = "&v_periodo&"</br>") 
'response.Write("sql_periodo = "&sql_periodo&"</br>") 
'response.Write("v_anio_admision = "&v_anio_admision&"</br>") 
'response.Write("sql_entregados = "&sql_entregados&"</br>") 
'response.Write("v_entregados = "&v_entregados&"</br>") 
'response.Write("v_constancia = "&v_constancia&"</br>") 
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
function ValidaFormBusqueda()
{
	var formulario = document.buscador;
	var	rut = formulario.elements["busqueda[0][pers_nrut]"].value + '-' + formulario.elements["busqueda[0][pers_xdv]"].value;
	
	if (!valida_rut(rut)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	}
	
	return true;
	
}
function InicioPagina(formulario)
{

}
function imprimir() {
  var rut;
  var direccion;
  rut=<%=q_pers_nrut%>
  direccion="impr_doc_matricula.asp?pers_nrut="+rut;
  window.open(direccion ,"ventana1","width=520,height=540,scrollbars=yes, left=350, top=150");
<%if v_constancia=1 then%>
  direccion2="../cajas/constancia_reserva.asp?rut="+rut;
  window.open(direccion2 ,"ventana2","width=640,height=600,resizable,scrollbars=yes, left=10, top=20");
  //alert("Enviando a imprimir");
<%end if%>
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="50%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right">R.U.T. Alumno </div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                        - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
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
	<br><% if q_pers_nrut <>"" and fc_datos.nrofilas > 0 then %>
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
                </div>
				<br>				<br>
				<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="17%"><strong>NOMBRE</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="82%" ><%=fc_datos.ObtenerValor("nombre_completo")%></td>
                </tr>
				<%if not esVacio(max_periodo_matricula) and max_periodo_matricula <> "" then%>
				<tr>
                  <td width="17%"><strong>CARRERA</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="82%" ><%=carrera%></td>
                </tr>
				<tr>
                  <td width="17%"><strong>AÑO INGRESO</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="82%"><%=ano_ingreso%></td>
                </tr>
                <tr>
                  <td width="17%"><strong>SEDE</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="82%"><%=sede%></td>
                </tr>
				<tr>
                  <td width="17%"><strong>JORNADA</strong></td>
                  <td width="1%"><strong>:</strong></td>
                  <td width="82%"><%=jornada%></td>
                </tr>
				<%end if%>
              </table>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
                          <%pagina.DibujarSubtitulo "Documentos"%>                          

                      <br><div align="center"><%f_documentos.DibujaTabla%></div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><font face="Tahoma, Geneva, sans-serif" color="#990000">Seleccione modalidad de matrícula del alumno</font></td>
                  </tr>
                  <tr>
                    <td><% f_forma.dibujaCampo ("tfma_ccod") %></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("guardar")%></div></td>
				  <td><div align="center"><%f_botonera.DibujaBoton ("imprimir")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="72%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table><%end if%>
	<br>
	<br>
    <br>
	<br>
    <br>
	<br>
    <br>
	<br>
    <br>
	<br>
    <br>
	<br>
    <br>
	<br>
    <br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
