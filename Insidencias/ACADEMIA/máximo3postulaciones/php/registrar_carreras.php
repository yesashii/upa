<?php
require ("../include/negocio_inicio.php");

$xtpl=new XTemplate ($sys_path_templates."registrar_carreras.html");
//## Contenidos Principales
$page_estilos_w3c[]="estilos.css";
$page_title		="Registro datos iniciales";
$titulo_pagina	="Registro datos iniciales";
//## Contenidos Principales
###############        INICIO RETROALIMENTACION        ###############
###############                FIN  RETROALIMENTACION        ###############

$correlativo    = $_SESSION['ses_corr_persona'];
$rut_persona    = $_SESSION['ses_rut_post'];
$dv_persona     = $_SESSION['ses_dv_post'];  
$periodo        = $_SESSION['peri_ccod'];
echo ($_SESSION['peri_ccod']);
echo $periodo;

$c_post_ncorr  = "select post_ncorr from personas_postulante a, postulantes b 
                  where cast(a.pers_nrut as varchar)= '$rut_persona' 
                  and a.pers_ncorr=b.pers_ncorr and cast(b.peri_ccod as varchar)='$periodo'";
$a_post_ncorr  = $obj_consulta->RetornaRegistro($c_post_ncorr);
$v_post_ncorr = $a_post_ncorr["post_ncorr"];

$consulta_carreras    =  "  select '' as ofer_ncorr,' ---Selecciona Carrera a Postular---' as carrera_ofertada,0 as orden
						    union 
							select cast(a.ofer_ncorr as varchar) as ofer_ncorr,
							carrera  as carrera_ofertada,orden
							from ofertas_academicas a, sedes b, especialidades c, carreras d, jornadas e,orden_carreras_admision f
							where a.sede_ccod=b.sede_ccod and a.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod
							and a.jorn_ccod=e.jorn_ccod and cast(a.peri_ccod as varchar)='$periodo' and a.post_bnuevo='S'
							and a.sede_ccod=f.sede_ccod and a.jorn_ccod=f.jorn_ccod and f.carr_ccod=d.carr_ccod
							and ofer_bactiva = 'S' and ofer_bpublica = 'S' and d.tcar_ccod=1
							and not exists (select 1 from detalle_postulantes bb where bb.ofer_ncorr=a.ofer_ncorr and cast(bb.post_ncorr as varchar)='$v_post_ncorr')
							order by carrera_ofertada";
//echo $consulta_carreras ;
							
/*						 "select '' as ofer_ncorr,'  Seleccione Carrera a postular' as carrera_ofertada
						 union 
                         select cast(a.ofer_ncorr as varchar) as ofer_ncorr,protic.initcap(b.sede_tdesc+ ':'+carr_tdesc + ' ('+lower(jorn_tdesc)+')')  as carrera_ofertada 
						 from ofertas_academicas a, sedes b, especialidades c, carreras d, jornadas e
						 where a.sede_ccod=b.sede_ccod and a.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod
						 and a.jorn_ccod=e.jorn_ccod and cast(a.peri_ccod as varchar)='$periodo' and a.post_bnuevo='S'
						 and not exists (select 1 from detalle_postulantes bb where bb.ofer_ncorr=a.ofer_ncorr and cast(bb.post_ncorr as varchar)='$v_post_ncorr')
						 order by carrera_ofertada";*/
					 
$arreglo_carreras		= $obj_consulta->RetornaArreglo($consulta_carreras);
//echo "<pre>";
//print_r($arreglo_carreras);
//echo "</pre>";
foreach($arreglo_carreras as $key=>$valor)
{
		$xtpl->assign("carrera",$arreglo_carreras[$key]);
		$xtpl->parse("main.carreras");
}


$c_postulante = " select protic.initCap (Pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) as nombre,
                  cast(pers_nrut as varchar) +'-'+ pers_xdv as rut, pers_ncorr 
				  from personas_postulante
				  where cast(pers_nrut as varchar)='$rut_persona'";
	$a_postulante  = $obj_consulta->RetornaRegistro($c_postulante);
	$v_nombre      = $a_postulante["nombre"];
    $v_rut         = $a_postulante["rut"];
	$pers_ncorr    = $a_postulante["pers_ncorr"];
$xtpl->assign("nombre",$v_nombre);
$xtpl->assign("rut",$v_rut);
$xtpl->assign("mensaje",$mensaje);



$sql_cartera = "select c.ofer_ncorr,protic.initcap(sede_tdesc)as sede, protic.initcap(g.carr_tdesc) as carrera,
					protic.initcap(h.jorn_tdesc) as jornada, protic.trunc(b.audi_fmodificacion) as fecha 
					from postulantes a,detalle_postulantes b, ofertas_academicas c, sedes d, especialidades f,
					carreras g, jornadas h
					where a.post_ncorr = b.post_ncorr and b.ofer_ncorr = c.ofer_ncorr and c.sede_ccod = d.sede_ccod
					and c.espe_ccod = f.espe_ccod and f.carr_ccod = g.carr_ccod and c.jorn_ccod=h.jorn_ccod
                    and g.tcar_ccod = 1
					and cast(a.peri_ccod as varchar)='$periodo' and cast(a.pers_ncorr as varchar)='$pers_ncorr'
					order by b.fecha_asignacion_carrera asc";

$arreglo_carteras = $obj_consulta->RetornaArreglo($sql_cartera);
$contador=0;
if (is_array($arreglo_carteras))
{
	$indice=0;
    foreach($arreglo_carteras as $key=>$valor)
	{
		$arreglo_carteras[$key]["indice"]=$indice;
		$indice = $indice+1;
		$arreglo_carteras[$key]["preferencia"]=$indice."a Preferencia";
		$contador = $contador + 1;
		
		/*$cod_tipo_beneficio	=$valor["cod_tipo_beneficio"];
		 $consulta = "select count(cod_persona) as cantidad from solicitar_reembolso bb
					  where bb.cod_tipo_beneficio='$cod_tipo_beneficio' and anio='$anio'
					  and fecha_solicitud >='$fecha_i' and fecha_solicitud <='$fecha_t'";
		 $a_temporal = $obj_solicitud->ConsultaUno($consulta);
		 $arreglo_solicitudes[$key]["cantidad"] = $a_temporal["cantidad"];*/
		 
		
		$xtpl->assign("cartera",$arreglo_carteras[$key]);
		
		$xtpl->parse("main.carteras");
    }
}
else
{
	$xtpl->parse("main.carteras");
}

if ($contador == 0)
{
	$deshabilita_borrar = "disabled";
	$mensaje_listado = "Aún no has incorporado carreras a tu carpeta de postulación.";
}
else
{
	$deshabilita_borrar = "";
	$mensaje_listado = "";
}

$c_con_encuesta  = "select case count(*) when 0 then 'NO' else 'SI' end as con_encuesta
                    from personas_postulante a, encuestas_postulantes b 
                    where cast(a.pers_nrut as varchar)= '$rut_persona' 
                    and a.pers_ncorr=b.pers_ncorr and cast(b.peri_ccod as varchar)='$periodo'";
$a_con_encuesta  = $obj_consulta->RetornaRegistro($c_con_encuesta);
$con_encuesta = $a_con_encuesta["con_encuesta"];
if ($con_encuesta =="SI")
{
	$siguiente="finalizar_postulacion_previa.php";
	$texto_boton = "Enviar postulación";
}
else
{
	$siguiente="encuesta_previa.php";
	$texto_boton = "Siguiente";
}


$xtpl->assign("siguiente",$siguiente);
$xtpl->assign("texto_boton",$texto_boton);

$xtpl->assign("deshabilita_borrar",$deshabilita_borrar);
$xtpl->assign("mensaje_listado",$mensaje_listado);

//## Inicio Carga Plantilla
include_once($sys_path_include."include_enc.php");

	$xtpl->parse("main");
	$xtpl->out("main");

include_once($sys_path_include."include_pie.php");
//## Fin Carga Plantilla
?>