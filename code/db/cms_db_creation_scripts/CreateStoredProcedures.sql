/****** Object:  StoredProcedure [dbo].[sp_getMasterListItems]    Script Date: 08/26/2007 11:38:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[sp_getMasterListItems]
(

@thisMasterID int

)

AS

SELECT LabelID, LabelCode, LabelName, LabelGroupID
FROM t_Label
WHERE LabelGroupID = @thisMasterID
ORDER BY LabelName

	return

/****** Object:  StoredProcedure [dbo].[sp_getMasterListName]    Script Date: 08/26/2007 11:38:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sp_getMasterListName]
@thisMasterID integer
As

SELECT LabelName, LabelCode
FROM t_Label
WHERE LabelID = @thisMasterID

	return

/****** Object:  StoredProcedure [dbo].[sp_getMasterLists]    Script Date: 08/26/2007 11:38:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[sp_getMasterLists]

AS

SELECT LabelID, LabelCode, LabelName, LabelGroupID
FROM t_Label
WHERE LabelParent = 1
ORDER BY LabelName

	return