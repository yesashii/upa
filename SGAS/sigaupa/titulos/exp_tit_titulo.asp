<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
saca_ncorr  = Request.QueryString("saca_ncorr")
pers_ncorr  = Request.QueryString("pers_ncorr")
q_ctes_ncorr  = Request.QueryString("ctes_ncorr")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Datos de Títulos y Grados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------
set f_salida = new CFormulario
f_salida.Carga_Parametros "expediente_titulacion.xml", "salida"
f_salida.Inicializar conexion

SQL = " select b.pers_ncorr,a.saca_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_nrut, b.pers_xdv,  "& vbCrLf &_
      " b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as alumno, "& vbCrLf &_
	  " a.saca_tdesc as salida, c.tsca_ccod,case c.tsca_ccod when 1 then '<font color=#073299><strong>' "& vbCrLf &_ 
      "            when 2 then '<font color=#004000><strong>' "& vbCrLf &_ 
  	  " 		   when 3 then '<font color=#b76d05><strong>' "& vbCrLf &_ 
	  "			   when 4 then '<font color=#714e9c><strong>' "& vbCrLf &_ 
	  " 		   when 5 then '<font color=#ab2b05><strong>' "& vbCrLf &_ 
	  "  		   when 6 then '<font color=#0078c0><strong>' end + c.tsca_tdesc + '</strong></font>' as tipo_salida, d.carr_ccod, d.carr_tdesc, "& vbCrLf &_
      "    (select top 1 sede_ccod from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as sede_ccod, "& vbCrLf &_
      "    (select top 1 sede_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN sedes t4 "& vbCrLf &_
      "            ON t2.sede_ccod = t4.sede_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as sede_tdesc, "& vbCrLf &_
      "    (select top 1 jorn_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN jornadas t4 "& vbCrLf &_
      "            ON t2.jorn_ccod = t4.jorn_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as jorn_tdesc, "& vbCrLf &_
      "    (select top 1 peri_ccod from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
      "            order by t2.peri_ccod desc) as peri_ccod, "& vbCrLf &_
      "    (select top 1 peri_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN periodos_academicos t4 "& vbCrLf &_
      "            ON t2.peri_ccod = t4.peri_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
      "            order by t2.peri_ccod desc) as peri_tdesc, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4)) as egresado, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (8)) as titulado, "& vbCrLf &_
      "    (select top 1 t1.plan_ccod  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (8) order by peri_ccod desc) as plan_ccod, "& vbCrLf &_
      " asca_ncorr, protic.trunc(asca_fsalida) as asca_fsalida, asca_nfolio, asca_nregistro, replace(cast(asca_nnota as decimal(2,1)),',','.') as asca_nnota, ' '  as asca_bingr_manual, "& vbCrLf &_
      "    (select max(peri_ccod) "& vbCrLf &_
      "			from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "			ON t1.pers_ncorr = b.pers_ncorr "& vbCrLf &_
      "			INNER JOIN especialidades t3 "& vbCrLf &_
      "			ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "			WHERE t2.espe_ccod = t3.espe_ccod and t3.carr_ccod = d.carr_ccod and isnull(t1.emat_ccod,0) <> 9) as ultimo_periodo "& vbCrLf &_
      " from salidas_carrera a INNER JOIN personas b "& vbCrLf &_
      " ON cast(b.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(a.saca_ncorr as varchar)='"&saca_ncorr&"' "& vbCrLf &_
      " INNER JOIN tipos_salidas_carrera c "& vbCrLf &_
      " ON a.tsca_ccod = c.tsca_ccod "& vbCrLf &_
      " INNER JOIN carreras d "& vbCrLf &_
      " ON a.carr_ccod = d.carr_ccod "& vbCrLf &_
      " LEFT OUTER JOIN alumnos_salidas_carrera e "& vbCrLf &_
      " ON a.saca_ncorr = e.saca_ncorr and b.pers_ncorr = e.pers_ncorr" 

f_salida.Consultar SQL
'response.Write("<pre>"&SQL&"</pre>")
f_salida.Siguiente
plan_ccod = f_salida.obtenerValor("plan_ccod")
egresado  = f_salida.obtenerValor("egresado")
titulado  = f_salida.obtenerValor("titulado")
carr_ccod = f_salida.obtenerValor("carr_ccod")
tsca_ccod = f_salida.obtenerValor("tsca_ccod")
asca_ncorr = f_salida.obtenerValor("asca_ncorr")
asca_nregistro = f_salida.obtenerValor("asca_nregistro")
ultimo_periodo = f_salida.obtenerValor("ultimo_periodo")
carr_ccod_informar = carr_ccod
if titulado = "N" and not EsVacio(ultimo_periodo) then
 c_detalle_ultima_matricula = " Select top 1 'El alumno no se encuentra titulado en la carrera seleccionada, su última matrícula corresponde a la especialidad: <strong>'+lower(c.espe_tdesc)+' - '+lower(d.plan_tdesc)+'</strong>, con el estado de matrícula '+e.emat_tdesc "&_
                               " from alumnos a, ofertas_academicas b, especialidades c, planes_estudio d, estados_matriculas e "&_
							   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=d.plan_ccod and a.emat_ccod=e.emat_ccod "&_
							   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"' and c.carr_ccod='"&carr_ccod&"' and isnull(a.emat_ccod,0) <> 9 order by peri_ccod desc "
 detalle_ultima_matricula =  conexion.consultaUno(c_detalle_ultima_matricula)
 c_plan_ccod = " select top 1 a.plan_ccod "&_
               " from alumnos a, ofertas_academicas b, especialidades c, planes_estudio d, estados_matriculas e "&_
			   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=d.plan_ccod and a.emat_ccod=e.emat_ccod "&_
			   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"' and c.carr_ccod='"&carr_ccod&"' and isnull(a.emat_ccod,0) <> 9 order by peri_ccod desc "
 plan_ccod = conexion.consultaUno(c_plan_ccod)
end if
q_plan_ccod  = plan_ccod
q_peri_ccod  = ultimo_periodo
q_pers_nrut  = f_salida.obtenerValor("pers_nrut")
q_pers_xdv   = f_salida.obtenerValor("pers_xdv")

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "expediente_titulacion.xml", "botonera_de"

'---------------------------------------------------------------------------------------------------
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "expediente_titulacion.xml", "encabezado_de"
f_titulado.Inicializar conexion

v_sede_ccod = conexion.consultaUno("select top 1 sede_ccod from personas a, alumnos b, ofertas_academicas c where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' and a.pers_ncorr=b.pers_ncorr and cast(b.plan_Ccod as varchar)='"&q_plan_ccod&"' and b.ofer_ncorr=c.ofer_ncorr order by peri_ccod desc")


SQL = " select f.sede_ccod, a.pers_ncorr, b.plan_ccod, c.espe_ccod, e.peri_ccod, d.carr_tdesc, c.espe_tdesc, e.peri_tdesc, f.sede_tdesc, plan_tdesc as plan_ncorrelativo, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre"
SQL = SQL &  " from personas a, planes_estudio b, especialidades c, carreras d, periodos_academicos e, sedes f"
SQL = SQL &  " where b.espe_ccod = c.espe_ccod"
SQL = SQL &  "   and c.carr_ccod = d.carr_ccod"
SQL = SQL &  "   and cast(f.sede_ccod as varchar)= '" & v_sede_ccod & "'"
SQL = SQL &  "   and cast(e.peri_ccod as varchar)= '" & q_peri_ccod & "'"
SQL = SQL &  "   and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "'"
SQL = SQL &  "   and cast(b.plan_ccod as varchar)= '" & q_plan_ccod & "'"

f_titulado.Consultar SQL
f_titulado.SiguienteF
v_sede_ccod = f_titulado.obtenerValor ("sede_ccod")

q_pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

tsca_ccod = conexion.consultaUno("select tsca_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
if tsca_ccod <> "4" then 
	tiene_grabado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion_carrera where cast(plan_ccod as varchar)='"&q_plan_ccod&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and carr_ccod='"&carr_ccod&"'")
	plan_consulta = q_plan_ccod
else
	tiene_grabado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion_carrera where cast(plan_ccod as varchar)='"&saca_ncorr&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"'")
	plan_consulta = saca_ncorr
end if	

if q_ctes_ncorr <> "" then
	 consulta_comision = " select '"&q_peri_ccod&"' as peri_ccod,ctes_ncorr, pers_nrut,pers_xdv, a.pers_ncorr, a.plan_ccod, docente, "&_
				" replace(calificacion_asignada,',','.') as calificacion_asignada " &_
				" from comision_tesis a, personas b "&_
				" where a.pers_ncorr=b.pers_ncorr "&_
				" and cast(a.ctes_ncorr as varchar)='"&q_ctes_ncorr&"'"
else
     consulta_comision = " select '"&plan_consulta&"' as plan_ccod, '"&q_pers_ncorr&"' as pers_ncorr"
end if

set f_comision = new CFormulario
f_comision.Carga_Parametros "expediente_titulacion.xml", "comision_tesis"
f_comision.Inicializar conexion

consulta_lista_comision = " select '"&q_peri_ccod&"' as peri_ccod,ctes_ncorr, pers_nrut,pers_xdv, a.pers_ncorr, a.plan_ccod, docente,'"&saca_ncorr&"' as saca_ncorr, "&_
				" replace(isnull(calificacion_asignada,1.0),',','.') as calificacion_asignada, cast(isnull(calificacion_asignada,1.0) as decimal(2,1)) as nota " &_
				" from comision_tesis a, personas b "&_
				" where a.pers_ncorr=b.pers_ncorr "&_
				" and cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(a.plan_ccod as varchar)='"&plan_consulta&"' "			

f_comision.Consultar consulta_comision
f_comision.Siguiente

'-----------------------para mostrar listado de docentes de la comisión evaluadora

set f_lista_comision = new CFormulario
f_lista_comision.Carga_Parametros "expediente_titulacion.xml", "lista_comision_tesis"
f_lista_comision.Inicializar conexion

f_lista_comision.Consultar consulta_lista_comision

contador_total = 0
nota_promedio =  cdbl("0,0")

while f_lista_comision.siguiente
  nota_promedio = cdbl(nota_promedio) + cdbl(f_lista_comision.obtenerValor("nota"))
  contador_total= contador_total + 1
wend
f_lista_comision.primero

'response.End()
if contador_total <> 0 then
	promedio_tesis = formatnumber((cdbl(nota_promedio) / cdbl(contador_total)),1,-1,0,0)
else
	promedio_tesis = 1.0
end if		

promedio_tesis = conexion.consultaUno("select replace('"&promedio_tesis&"',',','.')")

'response.Write("promedio tesis "&promedio_tesis)
'----------------------datos adicionales tesis
if tiene_grabado = "S" then
	 consulta_tesis = " select pers_ncorr,plan_ccod,tema_tesis,"&_
				" protic.trunc(inicio_tesis) as inicio_tesis,protic.trunc(fecha_ceremonia) as fecha_ceremonia,id_ceremonia,protic.trunc(termino_tesis) as termino_tesis, "&_
			    " replace(calificacion_tesis,',','.') as calificacion_tesis,protic.trunc(fecha_titulacion) as fecha_titulacion "&_
				" from detalles_titulacion_carrera a "&_
				" where cast(plan_ccod as varchar)='"&plan_consulta&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and carr_ccod='"&carr_ccod&"'"
else
     consulta_tesis = " select '"&plan_consulta&"' as plan_ccod, '"&q_pers_ncorr&"' as pers_ncorr"
end if
'response.Write(consulta_tesis)
set f_tesis = new CFormulario
f_tesis.Carga_Parametros "expediente_titulacion.xml", "datos_tesis"
f_tesis.Inicializar conexion

consulta_fecha =  " select protic.trunc(b.asca_fsalida) from salidas_carrera a, alumnos_salidas_carrera b " &_
			      " where cast(a.plan_ccod as varchar)='"&plan_consulta&"'  and a.carr_ccod='"&carr_ccod&"' and a.saca_ncorr=b.saca_ncorr "&_
		          " and cast(b.pers_ncorr as varchar)='"&q_pers_ncorr&"' and a.tsca_ccod in (1,4)"

fecha_examen = conexion.consultaUno(consulta_fecha)

f_tesis.Consultar consulta_tesis
if fecha_examen <> "" then
	f_tesis.agregaCampoCons "fecha_titulacion",fecha_examen
end if
f_tesis.Siguiente
'response.Write(promedio_tesis)
'---------------------------------------------------------------------------------------------------
f_botonera.AgregaBotonUrlParam "siguiente", "plan_ccod", plan_consulta
f_botonera.AgregaBotonUrlParam "siguiente", "peri_ccod", q_peri_ccod

f_botonera.AgregaBotonUrlParam "guardar_nuevo", "plan_ccod", plan_consulta
f_botonera.AgregaBotonUrlParam "guardar_nuevo", "peri_ccod", q_peri_ccod

'---------------------------------------------------------------------------------------------------
url_leng_0 = "exp_tit_mensajes.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_1 = "exp_tit_datos_personales.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_2 = "exp_tit_doctos_entregados.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_3 = "exp_tit_historico_notas.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_4 = "exp_tit_practica.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_5 = "exp_tit_egreso.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_6 = "exp_tit_salida.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_7 = "exp_tit_titulo.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_8 = "exp_tit_concentracion.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr

'---------------------------------------------------------------------------------------------------

se_titulo = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from salidas_alumnos a, salidas_plan b where a.sapl_ncorr = b.sapl_ncorr and cast(b.plan_ccod as varchar)='"&plan_consulta&"' and cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"'")
if tsca_ccod = "4" then
	titulo_salida_intermedia = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from alumnos_salidas_intermedias where cast(saca_ncorr as varchar) = '"&saca_ncorr&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and emat_ccod=8 ")
else
	titulo_salida_intermedia = "0"
end if	
'response.End()
mensaje_faltante = ""
if egresado  = "N" and titulado  = "N" and titulo_salida_intermedia = "0" then
	mensaje_faltante = "<center>"&_
				       "    <table border='1'  bordercolor='#CC6600' cellspacing='2' cellpadding='5' align='center'> "&_
					   "      <tr> "&_
					   "         <td align='center' bgcolor='#FFCC66'>El alumno no presenta matrículas en estado de egresado o titulado para la carrera seleccionada, se requiere de dichas matrículas para ingresar esta información.</td> "&_
					   "      </tr> "&_
					   "    </table> "&_
					   "</center>"
end if

carr_param = conexion.consultaUno("select carr_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
permiso_escuela = conexion.consultaUno("select isnull((select isnull(peca_dat_personal,'0') from permisos_evt_carrera where carr_ccod='"&carr_param&"'),'0')")

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
function certificado_titulo(){
   var formulario=document.edicion
   var peri=<%=q_peri_ccod%>;
   var plan=<%=q_plan_ccod%>;
   var rut=<%=q_pers_nrut%>;
   var sede=<%=v_sede_ccod%>;
   self.open('certificado_titulo.asp?peri_ccod='+ peri+'&plan_ccod='+plan+'&pers_nrut='+rut+'&sede_ccod='+sede,'certificado','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function calcular()
{
	var notas = document.concentracion.elements["concentracion[0][calificacion_notas]"].value;
	var practica = document.concentracion.elements["concentracion[0][calificacion_practica]"].value;
	var tesis = document.concentracion.elements["concentracion[0][calificacion_tesis]"].value;
	var nota_tesis = document.concentracion.elements["concentracion[0][nota_tesis]"].value;
	var porc_notas = document.concentracion.elements["concentracion[0][porcentaje_notas]"].value;
	var porc_practica = document.concentracion.elements["concentracion[0][porcentaje_practica]"].value;
	var porc_tesis = document.concentracion.elements["concentracion[0][porcentaje_tesis]"].value;
	var porc_nota_tesis = document.concentracion.elements["concentracion[0][porcentaje_nota_tesis]"].value;
	var valor1=0.0;
	var valor2=0.0;
	var valor3=0.0;
	var valor4=0.0;
	var suma = (porc_notas * 1) + (porc_practica * 1) + (porc_tesis * 1) + (porc_nota_tesis * 1);
	//alert(suma);
	var promedio_final=0.0;
	if (suma == 100 )
	 { valor1 = notas * ( porc_notas / 100 );
	   valor2 = practica * ( porc_practica / 100 );
	   valor3 = tesis * ( porc_tesis / 100 );
	   valor4 = nota_tesis * ( porc_nota_tesis / 100 );
	   promedio_final = valor1 + valor2 + valor3 + valor4;
	   promedio_final2 = promedio_final;
	   promedio_final2 = roundFun(promedio_final,10);//se rempleaza 10 por 2
	   promedio_final2 = roundFun(promedio_final2,1);
	   //alert("promedio " + promedio_final);
	   document.concentracion.elements["promedio_final"].value=promedio_final2;
	   document.concentracion.elements["promedio_final"].value=document.concentracion.elements["promedio_final"].value.substring(0,3);
	   document.concentracion.elements["concentracion[0][promedio_final]"].value=promedio_final2;
	   document.concentracion.elements["concentracion[0][promedio_final]"].value=document.concentracion.elements["concentracion[0][promedio_final]"].value.substring(0,3);
	   if (confirm("¿Está Seguro que desea grabar los datos para la concentracón de notas?"))
	   {
	   		return true;
	   }
	   else
	   {
	  	 	return false;
	   }
	 }
	 else
	 {
	 	alert("El porcentaje ingresado no corresponde al 100% necesario para cálculos de promedio final");
	 }  
	//alert("promedio " + promedio_final);
	return false;
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
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
            <td><%pagina.DibujarLenguetasFClaro Array(Array("Mensajes", url_leng_0), Array("Datos Pers.", url_leng_1), Array("Docs Alumno", url_leng_2),Array("Hist. Notas", url_leng_3), Array("Práctica prof.", url_leng_4), Array("Datos Egreso", url_leng_5),Array("Reg. Salida", url_leng_6), Array("Tesis y comisión", url_leng_7), Array("Conc. Notas", url_leng_8)),8%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_titulado.DibujaRegistro%></div></td>
                        </tr>
                      </table>
					</td>
                  </tr>
				  <tr> 
                       <td><div align="center"><%=mensaje_html%></div></td>
                  </tr>
				  <%if mensaje_faltante = "" then %>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Comisión Tesis de estudios."%>
                      <br>
					  <form name="comision">
                      <table width="98%"  border="1" align="center">
                        <tr>
                          <td align="center">
						  		<table border="0" width="98%">
								<tr>
								    		<td width="14%" align="left"><strong>Profesor</strong><input type="hidden" name="comision[0][pers_ncorr]" value="<%=q_pers_ncorr%>"></td>
											<td width="1%" align="left"><strong>:</strong></td>
											<td width="35%" align="left"><%f_comision.dibujaCampo("docente")%></td>
											<td width="14%" align="left"><strong>Calificación</strong><input type="hidden" name="comision[0][plan_ccod]" value="<%=plan_consulta%>"></td>
											<td width="1%" align="left"><strong>:</strong></td>
											<td width="25%" align="left"><%f_comision.dibujaCampo("calificacion_asignada")%><input type="hidden" name="comision[0][ctes_ncorr]" value="<%=q_ctes_ncorr%>"></td>
											<td width="10%" align="center"><%if permiso_escuela = "0" then
																				f_botonera.AgregaBotonParam "agregar_docente" , "deshabilitado" , "true"
																			 end if
											                                 f_botonera.DibujaBoton "agregar_docente"%><input type="hidden" name="comision[0][peri_ccod]" value="<%=q_peri_ccod%>"></td>
     							</tr>
							    </table>
						  </td>
                        </tr>
                      </table>
					  </form>
					</td>
                  </tr>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos de Tesis."%>
                      <br>
					  <form name="tesis">
					  <input type="hidden" name="saca_ncorr" value="<%=saca_ncorr%>">
                      <table width="98%"  border="1" align="center">
                        <tr>
                          <td align="center">
						  		<table border="0" width="98%">
								<tr>
								    <td width="14%" align="left"><strong>Tema Tesis</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td colspan="5" align="left"><%f_tesis.dibujaCampo("tema_tesis")%></td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Inicio</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left"><%f_tesis.dibujaCampo("inicio_tesis")%><input type="hidden" name="tesis[0][pers_ncorr]" value="<%=q_pers_ncorr%>"></td>
									<td width="14%" align="left"><strong>Término</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td colspan="2" align="left"><%f_tesis.dibujaCampo("termino_tesis")%><input type="hidden" name="tesis[0][plan_ccod]" value="<%=plan_consulta%>"></td>
								</tr>
								<tr>
								    <td width="14%" align="left"><strong>Fecha Ceremonia</strong></td>
									<td width="1%" align="left"><strong>:</strong></td>
									<td width="35%" align="left" colspan="4"><%f_tesis.dibujaCampo("id_ceremonia")%></td>
								</tr>
								<tr>
								    <td colspan="7" align="left"><strong>Docentes Comisión Evaluadora</strong></td>
    							</tr>
								<tr>
								    <td colspan="7" align="center"><%f_lista_comision.dibujaTabla()%></td>
    							</tr>
								<tr>
								    <td colspan="2">&nbsp;</td>
									<td colspan="3" align="center"><strong>Promedio Tesis : <%=promedio_tesis%> </strong><input type="hidden" name="tesis[0][calificacion_tesis]" value="<%=promedio_tesis%>" maxlength="3"></td>
    							    <td  colspan="2">&nbsp;</td>
								</tr>
								<tr>
								    <td colspan="7" align="center" bgcolor="#666666"><strong><font color="#FF0000">*</font><font color="#FFFFFF"> Fecha Examen de Títulos <%f_tesis.dibujaCampo("fecha_titulacion")%></font></strong></td>
    							</tr>
								<tr>
								    <td colspan="7" align="right"><%if permiso_escuela = "0" then
																		f_botonera.AgregaBotonParam "guardar_tesis" , "deshabilitado" , "true"
																	end if
									                                f_botonera.DibujaBoton "guardar_tesis"%></td>
    							</tr>
								<tr>
								   <td colspan="7">&nbsp;</td>
							    </tr>
								<% if permiso_escuela = "0" then%>
								  <tr>
									<td  colspan="7" align="center"><font color="#8A0808">LA  ESCUELA NO POSEE PERMISOS DE INGRESO O EDICIÓN DE DATOS</font></td>
								  </tr>
								<%end if%>
							    <tr>
								  <td colspan="7" >&nbsp;</td>
							    </tr>
								</table>
						  </td>
                        </tr>
                      </table>
					  </form>
					</td>
                  </tr>
				  <%else%>
				  <tr><td align="center" height="200"><%=mensaje_faltante%></td></tr>
				  <%end if%>
				  
                </table>
           </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td><div align="center"><%'f_botonera.DibujaBoton "guardar_nuevo"%></div></td>
                  <td><div align="center"><%'f_botonera.DibujaBoton "aceptar"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
				  <td><div align="center"><%'f_botonera.DibujaBoton "certificado_titulo"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
