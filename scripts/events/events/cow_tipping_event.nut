this.cow_tipping_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Strong = null,
		Cocky = null
	},
	function create()
	{
		this.m.ID = "event.cow_tipping";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_72.png[/img]While on the march, you come across a lone cow standing in a field. Not much to it: it\'s just a cow.\n\n But then %randombrother% sidles up next to you. He\'s gnawing on some broomstraw and twists it around as he talks.%SPEECH_ON%So who do you think can do it?%SPEECH_OFF%You ask \'do what.\' He smiles.%SPEECH_ON%Aw, sorry cap\'. Didn\'t realize you hadn\'t heard. We\'re gonna see if someone can knock that cow over! Say, seeing as how we can only knock it over once, how about you choose which of us has a go?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Pick whoever you think is best.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				});

				if (_event.m.Strong != null)
				{
					this.Options.push({
						Text = "I bet %strong% is strong enough to do it.",
						function getResult( _event )
						{
							return "Strong";
						}

					});
				}

				if (_event.m.Cocky != null)
				{
					this.Options.push({
						Text = "That cocky bastard %cocky% looks itching to have a go.",
						function getResult( _event )
						{
							return "Cocky";
						}

					});
				}

				this.Options.push({
					Text = "Leave that cow alone.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_72.png[/img]You tell the men to sort it out themselves. They quickly choose %cowtipper% who, after some badgering, agrees to give it a go.\n\n The sellsword carefully steps across the field, trying his best to avoid the cow patties. The cow itself nonchalantly looks over. It moos once before returning its short bovine attention to the grass. Snickering, the men shoo %cowtipper% onward, mouthing \'do it!\' and \'what are you waiting for?\' Finally, standing a few feet from the cow, %cowtipper% charges.%SPEECH_ON%Yaaahh!%SPEECH_OFF%He storms into the cow\'s side and he might as well have run into a house: his feet slip out from beneath him and he goes skidding beneath the animal, a glide well-oiled by fresh shit. The company bursts out laughing.%SPEECH_ON%You can\'t tip a cow ya fool! They\'re too goddam heavy!%SPEECH_OFF% %cowtipper% no doubt has a new beef with these jokers, but his \'sacrifice\' was worth the easy entertainment.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What a show!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.worsenMood(0.5, "Humiliated himself in front of the company");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Other.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Entertained by " + _event.m.Other.getName() + "\'s attempt to tip over a cow");

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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_72.png[/img]You tell the men to sort it out themselves. They quickly choose %cowtipper%. The sellsword carefully steps across the field, trying his best to avoid the cow patties. The cow itself nonchalantly looks over and moos once before returning its attention to the grass. Snickering, the men shoo %cowtipper% onward, mouthing \'do it!\' and \'hurry now!\'. Finally, standing a few feet from the cow, %cowtipper% charges forward.%SPEECH_ON%Yaaahh!%SPEECH_OFF%The scream spooks the cow. She dips her withers and kicks, catching %cowtipper% with a bit of hooved heel. He violently spins on his feet and twists right into the grass. The men laugh for a moment, then realize it\'s serious. As the cow moos and trots away, the sellsword is \'rescued.\' Though badly hurt, he\'ll survive this near-bovine homicide.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fun\'s over.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local injury = _event.m.Other.addInjury(this.Const.Injury.Accident3);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Other.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Other.worsenMood(0.5, "Humiliated himself in front of the company");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Strong",
			Text = "[img]gfx/ui/events/event_72.png[/img]You figure the strong and burly %strong% could give the cow a good tipping. Your awkward wording alone has the men laughing, but %strong% respectfully bows.%SPEECH_ON%I am honored, sir.%SPEECH_OFF%He rolls up his sleeves and strolls across the field, striding over cow patties like a merchant stepping over the homeless. The cow looks over, raising a curious eyebrow. %strong% nods.%SPEECH_ON%That\'s right, I\'m coming.%SPEECH_OFF%More phrasing issues abound. Despite the laughter of the company, %strong% charges the cow. At first, he simply presses against its side, muscled and heaving with breath. The men laugh as his efforts get him nowhere, but they quickly quiet down when the cow slides across the mud and grass. With a mighty roar, %strong% surges forward and the cow goes falling sideways with a confused moo.\n\n %otherbrother% stands there, slackjawed.%SPEECH_ON%It was a joke... I didn\'t think it was actually possible...%SPEECH_OFF%The company erupts in cheers for the strong man\'s incredible feat!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien Joué!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Strong.getImagePath());
				_event.m.Strong.getBaseProperties().Stamina += 1;
				_event.m.Strong.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Strong.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Max Fatigue"
				});
				_event.m.Strong.improveMood(0.5, "Has shown off of his physical prowess");

				if (_event.m.Other.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Strong.getMoodState()],
						text = _event.m.Strong.getName() + this.Const.MoodStateEvent[_event.m.Strong.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Strong.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "Witnessed " + _event.m.Strong.getName() + "\'s incredible feat");

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
		this.m.Screens.push({
			ID = "Cocky",
			Text = "[img]gfx/ui/events/event_72.png[/img]Before you can even finish your sentence, %cocky% beats his chest and steps forward.%SPEECH_ON%I will fell that petty cow!%SPEECH_OFF%You remind him that the company has no beef with the bovine creature and that this is all for fun and games. He stands there, arms tent-poled with his fists at his hips.%SPEECH_ON%Nonsense. The company laughs and thinks this an impossibility, but I\'m here to show them all just how wrong they are!%SPEECH_OFF%The cocksure sellsword steps into the field and immediately cuts his boot across a cow patty. He sidewinders forward, arms flailing for balance, but it\'s all for naught as he slams to the ground. The men burst into laughter. The cow glances over before simply walking off. %cocky% cleans himself up.%SPEECH_ON%A minor misstep. But look! The cowardly cattle wants no part of me!%SPEECH_OFF%%otherbrother% laughs and points at the sellsword\'s stained garb.%SPEECH_ON%Maybe, but it looks like you got a little part of her.%SPEECH_OFF%The cocky sellsword quickly swipes the shite off his shirt. Despite the failure, he is undeterred and the men are almost passing out they\'re laughing so hard.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You did well enough.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				_event.m.Cocky.getBaseProperties().Bravery += 1;
				_event.m.Cocky.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/bravery.png",
					text = _event.m.Cocky.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] DÃ©termination"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Cocky.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "Witnessed " + _event.m.Cocky.getName() + "\'s entertaining failure");

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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Plains && currentTile.Type != this.Const.World.TerrainType.Steppe)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidate_strong = [];
		local candidate_cocky = [];
		local candidate_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.strong") || bro.getSkills().hasSkill("trait.tough"))
			{
				candidate_strong.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.cocky"))
			{
				candidate_cocky.push(bro);
			}
			else
			{
				candidate_other.push(bro);
			}
		}

		if (candidate_other.len() == 0)
		{
			return;
		}

		if (candidate_strong.len() != 0)
		{
			this.m.Strong = candidate_strong[this.Math.rand(0, candidate_strong.len() - 1)];
		}

		if (candidate_cocky.len() != 0)
		{
			this.m.Cocky = candidate_cocky[this.Math.rand(0, candidate_cocky.len() - 1)];
		}

		this.m.Other = candidate_other[this.Math.rand(0, candidate_other.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"strong",
			this.m.Strong != null ? this.m.Strong.getNameOnly() : ""
		]);
		_vars.push([
			"strongfull",
			this.m.Strong != null ? this.m.Strong.getName() : ""
		]);
		_vars.push([
			"cocky",
			this.m.Cocky != null ? this.m.Cocky.getNameOnly() : ""
		]);
		_vars.push([
			"cockyfull",
			this.m.Cocky != null ? this.m.Cocky.getName() : ""
		]);
		_vars.push([
			"cowtipper",
			this.m.Other != null ? this.m.Other.getNameOnly() : ""
		]);
		_vars.push([
			"cowtipperfull",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Strong = null;
		this.m.Cocky = null;
		this.m.Other = null;
	}

});

