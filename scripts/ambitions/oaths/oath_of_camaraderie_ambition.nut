this.oath_of_camaraderie_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {
		DisableEffect = false
	},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_camaraderie";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "No single Oathtaker can face all the evils of the world alone.\nLet us take an Oath of Camaraderie, lest we lose sight of our true allies!";
		this.m.TooltipText = "Young Anselm believed that, on occasion, it was right to bring as many to a battle as one could muster, even if the great throngs did threaten the chain of command. Indeed, \"All men deserve to stand by their brothers.\"";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Power in numbers, camaraderie in brotherhood. While fielding additional men encumbered your ability to command, over the course of every battle the %companyname% quickly realized that the chaos of combat could be overcome by standing shoulder to shoulder with the man beside you, trusting him to do his job and him trusting that you do yours. The experience has hardened the company to the havocs of war.\n\nNow that the company knows it can confront its enemies by trusting its own members, it is ready to take on another Oath!}";
		this.m.SuccessButtonText = "{For Young Anselm! | As Oathtakers! | And death to the Oathbringers!}";
		this.m.OathName = "Oath of Camaraderie";
		this.m.OathBoonText = "You can take up to [color=" + this.Const.UI.Color.PositiveValue + "]14[/color] men into battle.";
		this.m.OathBurdenText = "Your men always start battle randomly at Wavering or Breaking morale.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "You gain extra Renown if your men become confident in battle enough times (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
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

