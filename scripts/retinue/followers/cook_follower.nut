this.cook_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.cook";
		this.m.Name = "Le Cuisinier";
		this.m.Description = "Un bon repas chaud contribue largement à la guérison du corps et de l\'esprit. Le cuisinier veille à ce qu\'aucune provision ne soit gaspillée et offre aux hommes des repas revigorants.";
		this.m.Image = "ui/campfire/cook_01";
		this.m.Cost = 2000;
		this.m.Effects = [
			"Fait durer toutes les provisions 3 jours de plus",
			"Augmente le taux de guérison des points de vie de 33%"
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
		this.World.Assets.m.FoodAdditionalDays = 3;
		this.World.Assets.m.HitpointsPerHourMult = 1.33;
	}

	function onEvaluate()
	{
		local uniqueProvisions = this.getAmountOfUniqueProvisions();
		this.m.Requirements[0].Text = "Ayez " + this.Math.min(8, uniqueProvisions) + "/8 différents types de provisions";

		if (uniqueProvisions >= 8)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

	function getAmountOfUniqueProvisions()
	{
		local provisions = [];
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.isItemType(this.Const.Items.ItemType.Food))
			{
				if (provisions.find(item.getID()) == null)
				{
					provisions.push(item.getID());
				}
			}
		}

		return provisions.len();
	}

});

