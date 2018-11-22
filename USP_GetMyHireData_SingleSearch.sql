
  
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetMyHireData_SingleSearch] 
	-- Add the parameters for the stored procedure here
(
@DemandId varchar(50)
)
AS
BEGIN
	
	select ErrorStatus,SentToMyHire,
	LastUpdated,OneBusStatus,ReceivedByMyHire,ACKMessage,MyHireStatus,JobRequestID,
	PositionIdGUID,PositionId,RequisitionId,RequisitionStatus,
	RequisitionChangeDate,RequisitionSOCreationDate,PositionCountry,PositionLocationstateProvince,
	PositionLocationLocation,Division,department,
	SubBu,PositionRoleJobTitle,PositionRoleJobRole,PositionTitle 
	 ,Local_Grade 
    ,MINIMUM_GRADE  
    ,RequisitionOriginator 
    ,Requestor 
    ,RequisitionCreationRctmntStrtDate  
    ,RequisitionjobStartDate  
    ,RequistionJobEndDate 
    ,PositionFTE 
	,PrjName  
    ,PositionFulfilmentChannel  
    ,Currency 
    ,CustHotSkill
    ,CusthotSkillbonus
    ,Status  
    ,FullFillmentType  
    ,entity 
    ,AccountName  
    ,HiringOffice  
    ,HiringManager  
	,Supervisor 
    ,R2D2Status  
    ,RecruiterGGID  
    ,ServiceLine  
    ,Changedate  
    --,ONEBUS_JR_POSTED  
    --,MyHireMessage  
    --,ACKDate  
	from vw_MyHireExport_Status where 
	--RequisitionId =''+@DemandId+''  or PositionId=''+@DemandId+''
	convert(int,RequisitionId) =convert(int,''+@DemandId+'')  or convert(int,PositionId)=convert(int,''+@DemandId+'')
	--{
	--Concat(requisitionid,'',positionid,'') like '%'+@DemandId+'%'
 
 END