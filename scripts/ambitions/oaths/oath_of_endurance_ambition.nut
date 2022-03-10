this.oath_of_endurance_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_endurance";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "To uphold Young Anselm\'s Oaths is to take on a duty without end.\nLet us take an Oath of Endurance and prepare ourselves for the tasks to come!";
		this.m.TooltipText = "\"Thrice times thrice to climb, endurance they did find.\" It is said that when Young Anselm ascended the highest peak of the Higgarian mountain range, he took nine of his worthiest followers with him.";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{When asked what army he would wish to see deployed before him, a famous general remarked: \'one that does not need to breathe.\' No matter how skilled a man is, if he does not have the energy to fight, then all his abilities are reduced to nothing but wheezes of air, and in such a state even a swordmaster may find himself only as dangerous as a dram wench. A good breath taken now is a well-placed sword swing later. The %companyname% has followed that axiom to its fullest!\n\nNow that the company has filled its lungs of proper fire, it is ready to accept another Oath!}";
		this.m.SuccessButtonText = "{For Young Anselm! | As Oathtakers! | And death to the Oathbringers!}";
		this.m.OathName = "Oath of Endurance";
		this.m.OathBoonText = "Your men recover [color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] Fatigue per turn.";
		this.m.OathBurdenText = "You can only take up to [color=" + this.Const.UI.Color.NegativeValue + "]10[/color] men into battle.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "You gain extra Renown for winning many battles (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
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

