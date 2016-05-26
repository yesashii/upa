<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")

'q_carr_ccod = Request.QueryString("b[0][carr_ccod]")
'q_espe_ccod = Request.QueryString("b[0][espe_ccod]")

q_plan_ccod = Request.QueryString("b2[0][plan_ccod]")
q_peri_ccod = Request.QueryString("b2[0][peri_ccod]")
q_sapl_ncorr = Request.QueryString("b2[0][sapl_ncorr]")



'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Adm. Requisitos de Alumnos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


v_sede_ccod = negocio.ObtenerSede

if EsVacio(q_pers_nrut) then
	q_pers_nrut = Request.QueryString("b2[0][pers_nrut]")
	q_pers_xdv = Request.QueryString("b2[0][pers_xdv]")
	
else
	nombre_alumno =conexion.consultaUno("select pers_tnombre +' '+ pers_tape_paterno + ' '+pers_tape_materno from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	rut_alumno = q_pers_nrut + " - " + q_pers_xdv
end if


'---------------------------------------------------------------------------------------------------
set f_botonera_g = new CFormulario
f_botonera_g.Carga_Parametros "botonera_generica.xml", "botonera"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_requisitos_titulacion.xml", "botonera"


f_botonera.AgregaBotonUrlParam "agregar", "pers_nrut", q_pers_nrut
f_botonera.AgregaBotonUrlParam "agregar", "sapl_ncorr", q_sapl_ncorr


'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "adm_requisitos_titulacion.xml", "busqueda"
f_busqueda.Inicializar conexion

f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


'------------------------------------------------------------------------------------------------
set f_busqueda2 = new CFormulario
f_busqueda2.Carga_Parametros "adm_requisitos_titulacion.xml", "busqueda2"
f_busqueda2.Inicializar conexion

SQL = " select distinct a.pers_ncorr"  & vbCrlf & _
      " from personas a, alumnos b " & vbCrlf & _
      " where a.pers_ncorr = b.pers_ncorr " & vbCrlf & _
      "   and b.emat_ccod = 1 " & vbCrlf & _
      "   and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "'"
'response.Write("<pre>"&SQL&"</pre>")
f_busqueda2.Consultar SQL
f_busqueda2.Siguiente

mostrar_busqueda_2 = false
if f_busqueda2.NroFilas > 0 then
	f_busqueda2.AgregaCampoCons "pers_nrut", q_pers_nrut
	f_busqueda2.AgregaCampoCons "pers_xdv", q_pers_xdv
	f_busqueda2.AgregaCampoCons "plan_ccod", q_plan_ccod
	f_busqueda2.AgregaCampoCons "peri_ccod", q_peri_ccod
	f_busqueda2.AgregaCampoCons "sapl_ncorr", q_sapl_ncorr
    mostrar_busqueda_2 = true
end if

'SQL = " select a.plan_ccod, a.plan_estudios, b.sapl_ncorr, decode(b.sapl_ncorr, null, 'No se han configurado salidas para este plan.', c.tspl_tdesc || ' : ' || b.sapl_tdesc) as salida, d.peri_ccod, nvl(d.peri_tdesc, 'No se han configurado salidas para este plan.') as peri_tdesc" & vbCrlf & _
'      " from (" & vbCrlf & _
'     " 		select distinct f.carr_tdesc || ' - ' || e.espe_tdesc || ' - Plan ' || d.plan_ncorrelativo as plan_estudios, b.plan_ccod" & vbCrlf & _
'     " 		from personas a, alumnos b, planes_estudio d, especialidades e, carreras f" & vbCrlf & _
'     " 		where a.pers_ncorr = b.pers_ncorr" & vbCrlf & _
'     " 		  and b.plan_ccod = d.plan_ccod" & vbCrlf & _
'     " 		  and d.espe_ccod = e.espe_ccod" & vbCrlf & _
'     " 		  and e.carr_ccod = f.carr_ccod" & vbCrlf & _
'     " 		  and b.emat_ccod = 1" & vbCrlf & _
'     " 		  and a.pers_nrut = '" & q_pers_nrut & "'" & vbCrlf & _
'     " 	  ) a, salidas_plan b, tipos_salidas_plan c, periodos_academicos d" & vbCrlf & _
'     " where a.plan_ccod = b.plan_ccod (+)" & vbCrlf & _
'      "   and b.tspl_ccod = c.tspl_ccod (+)" & vbCrlf & _
'      "   and b.peri_ccod = d.peri_ccod (+)" & vbCrlf & _
'      "   and b.sede_ccod (+) = '" & v_sede_ccod & "'" & vbCrlf & _
'      " order by plan_estudios asc, b.tspl_ccod asc " 

SQL = " select a.plan_ccod, a.plan_estudios, b.sapl_ncorr, " & vbCrlf & _
      " case b.sapl_ncorr when null then 'No se han configurado salidas para este plan.' else c.tspl_tdesc + ' : ' + b.sapl_tdesc end as salida," & vbCrlf & _
      " d.peri_ccod, isnull(d.peri_tdesc, 'No se han configurado salidas para este plan.') as peri_tdesc " & vbCrlf & _
	  " from (" & vbCrlf & _
	  " 		select distinct f.carr_tdesc + ' - ' + e.espe_tdesc + d.plan_tdesc as plan_estudios, b.plan_ccod" & vbCrlf & _
	  " 		from personas a, alumnos b, planes_estudio d, especialidades e, carreras f" & vbCrlf & _
	  " 		where a.pers_ncorr = b.pers_ncorr" & vbCrlf & _
	  " 		  and b.plan_ccod = d.plan_ccod" & vbCrlf & _
	  " 		  and d.espe_ccod = e.espe_ccod" & vbCrlf & _
	  " 		  and e.carr_ccod = f.carr_ccod" & vbCrlf & _
	  " 		  and b.emat_ccod = 1" & vbCrlf & _
	  " 		  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "'" & vbCrlf & _
	  " 	  ) a " & vbCrlf & _
	  "        left outer join salidas_plan b" & vbCrlf & _
	  "            on a.plan_ccod = b.plan_ccod and '" & v_sede_ccod & "' = cast(b.sede_ccod as varchar)" & vbCrlf & _
	  "        left outer join tipos_salidas_plan c" & vbCrlf & _
	  "            on b.tspl_ccod = c.tspl_ccod " & vbCrlf & _
	  "        left outer join periodos_academicos d" & vbCrlf & _
	  "            on b.peri_ccod = d.peri_ccod " & vbCrlf & _
	  " order by plan_estudios asc, b.tspl_ccod asc"
 
'response.Write("<pre>"&SQL&"</pre>")
f_busqueda2.InicializaListaDependiente "busqueda", SQL


'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "adm_requisitos_titulacion.xml", "encabezado"
f_encabezado.Inicializar conexion

'SQL = " select d.carr_tdesc, c.espe_tdesc, b.plan_ncorrelativo, e.tspl_tdesc, a.sapl_tdesc, f.peri_tdesc," & vbCrlf & _
'      "        obtener_rut(g.pers_ncorr) as rut, obtener_nombre_completo(g.pers_ncorr) as nombre," & vbCrlf & _
'      " 	   a.sapl_npond_asignaturas, nvl(sum(nvl(h.repl_nponderacion, 0)), 0) as pond_adicionales," & vbCrlf & _
'      " 	   a.sapl_npond_asignaturas + nvl(sum(nvl(h.repl_nponderacion, 0)), 0) as pond_requisitos" & vbCrlf & _
'      " from salidas_plan a, planes_estudio b, especialidades c, carreras d, tipos_salidas_plan e, periodos_academicos f, personas g," & vbCrlf & _
'      "      requisitos_plan h     " & vbCrlf & _
'      " where a.plan_ccod = b.plan_ccod" & vbCrlf & _
'      "   and b.espe_ccod = c.espe_ccod" & vbCrlf & _
'      "   and c.carr_ccod = d.carr_ccod" & vbCrlf & _
'      "   and a.tspl_ccod = e.tspl_ccod" & vbCrlf & _
'      "   and a.peri_ccod = f.peri_ccod" & vbCrlf & _
'      "   and a.sapl_ncorr = h.sapl_ncorr (+)" & vbCrlf & _
'      "   and exists (select 1" & vbCrlf & _
'     "                from alumnos a2			   " & vbCrlf & _
'      " 			   where a2.emat_ccod = 1" & vbCrlf & _
'      " 			     and a2.pers_ncorr = g.pers_ncorr" & vbCrlf & _
'      " 				 and a2.plan_ccod = b.plan_ccod)" & vbCrlf & _
'      "   and g.pers_nrut = '" & q_pers_nrut & "'" & vbCrlf & _
'      "   and a.sapl_ncorr = '" & q_sapl_ncorr & "'" & vbCrlf & _
'      " group by d.carr_tdesc, c.espe_tdesc, b.plan_ncorrelativo, e.tspl_tdesc, a.sapl_tdesc, f.peri_tdesc, g.pers_ncorr, a.sapl_npond_asignaturas"

SQL = "select d.carr_tdesc, c.espe_tdesc, b.plan_tdesc, e.tspl_tdesc, a.sapl_tdesc, f.peri_tdesc, " & vbCrlf & _
	  "        protic.obtener_rut(g.pers_ncorr) as rut, protic.obtener_nombre_completo(g.pers_ncorr,'n') as nombre," & vbCrlf & _
	  " 	   a.sapl_npond_asignaturas, isnull(sum(isnull(h.repl_nponderacion, 0)), 0) as pond_adicionales," & vbCrlf & _
	  " 	   a.sapl_npond_asignaturas + isnull(sum(isnull(h.repl_nponderacion, 0)), 0) as pond_requisitos" & vbCrlf & _
	  " from salidas_plan a, planes_estudio b, especialidades c, carreras d, tipos_salidas_plan e, periodos_academicos f, personas g," & vbCrlf & _
	  "      requisitos_plan h     " & vbCrlf & _
	  " where a.plan_ccod = b.plan_ccod " & vbCrlf & _
	  "   and b.espe_ccod = c.espe_ccod " & vbCrlf & _
	  "   and c.carr_ccod = d.carr_ccod " & vbCrlf & _
	  "   and a.tspl_ccod = e.tspl_ccod " & vbCrlf & _
	  "   and a.peri_ccod = f.peri_ccod " & vbCrlf & _
	  "   and a.sapl_ncorr *= h.sapl_ncorr " & vbCrlf & _
	  "   and exists (select 1" & vbCrlf & _
	  "                from alumnos a2	" & vbCrlf & _
	  " 			   where a2.emat_ccod = 1 " & vbCrlf & _
	  " 			     and a2.pers_ncorr = g.pers_ncorr" & vbCrlf & _
	  " 				 and a2.plan_ccod = b.plan_ccod)" & vbCrlf & _
	  "   and cast(g.pers_nrut as varchar) = '" & q_pers_nrut & "'" & vbCrlf & _
	  "   and cast(a.sapl_ncorr as varchar) = '" & q_sapl_ncorr & "'" & vbCrlf & _
	  " group by d.carr_tdesc, c.espe_tdesc, b.plan_tdesc, e.tspl_tdesc, a.sapl_tdesc, f.peri_tdesc, g.pers_ncorr, a.sapl_npond_asignaturas"
	  
'response.Write("<pre>"&SQL&"</pre>")

f_encabezado.Consultar SQL
f_encabezado.Siguiente
v_pond_requisitos = f_encabezado.ObtenerValor("pond_requisitos")


'---------------------------------------------------------------------------------------------------
set f_requisitos = new CFormulario
f_requisitos.Carga_Parametros "adm_requisitos_titulacion.xml", "requisitos_ingresados"
f_requisitos.Inicializar conexion

'SQL = " select c.reti_ncorr, e.treq_tdesc, f.teva_tdesc, b.repl_nponderacion, to_char(c.reti_nnota, '0.0') as reti_nnota, c.ereq_ccod, c.reti_ftermino" & vbCrlf & _
'      " from salidas_plan a, requisitos_plan b, requisitos_titulacion c, personas d, tipos_requisitos_titulo e, tipos_evaluacion_requisitos f" & vbCrlf & _
'      " where a.sapl_ncorr = b.sapl_ncorr" & vbCrlf & _
'      "   and b.repl_ncorr = c.repl_ncorr" & vbCrlf & _
'      "   and c.pers_ncorr = d.pers_ncorr" & vbCrlf & _
'      "   and b.treq_ccod = e.treq_ccod" & vbCrlf & _
'      "   and e.teva_ccod = f.teva_ccod" & vbCrlf & _
'      "   and d.pers_nrut = '" & q_pers_nrut & "'" & vbCrlf & _
'      "   and a.sapl_ncorr = '" & q_sapl_ncorr & "'" & vbCrlf & _
'      " order by b.treq_ccod"
	  
SQL = " select c.reti_ncorr, e.treq_tdesc, f.teva_tdesc, b.repl_nponderacion, cast(c.reti_nnota as decimal(2,1)) as reti_nnota, c.ereq_ccod, c.reti_ftermino" & vbCrlf & _
      " from salidas_plan a, requisitos_plan b, requisitos_titulacion c, personas d, tipos_requisitos_titulo e, tipos_evaluacion_requisitos f" & vbCrlf & _
      " where a.sapl_ncorr = b.sapl_ncorr" & vbCrlf & _
      "   and b.repl_ncorr = c.repl_ncorr" & vbCrlf & _
      "   and c.pers_ncorr = d.pers_ncorr" & vbCrlf & _
      "   and b.treq_ccod = e.treq_ccod" & vbCrlf & _
      "   and e.teva_ccod = f.teva_ccod" & vbCrlf & _
      "   and cast(d.pers_nrut as varchar)= '" & q_pers_nrut & "'" & vbCrlf & _
      "   and cast(a.sapl_ncorr as varchar)= '" & q_sapl_ncorr & "'" & vbCrlf & _
      " order by b.treq_ccod"	  

'response.Write("<pre>"&SQL&"</pre>")
'response.End()
f_requisitos.Consultar SQL


if f_encabezado.NroFilas = 0 then
	'f_requisitos.AgregaParam "mensajeError", "El alumno no registra matrícula en el plan buscado."
	f_botonera.AgregaBotonParam "agregar", "deshabilitado", "TRUE"
end if

if f_requisitos.NroFilas = 0 then
	f_botonera.AgregaBotonParam "eliminar", "deshabilitado", "TRUE"
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

<% f_busqueda2.GeneraJS %>

<script language="JavaScript">
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
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0">
                      <tr>
                        <td width="17%"><strong>RUT Alumno </strong></td>
                        <td width="3%"><strong>:</strong></td>
                        <td width="80%"><%f_busqueda.DibujaCampo "pers_nrut"%>-<%f_busqueda.DibujaCampo "pers_xdv"%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera_g.DibujaBoton "buscar"%></div></td>
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
              <form name="buscador2">
			  <% if mostrar_busqueda_2 then %>
			    <table width="98%"  border="0" align="center">
                  <tr>
                    <td width="81%"><div align="center">
                        <table width="98%"  border="0">
                           <tr>
                            <td width="18%"><strong>Alumno </strong></td>
                            <td width="1%"><strong>:</strong></td>
                            <td width="54%"><%=nombre_alumno%></td>
							<td width="6%"><strong>Rut</strong></td>
                            <td width="1%"><strong>:</strong></td>
                            <td width="20%"><%=rut_alumno%></td>
                          </tr>
						   <tr>
                            <td width="18%"><strong>&nbsp; </strong></td>
                            <td width="1%"><strong>&nbsp;</strong></td>
                            <td colspan="4">&nbsp;</td>
                          </tr>
						  <tr>
                            <td width="18%"><strong>Plan Estudios </strong></td>
                            <td width="1%"><strong>:</strong></td>
                            <td colspan="4"><%f_busqueda2.DibujaCampoLista "busqueda", "plan_ccod"%></td>
                          </tr>
                          <tr>
                            <td><strong>Periodo Salida</strong></td>
                            <td><strong>:</strong></td>
                            <td colspan="4"><%f_busqueda2.DibujaCampoLista "busqueda", "peri_ccod"%></td>
                          </tr>
                          <tr>
                            <td><strong>Salida </strong></td>
                            <td><strong>:</strong></td>
                            <td colspan="4"><%f_busqueda2.DibujaCampoLista "busqueda", "sapl_ncorr"%></td>
                          </tr>
                        </table><input type="hidden" value="<%=q_pers_nrut%>" name="b[0][pers_nrut]">
						        <input type="hidden" value="<%=q_pers_xdv%>" name="b[0][pers_xdv]">
                    </div></td>
                    <td width="19%"><div align="center">
                        <%f_botonera.DibujaBoton "buscar2"%>
                    </div></td>
                  </tr>
                </table>
				<%end if%>
              </form>			  
              <table width="98%"  border="0">
                <tr>
                  <td scope="col"><div align="center"><%f_encabezado.DibujaRegistro%></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Requisitos ingresados"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col"><div align="center"><%f_requisitos.DibujaTabla%></div></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton "agregar"%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "eliminar"%>
                  </div></td>
                  <td><div align="center"><%f_botonera_g.DibujaBoton "salir"%></div></td>
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
