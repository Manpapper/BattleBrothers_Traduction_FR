this.minstrel_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.minstrel";
		this.m.Name = "Le Ménestrel";
		this.m.Description = "Une bonne chanson et une bonne histoire jouent un rôle important dans la création de la réputation d\'une compagnie. Le ménestrel est un maître dans ces domaines et il contribuera à faire connaître vos exploits à toutes les oreilles, qu\'elles soient disposées à les entendre ou non.";
		this.m.Image = "ui/campfire/minstrel_01";
		this.m.Cost = 2000;
		this.m.Effects = [
			"Vous fait gagner 15% de renommée en plus à chaque action.",
			"Les rumeurs de taverne sont plus susceptibles de contenir des informations utiles"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function onUpdate()
	{
		this.World.Assets.m.BusinessReputationRate *= 1.15;
		this.World.Assets.m.IsNonFlavorRumorsOnly = true;
	}

	function onEvaluate()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local settlementsVisited = 0;
		local maxSettlements = settlements.len();

		foreach( s in settlements )
		{
			if (s.isVisited())
			{
				settlementsVisited = ++settlementsVisited;
			}
		}

		this.m.Requirements[0].Text = "Visiter " + settlementsVisited + "/" + maxSettlements + " villes";

		if (settlementsVisited >= maxSettlements)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

