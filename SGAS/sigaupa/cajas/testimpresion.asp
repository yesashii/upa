<%  
 archivo = " hola "
 impresora  	= 	"\\caja03cc\bolecajacc"
   Set oFile      = CreateObject("Scripting.FileSystemObject")
   Set oPrinter   = oFile.CreateTextFile(impresora, true, false) 
   
   oPrinter.write(archivo)
 
   Set oWshnet    = Nothing
   Set oFile      = Nothing
   set oPrinter   = Nothing
   set iPrinter   = Nothing 

%>