this.oath_of_humility_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_humility";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Arrogance is an insidious killer.\nLet us take an Oath of Humility and reflect on our shortcomings for a time.";
		this.m.TooltipText = "\"As you are indeed men in pursuit of power, always listen to the weak...for the weak know the strong better than you do, and in turn they shall know you better than you know yourself.\" - Young Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Any weak man can kneel, but to do so from a position of strength is true humility. While the %companyname% could have sought to wield its fame to make new fortunes, it instead stood aside, dedicating portions of its wealth to the needy and back to the communities who were offering these contracts in the first place. Many of the men have learned well from this experience and there is some hope that the methods deployed will be of use going forward, whether in this life or the next.\n\nThe %companyname% are ready to take on their next challenge.";
		this.m.SuccessButtonText = "{For Young Anselm! | As Oathtakers! | And death to the Oathbringers!}";
		this.m.OathName = "Oath of Humility";
		this.m.OathBoonText = "Your men gain [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] more experience.";
		this.m.OathBurdenText = "You earn [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] fewer crowns from contracts.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "You gain extra Renown for completing enough contracts (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersContractsComplete");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 7;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 6;
		}
		else
		{
			return 5;
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

	function onUpdateEffect()
	{
		this.World.Assets.m.ContractPaymentMult *= 0.75;
	}

	function onStart()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_humility_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersContractsComplete", 0);
		this.World.Assets.resetToDefaults();
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_humility");
		}

		this.World.Statistics.getFlags().set("OathtakersContractsComplete", 0);
	}

});

