<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Administrar Especialidades de Alumnos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_cambio_especialidad.xml", "botonera"
periodo_Actual=negocio.obtenerPeriodoAcademico("POSTULACION")
'periodo_Actual=negocio.obtenerPeriodoAcademico("TOMACARGA")
'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "adm_cambio_especialidad.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

'response.Write("Periodo :" &periodo_actual)
'---------------------------------------------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut

set alumno = new CAlumno

if EsVacio(persona.ObtenerMatrNCorr(periodo_Actual)) then
	set f_datos = persona
else
	alumno.Inicializar conexion, persona.ObtenerMatrNcorr(periodo_Actual)
	set f_datos = alumno
end if

'---------------------------------------------------------------------------------------------------
set f_alumno = new CFormulario
f_alumno.Carga_Parametros "adm_cambio_especialidad.xml", "alumno"
f_alumno.Inicializar conexion

if isnull(q_pers_nrut) and isempty(q_pers_nrut) then q_pers_nrut="null"
'consulta = "select obtener_rut(a.pers_ncorr) as rut, obtener_nombre_completo(a.pers_ncorr) as nombre_alumno, " & vbCrLf &_
'           "       b.matr_ncorr, b.emat_ccod, b.plan_ccod, c.espe_ccod, c.peri_ccod, obtener_nombre_carrera(c.ofer_ncorr, 'C') as carrera, obtener_nombre_carrera(c.ofer_ncorr, 'E') as especialidad, " & vbCrLf &_
'		   "	   d.peri_tdesc  " & vbCrLf &_
'		   "from personas a, alumnos b, ofertas_academicas c, periodos_academicos d  " & vbCrLf &_
'		   "where a.pers_ncorr = b.pers_ncorr  " & vbCrLf &_
'		   "  and b.ofer_ncorr = c.ofer_ncorr  " & vbCrLf &_
'		   "  and c.peri_ccod = d.peri_ccod " & vbCrLf &_
'		   "  and b.emat_ccod <> 9    " & vbCrLf &_
'		   "  and c.sede_ccod = '" & negocio.ObtenerSede & "'  " & vbCrLf &_
'		   "  and a.pers_nrut = " & q_pers_nrut & " " & vbCrLf &_
'		   "order by d.peri_ccod asc"

'------------------------------------Agragado para mostrar solamente la última matricula-----------------------------------
'-------------------------------------------generado por Marcelo Sandoval 03-03-05-----------------------------------------
v_pers_ncorr=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
consulta_periodo=" select top 1 max(b.peri_ccod)as periodo " & vbCrLf &_
				 " from postulantes a, periodos_academicos b,alumnos c " & vbCrLf &_
				 " where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' " & vbCrLf &_
				 " and a.peri_ccod=b.peri_ccod " & vbCrLf &_
				 " and a.post_ncorr=c.post_ncorr  and c.audi_tusuario not like '%ajunte matricula%'" & vbCrLf &_
				 " order by periodo desc "
'response.Write(consulta_periodo)
ultimo_periodo = conexion.consultaUno(consulta_periodo)


ultima_sede = conexion.consultaUno("select sede_ccod from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"'")
'response.Write(ultima_sede)
'--------------------------------------------------------------------------------------------------------------------------
		   
consulta = "select protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno," & vbCrLf &_
			"        b.matr_ncorr, b.emat_ccod, b.plan_ccod, c.espe_ccod, c.peri_ccod," & vbCrLf &_
			"        protic.obtener_nombre_carrera(c.ofer_ncorr, 'C') as carrera,protic.obtener_nombre_carrera(c.ofer_ncorr, 'E') as especialidad," & vbCrLf &_
			"        d.peri_tdesc,protic.obtener_nombre_carrera(c.ofer_ncorr, 'CC') as carr_ccod,c.jorn_ccod  " & vbCrLf &_
			"    from personas a,alumnos b,ofertas_academicas c,periodos_academicos d" & vbCrLf &_
			"    where a.pers_ncorr = b.pers_ncorr" & vbCrLf &_
			"        and b.ofer_ncorr = c.ofer_ncorr" & vbCrLf &_
			"        and c.peri_ccod = d.peri_ccod" & vbCrLf &_
			"        and b.emat_ccod <> 9  and b.audi_tusuario not like '%ajunte matricula%'   " & vbCrLf &_
			"        and c.sede_ccod = '" & negocio.ObtenerSede & "'  " & vbCrLf &_
			"  and cast(a.pers_nrut as varchar) = '" & q_pers_nrut & "' " & vbCrLf &_
			"  and c.peri_ccod  >= 164 " & vbCrLf &_
			"order by d.peri_ccod desc"
'response.Write("<pre>"&consulta&"</pre>")			
f_alumno.Consultar consulta

'---------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion
f_consulta.Consultar consulta
i_ = 0
while f_consulta.Siguiente	    
	f_alumno.AgregaCampoFilaParam i_, "plan_ccod", "filtro", " espe_ccod = '"&f_consulta.ObtenerValor("espe_ccod")&"'"
	f_alumno.AgregaCampoFilaParam i_, "especialidad", "filtro", "carr_ccod='"&f_consulta.ObtenerValor("carr_ccod")&"' and jorn_ccod='"&f_consulta.ObtenerValor("jorn_ccod")&"' and peri_ccod='"&f_consulta.ObtenerValor("peri_ccod")&"' group by espe_ccod,espe_tdesc"
	f_alumno.AgregaCampoFilaCons i_, "especialidad", f_consulta.ObtenerValor("espe_ccod")
	f_alumno.AgregaCampoFilaCons i_, "plan_ccod", f_consulta.ObtenerValor("plan_ccod")  
	i_ = i_ + 1
'response.Write("carr_ccod='"&f_consulta.ObtenerValor("carr_ccod")&"' and jorn_ccod='"&f_consulta.ObtenerValor("jorn_ccod")&"' and peri_ccod='"&f_consulta.ObtenerValor("peri_ccod")&"' group by espe_ccod,espe_tdesc")
wend

'---------------------------------------------------------------------------------------------------------------
'v_es_moroso = conexion.ConsultaUno("select protic.es_moroso(pers_ncorr,getdate()) from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")

if v_es_moroso = "S" then
	conexion.MensajeError "El alumno se encuentra moroso."
	f_alumno.AgregaCampoParam "emat_ccod", "permiso", "LECTURA"
	f_alumno.AgregaCampoParam "plan_ccod", "permiso", "LECTURA"
	f_alumno.AgregaCampoParam "especialidad", "permiso", "LECTURA"	
	f_botonera.AgregaBotonParam "guardar", "deshabilitado", "TRUE"
end if

if f_alumno.NroFilas = 0 then
	f_botonera.AgregaBotonParam "guardar", "deshabilitado", "TRUE"
end if


consulta = "SELECT espe_ccod, espe_tdesc, carr_ccod  FROM especialidades"
conexion.Ejecuta consulta
set rec_especialidades = conexion.ObtenerRS

consulta2= "Select plan_ccod,plan_tdesc,espe_ccod from planes_estudio"
conexion.Ejecuta consulta2
set rec_planes=conexion.ObtenerRS

'---------------------------------------------------------------------------------------------------------------
set errores = new CErrores


tiene_salida_intermedia = conexion.consultaUno("select count(*) from personas a, alumnos_salidas_intermedias b where a.pers_ncorr=b.pers_ncorr and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'")
if tiene_salida_intermedia <> "0" then
	c_salida_i = " select top 1 'Es alumno '+lower(emat_tdesc)+' de la salida intermedia de '+lower(linea_1_certificado + ' ' + linea_2_certificado)  "& vbCrLf &_
				 " from personas pa,alumnos_salidas_intermedias a, salidas_carrera b,estados_matriculas c  "& vbCrLf &_
				 " where pa.pers_ncorr=a.pers_ncorr and cast(pers_nrut as varchar)='"&q_pers_nrut&"' and a.saca_ncorr=b.saca_ncorr  "& vbCrLf &_
				 " and a.emat_ccod=c.emat_ccod  "& vbCrLf &_
				 " order by a.emat_ccod desc "
    salida_i = conexion.consultaUno(c_salida_i)	
	
	set f_salidas_i = new CFormulario
	f_salidas_i.Carga_Parametros "info_alumnos.xml", "listado_salidas_intermedias"
	f_salidas_i.Inicializar conexion
	
	c_salidas_i = " select  d.peri_tdesc as periodo,e.carr_tdesc as carrera,linea_1_certificado + ' ' + linea_2_certificado as salida, emat_tdesc as estado "& vbCrLf &_
				 " from personas pa,alumnos_salidas_intermedias a, salidas_carrera b,estados_matriculas c,periodos_academicos d, carreras e  "& vbCrLf &_
				 " where pa.pers_ncorr=a.pers_ncorr and cast(pers_nrut as varchar)='"&q_pers_nrut&"' and a.saca_ncorr=b.saca_ncorr  "& vbCrLf &_
				 " and a.emat_ccod=c.emat_ccod  and a.peri_ccod = d.peri_ccod and b.carr_ccod=e.carr_ccod "& vbCrLf &_
				 " order by a.emat_ccod desc "
	
	f_salidas_i.Consultar c_salidas_i			 
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
var t_busqueda;

function ValidaBusqueda()
{
	rut=document.buscador.elements['b[0][pers_nrut]'].value+'-'+document.buscador.elements['b[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['b[0][pers_nrut]'].focus()
		document.buscador.elements['b[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}

function InicioPagina()
{
	t_busqueda = new CTabla("b");
}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}



arr_especialidades = new Array();
arr_planes =new Array();

<%
rec_especialidades.MoveFirst
i = 0
while not rec_especialidades.Eof
%>
arr_especialidades[<%=i%>] = new Array();
arr_especialidades[<%=i%>]["espe_ccod"] = '<%=rec_especialidades("espe_ccod")%>';
arr_especialidades[<%=i%>]["espe_tdesc"] = '<%=rec_especialidades("espe_tdesc")%>';
arr_especialidades[<%=i%>]["carr_ccod"] = '<%=rec_especialidades("carr_ccod")%>';
<%	
	rec_especialidades.MoveNext
	i = i + 1
wend
%>

<%
rec_planes.MoveFirst
j = 0
while not rec_planes.Eof
%>
arr_planes[<%=j%>] = new Array();
arr_planes[<%=j%>]["plan_ccod"] = '<%=rec_planes("plan_ccod")%>';
arr_planes[<%=j%>]["plan_tdesc"] = '<%=rec_planes("plan_tdesc")%>';
arr_planes[<%=j%>]["espe_ccod"] = '<%=rec_planes("espe_ccod")%>';
<%	
	rec_planes.MoveNext
	j = j + 1
wend
%>

function CargarEspecialidades(formulario, carr_ccod)
{
	formulario.elements["alumno[0][espe_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Especialidad";
	formulario.elements["alumno[0][espe_ccod]"].add(op)
	for (i = 0; i < arr_especialidades.length; i++)
	  { 
		if (arr_especialidades[i]["carr_ccod"] == carr_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_especialidades[i]["espe_ccod"];
			op.text = arr_especialidades[i]["espe_tdesc"];
			formulario.elements["alumno[0][espe_ccod]"].add(op)			
		 }
	}	
}

function CargarPlanes(formulario, espe_ccod)
{
	formulario.elements["alumno[0][plan_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "";
	op.text = "Seleccione Plan";
	formulario.elements["alumno[0][plan_ccod]"].add(op)
	for (j = 0; j < arr_planes.length; j++)
	  { 
		if (arr_planes[j]["espe_ccod"] == espe_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_planes[j]["plan_ccod"];
			op.text = arr_planes[j]["plan_tdesc"];
			formulario.elements["alumno[0][plan_ccod]"].add(op)			
		 }
	}	
}


</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="74" border="0"></td>
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
                        <td><div align="right"><strong>R.U.T. Alumno</strong></div></td>
                        <td width="40"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                          - 
                            <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
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
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td width="678" height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="10" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
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
              <br>
              <br>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><%f_datos.DibujaDatos%></td>
                </tr>
				<%if tiene_salida_intermedia <> "0" then%>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="center" bgcolor="#FFFFFF"><font size="2" color="#006600"><strong><%=salida_i%></strong></font></td>
				</tr>
				<%end if%>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Alumno"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_alumno.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                          <br>
            </form>
			<%if tiene_salida_intermedia <> "0" then%>
			<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr><td width="100%">&nbsp;</td></tr>
				  <tr>
                    <td width="100%"><%pagina.DibujarSubtitulo "Salidas intermedias alumno"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_salidas_i.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
				  <tr><td width="100%">&nbsp;</td></tr>
            </table>
			<%end if%>
			</td></tr>
        </table></td>
        <td width="10" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("guardar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="10" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
