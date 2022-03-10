this.anatomist_dead_knight_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Noble = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_dead_knight";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_75.png[/img]{%anatomist% the anatomist spots something gleaming a little ways off the main path. You walk over and take a look. There\'s something dark and metallic in the distance. Perhaps a knight\'s corpse? Though it would make you wonder how he got there by himself. %anatomist% ponders aloud if perhaps something could be learned from the body of presumably great martial prowess. You shake your head.%SPEECH_ON%Knights rarely die alone, and if they do they sure as shite don\'t keep their armor with them. It smells like a trap through and through.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s go get it.",
					function getResult( _event )
					{
						if (_event.m.Noble != null)
						{
							return "C";
						}
						else if (this.World.FactionManager.isUndeadScourge())
						{
							return "E";
						}
						else if (this.Math.rand(1, 100) <= 30)
						{
							return "D";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "No.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Against your better judgment you go and take a look. You feel quite naked walking across the open ground to the knight, like a thief who steals by reaching all the way across the aisle. When you get to the knight, you pause and look around. No movement in the land around you. No bandits firing off a trap. No wolfpack finding its prey. You shrug and look down. The man is covered in decent armor and carrying a nice, albeit used sword. His face is dried out and the eyes gone. Dry birdshit crusts on the scuff of his chest armor. You order %anatomist% to get him out of the armor and carry it all back the wagon.%SPEECH_ON%What? Why do I have to do it?%SPEECH_OFF%You tell him if he wants to study the body, then the price is he has to strip it down in the first place. Walking off, you tell him that when he puts it in the inventory to make sure to not crush any of the foodstuffs cause that armor does look a bit heavy. Also be sure to clean the bird shit off, too. %anatomist% sighs, but he\'s still happy to have access to the corpse of one \'hero.\' You sometimes wonder what the anatomist would do if he found you dead like this...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Easy enough.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local armor_list = [
					"decayed_coat_of_scales",
					"decayed_reinforced_mail_hauberk"
				];
				local item = this.new("scripts/items/armor/" + armor_list[this.Math.rand(0, armor_list.len() - 1)]);
				item.setCondition(item.getConditionMax() / 2 - 1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/arming_sword");
				item.setCondition(item.getConditionMax() / 2 - 1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Anatomist.improveMood(0.75, "Got to examine the corpse of a heroic knight");

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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_78.png[/img]{You set out to the pile of armor which you hope is not at all the trap it looks like. %anatomist% is practically at your hip, his eyes eating up the prospective \'science\' set before him, and his hands have a tome open and are fervently writing into it already.\n\nSurprisingly, %noble% comes along, the man of noble background seeming to recognize the pile of armor itself. Indeed, as you get close he exclaims that it is a good friend of his from days gone by. You nod solemnly, but still say that the armor would be best used with the company instead of just wasting away here on the ground. The man nods.%SPEECH_ON%I think he would prefer the same. I\'ll get it off him.%SPEECH_OFF%Before he begins, %noble% turns to %anatomist% and tells him that he better not even dare to touch his friend. You go back to the wagon with the anatomist, who you\'ve given the duty of carrying the armor itself. The now sweaty anatomist is upset that he did not get a chance to see the corpse, and %noble% is noticeably upset that the corpse itself was a good friend. All in all, it seems this damn dead man has caused more grief than he was possibly worth.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "At least we got the armor.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Noble.getImagePath());
				local armor_list = [
					"armor/decayed_reinforced_mail_hauberk",
					"helmets/decayed_closed_flat_top_with_mail"
				];
				local item = this.new("scripts/items/" + armor_list[this.Math.rand(0, armor_list.len() - 1)]);
				item.setCondition(item.getConditionMax() / 2 - 1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Anatomist.worsenMood(1.0, "Was denied the opportunity to examine a promising corpse");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Noble.worsenMood(2.0, "Saw the decaying remains of an old friend");

				if (_event.m.Noble.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_21.png[/img]{You decide to go take a look. As you cross the seemingly open plain you get a feeling you\'re being watched. Something about all this just feels wrong. Halfway across, you turn to %anatomist% and tell him that it\'s time to doubleback. He shakes his head and says that you\'ve already come so far, why stop now? Before you can answer, an arrow whistles past your ear and the anatomist falls backward clutching his shoulder.\n\nYou gather the man up and drag him back to the wagon, arrows landing in the ground around you, tufts of dirt thrown over your boots, until they start hitting the wagon itself. Gathering up the company for a counter-attack, you see the would-be ambushers think better of their chances and run off, a few of them carrying the knight\'s armor with them. As you thought, the whole thing was a brigandine honeypot. %anatomist% will live, thankfully, and he\'s already writing in his book about the experience or perhaps, judging by his fascination with the arrow sticking out of him, writing about his grisly wound.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Next time I\'ll listen to my intuition.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local injury = _event.m.Anatomist.addInjury(this.Const.Injury.Accident2);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Anatomist.improveMood(1.0, "Got to study an interesting wound up close");

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
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Against your better judgment you go and take a look. You feel quite naked walking across the open ground to the knight, like a thief who steals by reaching all the way across the aisle. Nearing the corpse, you look back to ask the %anatomist% what his plans are for the dead body. You see the anatomist is standing stiff, his head back and eyes open, a nervous and jittery hand pointing forward. You look back to see the corpse moving, slowly gathering itself off the ground, moaning, croaking. The helm juts forward as filth pours through its openings. You draw your sword.\n\nThe black knight pushes itself up off the ground, its gauntlets falling away to reveal pale flesh beneath. It turns to look at you and there\'s a slight hue of red glowing somewhere in that frothing helm. You slash the sword down and the creature\'s head falls free, clanking against the ground as air sputters out of its neckholes. Sheathing your sword, you tell %anatomist% that if he wants something to study, well, there it is.%SPEECH_ON%Also be sure to carry its armor back to the wagon. Make sure to use your legs when you bend, don\'t want you hurting your back or anything.%SPEECH_OFF%You walk past the anatomist. He stares, gobsmacked, then closes his mouth and pulls out a quill pen and some scrolls. His fear is put behind him, and his usual self comes to the fore.%SPEECH_ON%A fresh specimen, up close, recently deceased, or perhaps it is re-deceased? Either way...we can learn so much from this.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You can also learn to bend with your knees, chop chop.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local armor_list = [
					"armor/decayed_reinforced_mail_hauberk",
					"helmets/decayed_closed_flat_top_with_mail"
				];
				local item = this.new("scripts/items/" + armor_list[this.Math.rand(0, armor_list.len() - 1)]);
				item.setCondition(item.getConditionMax() / 2 - 1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
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

		if (this.World.getTime().Days <= 25)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local noble_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().isNoble())
			{
				noble_candidates.push(bro);
			}
		}

		if (noble_candidates.len() > 0)
		{
			this.m.Noble = noble_candidates[this.Math.rand(0, noble_candidates.len() - 1)];
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"noble",
			this.m.Noble != null ? this.m.Noble.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Noble = null;
	}

});

