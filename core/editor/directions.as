namespace SGDirection
{
	const CGameEditorPluginMap::ECardinalDirections NORTH = CGameEditorPluginMap::ECardinalDirections::North;
	const CGameEditorPluginMap::ECardinalDirections EAST = CGameEditorPluginMap::ECardinalDirections::East;
	const CGameEditorPluginMap::ECardinalDirections SOUTH = CGameEditorPluginMap::ECardinalDirections::South;
	const CGameEditorPluginMap::ECardinalDirections WEST = CGameEditorPluginMap::ECardinalDirections::West;

	int3 Move(CGameEditorPluginMap::ECardinalDirections cDir, int iAmount = 1)
	{
		switch(cDir)
		{
			case NORTH:
				return int3(0,0,iAmount);
			case EAST:
				return int3(-iAmount,0,0);
			case SOUTH:
				return int3(0,0,-iAmount);
			case WEST:
				return int3(iAmount,0,0);			
		}
		
		return int3(iAmount,0,iAmount);
	}

	CGameEditorPluginMap::ECardinalDirections TurnLeft(CGameEditorPluginMap::ECardinalDirections cDir)
	{
		switch(cDir)
		{
			case NORTH:
				return WEST;
			case EAST:
				return NORTH;
			case SOUTH:
				return EAST;
			case WEST:
				return SOUTH;			
		}
		
		return NORTH;
	}

	CGameEditorPluginMap::ECardinalDirections TurnRight(CGameEditorPluginMap::ECardinalDirections cDir)
	{
		switch(cDir)
		{
			case NORTH:
				return EAST;
			case EAST:
				return SOUTH;
			case SOUTH:
				return WEST;
			case WEST:
				return NORTH;
		}
		
		return NORTH;
	}

	CGameEditorPluginMap::ECardinalDirections Convert(CGameEditorPluginMapConnectResults::ECardinalDirections cDir)
	{
		switch(cDir)
		{
			case CGameEditorPluginMapConnectResults::ECardinalDirections::North:
				return CGameEditorPluginMap::ECardinalDirections::North;	
			case CGameEditorPluginMapConnectResults::ECardinalDirections::East:
				return CGameEditorPluginMap::ECardinalDirections::East;
			case CGameEditorPluginMapConnectResults::ECardinalDirections::South:
				return CGameEditorPluginMap::ECardinalDirections::South;
			case CGameEditorPluginMapConnectResults::ECardinalDirections::West:
				return CGameEditorPluginMap::ECardinalDirections::West;
		}
		
		return CGameEditorPluginMap::ECardinalDirections::North;
	}

	CGameEditorPluginMap::ECardinalDirections Convert(CGameCtnBlock::ECardinalDirections cDir)
	{
		switch(cDir)
		{
			case CGameCtnBlock::ECardinalDirections::North:
				return CGameEditorPluginMap::ECardinalDirections::North;	
			case CGameCtnBlock::ECardinalDirections::East:
				return CGameEditorPluginMap::ECardinalDirections::East;
			case CGameCtnBlock::ECardinalDirections::South:
				return CGameEditorPluginMap::ECardinalDirections::South;
			case CGameCtnBlock::ECardinalDirections::West:
				return CGameEditorPluginMap::ECardinalDirections::West;
		}
		
		return CGameEditorPluginMap::ECardinalDirections::North;
	}	
}