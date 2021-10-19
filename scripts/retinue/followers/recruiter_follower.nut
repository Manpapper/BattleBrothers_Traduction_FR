this.recruiter_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.recruiter";
		this.m.Name = "Le Recruteur";
		this.m.Description = "Le Recruteur est un escroc sournois qui incite des personnes désespérées à rejoindre une compagnie de mercenaires pour échapper à leur mauvaise vie, pour finalement trouver la mort. Très utile pour quiconque dirige une compagnie de mercenaires.";
		this.m.Image = "ui/campfire/recruiter_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"Vous payez 10% de moins pour l\'embauche de nouveaux hommes et 50% de moins pour les essais.",
			"Permet de recruter entre 2 et 4 hommes supplémentaires dans chaque ville"
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
		this.World.Assets.m.RosterSizeAdditionalMin += 2;
		this.World.Assets.m.RosterSizeAdditionalMax += 4;
		this.World.Assets.m.HiringCostMult *= 0.9;
		this.World.Assets.m.TryoutPriceMult *= 0.5;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Recruter " + this.Math.min(12, this.World.Statistics.getFlags().getAsInt("BrosHired")) + "/12 hommes";

		if (this.World.Statistics.getFlags().getAsInt("BrosHired") >= 12)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

