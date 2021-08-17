this.jousting_tournament_event <- this.inherit("scripts/events/event", {
	m = {
		Jouster = null,
		Opponent = "",
		Bet = 0
	},
	function create()
	{
		this.m.ID = "event.jousting_tournament";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%jouster% vient à vous avec un papier à la main. Il le pose sur votre table et dit qu\'il souhaite y pqrticiper. Vous prenez le parchemin, le déployant pour montrer qu\'une ville locale organise un tournoi de joutes. L\'homme croise les bras, attendant votre réponse.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très bien, tu peux y prendre part.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Non, nous avons des affaires plus importantes à régler.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_96.png[/img]Vous acceptez de laisser %jouster% aller au tournoi et, voulant le voir vous-même, vous y allez aussi.\n\nLe tournoi de joutes déborde d\'énergie à votre approche. Les écuyers vont et viennent, portant de grandes quantités d\'armures et d\'armes, et certains marchent lentement avec d\'énormes lances sur leurs épaules. D\'autres hommes brossent des chevaux à l\'allure très royale, dont beaucoup portent des cuirasses décorées de sigles. Au loin, vous entendez de brefs galops, de lourds sabots qui piétinent grossièrement, puis il y a un claquement de bois sur le métal et des acclamations. Alors que vous regardez les festivités, un noble s\'avance et vous arrête. Pesant une bourse d\'une main et faisant tourner un morceau de paille au coin de sa bouche de l\'autre, il vous demande si vous voulez faire un pari. Vous demandez pour quoi faire. Il fait un signe de tête en désignant %jouster% qui est de l\'autre côté du point de rassemblement en train de s\'inscrire au tournoi. Apparemment, il va affronter le cavalier de ce noble, un homme du nom de %opponent%.%SPEECH_ON% Un peu de jeu n\'a jamais fait de mal, non ? Que pensez-vous de miser %bet% couronnes ? Le gagnant prend tout, bien sûr.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le pari est lancé !",
					function getResult( _event )
					{
						_event.m.Bet = 500;
						return "P";
					}

				},
				{
					Text = "Je ne parie jamais.",
					function getResult( _event )
					{
						return "P";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "P",
			Text = "[img]gfx/ui/events/event_96.png[/img]Vous prenez place parmi les roturiers et les nobles. Seul le seigneur local est à l\'écart de la racaille, assis sur une rangée plus élevée avec ses fils, ses filles et divers membres de la royauté de tout le pays.\n\n%jouster% est le prochain, un ecuyer emmène son cheval sur une des lignes de jouttes. De l\'autre côté, %opposant% entre sur le terrain, son cheval noir, son armure d\'un violet éclatant avec des garnitures et des ornements dorés ici et là.\n\nUn annonceur crie leurs noms depuis la loge royale, puis un prêtre dit quelques mots sur le fait que cela a été ordonné par les dieux et que, si quelqu\'un ici mourait aujourd\'hui, il serait assis parmi les plus grands hommes dans le prochain royaume, et on se souviendrait d\'eux dans celui-ci. Cela dit, les deux jouteurs abaissent leurs lances et chargent avant même que l\'annonceur ou le prêtre ne puissent s\'asseoir.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Excitant!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 30 + 5 * _event.m.Jouster.getLevel())
						{
							return "Win";
						}
						else
						{
							return "Lose";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Win",
			Text = "[img]gfx/ui/events/event_96.png[/img]N\'ayant jamais assisté à un tel événement, vous ne pouvez vous empêcher de retenir votre souffle lorsque les deux cavaliers dévalent les chemins l\'un vers l\'autre. Les chevaux sont majestueux, leurs jambes sont en rythme, leurs sabots arrachent de grosses mottes de terre, leurs armures brillent de mille feux dans la foule tandis qu\'ils courent, laissant dans leur sillage des flots d\'observateurs étourdis, des enfants qui crient, des ivrognes qui renversent leurs chopes, des jeunes princesses qui serrent leurs robes, des princes courageux qui applaudissent et, sans savoir comment cela a pu arriver, vous êtes vous-même debout et vous criez.\n\n %opponent% s\'efforce de garder son équilibre, sa lance oscille de haut en bas, sa pointe vacille à la recherche d\'une véritable cible.\n\nIl ne la trouve pas.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ohh!",
					function getResult( _event )
					{
						if (_event.m.Bet > 0)
						{
							return "WinBet";
						}
						else
						{
							return "WinNobet";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "WinNobet",
			Text = "[img]gfx/ui/events/event_96.png[/img]La lance de %jouster% se brise sur la poitrine de son adversaire, une explosion de sciure et d\'échardes à travers laquelle se déplace un cheval sans cavalier, le jouster ayant été désarçonné, se retrouve face contre terre sur le champ de bataille sans aucun mouvement ni souffle. Un rugissement jaillit de la foule, une tempête non maîtrisée à laquelle vous vous joignez rapidement, noyant vos oreilles dans une cacophonie foudroyante, emporté dans un temps et un lieu que vous n\'oublierez jamais.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Huzzah!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				_event.m.Jouster.improveMood(2.0, "A gagné un tournoi de joutes");

				if (_event.m.Jouster.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Jouster.getMoodState()],
						text = _event.m.Jouster.getName() + this.Const.MoodStateEvent[_event.m.Jouster.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "WinBet",
			Text = "[img]gfx/ui/events/event_96.png[/img]La lance de %jouster% se brise sur la poitrine de son adversaire, une explosion de sciure et d\'échardes à travers laquelle se déplace un cheval sans cavalier, le jouster ayant été désarçonné, se retrouve face contre terre sur le champ de bataille sans aucun mouvement ni souffle. Un rugissement jaillit de la foule, une tempête non maîtrisée à laquelle vous vous joignez rapidement, noyant vos oreilles dans une cacophonie foudroyante, emporté dans un temps et un lieu que vous n\'oublierez jamais.\n\nAlors que vous êtes encore en train de célébrer, le noble avec qui vous avez parié s\'approche et vous remet une bourse dans la main. Vous souhaitez lui dire quelques mots, mais avant que vous ne puissiez le faire, il se retourne avec colère et s\'en va.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Huzzah!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				this.World.Assets.addMoney(_event.m.Bet);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous gagnez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + _event.m.Bet + "[/color] Couronnes"
				});
				_event.m.Jouster.improveMood(2.0, "A gagné un tournoi de joutes");

				if (_event.m.Jouster.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Jouster.getMoodState()],
						text = _event.m.Jouster.getName() + this.Const.MoodStateEvent[_event.m.Jouster.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Lose",
			Text = "[img]gfx/ui/events/event_96.png[/img]N\'ayant jamais assisté à un tel événement, vous ne pouvez vous empêcher de retenir votre souffle lorsque les deux cavaliers dévalent les chemins l\'un vers l\'autre. Les chevaux sont majestueux, leurs jambes sont en rythme, leurs sabots arrachent de grosses mottes de terre, leurs armures brillent comme des soleils à travers la foule tandis qu\'ils courent, laissant dans leur sillage des flots d\'observateurs étourdis, des enfants qui crient, des ivrognes qui renversent leurs chopes, des jeunes princesses qui serrent leurs robes, des princes courageux qui applaudissent et, sans savoir comment cela a pu arriver, vous êtes vous-même debout et vous criez. \n\n%jouster% s\'efforce de garder son équilibre, sa lance oscille de haut en bas, sa pointe vacille à la recherche d\'une véritable cible.\n\nIl ne la trouve pas.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ohh...",
					function getResult( _event )
					{
						if (_event.m.Bet > 0)
						{
							return "LoseBet";
						}
						else
						{
							return "LoseNobet";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "LoseNobet",
			Text = "[img]gfx/ui/events/event_96.png[/img]La lance de %opponent% explose en touchant la poitrine de %jouster%. L\'homme est courbé en arrière sur sa selle, un nuage d\'échardes et de poudre de bois tourbillonnant dans son sillage. Il cherche désespérément ses rênes. En les trouvant, vous pensez qu\'il a récupéré, mais la bride se casse et les rênes glissent. %jouster% tombe en arrière, culbute sur l\'arrière-train de la monture et atterrit sur ses pieds. Il a beau être debout, il a perdu.\n\nLa foule est en délire, applaudissant avec ferveur le gagnant et le perdant. Se roulant l\'épaule avec un peu de douleur, %jouster% quitte le terrain. Vous le retrouvez sur le lieu du rassemblement. Il dit qu\'il y avait un problème avec sa lance, et vous mentionnez que la bride de son cheval s\'est détachée. À ce moment-là, le vainqueur passe, une suite de femmes en adoration derrière lui et un écuyer menant un cheval à l\'allure plutôt pompeuse. À votre grande surprise, %opposant% et %jouster% se serrent la main et se félicitent mutuellement pour ce match bien disputé.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oh well.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				local injury = _event.m.Jouster.addInjury(this.Const.Injury.Jousting);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Jouster.getName() + " souffre de " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "LoseBet",
			Text = "[img]gfx/ui/events/event_96.png[/img]La lance de %opponent% explose en touchant la poitrine de %jouster%. L\'homme est courbé en arrière sur sa selle, un nuage d\'échardes et de poudre de bois tourbillonnant dans son sillage. Il cherche désespérément ses rênes. En les trouvant, vous pensez qu\'il a récupéré, mais la bride se casse et les rênes glissent. %jouster% tombe en arrière, culbute sur l\'arrière-train de la monture et atterrit sur ses pieds. Il a beau être debout, il a perdu.\n\nLa foule est en délire, applaudissant avec ferveur le gagnant et le perdant. Se roulant l\'épaule avec un peu de douleur, %jouster% quitte le terrain. Vous le retrouvez sur le lieu du rassemblement. Il dit qu\'il y avait un problème avec sa lance, et vous mentionnez que la bride de son cheval s\'est détachée. À ce moment-là, le vainqueur passe, une suite de femmes en adoration derrière lui et un écuyer menant un cheval à l\'allure plutôt pompeuse. À votre grande surprise, %opposant% et %jouster% se serrent la main et se félicitent mutuellement pour ce match bien disputé.\n\nLe noble avec qui vous avez parié n\'est pas très porté sur l\'esprit sportif. Il vient vous voir en se frottant les mains sous un sourire mauvais. Vous payez à contrecoeur à l\'homme ce qui lui est dû.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oh bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				this.World.Assets.addMoney(-_event.m.Bet);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Bet + "[/color] Couronnes"
				});
				local injury = _event.m.Jouster.addInjury(this.Const.Injury.Jousting);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Jouster.getName() + " souffre de " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]Le fait que vous ayez dit non à %jouster% ne passe pas bien. Il se plaint longuement de l\'argent qu\'il aurait pu gagner au tournoi et du fait que vous le privez de ces couronnes. Toutes ces plaintes sont très intéressantes, bien sûr, jusqu\'à ce qu\'il se tourne vers vous et exige %compensation% couronnes, une compensation pour ce qu\'il prétend être un manque à gagner.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très bien, je vais te dédommager.",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Tu es un mercenaire maintenant, pas un jouteur. Tu ferais mieux de t\'y habituer.",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_64.png[/img]Vous vous levez et tapotez l\'épaule de %jouster%.%SPEECH_ON%Je ne doute pas qu\'un homme de ton talent et de tes prouesses aurait remporté le tournoi haut la main. Mais j\'ai besoin d\'un homme tel que toi ici, au camp. Vous n\'avez pas besoin de prouver le manque à gagner, je te compenserai pour cela.%SPEECH_OFF%Les mots plutôt diplomates calment l\'homme. Il acquiesce et semble brièvement penser qu\'il serait déshonorant d\'accepter le paiement. Ne voulant pas que le mercenaire mette sa détermination à l\'épreuve, ni qu\'il passe pour un imbécile ou un homme de peu d\'honneur, vous lui ordonnez de l\'accepter.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous pouvez partir maintenant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				this.World.Assets.addMoney(-500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_64.png[/img]Vous prenez l\'affiche du tournoi et la mettez sur une bougie. Pendant que les flammes rongent le papier, vous rappelez quelques règles de base pour %jouster%.%SPEECH_ON% Je t\'ai engagé pour être un mercenaire, pas un jouster à la noix. Si tu veux aller te battre dans des tournois, alors tu peux rendre tout ton équipement et ton salaire de base. Sinon, dégage de ma tente.%SPEECH_OFF% Cela ne se passe pas très bien, mais en fin de compte, le mercenaire ne quitte que votre tente et non la compagnie tout entière.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Retourne au travail !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Jouster.getImagePath());
				_event.m.Jouster.worsenMood(2.0, "S\'est vu refuser la participation à un tournoi de joutes");

				if (_event.m.Jouster.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Jouster.getMoodState()],
						text = _event.m.Jouster.getName() + this.Const.MoodStateEvent[_event.m.Jouster.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 500)
		{
			return;
		}

		if (this.World.FactionManager.isGreaterEvil())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 1)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getLevel() < 4)
			{
				continue;
			}

			if ((bro.getBackground().getID() == "background.adventurous_noble" || bro.getBackground().getID() == "background.disowned_noble" || bro.getBackground().getID() == "background.bastard" || bro.getBackground().getID() == "background.hedge_knight") && !bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Jouster = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 25;
	}

	function onPrepare()
	{
		this.m.Opponent = this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)];
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"jouster",
			this.m.Jouster.getName()
		]);
		_vars.push([
			"opponent",
			this.m.Opponent
		]);
		_vars.push([
			"bet",
			500
		]);
		_vars.push([
			"compensation",
			500
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Jouster = null;
		this.m.Opponent = "";
		this.m.Bet = 0;
	}

});

