namespace SGUI
{
	void Begin()
	{
		UI::SetNextWindowSize(700, 600);
		UI::SetNextWindowPos(300, 300, UI::Cond::Once);
		UI::SetNextWindowContentSize(700, 530);
		
		UI::PushStyleColor(UI::Col::Border, vec4(0.9f, 0.9f, 0.9f, 1));
		UI::Begin("Scenery Generator", bDisplayUI, UI::WindowFlags::NoResize + UI::WindowFlags::NoScrollbar);	
			SGUI::Tabs();

			UI::Separator();
			UI::Text("\\$fff\\$sScenery Generator \\$999\\$s" + Main::GetPluginVersion() + " \\$fff\\$sby AvondaleZPR\\$999\\$s" + Icons::Copyright);			
		UI::End();
		UI::PopStyleColor(1);
	}

	void Tabs()
	{
		UI::BeginTabBar("SGTabBar", UI::TabBarFlags::None);
			UI::PushStyleColor(UI::Col::Tab, vec4(0.2f, 0.6f, 0.0f, 1) * vec4(0.5f, 0.5f, 0.5f, 0.75f));
			UI::PushStyleColor(UI::Col::TabHovered, vec4(0.2f, 0.7f, 0.0f, 1) * vec4(1.2f, 1.2f, 1.2f, 0.85f));
			UI::PushStyleColor(UI::Col::TabActive, vec4(0.2f, 0.8f, 0.0f, 1));	
			if(UI::BeginTabItem("Generate"))
			{
				UI::BeginChild("Tab");
				SGUI::MainTab();
				UI::EndChild();
				UI::EndTabItem();
			}
			UI::PopStyleColor(3);
			
			UI::PushStyleColor(UI::Col::Tab, vec4(0.0f, 0.5f, 0.6f, 1) * vec4(0.5f, 0.5f, 0.5f, 0.75f));
			UI::PushStyleColor(UI::Col::TabHovered, vec4(0.0f, 0.5f, 0.7f, 1) * vec4(1.2f, 1.2f, 1.2f, 0.85f));
			UI::PushStyleColor(UI::Col::TabActive, vec4(0.0f, 0.5f, 0.8f, 1));	
			if(UI::BeginTabItem("Settings"))
			{
				UI::BeginChild("Tab");
				SGUI::SettingsTab();
				UI::EndChild();
				UI::EndTabItem();
			}
			UI::PopStyleColor(3);

			UI::PushStyleColor(UI::Col::Tab, vec4(0.5f, 0.2f, 0.0f, 1) * vec4(0.5f, 0.5f, 0.5f, 0.75f));
			UI::PushStyleColor(UI::Col::TabHovered, vec4(0.6f, 0.2f, 0.0f, 1) * vec4(1.2f, 1.2f, 1.2f, 0.85f));
			UI::PushStyleColor(UI::Col::TabActive, vec4(0.7f, 0.2f, 0.0f, 1));	
			if(UI::BeginTabItem("Blocks"))
			{
				UI::BeginChild("Tab");
				SGUI::BlockTab();
				UI::EndChild();
				UI::EndTabItem();
			}
			UI::PopStyleColor(3);	

			UI::PushStyleColor(UI::Col::Tab, vec4(0.5f, 0.5f, 0.0f, 1) * vec4(0.5f, 0.5f, 0.5f, 0.75f));
			UI::PushStyleColor(UI::Col::TabHovered, vec4(0.6f, 0.6f, 0.0f, 1) * vec4(1.2f, 1.2f, 1.2f, 0.85f));
			UI::PushStyleColor(UI::Col::TabActive, vec4(0.7f, 0.7f, 0.0f, 1));	
			if(UI::BeginTabItem("Items"))
			{
				UI::BeginChild("Tab");
				SGUI::ItemTab();
				UI::EndChild();
				UI::EndTabItem();
			}
			UI::PopStyleColor(3);					
		UI::EndTabBar();
	}

	void MainTab()
	{
		if (UI::Button(Icons::Pagelines + " Generate Random Scenery")) {
			startnew(SG::Begin);
		}
		UI::SameLine();
		if (UI::Button(Icons::Trash + " Undo Scenery")) {
			startnew(SG::Undo);
		}
		UI::Separator();

		UI::Text("\\$ff0\\$s" + Icons::ExclamationCircle +" Save your track before generating scenery!");
		UI::Text("\\$fff\\$s" + "Undo only works for 1 iteration!");
		UI::Text("\\$fff\\$s" + "Generation works better on floating tracks");
	}

	void SettingsTab()
	{
		SettingsMain();
		SettingsGeneration();
		SeedSettings();
	}

	void SettingsMain()
	{
		UI::Markdown("**General**");
		UI::BeginChild("General", vec2(685,40), true);
		bDebugMode = UI::Checkbox("Enable debug logging", bDebugMode);
		UI::EndChild();
	}

	void SettingsGeneration()
	{
		UI::Markdown("**Generation**");
		UI::BeginChild("Generation", vec2(685,40), true);
		SG::bGenerateArches = UI::Checkbox("Generate Arches", SG::bGenerateArches);
		UI::EndChild();	
	}

	void SeedSettings()
	{
		UI::Markdown("**Seeds**");
		UI::BeginChild("Seeds", vec2(685,75), true);
			bSeedEnabled = UI::Checkbox("Scenery", bSeedEnabled); UI::SameLine();
			bool bChanged = false;
			UI::Text("\\$080\\$s" + Icons::Key + " Seed:"); UI::SameLine();
			sSeedText = UI::InputText("##sSeedText", sSeedText, bChanged, UI::InputTextFlags::CharsUppercase); UI::SameLine();
			if (UI::Button(Icons::Random)) 
			{
				sSeedText = RandomTextSeed(Math::Rand(1,10));
			}
			sSeedText = sSeedText.SubStr(0, 10);
			if (bChanged && bSeedEnabled) 
			{
				if(sSeedText.Length <= 0)
				{
					bSeedEnabled = false;
				}
			}

			bSeedEnabledBS = UI::Checkbox("BlockSet", bSeedEnabledBS); UI::SameLine();
			bool bChangedBS = false;
			UI::Text("\\$080\\$s" + Icons::Key + " Seed:"); UI::SameLine();
			sSeedTextBS = UI::InputText("##sSeedTextBS", sSeedTextBS, bChangedBS, UI::InputTextFlags::CharsUppercase); UI::SameLine();
			if (UI::Button("\\$s" + Icons::Random)) // i added $s because if the buttons name is the same as the other one it doesnt work xdd
			{
				sSeedTextBS = RandomTextSeed(Math::Rand(1,10));
			}
			sSeedTextBS = sSeedTextBS.SubStr(0, 10);
			if (bChangedBS && bSeedEnabledBS) 
			{
				if(sSeedTextBS.Length <= 0)
				{
					bSeedEnabledBS = false;
				}
			}
		UI::EndChild();			
	}

	void BlockTab()
	{
		if (UI::BeginTable("BlocksTable", 2))
		{
			UI::TableSetupColumn("Name", UI::TableColumnFlags::None);	
			UI::TableSetupColumn("Tags", UI::TableColumnFlags::None);
			UI::TableHeadersRow();

			for(int i = 0; i < SGBlockList::tBlocks.Length; i++)
			{
				UI::TableNextColumn();
				SGBlockList::tBlocks[i].bEnabled = UI::Checkbox("##Block_" + tostring(i), SGBlockList::tBlocks[i].bEnabled); UI::SameLine();
				UI::Text(SGBlockList::tBlocks[i].sBlockName);
				UI::TableNextColumn();
				UI::Text(SGBlockList::tBlocks[i].TagsToString());
			}

			UI::EndTable();
		}
	}

	void ItemTab()
	{

	}
}