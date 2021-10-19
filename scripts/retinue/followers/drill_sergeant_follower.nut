this.drill_sergeant_follower <- this.inherit("scripts/retinue/follower", {
	m = {},
	function create()
	{
		this.follower.create();
		this.m.ID = "follower.drill_sergeant";
		this.m.Name = "Le Sergent Instructeur";
		this.m.Description = "Le sergent instructeur était autrefois un mercenaire, mais une blessure a mis fin prématurément à sa carrière. Maintenant, il inculque la discipline à vos hommes et crie beaucoup pour s\'assurer que chacun apprend de ses erreurs.";
		this.m.Image = "ui/campfire/drill_01";
		this.m.Cost = 3500;
		this.m.Effects = [
			"Vos hommes gagnent 20 % d\'expérience en plus au niveau 1, et 2 % en moins à chaque niveau supplémentaire.",
			"Fait en sorte que les hommes en réserve ne perdent jamais le moral en ne prenant pas part aux batailles"
		];
		this.m.Requirements = [
			{
				IsSatisfied = false,
				Text = "Mettre à la retraite un homme avec une blessure permanente qui n\'est pas endetté."
			}
		];
	}

	function onUpdate()
	{
		this.World.Assets.m.IsDisciplined = true;
	}

	function onEvaluate()
	{
		if (this.World.Statistics.getFlags().getAsInt("BrosWithPermanentInjuryDismissed") > 0)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}

});

