namespace SGItems
{
	CGameItemModel@ FindItemByName(const string &in name) {
		auto itemsCatalog = GetApp().GlobalCatalog.Chapters[3];
		for (int i = itemsCatalog.Articles.Length - 1; i > 1; i--) {
		    auto item = itemsCatalog.Articles[i];
		    if (item.Name == name) {
		        if (item.LoadedNod is null) {
		            item.Preload();
		        }
		        return cast<CGameItemModel>(item.LoadedNod);
		    }
		}
		return null;
	}
}