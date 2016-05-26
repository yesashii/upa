<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Nómina de Egresados y Títulados Universidad."
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

Sede = negocio.ObtenerSede()
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='"&Sede&"'")

'-------------------------------------------------------------------------------

set botonera = new CFormulario
botonera.Carga_Parametros "egresados_upa.xml", "botonera"
'-------------------------------------------------------------------------------
 carr_ccod   =   request.QueryString("busqueda[0][carr_ccod]")
 jorn_ccod	=	request.querystring("busqueda[0][jorn_ccod]")
 


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "egresados_upa.xml", "busqueda"
 f_busqueda.Inicializar conexion
 peri = periodo
 
 consulta="Select '"&carr_ccod&"' as carr_ccod, '"&jorn_ccod&"' as jorn_ccod"
 f_busqueda.consultar consulta

 consulta = " select carr_ccod, carr_tdesc,jorn_ccod,jorn_tdesc from (" & vbCrLf & _
			" select distinct c.carr_ccod,c.carr_tdesc,d.jorn_ccod,d.jorn_tdesc " & vbCrLf & _
			" from ofertas_academicas a, especialidades b, carreras c,jornadas d " & vbCrLf & _
			" where a.espe_ccod=b.espe_ccod and b.carr_ccod=c.carr_ccod " & vbCrLf & _
			" and a.jorn_ccod=d.jorn_ccod " & vbCrLf & _
			" and exists (select 1 from alumnos aa where a.ofer_ncorr=aa.ofer_ncorr) " & vbCrLf & _
			" union  " & vbCrLf & _
			" select distinct b.carr_ccod, b.carr_tdesc,c.jorn_ccod,c.jorn_tdesc " & vbCrLf & _
			" from egresados_upa2 a, carreras b,jornadas c" & vbCrLf & _
			" where a.carr_ccod=b.carr_ccod " & vbCrLf & _
			" and a.jorn_ccod=c.jorn_ccod)a" & vbCrLf & _
			" order by carr_tdesc "

'response.Write("<pre>"&consulta&"</pre>")	
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta

 f_busqueda.Siguiente
 
'----------------------------------------------------------------------------------
set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "egresados_upa.xml", "f_alumnos"
f_alumnos.Inicializar conexion

 if jorn_ccod = "" and carr_ccod= "" then
    f_alumnos.consultar "select '' "
	f_alumnos.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
 end if

 consulta = " select * from ( "& vbCrLf &_
			" select cast(pers_nrut as varchar)+'-'+dbo.dv(pers_nrut) as rut, "& vbCrLf &_
			" apellidos + ' ' + nombres as alumno,'<font color=#330099><b>' + 'EGRESADO' + '</b></font>' as estado, '<font color=#330099><b>' + año + '</b></font>' as realizado,'<font color=#330099><b>' + 'No'  + '</b></font>' as en_SIGAF, año as egreso_fox  "& vbCrLf &_
			" from egresados_upa2 a where carr_ccod='"&carr_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
			" and not exists (select 1 from personas aa , alumnos ba, ofertas_academicas ca, especialidades da "& vbCrLf &_
			"                where a.pers_nrut = aa.pers_nrut and aa.pers_ncorr=ba.pers_ncorr  "& vbCrLf &_
			"                and ba.ofer_ncorr = ca.ofer_ncorr and ca.espe_ccod = da.espe_ccod "& vbCrLf &_
			"                and da.carr_ccod = a.carr_ccod and ba.emat_ccod in (4,8)) "& vbCrLf &_
			" union                 "& vbCrLf &_
			" select cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut,d.pers_tape_paterno + ' ' + d.pers_tape_materno + ' ' + d.pers_tnombre as alumno, "& vbCrLf &_
			" f.emat_tdesc as estado,e.peri_tdesc as realizado,'Sí' as en_SIGAF,(select top 1 año from egresados_upa2 aa where aa.pers_nrut=d.pers_nrut and aa.carr_ccod=c.carr_ccod) as egreso_fox"& vbCrLf &_
			" from alumnos a, ofertas_academicas b, especialidades c, personas d,periodos_Academicos e,estados_matriculas f "& vbCrLf &_
			" where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "& vbCrLf &_
			" and c.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
			" and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
			" and a.pers_ncorr = d.pers_ncorr "& vbCrLf &_
			" and b.peri_ccod = e.peri_ccod "& vbCrLf &_
			" and a.emat_ccod= f.emat_ccod "& vbCrLf &_
			" and a.emat_ccod in (4,8))a "& vbCrLf &_
			" order by alumno"& vbCrLf		   
'response.Write("<pre>"&consulta&"</pre>")			   
'response.End()
  if Request.QueryString <> "" then
      f_alumnos.consultar consulta
  else
	f_alumnos.consultar "select '' "
	f_alumnos.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if

'-------------definimos contadores para hacer totalizadores de alumnos del sistema.
consulta_instituto_sin_subir = " select count(*) from ( "& vbCrLf &_
							   " select cast(pers_nrut as varchar)+'-'+dbo.dv(pers_nrut) as rut, "& vbCrLf &_
							   " apellidos + ' ' + nombres as alumno,'<font color=#330099><b>' + 'EGRESADO' + '</b></font>' as estado, '<font color=#330099><b>' + año + '</b></font>' as realizado,'<font color=#330099><b>' + 'No'  + '</b></font>' as en_SIGAF  "& vbCrLf &_
							   " from egresados_upa2 a where carr_ccod='"&carr_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
							   " and not exists (select 1 from personas aa , alumnos ba, ofertas_academicas ca, especialidades da "& vbCrLf &_
							   "                where a.pers_nrut = aa.pers_nrut and aa.pers_ncorr=ba.pers_ncorr  "& vbCrLf &_
							   "                and ba.ofer_ncorr = ca.ofer_ncorr and ca.espe_ccod = da.espe_ccod "& vbCrLf &_
							   "                and da.carr_ccod = a.carr_ccod and ba.emat_ccod in (4,8)) and entidad='I' )a " 
							   
consulta_Universidad_sin_subir = " select count(*) from ( "& vbCrLf &_
							   " select cast(pers_nrut as varchar)+'-'+dbo.dv(pers_nrut) as rut, "& vbCrLf &_
							   " apellidos + ' ' + nombres as alumno,'<font color=#330099><b>' + 'EGRESADO' + '</b></font>' as estado, '<font color=#330099><b>' + año + '</b></font>' as realizado,'<font color=#330099><b>' + 'No'  + '</b></font>' as en_SIGAF  "& vbCrLf &_
							   " from egresados_upa2 a where carr_ccod='"&carr_ccod&"' and cast(jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
							   " and not exists (select 1 from personas aa , alumnos ba, ofertas_academicas ca, especialidades da "& vbCrLf &_
							   "                where a.pers_nrut = aa.pers_nrut and aa.pers_ncorr=ba.pers_ncorr  "& vbCrLf &_
							   "                and ba.ofer_ncorr = ca.ofer_ncorr and ca.espe_ccod = da.espe_ccod "& vbCrLf &_
							   "                and da.carr_ccod = a.carr_ccod and ba.emat_ccod in (4,8)) and entidad='U' )a " 
							   
consulta_subidos = " select count(*) from ( "& vbCrLf &_
							   " select cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut,d.pers_tape_paterno + ' ' + d.pers_tape_materno + ' ' + d.pers_tnombre as alumno, "& vbCrLf &_
					    	   " f.emat_tdesc as estado,e.peri_tdesc as realizado,'Sí' as en_SIGAF "& vbCrLf &_
   							   " from alumnos a, ofertas_academicas b, especialidades c, personas d,periodos_Academicos e,estados_matriculas f "& vbCrLf &_
							   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "& vbCrLf &_
							   " and c.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
							   " and cast(b.jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
							   " and a.pers_ncorr = d.pers_ncorr "& vbCrLf &_
							   " and b.peri_ccod = e.peri_ccod "& vbCrLf &_
							   " and a.emat_ccod= f.emat_ccod "& vbCrLf &_
							   " and a.emat_ccod in (4,8))a "

instituto_sin_subir = conexion.consultaUno(consulta_instituto_sin_subir)
universidad_sin_subir = conexion.consultaUno(consulta_Universidad_sin_subir)
subidos = conexion.consultaUno(consulta_subidos)

total_listados = cint(instituto_sin_subir) + cint(universidad_sin_subir) + cint(subidos)

total_egresados = conexion.consultaUno("select count(*) from (select distinct pers_ncorr,carr_ccod from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.emat_ccod in (4,8) ) a ")


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
           	formulario.action ="egresados_upa.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
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
                        <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5%"> <div align="left">Carrera</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="5%"> <div align="left">Jornada</div></td>
								<td width="1%"> <div align="center">:</div> </td>
								<td><% f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
                              </tr>
                           </table></td>
                        <td width="19%"><div align="center"><%botonera.dibujaboton "buscar"%></div></td>
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
              <%pagina.DibujarTituloPagina%><br>
			  <br>
			  <table align="center" width="98%">
			  	<tr>
					<td width="50%"><font color=#330099><strong>Total Alumnos Instituto sin subir</strong></font></td>
					<td width="1%"><font color=#330099><strong>:</strong></font></td>
					<td><strong><font color=#330099><%=instituto_sin_subir%></font></strong></td>
			  	</tr>
				<tr>
					<td width="50%"><font color=#330099><strong>Total Alumnos Universidad sin subir</strong></font></td>
					<td width="1%"><font color=#330099><strong>:</strong></font></td>
					<td><strong><font color=#330099><%=universidad_sin_subir%></strong></font></td>
			  	</tr>
				<tr>
					<td width="50%"><strong>Total Alumnos Subidos</strong></td>
					<td width="1%"><strong>:</strong></td>
					<td><%=subidos%></td>
			  	</tr>
				<tr>
					<td width="50%"><strong>Total Carrera</strong></td>
					<td width="1%"><strong>:</strong></td>
					<td><%=total_listados%></td>
			  	</tr>
			  </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				<tr><td align="right"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_alumnos.AccesoPagina%>
                          </div></td></tr>
                  <tr>
                    <td>
                       <%f_alumnos.dibujaTabla()%>
					  </td>
                  </tr>
				  <tr><td>&nbsp;</td></tr>
				  <tr><td align="right">Los alumnos mostrados en color corresponden a gente que no presenta estado de egresados en el sistema SAGAF</td></tr>
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
						<td><div align="center"><%if carr_ccod<>"" and jorn_ccod<>"" then
													  botonera.agregaBotonParam "excel","url","egresados_upa_excel.asp?carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod
												   	  botonera.dibujaBoton "excel"
												   end if 
						                         %></div></td>
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
