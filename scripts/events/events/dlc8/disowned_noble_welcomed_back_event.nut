this.disowned_noble_welcomed_back_event <- this.inherit("scripts/events/event", {
	m = {
		Disowned = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.disowned_noble_welcomed_back";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_20.png[/img]{While in %townname%, you receive a letter from a messenger. He asks that you not read it, but as soon as he\'s around the corner you do just that, breaking apart a wax royal seal. You read that %disowned%, the disowned nobleman, is no longer exiled. Instead, his place is on the family throne as soon as his already gravely-ill father passes away.\n\nYou hold the letter in your hand, unsure of what to do with it. %disowned% has long been a member of the %companyname%. For some, there is a strange appeal to a man who was once in the royal rooms of the world, and now finds himself in the veritable lowlands of a mercenary company. But while a bloodline may dry, a lineage never truly dies...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'ll show him the letter.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "I\'ll burn the letter.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_82.png[/img]{Sighing with the realization of what might happen, you decide to go and show him the letter. He reads it for a length of time, then looks up.%SPEECH_ON%I know you\'ve read this.%SPEECH_OFF%He holds the letter back toward you.%SPEECH_ON%And I know you could have just as easily burned this letter. But you didn\'t. That only goes to show me what I already know: the %companyname% is my family now. If you want me to stay, I\'ll stay, if you want me to go, I\'ll go.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I think you should stay with us.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "You should go home to your family.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_82.png[/img]{You take the letter back, then put it toward a nearby candle. It burns quickly, ashes feathering way from your fingertips as the fire climbs up the paper. %disowned% nods.%SPEECH_ON%I\'m glad you did it. If my homelands need me, I shall only return when my work with the %companyname% is over. But until then, you shall have my sword, my sweat, and my blood.%SPEECH_OFF%He grins.%SPEECH_ON%For the right price, of course. I am, as it is, still yet a sellsword.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Of course.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Disowned.getImagePath());
				local background = this.new("scripts/skills/backgrounds/regent_in_absentia_background");
				_event.m.Disowned.getSkills().removeByID("background.disowned_noble");
				_event.m.Disowned.getSkills().add(background);
				_event.m.Disowned.m.Background = background;
				background.buildDescription();
				this.List = [
					{
						id = 13,
						icon = background.getIcon(),
						text = _event.m.Disowned.getName() + " is now a Regent in Absentia"
					}
				];
				local resolve_boost = this.Math.rand(10, 15);
				local initiative_boost = this.Math.rand(6, 10);
				local melee_defense_boost = this.Math.rand(2, 4);
				local ranged_defense_boost = this.Math.rand(3, 5);
				_event.m.Disowned.getBaseProperties().Bravery += resolve_boost;
				_event.m.Disowned.getBaseProperties().Initiative += initiative_boost;
				_event.m.Disowned.getBaseProperties().MeleeDefense += melee_defense_boost;
				_event.m.Disowned.getBaseProperties().RangedDefense += ranged_defense_boost;
				_event.m.Disowned.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Disowned.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve_boost + "[/color] Resolve"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Disowned.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative_boost + "[/color] Initiative"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Disowned.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + melee_defense_boost + "[/color] Melee Defense"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.Disowned.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + ranged_defense_boost + "[/color] Ranged Defense"
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_74.png[/img]{You push the letter back toward him.%SPEECH_ON%I think a man removed from his family is more in need of that family when they call him back, and certainly they must be in dire need of him. Your time with the %companyname% is over.%SPEECH_OFF%At first, the disowned nobleman appears despondent, but he then begins to nod, agreeing with your assessment that his family must be in need of him and he should not leave them twisting in the wind. He says his goodbyes to you and the rest of the company, but before he leaves for good he has prepared you a letter.%SPEECH_ON%You will have my thanks, captain. Don\'t think I\'d ever just leave without acknowledging how important you were to saving my life, because that\'s precisely what you did, whether you realize it or not.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You\'re alright, %disowned%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Disowned.getName() + " leaves the " + this.World.Assets.getName()
				});
				_event.m.Disowned.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Disowned.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Disowned);
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnAmbition);
				this.List.insert(0, {
					id = 10,
					icon = "ui/icons/special.png",
					text = "The company gained renown"
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_98.png[/img]{There\'s no way you\'re showing that to %disowned%. You promptly burn the letter and all details of his acceptance back into his family lineage. Just then, he comes around the corner. He looks a little perplexed and asks if there\'s anything wrong. You shake your head and ask if he wants to help count inventory. %disowned% grins.%SPEECH_ON%Of course. The %companyname% can\'t do what it does without a good inventory, or without your command, captain.%SPEECH_OFF%Just as you turn to join him, you see the messenger from earlier pulling something over. You leave %disowned% to the task and head the man off, asking what it is now. He pulls a heavy chest over and then wipes his brow, stating that this was also intended for the disowned nobleman. You kick it open to find a litany of arms and armor, some of which have his family crest on them. You thank the messenger, send him on his way, and then hurriedly break the crests off and throw the emblems into the gutters lest the nobleman see them himself. Curious, he hollers over if anything is wrong. You shake your head.%SPEECH_ON%No, nothing wrong. Just got a shipment of new gear, that\'s all.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nothing to see here.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				local stash = this.World.Assets.getStash();
				local armor_list = [
					"mail_hauberk",
					"reinforced_mail_hauberk"
				];

				if (this.Const.DLC.Unhold)
				{
					armor_list.extend([
						"footman_armor",
						"light_scale_armor",
						"sellsword_armor",
						"noble_mail_armor"
					]);
				}

				local weapons_list = [
					"noble_sword",
					"fighting_spear",
					"fighting_axe",
					"warhammer",
					"winged_mace",
					"arming_sword",
					"warbrand"
				];
				item = this.new("scripts/items/armor/" + armor_list[this.Math.rand(0, armor_list.len() - 1)]);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/" + weapons_list[this.Math.rand(0, weapons_list.len() - 1)]);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/" + weapons_list[this.Math.rand(0, weapons_list.len() - 1)]);
				stash.add(item);
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
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
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
		local disowned_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.disowned_noble" && bro.getLevel() >= 6)
			{
				disowned_candidates.push(bro);
			}
		}

		if (disowned_candidates.len() == 0)
		{
			return;
		}

		this.m.Disowned = disowned_candidates[this.Math.rand(0, disowned_candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 4 * disowned_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"disowned",
			this.m.Disowned.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Disowned = null;
		this.m.Town = null;
	}

});

