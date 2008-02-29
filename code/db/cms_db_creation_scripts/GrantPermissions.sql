--add permissions for 3w_customRole
GRANT EXECUTE ON [dbo].[sp_generateDisplayOrder] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_generateDisplayOrderLocaleMeta] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_GetCategoryContentTree] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_getContent] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_getContents] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_getContentsNoPosition] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_getPage] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_getMasterLists] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_getMasterListName] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_getMasterListItems] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_getPages] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_util_FindColumn] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_util_getDataStructure] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_util_send_mail] TO [3w_customRole]
GO
GRANT EXECUTE ON [dbo].[sp_CMS_getRecentHistory] TO [3w_customRole]