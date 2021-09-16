this.lose_fear_beasts_event <- this.inherit("scripts/events/event", {
	m = {
		Casualty = null
	},
	function create()
	{
		this.m.ID = "event.lose_fear_beasts";
		this.m.Title = "During camp...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{The company is gathered around the campfire enjoying rest and a meal when %fearful% stands up. Given that everyone else is sitting, he seems to have taken the \'floor\' so to speak and uses his newfound privilege.%SPEECH_ON%If men were to be fearful of beasts, then men would be the beasts! But we\'re the ones with the homes and the fire and the trade and the money! Us! Not them! They sleep where they shit, what are they good for, really?%SPEECH_OFF%Despite the bizarre outburst, a few of the men raise their mugs and give a hearty \'hear hear.\'}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hear, hear!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = _event.m.Casualty.getSkills().getSkillByID("trait.fear_beasts");
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " no longer fears beasts"
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

		if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID())
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

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkill("trait.fear_beasts") || bro.getLifetimeStats().Battles < 25 || bro.getLifetimeStats().Kills < 50 || bro.getLifetimeStats().BattlesWithoutMe != 0)
			{
				continue;
			}

			candidates.push(bro);
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Casualty = candidates[this.Math.rand(0, candidates.len() - 1)];
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
	}

	function onClear()
	{
		this.m.Casualty = null;
	}

});

