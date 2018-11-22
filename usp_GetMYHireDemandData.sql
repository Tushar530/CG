  
CREATE  PROCEDURE [dbo].[usp_GetMYHireDemandData]
(
@Details MyhireDemandTable READONLY
)
AS
BEGIN

--SELECT B.PositionId,	B.RequisitionId,	RequisitionStatus,	RequisitionChangeDate,	
--		RequisitionSOCreationDate,	PositionCountry,	PositionLocationstateProvince,
--		PositionLocationLocation,	Division,	department,	SubBu,	PositionRoleJobTitle,
--		PositionRoleJobRole,	PositionTitle,	SkillType,PrimarySkills,	SecondarySkills,
--		Category,	EmployeeType,Local_Grade,	MINIMUM_GRADE,	RequisitionOriginator,	
--		Requestor,	RequisitionCreationRctmntStrtDate,RequisitionjobStartDate,RequistionJobEndDate,	
--		PositionFTE,	 PrjName,	PositionFulfilmentChannel,Currency,	CustHotSkill,CusthotSkillbonus,
--		JobCode,	Jobfamily,	Status,	FullFillmentType,	entity,	OutgoingEmployee,	AccountName,	
--		HiringOffice,	HiringManager,	Supervisor,R2D2Status,	RecruiterGGID,	ServiceLine	Changedate,
--		ONEBUS_JR_POSTED	 
--FROM @Details A ,Retain_Web_Export.dbo.MyHire_Export_IU B
--where B.positionid = A.positionid

select ErrorStatus,	SentToMyHire,	LastUpdated	,OneBusStatus,	ReceivedByMyHire,	ACKMessage,
	MyHireStatus,	JobRequestID,	PositionIdGUID,	b.PositionId,	b.RequisitionId,	RequisitionStatus,	RequisitionChangeDate,
	RequisitionSOCreationDate,	PositionCountry,	PositionLocationstateProvince,	PositionLocationLocation,
	Division,	department,	SubBu,	PositionRoleJobTitle,	PositionRoleJobRole,	PositionTitle,
	SkillType,	PrimarySkills,	SecondarySkills,	Category,	EmployeeType,	Local_Grade,
	MINIMUM_GRADE,	RequisitionOriginator,	Requestor,	RequisitionCreationRctmntStrtDate,	RequisitionjobStartDate,
	RequistionJobEndDate,	PositionFTE,	PositionIsBillable, RequisitionBillingStartDate,	PositionRequiresClientInterview,
	PrjName,	PositionFulfilmentChannel,	PushToMyMobility,	pushToExternalRecruitment,	Currency,	
	DailyRateSalaryMin,	DailyratesalaryMax,	JobReqStatus,	CustHotSkill,	CusthotSkillbonus,
	JobCode,	Jobfamily,	Status,	FullFillmentType,	entity,	OutgoingEmployee,	AccountName,
	HiringOffice,	HiringManager,	Supervisor,	R2D2Status,	RecruiterGGID,	ServiceLine,	Changedate
  From @Details P ,vw_MyHireExport_Status B where convert(int,B.PositionId)=convert(int,P.PositionId) or 
convert(int,B.RequisitionId)=convert(int,P.RequisitionId)

END
