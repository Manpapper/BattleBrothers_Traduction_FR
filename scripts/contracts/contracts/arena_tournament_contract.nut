this.arena_tournament_contract <- this.inherit("scripts/contracts/contract", {
	m = {},
	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = 1.3;
		this.m.Type = "contract.arena_tournament";
		this.m.Name = "Le tournoi d\'arène";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local items = [];
		items.extend(this.Const.Items.NamedWeapons);
		items.extend(this.Const.Items.NamedHelmets);
		items.extend(this.Const.Items.NamedArmors);
		local item = this.new("scripts/items/" + items[this.Math.rand(0, items.len() - 1)]);
		this.m.Flags.set("PrizeName", item.createRandomName());
		this.m.Flags.set("PrizeScript", item.ClassNameHash);

		if (item.isItemType(this.Const.Items.ItemType.Weapon))
		{
			this.m.Flags.set("PrizeType", "weapon");
		}
		else if (item.isItemType(this.Const.Items.ItemType.Shield))
		{
			this.m.Flags.set("PrizeType", "shield");
		}
		else if (item.isItemType(this.Const.Items.ItemType.Armor))
		{
			this.m.Flags.set("PrizeType", "armor");
		}
		else if (item.isItemType(this.Const.Items.ItemType.Helmet))
		{
			this.m.Flags.set("PrizeType", "helmet");
		}

		this.m.Flags.set("Round", 1);
		this.m.Flags.set("RewardApplied", 0);
		this.m.Flags.set("Opponents1", this.getOpponents(1).I);
		this.m.Flags.set("Opponents2", this.getOpponents(2).I);
		this.m.Flags.set("Opponents3", this.getOpponents(3).I);
		this.contract.start();
	}

	function getOpponents( _round, _index = -1 )
	{
		local twists = [];

		if (_round >= 2)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d - this.Const.World.Spawn.Troops.Swordmaster.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d - this.Const.World.Spawn.Troops.Swordmaster.Cost * 2); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
					}
				}

			});
		}

		if (_round >= 2)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d - this.Const.World.Spawn.Troops.HedgeKnight.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d - this.Const.World.Spawn.Troops.HedgeKnight.Cost * 2); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
					}
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.BanditRaider, _d - this.Const.World.Spawn.Troops.HedgeKnight.Cost - this.Const.World.Spawn.Troops.Swordmaster.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.BanditRaider);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.HedgeKnight, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.MasterArcher, true);
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost - this.Const.World.Spawn.Troops.Swordmaster.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Swordmaster, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost * 2 - this.Const.World.Spawn.Troops.Swordmaster.Cost * 2); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
					}
				}

			});
		}

		if (_round >= 2)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
					}
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.Executioner.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.Executioner.Cost * 2); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost - this.Const.World.Spawn.Troops.Executioner.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost * 2 - this.Const.World.Spawn.Troops.Executioner.Cost * 2); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 3)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertStalker);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d - this.Const.World.Spawn.Troops.DesertDevil.Cost - this.Const.World.Spawn.Troops.Executioner.Cost - this.Const.World.Spawn.Troops.DesertStalker.Cost); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertDevil, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.DesertStalker, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Executioner, true);
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 50 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.Gladiator.Cost * 2); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 3 && this.World.getTime().Days > 150 && this.Const.DLC.Wildmen)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator, true);
					_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator, true);

					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d - this.Const.World.Spawn.Troops.Gladiator.Cost * 4); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 2)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Mercenary, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Mercenary);
					}
				}

			});
		}

		if (_round == 3 && this.Const.DLC.Unhold)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Unhold, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Unhold);
					}
				}

			});
		}

		if (_round == 3 && this.Const.DLC.Lindwurm)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < this.Math.min(3, _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Lindwurm, _d)); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Lindwurm);
					}
				}

			});
		}

		if (_round == 2)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.SandGolemMEDIUM, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.SandGolemMEDIUM);
					}
				}

			});
		}

		if (_round == 2)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Gladiator, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Gladiator);
					}
				}

			});
		}

		if (_round == 1 && this.Const.DLC.Unhold)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Spider, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Spider);
					}
				}

			});
		}

		if (_round <= 2)
		{
			twists.push({
				R = 10,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.NomadOutlaw, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.NomadOutlaw);
					}
				}

			});
		}

		if (_round == 1)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.Serpent, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.Serpent);
					}
				}

			});
		}

		if (_round == 1)
		{
			twists.push({
				R = 5,
				function F( _c, _d, _e )
				{
					for( local i = 0; i < _c.getAmountToSpawn(this.Const.World.Spawn.Troops.HyenaHIGH, _d); i = ++i )
					{
						_c.addToCombat(_e, this.Const.World.Spawn.Troops.HyenaHIGH);
					}
				}

			});
		}

		if (_index >= 0)
		{
			return {
				I = _index,
				F = twists[_index].F
			};
		}
		else
		{
			local maxR = 0;

			foreach( t in twists )
			{
				maxR = maxR + t.R;
			}

			local r = this.Math.rand(1, maxR);

			foreach( i, t in twists )
			{
				if (r <= t.R)
				{
					return {
						I = i,
						F = t.F
					};
				}
				else
				{
					r = r - t.R;
				}
			}
		}
	}

	function startTournamentRound()
	{
		local p = this.Const.Tactical.CombatInfo.getClone();
		p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
		p.CombatID = "Arena";
		p.TerrainTemplate = "tactical.arena";
		p.LocationTemplate.Template[0] = "tactical.arena_floor";
		p.Music = this.Const.Music.ArenaTracks;
		p.Ambience[0] = this.Const.SoundAmbience.ArenaBack;
		p.Ambience[1] = this.Const.SoundAmbience.ArenaFront;
		p.AmbienceMinDelay[0] = 0;
		p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
		p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
		p.IsUsingSetPlayers = true;
		p.IsFleeingProhibited = true;
		p.IsLootingProhibited = true;
		p.IsWithoutAmbience = true;
		p.IsFogOfWarVisible = false;
		p.IsArenaMode = true;
		p.IsAutoAssigningBases = false;
		local bros = this.getBros();

		for( local i = 0; i < bros.len() && i < 5; i = ++i )
		{
			p.Players.push(bros[i]);
		}

		p.Entities = [];
		local baseDifficulty = 45 + 10 * this.m.Flags.get("Round");
		baseDifficulty = baseDifficulty * this.getScaledDifficultyMult();
		local opponents = this.getOpponents(this.m.Flags.get("Round"), this.m.Flags.get("Opponents" + this.m.Flags.get("Round")));
		opponents.F(this, baseDifficulty, p.Entities);

		for( local i = 0; i < p.Entities.len(); i = ++i )
		{
			p.Entities[i].Faction <- this.getFaction();
		}

		this.World.Contracts.startScriptedCombat(p, false, false, false);
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Equiper cinq de vos hommes avec des colliers d\'arène",
					"Entrer dans l\'arène et commencer le premier combat",
					"Ce combat sera à mort et vous ne pourrez vous retraiter ou récuperer de butin après.",
					"Après chaque combat vous pouvez partir ou commencer le prochain combat dès maintenant"
				];
				this.Contract.m.BulletpointsPayment = [
					"Vous recevez un %prizetype% réputé appelé %prizename% en gagnant les trois combat"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.Flags.set("Day", this.World.getTime().Days);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Flags.get("Round") > 1 && this.Contract.getBros() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFailure"))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.World.getTime().Days > this.Flags.get("Day") + 1)
				{
					this.Contract.setScreen("Failure2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("Round") > 1)
				{
					this.Contract.setScreen("Won" + this.Flags.get("Round"));
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Arena")
				{
					this.Flags.increment("Round");
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Arena")
				{
					this.Flags.set("IsFailure", true);
				}
			}

		});
	}

	function createScreens()
	{
		this.m.Screens.push({
			ID = "Task",
			Title = "À l\'arène",
			Text = "",
			Image = "",
			List = [],
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Nous gagnerons le grand prix !}",
					function getResult()
					{
						return "Overview";
					}

				},
				{
					Text = "{Nous ne sommes pas prêts pour ça.}",
					function getResult()
					{
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.State.getTownScreen().getMainDialogModule().reload();
						return 0;
					}

				}
			],
			function start()
			{
				this.Text = "[img]gfx/ui/events/event_155.png[/img]Des dizaines d\'hommes se mêlent à l\'entrée de l\'arène. Certains se tiennent stoïquement, ne souhaitant pas donner le moindre indice sur leurs capacités. D\'autres, en revanche, se vantent sans cesse avec aplomb, soit sincèrement confiants dans leurs compétences martiales, soit espérant que leur bravade masque toute leurs failles. \n\n";
				this.Text += "Le maître d\'arène; sans doutes; l\'homme le plus désintéressé par son travail que vous ayez jamais rencontré , il semble étonnamment vif aujourd\'hui. Il vous présente un parchemin dans une main et trois doigts levés dans l\'autre.%SPEECH_ON%Trois rounds ! Trois rounds, l\'un après l\'autre et chacun plus difficile que le précédent. Gagnez les trois avec les cinq mêmes  hommes pour gagner le grand prix, célèbre  %prizetype% nommé %prizename% ! C\'est le sahtournoimentah ! Vous voulez en être ou pas, ah ?%SPEECH_OFF%";
				this.Text += "Le maître de l\'arène continue.%SPEECH_ON%Quand vous serez prêts, demandez aux hommes qui vont se battre de s\'équiper des colliers d\'arène que nous vous donnerons.%SPEECH_OFF%.";
			}

		});
		this.m.Screens.push({
			ID = "Overview",
			Title = "Vue d\'ensemble",
			Text = "Ce tournoi d\'arène fonctionne ainsi. En Acceptez-vous les termes ?",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous participons au tournoi !",
					function getResult()
					{
						for( local i = 0; i < 5; i = ++i )
						{
							this.World.Assets.getStash().add(this.new("scripts/items/accessory/special/arena_collar_item"));
						}

						this.Contract.setState("Running");
						return 0;
					}

				},
				{
					Text = "Je vais devoir y réfléchir.",
					function getResult()
					{
						return 0;
					}

				}
			],
			ShowObjectives = true,
			ShowPayment = true,
			function start()
			{
				this.Contract.m.IsNegotiated = true;
			}

		});
		this.m.Screens.push({
			ID = "Start",
			Title = "À the Arena",
			Text = "[img]gfx/ui/events/event_155.png[/img]{Tandis que vous attendez votre tour, la soif de sang de la foule rampe dans l\'obscurité, des traînées de poussière tombent d\'en haut, les bruits de pas résonnent. Ils murmurent dans l\'attente, et rugissent lors des tueries. Le calme entre les batailles ne dure que quelques instants , et ce silence s\'envole lorsque la porte rouillée se soulève, les chaînes s\'entrechoquent, la foule s\'agite à nouveau. Vous sortez dans la lumière et le bruit de votre cœur est si tonitruant qu\'il pourrait sûrement pousser même un homme mort à avancer...| La foule de l\'arène est très dense, la plupart des gens sont ivres. Ils crient et hurlent, leur langage est un mélange de patois locales et de dialectes étrangers, mais leur soif de sang n\'a pas besoin d\'être exprimé autrement que par leurs visages enragés et leurs poings levés. Maintenant, les hommes de %companyname% vont rassasier ces fous furieux... | Les nettoyeurs se pressent dans l\'arène. Ils traînent les cadavres, ramassent ce qui vaut la peine d\'être ramassé et, de temps en temps, lancent un trophée dans la foule, ce qui suscite dans les gradins l\'effervescence pour le prochain combat. Les %companyname% font maintenant partie de celui-ci. |L\'arène attend, la foule s\'enflamme, et la gloire de %companyname% est à portée de main ! | La foule hurle alors que les hommes de %companyname% s\'avancent dans la fosse sanglante. Malgré la soif de sang des gens, vous ne pouvez vous empêcher de ressentir un sentiment de fierté dans votre cœur, sachant que c\'est votre compagnie qui est prête à faire le spectacle. | La porte se lève. On n\'entend que le cliquetis des chaînes, le grincement des poulies et les grognements des esclaves au travail. Lorsque les hommes des %compagnie% sortent des entrailles de l\'arène pour se rendre en son centre, ils peuvent entendre le sable crisser sous leurs pieds. Une voix étrange hurle dans une langue inconnue depuis les sommets du stade, mais les mots ne résonnent qu\'une fois avant que la foule n\'éclate en acclamations et en rugissements. Le moment est venu pour vos hommes de faire leurs preuves devant les yeux attentifs des roturiers.| Les affaires de %companyname% sont rarement exposées sous les yeux de ceux qui préfèrent se tenir éloignés de la violence. Mais dans l\'arène, le commun des mortels attend avidement la mort et la souffrance, et il grogne de soif de sang lorsque vos hommes entrent dans les fosses, et rugit lorsque les mercenaires sortent leurs armes se préparant au combat.| L\'arène a la forme d\'une grotte en souffrance, son sommet a été arraché par les dieux, révélant la vanité, la soif de sang et la sauvagerie de l\'homme. Et ces hommes qui sont là, crient et hurlent, si des éclaboussures de sang les atteignent, ils s\'en baignent le visage et se sourient les uns aux autres comme s\'il s\'agissait d\'une blague. Ils se battent entre eux pour des trophées et se délectent de la douleur des autres. C\'est devant ces gens que %companyname% se battra, les divertira et les divertira bien. | La foule de l\'arène est un mélange de classes, de riches et de pauvres, seuls les vizirs se distinguent de la populace par des places à l\'écart. Brièvement unifiés, les habitants de %townname% se sont généreusement réunis pour regarder hommes et monstres se massacrer les uns les autres. Avec enthousiasme, %companyname% cherche à faire leur part. | Des garçons assis sur les épaules de leurs pères, des jeunes filles jetant des fleurs aux gladiateurs, des femmes s\'éventant, des hommes se demandant s\'ils pourraient le faire. Ce sont les personnes de l\'arène - et les autres sont tous ivres et crient n\'importe quoi. Vous espérez que %companyname% pourra contribuer au moins une heure ou deux à divertir ce peuple de cinglés.| La foule rugit lorsque les hommes de %companyname% avancent dans la fosse. Il serait stupide de confondre excitation et enthousiasme, car dès que les applaudissements cessent, les chopes de bière vides et les tomates pourries s\'entrechoquent et les spectateurs ricanent de plaisir. On se demande si les hommes de %companyname% sont vraiment les mieux placés ici, mais on pense ensuite à l\'or et à la gloire qui sera gagné, et qu\'à la fin de la journée, ces bâtards dans les gradins rentreront chez eux dans leur vie de merde, et vous; vous  retournerez dans votre vie de merde aussi, mais au moins vos poches seront un peu plus profondes.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Gagnons ce prix!",
					function getResult()
					{
						this.Contract.startTournamentRound();
						return 0;
					}

				},
				{
					Text = "On ne va pas faire ça. Je ne veux pas mourir !",
					function getResult()
					{
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.State.getTownScreen().getMainDialogModule().reload();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnArenaCancel);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Won2",
			Title = "À l\'arène",
			Text = "[img]gfx/ui/events/event_147.png[/img]{La première des trois batailles est terminée. Vous devrez faire une évaluation attentive de vos hommes et déterminer s\'ils peuvent continuer jusqu\'au prochain round, qui ne sera que plus ardu que le précédent. Tout comme vous ne trouverez aucune fierté dans la tombe, il n\'y a aucune honte à vous en aller. Vous obtiendrez toujours quelques pièces, mais vous perdrez aussi toute chance de gagner le grand prix.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous gagnerons aussi le prochain tour !",
					function getResult()
					{
						this.Contract.startTournamentRound();
						return 0;
					}

				},
				{
					Text = "Il est temps pour nous d\'abandonner ce tournoi.",
					function getResult()
					{
						return "DropOut";
					}

				}
			],
			function start()
			{
				if (this.Flags.getAsInt("RewardsApplied") < 2)
				{
					this.Flags.set("RewardsApplied", 2);
					this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);

					if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
					{
						this.updateAchievement("Gladiator", 1, 1);
					}

					this.Contract.updateTraits(this.List);
				}

				this.Contract.m.BulletpointsObjectives = [
					"Le prochain combat commencera automatiquement",
					"Chaque combat sera à mort et vous n\'aurez pas la possibilité de sonner la retraite ou de récupérer de butins après",
					"Après chaque combat vous pouvez partir ou commencer le prochain combat dès maintenant"
				];
			}

		});
		this.m.Screens.push({
			ID = "Won3",
			Title = "À l\'arène",
			Text = "[img]gfx/ui/events/event_147.png[/img]L\'avant-dernière bataille est gagnée, ce qui vous laisse le choix d\'abandonner maintenant ou de vous lancer dans le combat final pour gagner le grand prix.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On passe à la ronde finale !",
					function getResult()
					{
						this.Contract.startTournamentRound();
						return 0;
					}

				},
				{
					Text = "Il est temps pour nous d\'abandonner ce tournoi.",
					function getResult()
					{
						return "DropOut";
					}

				}
			],
			function start()
			{
				if (this.Flags.getAsInt("RewardsApplied") < 3)
				{
					this.Flags.set("RewardsApplied", 3);
					this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);

					if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
					{
						this.updateAchievement("Gladiator", 1, 1);
					}

					this.Contract.updateTraits(this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Won4",
			Title = "À l\'arène",
			Text = "[img]gfx/ui/events/event_147.png[/img]Le combat est terminé, et le bourdonnement sourd dans vos oreilles est le rugissement de la foule, submergeant tous les sens dans une explosion d\'extase festive. Vous n\'êtes qu\'un avatar pour le peuple, un totem à travers lequel il peut ,par procuration, galvaniser sa propre vanité et son héroïsme vacant. En plus de l\'adoration de la foule, vous êtes récompensé par le grand prix : %prizename% !",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Victoire !",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess * 2);
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("RewardsApplied", 4);
				this.World.Statistics.getFlags().increment("ArenaFightsWon", 1);

				if (this.World.Statistics.getFlags().getAsInt("ArenaFightsWon") >= 10)
				{
					this.updateAchievement("Gladiator", 1, 1);
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new(this.IO.scriptFilenameByHash(this.Flags.get("PrizeScript")));
				item.setName(this.Flags.get("PrizeName"));
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 12,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				this.Contract.updateTraits(this.List);
			}

		});
		this.m.Screens.push({
			ID = "DropOut",
			Title = "Dans l\'Arène",
			Text = "[img]gfx/ui/events/event_147.png[/img]{Vous décidez de quitter le tournoi et de préserver vos hommes pour combattre un autre jour. Aucun huée ou sifflement n\'est entendu, car cela se fait dans le ventre de l\'arène. C\'est une question de procédure, au mieux, un petit échange de compensation monétaire et vous êtes renvoyé sur votre chemin. Aucun reproche n\'est fait, surtout pas de la part des autres gladiateurs qui comprennent mieux que quiconque le sens de cette décision. Et la foule ? Ils veulent juste du sang, ils ne remarqueront même pas que les personnes qu\'ils acclamaient ont disparus.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Peut-être la prochaine fois.",
					function getResult()
					{
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				local money = (this.Flags.get("Round") - 1) * 1000;
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Dans l\'Arène",
			Text = "[img]gfx/ui/events/event_147.png[/img]{Les hommes de %companyname% ont été vaincus, morts ou, peut-être pire, mutilés. Au moins, la foule est heureuse. Dans les gradins, toute démonstration, même celle qui se termine par une défaite, est une bonne démonstration.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Catastrophe!",
					function getResult()
					{
						local roster = this.World.getPlayerRoster().getAll();

						foreach( bro in roster )
						{
							local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

							if (item != null && item.getID() == "accessory.arena_collar")
							{
								bro.getFlags().increment("ArenaFights", 1);
							}
						}

						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "Dans l\'Arène"",
			Text = "{[img]gfx/ui/events/event_155.png[/img]L\'heure de votre combat d\'arène est passée, mais vous ne vous y êtes pas présentés. Peut-être que quelque chose de plus important s\'est présenté, ou peut-être que vous vous êtes simplement cachés comme des lâches. Quoi qu\'il en soit, votre réputation va en souffrir.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Mais...",
					function getResult()
					{
						this.Contract.getHome().removeSituationByID("situation.arena_tournament");
						this.Contract.getHome().getBuilding("building.arena").refreshCooldown();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Collars",
			Title = "Dans l\'Arène",
			Text = "{[img]gfx/ui/events/event_155.png[/img]L\'heure de votre match d\'arène a sonné, mais aucun de vos hommes ne porte le collier d\'arène et ils ne sont donc pas autorisés à entrer. Vous devez décider qui va combattre en les équipant des colliers d\'arène qui vous ont été donnés, et le match commencera dès que vous serez de nouveau dans l\'arène.",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Oh, c\'est vrai !",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
	}

	function getBros()
	{
		local ret = [];
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.arena_collar")
			{
				ret.push(bro);
			}
		}

		return ret;
	}

	function updateTraits( _list )
	{
		local roster = this.World.getPlayerRoster().getAll();
		local n = 0;

		foreach( bro in roster )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.arena_collar")
			{
				local skill;
				bro.getFlags().increment("ArenaFightsWon", 1);
				bro.getFlags().increment("ArenaFights", 1);

				if (bro.getFlags().getAsInt("ArenaFightsWon") == 1)
				{
					skill = this.new("scripts/skills/traits/arena_pit_fighter_trait");
					bro.getSkills().add(skill);
					_list.push({
						id = 10,
						icon = skill.getIcon(),
						text = bro.getName() + " is now " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
					});
				}
				else if (bro.getFlags().getAsInt("ArenaFightsWon") == 5)
				{
					bro.getSkills().removeByID("trait.pit_fighter");
					skill = this.new("scripts/skills/traits/arena_fighter_trait");
					bro.getSkills().add(skill);
					_list.push({
						id = 10,
						icon = skill.getIcon(),
						text = bro.getName() + " is now " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
					});
				}
				else if (bro.getFlags().getAsInt("ArenaFightsWon") == 12)
				{
					bro.getSkills().removeByID("trait.arena_fighter");
					skill = this.new("scripts/skills/traits/arena_veteran_trait");
					bro.getSkills().add(skill);
					_list.push({
						id = 10,
						icon = skill.getIcon(),
						text = bro.getName() + " is now " + this.Const.Strings.getArticle(skill.getName()) + skill.getName()
					});
				}

				n = ++n;
			}

			if (n >= 5)
			{
				break;
			}
		}
	}

	function getAmountToSpawn( _type, _resources, _min = 1, _max = 24 )
	{
		return this.Math.min(_max, this.Math.max(_min, _resources / _type.Cost));
	}

	function addToCombat( _list, _entityType, _champion = false )
	{
		local c = clone _entityType;

		if (c.Variant != 0 && _champion)
		{
			c.Variant = 1;
		}
		else
		{
			c.Variant = 0;
		}

		if (c.Variant != 0 && "NameList" in _entityType)
		{
			c.Name <- this.Const.World.Common.generateName(_entityType.NameList) + (_entityType.TitleList != null ? " " + _entityType.TitleList[this.Math.rand(0, _entityType.TitleList.len() - 1)] : "");
		}

		_list.push(c);
	}

	function getScaledDifficultyMult()
	{
		local p = this.World.State.getPlayer().getStrength();
		p = p / this.World.getPlayerRoster().getSize();
		p = p * 12;
		local s = this.Math.maxf(0.75, 1.0 * this.Math.pow(0.01 * p, 0.95) + this.Math.minf(0.5, this.World.getTime().Days * 0.005));
		local d = this.Math.minf(5.0, s);
		return d * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()];
	}

	function setScreenForArena()
	{
		if (!this.m.IsActive)
		{
			return;
		}

		if (this.getBros().len() == 0)
		{
			this.setScreen("Collars");
		}
		else if (this.World.getTime().Days > this.m.Flags.get("Day") + 1)
		{
			this.setScreen("Failure2");
		}
		else
		{
			this.setScreen("Start");
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"prizename",
			this.m.Flags.get("PrizeName")
		]);
		_vars.push([
			"prizetype",
			this.m.Flags.get("PrizeType")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.m.Home.getSprite("selection").Visible = false;
			this.m.Home.getBuilding("building.arena").refreshCooldown();
			local roster = this.World.getPlayerRoster().getAll();

			foreach( bro in roster )
			{
				local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

				if (item != null && item.getID() == "accessory.arena_collar")
				{
					bro.getItems().unequip(item);
				}
			}

			local items = this.World.Assets.getStash().getItems();

			foreach( i, item in items )
			{
				if (item != null && item.getID() == "accessory.arena_collar")
				{
					items[i] = null;
				}
			}
		}

		this.m.Home.removeSituationByID("situation.arena_tournament");
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSerialize( _out )
	{
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
	}

});

