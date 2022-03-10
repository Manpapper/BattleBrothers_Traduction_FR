this.oath_of_fortification_ambition <- this.inherit("scripts/ambitions/oaths/oath_ambition", {
	m = {},
	function create()
	{
		this.oath_ambition.create();
		this.m.ID = "ambition.oath_of_fortification";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Evil-doers skulk and hide away from the walls of the just.\nLet us take an Oath of Fortification and bring those walls to them!";
		this.m.TooltipText = "\"Trust your shields as you would put faith in the old gods, for the contribution of the trees and the earth shall not be wasted on the nervous hinge of a coward\'s arm.\" - Young Anselm";
		this.m.SuccessText = "[img]gfx/ui/events/event_180.png[/img]{Texts of the Ancient Empire tell of military formations so tightly knit and compact that they were like roving castles on legs: hundreds of shields held together like the scales of a snake or the shell of a tortoise. The %companyname% tried its best to replicate these theories. It always took a few moments to piece the elements together, but you never intended for it to be an exercise in excellence. The ancients had an empire for a reason, and you\'re a company of misfits and Oathtakers. But by your estimation, which mostly starts and ends on whether or not the company still has a pulse, this oath was an outstanding success.\n\nNow it is time to lower the shields and the Ancient Empire-fervor and take on a new Oath!}";
		this.m.SuccessButtonText = "{For Young Anselm! | As Oathtakers! | And death to the Oathbringers!}";
		this.m.OathName = "Oath of Fortification";
		this.m.OathBoonText = "Your men build up [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] less Fatigue when using shield skills. The \'Knock Back\' skill now staggers targets on hit.";
		this.m.OathBurdenText = "Your men cannot move in the first round of combat.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = this.getBonusObjectiveProgress() <= this.getBonusObjectiveGoal() ? this.Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return this.Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "You gain extra Renown if none of your men die during the Oath (" + this.getBonusObjectiveProgress() + " dead so far).";
	}

	function getBonusObjectiveProgress()
	{
		return this.World.Statistics.getFlags().getAsInt("OathtakersBrosDead");
	}

	function getBonusObjectiveGoal()
	{
		return 0;
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
			bro.getSkills().add(this.new("scripts/skills/traits/oath_of_fortification_trait"));
			bro.getSkills().add(this.new("scripts/skills/special/oath_of_fortification_warning"));
		}
	}

	function onReward()
	{
		this.World.Statistics.getFlags().increment("OathsCompleted");
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			bro.getSkills().removeByID("trait.oath_of_fortification");
			bro.getSkills().removeByID("special.oath_of_fortification_warning");
		}
	}

});

