this.tutorial_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Location = null,
		BigCity = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.tutorial";
		this.m.Name = "%companyname%";
		this.m.TimeOut = this.Time.getVirtualTimeF() + 9000.0;
	}

	function start()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local best_dist = 9000;
		local best_start;
		local best_big;

		foreach( s in settlements )
		{
			if (s.isMilitary() || s.getSize() > 1 || s.isIsolatedFromRoads())
			{
				continue;
			}

			local bestDist = 9000;
			local best;

			foreach( b in settlements )
			{
				if (s.getID() == b.getID())
				{
					continue;
				}

				if (b.getSize() <= 1 || b.isIsolatedFromRoads())
				{
					continue;
				}

				local d = s.getTile().getDistanceTo(b.getTile());

				if (d < bestDist)
				{
					bestDist = d;
					best = b;
				}
			}

			if (best != null && bestDist < best_dist)
			{
				best_dist = bestDist;
				best_start = s;
				best_big = best;
			}
		}

		this.setHome(best_start);
		this.setOrigin(best_start);
		this.m.Home.setVisited(true);
		this.m.Home.setDiscovered(true);
		this.World.uncoverFogOfWar(this.m.Home.getTile().Pos, 500.0);
		this.m.Faction = best_start.getFactions()[0];
		this.m.EmployerID = this.World.FactionManager.getFaction(this.m.Faction).getRandomCharacter().getID();
		this.m.BigCity = this.WeakTableRef(best_big);
		local tile = this.getTileToSpawnLocation(this.m.Home.getTile(), 5, 8, [
			this.Const.World.TerrainType.Swamp,
			this.Const.World.TerrainType.Forest,
			this.Const.World.TerrainType.LeaveForest,
			this.Const.World.TerrainType.SnowyForest,
			this.Const.World.TerrainType.Shore,
			this.Const.World.TerrainType.Ocean,
			this.Const.World.TerrainType.Mountains
		]);
		this.World.State.getPlayer().setPos(tile.Pos);
		this.World.getCamera().jumpTo(this.World.State.getPlayer());
		this.m.Flags.set("BossName", "Hoggart the Weasel");
		this.m.Flags.set("LocationName", "Hoggart\'s Refuge");
		this.setState("StartingBattle");
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "StartingBattle",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Tuez %boss%"
				];
				this.World.State.m.IsAutosaving = false;
			}

			function update()
			{
				if (!this.Flags.get("IsTutorialBattleDone"))
				{
					if (!this.Flags.get("IsIntroShown"))
					{
						this.Flags.set("IsIntroShown", true);
						this.Sound.play("sounds/intro_battle.wav");
						this.Contract.setScreen("Intro");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.CivilianTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Tutorial1";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Custom;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Custom;
						p.PlayerDeploymentCallback = this.onPlayerDeployment.bindenv(this);
						p.EnemyDeploymentCallback = this.onAIDeployment.bindenv(this);
						p.IsFleeingProhibited = true;
						p.IsAutoAssigningBases = false;
						this.World.Contracts.startScriptedCombat(p, false, false, false);
					}
				}
				else
				{
					this.Contract.setScreen("IntroAftermath");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Tutorial1")
				{
					this.Flags.set("IsTutorialBattleDone", true);
					local brothers = this.World.getPlayerRoster().getAll();
					brothers[0].setIsAbleToDie(true);
					brothers[1].setIsAbleToDie(true);
					brothers[2].setIsAbleToDie(true);
					this.World.State.m.IsAutosaving = true;
				}
			}

			function onPlayerDeployment()
			{
				for( local x = 0; x != 32; x = ++x )
				{
					for( local y = 0; y != 32; y = ++y )
					{
						local tile = this.Tactical.getTileSquare(x, y);
						tile.Level = 0;

						if (x > 11 && x < 22 && y > 12 && y < 21)
						{
							tile.removeObject();

							if (tile.IsHidingEntity)
							{
								tile.clear();
								tile.IsHidingEntity = false;
							}
						}
					}
				}

				this.Tactical.fillVisibility(this.Const.Faction.Player, true);
				local brothers = this.World.getPlayerRoster().getAll();
				this.Tactical.addEntityToMap(brothers[0], 13, 15 - 13 / 2);
				brothers[0].setIsAbleToDie(false);
				this.Tactical.addEntityToMap(brothers[1], 13, 16 - 13 / 2);
				brothers[1].setIsAbleToDie(false);
				this.Tactical.addEntityToMap(brothers[2], 12, 18 - 12 / 2);
				brothers[2].setIsAbleToDie(false);
				this.Tactical.CameraDirector.addJumpToTileEvent(0, this.Tactical.getTile(6, 17 - 6 / 2), 0, null, null, 0, 0);
				this.Tactical.CameraDirector.addMoveSlowlyToTileEvent(0, this.Tactical.getTile(18, 17 - 18 / 2), 0, null, null, 0, 1000);
				this.Contract.spawnBlood(11, 12);
				this.Contract.spawnBlood(13, 15);
				this.Contract.spawnBlood(14, 17);
				this.Contract.spawnBlood(15, 16);
				this.Contract.spawnBlood(17, 14);
				this.Contract.spawnBlood(15, 15);
				this.Contract.spawnBlood(18, 16);
				this.Contract.spawnBlood(12, 14);
				this.Contract.spawnBlood(13, 16);
				this.Contract.spawnBlood(12, 15);
				this.Contract.spawnBlood(16, 18);
				this.Contract.spawnBlood(15, 17);
				this.Contract.spawnArrow(13, 13);
				this.Contract.spawnArrow(14, 17);
				this.Contract.spawnArrow(17, 15);
				this.Contract.spawnCorpse(12, 13);
				this.Contract.spawnCorpse(16, 14);
				this.Contract.spawnCorpse(17, 16);
				this.Contract.spawnCorpse(15, 14);
				this.Contract.spawnCorpse(14, 18);
			}

			function onAIDeployment()
			{
				local e;
				this.Const.Movement.AnnounceDiscoveredEntities = false;
				e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/bounty_hunter", 16, 16 - 16 / 2);
				e.setFaction(this.Const.Faction.PlayerAnimals);
				e.setName("One-Eye");
				e.getSprite("socket").setBrush("bust_base_player");
				e.assignRandomEquipment();
				e.getSkills().removeByID("perk.overwhelm");
				e.getSkills().removeByID("perk.nimble");
				e.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(0);

				if (e.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					e.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					e.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				e.getBaseProperties().Hitpoints = 5;
				e.getBaseProperties().MeleeSkill = -200;
				e.getBaseProperties().RangedSkill = 0;
				e.getBaseProperties().MeleeDefense = -200;
				e.getBaseProperties().Initiative = 200;
				e.getSkills().update();
				e.setHitpoints(5);
				e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/bounty_hunter", 15, 18 - 15 / 2);
				e.setFaction(this.Const.Faction.PlayerAnimals);
				e.setName("Captain Bernhard");
				e.getSprite("socket").setBrush("bust_base_player");
				e.getSkills().removeByID("perk.overwhelm");
				e.getSkills().removeByID("perk.nimble");
				local armor = this.new("scripts/items/armor/mail_hauberk");
				armor.setVariant(32);
				armor.setArmor(0);
				e.getItems().equip(armor);
				e.getItems().equip(this.new("scripts/items/weapons/arming_sword"));
				e.getBaseProperties().Hitpoints = 9;
				e.getBaseProperties().MeleeSkill = -200;
				e.getBaseProperties().RangedSkill = 0;
				e.getBaseProperties().MeleeDefense = -200;
				e.getBaseProperties().DamageTotalMult = 0.1;
				e.getBaseProperties().Initiative = 250;
				e.getSkills().update();
				e.setHitpoints(5);
				e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_thug", 18, 17 - 18 / 2);
				e.setFaction(this.Const.Faction.Enemy);
				e.getAIAgent().getProperties().OverallDefensivenessMult = 0.0;
				e.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
				e.assignRandomEquipment();
				e.getBaseProperties().Initiative = 300;
				e.getSkills().update();
				e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_thug", 17, 18 - 17 / 2);
				e.setFaction(this.Const.Faction.Enemy);
				e.getAIAgent().getProperties().OverallDefensivenessMult = 0.0;
				e.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
				e.assignRandomEquipment();
				e.getBaseProperties().Initiative = 200;
				e.getSkills().update();
				e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_raider_low", 19, 17 - 19 / 2);
				e.setFaction(this.Const.Faction.Enemy);
				e.setName(this.Flags.get("BossName"));
				e.getAIAgent().getProperties().OverallDefensivenessMult = 0.0;
				e.getAIAgent().addBehavior(this.new("scripts/ai/tactical/behaviors/ai_retreat_always"));
				local items = e.getItems();
				items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
				items.equip(this.new("scripts/items/weapons/hunting_bow"));
				this.Flags.set("BossHead", e.getSprite("head").getBrush().Name);
				this.Flags.set("BossBeard", e.getSprite("beard").HasBrush ? e.getSprite("beard").getBrush().Name : "");
				this.Flags.set("BossBeardTop", e.getSprite("beard_top").HasBrush ? e.getSprite("beard_top").getBrush().Name : "");
				this.Flags.set("BossHair", e.getSprite("hair").HasBrush ? e.getSprite("hair").getBrush().Name : "");
				e.getBaseProperties().Hitpoints = 300;
				e.getSkills().update();
				e.setHitpoints(180);
				e.setMoraleState(this.Const.MoraleState.Wavering);
				this.Const.Movement.AnnounceDiscoveredEntities = true;
			}

		});
		this.m.States.push({
			ID = "ReturnAfterIntro",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.BulletpointsObjectives = [
					"Retournez ?? " + this.Contract.m.Home.getName() + " pour ??tre pay??s"
				];
				this.World.State.getPlayer().setAttackable(false);
				this.World.State.m.IsAutosaving = true;
			}

			function update()
			{
				if (this.World.getTime().Days > 2)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("PaymentAfterIntro1", false);
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Recruit",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.Contract.m.BigCity.getSprite("selection").Visible = true;
				this.Contract.m.BulletpointsObjectives = [
					"Visitez %bigcity% %citydirection% de %townname%"
				];

				if (this.World.getPlayerRoster().getSize() < 6)
				{
					if (this.Math.max(1, 6 - this.World.getPlayerRoster().getSize()) > 1)
					{
						this.Contract.m.BulletpointsObjectives.push("Engager " + this.Math.max(1, 6 - this.World.getPlayerRoster().getSize()) + " hommes de plus");
					}
					else
					{
						this.Contract.m.BulletpointsObjectives.push("Engager au  moins un homme de plus");
					}
				}

				this.Contract.m.BulletpointsObjectives.push("Acheter des armes et des armures pour vos hommes");
				this.World.State.getPlayer().setAttackable(false);
				this.Contract.m.BigCity.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.BigCity.getTile().Pos, 500.0);
			}

			function update()
			{
				if (this.World.getTime().Days > 4)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.World.getPlayerRoster().getSize() >= 6 && this.Flags.get("IsMarketplaceTipShown"))
				{
					this.Contract.setState("ReturnAfterRecruiting");
				}
				else if (this.World.getPlayerRoster().getSize() >= 6 && this.Contract.m.BulletpointsObjectives.len() == 3)
				{
					this.start();
					this.World.Contracts.updateActiveContract();
				}
				else if (!this.Flags.get("IsMarketplaceTipShown") && this.World.State.getPlayer().getDistanceTo(this.Contract.m.BigCity.get()) <= 600)
				{
					this.Flags.set("IsMarketplaceTipShown", true);
					this.Contract.setScreen("MarketplaceTip");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "ReturnAfterRecruiting",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.BigCity.getSprite("selection").Visible = false;
				this.Contract.m.BulletpointsObjectives = [
					"Retournez voir %employer% ?? %townname%"
				];
				this.World.State.getPlayer().setAttackable(false);
			}

			function update()
			{
				if (this.World.getTime().Days > 6)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 6, 10, [
						this.Const.World.TerrainType.Swamp,
						this.Const.World.TerrainType.Forest,
						this.Const.World.TerrainType.LeaveForest,
						this.Const.World.TerrainType.SnowyForest,
						this.Const.World.TerrainType.Shore,
						this.Const.World.TerrainType.Ocean,
						this.Const.World.TerrainType.Mountains
					], false);
					tile.clear();
					this.Contract.m.Location = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/bandit_hideout_location", tile.Coords));
					this.Contract.m.Location.setResources(0);
					this.Contract.m.Location.setBanner("banner_deserters");
					this.Contract.m.Location.getSprite("location_banner").Visible = false;
					this.Contract.m.Location.setName(this.Flags.get("LocationName"));
					this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).addSettlement(this.Contract.m.Location.get(), false);
					this.Contract.m.Location.setDiscovered(true);
					this.World.uncoverFogOfWar(this.Contract.m.Location.getTile().Pos, 400.0);
					this.Contract.m.Location.clearTroops();
					this.Const.World.Common.addTroop(this.Contract.m.Location, {
						Type = this.Const.World.Spawn.Troops.BanditMarksmanLOW
					}, false);
					this.Const.World.Common.addTroop(this.Contract.m.Location, {
						Type = this.Const.World.Spawn.Troops.BanditThug
					}, false);
					this.Const.World.Common.addTroop(this.Contract.m.Location, {
						Type = this.Const.World.Spawn.Troops.BanditThug
					}, false);

					if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Normal)
					{
						this.Const.World.Common.addTroop(this.Contract.m.Location, {
							Type = this.Const.World.Spawn.Troops.BanditThug
						}, false);
					}

					if (this.World.Assets.getCombatDifficulty() >= this.Const.Difficulty.Hard)
					{
						this.Const.World.Common.addTroop(this.Contract.m.Location, {
							Type = this.Const.World.Spawn.Troops.BanditThug
						}, false);
					}

					this.Contract.m.Location.updateStrength();
					this.Contract.setScreen("Briefing");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Finale",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = false;

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.BigCity != null && !this.Contract.m.BigCity.isNull())
				{
					this.Contract.m.BigCity.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
				{
					this.Contract.m.Location.setOnCombatWithPlayerCallback(this.onLocationAttacked.bindenv(this));
				}

				this.Contract.m.BulletpointsObjectives = [
					"Voyagez jusqu\'?? %location% %direction% of %townname%",
					"Tuez %boss%"
				];
				this.Contract.m.BulletpointsPayment = [
					"Vous recevez 400 Couronnes ?? l\'ach??vement du contrat"
				];
				this.World.State.getPlayer().setAttackable(false);
			}

			function update()
			{
				if (this.World.getTime().Days > 8)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.Flags.has("IsHoggartDead") || this.Contract.m.Location == null || this.Contract.m.Location.isNull() || !this.Contract.m.Location.isAlive())
				{
					if (this.Contract.m.Location != null && !this.Contract.m.Location.isNull())
					{
						this.Contract.m.Location.die();
						this.Contract.m.Location = null;
					}

					this.Contract.setScreen("AfterFinale");
					this.World.Contracts.showActiveContract();
				}
			}

			function onLocationAttacked( _dest, _isPlayerAttacking = true )
			{
				local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				properties.Music = this.Const.Music.BanditTracks;
				properties.BeforeDeploymentCallback = this.onDeployment.bindenv(this);
				this.World.Contracts.startScriptedCombat(properties, true, true, true);
			}

			function onDeployment()
			{
				this.Tactical.getTileSquare(21, 17).removeObject();
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_raider_low", 21, 17 - 21 / 2);
				e.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
				e.setName(this.Flags.get("BossName"));
				e.m.IsGeneratingKillName = false;
				e.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
				e.getFlags().add("IsFinalBoss", true);
				local items = e.getItems();
				items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
				items.equip(this.new("scripts/items/weapons/falchion"));
				local shield = this.new("scripts/items/shields/wooden_shield");
				shield.setVariant(4);
				items.equip(shield);
				e.getSprite("head").setBrush(this.Flags.get("BossHead"));
				e.getSprite("beard").setBrush(this.Flags.get("BossBeard"));
				e.getSprite("beard_top").setBrush(this.Flags.get("BossBeardTop"));
				e.getSprite("hair").setBrush(this.Flags.get("BossHair"));
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsFinalBoss") == true)
				{
					this.Flags.set("IsHoggartDead", true);
					this.updateAchievement("TrialByFire", 1, 1);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.BigCity.getSprite("selection").Visible = false;
				this.Contract.m.BulletpointsObjectives = [
					"Retournez voir %employer% dans %townname% pour ??tre pay??"
				];
				this.World.State.getPlayer().setAttackable(false);
			}

			function update()
			{
				if (this.World.getTime().Days > 10)
				{
					this.World.State.getPlayer().setAttackable(true);
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsCampingTipShown") && this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() >= 10.0)
				{
					this.Flags.set("IsCampingTipShown", true);
					this.Contract.setScreen("CampingTip");
					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.m.Screens.push({
			ID = "Intro",
			Title = "La Derni??re Bataille",
			Text = "[img]gfx/ui/events/event_21.png[/img]Tout est parti en vrille. Deux jours plus t??t la compagnie a ??t?? engag??e pour traquer %boss% et sa bande de voleurs, mais ce sont eux qui nous ont trouv??s en premier. Une embuscade. Des blagues sur les chevaux, coup??es court par une fl??che dans la gorge. Des fl??ches venant de partout et nulle part en m??me temps. Des hommes hurlant, un doux son face ?? la mort.\n\nEn voyant la pluie de fl??ches s\'arr??ter, vous sortez votre arme et vos compagnons font de m??me, enfin pour ceux qui sont vivants... Vous tombez ?? genoux. Une fl??che a perc?? votre flanc. Vous hurlez de douleur. Un regard rapide o?? vous voyez vos hommes charger sans vous dans un dernier effort, l\'acier se heurt ?? l\'acier.\n\nVos yeux et ceux du capitaine se rencontrent, un dernier acquiescement de la t??te avant que sa gorge ne soit tranch??e. Vous ??tes laiss?? aux commandes des derniers hommes encore en vie. Tremblant de douleur, vous vous appuyez sur votre ??p??e et avec toute la d??termination que vous pouvez rassembler vous vous relevez encore...",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Jusqu\'?? la mort!",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "IntroAftermath",
			Title = "La suite",
			Text = "[img]gfx/ui/events/event_22.png[/img]Vous ??tes en vie. Vous avez gagn??.\n\nEn sentant l\'adr??naline dispara??tre vous vous alongez par terre. En serrant les dents, vous cassez le manche de la fl??che. Votre torse se soul??ve, vous ??prouvez de la douleur en respirant, tout se trouble.\n\nLa companie a ??t?? d??vast??e, r??duite ?? seulement quelques hommes. Et ce connard d\'Hoggart a rendu justice ?? son nom, en fuyant tel la fouine qu\'il est.%SPEECH_ON%Et maintenant, capitaine?%SPEECH_OFF%Une voix dit derri??re vous. C\'est %bro2% qui s\'asseoit ?? c??t?? de vous, posant sa h??che ensanglant?? sur ses jambes. Vous vous tournez vers lui et lui r??pondez, mais avant que vous puissiez r??pondre il continue.%SPEECH_ON%Bernhard est mort. Ils lui ont tranch?? la gorge. Il ??tait un bon homme et un tr??s bon capitaine, mais il n\'aura fallu qu\'une seule erreur. Ce qui fait de toi celui aux commandes maintenant, n\'est-ce pas?%SPEECH_OFF%%bro3% se joint ?? vous deux, toujours en respirant lourdement. Puis %bro1%.%SPEECH_ON%Gardez la c??r??monie et les onctions pour un autre jour. Donnons une bonne s??pulture ?? nos camarades et retournons ?? %townname% r??cup??rer notre paie. Les hommes de la fouine sont mort apr??s tout. Et puis, capitaine, on devrait regarder cette blessure avant que nous vous perdions aussi. On voudrait pas laisser %bro3% aux commandes, pas vrai?%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qu\'il en soit ainsi.",
					function getResult()
					{
						this.Contract.setState("ReturnAfterIntro");
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.World.getPlayerRoster().getAll()[1].getImagePath());
				this.Characters.push(this.World.getPlayerRoster().getAll()[0].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "PaymentAfterIntro1",
			Title = "Retournez ?? %townname%",
			Text = "[img]gfx/ui/events/event_79.png[/img]Quel spectacle d??solant pour les villageois lorsque vous arrivez ?? %townname%. Quatres mercenaires ensanglant??s et fatigu?? qui n\'ont pas eu de chance. L\'homme qui vous a embauch?? deux jours plus t??t, %employer%, sans aucun doute s\'attendait ?? un retour plus glorieux.\n\nCependant, il vous acceuille chez lui et vous offre du pain et du vin pendant qu\'un servant va chercher un soigneur. Peu de mots sont ??chang??s ?? part quelques grognements occasionnel et la respiration du vieil homme avec les mains tremblantes qui s\'occupe de vos blessures. Une aiguille perce votre peau, la premi??re d\'une longue s??rie. Vous serre les dents jusqu\'?? ce que vous pensez en entendre une se casser. %employer% s\'assoit ?? c??t?? de vous et vous demande si vous vous ??tes bien occup?? de Hoggart. Vous dites non de la t??te.%SPEECH_ON%On a tu?? ses hommes, mais cette fouine a r??ussit ?? ??chapper ?? nos ??p??es ?? la fin.%SPEECH_OFF%Le soigneur agite une arme de m??tal incandescente, sugg??rant qu\'il veut l\'appliquer sur la plaie. Vous hochez de la t??te et il commence. Pendant un moment c\'est tout ce qu\'il y avait. Vous n\'??tes pas un homme, mais une pique de flamme, peau contre feu, un avatar de la douleur. %employer% vous tends un gobelet de vin.%SPEECH_ON%Vous avez bien travaill??, mercenaire. Les brigands ne sont plus, malgr?? le fait que Hoggart soit toujours en vie.%SPEECH_OFF%",
			Characters = [],
			ShowEmployer = true,
			List = [],
			Options = [
				{
					Text = "On esperait ??tre pay??s pour cela.",
					function getResult()
					{
						return "PaymentAfterIntro2";
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(400);
				this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "A tu?? les hommes de Hoggart");
			}

		});
		this.m.Screens.push({
			ID = "PaymentAfterIntro2",
			Title = "Retournez ?? %townname%",
			Text = "[img]gfx/ui/events/event_79.png[/img]%employer% vous regarde.%SPEECH_ON%Oui bien s??r, naturellement! 400 Couronnes comme convenu.%SPEECH_OFF%Il fait signe ?? un servant qui s\'empresse de venir vers vous avec la paie dans ses mains.%SPEECH_ON%Je me demandais... puis-je encore faire appel ?? vos services encore une fois? J\'aimerais vraiment de lib??r?? du probl??me qu\'est Hoggart une bonne fois pour toute. Et je vous paierais de nouveau, bien s??r. De nouveau 400 Couronnes, qu\'en d??tes vous?%SPEECH_OFF%%bro2% rigole et se tourne pour boire plus de vin, mais %bro1% se l??ve pour parler.%SPEECH_ON%Oui, la compagnie est en ruine, mais nous allons la reconstruire! Sans %companyname%, %bro2% boira les couronnes et finira par mendier dans les rues, et %bro3%, par les dieux nous savons tous qu\'ils passera son temps apr??s les femmes jusqu\'?? ce que l\'une d\'entre elle finisse par lui mettre la t??te dans le four. On a besoin de %companyname%, c\'est tout ce que nous avons! Qu\'en pensez vous capitaine?%SPEECH_OFF%%bro2% fait un rot puis l??ve son verre vers vous. %bro3% met sa main sur son nez et acquiesce.%SPEECH_ON%Que l\'on tue ce salaud d\'Hoggart ou non, ??a ne d??pend que de vous capitaine.%SPEECH_OFF%",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Oui, nous avons des affaires ?? r??gler avec Hoggart.",
					function getResult()
					{
						return "PaymentAfterIntro3";
					}

				},
				{
					Text = "Non, nous ferons fortune autre part.",
					function getResult()
					{
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.EmployerID).getImagePath());
				this.Characters.push(this.World.getPlayerRoster().getAll()[0].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "PaymentAfterIntro3",
			Title = "Retournez ?? %townname%",
			Text = "[img]gfx/ui/events/event_79.png[/img]%employer% frappe dans ses main de bonheur.%SPEECH_ON%Excellent! Mes hommes vont mettre un peu de temps ?? trouver o?? Hoggart se cache. Pendant ce temps, je vous sugg??re de faire le plein de provisions pour que vous soyez pr??t quand le moment viendra. On se revoit d\'ici quelques jours au plus tard!%SPEECH_OFF%En quittant la maison de %employer% et en vous rendant en bordure de %townname%, %bro1% souhaite vous parler.%SPEECH_ON%Nous avons besoin de plus d\'hommes capitaine. Je sais que j\'ai donn?? un beau discours tout ?? l\'heure mais la bravoure n\'y changera rien. Nous avons besoin de plus de personnes dans les rangs. Je pense que trois hommes serait un bon d??but, achetez quelques armes d??centes, et habillez les de la meilleure armures que vous puissiez.%SPEECH_OFF%L\'homme s\'arr??te et regarde autour.%SPEECH_ON%Je suis s??r que dans cette ville perdu, nous trouverons un ou deux paysans cherchant une nouvelle vie. Sinon nou pourrions aller jusqu\'?? %bigcity% %citydirection%. Les gens de cette ville ne seront probablement pas aussi endurcis que ces gens de la campagne, mais on aura probablement plus de chance de tomber sur des hommes avec un peu d\'exp??riencee qui se sont arr??t??s l?? bas pour se reposer.%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est ce que nous devrions faire.",
					function getResult()
					{
						this.Contract.setState("Recruit");
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Tactical.getEntityByID(this.Contract.m.EmployerID).getImagePath());
				this.Characters.push(this.World.getPlayerRoster().getAll()[0].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "MarketplaceTip",
			Title = "Sur la route",
			Text = "[img]gfx/ui/events/event_77.png[/img]Au m??me moment que vous commencez ?? apercevoir %bigcity% au niveau de l\'horizon, %bro3% souhaite vous parler.%SPEECH_ON%Je suis jamais all?? ?? %bigcity% avant, mais je suis d??j?? all?? dans d\'autres qui y ressemblait. Les villes comme celles-ci sont bien pour vendre des biens ?? ces personnes pr??tentieuses et pompeuses adorent se faire livre leur choses dont ils ont besoin. Avec autant de marchands vous y trouverez aussi tout ce que vous voulez. Gardez un oeil alerte pour les bonnes affaires et ne vous faites pas avoir par les marchands.%SPEECH_OFF%%bro2% juge bon de partager son opinion de ce que vous devriez faire.%SPEECH_ON%S\'il y a une bonne taverne, je dirais qu\'il faudrait y aller en premier. Rien n\'aide plus la chance d\'un homme que de boire une bonne peinte. Et dieu sait que nous l\'aurions m??rit??!%SPEECH_OFF%%bro3% secoue sa t??te.%SPEECH_ON%Tu dis ??a ?? chaque fois que l\'on s\'arr??te dans une ville! Tu le dis m??me quand tu es compl??tement bourr??!%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je garderais ??a ?? l\'esprit.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() >= 3)
				{
					this.Characters.push(this.World.getPlayerRoster().getAll()[2].getImagePath());
					this.Characters.push(this.World.getPlayerRoster().getAll()[1].getImagePath());
				}
			}

		});
		this.m.Screens.push({
			ID = "Briefing",
			Title = "Affaires inachev??es",
			Text = "[img]gfx/ui/events/event_79.png[/img]%employer% est en train de faire les cent pas quand vous le trouvez. Le guerisseur qui vous a presque tu?? avec la barre de m??tal en fusion se tient pas tr??s loin. Il est en train de retirer des morceaux de sang coinc??s sous ses ongles. %employer% frappe dans ses mains.%SPEECH_ON%Enfin, vous ??tes l??. J\'ai de bonnes nouvelles ! Nous avons mis la main sur l\'un des anciens hommes de Hoggart ! Mon ami ici pr??sent a eu une petite discussion avec l\'homme et maintenant je sais o?? Hoggart panse ses blessures.%SPEECH_OFF%Le gu??risseur s\'??claircit la gorge, ??cartant ses doigts comme une jeune fille qui cherche ?? se mettre du vernis. Il parle comme s\'il identifiait une maladie qu\'il est sur le point d\'extirper.%SPEECH_ON%Le brigand connu sous le nom de Hoggart se cache dans une petite hutte %terrain% %direction% d\'ici. D\'apr??s la discussion que j\'ai eu avec l\'un de ses hommes, Hoggart sait que %companyname% est sur ses talons et que vous aurez rassembl?? plus d\'hommes depuis la derni??re fois que vous l\'avez rencontr??.%SPEECH_OFF%En hochant la t??te, %employer% vous fait signe de partir.%SPEECH_ON%Bonne chance, mercenaire.%SPEECH_OFF%",
			ShowEmployer = true,
			List = [],
			Options = [
				{
					Text = "Nous reviendrons avec sa t??te !",
					function getResult()
					{
						this.Contract.setState("Finale");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AfterFinale",
			Title = "Apr??s la bataille",
			Text = "[img]gfx/ui/events/event_87.png[/img]Hoggart g??t mort dans une mare de son propre sang, embroch?? dans une pose grotesque et paniqu??e. Il n\'a pas r??ussi ?? s\'en sortir. Vous posez une botte sur son cadavre et regardez vos hommes.%SPEECH_ON%Pour la compagnie. Pour tous les hommes qui sont tomb??s.%SPEECH_OFF%%bro3% crache sur le visage de l\'homme mort.%SPEECH_ON%Prenons la t??te de ce b??tard et retournons ?? %townname%%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il est temps d\'??tre pay??.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() >= 3)
				{
					this.Characters.push(this.World.getPlayerRoster().getAll()[2].getImagePath());
				}
			}

		});
		this.m.Screens.push({
			ID = "CampingTip",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_75.png[/img]%bro3% rejoint votre ??quipe.%SPEECH_ON%Vous avez un moment, capitaine ?%SPEECH_OFF%Vous acquiescez pour qu\'il dise ce qu\'il pense.%SPEECH_ON%La bataille a laiss?? des ??quipements en mauvais ??tat et certains hommes ont re??u une bonne racl??e. Nous pouvons soigner les hommes et r??parer l\'??quipement tout en marchant, mais c\'est beaucoup plus rapide si on s\'arr??te pour le faire. Bien s??r, si nous montons le camp, nous devons nous m??fier des embuscades. Un feu de camp dans ces r??gions peut ??tre vu de tr??s loin.%SPEECH_OFF%",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je vais garder ??a en t??te.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() >= 3)
				{
					this.Characters.push(this.World.getPlayerRoster().getAll()[2].getImagePath());
				}
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "Retourner ?? %townname%",
			Text = "[img]gfx/ui/events/event_24.png[/img]L\'??quipe revient ?? %townname% en vainqueur, la t??te bien plus haute cette fois-ci. Les %companyname% n\'ont plus l\'aura qu\'elles avaient autrefois, mais ils sont toujours une force avec laquelle il faut compter, comme Hoggart l\'a appris dans ses derniers moments.\n\nVous portez sa t??te dans un sac que vous videz devant les pieds de %employer%. Il sursaute, mais le gu??risseur ramasse rapidement la t??te, la fixe et acquiesce. %employer% s\'approche du visage ensanglant?? du brigand et le regarde attentivement.%SPEECH_ON%Oui, oui... C\'est bien sa sale gueule. Serviteurs ! Payez son argent ?? cet homme!%SPEECH_OFF%L\'argent en poche, vous ??levez la voix vers les hommes.%SPEECH_ON%Tant que le sang coule dans nos veines, tant que nous pouvons tenir l\'??p??e et le bouclier, notre compagnie sera l??. Partout dans le royaume, les gens conna??tront  %companyname%!%SPEECH_OFF%Les hommes applaudissent. %bro1% pose sa main sur votre ??paule.%SPEECH_ON%Vous avez bien fait, capitaine. O?? que vous nous meniez, les hommes vous suivront comme des fr??res de bataille.%SPEECH_OFF%",
			ShowEmployer = true,
			Image = "",
			List = [],
			Options = [
				{
					Text = "Comme des fr??res!",
					function getResult()
					{
						this.World.Flags.set("IsHoggartDead", true);
						this.Music.setTrackList(this.Const.Music.WorldmapTracks, this.Const.Music.CrossFadeTime, true);
						this.World.Assets.addMoney(400);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Killed Hoggart for good");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Music.setTrackList(this.Const.Music.VictoryTracks, this.Const.Music.CrossFadeTime);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.companion")
					{
						bro.improveMood(1.0, "Avenged the company");
					}
					else
					{
						bro.improveMood(0.25, "Gained confidence in your leadership");
					}
				}

				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]400[/color] Couronnes"
				});
			}

		});
	}

	function spawnCorpse( _x, _y )
	{
		local tile = this.Tactical.getTileSquare(_x, _y);
		local armors = [
			"bust_body_10_dead",
			"bust_body_13_dead",
			"bust_body_14_dead",
			"bust_body_15_dead",
			"bust_body_19_dead",
			"bust_body_20_dead",
			"bust_body_22_dead",
			"bust_body_23_dead",
			"bust_body_24_dead",
			"bust_body_26_dead"
		];
		local armorSprite = armors[this.Math.rand(0, armors.len() - 1)];
		local flip = this.Math.rand(0, 1) == 1;
		local decal = tile.spawnDetail(armorSprite, this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
		decal.Scale = 0.9;
		decal.setBrightness(0.9);
		decal = tile.spawnDetail("bust_naked_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
		decal.Scale = 0.9;
		decal.setBrightness(0.9);

		if (this.Math.rand(1, 100) <= 25)
		{
			decal = tile.spawnDetail("bust_body_guts_0" + this.Math.rand(1, 3), this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
		}
		else if (this.Math.rand(1, 100) <= 25)
		{
			decal = tile.spawnDetail("bust_head_smashed_01", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
		}
		else
		{
			decal = tile.spawnDetail(armorSprite + "_arrows", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
		}

		local color = this.Const.HairColors.All[this.Math.rand(0, this.Const.HairColors.All.len() - 1)];
		local hairSprite = "hair_" + color + "_" + this.Const.Hair.AllMale[this.Math.rand(0, this.Const.Hair.AllMale.len() - 1)];
		local beardSprite = "beard_" + color + "_" + this.Const.Beards.All[this.Math.rand(0, this.Const.Beards.All.len() - 1)];
		local headSprite = this.Const.Faces.AllMale[this.Math.rand(0, this.Const.Faces.AllMale.len() - 1)];
		local decal = tile.spawnDetail(headSprite + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
		decal.Scale = 0.9;
		decal.setBrightness(0.9);

		if (this.Math.rand(1, 100) <= 50)
		{
			local decal = tile.spawnDetail(beardSprite + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
		}

		if (this.Math.rand(1, 100) <= 90)
		{
			local decal = tile.spawnDetail(hairSprite + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false, this.Const.Combat.HumanCorpseOffset);
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
		}

		local pools = this.Math.rand(this.Const.Combat.BloodPoolsAtDeathMin, this.Const.Combat.BloodPoolsAtDeathMax);

		for( local i = 0; i < pools; i = ++i )
		{
			this.Tactical.spawnPoolEffect(this.Const.BloodPoolDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodPoolDecals[this.Const.BloodType.Red].len() - 1)], tile, this.Const.BloodPoolTerrainAlpha[tile.Type], 1.0, this.Const.Tactical.DetailFlag.Corpse);
		}

		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = "Someone";
		tile.Properties.set("Corpse", corpse);
	}

	function spawnBlood( _x, _y )
	{
		local tile = this.Tactical.getTileSquare(_x, _y);
		tile.spawnDetail(this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)]);
	}

	function spawnArrow( _x, _y )
	{
		local tile = this.Tactical.getTileSquare(_x, _y);
		tile.spawnDetail(this.Const.ProjectileDecals[this.Const.ProjectileType.Arrow][this.Math.rand(0, this.Const.ProjectileDecals[this.Const.ProjectileType.Arrow].len() - 1)], 0, true);
	}

	function onPrepareVariables( _vars )
	{
		local bros = this.World.getPlayerRoster().getAll();
		_vars.push([
			"location",
			this.m.Flags.get("LocationName")
		]);
		_vars.push([
			"bigcity",
			this.m.BigCity.getName()
		]);
		_vars.push([
			"boss",
			this.m.Flags.get("BossName")
		]);
		_vars.push([
			"direction",
			this.m.Location != null && !this.m.Location.isNull() ? this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Location.getTile())] : ""
		]);
		_vars.push([
			"citydirection",
			this.m.BigCity != null && !this.m.BigCity.isNull() ? this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.BigCity.getTile())] : ""
		]);
		_vars.push([
			"terrain",
			this.m.Location != null && !this.m.Location.isNull() ? this.Const.Strings.Terrain[this.m.Location.getTile().Type] : ""
		]);
		_vars.push([
			"bro1",
			bros[0].getName()
		]);
		_vars.push([
			"bro2",
			bros.len() >= 2 ? bros[1].getName() : bros[0].getName()
		]);
		_vars.push([
			"bro3",
			bros.len() >= 3 ? bros[2].getName() : bros[0].getName()
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			if (this.m.BigCity != null && !this.m.BigCity.isNull())
			{
				this.m.BigCity.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
			this.World.Ambitions.setDelay(12);
		}

		this.World.State.getPlayer().setAttackable(true);
		this.World.State.m.IsAutosaving = true;
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.BigCity != null && !this.m.BigCity.isNull())
		{
			_out.writeU32(this.m.BigCity.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		local bigCity = _in.readU32();

		if (bigCity != 0)
		{
			this.m.BigCity = this.WeakTableRef(this.World.getEntityByID(bigCity));
		}

		this.contract.onDeserialize(_in);
	}

});

