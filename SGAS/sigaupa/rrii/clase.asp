<!-- #include file = "../biblioteca/fpdf.asp" -->
<%

Set pdf=CreateJsObject("FPDF")

class PDF_MC_Table 

private widths
private aligns

Sub SetWidths(w)

    'Set the array of column widths
   widths=w
end Sub

Sub SetAligns(a)

    'Set the array of column alignments
    aligns=a
end Sub

Sub Row(data)

    'Calculate the height of the row
    nb=0
    for i=0 to data Step 1
        nb=max(nb,pdf.NbLines(pdf.widths[i],data[i]))
    h=5*nb
    'Issue a page break first if needed
	next
    pdf.CheckPageBreak(h)
    'Draw the cells of the row
    for(i=0 data Step 1
    
        w=pdf.widths[i]
        'a=isset(pdf.aligns[i]) ? this->aligns[i] : "L"
		if pdf.aligns[i]<>"" then 
		a=pdf.aligns[i]
		else
		a="L"
		end if
        'Save the current position
        x=pdf.GetX()
        y=pdf.GetY()
        'Draw the border
        pdf.Rect x,y,w,h
        'Print the text
        pdf.MultiCell w,5,data[i],0,a
        'Put the position to the right of the cell
        pdf.SetXY(x+w,y)
    next
    'Go to the next line
    pdf.Ln(h)
end sub

Sub CheckPageBreak(h)

    'If the height h would cause an overflow, add a new page immediately
    if(pdf.GetY()+h>pdf.PageBreakTrigger)
        pdf.AddPage(pdf.CurOrientation)
end sub

function NbLines(w,txt)

    'Computes the number of lines a MultiCell of width w will take
    cw=&pdf.CurrentFont "cw" 
    if(w==0)
        w=this->w-pdf.rMargin - pdf.x
    wmax=(w-2*pdf.cMargin)*1000/pdf.FontSize
    s=str_replace("\r",'',txt)
    nb=strlen(s)
    if(nb>0 and s[nb-1]=="\n")
        nb--
    sep=-1
    i=0
    j=0
    l=0
    nl=1
    while(i<nb)
    
        c=s[i]
        if c="\n" then
        
            i++
            sep=-1
            j=i
            l=0
            nl++
            continue
        end if
        
		if(c=" "  then
            sep=i
        l+=cw[c]
		end if
        if l>wmax then
        
            if sep==-1 then
            
                if(i==j)
                    i++
            
            else
                i=sep+1
            sep=-1
            j=i
            l=0
            nl++
       		end if
        else
            i++
		end if
    wend
    return nl
end function
end class

%>
