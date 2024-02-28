CGameEditorPluginMap::EMapElemColor Convert(CGameCtnBlock::EMapElemColor cColor)
{
	switch(cColor)
	{
		case CGameCtnBlock::EMapElemColor::Default:
			return CGameEditorPluginMap::EMapElemColor::Default;
		case CGameCtnBlock::EMapElemColor::White:
			return CGameEditorPluginMap::EMapElemColor::White;
		case CGameCtnBlock::EMapElemColor::Green:
			return CGameEditorPluginMap::EMapElemColor::Green;
		case CGameCtnBlock::EMapElemColor::Blue:
			return CGameEditorPluginMap::EMapElemColor::Blue;
		case CGameCtnBlock::EMapElemColor::Red:
			return CGameEditorPluginMap::EMapElemColor::Red;
		case CGameCtnBlock::EMapElemColor::Black:
			return CGameEditorPluginMap::EMapElemColor::Black;		
	}

	return CGameEditorPluginMap::EMapElemColor::Default;
}