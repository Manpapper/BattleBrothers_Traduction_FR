this.surgeon_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.surgeon";
		this.m.Name = "Le Chirurgien";
		this.m.Description = "Le chirurgien est un livre ambulant de connaissances anatomiques. Une compagnie de mercenaires semble être l\'endroit idéal pour appliquer ces connaissances de la guérison, mais aussi pour en apprendre davantage sur la façon dont l\'intérieur des hommes est constitué.";
		this.m.Image = "ui/campfire/surgeon_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"Chaque homme sans blessure permanente est assuré de survivre à un coup qui lui serait autrement fatal",
			"Chaque blessure prend un jour de moins pour guérir"
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
		this.World.Assets.m.IsSurvivalGuaranteed = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Traiter " + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("InjuriesTreatedAtTemple")) + "/5 blessures de vos hommes à un Temple";

		if (this.World.Statistics.getFlags().getAsInt("InjuriesTreatedAtTemple") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

