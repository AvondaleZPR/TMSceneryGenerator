namespace SGRandom
{
	double dSeed = 0;
	double dSavedSeed = 0;
	float fA = 45.0001;
	float fLEET = 1337.0000;
	float fM = 69.9999;

	void SetSeed(double dSeed)
	{
		SGRandom::dSeed = dSeed;
	}

	void SetTempSeed(double dTempSeed)
	{
		dSavedSeed = dSeed;
		dSeed = dTempSeed;
	}

	void ResetTempSeed()
	{
		dSeed = dSavedSeed;
	}

	float Next()
	{
		dSeed = (fA * dSeed + fLEET) % fM; 
		return dSeed % 1;
	}

	int Int(int iMin, int iMax)
	{
		return int(Math::Floor(Next() * (iMax-iMin) + iMin));
	}

	CGameEditorPluginMap::ECardinalDirections Direction()
	{
		switch(Int(1,5))
		{
			case 1:
				return SGDirection::NORTH;
			case 2:
				return SGDirection::EAST;
			case 3:
				return SGDirection::SOUTH;
			case 4:
				return SGDirection::WEST;		
		}
		return SGDirection::NORTH;
	}
}