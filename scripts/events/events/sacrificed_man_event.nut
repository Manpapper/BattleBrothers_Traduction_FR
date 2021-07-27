this.sacrificed_man_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Other = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.sacrificed_man";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%A strange sight: one dead man pinned to the earth with spears. His own blood has been used to circle his corpse and other strange ritualistic rites have been painted by way of his lifeblood. %otherbrother% starts retrieving the spears. You try and tell him to stop, but it\'s already too late. He holds one of the weapons up.%SPEECH_ON%What? These are of good quality. Why would we leave them here?%SPEECH_OFF%Well, if there was a deific protection here it\'s already been broken. You collect the spears.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rest in peace.",
					function getResult( _event )
					{
						if (_event.m.Cultist != null)
						{
							return "Cultist";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/militia_spear");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/militia_spear");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Cultist",
			Text = "%terrainImage%Before you can leave, %cultist% bends low to the sacrificed man and whispers into his ear. A moment later, the dead man\'s head lurches. His eyes widen and nostrils flare. The cultist looks over to you.%SPEECH_ON%He wasn\'t dead. His blood was used to satiate Davkul. Had we needed his death, we would have burned him.%SPEECH_OFF%He pauses, turning to the man whose wounds are mysteriously healing before your eyes like mud filling in a footprint. %cultist% pets him on the cheek.%SPEECH_ON%Come, friend, and serve Davkul.%SPEECH_OFF%The un-sacrificed man jumps to his feet and instinctively turns toward you. Somehow, he already knows you\'re the captain here and bends a knee.%SPEECH_ON%If you allow it, I will fight for you and, in doing so, spread the faith of Davkul.%SPEECH_OFF%His voice is robotic, as if he\'d spent the last year practicing the oath.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the %companyname% then.",
					function getResult( _event )
					{
						return "Recruit";
					}

				},
				{
					Text = "I really don\'t need more of this. You\'re on your own.",
					function getResult( _event )
					{
						return "Deny";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"cultist_background"
				]);
				_event.m.Dude.setTitle("the Sacrifice");
				_event.m.Dude.getBackground().m.RawDescription = "You found this man as a sacrifice, but he arose from his fate to be a servant of Davkul. He asked to fight for you, and you, for some reason, actually agreed.";
				_event.m.Dude.getBackground().buildDescription(true);

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Recruit",
			Text = "%terrainImage%You decide to take the man in. %otherbrother% stands by the wayside, a couple of spears in hand.%SPEECH_ON%We\'re still taking these, right?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Of course we do.",
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
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Cultist.improveMood(1.0, "You recruited a fellow cultist");

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
			ID = "Deny",
			Text = "%terrainImage%You deny the born-again cultist. He nods.%SPEECH_ON%Of course. I will find other ways to serve Davkul. Farewell, brother.%SPEECH_OFF%He bows to %cultist% before turning and leaving. %otherbrother% stands there with a couple of spears in hand.%SPEECH_ON%We\'re still taking these, right?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Of course we do.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Cultist.worsenMood(1.0, "You failed to recruit a fellow cultist");

				if (_event.m.Cultist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d >= 6 && d <= 12)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_cultist = [];
		local candidates_other = [];

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
			else if (bro.getBackground().getID() != "background.slave")
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		if (candidates_cultist.len() != 0)
		{
			this.m.Cultist = candidates_cultist[this.Math.rand(0, candidates_cultist.len() - 1)];
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = 3;
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
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.Other = null;
		this.m.Dude = null;
	}

});

