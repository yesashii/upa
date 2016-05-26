this.Header=function Header()
{
	this.Image ('../imagenes/logo_upa_negro.jpg', 10, 20, 55, 15, 'JPG');
    this.SetFont('Arial','B',8);
	this.Ln(25);
	this.Cell(190,10,'Dirección de Relaciones Internacionales','','','l');
	this.SetFont('Arial','B',15);
	this.Ln(15);
    this.Cell(190,10,'Datos Convenio','','','C');
    this.Ln(20);
}
this.Footer=function Footer()
{
    this.SetY(-15);
    this.SetFont('Arial','B',10);
    this.Cell(0,10,'' + this.PageNo() + '',0,0,'R');
}
