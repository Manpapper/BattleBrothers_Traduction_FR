this.corpses_in_forest_event <- this.inherit("scripts/events/event", {
	m = {
		BeastSlayer = null,
		Killer = null
	},
	function create()
	{
		this.m.ID = "event.corpses_in_forest";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_132.png[/img]{While marching through the forest you come across a pile of burnt corpses clutching themselves in a final fiery embrace. It is a writhing mass of black limbs and the occasional face which gapes up at the sky. The faint smell of burnt pigs is still present, but there are no pigs with it. %randombrother% nods at the sight.%SPEECH_ON%That there is one big pile of awful.%SPEECH_OFF%You nod. Indeed it is.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maybe there\'s something useful in there.",
					function getResult( _event )
					{
						if (_event.m.BeastSlayer != null && this.Math.rand(1, 100) <= 75)
						{
							return "D";
						}
						else if (_event.m.Killer != null && this.Math.rand(1, 100) <= 75)
						{
							return "E";
						}
						else
						{
							return this.Math.rand(1, 100) <= 50 ? "B" : "C";
						}
					}

				},
				{
					Text = "Better not dwell here.",
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
			Text = "[img]gfx/ui/events/event_132.png[/img]{The mercenaries start going through the bodies. Most of the corpses come in bundles of three or four which have to cracked apart like eggs. It takes a boot or steel wedge to get them apart. Chips of charred flesh flutter away as the men work. Burnt children are peeled off like breast plates, their chests caved in and their arms firmly out like spokes. Not much is discovered beneath the bodies. A few bits of gold at most. %randombrother% finds a grisly looking mask of sorts. You\'re not entirely sure what it is, but figure it wouldn\'t hurt to take it along. Maybe some trader will find it interesting.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get back on the road.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/misc/petrified_scream_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_132.png[/img]{%randombrother% crouches beside the ball of charred corpses and shakes his head.%SPEECH_ON%I don\'t rightfully think there\'s anything in there, sir.%SPEECH_OFF%Before you can respond a black hand shoots out and grabs the man by his ankle. The bodies rise and shift, a lone victim pulling himself out of the seared grotesquerie with a cape of charred corpses riding his back like spiderlings. His mouth is firmly agape, the lips burned away and the cheeks hollowed, and his eyes are flat in their sockets. His hand has the grip of a stone gargoyle\'s claw and when the mercenary crawls backward it only pulls the burnt man with him. The whole pile jerks and tumbles with some bodies rolling off the pile with their limbs firmly out like coffee tables and others totters over to stare at the sky and another pitches forward and smashes its head into the ground, pasting it there into a powdery blackmark.\n\n Groaning, the survivor yells for water. You draw your sword and put it through his neck, ending his pain there and then. %randombrother% breaks the fingers off to free his boot from the grisly hand. A few of the sellswords are shaken by the event.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get back on the road.",
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
					if (!bro.getBackground().isOffendedByViolence() || bro.getLevel() >= 7)
					{
						continue;
					}

					bro.worsenMood(0.75, "Shaken by a gruesome scene");

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

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_132.png[/img]{%beastslayer% holds his hand up.%SPEECH_ON%They weren\'t murdered, they were purged.%SPEECH_OFF%He squats beside the rim of the pile and lifts a charred arm and wrenched it free at the elbow. He flips the arm around and gives it a squeeze. Green puss oozes out from where the veins would be, dripping steadily to the ground. The beast slayer takes a vial and collects what he can.%SPEECH_ON%These people were infected with a Webknecht\'s poison. It usually dissolves the organs and kills, but sometimes, rarely, it has other effects. Causes bristles of thick hair to grow out on the arms, long fingernails, the shoulder blades start to ache and protrude from the back. Unsightly. And the poisoned, well, they go insane.%SPEECH_OFF%You ask if all these people were poisoned. The beast slayer shakes his head.%SPEECH_ON%This one I knew from the shoulders, the rest, I dunno. When an illness grips a village, it grips the village whole, and soon chaos and confusion become the contagion and the illness itself is but a forgotten spark drifting in the very bonfire it started.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get back on the road.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.BeastSlayer.getImagePath());
				local item = this.new("scripts/items/accessory/spider_poison_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_132.png[/img]{%killer% the murderer on the run smirks and snorts and he nods and spits and nods again. He points at the pile of bodies.%SPEECH_ON%That\'s a cruelty so fierce I don\'t think its doer survived the doing.%SPEECH_OFF%You ask what he means, but the man holds a finger up and walks about the forest, looking behind tree after tree until he comes to a stop.%SPEECH_ON%Just as I thought.%SPEECH_OFF%You come round to see a man hanging there. His fingertips are black and there\'s ash on his face and a noose about his neck. A note in his hand carries apologies, though it does not describe the nature of his crime or if it were a crime at all. Below his feet is his armor and weapons. He may have been a nobleman. Regardless, you have the body cut down and everything looted.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get back on the road.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Killer.getImagePath());
				local item = this.new("scripts/items/weapons/morning_star");
				item.setCondition(this.Math.rand(5, 30) * 1.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/armor/basic_mail_shirt");
				item.setCondition(this.Math.rand(25, 60) * 1.0);
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		local myTile = this.World.State.getPlayer().getTile();

		foreach( s in this.World.EntityManager.getSettlements() )
		{
			local d = s.getTile().getDistanceTo(myTile);

			if (d <= 6)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_beastslayer = [];
		local candidates_killer = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_beastslayer.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				candidates_killer.push(bro);
			}
		}

		if (candidates_beastslayer.len() != 0)
		{
			this.m.BeastSlayer = candidates_beastslayer[this.Math.rand(0, candidates_beastslayer.len() - 1)];
		}

		if (candidates_killer.len() != 0)
		{
			this.m.Killer = candidates_killer[this.Math.rand(0, candidates_killer.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"beastslayer",
			this.m.BeastSlayer != null ? this.m.BeastSlayer.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.BeastSlayer = null;
		this.m.Killer = null;
	}

});

