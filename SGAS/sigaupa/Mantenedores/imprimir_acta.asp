<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Título de la página"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------
reso_ncorr=request.Form("reso_acon[0][reso_ncorr]")
impresora=request.Form("ip[0][impr_truta]")
'response.Write(impresora)
'response.End()

set resolucion = new cformulario
set f_datos_alumnos=new cformulario
set tabla_i = new cformulario

set conectar = new CConexion
set jp = new cVariables

conectar.inicializar "upacifico"
jp.procesaform


resolucion.carga_parametros "paulo.xml","tabla"
resolucion.inicializar conectar


f_datos_alumnos.carga_parametros "paulo.xml","tabla"
f_datos_alumnos.inicializar conectar

tabla_i.carga_parametros "paulo.xml","tabla"
tabla_i.inicializar conectar

impresora = jp.obtenerValor("ip",0,"impr_truta")
session("impresora")=impresora

conresolucion =  " SELECT  b.acon_nacta ,b.acon_facta,a.reso_nresolucion,e.tres_tdesc," & _
 		 	  "	 a.reso_fresolucion,cast(d.pers_nrut as varchar)+'-'+cast(d.pers_xdv as varchar) as rut," & _
			  "	 d.pers_nrut as v_pers_nrut,b.peri_ccod as v_peri_ccod," & _
			  "	 b.acon_ncorr,e.tres_ccod" & _
			  "	 FROM resoluciones a, actas_convalidacion b, " & _
			  "	  	  resoluciones_personas c, personas d," & _
			  "		  tipos_resolucion e" & _
			  "	 WHERE a.reso_ncorr = b.reso_ncorr AND" & _ 
			  "		   a.reso_ncorr = c.reso_ncorr AND  " & _
			  "		   c.pers_ncorr = d.pers_ncorr AND " & _ 
		      "		   a.tres_ccod = e.tres_ccod and " & _
			  "		   cast(a.reso_ncorr as varchar)= '"&reso_ncorr&"' "
			  
resolucion.consultar conresolucion
resolucion.siguiente

acon_acta= resolucion.obtenerValor("acon_nacta")
acon_facta= resolucion.obtenerValor("acon_facta")
reso_nresolucion= resolucion.obtenerValor("reso_nresolucion")
tres_tdesc= resolucion.obtenerValor("tres_tdesc")
tres_ccod= resolucion.obtenerValor("tres_ccod")
reso_fresolucion= resolucion.obtenerValor("reso_fresolucion")

rut= resolucion.obtenerValor("rut")
v_pers_nrut= resolucion.obtenerValor("v_pers_nrut")
v_peri_ccod= resolucion.obtenerValor("v_peri_ccod")
acon_ncorr= resolucion.obtenerValor("acon_ncorr")




datos_alumnos = "SELECT cast(a.pers_tape_paterno as varchar) + ' ' + cast(a.pers_tape_materno as varchar)+ ' ' + cast(a.pers_tnombre as varchar) AS nombre_alumno," & vbCrLf &_
		        "  f.carr_tdesc,     " & vbCrLf &_
		        "  e.espe_tdesc,     " & vbCrLf &_
		        "  d.plan_ncorrelativo   " & vbCrLf &_
    	        " FROM personas a, alumnos b, ofertas_academicas c, planes_estudio d, especialidades e, carreras f     " & vbCrLf &_
		        " WHERE a.pers_ncorr = b.pers_ncorr AND     " & vbCrLf &_
		        " b.ofer_ncorr = c.ofer_ncorr AND     " & vbCrLf &_
		        " b.plan_ccod = d.plan_ccod AND     " & vbCrLf &_
		        " d.espe_ccod = e.espe_ccod AND     " & vbCrLf &_
		        " e.carr_ccod = f.carr_ccod AND  " & vbCrLf &_    
		        " b.emat_ccod = 1 AND     " & vbCrLf &_
		        " cast(a.pers_nrut as varchar)= '"&v_pers_nrut&"'  AND  " & vbCrLf &_
		        " cast(c.peri_ccod as varchar)=  '"&v_peri_ccod&"' "
				
f_datos_alumnos.consultar datos_alumnos
f_datos_alumnos.siguiente

nombre_alumno= f_datos_alumnos.obtenerValor("nombre_alumno")
carr_tdesc= f_datos_alumnos.obtenerValor("carr_tdesc")
espe_tdesc= f_datos_alumnos.obtenerValor("espe_tdesc")
plan_ncorrelativo= f_datos_alumnos.obtenerValor("plan_ncorrelativo")



'---------------------------------------------------------------------------------------
					  function Ac1(texto,ancho,alineado)
						largo =Len(Trim(texto))
						if isNull(largo) then
							largo=0
						end if
						if largo > ancho then largo=ancho
						if ucase(alineado) = "D" then 
						   Ac1=space(ancho-cint(largo))&Left(texto,largo)
						else
						   Ac1=Left(texto,largo)&space(ancho-largo)
						end if   
					  end function
					 
'---------------------------------------------------------------------------------------

Set oFile      = CreateObject("Scripting.FileSystemObject")

archivo= archivo & chr(13) & chr(10) & chr(13) & chr(10)& chr(13) & chr(10)
archivo= archivo & space(35) & Ac1("Acta De",9,"I") & Ac1(tres_tdesc,40,"I")& chr(13) & chr(10)
archivo= archivo & chr(13) & chr(10) & chr(13) & chr(10)
archivo= archivo & space(5) & Ac1("Numero Acta: ",13,"I") & Ac1(acon_acta ,8,"I") & space(13)&Ac1("Fecha Resolución : ",19,"I") & reso_fresolucion 
archivo= archivo & chr(13) & chr(10) & chr(13)
archivo= archivo & space(5) & Ac1("Fecha Acta : ",13,"I") & Ac1(acon_facta,11,"I") & space(10)& Ac1("Tipo Resolución :",17,"I") & tres_tdesc
archivo= archivo & chr(13) & chr(10) & chr(13)
archivo= archivo & space(39)& Ac1("Rut Alumno : ",13,"I") & rut 
archivo= archivo & chr(13) & chr(10) & chr(13)& chr(13) & chr(10) & chr(13)
archivo= archivo & space(5) & Ac1("Alumno : ",9,"I") & nombre_alumno
archivo= archivo & chr(13) & chr(10) & chr(13)
archivo= archivo & space(5) & Ac1("Carrera : ",10,"I") & carr_tdesc
archivo= archivo & chr(13) & chr(10) & chr(13)
archivo= archivo & space(5) & Ac1("Especialidad : ",15,"I") & espe_tdesc
archivo= archivo & chr(13) & chr(10) & chr(13)
archivo= archivo & space(5) & Ac1("Plan : ",7,"I") & plan_ncorrelativo
archivo= archivo & chr(13) & chr(10) & chr(13)& chr(13) & chr(10) & chr(13)
archivo= archivo & space(5) & Ac1("CODIGO",10,"I")& Ac1("ASIGNATURA",40,"I") & Ac1("SITUACION FINAL",19,"I")
if (tres_ccod="7") then
  archivo=archivo & Ac1("NOTA",8,"I")
end if  
archivo= archivo & chr(13) & chr(10)

'consulta_i= "SELECT a.matr_ncorr, a.asig_ccod, a.acon_ncorr, b.asig_tdesc, a.sitf_ccod,  DECODE(a.conv_nnota, '','---',0, '0.0',1, '1.0',2, '2.0',3, '3.0',4, '4.0',5, '5.0',6, '6.0',7, '7.0',a.conv_nnota) AS conv_nnota  " &_
'            " FROM convalidaciones a, asignaturas b  " &_
'		    " WHERE a.asig_ccod = b.asig_ccod AND  " &_
'		    "       acon_ncorr =  '"&acon_ncorr&"' " &_   
'		    " ORDER BY a.asig_ccod ASC "
			
consulta_i=" SELECT a.matr_ncorr, a.asig_ccod, a.acon_ncorr, b.asig_tdesc, a.sitf_ccod," & vbCrLf &_
           " case a.conv_nnota when '' then'---'" & vbCrLf &_
           " when 0 then '0.0'" & vbCrLf &_
           " when 1 then '1.0'" & vbCrLf &_
           " when 2 then '2.0'" & vbCrLf &_
           " when 3 then '3.0'" & vbCrLf &_
           " when 4 then '4.0'" & vbCrLf &_
           " when 5 then '5.0'" & vbCrLf &_
           " when 6 then '6.0'" & vbCrLf &_
           " when 7 then '7.0'" & vbCrLf &_
           " else a.conv_nnota end  AS conv_nnota  " & vbCrLf &_
           " FROM convalidaciones a, asignaturas b " & vbCrLf &_
           " WHERE a.asig_ccod = b.asig_ccod AND" & vbCrLf &_
           " acon_ncorr =  '21' " & vbCrLf &_
           " ORDER BY a.asig_ccod ASC "
		   
tabla_i.consultar consulta_i
'tabla_i.siguiente
i=0
if tabla_i.nroFilas > 0 then
   for k=0 to  tabla_i.nroFilas-1
	   tabla_i.siguiente
	   asig_ccod= tabla_i.obtenerValor("asig_ccod")
	   asig_tdesc=tabla_i.obtenerValor("asig_tdesc")
	   sitf_ccod=tabla_i.obtenerValor("sitf_ccod")
	   conv_nnota=tabla_i.obtenerValor("conv_nnota")
	   archivo= archivo & chr(13) & chr(10)
	   archivo= archivo & space(5) & Ac1(asig_ccod,10,"I")& Ac1(asig_tdesc,40,"I") & Ac1(sitf_ccod,19,"I")
	   if (tres_ccod=7) then
		   archivo= archivo & Ac1(conv_nnota,8,"I") 	
		end if   
	next
end if

archivo= archivo & chr(13) & chr(10)& chr(13) & chr(10)& chr(13) & chr(10)& chr(10)& chr(13) & chr(10)
archivo= archivo & space(5)& Ac1("____________________",22,"I") & space(10)& Ac1("____________________",22,"I")
archivo= archivo & chr(13) & chr(10)
Aarchivo= archivo & space(5)& Ac1("JEFE DE CARRERA",22,"I") & space(10) & Ac1("SUBDIRECTOR ACADEMICO",22,"I")
archivo=archivo & chr(12)

'--------------------------------------------------------------------------------------				
					   Set oFile      = CreateObject("Scripting.FileSystemObject")
					   Set oPrinter   = oFile.CreateTextFile(impresora) 
					   'Set oPrinter   = oFile.CreateTextFile("//gst_protic1/Musica$/impresora.txt") 
					   'Set oPrinter   = oFile.CreateTextFile("\\desarrollo\protic\SigaDesa\Mantenedores\impresora.txt") 
					  'response.Write("<pre>"&archivo&"</pre>")
					 oPrinter.write(archivo)
					 
					   Set oWshnet    = Nothing
					   Set oFile      = Nothing
					   set oPrinter   = Nothing
					   set iPrinter   = Nothing 
'--------------------------------------------------------------------------------------

%>

		<script language="JavaScript" type="text/javascript">
			history.go(-1)
		</script>
		


