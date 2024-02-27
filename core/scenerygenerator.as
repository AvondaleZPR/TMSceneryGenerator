namespace SG
{
	CTrackMania @cApp;
	CGameCtnEditorFree @cEditor;
	CGameEditorPluginMap @cMap;
	int iMapMinY = 9;
	int iMapMaxY = 39;
	int iBlockCountBefore = 0;
	int iBlockCountAfter = 0;

	void Begin()
	{
		if(SG::LoadMap())
		{
			SGBlocks::ClearBlockedSpots();
			auto tMapBlocks = GetApp().RootMap.Blocks;

			iBlockCountBefore = tMapBlocks.Length;
			uint64 iTimeBefore = Time::get_Now();

			if(SGUI::bSeedEnabled)
			{
				SGRandom::SetSeed(SGUI::SeedFromText(SGUI::sSeedText));
			}
			else
			{
				SGRandom::SetSeed(Math::Rand(1,99999));
			}

			SGTheme::FillNewBlockSet();
			
			print("Generating scenery...");
			BlockLoop(tMapBlocks);
			print("\\$0f0\\$sScenery generated in "+ tostring(Time::get_Now() - iTimeBefore) + " milliseconds!");

			iBlockCountAfter = GetApp().RootMap.Blocks.Length;
		}
		else
		{
			warn("couldnt load map");
		}
	}

	void Undo()
	{
		if(SG::LoadMap())
		{
			if (iBlockCountBefore != 0)
			{
				print("Removing scenery...");
				auto tMapBlocks = GetApp().RootMap.Blocks;

				for(int iBlockId = iBlockCountAfter-1; iBlockId > iBlockCountBefore-1; iBlockId--) 
				{
					auto i3Point = int3(tMapBlocks[iBlockId].CoordX, tMapBlocks[iBlockId].CoordY, tMapBlocks[iBlockId].CoordZ);
					
					while (!cMap.IsEditorReadyForRequest) {
						yield();
					}

					if(tMapBlocks[iBlockId].IsGhostBlock())
					{
						cMap.RemoveGhostBlock(tMapBlocks[iBlockId].BlockModel, i3Point, SGDirection::Convert(tMapBlocks[iBlockId].BlockDir));
					}
					else
					{
						cMap.RemoveBlock(i3Point);
					}
				}

				print("Scenery removed!");
			}
		}
		else
		{
			warn("couldnt load map");
		}		
	}

	bool LoadMap()
	{
		sgprint("Loading map...");
		
		@cApp = cast<CTrackMania>(GetApp());
		if (cApp is null) {
			return false;
		}	
		@cEditor = cast<CGameCtnEditorFree>(cApp.Editor);
		if (cEditor is null) {
			return false;
		}
		@cMap = cast<CGameEditorPluginMap>(cEditor.PluginMapType);
		if (cMap is null) {
			return false;
		}

		iMapMaxY = cMap.Map.Size.y - 2;

		sgprint("\\$0f0Map loaded!");
		return true;
	}

	void BlockLoop(MwFastBuffer<CGameCtnBlock@> tBlocks)
	{
		for(int iBlockId = 0; iBlockId < tBlocks.Length; iBlockId++) 
		{
			string sTrackBlockName = tBlocks[iBlockId].BlockModel.IdName;
			if (sTrackBlockName != "Grass" && !sTrackBlockName.Contains("TrackWall"))
			{		
				sgprint("Generating scenery near "+sTrackBlockName+" block #"+iBlockId+" at "+tBlocks[iBlockId].CoordX+","+tBlocks[iBlockId].CoordY+ ","+tBlocks[iBlockId].CoordZ);
				GenerateSceneryNearBlock(tBlocks[iBlockId]);
			}
		}
	}

	bool PlaceBlock(const string sSceneryBlockName, CGameEditorPluginMap::ECardinalDirections cDir, int3 i3Point, bool bGhostBlock = false)
	{
		cDir = SpecialBlockDirection(sSceneryBlockName, cDir); 	

		if (SGBlocks::CanPlace(cMap, sSceneryBlockName, cDir, i3Point))
		{
			if (SGBlocks::Place(cMap, sSceneryBlockName, cDir, i3Point, bGhostBlock) && cMap.GetBlock(i3Point) !is null)
			{	
				if (sSceneryBlockName.Contains("Screen") || sSceneryBlockName.Contains("Stage"))
				{
					cMap.SetBlockSkin(cMap.GetBlock(i3Point), "https://i.imgur.com/tHnp6xL.jpeg");
				}				
			}
			else
			{
				sgprint("\\$f00Block placement failed");
				return false;
			}
		}
		else
		{
			sgprint("\\$f00Cant place block " + sSceneryBlockName);
			return false;
		}

		return true;
	}

	void GenerateSceneryNearBlock(CGameCtnBlock@ cBlock)
	{
		switch(SGRandom::Int(1,5))
		{
			case 1:
				// do nothing
				break;
			case 2:
				GenerateTowerNearBlock(cBlock);
				break;
			case 3:
				GenerateStructureUnderBlock(cBlock);
				break;
			case 4:
				GenerateArchOnBlock(cBlock);
				break;
		}
	}

	void GenerateTowerNearBlock(CGameCtnBlock@ cBlock)
	{
		sgprint("generating scenery tower");

		CGameEditorPluginMap::ECardinalDirections cDir = SGRandom::Direction();
		int3 i3Point = int3(cBlock.CoordX, cBlock.CoordY, cBlock.CoordZ).opAdd(SGDirection::Move(cDir, SGRandom::Int(1,6)));

		int iTowerHeight = cBlock.CoordY + SGRandom::Int(-2,6);
		if (iTowerHeight <= iMapMinY)	{iTowerHeight = iMapMinY*2;}
		if (iTowerHeight >= iMapMaxY)	{iTowerHeight = iMapMaxY-2;} 

		if (!CanBuildStructureTower(i3Point, iMapMaxY))
		{
			return;
		}

		BuildStructureTower(i3Point, iTowerHeight, true);
	}

	void GenerateStructureUnderBlock(CGameCtnBlock@ cBlock)
	{
		sgprint("generating support structure");

		int3 i3Point = int3(cBlock.CoordX, iMapMaxY, cBlock.CoordZ);
		int iMaxHeight = cBlock.CoordY-1;

		if (!CanBuildStructureTower(i3Point, iMaxHeight))
		{
			return;
		}

		BuildStructureTower(i3Point, iMaxHeight, false);
	}

	bool CanBuildStructureTower(int3 i3Point, int iMaxHeight)
	{
		sgprint("trying to build tower structure at " + i3Point.x + " " + i3Point.z);
		for(int i = iMapMinY+1; i <= iMaxHeight; i++) // map min +1 cause grass counts as block
		{
			if(cMap.GetBlock(int3(i3Point.x, i, i3Point.z)) !is null || !SGBlocks::CanPlace(cMap, "PlatformBase", SGDirection::NORTH, i3Point))
			{
				sgprint("cant build tower structure here");
				return false;
			}
		}

		return true;
	}

	void BuildStructureTower(int3 i3Point, int iMaxHeight, bool bDecorateTop)
	{
		for(int iHeight = iMapMinY; iHeight <= iMaxHeight; iHeight++)
		{
			CGameEditorPluginMap::ECardinalDirections cDir = SGRandom::Direction();
			string sSceneryBlockName = "";

			if(iHeight == iMaxHeight && bDecorateTop)
			{
				sSceneryBlockName = SGBlockSet::GetRandomBlockNameWithTags({"Decoration","Straight","1x1"});
			}
			else
			{
			 	sSceneryBlockName = SGBlockSet::GetRandomBlockNameWithTag("Structure");
			}

			if(PlaceBlock(sSceneryBlockName, cDir, int3(i3Point.x, iHeight, i3Point.z)) && iHeight < iMaxHeight && !sSceneryBlockName.Contains("Structure"))
			// square pipe things have Structure in their names
			{
				for(int i = 1; i<=SGRandom::Int(0,3); i++)
				{
					cDir = SGRandom::Direction();
					int3 i3SmallDeco = int3(i3Point.x, iHeight, i3Point.z).opAdd(SGDirection::Move(cDir, 1));

					if(SGRandom::Int(1,4) == 2)
					{
						PlaceBlock(SGBlockSet::GetRandomBlockNameWithTag("Structure"), cDir, i3SmallDeco, true);
						cDir = SGDirection::TurnLeft(cDir); cDir = SGDirection::TurnLeft(cDir);
						i3SmallDeco.y++;
						PlaceBlock(SGBlockSet::GetRandomBlockNameWithTags({"Decoration","1x1"}), cDir, i3SmallDeco, true);
					}
					else
					{
						cDir = SGDirection::TurnLeft(cDir);
						PlaceBlock(SGBlockSet::GetRandomBlockNameWithTags({"Small4x1"}), cDir, i3SmallDeco);
					}
				}
			}
		}		
	}

	void GenerateArchOnBlock(CGameCtnBlock@ cBlock)
	{
		if(cBlock.CoordY < iMapMaxY-4)
		{
			CGameEditorPluginMap::ECardinalDirections cDir = SGDirection::Convert(cBlock.BlockDir);
			cDir = SGDirection::TurnLeft(cDir);
			int iArchHeight = cBlock.CoordY + SGRandom::Int(1,3);
			int3 i3Point = int3(cBlock.CoordX, iArchHeight, cBlock.CoordZ);
			int3 i3Tower1 = i3Point.opAdd(SGDirection::Move(cDir, 1));
			int3 i3Tower2 = i3Point.opAdd(SGDirection::Move(SGDirection::TurnLeft(SGDirection::TurnLeft(cDir)), 1));

			sgprint("building arch at " + i3Point.x + " " + i3Point.z);
			if (CanBuildStructureTower(i3Tower1, iArchHeight) && CanBuildStructureTower(i3Tower2, iArchHeight) && PlaceBlock(SGBlockSet::GetRandomBlockNameWithTags({"Arch"}), cDir, i3Point))
			{
				BuildStructureTower(i3Tower1, iArchHeight, true);
				BuildStructureTower(i3Tower2, iArchHeight, true);

				PlaceBlock(SGBlockSet::GetRandomBlockNameWithTags({"Decoration","1x1"}), SGRandom::Direction(), int3(i3Point.x, i3Point.y+2, i3Point.z));
			}
		}
	}
}