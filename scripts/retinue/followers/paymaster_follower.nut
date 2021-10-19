this.paymaster_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.paymaster";
		this.m.Name = "Le Trésorier";
		this.m.Description = "Le trésorier s\'occupe de tous les aspects financiers et organisationnels quotidiens de la gestion d\'une compagnie de mercenaires, comme le paiement des salaires.";
		this.m.Image = "ui/campfire/paymaster_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"Réduit le salaire journalier de chaque homme de 15%",
			"Réduit de 50% les risques de désertion",
			"Empêche les hommes d\'exiger un salaire plus élevé dans les événements"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function isVisible()
	{
		return this.World.Assets.getBrothersMax() >= 16;
	}

	function onUpdate()
	{
		this.World.Assets.m.DailyWageMult *= 0.85;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Avoir une compagnie de " + this.Math.min(16, this.World.getPlayerRoster().getSize()) + "/16 hommes";

		if (this.World.getPlayerRoster().getSize() >= 16)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

