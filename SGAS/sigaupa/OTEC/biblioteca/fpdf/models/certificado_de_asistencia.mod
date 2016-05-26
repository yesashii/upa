this.Header=function Header()
{
	this.Image ('../imagenes/logo_negro_2.jpg', 19, 10, 30, 15, 'JPG');
    this.SetFont('Arial','B',9);
	this.Ln(14);
    this.Cell(190,6,'CERTIFICADO DE ASISTENCIA ACTIVIDAD OTEC, CFT O ENTIDAD NIVELADORA DE ESTUDIOS, IMPUTADA','0','1','C');
	this.Cell(190,6,'EN FORMA TOTAL O PARCIAL A FRANQUICIA TRIBUTARIA DE CAPACITACIÓN','0','','C');
    this.Ln(8);
}
this.Footer=function Footer()
{
    
    this.SetY(-15);
    this.SetTextColor(186,186,186)
    this.SetFont('Arial','B',10);
    this.Cell(0,10,'' + this.PageNo() + '',0,0,'R');
}

