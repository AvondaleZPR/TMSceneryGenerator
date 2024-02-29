namespace SGBlocks
{
	array<int3> tBlockedSpots(9999);

	void ClearBlockedSpots()
	{
		tBlockedSpots.RemoveRange(0, 9999);
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
		if(IsPositionBlocked(i3Point))
		{
			return false;
		}

	    while (!cMap.IsEditorReadyForRequest) {
	        yield();
	    }

	    return cMap.CanPlaceBlock(cMap.GetBlockModelFromName(sBlockName), i3Point, cDir, true, 0);
	}	

	bool IsPositionBlocked(int3 i3Point)
	{
		for(int i = 0; i < tBlockedSpots.Length; i++)
		{
			if(i3Point == tBlockedSpots[i])
			{
				sgprint("\\$f00 cant place spot blocked");
				return true;
			}
		}	

		return false;	
	}

	void RemoveBlocksInChunk(CGameEditorPluginMap@ cMap, int iX, int iZ)
	{
		for(int i = SG::iMapMinY; i <= SG::iMapMaxY; i ++)
		{	
			int3 i3Point = int3(iX, i, iZ);
			cMap.RemoveBlock(i3Point);
		}
	}

	array<int> BlockChunk(int iX, int iZ)
	{
		array<int> tChunks(SG::iMapMaxY);

		for(int i = SG::iMapMinY; i <= SG::iMapMaxY; i++)
		{	
			tChunks[i-SG::iMapMinY] = tBlockedSpots.Length;
			tBlockedSpots.InsertLast(int3(iX, i, iZ));
		}	

		return tChunks;
	}

	void UnblockChunk(array<int> tChunks)
	{
		for(int i = tChunks.Length; i >= 0; i--)
		{	
			tBlockedSpots.RemoveAt(i);
		}	
	}
}