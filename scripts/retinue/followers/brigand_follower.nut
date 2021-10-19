this.brigand_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.brigand";
		this.m.Name = "Le Brigand";
		this.m.Description = "Le Brigand est peut-être vieux et faible maintenant, mais il fut un temps où son nom était craint dans tout le pays. En échange d\'un repas chaud, il partage volontiers avec vous ce qu\'il apprend de ses contacts sur les caravanes qui sont sur les routes.";
		this.m.Image = "ui/campfire/brigand_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"Permet de voir la position de certaines caravanes à tout moment et même si elles sont en dehors de votre rayon de vision"
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
		this.World.Assets.m.IsBrigand = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Piller " + this.Math.min(4, this.World.Statistics.getFlags().getAsInt("CaravansRaided")) + "/4 caravanes";

		if (this.World.Statistics.getFlags().getAsInt("CaravansRaided") >= 4)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

