this.oath_of_honor_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_honor";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "En tant que guerriers, nous ne devons jamais perdre de vue le véritable honneur.\nFaisons le serment d\'honneur et rencontrons nos adversaires en mêlée !";
		this.m.TooltipText = "\"Pendant que la flèche est encochée, l\'esprit tourne. Pendant que l\'épée se balance, tout est là où il devrait être. Mettez de côté l\'art du tir à l\'arc et allez dans la mêlée, confiant que ce que votre acier cherche, il le trouvera.\" - Young Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Quoi qu\'en disent les utilisateurs d\'arcs, il n\'y a pas de plus grand honneur que de rencontrer un homme face à face, chacun d\'entre vous, l\'épée à la main, croisant le regard entre deux aciers croisés, et trouvant dans cet affrontement un bref répit avant de trouver la mort. Même dans les tournois, le grand événement n\'est pas une affaire ridicule comme tirer des pommes sur des têtes ou des oiseaux dans le ciel. Non, c\'est la joute ! Un combat martial ! Le plus grand honneur de la bataille entrepris par la plus grande compagnie %companyname%.\n\nMaintenant que la compagnie est forte et solide, elle est prête à accepter son prochain serment !";
		this.m.SuccessButtonText = "{Pour le jeune Anselm ! | Prêteurs de Serments ! | Et mort aux Briseurs de Serments !}";
		this.m.OathName = "Serment d\'Honneur";
		this.m.OathBoonText = "Vos hommes commencent la bataille avec un moral Confiant.";
		this.m.OathBurdenText = "Vos hommes ne peuvent pas utiliser d\'armes à distance.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Vous gagnez des renommées supplémentaires pour vaincre des ennemis sans qu\'ils soient engagés par d\'autres combattants (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersSoloKills");
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

		if (this.World.Ambitions.getDone() < 1)
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_honor_trait"));
			bro.getSkills().add(this.new("scripts/skills/special/oath_of_honor_warning"));
		}

		this.World.Statistics.getFlags().set("OathtakersSoloKills", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_honor");
			bro.getSkills().removeByID("special.oath_of_honor_warning");
		}

		this.World.Statistics.getFlags().set("OathtakersSoloKills", 0);
	}

});

