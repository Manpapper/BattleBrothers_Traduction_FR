this.oath_of_humility_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_humility";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "L\'arrogance est un tueur sournois.\nFaisons un serment d\'humilité et réfléchissons à nos défauts pour un temps.";
		this.m.TooltipText = "\"Comme vous êtes en effet des hommes à la recherche du pouvoir, écoutez toujours les faibles... car les faibles connaissent les forts mieux que vous, et à leur tour ils vous connaîtront mieux que vous ne vous connaissez vous-même.\" - Jeune Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Tout homme faible peut s\'agenouiller, mais le faire à partir d\'une position de force est la véritable humilité. Alors que %companyname% aurait pu chercher à utiliser sa renommée pour faire de nouvelles fortunes, elle s\'est tenu à l\'écart, consacrant une partie de sa richesse aux nécessiteux et aux communautés qui offraient ces contrats en premier lieu. Beaucoup d\'hommes ont tiré les leçons de cette expérience et l\'on peut espérer que les méthodes utilisées seront utiles à l\'avenir, que ce soit dans cette vie ou dans la suivante.\n\n%companyname% est prêt à relever son prochain défi.";
		this.m.SuccessButtonText = "{Pour le jeune Anselm ! | Prêteurs de Serments ! | Et mort aux Briseurs de Serments !}";
		this.m.OathName = "Serment d\'Humilité";
		this.m.OathBoonText = "Vos hommes gagnent [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] d\'expérience en  plus.";
		this.m.OathBurdenText = "Vous gagnez [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] couronnes en moins des contrats.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Vous gagnez de la renommée supplémentaire en remplissant suffisamment de contrats (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersContractsComplete");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 7;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 6;
		}
		else
		{
			return 5;
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

		this.m.Score = 1 + this.Math.rand(0, 5) + (this.m.IsDone ? 0 : 10) + this.m.TimesSkipped * 2;
	}

	function onUpdateEffect()
	{
		this.World.Assets.m.ContractPaymentMult *= 0.75;
	}

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_humility_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersContractsComplete", 0);
		this.World.Assets.resetToDefaults();
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_humility");
		}

		this.World.Statistics.getFlags().set("OathtakersContractsComplete", 0);
	}

});

