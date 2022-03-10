this.oath_of_vengeance_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_vengeance";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "For too long have greenskins plagued our lands.\nLet us take an Oath of Vengeance and strike back at this menace!";
		this.m.TooltipText = "Young Anselm\'s family was killed by orcs during the Battle of Many Names. When he himself faced greenskins, it is said he seemed an unstoppable warrior and his followers seek to emulate this vengeful surge of martial prowess.";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]Greenskins have long plagued the land of man. Despite their everlasting threat, very few would ever take up an oath to destroy the creatures. They are a plague precisely because they are so dangerous, and because they are so dangerous most would rather look the other way than dare confront the beasts. However, the men of the %companyname% decided to take an oath against the orcs and goblins alike, and venture far to find them and hunt them down. Having followed through, a sense of accomplishment washes over the company.\n\nThe men are already chomping at the bit: which Oath should be undertaken next?";
		this.m.SuccessButtonText = "{For Young Anselm! | As Oathtakers! | And death to the Oathbringers!}";
		this.m.RewardTooltip = "";
		this.m.OathName = "Oath of Vengeance";
		this.m.OathBoonText = "Your men have [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] Resolve, [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Melee and Ranged Skill, and [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Melee and Ranged Defense when fighting orcs or goblins.";
		this.m.OathBurdenText = "Your men have [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] Resolve, [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Melee and Ranged Skill, and [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] Melee and Ranged Defense when fighting any other foe.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "You gain extra Renown for slaying greenskins (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersGreenskinsSlain");
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_vengeance_trait"));
		}

		this.World.Statistics.getFlags().set("OathtakersGreenskinsSlain", 0);
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_vengeance");
		}

		this.World.Statistics.getFlags().set("OathtakersGreenskinsSlain", 0);
	}

});

