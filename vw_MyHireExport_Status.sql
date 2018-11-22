

  


CREATE VIEW  [dbo].[vw_MyHireExport_Status] 
AS




WITH
AllSkillsText( AS_TRO_ID , CRITERIA)
as
(
	Select distinct ST2.CRI_TRO_ID, 
		substring(
			(
				Select '||'+ST1.CRITERIA  AS [text()]
				From (SELECT src.SRC_TRO_ID as CRI_TRO_ID
		,cri.CRI_DISPLAY_VALUE as CRITERIA
	  FROM [SRC] (nolock) as [SRC]
	inner join [CRI] (nolock) as [CRI] on src.SRC_ID = cri.CRI_TBL_ID and cri.CRI_TYPE = 'S') ST1
				Where ST1.CRI_TRO_ID = ST2.CRI_TRO_ID
				ORDER BY ST1.CRI_TRO_ID
				For XML PATH ('')
			), 3, 1000) [TRO_O_CRITERIA]
	From (SELECT src.SRC_TRO_ID as CRI_TRO_ID
		,cri.CRI_DISPLAY_VALUE
	  FROM [SRC] (nolock) as [SRC]
	inner join [CRI](nolock) as [CRI] on src.SRC_ID = cri.CRI_TBL_ID) ST2
),
RCRIT (CRI_TRO_ID,CRM_TBL,CRM_FLD,CRV_VALUE,FLD_OLDEST,FLD_NEWEST)
as
(
	SELECT src.SRC_TRO_ID as CRI_TRO_ID
		,CRM_TBL
		,CRM_FLD
		,CRV_VALUE
		,ROW_NUMBER() over (partition by SRC_TRO_ID,CRM_FLD order by SRC_CHANGE_DATE asc) as FLD_OLDEST
		,ROW_NUMBER() over (partition by SRC_TRO_ID,CRM_FLD order by SRC_CHANGE_DATE desc) as FLD_NEWEST
	  FROM [SRC] (nolock) as [SRC]
	inner join [CRI] (nolock) as [CRI] on src.SRC_ID = cri.CRI_TBL_ID
	inner join [CRV] (nolock) as [CRV] on crv.CRV_CRI_ID = cri.CRI_ID
	inner join [CRM] (nolock) as [CRM] on cri.CRI_ID = crm.CRM_CRI_ID
	WHERE CRI_TYPE = 'R'
),
SCRIT (CRI_TRO_ID,ATR_DESCR,MUSTHAVE,ATR_FAMILY,PAR_ATR_ID,PAT_ATR_DESCR,FAM_ATR_ID,FAM_ATR_DESCR,ATR_OLDEST,ATR_NEWEST)
as
(
	SELECT distinct src.SRC_TRO_ID as CRI_TRO_ID
		,atr.ATR_DESCR
		,SRC.SRC_ISMUSTHAVE_BIT as MUSTHAVE
		,ACL_DESCR as ATR_FAMILY
		,PATR.ATR_ID as PAR_ATR_ID
		,PATR.ATR_DESCR as PAR_ATR_DESCR
		,FATR.ATR_ID as FAM_ATR_ID
		,FATR.ATR_DESCR as FAM_ATR_DESCR
		,ROW_NUMBER() over (partition by SRC_TRO_ID,PATR.ATR_ID order by SRC_CHANGE_DATE asc) as ATR_OLDEST
		,ROW_NUMBER() over (partition by SRC_TRO_ID,PATR.ATR_ID order by SRC_CHANGE_DATE desc) as ATR_NEWEST
	  FROM [SRC] (nolock) as [SRC]
	inner join [CRI] (nolock) as [CRI] on src.SRC_ID = cri.CRI_TBL_ID
	inner join [CRS] (nolock) as [CRS] on cri.CRI_ID = crs.CRS_CRI_ID
	inner join [ATR] (nolock) as [ATR] on atr.ATR_ID = crs.CRS_ATR_ID
	inner join [ACL] (nolock) as [ACL] on ACL_ID = ATR.ATR_ACL_ID
	inner join [ATC] (nolock) as [ATC] on atc.ATC_CHD_ATR_ID = atr.ATR_ID
	LEFT OUTER JOIN [ATC] (nolock) as PATC on PATC.ATC_CHD_ATR_ID = ATC.ATC_PAR_ATR_ID
	LEFT OUTER JOIN [ATC] (nolock) as PPATC on PPATC.ATC_CHD_ATR_ID = PATC.ATC_PAR_ATR_ID
	INNER JOIN [ATR] (nolock) as PATR on PATR.ATR_ID = ISNULL(PPATC.ATC_PAR_ATR_ID,ISNULL(PATC.ATC_PAR_ATR_ID,ATC.ATC_PAR_ATR_ID))
	INNER JOIN [ATR] (nolock) as FATR on FATR.ATR_ID = ISNULL(PPATC.ATC_CHD_ATR_ID,ISNULL(PATC.ATC_CHD_ATR_ID,ATC.ATC_CHD_ATR_ID))
),
JRLastUpdate ( PositionId, Changedate , OneBusStatus, OLDEST , NEWEST )
as
(
		SELECT PositionId
			  ,Changedate
			  ,ONEBUS_JR_POSTED
			  ,ROW_NUMBER() over (partition by [PositionId] order by Changedate asc) as OLDEST
			  ,ROW_NUMBER() over (partition by [PositionId] order by Changedate desc) as NEWEST
		FROM [Retain_Web_Export].[dbo].[MyHire_Export_IU] as iu
		LEFT OUTER JOIN [Retain_Web_Export].[dbo].[FirstTimeSubmittedTMR] as f on f.TRO_ID = iu.PositionId
)
,
ACKUpdate ( PositionId, ACKStatus , ACKMessage, OLDEST , NEWEST )
as
(
		SELECT PositionId
			  ,ErrorStatus
			  ,[Message]
			  ,ROW_NUMBER() over (partition by [PositionId] order by UpdatedDate asc) as OLDEST
			  ,ROW_NUMBER() over (partition by [PositionId] order by UpdatedDate desc) as NEWEST
		FROM [Retain_Web_Import].[dbo].[MYHire_requisitionAck] as ACK
		WHERE PositionId is not null AND PositionId <> 'null'
)
,
StatusUpdate ( PositionId, MyHireStatus , JRID, OLDEST , NEWEST )
as
(
		SELECT PositionId
			  ,[status]
			  ,JorReqID
			  ,ROW_NUMBER() over (partition by [PositionId] order by [lastModified] asc) as OLDEST
			  ,ROW_NUMBER() over (partition by [PositionId] order by [lastModified] desc) as NEWEST
		FROM [Retain_Web_Import].[dbo].[MyHire_requisitionStatus] as MyHireS
)



SELECT --SCM.SBU,SCM.Country,Entity,ZPU_SBU_CODE,ZPU_COUNTRY,
	   CASE WHEN ZPU_ID is null THEN 'No Production Unit'
			WHEN Entity is null THEN 'Entity not configured'
			WHEN TRO_FTE > 1 THEN 'Can not have more than 1 person'
			ELSE 'Can Push to MyHire' END as ErrorStatus
	  ,CASE WHEN JRU.Changedate is null THEN 'Not Sent' ELSE 'Sent' END as SentToMyHire
	  ,convert(date,JRU.Changedate) as LastUpdated
	  ,CASE WHEN JRU.OneBusStatus is null THEN 'Not Sent' WHEN JRU.OneBusStatus = 'H' THEN 'Special Character' ELSE 'Pickedup' END as OneBusStatus
	  ,CASE WHEN JRU.Changedate is null THEN 'Not Sent' ELSE ISNULL(ACK.ACKStatus,'NO ACK') END as ReceivedByMyHire
	  ,ACKMessage
	  ,CASE WHEN JRU.Changedate is null THEN 'Not Sent' ELSE ISNULL(MHS.MyHireStatus,'No Status') END as MyHireStatus
	  ,MHS.JRID as [JobRequestID]
	  ,[TRO_ID] as [PositionIdGUID]
      ,[TRO_ID] as [PositionId]
      ,[TMR_ID] as [RequisitionId]
      ,[TSA_DESCR] as [RequisitionStatus]
      ,cast(TMR_CHANGE_DATE as date) as [RequisitionChangeDate]
      ,cast(TMR_REQUESTED_ON as date) as [RequisitionSOCreationDate]
      ,[TRO_DELIVERY_COUNTRY] as [PositionCountry]
      ,[TRO_MYHIRE_STATE] as [PositionLocationstateProvince]
      ,[TRO_MYHIRE_LOCATION] as [PositionLocationLocation]
      ,[ZPU_SBU_NAME] as [Division]
      ,[ZPU_BU_NAME]as [department]
      ,[ZPU_CODE] as [SubBu]
      ,'' as [PositionRoleJobTitle]
      ,(select [MYhire Role] from Retain_Web_Export.dbo.RoleLookupTable where [Global Grade] = [GGCRIT].[CRV_VALUE] 
					AND [ATR_Id] = RLCRIT.FAM_ATR_ID) as [PositionRoleJobRole]
      ,'' as [PositionTitle]
      ,'Generic' as [SkillType]
      ,PSCRIT.ATR_DESCR as [PrimarySkills]
      ,AllSkillsText.CRITERIA as [SecondarySkills]
      ,CASE WHEN p.pu is not null then p.peoplegroup
			WHEN RLCRIT.FAM_ATR_DESCR like '%(DSS)%' THEN 'DSS'
			WHEN RLCRIT.FAM_ATR_DESCR like '%(DSP)%' THEN 'DSP'
            ELSE 'CSS' END as [Category]
      ,'All' as [EmployeeType]
      ,[LGCRIT].[CRV_VALUE] as [Local_Grade]
      ,[GGCRIT].[CRV_VALUE] as [MINIMUM_GRADE]
      ,(select top 1 RES_DESCR from RES where RES_ID = TMR.TMR_ORGINATOR_RES_ID) as [RequisitionOriginator]
      ,(select top 1 RES_DESCR from RES where RES_ID = TMR.TMR_REQUESTED_BY_RES_ID) as [Requestor]
      ,cast(TMR_REQUESTED_ON as date) as [RequisitionCreationRctmntStrtDate]
      ,cast(TRO.TRO_START as date) as [RequisitionjobStartDate]
      ,cast(TRO.TRO_END as date) as [RequistionJobEndDate]
      ,[TRO_FTE] as [PositionFTE]
      ,[TRO_BILLABLE] as [PositionIsBillable]
      ,cast(TRO.TRO_START as date) as [RequisitionBillingStartDate]
      ,[TRO_CLIENT_INTERVIEW] as [PositionRequiresClientInterview]
      ,ISNULL([ZPR_NAME],[JOB_DESCR]) as [PrjName]
      ,[TRO_SOURCE_MAP] as [PositionFulfilmentChannel]
--      ,CAST(TRO.[TRO_NOTES] as VARCHAR(MAX)) as [JobDescription]
      ,NULL as [jobDescriptionAppendix1]
      ,NULL as [jobDescriptionAppendix2]
      ,'Yes' as [PushToMyMobility]
      ,'Yes' as [pushToExternalRecruitment]
      ,Case when NULLIF(TRO.[TRO_CUR_CODE], '') IS NULL then SCM.[Currency_Code] 
			Else TRO.[TRO_CUR_CODE] END AS [Currency]
      , isnull(TRO_DAILY_RATE,0) [DailyRateSalaryMin]
	  , isnull(TRO_DAILY_RATE,0) [DailyratesalaryMax]
      ,0 as [JobReqStatus]
      ,[TRO_HOTSKILL] as [CustHotSkill]
      ,[TRO_HOTSKILLBONUS] as [CusthotSkillbonus]
      ,' ' as [JobCode]
      ,' ' as [Jobfamily]
      ,'Pending Approval' as [Status]
      ,[TRO_HEADCOUNT_TYPE] as [FullFillmentType]
      ,SCM.[Entity] as [entity]
      ,ISNULL(ORES.RES_DESCR,'') as [OutgoingEmployee]
      ,ISNULL(CLT.CLT_DESCR,OPP_CLT.CLT_DESCR) as [AccountName]
      ,[ZOF_DESCR] as [HiringOffice]
      ,(select top 1 RES_DESCR from RES where RES_ID = TMR.TMR_REQUESTED_BY_RES_ID) as [HiringManager]
      ,(select top 1 RES_DESCR from RES where RES_ID = TMR.TMR_ORGINATOR_RES_ID) as [Supervisor]
      ,CASE WHEN JRLU.PositionId is NULL THEN 'CREATE' ELSE 'UPDATE' END as [R2D2Status]
      ,(SELECT top 1 GGIDRecruitementMngr from Retain_Web_Export.dbo.MappingBuRecruitmentMngr where BUCODE = ZPU_BU_CODE) as [RecruiterGGID]
      ,SUBSTRING(ISNULL(TRO.TRO_MYHIRE_SL,''),charindex('--',isnull(TRO.TRO_MYHIRE_SL,'')) + 2,len(isnull(TRO.TRO_MYHIRE_SL,''))) as [ServiceLine]
      ,[TRO_CHANGE_DATE] as [Changedate]
	  ,URES.[RES_DESCR] as [Changed By]
	FROM TRO (nolock) as TRO
INNER JOIN TMR (nolock) as TMR on TMR_ID = TRO_TMR_ID
INNER JOIN TSA (nolock) as TSA on TSA_ID = TMR_TSA_ID
LEFT OUTER JOIN ZPU (nolock) as ZPU on ZPU_ID = TRO_ZPU_ID
LEFT OUTER JOIN SBUCountryEntityMapping as SCM on SCM.SBU = ZPU_SBU_CODE and SCM.Country = ZPU_COUNTRY
LEFT OUTER JOIN JRLastUpdate as JRLU on JRLU.PositionId = TRO_ID and JRLU.NEWEST = 1
LEFT OUTER JOIN Z_COUNTRY on  Z_COUNTRY.COUNTRY_CODE = ZPU_COUNTRY
LEFT OUTER JOIN JOB (nolock) as JOB on JOB_ID = TMR_JOB_ID
LEFT OUTER JOIN CLT (nolock) as CLT on CLT.CLT_ID = JOB_CLT_ID
LEFT OUTER JOIN ZPR (nolock) as ZPR on ZPR_ID = JOB_ZPR_ID
LEFT OUTER JOIN ZOP (nolock) as ZOP on ZOP_ID = TMR_ZOP_ID
LEFT OUTER JOIN CLT (nolock) as OPP_CLT on OPP_CLT.CLT_ID = ZOP_CLT_ID
LEFT OUTER JOIN ZOF (nolock) as ZOF on ZOF_ID = TRO_ZOF_ID
LEFT OUTER JOIN RCRIT as GGCRIT on GGCRIT.CRI_TRO_ID = TRO_ID and GGCRIT.CRM_FLD = 'RES_GRADE' and GGCRIT.FLD_OLDEST=1
LEFT OUTER JOIN RCRIT as LGCRIT on LGCRIT.CRI_TRO_ID = TRO_ID and LGCRIT.CRM_FLD = 'RES_LOCAL_GRADE' and LGCRIT.FLD_OLDEST=1
LEFT OUTER JOIN SCRIT as RLCRIT on RLCRIT.CRI_TRO_ID = TRO_ID and RLCRIT.PAR_ATR_ID = 6342 and RLCRIT.ATR_OLDEST = 1
LEFT OUTER JOIN SCRIT as PSCRIT on PSCRIT.CRI_TRO_ID = TRO_ID and PSCRIT.PAR_ATR_ID = 2557 and PSCRIT.ATR_OLDEST = 1
LEFT OUTER JOIN AllSkillsText on AS_TRO_ID = TRO_ID
LEFT OUTER JOIN peoplegroupmapping (nolock) as p on p.pu = right(ZPU_CODE,4)
LEFT OUTER JOIN RES as ORES on ORES.RES_ID = TRO_RES_ID
LEFT OUTER JOIN JRLastUpdate as JRU on JRU.PositionId = TRO_ID and JRU.NEWEST = 1
LEFT OUTER JOIN ACKUpdate as ACK on ACK.PositionId = TRO_ID and ACK.NEWEST = 1
LEFT OUTER JOIN StatusUpdate as MHS on MHS.PositionId = TRO_ID 	AND isnumeric(MHS.PositionId) = 1 and MHS.NEWEST = 1
LEFT OUTER JOIN RES as URES on URES.RES_ID = [TRO_CHANGE_RES_ID]

WHERE TRO_SOURCE_MAP in ('Internal & Recruitment','All Channels')
	AND TSA_ID not in (3,5,6,11)


