<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
 set conectar = new CConexion
 conectar.Inicializar "upacifico"

 set negocio = new CNegocio
 negocio.Inicializa conectar

f_dcr=Request.querystring("dcur_ncorr")
f_dcur_ncorr=Request.Form("b[0]dcur_ncorr")
'f_dcur_ncorr=98

if f_dcur_ncorr="" then
f_dcur_ncorr=f_dcr
end if
'--------------------------------------------------

set conectar	=	new cconexion
conectar.inicializar "upacifico"
set negocio		=	new cnegocio
negocio.inicializa conectar


'--------------------------------------------------
set botonera = new CFormulario
botonera.carga_parametros "administra_encuesta.xml", "botonera"


set f_busqueda	=	new cformulario
f_busqueda.inicializar		conectar
f_busqueda.carga_parametros	"tabla_vacia.xml", "tabla" 

consulta="select mote_tdesc,rtrim(c.mote_ccod)as mote_ccod,protic.trunc(seot_finicio)as seot_finicio,protic.trunc(seot_ftermino)as seot_ftermino"& vbCrLf &_
"from diplomados_cursos a"& vbCrLf &_
"join mallas_otec b"& vbCrLf &_
"on a.dcur_ncorr=b.dcur_ncorr"& vbCrLf &_
"join modulos_otec c"& vbCrLf &_
"on b.mote_ccod=c.mote_ccod"& vbCrLf &_
"join secciones_otec d"& vbCrLf &_
"on b.maot_ncorr=d.maot_ncorr"& vbCrLf &_
"join autoriza_encuesta_otec e"& vbCrLf &_
"on b.mote_ccod=e.mote_ccod"& vbCrLf &_
"and a.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
"where a.dcur_ncorr="&f_dcur_ncorr&""& vbCrLf &_
"group by mote_tdesc,c.mote_ccod,seot_finicio,seot_ftermino"
'
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_busqueda.consultar	consulta

dcur_tdesc=conectar.consultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&f_dcur_ncorr&"")
'-------------------------------------------------------------------------


sel_prom_infraestructura="select cast(((round(avg(enpo_II_1),2)+round(avg(enpo_II_2),2)+round(avg(enpo_II_3),2)+round(avg(enpo_II_4),2)"& vbCrLf &_
													"+round(avg(enpo_II_5),2)+round(avg(enpo_II_6),2)+round(avg(enpo_II_7),2))/7) as decimal(18,2))"& vbCrLf &_
													"from encu_programa_otec vv" & vbCrLf &_
													"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
													"group by dcur_ncorr"
											
prom_infraestructura=conectar.consultaUno(sel_prom_infraestructura)

sel_prom_programa="select cast(((round(avg(enpo_I_1),2)+round(avg(enpo_I_2),2)+round(avg(enpo_I_3),2)+round(avg(enpo_I_4),2)"& vbCrLf &_
													"+round(avg(enpo_I_5),2)+round(avg(enpo_I_6),2)+round(avg(enpo_I_7),2))/7) as decimal(18,2))"& vbCrLf &_
													"from encu_programa_otec vv" & vbCrLf &_
													"where vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
													"group by dcur_ncorr"
prom_programa=conectar.consultaUno(sel_prom_programa)

tiene=conectar.consultaUno("select count(*) from informe_conclusione_encuesta_otec where dcur_ncorr="&f_dcur_ncorr&"")
set f_concluciones	=	new cformulario
f_concluciones.inicializar		conectar
f_concluciones.carga_parametros	"administra_encuesta.xml", "f_conculusiones" 

if 	tiene=0 then								
sel_concl_="select''"
else
sel_concl_="select iceo_preliminares as preliminares,iceo_acciones as acciones,iceo_finales as finales from informe_conclusione_encuesta_otec where dcur_ncorr="&f_dcur_ncorr&""	
end if
'response.Write(sel_concl_)
f_concluciones.consultar	sel_concl_
f_concluciones.Siguiente
 
 '---------------------------------------------------------------------------------------
 
 
 
 set f_relatores_encuesta=new cformulario
f_relatores_encuesta.inicializar		conectar
f_relatores_encuesta.carga_parametros	"tabla_vacia.xml", "tabla" 

consulta="select pers_ncorr_relator, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre from ENCU_RELATOR_OTEC a, personas b where a.pers_ncorr_relator=b.pers_ncorr and dcur_ncorr="&f_dcur_ncorr&" group by pers_ncorr_relator, pers_tape_paterno,pers_tape_materno,pers_tnombre order by nombre"
'
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_relatores_encuesta.consultar	consulta
 
 
'response.End()
 '---------------------------------------------------------------------------------------

Set pdf=CreateJsObject("FPDF")
'pdf.Header=function Header()
'{
'
'    pdf.Image "../imagenes/logo_upa_negro.jpg", 10, 20, 50, 15, "JPG"
'    pdf.SetFont("Arial","B",15)
'    pdf.Cell(80)
'    pdf.Cell(30,10,"Title",1,0,"C")
'    pdf.Ln(20)
'}
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","B",10
pdf.Open()
pdf.LoadModels("informe_encuesta") 
pdf.SetAutoPageBreak TRUE,20
pdf.AddPage()
pdf.Cell 190,5,"Programa:"&dcur_tdesc&"","","","C"
pdf.ln(10)
pdf.SetFont "Arial","BU",10
pdf.Cell 190,5,"Encuesta Relatores","","","C"
pdf.SetFont "Arial","B",8 
pdf.ln(10)
pdf.SetX(10)
pdf.Cell 65,5,"Relatores","","","C"
pdf.ln(0)
pdf.SetX(75)
pdf.Cell 95,5,"Modulos","","","C"
pdf.ln(0)
pdf.SetX(170)
pdf.Cell 30,5,"Promedios","","","C"
pdf.SetFont "Arial","",8 
pdf.ln(10)
while f_busqueda.Siguiente
									mote_ccod=f_busqueda.ObtenerValor("mote_ccod")
									seot_finicio=f_busqueda.ObtenerValor("seot_finicio")
									seot_ftermino=f_busqueda.ObtenerValor("seot_ftermino")
									
									set f_relatores = new CFormulario
									f_relatores.Carga_Parametros "tabla_vacia.xml", "tabla"
									f_relatores.Inicializar conectar
									  
	consulta_sec="select b.mote_ccod,c.seot_ncorr,f.pers_ncorr,mote_tdesc,a.dcur_ncorr,pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre"& vbCrLf &_
							"from modulos_otec b"& vbCrLf &_
							",mallas_otec a"& vbCrLf &_
							",secciones_otec c "& vbCrLf &_
							",bloques_horarios_otec d"& vbCrLf &_
							",bloques_relatores_otec e"& vbCrLf &_
							",personas f"& vbCrLf &_
							"where a.mote_ccod=b.mote_ccod"& vbCrLf &_
							"and a.maot_ncorr=c.maot_ncorr"& vbCrLf &_
							"and c.seot_ncorr=d.seot_ncorr"& vbCrLf &_
							"and d.bhot_ccod=e.bhot_ccod"& vbCrLf &_
							"and e.pers_ncorr=f.pers_ncorr"& vbCrLf &_
							"and a.mote_ccod='"&mote_ccod&"'"& vbCrLf &_
							"and protic.trunc(seot_finicio)='"&seot_finicio&"'"& vbCrLf &_
							"and protic.trunc(seot_ftermino)='"&seot_ftermino&"'"& vbCrLf &_
							"group by  e.pers_ncorr,b.mote_ccod,c.seot_ncorr,f.pers_ncorr,mote_tdesc,a.dcur_ncorr,pers_tape_paterno,pers_tape_materno,pers_tnombre"& vbCrLf &_
							"order by nombre"
							f_relatores.Consultar consulta_sec		
									
									 
								  'response.Write("<br>"&v_deuda)
								  
								
								while f_relatores.Siguiente	
							  
									pers_ncorr=f_relatores.Obtenervalor("pers_ncorr")
									seot_ncorr=f_relatores.Obtenervalor("seot_ncorr")
									mote_ccod=f_relatores.Obtenervalor("mote_ccod")
									
									sel_prom="select cast(((round(avg(enrp_1),2)+round(avg(enrp_2),2)+round(avg(enrp_3),2)+"& vbCrLf &_
											"round(avg(enrp_4),2)+round(avg(enrp_5),2)+round(avg(enrp_6),2)+round(avg(enrp_7),2)+"& vbCrLf &_
											"round(avg(enrp_8),2)+round(avg(enrp_9),2)+round(avg(enrp_10),2)+round(avg(enrp_11),2)+"& vbCrLf &_
											"round(avg(enrp_12),2)+round(avg(enrp_13),2))/13) as decimal(18,1))promedio_evaluacion"& vbCrLf &_
											"from ENCU_RELATOR_OTEC vv"& vbCrLf &_
											"where  vv.pers_ncorr_relator="&pers_ncorr&""& vbCrLf &_
											"and vv.seot_ncorr="&seot_ncorr&""& vbCrLf &_
											"and vv.DCUR_NCORR="&f_dcur_ncorr&""& vbCrLf &_
											"group by pers_ncorr_relator"
											
									prom=conectar.consultaUno(sel_prom)
									'response.Write(sel_prom)
									

pdf.SetX(10)
pdf.MultiCell 65,3,""&f_relatores.Obtenervalor("nombre")&"","","C",""
pdf.ln(-3)
pdf.SetX(75)
pdf.MultiCell 95,3,""&f_relatores.Obtenervalor("mote_tdesc")&"","","C",""
pdf.ln(-3)
pdf.SetX(170)
pdf.MultiCell 30,3,""&prom&"","","C",""
pdf.ln(0)
wend
wend
pdf.ln(10)
pdf.SetFont "Arial","BU",10

pdf.Cell 190,5,"Encuesta Programa","","","C"
pdf.SetFont "Arial","",8 
pdf.ln(10)
pdf.SetX(88) 
pdf.SetFont "Arial","B",8 
pdf.Cell 34,5,"Puntaje Promedio","","","C"
pdf.ln(5)
pdf.SetX(88)
pdf.SetFont "Arial","",8 
pdf.Cell 34,5,""&prom_programa&"","","","C"
pdf.ln(5)
pdf.SetFont "Arial","BU",10
pdf.Cell 190,5,"Encuesta Infraestructura","","","C"
pdf.SetFont "Arial","",8 
pdf.ln(10)
pdf.SetX(88) 
pdf.SetFont "Arial","B",8 
pdf.Cell 34,5,"Puntaje Promedio","","","C"
pdf.ln(5)
pdf.SetX(88) 
pdf.SetFont "Arial","",8 
pdf.Cell 34,5,""&prom_infraestructura&"","","","C"
pdf.ln(10)
pdf.SetFont "Arial","B",10
pdf.Cell 34,5,"Conclusiones Preliminares:","","","L"
pdf.ln(5)
pdf.SetFont "Arial","",8
pdf.MultiCell 190,5,""&f_concluciones.ObtenerValor("preliminares")&"","","0","D"  
pdf.ln(5)
pdf.SetFont "Arial","B",10
pdf.Cell 34,5,"Conclusiones Finales:","","","L"
pdf.ln(5)
pdf.SetFont "Arial","",8
pdf.MultiCell 190,5,""&f_concluciones.ObtenerValor("finales")&"","","0","D"  
pdf.ln(5)
pdf.SetFont "Arial","B",10
pdf.Cell 34,5,"Acciones:","","","L"
pdf.ln(5)
pdf.SetFont "Arial","",8
pdf.MultiCell 190,5,""&f_concluciones.ObtenerValor("acciones")&"","","0","D"
pdf.AddPage()
pdf.SetFont "Arial","B",10
pdf.Cell 190,5,"Observaciones a cada Relator ","","","C"
pdf.SetFont "Arial","",8 
pdf.ln(10)  

			while f_relatores_encuesta.siguiente
			
			pers_ncorr_relator=f_relatores_encuesta.ObtenerValor("pers_ncorr_relator")
			pers_tnombre=f_relatores_encuesta.ObtenerValor("nombre")
			
			 set f_relatores_encuesta_observacion=new cformulario
			f_relatores_encuesta_observacion.carga_parametros	"tabla_vacia.xml", "tabla" 
			f_relatores_encuesta_observacion.inicializar		conectar

			consulta_ob="select enrp_sug from ENCU_RELATOR_OTEC a where a.pers_ncorr_relator="&pers_ncorr_relator&" and dcur_ncorr="&f_dcur_ncorr&""
			
			f_relatores_encuesta_observacion.Consultar consulta_ob
pdf.SetFont "Arial","B",10			
pdf.Cell 190,5,"Relator "&pers_tnombre&" ","","","L"
pdf.SetFont "Arial","",8
pdf.ln(10)	 
			contador=1			
			while f_relatores_encuesta_observacion.siguiente
			
pdf.MultiCell 190,5,""&contador&") "&f_relatores_encuesta_observacion.ObtenerValor("enrp_sug")&"","","0","D"  
pdf.ln(5)	
			contador=contador+1		
			wend
			wend
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_relatores_encuesta.consultar	consulta
pdf.Close()
pdf.Output()
%> 
