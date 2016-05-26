<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new cErrores
'--------------------------------------------------por get
dcur_ncorr = request.querystring("dcur_ncorr")
'--------------------------------------------------por get

set f_portada = new CFormulario
f_portada.Carga_Parametros "tabla_vacia.xml", "tabla"
f_portada.Inicializar conexion
'*********************'
'* creación del pdf  *'
'*********************'   
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF "l","mm","Letter"
pdf.SetPath("../biblioteca/fpdf/" )
'pdf.LoadModels("PieFecha") 
'pdf.SetAutoPageBreak TRUE,20
pdf.SetFont "Arial","B",12
pdf.Open()
pdf.AddPage()
'*********************'  
'---------------------------------------------Titulo
pdf.SetY(15)
pdf.SetFont "Arial","BU",14
pdf.MultiCell 256,12,"EVALUACIONES" ,"0","C",""
'---------------------------------------------Titulo
'************************************'
'* imprime la cabecera de la tabla  *'
'************************************'
function filaUno()	
	'---------------------------------------FILA_1
	pdf.SetFont "Arial","B",11
	pdf.Cell 10,8,"N°","LTR","0","C"
	pdf.Cell 65,8,"APELLIDOS, NOMBRE","LTR","0","L"
	pdf.Cell 25,8,"FECHA: ","LTR","0","L"
	pdf.Cell 25,8,"FECHA: ","LTR","0","L"
	pdf.Cell 25,8,"FECHA: ","LTR","0","L"
	pdf.Cell 25,8,"FECHA: ","LTR","0","L"
	pdf.Cell 30,8,"NOTA FINAL","LTR","0","C"
	pdf.Cell 50,8,"FIRMA CONFORMIDAD","LTR","1","L"	
	'--------------------------------------------
	pdf.Cell 10,5,"","LBR","0","C"
	pdf.Cell 65,5,"","LBR","0","L"
	pdf.Cell 25,5,"","LBR","0","L"
	pdf.Cell 25,5,"","LBR","0","L"
	pdf.Cell 25,5,"","LBR","0","L"
	pdf.Cell 25,5,"","LBR","0","L"
	pdf.Cell 30,5,"","LBR","0","L"
	pdf.Cell 50,5,"PARTICIPANTES","LBR","1","L"	
	'---------------------------------------FILA_1
end function
'************************************'
'*********************'
'* inserta una fila  *'
'*********************'
function insertaElemento(apellidoP, apellidoM, nombre1, num, max)	
	pdf.SetFont "Arial","",12
	pdf.Cell 10,8,"" &num& "","LTR","0","C"
	pdf.Cell 65,8,""&apellidoP&" "&apellidoM&"","LTR","0","L"
	pdf.Cell 25,8,"","LTR","0","L"
	pdf.Cell 25,8,"","LTR","0","L"
	pdf.Cell 25,8,"","LTR","0","L"
	pdf.Cell 25,8,"","LTR","0","L"
	pdf.Cell 30,8,"","LTR","0","C"
	pdf.Cell 50,8,"","LTR","1","L"	
	'--------------------------------------------
	pdf.Cell 10,5,"","LBR","0","C"
	pdf.Cell 65,5,""&nombre1&"","LBR","0","L"
	pdf.Cell 25,5,"","LBR","0","L"
	pdf.Cell 25,5,"","LBR","0","L"
	pdf.Cell 25,5,"","LBR","0","L"
	pdf.Cell 25,5,"","LBR","0","L"
	pdf.Cell 30,5,"","LBR","0","L"
	pdf.Cell 50,5,"","LBR","1","L"	
	'--------------------------------------------
	if num mod 12 = 0 and max <> num then		
		pdf.AddPage()
		pdf.SetY(20)
		filaUno()			
	end if
	'--------------------------------------------
end function
'*********************'
'***************************************************************************************************************************************************************
filaUno() ' se inserta la cabecera
'************************************************************************'
'*				CONSULTA QUE LLENA LOS DATOS DE ANTECEDENTES			*'
'************************************************************************'
consulta = "" & vbCrLf & _
"select cast(c.pers_nrut as varchar) + '-'                        " & vbCrLf & _
"       + c.pers_xdv                        as rut,               " & vbCrLf & _
"       protic.initcap(c.pers_tape_paterno) as pers_tape_paterno, " & vbCrLf & _
"       protic.initcap(c.pers_tape_materno) as pers_tape_materno, " & vbCrLf & _
"       protic.initcap(c.pers_tnombre)      as pers_tnombre       " & vbCrLf & _
"from   personas as c                                             " & vbCrLf & _
"       inner join postulacion_otec as b                          " & vbCrLf & _
"               on c.pers_ncorr = b.pers_ncorr                    " & vbCrLf & _
"                  and epot_ccod = 4                              " & vbCrLf & _
"       inner join datos_generales_secciones_otec as d            " & vbCrLf & _
"               on b.dgso_ncorr = d.dgso_ncorr                    " & vbCrLf & _
"where  cast(d.dcur_ncorr as varchar) = '"&dcur_ncorr&"'          " & vbCrLf & _
"order  by pers_tape_paterno                                      " 
'************************************************************************'
f_portada.Consultar consulta
largoDeConsulta = f_portada.nroFilas
contador = 1
'********************************************'
'* CAPTURA DE VARIABLES	PARA SER INSERTADAS *'
'****************************************************'
'--------------------------------------------------------------------------------
while f_portada.siguiente
	perPaterno = f_portada.obtenerValor("pers_tape_paterno")
	perMaterno = f_portada.obtenerValor("pers_tape_materno")
	perNombre = f_portada.obtenerValor("pers_tnombre")
	insertaElemento perPaterno, perMaterno, perNombre, contador, largoDeConsulta	
	contador = contador + 1
wend
'****************************************************'
pdf.Close()
pdf.Output()
%>