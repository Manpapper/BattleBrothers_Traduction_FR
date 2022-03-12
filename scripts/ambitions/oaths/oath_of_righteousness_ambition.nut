this.oath_of_righteousness_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_righteousness";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Peu d\'aberrations sont aussi répugnantes que les morts-vivants.\nFaisons le serment de la justice et détruisons ces moqueries de la vie !";
		this.m.TooltipText = "\"Méfiez-vous du mal qui a envahi ce royaume. Mettez de côté les affaires mondaines et consacrez-vous à faire reposer nos morts une fois pour toutes. Aucun homme ne mérite de marcher deux fois sur cette terre sombre.\" - Jeune Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Quand on parcourt la terre, on ne peut s\'empêcher de se demander qui est venu avant, et qui ou quoi vient après. Ainsi, la vue des morts marchant à nouveau est une réponse si troublante à cette question que la plupart préfèrent la fuir plutôt que de chercher une confirmation, et dans cette confirmation : la confrontation. Mais ce sont ces crétins impies que %companyname% recherchait, faisant le serment de les vaincre où qu\'ils se trouvent. C\'était une affaire juste qui nécessitait un grand courage, et à son terme, il ne fait aucun doute que les hommes de la compagnie %companyname% ont été animés d\'un sentiment d\'accomplissement que peu de personnes sur cette terre, morts ou vivants, ressentiront jamais.\n\nLes veines embrasées par la droiture, %companyname% est prêt à prononcer son prochain serment !";
		this.m.SuccessButtonText = "{Pour le jeune Anselm ! | Prêteurs de Serments ! | Et mort aux Briseurs de Serments !}";
		this.m.RewardTooltip = "";
		this.m.OathName = "Serment de Justice";
		this.m.OathBoonText = "Vos hommes ont [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] de Détermination et [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Compétence en Mêlée et à distance, et [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] de Défense en Mêlée et à distance s\'ils se battent contre des morts vivants.";
		this.m.OathBurdenText = "Vos hommes ont [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Détermination et [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Compétence en Mêlée et à distance, et [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Défense en Mêlée et à distance s\'ils se battent contre n\'importe quel autre ennemi.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Vous gagnez de la renommée supplémentaire en tuant des morts-vivants (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersUndeadSlain");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 75;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 50;
		}
		else
		{
			return 25;
		}
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5) + (this.m.IsDone ? 0 : 10) + this.m.TimesSkipped * 2;
	}

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_righteousness_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersUndeadSlain", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_righteousness");
		}

		this.World.Statistics.getFlags().set("OathtakersUndeadSlain", 0);
	}

});

