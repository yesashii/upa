<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 150000
Response.AddHeader "Content-Disposition", "attachment;filename=contratos_caja.xls"
Response.ContentType = "application/vnd.ms-excel"
 
 '---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Contratos por caja"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

inicio			= request.querystring("busqueda[0][inicio]")
termino 		= request.querystring("busqueda[0][termino]")
v_sede_ccod  	= request.querystring("busqueda[0][sede_ccod]")
v_pers_ncorr 	= request.querystring("busqueda[0][pers_ncorr]")
v_periodo 		= request.querystring("busqueda[0][periodo]")

' INICIALIZA VARIABLES 
'---------------------------------

v_completo_nuevo_central=0
v_completo_nuevo_providencia=0
v_completo_nuevo_melipilla=0
v_completo_nuevo_bustamante=0
v_completo_nuevo_concepcion=0

v_completo_antiguo_central=0
v_completo_antiguo_providencia=0
v_completo_antiguo_melipilla=0
v_completo_antiguo_bustamante=0
v_completo_antiguo_concepcion=0

v_semestre_antiguo_central=0
v_semestre_antiguo_providencia=0
v_semestre_antiguo_melipilla=0
v_semestre_antiguo_bustamante=0
v_semestre_antiguo_concepcion=0


v_matricula_antiguo_central=0
v_matricula_antiguo_providencia=0
v_matricula_antiguo_melipilla=0
v_matricula_antiguo_bustamante=0
v_matricula_antiguo_concepcion=0

'Totales estados
v_total_nuevos_completos=0
v_total_antiguos_completos=0
v_total_antiguos_semestre=0
v_total_antiguos_matricula=0
' totales sedes
v_total_central=0
v_total_providencia	=0
v_total_melipilla=0
v_total_bustamante=0
v_total_concepcion=0
v_total_total=0

v_cae_central=0
v_cae_providencia=0
v_cae_melipilla=0
v_cae_bustamante=0
v_cae_concepcion=0

fecha_01 = conexion.ConsultaUno("Select protic.trunc(getdate())")



v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

set lista = new CFormulario
lista.carga_parametros "consulta.xml", "consulta"


if v_sede_ccod <> "" then
	filtro =" and  f.sede_ccod="&v_sede_ccod
end if


if v_pers_ncorr <> "" then
	filtro =filtro&" and  k.pers_ncorr="&v_pers_ncorr
end if

if inicio <> "" then
	if termino <> "" then
	filtro =filtro&" and  convert(datetime,j.mcaj_finicio,103)BETWEEN convert(datetime,'"&inicio&"',103) AND convert(datetime,'"&termino&"',103)"	
	else
	filtro =filtro&" and  protic.trunc(convert(datetime,j.mcaj_finicio,103))=protic.trunc(convert(datetime,'"&inicio&"',103)) "
	end if
end if


if v_periodo <> "0" then
	filtro =filtro&" and cast(d.peri_ccod as varchar)='"&v_peri_ccod&"' "
end if

' Ocupando las tablas sdescuentos como pase de matricula, (no estaba bien definido el pase matricula)
consulta = " Select p.sede_tdesc as sede_caja,j.sede_ccod,protic.trunc(j.mcaj_finicio) as fecha_apertura, isnull(a.mcaj_ncorr,0) as mcaj_ncorr,d.econ_ccod,d.contrato as n_contrato,g.sede_tdesc as sede, "& vbCrLf &_
			" protic.obtener_nombre_carrera(f.ofer_ncorr,'C') as carrera,h.jorn_tdesc as jornada,i.econ_tdesc as estado_contrato, "& vbCrLf &_
			" protic.obtener_nombre_completo(e.pers_ncorr,'n') as nombre_alumno, protic.trunc(d.cont_fcontrato) as fecha_contrato, "& vbCrLf &_
			" protic.obtener_rut(e.pers_ncorr) as rut_alumno,protic.obtener_nombre_completo(k.pers_ncorr,'n') as nombre_cajero, "& vbCrLf &_
			" Case e.post_bnuevo when 'S' then 'Nuevo' when 'N' then 'Antiguo' end as tipo_alumno, "& vbCrLf &_
            "  case when (select top 1 plec_ccod from periodos_academicos where peri_ccod=d.peri_ccod) = 1 then "& vbCrLf &_
            "      case     "& vbCrLf &_
		    "      when cast(isnull(m.sdes_nporc_colegiatura,999) as numeric)=0 then 'Completo'   "& vbCrLf &_
		    "      when cast(isnull(m.sdes_nporc_colegiatura,999) as numeric)=50 then 'Un Semestre'   "& vbCrLf &_
		    "      when cast(isnull(m.sdes_nporc_colegiatura,999) as numeric) between 51 and 100 then 'Solo Matricula'    "& vbCrLf &_
		    "      when cast(isnull(m.sdes_nporc_colegiatura,999) as numeric)=999 then 'Completo' end   "& vbCrLf &_
		    "  else "& vbCrLf &_
            "      case  "& vbCrLf &_
		    "       when cast(isnull(m.sdes_nporc_colegiatura,999) as numeric)between 0 and 50 then 'Un Semestre'   "& vbCrLf &_
		    "       when cast(isnull(m.sdes_nporc_colegiatura,999) as numeric) between 51 and 100 then 'Solo Matricula'   "& vbCrLf &_ 
		    "      when cast(isnull(m.sdes_nporc_colegiatura,999) as numeric)=999 then 'Un Semestre'  end "& vbCrLf &_
            "  end as tipo_contrato,   "& vbCrLf &_
			" Case (select count(*) from solicitud_credito_cae where post_ncorr=d.post_ncorr) when 1 then 'SI' else 'NO' end as solicita_cae, "& vbCrLf &_
			" Case (select count(*) from alumno_credito where post_ncorr=d.post_ncorr and tdet_ccod not in (1402)) when 1 then 'SI' else 'NO' end as beca_mineduc, "& vbCrLf &_
			" (select isnull(max(tdet_tdesc),' No registra información') from alumno_credito ac, tipos_detalle td where ac.post_ncorr=d.post_ncorr and ac.tdet_ccod=td.tdet_ccod and ac.tdet_ccod not in (1402)) nombre_beca_mineduc  "& vbCrLf &_                 
			" From  "& vbCrLf &_
			" ingresos a  "& vbCrLf &_
			" join abonos b  "& vbCrLf &_
			"     on a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_
			" join compromisos c "& vbCrLf &_
			"     on b.comp_ndocto=c.comp_ndocto "& vbCrLf &_
			"     and b.tcom_ccod=c.tcom_ccod "& vbCrLf &_
			"     and b.inst_ccod=c.inst_ccod "& vbCrLf &_
			" 	  and c.tcom_ccod in (1,2) "& vbCrLf &_
			" join contratos d "& vbCrLf &_
			"     on c.comp_ndocto=d.cont_ncorr "& vbCrLf &_
			" join postulantes e "& vbCrLf &_
			"     on d.post_ncorr=e.post_ncorr "& vbCrLf &_
			" join ofertas_academicas f "& vbCrLf &_
			"     on e.ofer_ncorr=f.ofer_ncorr    "& vbCrLf &_
			" join sedes g "& vbCrLf &_
			"     on f.sede_ccod=g.sede_ccod    "& vbCrLf &_     
			" join jornadas h "& vbCrLf &_
			"     on f.jorn_ccod=h.jorn_ccod   "& vbCrLf &_
			" join estados_contrato i "& vbCrLf &_
			"     on d.econ_ccod=i.econ_ccod   "& vbCrLf &_
			" join movimientos_cajas j "& vbCrLf &_
			"    on a.mcaj_ncorr=j.mcaj_ncorr "& vbCrLf &_
            "  join sedes p "& vbCrLf &_  
			"      on j.sede_ccod=p.sede_ccod "& vbCrLf &_
			" join cajeros k "& vbCrLf &_
			"    on j.caje_ccod=k.caje_ccod "& vbCrLf &_     
			" left outer join sdescuentos m "& vbCrLf &_
			"	on e.post_ncorr=m.post_ncorr "& vbCrLf &_
			"	and e.ofer_ncorr=m.ofer_ncorr "& vbCrLf &_
			"   and m.stde_ccod in (1262,1392) "& vbCrLf &_
			"   and m.esde_ccod =1 "& vbCrLf &_
			" where a.ting_ccod=7 "& vbCrLf &_
			" --and cast(d.peri_ccod as varchar)='"&v_peri_ccod&"' "& vbCrLf &_
			" and d.econ_ccod not in (2,3) "& vbCrLf &_
			" " &filtro&" "& vbCrLf &_
			" group by  f.ofer_ncorr,p.sede_tdesc,d.peri_ccod,j.sede_ccod,m.sdes_nporc_colegiatura,e.post_bnuevo,j.mcaj_finicio,e.pers_ncorr,k.pers_ncorr,d.cont_fcontrato,i.econ_tdesc,a.mcaj_ncorr,d.econ_ccod,d.post_ncorr,d.cont_ncorr,d.contrato,g.sede_tdesc,h.jorn_tdesc,protic.obtener_nombre_carrera(f.ofer_ncorr,'C'),protic.obtener_nombre_completo(e.pers_ncorr,'n') "& vbCrLf &_
			" order by tipo_alumno desc, g.sede_tdesc, carrera  "


lista.inicializar conexion 


'response.Write("<pre>"&consulta&"</pre>")		
'response.Write("<pre>Select Count(*) from ("&consulta&")a</pre>")	
if not Esvacio(Request.QueryString) then
	lista.Consultar consulta
	 
'	if lista.nroFilas > 0 then
'		'cantidad_encontrados=conexion.consultaUno("Select Count(*) from ("&consulta&")a")
'		cantidad_encontrados=lista.nroFilas
'	else
'		cantidad_encontrados=0
'	end if
	
else
	 lista.Consultar "select '' where 1=2"
	 lista.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
end if
%>
<html>
<head>
<title>Listado de alumnos contratados por día</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"><%=tituloPag%></font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="15%" colspan="2"><strong>Contratos del día </strong></td>
    <td width="85%" colspan="2"><strong>:</strong> <%=inicio %> </td>
  </tr>
  <tr>
    <td colspan="2"><strong>Fecha actual</strong></td>
    <td colspan="2"> <strong>:</strong> <%=fecha_01%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="2%" bgcolor="#FFFFCC" ><div align="center"><strong>N°</strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>N° Contrato</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Fecha contrato </strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Estado</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Rut</strong></div></td>
	<td width="15%" bgcolor="#FFFFCC" colspan="3"><div align="center"><strong>Nombre</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Sede Carrera </strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Jornada</strong></div></td>
	<td width="15%" bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
	<td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>Tipo Alumno</strong></div></td>
	<td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>Tipo Contrato</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Sede Caja</strong></div></td>			
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>N&deg; Caja</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Nombre cajero</strong></div></td>
	<td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>Fecha apertura</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Solicito Cae</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>Beca Mineduc</strong></div></td>
	<td width="6%" bgcolor="#FFFFCC"><div align="center"><strong>Nombre Beca</strong></div></td>	
  </tr>
  <% fila = 1 
     while lista.Siguiente %>
  <tr> 
    <td><div align="left"><%=fila%></div></td>
	<td><div align="center"><%=lista.ObtenerValor("n_contrato")%></div></td>
	<td><div align="center"><%=lista.ObtenerValor("fecha_contrato")%></div></td>
	<td><div align="center"><%=lista.ObtenerValor("estado_contrato")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("rut_alumno")%></div></td>
    <td colspan="3"><div align="left"><%=lista.ObtenerValor("nombre_alumno")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("jornada")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("tipo_alumno")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("tipo_contrato")%></div></td>	
	<td><div align="left"><%=lista.ObtenerValor("sede_caja")%></div></td>	
	<td><div align="left"><%=lista.ObtenerValor("mcaj_ncorr")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("nombre_cajero")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("fecha_apertura")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("solicita_cae")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("beca_mineduc")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("nombre_beca_mineduc")%></div></td>	
  </tr>
  <% fila = fila + 1  
  
  v_sede =lista.ObtenerValor("sede_ccod")
  v_nuevo=lista.ObtenerValor("tipo_alumno")
  v_tipo_contrato=lista.ObtenerValor("tipo_contrato")
  v_solicita_cae=lista.ObtenerValor("solicita_cae")
  
	  if v_sede="1" then
	  'response.Write("entro")
		 if v_nuevo="Nuevo" then
			v_nuevos_central=v_nuevos_central+ 1
		 else
			v_antiguos_central=v_antiguos_central+ 1
		 end if
		 
		 select case v_tipo_contrato
		 
			 case "Completo"
			  	if  v_nuevo="Nuevo" then
					v_completo_nuevo_central=v_completo_nuevo_central+1
				else
					v_completo_antiguo_central=v_completo_antiguo_central+1
				end if
				
			 case "Un Semestre"
			   if  v_nuevo="Nuevo" then
					v_completo_nuevo_central=v_completo_nuevo_central+1
				else
					v_semestre_antiguo_central=v_semestre_antiguo_central+1
				end if
				
			 case "Solo Matricula"
 			 	v_matricula_antiguo_central=v_matricula_antiguo_central+1
		 end select
		 
		 if v_solicita_cae="SI" then
		 	v_cae_central=v_cae_central+1
		 end if
		 
	  end if
	  
'******* SEDE PROVIDENCIA ************************************	  
	  if v_sede="2" then
	  
		 if v_nuevo="Nuevo" then
			v_nuevos_providencia=v_nuevos_providencia+ 1
		 else
			v_antiguos_providencia=v_antiguos_providencia+ 1
		 end if
		 
		 select case v_tipo_contrato
		 
			 case "Completo"
			  	if v_nuevo="Nuevo" then
					v_completo_nuevo_providencia=v_completo_nuevo_providencia+1
				else
					v_completo_antiguo_providencia=v_completo_antiguo_providencia+1
				end if
				
			 case "Un Semestre"
			 	v_semestre_antiguo_providencia=v_semestre_antiguo_providencia+1
				
			 case "Solo Matricula"
 			 	v_matricula_antiguo_providencia=v_matricula_antiguo_providencia+1
		 end select
		 
		 if v_solicita_cae="SI" then
		 	v_cae_providencia=v_cae_providencia+1
		 end if
		 
	  end if
	  
	  
'******* SEDE MELIPILLA ************************************
	  if v_sede="4" then
	  
		 if v_nuevo="Nuevo" then
			v_nuevos_melipilla=v_nuevos_melipilla+ 1
		 else
			v_antiguos_melipilla=v_antiguos_melipilla+ 1
		 end if
		 
		 select case v_tipo_contrato
		 
			 case "Completo"
			  	if v_nuevo="Nuevo" then
					v_completo_nuevo_melipilla=v_completo_nuevo_melipilla+1
				else
					v_completo_antiguo_melipilla=v_completo_antiguo_melipilla+1
				end if
				
			 case "Un Semestre"
			 	if v_nuevo="Nuevo" then
					v_completo_nuevo_melipilla=v_completo_nuevo_melipilla+1
				else
					v_semestre_antiguo_melipilla=v_semestre_antiguo_melipilla+1
				end if
				
			 case "Solo Matricula"
 			 	v_matricula_antiguo_melipilla=v_matricula_antiguo_melipilla+1
		 end select
		 
		 if v_solicita_cae="SI" then
		 	v_cae_melipilla=v_cae_melipilla+1
		 end if
		 
	  end if

'******* SEDE BUSTAMANTE ************************************
	  if v_sede="8" then
	  
		 if v_nuevo="Nuevo" then
			v_nuevos_bustamante=v_nuevos_bustamante+ 1
		 else
			v_antiguos_bustamante=v_antiguos_bustamante+ 1
		 end if
		 
		 select case v_tipo_contrato
		 
			 case "Completo"
			  	if v_nuevo="Nuevo" then
					v_completo_nuevo_bustamante=v_completo_nuevo_bustamante+1
				else
					v_completo_antiguo_bustamante=v_completo_antiguo_bustamante+1
				end if
				
			 case "Un Semestre"
			 	v_semestre_antiguo_bustamante=v_semestre_antiguo_bustamante+1
				
			 case "Solo Matricula"
 			 	v_matricula_antiguo_bustamante=v_matricula_antiguo_bustamante+1
		 end select
		 
		 if v_solicita_cae="SI" then
		 	v_cae_bustamante=v_cae_bustamante+1
		 end if
		 
	  end if

'******* SEDE BUSTAMANTE ************************************
	  if v_sede="7" then
	  
		 if v_nuevo="Nuevo" then
			v_nuevos_concepcion=v_nuevos_concepcion+ 1
		 else
			v_antiguos_concepcion=v_antiguos_concepcion+ 1
		 end if
		 
		 select case v_tipo_contrato
		 
			 case "Completo"
			  	if v_nuevo="Nuevo" then
					v_completo_nuevo_concepcion=v_completo_nuevo_concepcion+1
				else
					v_completo_antiguo_concepcion=v_completo_antiguo_concepcion+1
				end if
				
			 case "Un Semestre"
			 	v_semestre_antiguo_concepcion=v_semestre_antiguo_concepcion+1
				
			 case "Solo Matricula"
 			 	v_matricula_antiguo_concepcion=v_matricula_antiguo_concepcion+1
		 end select

		 if v_solicita_cae="SI" then
		 	v_cae_concepcion=v_cae_concepcion+1
		 end if
		 
	  end if


  wend 
  
  'Totales Parciales

  ' por sede
  v_total_central		=	v_completo_nuevo_central+v_completo_antiguo_central+v_semestre_antiguo_central+v_matricula_antiguo_central
  v_total_providencia	=	v_completo_nuevo_providencia+v_completo_antiguo_providencia+v_semestre_antiguo_providencia+v_matricula_antiguo_providencia
  v_total_melipilla		=	v_completo_nuevo_melipilla+v_completo_antiguo_melipilla+v_semestre_antiguo_melipilla+v_matricula_antiguo_melipilla
  v_total_bustamante	=	v_completo_nuevo_bustamante+v_completo_antiguo_bustamante+v_semestre_antiguo_bustamante+v_matricula_antiguo_bustamante
  v_total_concepcion	=	v_completo_nuevo_concepcion+v_completo_antiguo_concepcion+v_semestre_antiguo_concepcion+v_matricula_antiguo_concepcion

  v_total_cae			= v_cae_central+v_cae_providencia+v_cae_melipilla+v_cae_bustamante+v_cae_concepcion

  ' por estados
  v_total_nuevos_completos 		=	v_completo_nuevo_central+v_completo_nuevo_providencia+v_completo_nuevo_melipilla+v_completo_nuevo_bustamante+v_completo_nuevo_concepcion
  v_total_antiguos_completos	=	v_completo_antiguo_central+v_completo_antiguo_providencia+v_completo_antiguo_melipilla+v_completo_antiguo_bustamante+v_completo_antiguo_concepcion
  v_total_antiguos_semestre		=	v_semestre_antiguo_central+v_semestre_antiguo_providencia+v_semestre_antiguo_melipilla+v_semestre_antiguo_bustamante+v_semestre_antiguo_concepcion
  v_total_antiguos_matricula	=	v_matricula_antiguo_central+v_matricula_antiguo_providencia+v_matricula_antiguo_melipilla+v_matricula_antiguo_bustamante+v_matricula_antiguo_concepcion

 v_total_total=v_total_central+v_total_providencia+v_total_melipilla+v_total_bustamante+v_total_concepcion
  %>
</table>
<p>&nbsp;</p> 
<table width="100%" border="1">
  <tr>
    <th colspan="7">Resumen General</th>
  </tr>
  <tr>
    <td colspan="2"></td>
    <th bgcolor="#FFFFCC">NUEVOS</th>
    <th bgcolor="#FFFFCC" colspan="3">ANTIGUOS</th>
  </tr>
  <tr>
  	<th colspan="2"> Sede Caja </th>
    <th> Normal </th>
    <th>A&ntilde;o Completo </th>
    <th>1 Semestre</th>
    <th>Solo Matricula</th>
	<th>Totales</th>
	<th>CAE</th>
  </tr>
  <tr>
    <th colspan="2" align="left">Las Condes </th>
    <td align="center"> <%=v_completo_nuevo_central%> </td>
    <td align="center"><%=v_completo_antiguo_central%> </td>
    <td align="center"><%=v_semestre_antiguo_central%></td>
    <td align="center"><%=v_matricula_antiguo_central%></td>
	<td align="center"><%=v_total_central%></td>
	<td align="center"><%=v_cae_central%></td>
  </tr>
  <!--  <tr>
    <th colspan="2" align="left">Lyon</th>
    <td align="center"> <%=v_completo_nuevo_providencia%> </td>
    <td align="center"><%=v_completo_antiguo_providencia%> </td>
    <td align="center"><%=v_semestre_antiguo_providencia%></td>
    <td align="center"><%=v_matricula_antiguo_providencia%></td>
	<td align="center"><%=v_total_providencia%></td>
	<td align="center"><%=v_cae_providencia%></td>
  </tr>
  -->
  <tr >
    <th colspan="2" align="left">Melipilla</th>
    <td align="center"><%=v_completo_nuevo_melipilla%></td>
    <td align="center"><%=v_completo_antiguo_melipilla%> </td>
    <td align="center"><%=v_semestre_antiguo_melipilla%></td>
    <td align="center"><%=v_matricula_antiguo_melipilla%></td>
	<td align="center"><%=v_total_melipilla%></td>
	<td align="center"><%=v_cae_melipilla%></td>
  </tr>
  <!--
  <tr >
    <th colspan="2" align="left">Bustamante</th>
    <td align="center"><%=v_completo_nuevo_bustamante%></td>
    <td align="center"><%=v_completo_antiguo_bustamante%> </td>
    <td align="center"><%=v_semestre_antiguo_bustamante%></td>
    <td align="center"><%=v_matricula_antiguo_bustamante%></td>
	<td align="center"><%=v_total_bustamante%></td>
	<td align="center"><%=v_cae_bustamante%></td>
  </tr>
  <tr >
    <th colspan="2" align="left">Concepcion</th>
    <td align="center"><%=v_completo_nuevo_concepcion%></td>
    <td align="center"><%=v_completo_antiguo_concepcion%> </td>
    <td align="center"><%=v_semestre_antiguo_concepcion%></td>
    <td align="center"><%=v_matricula_antiguo_concepcion%></td>
	<td align="center"><%=v_total_concepcion%></td>
	<td align="center"><%=v_cae_concepcion%></td>
  </tr>  -->
  <tr bgcolor="#66FFFF">
    <th colspan="2">Totales</th>
    <th><%=v_total_nuevos_completos%></th>
    <th><%=v_total_antiguos_completos%></th>
    <th><%=v_total_antiguos_semestre%></th>
    <th><%=v_total_antiguos_matricula%></th>
	<th><%=v_total_total%></th>
	<td align="center"><%=v_total_cae%></td>
  </tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>