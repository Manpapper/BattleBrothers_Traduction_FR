this.kids_and_dead_merchant_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight = null
	},
	function create()
	{
		this.m.ID = "event.kids_and_dead_merchant";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]You find a kid wearing a rather opulent chain around his neck. It\'s so heavy his head is bent forward, but that minor struggle doesn\'t wipe the mile wide grin off his face. %randombrother% pushes the kid down and takes the necklace.%SPEECH_ON%Where did you get this?%SPEECH_OFF%The kid cries out, trying to grab his treasure back, but he\'s about three feet and a good jump too short.%SPEECH_ON%Hey, that\'s mine! Give it back!%SPEECH_OFF%Another kid comes over flashing a ring so large it\'s pinching two fingers at once. Alright. That\'s enough. The company fans out and eventually find a dead merchant in some tall grass beside a treeline. His face is purpled and jagged with broken bones. It appears he has been stoned to death.\n\n A group of about forty or fifty youngsters appear from the treeline, each juggling a stone in hand. Their leader, a little runt with red hair and sleeves of tattoos, asks what you want. You tell him that you\'ll be taking the merchant\'s goods. The leader laughs.%SPEECH_ON%Oy is that so? I\'ll give ya ten seconds to rethink that choice, oy that I will, mister!%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'re taking the goods.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.HedgeKnight != null)
				{
					this.Options.push({
						Text = "You got something to say, %hedgeknight%?",
						function getResult( _event )
						{
							return "HedgeKnight";
						}

					});
				}

				this.Options.push({
					Text = "Back off, men.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_97.png[/img]Despite the miniature military force arrayed before you, the goods are ordered to be taken. The little tyke in charge of this operation screams a warcry more dying cat than diving hawk.%SPEECH_ON%Take them down! Throw! Throw! Throooowww!%SPEECH_OFF%On his command, the mob of children start hurling stones from the treeline. The sellswords band together, holding shields up in a formation akin to a tortoise, and slowly move forward. It\'s a strange effort, like a shell-game artist sliding his cup over the ball, but the company manages to grab the merchant\'s goods and slide away out of the field, all the while being pelted from every which way. The little leader kid shakes his fist at you. You give him the finger and start back onto the path where you take a good look at the merchant\'s goods. %randombrother% stares at the rewards while rubbing a welt on his forehead.%SPEECH_ON%Goddam, man. I\'ve seen armies not nearly so fierce. I weep for the future men who have to cross swords with those lads and lasses.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Those little bastards really gave it to us.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(50, 200);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] Crowns"
				});
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
								text = bro.getName() + " suffers " + injury.getNameOnly()
							});
						}
						else
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " suffers light wounds"
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "HedgeKnight",
			Text = "[img]gfx/ui/events/event_35.png[/img]%hedgeknight% steps forward and heaves his weapon to the fore. He waves it at all the kids.%SPEECH_ON%Ah, so you want to be little bandits or heroes or some such shit? Well, that\'s good. That\'s fine. But I\'ll be watching to see who throws the first stone. He, or she, who does so will find out what happens when I get angry. And then after the rest of you have watched, I\'ll kill the lot of you. And I\'ll follow your little footprints all the way home, find your kin, and smash their farkin\' heads in.%SPEECH_OFF%The hedge knight pauses to glare about.%SPEECH_ON%So, which of you shall throw the first stone?%SPEECH_OFF%The tyke in charge of this miniature army raises his hand and speaks.%SPEECH_ON%Let the men go. We\'ve better things to do than quarrel with these travelers.%SPEECH_OFF%Hey, that\'s a wise move. With pride-swallowing smarts like that the red-headed bugger might someday lead a company to great fortunes. But this day is yours. You take the merchant\'s goods and make your leave.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Little pricks.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.Math.rand(50, 200);
				this.World.Assets.addMoney(item);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + item + "[/color] Crowns"
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_hedgeknight = [];

		foreach( b in brothers )
		{
			if (b.getBackground().getID() == "background.hedge_knight")
			{
				candidates_hedgeknight.push(b);
			}
		}

		if (candidates_hedgeknight.len() != 0)
		{
			this.m.HedgeKnight = candidates_hedgeknight[this.Math.rand(0, candidates_hedgeknight.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight",
			this.m.HedgeKnight != null ? this.m.HedgeKnight.getNameOnly() : ""
		]);
		_vars.push([
			"hedgeknighfull",
			this.m.HedgeKnight != null ? this.m.HedgeKnight.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.HedgeKnight = null;
	}

});

