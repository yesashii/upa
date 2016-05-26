<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Adm. Estado de Alumnos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_estado_alumnos.xml", "botonera"

set errores 	= new cErrores

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "adm_estado_alumnos.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


'---------------------------------------------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut
'---------------------------------------------------------------------------------------------------
set f_alumno = new CFormulario
f_alumno.Carga_Parametros "adm_estado_alumnos.xml", "alumno"
f_alumno.Inicializar conexion

if isnull(q_pers_nrut) and isempty(q_pers_nrut) then q_pers_nrut="null"
consulta_ultimo_periodo=" select max(peri_ccod) " & vbCrLf &_
						" from personas a,alumnos b, ofertas_Academicas c " & vbCrLf &_
						" where cast(pers_nrut as varchar)='" & q_pers_nrut & "' " & vbCrLf &_
						" and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
						" and b.ofer_ncorr=c.ofer_ncorr"

ultimo_periodo = conexion.consultaUno(consulta_ultimo_periodo)				
ano_periodo = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&ultimo_periodo&"'")		
'response.Write("periodo "&ultimo_periodo)		   
consulta = "select protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno, "& vbCrLf &_
		   "     b.matr_ncorr, b.emat_ccod,b.plan_ccod, c.espe_ccod, c.peri_ccod, "& vbCrLf &_
		   "     protic.initCap(protic.obtener_nombre_carrera(c.ofer_ncorr, 'C')) as carrera, "& vbCrLf &_
		   "     protic.initCap(protic.obtener_nombre_carrera(c.ofer_ncorr, 'E')) + case f.plan_tdesc when null then '' else '<font color=""#990000""> - '+f.plan_tdesc+'</font>' end as especialidad, "& vbCrLf &_
		   "     protic.initCap(d.peri_tdesc) as peri_tdesc,isnull(e.oema_tobservacion,'') as oema_tobservacion, e.eoma_ccod as eoma_ccod,(select case when bb.audi_tusuario  like '%ajunte matricula%' then 'S' else 'N' end from postulantes bb where bb.post_ncorr=b.post_ncorr) as ajustado  "& vbCrLf &_
		   "     from personas a join alumnos b "& vbCrLf &_
		   "        on a.pers_ncorr = b.pers_ncorr "& vbCrLf &_
		   "    join ofertas_academicas c "& vbCrLf &_
		   "        on b.ofer_ncorr = c.ofer_ncorr "& vbCrLf &_
		   "    join periodos_academicos d "& vbCrLf &_
		   "        on c.peri_ccod = d.peri_ccod "& vbCrLf &_
		   "    left outer join observaciones_estado_matricula e "& vbCrLf &_
		   "        on b.matr_ncorr = e.matr_ncorr "& vbCrLf &_
		   "    left outer join planes_estudio f "& vbCrLf &_
		   "        on b.plan_ccod = f.plan_ccod "& vbCrLf &_
		   "    where cast(a.pers_nrut as varchar) = '"&q_pers_nrut&"' "& vbCrLf &_
		   "     --and b.emat_ccod <> 9"& vbCrLf &_
		   "     --and  cast(d.anos_ccod as varchar)='"&ano_periodo&"'    "& vbCrLf &_
		   " order by d.anos_ccod,d.peri_ccod desc"
response.Write("<pre>"&consulta&"</pre>")			
f_alumno.Consultar consulta
'-------------recorremos en busca de el estadod e matricula y bloqueiamos si no esta eliminado
f_alumno.primero
fila_valor = 0
while f_alumno.siguiente
	estado_matricula = cint(f_alumno.obtenerValor("emat_ccod"))
	ajustado = f_alumno.obtenerValor("ajustado")
	'response.Write(ajustado)
	if (estado_matricula<>3) and (estado_matricula<>5) and (estado_matricula<>7) and (estado_matricula<>10) and ajustado <> "S" then
	  'response.Write("1")
		f_alumno.agregaCampoParam "eoma_ccod","deshabilitado","true"
		f_alumno.agregaCampoParam "eoma_ccod","id","TO-S"
		f_alumno.agregaCampoParam "oema_tobservacion","id","TO-S"
	elseif ((estado_matricula=3) or (estado_matricula=5) or (estado_matricula=7) or (estado_matricula=10)) and ajustado <> "S" then
	    'response.Write("2")
		f_alumno.agregaCampoParam "eoma_ccod","deshabilitado","false"
		f_alumno.agregaCampoParam "eoma_ccod","id","TO-N"
		f_alumno.agregaCampoParam "oema_tobservacion","id","TO-N"
	'elseif ajustado = "S" then
	'	f_alumno.agregaCampoParam "emat_ccod","deshabilitado","true"
	'	f_alumno.agregaCampoParam "emat_ccod","id","TO-S" 	
	end if
	


wend
f_alumno.primero

'---------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion
f_consulta.Consultar consulta

i_ = 0
while f_consulta.Siguiente	    
	f_alumno.AgregaCampoFilaParam i_, "plan_ccod", "filtro", " espe_ccod = '"&f_consulta.ObtenerValor("espe_ccod")&"'"
	i_ = i_ + 1
wend

'---------------------------------------------------------------------------------------------------------------
usuario = negocio.obtenerUsuario
pers_temporal = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")

'response.Write(usuario&" pers_ncorr "&pers_temporal)
es_de_registro_curricular = conexion.consultaUno("select count(*) from sis_roles_usuarios where srol_ncorr=2 and cast(pers_ncorr as varchar)='"&pers_temporal&"'")


v_es_moroso = conexion.ConsultaUno("select protic.es_moroso(pers_ncorr,getdate()) from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")
mensaje_moroso=""

if q_pers_nrut = "13827972" or q_pers_nrut= "14559514" or q_pers_nrut= "15385446" or q_pers_nrut= "15337855" or q_pers_nrut= "20341451" or q_pers_nrut= "14227212" or q_pers_nrut= "15336510" then 
	'response.Write("-")
	v_es_moroso="N"
end if


if es_de_registro_curricular > "0" and v_es_moroso = "S" then
'response.Write("Entre ")
	v_es_moroso = "N"
	mensaje_moroso="El alumno se Encuentra Moroso, sólo personal del departamento de Registro Curricular esta autorizado para realizar cambios de estado. <br> Cualquier cambio que se realice será bajo la responsabilidad de quien lo haga."
end if
if usuario = "9119940" then
'response.Write("Entre ")
	v_es_moroso = "N"
	mensaje_moroso="El alumno se Encuentra Moroso, sólo personal del departamento de Registro Curricular esta autorizado para realizar cambios de estado. <br> Cualquier cambio que se realice será bajo la responsabilidad de quien lo haga."
end if
'if v_es_moroso = "S" then
'	conexion.MensajeError "El alumno se encuentra moroso."
'	f_alumno.AgregaCampoParam "plan_ccod", "permiso", "LECTURA"	
'end if

if f_alumno.NroFilas = 0 then
	f_botonera.AgregaBotonParam "guardar", "deshabilitado", "TRUE"
end if


'---------------------------------------------------------------------------------------------------------------
set errores = new CErrores
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

function validaMorosidad()
{
	var estado = '<%=v_es_moroso%>';
	//alert("Estado "+estado);
	//var valor = formulario.elements["alumno[0][emat_ccod]"].value;
	nro = document.edicion.elements.length;
    num =0;
    for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  fila=extrae_indice(str);
	  valor=document.edicion.elements["alumno["+fila+"][emat_ccod]"].value;
	  if ((estado == 'S') && ((valor=="4")|| (valor=="8")))
		{
		alert('No se puede cambiar el estado del alumno, ya que se encuentra Moroso.');		
		return false;
		}
	}	

return true;	
}

function InicioPagina()
{
	t_busqueda = new CTabla("b");
}

function habilitarCondicional(valor,nombre)
{ //var estado = '<%=v_es_moroso%>';
  fila = extrae_indice(nombre);
  //alert(fila);
  if ((valor=="3")|| (valor=="5")||(valor=="7")||(valor=="10"))
		{
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].disabled = false;
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].id = "TO-N";
			document.edicion.elements["alumno["+fila+"][oema_tobservacion]"].id = "TO-N";
		}
	else
		{
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].disabled = true;
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].value = "";
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].id = "TO-S";
			document.edicion.elements["alumno["+fila+"][oema_tobservacion]"].id = "TO-S";
			
			/*if (estado=="S" ) && ((valor=="4")||(valor=="8"))
			{ alert("Imposible realizar el cambio de estado del alumno, ya que se encuentra moroso");
   		      document.edicion.elements["alumno["+fila+"][emat_ccod]"].value = document.edicion.elements["alumno["+fila+"][emat_ccod2]"].value;
			}*/
		
		
		}
 
}

function deshabilita_inicial(){
   nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if(comp.type == 'text'){
	     num += 1;
		 fila=extrae_indice(str);
		 valor=document.edicion.elements["alumno["+fila+"][emat_ccod]"].value;
		 ajuste=document.edicion.elements["alumno["+fila+"][ajustado]"].value;
		 
		 if ((valor=="3")|| (valor=="5")||(valor=="7")||(valor=="10"))
		{
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].disabled = false;
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].id = "TO-N";
			document.edicion.elements["alumno["+fila+"][oema_tobservacion]"].id = "TO-N";
		}
	else
		{
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].disabled = true;
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].value = "";
			document.edicion.elements["alumno["+fila+"][eoma_ccod]"].id = "TO-S";
			document.edicion.elements["alumno["+fila+"][oema_tobservacion]"].id = "TO-S";
		
		}
		if(ajuste=="S")
		{
		  document.edicion.elements["alumno["+fila+"][emat_ccod]"].disabled = true;
		  document.edicion.elements["alumno["+fila+"][emat_ccod]"].id = "TO-S";
		}
	  }
   }
}
</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="deshabilita_inicial(); MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
              <%pagina.DibujarTituloPagina%>
              <br>
              <br>
              <br>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><%persona.DibujaDatos%></td>
                </tr>
				<%if mensaje_moroso <> "" and q_pers_nrut <> "" then%>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="center"><font size="2" color="#0000FF"><strong><%=mensaje_moroso%></strong></font></td>
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
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
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
				  <td><div align="center">
                    <%f_botonera.agregaBotonParam "nueva_matricula", "url", "agregar_matricula_ajuste.asp?pers_nrut="&q_pers_nrut
					  f_botonera.DibujaBoton("nueva_matricula")%>
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
