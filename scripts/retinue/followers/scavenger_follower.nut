this.scavenger_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.scavenger";
		this.m.Name = "Le Charognard";
		this.m.Description = "Qu\'il s\'agisse du fils d\'un de vos hommes ou d\'un gamin que vous avez pris en pitié, le charognard fait son travail en collectant des objets sur tous les champs de bataille.";
		this.m.Image = "ui/campfire/scavenger_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"Récupère une partie de toutes les munitions que vous utilisez pendant les combats",
			"Récupère les outils et les fournitures de chaque armure détruite par vous pendant la bataille"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "Avoir un cœur"
			}
		];
	}

	function onUpdate()
	{
		this.World.Assets.m.IsRecoveringAmmo = true;
		this.World.Assets.m.IsRecoveringArmor = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].IsSatisfied = true;
	}

});

