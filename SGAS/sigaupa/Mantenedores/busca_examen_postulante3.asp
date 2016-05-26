<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
function SQLExamenesPostulantes(filtro)
'response.Write(filtro&"<br>")
SQLExamenesPostulantes = "select a.pers_ncorr, cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as rut,"  & vbCrLf &_
							"       a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as nombre_completo, " & vbCrLf &_
							"       e.carr_tdesc + '-' + d.espe_tdesc as carrera,f.ofer_ncorr,d.espe_ccod,e.carr_ccod,g.eepo_tdesc," & vbCrLf &_
							"       f.eepo_ccod,f.post_ncorr,a.pers_nrut as q_pers_nrut" & vbCrLf &_
							"from personas_postulante a, postulantes b,ofertas_academicas c,especialidades d,carreras e," & vbCrLf &_
							"     detalle_postulantes f, estado_examen_postulantes g,areas_academicas h" & vbCrLf &_
							"where a.pers_ncorr = b.pers_ncorr  " & vbCrLf &_
							"  and f.post_ncorr = b.post_ncorr" & vbCrLf &_
							"  and f.eepo_ccod = g.eepo_ccod" & vbCrLf &_
							"  and f.ofer_ncorr = c.ofer_ncorr" & vbCrLf &_
							"  and c.espe_ccod = d.espe_ccod" & vbCrLf &_
							"  and d.carr_ccod = e.carr_ccod" & vbCrLf &_
							"  and e.area_ccod = h.area_ccod " & vbCrLf &_
							"  and b.peri_ccod = '"&negocio.obtenerperiodoacademico("postulacion")&"' " & vbCrLf &_
							"  and "& filtro &"" & vbCrLf &_
							"  and not exists (select 1 " & vbCrLf &_
							"                  from alumnos a2 " & vbCrLf &_
							"				  where a2.post_ncorr = b.post_ncorr " & vbCrLf &_
							"				    and a2.emat_ccod = 1)"
end function



q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
area_ccod = Request.QueryString("busqueda[0][area_ccod]")
carr_ccod = Request.QueryString("busqueda[0][carr_ccod]")

v_anula_edicion=0


'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Examenes Admisión Postulantes"

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "busca_examen_postulante.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "busca_examen_postulante.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar " select '' as carr_ccod , '' as carr_tdesc, '' as area_ccod, '' as area_tdesc, '' as peri_ccod "

f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "area_ccod", area_ccod
f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod

f_busqueda.AgregaCampoParam "peri_ccod","filtro","peri_ccod= " &negocio.obtenerperiodoacademico("postulacion")


f_busqueda.Siguiente

if q_pers_nrut<>"" and q_pers_xdv<>"" then
	sql_pers_ncorr="select pers_ncorr from personas_postulante where pers_nrut='"&q_pers_nrut&"' And pers_xdv='"&q_pers_xdv&"'"
	v_pers_ncorr=conexion.ConsultaUno(sql_pers_ncorr)
end if

'-------------------------------------------------------------------
set f_alumno = new CFormulario
f_alumno.Carga_Parametros "busca_examen_postulante.xml", "alumno"
f_alumno.Inicializar conexion

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

consulta = "select distinct a.pers_ncorr, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'ap') as nombre_completo " & vbCrLf &_
           "from personas a, alumnos b " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and b.emat_ccod = 1 " & vbCrLf &_
		   "  and a.pers_nrut = cast(cast('" & q_pers_nrut & "' as real ) as numeric)" & vbCrLf &_
		   "  and not exists (select 1 " & vbCrLf &_
		   "                  from alumnos a2, ofertas_academicas b2" & vbCrLf &_
		   "				  where a2.ofer_ncorr = b2.ofer_ncorr" & vbCrLf &_
		   "				    and b2.peri_ccod = " & v_peri_ccod & "" & vbCrLf &_
		   "					and a2.pers_ncorr = b.pers_ncorr" & vbCrLf &_
		   "					and a2.emat_ccod = 1)"
		   

'response.Write("<pre>" & consulta & "</pre>")
f_alumno.Consultar consulta
if f_alumno.NroFilas = 0 then	

	'si solo se especifica la busqueda por rut
	if EsVacio(area_ccod) and EsVacio(carr_ccod) and q_pers_nrut <> ""  and q_pers_xdv <> "" then
			filtrar = "cast(a.pers_nrut as varchar) = '"&q_pers_nrut&"'"
			consulta=SQLExamenesPostulantes(filtrar)
	end if
	'si solo se especifica la busqueda por escuela
	if EsVacio(q_pers_nrut) and EsVacio(q_pers_xdv) and EsVacio(carr_ccod) and area_ccod <> "" then 
			filtrar = "e.area_ccod = "&area_ccod&""
			consulta=SQLExamenesPostulantes(filtrar)
	end if
	'si solo se especifica la busqueda por carrera
	if EsVacio(q_pers_nrut) and EsVacio(q_pers_xdv) and EsVacio(area_ccod) and carr_ccod <> "" then
			filtrar = "e.carr_ccod = "&carr_ccod&""
			consulta=SQLExamenesPostulantes(filtrar)
	end if
	'si se especifica la busqueda por rut y escuela
	if EsVacio(carr_ccod) and q_pers_nrut <> ""  and q_pers_xdv <> "" and area_ccod <> "" then
			filtrar = "(e.area_ccod = "&area_ccod&" and cast(a.pers_nrut as varchar) = '"&q_pers_nrut&"')"
			consulta=SQLExamenesPostulantes(filtrar)
	end if
	'si se especifica la busqueda por rut y carrera
	if EsVacio(area_ccod) and q_pers_nrut <> "" and q_pers_xdv <> "" and carr_ccod <> "" then
			filtrar = "(e.carr_ccod = "&carr_ccod&" and cast(a.pers_nrut as varchar) = '"&q_pers_nrut&"')"
			consulta=SQLExamenesPostulantes(filtrar)
	end if
	'si se especifica la busqueda por escuela y carrera
	if EsVacio(q_pers_nrut) and EsVacio(q_pers_xdv) and area_ccod <> "" and carr_ccod <> "" then
			filtrar = "(e.carr_ccod = "&carr_ccod&" and e.area_ccod = "&area_ccod&")"
			consulta=SQLExamenesPostulantes(filtrar)
	end if
	'si se especifica la busqueda por rut,escuela y carrera
	if area_ccod <> "" and carr_ccod <> "" and q_pers_nrut <> "" and q_pers_xdv <> "" then
			filtrar = "(e.area_ccod = "&area_ccod&" and cast(a.pers_nrut as varchar) = '"&q_pers_nrut&"' and e.carr_ccod = "&carr_ccod&")"
			consulta=SQLExamenesPostulantes(filtrar)
	end if
	
				
			   'response.write("<pre>"&consulta&"</pre>")
			   'response.end 
	f_alumno.Consultar consulta
	if v_pers_ncorr<>"" then
		sql_examen_pagado="select cast(cast(a.comp_mneto AS integer) - (protic.total_abonado_cuota(b.tcom_ccod,  a.inst_ccod, "&_
							" a.comp_ndocto, b.dcom_ncompromiso) + protic.total_abono_documentado_cuota(b.tcom_ccod, a.inst_ccod, "&_
							" a.comp_ndocto, b.dcom_ncompromiso))as integer) AS saldo"&_
							" from compromisos a,detalle_compromisos b "&_
							" where a.pers_ncorr="&v_pers_ncorr&_
							" and a.tcom_ccod=15 "&_
							" and a.tcom_ccod=b.tcom_ccod "&_
							" and a.inst_ccod=b.inst_ccod "&_
							" And a.comp_ndocto=b.comp_ndocto "&_
							" And a.ecom_ccod=1 "
		'response.Write("<br>"&sql_examen_pagado)
		v_saldo_examen=conexion.consultaUno(sql_examen_pagado)
	'-----------------------------------------------------------------------------------------------------------------			
		sql_post_ncorr	=	"Select post_ncorr from postulantes where pers_ncorr="&v_pers_ncorr
		v_post_ncorr	=	conexion.consultaUno(sql_post_ncorr)
		sql_paga_o_no	=	"Select count(*) from postulantes where post_ncorr='"&v_post_ncorr&"' and post_bpaga='N'"
		'response.Write(sql_paga_o_no)
		v_paga			=	conexion.consultaUno(sql_paga_o_no)
	'-----------------------------------------------------------------------------------------------------------------
		if v_saldo_examen>0 and v_paga=0 then
			v_anula_edicion=1 ' no ha pagado todo
		else
			if v_paga = 1 then
				v_anula_edicion=0 ' El alumno esta exento de pago
			end if			
		end if

	end if
	if f_alumno.NroFilas = 0 then
		f_botonera.AgregaBotonParam "siguiente", "deshabilitado", "TRUE"
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

<script language="JavaScript">
function irA(parametro){
pagado=<%=v_anula_edicion%>;
//pagado=1 -> entonces el alumno si ha pagado el examen
	if (pagado==1){
		alert("El alumno aun no ha cancelado el pago para poder rendir el examen de admision");
	}else{
		window.open(parametro,'notas','resizable,scrollbars');
	}
}
//edita_examen_postulante.asp?q_pers_nrut=%q_pers_nrut%&amp;post_ncorr=%post_ncorr%&amp;ofer_ncorr=%ofer_ncorr%
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
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
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>R.U.T. Alumno</td><td>:</td><td><%f_busqueda.DIbujaCampo("pers_nrut")%> - <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td></tr>
						<tr><td>Escuela</td><td>:</td><td><%f_busqueda.DIbujaCampo("area_ccod")%></td></tr>
						<tr><td>Carrera</td><td>:</td><td><%f_busqueda.DIbujaCampo("carr_ccod")%></td></tr>
                      
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
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
			  <input type="hidden" name="act_antecedentes" value="S">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Postulante"%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_alumno.DibujaTabla%></div></td>
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
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
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
