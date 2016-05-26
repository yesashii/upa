<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Gestor de Cargas Académica Adicionales"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
set errores 	= new cErrores

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
'--------------------------------------------------------------------------

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "cargas_adicionales.xml", "busqueda_usuarios_nuevo"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "cargas_adicionales.xml", "botonera"
'--------------------------------------------------------------------------
set datos_personales = new CFormulario
datos_personales.Carga_Parametros "tabla_vacia.xml", "tabla"
datos_personales.Inicializar conexion
consulta_datos =  " select a.pers_ncorr,protic.format_rut(pers_nrut) as rut, "& vbCrLf &_
				  " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' +a.pers_tape_materno as nombre, "& vbCrLf &_
				  " b.sexo_tdesc as sexo,c.pais_tdesc as pais "& vbCrLf &_
				  " from personas_postulante a,sexos b,paises c "& vbCrLf &_
				  " where cast(a.pers_nrut as varchar)='"&rut&"' "& vbCrLf &_
				  " and a.sexo_ccod *=b.sexo_ccod "& vbCrLf &_
				  " and a.pais_ccod=c.pais_ccod"

datos_personales.Consultar consulta_datos
datos_personales.siguiente

codigo = datos_personales.obtenerValor("pers_ncorr")
rut_completo = datos_personales.obtenerValor("rut")
nombre = datos_personales.obtenerValor("nombre")
sexo = datos_personales.obtenerValor("sexo")
pais = datos_personales.obtenerValor("pais")

actividad = session("_actividad")
if (actividad = "7")  then
	periodo = negocio.obtenerPeriodoAcademico("TOMACARGA")
else
	periodo = negocio.obtenerPeriodoAcademico("CLASES18")
end if


if not esvacio(codigo) then
	es_moroso = conexion.consultaUno("select protic.es_moroso('"&codigo&"', getDate())")
	if es_moroso="N" then
		moroso = "No"
	else
	    moroso = "Sí"		
    end if
	
	set f_carga = new CFormulario
 	f_carga.Carga_Parametros "cargas_adicionales.xml", "busqueda"
 	f_carga.Inicializar conexion
 	peri = periodo 
	consulta="Select '"&sede_ccod&"' as sede_ccod, '"&carr_ccod&"' as carr_ccod, '"&asig_ccod&"' as asig_ccod, '"&jorn_ccod&"' as jorn_ccod,'"&todas&"' as todas,'"&sin_alumnos&"' as sin_alumnos,'"&sin_cerrar&"' as sin_cerrar "
 	f_carga.consultar consulta

	 consulta = " select distinct f.sede_ccod,f.sede_tdesc,ltrim(rtrim(a.carr_ccod)) as carr_ccod, " & vbCrLf & _
				" a.carr_tdesc,e.jorn_ccod,e.jorn_tdesc,ltrim(rtrim(b.secc_ccod))as secc_ccod, " & vbCrLf & _
				" d.asig_tdesc+' - '+ltrim(rtrim(d.asig_ccod)) + ' (Secc:'+ substring(b.secc_tdesc,1,1) +') ' + isnull(ca.cred_tdesc,'') as asig_tdesc " & vbCrLf & _
				" from carreras a join secciones b " & vbCrLf & _
				"    on a.carr_ccod=b.carr_ccod " & vbCrLf & _
				" join bloques_horarios c " & vbCrLf & _
				"    on b.secc_ccod=c.secc_ccod  " & vbCrLf & _
				" join asignaturas d " & vbCrLf & _
				"    on b.asig_ccod=d.asig_ccod " & vbCrLf & _
				" join jornadas e " & vbCrLf & _
				"    on b.jorn_ccod=e.jorn_ccod " & vbCrLf & _
				" join sedes f " & vbCrLf & _
				"    on b.sede_ccod=f.sede_ccod  " & vbCrLf & _
				" left outer join creditos_asignatura ca " & vbCrLf & _
				"    on d.cred_ccod = ca.cred_ccod     " & vbCrLf & _
				" where b.secc_tdesc <>'Poblamiento'  " & vbCrLf & _
				" and cast(b.peri_ccod as varchar)='"&peri&"'  " & vbCrLf & _
				" and a.tcar_ccod in (1,2) " & vbCrLf & _
				" and (b.secc_ncupo - (select count(*) from cargas_academicas cc where cc.secc_ccod=b.secc_ccod)) > 0 " & vbCrLf & _
				" order by sede_tdesc,carr_tdesc,jorn_tdesc,asig_tdesc asc "
    'response.Write("<pre>"&consulta&"</pre>")
 	f_carga.inicializaListaDependiente "lBusqueda", consulta
	f_carga.Siguiente
    'response.Write("select matr_ncorr from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='"&codigo&"' and cast(b.peri_ccod as varchar)='"&peri&"'")
	matr_ncorr = conexion.consultaUno("select matr_ncorr from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and a.emat_ccod in (1,4) and cast(a.pers_ncorr as varchar)='"&codigo&"' and cast(b.peri_ccod as varchar)='"&peri&"'")
    
	c_carrera  = " select sede_tdesc + '-' + carr_tdesc + case jorn_ccod when 1 then ' (D)' else ' (V)' end "&_
	             " from alumnos a, ofertas_academicas b, sedes c, especialidades d, carreras e"&_
				 " where a.ofer_ncorr = b.ofer_ncorr and b.sede_ccod = c.sede_ccod "&_
				 " and b.espe_ccod = d.espe_ccod"&_
				 " and d.carr_ccod=e.carr_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'"
	carrera = conexion.consultaUno(c_carrera)
	periodo_tdesc = conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&peri&"'")
	
	set f_alumno = new CFormulario
	f_alumno.Carga_Parametros "cargas_adicionales.xml", "carga_tomada_agregada"
	f_alumno.Inicializar conexion
	consulta = " select a.secc_ccod,a.matr_ncorr,c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
			   " protic.horario_con_sala(b.secc_ccod) as horario, case acse_ncorr when 3 then 'Carga sin Pre-requisitos' else case a.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, "& vbCrLf &_
			   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
			   "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
			   " from cargas_Academicas a, secciones b, asignaturas c " & vbCrLf &_
			   " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
			   " and a.secc_ccod=b.secc_ccod "&vbCrLf &_
			   " and not exists (Select 1 from equivalencias eq where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
			   " and b.asig_ccod=c.asig_ccod " & vbCrLf &_
			   " union all " & vbCrLf &_
			   " select a.secc_ccod,a.matr_ncorr,c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
			   " protic.horario_con_sala(b.secc_ccod) as horario,case isnull(acse_ncorr,0) when 0 then 'Equivalencia' else 'Carga Extraordinaria' end as tipo, " & vbCrLf &_
			   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
			   "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
			   " from equivalencias a, secciones b, asignaturas c,cargas_academicas ca " & vbCrLf &_
			   " where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' "&vbCrLf &_
			   " and a.secc_ccod=b.secc_ccod  and a.matr_ncorr=ca.matr_ncorr and a.secc_ccod = ca.secc_ccod" & vbCrLf &_
			   " and b.asig_ccod=c.asig_ccod "
	'response.Write("<pre>"&consulta&"</pre>")
	f_alumno.Consultar consulta
	'response.Write("select protic.obtener_creditos_asignados("&matr_ncorr&")")
	creditos_totales = conexion.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
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

function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 
 posicion_guion = texto_rut.indexOf("-");
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.buscador.elements["busqueda[0][pers_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 

   
   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
buscador.elements["busqueda[0][pers_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['buscador'],'', 'Validar();', 'FALSE');
}
</script>
<% if codigo <> "" then 
    f_carga.generaJS 
   end if
%>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="95" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="10"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="550" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="98">Rut Usuario</td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%botonera.DibujaBoton "buscar" %>
                                  </div></td>
                              </tr>
                            </table>
                          </form>
                        </div></td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>	
	<br>		
	<%if rut <> "" then%>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="135" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Guardar Carga Adicional</font></div></td>
                      <td width="522" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; 
                    <BR>
					<%pagina.DibujarTituloPagina%><br>
                  </div>
				  <table width="100%" border="0">
				  <form name="edicion" method="post">
				  	<input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
                    <tr> 
                      <td align="left" width="15%"><strong>R.U.T.</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left" width="34%"><%=rut_completo%></td>
					  <td align="right" width="15%"><strong>Sexo</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left" width="34%"><%=sexo%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Nombre</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left" colspan="4"><%=nombre%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Pa&iacute;s</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left" width="34%"><%=pais%></td>
					  <td align="right" width="15%"><strong>Es Moroso</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left" width="34%"><%=moroso%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Carrera alumno</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left" colspan="4"><%=carrera%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Periodo</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left" colspan="4"><font color="#990000"><%=periodo_tdesc%></font></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Créditos</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left" colspan="4"><font color="#990000"><%=creditos_totales%> Asignados</font></td>
					</tr>
					<tr> 
                      <td align="left" colspan="2"><font color="#990000"><strong>Asigantura Adicional a Cursar</strong></font></td>
					  <td align="left" colspan="4"><hr style="color=#990000"></td>
					</tr>
					<%if codigo <> "" then %>
					<tr> 
                        <td width="15%">Sede</td>
						<td width="2%">:</td>
						<td colspan="4" align="left"><% f_carga.dibujaCampoLista "lBusqueda", "sede_ccod"%></td>
                    </tr>
					<tr> 
                        <td width="15%">Carrera</td>
						<td width="2%">:</td>
						<td colspan="4" align="left"><% f_carga.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                    </tr>
					<tr> 
                        <td width="15%">Jornada</td>
						<td width="2%">:</td>
						<td colspan="4" align="left"><% f_carga.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
                    </tr>
					<tr> 
                        <td width="15%">Asignatura</td>
						<td width="2%">:</td>
						<td colspan="4" align="left"><% f_carga.dibujaCampoLista "lBusqueda", "secc_ccod"%></td>
                    </tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
				   <%end if%>
				   </form>
		          </table>
		         </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                       <td width="54%"><%botonera.dibujaboton "guardar"%></td>
					  <td width="40%"><%botonera.dibujaboton "salir"%></td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<%end if%>
            <BR>
			<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
                    <tr> 
                      <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                      <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                      <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
                      <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                      <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                            <td width="176" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Carga Asignada al alumno 
                                </font></div></td>
                            <td width="10"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="473" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                          </tr>
                        </table></td>
                      <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                    </tr>
                    <tr> 
                      <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                      <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><div align="center"> 
                          <form name="carga_tomada">
                            <table width="98%"  border="0">
                               <%if matr_ncorr <> "" then %>
								  <tr>
									<td><%pagina.DibujarSubtitulo "Carga Asignada al alumno"%>
									  <br>
									  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
										  <td><div align="right">Pagina <%f_alumno.accesoPagina%></div></td>
										</tr>
										<tr>
										  <td><div align="center"><%f_alumno.DibujaTabla%></div></td>
										</tr>
										<tr> 
										<td align="right">&nbsp;</td>
									  </tr>
									  <tr>
										<td align="right">
										<% if f_alumno.nroFilas = 0 then
											   'f_botonera.agregabotonparam "ELIMINAR", "deshabilitado" ,"TRUE"
										   end if							
											   'f_botonera.DibujaBoton "ELIMINAR"%>
										</td>
									  </tr>
									  </table></td>
								 </tr>
							   <%end if%>
                            </table>
                          </form>
                        </div></td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                      <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                      <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>
	<br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
