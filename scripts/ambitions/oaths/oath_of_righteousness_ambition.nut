this.oath_of_righteousness_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_righteousness";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Few aberrations are as repugnant as the undead.\nLet us take an Oath of Righteousness and strike down these mockeries of life!";
		this.m.TooltipText = "\"Beware the evil which has stolen into this realm. Set aside the worldly matters and dedicate oneself to putting our dead to rest once and for all. No man deserves to walk twice across this darkened land.\" - Young Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]When you walk the earth, one can\'t help but wonder who came before, and who or what comes after. So the sight of the dead walking again is such a disturbing answer to this inquiry that most would rather run from it than seek confirmation, and in that confirmation: confrontation. But it is these godless cretins which the %companyname% sought, taking an oath to vanquish them wherever found. It was a righteous affair requiring great mettle and stupendous courage, and upon completion there\'s little doubt that the men of the %companyname% have been spurred with a sense of accomplishment that few who walk this earth, dead or alive, shall ever feel.\n\nWith veins aflame with righteousness, the %companyname% is ready to take on its next Oath!";
		this.m.SuccessButtonText = "{For Young Anselm! | As Oathtakers! | And death to the Oathbringers!}";
		this.m.RewardTooltip = "";
		this.m.OathName = "Oath of Righteousness";
		this.m.OathBoonText = "Your men have [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Resolve and [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Melee and Ranged Skill, and [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Melee and Ranged Defense when fighting the undead.";
		this.m.OathBurdenText = "Your men have [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Resolve and [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Melee and Ranged Skill, and [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Melee and Ranged Defense when fighting any other foe.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "You gain extra Renown for slaying the undead (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersUndeadSlain");
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_righteousness_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersUndeadSlain", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_righteousness");
		}

		this.World.Statistics.getFlags().set("OathtakersUndeadSlain", 0);
	}

});

