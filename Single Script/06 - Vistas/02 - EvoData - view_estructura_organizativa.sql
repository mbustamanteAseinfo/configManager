IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'eor.estructura_organizativa_v')
                    AND type IN ( N'V' ) )
DROP VIEW eor.estructura_organizativa_v
GO
CREATE VIEW [eor].[estructura_organizativa_v]
AS
select	cia.cia_codigo as codigo_compania,
		cia.cia_descripcion as compania,
		unidades_negocio.codigo_unidad_padre, 
		unidades_negocio.unidad_padre, 
		unidades_negocio.codigo_unidad_hija, 
		unidades_negocio.unidad_hija,
		case when plazas.codigo_plaza_padre is null then 0 else plazas.codigo_plaza_padre end codigo_plaza_padre,
		case when plazas.plaza_padre is null then 'Sin Padre' else plazas.plaza_padre end plaza_padre,
		plazas.codigo_plaza_hija,
		plazas.plaza_hija,
		puesto.pue_codigo,
		puesto.pue_nombre,
		centros_de_trabajo.cdt_codigo,
		centros_de_trabajo.cdt_descripcion 
from 
(select	case when ui.uni_codigo is null then 0 else ui.uni_codigo end as codigo_unidad_padre, 
		case when ui.uni_descripcion is null then 'Sin Padre' else ui.uni_descripcion end as unidad_padre, 
		uo.uni_codigo as codigo_unidad_hija, 
		uo.uni_descripcion as unidad_hija,
		uo.uni_codcia as codigo_compania 
from eor.uni_unidades uo 
outer apply (select ui.uni_descripcion, ui.uni_codigo from eor.uni_unidades ui where ui.uni_codigo = uo.uni_coduni_padre) ui) unidades_negocio
inner join 
(select p.plz_coduni, p.plz_codpue, p.plz_codcdt,pjp.pjf_codplz_jefe codigo_plaza_padre, pjp.plz_nombre plaza_padre, p.plz_codigo codigo_plaza_hija, p.plz_nombre plaza_hija from eor.plz_plazas p outer apply (select top 1 * from eor.pjf_plaza_jefes pj inner join eor.plz_plazas pz on pz.plz_codigo = pj.pjf_codplz_jefe where pj.pjf_codplz = p.plz_codigo and pj.pjf_tipo_relacion = 'A') pjp) plazas on unidades_negocio.codigo_unidad_hija = plazas.plz_coduni
left join eor.pue_puestos puesto on puesto.pue_codigo = plazas.plz_codpue
left join eor.cdt_centros_de_trabajo centros_de_trabajo on centros_de_trabajo.cdt_codigo = plazas.plz_codcdt
inner join eor.cia_companias cia on cia.cia_codigo = unidades_negocio.codigo_compania
GO

