this.lookout_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.lookout";
		this.m.Name = "Le Guetteur";
		this.m.Description = "Le fait d\'avoir un guetteur rapide aux yeux perçants qui voyage avant la compagnie peut s\'avérer inestimable pour être au courant des dangers et des points d\'intérêt avant que les autres ne soient au courant de la compagnie.";
		this.m.Image = "ui/campfire/lookout_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"Augmente votre rayon de vision de 25%",
			"Révèle des informations complémentaires sur les empreintes"
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
		this.World.Assets.m.VisionRadiusMult = 1.25;
		this.World.Assets.m.IsShowingExtendedFootprints = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Découverte de " + this.Math.min(10, this.World.Statistics.getFlags().getAsInt("LocationsDiscovered")) + "/10 lieux par vous-même";

		if (this.World.Statistics.getFlags().getAsInt("LocationsDiscovered") >= 10)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

