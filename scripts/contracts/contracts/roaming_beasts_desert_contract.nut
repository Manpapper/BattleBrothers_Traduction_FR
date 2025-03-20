this.roaming_beasts_desert_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.roaming_beasts_desert";
		this.m.Name = "Chasse aux Bêtes";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Chassez ce qui terrorise " + this.Contract.m.Home.getName()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 40 || this.World.getTime().Days <= 15 && r <= 80)
				{
					this.Flags.set("IsHyenas", true);
				}
				else if (r <= 80)
				{
					this.Flags.set("IsSerpents", true);
				}
				else
				{
					this.Flags.set("IsGhouls", true);
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10);
				local party;

				if (this.Flags.get("IsHyenas"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Hyènes", false, this.Const.World.Spawn.Hyenas, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Une meute de hyènes en quête de proies.");
					party.setFootprintType(this.Const.World.FootprintsType.Hyenas);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Hyenas, 0.75);
				}
				else if (this.Flags.get("IsGhouls"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Nachzehrers", false, this.Const.World.Spawn.Ghouls, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Un nuée de charognards nachzehrers.");
					party.setFootprintType(this.Const.World.FootprintsType.Ghouls);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Ghouls, 0.75);
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Serpents", false, this.Const.World.Spawn.Serpents, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Des serpents géants se faufilant partout.");
					party.setFootprintType(this.Const.World.FootprintsType.Serpents);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Serpents, 0.75);
				}

				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
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
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsHyenas"))
					{
						this.Contract.setScreen("CollectingHyenas");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("CollectingGhouls");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSerpents"))
					{
						this.Contract.setScreen("CollectingSerpents");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsWorkOfBeastsShown") && this.World.getTime().IsDaytime && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 9000) <= 1)
				{
					this.Flags.set("IsWorkOfBeastsShown", true);
					this.Contract.setScreen("WorkOfBeasts");
					this.World.Contracts.showActiveContract();
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
					if (this.Flags.get("IsHyenas"))
					{
						this.Contract.setScreen("Success1");
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("Success2");
					}
					else if (this.Flags.get("IsSerpents"))
					{
						this.Contract.setScreen("Success3");
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{En entrant chez %employer%, vous le trouvez debout sur un tapis original truffé de morceaux de corps humains. Il lève les yeux vers vous.%SPEECH_ON%Il s\'agissait de tueurs de bêtes, apparemment, et maintenant ils sont là, récupérés de la tâche à laquelle ils s\'étaient consacrés.%SPEECH_OFF%Le vizir hoche la tête et quelques assistants viennent enrouler le tapis. La chair et les entrailles s\'agitent, se pressent et jaillissent par les côtés. Les serviteurs soulèvent le tapis, le jettent sur leurs épaules et le sorte, avec une main démembrée qui pend librement d\'une extrémité. %employer% frappe dans ses mains.%SPEECH_ON%Dans le désert vit mon problème, une horde de bêtes cruelles qui s\'en prennent aux habitants. J\'ai regardé dans les Feux Éternels et j\'ai choisi de chercher des mercenaires pour m\'aider à résoudre ce problème monstrueux. Mercenaire, trouvez-vous que %reward% couronnes est une somme suffisante pour acheter votre loyauté temporaire ?%SPEECH_OFF% | Vous entrez dans le domicile de %employer%, mais un véritable mur de gardes vous empêche de vous approcher davantage. Il se tient au pied d\'un trône d\'où descend un court escalier. Il le descend avec détermination à chaque pas et arrive sur le palier. Un homme se retourne vers lui et le Vizir acquiesce. L\'homme se retourne vers vous et vous tend un parchemin. On y lit que des créatures d\'un genre indéterminé font des ravages dans le territoire de %townname%. Si vous trouvez et éliminez ces monstres, vous serez récompensé d\'une manière adaptée à la tâche, %reward% couronnes. | %employer% est retrouvé entouré d\'un harem de femmes à moitié nues. Il brandit une main coupée qui, étonnamment, semble fasciner les femmes plus que les dégoûter. Lorsqu\'il vous voit, le Vizir laisse tomber la main et s\'essuie sur l\'épaule d\'une des femmes, suscitant cette fois un certain dédain, quoique atténué.\n\n%employer% claque des doigts à un serviteur qui se précipite avec une jarre de vin. Le Vizir soupire, chasse le serviteur et claque une nouvelle fois des doigts. Un deuxième serviteur se rend compte qu\'il a été appelé et s\'avance, vous tend rapidement un parchemin dont il prononce les mots à haute voix : des monstres ont été repérés près de %townname% et ils doivent être éliminés de toute urgence.\n\n La récompense pour cela n\'est pas prononcée aussi fort. Au lieu de cela, le serviteur tapote la page où un chiffre a été écrit : %reward% couronnes. | %employer% se tient devant une carte si énorme qu\'elle ne peut tenir sur aucune table, elle est donc étalée sur le sol marbré. Cela semble inutile, car une carte pourrait facilement être mise sur la table si elle était dans une résolution appropriée, mais vous gardez cette observation pour vous. Le Vizir marche sur le papier et désigne un endroit.%SPEECH_ON%Des bêtes se sont attaquées à cette partie du territoire et veillent à sa destruction d\'une manière que je n\'ai pas acceptée. J\'ai des affaires plus importantes à régler que d\'aller là-bas.%SPEECH_OFF%Il montre une autre zone de la carte qui ressemble à un tas de désert vide. Il poursuit .%SPEECH_ON%J\'ai donc besoin d\'un homme tel que vous, mercenaire, pour vous occuper de ces monstres errants. En fonction de votre réussite, vous serez récompensé par %reward% de couronnes, ce qui devrait être plus que convenable.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Parlons plus en détail du paiement. | C\'est notre genre de travail.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne ressemble pas à notre type de travail. | Je vous souhaite bonne chance, mais nous ne participerons pas à cela.}",
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
			ID = "WorkOfBeasts",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Du sang dans le désert, assez épais pour recouvrir le sable. Vous suivez les marques de sang jusqu\'à une grande dune de sable et vous la surmontez. De l\'autre côté, il y a une série de membres éparpillés sur la pente. Un torse. Un corps auquel il manque un visage. Des fosses profondes dans le sable mènent loin de la zone. Vous n\'êtes pas à l\'heure pour sauver ces gens, mais vous êtes proche. | Vous arrivez à un puits avec une hutte à côté. La porte est ouverte et inclinée sur un gond cassé. Avec une épée dégainée, vous la poussez lentement et trouvez un tas de bouillie qui pourrait avoir été un homme. Du sang coule du plafond et il y a un trou dans le côté opposé de la hutte, là où ce qui a endommagé tout cela a fait son départ aussi violent que son entrée. Les bêtes doivent être proches. | Des corps jonchent autour d\'un puits dans le désert. Lorsque vous vous approchez, une paire de mains s\'agrippe aux bords du puits et utilise toute la force de son corps pour se sortir du puits. C\'est un vieil homme. Il passe ses jambes par-dessus le mur et s\'assoit là, reprenant son souffle. Il pointe du doigt autour de la scène et hausse les épaules. Il semble que les bêtes étaient juste là, mais vous venez de les manquer. Vous prenez votre gourde et l\'offrez au vieil homme, mais il vous repousse. Une grande douleur se lit dans ses yeux, mais il se bat pour que vous n\'en voyiez pas la moindre trace.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "On continue.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingHyenas",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_159.png[/img]{Vous n\'en êtes pas tout à fait sûr, car vous ne connaissez pas particulièrement cette créature, mais vous vous surprenez à fixer les hyènes avec mépris. Elles portent la marque des fouilleurs d\'ordures, des crétins qui chassent les faibles alors qu\'ils ont la force et le nombre pour se battre pour leur nourriture. Ce n\'est qu\'en vous rencontrant, voyant leur propre fin en jeu, qu\'elles ont décidé de se battre avec leur destin bestial. Vous leur coupez la tête et vous préparez à retourner voir %employer%. | Les hyènes sont des créatures méprisantes, mais elles sont coriaces. Même dans la mort, vous devez hacher et découper le cou des hyènes afin de gagner un peu de terrain, et couper les têtes demande encore plus de temps. Mais le travail est fait et vous êtes prêt à rapporter les têtes et les peaux à %employer%.}",
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
			ID = "CollectingGhouls",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_131.png[/img]{Le combat terminé, vous vous dirigez vers une goule morte et vous vous agenouillez. S\'il n\'y avait pas de dents mal taillées, vous pourriez facilement glisser votre tête dans la gueule surdimensionnée de la bête. Au lieu d\'admirer les défauts dentaires, vous sortez un couteau et lui sciez la tête. Vous levez le gage de votre quête et ordonnez à la compagnie %companyname% d\'en faire de même. %employer% attendra plus de preuves qu\'une seule tête, après tout. | Le corps mort de la goule ressemble plus à une pierre qu\'à une bête, elle est étendu et immobile. Des mouches s\'accouplent déjà dans sa bouche, semant la vie sur les restes écumeux de la mort. Vous ordonnez à %randombrother% de prendre sa tête, car %employer% attendra une preuve. | Des goules mortes sont éparpillées. Vous vous agenouillez à côté de l\'une d\'elles et regardez sa bouche. Un saignement gargouille de ses poumons. Mettant un tissu sur votre nez, vous utilisez une dague pour couper la tête. Vous ordonnez à quelques camarades de faire de même, car %employer% attend des preuves. | Une goule morte est un spécimen intéressant à contempler. On ne peut s\'empêcher de se demander où elle se situe dans le spectre naturel. Elle a la forme d\'un sauvage hermite, des muscles toniques à la manière d\'un prédateur, et sa tête semble plus en pierre qu\'en chair. Curiosité mise à part, vous ordonnez à la compagnie %companyname% de commencer à collecter des têtes car %employer% voudra sûrement des preuves.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Retournons à %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingSerpents",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_169.png[/img]{Vous vous accroupissez devant l\'un des serpents des sables. D\'un bout à l\'autre, vous pourriez vous allonger plusieurs fois et ne pas atteindre sa longueur totale. Un serpent fascinant, c\'est sûr. Vous commencez à les dépecer pour rendre les marchandises à %employer% comme preuve. | Les serpents sont coupés en morceaux et vous rassemblez les bons morceaux - principalement leurs têtes plates et leurs queues curieuses - afin d\'offrir à %employer% la preuve d\'un travail accompli.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Retournons à %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% est déjà devant son palais à votre retour. Il a quelques hommes en habits de soie à ses côtés. Lorsque vous déposez les cadavres des hyènes, ces hommes s\'empressent de les emporter. Le Vizir reste avec quelques gardes à ses côtés. Il claque des doigts et un serviteur vous remet un coffre de couronnes. Le Vizir hoche la tête.%SPEECH_ON%Bien joué, Mercenaire. Nous ferons bon usage de ces paquets que vous avez livrés en temps voulu.%SPEECH_OFF%Des paquets ? Vous pensiez que vous étiez ici pour aider à résoudre une menace de monstre. Alors que les gardes vous pressent hors de la place, vous voyez l\'un des sages utiliser un rapporteur pour commencer à prendre des mesures, tandis qu\'un autre homme installe un piédestal et commence à peindre. | %employer% se tient à sa porte, bien que vous soyez gardé à bonne distance. Ce sont ses serviteurs, au contraire, qui vous accueillent. Ils prennent les crânes des hyènes et les mettent dans des brouettes argentées. Les serviteurs ramènent les marchandises dans la cour et disparaissent aussi vite qu\'ils sont venus. Le vizir siffle comme un faucon qui s\'abat sur sa proie. Vous tressaillez une seconde, mais tout ce qui vient est une autre paire de serviteurs portant un tas de couronnes. L\'un d\'eux regarde le ciel en récitant.%SPEECH_ON%Mercenaire, ce travail, vous l\'avez bien fait, jetes un coupo d\'oeil au coffre, et vous trouverez votre bourse bien remplie.%SPEECH_OFF%Le serviteur fait claquer sa langue et regarde vers le bas, avec un grand sourire.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Débarrasser la région des hyènes");
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
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% vous accueille dans sa salle du trône. Elle est remplie à ras bord de ce qui semble être des personnes très importantes, mais vous êtes quand même amené à entrer. Faisant une courte pause parce que vous n\'êtes pas sûr que la foule puisse le supporter, vous haussez les épaules et déversez les restes des nachzehrers. L\'écume de sang, de tripes et de têtes se déverse sur le sol, mais les spectateurs ne bronchent pas.\n\nTout ce que vous pouvez entendre, c\'est le pas léger du Vizir qui s\'approche. Il fixe les restes, les mains jointes devant lui comme un scientifique, puis il claque des doigts et une horde de serviteurs vient nettoyer le désordre. Un homme avec une plume d\'oie et des papiers prend des notes. Quand tout est dit et fait, le Vizir retourne sur son trône et s\'assied en silence. Le seul autre son que vous entendez est le gling-gling d\'un coffre à trésor que l\'on traîne. Les %reward% couronnes vous sont remises comme promis, puis vous êtes invité à quitter la pièce en silence.\n\n En regardant derrière vous, vous voyez la foule reporter son attention sur le Vizir qui se met à prier. | Un homme vous arrête devant le bureau de %employer%. Il est accompagné de quelques maigres hommes munis de plumes et de registres. Ils tombent sur votre collection de nachzehrers et font des inscriptions en conséquence sur leurs papiers. Chacun termine, arrache la page et la remet au premier homme qui compare ses notes. Satisfait, il vous remet une bourse de %reward% couronnes.%SPEECH_ON%Que votre route soit toujours dorée, mercenaire.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une chasse réussie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Débarrasser la région des nachzehrers");
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
			ID = "Success3",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{Vous rencontrez votre employeur dans son jardin. Il vous regarde fixement, une paire de ciseaux à la main.%SPEECH_ON%Je suppose que la tâche est terminée ?%SPEECH_OFF%En hochant la tête, vous sortez une tête de serpent et la jetez au sol. Elle s\'affale en silence et roule sur le pied du Vizir% qui s\'écarte lentement du chemin. %employer% vous regarde d\'un air sévère.%SPEECH_ON%Les discours théâtraux ne sont pas nécessaires, mercenaire, c\'est l\'accomplissement de la tâche elle-même qui permet de m\'impressionner. Mes gardes fourniront à votre bourse un poids de %reward% couronnes, comme convenu.%SPEECH_OFF% | Vous traînez les peaux de serpent jusqu\'à %employer%, mais un homme portant un turban à plumes vous arrête. Il parle dans un langage qui ressemble à du charabia, bien que quelques mots se faufilent de temps en temps. Il semble qu\'il soit à la solde du Vizir et qu\'il s\'empare des restes du serpent. Vous regardez %employer% qui confirme d\'un signe de tête que c\'est bien ce qui va se passer. Il semble également remarquer les signes de tension sur votre visage alors que vous vous inquiétez de votre paiement. Il parle fort et fièrement.%SPEECH_ON%N\'ayez crainte, mercenaire, les seuls serpents ici sont ceux que vous nous avez apportés.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une chasse réussie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Débarrasser la région des serpents");
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
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_helpful = [];
		local candidates_bro1 = [];
		local candidates_bro2 = [];
		local helpful;
		local bro1;
		local bro2;

		foreach( bro in brothers )
		{
			if (bro.getBackground().isLowborn() && !bro.getBackground().isOffendedByViolence() && !bro.getSkills().hasSkill("trait.bright") && bro.getBackground().getID() != "background.hunter")
			{
				candidates_helpful.push(bro);
			}

			if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_bro1.push(bro);

				if (!bro.getBackground().isOffendedByViolence() && bro.getBackground().isCombatBackground())
				{
					candidates_bro2.push(bro);
				}
			}
		}

		if (candidates_helpful.len() != 0)
		{
			helpful = candidates_helpful[this.Math.rand(0, candidates_helpful.len() - 1)];
		}
		else
		{
			helpful = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro1.len() != 0)
		{
			bro1 = candidates_bro1[this.Math.rand(0, candidates_bro1.len() - 1)];
		}
		else
		{
			bro1 = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro2.len() > 1)
		{
			do
			{
				bro2 = candidates_bro2[this.Math.rand(0, candidates_bro2.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else if (brothers.len() > 1)
		{
			do
			{
				bro2 = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else
		{
			bro2 = bro1;
		}

		_vars.push([
			"helpfulbrother",
			helpful.getName()
		]);
		_vars.push([
			"bro1",
			bro1.getName()
		]);
		_vars.push([
			"bro2",
			bro2.getName()
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
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

