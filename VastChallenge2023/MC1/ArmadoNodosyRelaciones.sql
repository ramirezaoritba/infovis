-- Nodos con 3 datos, id, country, type (type para identificar tipo de nodo)
select a.id, a.country, a.type
from nodes a
where a.type in  ('person', 'company' )
order by a.type, a.id

-- Nodos con 2 datos, id, type (type para identificar tipo de nodo)
select a.id, a.type
from nodes a
where a.type not in  ('person', 'company' )
order by a.type, a.id

-- Nodos con 1 dato, id (NO tiene type para identificar tipo de nodo)
select a.id
from nodes a
where a.type is NULL
order by a.id

-- Nodos que que no pueden ser identificados por id
select * from nodes where id in 
(
select a.id
from nodes a
group by a.id
having count(*) > 1
 )
order by id, type

-- elimino los nodos que tienen type null y el id en más de 1 identificador
delete from nodes where type is null
and id in (
select a.id
from nodes a
group by a.id
having count(*) > 1
 )

-- elimino nodos que tienen el mismo el en más de un nodo, ambos con type, 
-- de forma arbitraria
delete from nodes where type = 'vessel' and
id in ('18','23','621','626','77')

delete from nodes where type = 'movement' and
id in ('38')

delete from nodes where type = 'event' and
id in ('90')
 
-- armo los archivos CSV para iportar a Neo4J
-- 1 dato
select 'id:id',':LABEL' 
union all
select a.id, 'unknown'
from nodes a
where a.type is NULL

-- 2 datos
select 'id:id',':LABEL' 
union all
select a.id, a.type
from nodes a
where a.type not in  ('person', 'company' )

-- 3 datos
select 'id:id','country',':LABEL'
union all
select a.id, a.country, a.type
from nodes a
where a.type in  ('person', 'company' )

-- armo datos de relaciones
SELECT ':START_ID', 'weight:float', 'key:int',':END_ID',':TYPE'
-- lo concateno a mano, ya que no se puede hacer el union con distintos tipos de dato
SELECT a.source, a.weight, a.key, a.target, a.type 
from links a

