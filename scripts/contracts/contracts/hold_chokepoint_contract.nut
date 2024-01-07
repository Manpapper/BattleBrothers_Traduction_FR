this.hold_chokepoint_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hold_chokepoint";
		this.m.Name = "Tenir la forteresse";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local enemies = [];

		foreach( n in nobles )
		{
			if (n.getFlags().get("IsHolyWarParticipant"))
			{
				enemies.push(n);
			}
		}

		this.m.Flags.set("EnemyID", enemies[this.Math.rand(0, enemies.len() - 1)].getID());
		local locations = this.World.EntityManager.getLocations();
		local candidates = [];

		foreach( v in locations )
		{
			if (v.getTypeID() == "location.abandoned_fortress")
			{
				candidates.push(v);
			}
		}

		local closest;
		local closest_dist = 9000;

		foreach( c in candidates )
		{
			local d = this.m.Home.getTile().getDistanceTo(c.getTile()) + this.Math.rand(0, 5);

			if (d < closest_dist)
			{
				closest = c;
				closest_dist = d;
			}
		}

		this.m.Destination = this.WeakTableRef(closest);
		this.m.Payment.Pool = 1400 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("Wave", 0);
		this.m.Flags.set("WavesDefeated", 0);
		this.m.Flags.set("WaitUntil", 0.0);
		this.m.Flags.set("MapSeed", this.Time.getRealTime());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Allez jusqu\'à la forteresse abandonnée et défendez la contre les incursions des Nordiques"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					if (this.Contract.getDifficultyMult() <= 1.05)
					{
						this.Flags.set("IsEnemyRetreating", true);
					}
				}

				if (r <= 40)
				{
					this.Flags.set("IsReinforcements", true);
				}
				else if (r <= 70)
				{
					this.Flags.set("IsUltimatum", true);
				}

				local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

				foreach( n in nobles )
				{
					if (n.getFlags().get("IsHolyWarParticipant"))
					{
						n.addPlayerRelation(-99.0, "Took sides in the war");
					}
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.Contract.setScreen("Arrive");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Defend",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Utilisez la forteresse abandonnée pour vous défendre contre les incursions des nordiques",
					"Ne vous éloignez pas trop"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsFailure") || !this.Contract.isPlayerNear(this.Contract.m.Destination, 600))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Flags.get("Wave") > this.Flags.get("WavesDefeated") && (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive()))
				{
					this.Flags.increment("WavesDefeated", 1);
					this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(3, 6));

					if (this.Flags.get("WavesDefeated") == 1)
					{
						this.Contract.setScreen("Waiting1");
					}
					else if (this.Flags.get("WavesDefeated") == 2)
					{
						this.Contract.setScreen("Waiting2");
					}
					else if (this.Flags.get("WavesDefeated") == 3)
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("WaitUntil") > 0 && this.Time.getVirtualTimeF() >= this.Flags.get("WaitUntil"))
				{
					this.Flags.set("WaitUntil", 0.0);
					this.Flags.set("IsWaveShown", false);

					if (this.Flags.getAsInt("Wave") == 2 && this.Flags.get("IsEnemyRetreating"))
					{
						this.Contract.setScreen("EnemyRetreats");
						this.World.Contracts.showActiveContract();
						return;
					}
					else if (this.Flags.getAsInt("Wave") == 2 && this.Flags.get("IsUltimatum"))
					{
						this.Contract.setScreen("Ultimatum1");
						this.World.Contracts.showActiveContract();
						return;
					}
					else
					{
						this.Flags.increment("Wave", 1);
						local enemyNobleHouse = this.World.FactionManager.getFaction(this.Flags.get("EnemyID"));
						local candidates = [];

						foreach( s in enemyNobleHouse.getSettlements() )
						{
							if (s.isMilitary())
							{
								candidates.push(s);
							}
						}

						local mapSize = this.World.getMapSize();
						local o = this.Contract.m.Destination.getTile().SquareCoords;
						local tiles = [];

						for( local x = o.X - 3; x < o.X + 3; x = ++x )
						{
							for( local y = o.Y + 3; y <= o.Y + 6; y = ++y )
							{
								if (!this.World.isValidTileSquare(x, y))
								{
								}
								else
								{
									local tile = this.World.getTileSquare(x, y);

									if (tile.Type == this.Const.World.TerrainType.Ocean)
									{
									}
									else
									{
										local s = this.Math.rand(0, 3);

										if (tile.Type == this.Const.World.TerrainType.Mountains)
										{
											s = s - 10;
										}

										if (tile.HasRoad)
										{
											s = s + 10;
										}

										tiles.push({
											Tile = tile,
											Score = s
										});
									}
								}
							}
						}

						tiles.sort(function ( _a, _b )
						{
							if (_a.Score > _b.Score)
							{
								return -1;
							}
							else if (_a.Score < _b.Score)
							{
								return 1;
							}

							return 0;
						});
						local party = enemyNobleHouse.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getName() + " Company", true, this.Const.World.Spawn.Noble, (this.Math.rand(100, 120) + this.Flags.get("Wave") * 10 + (this.Flags.get("IsAlliedReinforcements") ? 50 : 0)) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + enemyNobleHouse.getBannerString());
						party.setDescription("Soldats professionnels au service des seigneurs locaux.");
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
						local attack = this.new("scripts/ai/world/orders/attack_zone_order");
						attack.setTargetTile(this.Contract.m.Destination.getTile());
						c.addOrder(attack);
						local move = this.new("scripts/ai/world/orders/move_order");
						move.setDestination(this.Contract.m.Destination.getTile());
						c.addOrder(move);
						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(this.Contract.m.Destination.getTile());
						guard.setTime(240.0);
						c.addOrder(guard);
						party.setAttackableByAI(false);
						party.setAlwaysAttackPlayer(true);
						party.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
						this.Contract.m.Target = this.WeakTableRef(party);
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;

				if (!this.Flags.get("IsWaveShown"))
				{
					this.Flags.set("IsWaveShown", true);

					if (this.Flags.getAsInt("Wave") == 3 && this.Flags.get("IsReinforcements"))
					{
						this.Contract.setScreen("Reinforcements");
					}
					else
					{
						this.Contract.setScreen("Wave" + this.Flags.get("Wave"));
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "HoldChokepoint";
					p.Music = this.Const.Music.NobleTracks;

					if (this.Contract.isPlayerAt(this.Contract.m.Destination))
					{
						_isPlayerInitiated = false;
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.LocationTemplate.ShiftX = -4;

						if (this.Flags.get("IsAlliedReinforcements"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						}
					}

					this.World.Contracts.startScriptedCombat(p, _isPlayerInitiated, true, true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "HoldChokepoint")
				{
					this.Flags.set("IsFailure", true);
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
					if (this.Flags.getAsInt("WavesDefeated") <= 2 && !this.Flags.get("IsEnemyRetreating"))
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% est entouré de ses hommes. Ils portent des vêtements pompeux qui vous font penser qu\'ils ne sont pas dans leur élément. Cependant, malgré leur apparence plutôt pompeuse, l\'un des commandants vous prend à part avec une carte et vous parle clairement.%SPEECH_ON%Mercenaire, nous avons besoin de vous pour voyager jusqu\'à une forteresse abandonnée %direction% d\'ici. Nous avons une unité de soldats qui marchent vers l\'endroit, mais ils n\'y arriveront pas avant les sauvages du nord. De tous ceux qui sont disponible, vous êtes le plus proche. Allez-y et défendez jusqu\'à ce que nos soldats arrivent. La fortification est délabrée, mais je crois qu\'un homme de votre nature peut se contenter de quelques décombres s\'il le faut. %reward% couronnes attendront votre retour, et votre succès, bien sûr.%SPEECH_OFF% | %employer% est assis sur un coussin avec un énorme carte en tissu étalé devant lui. Des lieutenants bien habillés sont assis un peu partout autour de la carte, chacun équipé d\'un long bâton en bois pour pousser les pièces. Et au bout de la carte se trouve quelques artisans qui continuent à ajouter des pièces à la carte - pour autant que vous puissiez en juger, ils ajoutent des sections du nord. Le Vizir vous voit et vous parle.%SPEECH_ON%Mercenaire, il y a un fort %direction% d\'ici. C\'est une forteresse tombée en ruine, composé uniquement de décombres selon certains, mais les anciens l\'ont construite pour une bonne raison : elle est d\'une grande importance stratégique. Bien que j\'ai des soldats qui se déplacent rapidement vers son emplacement, ils n\'arriveront pas avant un contingent de Nordistes. Ce sont des sauvages impurs, mais il faut respecter leur volonté d\'avancer rapidement. Donc, j\'ai besoin que vous occupiez la forteresse et que vous reteniez les nordistes jusqu\'à ce que mes armées arrivent.%SPEECH_OFF%Il brandit un morceau de papier avec un chiffre que vous comprenez facilement : %reward% couronnes. | Un homme très grand en tenue militaire vous empêche d\'entrer dans la chambre de %employer%. On peut entendre le Vizir se mêler à son harem, mais ce n\'est pas votre affaire. Le lieutenant enfonce un parchemin dans votre poitrine.%SPEECH_ON%Les anciens ont construit une forteresse %direction% d\'ici. Elle s\'est effondrée depuis, affaiblie comme toute chose par le passage du temps, mais son emplacement s\'avère toujours stratégique. Nous sommes en train de déplacer une troupe de soldats vers l\'endroit, mais nos éclaireurs ont rapporté que ces chiens du nord sont aussi conscients de son importance et nous devanceront. C\'est là que vous intervenez. %reward% couronnes pour réquisitionner le fort et le tenir jusqu\'à l\'arrivée des renforts. Une fois libéré, vous nous reviendrez et gagnerez le salaire d\'un bon petit mercenaire.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Ça ressemble à quelque chose que %companyname% peut faire. | Parlons un peu plus de ce que nous sommes payés pour ça. | Nous pouvons tenir la forteresse contre les invasions païennes.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | On est demandé autre part. | Je ne veux pas risquer la compagnie pour garder des ruines.}",
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
			ID = "Arrive",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_167.png[/img]{La forteresse est à la fois familière et inhabituelle. Bien qu\'elle soit brisée et qu\'elle soit réduite en tas de décombres, on ne peut s\'empêcher de ressentir un sentiment de grandeur dans ses murs. Plus loin à l\'intérieur, autour des armureries délabrées et des salles à manger abandonnées, on trouve des constructions plus sommaires : des défenses érigées à la hâte, des signes de dernières résistances faites loin de là où elles devraient être. Il est impossible de dire ce qui s\'est passé ici, ni même quand, mais pour l\'instant, elle servira de maison temporaire à %companyname%.\n\n Vous marchez jusqu\'aux murs crénelés et regardez dehors. Il semble que vous ayez pris position juste à temps : les Nordistes sont déjà en approche, une ligne de silhouettes marchant juste au-dessus de l\'horizon comme des fourmis vers leur colline. | La forteresse étant un vestige perdu d\'un ancien empire vous semble cohérent : ses constructions sont aussi familières qu\'elles sont étrangères. Vous comprenez à quoi servent les murs, mais vous ne savez pas trop quoi penser de certains des symboles qui y sont gravés. Même l\'architecture de certaines pièces, la façon dont les angles se transforment en d\'incroyables tourbillons de briques, ne ressemble à rien de ce que vous avez vu. Vous ne savez pas s\'il s\'agit d\'un avantage tactique ou si les constructeurs ont voulu que les dessins soient d\'une autre ampleur.\n\nMais il n\'y a pas de temps à perdre avec son histoire, vous êtes ici pour l\'utiliser comme un point d\'étranglement. Et il semble que le moment soit venu : une vague de nordiques déferle sur l\'horizon et vous fonce dessus !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tout le monde, préparez-vous !",
					function getResult()
					{
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(5, 8));
						this.Contract.setState("Running_Defend");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Wave1",
			Title = "Avant la bataille...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{L\'avant-garde du Nord est là. Vous sautez sur les murs et criez à %companyname% de se préparer au combat. Les mercenaires se mettent en action, prennent position et préparent leurs armes. Pendant ce temps, les armures des hommes nord font de plsu en plus de bruit à mesure qu\'ils s\'approchent. La première flèche se dirige inoffensivement vers le fort, un doux signe qu\'une vilaine bataille est sur le point de se dérouler.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Wave2",
			Title = "Avant la bataille...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%randombrother% crie et vous vous précipitez vers les murs. Un contingent de nordistes lourdement armés est aligné sur le terrain. Peut-être ont-ils appris que c\'est %companyname% qui se tient devant eux et ils souhaitent prendre l\'affaire un peu plus au sérieux. Non pas que la prudence supplémentaire les sauvera. Il n\'y a qu\'un seul résultat à affronter %companyname% et vous ne pouvez vous empêcher de faire un sourire à l\'approche de l\'assaut.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Wave3",
			Title = "Avant la bataille...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Les nordiques approchent une fois de plus. Ils marchent à travers les cadavres pour se frayer un chemin dans la boue ensanglantée. Les rats qui se nourrissent déjà des morts se dispersent dans tous les sens et les vautours s\'envolent. Vous levez le bras et ordonnez aux hommes de se préparer pour ce qui est, espérons-le, la bataille finale.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Waiting1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_167.png[/img]{La première attaque a été repoussée. Vous envisagez brièvement d\'utiliser les cadavres pour boucher les trous dans les murs, mais vous n\'avez aucun intérêt à inviter les rats et leur pestilence sur le champ de bataille. D\'un ordre rapide, vous faites entasser les corps à l\'extérieur des murs et vous demandez aux hommes de se préparer pour le prochain assaut.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous à leur prochain assaut !",
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
			ID = "Waiting2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_167.png[/img]{%companyname% commence presque à ressembler aux hommes qu\'ils étaient lorsque vous les avez embauchés pour la première fois : abattus et battus par le monde. Mais tout ce temps passé dans la compagnie a fait d\'eux des hommes meilleurs. Malgré l\'épuisement, il n\'y a pas d\'usure de l\'entraînement, il n\'y a pas d\'usure du prestige, il n\'y a pas d\'usure de la renommée. Quand elle viendra, %companyname% sera prête pour le prochain assaut.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il y en aura peut-être d\'autres.",
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
			ID = "Failure",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Vous en avez assez vu. Le vizir a chargé la compagnie de tenir pendant un certain temps, pas de rester assis ici et de se suicider.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Cela ne vaut pas la peine de perdre la compagnie pour...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "N\'a pas réussi à tenir une fortification contre les envahisseurs du Nord.");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "EnemyRetreats",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Avec les corps qui s\'amoncellent, les mouches qui bourdonnent et les vautours qui tournent dans l\'air dans de grands nuages noirs, il semble que les Nordistes en aient assez. Un klaxon retentit, accompagné de beuglements vaincus, et les hommes du nord baissent les bras et retournent d\'où ils viennent. Au même moment, un éclaireur arrive du sud et annonce l\'arrivée imminente des troupes de %employer%. Il semble que vous soyez en sécurité pour retourner auprès de votre employeur.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous avons réussi !",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnAllies();
			}

		});
		this.m.Screens.push({
			ID = "Reinforcements",
			Title = "Before the battle...",
			Text = "[img]gfx/ui/events/event_164.png[/img]{Les nordiques approchent une fois de plus. Ils marchent parmi les cadavres pour se frayer un chemin jusqu\'à vous. Au moment où vous levez les bras pour donner l\'ordre à vos hommes, d\'autres hommes apparaissent à l\'horizon. Votre coeur se serre pendant un moment, jusqu\'à ce que vous réalisiez qu\'ils portent les couleurs de %employer% ! Les hommes du Vizir sont arrivés !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Enfin de l\'aide !",
					function getResult()
					{
						this.Flags.set("IsAlliedReinforcements", true);
						this.Flags.set("IsReinforcements", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Ultimatum1",
			Title = "Pendant que vous attendez...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Une corne retentissante attire votre attention. Vous vous rendez au sommet de vos défenses et regardez en bas pour trouver un héraut portant de nobles couleurs. Il est seul, bien que sa voix représente facilement une compagnie entière. %SPEECH_ON%Est-ce que le gentil mercenaire demande la clémence ? Est-ce que le gentil mercenaire cherche à avoir un autre lendemain, peut-être un autre hiver et un autre printemps ? Est-ce que le gentil mercenaire souhaite vivre, pour que son...%SPEECH_OFF%Vous lui criez d\'aller droit au but. L\'homme s\'éclaircit la gorge.%SPEECH_ON%Les nobles sont prêts à faire un deal. Quittez ce lieux sur-le-champ et nous vous laisserons partir sans vous traquer. Toutes les hostilités entre %companyname% et le Nord seront annulées par décret du Nord. Bien sûr, seulement si vous acceptez l\'offre.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Votre offre est acceptable.",
					function getResult()
					{
						return "Ultimatum2";
					}

				},
				{
					Text = "Au diable vous et votre offre !",
					function getResult()
					{
						return "Ultimatum3";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Ultimatum2",
			Title = "Pendant que vous attendez...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Vous acceptez le marché. Quelques hommes râlent, d\'autres sont soulagés, bien que les avis des uns et des autres soient très bien cachés pour ne pas éveiller vos propres soupçons, sans doute.%companyname% quitte \"légalement\" ce site et les nordistes prennent le contrôle. On vous remet un certain nombre de scripts officiels portant toutes les signatures des familles du Nord, ainsi que leurs cachets officiels. Il vous permettra de traverser pacifiquement les territoires du nord, bien que vous ayez sans doute gagné ce droit avec la perte de la bonne volonté dans le sud.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "C\'est mieux pour la compagnie.",
					function getResult()
					{
						local f = this.World.FactionManager.getFaction(this.Contract.getFaction());
						f.addPlayerRelation(-f.getPlayerRelation(), "Changement de camp pendant la guerre");
						f.getFlags().set("Betrayed", true);
						local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

						foreach( n in nobles )
						{
							n.addPlayerRelationEx(50.0 - n.getPlayerRelation(), "Changement de camp pendant la guerre");
							n.makeSettlementsFriendlyToPlayer();
						}

						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Ultimatum3",
			Title = "Pendant que vous attendez...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Vous dites au héraut de retournez à son commandant. Il acquiesce.%SPEECH_ON%Que votre force d\'âme impressionne les anciens dieux, car elle n\'impressionnera pas les puissances du Nord.%SPEECH_OFF%Le héraut s\'incline et part.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Préparez-vous à leur prochaine attaque.",
					function getResult()
					{
						this.Flags.set("IsUltimatum", false);
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(3, 6));
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Les cadavres jonchent le champ de bataille, parfois empilés par trois ou quatre. Les hommes de %companyname% marchent entre les corps pour piller ce qu\'ils peuvent, et se joignent à leur pillage des corbeaux, des buses, des rats, des souris, des chats, des chiens errants, un loup, un sauvage trop dangereux pour être approché, et un troupeau d\'oies qui a apparemment trouvé l\'endroit assez chaud pour arrêter une migration saisonnière. Les hommes du vizir sont également ici et prennent la relève, vous devrez donc vous-même migrer vers %employer% pour votre salaire. | Il y a une humidité stagnante dans l\'air avec une odeur âcre de cuivre. Le massacre a été si important que la terre ici s\'est transformée en un marécage de sang. Les corps sont tordus dans tous les sens, parfois empilés les uns sur les autres. Parfois, on entend quelqu\'un gémir, mais les morts sont si nombreux que ce serait une perte de temps d\'essayer de trouver le survivant. %employer%. Les hommes du Vizir vont bientôt vous remplacer, ce qui signifie que c\'est le bon moment pour retournez au Vizir pour votre salaire.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "On a réussi !",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnAllies();
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% vous arrête à bonne distance de son trône. Il claque des doigts et un serviteur s\'avance, mais le Vizir rit et lève la main.%SPEECH_ON%Non, attendez. Demandez à l\'une des femmes de le faire. Elle. La plus laide.%SPEECH_OFF%Il désigne son harem, et les dames se séparent jusqu\'à ce qu\'une femme soit isolée du groupe. C\'est une créature si légère qu\'on l\'imaginerait dans un château du nord. Elle prend une bourse de couronnes au serviteur et se prosterne devant vous. %employer% sourit.%SPEECH_ON%Vous deviez tenir le fort jusqu\'à l\'arrivée de mes hommes. Au lieu de cela, vous avez adopté la nature des femmes et avez fui à la vue du danger. Heureusement pour vous, mes hommes, des vrais hommes, sont venus reprendre le fort aux nordistes et l\'ont établi comme un point d\'étranglement. Arrêtez de fixer la concubine, Mercenaire ! Vos yeux peuvent se poser sur le sol ou sur votre paie. Je vous suggère de prendre votre argent et de quitter mon champ de vision avant que l\'on n\'allume un feu sous vos pieds.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A tenu un fort contre les nordistes");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
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
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Vous rapporterez à %employer% tout ce qui s\'est passé. Un sourire se dessine lentement sur le visage du Vizir.%SPEECH_ON%Mon Dieu, mes lieutenants vous ont envoyé là-bas ? Ce fort ne vaut rien. Qui voudrait jouer un tel tour ? J\'aurais bien eu l\'idée de décapiter le responsable, mais hélas, qu\'est-ce que c\'était déjà, %reward% couronnes ? Cela ne signifie rien pour moi. J\'ai payé plus cher pour qu\'un bouffon du nord me raconte une blague en personne, et leur sens de l\'humour est au mieux médiocre. Prenez votre or et quittez les lieux, Mercenaire.%SPEECH_OFF% | Lorsque vous retournez voir %employer%, le Vizir est introuvable. A la place, un de ses lieutenants vous prend à part et vous remercie pour vos services.%SPEECH_ON%Que ça reste entre nous et les souris, et sachez que ces paroles n\'ont jamais été prononcées, et qu\'il n\'y a pas de souris dans ces murs, que si j\'avais dans mes rangs des hommes comme vous, j\'aurais dans mon cœur des tentations de conquêtes. Hélas, on me donne des troupes aussi utiles pour moi que les simples grains de sable le sont pour le désert. Voici votre paie, merce... soldat.%SPEECH_OFF%Il vous remet une bourse de %reward% couronnes. Un autre lieutenant se dirige dans le couloir, et l\'homme qui vous précède vous tape sur l\'épaule, le visage soudain sans humour ni amabilité.%SPEECH_ON%Sortez d\'ici, Mercenaire, c\'est votre salaire et nous n\'entendrons pas une seule syllabe de la langue de quelqu\'un qui négocie sa paie !%SPEECH_OFF% | Vous entrez dans les salles du Vizir et trouvez un homme seul qui balaie les sols marbrés. Les poils de son balai s\'arrêtent sur votre botte et il lève les yeux.%SPEECH_ON%Ah. Ils m\'ont dit qu\'un homme de votre stature serait ici.%SPEECH_OFF%Il pose le balai, dont le manche est probablement plus épais que sa frêle silhouette. Il se dirige vers une table et ouvre un coffre rempli de sacs de %reward% couronnes. Vous demandez comment les Vizirs ont pu lui confier autant d\'argent. L\'homme ramasse son balai et rit.%SPEECH_ON%Si je volais les couronnes pour moi-même, jusqu\'où irais-je ? C\'est lourd. Je ne peux pas tout porter. Alors puis-je en prendre qu-un peu ? Non. Je suis un homme sans aucune présence. Je n\'irais jamais bien loin. Voici mon trésor, et voici le vôtre.%SPEECH_OFF%Vous prenez les pièces, mais demandez ensuite comment il sait que vous êtes le bon mercenaire. Son balai s\'arrête à nouveau, et une perle de sueur coule lentement sur sa joue. Avant qu\'il ne réponde, vous prenez les couronnes et partez. | %employer% se trouve parmi son conseil. Le groupe rare de personnes portant la soie et la barbe vous regarde avec mépris. Vous déclarez à voix haute que le fort a été tenu et pris par les soldats du sud. Tout bruit cesse et vos paroles résonnent dans les salles marbrées, chaque serviteur s\'arrête et le conseil fait une pause. %employer% se lève.%SPEECH_ON%Serviteurs, allez chercher les pièces de cette langue remuante.%SPEECH_OFF%L\'un des conseillers crache, ce qu\'un enfant à collier nettoie rapidement.%SPEECH_ON%Ils auraient dû lui remettre sa paie pendant qu\'il était au fort. Comment ose-t-il ne serait-ce que respirer dans cette pièce ?%SPEECH_OFF%Les serviteurs se précipitent à vos côtés avec des bourses contenant %reward% couronnes. Le Vizir fait un signe de la main.%SPEECH_ON%Allez-vous-en, Mercenaire. J\'ai des gens que j\'engage pour lambiner, et vous n\'en faites pas partie.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A tenu un fort contre les nordistes");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
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
	}

	function spawnAllies()
	{
		local cityState = this.World.FactionManager.getFaction(this.getFaction());
		local mapSize = this.World.getMapSize();
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 3; x < o.X + 3; x = ++x )
		{
			for( local y = o.Y - 6; y <= o.Y - 3; y = ++y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean)
					{
					}
					else
					{
						local s = this.Math.rand(0, 3);

						if (tile.Type == this.Const.World.TerrainType.Mountains)
						{
							s = s - 10;
						}

						if (tile.HasRoad)
						{
							s = s + 10;
						}

						tiles.push({
							Tile = tile,
							Score = s
						});
					}
				}
			}
		}

		if (tiles.len() == 0)
		{
			tiles.push({
				Tile = this.m.Destination.getTile(),
				Score = 0
			});
		}

		tiles.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});
		local party = cityState.spawnEntity(tiles[0].Tile, "Regiment of " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 150) * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + cityState.getBannerString());
		party.setDescription("Soldats enrôlés fidèles à leur cité-état.");
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 3);
		party.getLoot().Ammo = this.Math.rand(0, 30);
		local r = this.Math.rand(1, 4);

		if (r <= 2)
		{
			party.addToInventory("supplies/rice_item");
		}
		else if (r == 3)
		{
			party.addToInventory("supplies/dates_item");
		}
		else if (r == 4)
		{
			party.addToInventory("supplies/dried_lamb_item");
		}

		local c = party.getController();
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(240.0);
		c.addOrder(guard);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"employerfaction",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHolyWar())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

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
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

