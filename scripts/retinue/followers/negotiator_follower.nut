this.negotiator_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.negotiator";
		this.m.Name = "Le Négociateur";
		this.m.Description = "Le Négociateur est habitué aux cours de la noblesse et aux salles d\'apparat, et n\'a pas l\'habitude de voyager avec une bande de mercenaires aux bottes boueuses, mais il est un expert dans la négociation des meilleurs prix et conditions lorsqu\'il s\'agit de contrats.";
		this.m.Image = "ui/campfire/negotiator_01";
		this.m.Cost = 3000;
		this.m.Effects = [
			"Permet de faire plus de cycles de négociations avec vos employeurs potentiels avant qu\'ils abandonnent, et ce sans nuire aux relations.",
			"Permet aux mauvaises relations de se stabiliser plus vite et aux bonnes relations de se dégrader moins vite"
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
		this.World.Assets.m.NegotiationAnnoyanceMult = 0.5;
		this.World.Assets.m.AdvancePaymentCap = 0.75;
		this.World.Assets.m.RelationDecayGoodMult = 0.9;
		this.World.Assets.m.RelationDecayBadMult = 1.1;
	}

	function onNewDay()
	{
		this.onUpdate();
	}

	function onEvaluate()
	{
		this.m.Requirements[0].Text = "Compléter " + this.Math.min(15, this.World.Contracts.getContractsFinished()) + "/15 contrats";

		if (this.World.Contracts.getContractsFinished() >= 15)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

