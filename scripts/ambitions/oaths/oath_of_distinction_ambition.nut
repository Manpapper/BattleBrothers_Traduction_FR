this.oath_of_distinction_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_distinction";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Truly distinguished are those who can follow Young Anselm\'s teachings.\nLet us take an Oath of Distinction and prove ourselves worthy to walk in his path!";
		this.m.TooltipText = "Young Anselm frequently pursued solitude, sometimes even on the battlefield. \"Prove yourself worthy in such a manner that not even the old gods may claim their eyes have erred in what glories they have seen.\"";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Many swordmasters practice solitude. The thought is that they are not fighting the men in front of them, they are fighting for the spaces in between. While you cannot possibly understand the small nuances which differentiate a swordmaster from a would be sellsword hacking at air, you realize the kernel of truth in the axiom. Oathtakers, though honorable and diligent, are still at heart brutally courageous and absurdly overconfident. The Oath of Distinction followed the swordmaster\'s art in spirit, and the Oathtaker\'s in mind. Standing out on their own, each man sought to prove himself to his own accord and prove himself worthy of others\' praise. And if any unbiased laity happened to be watching, then it\'d be damn impossible to say the %companyname% did not distinguish itself as a fine outfit.\n\nBut distinction be damned. We can\'t be glory hogging for all our days! Onto the next Oath!}";
		this.m.SuccessButtonText = "{For Young Anselm! | As Oathtakers! | And death to the Oathbringers!}";
		this.m.OathName = "Oath of Distinction";
		this.m.OathBoonText = "Your men gain [color=" + this.Const.UI.Color.PositiveValue + "]40%[/color] more experience. Additionally, they get [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Resolve, [color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] Fatigue Recovery per turn, and deal [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] damage if there are no allies on adjacent tiles.";
		this.m.OathBurdenText = "Your men gain no experience for allied kills.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() >= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "You gain extra Renown if one of your men levels up " + this.getBonusObjectiveGoal() + " times (" + this.getBonusObjectiveProgress() + "/" + this.getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		brothers.sort(function ( _a, _b )
		{
			if (_a.getFlags().getAsInt("OathtakersDistinctionLevelUps") > _b.getFlags().getAsInt("OathtakersDistinctionLevelUps"))
			{
				return -1;
			}
			else if (_a.getFlags().getAsInt("OathtakersDistinctionLevelUps") < _b.getFlags().getAsInt("OathtakersDistinctionLevelUps"))
			{
				return 1;
			}

			return 0;
		});
		return brothers[0].getFlags().getAsInt("OathtakersDistinctionLevelUps");
	}

	function getBonusObjectiveGoal()
	{
		if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
		{
			return 3;
		}
		else if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
		{
			return 2;
		}
		else
		{
			return 2;
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_distinction_trait"));
			bro.getFlags().set("OathtakersDistinctionLevelUps", 0);
		}
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_distinction");
			bro.getFlags().set("OathtakersDistinctionLevelUps", 0);
		}
	}

});

