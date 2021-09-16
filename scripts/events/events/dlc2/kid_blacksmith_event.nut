this.kid_blacksmith_event <- this.inherit("scripts/events/event", {
	m = {
		Juggler = null,
		Apprentice = null,
		Killer = null,
		Other = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.kid_blacksmith";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{While walking about the shops of %townname%, you feel a tug at your sleeve. You turn to find a child there with a face smeared black with two bright white eyes staring out. He asks if you know anything about swords. You gesture toward the one you got sheathed at your side. He claps his hands.%SPEECH_ON%Great! I work for a blacksmith yonder, but he\'s away fetching iron ingots. He told me to keep watch of this special sword he was making, but it, uh, it fell. And broke. Fell on its own and broke on its own. Will you help me put it back together?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Someone help the kid out.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 70)
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
				if (_event.m.Juggler != null)
				{
					this.Options.push({
						Text = "Looks like %juggler% wants to help you.",
						function getResult( _event )
						{
							return "Juggler";
						}

					});
				}

				if (_event.m.Apprentice != null)
				{
					this.Options.push({
						Text = "Looks like %apprentice% wants to help you.",
						function getResult( _event )
						{
							return "Apprentice";
						}

					});
				}

				if (_event.m.Killer != null)
				{
					this.Options.push({
						Text = "Looks like %killer% wants to help you.",
						function getResult( _event )
						{
							return "Killer";
						}

					});
				}

				this.Options.push({
					Text = "No. Run along, kid.",
					function getResult( _event )
					{
						return "No";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "No",
			Text = "[img]gfx/ui/events/event_97.png[/img]{You tell the kid to piss off. Probably a scheming little pickpocket anyhow. Speaking of which, you check your pockets to ensure everything is still there.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What a relief, nothing seems to be missing.",
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
			ID = "Good",
			Text = "[img]gfx/ui/events/event_97.png[/img]{%other% is fetched to go help the kid. He helps place the sword\'s handle and steel together and the kid works his magic on his own, easily mending the sword back into one piece. You\'re amazed by his skill and wonder how good the blacksmith himself must be if this is his apprentice. After the work is done, the boy offers to fix some of the weapons for the %companyname% which you happily accept.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nice work!",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local stash = this.World.Assets.getStash().getItems();
				local items = 0;

				foreach( item in stash )
				{
					if (item != null && item.isItemType(this.Const.Items.ItemType.Weapon) && item.getCondition() < item.getConditionMax())
					{
						item.setCondition(item.getConditionMax());
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Your " + item.getName() + " is repaired"
						});
						items = ++items;

						if (items > 3)
						{
							break;
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_97.png[/img]{%other% sighs after you ask that he go help the kid with his duties. He lazily steps over to the blacksmith\'s anvil which is shaped like a molar as it rests on thin iron stilts. The blacksmith\'s goods are hanging from ad hoc walls manufactured out of old iron fences, the spokes curved outward to help catch the metalworks. The kid claps his hands.%SPEECH_ON%Now don\'t touch nothing else, just help me with this.%SPEECH_OFF% %other% turns \'round with confusion and mid-sentence knocks the anvil\'s leg out. It starts to crumple sideways and the kid rushes to catch it if only to stem the tide of trouble which has beset his day. The insane weight pastes him flat against the cobblestones, his limbs briefly stretched up like a cricket smooshed beneath a thumb. You see this all from a distance and whistle for the mercenary to head back before there\'s trouble. He makes his escape just as a few passersby start to take notice. He shrugs.%SPEECH_ON%We didn\'t do nothing, right sir?%SPEECH_OFF%You nod.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You should probably stay low for awhile.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.worsenMood(1.5, "Accidentally crippled a little boy");

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
			ID = "Juggler",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Your suspicions about the juggler volunteering to be sent to help are confirmed true as you soon see him throwing daggers and axes into the air and wowing the public at large. Seeing the crowds gather, he places a hat upon the cobblestones and continues the act. They throw plenty of coin in, and the applause is deafening as he plays out his final act of five maces at the same time. Bowing, he picks up the hat and rushes back over.%SPEECH_ON%A fine day\'s work, aye sir?%SPEECH_OFF%Nodding, you ask about the boy\'s broken sword. He clears the sweat from his brow.%SPEECH_ON%What you say, sir? Get back with the company? Aye sir, I\'ll get back with the company now.%SPEECH_OFF%Pursing your lips, you look back toward the smithery to see the boy bent over an anvil and taking a sound leather hiding from the returned blacksmith.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A show\'s a show.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());
				_event.m.Juggler.improveMood(1.0, "Basked in the admiration of a crowd");

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}

				local money = this.Math.rand(10, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "Apprentice",
			Text = "[img]gfx/ui/events/event_97.png[/img]{%apprentice% the young apprentice is tasked with helping the kid. He saunters over to the smithy and starts helping the kid. But he does more than just help: he fashions the sword back together in such a way that is stronger than it was to begin with. The blacksmith returns to find the handiwork and demands to know how to do it, almost begging for insight. %apprentice% laughs.%SPEECH_ON%You give me this sword and I\'ll give you the secret my meister passed down to me.%SPEECH_OFF%You didn\'t even know the apprentice knew how to do any of this, but the lad is nothing if not a sponge in boots. A trade is made with the blacksmith and both parties leave more than happy.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I thought you studied baskets?",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				_event.m.Apprentice.improveMood(1.0, "Brought his blacksmithing skills to bear");

				if (_event.m.Apprentice.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}

				local item = this.new("scripts/items/weapons/arming_sword");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Killer",
			Text = "[img]gfx/ui/events/event_97.png[/img]{You ask %killer% the murderer to help the kid. The man obliges with a smile to which the kid seems intuitively offended by. He takes a few steps back and waves the help away.%SPEECH_ON%No sir, I think I\'m quite alright. Th-thank you. After all, a man\'s gotta do what a man\'s gotta do, right?%SPEECH_OFF%The killer smiles, crouches, and puts a thumb to the kid\'s cheek and leaves it laying there.%SPEECH_ON%That\'s right, boy. That\'s right. A man does what he needs.%SPEECH_OFF%Now you\'re offended and ask %killer% to go count inventory. He rubs the lad\'s hair and then rises and departs. The kid runs off, but quickly returns with a dagger.%SPEECH_ON%H-here, take this. Keep that fella all the hells away from me, please sir. Got it? I want no business with that man and would sooner seek a blacksmith\'s hiding than see him ever again. You take the weapon, you keep him away. Deal? Deal, yeah? Take it!%SPEECH_OFF%You measure that the kid\'s never bargained in his life, that or this is the first time he\'s felt his life on the line. Either way, you accept the dagger. The kid sighs in relief before returning to the smithy, there working away, and there always keeping an eye over his shoulder.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'re a killer with the kid, %killer%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Killer.getImagePath());
				local item = this.new("scripts/items/weapons/rondel_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_other = [];
		local candidates_juggler = [];
		local candidates_apprentice = [];
		local candidates_killer = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.juggler")
			{
				candidates_juggler.push(b);
			}
			else if (b.getBackground().getID() == "background.apprentice")
			{
				candidates_apprentice.push(b);
			}
			else if (b.getBackground().getID() == "background.killer_on_the_run")
			{
				candidates_killer.push(b);
			}
			else
			{
				candidates_other.push(b);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_juggler.len() != 0)
		{
			this.m.Juggler = candidates_juggler[this.Math.rand(0, candidates_juggler.len() - 1)];
		}

		if (candidates_apprentice.len() != 0)
		{
			this.m.Apprentice = candidates_apprentice[this.Math.rand(0, candidates_apprentice.len() - 1)];
		}

		if (candidates_killer.len() != 0)
		{
			this.m.Killer = candidates_killer[this.Math.rand(0, candidates_killer.len() - 1)];
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"other",
			this.m.Other.getName()
		]);
		_vars.push([
			"juggler",
			this.m.Juggler != null ? this.m.Juggler.getName() : ""
		]);
		_vars.push([
			"apprentice",
			this.m.Apprentice != null ? this.m.Apprentice.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Juggler = null;
		this.m.Apprentice = null;
		this.m.Killer = null;
		this.m.Other = null;
		this.m.Town = null;
	}

});

