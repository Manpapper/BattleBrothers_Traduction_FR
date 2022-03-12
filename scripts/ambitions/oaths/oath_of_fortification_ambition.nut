this.oath_of_fortification_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_fortification";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Les méchants se tapissent et se cachent loin des murs des justes.\nFaisons un serment de fortification et apportons ces murs à eux !";
		this.m.TooltipText = "\"Faites confiance à vos boucliers comme vous feriez confiance aux anciens dieux, car la contribution des arbres et de la terre ne sera pas gaspillée sur le bras d\'un lâche.\" - Jeune Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Les textes de l\'Ancien Empire parlent de formations militaires si serrées et compactes qu\'elles ressemblaient à des châteaux ambulants sur pattes : des centaines de boucliers tenus ensemble comme les écailles d\'un serpent ou la carapace d\'une tortue. %companyname% s\'efforçait de reproduire ces théories. Il fallait toujours quelques instants pour assembler les éléments, mais vous n\'avez jamais voulu que ce soit un exercice d\'excellence. Les anciens avaient un empire pour une raison, et vous êtes une compagnie de marginaux et de Prêteurs de Serments. Mais d\'après votre estimation, ce serment a été un succès remarquable.\n\nIl est maintenant temps de baisser les boucliers et la ferveur de l\'Ancien Empire et de prononcer un nouveau serment !}";
		this.m.SuccessButtonText = "{Pour le jeune Anselm ! | Prêteurs de Serments ! | Et mort aux Briseurs de Serments !}";
		this.m.OathName = "Serment de Fortification";
		this.m.OathBoonText = "Vos hommes accumulent [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] de Fatigue en moins quand ils utilisent des compétences de bouclier. La compétence \'Renverser\' étourdit maintenant la cible lorsqu\'elle est touchée";
		this.m.OathBurdenText = "Vos hommes ne peuvent pas bouger lors du premier tour du combat.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() <= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Vous gagnez de la renommée supplémentaire si aucun de vos hommes ne meurt pendant le serment (" + this.getBonusObjectiveProgress() + " morts jusqu\'à maintenant).";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersBrosDead");
	}

	function getBonusObjectiveGoal()
	{
		return 0;
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_fortification_trait"));
			bro.getSkills().add(this.new("scripts/skills/special/oath_of_fortification_warning"));
		}
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_fortification");
			bro.getSkills().removeByID("special.oath_of_fortification_warning");
		}
	}

});

