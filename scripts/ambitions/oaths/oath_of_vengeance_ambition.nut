this.oath_of_vengeance_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_vengeance";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Pendant trop longtemps, les peaux vertes ont infesté nos terres.\nFaisons le serment de vengeance et eradiquons cette menace !";
		this.m.TooltipText = "La famille du jeune Anselm a été tuée par des orcs lors d\'une bataille connue dous de multiple noms. Lorsqu\'il a lui-même affronté les peaux-vertes, on dit qu\'il semblait être un guerrier invincible et ses disciples cherchent à imiter cet élan vengeur de prouesses martiales.";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Les peaux vertes sont depuis longtemps un fléau pour la terre des hommes. Malgré leur menace permanente, rares sont ceux qui prêtent serment de détruire ces créatures. Ils sont un fléau précisément parce qu\'ils sont si dangereux, et parce qu\'ils sont si dangereux, la plupart préfèrent détourner le regard plutôt que d\'oser affronter les bêtes. Cependant, les hommes de %companyname% ont décidé de prêter serment contre les orcs et les gobelins, et de s\'aventurer loin pour les trouver et les chasser. Après être allés jusqu\'au bout, un sentiment d\'accomplissement envahit la compagnie.\n\nLes hommes sont déjà en train de se ronger les sangs : quel sera le prochain serment à prononcer ?";
		this.m.SuccessButtonText = "{Pour le jeune Anselm ! | Prêteurs de Serments ! | Et mort aux Briseurs de Serments !}";
		this.m.RewardTooltip = "";
		this.m.OathName = "Serment de Vengeance";
		this.m.OathBoonText = "Vos hommes ont [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] de Détermination, [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Compétence en Mêlée et à distance, et [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] de Défense en Mêlée et à distance s\'ils se battent contre des Orcs ou des Gobelins.";
		this.m.OathBurdenText = "Vos hommes ont [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Détermination, [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Compétence en Mêlée et à distance, et [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Défense en Mêlée et à distance s\'ils se battent contre n\'importe quel autre ennemi.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Vous gagnez de la renommée supplémentaire en tuant des peaux vertes (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersGreenskinsSlain");
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_vengeance_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersGreenskinsSlain", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_vengeance");
		}

		this.World.Statistics.getFlags().set("OathtakersGreenskinsSlain", 0);
	}

});

