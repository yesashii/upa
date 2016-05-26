<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_sede_ccod = Request.QueryString("busqueda[0][sede_ccod]")
q_econ_ccod = Request.QueryString("busqueda[0][econ_ccod]")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Resumen de Convenios"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "resumen_convenios.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "resumen_convenios.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "sede_ccod", q_sede_ccod
f_busqueda.AgregaCampoCons "econ_ccod", q_econ_ccod

set f_convenios = new CFormulario
f_convenios.Carga_Parametros "resumen_convenios.xml", "convenios"
f_convenios.Inicializar conexion
		   
consulta = "select distinct cast(datePart(day,a.cont_fcontrato)as varchar)+'-'+cast(datePart(month,a.cont_fcontrato) as varchar)+'-'+cast(datePart(year,a.cont_fcontrato) as varchar) as fecha," & vbCrLf &_
 		   " a.cont_ncorr as contrato,protic.format_rut(c.pers_nrut) as rut,f.carr_tdesc +' - '+substring(g.jorn_tdesc,1,1) as escuela," & vbCrLf &_
		   " a.cont_ncorr,f.carr_ccod as cod_carrera,h.anos_ccod as promocion," & vbCrLf &_
		   " case j.mcaj_ncorr when null then '' else 'M-'+cast(j.mcaj_ncorr as varchar) end  as caja, i.econ_tdesc as estado" & vbCrLf &_
		   " from contratos a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f," & vbCrLf &_
		   " jornadas g,periodos_academicos h,estados_contrato i,ingresos j" & vbCrLf &_
		   " where a.post_ncorr=b.post_ncorr" & vbCrLf &_
           " and a.matr_ncorr=b.matr_ncorr" & vbCrLf &_
		   " and b.pers_ncorr=c.pers_ncorr" & vbCrLf &_
		   " and b.pers_ncorr=j.pers_ncorr" & vbCrLf &_
           " and b.ofer_ncorr=d.ofer_ncorr" & vbCrLf &_
           " and d.espe_ccod=e.espe_ccod" & vbCrLf &_
           " and e.carr_ccod=f.carr_ccod" & vbCrLf &_
		   " and d.jorn_ccod=g.jorn_ccod" & vbCrLf &_
           " and a.econ_ccod=i.econ_ccod" & vbCrLf &_
		   " and d.peri_ccod=h.peri_ccod" & vbCrLf &_
		   " and j.ting_ccod='7'"
		   
if q_sede_ccod<>""  then
		   consulta= consulta & " and cast(d.sede_ccod as varchar)='"&q_sede_ccod&"'"
end if
if q_econ_ccod<>""  then
		   consulta= consulta & " and cast(a.econ_ccod as varchar)='"&q_econ_ccod&"'"
end if		   
'response.Write("<pre>"&consulta&"</pre>")		
f_convenios.Consultar consulta
'f_convenios.siguiente
'------------------------------TOTALIZADORES DE CONTRATOS----------------------------------------------------------------
consulta_nulos = "select count(*) " & vbCrLf &_  
		   " from contratos a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f,jornadas g,periodos_academicos h,estados_contrato i" & vbCrLf &_
		   " where a.post_ncorr=b.post_ncorr" & vbCrLf &_
		   " and a.matr_ncorr=b.matr_ncorr" & vbCrLf &_
		   " and b.pers_ncorr=c.pers_ncorr" & vbCrLf &_
		   " and b.ofer_ncorr=d.ofer_ncorr" & vbCrLf &_
		   " and d.espe_ccod=e.espe_ccod" & vbCrLf &_
		   " and e.carr_ccod=f.carr_ccod" & vbCrLf &_
		   " and d.jorn_ccod=g.jorn_ccod" & vbCrLf &_
		   " and a.econ_ccod=i.econ_ccod" & vbCrLf &_
		   " and d.peri_ccod=h.peri_ccod"& vbCrLf &_
		   " and cast(a.econ_ccod as varchar)='3'"
if q_sede_ccod<>""  then
		   consulta_nulos= consulta_nulos & " and cast(d.sede_ccod as varchar)='"&q_sede_ccod&"'"
end if
if q_econ_ccod<>""  then
		   consulta_nulos= consulta_nulos & " and cast(a.econ_ccod as varchar)='"&q_econ_ccod&"'"
end if

consulta_nuevos = "select count(*) " & vbCrLf &_  
		   " from contratos a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f,jornadas g,periodos_academicos h,estados_contrato i,postulantes j" & vbCrLf &_
		   " where a.post_ncorr = b.post_ncorr" & vbCrLf &_
		   " and b.post_ncorr = j.post_ncorr"& vbCrLf &_
		   " and a.matr_ncorr=b.matr_ncorr" & vbCrLf &_
		   " and b.pers_ncorr=c.pers_ncorr" & vbCrLf &_
		   " and b.ofer_ncorr=d.ofer_ncorr" & vbCrLf &_
		   " and d.espe_ccod=e.espe_ccod" & vbCrLf &_
		   " and e.carr_ccod=f.carr_ccod" & vbCrLf &_
		   " and d.jorn_ccod=g.jorn_ccod" & vbCrLf &_
		   " and a.econ_ccod=i.econ_ccod" & vbCrLf &_
		   " and cast(a.econ_ccod as varchar)<>'3'"& vbCrLf &_
		   " and d.peri_ccod=h.peri_ccod"
if q_sede_ccod<>""  then
		   consulta_nuevos= consulta_nuevos & " and cast(d.sede_ccod as varchar)='"&q_sede_ccod&"'"
end if
if q_econ_ccod<>""  then
		   consulta_nuevos= consulta_nuevos & " and cast(a.econ_ccod as varchar)='"&q_econ_ccod&"'"
end if		   

v_cantidad_nulos=conexion.consultaUno(consulta_nulos)
v_cantidad_nuevos=conexion.consultaUno(consulta_nuevos & " and j.post_bnuevo='S'")
v_cantidad_antiguos=conexion.consultaUno(consulta_nuevos & " and j.post_bnuevo='N'")
v_total=cint(v_cantidad_nuevos)+cint(v_cantidad_antiguos)+cint(v_cantidad_nulos) 

'------------------------------------------------------------------------------------------------------------------------
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
	<table width="93%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"),1%></td>
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
                        <td><div align="right">Sedes </div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("sede_ccod")%></td>
					
                      </tr>
					   <tr>
                        <td>&nbsp;</td>
                        <td width="7%">&nbsp;</td>
                        <td>&nbsp;</td>
					  </tr>
					   <tr><br>
                        <td><div align="right">Estados </div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("econ_ccod")%></td>
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
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
              </div>
              <form name="edicion" method="post">
			  <input type="hidden" name="nuevos" value="<%=v_cantidad_nuevos%>">
			  <input type="hidden" name="antiguos" value="<%=v_cantidad_antiguos%>">
			  <input type="hidden" name="nulos" value="<%=v_cantidad_nulos%>">
			  <input type="hidden" name="sede" value="<%=q_sede_ccod%>">
			  <input type="hidden" name="estado" value="<%=q_econ_ccod%>">
                <table width="99%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
					    <tr>
                           <td width="129">Emitidos Nuevos</td>
						   <td width="12">:</td>
						   <td width="152"><%=v_cantidad_nuevos%></td>
                           <td width="120">Emitidos Antiguos</td>
						   <td width="10">:</td>
						   <td width="252"><%=v_cantidad_antiguos%></td>
                        </tr>
						<tr>
                           <td width="129">Total Nulos</td>
						   <td width="12">:</td>
						   <td width="152"><%=v_cantidad_nulos%></td>
                           <td width="120">Total Emitidos</td>
						   <td width="10">:</td>
						   <td width="252"><%=v_total%></td>
                        </tr>
						<tr>
							<td colspan="6"> &nbsp;<br> </td>
						</tr>
					  </table>
				    </td>
                  </tr>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Convenios"%>
                      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
					    <tr>
                           <td align="right">P&aacute;gina:
                                    <%f_convenios.accesopagina%>
                           </td>
                        </tr>
						<tr>
                          <td><div align="center"><%f_convenios.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
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
            <td width="28%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				    <td width="14%"> <div align="center">  <%
					                       f_botonera.agregabotonparam "excel", "url", "resumen_convenios_excel.asp"
										   f_botonera.dibujaboton "excel"
										%>
									 </div>
                  </td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
