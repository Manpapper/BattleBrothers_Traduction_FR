this.oathtakers_skull_cracked_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.oathtakers_skull_cracked";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{%oathtaker% bursts into the tent with trembling hands holding Young Anselm\'s skull.%SPEECH_ON%It\'s broken!%SPEECH_OFF%You jump out of your seat and take a look at Young Anselm\'s holy remains. There\'s a sliver of a crack going down the back of the skull. At first it doesn\'t look too bad, but when you stick a pinky finger in and lift, the bone splits apart. You both gasp and set the skull on the table. There\'s no doubt the skull could be broken apart with only a little bit more effort.%SPEECH_ON%What should we do? How do we fix it?%SPEECH_OFF%You ponder the question very carefully. The last time this happened Young Anselm\'s jawbone broke off, and so too did break the Oathtakers - with one group remaining as the Oathtakers, and the other forming the savage blasphemers, the Oathbringers. You\'re not going to let that happen again.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fix it.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Oathtaker.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{You take out a piece of string and coat it in ivy and sap. Then you gently lift Young Anselm\'s crack and run your finger down it with more sap. %oathtaker% stares nervously. Satisfied, you then insert the string along the crack and set the skull\'s parts back down, chomping down on the string and the sticky ivy with it.  You stand back, looking at your work. %oathtaker% swallows.%SPEECH_ON%I...I don\'t think anyone will notice.%SPEECH_OFF%You actually worry that it may be preferable that they find the crack in the skull absent of one\'s attempt to fix it, than to see the handiwork of some skulking skull restorer who tried to sneak one by. Either way, it\'s done, and Young Anselm\'s honor has been restored. %oathtaker% wipes the sweat from his brow.%SPEECH_ON%I believe this to have been a test, captain, and that Young Anselm has seen us through. His strength flows through me, and no words are capable of describing the honor I feel right now.%SPEECH_OFF%What? Young Anselm probably had no idea about sticky saps and ivies, and he presumably knew even less now that he\'s an unspeaking skull. But...you leave %oathtaker% to his interpretations, as shortchanging as they are to yourself.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I should have been an undertaker.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local resolveBoost = this.Math.rand(2, 4);
				_event.m.Oathtaker.getBaseProperties().Bravery += resolveBoost;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Oathtaker.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Resolve"
				});

				if (!_event.m.Oathtaker.getSkills().hasSkill("trait.determined"))
				{
					local trait = this.new("scripts/skills/traits/determined_trait");
					_event.m.Oathtaker.getSkills().add(trait);
					this.List.push({
						id = 10,
						icon = trait.getIcon(),
						text = _event.m.Oathtaker.getName() + " is now Determined"
					});
				}

				_event.m.Oathtaker.improveMood(1.0, "Had his faith in Young Anselm redoubled");

				if (_event.m.Oathtaker.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()],
						text = _event.m.Oathtaker.getName() + this.Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Oathtaker.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{You hush %oathtaker% and tell him to close the tent tarp. Taking the skull, you set it on the table and immediately work to fix it. Unfortunately, the second your hands put in any kind of effort, the crack widens and there\'s even fragments that fly off and scatter to who knows where. You let go of the skull as though it had burned you, Anselm\'s grace clopping hollowly on the table. %oathtaker% looks at you.%SPEECH_ON%What now? What should we do? Maybe we should take the best part and run off and form a new band?%SPEECH_OFF%Scoffing, you ask the fool if he takes you for an Oathtaker or an Oathbringer. He swallows and confirms the former. Damn right, and there\'s only one thing to do if that is the case: claim it is Young Anselm\'s desire to have this here skull crack, and that it is a display of how the %companyname% are not owning up to being true Oathtakers. He agrees, and you do end up showing the rest of the men the skull and its newly acquired bony demarcations.\n\nAt first they are fearful of its crack, but soon agree with you, that Young Anselm\'s influence is waning, not because of the First Oathtaker himself, but because you all, the last of the Oathtakers, are not owning up to your Oaths! And that you all must do better to follow the path of a true Oathtaker! The men roar and cheer, their convictions renewed by Young Anselm\'s crack.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nice save.",
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
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(0.25, "Convinced he hasn\'t upheld the oaths as well as he should");

						if (this.Math.rand(1, 100) <= 33)
						{
							bro.getBaseProperties().Bravery += 1;
							this.List.push({
								id = 16,
								icon = "ui/icons/bravery.png",
								text = _event.m.Oathtaker.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
							});
						}

						if (bro.getSkills().hasSkill("trait.deathwish") && this.Math.rand(1, 100) <= 20)
						{
							local trait = this.new("scripts/skills/traits/deathwish_trait");
							bro.getSkills().add(trait);
							this.List.push({
								id = 10,
								icon = trait.getIcon(),
								text = bro.getName() + " gains Deathwish"
							});
						}
					}

					bro.improveMood(0.75, "Was compelled to redouble his efforts following the oaths");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}

				this.Characters.push(_event.m.Oathtaker.getImagePath());
			}

		});
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

		if (this.World.getTime().Days < 40)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local haveSkull = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				candidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
			{
				haveSkull = true;
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (!haveSkull)
		{
			return;
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
	}

});

