this.oath_of_honor_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_honor";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "As warriors, we must never lose sight of true honor.\nLet us take an Oath of Honor and meet our opponents in melee!";
		this.m.TooltipText = "\"While the arrow is nocked, the mind turns. While the sword swings, all is where it should be. Set aside the craft of archery and go unto the melee, trusting that what your steel seeks, it shall find.\" - Young Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]No matter what the bow users wish to say, when it comes down to it there is no greater honor than meeting a man face to face, each of you with sword in hand, locking eyes between crossed steel, in this clash finding a brief respite before one finds their demise. Even in the tournaments, the grand event is not some ridiculous affair like shooting apples off heads or birds out of the sky. No, it is the joust! Martial combat! The greatest honor in battle undertaken by the greatest company in the %companyname%.\n\nNow that the company is of sturdy might and main, it is ready to accept its next Oath!";
		this.m.SuccessButtonText = "{For Young Anselm! | As Oathtakers! | And death to the Oathbringers!}";
		this.m.OathName = "Oath of Honor";
		this.m.OathBoonText = "Your men start battle at Confident morale.";
		this.m.OathBurdenText = "Your men cannot use ranged weapons.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "You gain extra Renown for defeating enemies without them being engaged by other combatants (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersSoloKills");
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_honor_trait"));
			bro.getSkills().add(this.new("scripts/skills/special/oath_of_honor_warning"));
		}

		this.World.Statistics.getFlags().set("OathtakersSoloKills", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_honor");
			bro.getSkills().removeByID("special.oath_of_honor_warning");
		}

		this.World.Statistics.getFlags().set("OathtakersSoloKills", 0);
	}

});

