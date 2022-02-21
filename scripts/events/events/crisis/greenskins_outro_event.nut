this.greenskins_outro_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_outro";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous rencontrez une poignée de soldats de %randomnoblehouse%. Ils inclinent leurs casques vers vous.%SPEECH_ON%Soir, mercenaires.%SPEECH_OFF%Vous ne savez pas s\'ils sont hostile, vous faites un signe de tête subtil vers %dude%. Il met son arme à portée de main et acquiesce en retour. Vous reportez votre attention sur les soldats en leur adressant un signe amical. Leur lieutenant s\'avance en souriant.%SPEECH_ON%Oy mercenaire, vous ne nous servez plus à rien dans ce monde maintenant.%SPEECH_OFF%Lentement, vous baissez la main, la faisant planer au-dessus du pommeau de votre épée. Vous demandez ce que l\'homme veut dire par là. Il rit.%SPEECH_ON%Vous n\'avez pas entendu ? La guerre est finie. Les peaux vertes ont été vaincus depuis %randomtown% il y a quelques jours à peine. Les éclaireurs rapportent avoir vus ces bâtards courir vers les collines dans tous les sens, se battre entre eux, les orcs tuant les gobelins, les gobelins tuant les orcs, juste une déroute complète. Donc, oui, les maisons nobles n\'ont pas besoin de payer votre cul pour rien maintenant parce que nous, les vrais soldats, nous avons tout sous contrôle. Maintenant, pourquoi vous et votre lot pathétique ne dégagez-vous pas le chemin. Nous, les combattants, avons des endroits où rentrer, tu comprends ?%SPEECH_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Bougeons pour laisser passer ces héros du royaume.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Tu t\'occupes de lui, %dude%.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.updateAchievement("GreenskinSlayer", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.Greenskins;
					this.setPersistentStat("CrisesDefeatedOnIronman", defeated);

					if (defeated == this.Const.World.GreaterEvilTypeBit.All)
					{
						this.updateAchievement("Savior", 1, 1);
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]%dude% attrape son arme, mais vous secouez la tête. Le lieutenant fait un signe de tête vers le mercenaire.%SPEECH_ON%Mieux vaut garder ce chien en laisse, d\'accord ?%SPEECH_OFF%Vous étendez votre bras, invitant les soldats à un \"passage\" qu\'ils savaient déjà avoir. Les soldats se préparent et le lieutenant sourit.%SPEECH_ON%Je savais que vous feriez le bon choix. On s\'amuse juste un peu, hein ? Mesdames, restez serrées.%SPEECH_OFF%L\'homme envoie un baiser en passant. %dude% se lève comme si quelqu\'un venait de frapper sa mère. Vous lui dites de se rasseoir et il le fait à contrecœur. Ce ne sont que des conneries, ces pièces de théâtre, mais vous n\'êtes pas du genre à perdre votre sang-froid et à faire tuer vos hommes.\n\nL\'incident vous fait vous demander s\'il est peut-être temps de raccrocher. Les peaux vertes sont repoussées et vous avez gagné assez d\'argent pour quitter la vie de mercenaire pour de bon, mais encore une fois, vous détesteriez passer le reste de vos jours à vous demander \'et si\'...\n\n %OOC%Vous avez gagné ! Battle Brothers est conçu pour la rejouabilité et pour que les campagnes soient jouées jusqu\'à ce que vous ayez vaincu une ou deux crises de fin de partie. Lancer une nouvelle campagne vous permettra d\'essayer différentes choses dans un monde différent.\n\nVous pouvez également choisir de poursuivre votre campagne aussi longtemps que vous le souhaitez. Sachez simplement que les campagnes ne sont pas destinées à durer éternellement et que vous finirez probablement par manquer de défis.%OOC_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = " %companyname% ont besoin de leur commandant!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Il est temps de se retirer de la vie de mercenaire. (Fin de campagne)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]Le lieutenant des soldats vous lance un regard noir.%SPEECH_ON%Faites ce que j\'ai dit, mercenaire, ou il y aura des problèmes.%SPEECH_OFF%En l\'ignorant, vous faites un autre signe de tête à %dude%. Il se lève, la lame de son arme raclant bruyamment la terre. Les soldats se tournent vers le mercenaire. Il prend son arme à deux mains et regarde en arrière. Alors que le lieutenant commence à parler, %dude% l\'interrompt brutalement.%SPEECH_ON%Chut, petit homme. Je vois de la douceur dans ta peau. Pas une cicatrice à voir. Des yeux aussi frais que le jour de leur naissance. Des mains aussi douces que des bougies intactes. Si vous étiez du genre à vous battre, vous seriez là-bas dans ces batailles dont vous parlez, pas ici à pisser dans le vent. Je vais vous donner deux options parce que je me sens bien. Première option, écoutez-vous ? La première option est celle-ci. Allez où vous voulez et ne dites plus un putain de mot.%SPEECH_OFF%Il marque une pause pour lever deux doigts.%SPEECH_ON%La deuxième option est un mystère. Parlez et vous l\'apprendrez.%SPEECH_OFF%Les yeux du lieutenant se sont un peu élargis et sa bouche est infiniment plus silencieuse. Il vous regarde, mais tout ce que vous pouvez faire, c\'est hausser les épaules. Après un long moment, les soldats se détournent avec un silence déterminé.\n\n%dude% rigole, mais l\'incident vous fait vous demander s\'il est peut-être enfin temps de prendre votre retraite. Combien y a-t-il d\'autres de ces situations sur le fil dans votre avenir ? Combien de combats encore ? Combien d\'autres morts devrez-vous enterrer ? La compagnie ferait bien de s\'appuyer sur les fondations que vous avez construites pour elle. Mais d\'autre part, si vous vous retiriez maintenant, quelles aventures rateriez-vous ?\n\n%OOC%Vous avez gagné ! Battle Brothers est conçu pour la rejouabilité et pour que les campagnes soient jouées jusqu\'à ce que vous ayez vaincu une ou deux crises de fin de partie. Lancer une nouvelle campagne vous permettra d\'essayer différentes choses dans un monde différent.\n\nVous pouvez également choisir de poursuivre votre campagne aussi longtemps que vous le souhaitez. Sachez simplement que les campagnes ne sont pas destinées à durer éternellement et que vous finirez probablement par manquer de défis.%OOC_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = " %companyname% ont besoin de leur commandant!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Il est temps de se retirer de la vie de mercenaire. (Fin de campagne)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.hasNews("crisis_greenskins_end"))
		{
			local currentTile = this.World.State.getPlayer().getTile();

			if (!currentTile.HasRoad)
			{
				return;
			}

			if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.15)
			{
				return;
			}

			local brothers = this.World.getPlayerRoster().getAll();
			local highest_hiretime = -9000.0;
			local highest_hiretime_bro;

			foreach( bro in brothers )
			{
				if (bro.getHireTime() > highest_hiretime)
				{
					highest_hiretime = bro.getHireTime();
					highest_hiretime_bro = bro;
				}
			}

			this.m.Dude = highest_hiretime_bro;
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_greenskins_end");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		_vars.push([
			"randomnoblehouse",
			nobles[this.Math.rand(0, nobles.len() - 1)].getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

