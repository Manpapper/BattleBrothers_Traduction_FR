this.cultish_arrangement_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null
	},
	function create()
	{
		this.m.ID = "event.cultish_arrangement";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_03.png[/img]{You come over a sand dune to see a half dozen men. They are wearing black cloaks and have their sleeve-sheathed hands holding onto one another to form a complete circle. Despite every one of their heads being down, they all seem to sense your presence and turn to stare. One man lets his hands go and steps forward.%SPEECH_ON%Davkul awaits us all, traveler, even the gilded path permits his patience.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll leave you guys to it.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "Have a word with your brothers in faith, %cultist%.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				this.Options.push({
					Text = "Slaughter these fools!",
					function getResult( _event )
					{
						return "B";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_12.png[/img]{You draw your sword and order the company to make short work of the cultists. They are set upon with ease, the cultists not even so much as raising a hand to resist their own demise. A survivor coughs as he lets an open wound bleed. He holds his hand out as if to show you your handiwork.%SPEECH_ON%With all your hard work you cannot buy time, sellsword. Davkul awaits us all.%SPEECH_OFF%You take your dagger out and end the man. You kick his body over and loot it, as well as the other corpses, though not much is to be found.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get going.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				local money = this.Math.rand(10, 100);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_03.png[/img]{%cultist% steps forward, brandishing his scarred pate for all the strangers to see. They nod and bow, and their leader speaks with his eyes to the sands.%SPEECH_ON%Davkul has spoken.%SPEECH_OFF%Nodding, %cultist% responds.%SPEECH_ON%And to every word I listen.%SPEECH_OFF%The leader retrieves a strange blade seemingly out of nowhere and runs it across his fingers. He speaks again without looking up.%SPEECH_ON%Then do as he requests.%SPEECH_OFF% %cultist% takes the blade and nods.%SPEECH_ON%Davkul awaits us all.%SPEECH_OFF%The strange men collapse to the ground and put their faces into the sand. Their chests rise and fall, tremor, and then they move no more. They have drowned themselves into the desert herself. %cultist% returns carrying a bizarre dagger with him.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Alright...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local item = this.new("scripts/items/weapons/oriental/qatal_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain a " + item.getName()
				});
				_event.m.Cultist.improveMood(1.0, "Had an understanding with his brothers in faith");

				if (_event.m.Cultist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_03.png[/img]{You offer a modest hello and goodbye to the black cloaks, then move on. They do not resist you, nor call out to you in any manner. The last you see of them they are holding hands again and have their heads crooned forward and staring into the sands. There is not a single jug of water or basket of food anywhere to be seen. If they had not come here to die, what could possibly save them?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Not for us to know, maybe.",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.getTime().Days < 10)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 7)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_cultist = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidates_cultist.push(bro);
			}
		}

		if (candidates_cultist.len() != 0)
		{
			this.m.Cultist = candidates_cultist[this.Math.rand(0, candidates_cultist.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
	}

});

