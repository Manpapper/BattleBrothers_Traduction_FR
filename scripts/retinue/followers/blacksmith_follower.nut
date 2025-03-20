this.blacksmith_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.blacksmith";
		this.m.Name = "Le Forgeron";
		this.m.Description = "Les mercenaires sont doués pour détruire les armes et les armures, mais pas pour les entretenir. Le forgeron s\'occupera de cette tâche fastidieuse rapidement et efficacement, et pourra même réparer des équipements que l\'on croyait perdus.";
		this.m.Image = "ui/campfire/blacksmith_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"Répare tout l\'équipement porté par vos hommes, même s\'ils sont cassés ou perdus parce que votre homme est mort",
			"Augmente la vitesse de réparation de 20%",
			"Réduit la consommation des Outils par 20%"
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
		this.World.Assets.m.RepairSpeedMult *= 1.2;
		this.World.Assets.m.ArmorPartsPerArmor *= 0.8;
		this.World.Assets.m.IsBlacksmithed = true;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Ayez " + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("ItemsRepaired")) + "/5 équipements réparé chez un forgeron d\'une ville";

		if (this.World.Statistics.getFlags().getAsInt("ItemsRepaired") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

