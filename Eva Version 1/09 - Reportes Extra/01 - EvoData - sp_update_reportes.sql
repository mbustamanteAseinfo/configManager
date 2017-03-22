IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'gen.update_uploads_rpt')
                    AND type IN ( N'P', N'PC' ) )
/****** Object:  StoredProcedure [pa].[aupla_autoriza_planilla]    Script Date: 16-01-2017 2:23:40 PM ******/
DROP PROCEDURE gen.update_uploads_rpt
GO
CREATE PROCEDURE gen.update_uploads_rpt
   @reportName  VARCHAR(MAX),
   @url    VARCHAR(MAX)
as
begin
	UPDATE cfg.upf_upload_files SET upf_ruta = @url WHERE upf_nombre_archivo = @reportName AND upf_usuario_grabacion = 'EVA';
end
