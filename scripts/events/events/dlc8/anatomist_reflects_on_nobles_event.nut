this.anatomist_reflects_on_nobles_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_reflects_on_nobles";
		this.m.Title = "During camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_39.png[/img]{%anatomist% the anatomist is sitting by the campfire. He seems deep in thought. Being a bit of an arsehole, you feel this is the perfect time to stop by and start asking him questions, particularly the most annoying inquiry in all of existence “What are you thinking about?” The anatomist pinches his eyes and lets out a long sigh. He says,%SPEECH_ON%I am ruminating on the nature of this world\'s entities, notably the ones furthest above, and furthest below. Understand, scapegrace, that we have met a number of royals in our travels and the impression they\'ve imparted on me is one of dire disappointment. Wild animals operate on an even table such that that which eats, and that which finds itself sniveling for scrap, or being scrap itself, are delineated by talent, pure in its innateness. Is the axiom of being the best allowing one to rise up to the top axiomatic only to the world of animals? I took it as truth that our rulers, and now benefactors, would reflect these realities. Instead I am met, time and time again, by buffoons. Incompetents whose primary talents are in balancing indulgences, too much and the peasants are angered by extravagances, too little and the laity think their rulers improperly wasting their extraordinarily lucky station in life. My evaluation of my fellow man drops with every day. Dare I say, dare I say, scapegrace...scapegrace, are you listening?%SPEECH_OFF%You\'re spinning a stick in the fire when you hear your byname. Glancing over, you tell him that you\'re not a stranger to these thoughts, but they\'re just that: thoughts. Despite the pressures of your surroundings, you still decide what you think about. If it bothers him so much, he should simply set it aside. He has no control over the world, after all, and such thinking will not broker greater change. It is mere whinging. The anatomist stares at you. He nods.%SPEECH_ON%I think it is well enough that I do not dwell on these things, for their errors were not by my hand made, nor by my hand could they ever be unmade.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'s the spirit.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local resolve_boost = this.Math.rand(2, 4);
				_event.m.Anatomist.getBaseProperties().Bravery += resolve_boost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve_boost + "[/color] Resolve"
				});
				_event.m.Anatomist.improveMood(1.0, "Better understands the limits of his volition");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
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

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1500)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

