<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Información de alumnos"
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
 f_busqueda.Carga_Parametros "info_alumnos.xml", "busqueda_usuarios_nuevo"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut
 f_busqueda.AgregaCampoCons "pers_xdv", digito
'--------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "info_alumnos.xml", "botonera"
'--------------------------------------------------------------------------
set datos_personales = new CFormulario
datos_personales.Carga_Parametros "tabla_vacia.xml", "tabla"
datos_personales.Inicializar conexion
consulta_datos =  " select a.pers_ncorr,protic.format_rut(pers_nrut) as rut, pers_temail, "& vbCrLf &_
				  " isnull(pers_tcelular,(select top 1 pers_tcelular from direcciones where pers_ncorr=a.pers_ncorr and pers_tcelular is not null)) as pers_tcelular, "& vbCrLf &_
				  " isnull(pers_tfono,(select top 1 pers_tfono from direcciones where pers_ncorr=a.pers_ncorr and pers_tfono is not null)) as pers_tfono,    "& vbCrLf &_
				  " a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' +a.pers_tape_materno as nombre, "& vbCrLf &_
				  " b.sexo_tdesc as sexo,c.pais_tdesc as pais "& vbCrLf &_
				  " from personas_postulante a,sexos b,paises c "& vbCrLf &_
				  " where cast(a.pers_nrut as varchar)='"&rut&"' "& vbCrLf &_
				  " and a.sexo_ccod *=b.sexo_ccod "& vbCrLf &_
				  " and a.pais_ccod=c.pais_ccod"

datos_personales.Consultar consulta_datos
datos_personales.siguiente

codigo 			= datos_personales.obtenerValor("pers_ncorr")
rut_completo 	= datos_personales.obtenerValor("rut")
nombre 	= datos_personales.obtenerValor("nombre")
sexo 	= datos_personales.obtenerValor("sexo")
pais 	= datos_personales.obtenerValor("pais")
pers_tcelular 	= datos_personales.obtenerValor("pers_tcelular")
pers_tfono 		= datos_personales.obtenerValor("pers_tfono")
pers_temail 	= datos_personales.obtenerValor("pers_temail")
'pais = datos_personales.obtenerValor("pais")




if not esvacio(codigo) then
es_moroso = conexion.consultaUno("select protic.es_moroso('"&codigo&"', getDate())")
	if es_moroso="N" then
		moroso = "No"
	else
	    consulta_monto = " select isnull(sum(protic.total_recepcionar_cuota(dc.tcom_ccod, dc.inst_ccod,dc.COMP_NDOCTO,dc.DCOM_NCOMPROMISO)), 0) "& vbCrLf &_
    					 " from compromisos cc,detalle_compromisos dc "& vbCrLf &_
    					 " where cc.tcom_ccod = dc.tcom_ccod "& vbCrLf &_
			             "        and cc.comp_ndocto = dc.comp_ndocto "& vbCrLf &_
				         "        and cc.inst_ccod = dc.inst_ccod      "& vbCrLf &_
						 "        --and convert(datetime,dc.DCOM_FCOMPROMISO,103) < convert(datetime,getDate(),103) "& vbCrLf &_
			             "		and dateadd(day,4,convert(datetime,dc.DCOM_FCOMPROMISO,103)) < convert(datetime,getDate(),103) "& vbCrLf &_
				         "        and dc.ecom_ccod = 1 "& vbCrLf &_
				         "        and cc.ecom_ccod = 1 "& vbCrLf &_
				         "        and cast(cc.pers_ncorr as varchar)= '"&codigo&"'" 
		
		moroso = "Sí"		
		monto = conexion.consultaUno(consulta_monto)
    end if
end if

'------------------------------------------------------------------------------------------------------
'----------------------------buscamos la información de acceso al sistema por parte del alumno
set datos_online = new CFormulario
datos_online.Carga_Parametros "info_alumnos.xml", "formu_online"
datos_online.Inicializar conexion
consulta_acceso =  " select susu_tlogin as login,susu_tclave as clave, (select case count(*) when 0 then 'No autorizado' else 'Autorizado' end from sis_roles_usuarios bb where bb.pers_ncorr=a.pers_ncorr and bb.srol_ncorr=4) as autorizado "& vbCrLf &_
				  " from sis_usuarios a where cast(pers_ncorr as varchar)='"&codigo&"'"

datos_online.Consultar consulta_acceso
datos_online.siguiente

'------------------------------------------------------------------------------------------------------
'----------------------------buscamos la información de acceso al sistema para entrar postulación
set datos_acceso = new CFormulario
datos_acceso.Carga_Parametros "info_alumnos.xml", "formu_clave"
datos_acceso.Inicializar conexion
consulta_acceso =  " select usua_tpregunta,usua_trespuesta,usua_tusuario,usua_tclave "& vbCrLf &_
				  " from usuarios where cast(pers_ncorr as varchar)='"&codigo&"'"

datos_acceso.Consultar consulta_acceso
datos_acceso.siguiente
'------------------------------------------------------------------------------------------------------
'----------------------------buscamos la información de postulaciones del alumno
set datos_postulacion = new CFormulario
datos_postulacion.Carga_Parametros "info_alumnos.xml", "postulaciones"
datos_postulacion.Inicializar conexion
consulta_postulacion =  " select distinct b.ofer_ncorr as num_ofe,b.post_ncorr as num_pos,c.peri_ccod,protic.initcap(f.peri_tdesc) as periodo,protic.initcap(g.sede_tdesc) as sede, protic.initcap(e.carr_tdesc) as carrera,case h.jorn_ccod when 1 then '(D)' else '(V)' end as jornada,cast(d.espe_ccod as varchar)+ '-->' + protic.initcap(d.espe_tdesc) as mension  "& vbCrLf &_
						" ,case a.epos_ccod when 1 then 'No enviada' when 2 then 'Enviada' end as estado_pos, protic.initcap(i.eepo_tdesc) as estado_examen,f.anos_ccod,f.plec_ccod " & vbCrLf &_
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
						" order by f.anos_ccod asc,f.plec_ccod asc,b.post_ncorr asc "
'response.Write("<pre>"&consulta_postulacion&"</pre>")
datos_postulacion.Consultar consulta_postulacion
'datos_postulacion.siguiente

'------------------------------------------------------------------------------------------------------
'----------------------------buscamos la información de las matriculas del alumno
set datos_matriculas = new CFormulario
datos_matriculas.Carga_Parametros "info_alumnos.xml", "matriculas"
datos_matriculas.Inicializar conexion
consulta_matriculas =  " select a.matr_ncorr as num_matricula, a.post_ncorr as num_pos,cast(j.cont_ncorr as varchar) + case j.contrato when null then '' else '(' + cast(contrato as varchar) + ')' end  as num_con,protic.initcap(f.peri_tdesc) as periodo,protic.initcap(g.sede_tdesc) as sede, protic.initcap(e.carr_tdesc) as carrera,case h.jorn_ccod when 1 then '(D)' else '(V)' end as jornada,cast(d.espe_ccod as varchar)+ '-->' + protic.initcap(d.espe_tdesc) as mension, "& vbCrLf &_
					   " protic.initcap(i.emat_tdesc) as estado_alumno, protic.trunc(isnull(j.cont_fcontrato,a.alum_fmatricula)) as fecha, isnull(k.econ_tdesc,'*') as estado_matricula "& vbCrLf &_   
					   " ,l.plan_tdesc as plan_estu, m.espe_ccod as espe_plan,f.anos_ccod,f.plec_ccod "& vbCrLf &_
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
					   " order by f.anos_ccod asc,f.plec_ccod asc, a.alum_fmatricula asc    "
'response.Write("<pre>"&consulta_matriculas&"</pre>")
datos_matriculas.Consultar consulta_matriculas
'datos_matriculas.siguiente
consulta = " select top 1 cast(c.pers_nrut as varchar)+ '-' +c.pers_xdv + ' : ' + c.pers_tnombre +  ' ' + c.pers_tape_paterno + ' (' + d.pare_tdesc + ') post: ' + cast(b.post_ncorr as varchar) " & vbCrLf &_
		   " from postulantes a, codeudor_postulacion b, personas c,parentescos d " & vbCrLf &_
		   " where cast(a.pers_ncorr as varchar)='"&codigo&"' " & vbCrLf &_
		   " and a.post_ncorr=b.post_ncorr " & vbCrLf &_
		   " and a.peri_ccod = (select max(peri_ccod) " & vbCrLf &_
		   " from postulantes aa, codeudor_postulacion ba where cast(aa.pers_ncorr as varchar)='"&codigo&"' and aa.post_ncorr=ba.post_ncorr) " & vbCrLf &_
		   " and b.pers_ncorr=c.pers_ncorr " & vbCrLf &_
		   " and b.pare_ccod=d.pare_ccod " & vbCrLf &_
		   " order by post_fpostulacion desc "
codeudor = conexion.consultaUno(consulta)


usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")

autorizado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios a where srol_ncorr='99' and cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"'")	


c_post_ncorr = " select top 1 a.post_ncorr  " & vbCrLf &_
		   " from postulantes a " & vbCrLf &_
		   " where cast(a.pers_ncorr as varchar)='"&codigo&"' and epos_ccod = 2" & vbCrLf &_
		   " and a.peri_ccod = (select max(peri_ccod) " & vbCrLf &_
		   " from postulantes aa, codeudor_postulacion ba where cast(aa.pers_ncorr as varchar)='"&codigo&"' and aa.post_ncorr=ba.post_ncorr) " & vbCrLf &_
           " and exists (select 1 from contratos cc, compromisos dd where cc.post_ncorr=a.post_ncorr and cc.cont_ncorr=dd.comp_ndocto and dd.ecom_ccod <> 3)" & vbCrLf &_    
		   " order by post_fpostulacion desc "
'response.Write("<pre>"&c_post_ncorr&"</pre>")
ultimo_post_ncorr = conexion.consultaUno(c_post_ncorr)

'response.Write("<pre>"&c_post_ncorr&"</pre>")
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
                  <%if rut<>"" then%>
				  <table width="100%" border="0">
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
                      <td align="left" width="15%"><strong>Email</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=pers_temail%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Celular</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=pers_tcelular%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Fono Fijo</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=pers_tfono%></td>
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
					<tr> 
                      <td align="left" width="15%"><strong>Es Moroso</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=moroso%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Monto deuda</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=monto%></td>
					</tr>
					<tr> 
                      <td align="left" width="15%"><strong>Último Codeudor</strong></td>
					  <td align="left" width="2%"><strong>:</strong></td>
					  <td align="left"><%=codeudor%></td>
					</tr>
                  </table>
				  <%end if%>
				  <br>
				  <table width="100%" border="0">
				  	<tr>
                      	<td align="left"><strong>DATOS DE MATRICULAS HISTÓRICAS DE LA PERSONA.</strong></td>
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
                      <td align="Right">* No existe informaci&oacute;n del estado del contrato</td>
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
					   <% if ultimo_post_ncorr <> "" then
					      botonera.agregabotonparam "imprimir_alumno", "url", "../REPORTESNET/ficha_alumno.aspx?post_ncorr=" &  ultimo_post_ncorr  
    					  botonera.dibujaboton "imprimir_alumno" 
						  end if%>
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
