this.retired_gladiator_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Gladiator = null,
		Name = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.retired_gladiator";
		this.m.Title = "At %townname%...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You come across an old man in the street. He wouldn\'t be particularly remarkable, except for the fact that he is owner of a particularly nice set of equipment. A bit worn and torn, but nice. And, of course, the fact he\'s an elder and hasn\'t had these items stolen from him is evidence of something else going on here.%SPEECH_ON%The Crownling stares, the Crownling wonders.%SPEECH_OFF%The man says as he bites in a loaf of bread. He looks up at you.%SPEECH_ON%My name is %retired%. I once fought in the arenas, but retired five years ago. Not by choice, mind. I was tasked with throwing a match, but instead I cut the opponent\'s head off. Said opponent was the son of a Vizier. This particular detail was not shared with me at the time. Those five years I spoke of? Spent them in a dungeon.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'d have use of you.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Well, good luck to you.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You tell him that you\'d have use for him in the %companyname%. He laughs.%SPEECH_ON%Fighting days are a bit beyond me. I\'m looking to sell this armor at cost and leave this city forever.%SPEECH_OFF%He tilts armor forward.%SPEECH_ON%You won\'t find equipment like this anywhere. All I ask is 1,000 crowns for it, a gladiator\'s harness the likes of which you\'d be hard pressed to find in any ordinary blacksmith\'s shop.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll take the armor for 1,000 crowns.",
					function getResult( _event )
					{
						return "BuyArmor";
					}

				},
				{
					Text = "No, thanks, we\'re good.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Gladiator != null)
				{
					this.Options.push({
						Text = "Perhaps %gladiator% can convince you to join us.",
						function getResult( _event )
						{
							return "Gladiator";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "BuyArmor",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You hand him the gold and he gives you the armor. He weighs the purse of crowns.%SPEECH_ON%I suppose this will be enough to retire away on. The weapons are better left to me. This is not a particularly safe land, after all, and even an old man as dangerous as myself might need protection.%SPEECH_OFF%He\'s right about that. You wish him well and put the armor into inventory.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Safe travels.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local a = this.new("scripts/items/armor/oriental/gladiator_harness");
				local u = this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade");
				a.setUpgrade(u);
				this.List.push({
					id = 12,
					icon = "ui/items/armor_upgrades/upgrade_25.png",
					text = "You gain a " + a.getName()
				});
				this.World.Assets.getStash().add(a);
				this.World.Assets.addMoney(-1000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]1,000[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "Gladiator",
			Text = "[img]gfx/ui/events/event_163.png[/img]{%gladiator% laughs.%SPEECH_ON%Friend, I was once a gladiator. Come with us and treat the whole world as your arena. I know you have that itch. I know it\'s somewhere down in there. Find it. That glee of the kill. That energy from victory. Share it with us, a band of battle brothers.%SPEECH_OFF%The elder gladiator stares at his equipment. His reflection stares back, albeit muddled and warbled from dirt and dents. He nods.%SPEECH_ON%You\'re right. What in the Gilder\'s name am I thinking? I\'ve been piss poor and pissed on and pissed off for far too long. If your company will have me, then I shall end my days going out the way I lived it: killing!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome aboard.",
					function getResult( _event )
					{
						return "Recruit";
					}

				},
				{
					Text = "No, thanks.",
					function getResult( _event )
					{
						return "Deny";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Recruit",
			Text = "[img]gfx/ui/events/event_163.png[/img]{You welcome the man aboard. He gets to his feet.%SPEECH_ON%I\'d like to fight with my own gear, but I\'m not partial to it. After all, I was just trying to sell it, right? Give me what you think is best and point me in the right direction. I\'ll show them what the Wolf of Arena Alley has to show!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wolf of Arena Alley? Ah, alright.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"old_gladiator_background"
				]);
				_event.m.Dude.setTitle("the Wolf");
				_event.m.Dude.getBackground().m.RawDescription = "%name%, also known as Wolf of Arena Alley, is a retired gladiator, but an active sellsword. He\'s been earning crowns by killing for a long time, and it shows both in his experience and his age.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/old_trait");
				_event.m.Dude.getSkills().add(trait);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Deny",
			Text = "[img]gfx/ui/events/event_163.png[/img]{The gladiator sits back down.%SPEECH_ON%Well, what the fuck was all that big bravado speech for?%SPEECH_OFF%%gladiator% apologizes, throwing you a glare between words whlie the rest of the company laughs.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sorry.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "Had a good laugh at a retired gladiator");

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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 1250)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 1)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer() && t.hasBuilding("building.arena"))
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gladiator")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Gladiator = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Name = this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)];
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gladiator",
			this.m.Gladiator != null ? this.m.Gladiator.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"retired",
			this.m.Name
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Dude = null;
		this.m.Gladiator = null;
		this.m.Name = null;
	}

});

