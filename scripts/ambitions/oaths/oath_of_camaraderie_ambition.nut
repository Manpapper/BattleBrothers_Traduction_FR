this.oath_of_camaraderie_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {
		DisableEffect = false
	},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_camaraderie";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Aucun Prêteur de Serments ne peut affronter seul tous les maux du monde.\nPrêtons le serment de Camaraderie, de peur de perdre de vue nos véritables alliés !";
		this.m.TooltipText = "Le jeune Anselm pensait que parfois, il était bon d\'amener le plus grand nombre possible de personnes à une bataille, même si la foule menaçait la chaîne de commandement. En effet, \"Tous les hommes méritent d\'être aux côtés de leurs frères.\"";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{La force du nombre, la camaraderie dans la fraternité. Bien que le fait de mobiliser des hommes supplémentaires réduise votre capacité de commandement, au cours de chaque bataille, %companyname% a rapidement compris que le chaos du combat pouvait être surmonté en se tenant côte à côte avec les homme à vos côtés, en leur faisant confiance pour faire leur travail et qu\'ils vous fasse confiance pour faire le votre. Cette expérience a endurci la compagnie aux ravages de la guerre.\n\nMaintenant que la compagnie sait qu\'elle peut affronter ses ennemis en faisant confiance à ses propres membres, elle est prête à prononcer un autre serment.!}";
		this.m.SuccessButtonText = "{Pour le jeune Anselm ! | Prêteurs de Serments ! | Et mort aux Briseurs de Serments !}";
		this.m.OathName = "Serment de Camaraderie";
		this.m.OathBoonText = "Vous pouvez prendre jusqu\'à [color=" + this.Const.UI.Color.PositiveValue + "]14[/color] hommes dans la bataille.";
		this.m.OathBurdenText = "Vos hommes commencent toujours la bataille au hasard avec un moral chancelant ou défaillant.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "Vous gagnez de la renommée supplémentaire si vos hommes deviennent confiants au combat suffisamment de fois. (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersBrosConfident");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 150;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 100;
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
		if (!this.m.DisableEffect)
		{
			this.World.Assets.m.BrothersMaxInCombat = 14;
		}
	}

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_camaraderie_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersBrosConfident", 0);
		this.World.Assets.resetToDefaults();
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_camaraderie");
		}

		this.World.Statistics.getFlags().set("OathtakersBrosConfident", 0);
		this.m.DisableEffect = true;
		this.World.Assets.resetToDefaults();
		this.World.Assets.updateFormation(true);
	}

});

