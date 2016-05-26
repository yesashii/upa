this.Header=function Header()
{
 
}
this.Footer=function Footer()
{
    
    this.SetY(-35);
	this.SetFont ('times','B',9);
	this.SetX(20);
	this.Cell (4,0,'A',0,0,'L'); 
	this.SetX(24);
	this.Cell (4,0,'=',0,0,'C');   	
	this.SetFont ('times','',9);
	this.SetX(28);
	this.Cell (62,0,'Asignatura aprobada.',0,0,'L'); 
	this.SetFont ('times','B',9);
	this.SetX(90);
	this.Cell (6,0,'H',0,0,'L'); 
	this.SetX(96);
	this.Cell (4,0,'=',0,0,'C');   	
	this.SetFont ('times','',9);
	this.SetX(100);
	this.Cell (82,0,'Asignatura Aprobada por Homologación.',0,0,'L'); 
	this.SetY(-31);
	this.SetFont ('times','B',9);
	this.SetX(20);
	this.Cell (4,0,'C',0,0,'L'); 
	this.SetX(24);
	this.Cell (4,0,'=',0,0,'C');   	
	this.SetFont ('times','',9);
	this.SetX(28);
	this.Cell (62,0,'Asignatura aprobada por Convalidación.',0,0,'L'); 
	this.SetFont ('times','B',9);
	this.SetX(90);
	this.Cell (6,0,'RC',0,0,'L'); 
	this.SetX(96);
	this.Cell (4,0,'=',0,0,'C');   	
	this.SetFont ('times','',9);
	this.SetX(100);
	this.Cell (82,0,'Asignatura Reprobada por Conocimientos Relevantes.',0,0,'L'); 
	this.SetY(-27);
	this.SetFont ('times','B',9);
	this.SetX(20);
	this.Cell (4,0,'S',0,0,'L'); 
	this.SetX(24);
	this.Cell (4,0,'=',0,0,'C');   	
	this.SetFont ('times','',9);
	this.SetX(28);
	this.Cell (62,0,'Asignatura aprobada por Suficiencia.',0,0,'L'); 
	this.SetFont ('times','B',9);
	this.SetX(90);
	this.Cell (6,0,'RS',0,0,'L'); 
	this.SetX(96);
	this.Cell (4,0,'=',0,0,'C');   	
	this.SetFont ('times','',9);
	this.SetX(100);
	this.Cell (82,0,'Asignatura Reprobada por Suficiencia.',0,0,'L'); 
	this.SetY(-23);
	this.SetFont ('times','B',9);
	this.SetX(20);
	this.Cell (4,0,'R',0,0,'L'); 
	this.SetX(24);
	this.Cell (4,0,'=',0,0,'C');   	
	this.SetFont ('times','',9);
	this.SetX(28);
	this.Cell (62,0,'Asignatura Reprobada.',0,0,'L'); 
	this.SetFont ('times','B',9);
	this.SetX(90);
	this.Cell (6,0,'RI',0,0,'L'); 
	this.SetX(96);
	this.Cell (4,0,'=',0,0,'C');   	
	this.SetFont ('times','',9);
	this.SetX(100);
	this.Cell (82,0,'Asignatura Reprobada por Inasistencia.',0,0,'L'); 
	this.SetY(-17);
	this.SetX(20)
	this.Cell (180,0,'Si detecta algún antecedente que no corresponda, comuníquese con el Departamento de Títulos y Grados.',0,0,'L'); 
    this.SetY(-15);
    this.SetTextColor(186,186,186);
    this.SetFont('Arial','B',8);
    this.Cell(0,10,'' + this.PageNo() + '',0,0,'R');
}
