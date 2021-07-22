this.starting_scenario <- {
	m = {
		ID = "",
		Name = "",
		Description = "",
		Difficulty = 1,
		Order = 0,
		IsFixedLook = false
	},
	function isFixedLook()
	{
		return this.m.IsFixedLook;
	}

	function isDroppedAsLoot( _item )
	{
		return false;
	}

	function getID()
	{
		return this.m.ID;
	}

	function getName()
	{
		return this.m.Name;
	}

	function getDescription()
	{
		return this.m.Description;
	}

	function getDifficulty()
	{
		return this.m.Difficulty;
	}

	function getDifficultyForUI()
	{
		switch(this.m.Difficulty)
		{
		case 1:
			return "difficulty_easy";

		case 2:
			return "difficulty_medium";

		case 3:
			return "difficulty_hard";
		}

		return "difficulty_unknown";
	}

	function getOrder()
	{
		return this.m.Order;
	}

	function isValid()
	{
		return true;
	}

	function onSpawnAssets()
	{
	}

	function onSpawnPlayer()
	{
	}

	function onInit()
	{
	}

	function onUpdateHiringRoster( _roster )
	{
	}

	function onUpdateDraftList( _list )
	{
	}

	function onCombatFinished()
	{
		return true;
	}

};

