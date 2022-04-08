this.oath_of_distinction_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_distinction";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Ceux qui peuvent suivre les enseignements du jeune Anselm sont vraiment distingués.\nFaisons serment de distinction et prouvons que nous sommes dignes de suivre ses traces !";
		this.m.TooltipText = "Le jeune Anselm recherchait fréquemment la solitude, parfois même sur le champ de bataille. \"Prouve-toi digne de telle sorte que même les anciens dieux ne puissent prétendre que leurs yeux se sont trompés dans les gloires qu\'ils ont vues.\"";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Beaucoup de maîtres d\'épée pratiquent la solitude. L\'idée est qu\'ils ne se battent pas contre les hommes qui se trouvent devant eux, mais qu\'ils se battent pour les espaces entre eux. Bien que vous ne puissiez pas comprendre les petites nuances qui différencient un maître d\'armes d\'un mercenaire en train de taper dans le vide, vous réalisez le fond de vérité de cet axiome. Les Prêteurs de Serments, bien qu\'honorables et diligents, sont toujours, au fond, brutalement courageux et absurdement trop sûrs d\'eux. Le Serment de la Distinction a suivi l\'art du Maître d\'épée dans l\'esprit, et celui du Prêteur de Serments dans la pensée. Se démarquant par ses propres moyens, chaque homme cherchait à faire ses preuves et à se montrer digne des louanges des autres. Et si des personnes impartiales se trouvaient à regarder, il serait impossible de dire que  %companyname% ne s\'est pas distinguée par son excellence.\n\nMais que la distinction soit damnée. Nous ne pouvons pas être en quête de gloire toute notre vie ! Au prochain serment !}";
		this.m.SuccessButtonText = "{Pour le jeune Anselm ! | Prêteurs de Serments ! | Et mort aux Briseurs de Serments !}";
		this.m.OathName = "Serment de Distinction";
		this.m.OathBoonText = "Vos hommes gagnent [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Détermination, [color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] de Récupération de Fatigue par tour, et font [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] de dégats s\'ils n\'ont pas d\'alliés sur les tuiles adjacentes.";		
		this.m.OathBurdenText = "Vos hommes ne gagnent pas d\'expérience pour les ennemis qui n\'ont pas été tués par eux-mêmes.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Vous gagnez de la renommée supplémentaire si l\'un de vos hommes monte en grade " + this.getBonusObjectiveGoal() + " fois (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		brothers.sort(function ( _a, _b )
		{
			if (_a.getFlags().getAsInt("OathtakersDistinctionLevelUps") > _b.getFlags().getAsInt("OathtakersDistinctionLevelUps"))
			{
				return -1;
			}
			else if (_a.getFlags().getAsInt("OathtakersDistinctionLevelUps") < _b.getFlags().getAsInt("OathtakersDistinctionLevelUps"))
			{
				return 1;
			}

			return 0;
		});
		return brothers[0].getFlags().getAsInt("OathtakersDistinctionLevelUps");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 3;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 2;
		}
		else
		{
			return 2;
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_distinction_trait"));
			bro.getFlags().set("OathtakersDistinctionLevelUps", 0);
		}
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_distinction");
			bro.getFlags().set("OathtakersDistinctionLevelUps", 0);
		}
	}

});

