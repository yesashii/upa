<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: CERTIFICADOS Y NOTAS 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 28/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=
'LINEA				          : 47, 80, 134
'********************************************************************
rut       		= 	request.QueryString("busqueda[0][pers_nrut]")
dv		  		= 	request.QueryString("busqueda[0][pers_xdv]")
plan_ccod		= 	request.querystring("ch[0][plan_ccod]")
ocultar         =   request.QueryString("ocultar")
	
set pagina = new CPagina
pagina.Titulo = "Historico de Notas y Equivalencias"

set botonera = new CFormulario
botonera.Carga_Parametros "historico.xml", "botonera"

set combo_b		= 	new cformulario
set negocio		=	new cnegocio
set conectar	=	new cconexion
set historico	=	new cHistoricoNotas

conectar.inicializar		"upacifico"
negocio.inicializa 			conectar

pers_ncorr	=	conectar.consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar) ='"& rut &"'")
if plan_ccod="" then
peri_ccod_temporal=negocio.obtenerPeriodoAcademico("POSTULACION")

'consulta_actual_plan=" select  distinct cast(f.espe_ccod as varchar)+ '-' + cast(f.plan_ccod as varchar)+ '-' + cast(d.carr_ccod as varchar) as parametro " & vbcrlf &_
'						 "	from personas a, alumnos b,ofertas_academicas c,especialidades d,carreras e,planes_estudio f,cargas_Academicas g" & vbcrlf &_
'						 " where cast(pers_nrut as varchar)='"&rut&"'" & vbcrlf &_
'						 " and a.pers_ncorr=b.pers_ncorr" & vbcrlf &_
'						 " and b.ofer_ncorr=c.ofer_ncorr" & vbcrlf &_
'						 " and b.matr_ncorr *= g.matr_ncorr" & vbcrlf &_
'						 " and c.espe_ccod=d.espe_ccod" & vbcrlf &_
'						 " and d.carr_ccod=e.carr_ccod" & vbcrlf &_
'						 " and cast(c.peri_ccod as varchar)='"&peri_ccod_temporal&"'" & vbcrlf &_
'					 	 "and b.plan_ccod=f.plan_ccod "
					 	 
'----------------------------------------------------------------------------------------------------------Nueva consulta 2008
consulta_actual_plan = "select distinct cast(f.espe_ccod as varchar) + '-'     " & vbCrLf &_
"                + cast(f.plan_ccod as varchar) + '-'                          " & vbCrLf &_
"                + cast(d.carr_ccod as varchar) as parametro                   " & vbCrLf &_
"from   personas as a                                                          " & vbCrLf &_
"       inner join alumnos as b                                                " & vbCrLf &_
"               on a.pers_ncorr = b.pers_ncorr                                 " & vbCrLf &_
"       inner join ofertas_academicas as c                                     " & vbCrLf &_
"               on b.ofer_ncorr = c.ofer_ncorr                                 " & vbCrLf &_
"                  and cast(c.peri_ccod as varchar) = '"&peri_ccod_temporal&"' " & vbCrLf &_
"       left outer join cargas_academicas as g                                 " & vbCrLf &_
"                    on b.matr_ncorr = g.matr_ncorr                            " & vbCrLf &_
"       inner join especialidades as d                                         " & vbCrLf &_
"               on c.espe_ccod = d.espe_ccod                                   " & vbCrLf &_
"       inner join carreras as e                                               " & vbCrLf &_
"               on d.carr_ccod = e.carr_ccod                                   " & vbCrLf &_
"       inner join planes_estudio as f                                         " & vbCrLf &_
"               on b.plan_ccod = f.plan_ccod                                   " & vbCrLf &_
"where  cast(pers_nrut as varchar) = '"&rut&"'                                 " 
'------------------------------------------------------------------------------------------------------fin_Nueva consulta 2008					 	 

plan_ccod = conectar.consultaUno(consulta_actual_plan) 
if esVacio(plan_ccod) then
'	consulta_actual_plan="  select  distinct cast(f.espe_ccod as varchar)+ '-' + cast(f.plan_ccod as varchar)+ '-' + cast(d.carr_ccod as varchar) as parametro " & vbcrlf &_
'						 "	from personas a, alumnos b,ofertas_academicas c,especialidades d,carreras e,planes_estudio f,cargas_academicas g" & vbcrlf &_
'						 " where cast(pers_nrut as varchar)='"&rut&"'" & vbcrlf &_
'						 " and a.pers_ncorr=b.pers_ncorr" & vbcrlf &_
'						 " and b.ofer_ncorr=c.ofer_ncorr" & vbcrlf &_
'						 " and b.matr_ncorr *= g.matr_ncorr" & vbcrlf &_
'						 " and c.espe_ccod=d.espe_ccod" & vbcrlf &_
'						 " and d.carr_ccod=e.carr_ccod" & vbcrlf &_
'					 	 "and b.plan_ccod=f.plan_ccod "
					 	 
'----------------------------------------------------------------------------------------------------------Nueva consulta 2008
consulta_actual_plan = " select distinct cast(f.espe_ccod as varchar) + '-' " & vbCrLf &_
"                + cast(f.plan_ccod as varchar) + '-'                       " & vbCrLf &_
"                + cast(d.carr_ccod as varchar) as parametro                " & vbCrLf &_
"from   personas as a                                                       " & vbCrLf &_
"       inner join alumnos as b                                             " & vbCrLf &_
"               on a.pers_ncorr = b.pers_ncorr                              " & vbCrLf &_
"       left outer join cargas_academicas as g                              " & vbCrLf &_
"                    on b.matr_ncorr = g.matr_ncorr                         " & vbCrLf &_
"       inner join planes_estudio as f                                      " & vbCrLf &_
"               on b.plan_ccod = f.plan_ccod                                " & vbCrLf &_
"       inner join ofertas_academicas as c                                  " & vbCrLf &_
"               on b.ofer_ncorr = c.ofer_ncorr                              " & vbCrLf &_
"       inner join especialidades as d                                      " & vbCrLf &_
"               on c.espe_ccod = d.espe_ccod                                " & vbCrLf &_
"       inner join carreras as e                                            " & vbCrLf &_
"               on d.carr_ccod = e.carr_ccod                                " & vbCrLf &_
"where  cast(pers_nrut as varchar) = '"&rut&"'                              " 
'------------------------------------------------------------------------------------------------------fin_Nueva consulta 2008					 	 
					 
plan_ccod = conectar.consultaUno(consulta_actual_plan) 
end if					 
end if 
'response.Write("<pre>"&consulta_actual_plan&"</pre>")
'-------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "historico.xml", "busqueda"
f_busqueda.Inicializar conectar

f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", rut
f_busqueda.AgregaCampoCons "pers_xdv", dv
'------------------------------------------------------------------------------------------


combo_b.inicializar			conectar
combo_b.carga_parametros	"historico.xml","combo"

combo_b.consultar			"select '' as salida, '' as parametro"

'combo_b.agregacampoparam	"plan_ccod","destino","(select  distinct a.pers_nrut,e.carr_ccod, " & vbcrlf &_
'							"                       cast(f.espe_ccod as varchar)+ '-' + e.carr_tdesc + '-' + d.espe_tdesc +'-'+ cast(f.plan_tdesc as varchar) AS salida,    " & vbcrlf &_
'							"						cast(f.espe_ccod as varchar)+ '-' + cast(f.plan_ccod as varchar)+ '-' + cast(e.carr_ccod as varchar) as parametro " & vbcrlf &_
'							"						from personas a, alumnos b,ofertas_academicas c,especialidades d,carreras e,planes_estudio f,cargas_academicas g " & vbcrlf &_
'							"                       where cast(pers_nrut as varchar)='"&rut&"' " & vbcrlf &_
'							"						and a.pers_ncorr=b.pers_ncorr" & vbcrlf &_
'							"						and b.ofer_ncorr=c.ofer_ncorr" & vbcrlf &_
'    						"						and b.matr_ncorr *= g.matr_ncorr" & vbcrlf &_
'							"						and c.espe_ccod=d.espe_ccod" & vbcrlf &_
'							"						and d.carr_ccod=e.carr_ccod" & vbcrlf &_
'							"						and b.plan_ccod=f.plan_ccod) a"
							
'----------------------------------------------------------------------------------------------------------Nueva consulta 2008
combo_b.agregacampoparam "plan_ccod","destino","(            " & vbCrLf &_
"select distinct a.pers_nrut,                                 " & vbCrLf &_
"                e.carr_ccod,                                 " & vbCrLf &_
"                cast(f.espe_ccod as varchar) + '-'           " & vbCrLf &_
"                + e.carr_tdesc + '-' + d.espe_tdesc + '-'    " & vbCrLf &_
"                + cast(f.plan_tdesc as varchar) as salida,   " & vbCrLf &_
"                cast(f.espe_ccod as varchar) + '-'           " & vbCrLf &_
"                + cast(f.plan_ccod as varchar) + '-'         " & vbCrLf &_
"                + cast(e.carr_ccod as varchar)  as parametro " & vbCrLf &_
"from   personas as a                                         " & vbCrLf &_
"       inner join alumnos as b                               " & vbCrLf &_
"               on a.pers_ncorr = b.pers_ncorr                " & vbCrLf &_
"       inner join ofertas_academicas as c                    " & vbCrLf &_
"               on b.ofer_ncorr = c.ofer_ncorr                " & vbCrLf &_
"       left outer join cargas_academicas as g                " & vbCrLf &_
"                    on b.matr_ncorr = g.matr_ncorr           " & vbCrLf &_
"       inner join planes_estudio as f                        " & vbCrLf &_
"               on b.plan_ccod = f.plan_ccod                  " & vbCrLf &_
"       inner join especialidades as d                        " & vbCrLf &_
"               on c.espe_ccod = d.espe_ccod                  " & vbCrLf &_
"       inner join carreras as e                              " & vbCrLf &_
"               on d.carr_ccod = e.carr_ccod                  " & vbCrLf &_
"where  cast(pers_nrut as varchar) = '"&rut&"'                " & vbCrLf &_
"						) a                                   " 
'------------------------------------------------------------------------------------------------------fin_Nueva consulta 2008							
							
combo_b.siguiente
combo_b.agregacampocons		"plan_ccod", plan_ccod

if plan_ccod <> "" then 
	variables		=	split(plan_ccod,"-")
	plan			=	variables(1)
	especialidad	=	variables(0)
'	carrera			=	mid(especialidad,1,2)
	carrera			=   variables(2)
	historico.inicializar	conectar, rut, plan, especialidad, carrera
	'response.write(  rut  &"'='" &  plan  &"'='" & especialidad &"'='" & carrera )
end if


alumno	=	conectar.consultauno("select pers_tape_paterno + ' ' + pers_tape_materno + ' , ' + pers_tnombre from personas where cast(pers_nrut as varchar)='" & rut & "'")


   
peri_ccod	=	conectar.consultauno("select max(b.peri_ccod)  " & vbcrlf & _
									"	from alumnos a, ofertas_academicas b  " & vbcrlf & _
									"	where cast(a.pers_ncorr as varchar)='" & pers_ncorr &"' and a.emat_ccod=1 " & vbcrlf & _
									"	and a.ofer_ncorr = b.ofer_ncorr ")
										
matr_ncorr	=conectar.consultauno("	select matr_ncorr from alumnos a, ofertas_academicas b  " & vbcrlf & _
								"		where a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='" & peri_ccod &"'  " & vbcrlf & _
								"		and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='" & pers_ncorr &"'")

set resumen_he		=	new cformulario

resumen_he.carga_parametros		"historico.xml","resumen"		
resumen_he.inicializar			conectar

tabla_resumen=" SELECT c.reho_ncorr,cast(e.asig_ccod as varchar)+' - '+ e.asig_tdesc AS asignatura_origen, " & vbcrlf &_
				"       cast(a.asig_ccod as varchar) + ' - ' + a.asig_tdesc AS asignatura_destino,cast(f.carg_nnota_final as varchar) as nota " & vbcrlf &_
				"  FROM asignaturas a, " & vbcrlf &_
				"       secciones b, " & vbcrlf &_
				"       resoluciones_homologaciones c, " & vbcrlf &_
				"       secciones d, " & vbcrlf &_
				"       asignaturas e " & vbcrlf &_
				"       ,cargas_academicas f " & vbcrlf &_
				"       ,cargas_academicas g " & vbcrlf &_
				"       ,ALUMNOS h " & vbcrlf &_
				"       ,personas i " & vbcrlf &_
				" WHERE b.secc_ccod = c.secc_ccod_destino " & vbcrlf &_
				"   AND d.secc_ccod = c.secc_ccod_origen " & vbcrlf &_
				"   AND e.asig_ccod = d.asig_ccod " & vbcrlf &_
				"   AND a.asig_ccod = b.asig_ccod " & vbcrlf &_
				"   and f.secc_ccod = d.secc_ccod " & vbcrlf &_
				"  and f.secc_ccod = c.secc_ccod_origen " & vbcrlf &_
				"   and g.secc_ccod = b.secc_ccod " & vbcrlf &_
				"   and g.secc_ccod = c.secc_ccod_destino " & vbcrlf &_
				"   and c.matr_ncorr_origen=f.matr_ncorr " & vbcrlf &_
				"   and c.matr_ncorr_destino=g.matr_ncorr " & vbcrlf &_
				"   and g.matr_ncorr=h.matr_ncorr " & vbcrlf &_
				"   and h.pers_ncorr=i.pers_ncorr " & vbcrlf &_
				"   and cast(h.matr_ncorr as varchar)='"&matr_ncorr&"' " & vbcrlf &_
				"union " & vbcrlf &_
				"	select " & vbcrlf &_
				"		  c.secc_ccod,cast(i.asig_ccod as varchar) + ' ' + i.asig_tdesc as asignatura_origen ,   " & vbcrlf &_
				"					cast(j.asig_ccod as varchar)+' '+ j.asig_tdesc as asignatura_destino, " & vbcrlf &_
				"					case b.carg_nnota_final when null then ' * ' else b.carg_nnota_final end as nota  " & vbcrlf &_
				"	from " & vbcrlf &_
				"		equivalencias a " & vbcrlf &_
				"		, cargas_academicas b " & vbcrlf &_
				"		, secciones c " & vbcrlf &_
				"		, ofertas_academicas d " & vbcrlf &_
				"		, planes_estudio e " & vbcrlf &_
				"		, especialidades f " & vbcrlf &_
				"		, alumnos g " & vbcrlf &_
				"		, personas h " & vbcrlf &_
				"		,asignaturas i " & vbcrlf &_
				"		,asignaturas j " & vbcrlf &_
				"		,malla_curricular k " & vbcrlf &_
				"	where " & vbcrlf &_
				"		 a.matr_ncorr=b.matr_ncorr " & vbcrlf &_
				"		 and a.secc_ccod=b.secc_ccod " & vbcrlf &_
				"		 and b.secc_ccod=c.secc_ccod " & vbcrlf &_
				"		 and b.matr_ncorr=g.matr_ncorr " & vbcrlf &_
				"		 and d.ofer_ncorr=g.ofer_ncorr " & vbcrlf &_
				"		 and e.plan_ccod=g.plan_ccod " & vbcrlf &_
				"		 and e.espe_ccod=f.espe_ccod " & vbcrlf &_
				"		 and g.pers_ncorr=h.pers_ncorr " & vbcrlf &_
				"		 and cast(h.pers_nrut as varchar)='"& rut &"' " & vbcrlf &_
				"		 and i.asig_ccod=k.asig_ccod " & vbcrlf &_
				"		 and j.asig_ccod=c.asig_ccod " & vbcrlf &_
				"		 and a.mall_ccod=k.mall_ccod " & vbcrlf &_
				"		 and a.secc_ccod=c.secc_ccod " 

'response.Write("<pre>"&tabla_resumen&"</pre>")
'response.End()
resumen_he.consultar	tabla_resumen

set f_asignaturas = new CFormulario
if plan_ccod <> "" then 
		f_asignaturas.Carga_Parametros "historico.xml", "asignaturas"
else
		f_asignaturas.Carga_Parametros "historico.xml", "asignaturas2"
end if
f_asignaturas.Inicializar conectar

sql_todas_asignaturas= " select distinct asig.asig_ccod,asig.asig_tdesc, " & vbcrlf &_
						"	 case cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) when ' .0' then '0.0' else cast(cast(b.carg_nnota_final as decimal(2,1))as varchar) end as carg_nnota_final,  " & vbcrlf &_
						"	 2003, " & vbcrlf &_
						"	 case ('('+ cast(d.anos_ccod as varchar) + '-' +  cast(b.sitf_ccod as varchar)+')') " & vbcrlf &_
						"    when ('('+ cast(d.anos_ccod as varchar) + '-' +')') then ' ' " & vbcrlf &_
						"    when '(-)' then ' '" & vbcrlf &_
						"    else ('('+ cast(d.anos_ccod as varchar) + '-' + case cast(b.sitf_ccod as varchar) when 'A' then 'Apr' when 'R' then 'Repr' when 'C' then 'Conv' when 'SP' then 'SP' when 'H' then 'Hom' when 'S' then 'Suf' when 'RS' then 'RS' when 'RC' then 'RC' when 'RI' then 'RI' end +')') end as anos_ccod,  " & vbcrlf &_
						" b.secc_ccod,b.matr_ncorr,'"&rut&"' as pers_nrut, '"&plan&"' as plan_ccod, '"&especialidad &"' as espe_ccod,'"&carrera&"' as carr_ccod" & vbcrlf &_
						" From    asignaturas asig, secciones c, cargas_academicas b,periodos_academicos d" & vbcrlf &_
						" where asig.asig_ccod = c.asig_ccod" & vbcrlf &_
						" and b.secc_ccod=c.secc_ccod and isnull(b.carg_noculto,0) <> 1 " & vbcrlf &_
						" and c.peri_ccod=d.peri_ccod" & vbcrlf &_
						" and (b.sitf_ccod <> '' or cast(b.carg_nnota_final as varchar)<>'')"& vbCrlf &_
						" and matr_ncorr in ( select matr_ncorr " & vbcrlf &_
						"			from personas p, alumnos al" & vbcrlf &_
						"			where al.pers_ncorr=p.pers_ncorr" & vbcrlf &_
						"			and cast(p.pers_nrut as varchar)='"& rut &"'	)"
'response.Write("<pre>"&sql_todas_asignaturas&"</pre>")						
f_asignaturas.Consultar sql_todas_asignaturas
'response.End()


'response.Write(plan)
ultimo_peri_ccod =	conectar.consultauno("select max(b.peri_ccod)  " & vbcrlf & _
									"	from alumnos a, ofertas_academicas b  " & vbcrlf & _
									"	where cast(a.pers_ncorr as varchar)='" & pers_ncorr &"' and a.emat_ccod <> 9 " & vbcrlf & _
									"	and a.ofer_ncorr = b.ofer_ncorr and cast(plan_ccod as varchar)='"&plan&"'")

ultimo_estado =	conectar.consultauno("select top 1 emat_tdesc  " & vbcrlf & _
									"	from alumnos a, ofertas_academicas b,estados_matriculas c, especialidades d  " & vbcrlf & _
									"	where cast(a.pers_ncorr as varchar)='" & pers_ncorr &"' and a.emat_ccod=c.emat_ccod and b.espe_ccod=d.espe_ccod " & vbcrlf & _
									"	and a.ofer_ncorr = b.ofer_ncorr and carr_ccod ='"&carrera&"' order by b.peri_ccod desc, a.audi_fmodificacion desc")
																	
nombre_carrera = conectar.consultaUno("select carr_tdesc from carreras where carr_ccod='"&carrera&"'")
nombre_plan = conectar.consultaUno("select plan_tdesc from planes_estudio where cast(plan_ccod as varchar)='"&plan&"'")
resolucion = conectar.consultaUno("select plan_nresolucion from planes_estudio where cast(plan_ccod as varchar)='"&plan&"'")


fecha_actual = conectar.consultaUno("select protic.trunc(getDate())")
'response.Write(resolucion)

%>
<html>
<head>

<style>
@media print{ .noprint {visibility:hidden; }}
</style>


<title>Consultar Hist&oacute;rico de Notas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
<!--
function dibujar(formulario){
	formulario.submit();
}

function enviar(formulario){
		if(!(valida_rut(formulario.elements["busqueda[0][pers_nrut]"].value + '-' + formulario.elements["busqueda[0][pers_xdv]"].value))){
		    alert('El RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
			formulario.elements["busqueda[0][pers_nrut]"].focus();
			formulario.elements["busqueda[0][pers_nrut]"].select();			
		 } else {
			formulario.action = 'historico_notas_avanzado.asp';
			return true
		}
		return false
}



function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}
//-->
</script>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/salir_f2.gif','../imagenes/buscador/buscar_f2.gif')">

<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <%if esVacio(ocultar) then%>
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>
  <%end if%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<div align="right">
	<table width="20%" border="1">
	   <tr>
			<td><strong>::Fecha Actual <%=fecha_actual%></strong></td>
	   </tr>
	</table>                          	
	</div>
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
                        <td><div align="right">R.U.T. Alumno </div></td>
                        <td width="7%"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                        - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%><%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton("buscar")%></div></td>
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
            <td><%pagina.DibujarLenguetas Array("Historico de Notas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br><br>
                </div>
				
              
			  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Resultado de la Búsqueda"%>
                      <br>
					  <form name="editar" action="historico_notas_avanzado.asp">
                      <%if rut <> "" then %>
                      <table width="50%" cellspacing="0" cellpadding="0">
                        
                        <tr>
                          <td nowrap><font size="1" face="Verdana, Arial, Helvetica, sans-serif">(HM) : Asignatura Homologada Por Malla </font></td>
                        </tr>
                        <tr>
                          <td nowrap>&nbsp;</td>
                        </tr>
                        <tr>
                          <td nowrap><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Rut: <strong><%=rut%>-<%=dv%></strong> Nombre:&nbsp;<strong><%= alumno%> </strong></font></td>
                        </tr>
                        <tr>
                          <td nowrap>&nbsp;</td>
                        </tr>
						<tr>
                          <td nowrap><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Carrera: <strong><%=nombre_carrera%></strong> Plan de Estudios:&nbsp;<strong><%= nombre_plan%> </strong><br> Último Estado de matrícula Registrado:&nbsp;<strong><%= ultimo_estado%> </strong></font></td>
                        </tr>
						<tr>
                          <td nowrap>&nbsp;</td>
                        </tr>
						<tr>
                          <td nowrap align="left">
						  	 	<strong>Resolución:</strong> <font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#990000"><%=resolucion%></font>
						  </td>
                        </tr>
                        <tr>
                          <td nowrap>&nbsp;</td>
                        </tr>
                        <tr>
                          <td nowrap>Programa de Estudio:
                              <%combo_b.dibujacampo("plan_ccod")%></td>
                        </tr>
                      </table>
                          <%end if%>
                          <input type="hidden" name="busqueda[0][pers_nrut]" value="<%=rut%>"> 
                          <input name="busqueda[0][pers_xdv]" type="hidden" value="<%=dv%>">
<br>
                      <br>
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                              <td align="center"> 
                                <%
						if plan_ccod <> "" then
							historico.dibuja
						else %>
                              <table class="v1" border="1" borderColor="#999999" bgColor="#adadad" cellspacing="0" cellspading="0" width="98%">
                              <tr align="center" bgColor="#c4d7ff">
                                <TH><FONT color=#333333>Nivel</FONT></TH>
                                <TH><FONT color=#333333>C&oacute;digo Asignatura</FONT></TH>
                                <TH><FONT color=#333333>Asignatura</FONT></TH>
                                <TH><FONT color=#333333>1 oportunidad</FONT></TH>
                                <TH><FONT color=#333333>2 oportunidad</FONT></TH>
                                <TH><FONT color=#333333>3 oportunidad</FONT></TH>
                              </tr>
                              <tr bgcolor="#FFFFFF">
                                <td colspan="6" align="center" class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>No hay datos asociados a los parametros de b&uacute;squeda.</td>
                              </tr>
                            </table>
                            <%
						end if
						%>
                          </td>
                        </tr>
                      </table></form>
                      <br>
					   <form name="editar2">
                      <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><div align="center"></div></td>
                            </tr>
                            <tr> 
                              <td align="center"><strong>RESUMEN EQUIVALENCIAS 
                                - HOMOLOGACIONES </strong></td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td><div align="center"> 
                                  <%resumen_he.dibujatabla()%>
                                </div></td>
                            </tr>
                            <tr> 
                              <td><br>Todas las asignaturas registradas :</td>
                            </tr>
                            <tr>
                              <td><%f_asignaturas.DibujaTabla()%></td>
                            </tr>
                          </table>
						  </form>
					</td>
                 </tr>
				 <tr> 
				<td align="left">
				 <table width="60%" border="0" align="left" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td  width="3%" align="center"><strong>*</strong></td>
							  <td  width="1%" align="center"><strong>:</strong></td>
							  <td  align="left"> Esta asignatura la est&aacute; cursando el alumno en este periodo.</td>
                            </tr>
							<tr> 
                              <td  width="3%" align="center"><strong>Conv</strong></td>
							  <td  width="5%" align="center"><strong>:</strong></td>
							  <td  align="left"> Asignatura Aprobada por convalidaci&oacute;n.</td>
                            </tr>
							<tr> 
                              <td  width="3%" align="center"><strong>Apr</strong></td>
							  <td  width="5%" align="center"><strong>:</strong></td>
							  <td  align="left"> Asignatura Aprobada (por Evaluación regular o conocimientos relevantes).</td>
                            </tr>
							<tr> 
                              <td  width="3%" align="center"><strong>Repr</strong></td>
							  <td  width="5%" align="center"><strong>:</strong></td>
							  <td  align="left"> Asignatura Reprobada.</td>
                            </tr>
							<tr> 
                              <td  width="3%" align="center"><strong>Hom</strong></td>
							  <td  width="5%" align="center"><strong>:</strong></td>
							  <td  align="left"> Asignatura Aprobada por Homologaci&oacute;n.</td>
                            </tr>
							<tr> 
                              <td  width="3%" align="center"><strong>SP</strong></td>
							  <td  width="5%" align="center"><strong>:</strong></td>
							  <td  align="left"> Asignatura con situaci&oacute;n Pendiente.</td>
                            </tr>
							<tr> 
                              <td  width="3%" align="center"><strong>Suf</strong></td>
							  <td  width="5%" align="center"><strong>:</strong></td>
							  <td  align="left"> Asignatura Aprobada por Suficiencias.</td>
                            </tr>
							<tr> 
                              <td  width="3%" align="center"><strong>RS</strong></td>
							  <td  width="5%" align="center"><strong>:</strong></td>
							  <td  align="left"> Asignatura Reprobada por Suficiencias.</td>
                            </tr>
							<tr> 
                              <td  width="3%" align="center"><strong>RC</strong></td>
							  <td  width="5%" align="center"><strong>:</strong></td>
							  <td  align="left"> Asignatura Reprobada por Conocimientos Relevantes.</td>
                            </tr>
							<tr> 
                              <td  width="3%" align="center"><strong>RI</strong></td>
							  <td  width="5%" align="center"><strong>:</strong></td>
							  <td  align="left"> Asignatura Reprobada por Inasistencia.</td>
                            </tr>
						</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
                </table>
               <br>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="18"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="8%" height="20"><div align="center">
              <table width="20%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="13%"><div align="center">
                            <% if esVacio(ocultar) then
							   		botonera.dibujaboton("salir")
							   end if%>
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
