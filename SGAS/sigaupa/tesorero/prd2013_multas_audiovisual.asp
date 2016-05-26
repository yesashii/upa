<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

set errores = new CErrores
'---------------------------------------------------------------------------------------------------
q_pers_nrut 	= 	Request.QueryString("buscador[0][pers_nrut]")
q_pers_xdv 		= 	Request.QueryString("buscador[0][pers_xdv]")
q_leng 			= 	Request.QueryString("leng")
v_peri_cta		=	Request.QueryString("v_peri_cta")

set pagina = new CPagina
pagina.Titulo = "Revisión de multas Audiovisual"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion



set f_botonera = new CFormulario
f_botonera.Carga_Parametros "cuenta_corriente.xml", "botonera"

set f_botonera2 = new CFormulario
f_botonera2.Carga_Parametros "rec_ingresos.xml", "botonera"

set botonera = new CFormulario
botonera.Carga_Parametros "anular_compromisos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "cuenta_corriente.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.Siguiente

v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")
pers_ncorr = v_pers_ncorr

v_peri_ccod_pos = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_peri_ccod_18  = negocio.ObtenerPeriodoAcademico("CLASES18")
'response.Write("peri postulacion: "&v_peri_ccod_pos&" <br> Peri Calses18: "&v_peri_ccod_18)

if cint(v_peri_ccod_pos) < cint(v_peri_ccod_18) then
	v_peri_ccod = v_peri_ccod_18
else
	v_peri_ccod =v_peri_ccod_pos
end if
periodo = v_peri_ccod

'---------------------------------------------------------------------------------------------------



'---------------------------------------------------------------------------------------------------
if v_peri_cta <> "" then
	filtro="SI"
else
	filtro="NO"
end if


if v_peri_cta="" then
	v_peri_cta=v_peri_ccod
end if
'---------------------------------------------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut

set alumno = new CAlumno
es_alumno = false

if EsVacio(persona.ObtenerMatriculaPeriodo(v_peri_cta)) then

' obtiene el periodo de la ultima matricula existente
	sql_ultima_matricula="select max(peri_ccod) from postulantes a, alumnos b where a.post_ncorr=b.post_ncorr and cast(b.pers_ncorr as varchar)='"&v_pers_ncorr&"'"
	v_peri_ant=conexion.ConsultaUno(sql_ultima_matricula)
	if EsVacio(v_peri_ant) then ' no existe matricula para ningun periodo
		set f_datos = persona
		persona="SI"
	else ' busca matricula correspondiante a ultimo periodo cursado

		if EsVacio(persona.ObtenerMatriculaPeriodo(v_peri_ant)) then

			set f_datos = persona
			persona="SI"
		else
			es_alumno = true
			alumno.InicializarCarreras conexion, persona.ObtenerMatriculaPeriodo(v_peri_ant), v_peri_ant,v_peri_cta
			set f_datos = alumno
			persona="NO&periodo="&v_peri_ant&"&filtro="&filtro&"&peri_sel="&v_peri_cta
		end if
	end if
	
else
	es_alumno = true
	alumno.InicializarCarreras conexion, persona.ObtenerMatriculaPeriodo(v_peri_cta), v_peri_cta,v_peri_cta
	set f_datos = alumno
	persona="NO&periodo="&v_peri_cta&"&filtro="&filtro&"&peri_sel="&v_peri_cta
end if

		sql_detalle_compromisos = "select b.inst_ccod, b.comp_ndocto,b.tcom_ccod, case when b.tcom_ccod in (1,2) then cast(b.comp_ndocto as varchar)+ ' ('+protic.numero_contrato(b.comp_ndocto)+')'else cast(b.comp_ndocto as varchar) end as ncompromiso, " & vbCrLf &_
								"     case " & vbCrLf &_
								"   when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35 or b.tcom_ccod=15 " & vbCrLf &_
        						"		then " & vbCrLf &_
							    "       (Select top 1 a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod " & vbCrLf &_
							    "        and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) " & vbCrLf &_
							    " 	when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') "& vbCrLf &_
								"   else " & vbCrLf &_
							    "        (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod) " & vbCrLf &_
							    "    end as tcom_tdesc, " & vbCrLf &_
								"    b.dcom_ncompromiso,cast(b.dcom_ncompromiso as varchar) + '/' + cast(a.comp_ncuotas as varchar)  as ncuota," & vbCrLf &_
								"    a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso," & vbCrLf &_
								"    protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod," & vbCrLf &_
								"    case  "& vbCrLf &_
								"    when a.tcom_ccod=2 and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')=52 "& vbCrLf &_
								"        then  "& vbCrLf &_
								"          (select pag.PAGA_NCORR from  pagares pag 	where  pag.cont_ncorr =a.comp_ndocto and isnull(pag.opag_ccod,1) not in (2)) "& vbCrLf &_
								"        else "& vbCrLf &_
								"            protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') "& vbCrLf &_
								"        end as ding_ndocto, "& vbCrLf &_
								"    protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, " & vbCrLf &_
								"    protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado," & vbCrLf &_
								"    isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, " & vbCrLf &_
								"(select d.edin_ccod from  estados_detalle_ingresos d" & vbCrLf &_
								"    where c.edin_ccod = d.edin_ccod) as edin_ccod," & vbCrLf &_
								"(select d.edin_tdesc+protic.obtener_institucion(c.ingr_ncorr) from estados_detalle_ingresos d" & vbCrLf &_
								"    where c.edin_ccod = d.edin_ccod) as edin_tdesc, " & vbCrLf &_
								" protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) + " & vbCrLf &_
								"    protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonado "& vbCrLf &_
								" from compromisos a,detalle_compromisos b,detalle_ingresos c" & vbCrLf &_
								" where a.tcom_ccod = b.tcom_ccod" & vbCrLf &_
								"    and a.inst_ccod = b.inst_ccod " & vbCrLf &_
								"    and a.comp_ndocto = b.comp_ndocto" & vbCrLf &_
								"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') *= c.ting_ccod" & vbCrLf &_
								"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') *= c.ding_ndocto" & vbCrLf &_
								"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') *= c.ingr_ncorr" & vbCrLf &_
								"    and a.ecom_ccod = '1' "&v_sql&" " & vbCrLf &_
								"    and b.ecom_ccod <> '3' " & vbCrLf &_
								"    and a.tcom_ccod in (5)  " & vbCrLf &_
								"    and cast(a.pers_ncorr as varchar) ='" & v_pers_ncorr & "'" & vbCrLf &_
								"    order by b.dcom_fcompromiso desc"

set f_cuenta = new CFormulario
f_cuenta.Carga_Parametros "multas_audiovisual.xml", "detalle_compromisos"
f_cuenta.Inicializar conexion
f_cuenta.Consultar sql_detalle_compromisos


f_botonera2.AgregaBotonUrlParam "agregar_multa", "pers_ncorr", v_pers_ncorr
f_botonera2.AgregaBotonUrlParam "agregar_multa", "alto", 100


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
	rut=document.buscador.elements['buscador[0][pers_nrut]'].value+'-'+document.buscador.elements['buscador[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['buscador[0][pers_xdv]'].focus()
		document.buscador.elements['buscador[0][pers_xdv]'].select()
		return false;
	}
	
	return true;	
}


function InicioPagina()
{
	t_busqueda = new CTabla("buscador");
}

function Anular(){
formulario = document.edicion;
mensaje="Anular";
	if (verifica_check(formulario,mensaje)){
			return true;
	}
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="32%"><div align="right">R.U.T.</div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("pers_nrut")%>
      -
        <%f_busqueda.DibujaCampo("pers_xdv")%>
        <%pagina.DibujarBuscaPersonas "buscador[0][pers_nrut]", "buscador[0][pers_xdv]" %></td>
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
			  <% if v_pers_ncorr <> "" then %>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><%f_datos.DibujaDatos%></td>
				  <td>&nbsp;</td>
                </tr>
				<tr>
					<td colspan="2"><%	if 	es_alumno = true then
											f_datos.DibujaDatos2
										end if
										%></td>
				</tr>
              </table>
			  <%end if%>	
</div>			
			<form name="edicion">
			  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                  <tr>
                    <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                    <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                    <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                  </tr>
                  <tr>
                    <td width="9" background="../imagenes/marco_claro/9.gif"></td>
                    <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td> 
							<%
									pagina.DibujarSubtitulo("Detalle de multas audiovisual")
							%>
                            <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td><div align="center">
										<div align="right"><%f_cuenta.AccesoPagina%></div><%
										f_cuenta.DibujaTabla
										%>
                                  </div></td>
                                </tr>
                           </table>                            <br>
						   <table width="20%"  border="0" align="left" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td><div align="center">	
							<% f_botonera2.DibujaBoton("agregar_multa") %>
							</div></td>
							<td><% 
							
						if	f_cuenta.NroFilas = 0 then
							   botonera.agregabotonparam "anular", "deshabilitado" ,"TRUE"			   
					   end if
					    botonera.DibujaBoton ("anular")%>
						</td></tr></table>
                          </td>
                        </tr>
                    </table></td>
                    <td width="7" background="../imagenes/marco_claro/10.gif"></td>
                  </tr>
                  <tr>
                    <td width="9" height="13"><img src="../imagenes/marco_claro/base1.gif" width="9" height="13"></td>
                    <td height="13" background="../imagenes/marco_claro/15.gif"></td>
                    <td width="7" height="13"><img src="../imagenes/marco_claro/base3.gif" width="7" height="13"></td>
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
                        <td width="45%">&nbsp;</td>
                        <td width="55%"><div align="center">
                            <%f_botonera.DibujaBoton("salir")%>
                          </div></td>
						  <td width="55%"><div align="center"></div></td>
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
