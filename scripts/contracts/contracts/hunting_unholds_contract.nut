this.hunting_unholds_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = true
	},
	function setEnemyType( _t )
	{
		this.m.Flags.set("EnemyType", _t);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_unholds";
		this.m.Name = "Chassez des Géeants";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 750 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Chassez les Unholds autour de " + this.Contract.m.Home.getName()
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

				if (r <= 40)
				{
					this.Flags.set("IsDriveOff", true);
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSignsOfAFight", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 6, 12, [
					this.Const.World.TerrainType.Mountains
				]);
				local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 8);
				local party;

				if (this.Flags.get("EnemyType") == 0)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Unholds", false, this.Const.World.Spawn.UnholdBog, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				}
				else if (this.Flags.get("EnemyType") == 1)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Unholds", false, this.Const.World.Spawn.UnholdFrost, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Unholds", false, this.Const.World.Spawn.Unhold, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				}

				party.setDescription("Un ou plusieurs géants imposants.");
				party.setFootprintType(this.Const.World.FootprintsType.Unholds);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				party.getFlags().set("IsUnholds", true);
				this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Unholds, 0.75);
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
					if (this.Flags.get("IsSignsOfAFight"))
					{
						this.Contract.setScreen("SignsOfAFight");
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
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsDriveOff") && !this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					local bros = this.World.getPlayerRoster().getAll();
					local candidates = [];

					foreach( bro in bros )
					{
						if (bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.barbarian" || bro.getSkills().hasSkill("trait.dumb"))
						{
							candidates.push(bro);
						}
					}

					if (candidates.len() == 0)
					{
						this.World.Contracts.showCombatDialog(_isPlayerAttacking);
					}
					else
					{
						this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
						this.Contract.setScreen("DriveThemOff");
						this.World.Contracts.showActiveContract();
					}
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
					if (this.Flags.get("IsDriveOffSuccess"))
					{
						this.Contract.setScreen("SuccessPeaceful");
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{Lorsque vous entrez dans le bureau de %employer%, vous trouvez l\'homme accroupi près de sa fenêtre, regardant par celle-ci avec un regard presque conspirateur. Ses yeux s\'amincissent, s\'ouvrent largement et s\'amincissent à nouveau. Il fait claquer un rideau sur la fenêtre et secoue la tête pour vous regarder.%SPEECH_ON%Vous n\'avez pas vu par hasard une femme très en colère se diriger vers moi, n\'est-ce pas ? Ah, laissez tomber. Regardez ça.%SPEECH_OFF%Il vous lance un parchemin que vous dépliez. Il y a un dessin grossier de ce qui ressemble à un homme penché sur une fourmi ou un insecte quelconque. Vous ne pouvez pas vraiment dire. %employer% frappe dans ses mains.%SPEECH_ON%Les agriculteurs locaux signalent la disparition du bétail. Ils n\'ont trouvé que des empreintes de pas assez grandes pour qu\'un homme y dépose un cercueil. Ça ressemble à des ouï-dire et des rumeurs, ça pourrait être des rivaux qui essaient de cacher leurs méfaits, mais je vous laisse vous débrouiller. Fouillez les terres environnantes et voyez ce que vous trouvez. Si vous tombez sur un vrai géant, je pense que vous savez quoi faire.%SPEECH_OFF% | Vous trouvez %employer% assis à son bureau et apparemment en congrès avec la moitié des fermiers du village. Ils sont penchés sur des parchemins et laissent des traces de plomb sur les papiers, dessinant ce qui ressemble à des géants ou des gros hommes avec des cornes. Un homme gribouille un bonhomme de bois qui baise un autre bonhomme de bois. %employer% vous lance une page plus prémonitoire sur laquelle se trouve le visage d\'un monstre.%SPEECH_ON%Ces messieurs me disent qu\'un géant se cache. Je ne souhaite pas mettre en doute les inquiétudes de mes pairs et je demande donc vos services, mercenaire. L\'argent est sur la table, tout ce que vous avez à faire est de fouiller les environs de %townname% et de trouver cette bête. Qu\'en dites-vous ?%SPEECH_OFF% | Vous trouvez %employer% en train de repousser une foule de paysans. Ils sont entrés dans sa chambre avec des fourches et des torches non allumées, qu\'il doit constamment les avertir de ne pas allumer étant donné l\'architecture tout en bois. En vous voyant, %employer% vous appelle comme un homme qui se noie et réclame un radeau.%SPEECH_ON%Mercenaire ! Par les dieux, venez ici. Ces braves gens déclarent qu\'il y a une bête en liberté.%SPEECH_OFF%Un des paysans plante sa fourche dans le sol.%SPEECH_ON%Non, pas une bête ordinaire, mais un monstre, hein ? Un géant ! Un gros. Un bon gros géant. Là-bas. Dans cette direction. Je l\'ai vu.%SPEECH_OFF%Avec un soupir et un hochement de tête, %employer% revient à la charge.%SPEECH_ON%Bien. Donc, je suis prêt à vous offrir une rémunération pour rechercher ce géant. Etes-vous prêt pour cette tâche ?%SPEECH_OFF% | %employer% est à son bureau, la tête entre les mains. Il se marmonne à lui-même. %SPEECH_ON%Monstre par-ci, bête par-là. \"Oh mon poulet s\'est fait prendre\", oh peut-être que tu devrais penser à le mettre dans un stylo, espèce mer - oh salut mercenaire !%SPEECH_OFF%L\'homme se lève de sa chaise et vous lance un morceau de papier. Il y a un dessin grossier d\'une grande bête dessus.%SPEECH_ON%Les gens disent qu\'il y a un géant qui erre autour de ces régions. Je paierai cher pour que ces rapports soient examinés comme il se doit, et bien sûr pour que la bête soit abattue comme il se doit. Êtes-vous partant ? Dites oui, s\'il vous plaît.%SPEECH_OFF% | %employer% vous accueille à contrecœur dans sa chambre, prétendant qu\'il n\'a pas besoin de votre aide, alors qu\'il est clair qu\'il préférerait ne pas en avoir besoin du tout.%SPEECH_ON%Ah, un mercenaire. Ce n\'est pas souvent qu\'un endroit comme %townname% recherche des hommes de votre trempe, mais j\'ai bien peur qu\'il y ait eu des apparitions d\'unholds parcourant ces terres, volant suffisamment de bétail pour que les habitants de la ville mettent la main à la poche pour aller chercher un homme tel que vous. Êtes-vous intéressé à chasser cette créature immonde ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combattre des géants n\'est pas donné. | %companyname% peut aider pour le bon prix. | Parlons couronnes.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne ressemble pas à notre genre de travail. | Ça n\'en vaut pas le coup.}",
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
			Text = "[img]gfx/ui/events/event_71.png[/img]{%randombrother% revient de sa reconnaissance. Il rapporte qu\'une ferme voisine a été détruite, un trou ayant traversé son toit, comme si on avait donné un coup de pied dans une fourmilière. Vous demandez s\'il y a des survivants. Il acquiesce.%SPEECH_ON%En quelque sorte. Un jeune garçon qui refuse de dire un mot. Une femme qui n\'arrêtait pas de me crier d\'aller me faire voir. Cela mis à part, non. Ce sont des survivants par circonstance et par chance. Ce monde ne leur permettra pas de rester ici bien longtemps.%SPEECH_OFF%Vous dites au mercenaire de garder les jugements pour lui et de remettre la compagnie sur les rails. | Vous trouvez une demi-vache au bord du chemin. Elle n\'a pas été dépecée, mais plutôt déchirée de manière inégale et avec une grande violence. La plupart de ses entrailles ont été jetées au sol en un tas. Des empreintes de la taille d\'une tombe s\'éloignent. La piste du carnage passe par une clôture qui a été coupée et, plus loin, on peut voir les restes d\'une grange. %randombrother% rit.%SPEECH_ON%Tout ce qui nous manque, c\'est un énorme tas de merde.%SPEECH_OFF%Vous lui dites de vérifier sa botte. | Quelques paysans sur la route vous mettent en garde.%SPEECH_ON%Partez d\'ici ! Cette armure ne vous protégera pas d\'un seul coup !%SPEECH_OFF%Vous les interrogez sur l\'unhold et ils vous donnent une excellente description d\'un géant monstrueux qui a déchiré la terre il n\'y a pas longtemps. Il semble que vous êtes sur la bonne voie. | L\'unhold a laissé un désordre géant dans son sillage. Le bétail a été piétiné, d\'autres ont été brisés et ont été vidés. Les poulets picorent le sol, un fermier les surveille. Il hoche la tête.%SPEECH_ON%Vous avez ratez le spectacle.%SPEECH_OFF%On dirait que vous vous rapprochez.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ils ne peuvent pas être loin.",
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
			Text = "[img]gfx/ui/events/event_104.png[/img]{Les unholds vous rappellent en partie n\'importe quel groupe d\'ouvriers, encerclés autour d\'un feu mort, se frottant le ventre et ressemblant à des blocs de pierre là, courbés sur le sol. Bien sûr, votre arrivée les fait se lever et détruit toute idée que vous pourriez leur ressembler, à part peut-être des troisièmes jambes de taille similaire. Les bêtes grognent et piétinent, mais elles n\'attaquent pas. Elles jettent leurs mains en l\'air et essaient de vous faire fuir. Mais %companyname% n\'est pas venu jusqu\'ici pour abandonner. Vous tirez votre épée et faites avancer vos hommes. | Chaque Unhold est énorme, au-delà de toute mesure. Ils sont déconcertés par les fourmis qui viennent se battre avec eux. L\'un d\'eux se gratte la tête et rote allègrement, tachant la compagnie de sang bovin. Ils semblent cependant reconnaître l\'acier de votre épée dégainée, et la lumière de celle-ci les réveille de leur sommeil réparateur. Après avoir fait trembler leurs pieds, ils s\'avancent pour vous chasser de la terre ou pour y pénétrer. | Les hommes de %companyname% empilé les uns sur les autres n\'atteindraient toujours pas la taille d\'un seul unhold. Pourtant, vous êtes là, brandissant une épée et prêt à combattre les énormes monstres. Ils vous regardent d\'un air incrédule, ne sachant pas trop quoi penser de ces minuscules créatures si disposées à les affronter. L\'un d\'eux se gratte le ventre et des flocons de peau mue de la taille d\'un chien descendent en tournoyant. Bon, ça ne sert à rien de s\'attarder plus longtemps. Vous ordonnez à la compagnie d\'avancer ! | Les unhold vous reniflent et traversent le pays à la rencontre de %companyname%. Ils ressemblent à des bambins de la taille d\'une montagne, les jambes avançant maladroitement, mais chaque pas fait trembler la terre, et leurs gueules sont ouvertes et bavent pour un repas. Vous dégainez calmement votre épée et mettez les hommes en formation.}",
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
			ID = "DriveThemOff",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_104.png[/img]{Alors que vous mettez les hommes en formation, %shouter% passe en courant devant vous et se dirige vers les unholds. Il hulule et hurle, les bras ballants comme un crétin des mers tiré par l\'hameçon. Les unholds font une pause et se fixent les uns les autres. Vous n\'êtes pas sûrs que cela doive continuer...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Attaquez-les !",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				},
				{
					Text = "%shouter% sait ce qu\'il fait.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 35)
						{
							return "DriveThemOffSuccess";
						}
						else
						{
							return "DriveThemOffFailure";
						}
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DriveThemOffSuccess",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_104.png[/img]{Contre tout jugement, vous laissez faire %shouter%. Il ne s\'arrête pas, comme s\'il poursuivait une foule de belles femmes qui se déshabillent juste pour lui. De manière choquante, les Unholds font un pas en arrière. Ils commencent à reculer un par un jusqu\'à ce qu\'il ne reste plus qu\'un géant solitaire.\n\n%shouter% se lève comme un chien qui jappe et pousse un cri atavique si rauque qu\'on se demande si tous les ancêtres de la terre, enterrés ou non, l\'ont entendu. L\'individu lève un bras devant son visage comme pour le protéger, puis commence à reculer, de plus en plus loin, jusqu\'à ce qu\'il ait disparu ! Ils sont tous partis !}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et ne revenez pas !",
					function getResult()
					{
						this.Contract.m.Target.die();
						this.Contract.m.Target = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.Contract.m.Dude.improveMood(3.0, "A réussi à chasser les unholds tout seul");

				if (this.Contract.m.Dude.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[this.Contract.m.Dude.getMoodState()],
						text = this.Contract.m.Dude.getName() + this.Const.MoodStateEvent[this.Contract.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "DriveThemOffFailure",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_104.png[/img]{Contre tout jugement, vous laissez faire %shouter%. Il ne s\'arrête pas, comme s\'il poursuivait une foule de belles femmes qui se déshabillent juste pour lui. De manière choquante, les Unholds font un pas en arrière. Ils commencent à reculer un par un jusqu\'à ce qu\'il ne reste plus qu\'un géant solitaire.\n\n%shouter% se lève comme un chien qui jappe et pousse un cri atavique si rauque qu\'on se demande si tous les ancêtres de la terre, enterrés ou non, l\'ont entendu. L\'homme lève un bras devant son visage, puis le jette à terre et repousse %shouter%. L\'homme fait la roue dans les airs et ses cris l\'accompagnent comme un lapin volé par un faucon. Ses cris retombent sur terre dans un écho de cris étourdissants et il atterrit avec un bruit sourd. Le géant se trémousse avec un gloussement terreux. Son amusement attire l\'attention unholds qui étaient partis. Ils se retournent tous et commencent à revenir.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tout ça pour ça",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, false);
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				local injury;

				if (this.Math.rand(1, 100) <= 50)
				{
					injury = this.Contract.m.Dude.addInjury(this.Const.Injury.BluntBody);
				}
				else
				{
					injury = this.Contract.m.Dude.addInjury(this.Const.Injury.BluntHead);
				}

				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = this.Contract.m.Dude.getName() + " souffre de " + injury.getNameOnly()
				});
				this.Contract.m.Dude.worsenMood(1.0, "N\'a pas réussi à chasser les unholds tout seul.");

				if (this.Contract.m.Dude.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[this.Contract.m.Dude.getMoodState()],
						text = this.Contract.m.Dude.getName() + this.Const.MoodStateEvent[this.Contract.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_113.png[/img]{Les unholds tués, vous ordonnez aux hommes de prendre les trophées qu\'ils peuvent comme preuve de votre travail, et peut-être comme quelque chose à utiliser pour vous-même. Si l\'homme peut fabriquer du cuir à partir d\'une vache, il y a sûrement quelque chose de digne de géants tels que ceux-ci ? Quoi qu\'il en soit, %employer% vous attendra. | Les géants ayant été tués jusqu\'au dernier, %employer% devrait attendre votre retour maintenant. Sa ville sera à jamais en sécurité et n\'aura plus besoin des services de mercenaires tels que vous. Vous vous attardez sur cette pensée jusqu\'à ce que vous déclenchiez une crise de rire qu\'aucun de vos hommes ne comprend. Vous leur dites de l\'ignorer et vous les rassemblez pour le voyage de retour. | Les horribles monstres se sont bien battus, mais ils n\'ont pas fait le poids face à la force collective, à l\'intelligence et aux couilles de %companyname%. Vous dites aux hommes de prendre les trophées qu\'ils peuvent et de se préparer à la marche de retour vers %employer%. | Après avoir tué le dernier des unholds, vous rassemblez vos hommes. %randombrother% se retrouve à sauter sur le ventre de l\'un d\'eux et semble déçu lorsque vous lui dites d\'arrêter et de descendre. %employer% cherchera des tueurs et leurs trophées, pas une bande d\'enfants.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Il est temps d\'être payé.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SignsOfAFight",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_113.png[/img]{Les géants tués, vous préparez les hommes pour retournez voir %employer%, mais %randombrother% attire votre attention avec un petit frémissement dans la gorge. Vous vous dirigez vers lui pour le voir debout devant l\'un des unholds abattus. Il montre du doigt sa chair qui a été déchirée en tranches et pend comme les épis d\'une tige de maïs. Les dégâts sont bien au-delà de la capacité de vos propres armes. Le mercenaire se retourne et regarde devant vous en écarquillant les yeux.%SPEECH_ON%Qu\'est-ce qui a fait ça, selon vous ?%SPEECH_OFF%Plus loin sur la peau se trouvent des cicatrices concaves en forme de soucoupes avec des perforations en plein dans les trous. Vous grimpez sur le unhold et enfoncez votre épée dans l\'un de ces trous, arrachant une dent de la longueur de votre avant-bras. Le long de ses bords se trouvent des barbes, des dents sur des dents, semble-t-il. Les hommes voient cela et commencent à murmurer entre eux et vous souhaiteriez ne jamais l\'avoir vu car vous ne savez pas quoi en penser.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Les régions sauvages sont sombres et pleines de terreurs.",
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
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer% se réjouit de votre retour, déclarant presque immédiatement qu\'il n\'a pas entendu une seule histoire de ravage des unholds depuis votre départ. Vous hochez la tête et présentez la preuve de la raison pour laquelle, les restes gluants des géants tués crachotent alors que vous les écrasez sur son sol. Le bois est taché comme si vous aviez déroulé un tapis. Le maire pince les lèvres.%SPEECH_ON%C\'est quoi ce bordel, mercenaire ?%SPEECH_OFF%Vous penchez la tête et levez un sourcil. L\'homme laisse tomber ses mains et s\'incline un peu.%SPEECH_ON%Ah, pas d\'inquiétude ! Tout va bien ! Voici votre récompense comme promis !%SPEECH_OFF% | Vous retournez voir %employer% et trouvez l\'homme qui lit des histoires aux enfants. Il brandit sa main en l\'air et grogne comme une bête. En frappant à la porte, vous faites intrusion dans le théâtre.%SPEECH_ON%Oui, et alors les mercenaires toujours honorables ont tué le monstre !%SPEECH_OFF%Les enfants applaudissent à votre arrivée. Le maire se lève et vous donne la récompense promise, déclarant qu\'il avait un éclaireur qui suivait tous vos mouvements et qu\'il a déjà entendu les rapports sur votre succès. Il demande si vous allez rester dans les parages et raconter l\'histoire aux enfants. Vous lui dites que vous ne travaillez pas gratuitement et vous quittez la pièce. | Il faut fouiller un moment dans la ville pour trouver %employer%, l\'homme lui-même étant retenu dans sa chambre par une jeune fille qui se cache sous les draps dans lesquels vous les avez surpris. Le maire s\'habille sans hésiter quant à sa propre nudité. Il lance une pièce à la jeune fille puis s\'adresse à vous.%SPEECH_ON%Oui, mercenaire, je vous attendais ! Voilà votre récompense, comme promis !%SPEECH_OFF%Il vous donne la sacoche, mais une pièce de monnaie se détache et passe entre les lattes du plancher. L\'homme pince les lèvres un instant, puis court vers la fille, lui arrache la pièce des mains et la dépose dans la sacoche. | %employer% se dispute avec les paysans au sujet des impôts impayés et de la façon dont les seigneurs de la terre obtiendront leur argent d\'une manière ou d\'une autre. L\'arrivée d\'un homme armé comme vous est plutôt opportune et fait fuir les paysans vers leurs porte-monnaie. Vous leur dites de se taire, puis vous vous adressez au maire pour obtenir votre argent. Il va le chercher dans un tiroir, ne s\'arrêtant que pour le remplir à ras bord en prenant une pièce de monnaie à un paysan, puis il vous le remet.%SPEECH_ON%J\'apprécie votre travail, mercenaire.%SPEECH_OFF% | Vous rendez compte à %employer% de vos exploits et il n\'est, étonnamment, pas incrédule le moins du monde.%SPEECH_ON%Oui, j\'avais un éclaireur qui suivait votre compagnie et il vous a devancé en ville. Chaque mot que vous dites reflète le sien. Votre paye, comme promis.%SPEECH_OFF%Il vous tend une sacoche.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of unholds");
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
			ID = "SuccessPeaceful",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer% conduit ses doigts jusqu\'au coin de l\'œil puis les écarte vers l\'avant.%SPEECH_ON%Si je comprends bien, un de vos mercenaires a poussé les géants à battre en retraite ?%SPEECH_OFF%Vous acquiescez et vous lui indiquez la direction qu\'ils ont prise, c\'est-à-dire, surtout, loin de %townname%. Le maire se penche en arrière sur sa chaise.%SPEECH_ON%Bien. Très bien alors. Je suppose que ce n\'est plus mon problème maintenant. Mort ou disparu, c\'est pareil, je suppose.%SPEECH_OFF%Il vous tend une sacoche, mais garde la main dessus un moment.%SPEECH_ON%Tu sais que si vous mentez et qu\'ils reviennent, j\'enverrai tous les messagers que j\'ai pour parler de votre honneur.%SPEECH_OFF%Vous vous levez, dégainez votre épée, et lui dites qu\'ils auront son crâne pour se reposer quand ils arriveront. L\'homme hoche la tête et laisse la pièce partir.%SPEECH_ON%Pas de problème, mercenaire, que du business.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of unholds");
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
			"shouter",
			this.m.Dude != null ? this.m.Dude.getName() : ""
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
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/unhold_attacks_situation"));
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

