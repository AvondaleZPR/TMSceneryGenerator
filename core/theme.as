namespace SGTheme
{
	//const array<string> THEME_PURPOSE = {"Structure", "Road", "Decoration", "Lighting", "Arch", SideStructure};
	//const array<string> THEME_SURFACE = {"Wood", "Grass", "Tech", "Dirt", "Ice", "Plastic", "PenaltyGrass", "Sand", "Snow", "Water", "Stone"};
	//const array<string> THEME_CURVE = {"Straight", "Curve"};
	//const array<string> THEME_SLOPE = {"Flat", "Slope"};
	//const array<string> THEME_TILT = {"NoTilt", "Tilted"};
	//const array<string> THEME_SIZE = {"Small4x1", "1x1", "2x1", "4x1", "3x6"};
	//const array<string> THEME_EFFECT = {"Boost", "Boost2", "NoEngine", "NoSteering", "Reset", "SlowMotion", "Fragile", "Turbo", "Turbo2"};
	//const array<string> THEME_SPECIAL = {"EffectBlock", "Ring", "Screen", "Pipe", "Triangle"};	

	void FillNewBlockSet()
	{
		if(SGUI::bSeedEnabledBS)
		{
			SGRandom::SetTempSeed(SGUI::SeedFromText(SGUI::sSeedTextBS));
		}

		SGBlockSet::Clear();

		SGBlockSet::AddBlock(SGBlockList::GetRandomBlockWithTags({"Structure", "Straight"}, /*ANTI TAGS:*/{"Pipe"}));
		SGBlockSet::AddBlock(SGBlockList::GetRandomBlockWithTags({"Structure", "Straight"}, /*ANTI TAGS:*/{"Pipe"}));
		SGBlockSet::AddBlock(SGBlockList::GetRandomBlockWithTags({"Pipe"}));

		SGBlockSet::AddBlock(SGBlockList::GetRandomBlockWithTags({"Arch"}));

		SGBlockSet::AddBlock(SGBlockList::GetRandomBlockWithTags({"Lighting"}));

		SGBlockSet::AddBlock(SGBlockList::GetRandomBlockWithTags({"Decoration","Straight","1x1"}));
		SGBlockSet::AddBlock(SGBlockList::GetRandomBlockWithTags({"Decoration","Straight","1x1"}));

		SGBlockSet::AddBlock(SGBlockList::GetRandomBlockWithTags({"Decoration","Curve","1x1"}));
		
		SGBlockSet::AddBlock(SGBlockList::GetRandomBlockWithTags({"Decoration","Small4x1"}, /*ANTI TAGS:*/{"Triangle"}));
		SGBlockSet::AddBlock(SGBlockList::GetRandomBlockWithTags({"Decoration","Small4x1"}));

		//SGBlockSet::AddBlock(SGBlockList::GetRandomBlockWithTags({"SideStructure"}));

		sgprint("\\$11fBlockSet: " + SGBlockSet::BlockSetToString());

		if(SGUI::bSeedEnabledBS)
		{
			SGRandom::ResetTempSeed();
		}		
	}
}