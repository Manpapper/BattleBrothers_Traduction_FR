this.killer_on_the_run_reminisces_event <- this.inherit("scripts/events/event", {
	m = {
		Killer = null
	},
	function create()
	{
		this.m.ID = "event.killer_on_the_run_reminisces";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Seemingly out of nowhere, which you imagine is just how he prefers to behave, %killer% casually mentions that there\'s a body buried out here. You know he\'s a killer on the run, but you do the honor of inquiring as to how he might know that. He flatly states:%SPEECH_ON%Because I killed them and hid the corpse out this way. You know, it was a good kill. I mean that, because this individual was pained by diseases.%SPEECH_OFF%The very word \'diseases\' elicits a turn of heads from the anatomists, as though they were hawks who\'d just seen a scampering mouse. Soon enough, and much to your chagrin, the medical troupe is digging up a corpse. There\'s much discussion over what blights the body might have carried. It is beyond you, but the group agrees that learning of it will make great advances in whatever it is they\'re studying. After their discussions are over, %killer% sidles up to you with a smirk. He says that he killed that person cause he enjoyed it, and it was nice seeing the body again.%SPEECH_ON%It\'s just a shame those eggheads manhandled it like they did. It deserved more care, more...time.%SPEECH_OFF%You ease away from the man and get this bizarre company of men back on the road.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The lot I cast my dice with...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.anatomist")
					{
						local resolveBoost = 1;
						bro.getBaseProperties().Bravery += resolveBoost;
						bro.getSkills().update();
						this.List.push({
							id = 16,
							icon = "ui/icons/bravery.png",
							text = bro.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Resolve"
						});
					}
				}

				this.Characters.push(_event.m.Killer.getImagePath());
				_event.m.Killer.improveMood(1.0, "Reminisced about an old kill");

				if (_event.m.Killer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Killer.getMoodState()],
						text = _event.m.Killer.getName() + this.Const.MoodStateEvent[_event.m.Killer.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local killerCandidates = [];
		local numAnatomists = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killerCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.anatomist")
			{
				numAnatomists++;
			}
		}

		if (killerCandidates.len() > 0 && numAnatomists > 1)
		{
			this.m.Killer = killerCandidates[this.Math.rand(0, killerCandidates.len() - 1)];
			this.m.Score = killerCandidates.len() * 10;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"killer",
			this.m.Killer.getName()
		]);
	}

	function onClear()
	{
		this.m.Killer = null;
	}

});

