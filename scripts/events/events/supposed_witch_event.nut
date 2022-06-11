this.supposed_witch_event <- this.inherit("scripts/events/event", {
	m = {
		Monk = null,
		Cultist = null,
		Witchhunter = null
	},
	function create()
	{
		this.m.ID = "event.supposed_witch";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]Vous traversez un petit hameau au bord du chemin. C\'est un endroit plutôt indescriptible, à l\'exception de la femme attachée au sommet d\'un futur feu de joie. Elle est entourée d\'une bande de paysans, comme il est habituel pour une femme dans cette position. Un moine de la foule lit un tome sacré, faisant apparemment savoir à tous la nature déontologique de ses crimes.Un autre homme se tient consciencieusement debout avec une torche, ses mains le démange à l\'utiliser.\n\n En vous voyant, la femme crie au secours.%SPEECH_ON%Ils vont me brûler !  Vous devez faire quelque chose ! Je n\'ai rien fait de mal ici!%SPEECH_OFF%.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Libérons-la.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 80)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Witchhunter != null)
				{
					this.Options.push({
						Text = "Qu\'est-ce que le chasseur de sorcières a à dire, %witchhunterfull%?",
						function getResult( _event )
						{
							return "Witchhunter";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Que disent les vieux dieux, %monkfull%?",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "Qu\'est-ce que votre dieu étrange fait dans ce cas, %cultistfull%?",
						function getResult( _event )
						{
							return "Cultist";
						}

					});
				}

				this.Options.push({
					Text = "Ce n\'est pas notre problème.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_79.png[/img]Vous ne resterez pas sans rien faire pendant qu\'une femme innocente est brûlée pour un crime imaginaire. Lame en main, vous grimpez sur les palettes de bois et la libérez. Elle s\'enfuit rapidement, cherchant sa propre sécurité. La foule, enragée, s\'en prend à la compagnie en un instant. Une bagarre entre paysans et mercenaires se termine mal pour les premiers, mais ils font quelques dégâts.\n\nPour avoir perdu le contrôle de la foule, vous faites tabasser le moine, ainsi que l\'homme portant la torche. Quelques frères d\'armes pensent que c\'était la bonne chose à faire et sont satisfaits de votre décision.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'espère qu\'elle trouvera un endroit sûr.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							local injury = bro.addInjury(this.Const.Injury.Brawl);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " souffre de " + injury.getNameOnly()
							});
						}
						else
						{
							bro.addLightInjury();
							this.List.push({
								id = 10,
								icon = "ui/icons/days_wounded.png",
								text = bro.getName() + " souffre de blessures légères"
							});
						}
					}

					if (this.Math.rand(1, 100) <= 25 && bro.getBackground().getID() != "background.witchhunter")
					{
						bro.improveMood(1.0, "Vous avez sauvé une femme qui allait être brûlée sur le bûcher.");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_79.png[/img]Vous ne resterez pas sans rien faire pendant qu\'une femme innocente est brûlée pour un crime imaginaire. Lame en main, vous grimpez sur les palettes de bois et la libérez. Quand elle est libre, elle se penche et vous prend dans ses mains. Sa peau est lisse et sans marque.%SPEECH_ON%Merci, mercenaire.%SPEECH_OFF%Elle vous embrasse et vous avez l\'impression que ses lèvres sont de glace. Vous la regardez flotter le long des palettes de bois. Oh oh.\n\nLe moine de la ville bat en retraite, essayant de se cacher dans la foule, mais la sorcière hurle et divise la foule, ne laissant que le moine seul sur le sol. Il glisse lentement sur la terre avant de se relever comme s\'il était poussé par une force invisible. Il tente à nouveau de battre en retraite, mais il n\'y a pas d\'issue. Elle l\'embrasse comme elle l\'a fait avec vous, mais les yeux de l\'homme se retournent dans sa tête et vous voyez ses veines s\'engorger, se violacer violemment, son corps entier cracher du sang par tous les pores tandis qu\'il tremble. Il hurle, mais c\'est perdu dans la bouche de la sorcière qui le dévore avec un gémissement. Quand elle le lâche, il tombe sur le sol comme un cadavre rouge et trempé. Les villageois se dispersent pendant que vos hommes tentent de combattre ce mal. Elle rit et se rétracte au centre de ses vêtements, sa cape s\'enroule en un paquet d\'où jaillit un spectre ricanant. Il s\'envole vers la ligne d\'arbres la plus proche, en espérant ne plus jamais être vu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oh, merde.",
					function getResult( _event )
					{
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(3);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25 || bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.monk" || bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.mad"))
					{
						bro.worsenMood(1.0, "A libéré un mauvais esprit");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Witchhunter",
			Text = "[img]gfx/ui/events/event_79.png[/img]%witchhunter% s\'avance, l\'œil sceptique. Il regarde la femme qui s\'efforce de dire \"s\'il vous plaît\". Le chasseur de sorcières la fixe de haut en bas, puis il se retourne et plante une lame dans l\'homme qui tient la torche. Il se gargarise avec la torche dans sa gorge et ses mains s\'efforcent de l\'extraire.%SPEECH_ON% Arrête avec cette farce, tu ne me tromperas pas.%SPEECH_OFF%Dit le chasseur de sorcières. Il arrache la lame et le porteur de la torche reste là un moment, mais ses yeux écarquillés se calment lentement et le \"sang\" s\'arrête en un instant. Son visage s\'élargit, la peau se tend comme le visage fondu de la poupée la plus horrible d\'un marionnettiste. Sa voix est criarde, chaque syllabe ayant la hauteur d\'un chat mourant.%SPEECH_ON%Je ne suis PAS le dernier ! Vous ne serez JAMAIS débarrassé de nous tous!%SPEECH_OFF%Et avec ça, %witchhunter% enfonce son arme dans le crâne de l\'esprit maléfique. La peau durcit comme la terre du désert avant de s\'effriter.\n\nLa vérité étant connue, la femme est détachée et libérée. Le moine est défroqué par une foule en colère qui n\'a nulle part où aller avec son énergie. Nu et humilié, il est chassé du hameau pour ses accusations injustifiées.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le vrai mal se dissimule bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Witchhunter.getImagePath());
				local resolve = 1;
				local initiative = 1;
				_event.m.Witchhunter.getBaseProperties().Bravery += resolve;
				_event.m.Witchhunter.getBaseProperties().Initiative += initiative;
				_event.m.Witchhunter.getSkills().update();
				_event.m.Witchhunter.improveMood(2.0, "A tué un mauvais esprit");

				if (_event.m.Witchhunter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Witchhunter.getMoodState()],
						text = _event.m.Witchhunter.getName() + this.Const.MoodStateEvent[_event.m.Witchhunter.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Witchhunter.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] de Détermination"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.Witchhunter.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] Initiative"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Witchhunter.getID() && (this.Math.rand(1, 100) <= 25 || bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.monk" || bro.getSkills().hasSkill("trait.superstitious")))
					{
						bro.improveMood(1.0, "A vu un mauvais esprit rencontrer sa fin");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_79.png[/img]Le moine, %monk%, s\'assied avec le prêtre de la ville et discute un moment. Lorsqu\'ils ont terminé, ils font un signe de tête au flambeur qui met le feu aux palettes de bois. La femme hurle à la pitié, mais les flammes n\'en ont pas pour elle, et se lèvent lentement, les pieds devant. C\'est un spectacle horrible et ce n\'est que lorsque la fumée est un nuage étouffant que la femme mourante se tait. Le feu la consume entièrement tandis que le reste de la ville applaudit et acclame. %monk% dit qu\'elle était clairement une sorcière et qu\'il fallait s\'en débarrasser. Vous n\'êtes pas sûr. Tout ce que tu as vu, c\'est une femme brûlée vive, mais vous pensez qu\'il en sait plus que vous sur la guerre entre les anciens dieux et la sorcellerie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Déraciner le mal n\'est jamais facile.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local resolve = this.Math.rand(2, 3);
				_event.m.Monk.getBaseProperties().Bravery += resolve;
				_event.m.Monk.getSkills().update();
				_event.m.Monk.improveMood(2.0, "A fait brûler une sorcière");

				if (_event.m.Monk.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Monk.getMoodState()],
						text = _event.m.Monk.getName() + this.Const.MoodStateEvent[_event.m.Monk.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Monk.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Détermination"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Monk.getID() && (bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.monk" || bro.getSkills().hasSkill("trait.superstitious")))
					{
						bro.improveMood(1.0, "A vu une sorcière brûler sur le bûcher");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Cultist",
			Text = "[img]gfx/ui/events/event_79.png[/img]%cultist% s\'avance et regarde les villageois de haut en bas. Il secoue la tête.%SPEECH_ON% Vous devriez tous vous tuer.%SPEECH_OFF% Le moine de la ville remue sa cape.%SPEECH_ON%E-excusez-moi?%SPEECH_OFF% Le cultist commence à détacher la femme. Quelques-uns de vos mercenaires s\'avancent pour empêcher quiconque de protester. Quand elle est libre et qu\'elle a couru pour sa propre sécurité, %cultist% parle à nouveau.%SPEECH_ON%Tuez vous. Chacun d\'entre vous. Ce soir. Vous avez mis Davkul en colère et sa rage est une dette que vous feriez mieux de payer vous-même.%SPEECH_OFF%Le moine ouvre la bouche pour dire quelque chose, mais son nez se fend comme s\'il avait été entaillé par une pierre invisible. Il vacille, du sang s\'écoule de ses narines. %cultist% hôche de la tête.%SPEECH_ON%Hmm, Il est plus en colère que je ne le pensais. Davkul nous attend tous, mais il est maintenant sur le pas de votre porte.%SPEECH_OFF%Crisant, le moine tombe sur le sol alors que sa mâchoire s\'ouvre de façon écoeurante, sa bouche restant entrouverte en permanence. Les villageois hurlent et se dispersent comme des lapins sous l\'ombre d\'un faucon.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Troublant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local resolve = 2;
				_event.m.Cultist.getBaseProperties().Bravery += resolve;
				_event.m.Cultist.getSkills().update();
				_event.m.Cultist.improveMood(2.0, "A été témoin de la puissance de Davkul");

				if (_event.m.Cultist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}

				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Cultist.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] Détermination"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() != _event.m.Cultist.getID() && (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist"))
					{
						bro.improveMood(1.0, "A été témoin de la puissance de Davkul");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().getID() == "background.witchhunter" || bro.getBackground().getID() == "background.monk" || bro.getSkills().hasSkill("trait.superstitious"))
					{
						bro.worsenMood(1.0, _event.m.Cultist.getName() + " a libéré une sorcière");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 15)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidate_witchhunter = [];
		local candidate_monk = [];
		local candidate_cultist = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				candidate_witchhunter.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				candidate_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidate_cultist.push(bro);
			}
		}

		if (candidate_witchhunter.len() != 0)
		{
			this.m.Witchhunter = candidate_witchhunter[this.Math.rand(0, candidate_witchhunter.len() - 1)];
		}

		if (candidate_monk.len() != 0)
		{
			this.m.Monk = candidate_monk[this.Math.rand(0, candidate_monk.len() - 1)];
		}

		if (candidate_cultist.len() != 0)
		{
			this.m.Cultist = candidate_cultist[this.Math.rand(0, candidate_cultist.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter != null ? this.m.Witchhunter.getNameOnly() : ""
		]);
		_vars.push([
			"witchhunterfull",
			this.m.Witchhunter != null ? this.m.Witchhunter.getName() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"monkfull",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"cultistfull",
			this.m.Cultist != null ? this.m.Cultist.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
		this.m.Monk = null;
		this.m.Cultist = null;
	}

});

