this.privateering_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Item = null,
		CurrentObjective = null,
		Objectives = [],
		LastOrderUpdateTime = 0.0
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.privateering";
		this.m.Name = "Déléguer";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

		foreach( i, h in nobleHouses )
		{
			if (h.getID() == this.getFaction())
			{
				nobleHouses.remove(i);
				break;
			}
		}

		nobleHouses.sort(this.onSortBySettlements);
		this.m.Flags.set("FeudingHouseID", nobleHouses[0].getID());
		this.m.Flags.set("FeudingHouseName", nobleHouses[0].getName());
		this.m.Flags.set("RivalHouseID", nobleHouses[1].getID());
		this.m.Flags.set("RivalHouseName", nobleHouses[1].getName());
		this.m.Payment.Pool = 1300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Score", 0);
		this.m.Flags.set("StartDay", 0);
		this.m.Flags.set("LastUpdateDay", 0);
		this.m.Flags.set("SearchPartyLastNotificationTime", 0);
		this.contract.start();
	}

	function onSortBySettlements( _a, _b )
	{
		if (_a.getSettlements().len() > _b.getSettlements().len())
		{
			return -1;
		}
		else if (_a.getSettlements().len() < _b.getSettlements().len())
		{
			return 1;
		}

		return 0;
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Flags.set("StartDay", this.World.getTime().Days);
				this.Contract.m.BulletpointsObjectives = [
					"Voyagez jusqu\'aux terres de %feudfamily%",
					"Attaquez et brulez des endroits",
					"Détruisez toutes les patrouilles et les caravanes",
					"Revenez après 5 jours"
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
				local f = this.World.FactionManager.getFaction(this.Flags.get("FeudingHouseID"));
				f.addPlayerRelation(-99.0, "A pris parti dans la guerre");
				this.Flags.set("StartDay", this.World.getTime().Days);
				local nonIsolatedSettlements = [];

				foreach( s in f.getSettlements() )
				{
					if (s.isIsolated() || !s.isDiscovered())
					{
						continue;
					}

					nonIsolatedSettlements.push(s);
					local a = s.getActiveAttachedLocations();

					if (a.len() == 0)
					{
						continue;
					}

					local obj = a[this.Math.rand(0, a.len() - 1)];
					this.Contract.m.Objectives.push(this.WeakTableRef(obj));
					obj.clearTroops();

					if (s.isMilitary())
					{
						if (obj.isMilitary())
						{
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Noble, this.Math.rand(90, 120) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						}
						else
						{
							local r = this.Math.rand(1, 100);

							if (r <= 10)
							{
								this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Mercenaries, this.Math.rand(90, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							}
							else
							{
								this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Noble, this.Math.rand(70, 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							}
						}
					}
					else if (obj.isMilitary())
					{
						this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Militia, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
					else
					{
						local r = this.Math.rand(1, 100);

						if (r <= 15)
						{
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Mercenaries, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						}
						else if (r <= 30)
						{
							obj.getFlags().set("HasNobleProtection", true);
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Noble, this.Math.rand(80, 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						}
						else if (r <= 70)
						{
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Militia, this.Math.rand(70, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						}
						else
						{
							this.Contract.addUnitsToEntity(obj, this.Const.World.Spawn.Peasants, this.Math.rand(70, 100));
						}
					}

					if (this.Contract.m.Objectives.len() >= 3)
					{
						break;
					}
				}

				local origin = nonIsolatedSettlements[this.Math.rand(0, nonIsolatedSettlements.len() - 1)];
				local party = f.spawnEntity(origin.getTile(), origin.getName() + " Compagnie", true, this.Const.World.Spawn.Noble, 190 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
				party.setDescription("Soldats professionnels au service des seigneurs locaux.");
				this.Contract.m.UnitsSpawned.push(party.getID());
				party.getLoot().Money = this.Math.rand(50, 200);
				party.getLoot().ArmorParts = this.Math.rand(0, 25);
				party.getLoot().Medicine = this.Math.rand(0, 3);
				party.getLoot().Ammo = this.Math.rand(0, 30);
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/roots_and_berries_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/dried_fruits_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/ground_grains_item");
				}

				local c = party.getController();
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
				local r = this.Math.rand(1, 100);

				if (r <= 15)
				{
					local rival = this.World.FactionManager.getFaction(this.Flags.get("RivalHouseID"));

					if (!f.getFlags().get("Betrayed"))
					{
						this.Flags.set("IsChangingSides", true);
						local i = this.Math.rand(1, 18);
						local item;

						if (i == 1)
						{
							item = this.new("scripts/items/weapons/named/named_axe");
						}
						else if (i == 2)
						{
							item = this.new("scripts/items/weapons/named/named_billhook");
						}
						else if (i == 3)
						{
							item = this.new("scripts/items/weapons/named/named_cleaver");
						}
						else if (i == 4)
						{
							item = this.new("scripts/items/weapons/named/named_crossbow");
						}
						else if (i == 5)
						{
							item = this.new("scripts/items/weapons/named/named_dagger");
						}
						else if (i == 6)
						{
							item = this.new("scripts/items/weapons/named/named_flail");
						}
						else if (i == 7)
						{
							item = this.new("scripts/items/weapons/named/named_greataxe");
						}
						else if (i == 8)
						{
							item = this.new("scripts/items/weapons/named/named_greatsword");
						}
						else if (i == 9)
						{
							item = this.new("scripts/items/weapons/named/named_javelin");
						}
						else if (i == 10)
						{
							item = this.new("scripts/items/weapons/named/named_longaxe");
						}
						else if (i == 11)
						{
							item = this.new("scripts/items/weapons/named/named_mace");
						}
						else if (i == 12)
						{
							item = this.new("scripts/items/weapons/named/named_spear");
						}
						else if (i == 13)
						{
							item = this.new("scripts/items/weapons/named/named_sword");
						}
						else if (i == 14)
						{
							item = this.new("scripts/items/weapons/named/named_throwing_axe");
						}
						else if (i == 15)
						{
							item = this.new("scripts/items/weapons/named/named_two_handed_hammer");
						}
						else if (i == 16)
						{
							item = this.new("scripts/items/weapons/named/named_warbow");
						}
						else if (i == 17)
						{
							item = this.new("scripts/items/weapons/named/named_warbrand");
						}
						else if (i == 18)
						{
							item = this.new("scripts/items/weapons/named/named_warhammer");
						}

						item.onAddedToStash("");
						this.Contract.m.Item = item;
					}
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [];

				foreach( obj in this.Contract.m.Objectives )
				{
					if (obj != null && !obj.isNull() && obj.isActive())
					{
						this.Contract.m.BulletpointsObjectives.push("Détruisez " + obj.getName() + " près de " + obj.getSettlement().getName());
						obj.getSprite("selection").Visible = true;
						obj.setAttackable(true);
						obj.setOnCombatWithPlayerCallback(this.onCombatWithLocation.bindenv(this));
					}
				}

				this.Contract.m.BulletpointsObjectives.push("Détruisez toutes les caravanes ou les patrouille de %feudfamily%");
				this.Contract.m.BulletpointsObjectives.push("Revenez dans %days%");
				this.Contract.m.CurrentObjective = null;
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("TimeIsUp");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.m.UnitsSpawned.len() != 0 && this.Time.getVirtualTimeF() - this.Contract.m.LastOrderUpdateTime > 2.0)
				{
					this.Contract.m.LastOrderUpdateTime = this.Time.getVirtualTimeF();
					local party = this.World.getEntityByID(this.Contract.m.UnitsSpawned[0]);
					local playerTile = this.World.State.getPlayer().getTile();

					if (party != null && party.getTile().getDistanceTo(playerTile) > 3)
					{
						local f = this.World.FactionManager.getFaction(this.Flags.get("FeudingHouseID"));
						local nearEnemySettlement = false;

						foreach( s in f.getSettlements() )
						{
							if (s.getTile().getDistanceTo(playerTile) <= 6)
							{
								nearEnemySettlement = true;
								break;
							}
						}

						if (nearEnemySettlement)
						{
							local c = party.getController();
							c.clearOrders();
							local move = this.new("scripts/ai/world/orders/move_order");
							move.setDestination(this.World.State.getPlayer().getTile());
							c.addOrder(move);
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(this.World.getTime().SecondsPerDay * 1);
							c.addOrder(wait);

							if (party.getTile().getDistanceTo(playerTile) <= 8 && this.Time.getVirtualTimeF() - this.Flags.get("SearchPartyLastNotificationTime") >= 300.0)
							{
								this.Flags.set("SearchPartyLastNotificationTime", this.Time.getVirtualTimeF());
								this.Contract.setScreen("SearchParty");
								this.World.Contracts.showActiveContract();
							}
						}
					}
				}

				if (this.Flags.get("IsChangingSides") && this.Contract.getDistanceToNearestSettlement() >= 5 && this.World.State.getPlayer().getTile().HasRoad && this.Math.rand(1, 1000) <= 1)
				{
					this.Flags.set("IsChangingSides", false);
					this.Contract.setScreen("ChangingSides");
					this.World.Contracts.showActiveContract();
				}

				foreach( i, obj in this.Contract.m.Objectives )
				{
					if (obj != null && !obj.isNull() && !obj.isActive() || obj.getSettlement().getOwner().isAlliedWithPlayer() || obj.isAlliedWithPlayer())
					{
						obj.getSprite("selection").Visible = false;
						obj.setAttackable(false);
						obj.getFlags().set("HasNobleProtection", false);
						obj.setOnCombatWithPlayerCallback(null);
					}

					if (obj == null || obj.isNull() || !obj.isActive() || obj.getSettlement().getOwner().isAlliedWithPlayer() || obj.isAlliedWithPlayer())
					{
						this.Contract.m.Objectives.remove(i);
						this.Flags.set("LastUpdateDay", 0);
						break;
					}
				}
			}

			function onCombatWithLocation( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.CurrentObjective = _dest;

				if (_dest.getTroops().len() == 0)
				{
					this.onCombatVictory("RazeLocation");
					return;
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "RazeLocation";
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.Template[0] = "tactical.human_camp";
					p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
					p.LocationTemplate.CutDownTrees = true;
					p.LocationTemplate.AdditionalRadius = 5;

					if (_dest.isMilitary())
					{
						p.Music = this.Const.Music.NobleTracks;
					}
					else
					{
						p.Music = this.Const.Music.CivilianTracks;
					}

					p.EnemyBanners = [];

					if (_dest.getSettlement().isMilitary() || _dest.getFlags().get("HasNobleProtection"))
					{
						p.EnemyBanners.push(_dest.getSettlement().getBanner());
					}
					else
					{
						p.EnemyBanners.push("banner_noble_11");
					}

					if (_dest.getFlags().get("HasNobleProtection"))
					{
						local f = this.Flags.get("FeudingHouseID");

						foreach( e in p.Entities )
						{
							if (e.Faction == _dest.getFaction())
							{
								e.Faction = f;
							}
						}
					}

					this.World.Contracts.startScriptedCombat(p, _isPlayerAttacking, true, true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "RazeLocation")
				{
					this.Contract.m.CurrentObjective.setActive(false);
					this.Contract.m.CurrentObjective.spawnFireAndSmoke();
					this.Contract.m.CurrentObjective.clearTroops();
					this.Contract.m.CurrentObjective.getSprite("selection").Visible = false;
					this.Contract.m.CurrentObjective.setOnCombatWithPlayerCallback(null);
					this.Contract.m.CurrentObjective.setAttackable(false);
					this.Contract.m.CurrentObjective.getFlags().set("HasNobleProtection", false);
					this.Flags.set("Score", this.Flags.get("Score") + 5);

					foreach( i, obj in this.Contract.m.Objectives )
					{
						if (obj.getID() == this.Contract.m.CurrentObjective.getID())
						{
							this.Contract.m.Objectives.remove(i);
							break;
						}
					}

					this.Flags.set("LastUpdateDay", 0);
				}
			}

			function onPartyDestroyed( _party )
			{
				if (_party.getFaction() == this.Flags.get("FeudingHouseID") || this.World.FactionManager.isAllied(_party.getFaction(), this.Flags.get("FeudingHouseID")))
				{
					this.Flags.set("Score", this.Flags.get("Score") + 2);
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

				foreach( obj in this.Contract.m.Objectives )
				{
					if (obj != null && !obj.isNull() && obj.isActive())
					{
						obj.getSprite("selection").Visible = false;
						obj.setOnCombatWithPlayerCallback(null);
					}
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("Score") <= 9)
					{
						this.Contract.setScreen("Failure1");
					}
					else if (this.Flags.get("Score") <= 15)
					{
						this.Contract.setScreen("Success1");
					}
					else
					{
						this.Contract.setScreen("Success2");
					}

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
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Vous entrez dans la pièce de %employer% et il commence immédiatement à parler.%SPEECH_ON%{Content de te voir, mercenaire. J\'ai besoin d\'une bande de pillards pour mettre le bazar dans les affaires de %feudfamily%, si tu vois ce que je veux dire. Non? Eh bien, en gros, j\'ai besoin que tu ailles dans leurs territoires et que tu incendies tout ce que tu peux trouver. Je dirais que %days% de cela fera vraiment des dégâts à leurs efforts de guerre. Et sois très, très prudent face aux patrouilles ennemies. | Ah, mercenaire. Regarde, j\'ai besoin d\'hommes robustes pour aller dans le territoire de %feudfamily% et brûler chaque caravane et chaque récolte qu\'ils trouvent. Ce n\'est pas le travail le plus honorable, mais des efforts comme ceux-ci contribueront à mettre fin à la guerre. Je dirais de passer %days% là-bas, puis de revenir. | J\'ai besoin de pillards pour plonger dans le territoire de %feudfamily% pendant %days% et détruire autant de leurs ressources que possible. Vous serez haïs et ils viendront après vous rapidement et violemment, mais si vous pouvez éviter leurs patrouilles, le travail devrait être rapide et facile. Qu\'en dis-tu ? | Nous sommes en guerre avec %feudfamily%, mais les guerres demandent un peu plus que des armées qui s\'affrontent. Parfois, elles exigent un peu de subterfuge. Ce dont j\'ai besoin, mercenaire, c\'est que tu attaques leurs territoires pendant %days%. Détruis les caravanes, brûle les fermes, tout ce qui aidera la cause de la guerre. Bien sûr, méfie-toi des patrouilles ennemies. Je sais que si tu venais après mes terres et mes gens, je viendrais deux fois plus fort après toi. Alors, qu\'en dis-tu ? | Soyons brefs. J\'ai besoin de quelqu\'un pour attaquer les territoires de %feudfamily% pendant %days%. Bien sûr, ils s\'attendront à des hommes comme toi, alors je travaillerais dur pour éviter toute patrouille pendant que tu es là-bas. Ça t\'intéresse ? | J\'ai le boulot parfait pour toi, mercenaire. J\'ai besoin que tu attaques les territoires de %feudfamily% et que tu détruises autant que possible pendant environ %days%. Des efforts comme ceux-ci peuvent contribuer à mettre fin aux guerres. Bien sûr, ils comprendront aussi ce petit fait, et feront tout en leur pouvoir pour t\'arrêter.}%SPEECH_OFF% | %employer% vous accueille dans sa pièce et montre une carte étalée sur une table.%SPEECH_ON%Saviez-vous que l\'une des meilleures façons de combattre un homme est de s\'assurer qu\'il est incapable de se battre du tout? J\'ai lu ça dans un vieux livre.%SPEECH_OFF%Une vision très artistique de la guerre, mais vraie. Vous hochez la tête. L\'homme continue.%SPEECH_ON%Je veux que tu ailles dans les terres de %feudfamily% et que tu détruises autant que possible de leur territoire. Détruis les caravanes, brûle les fermes, tu vois l\'idée. Fais autant de dégâts que possible en %days% et ensuite rentre. Oh, une dernière chose. Méfie-toi des patrouilles ennemies. Elles ne prendront pas gentiment tes... incursions.%SPEECH_OFF% | Vous trouvez %employer% en train de feuilleter un livre. Il prend des notes avec une plume.%SPEECH_ON%Mon grand-père a autrefois vaincu une armée dix fois plus grande que la sienne. Comment a-t-il fait ? Les historiens et les scribes, qui sont payés et nourris par ma famille, racontent des histoires de grandeur sur le champ de bataille. Mais ce n\'est pas la vérité. Tu connais la vérité ?%SPEECH_OFF%Vous haussez les épaules et supposez que le grand-père a utilisé une forme de subterfuge. Le noble claque le livre et pointe brièvement du doigt.%SPEECH_ON%Exactement ! Il a pris une poignée d\'hommes et a brûlé toutes leurs fermes, greniers et magasins de nourriture. À quoi sert une armée aussi grande si vous ne pouvez pas la nourrir ? J\'ai besoin que tu fasses la même chose, mercenaire. Va dans les territoires de %feudfamily% pendant %days% et détruis autant que possible. Évite les patrouilles, bien sûr. Elles ne prendront pas gentiment tes... excursions.%SPEECH_OFF% | Vous entrez dans la pièce de %employer% pour le trouver en conflit avec un très vieux général. Le commandant se redresse.%SPEECH_ON%Je ne salirai pas le nom de ma famille avec de telles actions déplorables. Trouvez quelque paysan de basse naissance pour le faire si vous voulez emprunter cette voie !%SPEECH_OFF%Le commandant prend ses affaires et part en bougonnant, vous tournant le nez alors qu\'il s\'en va. %employer% sourit quand vous entrez. Il ouvre ses bras et parle.%SPEECH_ON%Eh bien, parlez du diable très nécessaire. Mercenaire, j\'ai besoin de quelqu\'un pour attaquer le territoire de %feudfamily% pendant %days%. Mes nobles commandants pensent que c\'est en dessous d\'eux, mais je pense que tu t\'en sortiras très bien. Bien sûr, nos ennemis penseront que c\'est en dessous d\'eux aussi, alors si ils te trouvent, sois prêt parce qu\'ils viendront particulièrement fort.%SPEECH_OFF% | %employer% fixe un lait renversé qui coule sur sa table et goutte sur le bord.%SPEECH_ON%Avez-vous déjà eu une journée ruinée par quelque chose de très simple comme ça ?%SPEECH_OFF%Vous hochez la tête. Qui n\'a pas ? L\'homme continue.%SPEECH_ON%Mon intention était de faire du fromage, mais maintenant je ne peux pas parce que les ingrédients ont été ruinés. Mercenaire, cette maxime prompte et totalement fortuite s\'applique également à la guerre. J\'ai besoin que tu attaques le territoire de %feudfamily% et, pour parler métaphoriquement, que tu renverses leur lait : détruis les caravanes, brûle les fermes, effondre les mines, tout ce qu\'il faut. %days% de ce genre de travail devraient faire l\'affaire. Bien sûr, méfie-toi de leurs patrouilles pendant que tu es là-bas. Je serais sûr à cent pour cent de chercher à mettre ta tête sur une pique si tu faisais ces choses dans mes territoires !%SPEECH_OFF% | Un garde vous conduit vers %employer%, qui s\'occupe de quelques cultures dans son jardin. Les plantes sont penchées, leurs feuilles dentelées et mouchetées par la mastication d\'insectes envahissants. En ramassant l\'une des plantes mortes, %employer% parle.%SPEECH_ON%Cela ressemblait à la saison la plus forte pour ces cultures. Et pourtant, les voici, abattues par les plus petits des insectes qui ont couru ici. J\'en suis sûr, c\'était un grand moment pour ces petits bâtards.%SPEECH_OFF%Il laisse tomber la plante et vous tape sur l\'épaule.%SPEECH_ON%Mercenaire, j\'ai besoin que quelqu\'un soit l\'insecte diabolique dans le jardin de mon ennemi. J\'ai besoin que tu attaques les territoires de %feudfamily% pendant au moins %days%. Bien sûr, s\'ils te capturent, attends-toi à ce qu\'ils te traitent comme un insecte et te piétinent comme tel. Alors, éloigne-toi des bottes sur le terrain. Tu sais, comme un insecte le ferait.%SPEECH_OFF% | %employer% fait semblant de s\'amuser avec une femme lorsque vous entrez dans sa pièce. Elle rassemble rapidement ses affaires et part en hâte, détournant les yeux des vôtres. Le noble plutôt suffisant se sert un verre de vin.%SPEECH_ON%Ne fais pas attention à elle. Elle est amie avec ma femme. C\'est tout.%SPEECH_OFF%Il remet la carafe sur son bureau.%SPEECH_ON%En parlant simplement d\'amis, pourquoi ne deviendrais-tu pas un ami à moi et n\'irais-tu pas attaquer les territoires de %feudfamily% ?%SPEECH_OFF%L\'homme vacille en s\'approchant avant de s\'asseoir sur le bord d\'un bureau. Il renifle ses doigts, hausse les épaules et boit le vin.%SPEECH_ON%Va dans leurs terres et détruis autant que possible pendant %days%. Ensuite, rentre. Je veux dire, tu peux rester là-bas si tu veux, mais je te suggère fortement de revenir car leurs armées ne supporteront pas longtemps tes conneries. Les nobles n\'aiment pas les pillards avec beaucoup de considération. Je suis sûr que tu comprends la politique là-dedans.%SPEECH_OFF% | %employer% est entouré de ses commandants. Il vous fait signe du doigt comme pour vous accuser d\'un crime que vous ne saviez même pas avoir été commis.%SPEECH_ON%C\'est notre homme ! C\'est celui qui le fera ! Mercenaire ! J\'ai besoin de combattants endurcis pour attaquer les terres de %feudfamily% pendant %days%. Détruis autant que possible, tout ce qui nuit à leur capacité de faire la guerre. Bien sûr, reste agile sur tes pieds. Ils chercheront à écraser rapidement toutes les attaques qu\'ils découvriront.%SPEECH_OFF%}"
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Partir pendant cinq jours entiers vous coûtera. | C\'est quelque chose que la %companyname% peut prendre en charge. | Paiement ?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | On est demandé autre part. | C\'est un engagement trop long pour l\'entreprise.}",
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
			ID = "SearchParty",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Vous approchez d\'une ferme quand soudain l\'un des volets explose. Une vieille dame crie d\'une voix rauque en agitant un drapeau blanc. %randombrother% va vérifier, l\'écoutant un moment avant de revenir rapidement.%SPEECH_ON%Monsieur, elle a dit que %feudfamily% sait où nous sommes et qu\'une grande force ennemie vient vers nous. Et oui, elle a utilisé le mot \'force.\'%SPEECH_OFF% | En passant devant une ferme, un petit garçon sort en courant.%SPEECH_ON%Oooh, êtes-vous ceux qui vont tuer les pillards ?%SPEECH_OFF%Vous demandez qui lui a dit cela. Le garçon hausse les épaules.%SPEECH_ON%J\'étais autour du pub et j\'ai entendu dire que %feudfamily% savait où se trouvaient les pillards et envoyait de grands hommes pour les écraser bien fort !%SPEECH_OFF%Le gamin bat des mains comme s\'il écrasait un insecte. Vous caressez les cheveux du gamin.%SPEECH_ON%Bien sûr, c\'est nous. Maintenant, rentre chez toi.%SPEECH_OFF%Vous informez rapidement la %companyname% de la nouvelle. | %randombrother% descend en courant d\'une des collines. Il reprend son souffle à côté de vous.%SPEECH_ON%Monsieur, je... ils...%SPEECH_OFF%Il se redresse.%SPEECH_ON%J\'ai besoin de faire de l\'exercice. Mais ce n\'est pas pour ça que je suis venu vous dire ! Il y a un très grand groupe de soldats ennemis qui vient dans notre direction en ce moment même. Je pense qu\'ils savent exactement où nous sommes, monsieur.%SPEECH_OFF%Vous hochez la tête et dites aux hommes de se préparer. | Une mission de reconnaissance signale qu\'un énorme détachement ennemi semble connaître votre position et arrive maintenant ! La %companyname% doit se préparer, que ce soit pour fuir ou tenir bon et se battre. | Vous avez été repéré et une grande force de soldats %feudfamily% arrive ! Préparez les hommes du mieux que vous pouvez, car les rapports indiquent que ces ennemis sont bien armés. | %randombrother% vous rapporte ce qu\'il a entendu de certains habitants. Ils disent qu\'un grand groupe de soldats portant une bannière se dirige vers vous. Vous demandez au mercenaire de décrire le blason et il le fait avec beaucoup de détails : il appartient aux hommes de %feudfamily%. Ils doivent vous avoir rattrapé d\'une manière ou d\'une autre. La %companyname% devrait se préparer à un sacré combat ! | Un groupe de femmes lavant des vêtements dans un ruisseau demande ce que vous faites encore ici. Vous demandez ce qu\'elles veulent dire. L\'une d\'entre elles rit, un appel barbare s\'il en fut.%SPEECH_ON%Répète ça ? On vous a demandé ce que vous faisiez encore ici. Vous savez que %feudfamily% vient fort pour des hommes comme vous. De ce que j\'entends, ils seront sur vos fesses très bientôt.%SPEECH_OFF%Vous demandez comment elles le savent. Une des autres dames claque une chemise dans le ruisseau.%SPEECH_ON%Monsieur, vous devez être plus bête que l\'enfer. Les rumeurs vont plus vite que n\'importe quel cheval. Ne demandez pas comment. C\'est juste comme ça.%SPEECH_OFF%Si ce que disent ces femmes est vrai, alors la %companyname% a un grand combat devant elle ! | Vous montez sur une colline et observez les environs autant que possible. Il n\'y a pas grand-chose à voir, sauf un grand groupe d\'hommes arborant la bannière de %feudfamily% qui semble se diriger vers vous. C\'est un sacré spectacle et bientôt vous pourrez le voir de près et personnellement.\n\nLes ennemis ont rattrapé la %companyname%! Vous devriez vous préparer à un sacré combat à cause de tout ce que vous avez brûlé.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Soyez sur vos gardes !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TimeIsUp",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_36.png[/img]{Cela fait près de %maxdays% maintenant. La compagnie devrait commencer à retourner vers %employer% pour le paiement. | La compagnie est sur le terrain depuis %maxdays%. %employer% s\'attendra maintenant à votre retour. | Avec %maxdays% passés à piller, vous avez atteint le moment de retourner à %employer% pour être payé. Pas besoin de passer une autre seconde à faire ce pour quoi vous ne serez pas payé. | %employer% vous a engagé pour %maxdays%. La compagnie ne devrait pas passer un autre moment sur le terrain sans raison. Retournez vers l\'homme pour votre salaire. | La %companyname% a consacré %maxdays% de travail à accomplir les ordres de %employer%. C\'est tout le temps qu\'il était prêt à payer, alors vous feriez bien de retourner vers lui maintenant. | %employer% a payé pour %maxdays% et c\'est ce que vous avez fait. La %companyname% devrait retourner vers lui rapidement pour le paiement. | Bien que ravager les terres commence à vous plaire, %employer% ne paie que pour %maxdays% de travail. Vous feriez bien de retourner vers lui maintenant. | Vous avez fait du bon travail, mais il est temps de retourner vers %employer% car il ne vous paie que pour %maxdays% de vos services.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il est temps de retourner à %townname%.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ChangingSides",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_51.png[/img]{En chemin, un homme encapuchonné s\'approche lentement. Son visage est caché derrière l\'ombre de la capuche. Il s\'arrête devant vous et tend les mains.%SPEECH_ON%Salutations. Je suis un messager de la maison %rivalhouse%. Nous avons une offre pour vous. Posez vos armes pour %noblehouse% et rejoignez-nous. Vous ne manquerez pas d\'affaires avec nous et votre compagnie sera toujours la première pour les meilleurs contrats. Pour rendre l\'offre plus attrayante, je suis censé vous remettre cette merveilleuse arme appelée %nameditem%.%SPEECH_OFF%Vous réfléchissez à l\'idée. Changer de camp fait partie intégrante de la vie de mercenaire. Quelle maison noble traite mieux la compagnie ? Quelle maison a plus de chances de gagner ? | Vous vous écartez du chemin pour faire une pause. En vous soulageant, un homme apparaît soudainement hors des buissons, bien que visiblement sec. Vous reculez et tirez un poignard, mais l\'homme tend les mains.%SPEECH_ON%Attendez là, mercenaire. Je suis un messager de la maison %rivalhouse%. Je suis là pour vous faire une suggestion, et seulement une suggestion : rejoignez-nous. Vous bénéficierez de la priorité absolue chaque fois que nous aurons besoin de vos services, ce qui signifie les meilleurs contrats avec la meilleure rémunération, et laissez-moi vous dire, nous aurons toujours besoin de vous. Pour rendre l\'offre plus attrayante, je devais vous offrir ceci.%SPEECH_OFF%Il tend lentement une arme magnifiquement fabriquée. Vous lui demandez de vous donner un moment et retournez finir votre affaire. Des pensées vous traversent l\'esprit alors que quelque chose d\'autre sort de votre autre extrémité. | En observant les environs, un homme encapuchonné s\'approche. %randombrother% le saisit par la capuche et pointe une lame sur son cou. L\'homme lève simplement les mains et dit qu\'il est là pour transmettre un message de la part de %rivalhouse%. Vous hochez la tête et le laissez parler.%SPEECH_ON%Nous avons une offre : rejoignez-nous. Abandonnez ces nobles échecs que vous servez et venez travailler pour nous. Vous recevrez les meilleurs contrats et la meilleure rémunération, et, surtout, vous serez du côté gagnant ! En gage de bonne foi, je suis censé vous donner cette belle arme appelée %nameditem%. Si vous acceptez, bien sûr.%SPEECH_OFF%Vous réfléchissez soigneusement à l\'offre, car changer de camp ne doit pas être pris à la légère. | Une silhouette sombre descend le chemin avec un parchemin tendu dans une main.%SPEECH_ON%Bonsoir, la %companyname%. Je viens de la part de la maison %rivalhouse% avec une offre de service. Abandonnez vos bienfaiteurs et rejoignez-nous. Vous trouverez des contrats meilleurs et plus nombreux et, encore mieux, vous serez du côté gagnant de cette guerre ! Si vous acceptez, et en gage de bonne foi, vous recevrez cette arme appelée %nameditem%.%SPEECH_OFF%%randombrother% vous regarde et hausse les épaules.%SPEECH_ON%Sans vouloir dépasser ma fonction, je dirais que cela vaut la peine d\'y réfléchir.%SPEECH_OFF%En effet, c\'est le cas. | Vous vous éloignez de la compagnie pour avoir une bonne idée du terrain. Tout en observant les champs devant vous, une silhouette encapuchonnée apparaît soudainement avec quelque chose tendu. %randombrother% apparaît et le plaque au sol, prêt à lui enfoncer une lame dans le visage. L\'inconnu lève les mains, un parchemin enroulé à la main. Vous dites à l\'homme de se lever et de se présenter. Il déclare qu\'il vient de la part de %rivalhouse% et qu\'il a une offre pour la %companyname%.%SPEECH_ON%Changez de camp. En tant que mercenaires, il n\'y a pas d\'honneur à perdre en faisant cela, et c\'est en fait totalement attendu de vous. Poursuivez les couronnes, n\'est-ce pas ? Eh bien, nous avons le plus de contrats avec la meilleure rémunération. C\'est ce que vous recherchez, n\'est-ce pas ?%SPEECH_OFF%Le messager arrange ses vêtements, se redressant comme un ambassadeur temporairement embarrassé.%SPEECH_ON%De plus, si vous choisissez d\'accepter notre offre, je suis censé vous remettre cette arme appelée %nameditem% en gage de bonne foi. Alors, que dites-vous ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Une offre intriguante. J\'accepte.",
					function getResult()
					{
						return "AcceptChangingSides";
					}

				},
				{
					Text = "Vous perdez votre temps. Partez ou vous pendrez à cet arbre.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AcceptChangingSides",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_51.png[/img]{Vous acceptez l\'offre. Le messager mystérieux vous conduit vers un bosquet caché et sort l\'arme de derrière quelques buissons pour vous la remettre.%SPEECH_ON%Bonne affaire avec vous, mercenaire.%SPEECH_OFF%Il est juste de dire que %employer% et toute sa famille vous détestent complètement maintenant. | Après avoir accepté l\'offre, le messager vous emmène hors du chemin pour récupérer l\'arme de derrière quelques buissons. En vous la remettant, il vous serre également la main.%SPEECH_ON%Vous avez fait le bon choix, mercenaire.%SPEECH_OFF%%employer% vous déteste sans aucun doute maintenant, et il n\'y a aucune raison de retourner vers lui, à moins que vos nouveaux bienfaiteurs ne le demandent, bien sûr.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "La %companyname% travaillera dorénavant pour %rivalhouse% !",
					function getResult()
					{
						this.Contract.m.Item = null;
						local f = this.World.FactionManager.getFaction(this.Contract.getFaction());
						f.addPlayerRelation(-f.getPlayerRelation(), "A changé de camp pendant la guerre");
						f.getFlags().set("Betrayed", true);
						local a = this.World.FactionManager.getFaction(this.Flags.get("RivalHouseID"));
						a.addPlayerRelationEx(50.0 - a.getPlayerRelation(), "A changé de camp pendant la guerre");
						a.makeSettlementsFriendlyToPlayer();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.updateAchievement("NeverTrustAMercenary", 1, 1);
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(this.Contract.m.Item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + this.Contract.m.Item.getIcon(),
					text = "Vous recevez " + this.Contract.m.Item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% vous accueille dans sa chambre. Il vous remet une bourse contenant %reward_completion% couronnes.%SPEECH_ON%Bon travail là-bas, mercenaire. Vous avez fait tout ce qui pouvait être demandé.%SPEECH_OFF% | %employer% est occupé à s\'occuper d\'un tas de poulets. Vous vous frayez un chemin à travers la volaille pour le rejoindre et lui annoncer la nouvelle. Il réagit positivement.%SPEECH_ON%Ah ouais ? C\'est bien. Vous voulez être payé en grain ou en couronnes ?%SPEECH_OFF%Le noble vous fixe droit dans les yeux avant qu\'un sourire ne le trahisse.%SPEECH_ON%Vous trouverez %reward_completion% couronnes entre les mains de ce garde là-bas. Il saura vous les remettre.%SPEECH_OFF% | %employer% est trop occupé pour vous rencontrer, mais les %reward_completion% couronnes remises par l\'un de ses gardes semblent suffisamment mesurer sa satisfaction concernant votre travail. | %employer% agite un doigt dans un gobelet de vin.%SPEECH_ON%Les raids sont des travaux salissants, mais vous avez bien fait là-bas. Je dois admettre qu\'une partie de moi espérait que vous apporteriez l\'apocalypse elle-même à mes ennemis, mais ce que vous avez fait est suffisant, je suppose.%SPEECH_OFF%Il retire son doigt et le lèche avant de vous lancer une bourse contenant %reward_completion% couronnes. | %employer% s\'effondre dans l\'un de ses fauteuils, les mains pendantes sur les accoudoirs, les pieds étendus.%SPEECH_ON%Votre paiement de %reward_completion% couronnes est là-bas.%SPEECH_OFF%Il fait signe vers un coin de la pièce où un sac est appuyé contre le mur. Vous allez le chercher tout en continuant de parler.%SPEECH_ON%Je dirais que vous avez fait un assez bon travail. Cette bourse devrait être lourde de ma satisfaction.%SPEECH_OFF% | Vous trouvez %employer% occupé à nourrir ses chiens dans la cour des écuries.%SPEECH_ON%Bon travail, mercenaire. Si tous mes soldats étaient de votre trempe et de votre volonté, cette guerre serait déjà terminée avant d\'avoir vu son premier clair de lune. Une honte, n\'est-ce pas ?%SPEECH_OFF%Il se retourne soudainement vers vous, vous fixant intensément. Vous pensez que c\'est un effort subtil pour vous recruter dans son armée. Vous déclinez poliment en politique avant de vous renseigner sur la paie. Il continue en pointant du doigt une bande de lard flasque vers un homme se tenant de l\'autre côté.%SPEECH_ON%Ce garde l\'a. %reward_completion% couronnes au total.%SPEECH_OFF% | %employer% vous remercie pour vos services. C\'est à peu près tout ce qu\'il dit avant de vous remettre une somme de %reward_completion% couronnes. | Vous trouvez %employer% entouré de ses commandants. Ils ajustent la carte de bataille en fonction de l\'étendue de votre travail. Le noble se redresse et contemple les résultats.%SPEECH_ON%Ce n\'est pas tout ce que je pouvais demander, mais c\'est bien. Mon garde là-bas aura %reward_completion% couronnes pour vous.%SPEECH_OFF% | %employer% est debout devant une carte accrochée au mur. Il utilise une plume pour prendre des notes et vous remarquez que ces marques suivent le chemin qu\'a emprunté la %companyname% à travers les territoires de %feudfamily%. Le noble hume et hoche la tête. Il parle sans vous regarder.%SPEECH_ON%Ce n\'est pas le meilleur, mais c\'est bien. %reward_completion% couronnes vous attendent dans le coin.%SPEECH_OFF% | Un des commandants de %employer% vous empêche d\'entrer dans sa chambre. Il vous remet une bourse contenant %reward_completion% couronnes.%SPEECH_ON%Le seigneur est occupé. Prenez votre salaire et partez, je vous prie.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Un salaire honnête pour un travail honnête.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Raided the enemy lands");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isCivilWar())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% et ses commandants se saoulent lorsque vous entrez dans leur chambre. Un général baraqué vous tape sur l\'épaule, semble vouloir dire quelque chose, puis se retourne et vomit. Vous hâtez le pas et trouvez %employer% lui-même.%SPEECH_ON%Ah, mercenaire ! Moi -hic- bien, voici. %reward_completion% couronnes.%SPEECH_OFF%Il vous tend une bourse que vous prenez rapidement de peur qu\'elle ne subisse le même sort que le commandant toujours en train de vomir derrière vous. %employer% chancelle en arrière avant de s\'appuyer contre son bureau pour se soutenir.%SPEECH_ON%Vous avez damné près de percer un trou dans les efforts de guerre de %feudfamily%. Un putain -hic- de bon boulot ! Le plus foutu, le meilleur, le plus jobbest, le job que j\'ai jamais -hic- entendu parler.%SPEECH_OFF%Vous vous retirez de la pièce, tissant autour de la fête et des villes de vomissements. | %employer% frappe un gobelet de vin sur la table, en renversant la plupart sur lui-même.%SPEECH_ON%Excellent ! Exceptionnel ! La perfection ! Voilà ce que j\'ai à dire sur votre travail, mercenaire. Bon sang, nous avons même eu quelques déserteurs des armées de %feudfamily% qui sont très inquiets que leur côté ait déjà perdu ! Tenez, prenez %reward_completion% couronnes. C\'est pour moi.%SPEECH_OFF%L\'homme éclate de rire avant de prendre une longue gorgée. | Vous entrez dans la chambre de %employer% pour le trouver en train d\'étudier une carte de guerre. Il se chatouille le menton avec une plume, fredonnant et acquiesçant de temps en temps.%SPEECH_ON%Vous savez, je suis presque à court d\'encre pour suivre vos mouvements à travers le territoire de %feudfamily%. Voilà à quel point vous avez bien fait le boulot, mercenaire. Vous trouverez %reward_completion% couronnes dans le coin là-bas.%SPEECH_OFF% | Un homme vous accueille à l\'extérieur de la chambre de %employer% avec une bourse qui pèse lourd dans vos mains.%SPEECH_ON%%reward_completion% couronnes pour vos services. Mon suzerain est occupé, mais très satisfait. Espérons que cela soit le signe de sa reconnaissance pour votre travail.%SPEECH_OFF%C\'est un assez bon signe, oui. | Un garde vous conduit auprès de %employer% qui est derrière une porte verrouillée. Il y a une femme avec lui et il semble être dans une humeur un peu... festive. Le garde frappe à la porte, puis change d\'avis.%SPEECH_ON%Je devais lui dire que vous étiez là, mais il n\'aime pas être interrompu. Pas pendant des moments comme celui-ci. Vous savez. Les bons moments.%SPEECH_OFF%Vous hochez la tête et demandez où est votre salaire. Le garde vous conduit à la trésorerie. Vous rencontrez un homme au visage de faucon assis derrière des piles de papiers et de pièces. Il pousse une bourse contenant %reward_completion% couronnes dans votre direction avant de noter l\'échange sur un parchemin. | %employer% vous accueille dans son jardin. Il supervise des serviteurs en train de planter des plantes dans le sol fin.%SPEECH_ON%Qu\'avez-vous dans votre jardin, mercenaire ?%SPEECH_OFF%Vous informez gentiment l\'homme que vous n\'êtes pas du genre jardinage. Il hoche la tête comme si cela l\'intéressait beaucoup.%SPEECH_ON%Je pense mettre des navets pour la saison à venir. Quoi qu\'il en soit, assez parlé de ça. Voyez le serviteur là-bas qui transpire ? C\'est lui qui tient la lourde bourse. Lourde car elle contient %reward_completion% couronnes. Votre récompense pour un travail bien fait, mercenaire. Peut-être pourrez-vous vous acheter un jardin !%SPEECH_OFF% | %employer% et ses commandants chantonnent autour d\'une carte de bataille. L\'un pousse un jeton avec le sigle de votre compagnie. Il suit le jeton sur toute la carte, utilisant un bâton encré pour faire des marques de temps en temps. Vous croisez les bras et parlez fort.%SPEECH_ON%Vous appréciez mon travail, n\'est-ce pas ?%SPEECH_OFF%Le noble et ses commandants vous regardent. %employer% sourit et traverse rapidement la pièce.%SPEECH_ON%Ne le savez-vous pas ! Vous avez fait un travail incroyable, mercenaire. Ce garde debout là-bas a %reward_completion% couronnes en paiement pour vos services.%SPEECH_OFF% | %employer% est debout parmi ses commandants. Il hurle en vous voyant entrer dans la pièce.%SPEECH_ON%Nom de Dieu, mon fils ! Vous avez presque tout détruit ! Qu\'est-ce qu\'un homme comme moi pourrait demander de plus qu\'un éclair qui frappe du ciel ? Vous serez payé %reward_completion% couronnes, ce qui me semble plus que suffisant pour un travail de cette qualité !%SPEECH_OFF% | Vous trouvez %employer% assis dans sa chambre. Il a l\'air très content de vous.%SPEECH_ON%{Eh bien, eh bien, si ce n\'est pas l\'homme du jour. Un troupeau de mes petits oiseaux est passé par ma fenêtre pour parler de votre travail. Le mot se propage vite quand on fait un travail aussi bon que celui-là ! %feudfamily% sera handicapé et la guerre s\'achèvera bien avant de voir son premier clair de lune ! J\'ai préparé une bourse de %reward_completion% couronnes pour vous dans le coin là-bas. | Vous devriez avoir un peu plus de vigueur, mercenaire. Ce que vous avez fait à %feudfamily% était au-delà de ce que j\'avais demandé. Je suis surpris que vous n\'ayez pas poussé un peu plus loin et tué toute cette lignée pendant que vous y étiez. Ah, tout vient en son temps. Pour l\'instant, vous avez %reward_completion% couronnes qui vous attendent dans ce coin.}%SPEECH_OFF% | Vous trouvez %employer% accroupi devant une table avec une carte de guerre dessus. Ses yeux regardent par-dessus le bord, balayant un horizon de jetons.%SPEECH_ON%Saluez mercenaire.%SPEECH_OFF%Il se lève d\'un bond. D\'une main, il ramasse lentement des jetons représentant %feudfamily% et les lance de côté.%SPEECH_ON%Profitez de votre travail, mercenaire. Vous avez réussi à paralyser mes ennemis avec peu d\'efforts ! Je suppose que je parle pour moi-même à ce sujet, mais ce que vous avez fait ici bat tout ce qu\'une grande bataille aurait pu faire ! %reward_completion% couronnes vous attendent dans le coin là-bas. J\'espère que cette paye vous suffira, car le travail que vous avez fait l\'était certainement.%SPEECH_OFF% | Vous trouvez %employer% et ses commandants et une flopée de femmes qui ne semblent pas correctement vêtues pour une guerre que vous connaissez.%SPEECH_ON%Mercenaire ! Entrez%SPEECH_OFF%%employer% recule sur ses talons, une femme accrochée à chaque bras. Vous le suivez du mieux que vous pouvez. Une femme essaie de vous entraîner dans la fête, mais un général la prend en charge. %employer% tombe dans son siège, les femmes sur ses genoux.%SPEECH_ON%Vous êtes la cause de la célébration, mercenaire. Vous avez tellement bien fait le raid des territoires de %feudfamily% que je pense que vous nous avez beaucoup rapprochés de la fin de cette guerre que toute grande bataille n\'aurait jamais pu faire ! Santé !%SPEECH_OFF%Vous regardez autour de vous.%SPEECH_ON%Les festivités sont agréables, mais je n\'ai pas à me battre pour les femmes et les boissons. Vous me devez de l\'argent.%SPEECH_OFF%Votre employeur hoche la tête.%SPEECH_ON%Bien sûr, bien sûr ! Rendez visite à mon trésorier et remettez-lui votre sceau. Il aura %reward_completion% couronnes qui vous attendent.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une bonne journée de travail.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess * 2);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess * 2, "Raided the enemy lands");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isCivilWar())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Vous entrez dans la chambre de %employer% déjà résigné à la fureur qu\'il va déchaîner. Et il le fait.%SPEECH_ON%Laissez-moi comprendre ça, mercenaire. Je propose de vous payer pour aller piller le territoire de %feudfamily%. Vous acceptez cette offre puisque, comme je le pensais, c\'était une très bonne offre et que les deux parties avaient beaucoup à y gagner. Maintenant, vous vous tenez devant moi en disant que vous n\'avez foutu rien en ce qui concerne notre arrangement. Pourquoi avez-vous même franchi cette porte, espèce de sac à chien lamentable ? Non, vous êtes pire que ça, vous êtes un ver pleurnichard essayant de voler un homme noble qui fait un travail noble. Dégagez d\'ici avant que je perde patience.%SPEECH_OFF%Malgré la bravade de %employer%, c\'est lui qui glisse dans le danger. Vous partez rapidement avant que ce ne soit votre patience qui soit perdue et qu\'un noble ne perde la vie avec. | Vous retournez à %employer%, mais un garde vous arrête devant la porte.%SPEECH_ON%Il sait déjà ce que vous avez, ou devrais-je dire n\'avez pas fait. Il vaudrait mieux ne pas y aller.%SPEECH_OFF%Le fracas d\'une table retournée secoue la porte. Un cri incompréhensible s\'ensuit. Vous suivez la recommandation du garde et partez. | %employer% fait glisser un doigt le long du bord de sa coupe. Elle gémit bruyamment alors qu\'il s\'enroule autour, encore et encore.%SPEECH_ON%Une si douce, douce mélodie. Comment se fait-il qu\'une simple coupe soit meilleure que vous, mercenaire ? Je suppose que c\'est juste la façon dont le monde est parfois. Je demande à quelqu\'un de faire quelque chose, et il ne le fait pas. Que dire d\'autre ? S\'il vous plaît, sortez.%SPEECH_OFF% | Vous trouvez %employer% donnant des restes à ses chiens. Les serviteurs qui regardent à proximité ont l\'air de préférer être des chiens eux-mêmes si c\'est ce genre de traitement qu\'ils recevraient. %employer% se tourne vers vous alors qu\'un chien glisse doucement une pièce de bacon hors de sa main.%SPEECH_ON%Les chiens ont une préférence pour la viande. Ici, je les nourris avec les restes d\'un porc. C\'était un bon porc. Un porc qui a eu une bonne vie, sauf pour un très mauvais moment, bien sûr. Maintenant, il nourrit mes chiens. Vous, mercenaire, m\'avez apporté un très mauvais moment dans votre propre vie. Devrais-je aussi vous nourrir à mes chiens ? Non ? Alors sortez de ma chambre.%SPEECH_OFF% | %employer% refuse même de vous rencontrer. Deux de ses gardes expliquent qu\'il est furieux de votre échec à infliger le moindre dommage aux territoires de %feudfamily%. C\'est juste. Vous remerciez les gardes de vous avoir sauvé d\'un barrage inutile d\'insultes et de colère d\'un noble.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Allez au diable !",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to raid the enemy lands");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noblehouse",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
		_vars.push([
			"rivalhouse",
			this.m.Flags.get("RivalHouseName")
		]);
		_vars.push([
			"feudfamily",
			this.m.Flags.get("FeudingHouseName")
		]);
		_vars.push([
			"maxdays",
			"cinq jours"
		]);
		local days = 5 - (this.World.getTime().Days - this.m.Flags.get("StartDay"));
		_vars.push([
			"days",
			days > 1 ? "" + days + " jours" : "1 jour"
		]);

		if (this.m.Item != null)
		{
			_vars.push([
				"nameditem",
				this.m.Item.getName()
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			foreach( obj in this.m.Objectives )
			{
				if (obj != null && !obj.isNull() && obj.isActive())
				{
					obj.clearTroops();
					obj.setAttackable(false);
					obj.getSprite("selection").Visible = false;
					obj.getFlags().set("HasNobleProtection", false);
					obj.setOnCombatWithPlayerCallback(null);
				}
			}

			this.m.Item = null;
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		_out.writeU8(this.m.Objectives.len());

		foreach( o in this.m.Objectives )
		{
			if (o != null && !o.isNull())
			{
				_out.writeU32(o.getID());
			}
			else
			{
				_out.writeU32(0);
			}
		}

		if (this.m.Item != null)
		{
			_out.writeBool(true);
			_out.writeI32(this.m.Item.ClassNameHash);
			this.m.Item.onSerialize(_out);
		}
		else
		{
			_out.writeBool(false);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local numObjectives = _in.readU8();

		for( local i = 0; i != numObjectives; i = ++i )
		{
			local o = _in.readU32();

			if (o != 0)
			{
				this.m.Objectives.push(this.WeakTableRef(this.World.getEntityByID(o)));
				local obj = this.m.Objectives[this.m.Objectives.len() - 1];

				if (!obj.isMilitary() && !obj.getSettlement().isMilitary() && !obj.getFlags().get("HasNobleProtection"))
				{
					local garbage = [];

					foreach( i, e in obj.getTroops() )
					{
						if (e.ID == this.Const.EntityType.Footman || e.ID == this.Const.EntityType.Greatsword || e.ID == this.Const.EntityType.Billman || e.ID == this.Const.EntityType.Arbalester || e.ID == this.Const.EntityType.StandardBearer || e.ID == this.Const.EntityType.Sergeant || e.ID == this.Const.EntityType.Knight)
						{
							garbage.push(i);
						}
					}

					garbage.reverse();

					foreach( g in garbage )
					{
						obj.getTroops().remove(g);
					}
				}
			}
		}

		local hasItem = _in.readBool();

		if (hasItem)
		{
			this.m.Item = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
			this.m.Item.onDeserialize(_in);
		}

		this.contract.onDeserialize(_in);
	}

});

