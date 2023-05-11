this.oath_of_wrath_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_wrath";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Il n\'y a pas d\'erreur de combat plus fatale que la douceur.\nFaisons le Serment de la Colère et montrons à nos ennemis ce que cela signifie vraiment de mourir!";
		this.m.TooltipText = "Le jeune Anselm a rédigé de nombreux manuels de combat martial, dont les plus populaires prônent l\'utilisation d\'armes à deux mains et l\'absence de tact au combat. Du sang séché macule les pages de ces textes.";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Quand il s\'agit de combat mortel, il n\'y a qu\'un seul moyen d\'être sûr : l\'annihilation totale. Et l\'arme de prédilection dans cette entreprise de mort sont les armes à deux mains. Les hommes de %companyname% ont embrassé le Serment de la Colère comme des mites à un fer de forgeron à moitié achevé, lorsqu\'il sort des charbons ardents et flamboyants, le forgeron se tenant au-dessus de lui comme un bourreau fou, marteau à la main, prêt à aplanir ses bords incandescents pour en faire un produit fini de la mort ultime, et il le tourne et réalise que le morceau de métal est trop grand pour un homme ordinaire, mais assez grand pour couper quelqu\'un en deux s\'il est placé dans les bonnes mains. Ainsi, %companyname% a ignoré la défense et a accueilli la saignée à bras ouverts.\n\nEnsanglanté et la colère assouvie, %companyname% est prêt à prononcer son prochain serment !";
		this.m.SuccessButtonText = "{Pour le jeune Anselm ! | Prêteurs de Serments ! | Et mort aux Briseurs de Serments !}";
		this.m.OathName = "Serment de Colère";
		this.m.OathBoonText = "Vos hommes ont [color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] chance de toucher lorsqu\'ils utilisent des armes de mêlée à deux mains ou à double poignée, et leurs attaques causeront toujours des fatalités si elles le peuvent.";
		this.m.OathBurdenText = "Vos hommes ont [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Défense en Mêlée et [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Défense à Distance";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Vous gagnez de la renommée en tuant vos ennemis (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersWrathSlain");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 100;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 75;
		}
		else
		{
			return 50;
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_wrath_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersWrathSlain", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_wrath");
		}

		this.World.Statistics.getFlags().set("OathtakersWrathSlain", 0);
	}

});

