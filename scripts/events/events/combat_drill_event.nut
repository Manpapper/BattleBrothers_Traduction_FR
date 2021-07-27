this.combat_drill_event <- this.inherit("scripts/events/event", {
	m = {
		Teacher = null
	},
	function create()
	{
		this.m.ID = "event.combat_drill";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]You step out of your tent to survey the men. A great many of them are freshly hired grunts, nervously buddying up with one another or trying their hand at some of the weapons. %oldguard% comes to your side.%SPEECH_ON%I know what yer thinking. Yer thinking you\'d just hired a bunch of meat for a thresher. How about I whip these boys into shape so they don\'t eat an orcish blade their first go in the field?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Very well, see if you can teach them to fight man against man.",
					function getResult( _event )
					{
						return "B1";
					}

				},
				{
					Text = "Very well, see that they can put bow and arrow to use.",
					function getResult( _event )
					{
						return "C1";
					}

				},
				{
					Text = "Very well, get them in shape to carry real armor.",
					function getResult( _event )
					{
						return "D1";
					}

				},
				{
					Text = "No, they need to keep what little strength they have for battle.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_05.png[/img]%oldguard% tells the recruits to take up weapons. When every single one of them picks up a sword, the old guard yells at them, stating that not every foe hankering for you being graveyard dead is gonna be wielding the exact same blade. A few nod before hurriedly exchanging their swords for axes and spears. With the crew equipped, the training begins. Mostly, %oldguard% teaches basics like how a formation makes it easier to defend not only one another, but also yourself.%SPEECH_ON%Ye need not watch corner-to-corner if ya know a brother is by yer side. But if yer separated, if yer all out there by yer lonesome, then ye might be proper farked lest ye got a heretofore unknown way with a blade which I\'ll go ahead and assume ye don\'t.%SPEECH_OFF%The training moves to offense where %oldguard% shows a few tricks with various weapons.%SPEECH_ON%With swords ye can slash, cut, stab, and riposte. Proper-hard to miss with a sword, given every side of it is a killin\' side. If I see any of you trying to cut down an arrow with a sword like the fairy tales told ya I\'mma beat ya down myself. It ain\'t true, so stop fancying it!\n\nSpears are good for keeping distance. They won\'t do much to armor, but they\'ll keep ya safe. Just point this sharp-end away from ya. If an armored brute gets past this pointy end here then yer probably proper farked so don\'t let that happen.\n\nFinally, there\'s the axe. Just pretend the other man is a tree and cleave it so. Now let\'s practice!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Show me what you can do!",
					function getResult( _event )
					{
						return "B2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				_event.m.Teacher.improveMood(0.5, "Has drilled the new recruits");
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_50.png[/img]The training goes fairly well from there, though the men do come out the other side with a few bumps and bruises.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well done.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getLevel() > 3)
					{
						continue;
					}

					local meleeSkill = this.Math.rand(0, 2);
					local meleeDefense = meleeSkill == 0 ? this.Math.rand(0, 2) : 0;
					bro.getBaseProperties().MeleeSkill += meleeSkill;
					bro.getBaseProperties().MeleeDefense += meleeDefense;
					bro.getSkills().update();

					if (meleeSkill > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/melee_skill.png",
							text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Maîtrise de Mêlée"
						});
					}

					if (meleeDefense > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/melee_defense.png",
							text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeDefense + "[/color] Maîtrise à Distance"
						});
					}

					local injuryChance = 33;

					if (bro.getSkills().hasSkill("trait.clumsy") || bro.getSkills().hasSkill("trait.drunkard"))
					{
						injuryChance = injuryChance * 2.0;
					}

					if (bro.getBackground().isCombatBackground())
					{
						injuryChance = injuryChance * 0.5;
					}

					if (bro.getSkills().hasSkill("trait.dexterous"))
					{
						injuryChance = injuryChance * 0.5;
					}

					if (this.Math.rand(1, 100) <= injuryChance)
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " suffers light wounds"
							});
						}
						else
						{
							local injury = bro.addInjury(this.Const.Injury.Accident1);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " suffers " + injury.getNameOnly()
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C1",
			Text = "[img]gfx/ui/events/event_05.png[/img] %oldguard% musters the men together and begins handing them training bows.%SPEECH_ON%Now these ain\'t made for killing unless ye got an axe to grind with a newborn babe, which I\'m sure of y\'all do, but for now we\'ll just use them to practice.\n\nHere\'s how this contraption works. Oh, ye already know? Yer not a bunch of fools? Well go ahead, then, show me what ye sharpshooters got.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s see if you lot can hit anything.",
					function getResult( _event )
					{
						return "C2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				_event.m.Teacher.improveMood(0.5, "Has drilled the new recruits");
			}

		});
		this.m.Screens.push({
			ID = "C2",
			Text = "[img]gfx/ui/events/event_10.png[/img]The men take practiced shots downrange, the arrows peppering all around their targets, a scant few lucky ones going where they should. %oldguard% spends the rest of the day exhaustingly having the men shoot and shoot and shoot until luck is squeezed out of the equation altogether.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well done.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getLevel() > 3)
					{
						continue;
					}

					local rangedSkill = this.Math.rand(0, 2);
					bro.getBaseProperties().RangedSkill += rangedSkill;
					bro.getSkills().update();

					if (rangedSkill > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/ranged_skill.png",
							text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + rangedSkill + "[/color] de Maîtrise à Distance"
						});
					}

					local exhaustionChance = 33;

					if (bro.getSkills().hasSkill("trait.asthmatic"))
					{
						exhaustionChance = exhaustionChance * 4.0;
					}

					if (bro.getSkills().hasSkill("trait.athletic"))
					{
						exhaustionChance = exhaustionChance * 0.0;
					}

					if (bro.getSkills().hasSkill("trait.iron_lungs"))
					{
						exhaustionChance = exhaustionChance * 0.0;
					}

					if (this.Math.rand(1, 100) <= exhaustionChance)
					{
						local effect = this.new("scripts/skills/effects_world/exhausted_effect");
						bro.getSkills().add(effect);
						this.List.push({
							id = 10,
							icon = effect.getIcon(),
							text = bro.getName() + " is exhausted"
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D1",
			Text = "[img]gfx/ui/events/event_05.png[/img]%oldguard% looses a sharp whistle, gathering the new recruits around him. He looks around, grinning, then nods.%SPEECH_ON%Alright ye limpdick teatsucking noodlearm goatfarkers, we\'re going on a march!%SPEECH_OFF%The veteran spends the rest of the day ruthlessly running the recruits as far as he can until the last one drops from exhaustion.%SPEECH_ON%Breathe, little babe, breathe! Take it all in. There\'s plenty to go around for the rest of us, don\'t feel bad! Swallow it like yer mother should\'ve swallowed you. Now, I\'ve shot stains that ran faster than the lot of ye, so I\'ll be seeing y\'all again tomorrow on good, proper time. That\'d be before the sun rises, shitsticks.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll do that again, tomorrow!",
					function getResult( _event )
					{
						return "D2";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				_event.m.Teacher.improveMood(0.5, "Has drilled the new recruits");
			}

		});
		this.m.Screens.push({
			ID = "D2",
			Text = "%oldguard% shows little mercy and has the men running again and again in the days to come. After all, he says, it\'s for their own damn good.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well done.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Teacher.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getLevel() > 3)
					{
						continue;
					}

					local stamina = this.Math.rand(0, 3);
					local initiative = stamina == 0 ? this.Math.rand(0, 3) : 0;
					bro.getBaseProperties().Stamina += stamina;
					bro.getBaseProperties().Initiative += initiative;
					bro.getSkills().update();

					if (stamina > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/fatigue.png",
							text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] Max Fatigue"
						});
					}

					if (initiative > 0)
					{
						this.List.push({
							id = 16,
							icon = "ui/icons/initiative.png",
							text = bro.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] Initiative"
						});
					}

					local exhaustionChance = 75;

					if (bro.getSkills().hasSkill("trait.asthmatic"))
					{
						exhaustionChance = exhaustionChance * 2.0;
					}

					if (bro.getSkills().hasSkill("trait.athletic"))
					{
						exhaustionChance = exhaustionChance * 0.5;
					}

					if (bro.getSkills().hasSkill("trait.iron_lungs"))
					{
						exhaustionChance = exhaustionChance * 0.5;
					}

					if (this.Math.rand(1, 100) <= exhaustionChance)
					{
						local effect = this.new("scripts/skills/effects_world/exhausted_effect");
						bro.getSkills().add(effect);
						this.List.push({
							id = 10,
							icon = effect.getIcon(),
							text = bro.getName() + " is exhausted"
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local numRecruits = 0;

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().isCombatBackground() && !bro.getBackground().isNoble())
			{
				candidates.push(bro);
			}
			else if (bro.getLevel() <= 3 && !bro.getBackground().isCombatBackground())
			{
				numRecruits = ++numRecruits;
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		if (numRecruits < 3)
		{
			return;
		}

		this.m.Teacher = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10 + numRecruits * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oldguard",
			this.m.Teacher.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Teacher = null;
	}

});

