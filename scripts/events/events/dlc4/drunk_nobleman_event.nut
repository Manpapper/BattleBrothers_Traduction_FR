this.drunk_nobleman_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Servant = null,
		Thief = null,
		Townname = null
	},
	function create()
	{
		this.m.ID = "event.drunk_nobleman";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{While on the march, you find a drunken nobleman tottering side to side on the path. Mussy is the name of his hair, leaves and grass and what looks like birdshit swept up in it like someone stirred the ingredients to a prank. But his clothes sweep about with the finest of silks and his fingers glisten with jewelry. He has a bottle in each hand and he swings them around as he sings gibberish pub songs.\n\nHe is in all regards the greatest magnet for a mugging you\'ve ever seen. %randombrother% purses his lips and he looks like a wolf staring at a fat sheep.%SPEECH_ON%I\'m not saying nothing, sir, I\'m just. I\'m just seeing it. That\'s a lot of juice. A lot of juice limping down the road. But again I ain\'t saying nothing.%SPEECH_OFF%You know what he\'s talking about.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll rob him.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Servant != null)
				{
					this.Options.push({
						Text = "Why is he looking at %servant%?",
						function getResult( _event )
						{
							return "G";
						}

					});
				}

				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "Perhaps %thief% can ease his burden.",
						function getResult( _event )
						{
							return "H";
						}

					});
				}

				this.Options.push({
					Text = "Leave him be.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{You walk up to the man and help him sit down. He grins as one of his bottles clanks off the path and rolls away.%SPEECH_ON%Thankiicup, sir, jast, no, well, ya.%SPEECH_OFF%Nodding, you hold his hand out and spit on his fingers, then roll the jewelry off and pocket them. He merely watches as though you were a physician treating a malady. The rest of your mercenaries strip him down and throw a goatskin tarp over him and then leave him there. As you walk away he asks if you know about the drink.%SPEECH_ON%Not, not sayin\' away the secret, but, sirs, drinks are good.%SPEECH_OFF%Yes, are they ever. Unfortunately, as you rejoin the company %randombrother% reports that a kid saw everything and scampered off. You ask why he didn\'t chase after him. He looks at you shrewdly.%SPEECH_ON%I\'m not the scampering sort, sir.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rest easy, stranger.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local f = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
				f = f[this.Math.rand(0, f.len() - 1)];
				f.addPlayerRelation(-15.0, "Rumored to have robbed a family member on the road");
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Your relation to " + f.getName() + " has suffered"
				});
				local money = this.Math.rand(1, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/valuable_furs_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{You walk up to the man and, startled, he reels back with a hiccup.%SPEECH_ON%Oy, who are ye?%SPEECH_OFF%Telling him you\'re a good friend, you approach to rob him of everything, but as you take another step his eyes clear and he drops both bottles and suddenly reaches into his coat and pulls out a crossbow.%SPEECH_ON%Not another step you lout. I got men yonder who are watching. I don\'t want no trouble. We ain\'t keen on getting squirrely with sellswords. We\'re here to rob travelers, no good travelers at that, choosing to rob a drunk! Now why dontcha just get on down the road and we all leave without impasse upon our purposes.%SPEECH_OFF%The crossbow crickets as its wood shakes in his loose grip.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Deal.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "No deal.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "E" : "F";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%{You nod.%SPEECH_ON%Quite alright. I\'m assuming all that you got is counterfeit, aye?%SPEECH_OFF%The man nods.%SPEECH_ON%Of course. The finest fitting counterfeit this side of %townname% this is! But enough chin wagging shenanigans. Appreciate ya keeping this square, but we got work to do.%SPEECH_OFF%Nodding again, you wish him luck in them doings.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Back to the road.",
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
			ID = "E",
			Text = "%terrainImage%{You look back at the company, then unsheathe your sword as you turn around. You swing it up and clip the crossbow and the man shoots it just over your shoulder. You drive the blade down the slat of wood and cut the cords of the weapon and stab the steel into the man\'s chest. He goes down easy and you hear men shout in the distance, but they\'re scared and scampering away. Thieves like this know not to fight with sellswords. You collect whatever goods the man had already stolen up to this point.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s see what he had.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local money = this.Math.rand(1, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/valuable_furs_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "%terrainImage%{You look back at the company, then unsheathe your sword as you turn around. You swing it up and clip the crossbow and the man shoots it just over your shoulder. You drive the blade down the slat of wood and cut the cords of the weapon and stab the steel into the man\'s chest. He goes down easy and you hear men shout in the distance, but they\'re scared and scampering away. Thieves like this know not to fight with sellswords. Unfortunately, the crossbow bolt that went over your shoulder struck %hurtbro%. He\'ll survive, but it is a garish wound.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s see what he had.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local injury = _event.m.Other.addInjury(this.Const.Injury.PiercingBody);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Other.getName() + " suffers " + injury.getNameOnly()
				});
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/valuable_furs_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "%terrainImage%{As you near the nobleman, his eyes go wide and he points at %servant% the servant.%SPEECH_ON%Jast wait a sssec, I know youuu.%SPEECH_OFF%You look back. He does? The nobleman stumbles forward with his legs scissoring side to side.%SPEECH_ON%You were servant to my cousin in %randomtown% one fine evening. You were great! The greatest. Greeaaatest. S-servant. Hargh. Well -hic- I dare say you can have all this shite cause I don\'t think -hic- we explained yee, sorry, paid ya.%SPEECH_OFF%The man takes anything of value and throws it over. He seems happy just to be relieved of the weight of it all.%SPEECH_ON%If ye see my c-cousin again, let, let him know that I killed his brother, with the, the, mantlepiece. No harsh -hic- feelings.%SPEECH_OFF%Well alright then.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good job doing that thing awhile back.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Servant.getImagePath());
				_event.m.Servant.getBaseProperties().Bravery += 2;
				_event.m.Servant.getSkills().update();
				_event.m.Servant.improveMood(1.0, "Finally got paid for a job while back");
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Servant.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+2[/color] Resolve"
				});
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "%terrainImage%{As you approach the drunkard, a sharp whistle cracks across the path. You and the drunkard both look to see %thief% the thief standing there with a weapon to the back of another man.%SPEECH_ON%That feller\'s no nobleman, and probably aint no drunk neither. They\'re working together to either ambush travelers or threaten them with blackmail. They\'re robbers, sir.%SPEECH_OFF%You look back to see the man smiling nervously. He explains with suddenly sharpened clarity.%SPEECH_ON%We\'d no interest in robbing sellswords, sir, I-I-I swear I was about to explain myself soon as I sawr yer swords.%SPEECH_OFF%%thief% yells out, asking where the cache is. You look back at the man and tell him to hand over everything he\'s stolen. He nods and asks if you\'ll gut him if he refuses. You nod and tell him the gutting will come last, and by that point it\'ll be a relief. The man puts a little pep in his step.%SPEECH_ON%Yessir gotcha sir, right this way.%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ol\' thief sniffed that right out.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
				local money = this.Math.rand(1, 100);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
				});
				local item;
				item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/loot/silverware_item");
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
		if (!this.Const.DLC.Wildmen)
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

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_servant = [];
		local candidates_thief = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.servant" || bro.getBackground().getID() == "background.juggler")
			{
				candidates_servant.push(bro);
			}
			else if (bro.getBackground().getID() == "background.thief")
			{
				candidates_thief.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_servant.len() != 0)
		{
			this.m.Servant = candidates_servant[this.Math.rand(0, candidates_servant.len() - 1)];
		}

		if (candidates_thief.len() != 0)
		{
			this.m.Thief = candidates_thief[this.Math.rand(0, candidates_thief.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearest_town_distance = 999999;
		local nearest_town;

		foreach( t in towns )
		{
			local d = t.getTile().getDistanceTo(playerTile);

			if (d < nearest_town_distance)
			{
				nearest_town_distance = d;
				nearest_town = t;
			}
		}

		this.m.Townname = nearest_town.getName();
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hurtbro",
			this.m.Other.getNameOnly()
		]);
		_vars.push([
			"servant",
			this.m.Servant ? this.m.Servant.getNameOnly() : ""
		]);
		_vars.push([
			"thief",
			this.m.Thief ? this.m.Thief.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Townname
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.Servant = null;
		this.m.Thief = null;
		this.m.Townname;
	}

});

