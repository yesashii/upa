<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Listado de docentes de la asignatura"
'-------------------------------------------------------------------------------
set errores = new CErrores
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------
secc_ccod = request.querystring("secc_ccod")

'validacion de contratos ya creados

sql_existen_contratos="select count(*) from contratos_docentes_upa a,anexos b, detalle_anexos c "& vbCrLf &_
						" where a.cdoc_ncorr=b.cdoc_ncorr "& vbCrLf &_
						" and b.cdoc_ncorr=c.cdoc_ncorr "& vbCrLf &_
						" and b.anex_ncorr=c.anex_ncorr "& vbCrLf &_
						" and cast(c.secc_ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_
						" and a.ecdo_ccod=1 "& vbCrLf &_
						" and b.eane_ccod=1 "& vbCrLf &_
						" and b.tpro_ccod=1"

v_contratos=conexion.consultaUno(sql_existen_contratos)

if v_contratos > "0" then
	mensaje=" <font color='red'> (*)</font>Esta asignatura ya registra un contrato activo asociado, por lo tanto no puede ser modificada"
end if

Periodo = negocio.ObtenerPeriodoAcademico("CLASES18")
Sede = negocio.ObtenerSede()
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar) ='" & Sede & "'")

'-------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "horas_docente.xml", "botonera"

'-------------------------------------------------------------------------------
asignatura = conexion.consultaUno ("select ltrim(rtrim(asig_ccod)) from secciones where cast(secc_ccod as varchar)='" & secc_ccod & "'" )
carrera = conexion.consultaUno ("select ltrim(rtrim(cast(carr_ccod as varchar))) from secciones where cast(secc_ccod as varchar)='" & secc_ccod & "'" )
jornada = conexion.consultaUno ("select jorn_ccod from secciones where cast(secc_ccod as varchar)='" & secc_ccod & "'" )

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.inicializar conexion



	 sql =  "select top 1 c.asig_ccod, a.secc_tdesc, b.peri_tdesc, c.asig_tdesc, d.sede_tdesc, e.jorn_tdesc, f.carr_tdesc, "& vbCrLf &_
	 		" case when  a.moda_ccod in(1) then c.asig_nhoras else a.secc_nhoras_pagar end as asig_nhoras,isnull(asig_nhoras_ayudantia,0) as asig_nhoras_ayudantia, "& vbCrLf &_
			"  isnull(asig_nhoras_laboratorio,0) as asig_nhoras_laboratorio, isnull(asig_nhoras_terreno,0) as asig_nhoras_terreno,isnull(asig_nhoras_elearning,0) as asig_nhoras_elearning, "& vbCrLf &_
			"  isnull(asig_nhoras_ayudantia,0) as c_nhoras_ayudantia,isnull(asig_nhoras_laboratorio,0) as c_nhoras_laboratorio, "& vbCrLf &_
			"  isnull(asig_nhoras_terreno,0) as c_nhoras_terreno, isnull(asig_nhoras_elearning,0) as c_nhoras_elearning "& vbCrLf &_
			"from secciones a , periodos_academicos b, asignaturas c, sedes d, jornadas e,carreras f "& vbCrLf &_
			"where a.peri_ccod = b.peri_ccod  "& vbCrLf &_
			"  and a.asig_ccod = c.asig_ccod  "& vbCrLf &_
			"  and a.sede_ccod = d.sede_ccod "& vbCrLf &_
			"  and a.jorn_ccod = e.jorn_ccod "& vbCrLf &_
			"  and a.carr_ccod = f.carr_ccod "& vbCrLf &_
			"  and cast(a.secc_ccod as varchar) = '" & secc_ccod & "'"& vbCrLf

'response.Write("<pre>"&sql&"</pre>")
f_consulta.consultar sql
f_consulta.siguiente
'------------------------------------------------------------------------------------

set f_docentes = new CFormulario
f_docentes.Carga_Parametros "horas_docente.xml", "f_docentes"
f_docentes.inicializar conexion

			
  	  sql = " select distinct isnull(a.bloq_ayudantia,0) as bloq_ayudantia,a.secc_ccod, b.pers_ncorr,cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut,"& vbCrLf &_
		    " c.pers_tape_paterno as ap_paterno, c.pers_tape_materno as ap_materno, c.pers_tnombre as nombres, "& vbCrLf &_
			" protic.horario_seccion_docente(a.secc_ccod,c.pers_ncorr)  as horario, isnull(d.hopr_nhoras,0) as hopr_nhoras, "& vbCrLf &_
			" case isnull(a.bloq_ayudantia,0) when 0 then 'Cátedra' when 1 then 'Ayudantía' when 2 then 'Laboratorio' when 3 then 'Terreno' when 4 then 'E-learning' end tipo_bloque, "& vbCrLf &_
			" d.hopr_tresolucion,isnull(b.ebpr_ccod,1) as ebpr_ccod "& vbCrLf &_
			" from bloques_horarios a join bloques_profesores b "& vbCrLf &_
		    "    on a.bloq_ccod=b.bloq_ccod "& vbCrLf &_
			"    and b.tpro_ccod=1 "& vbCrLf &_
			" join personas c "& vbCrLf &_
			"    on b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" left outer join horas_profesores d "& vbCrLf &_
			"    on a.secc_ccod = d.secc_ccod "& vbCrLf &_
			" 	 and b.pers_ncorr = d.pers_ncorr "& vbCrLf &_
			"    and isnull(a.bloq_ayudantia,0)=d.bloq_ayudantia "& vbCrLf &_			
			"where cast(a.secc_ccod as varchar)='"&secc_ccod&"'"


			
'response.Write("cantidad_docentes <pre>"&sql&"</pre>")
f_docentes.consultar sql
cantidad_docentes = f_docentes.nroFilas

horas_asignatura 	= f_consulta.obtenerValor("asig_nhoras")
horas_laboratorio 	= f_consulta.obtenerValor("c_nhoras_laboratorio")
horas_terreno 		= f_consulta.obtenerValor("c_nhoras_terreno")
horas_ayudantia 	= f_consulta.obtenerValor("c_nhoras_ayudantia")
horas_elearning 	= f_consulta.obtenerValor("c_nhoras_elearning")

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
function validar_horas(){
var num_registros=<%=cantidad_docentes%>;
var horas_catedra= <%=horas_asignatura%>;
var horas_laboratorio= <%=horas_laboratorio%>;
var horas_terreno= <%=horas_terreno%>;
var horas_ayudantia= <%=horas_ayudantia%>;
var horas_elearning= <%=horas_elearning%>;

var formulario= document.edicion;
var valor_hora;
var horas_totales;
var horas_asignadas = 0;
var horas_cat = 0;
var horas_ayu = 0;
var horas_lab = 0;
var horas_terr = 0;
var horas_elear = 0;
var contador = 0;
var i=0;

//horas_totales=horas_catedra+horas_laboratorio+horas_terreno+horas_ayudantia+horas_elearning;
horas_totales=horas_catedra;// modificacion producto de solicitud O. huechao (no se deben considerar otras horas que no sean de catedra) 16/08/2012

//alert(horas_totales);
for( i = 0; i < num_registros; i++ ) {
    
	valor_hora 				= 	formulario.elements["docentes["+i+"][hopr_nhoras]"].value;
    valor_hora_terreno 		= 	formulario.elements["docentes["+i+"][c_nhoras_terreno]"].value;
	valor_hora_laboratorio 	= 	formulario.elements["docentes["+i+"][c_nhoras_laboratorio]"].value;
    valor_hora_ayudantia 	= 	formulario.elements["docentes["+i+"][c_nhoras_ayudantia]"].value;
	valor_hora_elearning 	= 	formulario.elements["docentes["+i+"][c_nhoras_elearning]"].value;			
	tipo_bloque				=	formulario.elements["docentes["+i+"][bloq_ayudantia]"].value;
	
	if(tipo_bloque=="0"){
		horas_cat = horas_cat + (valor_hora * 1);
	}
	if(tipo_bloque=="1"){
		horas_ayu=horas_ayu+ (valor_hora * 1);
	}
	if(tipo_bloque=="2"){
		horas_lab=horas_lab+ (valor_hora * 1);
	}
	if(tipo_bloque=="3"){
		horas_terr=horas_terr+ (valor_hora * 1);
	}
	if(tipo_bloque=="4"){
		horas_elear=horas_elear+ (valor_hora * 1);
	}
	if (valor_hora =="0")
		{contador = contador + 1;}
}
//	alert("valor "+ horas_asignadas);

	if (contador > 0 ){
	 	alert("No puede dejar docentes con horas en cero");
		return false;
	} 

//horas_asignadas=horas_terr+horas_lab+horas_ayu+horas_cat+horas_elear;
horas_asignadas=horas_cat;	// modificacion producto de solicitud O. huechao (no se deben considerar otras horas que no sean de catedra) 16/08/2012
	if (horas_totales < horas_asignadas){
		alert("El total de horas asignadas a docentes supera el máximo de ("+horas_totales+" hrs) de la asignatura");	
		return false;
	}else if(horas_totales > horas_asignadas){
				alert("El total de horas asignadas a docentes es inferior al total de ("+horas_totales+" hrs) de la asignatura");	
				return false;
	}else{
		if(horas_ayu>horas_ayudantia){alert("Hora Ayudantia exceden limite");return false;}
		if(horas_lab>horas_laboratorio){alert("Hora Laboratorio exceden limite");return false;}
		if(horas_terr>horas_terreno){alert("Hora Terreno exceden limite");return false;}
		if(horas_elear>horas_elearning){alert("Hora E-Learning exceden limite");return false;}			
		return true;
	}
	

}
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
              <%pagina.DibujarTituloPagina%><br><BR><BR>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="20%"><strong>Asignatura</strong></td>
                        <td width="3%"><div align="center"><strong>:</strong></div></td>
                        <td width="38%"><%= f_consulta.obtenerValor("asig_ccod") & " --> "  & f_consulta.obtenerValor("asig_tdesc")%></td>
                        <td width="13%"><strong>Sede</strong></td>
                        <td width="3%"><div align="center"><strong>:</strong></div></td>
                        <td width="23%"><%=f_consulta.obtenerValor("sede_tdesc")%></td>
                      </tr>
                      <tr> 
                        <td><strong>Carrera</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("carr_tdesc")%></td>
                        <td><strong>Periodo</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("peri_tdesc")%></td>
                      </tr>
                      <tr> 
                        <td><strong>Secci&oacute;n</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("secc_tdesc")%></td>
                        <td><strong>Jornada</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("jorn_tdesc")%></td>
                      </tr>
					  <tr> 
                        <td><strong>Horas Asignatura</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("asig_nhoras")%></td>
						<td><strong>H. Laboratorio</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("asig_nhoras_laboratorio")%></td>
                     </tr>
					 <tr> 
                        <td><strong>H. Ayudantia</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("asig_nhoras_ayudantia")%></td>
						<td><strong>H. Terreno</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("asig_nhoras_terreno")%></td>
                     </tr>
					 <tr> 
                        <td><strong>H. E-Learning</strong></td>
                        <td><div align="center"><strong>:</strong></div></td>
                        <td><%=f_consulta.obtenerValor("asig_nhoras_elearning")%></td>
						<td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                     </tr>					 
                    </table>
                       <BR>
					   <table>
					   <tr>
					   <td><font color="#0000FF"><%=mensaje%></font></td>
					   </tr>
					   </table>
                    <table width="100%" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_docentes.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Docentes de la asignatura (Cátedra)"%>
                      <br>
					  <% f_docentes.dibujaTabla()%>
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
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="48%"> <% botonera.AgregaBotonParam "anterior", "url", "horas_docente.asp?busqueda[0][asig_ccod]=" & asignatura &"&busqueda[0][carr_ccod]="&carrera&"&busqueda[0][jorn_ccod]="&jornada
						  botonera.dibujaBoton "anterior"
						  %> </td>
						  <td width="48%"> <% if (cantidad_docentes = "0" or  v_contratos > "0") then
						                      		botonera.agregabotonParam "guardar","deshabilitado","TRUE"
													
											  end if
						  botonera.dibujaBoton "guardar"
						  %> </td>
                       </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
