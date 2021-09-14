this.thief_caught_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.thief_caught";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]Pendant une courte pause, vos hommes ont réussi à attraper un homme qui a essayé de s\'enfuir avec certaines de vos fournitures. Ses vêtements ne sont que des haillons et il ressemble plus à un squelette qu\'à un homme. Qu\'allez-vous faire de lui ?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Donnez à ce pauvre gars de la nourriture et de l\'eau.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Donnez-lui une bonne raclée.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Passez-le au fil de l\'épée.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]Sous le couvert de la nuit, un voleur a réussi à voler quelques unes de vos provisions. Il vous les offrira probablement dans la prochaine colonie...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maudits voleurs !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					local food = this.World.Assets.getFoodItems();
					food = food[this.Math.rand(0, food.len() - 1)];
					this.World.Assets.getStash().remove(food);
					this.List = [
						{
							id = 10,
							icon = "ui/items/" + food.getIcon(),
							text = "Vous perdez " + food.getName()
						}
					];
				}
				else if (r == 2)
				{
					local amount = this.Math.rand(20, 50);
					this.World.Assets.addAmmo(-amount);
					this.List = [
						{
							id = 10,
							icon = "ui/icons/asset_ammo.png",
							text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] de Munitions"
						}
					];
				}
				else if (r == 3)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addArmorParts(-amount);
					this.List = [
						{
							id = 10,
							icon = "ui/icons/asset_supplies.png",
							text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] D\'Outils et Ressources"
						}
					];
				}
				else if (r == 4)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addMedicine(-amount);
					this.List = [
						{
							id = 10,
							icon = "ui/icons/asset_medicine.png",
							text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] de Ressources Médicales"
						}
					];
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]%randombrother% donne au voleur une bonne raclée avec une courte canne. Le bâton atterrit vicieusement et vous pouvez entendre le son des coups qui traversent la structure presque creuse de l\'homme. Il se dégonfle, se retourne et essaie de s\'enfuir, mais le mercenaire s\'obstine à lui infliger sa punition. Lorsque tout est terminé, vous laissez l\'homme battu derrière vous, gémissant et serrant la terre entre ses doigts frêles.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Que cela te serve de leçon !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous vous sentez mal pour cet homme faible et vous décidez de lui donner de l\'eau et de la nourriture. Il vous arrache presque le repas et y enfonce son visage affamé. Le voleur vous remercie entre chaque bouchée.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tout le monde ne sera pas aussi indulgent...",
					function getResult( _event )
					{
						if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax() || this.Math.rand(1, 100) <= 25)
						{
							return 0;
						}
						else
						{
							return "E";
						}
					}

				}
			],
			function start( _event )
			{
				local food = this.World.Assets.getFoodItems();
				food = food[this.Math.rand(0, food.len() - 1)];
				food.setAmount(this.Math.maxf(0.0, food.getAmount() - 5.0));
				this.List = [
					{
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Vous perdez quelques " + food.getName()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img] Vous dites aux hommes de se remettre en marche. Le voleur s\'essuie la bouche et se lève, vacillant sur ses faibles jambes pour faire quelques pas après vous. Il demande s\'il peut rejoindre la compagnie. Il est prêt à donner sa vie pour vous, s\'il le faut, tout pour ne plus avoir à voler.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eh bien, d\'accord, vous pourriez aussi bien vous joindre à nous.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Nous avons besoin de combattants, pas de voleurs sous-alimentés.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx(this.Const.CharacterThiefBackgrounds);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_33.png[/img]Alors que le voleur se dégonfle, vous dégainez votre épée. Il implore votre pitié alors que son visage réfléchi ondule sur les bords de la lame. Vous levez l\'arme. L\'homme crie qu\'il travaillera pour vous, qu\'il travaillera gratuitement, n\'importe quoi pour épargner sa vie. Vous hésitez, votre épée toujours en l\'air.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Meurt avec un peu de dignité, enfin.",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "Bien. J\'épargnerai votre vie si tu travailles pour moi.",
					function getResult( _event )
					{
						return "H";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_33.png[/img]%SPEECH_ON%La punition pour le vol est la mort.%SPEECH_OFF%Vous plongez l\'épée, coupant les derniers mots du voleur d\'un coup sec dans sa poitrine. Il s\'immobilise, sans voix, si ce n\'est le grattement de ses mains fines qui saisissent ce qui le tue, puis il retombe, mort dans l\'instant. Vous récupérez votre arme et la nettoyez dans le creux de votre coude. La tête de l\'homme mort se tourne sur le côté tandis que le sang s\'écoule tranquillement sous lui.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est mieux comme ça.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.beggar")
					{
						if (bro.getSkills().hasSkill("trait.bloodthirsty"))
						{
							continue;
						}

						bro.worsenMood(1.0, "S\'est senti désolé pour un voleur tué par vous");

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
			ID = "H",
			Text = "[img]gfx/ui/events/event_05.png[/img]Vous baissez votre arme et l\'homme rampe vers vous et enlace vos jambes. Il embrasse vos pieds jusqu\'à ce que vous vous éloigniez.\n\nPour mettre les choses au clair, vous lui donnez une longue liste d\'ordres et la façon de travailler dans la compagnie. Vous lui remettez également un contrat qu\'il signe d\'un coup sec. Quelques frères passent ensuite le reste de la journée à lui apprendre les ficelles du métier et à le présenter au reste de la compagnie. À la fin de la nuit, il semble qu\'il commence déjà à s\'intégrer. Le lendemain matin, vous vous réveillez pour constater qu\'un grand nombre de fournitures ont disparu et que le nouvel homme n\'est nulle part en vue. Il semble que, bien que vous ayez suspendu l\'exécution du voleur, il a quand même continué à voler des choses. Que cela vous serve de leçon.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cette satanée crapule !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					local food = this.World.Assets.getFoodItems();
					food = food[this.Math.rand(0, food.len() - 1)];
					this.World.Assets.getStash().remove(food);
					this.List = [
						{
							id = 10,
							icon = "ui/items/" + food.getIcon(),
							text = "Vous perdez " + food.getName()
						}
					];
				}
				else if (r == 2)
				{
					local amount = this.Math.rand(20, 50);
					this.World.Assets.addAmmo(-amount);
					this.List = [
						{
							id = 10,
							icon = "ui/icons/asset_ammo.png",
							text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Munitions"
						}
					];
				}
				else if (r == 3)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addArmorParts(-amount);
					this.List = [
						{
							id = 10,
							icon = "ui/icons/asset_supplies.png",
							text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Outils et Ressources"
						}
					];
				}
				else if (r == 4)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addMedicine(-amount);
					this.List = [
						{
							id = 10,
							icon = "ui/icons/asset_medicine.png",
							text = "Vous perdez [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Ressources Médicales"
						}
					];
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getFood() < 25 || this.World.Assets.getMedicine() < 10 || this.World.Assets.getArmorParts() < 10 || this.World.Assets.getAmmo() <= 50)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 10)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Score = this.isSomethingToSee() && this.World.getTime().Days >= 7 ? 50 : 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		if (!this.isSomethingToSee() && this.Math.rand(1, 100) <= 75)
		{
			return "A";
		}
		else
		{
			return "B";
		}
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

