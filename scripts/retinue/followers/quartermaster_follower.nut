this.quartermaster_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.quartermaster";
		this.m.Name = "Le Quartier-Maître";
		this.m.Description = "Grâce à ses années d\'expérience en matière de voyages en caravane, le quartier-maître est capable de serrer et de faire pivoter n\'importe quelle pièce d\'équipement, bagage ou armure à l\'endroit parfait pour utiliser l\'espace aussi efficacement que possible.";
		this.m.Image = "ui/campfire/quartermaster_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"Augmente de 100 la quantité de munitions que vous pouvez porter",
			"Augmente la quantité d\'outils et de ressources médicales que vous pouvez transporter de 50 chacun"
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
		this.World.Assets.m.AmmoMaxAdditional = 100;
		this.World.Assets.m.MedcineMaxAdditional = 50;
		this.World.Assets.m.ArmorPartsMaxAdditional = 50;
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Compléter " + this.Math.min(5, this.World.Statistics.getFlags().getAsInt("EscortCaravanContractsDone")) + "/5 des contrats d\'escorte de caravanes";

		if (this.World.Statistics.getFlags().getAsInt("EscortCaravanContractsDone") >= 5)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

