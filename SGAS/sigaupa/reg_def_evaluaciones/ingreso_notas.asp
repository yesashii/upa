<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Ingreso Notas"
set botonera =  new CFormulario
botonera.carga_parametros "notas.xml", "btn_ingreso_notas"
'for each k in request.querystring
'	response.Write(k&" = "&request.querystring(k)&"<br>")
'next

ip_usuario=Request.ServerVariables("REMOTE_ADDR")
'response.Write(ip_usuario)
'sesi_ccod =	request.QueryString("sesi_ccod")
cali_ncorr = request.QueryString("not[0][cali_ncorr]")
secc_ccod = request.QueryString("not[0][secc_tdesc]")
asig_tdesc = request.QueryString("not[0][secc_ccod]")
registros = 0
'response.Write("sesi_ccod"&sesi_ccod&"<br>")
'response.Write("cali_ncorr"&cali_ncorr&"<br>")
'response.Write("secc_ccod"&secc_ccod&"<br>")
'response.Write("asig_tdesc"&asig_tdesc&"<br>")

set conectar				=	new cconexion
set negocio					=	new cnegocio
set alumnos					=	new cformulario
set docente					=	new cformulario
set secciones				=	new cformulario
set nota					=	new cformulario
set datos_selecionados		=	new cformulario
set datos_no_selec			=	new cformulario
'-----------------------------------------------------------
set formbusqueda = new cformulario
set formsecciones = new cformulario
set formprofesores = new cformulario


formbusqueda.inicializar conectar
formsecciones.inicializar conectar 
formprofesores.inicializar conectar
'-----------------------------------------------------------
conectar.inicializar	"upacifico"
negocio.inicializa	conectar
sede=negocio.obtenersede
carrera= conectar.consultaUno("Select carr_tdesc from secciones a, carreras b where a.carr_ccod=b.carr_ccod and cast(a.secc_ccod as varchar)='"&secc_ccod&"'")

usuario = negocio.obtenerUsuario
periodo = negocio.obtenerperiodoacademico("PLANIFICACION")

profe_temp = conectar.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='"&usuario&"'")

alumnos.inicializar					conectar
docente.inicializar					conectar
secciones.inicializar				conectar
nota.inicializar					conectar
datos_selecionados.inicializar		conectar
datos_no_selec.inicializar			conectar

alumnos.carga_parametros			"notas.xml","alumnos"
docente.carga_parametros			"notas.xml","docente"
secciones.carga_parametros			"notas.xml","secciones"
nota.carga_parametros				"notas.xml","notas"
datos_selecionados.carga_parametros	"paulo.xml","tabla"	
datos_no_selec.carga_parametros		"paulo.xml","tabla"

'_______________________________________________________________________________________________________________________________________________
formbusqueda.carga_parametros "notas.xml", "busqueda"
formsecciones.carga_parametros "notas.xml", "secciones_J"
formprofesores.carga_parametros "notas.xml", "profesores"

PerSel=conectar.consultauno("select peri_tdesc  from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

Sql="select pers_ncorr from personas where cast(pers_nrut as varchar)='"&negocio.obtenerUsuario&"'"
pers_ncorr=conectar.consultaUno(Sql)

sedeprofesor=   " select distinct  cast(a.pers_ncorr as varchar) +' '+ cast(a.sede_ccod as varchar)+' '+ e.sede_tdesc as profesor_sede, "& _
				" e.sede_tdesc as sede,d.peri_ccod  "& _
				" from profesores a,bloques_profesores b, "& _
				" bloques_horarios c,secciones d, sedes e "& _
				" where a.pers_ncorr = b.pers_ncorr "& _
				" and a.sede_ccod = b.sede_ccod " & _
				" and b.bloq_ccod = c.bloq_ccod "& _
				" and c.secc_ccod = d.secc_ccod "& _
				" and a.sede_ccod = e.sede_ccod "& _
				" and cast(d.peri_ccod as varchar)='"&periodo&"' "& _
				" and cast(b.pers_ncorr as varchar)= '"&pers_ncorr&"' " 

consprofesor = "select '"&request.QueryString("not[0][sede_ccod]")&"' as sede_ccod"

formprofesores.consultar consprofesor
formprofesores.agregacampoparam "sede_ccod","destino","("& sedeprofesor &")aa"   
formprofesores.siguiente

consulta="select '"&request.QueryString("not[0][secc_ccod]")&"' as secc_ccod"
formbusqueda.consultar consulta
formbusqueda.agregacampocons "secc_ccod", asig_tdesc
formbusqueda.siguiente

consulta2="select '"&request.QueryString("not[0][secc_tdesc]")&"' as secc_tdesc"
formsecciones.consultar consulta2
formsecciones.siguiente

asignaturas=" select distinct a.sede_ccod,e.asig_ccod,e.asig_tdesc, a.pers_ncorr from  " & _
			" profesores a, bloques_profesores b, " & _
			" bloques_horarios c,secciones d, asignaturas e " & _
			" where a.pers_ncorr =  b.pers_ncorr  " & _
			" and a.sede_ccod = b.sede_ccod " & _
			" and b.bloq_ccod = c.bloq_ccod  " & _
			" and c.secc_ccod = d.secc_ccod " & _
			" and d.asig_ccod = e.asig_ccod  " & _
			" and cast(d.peri_ccod as varchar)= '"&periodo&"'" & _
			" and cast(a.pers_ncorr as varchar)= '"&pers_ncorr&"' " & _
			" order by asig_tdesc "



conectar.Ejecuta asignaturas
set rec_asignaturas = conectar.ObtenerRS

Secciones_J =" select distinct a.pers_ncorr,d.sede_ccod, " & _
			" d.secc_ccod,d.secc_tdesc, " & _
			" e.asig_ccod,e.asig_tdesc, d.secc_tdesc + ' - ' + isnull(f.carr_tsigla,'-') + ' ' + case d.jorn_ccod when 1 then '(D)' when 2 then '(V)' else '' end as descripcion " & _
			" from " & _
			" profesores a, bloques_profesores b, " & _
			" bloques_horarios c,secciones d,asignaturas e, carreras f " & _
			" where a.pers_ncorr = b.pers_ncorr " & _
			" and a.sede_ccod = b.sede_ccod " & _
			" and b.bloq_ccod = c.bloq_ccod " & _
			" and c.secc_ccod = d.secc_ccod " & _
			" and d.asig_ccod = e.asig_ccod " & _
			" and d.carr_ccod = f.carr_ccod " & _
			" and cast(d.peri_ccod as varchar)= '"&periodo&"' " & _
			" and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' " 


conectar.Ejecuta Secciones_J
set rec_secciones = conectar.ObtenerRS

set f_asignatura = new CFormulario
f_asignatura.Carga_Parametros "agregar_evaluacion.xml", "f_datos_asignaturas"
f_asignatura.Inicializar conectar
dotos_asignatura=   " select a.asig_ccod,a.secc_tdesc + ' - ' + isnull(e.carr_tsigla,'-') + ' ' + case a.jorn_ccod when 1 then '(DIURNA)' when 2 then '(VESPERTINA)' else '' end as secc_tdesc,d.tasg_tdesc," & _
	                " b.asig_tdesc,b.asig_nhoras,c.sede_tdesc " & _
					" from secciones a,asignaturas b, sedes c,tipos_asignatura d, carreras e" & _
					" where  a.asig_ccod=b.asig_ccod and" & _
					"	     a.sede_ccod=c.sede_ccod and " & _
					"        a.carr_ccod = e.carr_ccod and " & _
					"	   	 isnull(a.tasg_ccod,b.tasg_ccod)=d.tasg_ccod and    " & _					
					"	     cast(a.secc_ccod as varchar)='"&secc_ccod&"' " & _
					" and cast(a.peri_ccod as varchar)='"&periodo&"'"


		
f_asignatura.Consultar dotos_asignatura
f_asignatura.Siguiente
asig_ccod=f_asignatura.obtenervalor("asig_ccod")

'_______________________________________________________________________________________________________________________________________________

consulta_secciones=" select distinct b.secc_ccod,cast(b.asig_ccod as varchar)+' '+c.asig_tdesc +' Sección '+ isnull(b.secc_tdesc,'') as curso " & vbCrlf & _
				"	 from  " & vbCrlf & _
				"		bloques_horarios a,secciones b,asignaturas c " & vbCrlf & _
				"	 where a.secc_ccod=b.secc_ccod " & vbCrlf & _
				"		 and b.asig_ccod=c.asig_ccod " & vbCrlf & _
				"		 and cast(peri_ccod as varchar)= '"& periodo &"'  " & vbCrlf & _
				"		 and cast(pers_ncorr as varchar)=   '"& pers_ncorr &"' " 
		'		"		 and b.sede_ccod='"& sede &"' "' sacar variable en duro

'---------------------------------------------------------------------------------------------------
seccion	=	"select '' as curso, '' as secc_ccod "

secciones.consultar		seccion
	secciones.agregacampoparam	"secc_ccod","destino", "("& consulta_secciones &") a"
if usuario <> "" or not isnull(usuario) then 
	secciones.agregacampocons	"secc_ccod", secc_ccod
else
	secciones.agregacampocons	"secc_ccod", " "
end if
secciones.siguiente
'---------------------------------------------------------------------------------------------------
if (secc_ccod <> "" or not isnull(secc_ccod))then
	ponderacion	= conectar.consultauno("select isnull(sum(cali_nponderacion),0.0) as ponderacion from calificaciones_seccion where cast(secc_ccod as varchar)='"& secc_ccod &"'")
	ponderacion = conectar.consultaUno("select replace('"&ponderacion&"',',','.')")
	asig_ccod = conectar.consultauno("select asig_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
end if
'response.Write(ponderacion)

'-----------------------si la asignatura es anual y el periodo es priemr sem 2006 no considere estados matr. 
'---------------------------si es semestral o trimestral y el periodo mayor a 202 entonces no considere matr.
duracion_asig = conectar.consultaUno("select duas_ccod from asignaturas where asig_ccod ='"&asig_ccod&"'")
filtro_matr = " and b.emat_ccod in (1,2,16) "
if duracion_asig = "3" and periodo >= "202" then
	filtro_matr = " "
elseif (duracion_asig = "1" or duracion_asig ="2") and periodo > "202" then
    filtro_matr = " "
end if
'-----------------------------------------------------------------------------------------------------------



consulta_alumnos="select  " & vbCrlf & _
					" c.matr_ncorr,isnull(c.estado_cierre_ccod,1)as estado_cierre_ccod, " & vbCrlf & _
				    " case d.cali_njustificacion when 1 then '<font color=red>' + cast(a.pers_nrut as varchar) +' - ' + a.pers_xdv + '</font>' else  " & vbCrlf & _
					" cast(a.pers_nrut as varchar) +' - ' + a.pers_xdv end as rut," & vbCrlf & _
					" case d.cali_njustificacion when 1 then '<font color=red>' + pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre + '</font>' else  " & vbCrlf & _
					" pers_tape_paterno + ' '+ pers_tape_materno + ', ' + pers_tnombre end as alumno," & vbCrlf & _
					" protic.initCap(pers_tape_paterno + ' '+ pers_tape_materno + ', ' + pers_tnombre) as alumno_oculto, " & vbCrlf & _
					" (select top 1 lower(email_nuevo) from cuentas_email_upa tt where tt.pers_ncorr=a.pers_ncorr) as email," & vbCrlf & _
  					" replace(case cala_nnota when null then '1.0' when '1' then '1.0' when '2' then '2.0' when '3' then '3.0' when '4' then '4.0' when '5' then '5.0' when '6' then '6.0' when '7' then '7.0' else cala_nnota end,',','.') as cala_nnota,cast(isnull(d.cala_nnota,0) as decimal(2,1)) as nfinal2,   " & vbCrlf & _
					" d.cali_njustificacion" & vbCrlf & _
					"	from  " & vbCrlf & _
					"		personas a join alumnos b " & vbCrlf & _
					"       	on a.pers_ncorr=b.pers_ncorr " & vbCrlf & _
					"       join cargas_academicas c " & vbCrlf & _
					"			on b.matr_ncorr=c.matr_ncorr " & vbCrlf & _
					"		join calificaciones_seccion e " & vbCrlf & _
					"			on e.secc_ccod = c.secc_ccod and cast(e.cali_ncorr as varchar)='"&cali_ncorr&"' " & vbCrlf & _
					"		left outer join calificaciones_alumnos d " & vbCrlf & _
					"           on c.secc_ccod=d.secc_ccod and c.matr_ncorr=d.matr_ncorr and  e.cali_ncorr = d.cali_ncorr" & vbCrlf & _			
					"	where  c.carg_nsence is null  "& filtro_matr & vbCrlf & _
					"		and cast(c.secc_ccod as varchar) =	'"& secc_ccod &"' " & vbCrlf & _
					"		and c.matr_ncorr not in (select matr_ncorr_destino from resoluciones_homologaciones  where cast(secc_ccod_destino as varchar)='"&secc_ccod&"') " & vbCrlf & _				
					"		and c.matr_ncorr not in (select matr_ncorr from convalidaciones where matr_ncorr=c.matr_ncorr and cast(asig_ccod as varchar)='"&asig_ccod&"') " & vbCrlf & _
					"		and (c.sitf_ccod<>'EE' or sitf_ccod is null)" 
					

'response.write("<pre>"&consulta_alumnos&"</pre>")
'response.end()
if ((secc_ccod <> "" or not isempty(secc_ccod)) or (cali_ncorr <> "" or not isempty(cali_ncorr))) then
cons_datos_sel="select cali_ncorr, convert(datetime,cali_fevaluacion,103) as fecha from calificaciones_seccion where cast(cali_ncorr as varchar)='"&cali_ncorr&"'"
cons_datos_nsel="select cali_ncorr, convert(datetime,cali_fevaluacion,103) as fecha from calificaciones_seccion where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(cali_ncorr as varchar) not in ('"& cali_ncorr &"') and cali_fevaluacion < convert(datetime,case '"& cali_ncorr &"' when '' then '' else '"&conectar.consultauno("select convert(datetime,cali_fevaluacion,103) as fecha from calificaciones_seccion where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(cali_ncorr as varchar)='"& cali_ncorr &"'")&"' end,103) order by fecha"
'response.Write(cons_datos_nsel&"<br>")
datos_selecionados.consultar		cons_datos_sel
datos_no_selec.consultar			cons_datos_nsel

 dim existe()
	if (datos_selecionados.nrofilas > 0) then
		for i=0 to datos_selecionados.nrofilas - 1
			datos_selecionados.siguiente
			for k=0 to datos_no_selec.nrofilas - 1
				redim preserve existe(k)
				datos_no_selec.siguiente
				existe(k)=conectar.consultauno("select count(*) from calificaciones_alumnos where cali_ncorr in ('"&datos_no_selec.obtenervalor("cali_ncorr")&"') and audi_tusuario not like '%MIGRACION%'")
			next
		next
	end if

	if  datos_no_selec.nrofilas > 0 and not (isnull(datos_no_selec.nrofilas)) then
		no_permite=1
		for k_=0 to datos_no_selec.nrofilas - 1
			if existe(k_) <= 0 then
				no_permite=0
			else
				no_permite=no_permite + 1
			end if
		next
	else
		no_permite=1
	end if

if (no_permite=0 and no_permite<>"") then 
%>
<script language="JavaScript">
	alert('No puede ingresar nota.\nPorque alguna de las evaluaciones anteriores no presenta notas ingresadas.');
</script>	
<%
end if

consulta_nota	="  select cali_ncorr, " & vbCrlf & _
				"	cast(case cali_nevaluacion when null then 'PN' else cali_nevaluacion end as varchar) +' - '+ cast(protic.trunc(cali_fevaluacion)as varchar)+' - '+ teva_tdesc  as cali_nevaluacion  " & vbCrlf & _
				"	from calificaciones_seccion a, tipos_evaluacion b " & vbCrlf & _
				"	where  " & vbCrlf & _
				"	a.teva_ccod=b.teva_ccod " & vbCrlf & _
				" 	and cast(a.secc_ccod as varchar)='"& secc_ccod &"'  " 

'response.Write("<pre>"&consulta_nota&"</pre>")
nro_evaluaciones	=	conectar.consultauno("Select count(*)  from ("&consulta_nota&")t")

if (cali_ncorr <> "" )then
nro_nota	=	conectar.consultauno("select cali_nevaluacion from calificaciones_seccion where cast(cali_ncorr as varchar)='"& cali_ncorr &"'")

alumnos.consultar	consulta_alumnos & " order by pers_tape_paterno, pers_tape_materno, pers_tnombre"
alumnos.agregacampoparam	"cala_nnota","descripcion","Nota "&nro_nota
end if

registros	=	conectar.consultauno("select count(*)  from ("& consulta_alumnos &")r")
'response.Write(registros)

notas	=	"select '' as cali_ncorr "
nota.consultar	notas

nota.agregacampoparam	"cali_ncorr",	"destino", "("& consulta_nota &")m"
nota.agregacampocons	"cali_ncorr",	cali_ncorr

if  nota.nrofilas > 0 then
nota.siguiente
end if
if (ponderacion <> 100 )  then 
 ' response.Write("error nota bajo el 100%")
  %>
		<script language="JavaScript">
			alert('No puede ingresar notas.\nNo está completo el 100% de las calificaciones');
		</script>
	<%
	end if



correspondencia	=	conectar.consultauno("select count(*) from ("& consulta_nota &")j")

	if correspondencia = 0 then
		cali_ncorr=""
	end if
end if

'asignatura cerrada-----------------
asig_cerrada = conectar.consultaUno("select isnull(estado_cierre_ccod,1) from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")

if secc_ccod <> "" then
	jorn_ccod = conectar.consultaUno("select jorn_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
	es_anual = conectar.consultaUno("select count(*) from secciones a, asignaturas b where cast(secc_ccod as varchar)='"&secc_ccod&"' and a.asig_ccod=b.asig_ccod and b.duas_ccod = 3")
end if


fecha_parcial = conectar.consultaUno("select top 1 protic.trunc(audi_fmodificacion) as fecha from calificaciones_alumnos where cast(secc_ccod as varchar)='"&secc_ccod&"' order by audi_fmodificacion desc")
fecha_final = conectar.consultaUno("select top 1 protic.trunc(audi_fmodificacion) as fecha from cargas_academicas where cast(secc_ccod as varchar)='"&secc_ccod&"' order by audi_fmodificacion desc")



anos_ccod = conectar.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
'response.Write(anos_ccod)
bloqueado_cambio = false
if anos_ccod < "2007" then
	 bloqueado_cambio = true
else
	sys_cierra_notas = false	 
end if

if ip_usuario="172.16.100.82" OR ip_usuario="172.16.16.163" OR ip_usuario="10.10.2.17" OR ip_usuario="10.10.2.184" OR ip_usuario="172.16.16.165" then
	autorizar = true
end if
'response.Write("ip_usuario "&ip_usuario&"</br>")
'response.Write("autorizar2 "&autorizar)
'autorizar = true
'response.Write(bloqueado_cambio)
bloquear_todo = "N"
carr_seccion = conectar.consultaUno("select ltrim(rtrim(carr_ccod)) from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
if anos_ccod < "2010" then
	if jorn_ccod="1" and autorizar=false and es_anual="0" then
		bloquear_todo= conectar.consultaUno("select case when convert(datetime,getDate(),103) >= convert(datetime,'01/01/2009',103) then 'S' else 'N' end ")
	elseif jorn_ccod="2" and autorizar=false  and es_anual="0"  then
		bloquear_todo= conectar.consultaUno("select case when convert(datetime,getDate(),103) >= convert(datetime,'01/01/2009',103) then 'S' else 'N' end ")
	end if
	
	if carr_seccion="7" and (anos_ccod="2008" or anos_ccod="2007" or anos_ccod="2009") then
		bloquear_todo = "N"
		autorizar = true
	end if
		
end if
'if anos_ccod = "2008" then
'	bloquear_todo="N"
'end if

if anos_ccod = "2011" then
	if secc_ccod <> "" and periodo <> "" then
		duracion_asignatura = conectar.consultaUno("select b.duas_ccod from secciones a, asignaturas b where a.asig_ccod=b.asig_ccod and cast(secc_ccod as varchar)='"&secc_ccod&"'")
		plec_ccod = conectar.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
		sede_ccod = conectar.consultaUno("select sede_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
		
		if plec_ccod="1" then
			bloquear_todo = "N"
		end if
		
		if sede_ccod <> "4" then 
			fecha_cierre= conectar.consultaUno("select case when convert(datetime,protic.trunc(getDate()),103) > convert(datetime,'24/07/2011',103) then 'S' else 'N' end ")
		else
			fecha_cierre= conectar.consultaUno("select case when convert(datetime,protic.trunc(getDate()),103) > convert(datetime,'24/07/2011',103) then 'S' else 'N' end ")
		end if
		
		if fecha_cierre="N" then
			bloquear_todo = "N"
		else
			bloquear_todo = "S"	
		end if
		
		if carr_seccion="7" or carr_seccion="500" or carr_seccion="400" or carr_seccion="600" then
			bloquear_todo = "N"
			'autorizar = true
		end if
		
		if carr_seccion="900" then
			bloquear_todo = "N"
		end if
		
		if plec_ccod="2" then
			bloquear_todo = "N"
		end if
		
	end if
end if
'-----------------------------------agregado para listados resumenes e intervalos de notas.-
if (cali_ncorr <> "" )then
	contador_total = 0
	nota_promedio =  cdbl("0,0")
	menores_a_4 = 0
	mayores_a_4 = 0
	entre_1_2 = 0
	entre_2_3 = 0
	entre_3_4 = 0
	entre_4_5 = 0
	entre_5_6 = 0
	entre_6_7 = 0
    while alumnos.siguiente 
		contador_total = contador_total + 1
		nota_promedio = cdbl(nota_promedio) + cdbl(alumnos.obtenerValor("nfinal2"))
		if cdbl(alumnos.obtenerValor("nfinal2")) < cdbl("4,0") then
				menores_a_4 = menores_a_4 + 1
		else
				mayores_a_4 = mayores_a_4 + 1		
		end if		
		
		if ((cdbl(alumnos.obtenerValor("nfinal2")) >= cdbl("1,0"))and (cdbl(alumnos.obtenerValor("nfinal2")) < cdbl("2,0"))) then
			entre_1_2 = entre_1_2 + 1
		elseif ((cdbl(alumnos.obtenerValor("nfinal2")) >= cdbl("2,0"))and (cdbl(alumnos.obtenerValor("nfinal2")) < cdbl("3,0"))) then
			entre_2_3 = entre_2_3 + 1
		elseif ((cdbl(alumnos.obtenerValor("nfinal2")) >= cdbl("3,0"))and (cdbl(alumnos.obtenerValor("nfinal2")) < cdbl("4,0"))) then
			entre_3_4 = entre_3_4 + 1		
		elseif ((cdbl(alumnos.obtenerValor("nfinal2")) >= cdbl("4,0"))and (cdbl(alumnos.obtenerValor("nfinal2")) < cdbl("5,0"))) then
			entre_4_5 = entre_4_5 + 1
		elseif ((cdbl(alumnos.obtenerValor("nfinal2")) >= cdbl("5,0"))and (cdbl(alumnos.obtenerValor("nfinal2")) < cdbl("6,0"))) then
			entre_5_6 = entre_5_6 + 1		
		elseif ((cdbl(alumnos.obtenerValor("nfinal2")) >= cdbl("6,0"))and (cdbl(alumnos.obtenerValor("nfinal2")) <= cdbl("7,0"))) then
			entre_6_7 = entre_6_7 + 1	
		end if	
	wend
alumnos.primero
'response.Write(nota_promedio & "contador_total "&contador_total)

if contador_total <> 0 then
	promedio_curso = formatnumber((cdbl(nota_promedio) / cdbl(contador_total)),1,-1,0,0)
	valor = (menores_a_4 * 100) / contador_total
	porc_menores_a_4 = formatnumber(valor,2)
else
	promedio_curso = 0
	porc_menores_a_4 = 0
end if		


cantidad_retirados = conectar.consultaUno ("select count(*) from cargas_academicas a, alumnos b where cast(a.secc_Ccod as varchar)='"&secc_ccod&"' and a.matr_ncorr=b.matr_ncorr and b.emat_ccod not in (1,2,4,8)")
'response.Write("<br>prom "&promedio_curso& " menores_a_4 "&menores_a_4&" mayores_a_4 "&mayores_a_4&" retirados "&cantidad_retirados)

end if 

bloquear_botones ="N"
if anos_ccod >= "2007" and secc_ccod <> "" then 
'response.Write("entre")
	porce_asignado = conectar.consultaUno("select isnull(secc_porce_asiste,0) from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
	if porce_asignado = "0" then
	bloquear_botones="S"
	%>
		<script language="JavaScript">
			alert('No puede ingresar notas.\nAún no se ha agregado información del porcentaje de asistencia necesario para aprobar la asignatura.(Esto se ingresa en definición de evaluaciones)');
		</script>
	<%
	end if
end if

'response.Write("autorizar  "&autorizar&"</br>")
'response.Write("bloqueado_cambio "&bloqueado_cambio&"</br>")
'response.Write("bloquear todo "&bloqueado_todo)
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
<!--
<!--  ----------------------------------------------------------------------------------------
rec_asignaturas = new Array();

<%
if (rec_asignaturas.BOF <> rec_asignaturas.EOF) then

rec_asignaturas.MoveFirst
i = 0
while not rec_asignaturas.Eof
%>
rec_asignaturas[<%=i%>] = new Array();
rec_asignaturas[<%=i%>]["pers_ncorr"] = '<%=rec_asignaturas("pers_ncorr")%>';
rec_asignaturas[<%=i%>]["asig_ccod"] = '<%=rec_asignaturas("asig_ccod")%>';
rec_asignaturas[<%=i%>]["asig_tdesc"] = '<%=rec_asignaturas("asig_tdesc")%>';
rec_asignaturas[<%=i%>]["sede_ccod"] = '<%=rec_asignaturas("sede_ccod")%>';

<%	
	rec_asignaturas.MoveNext
	i = i + 1
wend
end if
%>

rec_secciones = new Array();
<%

if (rec_secciones.BOF <> rec_secciones.EOF) then
rec_secciones.MoveFirst
j = 0
while not rec_secciones.Eof
%>
rec_secciones[<%=j%>] = new Array();
rec_secciones[<%=j%>]["pers_ncorr"] = '<%=rec_secciones("pers_ncorr")%>';
rec_secciones[<%=j%>]["asig_ccod"] = '<%=rec_secciones("asig_ccod")%>';
rec_secciones[<%=j%>]["asig_tdesc"] = '<%=rec_secciones("asig_tdesc")%>';
rec_secciones[<%=j%>]["sede_ccod"] = '<%=rec_secciones("sede_ccod")%>';
rec_secciones[<%=j%>]["secc_tdesc"] = '<%=rec_secciones("secc_tdesc")%>';
rec_secciones[<%=j%>]["secc_ccod"] = '<%=rec_secciones("secc_ccod")%>';
rec_secciones[<%=j%>]["descripcion"] = '<%=rec_secciones("descripcion")%>';


<%	
	rec_secciones.MoveNext
	j = j + 1
wend
end if
%>

function CargarAsignaturas(formulario, profesor_sede)
{
 var cadena, pers_ncorr, sede_ccod
 cadena=profesor_sede.split(" ");
 pers_ncorr=cadena[0];
 sede_ccod=cadena[1];
	
	formulario.elements["not[0][secc_ccod]"].length = 0;
	
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "-- Seleccione Una Asignaturas --";
	formulario.elements["not[0][secc_ccod]"].add(op)
	
	for (i = 0; i < rec_asignaturas.length; i++) {
		if ((rec_asignaturas[i]["pers_ncorr"] == pers_ncorr) && (rec_asignaturas[i]["sede_ccod"] == sede_ccod)) {
			op = document.createElement("OPTION");
			op.value =  rec_asignaturas[i]["asig_ccod"];
			op.text = rec_asignaturas[i]["asig_ccod"]+"-"+rec_asignaturas[i]["asig_tdesc"];
			formulario.elements["not[0][secc_ccod]"].add(op)
		}
	}	
}
function InicioPagina(formulario)
{
/*formulario = document.busqueda;*/
a="<%=asig_tdesc%>"
if (a !="")
{
CargarAsignaturas(formulario, formulario.elements["not[0][sede_ccod]"].value)
formulario.elements["not[0][secc_ccod]"].value = "<%=asig_tdesc%>";

CargarSecciones(formulario,formulario.elements["not[0][secc_ccod]"].value)

if ('<%=secc_ccod%>' != '') {
	formulario.elements["not[0][secc_tdesc]"].value = "<%=secc_ccod%>";
}

sec=formulario.elements["not[0][secc_tdesc]"].value;
}
	
}



function cambiarperiodo(formulario){
	   formulario.action = 'matar_sesion.asp'
   	   formulario.submit();
}

function inicio (formulario){
	if ('<%=cali_ncorr%>'!=''){
		for (I=0;I<<%=registros%>;I++){
			if(formulario.elements["not["+I+"][estado_cierre_ccod]"].value!="1" ){
				//debe ser true pero como solo un par de pc puden hacer este cambio se deja deshabilitado (Msandoval)
			   formulario.elements["not["+I+"][cala_nnota]"].setAttribute("disabled",false)

			}	
		}	

	}	

}
 
function CargarSecciones(formulario,asig_ccod){
var cadena,cadena2, pers_ncorr, sede_ccod
 cadena= formulario.elements["not[0][sede_ccod]"].value.split(" ");
 cadena2=asig_ccod.split(" ");
 pers_ncorr=cadena[0];
 sede_ccod=cadena[1];
 asig=cadena2[0];
 formulario.elements["not[0][secc_tdesc]"].length = 0;
//asig_ccod=formulario.elements["m[0][secc_ccod]"].value

	op2 = document.createElement("OPTION");
	op2.value = "-1";
	op2.text = "-- Secciones --";
	formulario.elements["not[0][secc_tdesc]"].add(op2)
	
	
	for (i = 0; i < rec_secciones.length; i++) {
		if ((rec_secciones[i]["pers_ncorr"] == pers_ncorr) && (rec_secciones[i]["sede_ccod"] == sede_ccod) && (rec_secciones[i]["asig_ccod"]== asig_ccod)) {
			op2 = document.createElement("OPTION");
			op2.value = rec_secciones[i]["secc_ccod"];
			op2.text = rec_secciones[i]["descripcion"];
			formulario.elements["not[0][secc_tdesc]"].add(op2)
			
		}
	}

 
}

function ValidarBusqueda(formulario){
	if (formulario.elements["not[0][sede_ccod]"].value == "") {
		alert('Seleccione una Sede.');
		formulario.elements["not[0][sede_ccod]"].focus();
		return false ;
	}
	if (formulario.elements["not[0][secc_ccod]"].value == "-1") {
		alert('Seleccione una Asignatura.');
		formulario.elements["not[0][secc_ccod]"].focus();
		return false;
	}
	
	if (formulario.elements["not[0][secc_tdesc]"].value == "-1") {
		alert('Seleccione una Sección.');
		formulario.elements["not[0][secc_tdesc]"].focus();
		return false ;
	}

	
	return true;
 }

<!--  ----------------------------------------------------------------------------------------

function verifica_nota(formulario){
n_mala=0;
var num=formulario.elements.length;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var ingresada = new RegExp ("cala_nnota","gi");
		if (ingresada.test(nombre)){
			nota = eval(formulario.elements[i].value);
			if (nota < 1 || nota > 7) {
				n_mala	=	n_mala+1;
				mal		=	formulario.elements[i].focus();
			}
		}
	}
	if (n_mala > 0){
		return(false);
	}
	else {
		return(true);
	}
}

function dibujar(formulario){
	formulario.action='ingreso_notas.asp';
	formulario.submit();
}


function guardar(formulario){
nro_evaluaciones='<%=nro_evaluaciones%>'
pon	=parseInt(<%=ponderacion%>);

if (parseInt(nro_evaluaciones)>0){
	if (pon > 0 || pon <=100){
		ponderacion=pon
		if (parseInt(ponderacion) == 100){
			if(preValidaFormulario(formulario)){
				formulario.method='post';
				if (verifica_nota(formulario)){
					formulario.action ='guardar_nota.asp';
					formulario.submit();
				}
				else {
					alert('Las notas deben estar entre 1.0 y 7.0.');
				}
			}
		}
	}
}
else {alert("No Existen Alumnos ")	}
}

function enviar_email_masivo()
{
	if (confirm("Esto enviará las calificaciones a todos los alumnos,\n¿Para continuar presione Aceptar?") )
	{
		var formulario = document.lista;
		formulario.action = "http://www.upacifico.cl/super_test/motor_email_notas_parciales.php";
		formulario.target = "_black";
		formulario.submit();
	}	
}


str_nota_minima = '<%=negocio.ObtenerParametroSistema("NOTA_MINIMA")%>';
str_nota_maxima = '<%=negocio.ObtenerParametroSistema("NOTA_MAXIMA")%>';
v_nota_minima = parseFloat(str_nota_minima);
v_nota_maxima = parseFloat(str_nota_maxima);

function ValidaNota(valor)
{
	if (isEmpty(valor))
		return true;
	
	if (!isNumber(valor))
		return false;
		
	if (valor < v_nota_minima)
		return false;
		
	if (valor > v_nota_maxima)
		return false;
		
	return true;
}

function cala_nnota_blur(objeto)
{
	if (!ValidaNota(objeto.value)) {
		objeto.select();
		alert('Ingrese una nota válida. \n\nDebe ingresar una nota entre ' + str_nota_minima + ' y ' + str_nota_maxima + ', \ny utilizar un punto (.) como separador decimal.');		
	}
}
//-->

//-->

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
function aviso_email()
{
	var seccion = '<%=secc_ccod%>';
	 if (seccion == '')
	 {
	 	direccion="aviso_nuevo_email.asp";
     	resultado=window.open(direccion, "ventana_aviso","width=380,height=559,scrollbars=no, left=0, top=0");
	 }	
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="inicio(document.lista);InicioPagina(document.busca_alumnos);MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" >
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
      <br>
	<table width="88%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr>
        <td width="10" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td width="658" height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="10" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Ingreso Notas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
                <td> <p><br>
                  <form name="busca_alumnos" method="get">
                    <table width="98%"  border="0" align="center">
                      <tr> 
                        <td width="81%"><div align="center"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="26%" align="left"> <font face="Verdana, Arial, Helvetica, sans-serif" size="1">Sede 
                                  <br>
                                  <%formprofesores.dibujacampo("sede_ccod")%>
                                  </font></td>
                                <td width="53%" align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  </font> <font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  </font><font face="Verdana, Arial, Helvetica, sans-serif" size="1">&nbsp; 
                                  Asignaturas<br>
                                  <%formbusqueda.dibujacampo("secc_ccod")%>
                                  </font></td>
                                <td width="21%" align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Secci&oacute;n<br>
                                  <%formsecciones.dibujacampo("secc_tdesc")%>
                                  </font></td>
                              </tr>
                            </table>
                          </div></td>
                       </tr>
                    </table>
                    <table width="98%" border="0" align="center">
                      <tr> 
                        <td align="left">*PARA VER UN CURSO SELECCIONES LOS PARAMETROS 
                          DE BUSQUEDA Y PRESIONE EL BOTON <em><strong>&quot;BUSCAR&quot;</strong></em></td>
                      </tr>
                      <tr> 
                        <td align="left">Nota : Ud. esta Ingresando Notas para 
                          el periodo academico de :<strong> 
                          <%response.Write(PerSel)%>
                          </strong> &nbsp;</td>
                      </tr>
					  <tr> 
                      <td align="right"><%botonera.dibujaboton "buscar"%></td>
                      </tr>
                    </table>
                    <br>
                    <% if (not isnull(secc_ccod)) and (secc_ccod <> "") and (secc_ccod <> "-1" ) then %></p> 
                    <table width="100%" border="0">
                    <tr> 
                      <td colspan="2" nowrap>Resultado de La b&uacute;squeda </td>
                    </tr>
                    <tr> 
                      <td width="21%">Sede </td>
                      <td width="79%">:<strong>&nbsp;<%=f_asignatura.obtenervalor("sede_tdesc")%></strong></td>
                    </tr>
                    <tr> 
                      <td nowrap>Carrera </td>
                      <td nowrap>:<strong>&nbsp;<%=carrera%></strong> 
                      </td>
                    </tr>
					<tr> 
                      <td nowrap>Asignatura </td>
                      <td nowrap>:<strong> <%=f_asignatura.obtenervalor("asig_ccod")%> 
                        &nbsp; <%=f_asignatura.obtenervalor("asig_tdesc")%></strong> 
                      </td>
                    </tr>
                    <tr> 
                      <td>Secci&oacute;n</td>
                      <td>:<strong> <%=f_asignatura.obtenervalor("secc_tdesc")%></strong> 
                      </td>
                    </tr>
                    <tr> 
                      <td>Tipo Asignatura</td>
                      <td>:<strong> <%=f_asignatura.obtenervalor("tasg_tdesc")%></strong></td>
                    </tr>
                  </table>
                  <p></p>
                  <table width="100%" border="0">
                    <tr> 
                      <td align="left"> 
                        <%if ponderacion=100 then%>
                        <strong>CALIFICACIONES :</strong> <%=nota.dibujacampo("cali_ncorr")%> 
                        <%end if%>
                      </td>
                    </tr>
                    <tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td align="left"><p> 
                          <%if cali_ncorr <> "" then%>
                        </p>
                        <p>Calificacion Seleccionada:<strong> 
                          <% detalle_evaluacion = conectar.consultauno("select 'Nº '+ cast(cali_nevaluacion as varchar)+ ' - ' + cast(protic.trunc(a.cali_fevaluacion)as varchar)+' - '+ teva_tdesc as evaluacion from calificaciones_seccion a, tipos_evaluacion b where a.teva_ccod=b.teva_ccod and cast(cali_ncorr as varchar)='"&cali_ncorr&"' ")
						     ponderacion_evaluacion = conectar.consultauno("select 'Evaluación correspondiente al '+ cast(cali_nponderacion as varchar)+ '% de la nota final de la asignatura' from calificaciones_seccion a, tipos_evaluacion b where a.teva_ccod=b.teva_ccod and cast(cali_ncorr as varchar)='"&cali_ncorr&"' ")
					  		response.Write(detalle_evaluacion)
					  %>
                          </strong> 
                          <%end if%>
                        </p>
                        </td>
                    </tr>
                  </table>
                  <p> 
                    <%end if %>
                  </form></p>
                  <form name="lista" method="post">
                    <div align="left"> 
                      <p>
                        <% if secc_ccod <> "" and cali_ncorr <> "" then %>
                      </p>
                      <table width="100%" cellspacing="0" cellpadding="0">
                        <%if ((bloqueado_cambio = true and autorizar = false) or (bloquear_todo="S")) then  %>
						<tr> 
                          <td align="center"><font color="#0000FF" size="2"><strong>Atención: </strong><br>
                          No se pueden hacer modificaciones en las actas ya que el proceso fue cerrado según reglamento académico, si desea hacer cambios en ella diríjase al departamento de registro curricular.</font>
                          </td>
                        </tr>
						<tr> 
                          <td align="center">&nbsp;</td>
                        </tr>
						<%end if%>
						<%if registros > 0 and promedio_curso >= 2 then%>
						<tr>
				   	      <td align="center">
						  	<table width="60%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="15%" bgcolor="#ebc66d" align="center"><font color="#0033CC" size="2"><strong>NUEVO</strong></font></td>
									<td width="70%">&nbsp;</td>
									<td width="15%">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="2" bgcolor="#ebc66d"><font color="#000000" face="Times New Roman, Times, serif" size="2">Estimado(a) Docente:<br>Ahora puede enviar directamente al email de los alumnos las calificaciones parciales de esta evaluación. Para ello presione en el ícono.</font></td>
									<td width="15%" bgcolor="#ebc66d" align="center"><a href="javascript: enviar_email_masivo();" title="Enviar correo con notas a todo el curso."><img width="64" height="64" src="../imagenes/email_masivo.png" border="0"></a></td>
								</tr>
							</table>
						  </td>
						</tr>
						<tr>
				   	      <td align="center">&nbsp;</td>
						</tr>
						<%end if%>
						<tr> 
                          <td align="center">
                            <%pagina.DibujarSubtitulo "Lista de Alumnos"%>
                          </td>
                        </tr>
                        <tr> 
                          <td align="right">&nbsp; </td>
                        </tr>
                        <tr> 
                          <td align="center"> <% 
					if cali_ncorr<>"" then
					alumnos.dibujatabla()
					end if
					%>      <input type="hidden" name="registros" value="<%=registros%>"> 
                            <input type="hidden" name="not[0][cali_ncorr]" value="<%=cali_ncorr%>"> 
                            <input type="hidden" name="not[0][secc_ccod]" value="<%=secc_ccod%>">
							<input type="hidden" name="sede_tdesc_temp" value="<%=f_asignatura.obtenerValor("sede_tdesc")%>">
							<input type="hidden" name="carr_tdesc_temp" value="<%=carrera%>">
							<input type="hidden" name="asig_ccod_temp" value="<%=f_asignatura.obtenerValor("asig_ccod")%>">	
							<input type="hidden" name="asig_tdesc_temp" value="<%=f_asignatura.obtenerValor("asig_tdesc")%>">
							<input type="hidden" name="secc_tdesc_temp" value="<%=f_asignatura.obtenerValor("secc_tdesc")%>">
							<input type="hidden" name="profe_temp" value="<%=profe_temp%>">
							<input type="hidden" name="detalle_evaluacion_temp" value="<%=detalle_evaluacion%>">
							<input type="hidden" name="ponderacion_evaluacion_temp" value="<%=ponderacion_evaluacion%>">
                          </td>
                        </tr>
						<%if cali_ncorr <> "" then%>
                        <tr> 
                          <td align="right"><%if no_permite > 0 and ponderacion=100 and asig_cerrada = "1"  then
											  botonera.agregaBotonParam "guardar","deshabilitado","FALSE"
											  end if%>
										 <%
				  						 if asig_cerrada <> "1" or (sys_cierra_notas = TRUE ) or bloqueado_cambio = true or bloquear_botones="S" then
										 	botonera.agregaBotonParam "guardar","deshabilitado","TRUE"
										 end if %>
										
										  <%											
											if ((bloqueado_cambio = true and autorizar = false) or (bloquear_todo="S")) then
											     botonera.agregaBotonParam "guardar","deshabilitado","TRUE"
											End if
											
											if autorizar then 'or ip_usuario="172.16.11.216" or ip_usuario="172.16.11.147" then 'or ip_usuario="172.16.11.143" or ip_usuario="172.16.11.147"  or ip_usuario="172.16.11.249" then
												botonera.agregaBotonParam "guardar","deshabilitado","FALSE"
											end if
								
											botonera.dibujaBoton "guardar"%>
											
								</td>
                        </tr>
						<tr>
				   	      <td align="center"><br><hr><br></td>
						</tr>
						
     				   <tr>
				   	   <td align="center">
						<table width="90%" border="1">
							<tr>	
								<td colspan="2" align="center" bgcolor="#7A8B8B"><font size="3" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>Resumen</strong></font></td>
							</tr>
							<tr>	
								<td width="50%" align="left">Nota Promedio Curso</td>
								<td width="50%" align="center"><strong><%=promedio_curso%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="left">Notas bajo 4.0</td>
								<td width="50%" align="center"><strong><%=menores_a_4%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="left">Notas iguales o superiores a 4.0</td>
								<td width="50%" align="center"><strong><%=mayores_a_4%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="left">Alumnos no Activos</td>
								<td width="50%" align="center"><strong><%=cantidad_retirados%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="left">% curso bajo 4.0</td>
								<td width="50%" align="center"><strong><%=porc_menores_a_4%> %</strong></td>
    						</tr>
						</table>
					</td>
				   </tr>
				   <tr>
				  	  <td align="right">&nbsp;
					  </td>
				   </tr>
				   <tr>
				   	<td align="center">
						<table width="90%" border="1">
							<tr>	
								<td colspan="2" align="center" bgcolor="#7A8B8B"><font size="3" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>Intervalos</strong></font></td>
							</tr>
							<tr>	
								<td width="50%" align="center">1.0 a 1.9</td>
								<td width="50%" align="center"><strong><%=entre_1_2%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center">2.0 a 2.9</td>
								<td width="50%" align="center"><strong><%=entre_2_3%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center">3.0 a 3.9</td>
								<td width="50%" align="center"><strong><%=entre_3_4%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center">4.0 a 4.9</td>
								<td width="50%" align="center"><strong><%=entre_4_5%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center">5.0 a 5.9</td>
								<td width="50%" align="center"><strong><%=entre_5_6%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center">6.0 a 7.0</td>
								<td width="50%" align="center"><strong><%=entre_6_7%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center">Alumnos no Activos</td>
								<td width="50%" align="center"><strong><%=cantidad_retirados%></strong></td>
    						</tr>
							<tr>	
								<td width="50%" align="center"><strong>Total Alumnos</strong></td>
								<td width="50%" align="center"><strong><%=contador_total + cantidad_retirados%></strong></td>
    						</tr>
						</table>
					</td>
				   </tr>
				   <%end if%>
						<tr> 
                          <td align="center">&nbsp;</td>
                        </tr>
                      </table>
                      <%end if%>
                      <p><%if asig_cerrada <> "1" then%>
					       <font color="#0000FF"><b>Observaci&oacute;n :</b></font>&nbsp;La 
                                  evaluación de esta asignatura se encuentra <b>Cerrada</b>, 
                                  por lo tanto si desea hacer cualquier cambio 
                                  en ella se debe comunicar con la dirección de 
                                  la escuela.</p>
						  <%else%>
						  &nbsp; 
						  <%end if%></p>
						  <hr>
						  - Las evaluaciones parciales fueron modificadas por última vez el <%=fecha_parcial%> y las notas finales el <%=fecha_final%>, no olvide que si estas fechas no coinciden y ya ha guardado con anterioridad
						   las notas finales debe volver a hacerlo para actualizar los datos con la nueva información de notas parciales.
						  
                    </div>
                   
                    <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="10" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"></div></td>
                  <td><div align="center">
                    <%if no_permite > 0 and ponderacion=100 and asig_cerrada = "1"  then 
					
											  botonera.agregaBotonParam "guardar","deshabilitado","FALSE"
											 end if%>
                    <%
				  						 if asig_cerrada <> "1" or (sys_cierra_notas = TRUE ) or bloqueado_cambio = true or bloquear_botones="S" then
										
										 	botonera.agregaBotonParam "guardar","deshabilitado","TRUE"
										 end if %>
										
										  <%											
											if ((bloqueado_cambio = true and autorizar = false) or (bloquear_todo="S")) then
											'response.Write(",")
											     botonera.agregaBotonParam "guardar","deshabilitado","TRUE"
											End if
											
											if autorizar then ' or ip_usuario="172.16.11.216" or ip_usuario="172.16.11.147" then 'or ip_usuario="172.16.11.143" or ip_usuario="172.16.11.147"  or ip_usuario="172.16.11.249" then
												'response.Write(".")
												botonera.agregaBotonParam "guardar","deshabilitado","FALSE"
											end if
								
											botonera.dibujaBoton "guardar"%>
						</div>				  </td>
                  <td><div align="center"><%botonera.dibujaboton "salir"%></div></td>
				  <%if cali_ncorr <> "" then%>
				  <td width="14%"> <div align="center">  <%
					                       botonera.agregabotonparam "excel", "url", "ingreso_notas_excel.asp?secc_ccod="&secc_ccod&"&cali_ncorr="&cali_ncorr
										   botonera.dibujaboton "excel"
										%>
					 </div>                  </td>
				  <%end if%>
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
