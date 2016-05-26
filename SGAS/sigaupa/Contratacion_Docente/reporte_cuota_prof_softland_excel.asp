<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: NA
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 28/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=
'LINEA				          : 88, 89
'********************************************************************
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_cuota_prof_softlan.xls"
Response.ContentType = "application/vnd.ms-excel"
'Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------
'carr_ccod = request.QueryString("busqueda[0][carr_ccod]")
'response.Write("carrera :" & carr_ccod)
'response.End()
set pagina = new CPagina
'pagina.Titulo = "Reporte Planificacion General" 

set conexion = new cConexion
set negocio = new cNegocio
set formu_resul= new cformulario
set resultado_busqueda = new cFormulario
conexion.inicializar "upacifico"
negocio.inicializa conexion

periodo = conexion.consultaUno("select max(peri_ccod) from actividades_periodos where tape_ccod=6 and acpe_bvigente='S'")
''****************************************************************************
''#################	 VERSION FUNCIONAL PERO CON DATOS EXTRAS #################
'sql_detalles_mate_antigua = " select  a.ficha,a.rut,a.pers_tape_paterno,a.pers_tape_materno,a.pers_tnombre,sum(cast(a.total_cuota as integer)) as cuota,a.tipo_profe from ( " & vbcrlf & _
'	" select  max(d.tpro_tdesc) as tipo_profe,a.pers_ncorr,g.pers_nrut as ficha,pers_xdv,rtrim(convert(char,g.pers_nrut))+g.pers_xdv as rut, " & vbcrlf & _
'	"  g.pers_tape_paterno,g.pers_tape_materno,g.pers_tnombre, " & vbcrlf & _
'	"  c.sede_ccod,carr_ccod,jorn_ccod,e.duas_ccod,bloq_anexo,hcor_valor1, " & vbcrlf & _
'	"  max(hcor_valor1*bpro_mvalor)as Total_Hcor, " & vbcrlf & _
'	" sum(ISNULL(CASE c.MODA_CCOD WHEN 1 THEN  (a.BPRO_MVALOR * (isnull(Y.hopr_nhoras,isnull(protic.retorna_horas_seccion1(c.secc_ccod,d.TPRO_CCOD,a.pers_ncorr),0))/2)) ELSE (a.BPRO_MVALOR * (isnull(c.secc_nhoras_pagar,0)/2)) END ,0)) as Total_seccion, " & vbcrlf & _
'	" max(case a.tpro_ccod when 1 then isnull(a.hcor_valor1,0) else 0 end *isnull(a.bpro_mvalor,0))+sum(ISNULL(CASE c.MODA_CCOD WHEN 1 THEN  (a.BPRO_MVALOR * (isnull(Y.hopr_nhoras,isnull(protic.retorna_horas_seccion1(c.secc_ccod,d.TPRO_CCOD,a.pers_ncorr),0))/2)) ELSE (a.BPRO_MVALOR * (isnull(c.secc_nhoras_pagar,0)/2)) END ,0)) as Total_anexo, " & vbcrlf & _
'	"        cast((max(hcor_valor1*bpro_mvalor)+sum(ISNULL(CASE c.MODA_CCOD WHEN 1 THEN  (a.BPRO_MVALOR * (isnull(isnull(Y.hopr_nhoras,protic.retorna_horas_seccion1(c.secc_ccod,d.TPRO_CCOD,a.pers_ncorr)),0)/2)) ELSE (a.BPRO_MVALOR * (isnull(c.secc_nhoras_pagar,0)/2)) END ,0)))/(CASE e.DUAS_CCOD WHEN 1 THEN h.PROC_CUOTAS_TRIMESTRAL WHEN 2 THEN h.PROC_CUOTAS_SEMESTRAL WHEN 3 THEN h.PROC_CUOTAS_ANUAL WHEN 4 THEN h.PROC_CUOTAS_ANUAL WHEN 5 THEN protic.OBTENER_CUOTAS_PERIODO(max(C.SECC_CCOD)) END) as integer) as Total_cuota " & vbcrlf & _
'	" from bloques_profesores a, bloques_horarios b,secciones c,tipos_profesores d, " & vbcrlf & _
'	" asignaturas e,duracion_asignatura f,personas g,procesos h ,horas_profesores Y " & vbcrlf & _
'	" where a.bloq_ccod=b.bloq_ccod " & vbcrlf & _
'	" and a.tpro_ccod=d.tpro_ccod " & vbcrlf & _
'	" and a.proc_ccod=h.proc_ccod " & vbcrlf & _
'	" and b.secc_ccod=c.secc_ccod " & vbcrlf & _
'	" and c.asig_ccod=e.asig_ccod " & vbcrlf & _
'	" and e.duas_ccod=f.duas_ccod " & vbcrlf & _
'	" and a.bloq_anexo is not null " & vbcrlf & _
'	" and a.pers_ncorr=g.pers_ncorr " & vbcrlf & _
'	" and a.PERS_NCORR*=Y.pers_ncorr " & vbcrlf & _
'   " and b.SECC_CCOD *=Y.secc_ccod " & vbcrlf & _
'	"  and a.pers_ncorr=12932  " & vbcrlf & _
'   " and Y.hopr_nhoras > 0 " & vbcrlf & _
'	" and b.bloq_ccod=(select max(bb.bloq_ccod) from bloques_horarios bb,bloques_profesores cc  where bb.bloq_ccod=cc.bloq_ccod and c.secc_ccod=bb.secc_ccod and a.pers_ncorr=cc.pers_ncorr ) " & vbcrlf & _
'	" group by a.pers_ncorr,g.pers_nrut,g.pers_xdv,g.pers_tape_paterno,g.pers_tape_materno,g.pers_tnombre,c.sede_ccod,carr_ccod,jorn_ccod,e.duas_ccod,bloq_anexo,hcor_valor1,h.PROC_CUOTAS_TRIMESTRAL,h.PROC_CUOTAS_SEMESTRAL,h.PROC_CUOTAS_ANUAL  " & vbcrlf & _
'	" --order by a.pers_ncorr,c.sede_ccod,carr_ccod,jorn_ccod,e.duas_ccod " & vbcrlf & _
'   " ) as a " & vbcrlf & _
'   " group by a.tipo_profe,a.ficha,a.rut,a.pers_tape_paterno,a.pers_tape_materno,a.pers_tnombre " & vbcrlf & _
'   " order by a.pers_tape_paterno,a.pers_tape_materno,a.pers_tnombre " & vbcrlf 
''****************************************************************************

'sql_detalles_mate = " select  a.ficha,a.rut,a.pers_tape_paterno,a.pers_tape_materno,a.pers_tnombre,sum(cast(a.total_cuota as integer)) as cuota,a.tipo_profe from ( " & vbcrlf & _
'	" select  max(d.tpro_tdesc) as tipo_profe,a.pers_ncorr,g.pers_nrut as ficha,pers_xdv,rtrim(convert(char,g.pers_nrut))+g.pers_xdv as rut, " & vbcrlf & _
'	"  g.pers_tape_paterno,g.pers_tape_materno,g.pers_tnombre, " & vbcrlf & _
'	"  c.sede_ccod,carr_ccod,jorn_ccod,e.duas_ccod,bloq_anexo,hcor_valor1, " & vbcrlf & _
'	" (max(case a.tpro_ccod when 1 then isnull(a.hcor_valor1,0) else 0 end *isnull(a.bpro_mvalor,0))+sum(ISNULL(CASE c.MODA_CCOD WHEN 1 THEN  (a.BPRO_MVALOR * (isnull(Y.hopr_nhoras,isnull(protic.retorna_horas_seccion1(c.secc_ccod,d.TPRO_CCOD,a.pers_ncorr),0))/2)) ELSE (a.BPRO_MVALOR * (isnull(c.secc_nhoras_pagar,0)/2)) END ,0)))/(CASE e.DUAS_CCOD WHEN 1 THEN h.PROC_CUOTAS_TRIMESTRAL WHEN 2 THEN h.PROC_CUOTAS_SEMESTRAL WHEN 3 THEN h.PROC_CUOTAS_ANUAL WHEN 4 THEN h.PROC_CUOTAS_ANUAL WHEN 5 THEN protic.OBTENER_CUOTAS_PERIODO(max(C.SECC_CCOD)) END) as Total_cuota " & vbcrlf & _
'	"   ,case F.DUAS_CCOD WHEN 5 then protic.trunc(c.SECC_FINICIO_SEC) else protic.trunc(h.PROC_FINICIO) end AS FECHA_INICIO " & vbcrlf & _
'    "   ,protic.trunc(CASE F.DUAS_CCOD WHEN 1 THEN h.PROC_FFIN_TRIMESTRAL WHEN 2 THEN h.PROC_FFIN_SEMESTRAL WHEN 3 THEN h.PROC_FFIN_ANUAL WHEN 4 THEN h.PROC_FFIN_ANUAL WHEN 5 THEN c.SECC_FTERMINO_SEC END) AS FECHA_FIN " & vbcrlf & _
'	" from bloques_profesores a, bloques_horarios b,secciones c,tipos_profesores d, " & vbcrlf & _
'	" asignaturas e,duracion_asignatura f,personas g,procesos h ,horas_profesores Y " & vbcrlf & _
'	" where a.bloq_ccod=b.bloq_ccod " & vbcrlf & _
'	" and a.tpro_ccod=d.tpro_ccod " & vbcrlf & _
'	" and a.proc_ccod=h.proc_ccod " & vbcrlf & _
'	" and b.secc_ccod=c.secc_ccod " & vbcrlf & _
'	" and c.asig_ccod=e.asig_ccod " & vbcrlf & _
'	" and e.duas_ccod=f.duas_ccod " & vbcrlf & _
'	" and a.bloq_anexo is not null " & vbcrlf & _
'	" and a.pers_ncorr=g.pers_ncorr " & vbcrlf & _
'	" and a.PERS_NCORR*=Y.pers_ncorr " & vbcrlf & _
'    " and b.SECC_CCOD *=Y.secc_ccod " & vbcrlf & _
'	" and isnull(a.eblo_ccod,0)<>3  " & vbcrlf & _
'    " and Y.hopr_nhoras > 0 " & vbcrlf & _
'	" and b.bloq_ccod=(select max(bb.bloq_ccod) from bloques_horarios bb,bloques_profesores cc  where bb.bloq_ccod=cc.bloq_ccod and c.secc_ccod=bb.secc_ccod and a.pers_ncorr=cc.pers_ncorr ) " & vbcrlf & _
'	" 	  group by a.pers_ncorr,g.pers_nrut,g.pers_xdv,g.pers_tape_paterno,g.pers_tape_materno,g.pers_tnombre,c.sede_ccod,carr_ccod,jorn_ccod,e.duas_ccod,bloq_anexo,hcor_valor1,h.PROC_CUOTAS_TRIMESTRAL,h.PROC_CUOTAS_SEMESTRAL,h.PROC_CUOTAS_ANUAL,c.SECC_FINICIO_SEC,F.DUAS_CCOD,h.PROC_FINICIO,h.PROC_FFIN_ANUAL,h.PROC_FFIN_TRIMESTRAL,c.SECC_FTERMINO_SEC,h.PROC_FFIN_SEMESTRAL " & vbcrlf & _
'	" --order by a.pers_ncorr,c.sede_ccod,carr_ccod,jorn_ccod,e.duas_ccod " & vbcrlf & _
'   " ) as a " & vbcrlf & _
'   "       where  convert(datetime,getdate(),103) between  convert(datetime,a.fecha_inicio,103) and convert(datetime,a.fecha_fin,103) "& vbcrlf & _
'   " group by a.tipo_profe,a.ficha,a.rut,a.pers_tape_paterno,a.pers_tape_materno,a.pers_tnombre " & vbcrlf & _
'   " order by a.pers_tape_paterno,a.pers_tape_materno,a.pers_tnombre " & vbcrlf 

'----------------------------------------------------------------------------------------------------------Nueva consulta 2008
sql_detalles_mate = " select a.ficha,                                                                                                               " & vbCrLf &_
"       a.rut,                                                                                                                                      " & vbCrLf &_
"       a.pers_tape_paterno,                                                                                                                        " & vbCrLf &_
"       a.pers_tape_materno,                                                                                                                        " & vbCrLf &_
"       a.pers_tnombre,                                                                                                                             " & vbCrLf &_
"       sum(cast(a.total_cuota as integer)) as cuota,                                                                                               " & vbCrLf &_
"       a.tipo_profe                                                                                                                                " & vbCrLf &_
"from   (                                                                                                                                           " & vbCrLf &_
"select max(d.tpro_tdesc)             as tipo_profe,                                                                                                " & vbCrLf &_
"       a.pers_ncorr,                                                                                                                               " & vbCrLf &_
"       g.pers_nrut                   as ficha,                                                                                                     " & vbCrLf &_
"       pers_xdv,                                                                                                                                   " & vbCrLf &_
"       rtrim(convert(char, g.pers_nrut))                                                                                                           " & vbCrLf &_
"       + g.pers_xdv                  as rut,                                                                                                       " & vbCrLf &_
"       g.pers_tape_paterno,                                                                                                                        " & vbCrLf &_
"       g.pers_tape_materno,                                                                                                                        " & vbCrLf &_
"       g.pers_tnombre,                                                                                                                             " & vbCrLf &_
"       c.sede_ccod,                                                                                                                                " & vbCrLf &_
"       carr_ccod,                                                                                                                                  " & vbCrLf &_
"       jorn_ccod,                                                                                                                                  " & vbCrLf &_
"       e.duas_ccod,                                                                                                                                " & vbCrLf &_
"       bloq_anexo,                                                                                                                                 " & vbCrLf &_
"       hcor_valor1,                                                                                                                                " & vbCrLf &_
"       ( max(case a.tpro_ccod when 1 then isnull(a.hcor_valor1, 0) else 0 end *isnull(a.bpro_mvalor, 0)) + sum(isnull(case c.moda_ccod when 1 then " & vbCrLf &_
"         (a.bpro_mvalor * (                                                                                                                        " & vbCrLf &_
"         isnull(y.hopr_nhoras, isnull(protic.retorna_horas_seccion1(c.secc_ccod, d.tpro_ccod, a.pers_ncorr), 0))/2)) else (a.bpro_mvalor *         " & vbCrLf &_
"         (isnull(c.secc_nhoras_pagar,                                                                                                              " & vbCrLf &_
"         0)/2)) end, 0)) ) / ( case e.duas_ccod                                                                                                    " & vbCrLf &_
"                                 when 1 then h.proc_cuotas_trimestral                                                                              " & vbCrLf &_
"                                 when 2 then h.proc_cuotas_semestral                                                                               " & vbCrLf &_
"                                 when 3 then h.proc_cuotas_anual                                                                                   " & vbCrLf &_
"                                 when 4 then h.proc_cuotas_anual                                                                                   " & vbCrLf &_
"                                 when 5 then protic.obtener_cuotas_periodo(max(c.secc_ccod))                                                       " & vbCrLf &_
"                               end ) as total_cuota,                                                                                               " & vbCrLf &_
"       case f.duas_ccod                                                                                                                            " & vbCrLf &_
"         when 5 then protic.trunc(c.secc_finicio_sec)                                                                                              " & vbCrLf &_
"         else protic.trunc(h.proc_finicio)                                                                                                         " & vbCrLf &_
"       end                           as fecha_inicio,                                                                                              " & vbCrLf &_
"       protic.trunc(case f.duas_ccod                                                                                                               " & vbCrLf &_
"                      when 1 then h.proc_ffin_trimestral                                                                                           " & vbCrLf &_
"                      when 2 then h.proc_ffin_semestral                                                                                            " & vbCrLf &_
"                      when 3 then h.proc_ffin_anual                                                                                                " & vbCrLf &_
"                      when 4 then h.proc_ffin_anual                                                                                                " & vbCrLf &_
"                      when 5 then c.secc_ftermino_sec                                                                                              " & vbCrLf &_
"                    end)             as fecha_fin                                                                                                  " & vbCrLf &_
"from   bloques_profesores as a                                                                                                                     " & vbCrLf &_
"       inner join bloques_horarios as b                                                                                                            " & vbCrLf &_
"               on a.bloq_ccod = b.bloq_ccod                                                                                                        " & vbCrLf &_
"       inner join secciones as c                                                                                                                   " & vbCrLf &_
"               on b.secc_ccod = c.secc_ccod                                                                                                        " & vbCrLf &_
"                  and b.bloq_ccod = (select max(bb.bloq_ccod)                                                                                      " & vbCrLf &_
"                                     from   bloques_horarios as bb                                                                                 " & vbCrLf &_
"                                            inner join bloques_profesores as cc                                                                    " & vbCrLf &_
"                                                    on bb.bloq_ccod = cc.bloq_ccod                                                                 " & vbCrLf &_
"                                                       and c.secc_ccod = bb.secc_ccod                                                              " & vbCrLf &_
"                                                       and a.pers_ncorr = cc.pers_ncorr)                                                           " & vbCrLf &_
"       inner join tipos_profesores as d                                                                                                            " & vbCrLf &_
"               on a.tpro_ccod = d.tpro_ccod                                                                                                        " & vbCrLf &_
"                  and a.tpro_ccod = d.tpro_ccod                                                                                                    " & vbCrLf &_
"       inner join asignaturas as e                                                                                                                 " & vbCrLf &_
"               on c.asig_ccod = e.asig_ccod                                                                                                        " & vbCrLf &_
"       inner join duracion_asignatura as f                                                                                                         " & vbCrLf &_
"               on e.duas_ccod = f.duas_ccod                                                                                                        " & vbCrLf &_
"       inner join personas as g                                                                                                                    " & vbCrLf &_
"               on a.pers_ncorr = g.pers_ncorr                                                                                                      " & vbCrLf &_
"       inner join procesos as h                                                                                                                    " & vbCrLf &_
"               on a.proc_ccod = h.proc_ccod                                                                                                        " & vbCrLf &_
"       left outer join horas_profesores as y                                                                                                       " & vbCrLf &_
"                    on a.pers_ncorr = y.pers_ncorr                                                                                                 " & vbCrLf &_
"                       and b.secc_ccod = y.secc_ccod                                                                                               " & vbCrLf &_
"                       and y.hopr_nhoras > 0                                                                                                       " & vbCrLf &_
"where  a.bloq_anexo is not null                                                                                                                    " & vbCrLf &_
"       and isnull(a.eblo_ccod, 0) <> 3                                                                                                             " & vbCrLf &_
"group  by a.pers_ncorr,                                                                                                                            " & vbCrLf &_
"          g.pers_nrut,                                                                                                                             " & vbCrLf &_
"          g.pers_xdv,                                                                                                                              " & vbCrLf &_
"          g.pers_tape_paterno,                                                                                                                     " & vbCrLf &_
"          g.pers_tape_materno,                                                                                                                     " & vbCrLf &_
"          g.pers_tnombre,                                                                                                                          " & vbCrLf &_
"          c.sede_ccod,                                                                                                                             " & vbCrLf &_
"          carr_ccod,                                                                                                                               " & vbCrLf &_
"          jorn_ccod,                                                                                                                               " & vbCrLf &_
"          e.duas_ccod,                                                                                                                             " & vbCrLf &_
"          bloq_anexo,                                                                                                                              " & vbCrLf &_
"          hcor_valor1,                                                                                                                             " & vbCrLf &_
"          h.proc_cuotas_trimestral,                                                                                                                " & vbCrLf &_
"          h.proc_cuotas_semestral,                                                                                                                 " & vbCrLf &_
"          h.proc_cuotas_anual,                                                                                                                     " & vbCrLf &_
"          c.secc_finicio_sec,                                                                                                                      " & vbCrLf &_
"          f.duas_ccod,                                                                                                                             " & vbCrLf &_
"          h.proc_finicio,                                                                                                                          " & vbCrLf &_
"          h.proc_ffin_anual,                                                                                                                       " & vbCrLf &_
"          h.proc_ffin_trimestral,                                                                                                                  " & vbCrLf &_
"          c.secc_ftermino_sec,                                                                                                                     " & vbCrLf &_
"          h.proc_ffin_semestral                                                                                                                    " & vbCrLf &_
"--order by a.pers_ncorr,c.sede_ccod,carr_ccod,jorn_ccod,e.duas_ccod                                                                                " & vbCrLf &_
") as a                                                                                                                                             " & vbCrLf &_
"where  convert(datetime, getdate(), 103) between convert(datetime, a.fecha_inicio, 103) and convert(datetime, a.fecha_fin, 103)                    " & vbCrLf &_
"group  by a.tipo_profe,                                                                                                                            " & vbCrLf &_
"          a.ficha,                                                                                                                                 " & vbCrLf &_
"          a.rut,                                                                                                                                   " & vbCrLf &_
"          a.pers_tape_paterno,                                                                                                                     " & vbCrLf &_
"          a.pers_tape_materno,                                                                                                                     " & vbCrLf &_
"          a.pers_tnombre                                                                                                                           " & vbCrLf &_
"order  by a.pers_tape_paterno,                                                                                                                     " & vbCrLf &_
"          a.pers_tape_materno,                                                                                                                     " & vbCrLf &_
"          a.pers_tnombre                                                                                                                           " & vbCrLf
'------------------------------------------------------------------------------------------------------fin_Nueva consulta 2008
	
'response.Write("Sql : <pre>"&sql_detalles_mate&"</pre>")
'response.End()

set f_detalle_mat  = new cformulario
f_detalle_mat.carga_parametros "planificacion_gral_excel.xml", "f_detalle_serv" 
f_detalle_mat.inicializar conexion							
f_detalle_mat.consultar sql_detalles_mate

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  
<!--<meta http-equiv="Content-Type" content="text/html;">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">-->

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="75%" border="1">
  <tr> 
    <td><div align="center"><strong>Ficha</strong></div></td>
    <td><div align="center"><strong>Rut</strong></div></td>
    <td><div align="center"><strong>Apellido Paterno</strong></div></td>
    <td><div align="center"><strong>Apellido Materno</strong></div></td>
    <td><div align="center"><strong>Nombres</strong></div></td>
	<td><div align="center"><strong>Valor Cuota</strong></div></td>
	<td><div align="center"><strong>Tipo Profesor</strong></div></td>
  </tr>
  <%  while f_detalle_mat.Siguiente %>
  <tr> 
      <td><div align="left"><%=f_detalle_mat.ObtenerValor("ficha")%></div></td>
    <td><div align="left"><%=f_detalle_mat.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_detalle_mat.ObtenerValor("pers_tape_paterno")%></div></td>
    <td><div align="left"><%=f_detalle_mat.ObtenerValor("pers_tape_materno")%></div></td>
    <td><div align="left"><%=f_detalle_mat.ObtenerValor("pers_tnombre")%></div></td>
	<td><div align="right"><%=f_detalle_mat.ObtenerValor("cuota")%></div></td>
	<td><div align="right"><%=f_detalle_mat.ObtenerValor("tipo_profe")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>