<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 
set pagina = new CPagina
pagina.Titulo = "Notas Parciales"

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
'-----------------------------------------------------------------------------------------
 set botonera = new CFormulario
 botonera.Carga_Parametros "Ficha_Alumno.xml", "botonera"
 '-----------------------------------------------------------------------------------------
 set f_alumno = new CFormulario
 f_alumno.Carga_Parametros "parametros.xml", "tabla"
 f_alumno.Inicializar conexion
 
 
	 sql =  "select protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno, f.carr_tdesc, e.espe_tdesc, g.peri_ccod, g.peri_tdesc as periodo "& vbCrLf &_
			"from personas a, postulantes b, alumnos c, ofertas_academicas d, especialidades e, carreras f, periodos_academicos g "& vbCrLf &_
			"where a.pers_ncorr = b.pers_ncorr "& vbCrLf &_
			"  and b.post_ncorr = c.post_ncorr "& vbCrLf &_
			"  and c.emat_ccod <> 9 "& vbCrLf &_
			"  and c.ofer_ncorr = d.ofer_ncorr "& vbCrLf &_
			"  and d.espe_ccod = e.espe_ccod "& vbCrLf &_
			"  and e.carr_ccod = f.carr_ccod "& vbCrLf &_
			"  and b.peri_ccod = g.peri_ccod "& vbCrLf &_
			"  and cast(a.pers_nrut as varchar) = '" & rut_alumno & "' "& vbCrLf &_
			"order by  b.peri_ccod DESC "& vbCrLf
 
 
  if Request.QueryString <> "" then
	 f_alumno.consultar sql
     f_alumno.siguiente
	 alumno = f_alumno.Obtenervalor ("nombre_alumno")
	 Periodo = f_alumno.Obtenervalor ("peri_ccod")	 
  else
	f_alumno.consultar "select '' where 1 = 2"
  end if

 '---------------------------------------------------------------------
  set f_notas = new CFormulario
  f_notas.Carga_Parametros "Ficha_Alumno.xml", "f_notas"
  f_notas.Inicializar conexion 
  f_notas.consultar "select '' where 1 = 2 "  
  '---------------------------------------------------------------------

 ' CONSULTA PARA SABER LA CANTIDAD MAXIMA DE NOTAS PLANIFICADAS PARA LAS ASIGNATURAS DE UN ALUMNO X   
		sql	 =  "select isnull(max(nro_calificaciones),0) as maximo "& vbCrLf &_
				"from ( "& vbCrLf &_
				"		select a.pers_nrut, c.peri_ccod, e.asig_ccod,  e.secc_ccod, count(f.secc_ccod) as nro_calificaciones "& vbCrLf &_
				"		from personas a, alumnos b, postulantes c, cargas_academicas d, secciones e, calificaciones_seccion f "& vbCrLf &_
				"		where a.pers_ncorr = b.pers_ncorr "& vbCrLf &_
				"		  AND b.EMAT_CCOD  <> 9 "& vbCrLf &_
				"		  and a.pers_ncorr = c.pers_ncorr "& vbCrLf &_
				"		  and b.ofer_ncorr = c.ofer_ncorr "& vbCrLf &_
				"		  and b.matr_ncorr = d.matr_ncorr "& vbCrLf &_
				"		  and cast(c.peri_ccod as varchar) = '" & Periodo & "' "& vbCrLf &_
				"		  and d.secc_ccod = e.secc_ccod "& vbCrLf &_
				"		  and e.secc_ccod *= f.secc_ccod  "& vbCrLf &_
				"		  and cast(a.pers_nrut as varchar) = '" & rut_alumno & "' "& vbCrLf &_
				"		group by a.pers_nrut, e.asig_ccod,c.peri_ccod, e.secc_ccod, f.secc_ccod "& vbCrLf &_
				"	 )  as tabla"& vbCrLf


max_notas  = conexion.consultaUno(sql)
 
 'AGREGAMOS LOS CAMPOS PARA LAS NOTAS, RESPECTO DE LA SIGNATURA CON MAYOR CANTIDAD DE NOTAS PLANIFICADAS
 for K = 1 to max_notas
		f_notas.AgregaElemento "campos", "nota"& K
		f_notas.AgregaCampoParam "nota" & K, "descripcion", "Nota " & k
		f_notas.AgregaCampoParam "nota" & K, "tipo", "INPUT" 
		f_notas.AgregaCampoParam "nota" & K, "permiso", "lectura" 		
		f_notas.AgregaCampoParam "nota" & K, "alineamiento","right"		
 next
 
 
set f_parciales = new CFormulario
f_parciales.Carga_Parametros "parametros.xml", "tabla"
 
 ' ----------------- ASIGNATURAS DEL ALUMNO    ------------------
 set f_asignaturas = new CFormulario
 f_asignaturas.Carga_Parametros "parametros.xml", "tabla"
 f_asignaturas.Inicializar conexion
				
		sql  =  "select b.matr_ncorr, e.asig_ccod, e.secc_ccod, f.asig_tdesc "& vbCrLf &_
				"from personas a, alumnos b, postulantes c, cargas_academicas d , secciones e, asignaturas f  "& vbCrLf &_
				"where a.pers_ncorr = b.pers_ncorr   "& vbCrLf &_
				" AND b.EMAT_CCOD  <> 9   "& vbCrLf &_
				" and a.pers_ncorr = c.pers_ncorr   "& vbCrLf &_
				" and b.ofer_ncorr = c.ofer_ncorr   "& vbCrLf &_
				" and b.matr_ncorr = d.matr_ncorr   "& vbCrLf &_
				" and d.secc_ccod = e.secc_ccod "& vbCrLf &_
				" and e.asig_ccod = f.asig_ccod "& vbCrLf &_
				" and cast(c.peri_ccod as varchar) = '" & Periodo & "'  "& vbCrLf &_
				" and cast(a.pers_nrut as varchar) =  '" & rut_alumno & "' "& vbCrLf &_ 
				"ORDER BY e.asig_ccod "

 

'response.Write("<PRE>" & sql & "</PRE>")
'response.End()
f_asignaturas.consultar sql

fila =0
while f_asignaturas.siguiente
   asig_ccod =  f_asignaturas.obtenerValor ("asig_ccod")
   asig_tdesc =  f_asignaturas.obtenerValor ("asig_tdesc")
   matr_ncorr =  f_asignaturas.obtenerValor ("matr_ncorr")
   secc_ccod =  f_asignaturas.obtenerValor ("secc_ccod") 
   'nota=" "
 
   f_parciales.Inicializar conexion
   'trim(to_char(a.cala_nnota,'9.0')) => cast(a.cala_nnota as decimal)
   sql = "select cast(a.cala_nnota as decimal) as nota "& vbCrLf &_ 
   		 "from calificaciones_alumnos a, calificaciones_seccion b "& vbCrLf &_ 
		 "where a.secc_ccod = b.secc_ccod "& vbCrLf &_ 
	     "  and a.cali_ncorr = b.cali_ncorr "& vbCrLf &_ 
	     "  and cast(a.matr_ncorr as varchar) =  '" & matr_ncorr & "' "& vbCrLf &_ 
	     "  and cast(a.secc_ccod as varchar) =  '" & secc_ccod & "' "& vbCrLf &_ 
	     "order by b.cali_nevaluacion "& vbCrLf
   
   f_parciales.consultar sql
   f_parciales.Siguiente

   'if f_parciales.NroFilas > 0 then
      f_notas.clonaFilaCons (0)
	  'for R = 0 to f_parciales.NroFilas - 1     
	  for R = 0 to f_asignaturas.NroFilas - 1 
	    'nota = f_parciales.obtenerValor ("nota")
		f_notas.agregaCampoFilaCons fila, "asig_ccod", asig_ccod
		f_notas.agregaCampoFilaCons fila, "asig_tdesc", asig_tdesc
        
		if R < f_parciales.NroFilas then
			nota = f_parciales.obtenerValor ("nota")
		else 
			nota = ""
		end if
		f_notas.agregaCampoFilaCons fila, trim("nota" & R + 1), nota  
        
		f_parciales.Siguiente
	  next  	  
  'else
  		'nota1 =0
     'f_notas.clonaFilaCons (0)
    ' f_notas.agregaCampoFilaCons fila, "asig_ccod", asig_ccod
	 'f_notas.agregaCampoFilaCons fila, "asig_tdesc", asig_tdesc
	 'f_notas.agregaCampoFilaCons fila, trim("nota1" & R + 1), nota 	
	 'response.Flush() 
	
  'end if
  fila = fila + 1
wend


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

function abrir()
{
 resultado = window.open('../toma_carga_jefe/horario.asp?matr_ncorr=<%=matr_ncorr%>','','width=800,height=500,scrollbars=yes,toolbar=no')
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
				    pagina.DibujarLenguetas array(Array("Datos Alumno","Ficha_Alumno.asp?busqueda[0][pers_nrut]=" & rut_alumno  & "&busqueda[0][pers_xdv]=" & rut_alumno_digito), Array("Avance Curricular","Ficha_Alumno_Avance.asp?busqueda[0][pers_nrut]=" & rut_alumno  & "&busqueda[0][pers_xdv]=" & rut_alumno_digito), Array("Notas Parciales")), 3
                  else
				    pagina.DibujarLenguetas Array("Datos Alumno","Avance Curricular","Notas Parciales"), 3 
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
                          <table width="100%">
                            <tr>
						      <td>
							   <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"> 
                                  </font></b></font> </div>
								  <% if alumno <> "" then %> 
								<table width="100%" border="0">
                                  <tr> 
                                    <td width="15%"><strong>Nombre</strong></td>
                                    <td width="5%"><div align="center"><strong>:</strong></div></td>
                                    <td width="80%"><b><font color="#666677" size="2"> 
                                      <%=f_alumno.Obtenervalor ("nombre_alumno")%> </font></b></td>
                                  </tr>
                                  <tr> 
                                    <td><strong>Carrera</strong></td>
                                    <td><div align="center"><strong>:</strong></div></td>
                                    <td><b><font color="#666677" size="2"> <%=f_alumno.Obtenervalor ("carr_tdesc") & " - " &  f_alumno.Obtenervalor ("espe_tdesc")%> 
                                      </font></b></td>
                                  </tr>
                                  <tr> 
                                    <td><strong>Periodo</strong></td>
                                    <td><div align="center"><strong>:</strong></div></td>
                                    <td><b><font color="#666677" size="2"> <%=f_alumno.Obtenervalor ("periodo")%> </font></b></td>
                                  </tr>
                                </table> 
								<%end if%>
								<BR><BR><BR>
                                <BR>
                                <table width="100%" border="0">
                                  <tr>
                                    <td> <div align="center">
                                        <%f_notas.DibujaTabla()%>
                                      </div></td>
                                  </tr>
                                  <tr> 
                                    <td><div align="right"> 
                                        <%
										if f_notas.nroFilas > 0 then
										botonera.agregaBotonParam "horario", "deshabilitado", "FALSE"
										else
										botonera.agregaBotonParam "horario", "deshabilitado", "TRUE"
										end if
										botonera.dibujaBoton "horario"
										%>
                                      </div></td>
                                  </tr>
                                </table>
                                <BR> <BR>
                                <BR>
                                <BR>
                              </td>
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
            <td width="19%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="47%"><div align="center"> 
                            <%
				  if alumno <> "" then
				    botonera.agregaBotonParam "anterior", "deshabilitado", "false"
				  else
				    botonera.agregaBotonParam "anterior", "deshabilitado", "true"
				  end if
				  botonera.agregaBotonParam "anterior" , "url",  "Ficha_Alumno_Avance.asp?busqueda[0][pers_nrut]=" & rut_alumno  & "&busqueda[0][pers_xdv]=" & rut_alumno_digito
				  botonera.dibujaBoton "anterior"
				  %>
                          </div></td>
                        <td width="17%">&nbsp; </td>
                        <td width="36%"><div align="center"> 
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
