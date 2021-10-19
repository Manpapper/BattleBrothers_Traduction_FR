this.cartographer_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.cartographer";
		this.m.Name = "Le Cartographe";
		this.m.Description = "Le Cartographe est un homme de culture et de savoir, mais il sait aussi que voyager en compagnie de mercenaires bien armés est l\'un des meilleurs moyens de voir le monde en toute sécurité et d\'explorer des endroits que peu ont visités auparavant.";
		this.m.Image = "ui/campfire/cartographer_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"Il vous verse entre 100 et 400 couronnes pour chaque lieu que vous découvrez par vous-même. Plus vous vous éloignez de la civilisation, plus vous êtes payé. Les lieux légendaires sont payés double."
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "Découverte d\'un lieu légendaire"
			}
		];
	}

	function onUpdate()
	{
	}

	function onEvaluate()
	{
		if (this.World.Flags.getAsInt("LegendaryLocationsDiscovered") >= 1)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

	function onLocationDiscovered( _location )
	{
		local settlements = this.World.EntityManager.getSettlements();
		local dist = 9999;

		foreach( s in settlements )
		{
			local d = s.getTile().getDistanceTo(_location.getTile());

			if (d < dist)
			{
				dist = d;
			}
		}

		local reward = this.Math.min(400, this.Math.max(100, 10 * dist));

		if (_location.isLocationType(this.Const.World.LocationType.Unique))
		{
			reward = reward * 2;
		}

		this.World.Assets.addMoney(reward);
	}

});

