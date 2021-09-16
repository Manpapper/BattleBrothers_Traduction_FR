this.youngling_alp_event <- this.inherit("scripts/events/event", {
	m = {
		Callbrother = null,
		Other = null,
		Beastslayer = null,
		Flagellant = null
	},
	function create()
	{
		this.m.ID = "event.youngling_alp";
		this.m.Title = "During camp...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]{%callbrother% runs into your tent and says something is watching the camp. You come outside to see a silhouette in the distance, skulking behind brush and tree limbs. You know its staring when it hisses, for what else would it be looking at to elicit such a charge. Its arms are long and slender and end in claws. You take a torch and sling it toward the beast. Its slick skin winks a vibrant orange and it shrieks away from the cloud of embers and sparks as the torch lands and rolls past. The toothy maw is the last thing you see fading back into the darkness.%SPEECH_ON%I think it\'s an alp, sir. It\'s all by itself as far as we can tell.%SPEECH_OFF%You ask if the sellsword has had visions. He shrugs.%SPEECH_ON%Yeah, some, but I also been drinking so there\'s that.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Kill it.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Ignore it.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Callbrother.getImagePath());

				if (_event.m.Beastslayer != null)
				{
					this.Options.push({
						Text = "%beastslayer%, you\'re an expert on these things. What say you?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Flagellant != null)
				{
					this.Options.push({
						Text = "What is %flagellant% saying about this?",
						function getResult( _event )
						{
							return "E";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_122.png[/img]{The alp is alone and possibly a youngling. Even monsters have to cut their cloth and put in the work to become truly horrible beasts, and this one just doesn\'t seem there yet. You send a pair of sellswords to slay the beast. They close in on it through the shroud of darkness. You see the silhouettes rising up in ambush and there\'s a clatter and a scream, and another scream which is nothing humanlike at all. Shrieking now. And this time a man crying. Someone speaking. Quiet. A long, long quiet. Then the pair comes back. One is clutching his head as though taken by a terrific ache, the other looks at you and nods.%SPEECH_ON%We killed it and, uh, I think we need to lie down.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good work.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Callbrother.getImagePath());
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Callbrother.addXP(200, false);
				_event.m.Other.addXP(200, false);
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Callbrother.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				_event.m.Callbrother.worsenMood(0.75, "Had an alp invade his mind");

				if (_event.m.Callbrother.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Callbrother.getMoodState()],
						text = _event.m.Callbrother.getName() + this.Const.MoodStateEvent[_event.m.Callbrother.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Other.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				_event.m.Other.worsenMood(0.75, "Had an alp invade his mind");

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
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]{You tell the men to ignore the alp. If it were of any danger it would have already proven so. Instead, it has let you know it is there, whether by ignorance or arrogance, neither of which bother you none. A few of the men do not agree with this decision and they stay up all night watching for the beast.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Grow a pair.",
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
					if (bro.getLevel() <= 3 || bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.witchhunter" || bro.getSkills().hasSkill("trait.hate_beasts") || bro.getSkills().hasSkill("trait.fear_beasts") || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.paranoid") || bro.getSkills().hasSkill("trait.superstitious"))
					{
						bro.worsenMood(0.75, "You let some alp live which may haunt the company later");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_122.png[/img]{%beastslayer% the beast slayer comes over.%SPEECH_ON%It ain\'t dangerous, it\'s confused. I\'ll take care of this.%SPEECH_OFF%He\'s chewing on a dried biscuit and grunts and puts the biscuit in his pocket and sets off into the dark all by himself. A moment later, the alp\'s silhouette suddenly falls away and disappears. A few minutes later and the slayer returns, shoving the last morsels of the biscuit into his mouth. You ask why the alp didn\'t put up much of a fight. The beast slayer laughs.%SPEECH_ON%You said %callbrother% fetched you from your tent, right? Right. And where is %callbrother%?%SPEECH_OFF%The beast slayer points toward the campfire. The sellsword is there. Asleep. Deeply asleep. %beastslayer% gets himself another biscuit.%SPEECH_ON%Young alps are still learning how to pry into your mind. They\'re not good at it and often call attention to themselves while trying. They\'re like thieves who can\'t pick a lock, so they knock on the door instead.%SPEECH_OFF%A few of the men listen to this and are emboldened by the apparent flaws of these otherwise horrifying creatures.}  ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nice job.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beastslayer.getImagePath());
				_event.m.Beastslayer.improveMood(0.5, "Dispatched of a youngling alp");
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getLevel() <= 3 && this.Math.rand(1, 100) <= 33 || bro.getBackground().getID() == "background.witchhunter" || bro.getSkills().hasSkill("trait.hate_beasts") || bro.getSkills().hasSkill("trait.fear_beasts") || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.paranoid") || bro.getSkills().hasSkill("trait.superstitious"))
					{
						bro.improveMood(1.0, "Emboldened by learning of the weakness of young alps");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
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
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]{%flagellant% the flagellant is at the rim of the camp whipping himself raw. His soul cleansing tool is rigged with broken glass and cat claws, bound tight with leather rinsed taut in urine, and tassels of twisted horse hair. He walks out into the wilderness, hiding himself with every step.%SPEECH_ON%It\'s not that I fear you, creature in the shadows. It\'s not that I fear you, shadows in my mind. It\'s not that I fear you, mind in my body.%SPEECH_OFF%The man stops walking, but the urgency of his flagellation increases and you can see the flecks of blood winking in the moonlight.%SPEECH_ON%It is that I fear the old gods of which you are not! Of which you are but an insect!%SPEECH_OFF%The alp\'s silhouette shrinks away, shrieks, and then scurries off altogether. The man returns and collapses into the camp. A few of the men are horrified, while others are emboldened by his courage and righteousness.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "By the old gods.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Flagellant.getImagePath());
				local hitpoints = this.Math.rand(1, 3);
				_event.m.Flagellant.getBaseProperties().Hitpoints += hitpoints;
				_event.m.Flagellant.getSkills().update();
				local injury = _event.m.Flagellant.addInjury(this.Const.Injury.Flagellation);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Flagellant.getName() + " suffers " + injury.getNameOnly()
					}
				];
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.Flagellant.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + hitpoints + "[/color] Hitpoints"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days < 20)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];
		local candidates_beastslayer = [];
		local candidates_flagellant = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_beastslayer.push(bro);
			}
			else if (bro.getBackground().getID() == "background.flagellant" || bro.getBackground().getID() == "background.monk_turned_flagellant")
			{
				candidates_flagellant.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		local r = this.Math.rand(0, candidates.len() - 1);
		this.m.Callbrother = candidates[r];
		candidates.remove(r);
		this.m.Other = candidates[this.Math.rand(0, candidates.len() - 1)];

		if (candidates_beastslayer.len() != 0)
		{
			this.m.Beastslayer = candidates_beastslayer[this.Math.rand(0, candidates_beastslayer.len() - 1)];
		}

		if (candidates_flagellant.len() != 0)
		{
			this.m.Flagellant = candidates_flagellant[this.Math.rand(0, candidates_flagellant.len() - 1)];
		}

		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"callbrother",
			this.m.Callbrother.getName()
		]);
		_vars.push([
			"beastslayer",
			this.m.Beastslayer != null ? this.m.Beastslayer.getName() : ""
		]);
		_vars.push([
			"flagellant",
			this.m.Flagellant != null ? this.m.Flagellant.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Callbrother = null;
		this.m.Other = null;
		this.m.Beastslayer = null;
		this.m.Flagellant = null;
	}

});

