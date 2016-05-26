this.Header=function Header()
{
	this.Image ('../imagenes/logo_upa_nuevo.jpg', 10, 20, 55, 15, 'JPG');
    this.Ln(40);
	this.Image ('../imagenes/prueba.jpg', 20, 40, 180, 30, 'JPG');
}
this.Footer=function Footer()
{
    this.SetY(-15);
    this.SetFont('Arial','B',10);
    this.Cell(0,10,'' + this.PageNo() + '',0,0,'R');
}
