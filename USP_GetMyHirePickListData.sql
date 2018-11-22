 
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetMyHirePickListData] 
	-- Add the parameters for the stored procedure here
(
@PickListType varchar(50)
)
AS
BEGIN
	 

	 If (@PickListType = 'HiringPU')
	 BEGIN
	  Select ZPU_DESCR as PU_Descr,	ZPU_CODE as PU_Code,ZPU_REGION as  Region,
			ZPU_SBU_CODE as SBU_CODE,ZPU_SBU_NAME as SBU_NAME,ZPU_BU_CODE AS BU_CODE,
			ZPU_BU_NAME as BU_NAME,ZPU_COUNTRY as PU_Country 
	  from ZPU where ZPU_STATUS=1
	 END

	 Else IF (@PickListType = 'ServiceLine')
	 BEGIN 
		Select  SUBSTRING(ISNULL(FDD_VALUE,''),charindex('--',isnull(FDD_VALUE,'')) + 2,len(isnull(FDD_VALUE,''))) as ServiceLine
		FROM FDD where FDD_FIELD='TRO_MYHIRE_SL'
     END

	 ELSE IF(@PickListType = 'PositionLocationLocation')
	 BEGIN 
		select FDD_VALUE as PositionLocationLocation from FDD where FDD_FIELD='TRO_MYHIRE_LOCATION'
	 END

	  
	  ELSE IF(@PickListType = 'GradeDetails')
	 BEGIN
	  select A.GRA_DESCR as GlobalGrade,B.LGR_DESCR as LocalGrade From GRA A,LGR B where A.GRA_ID=B.LGR_GRA_ID
	 END

	  ELSE IF(@PickListType = 'Entity')
	 BEGIN
		select SBU,	Country,	Entity,	Currency_Code,	LocalCSSValue from SBUCountryEntityMapping
	 END

	 Else
	 BEGIN 
		Print 'Please Select Picklist Type'
	 END
END
