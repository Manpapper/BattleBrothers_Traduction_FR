this.hunting_serpents_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_serpents";
		this.m.Name = "Chasser des Serpents";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Chassez les serpents aux alentours de " + this.Contract.m.Home.getName()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Const.DLC.Lindwurm && this.Contract.getDifficultyMult() >= 1.15 && this.World.getTime().Days >= 30)
					{
						this.Flags.set("IsLindwurm", true);
					}
				}
				else if (r <= 20)
				{
					this.Flags.set("IsCaravan", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Oasis)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 14, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Serpents", false, this.Const.World.Spawn.Serpents, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Giant serpents slithering about.");
				party.setFootprintType(this.Const.World.FootprintsType.Serpents);
				party.setAttackableByAI(false);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(999999);
				c.addOrder(wait);
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

				this.Contract.m.BulletpointsObjectives = [
					"Chassez les serpents dans les marais %direction% de " + this.Contract.m.Home.getName()
				];
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsCaravan"))
					{
						this.Contract.setScreen("Caravan2");
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Contract.isPlayerNear(this.Contract.m.Target, 700) && this.Math.rand(1, 100) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsLindwurm"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Lindwurm");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BeastsTracks;
						properties.EnemyBanners.push(this.Contract.m.Target.getBanner());
						properties.Entities.push({
							ID = this.Const.EntityType.Lindwurm,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/enemies/lindwurm",
							Faction = this.Const.Faction.Enemy
						});
						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else if (this.Flags.get("IsCaravan"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Caravan1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local f = this.Contract.m.Home.getFaction();
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "HuntingSerpentsCaravan";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.EnemyBanners.push(this.Contract.m.Target.getBanner());
						properties.Entities.push({
							ID = this.Const.EntityType.CaravanDonkey,
							Variant = 0,
							Row = 3,
							Script = "scripts/entity/tactical/objective/donkey",
							Faction = f
						});

						for( local i = 0; i < 2; i = ++i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.CaravanHand,
								Variant = 0,
								Row = 3,
								Script = "scripts/entity/tactical/humans/conscript",
								Faction = f
							});
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getType() == this.Const.EntityType.CaravanDonkey && _combatID == "HuntingSerpentsCaravan")
				{
					this.Flags.set("IsCaravan", false);
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
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% vous accueille dans sa chambre qui est un espace de luxe ultime - il y a de nombreuses parures de soies, de peaux, de femmes et de pierres précieuses. Tant de pierres précieuses.%SPEECH_ON%Mercenaire, il était temps que vous veniez. Nous avons un problème économique qui doit être réglé. Des serpents s\'attaquent méchamment à la population près des marécages %direction%  d\'ici. Mais plus important encore, nous voulons les écailles de ces serpents. Elles font les meilleurs...%SPEECH_OFF%L\'homme embrasse ses doigts.%SPEECH_ON%Sacs et chaussures. Regardez ces femmes, ne montrent-elles pas leur désir pour lesdites écailles ?%SPEECH_OFF%Les femmes regardent leurs mains ou parlent entre elles. Le Vizir frappe dans ses mains.%SPEECH_ON%Des sacs à main, mes douces et belles colombes, des sacs à main en écailles de serpent ! Oui, souriez. Et voilà. Vous voyez ? C\'était pas difficile, hein ? Très bien, mercenaire. L\'offre pour rapporter ces écailles est de %reward% couronnes. Pour un tel prix, acceptez-vous de vous atteler à cette tâche ?%SPEECH_OFF% | Vous trouvez %employer% en train de caresser un grand oiseau sauvage aux plumes roses et aux longues pattes noires. Il lui donne des grillons, dont l\'oiseau ne semble pas très friand.%SPEECH_ON%Ahh, je t\'ai trop gâté, petit Ronchon.%SPEECH_OFF%Il commence à nourrir l\'étrange créature avec de longs poissons argentés qu\'il sort, vivants, d\'un seau doré. Il parle sans vous regarder tandis que l\'oiseau engloutit poisson sur poisson.%SPEECH_ON%Nous avons appris que des serpents se trouvent dans les marécages %direction% d\'ici. Les écailles desdits serpents ont une valeur considérable, pas en or, bien sûr, mais en termes de biens raffinés. Nous désirons que vous vous y rendiez, que vous mettiez ces écailles dans vos sacs à dos et que vous reveniez ici au trot de vos petites jambes.%SPEECH_OFF%L\'homme lève un doigt, le lève encore plus, puis le pointe vers les carreaux sous ses pieds.%SPEECH_ON%Et pour cela, nous vous paierons %reward% couronnes.%SPEECH_OFF%L\'oiseau rose se nettoie et semble vous regarder à la place de son gardien. | %employer% est installé sur ce qui semble être le rebord d\'un sauna, mais ses pieds sont enfouis dans les mains de femmes allongées dans ce qui est une sorte d\'aqueduc intérieur. Elles utilisent des roseaux pour respirer, et d\'après ce que l\'on peut voir, elles massent les pieds de l\'homme. C\'est un spectacle absurde, mais le vizir y prête autant d\'attention qu\'à vous.%SPEECH_ON%Ah, le mercenaire arrive. Nous désirons, comme nous l\'avons toujours désiré, les écailles de serpents dont nous nous servons pour décorer nos richesses. Ces écailles peuvent être trouvées sur les serpents, qui eux-mêmes, hmmm, oui, peuvent être trouvés %direction% d\'ici. Dans les, hmmm, marécages.%SPEECH_OFF%L\'homme se penche en arrière et sort brièvement ses orteils de l\'eau. Ils les remuent alors qu\'il vous regarde fixement.%SPEECH_ON%L\'offre est de %reward% couronnes, êtes-vous d\'accord avec une offre aussi belle et équitable ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Je suis intéressé.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne ressemble pas à notre type de travail. | Ce n\'est pas le genre de travail que nous recherchons.}",
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
			Text = "[img]gfx/ui/events/event_161.png[/img]{Vous trouvez une longue enveloppe d\'écailles séchées, assez grosse pour y passer le bras, une vue aussi troublante que l\'est la sensation de ces écailles. Les serpents ne sont sans doute pas loin de ces enveloppes. | Un homme avec de la chique verte dans la bouche vous arrête. Il a une dague à la ceinture, avec des écailles pour manche et une tête de serpent en or pour pommeau.%SPEECH_ON%Vous êtes des chasseurs de serpents ? Je le ferais bien moi-même, comme en témoignent ma fascinante démarche et ma délicieuse dague, mais hélas, je préfère maintenant regarder les autres travailler. Je dirai là-bas, ils sont assez proches, ces petits serpents.%SPEECH_OFF%Vous faites vos adieux à l\'homme aussi vite que vous le pouvez. | Il y a quelques enfants qui jouent dans une flaque de boue, ils sont couverts de boue qu\'il s\'agisse de leurs genoux ou de leurs coudes. Ils vous regardent et vous demandent ce que vous faites. Quand vous leur dites ce que vous faites, les enfants rient.%SPEECH_ON%Des serpents ! C\'est du petit gibier ! Rien qui ne doive vous préoccuper en ce qui me concerne.%SPEECH_OFF% | Vous trouvez un tas de peaux de serpent enroulées autour d\'un tronc d\'arbre d\'une zone humide. Les serpents ont sans doute utilisé le tronc pour perdre leurs écailles. Et la taille des écailles, chacune bien plus grande qu\'une pointe de flèche, est une preuve suffisante que les serpents sont proches.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Gardez vos yeux ouverts.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_169.png[/img]{Le dernier des serpents est mort. Vous marchez sur sa tête, puis vous levez votre pied en réalisant que c\'est en fait la queue. Vous marchez le long du serpent et vous arrivez à sa tête et là vous la coupez net. C\'est beaucoup plus facile maintenant qu\'il ne se tortille pas et ne glisse pas. %employer% voudra vous voir revenir avec les têtes et avec toutes les écailles . | Vous vous promenez dans les champs en jetant des serpents dans un sac à dos, et même dans la mort, ils semblent se tordre les uns les autres dans le sac. Après avoir ramassé chaque serpent, vous préparez pour retouner voie %employer%. | Les serpents sont tous morts, comme l\'indique leur immobilité. Mais pour être sûr, vous allez leur couper la tête. Après vous être assuré que rien ne peut survivre à de tels dégâts, vous mettez les serpents dans un sac à dos et vous vous préparez à retourner voir %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Finissons-en avec ça, nous avons des couronnes à collecter.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Lindwurm",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_129.png[/img]Vous voyez le premier serpent se tordre sur ce qui ressemble à un arbre tombé dans une zone humide. Alors que vous gagnez du terrain sur le serpent, vous réalisez qu\'il y en a d\'autres qui se faufilent. Puis vous réalisez que l\'arbre où ils se sont réfugiés n\'est pas un arbre du tout : sa circonférence se déplace et se retourne, et vous voyez les écailles, aussi grosses que votre propre main, scintiller dans la lumière, et le lindwurm relève la tête et la tourne, ses yeux acérés sont d\'une noirceur impénétrable. Il ouvre sa gueule et rugit, l\'eau des marécages ondules tandis que son grognement déchire la surface.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Un Lindwurm!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Caravan1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_149.png[/img]{Les marécages n\'abritent habituellement pas de caravanes, et c\'est donc avec surprise que vous en trouvez une avec tous ses gardes courant dans tous les sens. Vous pensez d\'abord qu\'ils déchargent des marchandises, qu\'il s\'agit peut-être de bandits arrivés dans leur repaire secret, mais en vous approchant, vous voyez un garde se faire enrouler par un serpent meurtrier et tomber. Un autre garde se retourne et la gueule du serpent se referme sur sa tête. Les marchands sont attaqués !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Protégez-les !",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Caravan2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_169.png[/img]{La bataille terminée, le chef de la caravane vient vous voir personnellement.%SPEECH_ON%Je vous remercie, Mercenaire. Esclave des curonnes, vous l\'êtes peut-être, mais pas sans une ou deux chaînes ornées de ce que nous aimerions tous avoir, le sens du bien.%SPEECH_OFF%Vous n\'étiez ici que pour les serpents et la caravane n\'était qu\'une coïncidence, un supplément bienvenu d\'appât vivant qui éloignait les monstres de vos propres hommes. Vous êtes sur le point de lui dire, mais il vous interrompt avec un sac de trésors à la main.%SPEECH_ON%En récompense de votre intervention, Mercenaire. Que votre chemin vers les couronnes soit toujours plus doré.%SPEECH_OFF%En hochant la tête, vous lui serrez la main, puis vous vous mettez à collecter les écailles de serpent. Le marchand demande s\'il peut en avoir une, mais d\'une main sur votre épée, vous lui dites que ce n\'est pas un comptoir commercial. Il a compris le message.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On bouge !",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local e = this.Math.rand(1, 2);

				for( local i = 0; i < e; i = ++i )
				{
					local item;
					local r = this.Math.rand(1, 3);

					switch(r)
					{
					case 1:
						item = this.new("scripts/items/trade/spices_item");
						break;

					case 2:
						item = this.new("scripts/items/trade/silk_item");
						break;

					case 3:
						item = this.new("scripts/items/trade/incense_item");
						break;
					}

					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Vous recevez " + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{Un groupe de femmes se précipite sur vous. Elles sont beaucoup trop nombreuses, et la porte de la chambre de %employer% apparaît et disparaît, clignant de l\'œil derrière un tourbillon de foulards de soie, de plumes scintillantes, de bijoux étincelants, et le tourbillon général et le jet de cheveux plus fins que tout ce que vous avez jamais vu. Il y a aussi le bruit qui est une distraction considérable.\n\n On vous vole pratiquement les écailles et, étant chez le Vizir, vous ne résistez pas vraiment au vol. Alors que les femmes s\'enfuient en riant, une femme beaucoup plus âgée reste dans le sillage. Elle vous tend une sacoche de couronnes, votre paiement.%SPEECH_ON%Le vizir ne souhaite pas vous parler, Mercenaire. Il pense que c\'est indigne de lui.%SPEECH_OFF%Vous lui demandez si c\'est indigne d\'elle de vous rencontrez. Elle acquiesce.%SPEECH_ON%C\'est vrai, mais je préfère me charger de cette tâche, plutôt que le Vizir lui-même s\'en charge. Passez une bonne journée, Mercenaire, et que votre route vers les couronnes soit dorée.%SPEECH_OFF% | Vous êtes soulagé des écailles de serpent par une horde d\'assistants. Le Vizir est à leurs ordres, et les regarde d\'un air sévère depuis le fond de la pièce. Lorsqu\'ils partent, il lève les mains et applaudit. Quatre assistants s\'approchent, portant une sacoche. Vous pensez qu\'on vous surprend avec un salaire supplémentaire, mais lorsqu\'ils vous la remettent, vous pouvez très bien la tenir tout seul. Vous regardez par-dessus le couvercle pour voir le vizir sourire d\'un air penaud. Vous prenez les %reward_completion% couronnes et vous partez. | Sur le domaine du Vizir, les écailles de serpent ne restent pas longtemps dans vos mains. Vous trouvez une série d\'aides qui se précipitent tous à ses côtés pour venir vous soulager de la marchandise. Le Vizir lui-même est tout près, vous le savez, il vous observe probablement depuis une sorte de fenêtre ou à travers un portail. Mais vous ne le voyez jamais vraiment. Vous voyez cependant votre paiement, dans une sacoche de %reward_completion% couronnes donnée par un timide assistant.%SPEECH_ON%De notre grâce, pour vous.%SPEECH_OFF%Le serviteur dit, puis il part au trot et disparaît comme ça.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Hunted down some giant serpents");
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
		if (this.m.SituationID == 0 && this.Math.rand(1, 100) <= 50)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/moving_sands_situation"));
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

