this.oath_of_dominion_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_dominion";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Les bêtes ont toujours menacé la civilisation.\nFaisons le serment de domination et revendiquons nos droits contre les marées de la nature !";
		this.m.TooltipText = "\"Nous venons des bêtes, mais les bêtes veulent nous reprendre. Prenez vos distances par rapport à la primitivité de la nature, prouvez votre valeur par rapport à elle de manière à ce que votre humanité soit tenue en main et vue à travers vos propres yeux.\" - Jeune Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Il n\'y a pas de menace plus courante dans ce monde que celle de la bête ordinaire. Et pourtant, malgré cette maladie rampante des créatures, très peu d\'hommes sont prêts à prendre les armes et à chercher à les vaincre. Il n\'y a que vous tous, %companyname%, qui avez fait le serment de tuer les monstres, et vous les avez tués. Avec des mains fermes et des coeurs calmes, vous avez respecté ce serment.\n\nTriomphant des bêtes et des monstres, les hommes sont prêts à affronter tout ce qui peut arriver !";
		this.m.SuccessButtonText = "{Pour le jeune Anselm ! | Prêteurs de Serments ! | Et mort aux Briseurs de Serments !}";
		this.m.RewardTooltip = "";
		this.m.OathName = "Serment de Domination";
		this.m.OathBoonText = "Vos hommes ont [color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] de Détermination et [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Compétence en Mêlée et à distance s\'ils se battent contre des bêtes.";
		this.m.OathBurdenText = "Vos hommes ont [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Détermination et [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Compétence en Mêlée et à distance s\'ils se battent contre n\'importe quel autre ennemi.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Vous gagnez de la renommée supplémentaire en tuant des bêtes (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersBeastsSlain");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 50;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 35;
		}
		else
		{
			return 20;
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

		if (this.World.Ambitions.getDone() < 2)
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_dominion_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersBeastsSlain", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_dominion");
		}

		this.World.Statistics.getFlags().set("OathtakersBeastsSlain", 0);
	}

});

