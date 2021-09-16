this.hedge_knight_vs_refugee_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight = null,
		Refugee = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.hedge_knight_vs_refugee";
		this.m.Title = "During camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img]%hedgeknight% the hedge knight walks up to an eating %refugee%. The former refugee sees the shadow loom over him and slowly turns about.%SPEECH_ON%Yeah?%SPEECH_OFF%The hedge knight snorts and spits a loogie about the size of a baby\'s arm. He snorts again.%SPEECH_ON%You ran from your home. You watched it burn and put yer back to the flames rather than fight them. This company is your home now. What stops you from running from the fire now?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Come on, %hedgeknight%. Stop it!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "You can deal with this yourselves.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.Refugee.getImagePath());

				if (_event.m.OtherGuy != null)
				{
					this.Options.push({
						Text = "Wait. %streetrat%, you look like you have something to say?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_52.png[/img]You step forward and tell the hedge knight to stuff it. The company ain\'t here to stroke his ego. Laughing, the bear of a man steps off.%SPEECH_ON%As you say, sir. Wouldn\'t want to get into a scrap with the company princess.%SPEECH_OFF%The company laughs, but the refugee only stares into is bowl of food like someone\'d just spat in it.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, I guess that\'s settled.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.Refugee.getImagePath());
				local bravery = this.Math.rand(1, 3);
				_event.m.Refugee.getBaseProperties().Bravery -= bravery;
				_event.m.Refugee.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Refugee.getName() + " loses [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + bravery + "[/color] Resolve"
				});
				_event.m.Refugee.worsenMood(1.0, "Got humiliated in front of the company");

				if (_event.m.Refugee.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Refugee.getMoodState()],
						text = _event.m.Refugee.getName() + this.Const.MoodStateEvent[_event.m.Refugee.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]You don\'t intervene. The hedge knight continues.%SPEECH_ON%I\'ve no pity for your pain. You understand?%SPEECH_OFF%Nodding, the refugee looks up.%SPEECH_ON%Aye, but what pity does anyone have for yours?%SPEECH_OFF%%refugee%\'s arm shoots forward so fast it flips the plate into the campfire. The fork sticks in the thigh of %hedgeknight% and %refugee% can\'t wrench it out no better than if it were stuck in a trunk of oak. The hedge knight grits and falls on the refugee and flattens him. His giant hands press the refugee\'s skull into the earth until the poor man\'s breathing dirt. The rest of the company stands up and backs off. You step forward, but %hedgeknight% holds his hand out before standing back up.%SPEECH_ON%Alright, little runner, alright. You\'ve fight in you yet.%SPEECH_OFF%He retrieves the fork and holds it out. A drop of blood grooves between he tines.%SPEECH_ON%Whatcha eating? Oh yeah? Good. I\'ll double it with my portion. Come and sit.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Glad that\'s settled.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.Refugee.getImagePath());
				local bravery = this.Math.rand(1, 3);
				_event.m.Refugee.getBaseProperties().Bravery += bravery;
				_event.m.Refugee.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Refugee.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + bravery + "[/color] Resolve"
				});
				_event.m.Refugee.improveMood(1.0, "Got some recognition from " + _event.m.HedgeKnight.getName());

				if (_event.m.Refugee.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Refugee.getMoodState()],
						text = _event.m.Refugee.getName() + this.Const.MoodStateEvent[_event.m.Refugee.getMoodState()]
					});
				}

				_event.m.HedgeKnight.improveMood(0.5, "Grew to like " + _event.m.Refugee.getName() + " some");

				if (_event.m.HedgeKnight.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.HedgeKnight.getMoodState()],
						text = _event.m.HedgeKnight.getName() + this.Const.MoodStateEvent[_event.m.HedgeKnight.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_80.png[/img]%streetrat% steps forward. He points a finger at the hedge knight.%SPEECH_ON%You ain\'t got a lick of understanding of no flame nor fire.%SPEECH_OFF%Laughing, %hedgeknight% turns around and cracks his knuckles.%SPEECH_ON%Course I do. I AM the fire.%SPEECH_OFF%The lowborn defiantly crosses his arms.%SPEECH_ON%And we ain\'t the ash, but the wood itself. You\'re a whore for the noblemen, that\'s what you truly are. They pay you a high price and you go on with your strength and cruelty and do what they tell you to do. Like... like a whore...%SPEECH_OFF%Another sellsword holds up a finger.%SPEECH_ON%I think yer describing us in general. We\'re mercenaries.%SPEECH_OFF%And another adds.%SPEECH_ON%Did you just compare yerself to kindling?%SPEECH_OFF%%streetrat% rubs the back of his head.%SPEECH_ON%Yeah I\'m gonna be honest the hedge knight scared me a bit there and I lost what I was going to say.%SPEECH_OFF%The company looks around before bursting into laughter and whatever animosity there was is gone.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What were were fighting about again?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.OtherGuy.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.OtherGuy.getID() || bro.getID() == _event.m.HedgeKnight.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local hedge_knight_candidates = [];
		local refugee_candidates = [];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.hedge_knight")
			{
				hedge_knight_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.refugee")
			{
				refugee_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.beggar" || bro.getBackground().getID() == "background.cripple" || bro.getBackground().getID() == "background.servant" || bro.getBackground().getID() == "background.ratcatcher")
			{
				other_candidates.push(bro);
			}
		}

		if (hedge_knight_candidates.len() == 0 || refugee_candidates.len() == 0)
		{
			return;
		}

		this.m.HedgeKnight = hedge_knight_candidates[this.Math.rand(0, hedge_knight_candidates.len() - 1)];
		this.m.Refugee = refugee_candidates[this.Math.rand(0, refugee_candidates.len() - 1)];
		this.m.Score = (hedge_knight_candidates.len() + refugee_candidates.len()) * 5;

		if (other_candidates.len() != 0)
		{
			this.m.OtherGuy = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight",
			this.m.HedgeKnight.getNameOnly()
		]);
		_vars.push([
			"refugee",
			this.m.Refugee.getName()
		]);
		_vars.push([
			"streetrat",
			this.m.OtherGuy != null ? this.m.OtherGuy.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.HedgeKnight = null;
		this.m.Refugee = null;
		this.m.OtherGuy = null;
	}

});

