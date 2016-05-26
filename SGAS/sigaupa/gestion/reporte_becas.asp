<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
v_tdet_ccod = Request.QueryString("busqueda[0][tdet_ccod]")
v_carr_ccod = Request.QueryString("busqueda[0][carr_ccod]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Listado becas y beneficios por alumnos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "reporte_becas.xml", "botonera"

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "reporte_becas.xml", "busqueda_becas"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
'---------------------------------------------------------------------------------------------------
set f_lista_incritos = new CFormulario
f_lista_incritos.Carga_Parametros "reporte_becas.xml", "f_becas"
f_lista_incritos.Inicializar conexion
'response.Write("Largo:"&len(Request.QueryString))
if len(Request.QueryString) > 1 then
	if esVacio(v_tdet_ccod) and  esVacio(v_carr_ccod)then
		sql_filtro = ""
	else
		if v_tdet_ccod<>"" then
			sql_filtro = " and cast(g.stde_ccod as varchar)='"&v_tdet_ccod&"'  "
			f_busqueda.agregaCampoCons "tdet_ccod", v_tdet_ccod
		end if
		if v_carr_ccod<>"" then
			sql_filtro = sql_filtro+" and cast(k.carr_ccod as varchar)='"&v_carr_ccod&"' "
			f_busqueda.agregaCampoCons "carr_ccod", v_carr_ccod
		end if

	end if


			
sql_becas =" select distinct cast(sdes_mmatricula as integer) as d_matricula,cast(sdes_mcolegiatura as integer) as d_colegiatura, "& vbCrLf &_
			" cast(g.sdes_nporc_matricula as numeric) as porcentaje_matricula,cast(g.sdes_nporc_colegiatura as numeric) as porcentaje_colegiatura, "& vbCrLf &_
			" i.ingr_nfolio_referencia as comprobante,i.mcaj_ncorr as caja, "& vbCrLf &_
			" (select tdet_tdesc from tipos_detalle where tdet_ccod=g.stde_ccod) as beneficio, "& vbCrLf &_
			" protic.trunc(convert(datetime,protic.trunc(c.cont_fcontrato),103)) as fecha_asignacion, "& vbCrLf &_
			" protic.obtener_rut(a.pers_ncorr) as rut_alumno,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno, "& vbCrLf &_
			" protic.obtener_nombre_carrera(d.ofer_ncorr,'CJ') as carrera, "& vbCrLf &_
			" isnull(protic.obtener_direccion_letra(b.pers_ncorr,1,'CNPB'),protic.obtener_direccion_letra(b.pers_ncorr,2,'CNPB')) direccion_alumno "& vbCrLf &_
			" from alumnos a  "& vbCrLf &_
			" join postulantes b "& vbCrLf &_
			" 	on a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
			" 	and a.post_ncorr=b.post_ncorr "& vbCrLf &_
			" join contratos c "& vbCrLf &_
			" 	on a.matr_ncorr=c.matr_ncorr "& vbCrLf &_
			" join ofertas_academicas d "& vbCrLf &_
			" 	on b.ofer_ncorr=d.ofer_ncorr "& vbCrLf &_
			" join especialidades k "& vbCrLf &_
			" 	on d.espe_ccod=k.espe_ccod  "& vbCrLf &_    
			" join sdescuentos g "& vbCrLf &_
			" 	on a.post_ncorr=g.post_ncorr "& vbCrLf &_
			" 	and d.ofer_ncorr=g.ofer_ncorr "& vbCrLf &_
			"  join compromisos f "& vbCrLf &_
			" 	on c.cont_ncorr=f.comp_ndocto "& vbCrLf &_
			" 	and f.tcom_ccod in (1,2) "& vbCrLf &_
			"  join abonos h "& vbCrLf &_
			" 	on f.comp_ndocto=h.comp_ndocto "& vbCrLf &_
			" 	and h.tcom_ccod in (1,2) "& vbCrLf &_
			"  join ingresos i "& vbCrLf &_
			" 	on h.ingr_ncorr=i.ingr_ncorr "& vbCrLf &_
			" 	and i.ting_ccod=7 "& vbCrLf &_
			" 	--and i.ingr_nfolio_referencia=105944 "& vbCrLf &_
			" join personas j "& vbCrLf &_
			" 	on a.pers_ncorr=j.pers_ncorr      "& vbCrLf &_
			" where b.peri_ccod in ("&Periodo&") "& vbCrLf &_
			" and c.peri_ccod in ("&Periodo&") "& vbCrLf &_
			" and c.econ_ccod not in (2,3) "& vbCrLf &_
			" and g.esde_ccod in (1) " &sql_filtro& " "& vbCrLf &_
			" --and convert(datetime,cont_fcontrato,103) between  convert(datetime,'01/09/2006',103) and convert(datetime,'01/10/2007',103) "& vbCrLf &_
			" order by fecha_asignacion,beneficio "
				
else
	sql_becas="select '' where 1=2"						
end if
'response.Write("<pre>"&sql_becas&"</pre>")
f_lista_incritos.Consultar sql_becas



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


</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../mantenedores/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../mantenedores/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../mantenedores/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../mantenedores/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Tipos de Ítemes"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
			<form name="buscador">
                    <table width="438" border="0">
                      <tr> 
                        <td width="104">Beneficios</td>
                        <td width="16">:</td>
                        <td width="147"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                            <% f_busqueda.dibujaCampo ("tdet_ccod")%>
                            </font></div></td>
							<td width="18"></td>
                        <td width="131" rowspan="2"><div align="center">
                              <% f_botonera.DibujaBoton ("buscar")%>
                        </div></td>
                      </tr>
                      <tr>
                        <td>Carreras</td>
                        <td>:</td>
                        <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                          <% f_busqueda.dibujaCampo ("carr_ccod")%>
                        </font></td>
						<td></td>
                        </tr>
                    </table>
				  </form> 
                  </div>
				  <br>
				  <br>
			<%pagina.DibujarSubtitulo "Listado Alumnos con beneficios"%>  
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
					  <tr>
					  <td><div align="right"> <%f_lista_incritos.AccesoPagina%></div></td>
					  </tr>
                        <tr>
                          <td><div align="center"><%f_lista_incritos.DibujaTabla%></div></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="49%"><div align="center"><%f_botonera.DibujaBoton "salir"%></div></td>
                  <td width="35%"><div align="center">
                            <% f_botonera.DibujaBoton "excel"
							  'f_botonera.agregabotonparam "excel", "url", "inscritos_cursos_excel.asp?tdet_ccod=" & folio_envio
							%>
                          </div></td>
                  <td width="16%"><div align="center"> </div></td>
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
