this.oath_of_endurance_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_endurance";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Respecter les serments du Jeune Anselm, c\'est assumer un devoir sans fin.\nFaisons le serment d\'endurance et préparons-nous pour les tâches à venir !";
		this.m.TooltipText = "\"Trois fois ils ont grimpé, l\'endurance ils l\'ont trouvée.\" On raconte que lorsque le jeune Anselm a gravi le plus haut sommet de la chaîne de montagnes Higgarian, il a emmené avec lui neuf de ses plus valeureux disciples.";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Lorsqu\'on lui a demandé quelle armée il souhaitait voir déployée avec lui, un célèbre général a fait la remarque suivante : \'une qui n\'a pas besoin de respirer.\' Quelle que soit l\'habileté d\'un homme, s\'il n\'a pas l\'énergie nécessaire pour se battre, toutes ses capacités ne sont rien d\'autre que des sifflements d\'air, et dans un tel état, même un maître d\'épée peut se trouver aussi dangereux qu\'une fille de joie. Une bonne respiration prise maintenant est un coup d\'épée bien placé plus tard. %companyname% a suivi cet axiome à la lettre !\n\nMaintenant que la compagnie a rempli ses poumons, elle est prête à accepter un autre serment !}";
		this.m.SuccessButtonText = "{Pour le jeune Anselm ! | Prêteurs de Serments ! | Et mort aux Briseurs de Serments !}";
		this.m.OathName = "Serment d\'Endurance";
		this.m.OathBoonText = "Vos hommes récupèrent [color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] de Fatigue par tour.";
		this.m.OathBurdenText = "Vous pouvez seulement prendre jusqu\'à [color=" + this.Const.UI.Color.NegativeValue + "]10[/color] hommes au combat.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Vous gagnez de la renommée supplémentaire en gagnant de nombreuses batailles (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersBattlesWon");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 10;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 9;
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

		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() < 10)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5) + (this.m.IsDone ? 0 : 10) + this.m.TimesSkipped * 2;
	}

	function onUpdateEffect()
	{
		this.World.Assets.m.BrothersMaxInCombat = 10;
	}

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_endurance_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersBattlesWon", 0);
		this.World.Assets.resetToDefaults();
		this.World.Assets.updateFormation(true);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_endurance");
		}

		this.World.Statistics.getFlags().set("OathtakersBattlesWon", 0);
	}

});

