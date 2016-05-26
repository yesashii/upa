<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_bloq_ccod = Request.QueryString("bloq_ccod")
'carrera = request.QueryString("Carrera_ocul")
'response.write(carrera)
'response.end

'---------------------------------------------------------------------------------------------------

set pagina = new CPagina
pagina.Titulo = "Asignar profesor"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

seccion_temporal=conexion.consultaUno("Select secc_ccod from bloques_horarios where cast(bloq_ccod as varchar)='"&q_bloq_ccod&"'")
sede_temporal=conexion.consultaUno("Select sede_ccod from secciones where cast(secc_ccod as varchar)='"&seccion_temporal&"'")
jornada_temporal=conexion.consultaUno("Select jorn_ccod from secciones where cast(secc_ccod as varchar)='"&seccion_temporal&"'")
horas_ayudante_total=conexion.consultaUno("Select isnull(secc_nhoras_ayudante,0) from secciones where cast(secc_ccod as varchar)='"&seccion_temporal&"'")
nivel_maximo=conexion.consultaUno("Select b.asig_nnivel_ayudante from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(a.secc_ccod as varchar)='"&seccion_temporal&"'")
'response.Write("horas "&horas_Ayudante_total&" seccion "&seccion_temporal)

'buscamos el periodo para sacar el año de la planificación y solo mostrar a los docentes de ese año
peri_ccod= negocio.obtenerPeriodoAcademico("PLANIFICACION")
peri_tdesc = conexion.consultaUno("Select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")


if esVacio(nivel_maximo) then
	nivel_maximo=3
	paso_nivel=0
else
	paso_nivel=1		
end if
consulta= " select isnull(sum(c.blpr_nhoras_ayudante),0) " & vbCrLf &_
		  " from secciones a, bloques_horarios b,bloques_profesores c " & vbCrLf &_
		  " where cast(a.secc_ccod as varchar) = '"&seccion_temporal&"'" & vbCrLf &_
		  " and a.secc_ccod=b.secc_ccod " & vbCrLf &_
		  " and b.bloq_ccod=c.bloq_ccod " & vbCrLf &_
		  " and c.tpro_ccod=2"
horas_ayudante_asignadas= conexion.consultaUno(consulta)
'response.Write("horas_asignadas "&horas_Ayudante_asignadas)

horas_disponibles_ayudante = clng(horas_ayudante_total) - clng(horas_ayudante_asignadas)
'response.Write("horas_ayudante "&horas_disponibles_ayudante)		  
'---------------------------------------------------------------------------------------------------
if EsVacio(q_bloq_ccod) then
	q_bloq_ccod = conexion.ConsultaUno("execute obtenersecuencia 'bloq_ccod_seq'")
end if
'response.write(session("c_carr_TMP"))


'---------------------------------------------------------------------------------------------------
set f_profesor = new CFormulario
f_profesor.Carga_Parametros "edicion_plan_acad.xml", "agregar_profesor"
f_profesor.Inicializar conexion

f_profesor.Consultar "select '' "

'f_profesor.AgregaCampoCons "bpro_mvalor", "0"


consulta = "select a.pers_ncorr, protic.obtener_nombre_completo(a.pers_ncorr, 'PM,N') as nombre_profesor, a.sede_ccod " & vbCrLf &_
           "from profesores a, personas b,  CARRERAS_DOCENTE C, periodos_academicos d" & vbCrLf &_		   
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and cast(a.sede_ccod as varchar) = '" & negocio.ObtenerSede & "' " & vbCrLf &_
		   "  and b.pers_ncorr = c.pers_ncorr " & vbCrLf &_		   
		   "  and c.peri_ccod = d.peri_ccod and cast(d.anos_ccod as varchar)='"&anos_ccod&"'" & vbCrLf &_		   
		   "  and c.peri_ccod="&peri_ccod&" "& vbCrLf &_   
		   "  and C.CARR_CCOD =  " & session("c_carr_TMP") & vbCrLf &_
		   "  and cast(C.SEDE_CCOD as varchar)=  '" & sede_temporal &"'" & vbCrLf &_		   
		   "  and cast(C.JORN_CCOD as varchar)=  '" & jornada_temporal &"'" & vbCrLf &_		   
		   "  and not exists (select 1 " & vbCrLf &_
		   "                  from bloques_profesores a2 " & vbCrLf &_
		   "				  where a2.pers_ncorr = a.pers_ncorr " & vbCrLf &_
		   "				    and cast(a2.bloq_ccod as varchar)= '" & q_bloq_ccod & "')"
'response.Write("<pre>"&consulta&"</pre>")
f_profesor.AgregaCampoParam "pers_ncorr", "destino", "(" & consulta & ")t"


consulta = "select * " & vbCrLf &_
           "from tipos_profesores a  " & vbCrLf &_
		   "where not exists (select 1 " & vbCrLf &_
		   "                  from bloques_profesores a2 " & vbCrLf &_
		   "				  where a2.tpro_ccod = 1 " & vbCrLf &_
		   "                   and isnull(ebpr_ccod,1)=1 " &vbCrlf &_
		   "				    and a2.tpro_ccod = a.tpro_ccod " & vbCrLf &_
		   "					and cast(a2.bloq_ccod as varchar) = '" & q_bloq_ccod & "')"
'response.Write("<pre>"&consulta&"</pre>")		   
f_profesor.AgregaCampoParam "tpro_ccod", "destino", "(" & consulta & ")r"

consulta_nivel= "Select niay_ccod, niay_tdesc from niveles_ayudante where niay_tdesc < = "&nivel_maximo
f_profesor.AgregaCampoParam "niay_ccod", "destino", "(" & consulta_nivel & ")t"
'response.Write("bloque "&q_bloq_ccod)
f_profesor.AgregaCampoCons "bloq_ccod", q_bloq_ccod
f_profesor.AgregaCampoCons "sede_ccod", negocio.ObtenerSede
f_profesor.siguiente

cantidad_docentes= conexion.consultaUno("Select count(*) from bloques_profesores where tpro_ccod=1 and cast(bloq_ccod as varchar)='"&q_bloq_ccod&"'")

if cantidad_docentes=0 then
variable_tipo="0"
f_profesor.agregaCampoParam "blpr_nhoras_ayudante", "deshabilitado", "TRUE"
f_profesor.agregaCampoParam "niay_ccod", "deshabilitado", "TRUE"
else
variable_tipo="2"
end if

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "edicion_plan_acad.xml", "botonera_agregar_profesor"
'---------------------------------------------------------------------------------------------------

consulta = " select count(*) from bloques_profesores "&_
           " where tpro_ccod=1 and ebpr_ccod=2 and cast(bloq_ccod as varchar)='"&q_bloq_ccod&"'" &_
		   " and not exists(select 1 from bloques_profesores bl where cast(bloq_ccod as varchar)='"&q_bloq_ccod&"' and tpro_ccod=1 and isnull(ebpr_ccod,1)=1)"

busca_prof_eliminado = conexion.consultaUno(consulta)

if busca_prof_eliminado <> "0" then
    variable_tipo="0"
	f_profesor.agregaCampoParam "blpr_nhoras_ayudante", "deshabilitado", "TRUE"
	f_profesor.agregaCampoParam "niay_ccod", "deshabilitado", "TRUE"
	mensaje = "Si usted agrega un nuevo docente, este será considerado como docente sustituto"
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
var variable_tipo='<%=variable_tipo%>';

function corregir(nombre,valor)
{var indice;
     indice= extrae_indice(nombre)
	 if (valor==2){
	    variable_tipo='2';
		document.edicion.elements["profesor["+indice+"][blpr_nhoras_ayudante]"].disabled=false;
		document.edicion.elements["profesor["+indice+"][niay_ccod]"].disabled=false;
	}
	else {
	    variable_tipo='0';
		document.edicion.elements["profesor["+indice+"][blpr_nhoras_ayudante]"].disabled=true;
		document.edicion.elements["profesor["+indice+"][niay_ccod]"].disabled=true;
	}
	//alert("variable_tipo " + variable_tipo);
}
function validar_horas(formulario)
{var horas_asignatura =<%=horas_disponibles_ayudante%>;
 var asignadas_ayudante=formulario.elements["profesor[0][blpr_nhoras_ayudante]"].value;
 var paso_nivel ='<%=paso_nivel%>';
 if (variable_tipo=='2'){
 	if (paso_nivel=='1'){
 		if ((asignadas_ayudante > horas_asignatura)&&(horas_asignatura > 0))
 			{alert("El número de horas asignadas al ayudante supera el máximo disponible de la sección ( "+ horas_asignatura + " Hrs)");
	 		formulario.elements["profesor[0][blpr_nhoras_ayudante]"].focus();
		 	return false; }
 		else if ((asignadas_ayudante > horas_asignatura)&&(horas_asignatura == 0))
 			{alert("Imposible asignar ayudante por falta de horas disponibles para ayudantía en la asignatura");
	 		formulario.elements["profesor[0][blpr_nhoras_ayudante]"].focus();
		 	return false; 
		}
 		else
   			{return true;}
  }
   else 
      {alert("No se puede agregar la carga, ya que aún no se ha definido la configuración de los ayudantes para la Asignatura"); }
}
else
{return true;} 

}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td><%pagina.DibujarLenguetas Array("Asignar profesor"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Profesor"%>
					 <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="37%"><strong><font color="#CC3300">*</font> Profesor</strong></td>
						  <td width="12%" align="center"><strong>:</strong></td>
						  <td width="51%"><%f_profesor.DibujaCampo("pers_ncorr")%></td>
                        </tr>
						<tr>
                          <td width="37%"><strong><font color="#CC3300">*</font> Tipo de Profesor</strong></td>
						  <td width="12%" align="center"><strong>:</strong></td>
						  <td width="51%"><%f_profesor.DibujaCampo("tpro_ccod")%></td>
                        </tr>
						<tr>
                          <td width="37%"><strong>Horas Ayudante</strong></td>
						  <td width="12%" align="center"><strong>:</strong></td>
						  <td width="51%"><%f_profesor.DibujaCampo("blpr_nhoras_ayudante")%> 
						   (<font color="#FF0000">*</font>)  </td>
                        </tr>
						<tr>
                          <td width="37%"><strong>Nivel Ayudante</strong></td>
						  <td width="12%" align="center"><strong>:</strong></td>
						  <td width="51%"><%f_profesor.DibujaCampo("niay_ccod")%></td>
                        </tr>
						<tr>
                          <td colspan="3"><br>(<font color="#FF0000">*</font>) Las horas ingresadas seran dividas en 2 al momento de realizar el pago</td>
						</tr>
						<tr>
                          <td colspan="3"><%=mensaje%></td>
						</tr>
                      </table>
					</td>
                  </tr>
				  <input type="hidden" name="bloque" value="<%=q_bloq_ccod%>">
				  <input type="hidden" name="sede" value="<%=negocio.ObtenerSede%>">
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
                  <td><div align="center"><%f_botonera.DibujaBoton("aceptar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cancelar")%>
                  </div></td>
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
