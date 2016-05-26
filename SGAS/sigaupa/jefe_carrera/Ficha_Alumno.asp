<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:15/02/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:152
'********************************************************************
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 
set pagina = new CPagina
pagina.Titulo = "Ficha del Alumno"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Ficha_Alumno.xml", "busqueda_alumno"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito

 set botonera = new CFormulario
 botonera.Carga_Parametros "Ficha_Alumno.xml", "botonera"
 '-----------------------------------------------------------------------------------------

 set f_alumno = new CFormulario
 f_alumno.Carga_Parametros "parametros.xml", "tabla"
 f_alumno.Inicializar conexion
 
sql ="SELECT max(b.peri_ccod), a.sexo_ccod, u.peri_tdesc as periodo, a.pers_ncorr, "& vbCrLf &_
"	protic.obtener_rut(a.pers_ncorr) as rut_alumno, l.emat_tdesc as estado_matricula,  "& vbCrLf &_
"	case e.cole_tdesc when '' then a.pers_tcole_egreso else e.cole_tdesc end as colegio_egreso, "& vbCrLf &_
"	f.ciud_tdesc as ciud_colegio, f.ciud_tcomuna as comuna_colegio, "& vbCrLf &_
"	case g.tcol_tdesc when '' then a.pers_ttipo_ensenanza else g.tcol_tdesc end as tipo_colegio, "& vbCrLf &_
"	h.regi_tdesc as region_col, i.eciv_tdesc, j.sexo_tdesc, k.pais_tdesc, a.pers_temail,"& vbCrLf &_
"	protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno, d.tens_tdesc,"& vbCrLf &_
"	a.pers_fnacimiento, case a.pers_tfono when '' then s.dire_tfono else a.pers_tfono end as fono,  "& vbCrLf &_
"	case a.pers_tcelular when '' then s.dire_tcelular else a.pers_tcelular end as celular,  "& vbCrLf &_
"	a.pers_nnota_ens_media, a.pers_nano_egr_media, n.espe_tdesc, o.carr_tdesc, p.sede_tdesc, "& vbCrLf &_
"	q.jorn_tdesc, r.tpad_tdesc, b.post_npaa_verbal, b.post_npaa_matematicas, b.post_nano_paa, "& vbCrLf &_
"	s.dire_tcalle, s.dire_tnro, s.dire_tpoblacion, s.dire_tblock, s.dire_tdepto, "& vbCrLf &_
"	t.ciud_tdesc as ciud_alumno, t.ciud_tcomuna as comuna_alumno, c.alum_nmatricula "& vbCrLf &_
"	FROM personas a "& vbCrLf &_
"	join postulantes b "& vbCrLf &_
"    	on a.pers_ncorr = b.pers_ncorr "& vbCrLf &_
"	join alumnos c "& vbCrLf &_
"    	on b.post_ncorr = c.post_ncorr "& vbCrLf &_
"	left outer join tipos_ensenanza_media d "& vbCrLf &_
"    	on a.tens_ccod = d.tens_ccod "& vbCrLf &_
"	left outer join colegios e "& vbCrLf &_
"    	on a.cole_ccod = e.cole_ccod "& vbCrLf &_
"	left outer join ciudades f "& vbCrLf &_
"    	on e.ciud_ccod = f.ciud_ccod "& vbCrLf &_
"	left outer join tipos_colegios g "& vbCrLf &_
"    	on e.tcol_ccod = g.tcol_ccod "& vbCrLf &_
"	left outer join regiones h "& vbCrLf &_
"    	on f.regi_ccod = h.regi_ccod "& vbCrLf &_
"	left outer join estados_civiles i "& vbCrLf &_
"  	  	on a.eciv_ccod = i.eciv_ccod "& vbCrLf &_
"	left outer join sexos j "& vbCrLf &_
"    	on a.sexo_ccod = j.sexo_ccod "& vbCrLf &_
"	left outer join paises k "& vbCrLf &_
"    	on a.pais_ccod = k.pais_ccod "& vbCrLf &_
"	join estados_matriculas l "& vbCrLf &_
"    	on c.emat_ccod = l.emat_ccod "& vbCrLf &_
"	join ofertas_academicas m "& vbCrLf &_
"    	on b.ofer_ncorr = m.ofer_ncorr "& vbCrLf &_
"	join especialidades n "& vbCrLf &_
"    	on m.espe_ccod = n.espe_ccod "& vbCrLf &_
"	join carreras o "& vbCrLf &_
"    	on n.carr_ccod = o.carr_ccod "& vbCrLf &_
"	join sedes p "& vbCrLf &_
"    	on m.sede_ccod = p.sede_ccod "& vbCrLf &_
"	join jornadas q "& vbCrLf &_
"    	on m.jorn_ccod = q.jorn_ccod "& vbCrLf &_
"	left outer join tipos_pruebas_admision r "& vbCrLf &_
"    	on b.tpad_ccod = r.tpad_ccod "& vbCrLf &_
"	join direcciones s "& vbCrLf &_
"    	on a.pers_ncorr = s.pers_ncorr "& vbCrLf &_
"	join ciudades t "& vbCrLf &_
"    	on s.ciud_ccod = t.ciud_ccod "& vbCrLf &_
"	join periodos_academicos u "& vbCrLf &_
"    	on b.peri_ccod = u.peri_ccod "& vbCrLf &_
"	WHERE c.emat_ccod <> 9 "& vbCrLf &_    
"	and s.tdir_ccod = 1 "& vbCrLf &_     
"	and cast(a.pers_nrut as varchar) ='" & rut_alumno & "' "& vbCrLf &_
"	GROUP BY b.peri_ccod, a.pers_ncorr,l.emat_tdesc, d.tens_tdesc, "& vbCrLf &_ 
"	e.cole_tdesc, a.pers_tcole_egreso, f.ciud_tdesc, "& vbCrLf &_
"	f.ciud_tcomuna, g.tcol_tdesc, a.pers_ttipo_ensenanza, h.regi_tdesc, i.eciv_tdesc, j.sexo_tdesc, k.pais_tdesc, "& vbCrLf &_
"	a.pers_fnacimiento, a.pers_tfono, s.dire_tfono,  "& vbCrLf &_
"	a.pers_tcelular, s.dire_tcelular, a.pers_temail, "& vbCrLf &_
"	a.pers_nnota_ens_media, a.pers_nano_egr_media, n.espe_tdesc, o.carr_tdesc, p.sede_tdesc, q.jorn_tdesc, r.tpad_tdesc, "& vbCrLf &_
"	b.post_npaa_verbal, b.post_npaa_matematicas, b.post_nano_paa, s.dire_tcalle, s.dire_tnro, s.dire_tpoblacion, s.dire_tblock, "& vbCrLf &_
"	s.dire_tdepto, t.ciud_tdesc, t.ciud_tcomuna, c.alum_nmatricula, u.peri_tdesc, a.sexo_ccod "& vbCrLf &_
"	ORDER BY cast(b.peri_ccod as numeric) DESC "& vbCrLf


  
  if Request.QueryString <> "" then
	 f_alumno.consultar sql
     f_alumno.siguiente
	 alumno = f_alumno.Obtenervalor ("nombre_alumno")
	 if alumno <> "" then
	 else
	   mensaje =  "Alumno no encontrado"
	 end if
  else
	f_alumno.consultar "select '' where 1 = 2"	
	mensaje=""
  end if
 

'---------------------------------------------------------------------
  set f_direcciones = new CFormulario
 f_direcciones.Carga_Parametros "Ficha_Alumno.xml", "f_direcciones"
 f_direcciones.inicializar conexion
 
'  sql = "select b.TDIR_TDESC, a.dire_tcalle, a.dire_tnro, a.dire_tpoblacion, a.dire_tblock, a.dire_tdepto,  "& vbCrLf &_
'               "c.ciud_tdesc, c.ciud_tcomuna, a.dire_tfono, a.dire_tcelular "& vbCrLf &_
'		"from direcciones a, tipos_direcciones b, ciudades c, personas d  "& vbCrLf &_
'		"where a.tdir_ccod = b.tdir_ccod "& vbCrLf &_
'		  "and a.ciud_ccod *= c.ciud_ccod  "& vbCrLf &_
'		  "and a.pers_ncorr = d.pers_ncorr  "& vbCrLf &_
'		  "and cast(d.pers_nrut as varchar) ='" & rut_alumno & "' "& vbCrLf

  sql = "select b.TDIR_TDESC, a.dire_tcalle, a.dire_tnro, a.dire_tpoblacion, a.dire_tblock, a.dire_tdepto,  "& vbCrLf &_
               "c.ciud_tdesc, c.ciud_tcomuna, a.dire_tfono, a.dire_tcelular "& vbCrLf &_
		"from direcciones a INNER JOIN tipos_direcciones b "& vbCrLf &_
		"ON a.tdir_ccod = b.tdir_ccod "& vbCrLf &_
		"LEFT OUTER JOIN ciudades c "& vbCrLf &_
		"ON a.ciud_ccod = c.ciud_ccod "& vbCrLf &_
		"INNER JOIN  personas d "& vbCrLf &_
		"ON a.pers_ncorr = d.pers_ncorr "& vbCrLf &_
		"WHERE cast(d.pers_nrut as varchar) = '" & rut_alumno & "'"

'response.Write("<pre>"&sql&"</pre>")
'response.Flush()
'response.End()
 f_direcciones.consultar sql		  

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
function Validar()
{
	formulario = document.buscador;
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	return true;
	}
	
	
</script>


</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                        <td width="36%"><div align="right">RUT del Alumno</div></td>
                        <td width="5%"><div align="center">:</div></td>
                        <td width="47%"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                            <% f_busqueda.DibujaCampo ("pers_nrut") %>
                            - 
                            <% f_busqueda.DibujaCampo ("pers_xdv") %>
                            </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div></td>
                        <td width="12%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
                <td>
                  <%
				  if alumno <> "" then
				    pagina.DibujarLenguetas array(Array("Datos Alumno"), Array("Avance Curricular","Ficha_Alumno_Avance.asp?busqueda[0][pers_nrut]=" & rut_alumno  & "&busqueda[0][pers_xdv]=" & rut_alumno_digito), Array("Notas Parciales","Ficha_Alumno_Notas.asp?busqueda[0][pers_nrut]=" & rut_alumno  & "&busqueda[0][pers_xdv]=" & rut_alumno_digito)), 1 
                  else
				    pagina.DibujarLenguetas Array("Datos Alumno","Avance Curricular","Notas Parciales"), 1 
				  end if
				  %>
				</td>
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
                    <td>								                  
					      <%if alumno <> "" then %>
						  <table width="100%" border="0">
                            <tr> 
                              <td colspan="6"> <% pagina.DibujarSubtitulo "Antecedentes Personales"  %> </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                              <td colspan="4">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><strong>Nombre</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td colspan="4"><b><font color="#666677" size="2"> 
                                <%=f_alumno.Obtenervalor ("nombre_alumno")%> </font></b></font> </td>
                            </tr>
                            <tr> 
                              <td><strong>Carrera</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td colspan="4"> <b><font color="#666677" size="2"> 
                                <%=f_alumno.Obtenervalor ("carr_tdesc") & " - " &  f_alumno.Obtenervalor ("espe_tdesc")%> </font></b> <div align="center"></div></td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                              <td width="5%">&nbsp;</td>
                              <td width="30%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><strong>Sede</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("sede_tdesc")%></td>
                              <td>&nbsp;</td>
                              <td colspan="2" rowspan="7"> <div align="center"><img src="foto.asp?rut_alumno=<%=rut_alumno%>" width=185 height="139" border="0"></div>
                                <div align="center"></div>
                                <div align="center"></div>
                                <div align="center"></div></td>
                            </tr>
                            <tr> 
                              <td><strong>Jornada</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("jorn_tdesc")%></td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="18%"><strong>N&ordm; Matricula</strong></td>
                              <td width="6%"><div align="center"><strong>:</strong></div></td>
                              <td width="21%"><%=f_alumno.Obtenervalor ("alum_nmatricula")%></td>
                              <td width="20%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><strong>Estado Matricula</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("estado_matricula")%></td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><strong>RUT</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("rut_alumno")%></td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><strong>F. Nacimiento</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("pers_fnacimiento")%></td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><strong>Estado Civil</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("eciv_tdesc")%></td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><strong>Periodo</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td colspan="4"><%=f_alumno.Obtenervalor ("periodo")%></td>
                            </tr>
                            <tr> 
                              <td><strong>Sexo</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td colspan="4"><%=f_alumno.Obtenervalor ("sexo_tdesc")%></td>
                            </tr>
                            <tr> 
                              <td><strong>Email</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td colspan="4"><%=f_alumno.Obtenervalor ("pers_temail")%></td>
                            </tr>
                            <tr> 
                              <td colspan="6">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="6"> <% pagina.DibujarSubtitulo "Direcciones"  %> </td>
                            </tr>
                            <tr> 
                              <td colspan="6">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="6"><% f_direcciones.dibujaTabla%></td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                              <td colspan="4">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="6"> <div align="center"> 
                                  <% pagina.DibujarSubtitulo "Antecedentes Academicos"  %>
                                </div></td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                              <td><div align="center"></div></td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><strong>Colegio de Egreso</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td colspan="4"><%=f_alumno.Obtenervalor ("colegio_egreso")%></td>
                            </tr>
                            <tr> 
                              <td><strong>Tipo Colegio</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("tipo_colegio")%></td>
                              <td><strong>Tipo Ense&ntilde;a&ntilde;za</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("tens_tdesc")%></td>
                            </tr>
                            <tr> 
                              <td><strong>Ciudad</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("ciud_colegio")%></td>
                              <td><strong>Comuna</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("comuna_colegio")%></td>
                            </tr>
                            <tr> 
                              <td><strong>A&ntilde;o de Egreso</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("pers_nano_egr_media")%></td>
                              <td><strong>Nota</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("pers_nnota_ens_media")%></td>
                            </tr>
                            <tr> 
                              <td><strong>Prueba de Admisi&oacute;n</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("tpad_tdesc")%></td>
                              <td><strong>A&ntilde;o Prueba</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("post_nano_paa")%></td>
                            </tr>
                            <tr> 
                              <td><strong>Pje. Verbal</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("post_npaa_verbal")%></td>
                              <td><strong>Pje. Matem&aacute;ticas</strong></td>
                              <td><div align="center"><strong>:</strong></div></td>
                              <td><%=f_alumno.Obtenervalor ("post_npaa_matematicas")%></td>
                            </tr>
                          </table>
						  <% else %>
						  <table width="100%">
                            <tr>
						      <td> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"> 
                                  <%=mensaje%> </font></b></font> </div></td>
						  </tr>
						  </table>
						<%end if%>
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
            <td width="19%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"> 
                            <%
				  if alumno <> "" then
				    botonera.agregaBotonParam "siguiente", "deshabilitado", "false"
				  else
				    botonera.agregaBotonParam "siguiente", "deshabilitado", "true"
				  end if
				  botonera.agregaBotonParam "siguiente" , "url",  "ficha_alumno_Avance.asp?busqueda[0][pers_nrut]=" & rut_alumno  & "&busqueda[0][pers_xdv]=" & rut_alumno_digito
				  botonera.dibujaBoton "siguiente"
				  %>
                          </div></td>
                  <td><div align="center">
                            <%botonera.dibujaBoton "lanzadera"%>
                          </div></td>                 
                </tr>
              </table>
            </div></td>
            <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
