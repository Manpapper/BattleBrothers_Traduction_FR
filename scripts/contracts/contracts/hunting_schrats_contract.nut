this.hunting_schrats_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_schrats";
		this.m.Name = "Haunted Woods";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Chassez ce qui tue les gens dans les bois autour de " + this.Contract.m.Home.getName()
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					this.Flags.set("IsDirewolves", true);
				}
				else if (r <= 25)
				{
					this.Flags.set("IsGlade", true);
				}
				else if (r <= 30)
				{
					this.Flags.set("IsWoodcutter", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local x = this.Math.max(3, playerTile.SquareCoords.X - 11);
				local x_max = this.Math.min(mapSize.X - 3, playerTile.SquareCoords.X + 11);
				local y = this.Math.max(3, playerTile.SquareCoords.Y - 11);
				local y_max = this.Math.min(mapSize.Y - 3, playerTile.SquareCoords.Y + 11);
				local numWoods = 0;

				while (x <= x_max)
				{
					while (y <= y_max)
					{
						local tile = this.World.getTileSquare(x, y);

						if (tile.Type == this.Const.World.TerrainType.Forest || tile.Type == this.Const.World.TerrainType.LeaveForest || tile.Type == this.Const.World.TerrainType.AutumnForest)
						{
							numWoods = ++numWoods;
						}

						y = ++y;
					}

					x = ++x;
				}

				local tile = this.Contract.getTileToSpawnLocation(playerTile, numWoods >= 12 ? 6 : 3, 11, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Schrats", false, this.Const.World.Spawn.Schrats, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("A creature of bark and wood, blending between trees and shambling slowly, its roots digging through the soil.");
				party.setFootprintType(this.Const.World.FootprintsType.Schrats);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);

				for( local i = 0; i < 2; i = ++i )
				{
					local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 7, disallowedTerrain);

					if (nearTile != null)
					{
						this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Schrats, 0.75);
					}
				}

				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(5);
				roam.setMaxRange(10);
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.SnowyForest, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					this.Contract.setScreen("Victory");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					local tileType = this.World.State.getPlayer().getTile().Type;

					if (tileType == this.Const.World.TerrainType.Forest || tileType == this.Const.World.TerrainType.LeaveForest || tileType == this.Const.World.TerrainType.AutumnForest)
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);

					if (this.Flags.get("IsDirewolves"))
					{
						this.Contract.setScreen("Direwolves");
					}
					else
					{
						this.Contract.setScreen("Encounter");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_62.png[/img]{You find a town board littered with notes written in cheap scrap or even on leaves and held there with the most rusted of nails. %employer% sidles up to you.%SPEECH_ON%We\'ve been waiting for a man of your sort, sellsword. Folks keep going missing in the woods and I\'ve no recourse in getting them back. I\'ve heard tales of trees on the move and killing the lumberjacks hacking at their trunks, but who knows if any of that\'s true. I need your company to head into the woods and find out what\'s causing all this carnage. Are you interested?%SPEECH_OFF% | %employer% is rolling a piece of bark between his fingers like a gambler\'s coin. He sighs and throws it across his table.%SPEECH_ON%I\'ve been receiving stories about lumberjacks and peddlers going missing in the woods. Some say the trees are coming alive to have their revenge, but that sounds like hogwash to me. Either way, a sum of coin has been readied to help \'solve\' this issue and I\'m willing to dispense it. What say you, sellsword, are you interested in finding whatever monsters are hounding this town?%SPEECH_OFF% | There\'s a pile of sawdust on %employer%\'s desk and his eyes are intently staring into the mound. He waves you in without breaking his glare, and speaks all the same.%SPEECH_ON%The local lumberjacks are reporting that men are going missing in the woods. They say the trees are up to it, something about monsters made of wood and roots. Parts of me believe they\'re hiding a murder and won\'t fess to the crime, but then maybe the spooky stories are true. Either way, I\'ve coin to see it to an end and you\'re just the man the task, yeah?%SPEECH_OFF% | Entering %employer%\'s room, your foot clips a slat of chopped wood. It tumbles over and falls flat edged, the round trunk and its bark now up at you. The mayor claps his hands.%SPEECH_ON%So it didn\'t move! Ah, you\'re probably wondering what I\'m on about. Here.%SPEECH_OFF%He throws you a drawing of what looks like a tree with arms. He goes on.%SPEECH_ON%I\'ve word from the roads that the trees are coming alive. Even have a trusted friend who works as a lumberjack said, straight faced, that some spiritual beast in the trees had taken the wood and roots and wielded them as weapons. Whatever is out there, I need a set of killers to seek it out. Are you and your company up for the task?%SPEECH_OFF% | %employer% is found sitting on a trunk of a tree while surrounded by peasants. After a few minutes he throws his hands out.%SPEECH_ON%See! Ain\'t nothing wrong! It\'s a tree! A tree, see?%SPEECH_OFF%The peasants are not convinced and go on about monsters in the forest shaped like the woods themselves. Sighing, %employer% throws his hand out to you.%SPEECH_ON%Fine, we\'ll hire some mercenaries? Does that suit everyone? What say you, sellsword. We\'ve coin to pay and murderous trees for you to hunt. Sound good?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Interested for sure. | Let\'s talk pay. | Let\'s talk crowns. | This is going to cost you. | A wild chase through the forest, then? Count me in. | The %companyname% can help, for the right price.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{This doesn\'t sound like our kind of work. | I won\'t lead the men on a wild goose chase through the woods. | I don\'t think so. | I say no. The men prefer known enemies of flesh and blood.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Banter",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_25.png[/img]{The company is increasingly on edge, insomuch as a company would be in a forest while hunting murderous trees. Every crack of a branch has the men drawing swords and one of them screamed when a fallen leaf fell into the nape of shirt. Your enemy is already scoring wins without even having to do anything! | The forest is making the men uneasy. You tell them to shape up for the enemy is out there one way or another, and it is not worth being fearful of that which is certain. It is you who shall be feared, the %companyname%, and these damned murderous trees will be wishing you were simple lumberjacks by the time you\'re done with them! | %randombrother% heaves his weapon over his shoulders and totters on with his arms swinging around dramatically. He\'s sizing up the forest foliage.%SPEECH_ON%Hey cap\', what you say we smash up one of these trees here and call it a day! Pitch \'em a pile of chopped wood and mulch and ain\'t no one gonna know the difference when it\'s all said and told. If they ask questions just tell \'em the bark had some bite!%SPEECH_OFF%The men laugh and you tell the sellsword you\'ll take his idea into consideration.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Watch where you step.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_107.png[/img]{While standing around getting a lay of the land, %randombrother% calls out that there\'s something moving in the distance. As you come to his side, he points a finger into the foliage and draws his sword. A great tree is marching toward you, shambling from side to side like an old man in a library\'s familiar corridors. You draw your own sword and order the men into formation. | %randombrother% is sitting on a fallen tree when he suddenly jumps up yelling and grabbing his weapon. You look over to see the tree itself rising up into the air, clumps of earth raining below and a great wet ditch left as though it had bedded there for eons. It leans against its healthier brethren like a drunkard would into a friend\'s shoulder. Slowly, it twists its body around, a pair of green eyes flared from somewhere deep in its trunk, and its sharp branches wheel around with it, splayed wide with their shadows falling over the company like a web. You grab your sword and order the men into formation.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Charge!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Direwolves",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_118.png[/img]{You spot pairs of green eyes glowing in the distance. No doubt a sight of the schrats themselves, and so you order your men to clamber toward them quietly.\n\nCresting a hill you find the trunk of one tree is surrounded by direwolves. They\'re crouched beneath it like knights swearing fealty. Your arrival has not gone unnoticed as the schrat leans forward with a seemingly ancient crooning. The creatures at its roots growl and turn as though commanded. You\'re not sure what to make of such arboreal allegiance, but the %companyname% will break them all the same.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Charge!",
					function getResult()
					{
						this.Contract.addUnitsToEntity(this.Contract.m.Target, this.Const.World.Spawn.Direwolves, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_121.png[/img]{The schrats are slain, their arboreal remains now resembling little more than ordinary trees. You carve trophies and evidence for a Retournez à %employer%. | You stare at a felled tree and then at a felled schrat. Between the two you see almost no difference, which makes you ponder about all those supposedly dead trees you\'ve been hopping over your whole life. Not one to dwell on such matters, you order the company take trophies as proof of the battle and ready a Retournez à %employer%. | The schrats are felled, each draped against the rest of the forest foliage like brawlers resting between rounds. You walk up beneath the roots of one and get a good look at it, but now it appears no different than any other tree around. You order the company to take what trophies they can to show %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "It\'s done.",
					function getResult()
					{
						if (this.Flags.get("IsGlade") && this.World.Assets.getStash().hasEmptySlot())
						{
							return "Glade";
						}
						else if (this.Flags.get("IsWoodcutter") && this.World.Assets.getStash().hasEmptySlot())
						{
							return "DeadWoodcutter";
						}
						else
						{
							return 0;
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Glade",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_121.png[/img]{As you\'re departing the battlefield, %randombrother% remarks that the surrounding area looks rather ripe. You turn around to see that he\'s indeed correct: a beautiful crop of trees served host to the schrats, presumably chosen for good reason. And if the schrats took it for a good home, then it surely means the wood is very fine. You order the men to make use of this quality glade and chop as many trees down as time and energy permits. The harvested timber is very fine indeed.\n\n It begins to rain as you depart the impromptu lumbermill.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Back to %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local item = this.new("scripts/items/trade/quality_wood_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				item = this.new("scripts/items/trade/quality_wood_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "DeadWoodcutter",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_121.png[/img]{Just as you\'re departing a glint catches your eye. You turn around and come to one of the schrats\' trunk. An axe is embedded in the wood. Moss has long since overgrown the handle, and yet the metal of the tool is without error, not a smidge of rust upon it. Scraping the moss away, you uncover wooden fingertips still at full grip. Tracing the fingers ends at the tree trunk where the wrist becomes a vein of wood. You follow that along to a wooden face with a twisted maw, like a face of brown wax melted by time alone. The frame of a helmet twists autour de face and there\'s a chest plate cresting below like the reservoir of a deerchaser.\n\nYou shake your head and retrieve the axe, breaking it free and throwing the wooden fingers off its handle. The misshapen face blankly observes your theft, its stare preserved in the very annihilation from which it is eons removed. You don\'t dwell on the sight and Retournez à the company with the axe.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Back to %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local item;
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/woodcutters_axe");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/hand_axe");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/fighting_axe");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/greataxe");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain a " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_62.png[/img]{You find %employer% carving a toy out of wood. He blows the shavings off his desk and claps the sawdust from his fingers. He sets the toy up on its legs, shaped like a knight that\'s eaten too many sweets, but it promptly falls over. Sighing, he turns to you for help. You pull the schrat\'s head into the room and let it rock back and forth on the floor til it rests upon one of its horns. The mayor nods.%SPEECH_ON%Quite good, sellsword.%SPEECH_OFF%He fetches your promised reward. | %employer% is shocked at your return, and shocked at the schrat\'s remains which you have brought upon his doorstep. He looks down at it, ever incredulous as to its source. Like a cat pawing at a bug\'s shorn wings he rummages the pile with his foot.%SPEECH_ON%I\'d no imagination of you bringing these back, but damned if you didn\'t find and kill those bastard trees. Well, I\'ll fetch your reward.%SPEECH_OFF%He brings you the contracted coin as promised. | %employer% is running a carver down the arm of a wooden chair when you find him. He looks up at your arrival and you present the remains of a schrat. The man gets up and takes a piece, coming to sit in his chair to get a good look at it, but his chair blows apart beneath his arse and claps the boards against the ground with a tremendous clatter as if his original designs all along were to export a great cacophony. %employer% throws his tools in a fit.%SPEECH_ON%By the gods I\'ll, well, I\'d best not make myself a savage and threaten them. Suppose doing that got me to this state in the first place.%SPEECH_OFF%You nod, stating it\'s unwise to anger the old gods. You also suggest that it is unwise to let a sellsword go unpaid for his work. The mayor jumps to his feet and runs to get a satchel of coin.%SPEECH_ON%Of course, mercenary! You need not lecture me on such matters!%SPEECH_OFF% | %employer% is found beneath a copse of trees. He\'s got his hands over his belly and he\'s staring at the sky. A smile crosses his face and he points up at a cloud as though someone should be beside him to witness, but he\'s all by himself and says nothing. You throw a chunk of schrat at his feet and ask if he has your payment. He turns over a satchel that had heretofore gone unseen.%SPEECH_ON% A couple of lumberjacks saw you in battle with them and told me the tale, already. I\'d not thought the schrats entirely real. Deadly trees seem like a superstition for children, but I suppose I\'ve things to learn yet. Good work, sellsword.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A successful hunt.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of living trees");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/disappearing_villagers_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setAttackableByAI(true);
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

