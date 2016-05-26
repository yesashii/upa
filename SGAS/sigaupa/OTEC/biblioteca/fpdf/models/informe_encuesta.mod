this.Header=function Header()
{
	this.Image ('../imagenes/logo_upa_negro.jpg', 10, 20, 55, 15, 'JPG');
    this.SetFont('Arial','B',15);
	this.Ln(20);
    this.Cell(190,10,'Informe Resultado','','','C');
    this.Ln(20);
}
this.Footer=function Footer()
{
    
    this.SetY(-15);
    this.SetTextColor(186,186,186)
    this.SetFont('Arial','B',10);
    this.Cell(0,10,'' + this.PageNo() + '',0,0,'R');
}
