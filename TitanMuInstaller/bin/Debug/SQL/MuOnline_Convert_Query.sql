ALTER TABLE Character ALTER COLUMN Inventory VARBINARY(1728) NULL
GO

ALTER TABLE DefaultClassType ALTER COLUMN Inventory VARBINARY(1728) NULL
GO

ALTER TABLE warehouse ALTER COLUMN Items VARBINARY(1920) NULL
GO

ALTER TABLE T_FriendMail ALTER COLUMN Photo BINARY(18) NULL
GO

ALTER TABLE Character ADD FruitPoint INT DEFAULT(0) 
GO

update Character set FruitPoint = 0
GO

CREATE TABLE [dbo].[Mu_DBID] (
	[DESC] [varchar] (20) NOT NULL 
) ON [PRIMARY]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WZ_Get_DBID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[WZ_Get_DBID]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO

CREATE procedure WZ_Get_DBID
as
BEGIN	
	SET NOCOUNT ON

	SELECT [DESC] FROM Mu_DBID

	SET NOCOUNT OFF

END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TABLE [dbo].[T_User_CheckSum] (
	[AccountID] [varchar] (10) COLLATE Korean_Wansung_CS_AS_KS_WS NOT NULL ,
	[WHCheckSum] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[T_User_CheckSum] WITH NOCHECK ADD 
	CONSTRAINT [DF_T_User_CheckSum_WHCheckSum] DEFAULT ((-1)) FOR [WHCheckSum],
	CONSTRAINT [PK_T_User_CheckSum] PRIMARY KEY  CLUSTERED 
	(
		[AccountID]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[MuCrywolf_DATA] (
	[MAP_SVR_GROUP] [int] NOT NULL ,
	[CRYWOLF_OCCUFY] [int] NOT NULL ,
	[CRYWOLF_STATE] [int] NOT NULL ,
	[CHAOSMIX_PLUS_RATE] [int] NOT NULL ,
	[CHAOSMIX_MINUS_RATE] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[MuCrywolf_DATA] WITH NOCHECK ADD 
	CONSTRAINT [DF_MuCrywolf_DATA_CRYWOLF_OCCUFY] DEFAULT (0) FOR [CRYWOLF_OCCUFY],
	CONSTRAINT [DF_MuCrywolf_DATA_CRYWOLF_STATE] DEFAULT (0) FOR [CRYWOLF_STATE],
	CONSTRAINT [DF_MuCrywolf_DATA_CHAOSMIX_PLUS_RATE] DEFAULT (0) FOR [CHAOSMIX_PLUS_RATE],
	CONSTRAINT [DF_MuCrywolf_DATA_CHAOSMIX_MINUS_RATE] DEFAULT (0) FOR [CHAOSMIX_MINUS_RATE],
	CONSTRAINT [PK_MuCrywolf_DATA] PRIMARY KEY  CLUSTERED 
	(
		[MAP_SVR_GROUP]
	)  ON [PRIMARY] 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WZ_CW_InfoLoad]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[WZ_CW_InfoLoad]
GO

CREATE PROCEDURE	WZ_CW_InfoLoad
	@iMapSvrGroup		SMALLINT	
As
Begin
	BEGIN TRANSACTION
	
	SET NOCOUNT ON
	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCrywolf_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN					
		SELECT CRYWOLF_OCCUFY, CRYWOLF_STATE  FROM MuCrywolf_DATA  WHERE MAP_SVR_GROUP = @iMapSvrGroup
	END
	ELSE
	BEGIN
		INSERT MuCrywolf_DATA VALUES ( @iMapSvrGroup, DEFAULT, DEFAULT, DEFAULT, DEFAULT )
		SELECT CRYWOLF_OCCUFY, CRYWOLF_STATE  FROM MuCrywolf_DATA WHERE  MAP_SVR_GROUP = @iMapSvrGroup
	END
	
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION
	SET NOCOUNT OFF	
End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WZ_CW_InfoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[WZ_CW_InfoSave]
GO

CREATE PROCEDURE	WZ_CW_InfoSave
	@iMapSvrGroup		SMALLINT,
	@iCrywolfState		INT,	
	@iOccupationState	INT		
As
Begin
	BEGIN TRANSACTION
	
	SET NOCOUNT ON
	IF EXISTS ( SELECT MAP_SVR_GROUP FROM MuCrywolf_DATA  WITH (READUNCOMMITTED) 
				WHERE MAP_SVR_GROUP = @iMapSvrGroup)
	BEGIN					
		UPDATE MuCrywolf_DATA
		SET CRYWOLF_OCCUFY = @iOccupationState, CRYWOLF_STATE = @iCrywolfState
		WHERE MAP_SVR_GROUP = @iMapSvrGroup
	END
	ELSE
	BEGIN
		INSERT MuCrywolf_DATA VALUES ( @iMapSvrGroup, DEFAULT, DEFAULT, DEFAULT, DEFAULT )

		UPDATE MuCrywolf_DATA
		SET CRYWOLF_OCCUFY = @iOccupationState, CRYWOLF_STATE = @iCrywolfState
		WHERE MAP_SVR_GROUP = @iMapSvrGroup
	END
	
	IF(@@Error <> 0 )
		ROLLBACK TRANSACTION
	ELSE	
		COMMIT TRANSACTION
	SET NOCOUNT OFF	
End
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO