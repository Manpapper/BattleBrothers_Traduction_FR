this.trader_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.trader";
		this.m.Name = "Le Commerçant";
		this.m.Description = "Les commerçants du Sud sont réputés pour leurs compétences en matière de troc. Vous avez de la chance d\'avoir pu convaincre un tel maître du marchandage de rejoindre votre compagnie. Et à un tel prix !";
		this.m.Image = "ui/campfire/trader_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"Augmente la quantité de marchandises à vendre de 1 pour chaque emplacement qui les produit, comme le sel près des mines de sel, ce qui vous permet de faire du commerce à des volumes plus élevés."
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
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Vendre " + this.Math.min(25, this.World.Statistics.getFlags().getAsInt("TradeGoodsSold")) + "/25 marchandises commerciales";

		if (this.World.Statistics.getFlags().getAsInt("TradeGoodsSold") >= 25)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

