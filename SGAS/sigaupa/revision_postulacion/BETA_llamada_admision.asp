<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Registro de llamadas admisión"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
rut = request.querystring("busqueda[0][pers_nrut]")
digito = request.querystring("busqueda[0][pers_xdv]")
grabar = request.querystring("grabar")
'--------------------------------------------------------------------------

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "llamada_admision.xml", "busqueda_usuarios_nuevo"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "llamada_admision.xml", "botonera"
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
'response.Write("<pre>"&consulta_datos&"</pre>")
datos_personales.Consultar consulta_datos
datos_personales.siguiente

codigo = datos_personales.obtenerValor("pers_ncorr")
rut_completo = datos_personales.obtenerValor("rut")
nombre = datos_personales.obtenerValor("nombre")
sexo = datos_personales.obtenerValor("sexo")
pais = datos_personales.obtenerValor("pais")

'----------------------------------------------------------------------------------------------------
'----------------------------buscamos la información de acceso al sistema por parte del alumno
set datos_online = new CFormulario
datos_online.Carga_Parametros "llamada_admision.xml", "formu_online"
datos_online.Inicializar conexion
consulta_acceso =  " select susu_tlogin as login,case when pers_ncorr in (103170,12118,101130) then '******' else susu_tclave end as clave, (select case count(*) when 0 then 'Sin asignar' else 'Asignados' end from sis_roles_usuarios bb where bb.pers_ncorr=a.pers_ncorr and bb.srol_ncorr=4) as autorizado, "& vbCrLf &_
                   " (select top 1 lower(email_nuevo) from cuentas_email_upa tt where tt.pers_ncorr=a.pers_ncorr) as email"& vbCrLf &_
				   " from sis_usuarios a where cast(pers_ncorr as varchar)='"&codigo&"'"

datos_online.Consultar consulta_acceso
datos_online.siguiente

'------------------------------------------------------------------------------------------------------
'----------------------------buscamos la información de acceso al sistema para entrar postulación
set datos_acceso = new CFormulario
datos_acceso.Carga_Parametros "llamada_admision.xml", "formu_clave"
datos_acceso.Inicializar conexion
consulta_acceso =  " select usua_tpregunta,usua_trespuesta,usua_tusuario,usua_tclave "& vbCrLf &_
				  " from usuarios where cast(pers_ncorr as varchar)='"&codigo&"'"

datos_acceso.Consultar consulta_acceso
datos_acceso.siguiente
'------------------------------------------------------------------------------------------------------
'----------------------------buscamos la información de postulaciones del alumno
set datos_postulacion = new CFormulario
datos_postulacion.Carga_Parametros "llamada_admision.xml", "postulaciones"
datos_postulacion.Inicializar conexion
consulta_postulacion =  " select distinct cast(f.anos_ccod as varchar)+'-'+cast(f.plec_ccod as varchar) as periodo,protic.initcap(g.sede_tdesc) as sede, protic.initcap(e.carr_tdesc) as carrera,case h.jorn_ccod when 1 then '(D)' else '(V)' end as jornada,cast(d.espe_ccod as varchar)+ '-->' + protic.initcap(d.espe_tdesc) as mension  "& vbCrLf &_
						" ,case a.epos_ccod when 1 then 'No enviada' when 2 then 'Enviada' end as estado_pos, protic.initcap(i.eepo_tdesc) as estado_examen,f.anos_ccod,f.plec_ccod, " & vbCrLf &_
						"  (select protic.trunc(fecha_entrevista)+' '+ htes_hinicio "& vbCrLf &_
						"   from observaciones_postulacion tt, horarios_test t2 "& vbCrLf &_
						"   where tt.post_ncorr=a.post_ncorr and tt.ofer_ncorr=b.ofer_ncorr  "& vbCrLf &_
						"   and tt.htes_ccod=t2.htes_ccod) as horario_entrevista "& vbCrLf &_
						" from postulantes a, detalle_postulantes b, ofertas_academicas c, especialidades d, "& vbCrLf &_
						"     carreras e, periodos_Academicos f, sedes g, jornadas h,estado_examen_postulantes i "& vbCrLf &_
						" where cast(a.pers_ncorr as varchar)='"&codigo&"'"& vbCrLf &_
						"	and a.post_ncorr = b.post_ncorr "& vbCrLf &_
						"	and b.ofer_ncorr = c.ofer_ncorr "& vbCrLf &_
						"	and c.espe_ccod  = d.espe_ccod "& vbCrLf &_
						"	and d.carr_ccod  = e.carr_ccod "& vbCrLf &_
						"	and c.peri_ccod  = f.peri_ccod "& vbCrLf &_
						"	and c.sede_ccod  = g.sede_ccod "& vbCrLf &_
						"	and c.jorn_ccod  = h.jorn_ccod "& vbCrLf &_
						"	and b.eepo_ccod  = i.eepo_ccod "& vbCrLf &_
						" order by f.anos_ccod desc,f.plec_ccod desc "
'response.Write("<pre>"&consulta_postulacion&"</pre>")
datos_postulacion.Consultar consulta_postulacion
'datos_postulacion.siguiente

'------------------------------------------------------------------------------------------------------
'----------------------------buscamos la información de las matriculas del alumno
set datos_matriculas = new CFormulario
datos_matriculas.Carga_Parametros "llamada_admision.xml", "matriculas"
datos_matriculas.Inicializar conexion
consulta_matriculas =  " select a.matr_ncorr as num_matricula, a.post_ncorr as num_pos,cast(j.cont_ncorr as varchar) + case j.contrato when null then '' else '(' + cast(contrato as varchar) + ')' end  as num_con,cast(anos_ccod as varchar)+'-'+cast(plec_ccod as varchar) as periodo,protic.initcap(g.sede_tdesc) as sede, protic.initcap(e.carr_tdesc) as carrera,case h.jorn_ccod when 1 then '(D)' else '(V)' end as jornada,cast(d.espe_ccod as varchar)+ '-->' + protic.initcap(d.espe_tdesc) as mension, "& vbCrLf &_
					   " protic.initcap(i.emat_tdesc) as estado_alumno, protic.trunc(isnull(j.cont_fcontrato,a.alum_fmatricula)) as fecha, isnull(k.econ_tdesc,'*') as estado_matricula "& vbCrLf &_   
					   " ,l.plan_tdesc as plan_estu, m.espe_ccod as espe_plan,f.anos_ccod,f.plec_ccod,isnull(j.cont_fcontrato,a.alum_fmatricula) as fecha2  "& vbCrLf &_
					   " from "& vbCrLf &_
					   " alumnos a join ofertas_academicas c "& vbCrLf &_
				       "    on a.ofer_ncorr = c.ofer_ncorr "& vbCrLf &_
					   " join especialidades d "& vbCrLf &_
				       "    on c.espe_ccod  = d.espe_ccod "& vbCrLf &_
					   " join carreras e "& vbCrLf &_
				       "    on d.carr_ccod  = e.carr_ccod "& vbCrLf &_
					   " join periodos_Academicos f "& vbCrLf &_
				       "    on c.peri_ccod  = f.peri_ccod  "& vbCrLf &_
				       " join sedes g "& vbCrLf &_
				       "    on c.sede_ccod  = g.sede_ccod "& vbCrLf &_
				       " join jornadas h "& vbCrLf &_
				       "    on c.jorn_ccod  = h.jorn_ccod  "& vbCrLf &_
					   " join estados_matriculas i "& vbCrLf &_
					   "    on a.emat_ccod  = i.emat_ccod "& vbCrLf &_
					   " left outer join contratos j "& vbCrLf &_
					   "    on a.matr_ncorr = j.matr_ncorr "& vbCrLf &_
				       " left outer join estados_contrato k "& vbCrLf &_
					   "    on j.econ_ccod = k.econ_ccod "& vbCrLf &_
					   "left outer join planes_estudio l "& vbCrLf &_
					   "    on a.plan_ccod = l.plan_ccod   "& vbCrLf &_
					   " left outer join especialidades m "& vbCrLf &_
					   "    on l.espe_ccod = m.espe_ccod " & vbCrLf &_
					   " where cast(a.pers_ncorr as varchar)='"&codigo&"' "& vbCrLf &_
					   " union  "& vbCrLf &_
 					   " select null as num_matricula, null as num_pos,null  as num_con,protic.initcap(d.peri_tdesc) as periodo,null as sede, protic.initCap(linea_1_certificado + ' ' + linea_2_certificado) as carrera,  "& vbCrLf &_
					   " null as jornada,protic.initCap(linea_1_certificado + ' ' + linea_2_certificado) as mension,   "& vbCrLf &_
					   " protic.initcap(c.emat_tdesc) as estado_alumno, protic.trunc(a.fecha_proceso) as fecha, '*' as estado_matricula   "& vbCrLf &_
					   " ,null as plan_estu, null as espe_plan,d.anos_ccod,d.plec_ccod,a.fecha_proceso as fecha2   "& vbCrLf &_
					   " from alumnos_salidas_intermedias a, salidas_carrera b,estados_matriculas c,periodos_academicos d, carreras e  "& vbCrLf &_
					   " where cast(a.pers_ncorr as varchar)='"&codigo&"' and a.saca_ncorr=b.saca_ncorr    "& vbCrLf &_
					   " and a.emat_ccod=c.emat_ccod  and a.peri_ccod = d.peri_ccod and b.carr_ccod=e.carr_ccod "& vbCrLf &_
					   " order by anos_ccod desc,plec_ccod desc, fecha2 desc    "
'response.Write("<pre>"&consulta_matriculas&"</pre>")
datos_matriculas.Consultar consulta_matriculas
'datos_matriculas.siguiente

usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")

'autorizado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios a where srol_ncorr='99' and cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"'")

autorizado="S"

tiene_foto  = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from rut_fotos_2010 where cast(rut as varchar)='"&rut&"'")
tiene_foto2 = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&rut&"'")

if tiene_foto="S" then 
 	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(imagen)) from rut_fotos_2010 where cast(rut as varchar)='"&rut&"'")
elseif tiene_foto="N" and tiene_foto2="S" then 
  	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(foto_truta)) from fotos_alumnos where cast(pers_nrut as varchar)='"&rut&"'")	
else
    nombre_foto = "user.png"
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
function postular_online()
{
	formu_llamado.target="_blank";
	formu_llamado.submit();
}
function guardar_llamado()
{
   formu_llamado.target="_self";
   formu_llamado.action="llamada_admision_proc.asp";
   formu_llamado.submit();
}
</script>

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
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos 
                          Encontrados</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
					<%pagina.DibujarTituloPagina%>
                  </div>
                  <%if rut <> "" then%>
				  <table width="100%" border="0">
				  <%if codigo <> "" then%>
				    <tr valign="top">
						<td colspan="3">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="80%" align="left">
										<table width="100%" cellpadding="0" cellspacing="0">
											<tr> 
											  <td align="left" width="15%"><strong>C&oacute;digo</strong></td>
											  <td align="left" width="2%"><strong>:</strong></td>
											  <td width="83%" align="left"><%=codigo%></td>
											</tr>
											<tr> 
											  <td align="left" width="15%"><strong>R.U.T.</strong></td>
											  <td align="left" width="2%"><strong>:</strong></td>
											  <td align="left"><%=rut_completo%></td>
											</tr>
											<tr> 
											  <td align="left" width="15%"><strong>Nombre</strong></td>
											  <td align="left" width="2%"><strong>:</strong></td>
											  <td align="left"><%=nombre%></td>
											</tr>
											<tr> 
											  <td align="left" width="15%"><strong>Sexo</strong></td>
											  <td align="left" width="2%"><strong>:</strong></td>
											  <td align="left"><%=sexo%></td>
											</tr>
											<tr> 
											  <td align="left" width="15%"><strong>Pa&iacute;s</strong></td>
											  <td align="left" width="2%"><strong>:</strong></td>
											  <td align="left"><%=pais%></td>
											</tr>
										</table>								
									</td>
									<td width="20%" align="center">
									    <img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=nombre_foto%>" border="2">
									</td>
								</tr>
							</table>
						</td>
					</tr>
                    <%end if%>
					<%if (autorizado= "S") and grabar <> "1" then%>
					<tr><td colspan="3" align="center">&nbsp;</td></tr>
					<tr><td colspan="3" align="center">&nbsp;</td></tr>
					<tr>
					   <td colspan="3" align="center">
					   <form name="formu_llamado" action="http://admision.upacifico.cl/postulacion/www/inicio.php?p=1" method="post">
					       <input type="hidden" name="pers_nrut" value="<%=rut%>">
						   <input type="hidden" name="pers_xdv" value="<%=digito%>">
					       <table width="90%" cellpadding="0" cellspacing="10" border="1">
						   	  <tr>
							  		<td width="50%" align="center">
									   <input type="button" name="b1" value="POSTULACIÓN ONLINE" onClick="postular_online();" title="Ir a postulación online">
									</td>
									<td width="50%" align="center">
									   <table width="100%" cellpadding="0" cellspacing="0">
									   	<tr>
											<td colspan="2" align="center"><strong>REGISTRO DE LLAMADO ATENDIDO</strong></td>
										</tr>
										<tr>
											<td width="10%"><strong>Rut</strong></td>
											<td width="10%"><%=rut%>-<%=digito%></td>
										</tr>
										<tr>
											<td width="10%"><strong>Nombre</strong></td>
											<td width="10%"><input type="text" name="nombre_completo" size="40" maxlength="60"></td>
										</tr>
										<tr>
											<td width="10%"><strong>Observación</strong></td>
											<td width="10%"><textarea name="observacion" rows="3" cols="40"></textarea></td>
										</tr>
										<tr>
											<td width="10%"><strong>Postulado online</strong></td>
											<td width="10%"><input type="checkbox" name="postulado_online" value="1"></td>
										</tr>
										<tr>
											<td width="10%"><strong>Teléfono</strong></td>
											<td width="10%"><input type="text" name="pers_tfono" size="20" maxlength="30"></td>
										</tr>
										<tr>
											<td width="10%"><strong>Email</strong></td>
											<td width="10%"><input type="text" name="pers_temail" size="40" maxlength="40"></td>
										</tr>
										<tr>
											<td colspan="2" align="center">
												<input type="button" name="b2" value="GUARDAR LLAMADO" onClick="guardar_llamado();" title="Guardar información sobre llamado">
											</td>
										</tr>
									   </table>
									</td>
							  </tr>
						   </table>
					   </form>					
					   </td>
					</tr>
					<tr>
					   <td colspan="3" height="30" align="center" bgcolor="#d8d8de">
					                 
				      </td>
					</tr>
					<%elseif grabar = "1" then %>
					<tr><td colspan="3" align="center">&nbsp;</td></tr>
					<tr>
					   <td colspan="3" height="30" align="center" bgcolor="#009933"><font color="#FFFFFF" size="2"><strong>El registro de la llamada ha sido grabado exitosamente.</strong></font>
				      </td>
					</tr>
					<%end if%>
                  </table>
				  <%end if%>
				  <table width="100%" border="0">
                    <tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
					<tr> 
                      <td align="left">- Datos de acceso postulante para completar ficha de admisión</td>
                    </tr>
					<tr> 
						<td><form name="edicion_acceso">
							<div align="center">
							  <% datos_acceso.DibujaTabla %>
							</div>
						  </form>
					  </td>
                    </tr>
					<tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
					<tr> 
                      <td align="left">- Datos de postulaciones históricas del postulante.</td>
                    </tr>
					<tr> 
						<td><form name="edicion_postulacion">
							<div align="center">
							  <%datos_postulacion.DibujaTabla %>
							</div>
						  </form>
					  </td>
                    </tr>
					<tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
					<tr> 
                      <td align="left">- Datos de matriculas históricas del postulante.</td>
                    </tr>
					<tr> 
						<td><form name="edicion_matriculas">
							<div align="center">
							  <%datos_matriculas.DibujaTabla %>
							</div>
						  </form>
					  </td>
                    </tr>
					<tr> 
                      <td align="Right">&nbsp;</td>
                    </tr>
                  </table> 
                  
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                       <td width="54%">
                        <%  botonera.dibujaboton "salir"%>
                      </td>
					  <td width="40%">
					  <% botonera.agregaBotonParam "excel","url","llamada_admision_excel.asp" 
					     botonera.dibujaboton "excel"%>
					  </td>
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
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
