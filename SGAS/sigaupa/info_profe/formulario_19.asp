<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: SIN ACCESO DESDE EL SISTEMA
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 20/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=, =*
'LINEA				          : 178, 209
'********************************************************************
set pagina = new CPagina
pagina.Titulo = "Curriculum Docente"

'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


usuario = negocio.ObtenerUsuario
sede = negocio.obtenerSede
'response.Write("usuario "&usuario)

pers_ncorr = Request.QueryString("pers_ncorr")

'-----------------------------------------------------------------------
set F_consulta_docente = new CFormulario
F_consulta_docente.Carga_Parametros "parametros.xml", "tabla"
F_consulta_docente.inicializar conexion

sql = " Select b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as nombre_docente, " & vbcrlf & _
	  " case e.tpro_ccod when 1 then 'DOCENTE' when 2 then 'AYUDANTE' end as tipo_docente, " & vbcrlf & _
 	  " d.ciud_tdesc,a.DIRE_TCALLE,a.DIRE_TNRO, " & vbcrlf & _
	  " a.DIRE_TPOBLACION,a.DIRE_TBLOCK,a.DIRE_TDEPTO,a.DIRE_TLOCALIDAD,b.pers_tfono as fono, " & vbcrlf & _
	  " f.eciv_tdesc,cast(pers_nrut as varchar)+ '-' + pers_xdv as rut, " & vbcrlf & _
 	  " isnull(c.pais_tnacionalidad,c.pais_tdesc) as nacionalidad,protic.trunc(b.pers_fnacimiento) as fecha_nac,getdate() as fecha_actual " & vbcrlf & _
 	  " from personas b " & vbcrlf & _
	" left outer join direcciones a " & vbcrlf & _
	"    on b.pers_ncorr = a.pers_ncorr and 1 = a.tdir_ccod " & vbcrlf & _
	" left outer join paises c " & vbcrlf & _
	"    on c.pais_ccod = b.pais_ccod " & vbcrlf & _
	" left outer join ciudades d " & vbcrlf & _
	"    on d.ciud_ccod = a.ciud_ccod " & vbcrlf & _
	" left outer join profesores e " & vbcrlf & _
	"    on e.pers_ncorr = '" & pers_ncorr & "'" & vbcrlf & _
	" 	 and e.sede_ccod= " & sede & " " & vbcrlf & _
	" left outer join estados_civiles f " & vbcrlf & _
    " 	 on b.eciv_ccod=f.eciv_ccod " & vbcrlf & _
	" where cast(b.pers_ncorr as varchar) ='" & pers_ncorr & "' " 
'response.Write("<pre>" & sql & "</pre>")'periodo=negocio.obtenerPeriodoAcademico("CLASE18")		
'response.End()
F_consulta_docente.consultar sql
F_consulta_docente.siguiente


'---------------------------------------------------------------------------------
set F_academicos = new CFormulario
F_academicos.Carga_Parametros "parametros.xml", "tabla"
F_academicos.inicializar conexion

 
Sqlperfeccionamiento = " Select '"&pers_ncorr&"' as pers_ncorr,cudo_ncorr,cudo_tinstitucion, " & vbcrlf & _
						" case grac_ccod when 1 then ' TÉCNICO ' when 2 then ' PROFESIONAL ' else '' end as tipo_titulo," & vbcrlf & _
						" CUDO_TITULO as Nombre_TITULO, " & vbcrlf & _
						" PAIS_TDESC,cudo_ano_egreso " & vbcrlf & _
					    " from curriculum_docente a,paises b " & vbcrlf & _
					    " where a.pais_ccod = b.pais_ccod " & vbcrlf & _
					    " and cast(pers_ncorr as varchar)='"&pers_ncorr&"' " & vbcrlf & _
					    " and tiex_ccod=3 " & vbcrlf & _
					    " order by cudo_finicio asc"
'response.Write("<pre>" & Sqlperfeccionamiento & "</pre>")		
F_academicos.consultar Sqlperfeccionamiento
'F_academicos.siguiente

'---------------------------------------------------------------------------------
set F_grados_academicos = new CFormulario
F_grados_academicos.Carga_Parametros "parametros.xml", "tabla"
F_grados_academicos.inicializar conexion

SqlGradosAcademicos = " select '"&pers_ncorr&"' as pers_ncorr, a.gpro_ncorr, " & vbcrlf & _
						" b.grac_tdesc, " & vbcrlf & _
						" a.gpro_tdescripcion as GPRO_TDESCRIPCION, " & vbcrlf & _
						" a.gpro_tinstitucion,a.gpro_ano_egreso, c.pais_tdesc,d.egra_tdesc " & vbcrlf & _
						" from grados_profesor a,grados_academicos b,paises c,estados_grados_academicos d " & vbcrlf & _
						" where a.grac_ccod = b.grac_ccod " & vbcrlf & _
						" and a.pais_ccod = c.pais_ccod " & vbcrlf & _
						" and a.egra_ccod=d.egra_ccod " & vbcrlf & _
						" and cast(a.pers_ncorr as varchar) = '"&pers_ncorr&"' "
'response.Write("<pre>" & SqlGradosAcademicos & "</pre>")
'response.End()		

F_grados_academicos.consultar SqlGradosAcademicos
'F_grados_academicos.Siguiente
'F_grados_academicos.primero
'response.Write("<PRE>" & sql & "</PRE>")

set F_experiencia_doc = new CFormulario
F_experiencia_doc.Carga_Parametros "parametros.xml", "tabla"
F_experiencia_doc.inicializar conexion


SqlExdocente = " Select '"&pers_ncorr&"' as pers_ncorr,cudo_ncorr,cudo_tinstitucion, " & vbcrlf & _
			   	" cudo_asig_tdesc,cudo_nsemestre,cudo_carr_tdesc,cudo_area,cudo_tdescripcion_experiencia,"& vbcrlf & _
			   	"  cast(DATEPART(year, cudo_finicio) as varchar) + '-' + cast(DATEPART(year, cudo_ftermino) as varchar) as rango_fecha, " & vbcrlf & _
			   	" protic.trunc(cudo_finicio) as cudo_finicio,protic.trunc(cudo_ftermino) as cudo_ftermino,cudo_tactividad, " & vbcrlf & _
        		" case isnull(cudo_anos_experiencia,0) " & vbcrlf & _ 
				" when 0 then " & vbcrlf & _ 
				" case " & vbcrlf & _ 
				" when DATEDIFF(month,cudo_finicio,cudo_ftermino)>=1 and  DATEDIFF(month,cudo_finicio,cudo_ftermino)<=5 then cast(DATEDIFF(month,cudo_finicio,cudo_ftermino) as varchar)+ ' Meses' " & vbcrlf & _
        		" when DATEDIFF(month,cudo_finicio,cudo_ftermino)<1 then cast(DATEDIFF(day,cudo_finicio,cudo_ftermino) as varchar)+ ' Dias' " & vbcrlf & _
        		" else cast(ceiling(DATEDIFF(month,cudo_finicio,cudo_ftermino)/cast(12 as decimal)) as varchar)+ ' Años'  end else cast(cudo_anos_experiencia as varchar) + ' Años' end as  cudo_anos_experiencia " & vbcrlf & _
			   	" from curriculum_docente" & vbcrlf & _
			   	" where cast(pers_ncorr as varchar)='"&pers_ncorr&"'" & vbcrlf & _
			   	" and tiex_ccod=4" & vbcrlf & _
			   	" order by cudo_finicio asc"

'response.Write("<pre>" & SqlExdocente & "</pre>")

F_experiencia_doc.consultar SqlExdocente
'------------------------------------------------------------------------------
set F_experiencia_aca = new CFormulario
F_experiencia_aca.Carga_Parametros "parametros.xml", "tabla"
F_experiencia_aca.inicializar conexion


SqlExAcademica = " Select '"&pers_ncorr&"' as pers_ncorr,cudo_ncorr,cudo_tinstitucion, " & vbcrlf & _
			   	" cudo_asig_tdesc,cudo_nsemestre,cudo_carr_tdesc,cudo_area,"& vbcrlf & _
			   	" cast(DATEPART(year, cudo_finicio) as varchar) + '-' + cast(DATEPART(year, cudo_ftermino) as varchar) as rango_fecha, " & vbcrlf & _
			   	" protic.trunc(cudo_finicio) as cudo_finicio,protic.trunc(cudo_ftermino) as cudo_ftermino,cudo_tactividad,   " & vbcrlf & _   
        		" case isnull(cudo_anos_experiencia,0) " & vbcrlf & _ 
				" when 0 then " & vbcrlf & _ 
				" case " & vbcrlf & _ 
				" when DATEDIFF(month,cudo_finicio,cudo_ftermino)>=1 and  DATEDIFF(month,cudo_finicio,cudo_ftermino)<=5 then cast(DATEDIFF(month,cudo_finicio,cudo_ftermino) as varchar)+ ' Meses' " & vbcrlf & _
        		" when DATEDIFF(month,cudo_finicio,cudo_ftermino)<1 then cast(DATEDIFF(day,cudo_finicio,cudo_ftermino) as varchar)+ ' Dias' " & vbcrlf & _
        		" else cast(ceiling(DATEDIFF(month,cudo_finicio,cudo_ftermino)/cast(12 as decimal)) as varchar)+ ' Años'  end else cast(cudo_anos_experiencia as varchar) + ' Años' end as  cudo_anos_experiencia " & vbcrlf & _
				" From curriculum_docente" & vbcrlf & _
			   	" where cast(pers_ncorr as varchar)='"&pers_ncorr&"'" & vbcrlf & _
			   	" and tiex_ccod=2" & vbcrlf & _
			   	"order by cudo_finicio asc"
'response.Write("<pre>" & SqlExAcademica & "</pre>")
F_experiencia_aca.consultar SqlExAcademica
'------------------------------------------------------------------------------
set F_experiencia_lab = new CFormulario
F_experiencia_lab.Carga_Parametros "parametros.xml", "tabla"
F_experiencia_lab.inicializar conexion

SqlExLaboral = " Select '" & pers_ncorr & "' as pers_ncorr,cudo_ncorr,cudo_tinstitucion,cudo_tactividad, " & vbcrlf & _
			   " cudo_trubro_institucion,cudo_anos_experiencia,pais_tdesc,cudo_tdescripcion_experiencia," & vbcrlf & _
			   " cast(DATEPART(year, cudo_finicio) as varchar) + '-' + cast(DATEPART(year, cudo_ftermino) as varchar) as rango_fecha  " & vbcrlf & _
			   " from curriculum_docente a, paises b " & vbcrlf & _
			   " where cast(pers_ncorr as varchar)='" & pers_ncorr & "'" & vbcrlf & _
			   " and b.pais_ccod=a.pais_ccod " & vbcrlf & _
			   " and tiex_ccod=1 " & vbcrlf & _
			   "order by cudo_finicio asc"
'response.Write("<pre>" & SqlExLaboral & "</pre>")
F_experiencia_lab.consultar SqlExLaboral
'------------------------------------------------------------------------------
set F_publicaciones = new CFormulario
F_publicaciones.Carga_Parametros "parametros.xml", "tabla"
F_publicaciones.inicializar conexion

'SqlPublicaciones = " Select '" & pers_ncorr & "' as pers_ncorr,publ_ccod,protic.trunc(publ_fpublicacion) as publ_fpublicacion,tpub_ccod, "  & vbcrlf & _
'			   " publ_tdesc,publ_tmedio,publ_tautoria,pais_tdesc "  & vbcrlf & _
'			   " from publicacion_docente a,paises b "  & vbcrlf & _
'			   " where cast(pers_ncorr as varchar)='" & pers_ncorr & "'"  & vbcrlf & _
'			   " and tpub_ccod = 1 "  & vbcrlf & _
'			   " and a.pais_ccod *= b.pais_ccod "  & vbcrlf & _
'			   " order by publ_fpublicacion asc "
'--------------------------------------------------------------------------------------------INICIO CONSULTA SQLServer 2008
SqlPublicaciones = " select '" & pers_ncorr & "'            as pers_ncorr, " & vbcrlf &_
"       publ_ccod,                                                         " & vbcrlf &_
"       protic.trunc(publ_fpublicacion) as publ_fpublicacion,              " & vbcrlf &_
"       tpub_ccod,                                                         " & vbcrlf &_
"       publ_tdesc,                                                        " & vbcrlf &_
"       publ_tmedio,                                                       " & vbcrlf &_
"       publ_tautoria,                                                     " & vbcrlf &_
"       pais_tdesc                                                         " & vbcrlf &_
"from   publicacion_docente as a                                           " & vbcrlf &_
"       left outer join paises as b                                        " & vbcrlf &_
"                    on a.pais_ccod = b.pais_ccod                          " & vbcrlf &_
"where  cast(pers_ncorr as varchar) = '" & pers_ncorr & "'                 " & vbcrlf &_
"       and tpub_ccod = 1                                                  " & vbcrlf &_
"order  by publ_fpublicacion asc                                           "
'--------------------------------------------------------------------------------------------FIN CONSULTA SQLServer 2008			   
'response.Write("<pre>" & SqlPublicaciones & "</pre>")
F_publicaciones.consultar SqlPublicaciones

'------------------------------------------------------------------------------
set F_investigaciones = new CFormulario
F_investigaciones.Carga_Parametros "parametros.xml", "tabla"
F_investigaciones.inicializar conexion

'SqlInvestigaciones = " Select '" & pers_ncorr & "' as pers_ncorr,publ_ccod,protic.trunc(publ_fpublicacion) as publ_fpublicacion,tpub_ccod, "  & vbcrlf & _
'			   " publ_tdesc,publ_tmedio,publ_tautoria,pais_tdesc "  & vbcrlf & _
'			   " from publicacion_docente a,paises b "  & vbcrlf & _
'			   " where cast(pers_ncorr as varchar)='" & pers_ncorr & "'"  & vbcrlf & _
'			   " and tpub_ccod = 2 "  & vbcrlf & _
'			   " and a.pais_ccod *= b.pais_ccod "  & vbcrlf & _
'			   " order by publ_fpublicacion asc "
'--------------------------------------------------------------------------------------------INICIO CONSULTA SQLServer 2008
SqlInvestigaciones = " select '" & pers_ncorr & "'          as pers_ncorr, " & vbcrlf &_
"       publ_ccod,                                                         " & vbcrlf &_
"       protic.trunc(publ_fpublicacion) as publ_fpublicacion,              " & vbcrlf &_
"       tpub_ccod,                                                         " & vbcrlf &_
"       publ_tdesc,                                                        " & vbcrlf &_
"       publ_tmedio,                                                       " & vbcrlf &_
"       publ_tautoria,                                                     " & vbcrlf &_
"       pais_tdesc                                                         " & vbcrlf &_
"from   publicacion_docente as a                                           " & vbcrlf &_
"       left outer join paises as b                                        " & vbcrlf &_
"                    on a.pais_ccod = b.pais_ccod                          " & vbcrlf &_
"where  cast(pers_ncorr as varchar) = '" & pers_ncorr & "'                 " & vbcrlf &_
"       and tpub_ccod = 2                                                  " & vbcrlf &_
"order  by publ_fpublicacion asc                                           "
'--------------------------------------------------------------------------------------------FIN CONSULTA SQLServer 2008
'response.Write("<pre>" & SqlInvestigaciones & "</pre>")
F_investigaciones.consultar SqlInvestigaciones

'------------------------------------------------------------------------------
set F_actividades = new CFormulario
F_actividades.Carga_Parametros "parametros.xml", "tabla"
F_actividades.inicializar conexion

SqlActividades = " Select publ_totrasactividades "  & vbcrlf & _
			   " from publicacion_docente  "  & vbcrlf & _
			   " where cast(pers_ncorr as varchar)='" & pers_ncorr & "'"  & vbcrlf & _
			   " and tpub_ccod = 3 "  
'response.Write("<pre>" & SqlActividades & "</pre>")
F_actividades.consultar SqlActividades
'------------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "comp_ingreso.xml", "f_botonera"
f_botonera.inicializar conexion
%>

<html>
<head>
<title>Curriculum Docente</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<style>
@media print{ .noprint {visibility:hidden; }}
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
function imprimir()
{
  window.print();  
}

function salir()
{ //alert("yupiiiiiiiii");
  window.close();
  //window.opener.parent.top.location.reload();
}

</script>

</head>

<body onUnload="window.opener.parent.top.location.reload();">
<table width="95%" border="0">
   <tr> 
    <td><table width="630" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
          <th nowrap> <table width="100%" border="0" cellpadding="0">
              <tr> 
                <th nowrap> <table width="100%" border="0" cellpadding="2" cellspacing="0">
                    <tr> 
                      <td width="382" height="23"> <div align="center"></div></td>
                      <td width="113"><div align="center"><font size="1"><font size="1"></font></font></div></td>
                      <td><div align="center"><font size="3"><strong></strong></font></div></td>
                    </tr>
                    <tr> 
                      <td height="23" colspan="3"><font size="2"> <div align="center"><strong>UNIVERSIDAD DEL PACIFICO <BR> CURRICULUM DIRECTIVO DOCENTE</strong></div>
                        </font></td>
                    </tr>
                    <tr> 
                      <td height="23"><font size="1"> 
                        <div align="left"><strong>FORMULARIO 19</strong></div>
                        </font></td>
                      <td><div align="center"><font size="1"><font size="1"></font></font></div></td>
                      <td><div align="center"><font size="3"><strong></strong></font></div></td>
                    </tr>
                    <tr> 
                      <td colspan="3"> <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                          <tr> 
                            <td width="14%"><font size="2">&nbsp;Nombre</font></td>
                            <td colspan="2"><font size="2">&nbsp;<%=F_consulta_docente.ObtenerValor ("nombre_docente")%></font></td>
                          </tr>
                          <tr> 
                            <td><font size="2">&nbsp;Rut</font></td>
                            <td width="52%"><font size="2">&nbsp;<%=F_consulta_docente.ObtenerValor ("rut")%></font></td>
                            <td width="34%"><font size="2">&nbsp;Fecha Nac.&nbsp;<%=F_consulta_docente.ObtenerValor ("fecha_nac")%></font></td>
                          </tr>
                          <tr> 
                            <td><font size="2">&nbsp;Direcci&oacute;n</font></td>
                            <td colspan="2"><font size="2">&nbsp;<%=F_consulta_docente.ObtenerValor ("dire_tcalle")%>&nbsp;<%=F_consulta_docente.ObtenerValor ("dire_tnro")%>
                              <% if not Esvacio(F_consulta_docente.ObtenerValor ("dire_tblock")) then response.Write(" DEPTO " & F_consulta_docente.ObtenerValor ("dire_tblock"))%>
                              ,&nbsp;<%=F_consulta_docente.ObtenerValor ("ciud_tdesc")%></font></td>
                          </tr>
                          <tr> 
                            <td><font size="2">&nbsp;Fono</font></td>
                            <td><font size="2">&nbsp;<%=F_consulta_docente.ObtenerValor ("FONO")%></font></td>
                            <td><font size="2">&nbsp;Estado Civil:&nbsp;<%=F_consulta_docente.ObtenerValor ("eciv_tdesc")%></font></td>
                          </tr>
                          <tr> 
                            <td><font size="2">&nbsp;Nacionalidad</font></td>
                            <td><font size="2">&nbsp;<%=F_consulta_docente.ObtenerValor ("nacionalidad")%></font></td>
                            <td><font size="2">&nbsp;Tipo:&nbsp;<%=F_consulta_docente.ObtenerValor ("tipo_docente")%></font></td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr> 
                      <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td colspan="3"> </td>
                    </tr>
                    <tr> 
                      <td height="59" colspan="3"> 
					  <font size="2" ><strong>ANTECEDENTES ACADEMICOS PERSONALES</strong></font>
					  <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                          
                          <tr> 
                            <td width="40%"><strong><font size="2"><strong>Titulo(s) que posee</strong></font></strong></td>
                            <td width="40%"><strong><font size="2">Instituci&oacute;n</font></strong></td>
                            <td width="15%"><strong><font size="2">Pa&iacute;s</font></strong></td>
                            <td width="5%"><strong><font size="2">A&ntilde;o</font></strong></td>
                            
                          <tr> 
                            <% while F_academicos.Siguiente 
							v_cont_tit=v_cont_tit+1%>
                          <tr> 
                            <td><font size="1"><%=v_cont_tit%>.-&nbsp;<%=F_academicos.ObtenerValor("Nombre_TITULO")%></font></td>
                            <td><font size="1"><%=F_academicos.ObtenerValor("cudo_tinstitucion")%></font></td>
                            <td><font size="1"><%=F_academicos.ObtenerValor("pais_tdesc")%></font></td>
                            <td><font size="1"><%=F_academicos.ObtenerValor("cudo_ano_egreso")%></font></td>
                            
                          </tr>
                          <%wend%>
                        </table></td>
                    </tr>
                    <tr> 
                      <td colspan="3" height="5px">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td colspan="3"> <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">

                          <tr> 
                            <td width="40%"><strong><font size="2"><strong>Grado(s) que posee</strong></font></strong></td>
                            <td width="40%"><strong><font size="2">Instituci&oacute;n</font></strong></td>
                            <td width="15%"><strong><font size="2">Pa&iacute;s</font></strong></td>
                            <td width="5%"><strong><font size="2">A&ntilde;o</font></strong></td>
                          <tr> 
                          <% while F_grados_academicos.Siguiente 
						  v_cont_grad=v_cont_grad+1%>
                          <tr> 
                            
                            <td><font size="1"><%=v_cont_grad%>.-&nbsp;<%=F_grados_academicos.ObtenerValor("gpro_tdescripcion")%></font></td>
                            <td><font size="1"><%=F_grados_academicos.ObtenerValor("gpro_tinstitucion")%></font></td>
                            <td><font size="1"><%=F_grados_academicos.ObtenerValor("pais_tdesc")%></font></td>
                            <td><font size="1"><%=F_grados_academicos.ObtenerValor("gpro_ano_egreso")%></font></td>
                            
                          <tr> 
                            <%wend%>
                        </table></td>
                    </tr>
                    <tr> 
                      <td colspan="3" height="5px">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td colspan="3"> </td>
                    </tr>
        
                    <tr> 
                      <td colspan="3"> <font size="2"><strong>EXPERIENCIA ADMINISTRATIVA-ACADEMICA </strong></font>
					  <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                          <tr> 
                            <td width="30"><strong><font size="2">Cargos</font></strong></td>
                            <td width="30%"><strong><font size="2">Institucion</font></strong></td>
							<td width="30%"><strong><font size="2">Descripcion</font></strong></td>
                            <td width="10%"><strong><font size="2">Tiempo</font></strong></td>
							
                          <tr>
						  <% while F_experiencia_doc.Siguiente 
						  v_cont_doc=v_cont_doc+1 %> 
                          <tr> 
                            <td><font size="1"><%=v_cont_doc%>.-&nbsp;<%=F_experiencia_doc.ObtenerValor("cudo_tactividad")%></font></td>
                            <td><font size="1"><%=F_experiencia_doc.ObtenerValor("cudo_tinstitucion")%></font></td>
                            <td><font size="1"><%=F_experiencia_doc.ObtenerValor("cudo_tdescripcion_experiencia")%></font></td>
							<td><font size="1"><%=F_experiencia_doc.ObtenerValor("cudo_anos_experiencia")%></font></td>
                          <tr> 
						  <%wend%>
						  </table></td>
                    </tr>
                    <tr> 
                      <td colspan="3" height="5px">&nbsp;</td>
                    </tr>
					<tr>
					<td colspan="3">
					<font size="2"><strong>EXPERIENCIA ACADEMICA (Docencia, Investigaci&oacute;n y Extensi&oacute;n)</strong></font>
					<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                        
                          <tr> 
                            <td width="35"><strong><font size="2">Cargos</font></strong></td>
							<td width="30%"><strong><font size="2">Carrera/Facultad</font></strong></td>
                            <td width="30%"><strong><font size="2">Institucion</font></strong></td>
                            <td width="5%"><strong><font size="2">Tiempo</font></strong></td>
                          <tr>
						  <% while F_experiencia_aca.Siguiente 
						  v_cont_aca=v_cont_aca+1 %> 
                          <tr> 
                            <td><font size="1"><%=v_cont_aca%>.-&nbsp;<%=F_experiencia_aca.ObtenerValor("cudo_tactividad")%></font></td>
                            <td><font size="1"><%=F_experiencia_aca.ObtenerValor("cudo_carr_tdesc")%></font></td>
							<td><font size="1"><%=F_experiencia_aca.ObtenerValor("cudo_tinstitucion")%></font></td>
                            <td><font size="1"><%=F_experiencia_aca.ObtenerValor("cudo_anos_experiencia")%></font></td>
                          <tr> 
						  <%wend%>
						  </table></td>
					</tr>
					<tr>
					<td colspan="3" height="5px">&nbsp;</td>
					</tr>
					
                    <tr> 
                      <td colspan="3"> 
					  <font size="2"><strong>EXPERIENCIA PROFESIONAL</strong></font>	
					  <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                       
                          <tr> 
                            <td width="25%"><strong><font size="2">Instituci&oacute;n</font></strong></td>
							<td width="25%"><strong><font size="2">Actividad</font></strong></td>
                            <td width="40%"><strong><font size="2">Descripcion</font></strong></td>
							<td width="10%"><strong><font size="2">Rango</font></strong></td>
                          <tr>
						  <% while F_experiencia_lab.Siguiente 
						  	v_cont_prof=v_cont_prof+1 %>  
                          <tr> 
                            <td><font size="1"><%=v_cont_prof%>.-&nbsp;<%=F_experiencia_lab.ObtenerValor("cudo_tinstitucion")%></font></td>
                            <td><font size="1"><%=F_experiencia_lab.ObtenerValor("cudo_tactividad")%></font></td>
							<td><font size="1"><%=F_experiencia_lab.ObtenerValor("cudo_tdescripcion_experiencia")%></font></td>
							<td><font size="1"><%=F_experiencia_lab.ObtenerValor("rango_fecha")%></font></td>
                          <tr> 
						  <%wend%>
						  </table></td>
                    </tr>
                    <tr> 
                      <td colspan="3" height="5px">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td colspan="3"> 
					    <font size="2"><strong>PUBLICACIONES</strong></font>
					  <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
						  <tr> 
                          	<td  height="20">
						  <% while F_publicaciones.Siguiente 
						  	v_cont_pub=v_cont_pub+1 %>     
                          	<font size="1">
								<%=v_cont_pub%>.-&nbsp;
								<%=F_publicaciones.ObtenerValor("publ_tdesc")%>,&nbsp;&nbsp;
								<%=F_publicaciones.ObtenerValor("publ_tmedio")%>,&nbsp;&nbsp;
								<%=F_publicaciones.ObtenerValor("pais_tdesc")%>,&nbsp;&nbsp;
								<%=F_publicaciones.ObtenerValor("publ_fpublicacion")%>,&nbsp;&nbsp;
								<%=F_publicaciones.ObtenerValor("publ_tautoria")%>
							</font><br>
							
						  <%wend%>
						  	</td>
                          <tr> 
						  </table></td>
                    </tr>
                    <tr> 
                      <td colspan="3" height="5px">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td colspan="3"> 
					  <font size="2"><strong>PROYECTOS DE INVESTIGACION</strong></font>
					  <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
						  <tr> 
                            <td  height="20" >
						  <% while F_investigaciones.Siguiente 
						  	 v_cont_inv=v_cont_inv+1 %>  
							<font size="1">
									<%=v_cont_inv%>.-&nbsp;
									<%=F_investigaciones.ObtenerValor("publ_tdesc")%>,&nbsp;&nbsp; 
									<%=F_investigaciones.ObtenerValor("publ_tmedio")%>,&nbsp;&nbsp; 
									<%=F_investigaciones.ObtenerValor("pais_tdesc")%>,&nbsp;&nbsp; 
									<%=F_investigaciones.ObtenerValor("publ_fpublicacion")%>,&nbsp;&nbsp; 
									<%=F_investigaciones.ObtenerValor("publ_tautoria")%>
							</font><br>
						  <%wend%>
						  	</td>
                          <tr> 
						  </table></td>
                    </tr>
                    <tr> 
                      <td colspan="3" height="5px">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td colspan="3"> 
					  <font size="2"><strong>OTRAS ACTIVIDADES QUE DESARROLLA ACTUALMENTE</strong></font>
					  <table width="100%"  border="1" align="center" cellpadding="0" cellspacing="0">
						     
                          <tr> 
                            <td height="20">
							<% while F_actividades.Siguiente  
							v_cont_otras=v_cont_otras+1 %>
								<font size="1">
									<%=v_cont_otras%>.-&nbsp;
									<%=F_actividades.ObtenerValor("publ_totrasactividades")%>&nbsp;
								</font><br>
							 <%wend%>
							</td>
                          <tr> 
						 
                          </table></td>
                    </tr>
                </table></th>
              </tr>
            </table></th>
        </tr>
      </table></td>
 
  </tr>
  <tr> 
    <td>  <table class="noprint" width="100%" border="0">
            <tr> 
              <td> <div align="right"> 
                  <%f_botonera.dibujaboton "imprimir" %>
                </div></td>
              <td> <div align="left"> 
                  <% f_botonera.dibujaboton "cancelar"
		  %>
                </div></td>
            </tr>
          </table></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
</table>

</body>
</html>