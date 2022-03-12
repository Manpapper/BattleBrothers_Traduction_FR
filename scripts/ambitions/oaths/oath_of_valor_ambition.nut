this.oath_of_valor_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_valor";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous devons avoir le courage de relever n\'importe quel défi, aussi décourageant soit-il.\nFaisons serment de courage et prouvons notre bravoure à tous !";
		this.m.TooltipText = "\"Rappelez-vous en temps de péril que le courage peut vaincre l\'habileté. Bien que peu de choses puissent être apprises par la bravoure seule, la détermination pure et simple vous gardera en vie et c\'est une conclusion suffisante aux leçons de la bataille.\" - Jeune Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Un homme ne peut pas prospérer uniquement grâce à ses compétences et ses capacités. Beaucoup savent manier l\'épée, manier la hache ou décocher une flèche. Ce n\'est pas dans les affaires martiales que l\'homme est façonné, mais en lui-même, dans les couloirs de son propre cœur. Cet acier forgé là ne peut jamais être vaincu, car même un homme valeureux abattu se retrouvera éternellement dans les tomes de ce monde, célébré dans l\'admiration, et son nom porté sur les lèvres de ceux qui lui ressemblent.\n\nMaintenant que la compagnie a prouvé sa solidité, elle est prête à accepter un autre serment !}";
		this.m.SuccessButtonText = "{Pour le jeune Anselm ! | Prêteurs de Serments ! | Et mort aux Briseurs de Serments !}";
		this.m.OathName = "Serment de Courage";
		this.m.OathBoonText = "Vos hommes ne fuiront jamais pendant la bataille.";
		this.m.OathBurdenText = "Vos hommes gagnent [color=" + this.Const.UI.Color.NegativeValue + "]15%[/color] d\'Expérience en moins.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Vous gagnez de la renommée supplémentaire en gagnant des batailles où vous êtes en infériorité numérique (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersDefeatedOutnumbering");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 5;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 4;
		}
		else
		{
			return 3;
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

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_valor_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersDefeatedOutnumbering", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_valor");
		}

		this.World.Statistics.getFlags().set("OathtakersDefeatedOutnumbering", 0);
	}

});

