<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_carr_ccod = Request.QueryString("b[0][carr_ccod]")
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
'response.Write("solo_rut "&q_solo_rut)
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Administración Salidas Alumno"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new cErrores
'---------------------------------------------------------------------------------------------------
set f_botonera_g = new CFormulario
f_botonera_g.Carga_Parametros "botonera_generica.xml", "botonera"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_salidas_alumnos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
v_sede_ccod = negocio.ObtenerSede

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "adm_salidas_alumnos.xml", "busqueda"
f_busqueda.Inicializar conexion

f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "carr_ccod", q_carr_ccod
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


SQL =        " select distinct c.carr_ccod, c.carr_tdesc "
SQL = SQL &  " from ofertas_academicas a, especialidades b, carreras c "
SQL = SQL &  " where a.espe_ccod = b.espe_ccod "
SQL = SQL &  "   and b.carr_ccod = c.carr_ccod "
SQL = SQL &  "   and exists (select 1 from alumnos tt where tt.ofer_ncorr=a.ofer_ncorr and tt.emat_ccod=1) "
SQL = SQL &  " UNION "
SQL = SQL &  "   select '' as carr_ccod,' TODAS ' as carr_tdesc "
SQL = SQL &  " order by c.carr_tdesc asc "

f_busqueda.InicializaListaDependiente "busqueda", SQL

if q_carr_ccod = "" and q_pers_nrut <> "" then
    q_carr_ccod = conexion.consultaUno("select top 1 carr_ccod from alumnos tt, ofertas_academicas t2, especialidades t3, personas t4 where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and tt.pers_ncorr=t4.pers_ncorr and cast(t4.pers_nrut as varchar)='"&q_pers_nrut&"' and emat_ccod <> 9 order by peri_ccod desc ")
end if


c_datos = " select a.pers_ncorr, cast(pers_nrut as varchar)+'-'+pers_xdv as rut, "& vbCrLf &_
		  " protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) as alumno, "& vbCrLf &_
		  " (select case count(*) when 0 then 'N' else 'S' end from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_
          "       where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr "& vbCrLf &_
          "       and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and t1.emat_ccod=8) as titulado, "& vbCrLf &_
		  " (select case count(*) when 0 then 'N' else 'S' end from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_
          "       where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr "& vbCrLf &_
          "       and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and t1.emat_ccod=4) as egresado, "& vbCrLf &_
		  " (select case count(*) when 0 then 'N' else 'S' end from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_
          "       where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr "& vbCrLf &_
          "       and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and t1.emat_ccod=1) as en_carrera, "& vbCrLf &_             
		  " (select t1.plan_ccod from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_ 
          "       where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr "& vbCrLf &_ 
          "       and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and t1.emat_ccod=8) as plan_titulacion, "& vbCrLf &_ 
		  " (select case count(*) when 0 then 'N' else 'S' end from alumnos t1,ofertas_academicas t2,especialidades t3, planes_estudio t4"& vbCrLf &_ 
          "       where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr and t1.plan_ccod=t4.plan_ccod "& vbCrLf &_ 
          "       and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and t1.emat_ccod=8 and t3.espe_ccod=t4.espe_ccod) as encasillado, "& vbCrLf &_ 
          " (select 'El alumno se encuentra titulado para esta carrera en la especialidad: <strong>'+lower(t3.espe_tdesc)+' - '+lower(t4.plan_tdesc)+'</strong>'  "& vbCrLf &_ 
          "      from alumnos t1,ofertas_academicas t2, especialidades t3,planes_estudio t4 "& vbCrLf &_ 
          "      where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr and t1.plan_ccod=t4.plan_ccod "& vbCrLf &_ 
          "      and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and t1.emat_ccod=8) as detalle_titulacion,  "& vbCrLf &_ 
		  " (select max(peri_ccod)  "& vbCrLf &_ 
  		  "      from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_ 
     	  "      where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr  "& vbCrLf &_ 
      	  "      and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and isnull(t1.emat_ccod,0) <> 9) as ultimo_periodo  "& vbCrLf &_ 
		  " from personas a "& vbCrLf &_
		  " where cast(pers_nrut as varchar)='"&q_pers_nrut&"'"
		  
'response.write("<pre>"&c_datos&"</pre>")
'---------------------------------------------------------------------------------------------------
carr_tdesc = conexion.consultaUno("select protic.initCap(carr_tdesc) from carreras where carr_ccod='"&q_carr_ccod&"'")
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "tabla_vacia.xml", "tabla"
f_encabezado.Inicializar conexion

f_encabezado.Consultar c_datos
f_encabezado.siguiente

detalle_titulacion = f_encabezado.obtenerValor("detalle_titulacion")
q_plan_ccod = f_encabezado.obtenerValor("plan_titulacion")
en_carrera = f_encabezado.obtenerValor("en_carrera")
encasillado = f_encabezado.obtenerValor("encasillado")
pers_ncorr = f_encabezado.obtenerValor("pers_ncorr")
titulado = f_encabezado.obtenerValor("titulado")
ultimo_periodo = f_encabezado.obtenerValor("ultimo_periodo")
if titulado = "N" and not EsVacio(ultimo_periodo) then
 c_detalle_ultima_matricula = " Select top 1 'El alumno no se encuentra titulado en la carrera seleccionada, su última matrícula corresponde a la especialidad: <strong>'+lower(c.espe_tdesc)+' - '+lower(d.plan_tdesc)+'</strong>, con el estado de matrícula '+e.emat_tdesc "&_
                               " from alumnos a, ofertas_academicas b, especialidades c, planes_estudio d, estados_matriculas e "&_
							   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=d.plan_ccod and a.emat_ccod=e.emat_ccod "&_
							   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"' and c.carr_ccod='"&q_carr_ccod&"' and isnull(a.emat_ccod,0) <> 9 "
 detalle_ultima_matricula =  conexion.consultaUno(c_detalle_ultima_matricula)
 c_plan_ccod = " select top 1 a.plan_ccod "&_
               " from alumnos a, ofertas_academicas b, especialidades c, planes_estudio d, estados_matriculas e "&_
			   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=d.plan_ccod and a.emat_ccod=e.emat_ccod "&_
			   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"' and c.carr_ccod='"&q_carr_ccod&"' and isnull(a.emat_ccod,0) <> 9 "
 q_plan_ccod = conexion.consultaUno(c_plan_ccod)
end if

if en_carrera ="S" then 
	if detalle_titulacion <> "" and titulado = "S"  then
		mensaje_html = "<center> "&_
					   "     <table border='1'  bordercolor='#339900' cellspacing='2' cellpadding='5' align='center'> "&_
					   "       <tr>"&_
					   "	         <td align='center' bgcolor='#CCFFCC'>"&detalle_titulacion&"</td> "&_
					   "       </tr>"&_
					   "     </table> "&_
					   " </center>"
	else
		mensaje_html = "<center>"&_
					   "    <table border='1'  bordercolor='#CC6600' cellspacing='2' cellpadding='5' align='center'> "&_
					   "      <tr> "&_
					   "         <td align='center' bgcolor='#FFCC66'>"&detalle_ultima_matricula&"</td> "&_
					   "      </tr> "&_
					   "    </table> "&_
					   "</center>"
	end if
else'en caso que el alumno no presente matrícula en la carrera
		mensaje_html = "<center>"&_
					   "    <table border='1'  bordercolor='#CC6600' cellspacing='2' cellpadding='5' align='center'> "&_
					   "      <tr> "&_
					   "         <td align='center' bgcolor='#FFCC66'>El alumno consultado no presenta matrícula en la carrera.</td> "&_
					   "      </tr> "&_
					   "    </table> "&_
					   "</center>"
end if

msj_encasillado=""
if encasillado = "N" and q_plan_ccod <> "" and titulado="S"  then'El alumno se encuentra mal encasillado en su matrícula con estado de titulación
	msj_encasillado = "El alumno se encuentra mal encasillado(especialidad o plan de estudios), para su matrícula de titulado"
end if

'---------------------------------------------------------------------------------------------------
set f_titulados = new CFormulario
f_titulados.Carga_Parametros "adm_salidas_alumnos.xml", "titulados"
f_titulados.Inicializar conexion

if q_carr_ccod <> "" then
	filtro_carrera = " carr_ccod='"&q_carr_ccod&"' and"
else
	filtro_carrera = " carr_ccod in (select distinct carr_ccod from alumnos tt, ofertas_academicas t2, especialidades t3 where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"') and "	
end if

SQL = "  select '"&pers_ncorr&"' as pers_ncorr,tsca_ccod,case a.tsca_ccod when 1 then '<font color=#073299><strong>' "& vbCrLf &_ 
      "            when 2 then '<font color=#004000><strong>' "& vbCrLf &_ 
  	  " 		   when 3 then '<font color=#b76d05><strong>' "& vbCrLf &_ 
	  "			   when 4 then '<font color=#714e9c><strong>' "& vbCrLf &_ 
	  " 		   when 5 then '<font color=#ab2b05><strong>' "& vbCrLf &_ 
	  "  		   when 6 then '<font color=#0078c0><strong>' end + a.tsca_tdesc + '</strong></font>' as tsca_tdesc, "& vbCrLf &_ 
	  " saca_ncorr, saca_tdesc as salida, "& vbCrLf &_ 
	  " (select count(*) from asignaturas_salidas_carrera tt where tt.saca_ncorr=a.saca_ncorr) as total_asignaturas_requeridas, "& vbCrLf &_ 
	  " (select ASCA_NFOLIO +'/'+cast(ASCA_NREGISTRO as varchar) from alumnos_salidas_carrera tt where tt.saca_ncorr=a.saca_ncorr and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"') as folio_reg, "& vbCrLf &_ 
	  " (select protic.trunc(ASCA_FSALIDA) from alumnos_salidas_carrera tt where tt.saca_ncorr=a.saca_ncorr and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"') as asca_fsalida, "& vbCrLf &_ 
	  " (select asca_nnota from alumnos_salidas_carrera tt where tt.saca_ncorr=a.saca_ncorr and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"') as asca_nnota "& vbCrLf &_ 
	  " from "& vbCrLf &_ 
	  " ( "& vbCrLf &_ 
	  " 	select a.tsca_ccod, tsca_tdesc, saca_ncorr,saca_tdesc  "& vbCrLf &_ 
	  " 	from salidas_carrera a, tipos_salidas_carrera b "& vbCrLf &_ 
	  " 	where "&filtro_carrera&" a.tsca_ccod in (1,2) and cast(plan_ccod as varchar)='"&q_plan_ccod&"' "& vbCrLf &_ 
	  " 	and a.tsca_ccod=b.tsca_ccod "& vbCrLf &_ 
	  " union "& vbCrLf &_ 
	  " 	select a.tsca_ccod, tsca_tdesc, saca_ncorr,saca_tdesc  "& vbCrLf &_ 
	  " 	from salidas_carrera a, tipos_salidas_carrera b "& vbCrLf &_ 
	  " 	where "&filtro_carrera&" a.tsca_ccod not in (1,2) "& vbCrLf &_ 
	  " 	and a.tsca_ccod=b.tsca_ccod "& vbCrLf &_ 
	  ") a "& vbCrLf &_ 
	  " order by tsca_ccod asc"

'response.Write("<pre>"&SQL&"</pre>")

f_titulados.Consultar SQL
total_salidas = f_titulados.nroFilas
'------------------------------------------------------------------------------------------------
if f_encabezado.NroFilas = 0 then
	f_botonera.AgregaBotonParam "agregar", "deshabilitado", "TRUE"
	f_botonera.AgregaBotonParam "eliminar", "deshabilitado", "TRUE"
else
	f_botonera.AgregaBotonUrlParam "agregar", "dp[0][plan_ccod]", q_plan_ccod
	f_botonera.AgregaBotonUrlParam "agregar", "dp[0][peri_ccod]", q_peri_ccod
end if
tiene_salidas = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from alumnos_salidas_carrera a, salidas_carrera b where a.saca_ncorr=b.saca_ncorr and tsca_ccod in (1,3,5,6) and b.carr_ccod='"&q_carr_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
tiene_titulo_ajuste = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr = b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.emat_ccod in (8) and c.carr_ccod='"&q_carr_ccod&"' and a.alum_nmatricula=7777 and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'")
tiene_egreso_ajuste = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr = b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.emat_ccod in (4) and c.carr_ccod='"&q_carr_ccod&"' and a.alum_nmatricula=7777 and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'")
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
var par=false;
colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6';
function parpadeo() 
{
	document.getElementById('txt').style.visibility= (par) ? 'visible' : 'hidden';
	par = !par;
}
function eliminar(saca,pers) 
{
	respuesta = confirm("¿Está seguro que desea eliminar la salida del alumno?, esto puede afectar la estadística de titulados"); 
	if (respuesta)
	{
        irA('adm_salidas_alumnos_eliminar.asp?saca_ncorr='+saca+'&pers_ncorr='+pers, '1', 50, 50); 
	}
}
function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["b[0][pers_nrut]"].value + "-" + formulario.elements["b[0][pers_xdv]"].value;	
	if (formulario.elements["b[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["b[0][pers_xdv]"].focus();
		formulario.elements["b[0][pers_xdv]"].select();
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
    document.buscador.elements["b[0][pers_nrut]"].value= texto_rut;
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
buscador.elements["b[0][pers_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['buscador'],'', 'Validar();', 'FALSE');
}
</script>

<%f_busqueda.GeneraJS%>

<style type="text/css">
.blink {text-decoration: blink;}
</style>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');setInterval('parpadeo()',500);" onBlur="revisaVentana(); ">
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
        		<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
					  </tr>
					  <tr>
						<td height="2" background="../imagenes/top_r3_c2.gif"></td>
					  </tr>
					  <tr>
            			<td>
							<form name="buscador">
              				<br>
              					<table width="98%"  border="0" align="center">
               					 <tr>
                  					<td width="81%">
									<div align="center">
                   						<table width="98%"  border="0">
										  <tr>
											<td width="14%"><strong>Carrera</strong></td>
											<td width="2%"><strong>:</strong></td>
											<td colspan="4" width="84%"><%f_busqueda.DibujaCampoLista "busqueda", "carr_ccod"%></td>
										  </tr>
										  <tr>
											<td width="14%"><strong>Rut Alumno</strong></td>
											<td width="2%"><strong>:</strong></td>
											<td colspan="3" width="54%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
															<%f_busqueda.DibujaCampo("pers_nrut") %>
															- 
															<%f_busqueda.DibujaCampo("pers_xdv")%>
															</font><a href="javascript:buscar_persona('b[0][pers_nrut]', 'b[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
											<td width="30%"><%f_botonera.DibujaBoton "buscar"%></td>
										  </tr>
                      					</table>
									</div>
									</td>
                                </tr>
                               </table>
                            </form>
					 </td>
                 </tr>
               </table>
			 </td>
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
        <td>
		 	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
			  </tr>
			  <tr>
				<td height="2" background="../imagenes/top_r3_c2.gif"></td>
			  </tr>
          	  <tr>
                <td align="center">
				 <br>
                 <%pagina.DibujarTituloPagina%><br>
                 <br>
			     <table width="98%"  border="0">
                 <tr>
                  <td width="100%" align="left">
                  	<table width="98%" cellpadding="0" cellspacing="0">
                    	<%if q_pers_nrut <> "" then%>
                        <tr>
                        	<td width="10%" align="left"><strong>RUT</strong></td>
                            <td width="1%" align="center"><strong>:</strong></td>
                            <td align="left"><%=f_encabezado.obtenerValor("rut")%></td>
                        </tr>
                        <tr>
                        	<td width="10%" align="left"><strong>Alumno</strong></td>
                            <td width="1%" align="center"><strong>:</strong></td>
                            <td align="left"><%=f_encabezado.obtenerValor("alumno")%></td>
                        </tr>
                        <tr>
                        	<td width="10%" align="left"><strong>Carrera</strong></td>
                            <td width="1%" align="center"><strong>:</strong></td>
                            <td align="left"><%=carr_tdesc%></td>
                        </tr>
						
						<%end if%>
						<tr><td colspan="3" align="center"><span id="txt"><font color="#993300"><%=msj_encasillado%></font></span></td></tr>
                        <tr><td colspan="3">&nbsp;</td></tr>
                        <td><td colspan="3" align="center"><%=mensaje_html%></td></td>
                    </table>
                  </td>
                </tr>
              </table>
			 
              <form name="edicion" method="get">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				 <%if en_carrera ="S" then %>
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Listado de Salidas ofrecidas por la carrera"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col"><div align="right">P&aacute;ginas : <%f_titulados.AccesoPagina%></div></td>
                        </tr>
                        <tr>
                          <td align="center">
                          		<table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
                                	<tr borderColor="#999999" bgColor="#c4d7ff">
                                    	<TH><FONT color="#333333">Tipo</FONT></TH>
                                        <TH><FONT color="#333333">Salida</FONT></TH>
                                        <TH><FONT color="#333333">Folio Nº/Reg.Nº</FONT></TH>
                                        <TH><FONT color="#333333">Fecha</FONT></TH>
                                        <TH><FONT color="#333333">Nota</FONT></TH>
                                        <TH><FONT color="#333333">Acción</FONT></TH>
                                    </tr>
                                    <%if total_salidas > 0 then
									    f_titulados.primero
										while f_titulados.siguiente 
										tipo = f_titulados.obtenerValor("tsca_tdesc")
										salida = f_titulados.obtenerValor("salida")
										folio = f_titulados.obtenerValor("folio_reg")
										fecha_salida = f_titulados.obtenerValor("asca_fsalida")
										nota = f_titulados.obtenerValor("asca_nnota")
										pers_ncorr = f_titulados.obtenerValor("pers_ncorr")
										saca_ncorr = f_titulados.obtenerValor("saca_ncorr")
										asig = f_titulados.obtenerValor("total_asignaturas_requeridas")
										tsca_ccod = f_titulados.obtenerValor("tsca_ccod")
										%>
                                        <tr bgColor="#ffffff">
                                            <td onmouseover="resaltar(this);" onmouseout="desResaltar(this);"><%=tipo%></td>
                                            <td onmouseover="resaltar(this);" onmouseout="desResaltar(this);"><%=salida%></td>
                                            <td onmouseover="resaltar(this);" onmouseout="desResaltar(this);"><%=folio%></td>
                                            <td onmouseover="resaltar(this);" onmouseout="desResaltar(this);"><%=fecha_salida%></td>
                                            <td onmouseover="resaltar(this);" onmouseout="desResaltar(this);" align="center"><%=nota%></td>
                                            <td onmouseover="resaltar(this);" onmouseout="desResaltar(this);">
                                            	<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#FFFFFF">
                                                	<tr>
                                                    	<td width="25%" align="center">
                                                           <a href="javascript:irA('adm_salidas_alumnos_agregar.asp?saca_ncorr=<%=saca_ncorr%>&pers_ncorr=<%=pers_ncorr%>', '1', 750, 400);" title="Agregar/Editar salida a alumno">
                                                           	<img width="16" height="16" src="../imagenes/editar.png" border="0">
                                                           </a>
                                                        </td>
                                                        <td width="25%" align="center">
                                                           <%if folio <> "" then%>
                                                           		<a href="javascript:eliminar(<%=saca_ncorr%>,<%=pers_ncorr%>);" title="Eliminar salida del alumno">
                                                                	<img width="16" height="16" src="../imagenes/eliminar.png" border="0">
                                                                </a>
                                                           <%end if%>
                                                        </td>
                                                        <td width="25%" align="center">
                                                          <%if asig > "0" then%>
                                                           <a href="javascript:irA('cumplimiento_asignaturas_salida_carrera.asp?saca_ncorr=<%=saca_ncorr%>&pers_ncorr=<%=pers_ncorr%>', '1', 750, 400);" title="Ver cumplimiento de requisitos de asignaturas">
                                                           	<img width="16" height="16" src="../imagenes/asignaturas.png" border="0">
														   </a>
                                                          <%end if%>
                                                        </td>
                                                        <td width="25%" align="center">
                                                           <%if folio <> "" then
														        if tsca_ccod = "1" or tsca_ccod="2" or tsca_ccod="6" then %>
                                                           		<a href="javascript:irA('certificado_titulo.asp?saca_ncorr=<%=saca_ncorr%>&pers_ncorr=<%=pers_ncorr%>', '1', 750, 550);" title="Imprimir certificado de salida">
                                                           	      <img width="16" height="16" src="../imagenes/imprimir.png" border="0">
																</a>
																<%else%>
																<a href="javascript:irA('certificado_grado.asp?saca_ncorr=<%=saca_ncorr%>&pers_ncorr=<%=pers_ncorr%>', '1', 750, 550);" title="Imprimir certificado de salida">
                                                           	      <img width="16" height="16" src="../imagenes/imprimir.png" border="0">
																</a>
																<%end if%>
                                                           <%end if%>     
                                                        </td>
                                                </table>
                                            </td>
                                        </tr>
                                    <%  wend
									 else%>
                                    <tr bgColor="#ffffff">
                                    	<td colspan="6" align="center">No existen salidas asociadas a la carrera y alumno indicado</td>
                                    </tr>
                                    <%end if%>
                                 </table>
                          </td>
                        </tr>
                        <tr>
                          <td align="right"><font color="#0033FF">Para asignar el alumno a la salida, haga clic sobre ella</font></td>
                        </tr>
                      </table></td>
                  </tr>
				  <input type="hidden" name="pers_ncorr" value="<%=pers_ncorr%>">
				  <input type="hidden" name="carr_ccod" value="<%=q_carr_ccod%>">
				  <%end if%>
                </table>
            </form>
			</td>
		 </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
	  <%if tiene_titulo_ajuste ="NO" or tiene_salidas = "SI" or tiene_egreso_ajuste ="NO" then %>
	  <tr valign="bottom">
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td height="28" align="center"><font color="#CC6600">Debe eliminar todas las salidas profesionales antes de eliminar las matrículas</font></td>
	    <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
	  <%end if%>
	  <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera_g.DibujaBoton "salir"%></div></td>
				  <td><div align="center"><% if tiene_titulo_ajuste ="NO" or tiene_salidas = "SI" then
				                                f_botonera.agregaBotonParam "eliminar_matr_titulado","deshabilitado","true"
											 end if      
				                             f_botonera.DibujaBoton "eliminar_matr_titulado"%>
					  </div>
				  </td>
				  <td><div align="center"><% if tiene_egreso_ajuste ="NO" or tiene_salidas="SI" then
				                                f_botonera.agregaBotonParam "eliminar_matr_egresado","deshabilitado","true"
											 end if      
				                             f_botonera.DibujaBoton "eliminar_matr_egresado"%>
					  </div>
				  </td>
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
