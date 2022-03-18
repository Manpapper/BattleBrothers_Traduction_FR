this.restore_location_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Caravan = null,
		Location = null,
		IsEscortUpdated = false
	},
	function setLocation( _l )
	{
		this.m.Location = this.WeakTableRef(_l);
	}

	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(70, 90) * 0.01;
		this.m.Type = "contract.restore_location";
		this.m.Name = "Rebuilding Effort";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Sécurisez les ruines %location% près de %townname%"
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

				if (r <= 15)
				{
					this.Flags.set("IsEmpty", true);
				}
				else if (r <= 30)
				{
					this.Flags.set("IsRefugees", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsSpiders", true);
				}
				else
				{
					this.Flags.set("IsBandits", true);
				}

				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Sécurisez les ruines %location% près de %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Location))
				{
					if (this.Flags.get("IsVictory"))
					{
						this.Contract.setScreen("Victory");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("ReturnForEscort");
					}
					else if (this.Flags.get("IsFleeing"))
					{
						this.Contract.setScreen("Failure2");
						this.World.Contracts.showActiveContract();
						return;
					}
					else if (this.Flags.get("IsEmpty"))
					{
						this.Contract.setScreen("Empty");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsRefugees"))
					{
						this.Contract.setScreen("Refugees1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("Spiders");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsBandits"))
					{
						this.Contract.setScreen("Bandits");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "RestoreLocationContract")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "RestoreLocationContract")
				{
					this.Flags.set("IsFleeing", true);
				}
			}

		});
		this.m.States.push({
			ID = "ReturnForEscort",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Escort",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Escortez les travailleurs à %location% près de %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = true;
				this.Contract.m.Home.getSprite("selection").Visible = false;
			}

			function update()
			{
				if (this.Contract.m.Caravan == null || this.Contract.m.Caravan.isNull() || !this.Contract.m.Caravan.isAlive() || this.Contract.m.Caravan.getTroops().len() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (!this.Contract.m.IsEscortUpdated)
				{
					this.World.State.setEscortedEntity(this.Contract.m.Caravan);
					this.Contract.m.IsEscortUpdated = true;
				}

				this.World.State.setCampingAllowed(false);
				this.World.State.getPlayer().setPos(this.Contract.m.Caravan.getPos());
				this.World.State.getPlayer().setVisible(false);
				this.World.Assets.setUseProvisions(false);
				this.World.getCamera().moveTo(this.World.State.getPlayer());

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(this.Const.World.SpeedSettings.EscortMult);
				}

				this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.EscortMult;

				if (this.Flags.get("IsFleeing"))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Location))
				{
					this.Contract.setScreen("RebuildingLocation");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsFleeing", true);

				if (this.Contract.m.Caravan != null && !this.Contract.m.Caravan.isNull())
				{
					this.Contract.m.Caravan.die();
					this.Contract.m.Caravan = null;
				}
			}

			function end()
			{
				this.World.State.setCampingAllowed(true);
				this.World.State.setEscortedEntity(null);
				this.World.State.getPlayer().setVisible(true);
				this.World.Assets.setUseProvisions(true);

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(1.0);
				}

				this.World.State.m.LastWorldSpeedMult = 1.0;
				this.Contract.clearSpawnedUnits();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success2");
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% offre du pain et de la bière, et semble heureux de se servir. Après quelques échanges sur la façon dont vous aimez %townname%, il en vient au fait.%SPEECH_ON%Cette région a été prospère par le passé, mais beaucoup de nos biens ont été pillés, brûlés ou pris par des brigands. Nous avons besoin que vous vous rendiez à la %location% à l'extérieur de %townname% et que vous la libériez de tout occupant afin que nous puissions y envoyer des matériaux en toute sécurité et que nos artisans puissent reconstruire ce que nous avions autrefois.%SPEECH_OFF%Il se penche sur la table et vous regarde fixement.%SPEECH_ON%Êtes-vous prêt à nous aider dans cette tâche ?%SPEECH_OFF% | %employer% prend une bouchée d'une pomme et vous lance le reste. Vous l'attrapez et vous regardez l'homme, sans trop savoir quoi en faire. Comme il ne dit rien, vous en prenez une bouchée et la lui rendez en le remerciant.%SPEECH_ON%Pas de problème, mercenaire. Aujourd'hui, c'est une bonne journée, même si, évidemment, j'ai besoin de quelque chose de votre part. %location% à l'extérieur de %townname% est, je crois, le refuge d'un groupe de brigands. Tout ce que j'ai besoin que vous fassiez, c'est d'aller là-bas et de nettoyer pour que je puisse restaurer l'endroit à sa gloire passée. Cela convient-il à vos... intérêts ?%SPEECH_OFF% | %employer% soupire en laissant tomber un parchemin de ses doigts comme si les nouvelles le pesaient lourdement.%SPEECH_ON%Nous ne recevons pas assez de couronnes de %townname%, et je crois que c'est parce que des brigands ont pris le contrôle de %location%. Ce n'est pas entièrement confirmé... Je devrais vraiment mieux suivre les nouvelles de mes gens, mais vous savez comment c'est.%SPEECH_OFF%Vous haussez les épaules.%SPEECH_ON%Bref, je veux que vous y alliez, que vous identifiez le problème, et que vous me fassiez un rapport pour que je vous donne des instructions. Ça semble assez simple, non ?%SPEECH_OFF% | En se penchant sur sa chaise, %employer% montre une carte qu'il a étalée sur son bureau.%SPEECH_ON%%location% à l'extérieur de %townname% a été détruite par des brigands. Maintenant, mercenaire, j'ai besoin de vos services pour reprendre le site et m'aider à lui redonner sa gloire d'antan ou quoi que ce soit que je raconte aux paysans de nos jours. Êtes-vous intéressé ?%SPEECH_OFF% | %employer% soupire, son souffle le quittant d'un côté, et son corps s'enfonçant dans sa chaise de l'autre.%SPEECH_ON%J'avais l'habitude de visiter %location% quand j'étais enfant. C'était un endroit si prospère, mais maintenant il est en ruine à cause de quelques brigands. Évidemment, je ne vous en parle pas juste pour m'en souvenir. J'ai besoin que vous y alliez et que vous repreniez l'endroit ! Tuez ces brigands et faites-moi un rapport immédiatement. Cette tâche simple vous intéresse-t-elle ?%SPEECH_OFF% | %employer% pose ses pieds sur son bureau, ce qui fait tomber un gobelet vide.%SPEECH_ON%Les paysans sont de retour. Ils m'embêtent. Ils disent que %location% à l'extérieur de %townname% a été détruite. D'habitude, je ne prends pas ces imbéciles au mot, mais certains de mes conseillers semblent avoir confirmé la nouvelle. Alors maintenant, je dois faire quelque chose.%SPEECH_OFF%Il vous pointe du doigt, en souriant.%SPEECH_ON%C'est là que vous intervenez. Allez à %location%, tuez ces brigands indisciplinés, puis faites-moi un rapport. Qu'est-ce que vous en pensez ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Cela semble assez facile. | Parlons des couronnes.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne ressemble pas à notre type de travail. | Je ne pense pas.}",
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
			ID = "Empty",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Arrivé à %location%, vous demandez aux hommes de se disperser et de se faufiler lentement dans la zone. Vous avancez vous-même, en vous faufilant prudemment vers les bâtiments dont les fenêtres grincent sous l'effet d'un vent impétueux. En enquêtant davantage, il ne semble y avoir personne ici. Pas même de preuve que quelqu'un vient de partir, non plus. Vous rassemblez vos hommes et retournez informer %employer%. | %location% est étonnamment vide. Vous vous promenez dans une des maisons, ramassant des tasses poussiéreuses et retournant des lits de paille, mais vous ne trouvez ni insecte ni homme. L'endroit a été complètement abandonné. Vous rentrez pour annoncer la nouvelle à %employer%. | Un cerf de Virginie hoche la tête et s'incline à la lisière de %location%, son carillon de bois étant la seule chose aux alentours qui semble être vivante. Si quelqu'un vivait ici, il est parti il y a longtemps. Les bâtiments sont vides.  On peut dire rien qu'en les regardant qu'il n'y a personne à l'intérieur. Les anciens dieux eux-mêmes pourraient détruire cet endroit et pas une seule personne ne le saurait ou ne s'en soucierait. C'est triste. Mieux vaut prévenir %employer% des \"bonnes\" nouvelles. | %location% est abandonné, comme vous le pensiez, mais il n'y a pas un seul bandit ou vagabond en vue. Vous ne pouvez pas leur reprocher de ne pas vouloir de cet endroit : même s'il y a peu de bâtiments dans les environs, tout ce qui les concerne vous met sur les nerfs. Vieux, fragiles... hantés ? Comme s'ils avaient été le théâtre de crimes incommensurables. Peut-être que les ouvriers de %employer% les détruiront et repartiront à zéro. | Vous ne trouvez pas un seul bandit à %location%. La moitié des bâtiments sont détruits tandis que l'autre moitié est vide et abandonnée. Quelques-uns des ouvriers de %employer% pourraient probablement remettre cet endroit en état, alors vous feriez mieux d'aller l'informer. | Vous trouvez une girouette enfoncée dans la boue et une carcasse de vache à côté. Une porcherie est recouverte d'herbe verte fraîche. L'un des bâtiments a été peint de façon verdoyante par une rampe de vignes. Les marques du cimetière sont inclinées et certaines sont à plat sur le sol. Vous trouvez une pelle et un trou à côté. De l'eau a rempli la tombe inutilisée et des oiseaux bleus s'y baignent. Vous vous demandez s'il ne vaudrait pas mieux laisser cet endroit en l'état, mais ce n'est pas à vous de vous poser la question. Vous retournez informer %employer% de l'état des choses. | Vous entrez dans %location% et demandez aux hommes de se séparer et de commencer à fouiller les bâtiments. N'étant pas du genre à laisser une investigation entièrement à une bande de mercenaires, vous entrez dans une maison voisine. La porte s'ouvre et presque immédiatement, votre pied se fraye un chemin dans un tas de pots et de casseroles laissés sur le sol en terre. En vous avançant, vous repérez quelques souris mortes dans un coin de la pièce, leurs squelettes encore en état de se déplacer, et à côté d'elles, un chat mort. Il y a un nid d'oiseau dans les combles. Des œufs jaunis dépassent du nid, mais vous n'avez pas encore vu et encore moins entendu un oiseau.\n\n%randombrother% entre par la porte et dit que rien n'a été trouvé. Si des brigands étaient ici, ils sont partis depuis longtemps. Vous dites aux mercenaires de rassembler les hommes car il est temps de rapporter vos découvertes à %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Pas ce à quoi je m'attendais.",
					function getResult()
					{
						this.Contract.setState("ReturnForEscort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Bandits",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Vous ordonnez à vos hommes de se déployer dans %location%. Vous vous faufilez dans la zone, votre épée à la main. En tournant un coin, vous trouvez un homme accroupi au-dessus de chiottes à ciel ouvert. Ses genoux vacillent à votre vue. Lorsqu'il saisit son arme, vous l'écrasez, dégageant rapidement son corps de votre lame et prévenant vos hommes des brigands qui commencent rapidement à sortir des bâtiments environnants. | %location% est calme, mais pas assez. Ici et là, vous entendez des craquements ou des grincements de bois, le tintement de chaînes que l'on déplace. Des personnes sont là. Vous dégainez votre épée et ordonnez à vos hommes de se préparer au combat. Aussitôt, un bandit ouvre d'un coup de pied la porte d'un bâtiment et en sort en courant, suivi d'une foule d'hommes tout aussi bruyants. | Brigands ! Comme vous l'aviez prévu. Non seulement ils sont à %localisation%, mais ils ne semblent pas se soucier d'être à découvert. Alors que vos hommes convergent vers la zone, les brigands rassemblent paresseusement leurs armes, comme s'ils avaient déjà traité avec des hommes de votre trempe. | %location% est complètement vide - sauf pour le grand groupe de brigands qui habite son centre, accroupis autour d'un feu et d'un cochon embroché. Ils vous regardent, puis regardent le cochon, puis vous regardent à nouveau. L'un d'entre eux tire une fourche charnue loin du feu.%SPEECH_ON%Bon sang, messieurs, on veut juste manger.%SPEECH_OFF%Vous dégainez votre épée et faites un signe de tête.%SPEECH_ON%Nous aussi.%SPEECH_OFF% | Vous trouvez un bandit juste à l'extérieur de %location%. Il porte le corps d'un paysan, ce qui est une bonne preuve pour que vous puissiez le tuer ainsi que tous ses amis. Vous ordonnez à vos hommes d'attaquer. | Des brigands surgissent d'un feu de camp lorsque vous approchez de %location%. Étonnamment, ils s'arment et sortent pour défendre leur \"territoire\" récemment acquis.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "RestoreLocationContract";
						p.TerrainTemplate = "tactical.plains";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.human_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditScouts, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spiders",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_110.png[/img]{Le blanc qui s'échappe des maisons de %location% et qui se tortille dans le vent ressemble à de la fumée, mais les bâtiments sont intacts. Alors que vous vous approchez des habitations, des paires d'yeux rouges s'allument dans l'obscurité des fenêtres. Les webknechts se précipitent, leurs pattes épineuses s'entrechoquent sur les lattes de bois et grattent les toits ondulés, la masse des corps noirs traversent le cadre de la fenêtre comme si les enfants du coin avaient envoyé plusieurs balles dans la fenêtre. | Vous trouvez %location% désert, mais il y a une pellicule blanche et soyeuse qui recouvre chaque recoin de l'endroit. %randombrother% touche la la pellicule et elle s'étire en suivant son bras et il doit la couper pour se libérer. En regardant devant vous, vous voyez des webknechts se précipiter vers vous, leurs pattes épineuses s'entrechoquant alors qu'ils se déplacent à une vitesse effrayante, leurs mandibules claquant de faim.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Aux armes !",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BeastsTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "RestoreLocationContract";
						p.TerrainTemplate = "tactical.plains";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Spiders, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{%location% est pleine de gens, d'accord, mais ce ne sont pas des brigands. Les réfugiés encombrent l'endroit comme des ordures en mouvement qui cherchent un endroit où se reposer.Les hommes, les femmes et même les enfants dégoûtants marchent docilement autour d'eux, bien trop faibles pour prêter attention à la bande de mercenaires qui vient d'arriver.  %randombrother% vient à vos côtés et demande ce qu'il faut faire.\n\n Si on les laisse rester, %employer% ne sera pas très content et vous ne serez probablement pas payé. D'un autre côté... regardez ces malheureux. Ils méritent de se reposer des problèmes qui les ont amenés ici. | Vous enlevez la longue-vue de votre œil et secouez la tête. %location% est remplie - ou peut-être infestée - de réfugiés. C'est mieux que des brigands, vous supposez, mais ça reste un problème. %employer% ne sera pas très content de leur présence, vous le savez bien. D'un autre côté, les gens la-bas... en haillons... avec plus d'os que de chair... fatigués... ils ne méritent pas d'être remis sur la route, n'est-ce pas ? | %randombrother% se retourne et crache. Il a les poings sur les hanches et secoue la tête.%SPEECH_ON%Bordel de merde.%SPEECH_OFF%Devant vous et le reste de la compagnie se tient un groupe hétéroclite de réfugiés. Vingt, trente peut-être. Surtout des hommes. Vous pensez que le reste du groupe, les femmes et les enfants, se cachent dans l'arrière-pays pour le moment. Le groupe semble trop épuisé pour vraiment communiquer avec vous. Ils se contentent d'échanger des regards et de hausser occasionnellement les épaules.\n\n Un de vos hommes vous parle en étant juste à côté de vous.%SPEECH_ON%On doit les foutre dehors si on veut l'argent de %employer%...%SPEECH_OFF%Mais un autre de vos hommes vient de l'autre côté...%SPEECH_ON%Oui, mais regarde ces gens. Peut-on vraiment les renvoyer dans le monde extérieur ? Je propse de les laisser rester ici.%SPEECH_OFF% | Des réfugiés se sont installés à %location%, probablement des survivants d'une guerre perdue. Ils ont parcouru la région à la recherche de ressources et semblent maintenant bien établis. Vous savez que %employer% ne sera pas ravi de leur présence - ils ne semblent pas particulièrement locaux. %randombrother% vient à vos côtés et fait un signe de tête en direction de la bande d'étrangers fatigués.%SPEECH_ON%Je pourrais prendre quelques hommes et les chasser, monsieur. Ce serait très facile.%SPEECH_OFF% | Il n'y a pas un seul bandit en vue. Au lieu de cela, vous avez trouvé un grand groupe de réfugiés qui a occupé %location%. Une foule d'âmes fatiguées s'est plutôt bien adaptée à l'endroit : ils ont quelques marmites qui cuisent sur des feux crépitants et semblent plutôt heureux de leur nouvelle \"maison\". Mais %employer% ne sera pas heureux de leur présence. Pas du tout. Vous ne voulez pas le croire, mais la froide vérité est que si vous voulez être payé, ces personnes doivent partir.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Mettez ces gens dehors.",
					function getResult()
					{
						return "Refugees2";
					}

				},
				{
					Text = "Ces gens n'ont nulle part où aller. Juste... laissons-les.",
					function getResult()
					{
						return "Refugees3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees2",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Vous ordonnez aux hommes de faire partir les réfugiés. Ils ne se battent pas beaucoup, ils se contentent de gémir sur la cruauté du monde. Tout ce à quoi vous pensez, c'est à combien vous allez être payé. | %randombrother% et quelques mercenaires reçoivent l'ordre d'entrer et de les mettre dehors. Heureusement, cela se passe sans effusion de sang, mais chaque réfugié qui passe devant votre regard le croise avec un air solennel et triste. Vous haussez les épaules. | Les réfugiés sont mis à la porte. L'un d'eux semble prêt à vous dire quelque chose, mais ferme la bouche. C'est comme s'il avait déjà dit ces pensées auparavant et qu'il se souvenait qu'elles n'avaient eu aucun effet à l'époque, tout comme elles n'en auraient pas maintenant. Vous appréciez le silence. | Vous demandez à %randombrother% de distribuer quelques denrées alimentaires aux réfugiés. Des produits qui étaient de toute façon sur le point de se gâter : des morceaux de pain qui font office de briques et un vieux ragoût qui pue la mort quand on enlève le couvercle. Les réfugiés prennent chaque objet comme si vous leur aviez donné le monde. Mais ils ne disent pas merci. Ils hochent la tête, haussent les épaules et continuent leur chemin.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Et bon débarras !",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-2);
						this.Contract.setState("ReturnForEscort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees3",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Vous laissez les réfugiés là où ils sont. Autant ne pas retourner voir %employer% parce qu'il ne sera pas content du tout. | Les hommes, les femmes et les enfants ont l'air d'en avoir assez d'être malmenés. Vous décidez de les laisser faire. | Ces gens en ont assez de ce monde. Vous ne pensez pas qu'ils survivront à un autre voyage dans la nature et vous décidez de les laisser là où ils se sont installés. | Les personnes hagardes et fatiguées ne méritent pas d'être expulsées de cet endroit. Vous devriez les laisser. Ils le transformeront en une zone exploitable bien assez tôt, bien que %employer% ne sera pas content de ne pas avoir ses propres gens dans la zone. | %employer% veut que son propre peuple s'installe ici, mais on dira que ces gens sont arrivés les premiers. Ça, et ils n'ont pas l'air de pouvoir vivre plus longtemps s'ils sont lâchés dans la nature.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous trouverons du travail ailleurs...",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "N'a pas réussi à sécuriser les ruines de " + this.Contract.m.Location.getRealName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{La bataille est terminée et %location% a été sécurisé. Il est temps de retourner voir %employer%. | Vous regardez la bataille et hochez la tête, heureux d'avoir encore une tête sur vos épaules avec laquelle hocher la tête. Il est temps de retournez voir %employer%. | Aussi rude que soit le combat, vous rassemblez vos hommes et vous vous préparez à retourner voir %employer%. | Le combat terminé, vous évaluez la scène et préparez un rapport. %employer% voudra savoir tout ce qui s'est passé ici.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On s'en est occupé.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RebuildingLocation",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{You Retournez à %location% and watch the workers fan out to the buildings. They get to work, piling slats of wood, putting up support beams, and one group is digging themselves a well. Looks like you can Retournez à %employer% now. | The builders thank you for getting them to the %location% safe and sound. They then turn and begin work, spreading out amongst the location and turning their hands to what tools are about them. The snicker-snacker and snoring haw of hammers and saws echo behind you as you leave to Retournez à %employer%. | Most of the builders head into %location% and begin preparations for its rebuilding. The foreman thanks you for getting them there safely as he knows the dangers of the world. He also thanks you for not betraying them all into an early grave. You take this gratitude with a smirk before starting the return journey to %employer%. | Well, the workers are here safe and sound. You turn back, returning to %employer% to get the pay you\'ve rightly earned. | It\'s been a long journey, there and back and there again, but it seems %location% is now about to get its legs underneath itself again. After making sure the workers are safe, you start the return trip to %employer% for your pay.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Time to get paid.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_98.png[/img]{%employer% glances at you as enter.%SPEECH_ON%So is it clear?%SPEECH_OFF%You nod. %employer% gets up and gives you instructions: you\'re to take a troop of builders back to the %location% so that they can rebuild it. | %employer% listens to your report and nods.%SPEECH_ON%I have a group of men going back to the %location% so that they can rebuild it. I need you to escort them. Got it? Good.%SPEECH_OFF% | Rolling up some scrolls, %employer% gives you your next instruction.%SPEECH_ON%I\'ve got a gang of men going back there to rebuild the place. A lot of crowns are involved here, so I need you to make sure those men get there in one piece. After that, come back and get your pay.%SPEECH_OFF% | %employer% sits back after listening to your report. He\'s sipping a goblet of cobra wine.%SPEECH_ON%News?%SPEECH_OFF%You tell him that the area has been cleared out. The man swigs the rest of the drink in one go and sets the cup down.%SPEECH_ON%Good... good. Now take a gang of my workers back there to help rebuild. Once they are finished, come back for your payday.%SPEECH_OFF% | %employer% sits back as you enter.%SPEECH_ON%I take it by your return that the %location% has been cleared, yes?%SPEECH_OFF%You confirm what the man wants to hear. He seems happy, though your job is not yet finished: %employer% wants you to take a gang of workers back to the area to help rebuild and resettle it. Once they\'re there safe and sound, Retournez à him for payment.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "This shouldn\'t take long.",
					function getResult()
					{
						this.Contract.spawnCaravan();
						this.Contract.setState("Escort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% welcomes your return with a satchel heavy with crowns. He waves you off, hardly even thanking you for your work. Although, screw him and screw the formalities. A bag of crowns is thanks enough. | You enter %employer%\'s abode and he waves you in. One of his men hands you a large satchel of crowns. You look at the man.%SPEECH_ON%How did you know they made it?%SPEECH_OFF%%employer% smiles sheepishly.%SPEECH_ON%I have many eyes and ears in these parts. Even the birds talk to me...%SPEECH_OFF%That explanation\'s good enough. | Returning to %employer%, you explain that the %location% is well underway to restoration. He thanks you.%SPEECH_ON%Well, would you look at that? A mercenary who keeps his word and gets his work done. A rarity. Here is your pay.%SPEECH_OFF%One of his men hands you a burlap sack heavy and sharpened by crowns. %employer% tips a hand.%SPEECH_ON%Be seeing you, sellsword.%SPEECH_OFF% | %employer% is in his study when you return. He shows a scroll to you and asks if you know what it is. You shrug.%SPEECH_ON%I\'m not a learned man. Not of the written word, anyway.%SPEECH_OFF%%employer% returns the shrug.%SPEECH_ON%What a shame. But you are a man of the spoken word. You\'ve owned up to your promises and, believe me, that is rare to see. Your pay is in the corner.%SPEECH_OFF%The pay is right where he says it is. You spend little time dawdling on ceremony and take it and make your leave. | %employer% sits back, seemingly smug with himself.%SPEECH_ON%I know how to pick \'em. Sellswords, that is. Most of my compatriots hire folks like you, but it goes tits up because they don\'t know how to spot a good man from the wag of a dead dog\'s tail. But you... I knew you were good on your word the second I saw you. Your pay, mercenary...%SPEECH_OFF%He slams a satchel of crowns on his desk.%SPEECH_ON%It\'s all there, but I understand if you want to count it.%SPEECH_OFF%You do count it - and it\'s all there.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Easy crowns.",
					function getResult()
					{
						this.Contract.m.Location.setActive(true);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Helped rebuild a " + this.Contract.m.Location.getRealName());
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
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Après la bataille",
			Text = "[img]gfx/ui/events/event_60.png[/img]{The building trek is in ruin and any hope to salvage %location% is lost. At least for the time being.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Darn it!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to protect a building trek");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "Après la bataille",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Your men failed to secure the %location% and so you shouldn\'t expect any pay.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Darn it!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to secure the " + this.Contract.m.Location.getName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnCaravan()
	{
		local faction = this.World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.m.Home.getTile(), "Worker Caravan", false, this.Const.World.Spawn.CaravanEscort, this.m.Home.getResources() * 0.4);
		party.getSprite("banner").Visible = false;
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.setDescription("A caravan of workers and building materials from " + this.m.Home.getName() + ".");
		party.setFootprintType(this.Const.World.FootprintsType.Caravan);
		party.setMovementSpeed(this.Const.World.MovementSettings.Speed * 0.5);
		party.setLeaveFootprints(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Location.getTile());
		move.setRoadsOnly(false);
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(move);
		c.addOrder(despawn);
		this.m.Caravan = this.WeakTableRef(party);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Location.getRealName()
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.State.setCampingAllowed(true);
			this.World.State.setEscortedEntity(null);
			this.World.State.getPlayer().setVisible(true);
			this.World.Assets.setUseProvisions(true);

			if (!this.World.State.isPaused())
			{
				this.World.setSpeedMult(1.0);
			}

			this.World.State.m.LastWorldSpeedMult = 1.0;

			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.Location == null || this.m.Location.isActive() || !this.m.Location.isUsable())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Caravan != null && !this.m.Caravan.isNull())
		{
			_out.writeU32(this.m.Caravan.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local caravan = _in.readU32();

		if (caravan != 0)
		{
			this.m.Caravan = this.WeakTableRef(this.World.getEntityByID(caravan));
		}

		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		this.contract.onDeserialize(_in);
	}

});

