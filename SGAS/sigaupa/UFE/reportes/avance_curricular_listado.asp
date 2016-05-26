<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeOut = 150000
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Avance curricular alumnos"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "avance_curricular_listado.xml", "botonera"

'-----------------------------------------------------------------------
ufco_ncorr = request.querystring("busqueda[0][ufco_ncorr]")
'response.Write(carr_ccod)
listado = conexion.consultauno("SELECT ufco_tdescripcion FROM ufe_comparador WHERE cast(ufco_ncorr as varchar) = '" & ufco_ncorr & "'")
tabla = conexion.consultauno("SELECT ufco_ttabla FROM ufe_comparador WHERE cast(ufco_ncorr as varchar) = '" & ufco_ncorr & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "avance_curricular_listado.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"

 f_busqueda.AgregaCampoCons "ufco_ncorr", ufco_ncorr 
 f_busqueda.Siguiente
  
'---------------------------------------------------------------------------------------------------
set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "avance_curricular_listado.xml", "f_listado"
f_alumnos.Inicializar conexion
if tabla <> "" then
 consulta = "select pers_ncorr,rut,nombre,carr_ccod, carrera, plan_ccod,protic.ano_ingreso_carrera_egresa2(pers_ncorr,carr_ccod) as ingreso,estado,periodo, "& vbCrLf &_
            "    (select count(*) from malla_curricular tr where tr.plan_ccod = tra.plan_ccod   " & vbCrLf & _
		    "     and isnull(tr.mall_npermiso,0) = 0 ) as total_ramos_malla,   " & vbCrLf & _
		    "    (select count(*) from malla_curricular tr where tr.plan_ccod = tra.plan_ccod   " & vbCrLf & _
		    "     and isnull(tr.mall_npermiso,0) = 0    " & vbCrLf & _
		    "     and isnull(protic.estado_ramo_alumno(tra.pers_ncorr,tr.asig_ccod,tra.carr_ccod,tr.plan_ccod,'222'),'') <> '') as total_ramos_aprobados_o_en_curso  " & vbCrLf & _
            " From "& vbCrLf &_
			"( "& vbCrLf &_
            "	select b.pers_ncorr, cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, pers_tape_paterno + ' ' + pers_tape_materno + ' ' + pers_tnombre as nombre, "& vbCrLf &_
			"	 (select top 1 carr_tdesc from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			"	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			"	   and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as carrera, "& vbCrLf &_
			"	 (select top 1 emat_tdesc from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			"	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			"	   and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as estado, "& vbCrLf &_
            "	 (select top 1 cast(anos_ccod as varchar)+'-'+cast(plec_ccod as varchar) from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			"	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			"	   and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as periodo, "& vbCrLf &_
			"	 (select top 1 f.carr_ccod from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			"	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			"	   and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as carr_ccod, "& vbCrLf &_
			"	 (select top 1 plan_ccod from alumnos c (nolock), ofertas_academicas d, especialidades e, carreras f, estados_matriculas g, periodos_academicos h "& vbCrLf &_
			"	   where c.ofer_ncorr=d.ofer_ncorr and d.espe_ccod=e.espe_ccod and e.carr_ccod=f.carr_ccod "& vbCrLf &_
			"	   and c.pers_ncorr=b.pers_ncorr and c.emat_ccod <> 9 and c.emat_ccod=g.emat_ccod and d.peri_ccod=h.peri_ccod order by d.peri_ccod desc) as plan_ccod "& vbCrLf &_
			"	 from "&tabla&" a, personas b "& vbCrLf &_
			"	 where a.rut = cast(b.pers_nrut as varchar) "& vbCrLf &_
			"	 and exists (select 1 from alumnos tt (nolock) where tt.pers_ncorr=b.pers_ncorr and tt.emat_ccod=1) "& vbCrLf &_
			")tra "& vbCrLf &_
			" ORDER BY nombre "
else
 consulta= "select '' "
end if
f_alumnos.Consultar consulta

'response.Write(consulta)

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
  buscador.action="avance_curricular_listado.asp?busqueda[0][ufco_ncorr]=" + document.buscador.elements["busqueda[0][ufco_ncorr]"].value;
  buscador.method="POST";
  buscador.submit();
}
function enviar(formulario){
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="avance_curricular_listado.asp";
			formulario.submit();
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
                                <td width="25%"><div align="left">Listado a consultar</div></td>
                                <td width="3%"><div align="center">:</div></td>
                                <td width="72%"><% f_busqueda.dibujaCampo ("ufco_ncorr") %></td>
                              </tr>
							  <tr> 
                                <td colspan="3" align="left"><div  align="right" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
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
                    <br><%pagina.DibujarSubtitulo listado%>
                  
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%pagina.DibujarTituloPagina%>
                            <br>
							<br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%f_alumnos.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <%f_alumnos.DibujaTabla()%>
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
                            <% botonera.AgregaBotonParam "excel", "url", "avance_curricular_listado_excel.asp?tabla=" & tabla
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
