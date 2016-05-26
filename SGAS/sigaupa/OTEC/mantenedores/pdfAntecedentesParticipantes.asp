<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script language="JavaScript">
function ucWords(string){
 var arrayWords;
 var returnString = "";
 var len;
 arrayWords = string.split(" ");
 len = arrayWords.length;
 for(i=0;i < len ;i++){
  if(i != (len-1)){
   returnString = returnString+ucFirst(arrayWords[i])+" ";
  }
  else{
   returnString = returnString+ucFirst(arrayWords[i]);
  }
 }
 return returnString;
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Documento sin título</title>
</head>

<body javascript::onload(reset);>
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'set errores = new cErrores
'--------------------------------------------------por get
dcur_ncorr = request.querystring("dcur_ncorr")
'--------------------------------------------------por get
'*********************'
'* creación del pdf  *'
'*********************'   
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF "l","mm","Letter"
pdf.SetPath("../biblioteca/fpdf/" )
'pdf.LoadModels("NumeroPagina")
'pdf.SetAutoPageBreak TRUE,20
pdf.SetFont "Arial","B",12
pdf.Open()
pdf.AddPage()
'*********************'  
'---------------------------------------------Titulo
pdf.SetY(20)
pdf.SetFont "Arial","BU",14
pdf.MultiCell 256,12,"ANTECEDENTES PARTICIPANTES" ,"0","C",""
'---------------------------------------------Titulo

'************************************'
'* imprime la cabecera de la tabla  *'
'************************************'
function filaUno()	
	'---------------------------------------FILA_1
	pdf.SetFont "Arial","B",11
	pdf.Cell 10,8,"N°","LTR","0","C"
	pdf.Cell 65,8,"APELLIDOS, NOMBRE","LTR","0","C"
	pdf.Cell 30,8,"RUT","LTR","0","C"
	pdf.Cell 40,8,"NIVEL","LTR","0","C"
	pdf.Cell 50,8,"EMPRESA","LTR","0","C"
	pdf.Cell 40,8,"CARGO QUE","LTR","0","L"
	pdf.Cell 25,8,"FIRMA","LTR","1","C"
	'--------------------------------------------
	pdf.Cell 10,5,"","LBR","0","C"
	pdf.Cell 65,5,"","LBR","0","L"
	pdf.Cell 30,5,"","LBR","0","L"
	pdf.Cell 40,5,"ESCOLARIDAD","LBR","0","C"
	pdf.Cell 50,5,"","LBR","0","L"
	pdf.Cell 40,5,"DESEMPEÑA","LBR","0","L"
	pdf.Cell 25,5,"","LBR","1","L"
	'---------------------------------------FILA_1
end function
'************************************'
'***********************'
'* repite la cabecera  *'
'***********************'
function repiteCabeza(numUno, numDos)	
	if numUno = 12  then
			if numDos > 12 then
				filaUno()
			end if
		ElseIf (numUno - 12) mod 14 = 0 and numUno <> 14 then
			if numDos > numUno then
				filaUno()
			end if
	end if
end function
'***********************'
'*********************'
'* inserta una fila  *'
'*********************'
function insertaElemento(apellidoP, apellidoM, nombres, rut , num)	
		pdf.SetFont "Arial","",11
		pdf.Cell 10,8,""& num &"","LTR","0","C"
		pdf.Cell 65,8,"" & apellidoP & " "& apellidoM & " ","LTR","0","L"
		pdf.Cell 30,8,""&rut&"","LTR","0","C"
		pdf.Cell 40,8,"","LTR","0","C"
		pdf.Cell 50,8,"","LTR","0","C"
		pdf.Cell 40,8,"","LTR","0","L"
		pdf.Cell 25,8,"","LTR","1","C"
		'--------------------------------------------
		pdf.Cell 10,5,"","LBR","0","C"
		pdf.Cell 65,5,""& perNombre &" ","LBR","0","L"
		pdf.Cell 30,5,"","LBR","0","L"
		pdf.Cell 40,5,"","LBR","0","C"
		pdf.Cell 50,5,"","LBR","0","L"
		pdf.Cell 40,5,"","LBR","0","L"
		pdf.Cell 25,5,"","LBR","1","L"
end function
'*********************'
filaUno() ' se inserta la cabecera
set f_portada = new CFormulario
f_portada.Carga_Parametros "tabla_vacia.xml", "tabla"
f_portada.Inicializar conexion
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
'---------------------------------------------------------------------------------------------
largoDeConsulta = f_portada.nroFilas
contador = 1
'********************************************'
'* CAPTURA DE VARIABLES	PARA SER INSERTADAS *'
'****************************************************'
perRut = ""
perPaterno = ""
perMaterno = ""
perNombre = ""
while f_portada.siguiente
	perRut = f_portada.obtenerValor("rut")
	perPaterno = f_portada.obtenerValor("pers_tape_paterno")
	perMaterno = f_portada.obtenerValor("pers_tape_materno")
	perNombre = f_portada.obtenerValor("pers_tnombre")
	insertaElemento perPaterno, perMaterno, perNombre, perRut, contador
	repiteCabeza contador, largoDeConsulta
	contador = contador + 1
wend
'****************************************************'
pdf.Close()
pdf.Output()   
%>
</body>
</html>
