this.hunting_lindwurms_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_unholds";
		this.m.Name = "Chasse aux Lindwurms";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.DifficultyMult = this.Math.rand(95, 135) * 0.01;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 800 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("Bribe", this.Math.rand(300, 600));
		this.m.Flags.set("MerchantsDead", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Chassez les Lindwurms aux alentours de " + this.Contract.m.Home.getName()
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
					this.Flags.set("IsAnimalActivist", true);
				}
				else if (r <= 25)
				{
					this.Flags.set("IsBeastFight", true);
				}
				else if (r <= 35)
				{
					this.Flags.set("IsMerchantInDistress", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 6, 12, [
					this.Const.World.TerrainType.Mountains
				]);
				local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 7);
				local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Lindwurm", false, this.Const.World.Spawn.Lindwurm, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("A Lindwurm - a wingless bipedal dragon resembling a giant snake.");
				party.setFootprintType(this.Const.World.FootprintsType.Lindwurms);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Lindwurms, 0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(2);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
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
					if (this.Flags.get("IsMerchantInDistress"))
					{
						if (this.Flags.get("MerchantsDead") < 5)
						{
							this.Contract.setScreen("MerchantDistressSuccess");
						}
						else
						{
							this.Contract.setScreen("MerchantDistressFailure");
						}
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 15.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsBeastFight"))
				{
					this.Contract.setScreen("BeastFight");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsMerchantInDistress"))
				{
					this.Contract.setScreen("MerchantDistress");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAnimalActivist"))
				{
					this.Contract.setScreen("AnimalActivist");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsEncounterShown"))
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

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID != "Lindwurms")
				{
					return;
				}

				if (_actor.getType() == this.Const.EntityType.CaravanDonkey || _actor.getType() == this.Const.EntityType.CaravanHand)
				{
					this.Flags.increment("MerchantsDead");
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
					if (this.Flags.get("BribeAccepted") && this.Math.rand(1, 100) <= 40)
					{
						this.Contract.setScreen("Failure");
					}
					else
					{
						this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_77.png[/img]{%employer% regarde fixement dans un pot lorsque vous le trouvez. Dans un coin, quelques paysans attendent et ont l\'air plutôt tendus. Vous demandez ce qui se passe. Votre employeur potentiel vous amène au pot, à l\'intérieur, vous trouvez un serpent qui se tortille. Il est docile, et les couleurs ne sont pas disposées de manière à suggérer qu\'il possède du poison. C\'est ce que vous lui dites. Il hausse les épaules et referme le couvercle.%SPEECH_ON%J\'allais le tuer et le manger de toute façon, et prendre sa peau pour en faire un fourreau pour mon poignard. Ce dont j\'ai besoin, c\'est que vous trouviez un serpent bien plus gros que celui-ci. Je parle de lindwurms, mercenaire. De gros serpents. Ils rôdent et mangent les gens dans l\'arrière-pays. Êtes-vous le genre à vouloir régler cette situation ?%SPEECH_OFF% | Vous trouvez %employer% en train de fouiller dans sa bibliothèque personnelle qui tient plus de la toile d\'araignée que du savoir. Il semble sentir votre entrée et vous demande si vous connaissez les lindwurms. Avant que vous ne puissiez répondre, il vous fait maintenant face, un parchemin à la main.%SPEECH_ON%J\'ai besoin que vous alliez dans l\'arrière-pays. Nous avons quelques monstres sur les bras. Ils tuent des fermiers, des marchands ambulants. Certains d\'entre eux étaient même très appréciés. Je pense que vous êtes l\'homme qu\'il nous faut pour nous débarrasser de ces bêtes. Êtes-vous intéressé ?%SPEECH_OFF%Vous voyez son parchemin se déployer un peu pour révéler une femme grossièrement dessinée et sa poitrine exposée. L\'homme s\'empresse de l\'enrouler et de le ranger dans son dos. Il sourit.%SPEECH_ON%Alors êtes vous intéressé ?%SPEECH_OFF% | Une ligne de paysans se tient devant la porte de %employer%. Vous les dépassez tous et lorsque quelques-uns protestent, vous saisissez la poignée de votre épée. %employer% sort de chez lui et s\'interpose.%SPEECH_ON%Du calme, du calme tout le monde. C\'est le mercenaire que je voulais engager. Monsieur, s\'il vous plaît, laissez-moi vous expliquer le problème dans les grandes lignes. Des Lindwurms ravagent l\'arrière-pays et nous avons besoin de mercenaire tel que vous pour les tuer tous. Êtes-vous intéressé ?%SPEECH_OFF%Les habitants, qui étaient plus tôt en colère, vous regardent maintenant comme si vous étiez leur sauveur.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{C\'est une bien grande tâche que vous nous demandez. | Je m\'attends à être bien rémunéré pour combattre un tel ennemi. | J\'attends de vous que vous fassiez de moi un homme riche pour cela.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{On dirait plutôt que ce dont vous avez besoin, ce sont des héros ou des idiots. | Le risque n\'en vaut pas la chandelle. | Je ne pense pas.}",
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
			Text = "[img]gfx/ui/events/event_66.png[/img]{%randombrother% tient un manchon de peau écailleuse de la longueur de son arme. Il l\'agite dans tous les sens, la peau s\'égratignant en râpes sèches. Vous lui dites de la poser et de rester sur ses gardes. Les lindwurms sont sans doute proches. | %randombrother% déclare avoir entendu un jour l\'histoire d\'un lindwurm qui avait tué quelqu\'un sans le manger.%SPEECH_ON%C\'est vrai. Ils ont dit que la créature aurait cracher de l\'eau verte et que l\'homme aurait fondu dans ses propres bottes. Ils ont dit que ça ressemblait à de la soupe avec ses tibias comme cuillères.%SPEECH_OFF%Une histoire dégoûtante, mais qui, espérons-le, gardera les hommes sur leurs gardes. Ces lindwurms ne doivent pas être loin. | L\'herbe est applatie par endroit cela pourraient laisser penser qu\'un gros serpent y soit passé. %randombrother% s\'accroupit à côté des traces.%SPEECH_ON%Soit c\'est une charrue qui ne creuse pas, soit ce sont les créatures que nous cherchons.%SPEECH_OFF%Vous acquiescez. Les lindwurms ne doivent pas être loin.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Soyez alertes!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_129.png[/img]{Vous êtes en train de vérifier la carte quand %randombrother% vous appelle. En levant les yeux, vous voyez les lindwurms émerger d\'un trou dans le sol, de grandes nappes de poussière s\'échappant de leurs flancs. Leurs corps se balancent au ras du sol tandis qu\'ils se dirigent vers la compagnie %companyname%. Vous dégainez votre épée et ordonnez à vos hommes de se mettre en formation. | La compagnie arrive à une grotte bordée de rochers. Mais alors que vous vous approchez, les rochers se détachent et bougent, il s\'agit manifestement des lindwurms. Vous reculez tandis que les bêtes se débarrassent de la poussière sur leur dos et font claquer leurs mâchoires dans un croassement guttural. Elles se tournent vers vous, les yeux s\'ouvrant et se fermant frénétiquement, et commencent à s\'avancer paresseusement, comme si vos mercenaires n\'étaient qu\'un inconvénient mineur à éliminer. Vous ordonnez à la compagnie de se mettre en formation. Les monstres, sentant peut-être que vous êtes plus menaçants, s\'élancent soudain vers l\'avant, sifflant puissamment tandis que leurs corps se déplacent sur le sol à une vitesse surprenante. | La compagnie %companyname% se dirige vers une colline couverte d\'os chacun des pas de la compagnie fait craquer des os. %randombrother% fait taire la compagnie et montre du doigt le sommet de la colline. Des lindwurms sont enroulés autour de sa crête comme s\'ils faisaient qu\'uns avec la terre. Semblant percevoir votre regard, les bêtes se déroulent et descendent la pente lentement. Leurs mâchoires claquent, leurs langues lèchent la poussière de leurs yeux, et elles ressemblent plus à des créatures somnambules qu\'à des monstres meurtriers. Mais à la seconde où ils foulent la terre plate, ils se redressent et bondissent en avant, leurs silhouettes serpentines traversant le cimetière, la queue de coq en poudre d\'os s\'élevant dans leur sillage. Dégainant votre épée, vous ordonnez d\'urgence aux hommes de se mettre en formation.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chargez !",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "AnimalActivist",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_17.png[/img]{Vous trouvez les lindwurms en train de se faufiler dans un abri creusé dans le sol, mais avant que vous ne puissiez engager le combat, un homme vous interrompt avec un sifflement humain. On dirait qu\'il ne s\'est pas rasé depuis des jours, qu\'il porte une grosse valise sur les deux épaules et que ses cheveux sont attachés par un bandana. À part son air hagard, il n\'a pas d\'arme sur lui. Vous lui demandez ce qu\'il veut. Il parle précipitamment et à voix basse.%SPEECH_ON%Vous êtes ici pour tuer les lindwurms ?%SPEECH_OFF%Les méchants monstres ressemblant à des serpents se tortillent au loin, semblant jouer les uns avec les autres comme le feraient des chiots ou des chatons. Vous acquiescez et lui dites que ce sont des tueurs et que vous avez été payé pour les tuer tous. L\'homme pince les lèvres.%SPEECH_ON% Vous voyez cette lueur sur leur écailles ? Elle leur est propre, et ils sont les derniers de leur espèce. Ce sont des lindwurms très rares, monsieur, et ce serait épouvantable pour le monde lui-même que de les tuer tous. Et si je vous donnais %bribe% couronnes et, euh, vous avez été payé par quelqu\'un, n\'est-ce pas ? Alors prenez ça aussi.%SPEECH_OFF%Il sort de sa sacoche une grande peau de lindwurm toute griffée et propose de vous la remettre.%SPEECH_ON%Dites à votre employeur que vous avez trouvé et tué les lindwurms et montrez-lui ceci. Ils ne verront pas la différence. Et si vous envisagez de me tromper, laissez-moi vous dire que j\'ai l\'air un peu fou, mais que je le suis vraiment. Et un cinglé comme moi ne survivrait pas en suivant ces lindwurms géants, merveilleux et magnifiques s\'il ne connaissait pas une ou deux choses, compris ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Hors du chemin, imbécile. Nous avons des bêtes à tuer.",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				},
				{
					Text = "Très bien. J\'accepte votre offre.",
					function getResult()
					{
						return "AnimalActivistAccept";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsAnimalActivist", false);
			}

		});
		this.m.Screens.push({
			ID = "AnimalActivistAccept",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_17.png[/img]{D\'après vous, les lindwurms ne sont pas vraiment votre problème, vous avez juste été payé pour vous en occuper. Et vous pourriez être payé deux fois si la peau du protecteur des lindwurms, qui a perdu la tête, trompait %employer%.\n\nVous acceptez le marché. L\'imbécile vous remercie et vous prend dans ses bras de façon inattendue. Il sent très mauvais et ses cheveux sont devenus si épais et emmêlés que de minuscules insectes y ont creusé des grottes et peuvent être vus en train de vous regarder. Un minuscule lézard se faufile entre les tiges puantes et s\'empare d\'une des bestioles. Vous repoussez l\'homme et lui souhaitez bonne chance dans ce qu\'il est en train de faire. Il tend le pouce et l\'auriculaire et agite la main.%SPEECH_ON%Vous, monsieur, êtes juste.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Juste, oui.",
					function getResult()
					{
						local bribe = this.Flags.get("Bribe");
						this.World.Assets.addMoney(bribe);

						if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
						{
							this.Contract.m.Target.getSprite("selection").Visible = false;
							this.Contract.m.Target.setOnCombatWithPlayerCallback(null);
							this.Contract.m.Target.die();
							this.Contract.m.Target = null;
						}

						this.Flags.set("BribeAccepted", true);
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				local bribe = this.Flags.get("Bribe");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + bribe + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "BeastFight",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_129.png[/img]{Des nuages de poussière s\'échappent d\'une lointaine entrée de grotte. En vous approchant, vous pouvez entendre le sifflement des lindwurms et le grognement intermittent d\'une toute autre chose.%SPEECH_ON%Regardez !%SPEECH_OFF%%randombrother% montre le bord de la grotte. Il y a deux nachzehrers qui s\'attaquent à un lindwurm, l\'un d\'entre eux s\'accrochant à la queue, l\'autre luttant avec ses mains contre la gueule du monstre pour ne pas se faire mordre. Les monstres se battent entre eux !\n\nSecouant la tête, vous sortez votre épée et ordonnez aux hommes de se mettre en formation. On dirait que ça va être une vrai bataille, s\'il y en a jamais eu une.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je ne sais pas si c\'est une bonne ou une mauvaise chose.",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Lindwurms";
						p.Music = this.Const.Music.BeastsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Ghouls, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "MerchantDistress",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{Vous apercevez un marchand et son chariot qui remontent la route. L\'arrière du chariot se soulève et le garde de la caravane à l\'arrière est projetée comme une poupée de chiffon. Une traînée verte se glisse derrière la caravane et une autre sur le côté. Le marchand se retourne et saute dans la caravane alors que les lindwurms commencent leur assaut. Ce sont sans doute les créatures que vous cherchiez. À votre commandement, la compagnie %companyname% se précipite en avant avant que la caravane ne soit détruite.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Attaquez !",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Lindwurms";
						p.Music = this.Const.Music.BeastsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Random;
						p.Entities.push({
							ID = this.Const.EntityType.CaravanDonkey,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/objective/donkey",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanDonkey,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/objective/donkey",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanHand,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/humans/caravan_hand",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanHand,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/humans/caravan_hand",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						p.Entities.push({
							ID = this.Const.EntityType.CaravanHand,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/humans/caravan_hand",
							Faction = this.Const.Faction.PlayerAnimals,
							Callback = null
						});
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				},
				{
					Text = "Replions-nous !",
					function getResult()
					{
						this.Flags.set("IsMerchantInDistress", false);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "MerchantDistressSuccess",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{La bataille est terminée. Vous demandez aux hommes de dépecer les quelques lindwurms pendant que vous allez parler au marchand. Il s\'incline en guise de remerciement et embrasse votre doigt dépourvu d\'anneau.%SPEECH_ON%Merci, monsieur, merci ! Ohhh, mon chariot ! Ma marchandise !%SPEECH_OFF%Ses yeux se perdent dans les restes de sa caravane. Il s\'effondre, les genoux dans les débris, et secoue la tête.%SPEECH_ON%J\'aimerais avoir de quoi vous payer, étranger, mais je n\'ai plus rien.%SPEECH_OFF%Puis il lève le doigt. Il se relève d\'un bond et vous demande si vous avez une carte. Vous lui montrez ce que vous avez, et il sort une plume d\'oie.%SPEECH_ON%Je connais un endroit où l\'on dit qu\'il y a un grand trésor. Je ne sais pas si c\'est vrai ou non, mais la rumeur vaut de l\'or si c\'est le cas !%SPEECH_OFF%Oui, si. Vous remerciez tout de même le marchand pour sa générosité et lui souhaitez bonne chance pour la suite de son voyage. Quant à la compagnie %companyname%, elle doit retournez voir %employer% pour être payée.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous devrions visiter cet endroit un jour.",
					function getResult()
					{
						this.Contract.setState("Return");
						local bases = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local candidates_location = [];

						foreach( b in bases )
						{
							if (!b.getLoot().isEmpty() && !b.isLocationType(this.Const.World.LocationType.Unique) && !b.getFlags().get("IsEventLocation"))
							{
								candidates_location.push(b);
							}
						}

						if (candidates_location.len() == 0)
						{
							return 0;
						}

						local location = candidates_location[this.Math.rand(0, candidates_location.len() - 1)];
						this.World.uncoverFogOfWar(location.getTile().Pos, 700.0);
						location.getFlags().set("IsEventLocation", true);
						location.setDiscovered(true);
						this.World.getCamera().moveTo(location);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "MerchantDistressFailure",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{La bataille est terminée. La moitié de vos hommes s\'occupent de dépecer les lindwurms pour les montrer à %employer% à votre retour. L\'autre moitié fouille les restes de la caravane du marchand. Il n\'y a rien d\'intéressant à trouver, pas même de l\'or. Tout ce qui avait de la valeur a été réduit en miettes pendant le combat. Le marchand lui-même a été déchiré en deux et les jambes sont retrouvés un peu plus loin, les poches retournées et vides, %randombrother% accroupi à côté des restes. Il hoche de la tête.%SPEECH_ON%Eh bien, c\'est une bien triste façon de partir.%SPEECH_OFF%Vous répondez par un signe de tête, puis vous demandez aux hommes de préparer leurs affaires. Il est temps de retourner voir votre employeur et de percevoir votre salaire.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au moins, nous avons mis fin à ces bêtes.",
					function getResult()
					{
						this.Contract.setState("Return");
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
			Text = "[img]gfx/ui/events/event_130.png[/img]{Combattre les lindwurms, c\'était comme prendre un couteau à beurre et le planter dans un panier de vipères. Ils se battaient comme s\'ils venaient d\'un autre monde, sifflant, crachant et mordant, mais ils ne faisaient pas le poids face à la détermination et à l\'habileté de la compagnie %companyname%. Vous demandez aux hommes d\'écorcher et de dépecer les créatures et de les préparer avant de retourner voir %employer% pour un salaire bien mérité. | Les lindwurms gisent par terre enfin tués. Votre compagnie se met à fouiller les cadavres à distance, pour s\'assurer que ces salauds sont bien morts. Quelques-uns se tortillent et se retournent, mais c\'est à peu près tout ce qu\'ils ont de vivant. Vous demandez à ce que les gros lézards soient scalpés et dépecés. %employer% attendra des preuves, après tout. | Vous vous accroupissez à côté d\'un lindwurm et passez votre main sur sa peau. D\'après ce que vous avez compris, les écailles sont suffisamment longues et tranchantes pour vous couper les doigts si vous les coincez entre les pointes. Vous vous tenez ensuite debout au-dessus de la tête et fixez sa gueule, mesurant ses dents avec vos mains et son ventre avec l\'acier de votre épée. %randombrother% vient à vos côtés et vous demande ce que vous allez faire. Vous retirez votre épée de la gorge du lindwurm, l\'essuyez et la rengainez correctement. Vous ordonnez aux hommes de dépecer quelques bêtes et de se préparer à retourner voir %employer%. | La bataille terminée, vous faites dépecer les lindwurms et les examinez pour en extraire tout ce qui a de la valeur. Il ne faut pas longtemps pour que le champ de bataille empeste, les lézards trop grands étant dépouillés des écailles qui les protégeaient autrefois. Leur musculature maladive et luisante est exposée à la vue de tous, une nudité et une vulnérabilité pour ces monstres. %randombrother% renifle et passe sa manche sous son nez. Il hoche la tête devant son œuvre.%SPEECH_ON%Rien de plus qu\'une créature ordinaire, juste un peu plus grande qu\'elle ne devrait l\'être.%SPEECH_OFF%C\'est bien vrai. Vous ordonnez aux hommes de rassembler ce qu\'ils ont et de se préparer à retourner voir %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous avons réussi.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_77.png[/img]{Vous entrez dans le bureau de %employer% dans lequel vous traînez de la peau d\'un lindwurm. Il lève les yeux de son bureau, regarde les écailles et la longue peau reptilienne, vous jette un coup d\'œil, puis jette un coup d\'œil à son trésorier et hoche la tête. Le trésorier prend une sacoche de couronnes et vous la remet. %employer% retourne à son travail, s\'adressant à vous tout en écrivant avec une plume d\'oie.%SPEECH_ON%Bon travail, sellsword. Je pense que notre argent a été utilisé à bon escient. Laissez la peau. J\'ai un homme qui peut réparer des bottes avec.%SPEECH_OFF%Est-ce que la compagnie %companyname% vient de travailler pour offrir de nouvelles bottes à cet imbécile ? Vous secouez la tête et partez. | %employer% vous accueille avec votre butin, un long morceau de peau de lindwurm, écailleux et coupant. Vous la lancez sur le sol où elle glisse comme une veste en cuir rigide. Le maire hoche la tête.%SPEECH_ON%Très, très bien travaillé, mon cher monsieur ! Tout à fait excellent. Votre paiement, comme promis.%SPEECH_OFF%L\'homme vous tend une sacoche lourde de couronnes bien méritées. | %employer% se trouve en train de se réchauffer près d\'un feu. Il se retourne sur son siège pour voir la peau d\'un lindwurm que vous avez apportée avec vous. Le maire hoche la tête.%SPEECH_ON%Très bon travail, mercenaire. Je suis curieux de savoir si ces bâtards de lézards font repousser leurs membres ? J\'ai entendu des histoires sur les reptiles qui font ce genre de choses.%SPEECH_OFF%Vous haussez les épaules et déclarez que chaque créature a été tuée avec autant de curiosité scientifique qu\'une bonne épée puisse le faire. %employer% se pince les lèvres.%SPEECH_ON%Ah. C\'est vrai. Eh bien, votre paiement, comme convenu, est là-bas, vous pouvez vous servir.%SPEECH_OFF%Il retourne auprès du feu, s\'emmitoufle dans une couverture et sirote le bord d\'une tasse fumante. | %employer% se trouve à l\'extérieur, entouré de paysans en délire. Vous criez au-dessus de la foule et montrez la peau de lindwurm que vous avez apportée. La foule se calme un instant, un chuchotement entre ses membres se fait entendre, puis se remet à crier. Vous vous pincez les lèvres, jouez des coudes pour vous frayer un chemin dans la foule et exiger le salaire qui vous est dû. %employer% hurle aux paysans de se disperser et de vous laisser passer. Tandis que deux gardes se tiennent à proximité, il vous tend une sacoche en cuir.%SPEECH_ON%Bon travail, mercenaire. Si tout n\'est pas là, n\'hésitez pas à revenir me tuer. Ça ne me dérangera pas, pas en ce jour maudit.%SPEECH_OFF%Alors que vous prenez la sacoche et que vous partez, un paysan fait un doigt d\'honneur au maire.%SPEECH_ON%Je vous le dis, ce salaud, mon supposé \"voisin\", a volé mes oiseaux et s\'il ne me les rend pas, je vais brûler toute sa ferme !%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une chasse réussie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Débarrasser la ville des lindwurms");
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
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Vous trouvez %employer% dans son bureau, qui est rempli de gardes. Ne sachant pas trop ce qui se passe, vous montrez la chair de lindwurm au maire et réclamez votre salaire. Ses doigts s\'entrechoquent avant de se déployer en éventail comme une scie à bois.%SPEECH_ON%Je ne pense pas que ce soit le cas, mercenaire. Je ne sais pas où vous avez trouvé cette putain de peau que vous transportez, et croyez-moi, je peux dire qu\'elle est vieille comme le monde et qu\'elle ne date pas d\'hier, mais on me signale encore des lézards qui font des ravages dans l\'arrière-pays, alors si ça ne vous dérange pas, quittez gentiment cette ville avant que je ne vous envoie un tout autre prédateur.%SPEECH_OFF%Prenant une profonde inspiration, vous regardez les gardes. Ils sont trop nombreux pour être combattus. %employer% soupire.%SPEECH_ON%Si c\'est votre honneur que vous voulez protéger, ne le faites pas. J\'ai déjà dissuadé ces gens de vous tendre une embuscade à la seconde où vous passeriez cette porte. J\'ai fait ça avec le peu de respect qu\'il me reste pour vous. Ne le gâchez pas, voulez-vous ?%SPEECH_OFF%Vous n\'avez rien à y redire. Les choses sont ce qu\'elles sont et vous ne pouvez vous en prendre qu\'à vous-même de toute façon. Vous fermez la porte et partez.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Ce n\'est pas vraiment une surprise.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "A tenté d\'escroquer la ville pour lui soutirer de l\'argent");
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
			"bribe",
			this.m.Flags.get("Bribe")
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/ambushed_trade_routes_situation"));
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
				this.m.Target.getController().getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(true);
				this.m.Target.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
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

