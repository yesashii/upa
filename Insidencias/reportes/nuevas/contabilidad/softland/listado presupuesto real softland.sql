select * from softland.cwmovim 
where pctcod='2-10-070-10-000003' 
and cpbano=2008 
and movhaber not in (0)
and movglosa like '%PSU%'
--and cajcod like '%01032%'
--and datepart(month,movfv)=4