SELECT campo1, count(*)
FROM tabla1
GROUP BY campo1
HAVING count(*) > 1