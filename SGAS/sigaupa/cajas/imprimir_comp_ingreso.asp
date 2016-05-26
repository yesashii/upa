<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
q_ingr_nfolio_referencia = Request.QueryString("b[0][ingr_nfolio_referencia]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Impresión de comprobantes de ingreso"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "imprimir_comp_ingreso.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "imprimir_comp_ingreso.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "ingr_nfolio_referencia", q_ingr_nfolio_referencia

'---------------------------------------------------------------------------------------------------
set f_comprobantes = new CFormulario
f_comprobantes.Carga_Parametros "imprimir_comp_ingreso.xml", "comp_ingreso"
f_comprobantes.Inicializar conexion

consulta= "select a.ting_ccod, a.ingr_nfolio_referencia, a.pers_ncorr, " & vbCrLf &_
          " max(protic.trunc(a.ingr_fpago)) as ingr_fpago, sum(a.ingr_mtotal) as ingr_mtotal, " & vbCrLf &_
          " protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre " & vbCrLf &_
          " from ingresos a, movimientos_cajas b, personas c " & vbCrLf &_
          " where a.mcaj_ncorr = b.mcaj_ncorr " & vbCrLf &_
          " and a.pers_ncorr = c.pers_ncorr " & vbCrLf &_
          " and a.eing_ccod in (1, 7, 4) " & vbCrLf &_
          " and a.ting_ccod in (16, 17, 34) " & vbCrLf &_
          " and b.sede_ccod = '1' "

'response.Write("<pre>"&consulta&"<pre>")
'response.End()
if q_ingr_nfolio_referencia <>"" then
	consulta = consulta & " and cast(a.ingr_nfolio_referencia as varchar) = isnull('"&q_ingr_nfolio_referencia&"', cast(a.ingr_nfolio_referencia as varchar))"& vbCrLf
end if

if q_pers_nrut <>"" then
	consulta = consulta & " and cast(c.pers_nrut as varchar)= isnull('"&q_pers_nrut&"', cast(c.pers_nrut as varchar))"& vbCrLf
end if

consulta= consulta & " group by a.ting_ccod, a.ingr_nfolio_referencia, a.pers_ncorr " & vbCrLf &_
 					 " order by ingr_fpago asc, ingr_nfolio_referencia asc"

'sresponse.Write("<pre>"&consulta&"<pre>")
'response.End()

if not EsVacio(Request.QueryString) then
	f_comprobantes.Consultar consulta	
else
	f_comprobantes.Consultar "select '' from sexos where 1=2"
end if
v_peri_ccod=negocio.ObtenerPeriodoAcademico("POSTULACION")

if f_comprobantes.NroFilas > 0 then
	f_comprobantes.AgregaCampoCons "peri_ccod", v_peri_ccod
end if



'-------------------------------------------------------------------------------------------
set f_lista_cursos = new CFormulario
f_lista_cursos.Carga_Parametros "imprimir_comp_ingreso.xml", "lista_cursos"
f_lista_cursos.Inicializar conexion

consulta = "select b.comp_ndocto, b.comp_fdocto, b.comp_ncuotas, b.comp_mdocumento " & vbCrLf &_
           "from personas a, compromisos b  " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and b.tcom_ccod = 7 " & vbCrLf &_
		   "  and b.ecom_ccod <> 3 " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "'"
	'response.Write("<pre>"&consulta&"</pre>")	   
f_lista_cursos.Consultar consulta

'-------------------------------------------------------------------------------------------
set f_lista_contratos = new CFormulario
f_lista_contratos.Carga_Parametros "imprimir_comp_ingreso.xml", "lista_contratos"
f_lista_contratos.Inicializar conexion

v_pers_ncorr=conexion.ConsultaUno("select top 1 pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")


consulta = "select a.cont_ncorr, "& vbCrLf &_
 	" isnull(case when e.tcar_ccod=2 then "& vbCrLf &_
    "                case 	when year(a.cont_fcontrato)< 2009 then 'P'  "& vbCrLf &_
	"						when a.cont_fcontrato<= convert(datetime,'09/08/2010',103) and year(a.cont_fcontrato)> 2009 then 'PM' "& vbCrLf &_
	"                     	when protic.extrae_acentos(e.carr_tdesc) like '%magister%' and year(a.cont_fcontrato)<= 2013 then 'PV2'  "& vbCrLf &_
	"						when protic.extrae_acentos(e.carr_tdesc) like '%magister%' and b.peri_ccod > 232 then 'PG2014' end  "& vbCrLf &_
    "              else 	 "& vbCrLf &_
    "                        case when protic.ANO_INGRESO_CARRERA(b.pers_ncorr,d.carr_ccod)<2005 then " & vbCrLf &_
    "                            case when d.carr_ccod='890'or d.carr_ccod='900' or d.carr_ccod='910' then 'CN' else 'N' end " & vbCrLf &_
    "                        else  	" & vbCrLf &_
    "                            case when d.carr_ccod='890'or d.carr_ccod='900' or d.carr_ccod='910' then 'CN' " & vbCrLf &_
	"								  	when d.carr_ccod='110' and c.sede_ccod=9 and b.peri_ccod <= 232 then 'LA'  " & vbCrLf &_
    "                              		when d.carr_ccod='110' and c.sede_ccod=7 and b.peri_ccod <= 232 then 'LAC' " & vbCrLf &_
	"								  	when d.carr_ccod='110' and c.sede_ccod=9 and b.peri_ccod > 232 then 'LAL2014'  " & vbCrLf &_
    "                              		when d.carr_ccod='110' and c.sede_ccod=7 and b.peri_ccod > 232 then 'LAC2014' " & vbCrLf &_
    "                              		else 'S' end " & vbCrLf &_
    "                        end 	" & vbCrLf &_
    "                  end,'S') as post_nuevo, " & vbCrLf &_
	" b.post_ncorr,protic.obtener_nombre_carrera(b.ofer_ncorr,'CJ') as carrera,protic.trunc(a.cont_fcontrato) as fecha_contrato,  " & vbCrLf &_
	" (select peri_tdesc from periodos_academicos where peri_ccod=b.peri_ccod) as periodo, "& vbCrLf &_
	" '<a href=../REPORTESNET/Comprobante.aspx?contrato='+cast(a.cont_ncorr as varchar)+'&periodo='+cast(b.peri_ccod as varchar)+' target=_blank >Comprobante</a>' as comprobante "  & vbcrlf & _
	" From contratos a, postulantes b, ofertas_academicas c, especialidades d, carreras e " & vbCrLf &_
	" Where a.post_ncorr=b.post_ncorr" & vbCrLf &_
	" and b.ofer_ncorr=c.ofer_ncorr" & vbCrLf &_
	" and c.espe_ccod=d.espe_ccod" & vbCrLf &_
	" and a.econ_ccod <> 3 "& vbCrLf &_
	" and cast(b.pers_ncorr as varchar)='"&v_pers_ncorr&"'" & vbCrLf &_
    " and d.carr_ccod=e.carr_ccod "& vbCrLf &_ 
	" and a.audi_tusuario like 'ACTIVAR CONTRATO' "
'" and b.peri_ccod="&v_peri_ccod & vbCrLf &_	

'response.Write("<pre>"&consulta&"</pre>")		

 
f_lista_contratos.Consultar consulta	

'******************************************
' solo para que no quede linkeable el cuadro bajo al palabra comprobante
fila=0
	while f_lista_contratos.siguiente   
		f_lista_contratos.AgregaCampoFilaParam fila, "comprobante", "permiso", "lectura"
		fila=fila+1
	wend			
'*****************************************	   
f_lista_contratos.primero

v_retroactivo=conexion.consultaUno("select case when convert(datetime,getdate(),103)<= convert(datetime,'06/08/2010',103) then 1 else 0 end")
'response.Write(v_retroactivo)
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
function ValidaBusqueda()
{
	if ((isEmpty(t_busqueda.ObtenerValor(0, "pers_nrut"))) && (isEmpty(t_busqueda.ObtenerValor(0, "ingr_nfolio_referencia")))) {
		alert('Debe llenar al menos un campo de búsqueda.');
		return false;
	}
	
	return true;
}

var t_busqueda;
function InicioPagina()
{
	t_busqueda = new CTabla("b");
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
                    <table width="98%"  border="0">
                      <tr>
                        <td><div align="left"><strong>RUT : </strong></div></td>
                        <td><%f_busqueda.DibujaCampo "pers_nrut"%> 
                          - 
                            <%f_busqueda.DibujaCampo "pers_xdv"%></td>
                        <td>&nbsp;</td>
                        <td><strong>Folio : </strong></td>
                        <td><%f_busqueda.DibujaCampo "ingr_nfolio_referencia"%></td>
                        </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton "buscar"%></div></td>
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
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Comprobantes"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><%f_comprobantes.DibujaTabla%></td>
                        </tr>
                      </table>
                      <br>
                      <br>
                      <%pagina.DibujarSubtitulo "Cursos"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><%f_lista_cursos.DibujaTabla%></td>
                        </tr>
                      </table>
					  
					   <br>
                      <%pagina.DibujarSubtitulo "Contratos por periodo"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><%f_lista_contratos.DibujaTabla%></td>
                        </tr>
                      </table>
					  </td>
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
            <td width="15%" height="20"><div align="center">
              <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "salir"%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="85%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
