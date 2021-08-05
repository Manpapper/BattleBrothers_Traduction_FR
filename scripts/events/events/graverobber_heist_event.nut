this.graverobber_heist_event <- this.inherit("scripts/events/event", {
	m = {
		Graverobber = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.graverobber_heist";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%graverobber% le sinistre pilleur de tombes entre dans votre tente, les mains derrière le dos. Vous ne souhaitez pas retarder plus longtemps la folie qui vous a été présentée, alors vous allez de l\'avant et demandez ce que l\'homme veut.%SPEECH_ON%Monsieur... J\'ai... On m\'a dit qu\'un baron local - un homme riche, en effet ! - a été récemment enterré dans un cimetière non loin d\'ici.%SPEECH_OFF%En vous penchant sur votre chaise, vous donnez à l\'homme un haussement d\'épaules. Il continue.%SPEECH_ON%I... Je ne souhaite pas demander l\'aide des autres hommes, car ils me regardent comme une sorte de chose horrible. Mais vous... vous êtes différent. Vous m\'avez engagé après tout.%SPEECH_OFF%Vous vous penchez en avant, tirant votre armure et la chaise sous vous à un grincement de bois.%SPEECH_ON%Laissez-moi deviner : vous voulez que je vous aide à creuser la tombe de ce baron.%SPEECH_OFF%L\'homme sourit, un spectacle pathétique, qui vous rappelle la fois où vous avez grondé un chien pour avoir volé un biscuit.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Euh, peut-être une autre fois.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Je ne vais pas le faire, et toi non plus.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Je vais chercher ma pelle !",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]Après vous être excusé de l\'expédition de fouilles, vous vous remettez au travail. Le temps s\'écoule, les papillons de nuit décrivant des boucles répétitives autour d\'une bougie qui s\'abaisse de plus en plus, sa flamme claire s\'adaptant si facilement aux battements d\'ailes des créatures qui l\'entourent. Finalement, %graverobber% revient, soulevant un bout de coffre dans la tente. Il ressemble plus à de la boue qu\'à un homme.%SPEECH_ON%Je l\'ai, monsieur !%SPEECH_OFF%Le fossoyeur regarde rapidement derrière lui, puis répète, la voix un peu plus faible cette fois.%SPEECH_ON%Je l\'ai... Je les ai tous. Ecoute, je vais partager avec toi. Je veux dire, tu ne m\'as pas aidé à éviter le gardien, ni à ramasser la terre, ni à sortir le corps, ni à sortir le coffre, ni à remettre le cercueil à sa place, ni à remettre la terre sur le cercueil, ni à éviter le gardien une seconde fois, ni à traîner le coffre jusqu\'au camp... mais tu m\'as laissé faire !%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est vrai.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local money = this.Math.rand(50, 150);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]Après vous être excusé de l\'expédition de fouilles, vous vous remettez au travail. Le temps s\'écoule, les papillons de nuit décrivant des boucles répétitives autour d\'une bougie qui s\'abaisse de plus en plus, sa flamme claire s\'adaptant si facilement aux battements d\'ailes des créatures qui l\'entourent. Finalement, %graverobber% revient, le premier signe de son retour étant le bord du rabat de votre tente qui bouge juste comme il faut. Vous posez votre couette et demandez à l\'homme d\'entrer. Il le fait, plutôt timidement, comme un homme sur le point de franchir un seuil qu\'il préférerait ne pas franchir. Même à la faible lueur des bougies, vous pouvez voir les couleurs que l\'obscurité sait si bien cacher : des violets, des bleus et des rouges sombres. Il sourit d\'un air penaud.%SPEECH_ON%Ils, euh, m\'ont attrapé monsieur.%SPEECH_OFF%Vous hochez la tête.%SPEECH_ON%Oui, je peux voir ça.%SPEECH_OFF%L\'homme lève rapidement un doigt, un filet de boue volant vers nulle part, puis un bruit humide.%SPEECH_ON%Mais la prochaine fois !%SPEECH_OFF%Vous arrêtez l\'homme avec une main levée.%SPEECH_ON%Et si tu allais te faire soigner et qu\'on parle ensuite de cette \"Prochaine Fois\", hein ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et veille à ne pas jeter plus de boue en sortant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Graverobber.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Graverobber.getName() + " souffre de " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Graverobber.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Graverobber.getName() + " souffre de blessures légères"
					});
				}

				_event.m.Graverobber.worsenMood(0.5, "S\'est fait tabasser dans " + _event.m.Town.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]%townname% n\'est pas le pilier sur lequel vous souhaitez sacrifier votre bonne réputation dans le monde - ou du moins, la bonne réputation qu\'un mercenaire peut avoir. Vous dites à %graverobber% que non seulement vous ne l\'accompagnerez pas, mais que vous refusez de le laisser se débrouiller seul. Il boude comme un jeune chasseur à qui un père en colère a retiré son arc.%SPEECH_ON%Bien... d\'accord alors... Je suppose que ce n\'était que quelques Couronnes...%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Retourne au travail.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				_event.m.Graverobber.worsenMood(1.0, "Il lui a été interdit de piller une tombe");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous et %graverobber% marchez à ras de terre à travers les buissons, un duo absurde, aux silhouettes sombres et ruminant d\'évidentes facéties, même dans la nuit la plus noire. Vous entrez tous les deux dans le cimetière comme si vous l\'aviez découvert par hasard, prétendant joyeusement que ce qui va se passer ensuite ne viendrait sûrement pas de deux étranges comme vous.\n\n Autour du cimetière, il y a des rangées et des rangées de dalles grises, des statues marbrées sans visage et des portes en fer noir qui gémissent dans le vent. De l\'herbe haute partout, de l\'engrais en abondance. Des fleurs qui ont grandis en intérieur, d\'autres en extérieur seulement, et certaines un peu des deux. Se pinçant les lèvres, le fossoyeur se retourne. Il plante sa pelle dans le sol et met ses poings sur ses hanches.%SPEECH_ON%Bordel de merde.%SPEECH_OFF%Sentant que quelque chose ne va pas, vous demandez ce qui ne va pas. Il crache et répond.%SPEECH_ON%Je n\'arrive pas à savoir si c\'est cette tombe, celle-là, ou celle-là.%SPEECH_OFF%Il désigne trois sites différents : l\'un est une modeste petite pierre, blanchie et dégarnie pour commémorer un décès ; un autre est clôturé par des flèches gothiques ; un autre n\'est que la porte d\'un mausolée. Le fossoyeur se tourne vers vous.%SPEECH_ON%Nous n\'avons probablement pas beaucoup de temps ici, quel tombe pensez-vous être la bonne?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous allons déterrer la tombe hétéroclite.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							return "F";
						}
						else
						{
							return "I";
						}
					}

				},
				{
					Text = "On va prend celle avec la barrière gothique.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							return "G";
						}
						else
						{
							return "I";
						}
					}

				},
				{
					Text = "Nous allons nous introduire dans le mausolée.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							return "H";
						}
						else
						{
							return "I";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous et %graverobber% commencez à creuser, tout ce que vous finissez par trouver c\'est de la terre et des os.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tout ça pour rien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				_event.m.Graverobber.worsenMood(0.5, "N\'a pas réussi à piller une tombe avec vous");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_33.png[/img]D\'un coup de bêche, la porte gothique est ouverte. Le tintement du métal sur le métal est envoyé en grondant entre les pierres tombales et les branches des arbres qui se balancent semblent ricaner de votre intrusion plutôt bruyante. Lorsque vous ouvrez le portail, les gonds grincent comme s\'ils étaient eux-mêmes des esprits éveillés. Vous entrez dans la petite parcelle carrée et vous vous appuyez sur les flèches de la clôture. Une courte commande met %graverobber% au travail tandis que vous restez à l\'affût comme un homme peu impressionné par la nature de ses propres crimes. Quelques minutes de pelletage scrupuleux plus tard, le pilleur de tombes a terminé. Ce qu\'on finit par trouver, c\'est un très grand cercueil qui n\'a aucun espoir d\'être sorti de terre, pas avec seulement deux hommes en tout cas.\n\n De la même manière que vous avez porté un coup à la porte, vous brisez les loquets du cercueil et vous l\'ouvrez. Un homme fraîchement mort vous regarde fixement, deux pierres peintes avec des yeux roulant hors de ses orbites. La vue vous fait sursauter, mais vous commencez rapidement à fouiller dans les affaires du mort. Il s\'avère que %graverobber% avait raison : l\'homme a été enterré avec de grands sacs d\'or et des gobelets et des gobelets en or. Vous prenez tout, refermez le cercueil et sortez discrètement du cimetière.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Trésors!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local money = this.Math.rand(200, 500);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
					}
				];
				_event.m.Graverobber.improveMood(1.0, "A trouvé un trésor en pillant une tombe");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous entrez dans le mausolée comme un homme qui craint que la porte derrière lui ne se referme à jamais. Le cercueil repose sur une dalle de marbre et des bougies brûlent à ses quatre coins. Bien qu\'il n\'y ait pas de vent à l\'extérieur, vous ne pouvez vous empêcher d\'en entendre un faible gémissement qui tourne autour de la pièce. Secouant vos craintes, vous et %graverobber% poussez le couvercle du cercueil, en prenant soin de ne pas le laisser tomber de l\'autre côté et de ne pas réveiller la moitié de la ville.\n\n À l\'intérieur du sarcophage, vous trouvez un homme vêtu d\'une tenue de chevalier : un casque, un plastron et un bouclier. Son épée traverse son corps du cou à l\'aine, ses mains se refermant autour de la poignée dans une étreinte prête au combat. Vous regardez %graverobber% qui hausse les épaules.%SPEECH_ON%Je suppose que ce type était un chevalier.%SPEECH_OFF%Vous acquiescez. Le pilleur de tombes jette un coup d\'œil du mort au vivant.%SPEECH_ON%Je suppose que... ce chevalier n\'a plus besoin de ces trucs...%SPEECH_OFF%Comme vous n\'avez pas l\'intention de partir les mains vides, vous acquiescez à nouveau. Le chevalier mort se défend bien alors que %graverobber% se bat pour le libérer de ce dont il n\'a plus besoin. Après quelques minutes de combat, vous donnez un coup de main pour enlever le casque. Ce qui en tombe est un gros paquet de cheveux blonds. %graverobber% recule.%SPEECH_ON%C\'est une femme%SPEECH_OFF%Soudain, des voix s\'élèvent de l\'extérieur du cimetière. Vous attrapez tout ce que vous pouvez et dites au pilleur de tombes de commencer à courir.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Trésors!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local item;
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/arming_sword");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/helmets/decayed_full_helm");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/armor/decayed_coat_of_plates");
				}

				item.setCondition(item.getCondition() / 2);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Graverobber.improveMood(1.0, "A trouvé un trésor en pillant une tombe");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_33.png[/img]Au moment où vous prenez votre pelle en main, la voix d\'un homme vous interpelle.%SPEECH_ON%Mais qu\'est-ce que vous pensez que vous faites ?%SPEECH_OFF%Vous vous retournez pour voir un homme qui allume une lanterne. Il la tient en l\'air, la poignée grince en pivotant d\'avant en arrière.%SPEECH_ON%Vous ressemblez à des fossoyeurs pour moi.%SPEECH_OFF%%graverobber% dégaine un couteau de sa ceinture. Le veilleur dégaine une cloche de sa ceinture, un grand instrument rondouillard qui brille d\'or du côté de la lumière de la lanterne et de blanc du côté de celle de la lune.%SPEECH_ON%Vous pouvez m\'attaque, mais pas avant que j\'aie fait sonner cette cloche. Alors la prochaine cloche que vous entendrez sonnera pour vous.%SPEECH_OFF%Vous attrapez %graverobber% par le col et lui dites de partir. Il n\'y a pas de raison de causer des problèmes. Le gardien vous aboie dessus lorsque vous partez.%SPEECH_ON%Je me souviendrai de vos visages ! Comme un chien battu connaît la botte qui l\'a frappé, je me souviendrai de vos visages !%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Embarrassant.",
					function getResult( _event )
					{
						this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationOffense, "Vous et vos hommes avez tenté de voler une tombe locale");
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				_event.m.Graverobber.worsenMood(0.5, "A été pris en train d\'essayer de piller une tombe");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_graverobber = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				candidates_graverobber.push(bro);
			}
		}

		if (candidates_graverobber.len() == 0)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() >= 2 && t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Graverobber = candidates_graverobber[this.Math.rand(0, candidates_graverobber.len() - 1)];
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"graverobber",
			this.m.Graverobber.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Graverobber = null;
		this.m.Town = null;
	}

});

