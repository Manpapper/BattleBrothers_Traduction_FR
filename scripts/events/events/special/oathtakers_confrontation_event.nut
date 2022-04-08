this.oathtakers_confrontation_event <- this.inherit("scripts/events/event", {
	m = {
		Bro1 = null,
		Bro2 = null,
		Bro3 = null
	},
	function create()
	{
		this.m.ID = "event.oathtakers_confrontation";
		this.m.Title = "Along the way...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				if (this.World.Statistics.getFlags().getAsInt("OathbringerConfrontationTimesDelayed") > 0)
				{
					this.Text = "[img]gfx/ui/events/event_180.png[/img]{The Oathbringers are back. One grins wildly as he steps forward.%SPEECH_ON%Shall we see through Young Anselm\'s visions, or will you drop trou and shit on divine providence once again, Oathtaker?%SPEECH_OFF%You look at your men and decide...}";
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_180.png[/img]{\'We\'ll be seeing you someday,\' they said, spoken softly like old friends, but they meant it, meant it in only the way enemies can. Them. The Oathbringers. Now standing before you in glinting steel, chins up and weapons readied, a salient of hate, manifest from the untimely demise of Young Anselm. You thought you would find them in much larger number, but now only two stand wishing to confront the %companyname%. One steps forward. You see Young Anselm\'s jawbone dangling from his neck. The Oathbringer nods.%SPEECH_ON%I knew it the day we departed that it were only a matter of time until we saw each other again. I can see you have been fighting many a battle, as have we. It is clear that Young Anselm\'s prophecies bore such weight that this world would see us brought together one final time, not robbed of the ceremony on account of some brigand or greenskin. You and I both have been shielded by fate, clothed in the invincibility of one very certain inevitability. Oathtakers. Oathbringers. Let us settle this schism once and for all. As Young Anselm decreed, choose your finest fighters, and we shall see which of us are most deserving of upholding the Oaths!%SPEECH_OFF%}";
				}

				local roster = this.World.getPlayerRoster().getAll();
				roster.sort(function ( _a, _b )
				{
					local score1 = _event.getBroScore(_a);
					local score2 = _event.getBroScore(_b);

					if (score1 > score2)
					{
						return -1;
					}
					else if (score1 < score2)
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "{Represent us in this fight | Be our champion | Reclaim Anselm\'s jawbone | Kill these Oathbringers}, " + bro.getName() + ".",
						function getResult( _event )
						{
							_event.m.Bro1 = bro;
							return "B";
						}

					});
					  // [054]  OP_CLOSE          0      5    0    0
				}

				$[stack offset 0].Options.push({
					Text = "We can\'t win this. No fight.",
					function getResult( _event )
					{
						if (this.World.Statistics.getFlags().getAsInt("OathbringerConfrontationTimesDelayed") > 0)
						{
							return "FightAvoided2";
						}
						else
						{
							return "FightAvoided1";
						}
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro1.getImagePath());

				if (_event.m.Bro2 != null)
				{
					this.Characters.push(_event.m.Bro2.getImagePath());
				}

				this.Text = "[img]gfx/ui/events/event_180.png[/img]The Oathbringers stand before you, waiting for you to pick your champions.\n\n";

				if (_event.m.Bro2 != null)
				{
					this.Text += "You\'ve already chosen " + _event.m.Bro1.getName() + " and " + _event.m.Bro2.getName() + " to fight. Is there another who shall help reclaim Young Anselm\'s jawbone?";
				}
				else
				{
					this.Text += _event.m.Bro1.getName() + " stands ready to fight. Who shall join him?";
				}

				local raw_roster = this.World.getPlayerRoster().getAll();
				local roster = [];

				foreach( bro in raw_roster )
				{
					if (bro.getID() != _event.m.Bro1.getID() && (_event.m.Bro2 == null || bro.getID() != _event.m.Bro2.getID()) && (_event.m.Bro3 == null || bro.getID() != _event.m.Bro3.getID()))
					{
						roster.push(bro);
					}
				}

				roster.sort(function ( _a, _b )
				{
					local score1 = _event.getBroScore(_a);
					local score2 = _event.getBroScore(_b);

					if (score1 > score2)
					{
						return -1;
					}
					else if (score1 < score2)
					{
						return 1;
					}

					return 0;
				});
				local e = this.Math.min(4, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = "{Represent us in this fight | Be our champion | Reclaim Anselm\'s jawbone | Kill these Oathbringers}, " + bro.getName() + ".",
						function getResult( _event )
						{
							if (_event.m.Bro2 == null)
							{
								_event.m.Bro2 = bro;
								return "B";
							}
							else
							{
								_event.m.Bro3 = bro;
								local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
								properties.CombatID = "Event";
								properties.Music = this.Const.Music.NobleTracks;
								properties.IsAutoAssigningBases = false;
								properties.Entities = [];
								properties.Entities.push({
									ID = this.Const.EntityType.Oathbringer,
									Variant = 0,
									Row = 0,
									Script = "scripts/entity/tactical/humans/oathbringer",
									Faction = this.Const.Faction.Enemy
								});
								properties.Entities.push({
									ID = this.Const.EntityType.Oathbringer,
									Variant = 0,
									Row = 0,
									Script = "scripts/entity/tactical/humans/oathbringer",
									Faction = this.Const.Faction.Enemy
								});
								properties.Players.push(_event.m.Bro1);
								properties.Players.push(_event.m.Bro2);
								properties.Players.push(_event.m.Bro3);
								properties.IsUsingSetPlayers = true;
								properties.IsFleeingProhibited = true;
								_event.registerToShowAfterCombat("Victory", "Defeat");
								this.World.State.startScriptedCombat(properties, false, false, true);
								return 0;
							}
						}

					});
					  // [145]  OP_CLOSE          0      6    0    0
				}

				$[stack offset 0].Options.push({
					Text = "I\'ve selected everyone I wish to. Now defeat those Oathbringers!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.NobleTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.Entities.push({
							ID = this.Const.EntityType.Oathbringer,
							Variant = 0,
							Row = 0,
							Script = "scripts/entity/tactical/humans/oathbringer",
							Faction = this.Const.Faction.Enemy
						});
						properties.Entities.push({
							ID = this.Const.EntityType.Oathbringer,
							Variant = 0,
							Row = 0,
							Script = "scripts/entity/tactical/humans/oathbringer",
							Faction = this.Const.Faction.Enemy
						});
						properties.Players.push(_event.m.Bro1);

						if (_event.m.Bro2 != null)
						{
							properties.Players.push(_event.m.Bro2);
						}

						if (_event.m.Bro3 != null)
						{
							properties.Players.push(_event.m.Bro3);
						}

						properties.IsUsingSetPlayers = true;
						properties.IsFleeingProhibited = true;
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Two bodies on the ground, and a weight off your shoulders. But...you thought it would be different. Not that you are displeased with the results, such that the Oathbringers are no more, but there\'s something amiss. It is almost as if you put out a fire that threatened your home, only to realize those flames were the only warmth you had in a world of cold.%SPEECH_ON%Good riddance.%SPEECH_OFF%One of your men says and spits on the corpses. Staring at the dead, you realize you had become addicted to the hunt, addicted to the challenge, addicted to being strong. You weren\'t encumbered by a threat. You were weighted with purpose, and now it is gone. %randombrother% leans down and picks up Young Anselm\'s jawbone and hands it over. You take it and piece it to Young Anselm\'s skull. It fits with ease, almost as if even in its decay it had no reason to separate. The men cheer. They cheer the Oathtakers. They cheer your name. And they cheer for Young Anselm who in death has finally been made whole again. You take one last look at the Oathbringers and nod. They had a purpose, sure, but now it is fulfilled. May the old gods have mercy on their heathen souls.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And death to the Oathbringers...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local found_skull = false;

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 75 || bro.getBackground().getID() == "background.paladin")
					{
						bro.improveMood(2.0, "Reclaimed Young Anselm\'s jawbone");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}

					local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

					if (item != null && item.getID() == "accessory.oathtaker_skull_01")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						found_skull = true;
						bro.getItems().unequip(item);
					}
				}

				if (!found_skull)
				{
					local stash = this.World.Assets.getStash().getItems();

					foreach( i, item in stash )
					{
						if (item != null && item.getID() == "accessory.oathtaker_skull_01")
						{
							this.List.push({
								id = 10,
								icon = "ui/items/" + item.getIcon(),
								text = "You lose " + item.getName()
							});
							stash[i] = null;
							found_skull = true;
							break;
						}
					}
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/accessory/oathtaker_skull_02_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Statistics.getFlags().set("OathbringerConfrontationTriggered", true);
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_87.png[/img]{You stare in disbelief as your chosen fighters go down. A thought crosses your mind to kill the Oathbringers, but rules are rules and you wouldn\'t dare infringe on Young Anselm\'s oath of proper combat. You watch as an Oathbringer takes up Young Anselm\'s jawbone, presses thumb to mandible, and promptly snaps the relic in half.%SPEECH_ON%Despite our victory, even we Oathbringers can see that we\'ve both our errors. So let schism grace schism! Through us we all take on the Oath of Failure, and see unto this world that we find true followers of the Oaths...%SPEECH_OFF%The Oathbringer stares at you through the broken bones, himself shielded by a dead man\'s decree.%SPEECH_ON%When Young Anselm\'s guidance finds fulfillment, only then shall he be made whole again.%SPEECH_OFF%The Oathbringer turns and leaves. Your heart races with ideas of stabbing him in the back, cobbling Anselm\'s remains back together, and completing your ultimate task. But the notion passes. To do such a thing would curse you forever with having ruined your firmest beliefs. You simply watch the Oathbringer go, knowing that the Oaths and all its believers may one day come back together, but it will not be in your lifetime.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damnit!",
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
					if (this.Math.rand(1, 100) <= 75 || bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(1.5, "The company lost to Oathbringers");

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

				this.World.Statistics.getFlags().set("OathbringerConfrontationTriggered", true);
			}

		});
		this.m.Screens.push({
			ID = "FightAvoided1",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Against every fiber of your being, you turn the fight down. The reality is simple: the %companyname% is not ready for this battle. Unsurprisingly, the Oathtakers are not especially happy about this, and in fact show considerable concern that you would take a rare opportunity at slaying Oathbringers and piss all over it. As for the Oathbringers themselves, they laugh and crow at you as you leave.%SPEECH_ON%Young Anselm saw nothing good in you, Oathtakers! Your visions of him are a lie! Your whole existence is a lie! I\'d say join us while you can, but we want nothing to do with you worms!%SPEECH_OFF%You pray that in the coming days you will be able to prove to your men that you made the right decision here.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It had to be this way.",
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
					if (this.Math.rand(1, 100) <= 25 || bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(2.0, "You refused to fight Oathbringers, given the chance");

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

				this.World.Statistics.getFlags().increment("OathbringerConfrontationTimesDelayed");
			}

		});
		this.m.Screens.push({
			ID = "FightAvoided2",
			Text = "[img]gfx/ui/events/event_180.png[/img]{The company is still not ready. You are worried that they will leave you entirely, infuriated as they are, but you\'d rather they be pissed than flat dead in the ground. With the decision weighing on your heart, and the Oathbringers screaming insults into your ear, you have the company once again march from the fight.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'re still not ready!",
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
					if (this.Math.rand(1, 100) <= 50 || bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(2.5, "You refused to fight Oathbringers, given multiple chances");

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

				this.World.Statistics.getFlags().increment("OathbringerConfrontationTimesDelayed");
			}

		});
	}

	function getBroScore( bro )
	{
		local bro_score = 0;

		if (bro.getBackground().getID() == "background.paladin")
		{
			bro_score = bro_score + 2;
		}

		if (bro.getLevel() >= 11)
		{
			bro_score = bro_score + 5;
		}
		else if (bro.getLevel() >= 7)
		{
			bro_score = bro_score + 2;
		}
		else if (bro.getLevel() >= 5)
		{
			bro_score = bro_score + 1;
		}
		else
		{
			bro_score = bro_score - 3;
		}

		if (bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
		{
			bro_score = bro_score - 2;
		}

		if (bro.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
		{
			bro_score = bro_score - 5;
		}

		if (bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body) == null)
		{
			bro_score = bro_score - 5;
		}
		else
		{
			bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getCondition() < bro.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getConditionMax() / 2;
		}

		bro_score = bro_score - 2;
		return bro_score;
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

		if (this.World.Statistics.getFlags().get("OathbringerConfrontationTriggered"))
		{
			return;
		}

		if (this.World.Ambitions.hasActiveAmbition() && (this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_camaraderie" || this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_dominion" || this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_righteousness" || this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_vengeance"))
		{
			return;
		}

		local oathTimer = 6 + this.World.Statistics.getFlags().getAsInt("OathbringerConfrontationTimesDelayed") * 2;

		if (this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Normal)
		{
			oathTimer = oathTimer + 1;
		}
		else if (this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Easy)
		{
			oathTimer = oathTimer + 3;
		}

		if (oathTimer > this.World.Statistics.getFlags().getAsInt("OathsCompleted"))
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		this.m.Score = 1000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Bro1 = null;
		this.m.Bro2 = null;
		this.m.Bro3 = null;
	}

});

