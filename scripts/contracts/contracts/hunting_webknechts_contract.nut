this.hunting_webknechts_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_webknechts";
		this.m.Name = "Hunting Webknechts";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 450 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 0.9)
					{
						this.Flags.set("IsOldArmor", true);
					}
				}
				else if (r <= 20)
				{
					this.Flags.set("IsSurvivor", true);
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
				local x = this.Math.max(3, playerTile.SquareCoords.X - 9);
				local x_max = this.Math.min(mapSize.X - 3, playerTile.SquareCoords.X + 9);
				local y = this.Math.max(3, playerTile.SquareCoords.Y - 9);
				local y_max = this.Math.min(mapSize.Y - 3, playerTile.SquareCoords.Y + 9);
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

				local tile = this.Contract.getTileToSpawnLocation(playerTile, numWoods >= 12 ? 6 : 3, 9, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Webknechts", false, this.Const.World.Spawn.Spiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("A swarm of webknechts skittering about.");
				party.setFootprintType(this.Const.World.FootprintsType.Spiders);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);

				for( local i = 0; i < 2; i = ++i )
				{
					local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 5);

					if (nearTile != null)
					{
						this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
					}
				}

				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
				roam.setMinRange(1);
				roam.setMaxRange(1);
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
					if (this.Flags.get("IsOldArmor") && this.World.Assets.getStash().hasEmptySlot())
					{
						this.Contract.setScreen("OldArmor");
					}
					else if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Survivor");
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

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
					this.Contract.setScreen("Encounter");
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{%employer% waves you into his room. You notice that there are pitchfork-armed men keeping vigilant watch by means of grimly staring out his windows, though one of these fellows is clearly asleep against the wall. You ask the settlement\'s mayor what it is he wants. He gets to the point.%SPEECH_ON%Townsfolk in the hinterland are reporting monstrosities taking children and dogs and the like. Now I don\'t mean to give leeway to paranoia and superstition, but it sounds an awful lot like these reports are talking about spiders. Webknechts as my father would call \'em, and if it\'s true then it is likely they\'ve a nest in these parts and I need you to find and destroy it. Are you interested, sellsword?%SPEECH_OFF% | You find %employer% stretching a cobweb between two forks. He turns one of the utensils and wraps the webbing around a twine. Sighing, he finally looks at you.%SPEECH_ON%I\'ve little mind to bring sellswords to these parts, but I\'m at my wit\'s end here. Enormous spiders are afoot, stealing livestock, pets. One lady reported her infant taken from the crib, all there being a pit of webbing where it slept. I need these horrid creatures taken care of, their nest destroyed. With proper incentive, would you be interested?%SPEECH_OFF% | You come to %employer% and your shadow alone startles the man. He sits up straight at his desk and nods.%SPEECH_ON%Ah, I got the fits. No mind to your being here, sellsword, though you\'re scary enough, but word autour dese parts is that large spiders are afoot. I\'ve reason to believe the stories, being that I\'d gone to a farmstead and seen the large webbings and the devoured livestock. I need a man privy to absolute violence, speaking to you here, and I need such a man to find the nest of monsters and put them to an end. Are you interested?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{How many crowns can you muster? | Let\'s talk pay. | Let\'s talk crowns.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{This doesn\'t sound like our kind of work.}",
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
			Text = "[img]gfx/ui/events/event_25.png[/img]{You stumble across a dead cow with its flesh sucked to its very bones, yet its hide does not carry any sign of being sundried. %randombrother% crouches and runs his finger among a number of puncture wounds. He nods.%SPEECH_ON%The work of a webknecht, no doubt to it. I\'d say they poisoned it and then fed upon its paralyzed body. And a fresh corpse means they\'re close...%SPEECH_OFF% | You find a webbed corpse leaning against a lone tree. You slash the filaments away. A child\'s body slips out and crumples to the ground. Its face is tight to the bone, a pallid skull with the eyeballs peeking from deep in the sockets. The tongue is equally receded and there\'s hardly a nose at all. %randombrother% spits and nods.%SPEECH_ON%Alright. We\'re close. Rather, they\'re close. If it\'s solace to you folks, the boy died prior to this here state of being. Webknechts bring poison with their puncturing and no kid would stand to survive it long.%SPEECH_OFF%Well that\'s good. Time for the men to find these monsters. | You find a lad hiding beneath an upturned wheelbarrow. He refuses to come out, his tiny head staring out from the shelter like a pearl from a clamshell. You ask what he\'s doing. He frantically explains that he\'s hiding from the spiders and that you should go.%SPEECH_ON%Getcher own barrow. This here\'s mine.%SPEECH_OFF% Brandishing your sword, you tell him that it\'s the spiders you\'re looking for. The boy stares at you. He nods.%SPEECH_ON%That\'s a right goddam bad idea, sir. And no, I ain\'t a clue where\'d they gone to. I was here with a caravan and do you see a caravan? No that\'s right you damn don\'t cause they all spider salad now, so git before they see you speaking to me!%SPEECH_OFF%The barrow clatters closed. You\'ve no mind to lift it back up, though you do give it a good kick as you depart.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Keep your eyes peeled.",
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
			Text = "[img]gfx/ui/events/event_110.png[/img]{The nest of webknechts is a pit of earth wreathed in white. At its rim are thin filaments which list about at even the slightest suggestion of a breeze. Marching your company inward, the webbing begins to take a sort of civilized shape, as though you were walking in from wintery hinterland, the recency of its creation apparent in its tight trappings: deer, dogs, man-sized cocoons which show no sign of life, all bound snug in the hangars of white silos and planes like morsels lost upon a pale rug. A black shadow saunters up behind the veiled domicile, coming to the fore with its legs squatting defilade, its head crouched beyond them as though the foul cretin were gated by its own stride. A human hand sucks in and out from its mandibles like some macabre pacifier. You\'ve come to the right place. | The webknecht nest is silent and the clatter of the company\'s arrival seems apocryphal, with the chink and clink of metals distinctly sharp in their trespass.\n\n You find a man hanging upside down from a tree, his whole body cocooned save his face which is stretched and pulled by the filaments. He asks you cut his eyelids free of the webbing which you oblige. His lids slowly close, the crust of the dry eyes crackling closed for the first time in possibly days. But then they snap open and the man screams. The cocoon bubbles at his waist and rips apart, a sputtering of tiny black spiders flooding out. The man\'s body jolts violently around as the swarm consumes him, his gargled screams rife with the skittering of spiderlings which fill his lungs and which he coughs out in dying fits. Horrified, you step back only to see a throng of much larger spiders emerging from autour de trees! | The nest is an easy spot, a stretch of winterscape where there\'s no cold, the white webbing patchy and listing from every tree, every copse, every inch of the place. You march the company right in, weapons drawn, and there you come across the wrapped bodies, their centers blown open and blackened, a spawn of spiderlings sucking on the organs.\n\n  Staring up, you see red eyes flare between the branches of the surrounding trees, the whole arachnidian arboretum come alive, its wardens perched there amongst the brush with their squatted legs indistinguishable from the branches, the enemy hiding in plain sight. You damn near shit yourself when a supposed tree unfolds entirely, every wooden stalk but a spider leg, the arborous sleight descending on the company chittering and chamfering for a bite!}",
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
			ID = "Victory",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{The last of the webknechts is dealt with, its legs gating itself as though to eternally clutch at the weapon which had slain it. You nod at the company\'s good work then order the whole place torched. Fires rapidly run the length of the webs, breaking bridges of filament apart and sending fiery doom to their connectors. The whole nest is consumed in the inferno and somewhere deep in its bedding you hear the shrill cry of spiderlings set alight. | You step close to the last of the webknechts and stare at its grisly maw. It carries a vicious set of mandibles for a sort of gum guard, the mouth itself a slit lined with razor sharp teeth pointed counter-current as to shred anything that tried to escape.\n\n You order the whole nest put to the torch. As the flames rise, there comes the cry of spiderlings somewhere in their warrens. | You ready a Retournez à %employer%, but first have the nest torched entirely. The company stands before the flames listening to the shrill cries of spiderlings and at times laughing at the little mites scuttling around like tiny fireballs on legs. | The spiders defeated, you have the whole godsforsaken place burned and ready a Retournez à %employer%. As the fires rise, tiny spiderlings come running out with their bodies aflame like fireflies in the night. A few sellswords take up an impromptu game of seeing who can squash the most, an affair which ends with a particularly ambitious spiderling almost setting a mercenary\'s pants alight.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s be done with this, we have crowns to collect.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "OldArmor",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{With the webknechts dispatched you have the company briefly search the creatures\' nest, though the mercenaries are ordered to never wander alone. You muck about as well, %randombrother% at your side. Together, you spot a tree that\'s remarkably untouched by the webs. As you circle around, you find a knight\'s corpse leaning against its trunk. His hand rests atop a broken sword\'s pommel, the other hand is missing altogether, nothing but sleeve at the wrist with the mutilated arm couched at his belly. The corpse rests in a nest of its own making, a thicket of what look like spoiled rhubarb stalks and decayed carapaces, the broken bodies caverned and smelling of poison. %randombrother% nods.%SPEECH_ON%That\'s a right shame. I\'d wager he would have made a sound addition to the %companyname%, whoever he was.%SPEECH_OFF%Indeed, it has all the look of a great fighter\'s end. You\'ve mind to bury him, but you\'ve no time. You tell %randombrother% to fetch what he can from the corpse and to ready a Retournez à %employer%.}",
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
				local r = this.Math.rand(1, 2);

				if (r == 1)
				{
					item = this.new("scripts/items/armor/decayed_reinforced_mail_hauberk");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/armor/decayed_coat_of_scales");
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
			ID = "Survivor",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{The battle over, you find a man dangling by webbing attached to his feet. Half of his body is bound in the filaments and more dangle from his hip like a shredded dress. Seems the spiders deserted him upon the %companyname%\'s arrival. He smiles at the sight of you.%SPEECH_ON%Hey there. Mercenaries ain\'t ya? Yeah I see it. You\'ve no mind being here lest it was coin that brought ya, and you fought like bastards that\'d been bet on. Absolute savages.%SPEECH_OFF%You ask the man what you\'ll get for cutting him down. He turns his head up, his whole body then starting to swing about and at times twist him away from you entirely. He speaks, either to you or to whichever direction he\'s facing.%SPEECH_ON%Aye, good question! Well, you may not see it here and now, but I\'m a sellsword m\'self, and wouldn\'t you know that my company and its captain all been done stringed up and consumed whole by them spiders! Cut me down and I\'ve nowhere else better to go then your company. That is, if you\'d have me.%SPEECH_OFF%You have the man cut free and debate what to do before returning to %employer%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the company!",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "You\'ll have to find your luck elsewhere.",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx([
					"retired_soldier_background"
				]);

				if (!this.Contract.m.Dude.getSkills().hasSkill("trait.fear_beasts") && !this.Contract.m.Dude.getSkills().hasSkill("trait.hate_beasts"))
				{
					this.Contract.m.Dude.getSkills().removeByID("trait.fearless");
					this.Contract.m.Dude.getSkills().add(this.new("scripts/skills/traits/fear_beasts_trait"));
				}

				this.Contract.m.Dude.getBackground().m.RawDescription = "You found %name% dangling from a tree, the sellsword the last survivor of a mercenary band sent to kill webknechts. He joined the company after you rescued him.";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.worsenMood(0.5, "Lost his previous company to webknechts");
				this.Contract.m.Dude.worsenMood(0.5, "Almost consumed alive by webknechts");

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).getArmor() * 0.33);
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_85.png[/img]{%employer% meets you at the town entrance and there\'s a crowd of folks beside him. He welcomes you warmly, stating he had a scout following you who saw the whole battle unfold. After he hands you your reward, the townsfolk come forward one by one, many of them reluctant to stare a sellsword in the eyes, but they offer a few gifts as thanks for relieving them of the webknecht horrors. | You have to track down %employer%, ultimately finding the man in a stable livery with a peasant girl. He saws upward from the hay, startling the horses which whinny and stamp their feet. Half-dressed, the man states he already has your pay and forks it over. Eyeing you eyeing the girl, he then starts to grab whatever\'s in reach, including from the saddlebags of stabled mounts, and hands them over.%SPEECH_ON%The, uh, townsfolk also sought to pitch in. You know, as thanks.%SPEECH_OFF%Right. For further \'thanks\' you ask if he\'ll give you whatever\'s in a nearby satchel. | %employer% welcomes you back with a great clap and rub of his hands, as though you\'d just brought in a turkey and not the horrifying evidence of your victory. After paying you the agreed reward, you hear some surprising news. The mayor states that the estate of a lost townsman could not be properly divvied up and, as further thanks, you\'re free to take what\'s left of it.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of webknechts");
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
				local food;
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					food = this.new("scripts/items/supplies/cured_venison_item");
				}
				else if (r == 2)
				{
					food = this.new("scripts/items/supplies/pickled_mushrooms_item");
				}
				else if (r == 3)
				{
					food = this.new("scripts/items/supplies/roots_and_berries_item");
				}

				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "You gain " + food.getName()
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

