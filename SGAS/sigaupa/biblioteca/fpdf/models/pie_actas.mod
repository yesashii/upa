this.Header=function Header()
{
 
}
this.Footer=function Footer()
{
    
    this.SetY(-20);
	this.SetFont ('times','B',8);
	this.SetX(20);
	this.Cell (4,0,'A',0,0,'L'); 
	this.SetX(24);
	this.Cell (4,0,'=',0,0,'C');   	
	this.SetFont ('times','',8);
	this.SetX(28);
	this.Cell (62,0,'Aprobado.',0,0,'L'); 
	this.SetFont ('times','B',8);
	this.SetX(90);
	this.Cell (6,0,'R',0,0,'L'); 
	this.SetX(96);
	this.Cell (4,0,'=',0,0,'C');   	
	this.SetFont ('times','',8);
	this.SetX(100);
	this.Cell (82,0,'Reprobado.',0,0,'L'); 
	this.SetY(-16);
	this.SetFont ('times','B',8);
	this.SetX(20);
	this.Cell (4,0,'RI',0,0,'L'); 
	this.SetX(24);
	this.Cell (4,0,'=',0,0,'C');   	
	this.SetFont ('times','',8);
	this.SetX(28);
	this.Cell (62,0,'Reprobado por inasistencia.',0,0,'L'); 
	this.SetFont ('times','B',8);
	this.SetX(90);
	this.Cell (6,0,'',0,0,'L'); 
	this.SetX(96);
	this.Cell (4,0,'',0,0,'C');   	
	this.SetFont ('times','',8);
	this.SetX(100);
	this.Cell (82,0,'',0,0,'L'); 
	this.SetY(-15);
    this.SetTextColor(186,186,186);
    this.SetFont('Arial','B',8);
    this.Cell(0,10,'' + this.PageNo() + '',0,0,'R');
}
