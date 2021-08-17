this.melon_thief_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.melon_thief";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]Vous regardez un grand groupe de villageois qui crient. Ils transportent un arbre abattu comme une bande de fourmis le ferait avec un scarabée. Il y a un homme aux yeux bandés et enchaîné à cheval sur le bois. Alors que la foule s\'approche, l\'âcreté de l\'alcool émane de la foule comme les miasmes d\'un marais particulièrement furieux.\n\n %otherbro% demande à la populace où elle va. Un inconnu barbu s\'avance, et freine sur un talon et une pointe de pied en même temps comme une marionnette inexpérimentée.%SPEECH_ON%Hé ! On va mettre de la poix et des plumes sur ce, ce, euh...%SPEECH_OFF%Quelqu\'un crie\"Amoureux des fruits !\" dans la foule. L\'inconnu claque des doigts. %SPEECH_ON%D\'accord ! Ce hum... voleur de melon va voir ce qu\'il va lui arriver.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Un voleur de melons ?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Oui, ce n\'est pas du tout notre affaire.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_43.png[/img]L\'inconnu se balance sur ses pieds. Il y a assez de mousse de bière dans sa barbe pour rendre une jeune fille ivre. Il pointe vers l\'avant.%SPEECH_ON%C\'est... c\'est vrai ! Il a volé un melon - oh, mais pas n\'importe quel voleur ! Nan, il l\'a attaqué de manière féroce ! Nous avons trouvé les traces macabres de son gestel tout autour de lui quand nous l\'avons rattrapé ! Et par traces macabres, je veux dire le déversement mal mesuré de sa queue!%SPEECH_OFF%N\'ayant rien compris, vous demandez à l\'homme de vous expliquer - lentement cette fois. Il lève les mains en l\'air comme si vous étiez un idiot.%SPEECH_ON% C\'est quoi cette discussion ? Tu baises un melon et c\'est tout ! De telles fornications sont, eh bien, bien... bien au-delà des actes ordinaires géré par la justice ! Maintenant dégage de notre chemin, étranger, nous avons des plumes à ramasser et à placer sur ce fou!%SPEECH_OFF%La foule applaudit.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qu\'en dis-tu, homme Melon ?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Un fornicateur de fruits ? %otherbro%, qu\'on jette de la poix sur ce fou !",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Ok. Ce n\'est pas notre affaire.",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_43.png[/img]Vous demandez à l\'homme au sommet de l\'arbre ce qu\'il a à dire, s\'il a quelque chose à dire. Il hausse les épaules et parle. %SPEECH_ON% Ecoute, ce qui se passe entre un homme et un melon c\'est leur affaire et rien que leur affaire. Pas de mal, pas de faute.%SPEECH_OFF%L\'inconnu donne un coup de bâton à l\'homme.%SPEECH_ON%Non dis la vérité à ce gars, dis-lui ce que tu as fait ! %SPEECH_OFF%Soupirant, l\'homme-melon acquiesce.%SPEECH_ON%D\'accord alors, si c\'est la fin des négociations, et les choses étant ce qu\'elles sont avec moi ici et l\'odeur de la poix dans l\'air, je vais parler franchement de ce qui se passe. J\'ai baisé ce melon et je me suis amusé.%SPEECH_OFF%La foule siffle et hue tandis que vos hommes rient entre eux.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On ne peut pas vous laisser jeter de la poix sur cet homme.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Un fornicateur de fruits ? %otherbro%, va aider à jeter de la poix sur cet idiot !",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Ok. Ce n\'est pas notre affaire.",
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
			Text = "[img]gfx/ui/events/event_43.png[/img]Vous attrapez l\'inconnu. %SPEECH_ON%Laissez cet homme partir. %SPEECH_OFF%L\'homme vous demande si vous défendez vraiment cet abruti de fruit. Vous acquiescez et lui dites que l\'adultère avec un melon, bien que dégoûtant et déroutant, est en fin de compte un geste inoffensif. Un paysan ivre jette un coup d\'œil par-dessus son épaule. %SPEECH_ON%Hum quoi ? La semaine dernière, on a mis le vieux Bentley derrière le hangar pour avoir brisé le cou de ce pauvre canard.%SPEECH_OFF%Le visage du paysan se renfrogne et il boie le reste de son verre. Il marmonne quelque chose comme quoi ce canard lui manquait vraiment. N\'ayant peut-être pas été assez clair, et fatigué des pitreries de ces idiots, vous tirez votre épée et libérez le violeur de melon. Vous tournez l\'épée vers la foule et celle-ci se disperse rapidement dans une retraite d\'ivrogne, se dispersant en éventail le long de la route, s\'éparpillant au hasard pour revenir d\'où elle est venue comme un tas de pierres sautant sur un lac....",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Allez vous faire voir, bande d\'idiots, allez vous faire voir !",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]Le \"voleur de melon\" vient à vous. Il arrange ses vêtements avec un peu de corde et des liens. %SPEECH_ON%So, euh, vu que vous m\'avez épargné ce terrible destin, que diriez-vous si j\'essayais de vous rembourser ? Je suis fatigué de cette ville de toute façon.%SPEECH_OFF%Vous lui dites que le métier de mercenaire n\'est pas une vocation enviable à prendre à la volée. Il pointe un doigt narquois.%SPEECH_ON%Écoute, si tu as peur que je te pique tes produits, je te promets sur la tombe de ma mère que je garderai mon foret dans son pantalon.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très bien. Bienvenue au %companyname% !",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Non, nous préférons ne pas avoir à revérifier notre nourriture à chaque fois que nous prenons une bouchée.",
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
				_event.m.Dude.setStartValuesEx([
					"thief_background"
				]);
				_event.m.Dude.setTitle("the Melon Mugger");
				_event.m.Dude.getSprite("head").setBrush("bust_head_03");
				_event.m.Dude.getBackground().m.RawDescription = "%name% est juste un voleur de melon ordinaire - c\'est ce que vous dites aux gens qui demandent.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.improveMood(1.0, "Il a satisfait ses besoins avec un melon");
				_event.m.Dude.worsenMood(0.5, "Almost got tarred and feathered");

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_43.png[/img]%otherbro% hoche la tête. %SPEECH_ON%Avec plaisir ! Dégagez la paysannerie, laissez un vrai homme faire son travail ici.%SPEECH_OFF%Le mercenaire ramasse le seau à poix et le lance complètement sur le fornicateur de fruits. L\'homme hurle alors que les liquides chauds grésillent et qu\'une ordeur plutôt puissante s\'envole dans l\'air. Vous regardez %otherbro% s\'emparer de quelques poulets nus - pas leurs plumes, juste les poulets eux-mêmes - et commencer à frapper le voleur de melon avec eux comme un moine en colère balançant des encensoirs enchaînés. L\'homme recouvert de poix hurle, en partie de douleur, en partie de confusion. La foule, également confuse, applaudit à contrecœur. Lorsqu\'il a terminé, %otherbro% laisse tomber les poulets, qui ne sont plus qu\'un amas de viande et de poix. Il s\'essuie le front. %SPEECH_ON%Ça déchire, monsieur%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je ne pense pas qu\'il ait compris, mais ça marche.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.improveMood(0.5, "A infligé un juste châtiment");

				if (_event.m.Other.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (!t.isMilitary() && !t.isSouthern() && t.getSize() <= 1 && t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( b in brothers )
		{
			candidates.push(b);
		}

		this.m.Other = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbro",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.Dude = null;
		this.m.Town = null;
	}

});

