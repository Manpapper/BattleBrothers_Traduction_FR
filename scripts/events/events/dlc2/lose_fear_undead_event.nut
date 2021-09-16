this.lose_fear_undead_event <- this.inherit("scripts/events/event", {
	m = {
		Casualty = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.lose_fear_undead";
		this.m.Title = "During camp...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%fearful% interrupts a company break with a sudden speech.%SPEECH_ON%I\'ve killed and buried so many men, you know? And if they were worth their salt then they wouldn\'t have the opportunity to come back as undead to begin with! And if they come back from ancient times then I\'ll be damned, they\'re persistent! But they ain\'t me. I\'m living. I\'m breathing. And I aim to keep it that way. And when it\'s my time I aim to stay dead, because I\'ve the gumption to know I\'ve troubled this world enough.%SPEECH_OFF%Clapping, %otherbrother% offers a plate of food.%SPEECH_ON%Well alright, now stop troubling us!%SPEECH_OFF%The men laugh and %fearful% joins right in.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This world belongs to the living.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = _event.m.Casualty.getSkills().getSkillByID("trait.fear_undead");
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " no longer fears the undead"
				});
				_event.m.Casualty.getSkills().remove(trait);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID() && this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID())
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > this.World.getTime().SecondsPerDay * 1.0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (!bro.getSkills().hasSkill("trait.fear_undead") || bro.getLifetimeStats().Battles < 25 || bro.getLifetimeStats().Kills < 50 || bro.getLifetimeStats().BattlesWithoutMe != 0)
			{
				candidates_other.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Casualty = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = this.m.Casualty.getLifetimeStats().Kills / 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fearful",
			this.m.Casualty.getName()
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Casualty = null;
		this.m.Other = null;
	}

});

