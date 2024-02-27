namespace SGBlocks
{
	array<int3> tBlockedSpots(999);

	void ClearBlockedSpots()
	{
		tBlockedSpots.RemoveRange(0, 999);
	}

	bool Place(CGameEditorPluginMap@ cMap, const string sBlockName, CGameEditorPluginMap::ECardinalDirections cDir, int3 i3Point, bool bGhostBlock = false)
	{

	    while (!cMap.IsEditorReadyForRequest) {
	        yield();
	    }

	    if(bGhostBlock)
	    {
	    	tBlockedSpots.InsertLast(i3Point);
	    	return cMap.PlaceGhostBlock(cMap.GetBlockModelFromName(sBlockName), i3Point, cDir);	
	    }

	    return cMap.PlaceBlock(cMap.GetBlockModelFromName(sBlockName), i3Point, cDir);
	}	

	bool CanPlace(CGameEditorPluginMap@ cMap, const string sBlockName, CGameEditorPluginMap::ECardinalDirections cDir, int3 i3Point)
	{
		for(int i = 0; i < tBlockedSpots.Length; i++)
		{
			if(i3Point == tBlockedSpots[i])
			{
				return false;
			}
		}

	    while (!cMap.IsEditorReadyForRequest) {
	        yield();
	    }

	    return cMap.CanPlaceBlock(cMap.GetBlockModelFromName(sBlockName), i3Point, cDir, true, 0);
	}	
}