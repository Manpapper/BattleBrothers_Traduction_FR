this.alchemist_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.alchemist";
		this.m.Name = "L\'Alchimiste";
		this.m.Description = "L\'alchimiste est capable de fabriquer toutes sortes d\'engins et de concoctions mystérieuses à partir d\'ingrédients exotiques lorsqu\'il a accès à l\'équipement du taxidermiste, et il utilise moins de matériaux pour le faire.";
		this.m.Image = "ui/campfire/alchemist_01";
		this.m.Cost = 2500;
		this.m.Effects = [
			"A 25% de chances de ne pas consommer les composants d\'artisanat que vous utilisez",
			"Déverrouille la recette \"Huile de Serpent\" pour gagner de l\'argent en fabriquant des objets à partir de divers composants de bas niveau"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = ""
			}
		];
	}

	function isValid()
	{
		return this.Const.DLC.Unhold;
	}

	function onUpdate()
	{
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Fabriquer " + this.Math.min(15, this.World.Statistics.getFlags().getAsInt("ItemsCrafted")) + "/15 objets chez le taxidermiste";

		if (this.World.Statistics.getFlags().getAsInt("ItemsCrafted") >= 15)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

