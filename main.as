bool bDebugMode = true;
bool bDisplayUI = false;

void sgprint(const string sText)
{
	if (bDebugMode) {print(sText);}
}

// openplanet callbacks
void Main()
{
	InitBlockList();

	while(true)
	{
		if (!Main::IsEditorLoaded())
		{
			bDisplayUI = false;
		}

		yield();
	}
}

void RenderMenu()
{
	if(!Permissions::OpenAdvancedMapEditor())
	{
		return;
	}

	if (UI::MenuItem("\\$0f0" + Icons::Pagelines + "\\$fff\\$s Scenery Generator", Main::GetPluginVersion(), bDisplayUI, Main::IsEditorLoaded())) 
	{	
		bDisplayUI = !bDisplayUI;
	}
}

void RenderInterface()
{
	if(!bDisplayUI)
	{
		return;
	}
	
	SGUI::Begin();
}
//--

namespace Main
{
	bool IsEditorLoaded()
	{
		if (cast<CGameCtnEditorFree>(cast<CTrackMania>(GetApp()).Editor) is null) 
		{
			return false;
		}

		return true;
	}

	string GetPluginVersion()
	{
		return Meta::ExecutingPlugin().Version;
	}
}