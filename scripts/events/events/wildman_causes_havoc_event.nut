this.wildman_causes_havoc_event <- this.inherit("scripts/events/event", {
	m = {
		Wildman = null,
		Town = null,
		Compensation = 600
	},
	function create()
	{
		this.m.ID = "event.wildman_causes_havoc";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%Civilization is no place for a wildman like %wildman% and he quickly proves it.\n\nApparently, the damned man went crazy while in a shop and trashed the whole place. As the story goes, he just walked in and started taking things, not quite understanding the social norms of paying for goods. The shop owner then came after him with a broom, trying to shoo the man out of his store. Believing the broom a monster, the wildman proceeded to go completely crazy. Judging by the reports, it was quite the commotion, up to and including shite throwing.\n\nNow the shop owner is in your face demanding compensation for the damage done. Apparently he\'s wanting %compensation% crowns. Behind him, a few town militia stand with very watchful eyes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This ain\'t our problem.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Fine, the company will cover the damages.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Fine, the company will cover the damages - but %wildman% will work it off.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%townImage%You push the shop owner away, telling him that you owe nothing. When he jumps forward again, your hand deftly moves to the pommel of your sword, stopping the man in one swift motion. He raises his hands up, nodding as he backs off. A few townspeople see this and skirt by, trying to avoid your gaze. The militiamen notice, but they seem uncertain on whether to take action or not.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To hell with your shop.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "E" : 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "You refused to pay for damages caused by one of your men");
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_01.png[/img]You go and see the shop. The wildman truly did a number on the place. And it reeks of his... scent. It would be a bad look for the company to not handle this issue with great care. You agree to pay for the damages, something most mercenary bands would not have done. This act of kindness does not slip the townspeople by.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Charity through destruction?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				this.World.Assets.addMoney(-_event.m.Compensation);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Compensation + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%townImage%Surveying the damage, you agree to compensate the businessman. But this isn\'t your fault, it\'s the wildman\'s. You dock his pay: for some time to come, the mercenary\'s earnings will be halved. Furthermore, you take what earnings he\'s made and hand them over to the shop owner. It doesn\'t even begin to cover the damages, but it\'s a start. One man is left happy, and another quite disgruntled.\n\nYou tell the wild cretin that now he\'ll think twice about smearing shit all over someone else\'s walls. But the wildman doesn\'t seem to understand you. He just understands that the gold he once owned has been given to someone else, and he eyes its departure with sadness and bottled anger.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Don\'t look at me like that, you know what you did.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-_event.m.Compensation);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Compensation + "[/color] Crowns"
				});
				this.Characters.push(_event.m.Wildman.getImagePath());
				_event.m.Wildman.getBaseProperties().DailyWage -= this.Math.floor(_event.m.Wildman.getDailyCost() / 4);
				_event.m.Wildman.getSkills().update();
				this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "One of your men caused havoc in town");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Wildman.getName() + " is now paid [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Wildman.getDailyCost() + "[/color] crowns a day"
				});
				_event.m.Wildman.worsenMood(2.0, "Got a pay cut");

				if (_event.m.Wildman.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Wildman.getMoodState()],
						text = _event.m.Wildman.getName() + this.Const.MoodStateEvent[_event.m.Wildman.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_141.png[/img]While leaving town, you hear a bark over your shoulder. But it is from no dog: you turn \'round to find a number of militiamen converging on the road, fanning out from homes and shops. They say you did that businessman wrong and they won\'t be having your kind in a place like this no more. You can either pay up right now, or they\'ll take it from you by force.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A shame it had to come to this.",
					function getResult( _event )
					{
						this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationBetrayal, "You killed some of the militia");
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Militia, this.Math.rand(90, 130), this.Const.Faction.Enemy);
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				},
				{
					Text = "Fine. I did not wake up this morning looking to slaughter innocents.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_141.png[/img]The men before you are weak and frail, a force cobbled together out of the meek and downtrodden. Nowhere in their ranks is the actual businessman you had trouble with. While you admire their tenacity, you can\'t quite bring yourself to slaughter half a town over a rather small affair. You reach to your side, drawing a few gasps from the poorly armed crowd of men, only to return your hand with a purse in its palm. A deal is struck and the compensation is paid. The townspeople are relieved, though a few of the men are not so happy about backing down from a fight.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It\'s better this way.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				this.World.Assets.addMoney(-_event.m.Compensation);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Compensation + "[/color] Crowns"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isCombatBackground() && this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(1.0, "The company backed down from a fight");
					}

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
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getMoney() < this.m.Compensation)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
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
		local candidates_wildman = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
		}

		if (candidates_wildman.len() == 0)
		{
			return;
		}

		this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		this.m.Town = town;
		this.m.Score = candidates_wildman.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"compensation",
			this.m.Compensation
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
		this.m.Town = null;
	}

});

