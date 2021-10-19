this.scout_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.scout";
		this.m.Name = "L\'Éclaireur";
		this.m.Description = "L\'éclaireur est un expert pour trouver des cols de montagne, naviguer dans des marécages traîtres et guider quiconque en toute sécurité dans les forêts les plus sombres.";
		this.m.Image = "ui/campfire/scout_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"Permet à la compagnie de se déplacer 15% plus vite sur n\'importe quel terrain",
			"Prévient les maladies et les accidents dus au terrain"
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
		for( local i = 0; i < this.World.Assets.m.TerrainTypeSpeedMult.len(); i = ++i )
		{
			this.World.Assets.m.TerrainTypeSpeedMult[i] *= 1.15;
		}
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Gagner " + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("BeastsDefeated")) + "/5 batailles contre des bêtes";

		if (this.World.Statistics.getFlags().getAsInt("BeastsDefeated") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

