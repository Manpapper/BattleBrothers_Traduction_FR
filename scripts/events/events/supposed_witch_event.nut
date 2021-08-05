this.supposed_witch_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null,
		Cultist = null,
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.supposed_witch";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]You cross into a small hamlet beside the path. It\'s a rather nondescript place save for the woman tied atop a soon-to-be bonfire. She\'s surrounded by a band of peasants as is usual for a woman in this position. A monk from the mob reads from a holy tome, apparently letting everyone know the deontological nature of her crimes. Another man dutifully stands by with a torch, his hands itchy to put it to use.\n\n Seeing you, the woman shouts for help.%SPEECH_ON%They\'re going to burn me! You must do something! I\'ve done no wrong here!%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s free her.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 80)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Witchhunter != null)
				{
					this.Options.push({
						Text = "What does a witch hunter say to this, %witchhunterfull%?",
						function getResult( _event )
						{
							return "Witchhunter";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "What do the old gods say, %monkfull%?",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "What does your strange god make of this, %cultistfull%?",
						function getResult( _event )
						{
							return "Cultist";
						}

					});
				}

				this.Options.push({
					Text = "This isn\'t our problem.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_79.png[/img]You will not stand idly by while an innocent woman is burned for some imaginary crime. Blade in hand, you climb the wooden pallets and cut her free. She quickly scurries away, seeking her own safety. The crowd, enraged, sets upon the company in an instant. A scuffle between peasants and sellswords ends poorly for the former, but they do put in some damage.\n\n For losing control of the crowd, you have the monk beaten up, and the man carrying the torch, too. A few of the brothers believe this was the right thing to do and are pleased with your decision.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I hope she finds somewhere safe to be.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							local injury = bro.addInjury(this.Const.Injury.Brawl);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " souffre de " + injury.getNameOnly()
							});
						}
						else
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " souffre de blessures légères"
							});
						}
					}

					if (this.Math.rand(1, 100) <= 25 && bro.getBackground().getID() != "background.witchhunter")
					{
						bro.improveMood(1.0, "You saved a woman from being burned at the stake");

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
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_79.png[/img]You will not stand idly by while an innocent woman is burned for some imaginary crime. Blade in hand, you climb the wooden pallets and cut her free. When she\'s free, she leans down and takes you in her hands. Her skin is smooth and unmarked.%SPEECH_ON%Thank you, sellsword.%SPEECH_OFF%She plants a kiss and it feels as though her lips are ice. You watch as she floats down the wooden pallets. Uh oh.\n\n The town monk retreats, trying to hide himself in the crowd, but the witch screams and splits the mob, leaving only the friar by himself on the ground. He slowly slides across the dirt before rising to his feet as though pushed by an invisible force. He tries to retreat again, but there\'s no going anywhere. She kisses him as she did you, but the man\'s eyes roll back in his head and you see his veins engorge, purpling violently, his whole body issuing blood out of every pore as he shakes. He screams, but it\'s lost in the mouth of the witch who eats it with a moan. When she lets go, he drops to the ground a sopping red corpse.\n\n The villagers scatter while your men try and fight this evil. She laughs and shrinks into the center of her clothes, her cloak rolling itself in a bundle out of which shoots a cackling specter. It\'s soars to the nearest tree line hopefully to never be seen again.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oh shit.",
					function getResult( _event )
					{
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25 || bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.monk" || bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.mad"))
					{
						bro.worsenMood(1.0, "You set free an evil spirit");

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
			ID = "Witchhunter",
			Text = "[img]gfx/ui/events/event_79.png[/img]%witchhunter% steps forward with a skeptical eye. He looks at the woman who strains to say \'please.\' The witch hunter stares her up and down, then he turns and drives a blade through the man holding the torch. He gargles with it in his throat and his hands work to try and pry it out.%SPEECH_ON%Stop with the farce, you will not fool me.%SPEECH_OFF%The witch hunter says. He yanks out the blade and the torch-wielder stands there for a moment, but his wide eyes slowly settle down and the \'blood\' stops in an instant. His face widens, skin stretching taut like the melted visage of a puppeteer\'s most gruesome doll. Its voice is shrieking, every syllable the pitch of a dying cat.%SPEECH_ON%I am NOT the last! You\'ll NEVER be rid of us all!%SPEECH_OFF%And with that, %witchhunter% drives his weapon into the evil spirit\'s skull. The skin hardens like a desert earth before chipping away.\n\n With the truth out there, the woman is cut down and freed. The monk is defrocked by an angry mob with nowhere else to turn their energy. Naked and humiliated, he is driven from the hamlet for his wrongful accusations.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "True evil hides itself well.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local resolve = 1;
				local initiative = 1;
				_event.m.Witchhunter.getBaseProperties().Bravery += resolve;
				_event.m.Witchhunter.getBaseProperties().Initiative += initiative;
				_event.m.Witchhunter.getSkills().update();
				_event.m.Witchhunter.improveMood(2.0, "Killed an evil spirit");

				if (_event.m.Witchhunter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Witchhunter.getMoodState()],
						text = _event.m.Witchhunter.getName() + this.Const.MoodStateEvent[_event.m.Witchhunter.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Witchhunter.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Détermination"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Witchhunter.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] Initiative"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Witchhunter.getID() && (this.Math.rand(1, 100) <= 25 || bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.monk" || bro.getSkills().hasSkill("trait.superstitious")))
					{
						bro.improveMood(1.0, "Saw an evil spirit meet its end");

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
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_79.png[/img]The monk, %monk%, sits with the town\'s own friar and talks for a time. When they are done, a nod is given to the torchman who sets the wooden pallets aflame. The woman screams for mercy, but the flames have none for her, slowly working up feet first. It is a horrific sight and only when the smoke is a choking cloud does the dying woman go silent. The fire consumes her entirely as the rest of the town claps and cheers. %monk% states that she was clearly a witch and had to be done away with. You\'re not sure. All you saw was a woman burned alive, but you trust that he knows more than you about the war between the old gods and the evils of sorcery.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rooting out evil is never easy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local resolve = this.Math.rand(2, 3);
				_event.m.Monk.getBaseProperties().Bravery += resolve;
				_event.m.Monk.getSkills().update();
				_event.m.Monk.improveMood(2.0, "Had a witch burned");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Détermination"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Monk.getID() && (bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.monk" || bro.getSkills().hasSkill("trait.superstitious")))
					{
						bro.improveMood(1.0, "Saw a witch burning at the stake");

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
			ID = "Cultist",
			Text = "[img]gfx/ui/events/event_79.png[/img]%cultist% steps forward and looks the villagers up and down. He shakes his head.%SPEECH_ON%You all should kill yourselves.%SPEECH_OFF%The town monk rustles up his cloak.%SPEECH_ON%E-excuse me?%SPEECH_OFF%The cultist starts to cut the woman down. A few of your mercenaries step forward to stop anyone from protesting. When she\'s free and sent running for her own safety, %cultist% speaks again.%SPEECH_ON%Kill yourselves. Each of you. Tonight. You\'ve angered Davkul and his rage is a debt you\'d do best to pay yourself.%SPEECH_OFF%The monk opens his mouth to say something, but his nose cracks as though indented by an invisible stone. He lurches, blood spewing from his nostrils. %cultist% nods.%SPEECH_ON%Hmm, he is angrier than I had thought. Davkul awaits us all, but he is now on your doorstep.%SPEECH_OFF%Screaming, the monk falls to the ground as his jaw sickeningly cracks open, his mouth left permanently ajar. The villagers scream and disperse like rabbits beneath the shadow of a hawk.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Disturbing.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local resolve = 2;
				_event.m.Cultist.getBaseProperties().Bravery += resolve;
				_event.m.Cultist.getSkills().update();
				_event.m.Cultist.improveMood(2.0, "Witnessed Davkul\'s power");

				if (_event.m.Cultist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Cultist.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Détermination"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Cultist.getID() && (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist"))
					{
						bro.improveMood(1.0, "Witnessed Davkul\'s power");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.monk" || bro.getSkills().hasSkill("trait.superstitious"))
					{
						bro.worsenMood(1.0, _event.m.Cultist.getName() + " freed a witch");

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
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidate_witchhunter = [];
		local candidate_monk = [];
		local candidate_cultist = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				candidate_witchhunter.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				candidate_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidate_cultist.push(bro);
			}
		}

		if (candidate_witchhunter.len() != 0)
		{
			this.m.Witchhunter = candidate_witchhunter[this.Math.rand(0, candidate_witchhunter.len() - 1)];
		}

		if (candidate_monk.len() != 0)
		{
			this.m.Monk = candidate_monk[this.Math.rand(0, candidate_monk.len() - 1)];
		}

		if (candidate_cultist.len() != 0)
		{
			this.m.Cultist = candidate_cultist[this.Math.rand(0, candidate_cultist.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter != null ? this.m.Witchhunter.getNameOnly() : ""
		]);
		_vars.push([
			"witchhunterfull",
			this.m.Witchhunter != null ? this.m.Witchhunter.getName() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"monkfull",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"cultistfull",
			this.m.Cultist != null ? this.m.Cultist.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
		this.m.Monk = null;
		this.m.Cultist = null;
	}

});

