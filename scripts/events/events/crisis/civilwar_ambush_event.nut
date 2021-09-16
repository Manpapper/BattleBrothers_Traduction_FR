this.civilwar_ambush_event <- this.inherit("scripts/events/event", {
	m = {
		NobleHouse = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_ambush";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]Forests hide many things, being the natural resort of predators and men of wilder intents. But you know this well, and you know how to spot shadows most unnatural to this climate. It doesn\'t take you long to realize that there are more than just trees here, and with a quick punch into the thicket of a bush you pull out a young boy with a bow. He cries for help and the reinforcements arrive like songbirds to the prettiest of tunes: a dozen men emerge from the shadows, but the company is prepared, drawing their weapons and coming to stand on equal footing.\n\n An elderly man steps forth, holding his hands up.%SPEECH_ON%Wait, there is no need for violence here.%SPEECH_OFF%He comes to you personally and in a muted, scholarly tone explains what is happening. The small bunch of peasants are preparing to ambush a troop of %noblehouse% soldiers that will be coming this way any moment. He states you\'ll get a piece of the rewards if you help. If not, please get out of the way.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Let\'s help these peasants.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "We have to warn the soldiers.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "We\'ve no time for any of this.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_10.png[/img]They\'re peasants, scroungy and looking like they came here to find leaves to dress themselves. But flimsy bows like theirs come with hardened hands, well versed in getting arrows to targets they got no business finding. These are men of the forests. With confidence that this ambush will go right, you elect to join them.\n\n You don\'t have to wait long for the soldiers of %noblehouse% to start trundling there way over. They\'re loud, obnoxious, and some of them farting and complaining about mushrooms that they mistakenly ate.\n\n A kid about half your size releases the first shot. The arrow streaks between two branches and the lead scout drops to his knees. Leaves ruffle as though a great wind has come - arrows, sight unseen, zip into the soldiers\' column and they\'re so true in aim that their targets die silently. A few of the soldiers manage to close the distance, raising swords and shields, but here the %companyname% steps in and cuts them down. After but a minute, the entire troop has been slain.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "That went well. Let\'s divide the goods.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_87.png[/img]Your men go picking through the corpses, joined by the motley crew of killers. A scuffle breaks out over who should take a shield. You explain that the only reason the shield exists for the taking is because your men stepped forward to kill its owner. The leader of the group nods in agreement. He calls out that your company should take the heavier equipment as your men most certainly have better use for such things.\n\n As you divvy up the goods, one of the bowmen comes forward.%SPEECH_ON%I think one of them got away. There\'s tracks, but he must\'ve been a bit smarter than his dead brothers because he doubled back and covered them quite well.%SPEECH_OFF%Just when you thought you could get away with something...",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Except for the guy who got away, that also went well.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationOffense, "Ambushed some of their men");
				this.World.Assets.addMoralReputation(-1);
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Helped in an ambush against " + _event.m.NobleHouse.getName());
				local item;
				local banner = _event.m.NobleHouse.getBanner();
				local r;
				r = this.Math.rand(1, 4);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/arming_sword");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/morning_star");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/military_pick");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/billhook");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				r = this.Math.rand(1, 4);

				if (r == 1)
				{
					item = this.new("scripts/items/shields/faction_wooden_shield");
					item.setFaction(banner);
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/shields/faction_kite_shield");
					item.setFaction(banner);
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/armor/mail_shirt");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/armor/basic_mail_shirt");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_94.png[/img]You tell the peasants you want no part of their war, but you\'ll stay out of it nonetheless.\n\n As soon as they\'re out of sight and sound, you find the soldiers of %noblehouse% and inform them of the troubles that are soon to come. The lieutenant doesn\'t believe you until you lead him to the peasants and point them out or, rather, their slim shadows sneakily lingering behind this branch or that one.\n\n Going back to the troop, you organize an assault. It\'s pretty simple - you go around the ambush and come up from behind. The old men, desperate men, and naive boys are all slain in turn. They did not see it coming, but in the thick of the chaos some almost certainly escaped and have told of your betrayal. You collect a few goods from the battlefield and a summation of goodwill from the %noblehouse% bannermen.",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "So the locals may hear of this, what does it matter?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = _event.m.NobleHouse.getUIBannerSmall();
				_event.m.NobleHouse.addPlayerRelation(this.Const.World.Assets.RelationFavor, "Saved some of their men");
				_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationOffense, "Killed some of their men");
				local money = this.Math.rand(200, 400);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
				local item;
				local r = this.Math.rand(1, 5);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/pitchfork");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/short_bow");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/hunting_bow");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/militia_spear");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/shields/wooden_shield");
				}

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
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();

		if (playerTile.Type != this.Const.World.TerrainType.Forest && playerTile.Type != this.Const.World.TerrainType.LeaveForest && playerTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local bestDistance = 9000;
		local bestTown;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() >= 3)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d < bestDistance)
			{
				bestDistance = d;
				bestTown = t;
			}
		}

		if (bestTown == null || bestDistance > 10)
		{
			return;
		}

		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local candidates = [];

		foreach( h in nobleHouses )
		{
			if (h.getID() != bestTown.getOwner().getID())
			{
				candidates.push(h);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.NobleHouse = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = bestTown;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.m.NobleHouse.getName()
		]);
		_vars.push([
			"town",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.NobleHouse = null;
		this.m.Town = null;
	}

});

