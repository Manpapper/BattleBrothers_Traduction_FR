this.hedgeknight_vs_hedgeknight_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight1 = null,
		HedgeKnight2 = null,
		NonHedgeKnight = null,
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.hedgeknight_vs_hedgeknight";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%nonhedgeknight% sprints into your tent, nearly taking out one of the stakes and bringing the whole thing down. Sweat flies off his face and onto your maps. You look at the man with a stare that demands a good answer for what he\'s doing. He explains that the hedge knights %hedgeknight1% and %hedgeknight2% are getting into it. They\'ve both picked up weapons and look about ready to kill each other. Having the two largest men in the company do battle probably isn\'t best for the health of... well, everyone. You quickly rush to the scene.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Show me to them.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.NonHedgeKnight.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_35.png[/img]You find %hedgeknight1% with a great sword in hand and %hedgeknight2% is twirling a giant axe around like a child would a stick. Most of the men have cleared out. %nonhedgeknight% explains that the two {have unfinished business from a jousting tournament | met before on the battlefield, on opposite sides, and now look to continue a battle long past | seek to end a dispute between them by the old tradition of mortal combat}. Another brother steps forward, begging that the hedge knights put their differences aside, but %hedgeknight2% throws him out of the way. Golems of might and terror that they are, perhaps it is wise to seek an end to this confrontation?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "May the strongest man win.",
					function getResult( _event )
					{
						return _event.m.Monk == null ? "C1" : "C2";
					}

				},
				{
					Text = "Listen to me, save yourselves for the battlefield!",
					function getResult( _event )
					{
						return _event.m.Monk == null ? "C3" : "C4";
					}

				},
				{
					Text = "A thousand crowns to both of you to stop this madness now!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C1",
			Text = "[img]gfx/ui/events/event_35.png[/img]%nonhedgeknight% calls out to you, asking you to stop the fight. The two hedge knights look over, each breath heaving their massive chests. You throw a dismissive hand. The knights nod and charge one another. The clash is loud, metal-shattering, bone-crunching. Growls follow every attempt to kill, so sonorous become the weapon swings. The sword catches the shaft of the giant axe and the two blades snap against one another. The hedge knights exchange cruel stares over the crossing, then quickly disarm and pull daggers, stabbing each other repeatedly as they fall to the ground. Neither man seems the least bit bothered by the wounds. They give up on the pitiful daggers and turn to using their own mitts, punching each other so fiercely you see teeth scattering amongst the bloodsprays.\n\nAgain, the company looks to you for guidance as it is becoming readily obvious that these men seek to fight to a finish.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This is getting out of hand. Everyone, stop them!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Let\'s see who is strongest in battle.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " souffre de blessures légères"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " souffre de blessures légères"
				});
			}

		});
		this.m.Screens.push({
			ID = "C3",
			Text = "[img]gfx/ui/events/event_35.png[/img]The two hedge knights stand there, eyes only on their opponent and with no regard to your words, each breath heaving their massive chests. A short moment and they charge one another. The clash is loud, metal-shattering, bone-crunching. Growls follow every attempt to kill, so sonorous become the weapon swings. The sword catches the shaft of the giant axe and the two blades snap against one another. The hedge knights exchange cruel stares over the crossing, then quickly disarm and pull daggers, stabbing each other repeatedly as they fall to the ground. Neither man seems the least bit bothered by the wounds. They give up on the pitiful daggers and turn to using their own mitts, punching each other so fiercely you see teeth scattering amongst the bloodsprays.\n\nThe company looks to you for guidance as it is becoming readily obvious that these men seek to fight to a finish.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This is getting out of hand. Everyone, stop them!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Let\'s see who is strongest in battle.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " souffre de blessures légères"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " souffre de blessures légères"
				});
			}

		});
		this.m.Screens.push({
			ID = "C2",
			Text = "[img]gfx/ui/events/event_35.png[/img]%nonhedgeknight% calls out to you, asking you to stop the fight. The two hedge knights look over, each breath heaving their massive chests. You throw a dismissive hand. The knights nod and charge one another. The clash is loud, metal-shattering, bone-crunching. Growls follow every attempt to kill, so sonorous become the weapon swings. The sword catches the shaft of the giant axe and the two blades snap against one another. The hedge knights exchange cruel stares over the crossing, then quickly disarm and pull daggers, stabbing each other repeatedly as they fall to the ground. Neither man seems the least bit bothered by the wounds. They give up on the pitiful daggers and turn to using their own mitts, punching each other so fiercely you see teeth scattering amongst the bloodsprays.\n\nAgain, the company looks to you for guidance as it is becoming readily obvious that these men seek to fight to a finish.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This is getting out of hand. Everyone, stop them!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Let\'s see who is strongest in battle.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				},
				{
					Text = "%monk% the monk! Can you find a peaceful resolution?",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " souffre de blessures légères"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " souffre de blessures légères"
				});
			}

		});
		this.m.Screens.push({
			ID = "C4",
			Text = "[img]gfx/ui/events/event_35.png[/img]The two hedge knights stand there, eyes only on their opponent and with no regard to your words, each breath heaving their massive chests. A short moment and they charge one another. The clash is loud, metal-shattering, bone-crunching. Growls follow every attempt to kill, so sonorous become the weapon swings. The sword catches the shaft of the giant axe and the two blades snap against one another. The hedge knights exchange cruel stares over the crossing, then quickly disarm and pull daggers, stabbing each other repeatedly as they fall to the ground. Neither man seems the least bit bothered by the wounds. They give up on the pitiful daggers and turn to using their own mitts, punching each other so fiercely you see teeth scattering amongst the bloodsprays.\n\nThe company looks to you for guidance as it is becoming readily obvious that these men seek to fight to a finish.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This is getting out of hand. Everyone, stop them!",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Let\'s see who is strongest in battle.",
					function getResult( _event )
					{
						return this.Math.rand(1, _event.m.HedgeKnight1.getLevel() + _event.m.HedgeKnight2.getLevel()) <= _event.m.HedgeKnight1.getLevel() ? "F" : "G";
					}

				},
				{
					Text = "%monk% the monk, can you find a peaceful resolution?",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				_event.m.HedgeKnight1.addLightInjury();
				_event.m.HedgeKnight2.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight1.getName() + " souffre de blessures légères"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.HedgeKnight2.getName() + " souffre de blessures légères"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_04.png[/img]You bring out a satchel heavy with coins. The two hedge knights look over, the sound of gold clinking against itself hard to miss.%SPEECH_ON%A thousand crowns to each of you, yeah?%SPEECH_OFF%The men exchange a glance. They shrug. You nod.%SPEECH_ON%Alright, but this isn\'t happening again, understand?%SPEECH_OFF%The men nod too, walking over and accepting the crowns with shameless ease. Some brothers look a little miffed that these men just got free money for essentially choosing not to fight. The hedge knights begrudgingly find peace amongst themselves, being more concerned with counting money than killing each other. You just hope they got an equal amount lest the \'festivities\' resume.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This better last.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				this.World.Assets.addMoney(-2000);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]2000[/color] Couronnes"
					}
				];
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.HedgeKnight1.getID() || bro.getID() == _event.m.HedgeKnight2.getID())
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.greedy"))
					{
						bro.worsenMood(2.0, "Angry about you bribing men to stop their fight");
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(1.0, "Concerned about you bribing men to stop their fight");
					}

					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bro.getMoodState()],
						text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_35.png[/img]Having seen enough, you order the men to intervene. They hesitate, but you quickly remind them of their contractual duties. The men grab great tarps of leather and blankets and some pots and pans and a few carry buckets. Their strategy is sound: buckets are slammed over the heads of the hedge knights, blinding them just long enough to throw everything else over them. As a man would wrestle a bull, the men tangle with the hedge knights, occasionally being thrown into the air, and one brother eats a kick to the face, suffering a black-gapped smile for his troubles. Another is swallowed up in the mass of blankets, being smashed in between the growling hedge knights like an amorphous blob of anger.\n\nEventually, the two men cool down and the battle is over. They begrudgingly make peace, lest you have the rest of your men pick up real weapons to end the scuffle. The rest of the company recovers, picking themselves up as though a great tornado had just torn through the camp. You take account of the injuries and begin distributing aid.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Finally, it\'s over.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.HedgeKnight1.getID() || bro.getID() == _event.m.HedgeKnight2.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 60)
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 75)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " souffre de blessures légères"
						});
					}
					else
					{
						local injury = bro.addInjury(this.Const.Injury.Brawl);
						this.List.push({
							id = 10,
							icon = injury.getIcon(),
							text = bro.getName() + " souffre de " + injury.getNameOnly()
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_35.png[/img]You set yourself down on a stump and watch the rest of the fight. The men roll around on the ground, smashing each other in the face with punches that would kill a horse. Eventually, %hedgeknight1% squats on %hedgeknight2%\'s shoulders. Seeing a rock nearby, %hedgeknight1% grabs it and cracks it over his opponent\'s skull. A bit of flesh is sheared off, revealing a slop of red and white beneath. The rock is brought down again. The brain pan splinters, shards of bone rupturing into fragments. %hedgeknight2% goes a bit limp, showing only a modicum of fight left in him. %hedgeknight1% punches his fist into the brainbox and rips out the namesake in one big gush of crimson. You gag at the sight, and a few men turn and vomit.\n\n%hedgeknight1% gets to his feet and throws his trophy into the tall grass. He wipes his forehead and says only one word.%SPEECH_ON%Finished.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A death in battle for %hedgeknight2%, at least.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				local dead = _event.m.HedgeKnight2;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Killed in a duel by " + _event.m.HedgeKnight1.getName(),
					Expendable = false
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.HedgeKnight2.getName() + " has died"
				});
				_event.m.HedgeKnight2.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.HedgeKnight2.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.HedgeKnight2);
				local injury = _event.m.HedgeKnight1.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.HedgeKnight1.getName() + " souffre de " + injury.getNameOnly()
				});

				if (this.Math.rand(1, 2) == 1)
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight1.getBaseProperties().MeleeSkill += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.HedgeKnight1.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] Maîtrise de Mêlée"
					});
				}
				else
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight1.getBaseProperties().MeleeDefense += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.HedgeKnight1.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] Maîtrise à Distance"
					});
				}

				_event.m.HedgeKnight1.getSkills().update();
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_35.png[/img]You look to set yourself down on a nearby stump but jump back when the two hedge knights come barreling your way. %hedgeknight1%\'s head smashes face first into what was to be your seat. He quickly turns around to face his assailant. All he meets is %hedgeknight2%\'s boot, the interfacing of flesh and leather sounding off with a sickening clap. Now gargling on his own teeth, %hedgeknight1% asks if that\'s the best %hedgeknight2%\'s got. To answer, %hedgeknight2% kicks him in the head again and again, and each rearing of his boot reveals %hedgeknight1% to be in a worse state, from bloodied red to a nightmarish twisting of flesh and eyelids and a flattened nose and a grin of horror where his teeth are either missing or hanging from blood engorged gums like they were nails on a skinless finger.\n\nFinally, the brainpan is crushed, the series of splintering boneplates sounding like something falling through a winter tree\'s branches. You turn your gaze in abhorrence, but some brothers cannot, one spews vomit. Peeking to see what damage was done, you see %hedgeknight2%\'s heel is halfway down a throat and the toe of his boot is churning another man\'s brain. He curses as he struggles to retrieve what delivered the killing blow.\n\nThe surviving hedge knight has to pull on his thigh to help yank his foot out of the brainpan. Turning around, he drags his foot across the grass and picks his heel up like a child coming in after a day\'s play, looking intently to make sure there was no mess to be dragged in after him. He peels off a slug of brain matter and throws it aside like he just shucked some corn. Rubbing his belly, he asks if anyone\'s hungry before grabbing a plate of grits and heading back to his own tent.\n\nLater in the night, after you\'ve put down a short-lived plot to have the man eliminated for the safety of the company, you find %hedgeknight2% sleeping like a baby.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A death in battle for %hedgeknight1%, at least.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight2.getImagePath());
				local dead = _event.m.HedgeKnight1;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Killed in a duel by " + _event.m.HedgeKnight2.getName(),
					Expendable = false
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.HedgeKnight1.getName() + " has died"
				});
				_event.m.HedgeKnight1.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.HedgeKnight1.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.HedgeKnight1);
				local injury = _event.m.HedgeKnight2.addInjury(this.Const.Injury.Brawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.HedgeKnight2.getName() + " souffre de " + injury.getNameOnly()
				});

				if (this.Math.rand(1, 2) == 1)
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight2.getBaseProperties().MeleeSkill += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.HedgeKnight2.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] Maîtrise de Mêlée"
					});
				}
				else
				{
					local v = this.Math.rand(1, 2);
					_event.m.HedgeKnight2.getBaseProperties().MeleeDefense += v;
					this.List.push({
						id = 16,
						icon = "ui/icons/melee_defense.png",
						text = _event.m.HedgeKnight2.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] Maîtrise à Distance"
					});
				}

				_event.m.HedgeKnight2.getSkills().update();
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_05.png[/img]The monk nods, stepping forward and calmly walking between the two men. His hands are raised, the fingers trailing to and fro as they mimic the shapes of old religious rites. He speaks of the gods and how they judge men for what they are and what they do. He says that some gods might find this battle favorable, but that most would not. Most of all, though, the monk says that if they truly wish to fight, then there is plenty of room for that after they die. However, if they kill one another, the loser is given great prestige in the afterlife, and the winner will not, for this violence serves no purpose than to give the victor pride. Surprisingly, this oddity in religious rules calms the men down. The monk invites them to talk more and they do so, the three walking off, hands gesticulating, backs arching in bellowing laughter. As for the rest of the company, they just seem happy nobody got killed.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Thank the gods.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());

				if (!_event.m.Monk.getFlags().has("resolve_via_hedgeknight"))
				{
					_event.m.Monk.getFlags().add("resolve_via_hedgeknight");
					_event.m.Monk.getBaseProperties().Bravery += 2;
					_event.m.Monk.getSkills().update();
					this.List = [
						{
							id = 16,
							icon = "ui/icons/bravery.png",
							text = _event.m.Monk.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Détermination"
						}
					];
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 2000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 4)
		{
			return;
		}

		local candidates = [];
		local candidates_other = [];
		local candidates_monk = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.hedge_knight")
			{
				candidates.push(bro);
			}
			else
			{
				candidates_other.push(bro);

				if (bro.getBackground().getID() == "background.monk")
				{
					candidates_monk.push(bro);
				}
			}
		}

		if (candidates.len() < 2 || candidates_other.len() == 0 && candidates.len() <= 2)
		{
			return;
		}

		local r = this.Math.rand(0, candidates.len() - 1);
		this.m.HedgeKnight1 = candidates[r];
		candidates.remove(r);
		r = this.Math.rand(0, candidates.len() - 1);
		this.m.HedgeKnight2 = candidates[r];
		candidates.remove(r);

		if (candidates_other.len() > 0)
		{
			this.m.NonHedgeKnight = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		}
		else
		{
			this.m.NonHedgeKnight = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		if (candidates_monk.len() != 0)
		{
			this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		}

		this.m.Score = (2 + candidates.len()) * 600;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight1",
			this.m.HedgeKnight1.getName()
		]);
		_vars.push([
			"hedgeknight2",
			this.m.HedgeKnight2.getName()
		]);
		_vars.push([
			"nonhedgeknight",
			this.m.NonHedgeKnight.getName()
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.HedgeKnight1 = null;
		this.m.HedgeKnight2 = null;
		this.m.NonHedgeKnight = null;
		this.m.Monk = null;
	}

});

