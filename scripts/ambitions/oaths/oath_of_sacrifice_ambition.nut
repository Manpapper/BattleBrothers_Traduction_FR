this.oath_of_sacrifice_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_sacrifice";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous ne pouvons pas être à la hauteur de l\'exemple du jeune Anselm si nous sommes obsédés par les affaires du monde.\nFaisons le serment du sacrifice et aiguisons notre but jusqu\'au bout.";
		this.m.TooltipText = "\"Si tout est dans le domaine des dons des anciens dieux, alors la douleur elle-même sera leur fruit le plus amer. Mais c\'est une offrande, néanmoins, et donc notre combat contre la douleur est celui d\'un grand altruisme. Abstenez-vous de la réparation du guérisseur, et tout autant du prêt du marchand.\" - Jeune Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Les moines du couvent passeront des jours sans eau, des semaines sans nourriture et une éternité sans sexe. On croit que le sacrifice est le \'piment de toute chose\', et c\'est un élément si puissant que l\'on trouve dans les cendres de ceux qui ont volontairement souffert le résidu de l\'endurance elle-même. Maintenant, ayant fait un serment similaire, vous comprenez pourquoi les hommes saints manipulent les restes cendrés de leurs frères avec une sorte de soin maternel. Pour %companyname%, cette force éternelle a été répandue à travers la compagnie, car la misère est une chose terrible, mais la misère partagée, prise de front et épaule contre épaule avec vos frères d\'armes, est un élixir poignant, un élixir qui réduit l\'esprit à ce qui doit être fait, et évite toutes les questions terrestres.\n\nMaintenant, les hommes vont guérir et leurs esprits vont retrouver les attaches qui les maintiennent à la terre. Laissez aux moines le soin de se sacrifier pour le long terme, ils sont d\'une intelligence et d\'une foi plus fortes, ceux qu\'il faut regarder, et non suivre bêtement en pensant que vous pourriez faire la même chose qu\'eux.\n\nQuant à l\'avenir, il est temps que les Prêteurs de Serments prêtent un autre serment !}";
		this.m.SuccessButtonText = "{Pour le jeune Anselm ! | Prêteurs de Serments ! | Et mort aux Briseurs de Serments !}";
		this.m.OathName = "Serment de Sacrifice";
		this.m.OathBoonText = "Aucun de vos hommes ne prend de couronne comme salaire.";
		this.m.OathBurdenText = "Vos hommes ne guérissent pas de leurs blessures.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() <= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Vous gagnez de la renommée supplémentaire en ne subissant pas plus de " + this.getBonusObjectiveGoal() + " blessures au combat (" + this.getBonusObjectiveProgress() + (this.getBonusObjectiveProgress() == 1 ? " blessure reçue" : " blessures reçues") + "  jusqu\'à maintenant).";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersInjuriesSuffered");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 4;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 6;
		}
		else
		{
			return 8;
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_sacrifice_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersInjuriesSuffered", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_sacrifice");
		}

		this.World.Statistics.getFlags().set("OathtakersInjuriesSuffered", 0);
	}

});

