this.oath_of_valor_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_valor";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "We must have the courage to face down any challenge, no matter how daunting.\nLet us take an Oath of Valor and prove our bravery to all!";
		this.m.TooltipText = "\"Remember in times of peril that courage can overcome skill. While little can be learned through bravery alone, sheer determination shall keep you alive and that is well enough as any conclusion to the lessons of battle.\" - Young Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{A man cannot thrive merely on skill and capability. Many know how to swing a sword, heft an axe, or loose an arrow. It is not in martial matters where man is molded, but within himself, within the corridors of his own heart. The steel forged there can\'t ever be defeated, for even a felled man of valor shall find himself eternal in the tomes of this world, celebrated in awe, and his name carried on the lips of those like him.\n\nNow that the company has proven itself of the firmest element, it is ready to accept another Oath!}";
		this.m.SuccessButtonText = "{For Young Anselm! | As Oathtakers! | And death to the Oathbringers!}";
		this.m.OathName = "Oath of Valor";
		this.m.OathBoonText = "Your men will never flee while in battle.";
		this.m.OathBurdenText = "Your men gain [color=" + this.Const.UI.Color.NegativeValue + "]15%[/color] less experience.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "You gain extra Renown for winning battles where you are outnumbered (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersDefeatedOutnumbering");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 5;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 4;
		}
		else
		{
			return 3;
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_valor_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersDefeatedOutnumbering", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_valor");
		}

		this.World.Statistics.getFlags().set("OathtakersDefeatedOutnumbering", 0);
	}

});

