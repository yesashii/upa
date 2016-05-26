select distinct bib#,collection,location from item 
where collection in ('RES', 'CG', 'LIT', 'REF', 'CAD') and location in ('BC','BP','BM1','BAQ')
