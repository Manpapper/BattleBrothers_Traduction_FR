this.agent_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.agent";
		this.m.Name = "L\'Agent";
		this.m.Description = "L\'Agen a des yeux et des oreilles partout et sait ce qu\'il se passe dans les villes et les villages ainsi que els contrats juteux qui s\'y trouvent.";
		this.m.Image = "ui/campfire/agent_01";
		this.m.Cost = 4000;
		this.m.Effects = [
			"Révèle les contrats disponible ets les situations dans les info-bulles des villes et villages peu importe où vous êtes"		
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "Avoir une relation \"Allié\" avec une maison noble ou une ville-État"
			}
		];
	}

	function onUpdate()
	{
	}

	function onEvaluate()
	{
		local allied = false;
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

		foreach( n in nobles )
		{
			if (n.getPlayerRelation() >= 90.0)
			{
				this.m.Requirements[0].IsSatisfied = true;
				return;
			}
		}

		local citystates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

		foreach( c in citystates )
		{
			if (c.getPlayerRelation() >= 90.0)
			{
				this.m.Requirements[0].IsSatisfied = true;
				return;
			}
		}
	}

});

