namespace SGUI
{
	bool bSeedEnabled = false;
	bool bSeedEnabledBS = false;
	string sSeedText = "OPENPLANET";
	string sSeedTextBS = "BLOCKSET";

	string RandomTextSeed(int length)
	{
		string result = "";
		string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		
		for(int i = 0; i < length; i++)
		{
			result = result.opAdd(chars.SubStr(Math::Rand(0, chars.Length), 1));
		}
		
		return result;
	}

	double SeedFromText(const string seed)
	{
		string newSeed = "";
		
		int length = seed.Length;
		if (length > 10) {length = 10;}
		for(int i = 0; i < length; i++)
		{
			newSeed = newSeed + tostring(seed[i]);
		}
		
		return Text::ParseDouble(newSeed + ".0000");
	}
}