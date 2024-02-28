namespace SGBlockList
{
	array<SGBlockData@> tBlocks;

	class SGBlockData
	{
		string sBlockName;
		bool bEnabled = false;
		array<string> tTags;

		SGBlockData() {}

		SGBlockData(const string sBlockName, bool bEnabled, array<string> tTags)
		{
			this.sBlockName = sBlockName;
			this.bEnabled = bEnabled;
			this.tTags = tTags;
		}
	}

	void RegisterNewBlock(const string sBlockName, bool bEnabled, array<string> tTags)
	{
		tBlocks.InsertLast(SGBlockData(sBlockName, bEnabled, tTags));
	}

	SGBlockData GetRandomBlock(array<SGBlockData@> tBDArray)
	{
		SGBlockData bdBlock;

		while(bdBlock.bEnabled == false)
		{
			bdBlock = tBDArray[SGRandom::Int(0, tBDArray.Length)];
		}

		return bdBlock;
	}

	string GetRandomBlockName()
	{
		return GetRandomBlock(tBlocks).sBlockName;
	}	

	SGBlockData FindBlockInArrayWithTagList(array<string> tTags, array<SGBlockData@> tBDArray)	
	{
		int iLoopCounter = 0;
		SGBlockData bdBlock;
		bool bTagsMatch = false;

		do {
			iLoopCounter++;
			if(iLoopCounter > tBlocks.Length){ SGBlockData bdNull; return bdNull;}

			bdBlock = GetRandomBlock(tBDArray);
			int iTagsMatched = 0;

			for(int i = 0; i < tTags.Length; i++)
			{
				for(int j = 0; j < bdBlock.tTags.Length; j++)
				{
					if(tTags[i] == bdBlock.tTags[j])
					{
						iTagsMatched++;
						break;
					}
				}
			}
			bTagsMatch = iTagsMatched >= tTags.Length;
		} while(bTagsMatch == false);

		return bdBlock;
	}

	SGBlockData GetRandomBlockWithTags(array<string> tTags)
	{
		return FindBlockInArrayWithTagList(tTags, tBlocks);
	}	

	SGBlockData GetRandomBlockWithTag(const string sTag)
	{
		return GetRandomBlockWithTags({sTag});
	}	

	string GetRandomBlockNameWithTags(array<string> tTags)
	{
		return FindBlockInArrayWithTagList(tTags, tBlocks).sBlockName;
	}

	string GetRandomBlockNameWithTag(const string sTag)
	{
		return GetRandomBlockNameWithTags({sTag});
	}
}

namespace SGBlockSet 
{
	array<SGBlockList::SGBlockData@> tBlockSet;

	void AddBlock(SGBlockList::SGBlockData@ bdBlock)
	{
		tBlockSet.InsertLast(bdBlock);
	}

	void Clear()
	{
		tBlockSet = {};
	}

	string GetRandomBlockNameWithTags(array<string> tTags)
	{
		return SGBlockList::FindBlockInArrayWithTagList(tTags, tBlockSet).sBlockName;
	}

	string GetRandomBlockNameWithTag(const string sTag)
	{
		return GetRandomBlockNameWithTags({sTag});
	}	
}

// if specific block's direction works differently for the rest of the blocks - add statements to this
CGameEditorPluginMap::ECardinalDirections SpecialBlockDirection(const string sBlockName, CGameEditorPluginMap::ECardinalDirections cDir) 
{
	if (sBlockName == "TrackWallArch1x1SideTop" || sBlockName == "DecoCliffIceTopStraight10m" || sBlockName == "StageStraight")
	{
		cDir = SGDirection::TurnRight(cDir);
	}

	if (sBlockName.Contains("Light"))
	{
		cDir = SGDirection::TurnLeft(cDir);
	}

	return cDir;
}

// block registration goes here
/*
Block tags:
	Purpose:
		Structure
		Road
 		Decoration
 		Lighting
 		Arch
 	Surface:
 		Wood
 		Grass
 		Tech
 		Dirt
 		Ice
		Plastic
		PenaltyGrass
		Sand
		Snow
		Water
	Curve:
		Straight
		Curve
	Slope:
		Flat
		Slope
	Tilt:
		NoTilt
		Tilted
	Size:
		Small4x1
		1x1
		2x1
		4x1
		3x6
	Effect:
		Boost
		Boost2
		NoEngine
		NoSteering
		Reset
		SlowMotion
		Fragile
		Turbo
		Turbo2
	Special:
		EffectBlock
		Ring
		Screen
*/
void InitBlockList()
{
	//SGBlockList::RegisterNewBlock("NAME", true, {"Purpose", "Surface", "Curve", "Slope", "Tilt", "Size", "Effect?", "Special?"});

	//PENALTY DECO BLOCKS
	SGBlockList::RegisterNewBlock("DecoHillSlope2Straight", true, {"Decoration", "PenaltyGrass", "Straight", "Slope", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoHillSlope2Curve1In", true, {"Decoration", "PenaltyGrass", "Curve", "Slope", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoHillSlope2Curve1Out", true, {"Decoration", "PenaltyGrass", "Curve", "Slope", "NoTilt", "1x1"});

	SGBlockList::RegisterNewBlock("DecoHillIceSlope2Straight", true, {"Decoration", "Snow", "Straight", "Slope", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoHillIceSlope2Curve1In", true, {"Decoration", "Snow", "Curve", "Slope", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoHillIceSlope2Curve1Out", true, {"Decoration", "Snow", "Curve", "Slope", "NoTilt", "1x1"});

	SGBlockList::RegisterNewBlock("DecoHillDirtSlope2Straight", true, {"Decoration", "Sand", "Straight", "Slope", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoHillDirtSlope2Curve1In", true, {"Decoration", "Sand", "Curve", "Slope", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoHillDirtSlope2Curve1Out", true, {"Decoration", "Sand", "Curve", "Slope", "NoTilt", "1x1"});	
	//--

	//PENALTY PLATFORMS
	SGBlockList::RegisterNewBlock("DecoPlatformBase", true, {"Decoration", "PenaltyGrass", "Straight", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoPlatformIceBase", true, {"Decoration", "Snow", "Straight", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoPlatformDirtBase", true, {"Decoration", "Sand", "Straight", "Flat", "NoTilt", "1x1"});

	SGBlockList::RegisterNewBlock("DecoPlatformSlope2Straight", true, {"Decoration", "PenaltyGrass", "Straight", "Slope", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoPlatformIceSlope2Straight", true, {"Decoration", "PenaltyGrass", "Straight", "Slope", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoPlatformDirtSlope2Straight", true, {"Decoration", "PenaltyGrass", "Straight", "Slope", "NoTilt", "1x1"});

	SGBlockList::RegisterNewBlock("DecoPlatformSlope2UTop", true, {"Decoration", "PenaltyGrass", "Straight", "Slope", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoPlatformIceSlope2UTop", true, {"Decoration", "PenaltyGrass", "Straight", "Slope", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoPlatformDirtSlope2UTop", true, {"Decoration", "PenaltyGrass", "Straight", "Slope", "NoTilt", "1x1"});	
	//--

	//WOOD TRACK WALLS BLOCKS
	SGBlockList::RegisterNewBlock("PlatformBase", true, {"Structure", "Wood", "Straight", "Flat", "NoTilt", "1x1"});

	SGBlockList::RegisterNewBlock("DecoWallBase", true, {"Structure", "Wood", "Straight", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoWallCurve1", true, {"Structure", "Wood", "Curve", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("DecoWallSlope2Straight", true, {"Decoration", "Wood", "Straight", "Curve", "NoTilt", "1x1"});

	SGBlockList::RegisterNewBlock("TrackWallStraight", true, {"Structure", "Wood", "Straight", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("TrackWallBranchCross", true, {"Structure", "Wood", "Straight", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("TrackWallBranchTShaped", true, {"Structure", "Wood", "Straight", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("TrackWallCurve1", true, {"Structure", "Wood", "Curve", "Flat", "NoTilt", "1x1"});

	SGBlockList::RegisterNewBlock("TrackWallArch1x1SideTop", true, {"Decoration", "Wood", "Straight", "Flat", "NoTilt", "Small4x1"}); // default rotation is fucked look the SBD function
	//--		

	//SCREENS
	SGBlockList::RegisterNewBlock("TechnicsScreen1x1Straight", true, {"Decoration", "1x1", "Screen"});
	SGBlockList::RegisterNewBlock("TechnicsScreen4x1Straight", true, {"Decoration", "Small4x1", "Screen"});
	//--

	//PLATFORM WALLS
	SGBlockList::RegisterNewBlock("PlatformTechWallStraight", true, {"Decoration", "Tech", "Straight", "Flat", "NoTilt", "Small4x1"});
	SGBlockList::RegisterNewBlock("PlatformIceWallStraight", true, {"Decoration", "Ice", "Straight", "Flat", "NoTilt", "Small4x1"});
	SGBlockList::RegisterNewBlock("PlatformDirtWallStraight", true, {"Decoration", "Dirt", "Straight", "Flat", "NoTilt", "Small4x1"});
	SGBlockList::RegisterNewBlock("PlatformGrassWallStraight", true, {"Decoration", "Grass", "Straight", "Flat", "NoTilt", "Small4x1"});
	//--

	//SQUARE PIPE THINGS
	SGBlockList::RegisterNewBlock("StructureBase", true, {"Structure", "Straight", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("StructureCorner", true, {"Structure", "Curve", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("StructureCross", true, {"Structure", "Straight", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("StructureDeadend", true, {"Structure", "Straight", "Flat", "NoTilt", "1x1"});
	//--

	//WATER 
	SGBlockList::RegisterNewBlock("WaterBase", true, {"Decoration", "Water", "Straight", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("WaterWall", true, {"Decoration", "Water", "Straight", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("WaterGrassStraight", true, {"Decoration", "Water", "Straight", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("WaterDirtStraight", true, {"Decoration", "Water", "Straight", "Flat", "NoTilt", "1x1"});
	SGBlockList::RegisterNewBlock("WaterIceStraight", true, {"Decoration", "Water", "Straight", "Flat", "NoTilt", "1x1"});
	//--

	//BOBSLEIGHGYTJHTHTGHJGYFSVBUDI
	SGBlockList::RegisterNewBlock("RoadIceBranchCross", true, {"Decoration", "Ice", "Straight", "Flat", "NoTilt", "1x1"});
	//--

	//LIGHTS 
	SGBlockList::RegisterNewBlock("StageTechnicsLight", true, {"Lighting", "Small4x1"});
	SGBlockList::RegisterNewBlock("StageTechnicsLightToStructure", true, {"Lighting", "Small4x1"});
	SGBlockList::RegisterNewBlock("StageTechnicsLightDown", true, {"Lighting", "Small4x1"});
	//--

	//ROAD TECH EFFECTS
	SGBlockList::RegisterNewBlock("RoadTechSpecialReset", true, {"Decoration", "Tech", "Straight", "Flat", "NoTilt", "1x1", "Reset", "EffectBlock"});
	SGBlockList::RegisterNewBlock("RoadTechSpecialNoSteering", true, {"Decoration", "Tech", "Straight", "Flat", "NoTilt", "1x1", "NoSteering", "EffectBlock"});
	SGBlockList::RegisterNewBlock("RoadTechSpecialNoEngine", true, {"Decoration", "Tech", "Straight", "Flat", "NoTilt", "1x1", "NoEngine", "EffectBlock"});
	SGBlockList::RegisterNewBlock("RoadTechSpecialFragile", true, {"Decoration", "Tech", "Straight", "Flat", "NoTilt", "1x1", "Fragile", "EffectBlock"});
	SGBlockList::RegisterNewBlock("RoadTechSpecialSlowMotion", true, {"Decoration", "Tech", "Straight", "Flat", "NoTilt", "1x1", "SlowMotion", "EffectBlock"});
	SGBlockList::RegisterNewBlock("RoadTechSpecialTurbo", true, {"Decoration", "Tech", "Straight", "Flat", "NoTilt", "1x1", "Turbo", "EffectBlock"});

	SGBlockList::RegisterNewBlock("RoadTechSpecialResetSlope", true, {"Decoration", "Tech", "Straight", "Slope", "NoTilt", "1x1", "Reset", "EffectBlock"});
	SGBlockList::RegisterNewBlock("RoadTechSpecialNoSteeringSlope", true, {"Decoration", "Tech", "Straight", "Slope", "NoTilt", "1x1", "NoSteering", "EffectBlock"});
	SGBlockList::RegisterNewBlock("RoadTechSpecialNoEngineSlope", true, {"Decoration", "Tech", "Straight", "Slope", "NoTilt", "1x1", "NoEngine", "EffectBlock"});	
	SGBlockList::RegisterNewBlock("RoadTechSpecialFragileSlope", true, {"Decoration", "Tech", "Straight", "Slope", "NoTilt", "1x1", "Fragile", "EffectBlock"});	
	SGBlockList::RegisterNewBlock("RoadTechSpecialSlowMotionSlope", true, {"Decoration", "Tech", "Straight", "Slope", "NoTilt", "1x1", "SlowMotion", "EffectBlock"});	
	SGBlockList::RegisterNewBlock("RoadTechSpecialTurboSlope", true, {"Decoration", "Tech", "Straight", "Slope", "NoTilt", "1x1", "Turbo", "EffectBlock"});	

	SGBlockList::RegisterNewBlock("RoadTechSpecialResetTilt", true, {"Decoration", "Tech", "Straight", "Flat", "Tilt", "1x1", "Reset", "EffectBlock"});
	SGBlockList::RegisterNewBlock("RoadTechSpecialNoSteeringTilt", true, {"Decoration", "Tech", "Straight", "Flat", "Tilt", "1x1", "NoSteering", "EffectBlock"});
	SGBlockList::RegisterNewBlock("RoadTechSpecialNoEngineTilt", true, {"Decoration", "Tech", "Straight", "Flat", "Tilt", "1x1", "NoEngine", "EffectBlock"});	
	SGBlockList::RegisterNewBlock("RoadTechSpecialFragileTilt", true, {"Decoration", "Tech", "Straight", "Flat", "Tilt", "1x1", "Fragile", "EffectBlock"});	
	SGBlockList::RegisterNewBlock("RoadTechSpecialSlowMotionTilt", true, {"Decoration", "Tech", "Straight", "Flat", "Tilt", "1x1", "SlowMotion", "EffectBlock"});	
	SGBlockList::RegisterNewBlock("RoadTechSpecialTurboTilt", true, {"Decoration", "Tech", "Straight", "Flat", "Tilt", "1x1", "Turbo", "EffectBlock"});	
	//--

	//ARCHES
	//SGBlockList::RegisterNewBlock("TrackWallArch1x1CenterTop", true, {"Arch", "1x1"});	
	SGBlockList::RegisterNewBlock("TrackWallArch1x2CenterTop", true, {"Arch", "1x2"});	
	//SGBlockList::RegisterNewBlock("DecoWallLoopEnd1x1Center", true, {"Arch", "1x1"});	
	SGBlockList::RegisterNewBlock("DecoWallLoopEnd1x2Center", true, {"Arch", "1x2"});	
	//--

	//WOOD
	SGBlockList::RegisterNewBlock("SnowRoadStraight", true, {"Structure", "Wood", "Straight", "Flat", "NoTilt", "1x1"});
	//--

	//idk how to categorise these so go fuck yourself
	SGBlockList::RegisterNewBlock("StageStraight", true, {"Decoration", "Tech", "Straight", "Flat", "NoTilt", "Small4x1"}); // rotation is wrong
	SGBlockList::RegisterNewBlock("DecoCliffIceTopStraight10m", true, {"Decoration", "Tech", "Straight", "Flat", "NoTilt", "Small4x1"}); // rotation is wrong
	//--
}